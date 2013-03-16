%%%------------------------------------
%%% @Module  : mod_player
%%% @Author  : 
%%% @Created : 2010.09.27
%%% @Description: 角色处理
%%%------------------------------------
-module(mod_player). 
-behaviour(gen_server).
-include("common.hrl").
-include("goods.hrl").
-include("record.hrl").
-include("debug.hrl").
-export([code_change/3, handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).

%%启动角色主进程
start(PlayerId, AccountId, ResoltX, ResoltY, Socket) ->
    gen_server:start(?MODULE, [PlayerId, AccountId, ResoltX, ResoltY, Socket], []).
 
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([PlayerId, _AccountId, ResoltX,ResoltY, Socket]) ->
    %%net_kernel:monitor_nodes(true),
    %%注册进程和清理在线数据(这里可能会耗尽节点VM中原子数限制)
    PlayerProcessName = misc:player_process_name(PlayerId),
	catch misc:unregister({local,PlayerProcessName}) ,
    misc:register(local, PlayerProcessName, self()),
    delete_ets_when_init(PlayerId),
    
    %%加载玩家数据和各种逻辑
    Status = load_player_info(PlayerId,ResoltX,ResoltY, Socket),
    
    %%上线防沉迷处理
    %%online_antirevel(AccountId),
    
    %%各种定时器 
    erlang:send_after(5*1000,self(),'CHECK_DUPLICATE_LOGIN'),    %% 5秒后检查重复登陆

    %% 心跳包时间检测
    put(detect_heart_time, [0, ?HEART_TIMEOUT_TIME, []]),
    HeartTimer = erlang:send_after(?HEART_TIMEOUT, self(), 'check_heart_time'),
    put(check_heart_timer, HeartTimer),
    
    misc:write_monitor_pid(self(),?MODULE, {PlayerId}),    
    {ok, Status}.

%% 路由
%% cmd:命令号
%% Socket:socket id
%% data:消息体
routing(Cmd, Status, Bin) ->
    %%取前面二位区分功能类型
    [H1, H2, _, _, _] = integer_to_list(Cmd),
    case [H1, H2] of
        %%游戏基础功能处理
        "10" -> pp_base:handle(Cmd, Status, Bin);
		"11" -> pp_chat:handle(Cmd, Status, Bin);
        "12" -> pp_scene:handle(Cmd, Status, Bin);
        "13" -> pp_player:handle(Cmd, Status, Bin);
        "14" -> pp_relation:handle(Cmd, Status, Bin);
        "15" -> pp_goods:handle(Cmd, Status, Bin);
        %"18" -> pp_notice:handle(Cmd, Status, Bin);
        "19" -> pp_mail:handle(Cmd, Status, Bin);
        "20" -> pp_battle:handle(Cmd, Status, Bin);
        "21" -> pp_skill:handle(Cmd, Status, Bin);
		"25" -> pp_skill:handle(Cmd, Status, Bin);
        "30" -> pp_task:handle(Cmd, Status, Bin);
        "34" -> pp_system_config:handle(Cmd, Status, Bin); 
        "35" -> pp_team:handle(Cmd, Status, Bin); 
        %"36" -> pp_boss:handle(Cmd, Status, Bin);
        "40" -> pp_guild:handle(Cmd, Status, Bin);
        "44" -> pp_mount:handle(Cmd, Status, Bin);
		"45" -> pp_meridian:handle(Cmd, Status, Bin);
        "60" -> pp_gateway:handle(Cmd, Status, Bin);
        _ -> %%错误处理
            ?ERROR_MSG("Routing Error [~w].", [Cmd]),
            {error, "Routing failure"}
    end.

%%处理socket协议 (cmd：命令号; data：协议数据)
handle_call({'SOCKET_EVENT', Cmd, Bin}, _From, Status) ->
     case routing(Cmd, Status, Bin) of
          {ok, Status1} ->                           %% 修改ets和status
              save_online(Status1),
              save_online_diff(Status,Status1),
              {reply, ok, Status1};
          {ok, change_ets_table, Status1} ->         %% 修改ets、status和table
              save_online_diff(Status,Status1),            
              save_player_table(Status1, Cmd),
              {reply, ok, Status1};
          {ok, change_status, Status2} ->            %% 修改status
              {reply, ok, Status2};
          _ ->
              {reply, ok, Status}
     end;

%%获取用户信息
handle_call('PLAYER', _from, Status) ->
    {reply, Status, Status};

%%获取用户信息(按字段需求)
handle_call({'PLAYER', List}, _from, Status) ->
    Reply = lib_player_rw:get_player_info_fields(Status, List),
    {reply, Reply, Status};

handle_call(Event, From, Status) ->
   ?ERROR_MSG("mod_player_call: /~p/~n",[[Event, From, Status]]),
   {reply, ok, Status}.

%%凌晨操作
handle_cast(midnight, Status) ->
    ?TRACE("midnight operations~n"),
    {noreply, Status};

%%给玩家发送奖励
handle_cast({add_coin_exp, Coin, BCoin, BGold, Exp}, Status) ->
    Status1 = lib_player:add_money(Status, Coin, BCoin, 0, BGold),
    if Exp > 0 ->
            NewStatus = lib_player:add_exp(Status1, Exp, 0),
            {noreply, NewStatus};
       true ->
            %%发送消息更新
            {noreply, Status1}
    end;

%%给玩家发送奖励
handle_cast({add_goods, GoodsList, Source}, Status) ->
	NewStatus = goods_util:send_goods_and_money(GoodsList, Status, Source),
	Fields = record_info(fields,player),
	OldValueList = lib_player_rw:get_player_info_fields(Status,Fields),
	NewValueList = lib_player_rw:get_player_info_fields(NewStatus,Fields),
	KeyValue = get_diff_val(OldValueList,NewValueList,Fields),
	if
		length(KeyValue) > 0 ->
			lib_player:send_player_attribute4(NewStatus) ;
		true ->
			skip
	end ,	
	{noreply, NewStatus};

%%刷新玩家战斗属性
handle_cast(refresh_battle_attr, Status) ->
   Status1 = lib_player:calc_player_battle_attr(Status),
   {noreply, Status1};

% 战斗操作hp
handle_cast({reducehpmp, HP}, Status) ->
    OldBattleAttr = Status#player.battle_attr,
    CurrentHP = max(0, OldBattleAttr#battle_attr.hit_point - HP),
    NewBattleAttr = OldBattleAttr#battle_attr{hit_point = CurrentHP},
    NewStatus = Status#player{battle_attr = NewBattleAttr},
	?TRACE("reducehpmp,playerid:~p  hp:~p, CurrentHP:~p ~n", [Status#player.id, HP, CurrentHP]),
%% 	case NewStatus#player.hit_point > 0 of
%% 		true ->
			update(NewStatus),
%% 		_ ->	%死亡/状态改变时再同步到地图
%% 			save_online(NewStatus)
%% 	end,
	{noreply, NewStatus};


%%停止角色进程(Reason 为停止原因)
handle_cast({stop, Reason}, Status) ->
    {ok, BinData} = pt_10:write(10007, Reason),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
    {stop, normal, Status};

%%设置用户信息
handle_cast({'SET_PLAYER', NewStatus}, _Status) when is_record(NewStatus, player)->
    %%put(last_msg, [{'SET_PLAYER', NewStatus}]),%%监控记录接收到的最后的消息
    save_online_diff(_Status,NewStatus),
    {noreply, NewStatus};

%%设置用户信息(按字段+数值)
handle_cast({'SET_PLAYER', List}, Status) when is_list(List)->
    NewStatus = lib_player_rw:set_player_info_fields(Status, List),
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};

%%发送信息到socket端口
handle_cast({send_to_sid, Bin}, Status) ->
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, Bin),
    {noreply, Status};

%%设置禁言 或 解除禁言
handle_cast({set_donttalk, BeginTime, DurationSeconds}, Status) ->
    put(donttalk, [BeginTime, DurationSeconds]),
    {noreply, Status};    
 
% 场景的PID改变了
handle_cast({change_pid_scene, NewScenePId, SceneId}, Status) ->
	%%put(last_msg, [{change_pid_scene, NewScenePId, SceneId}]),%%监控记录接收到的最后的消息
	if Status#player.other#player_other.pid_scene=/= undefined, 
		 Status#player.other#player_other.pid_scene =/= NewScenePId,
		 Status#player.scene == SceneId ->
					ok;
	   true -> no_action
	end,
	NewStatus = Status#player{other=Status#player.other#player_other{pid_scene = NewScenePId}},
    {noreply, NewStatus};

%%处理好友添加请求
handle_cast({add_friend_request, RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel}, Status) ->
    lib_relation:put_request_uids([RequestUid]),  %%把请求的玩家ID存起来, 同意好友请求需要判断
    {ok,BinData} = pt_14:write(14012, [[[RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel]]]),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
    {noreply, Status};

%%响应好友添加请求
handle_cast({add_friend_response, FriendId, FriendName, FriendCareer, FriendGender}, Status) ->
    lib_relation:add_to_friend_list(Status, {FriendId, FriendName, FriendCareer, FriendGender}),
    {noreply, Status};

%%好友祝福
handle_cast({bless, Type, Uid, Name}, Status) ->
    {ok,BinData} = pt_14:write(14022, [Uid, Name, Type]),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
    {noreply, Status};

%%刷新新信件数量到客户端
handle_cast(refresh_mail, Status) ->
    case lib_mail:get_newmail_count(Status#player.id) of
        [Num] -> {ok,BinData} = pt_19:write(19010, [Num]),
                 lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
        _     ->  skip
    end,
    {noreply, Status};

%%增加Buff
handle_cast({add_goods_buff, BuffId}, Status) ->
    case buff_util:add_goods_buff(Status, BuffId) of
           {add, NewStatus} -> %新加的Buff成功了
                save_online_diff(Status,NewStatus),
                {noreply, NewStatus};
           {replace, NewStatus} -> %加成功,冲掉了旧的Buff
                save_online_diff(Status,NewStatus),
                {noreply, NewStatus};
            _ ->
                {noreply, Status}
    end;
    
%%强制移除Buff
handle_cast({remove_goods_buff, BuffId}, Status) ->
    NewStatus = buff_util:remove_goods_buff(Status, BuffId),
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};

%%为玩家赠送物品
handle_cast({give_present,ItemList},Status)->
	case lib_task:do_player_get_goods(ItemList,Status) of
		NewStatus when is_record(NewStatus, player)->
			{noreply, NewStatus};
		_->
			?ERROR_MSG("give present to player error good is ~p ~n",[ItemList]),
			{noreply, Status}
	end;	

%%加入了帮派
handle_cast({join_guild, GuildId, GuildName, Position}, Status) ->
    NewStatus = Status#player{guild_id = GuildId, guild_name = GuildName, guild_post = Position},
    {ok, BinData} = pt_40:write(40078, [GuildId, GuildName]),
    lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData),
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};

