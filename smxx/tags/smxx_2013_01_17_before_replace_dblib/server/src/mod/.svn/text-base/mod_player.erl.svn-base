%%%------------------------------------
%%% @Module  : mod_player
%%% @Author  : 
%%% @Created : 2010.09.27
%%% @Description: 角色处理
%%%------------------------------------
-module(mod_player). 
-behaviour(gen_server).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-export([code_change/3, handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).
%%启动角色主进程
start(PlayerId, AccountId, Socket) ->
    gen_server:start(?MODULE, [PlayerId, AccountId, Socket], []).
 
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([PlayerId, AccountId, Socket]) ->
    net_kernel:monitor_nodes(true),

    %%注册进程和清理在线数据
    PlayerProcessAccountName = misc:player_process_accountname(lists:concat([PlayerId,AccountId])),
    misc:register(global, PlayerProcessAccountName, self()),
    PlayerProcessName = misc:player_process_name(PlayerId),
    misc:register(global, PlayerProcessName, self()),
    delete_ets_when_init(PlayerId),
    
    %%加载玩家数据和各种逻辑
    Status = load_player_info(PlayerId, Socket),
    
    %%上线防沉迷处理
    %online_antirevel(AccountId) ,
    
    %%各种定时器 
    erlang:send_after(5*1000,self(),'CHECK_DUPLICATE_LOGIN'),    %% 5秒后检查重复登陆

    %% 心跳包时间检测
    put(detect_heart_time, [0, 0, []]),
    HeartTimer = erlang:send_after(?HEARTBEAT_TICKET_TIME, self(), 'check_heart_time'),
    put(check_heart_timer, HeartTimer),
    
    %% 减速Timer
    misc:write_monitor_pid(self(),?MODULE, {PlayerId}),    
    {ok, Status}.


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
                    Alart_time_1h = data_player:get_antirevel_con(warn_time1),    %%60*60 + 5,
                    Alart_time_2h = data_player:get_antirevel_con(warn_time2),    %%120*60 + 5,
                    Alart_time = data_player:get_antirevel_con(warn_time3),       %%(3*60-5)*60 + 5,
                    Force_out_time = data_player:get_antirevel_con(act_time),     %%3*60*60 + 5,
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

%% 路由
%% cmd:命令号
%% Socket:socket id
%% data:消息体
routing(Cmd, Status, Bin) ->
    %%取前面二位区分功能类型
    io:format("mod_player routing: Id: ~p, Cmd: ~p ~n",[Status#player.id, Cmd]),
    [H1, H2, _, _, _] = integer_to_list(Cmd),
    case [H1, H2] of
        %%游戏基础功能处理
        "10" -> pp_base:handle(Cmd, Status, Bin);
        %"11" -> pp_chat:handle(Cmd, Status, Bin);
        "12" -> pp_scene:handle(Cmd, Status, Bin);
        "13" -> pp_player:handle(Cmd, Status, Bin);
        %"15" -> pp_goods:handle(Cmd, Status, Bin);
        %"18" -> pp_notice:handle(Cmd, Status, Bin);
        %"19" -> pp_mail:handle(Cmd, Status, Bin);
        %"20" -> pp_battle:handle(Cmd, Status, Bin);
        %"21" -> pp_skill:handle(Cmd, Status, Bin);
        %"30" -> pp_task:handle(Cmd, Status, Bin);
        %"34" -> pp_syssetting:handle(Cmd, Status, Bin); 
        %"36" -> pp_boss:handle(Cmd, Status, Bin);
        %"40" -> pp_guild:handle(Cmd, Status, Bin);
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

%%子socket断开消息
handle_cast({'SOCKET_CHILD_LOST', N},Status) ->
    NewStatus =
    case N of
        2 ->
            F = fun(Pid) ->
                        Pid ! {stop}
                end,
            lists:foreach(F, Status#player.other#player_other.pid_send2),
            Status#player{other=Status#player.other#player_other{socket2 = undefined,pid_send2 = []}};
        3 ->
            F = fun(Pid) ->
                        Pid ! {stop}
                end,
            lists:foreach(F, Status#player.other#player_other.pid_send3),
            Status#player{other=Status#player.other#player_other{socket3 = undefined,pid_send3 = []}};
        _ -> Status
    end,
    ets:insert(?ETS_ONLINE, NewStatus),
    {noreply,NewStatus};

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
handle_cast({set_donttalk, Stop_begin_time, Stop_chat_minutes}, Status) ->
    put(donttalk, [Stop_begin_time, Stop_chat_minutes]),
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
    PlayerProcessAccountName = misc:player_process_accountname(lists:concat([Player#player.id,Player#player.account_id])),
    case misc:whereis_name({global,PlayerProcessAccountName}) of
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
    if [Status#player.scene, Status#player.x, Status#player.y] == [Scene, X, Y] ->
       if Counter >= 30 -> %%9级以下，30分钟都不移动, 则做退出处理
           {ok, BinData} = pt_10:write(10007, 6),
           lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
           {stop, normal, Status};
       true ->
           erlang:send_after(60*1000, self(),
           {check_static_player, [Status#player.scene, Status#player.x,Status#player.y, Counter+1]}),
           {noreply, Status}
       end;
    true -> 
       {noreply, Status}
    end;


%% 子socket连接
handle_info({child_socket_join,N,Socket},Player) ->
    NewPlayer = 
    case N of
        2 ->
            %% 打开socket2广播信息进程
            Pid_send2 = lists:map(fun(_N)-> 
                        {ok,_Pid_send} = mod_pid_send:start(Socket,_N),
                        _Pid_send
                    end, lists:seq(1,?SEND_MSG)),
            Player#player{other=Player#player.other#player_other{socket2 = Socket,pid_send2 = Pid_send2}};
        3 ->
            %% 打开socket3广播信息进程
            Pid_send3 = lists:map(fun(_N)-> 
                        {ok,_Pid_send} = mod_pid_send:start(Socket,_N),
                        _Pid_send
                    end, lists:seq(1,?SEND_MSG)),
            Player#player{other=Player#player.other#player_other{socket3 = Socket,pid_send3 = Pid_send3}};
        _ -> Player
    end,
    if
        N > 1 -> 
            ets:insert(?ETS_ONLINE, NewPlayer);
        true ->
            skip
    end,    
    {noreply, NewPlayer};
     
%%心跳数据检测
handle_info('check_heart_time', Status) ->
    misc:cancel_timer(check_heart_timer),
    [_PreTime, Num, _TimeList] = get(detect_heart_time),
    if Num > 0 ->
           put(detect_heart_time, [0, 0, []]),
           HeartTimer = erlang:send_after(?HEARTBEAT_TICKET_TIME, self(), 'check_heart_time'),
           put(check_heart_timer, HeartTimer),
           {noreply, Status};
       true ->
           Now = util:unixtime(),
           NewTimeListStr = "",
           spawn(fun()-> db_log_agent:insert_kick_off_log(Status#player.id, Status#player.nick, 7, Now, 
                                                          Status#player.scene, Status#player.x, Status#player.y, NewTimeListStr) end),
           mod_player:stop(Status#player.other#player_other.pid, 7),
           {stop, normal, Status}
    end;


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
load_for_complete_record(Player, Socket, LastLoginTime) ->
    PlayerId = Player#player.id ,
    SocketGroupName = mod_socket:get_socket_group_name(Player#player.account_id) ,
    PidSocket = mod_socket:start([SocketGroupName, Socket, PlayerId, self()]) ,
    %% 打开广播信息进程
    PidSendList = lists:map(fun(_N)-> 
                             {ok, PidSend} = mod_pid_send:start(Socket,_N),
                             PidSend
                         end, lists:seq(1, ?SEND_MSG)) ,
    %%打开任务进程
    %{ok, PidTask} = mod_task:start_link([PlayerId]) ,
    PidTask = undefined,
    %{ok, PidGoods} = mod_goods:start(PlayerId, Player#player.clln, Player#player.dpn, Player#player.lstm, LastLoginTime, Pid_send),
    PidGoods = undefined,
    
    %%获取技能
    %Skill = lib_skill:get_all_skill(PlayerId, Player#player.crr),
    %NowSkillID = Skill#skill.cur_skill,

    %% 设置角色的相关信息
    Other = #player_other{ skill = 0,
                           socket = Socket,
                           pid = self() ,
                           pid_socket = PidSocket,
                           pid_goods = PidGoods,
                           pid_send = PidSendList,
                           pid_task = PidTask,
                           node = node()
                          },
    
    %% 初始化部分角色属性
    NewPlayer = Player#player{ 
                      account_name = binary_to_list(Player#player.account_name) ,
                      nick = binary_to_list(Player#player.nick) ,
                      last_login_time = LastLoginTime ,
                      online_flag = 1 ,
                      other = Other},

    %%更新ETS_ONLINE在线表
    ets:insert(?ETS_ONLINE, NewPlayer),
    NewPlayer.
    
%%----------------------------------------------
%%@spec 加载玩家运行时数据
%%----------------------------------------------
load_for_runtime_data(Player) ->
    PlayerId = Player#player.id , 
    %%新手进度
    lib_syssetting:init_system_config(PlayerId),
    
    %%初始化任务  临时处理
    %gen_server:cast(Player#player.other#player_other.pid_task,{'init_task',Player}),
    
    %%加载或进入场景
    %%ScnPlayer = lib_scene:init_player_scene(Player),
    %%ScnPlayer.
    Player.
    
    
%% 加载玩家成就系统
%%----------------------------------------------
%% @spec 加载角色数据
%%    input: PlayerId -- 玩家ID
%%         Socket   -- 
%%----------------------------------------------
load_player_info(PlayerId, Socket) ->
    NowTime = util:unixtime() ,
    LastLoginTime = NowTime + 5 ,
    put(player_id,PlayerId),
    
    %%获取玩家结构 record
    PlayerInfo = lib_account:get_info_by_id(PlayerId),
    RawPlayer = list_to_tuple([player | PlayerInfo]),
    CompPlayer = load_for_complete_record(RawPlayer, Socket, LastLoginTime) ,
    Player = load_for_runtime_data(CompPlayer) ,
    
    %%更新最近登录时间
    update_last_login(Player, Socket),
    
    %%获取禁言信息
    %%[Stop_begin_time, Stop_chat_minutes] =  lib_player:get_donttalk_status(PlayerId),
    %%put(donttalk, [Stop_begin_time, Stop_chat_minutes]), 
    Player.


%% 卸载角色数据
unload_player_info(Status) ->
    %% 保存状态数据
    Now = util:unixtime(),
    save_player_table(Status#player{online_flag = 0}, 0),
    %%删除玩家节点ETS相关信息
    delete_player_ets(Status#player.id),
    %%下线离开场景
    %pp_scene:handle(12004, Status, 0),
    %%更新物品buff和cd
    %lib_goods:role_logout(Status),
    %% 退出物品进程
    %gen_server:cast(Status#player.other#player_other.pid_goods, {stop, 0}),
    %% 退出任务进程
    %gen_server:cast(Status#player.other#player_other.pid_task, {stop, Status}),
    %%下线删除定时器
    logout_cancel_timer(),
    %% 下线防沉迷处理
    handle_offline_antirevel(Status, Now),
    %%新手引导
    lib_syssetting:save_system_config(Status#player.id),
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
set_donttalk(PlayerId, {Stop_begin_time, Stop_chat_minutes}) ->
      gen_server:cast({global, misc:player_process_name(PlayerId)}, 
                       {set_donttalk, Stop_begin_time, Stop_chat_minutes}).

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
            Fields = Plist ++ Olist,
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
        K /= other andalso V1 /= V2 ->
            get_diff_val_loop(Ol,Nl,Fs,[{K,V2}|DiffList]);
        true ->
            get_diff_val_loop(Ol,Nl,Fs,DiffList)
    end.
    
                
%%保存基本信息
%%这里主要统一更新一些相对次要的数据。譬如经验exp不会实时写入数据库
%%当玩家退出的时候也会执行一次这边的信息 
save_player_table(Status, _Cmd) ->
    %Now = util:unixtime(),
    %MyForce = lib_player:force_att(Status),
    FieldList = [   scene ,                              %% 场景ID	
                    x ,                                  %% X坐标	
                    y ,                                  %% Y坐标	
                    level ,                              %% 等级	
                    hit_point ,                          %% 生命	
                    hit_point_max ,                      %% 生命上限	
                    magic ,                              %% 法力值	
                    magic_max ,                          %% 法力值上限	
                    anger ,                              %% 怒气值	
                    anger_max ,                          %% 怒气值上限	
                    attack ,                             %% 普通攻击力	
                    defense ,                            %% 普通防御力	
                    abs_damage ,                         %% 绝对伤害值	
                    fattack ,                            %% 仙攻值	
                    mattack ,                            %% 魔攻值	
                    dattack ,                            %% 妖攻值	
                    fdefense ,                           %% 仙防值	
                    mdefense ,                           %% 魔防值	
                    ddefense ,                           %% 妖防值	
                    speed ,                              %% 移动速度	
                    attack_speed ,                       %% 攻击速度	
                    hit ,                                %% 命中等级	
                    dodge ,                              %% 闪避等级	
                    crit ,                               %% 暴击等级	
                    tough ,                              %% 坚韧等级	
                    hit_per ,                            %% 命中率	
                    dodge_per ,                          %% 闪避率	
                    crit_per ,                           %% 暴击率	
                    tough_per ,                          %% 坚韧率	
                    frozen_resis_per ,                   %% 冰冻抗性率	
                    weak_resis_per ,                     %% 虚弱抗性率	
                    flaw_resis_per ,                     %% 破绽抗性率	
                    poison_resis_per                     %% 中毒抗性率	
                ],
    ValueList = [   Status#player.scene ,                %% 场景ID	
                    Status#player.x ,                    %% X坐标	
                    Status#player.y ,                    %% Y坐标	
                    Status#player.level ,                %% 等级	
                    Status#player.hit_point ,            %% 生命	
                    Status#player.hit_point_max ,        %% 生命上限	
                    Status#player.magic ,                %% 法力值	
                    Status#player.magic_max ,            %% 法力值上限	
                    Status#player.anger ,                %% 怒气值	
                    Status#player.anger_max ,            %% 怒气值上限	
                    Status#player.attack ,               %% 普通攻击力	
                    Status#player.defense ,              %% 普通防御力	
                    Status#player.abs_damage ,           %% 绝对伤害值	
                    Status#player.fattack ,              %% 仙攻值	
                    Status#player.mattack ,              %% 魔攻值	
                    Status#player.dattack ,              %% 妖攻值	
                    Status#player.fdefense ,             %% 仙防值	
                    Status#player.mdefense ,             %% 魔防值	
                    Status#player.ddefense ,             %% 妖防值	
                    Status#player.speed ,                %% 移动速度	
                    Status#player.attack_speed ,         %% 攻击速度	
                    Status#player.hit ,                  %% 命中等级	
                    Status#player.dodge ,                %% 闪避等级	
                    Status#player.crit ,                 %% 暴击等级	
                    Status#player.tough ,                %% 坚韧等级	
                    Status#player.hit_per ,              %% 命中率	
                    Status#player.dodge_per ,            %% 闪避率	
                    Status#player.crit_per ,             %% 暴击率	
                    Status#player.tough_per ,            %% 坚韧率	
                    Status#player.frozen_resis_per ,     %% 冰冻抗性率	
                    Status#player.weak_resis_per ,       %% 虚弱抗性率	
                    Status#player.flaw_resis_per ,       %% 破绽抗性率	
                    Status#player.poison_resis_per       %% 中毒抗性率	
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