%%帮派职位变更
handle_cast({guild_post, Position}, Status) ->
    NewStatus = Status#player{guild_post = Position},
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};

%%取消帮派信息
handle_cast({quit_guild}, Status) ->
    NewStatus = Status#player{guild_id = 0, guild_name ="", guild_post = 0},
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};

%%更新帮派申请信息
handle_cast({new_guild_apply}, Status) ->
    pp_guild:handle(40031, Status, 0),
    {noreply, Status};

%%更新组队信息
handle_cast({update_team, TeamId, TeamLeader}, Status) ->
    NewStatus = Status#player{other = Status#player.other#player_other{team_id = TeamId, team_leader = TeamLeader}},
    save_online_diff(Status, NewStatus),
    {noreply, Status};

handle_cast(Event, Status) ->
   ?ERROR_MSG("mod_player_cast: /~p/~n",[[Event, Status]]),
   {noreply, Status}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 发送信息到socket端口
handle_info({send_to_sid, Bin}, Status) ->
   lib_send:send_to_sid(Status#player.other#player_other.pid_send, Bin),
   {noreply, Status};

%%检查是否有重复登陆
handle_info('CHECK_DUPLICATE_LOGIN',Player)->
    PlayerProcessName = misc:player_process_name(Player#player.id),
	case misc:whereis_name({local,PlayerProcessName}) of
        Pid when is_pid(Pid)->
            case misc:is_process_alive(Pid) of
                true  ->
                    Self = self(),
                    if Pid /= Self ->
                            mod_login:logout(self(), 1);
                       true ->
                           skip
                    end;
                flase ->
                    skip
            end;
        _E ->
            skip
    end,
    {noreply,Player};

%% 防沉迷信息播报
handle_info({'ALART_REVEL', Min}, Status) ->
    Accid = Status#player.account_id,
    Idcard_status = db_agent:get_idcard_status(Accid),
    case Idcard_status of
        1 -> {noreply, Status};
        _ ->
            case Min of
                60 ->
                    {ok, BinData} = pt_29:write(29001, 1),
                    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
                120 ->
                    {ok, BinData} = pt_29:write(29001, 2),
                    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
                _ ->
                    {ok, BinData} = pt_29:write(29001, 3),
                    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData)
            end,
            {noreply, Status}
    end;

%% 防沉迷强制退出
handle_info('FORCE_OUT_REVEL', Status) ->
    Accid = Status#player.account_id,
    Idcard_status = db_agent:get_idcard_status(Accid),    
    case Idcard_status of
        1 -> {noreply, Status};
        _ ->
            mod_login:logout(Status#player.other#player_other.pid, 5),
            {noreply, Status}
    end;

%%设置用户信息(按字段+数值)
handle_info({'SET_PLAYER_INFO', List}, Status) when is_list(List) ->
    NewStatus = lib_player_rw:set_player_info_fields(Status, List),
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};
 
%%判断是否死游客
handle_info({check_static_player,[Scene, X, Y, Counter]}, Status) ->
    if [Status#player.scene, Status#player.battle_attr#battle_attr.x, Status#player.battle_attr#battle_attr.y] == [Scene, X, Y] ->
       if Counter >= 30 -> %%9级以下，30分钟都不移动, 则做退出处理
           {ok, BinData} = pt_10:write(10007, 6),
           lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
           {stop, normal, Status};
       true ->
           erlang:send_after(60*1000, self(),
           {check_static_player, [Status#player.scene, Status#player.battle_attr#battle_attr.x,Status#player.battle_attr#battle_attr.y, Counter+1]}),
           {noreply, Status}
       end;
    true -> 
       {noreply, Status}
    end;

%%心跳数据检测
handle_info('check_heart_time', Status) ->
    misc:cancel_timer(check_heart_timer),
    [_PreTime, Num, _TimeList] = get(detect_heart_time),
    if Num > 0 ->
           put(detect_heart_time, [0, Num-1, []]),
           HeartTimer = erlang:send_after(?HEART_TIMEOUT, self(), 'check_heart_time'),
           put(check_heart_timer, HeartTimer),
           {noreply, Status};
       true ->
           Now = util:unixtime(),
           NewTimeListStr = "",
           spawn(fun()-> db_log_agent:insert_kick_off_log(Status#player.id, Status#player.nick, 7, Now, 
                                                          Status#player.scene, Status#player.battle_attr#battle_attr.x, 
                                                          Status#player.battle_attr#battle_attr.y, NewTimeListStr) end),
           mod_player:stop(Status#player.other#player_other.pid, 7),
           {stop, normal, Status}
    end;

%%刷新BUFF
handle_info('REFRESH_BUFF', Status) ->
    NewStatus = buff_util:refresh_goods_buff(Status),
    buff_util:refresh_buff_timer(NewStatus), 
    save_online_diff(Status,NewStatus),
    {noreply, NewStatus};

handle_info(Info, Status) ->
   ?ERROR_MSG("Mod_player_info: /~p/~n",[[Info, Status]]),
   {noreply, Status}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, Status) ->
    %% 卸载角色数据
    unload_player_info(Status),    
	mod_disperse:sync_player_to_gateway(Status) ,
    misc:delete_monitor_pid(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_oldvsn, Status, _extra) ->
    {ok, Status}.

%%----------------------------------------------
%%更新上次登录IP及时间
%%----------------------------------------------
update_last_login(Player, Scoket) ->
    %%最后登录时间和IP
    LastLoginIP = misc:get_ip(Scoket) ,
    db_agent_player:update_last_login(Player#player.last_login_time, LastLoginIP, Player#player.id) .
    
%%----------------------------------------------
%%@spec 完善record 结构,包括本身和Other
%%----------------------------------------------
load_for_runtime_data(Player, ResoltX, ResoltY, Socket, LastLoginTime) ->
    PlayerId = Player#player.id ,
    %% Socket消息发送进程
    PidSendList = lists:map(fun(N)-> 
                                {ok, PidSend} = mod_pid_send:start(Socket, N),
                                 PidSend
                            end, lists:seq(1, ?SEND_MSG)),
    %%打开任务进程
    {ok, PidTask} = mod_task:start_link([PlayerId]) ,
	
	%% 创建物品模块PID
    GoodsEtsId = mod_goods_l:get_min_ets_goods_name(),
	{ok, GoodsPid} = mod_goods:start(PlayerId, Player#player.cell_num, GoodsEtsId),
	GoodsStatus = gen_server:call(GoodsPid, {'STATUS'}),
    ?TRACE("login suc equip current: ~p~n", [GoodsStatus#goods_status.equip_current]),
    %%初始玩家基本战斗属性, 生命力, 法力, 怒气, 连击点用玩家数据库里的
    BattleAttr = lib_player:init_base_battle_attr(Player#player.level, Player#player.career, Player#player.battle_attr), 
	OtherTmp = #player_other{goods_ets_id = GoodsEtsId},
	PlayerTmp = Player#player{other = OtherTmp},
    [WeaponStrenLv, ArmorStrenLv, FashionStrenLv, WaponAccStrenLv, WingStrenLv] = lib_equip:get_equip_strenlv(GoodsStatus#goods_status.equip_current, PlayerTmp, []),
	{PetId, PetTempId, PetName} = lib_pet:init_pet_info(PlayerId),
    %% 设置角色的相关信息
    Other = #player_other{ skill_list = [],
                           socket = Socket,
                           pid = self(),
                           pid_goods = GoodsPid,
                           pid_send = PidSendList,
                           pid_battle = undefined,       % 战斗进程Pid
                           pid_scene = undefined,        % 当前场景Pid
                           pid_dungeon = undefined,      % 当前副本进程
                           pid_task = PidTask,
                           node = node(),
                           pk_mode = 0,
						   goods_ets_id = GoodsEtsId,
						   equip_current = GoodsStatus#goods_status.equip_current,
						   weapon_strenLv = WeaponStrenLv,
						   armor_strenLv = ArmorStrenLv,
						   fashion_strenLv = FashionStrenLv,
						   wapon_accstrenLv = WaponAccStrenLv,
						   wing_strenLv = WingStrenLv
                          },

    %% 初始化部分角色属性
    NewPlayer1 = Player#player{ 
                      account_name = tool:to_list(Player#player.account_name) ,
                      nick = tool:to_list(Player#player.nick) ,
                      last_login_time = LastLoginTime ,
                      online_flag = 1 ,
					  resolut_x = ResoltX,
					  resolut_y = ResoltY,
                      battle_attr = BattleAttr,
                      other = Other},

	%%初始化经脉模块数据
 	lib_meridian:init_meridian(NewPlayer1),
	
    %%更新ETS_ONLINE在线表
    ets:insert(?ETS_ONLINE, NewPlayer1),
                      
    %%加载玩家系统配置
    NewPlayer2 = lib_system_config:init_system_config(NewPlayer1),
    
    %%获取技能
    NewPlayer3 = lib_skill:role_login(NewPlayer2),

    %%加载座骑
    NewPlayer4 = lib_mount:role_login(NewPlayer3),

    %%加载关系
    lib_relation:role_login(NewPlayer4),
    
    %%加载帮派
    NewPlayer5 = guild_util:role_login(NewPlayer4),

    %%初始化任务  临时处理
    gen_server:cast(PidTask,{'init_task', NewPlayer5}),
    
    %%加载或进入场景
    %%ScnPlayer = lib_scene:init_player_scene(Player),
    NewPlayer5.
    
    
%% 加载玩家成就系统
%%----------------------------------------------
%% @spec 加载角色数据
%%    input: PlayerId -- 玩家ID
%%         Socket   -- 
%%----------------------------------------------
load_player_info(PlayerId, ResoltX, ResoltY, Socket) ->
    NowTime = util:unixtime() ,
    LastLoginTime = NowTime + 5 ,
    put(player_id,PlayerId),
    
    %%获取玩家结构 record
    RawPlayer = load_player_table(PlayerId),
	
    Player = load_for_runtime_data(RawPlayer, ResoltX, ResoltY, Socket, LastLoginTime) ,
    %%更新最近登录时间
    update_last_login(Player, Socket),
    
    %%获取禁言信息
    [StopBeginTime, StopSeconds] = lib_player:get_donttalk_status(PlayerId),
    put(donttalk, [StopBeginTime, StopSeconds]), 
	%% 初始化商店信息
	lib_shop:init_shop_info(PlayerId),
    Player.

test() ->
	Fun = fun(P) ->
				  io:format("====player: ~p~n", [[P#player.battle_attr#battle_attr.x,
												  P#player.battle_attr#battle_attr.y,
												  P#player.id,
												  P#player.scene,
												  P#player.battle_attr#battle_attr.hit_point,
												  P#player.battle_attr#battle_attr.hit_point_max]]) 
		  end ,
	lists:foreach(Fun, ets:tab2list(ets_online)) .

%% 卸载角色数据
unload_player_info(Status) ->
    %% 保存状态数据
    Now = util:unixtime(),
    save_player_table(Status#player{online_flag = 0}, 0),

    %%删除玩家节点ETS相关信息
    delete_player_ets(Status#player.id),
    
    %%禁言回写
    writeback_donttalk(Status#player.id, Now),

    %%下线离开场景
    pp_scene:handle(12004, Status, []),
    
    %%座骑退出
    lib_mount:role_logout(Status),

    %%关系退出
    lib_relation:role_logout(Status),

    %%更新物品buff和cd
    %lib_goods:role_logout(Status),
    
    %% 退出物品进程
    %gen_server:cast(Status#player.other#player_other.pid_goods, {stop, 0}),
    
    %% 退出任务进程
    gen_server:cast(Status#player.other#player_other.pid_task, {stop, Status}),
    
    %%下线删除定时器
    logout_cancel_timer(),
    
    %% 下线防沉迷处理
    handle_offline_antirevel(Status, Now),
    
    %%新手引导（改成实时写，在改动的时候）
%%     lib_system_config:save_system_config(),

	mod_goods_l:sub_ets_goods_num(Status#player.other#player_other.goods_ets_id),
	%% 清理商店日志记录
	lib_shop:clear_shop_info(Status#player.id),
    %% 关闭socket连接
    gen_tcp:close(Status#player.other#player_other.socket),
    ok.

delete_ets_when_init(PlayerId)->
    ets:delete(?ETS_ONLINE, PlayerId).

%%停止本游戏进程
stop(Pid, Reason) when is_pid(Pid) ->
    gen_server:cast(Pid, {stop, Reason}).

%% 设置副本
set_dungeon(Pid, PidDungeon) ->
    case misc:is_process_alive(Pid) of
        false -> false;
        true -> gen_server:cast(Pid, {'SET_PLAYER', [{pid_dungeon, PidDungeon}]})
    end.

%% 设置禁言 或 解除禁言
set_donttalk(PlayerId, {BeginTime, DurationSeconds}) ->
      gen_server:cast({local, misc:player_process_name(PlayerId)}, {set_donttalk, BeginTime, DurationSeconds}).

%%回写禁言时间.
%%有必要时才回写
writeback_donttalk(Id, Now) ->
     case get(donttalk) of
        [BeginTime, Duration] ->
            case (BeginTime + Duration) > (Now + 5) of
                true ->
                    db_agent:update_donttalk(Id, BeginTime, Duration);
                false ->
                    skip
            end;
        _Other ->   
            skip
     end.

%% 同步更新ETS中的角色数据
save_online(PlayerStatus) ->
    %% 更新本地ets里的用户信息
    ets:insert(?ETS_ONLINE, PlayerStatus),
    %% 更新对应场景中的用户信息
    mod_scene:update_player(PlayerStatus),
    ok.

%% 差异同步更新ETS中的角色数据
save_online_diff(OldPlayer,NewPlayer) ->
    if
        is_record(OldPlayer,player) andalso is_record(NewPlayer,player) ->
            Plist = record_info(fields,player),
            Olist = record_info(fields,player_other),
			AList = record_info(fields,battle_attr) ,
            Fields = Plist ++ Olist ++ AList ,
            OvalList = lib_player_rw:get_player_info_fields(OldPlayer,Fields),
            NvalList = lib_player_rw:get_player_info_fields(NewPlayer,Fields),
            KeyValue = get_diff_val(OvalList,NvalList,Fields),
            if
                length(KeyValue) > 0 ->
                    ets:insert(?ETS_ONLINE, NewPlayer),
                    mod_scene:update_player_info_fields(NewPlayer,KeyValue);
                true ->
                    skip
            end;
        true ->
            ?ERROR_MSG("badrecord in save_online_diff:~p~n", [[OldPlayer,NewPlayer]])
    end,
    ok.

get_diff_val(Ol,Nl,Fs)->
    get_diff_val_loop(Ol,Nl,Fs,[]).

get_diff_val_loop([],_,_,DiffList) ->
    DiffList;
get_diff_val_loop(_,[],_,DiffList) ->
    DiffList;
get_diff_val_loop(_,_,[],DiffList) ->
    DiffList;
get_diff_val_loop([V1|Ol],[V2|Nl],[K|Fs],DiffList) ->
    if
        K /= other andalso K /= battle_attr andalso V1 /= V2 ->
            get_diff_val_loop(Ol,Nl,Fs,[{K,V2}|DiffList]);
        true ->
            get_diff_val_loop(Ol,Nl,Fs,DiffList)
    end.
    
%%从玩家表读取基本信息, 转换成玩家Record
%%登录时使用
load_player_table(PlayerId) ->
    PlayerInfo = lib_account:get_info_by_id(PlayerId),
    RawPlayer = list_to_tuple([player|PlayerInfo]),
    %%战斗信息需要特别处理
    case is_binary(RawPlayer#player.battle_attr) of
        true  ->  case util:bitstring_to_term(RawPlayer#player.battle_attr) of
                      [X, Y, Combopoint, Hit_point, Magic, Anger|_T] ->
                            BattleAttr = #battle_attr{ x = X,
                                                       y = Y,
                                                       combopoint = Combopoint,
                                                       hit_point = Hit_point,
                                                       magic = Magic,
                                                       anger = Anger
                                                      },
                            RawPlayer#player{battle_attr = BattleAttr};
                      _Other ->
                            RawPlayer#player{battle_attr = #battle_attr{}}
                  end;
        false ->  RawPlayer#player{battle_attr = #battle_attr{}}
    end.

%%保存基本信息
%%这里主要统一更新一些相对次要的数据。
%%当玩家退出的时候也会执行一次这边的信息 
save_player_table(Status, _Cmd) ->
    BattleAttrStr = util:term_to_string([ Status#player.battle_attr#battle_attr.x,
                                          Status#player.battle_attr#battle_attr.y,
                                          Status#player.battle_attr#battle_attr.combopoint,
                                          Status#player.battle_attr#battle_attr.hit_point,
                                          Status#player.battle_attr#battle_attr.magic,
                                          Status#player.battle_attr#battle_attr.anger
                                        ]),
    FieldList = [   scene ,                              %% 场景ID	
                    cell_num,                            %% 物品格子数
                    level,                               %% 等级	
                    exp,                                 %% 经验	
                    online_flag,                         %% 在线标记，0不在线 1在线	
                    liveness,                            %% 活跃度	
                    lilian,                              %% 历练值
                    mount,                               %% 座骑外观
                    switch,                              %% 状态开关码1:功能开 0:功能关，位定义参考common.hrl	
                    battle_attr                          %% 战斗属性
                ],
    ValueList = [   Status#player.scene ,                %% 场景ID	
                    Status#player.cell_num,              %% 物品格子数	
                    Status#player.level,                 %% 等级	
                    Status#player.exp,                   %% 经验	
                    Status#player.online_flag,           %% 在线标记，0不在线 1在线	
                    Status#player.liveness,              %% 活跃度	
                    Status#player.lilian,                %% 历练值	
                    Status#player.mount,                 %% 座骑外观
                    Status#player.switch,                %% 状态开关码1:
                    BattleAttrStr                        %% 战斗属性存数据库部分
                ],
    db_agent_player:save_player_table(Status#player.id, FieldList, ValueList).


%%下线删除定时器
logout_cancel_timer() ->
    misc:cancel_timer(check_heart_timer),
    misc:cancel_timer(antirevel_act_timer),
    misc:cancel_timer(antirevel_warn_timer1),
    misc:cancel_timer(antirevel_warn_timer2),
    misc:cancel_timer(antirevel_warn_timer3),    
    ok.

%% 下线删除节点ETS表相关数据
delete_player_ets(PlayerId) ->
    %%清除玩家ets数据
    ets:delete(?ETS_ONLINE, PlayerId),
    %%清除任务模块及回存任务数据
    %lib_task:offline(PlayerId),
    %%删除在线玩家的ets物品表
    %goods_util:goods_offline(PlayerId, 1),
    ok.

%% --------------------------------------------------------------------
%% @spec 登陆的防沉迷处理
%%    input: acctount id
%% --------------------------------------------------------------------
online_antirevel(AcctId) ->
    case config:get_infant_ctrl(server) of
        1 -> %%防沉迷开启
            case db_agent:get_idcard_status(AcctId) of
                1 -> 
                    ok; %%成年人
                %未成年人或未填写
                _ ->
                    T_time = lib_antirevel:get_total_gametime(AcctId),
                    Alart_time_1h = data_antirevel:get_antirevel_con(warn_time1),    %%60*60 + 5,
                    Alart_time_2h = data_antirevel:get_antirevel_con(warn_time2),    %%120*60 + 5,
                    Alart_time = data_antirevel:get_antirevel_con(warn_time3),       %%(3*60-5)*60 + 5,
                    Force_out_time = data_antirevel:get_antirevel_con(act_time),     %%3*60*60 + 5,
                    if T_time >= Force_out_time ->  %%累计时间10秒后立刻退出，不开其他定时器了
                        ForceOutTimer = erlang:send_after(10*1000, self(), 'FORCE_OUT_REVEL'),
                        put(antirevel_act_timer, ForceOutTimer);
                    true ->
                        %%强制退出定时器
                        ForceOutTimer = erlang:send_after((Force_out_time - T_time + 10)*1000, self(), 'FORCE_OUT_REVEL'),
                        put(antirevel_act_timer, ForceOutTimer),
                        %%1小时通知
                        if T_time < Alart_time_1h ->
                           Timer_1h = erlang:send_after((Alart_time_1h - T_time) * 1000, self(), {'ALART_REVEL', 60}),
                           put(antirevel_warn_timer1, Timer_1h);
                        true -> ok
                        end,

                        %%两小时通知
                        if T_time < Alart_time_2h ->
                            Timer_2h = erlang:send_after((Alart_time_2h - T_time) * 1000, self(), {'ALART_REVEL', 120}),
                            put(antirevel_warn_timer2, Timer_2h);
                        true -> ok
                        end,

                        %%两小时55分钟能知
                        if T_time < Alart_time ->
                            Alart_timer = erlang:send_after((Alart_time - T_time) * 1000, self(), {'ALART_REVEL', 180}),
                            put(antirevel_warn_timer3, Alart_timer);
                        true -> ok
                        end
                    end
            end;
        _ -> 
            ok
    end .

%% 下线防沉迷处理
handle_offline_antirevel(Status, Now_time) ->
    case config:get_infant_ctrl(server) of
        1 -> %%防沉迷开启
            Accid = Status#player.account_id,
            case db_agent:get_idcard_status(Accid) of
                1 -> ok; %%成年人 
                _ ->
                    {TodayMidnight, _NextDayMidnight} = util:get_midnight_seconds(Now_time),
                     TotalTime = lib_antirevel:get_total_gametime(Accid), %%如果没有记录，这个函数会建立一条
                     case Status#player.last_login_time > TodayMidnight of
                         %今天登录的
                         true ->
                             NewTotalTime = TotalTime + tool:int_format(Now_time - Status#player.last_login_time);
                         %昨天登录 只记今天时间
                         false -> 
                             NewTotalTime = tool:int_format(Now_time - TodayMidnight)
                     end,
                     lib_antirevel:set_total_gametime(Accid, NewTotalTime),
                     lib_antirevel:set_logout_time(Accid, Now_time)
            end;
        _ -> ok
    end.

%% 更新本节点信息
update(PlayerStatus) ->
	ets:insert(?ETS_ONLINE, PlayerStatus).

%%协议测试函数
pp_test(PlayerId, Cmd, Data) ->
     case lib_player:get_player_pid(PlayerId) of 
         Pid when is_pid(Pid) ->  %%在线
             gen_server:call(Pid, {'SOCKET_EVENT', Cmd, Data});
         _Other ->  
             io:format("PlayerId: ~p is not online~n", [PlayerId])
     end.
