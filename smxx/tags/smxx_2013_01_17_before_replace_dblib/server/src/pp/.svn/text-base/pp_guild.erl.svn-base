%%%--------------------------------------
%%% @Module  : pp_guild
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 联盟处理接口  
%%%--------------------------------------
-module(pp_guild).

-include("common.hrl").
-include("record.hrl").

-define(GUILD_TASK_ID, 1000).

-import(data_guild, [get_guild_config/2]).
-compile([export_all]).

%% %%=========================================================================
%% %% 接口函数
%% %%=========================================================================
%% 
%% %% -----------------------------------------------------------------
%% %% 40001 创建联盟  by chenzm
%% %% -----------------------------------------------------------------
%% 
%% handle(40001, Status, [GuildName, GuildNotice]) ->
%% 	case tool:is_operate_ok(pp_40001, 2) of
%% 		
%% 		true ->
%% 			TimeNow = util:unixtime(),
%% 			TimeRest = TimeNow - Status#player.uqlt,
%% 			
%% 			if 
%% 				TimeRest =< ?QUIT_GUILD_TIME_LIMIT -> %%最近有加入并退出过联盟，间隔时间太短
%% 					[Result, GuildId] = [11, 0];
%% 				true ->
%% 					[Result, GuildId] = mod_guild:create_guild(Status, [GuildName, GuildNotice])
%% 			end,
%% 			
%% 			if  % 创建成功
%% 				Result == 1 ->
%% 					% 发送回应
%% 					{ok, BinData} = pt_40:write(40001, [Result, GuildId]),
%% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 					%%扣钱
%% 					CreateCoin = data_guild:get_guild_config(create_coin, []),
%% 					StatusCoin = lib_goods:cost_money(Status, CreateCoin, coin, 4001),
%% %% 					StatusGold = lib_goods:cost_money(StatusCoin, 30, gold, 4001),
%% 					Status1 = StatusCoin#player{
%% 												unid = GuildId,
%% 												un = tool:to_binary(GuildName),
%% 												upst = 1,
%% 												uqlt = 0
%% 												},
%% 					lib_player:send_player_attribute(Status1, 2),
%% 					%% 加入联盟任务
%% 					lib_target:target(guild_lv,1),
%%  					lib_task:event(guild, null, Status),
%% %% 					lib_task:init_task_guild(Status1),			%%初始化联盟任务
%%                     %%通知成就系统：创建联盟一次
%% 					
%% 					%% 创建联盟广播
%% 					spawn(fun() -> lib_broadcast:broadcast_info(create_guild, [Status1#player.id, Status1#player.nick, GuildId, GuildName]) end),
%% 					
%% %% 					if 
%% %% 						Status#player.lv >= 40 ->
%% %% 							mod_slave:update_guild(0, GuildId, GuildName, Status#player.id);
%% %% 						true ->
%% %% 							ok
%% %% 					end,
%% 					
%% 					%% 通知客户端更新联盟旗帜buff
%% 					handle(40044, Status1, []),
%% 					lib_guild:get_guild_attr(Status1#player.id),
%% 					
%% 					NewStatus = lib_player:count_player_attribute(Status1), 
%% 					lib_pet2:refresh_all_pet(),
%% 					lib_player:send_player_attribute3(Status, NewStatus),
%% 					%% 通知场景
%% 					pp_player:handle(13090, NewStatus, [NewStatus#player.id,GuildId, GuildName]),
%% 					
%% 					{ok, NewStatus};
%% 				% 创建失败
%% 				true ->
%% 					% 发送回应
%% 					{ok, BinData} = pt_40:write(40001, [Result, 0]),
%% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 					ok
%% 			end;
%% 		false ->
%% 			{ok, BinData} = pt_40:write(40001, [0, 0]),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%% 	end;
%%     
%% %% -----------------------------------------------------------------
%% %% 40002 解散联盟  
%% %% -----------------------------------------------------------------
%% handle(40002, Status, [GuildId]) ->
%% 	QuitTime = util:unixtime(),
%% 	Result = mod_guild:confirm_disband_guild(Status, [GuildId, QuitTime]),
%% 
%% 	if  % 解散成功
%%         Result == 1 ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40002, Result),
%%              lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             % 返回新状态
%%             Status1 = Status#player{unid = 0,
%% 									un = <<>>,
%% 									upst = 0,
%% 									udpn = <<>>,
%% 									udpid = 0,
%% 									uqlt = QuitTime},
%% 			
%% 			%% 通知场景
%% 			pp_player:handle(13090, Status1, [Status1#player.id, GuildId, <<>>]),
%% 			
%% %% 			mod_slave:update_guild(2, GuildId, <<>>, Status#player.id),
%% 			
%% 			%% 临时屏蔽
%% %% 			gen_server:cast(Status1#player.other#player_other.pid_task,{'guild_task_del',Status1}),
%% %% 			%%解散联盟时，传出领地中的所有的成员
%% %% 			mod_guild_manor:send_out_all_manor(GuildId),
%% %% 			lib_task:delete_task_guild(Status1),	%%删除联盟任务
%% 			lib_task:refresh_active(Status1),	%%刷新可接任务列表
%% 			gen_server:cast(Status1#player.other#player_other.pid_task,{'task_list',Status1}),
%%             {ok, Status1};
%%         % 解散失败
%%         true ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40002, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%%     end;		
%% 
%% %% -----------------------------------------------------------------
%% %% 40004 申请加入 
%% %% -----------------------------------------------------------------
%% handle(40004, Status, [GuildId]) ->
%% 
%% 	if 
%% 		Status#player.ftst band 1024 =:= 0 -> %%对方未开启联盟功能
%% 			Result = 10;
%% 		true ->
%% 			[Result] = mod_guild:apply_join_guild(Status, [GuildId])
%% 	end,
%% 
%% 	{ok, BinData} = pt_40:write(40004, Result),	
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	
%% 	ok;
%%      
%% %% -----------------------------------------------------------------
%% %% 40005 撤销加入联盟
%% %% -----------------------------------------------------------------
%% handle(40005, Status, [GuildId]) ->
%%     [Result] = mod_guild:apply_cancel_join(Status, [GuildId]),
%% 	{ok, BinData} = pt_40:write(40005, Result),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40006 开除帮众
%% %% PlayerId:指定的联盟成员
%% %% -----------------------------------------------------------------
%% handle(40006, Status, [PlayerId]) ->
%% 	NowTime = util:unixtime(),
%%     [Result, PlayerName] = mod_guild:kickout_guild(Status, [PlayerId, NowTime]),
%%     if  % 踢出成功
%%         Result == 1 ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40006, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             %% 通知联盟成员
%% 			lib_guild:send_guild(0, Status#player.id, Status#player.unid, guild_kickout, [PlayerId, PlayerName, Status#player.unid, Status#player.un, NowTime]),
%% 			%% 通知被踢出者
%%             lib_guild_inner:send_msg_to_player(PlayerId, guild_kickout, [PlayerId, PlayerName, Status#player.unid, Status#player.un, NowTime]),
%% 			
%% 			% 邮件给被踢出者
%% 			Content = lists:concat(["您被踢出了联盟。"]),
%% 			lib_guild_inner:send_guild_notice(1, [PlayerId], Content),
%% 			
%% %% 			mod_slave:update_guild(1, 0, <<>>, PlayerId),
%% 			
%% 			mod_guild:delete_member_sit(PlayerId, Status#player.unid),
%% 			%%如果在领地里面，则主动传出
%% 			%%mod_guild_manor:quit_guild_manor(0, {PlayerId, Status#player.unid, 1}),
%%            
%%             ok;
%%         % 踢出失败
%%         true ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40006, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%%     end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40007 查询个人联盟信息
%% %% -----------------------------------------------------------------
%% handle(40007, Status, [PlayerId]) ->
%%     [Result, GuildLv, MemberInfo] = mod_guild:guild_member_info(Status, [PlayerId]),
%% 
%% %%     if % 查询成功
%% %%         Result == 1 ->
%% %% 			GuildId = MemberInfo#ets_guild_member.unid,
%% %% 			Position = MemberInfo#ets_guild_member.upst,
%% %% 			Devotion = MemberInfo#ets_guild_member.devo,
%% %% 			RemoveDv = MemberInfo#ets_guild_member.rmdv,
%% %% 			
%% %%             % 发送回应
%% %%             {ok, BinData} = pt_40:write(40007, [Result, GuildId, GuildLv, Position, Devotion, RemoveDv]),
%% %%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %%             ok;
%% %%         % 查询失败
%% %%         true ->
%% %% 			GuildId = 0,
%% %% 			Position = 0,
%% %% 			Devotion = 0,
%% %% 			RemoveDv = 0,
%% %% 			
%% %%             % 发送回应
%% %%             {ok, BinData} = pt_40:write(40007, [Result, GuildId, 0, Position, Devotion, RemoveDv]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %%             ok
%% %%     end;	
%% ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40008 退出联盟 
%% %% -----------------------------------------------------------------
%% handle(40008, Status, []) ->
%% 	QuitTime = util:unixtime(),
%%     Result = mod_guild:quit_guild(Status, [QuitTime]),
%%     if  % 退出成功
%%         Result == 1 ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40008, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 			% 返回新状态
%%             Status1 = Status#player{unid = 0,
%%                                     un   = <<>>,
%%                                     upst = 0,
%% 									uqlt = QuitTime									
%% 								   },
%% 			
%% 			%% 通知联盟成员
%% 			lib_guild:send_guild(1, Status#player.id, Status#player.unid, quit_guild, [Status#player.id, Status#player.nick, Status#player.unid, Status#player.un]),
%% 			
%% %% 			mod_slave:update_guild(1, 0, <<>>, Status#player.id),
%% 			%% 通知场景
%% 			pp_player:handle(13090, Status1, [Status1#player.id, Status#player.unid, <<>>]),
%% 			
%% 			
%% 			%% 通知客户端更新联盟技能buff
%% 			handle(40039, Status1, []),
%% 			
%% 			%% 通知客户端更新联盟旗帜buff
%% 			handle(40044, Status1, []),
%% 			
%% 			lib_guild:get_guild_attr(Status1#player.id),
%% 			
%% 			NewStatus = lib_player:count_player_attribute(Status1), 
%% 			lib_pet2:refresh_all_pet(),
%% 			lib_player:send_player_attribute3(Status, NewStatus),
%% 			
%% 			%%如果在领地里面，则主动传出
%% 			%%mod_guild_manor:quit_guild_manor(1, {Status#player.other#player_other.pid_scene, Status#player.scn,
%% 			%%									 Status#player.id,Status#player.unid, 1}),
%% 			%%玩家退出帮派，处理帮派任务
%% 			%% 临时屏蔽
%% %% 			lib_task:abnegate_guild_task(Status1),
%% 			%%gen_server:cast(Status#player.other#player_other.pid_task,{'guild_task_del',Status1}),
%% %% 			lib_task:delete_task_guild(NewStatus),	%%删除联盟任务
%% 			lib_task:refresh_active(NewStatus),	%%刷新可接任务列表
%% 			gen_server:cast(NewStatus#player.other#player_other.pid_task,{'task_list',NewStatus}),
%% 			
%% 			%%mod_guild:delete_member_sit(Status#player.id, Status#player.unid),
%%             {ok, NewStatus};
%%         % 退出失败
%%         true ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40008, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%%     end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40009 盟主让位
%% %% -----------------------------------------------------------------
%% handle(40009, Status, [PlayerId]) ->
%%     [Result, Upst, PlayerName] = mod_guild:demise_chief(Status, [PlayerId]),
%% 	
%%     if % 让位成功
%%         Result == 1 ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40009, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             % 通知联盟成员
%%             lib_guild:send_guild(1, Status#player.id, Status#player.unid, 
%% 								 guild_demise_chief, [Status#player.id, Status#player.nick, PlayerId, PlayerName]),
%% 			
%% %%            %向整个联盟成员发送信件
%% %% 			lib_guild:send_mail_guild_everyone(1, Status#player.id, Status#player.unid, guild_demise_chief,
%% %% 											   [Status#player.nick, PlayerName, Status#player.un]),
%% 			% 返回新状态
%%             Status1 = Status#player{upst = Upst},
%% 			
%% 			mod_guild_guard_agent:change_master(Status1#player.unid,PlayerId,PlayerName),
%% 			
%%             {ok, Status1};
%%         % 创建失败
%%         true ->
%%             % 发送回应
%%             {ok, BinData} = pt_40:write(40009, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%%     end;	
%% 
%% %% -----------------------------------------------------------------
%% %% 40010 获取联盟列表 	  by chenzm
%% %% -----------------------------------------------------------------
%% handle(40010, Status, [GuildName, MasterName]) ->
%%     [Ret, GuildList, ApplyIdList] = mod_guild:list_guild(Status, [GuildName, MasterName]),
%% 
%%     {ok, BinData} = pt_40:write(40010, [Ret, GuildList, ApplyIdList]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40011 获取联盟成员列表  by chenzm
%% %% -----------------------------------------------------------------
%% handle(40011, Status, [GuildId]) ->
%%     [Ret, MemberList] = mod_guild:list_guild_member(Status, [GuildId]),
%% 
%%     {ok, BinData} = pt_40:write(40011, [Ret, MemberList]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40012 获取联盟日记 
%% %% -----------------------------------------------------------------
%% handle(40012, Status, [GuildId]) ->
%%     LogList = mod_guild:get_guild_log(Status, [GuildId]),
%% 	
%%     {ok, BinData} = pt_40:write(40012, LogList),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40013 获取联盟申请列表  
%% %% -----------------------------------------------------------------
%% handle(40013, Status, [GuildId]) ->
%%     [Len, Data] = mod_guild:list_guild_apply(Status, [GuildId]),
%%     {ok, BinData} = pt_40:write(40013, [Len, Data]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40014 查看联盟信息	
%% %% -----------------------------------------------------------------
%% handle(40014, Status, [GuildId]) ->
%%     [Result, Guild] = mod_guild:get_guild_info(Status, [GuildId]),
%% 	if 
%% 		Result =:= 1 ->
%% 			List = mod_guild:get_guild_rank([GuildId]),
%% 			[_Ret, Blv, Dplv, _Skills] = mod_guild:get_guild_beast(Status),	
%% 			case List of
%% 				[] -> 
%% 					Rank = 0;
%% 				_ ->
%% 					{_Gid, Rank} = lists:nth(1, List)
%% 			end;
%% 		true ->
%% 			Rank = 0,
%% 			Blv = 0, 
%% 			Dplv = 0
%% 	end,
%% 	
%%     {ok, BinData} = pt_40:write(40014, [Result, Guild, Rank, Blv, Dplv]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40015 修改联盟公告 	
%% %% -----------------------------------------------------------------
%% handle(40015, Status, [GuildId, Announce]) ->
%%     [Result] = mod_guild:modify_guild_announce(Status, [GuildId, 0, Announce]),
%%     {ok, BinData} = pt_40:write(40015, Result),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40016 捐献钱币
%% %% -----------------------------------------------------------------
%% handle(40016, Status, [GuildId, Value, Type]) ->	
%% 	case tool:is_operate_ok(pp_40016, 1) of
%% 		true ->
%% 			if Type > 2 ->
%% 				   {ok, BinData} = pt_40:write(40016, [0, Value, Type]),
%% 				   lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 				   ok;
%% 			   Type =:= 0 andalso Value < 1000 -> %% 铜币捐献不能小于100
%% 				   {ok, BinData} = pt_40:write(40016, [0, Value, Type]),
%% 				   lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 				   ok;				   
%% 			   Type =:= 0 andalso Value =< 0 -> %% 元宝捐献不能为0
%% 				   {ok, BinData} = pt_40:write(40016, [0, Value, Type]),
%% 				   lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 				   ok;
%% 			   true ->
%% 				   [Result, NewStatus] = mod_guild:donate_money(Status, [GuildId, Value, Type]),
%% 				   
%% 				   if  % 捐献成功
%% 					   Result == 1 ->
%% 						   % 发送回应
%% 						   {ok, BinData} = pt_40:write(40016, [Result, Value, Type]),
%% 						   lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 						   % 返回新状态
%% 						   lib_player:send_player_attribute(NewStatus, 2),
%% 						   
%% 						   [_Fund, _Devo, PerDevo] = data_guild:get_donate_money(Value, Type),						   
%% 						   List = update_guild_member_devo(NewStatus#player.id, PerDevo),
%% 						   case List of
%% 							   [] -> ok;
%% 							   _ ->
%% 								   {ok, BinData1} = pt_40:write(40041, [1, List]),
%% 								   lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData1)
%% 						   end,
%% 						   
%% 						   {ok, NewStatus};
%% 					   true ->% 捐献失败
%% 						   % 发送回应
%% 						   {ok, BinData} = pt_40:write(40016, [Result, Value, Type]),
%% 						   lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 						   ok
%% 				   end
%% 			end;
%% 		false ->
%% 			ok
%% 	end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40017 联盟升级请求
%% %% -----------------------------------------------------------------
%% handle(40017, Status, [GuildId]) ->
%% 	[Result, NewLevel] = mod_guild:guild_upgrade(Status,[GuildId]),
%% 	
%% 	{ok, BinData} = pt_40:write(40017, Result),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	
%% 	lib_target:target(guild_lv,NewLevel),
%% 	ok;
%% 	
%% 
%% %% -----------------------------------------------------------------
%% %% 40018 领取俸禄
%% %% -----------------------------------------------------------------
%% handle(40018, _Status, []) ->
%% 	ok;
%% %% 	case tool:is_operate_ok(pp_40018, 1) of
%% %% 		true ->
%% %% 			%%io:format("~s handle_40018 [~p] \n ",[misc:time_format(now()), Status]),
%% %% 			[Result, Salary, NewStatus] = mod_guild:get_member_salary(Status,[]),
%% %% 			%%io:format("~s handle_40018 [~p/~p] \n ",[misc:time_format(now()), Result, NewStatus]),
%% %% %% 			LTGetWeal = lib_guild_weal:get_weal_lasttime(Status#player.id),
%% %% %% 			[Result, NewStatus] = mod_guild_manor:check_get_member_weal(Status, LTGetWeal),
%% %% 			case Result of
%% %% 				1 ->
%% %% 					{ok, BinData} = pt_40:write(40018, [Result, Salary]),
%% %% 					lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData),
%% %% 					lib_player:send_player_attribute2(NewStatus, 2),
%% %% 					
%% %% 					%%长生秘笈
%% %% %% 					lib_help:chang_help_data(NewStatus, salary),
%% %% 					
%% %% 					{ok, NewStatus};
%% %% 				_ ->
%% %% 					{ok, BinData} = pt_40:write(40018, [Result, Salary]),
%% %% 					lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData),
%% %% 					ok
%% %% 			end;
%% %% 		false ->
%% %% 			{ok, BinData} = pt_40:write(40018, [0, 0]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 			ok
%% %% 	end;
%% 
%% %% -----------------------------------------------------------------
%% %% 提升职务
%% %% -----------------------------------------------------------------
%% handle(40019, Status, [PlayerId, Position]) ->
%% 	[Result, PlayerName, OldPosition, NewPosition, PositionName] = mod_guild:set_member_post(Status, [Status#player.unid, PlayerId, Position]),
%% 
%% 	case Result of
%% 		1 ->
%% 			{ok, BinData} = pt_40:write(40019, Result),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 			
%% 			% 通知联盟成员
%%             lib_guild:send_guild(1, Status#player.id, Status#player.unid, 
%% 								 guild_set_position, [1, PlayerId, PlayerName, OldPosition, NewPosition]),
%% 			
%% %% %% 			%%相对应的成员发即时信息	
%% %% 			lib_guild_inner:send_msg_to_player(PlayerId, guild_set_position, 
%% %% 											   [1, PlayerId, PlayerName, NewPosition]),			
%% 			%%邮件通知 
%% 			Content = lists:concat(["恭喜您，您被提升为本盟的",PositionName,"。"]),			
%% 			lib_guild_inner:send_guild_notice(1, [PlayerId], Content),	
%%  			
%%             ok;
%%         _ ->
%%             {ok, BinData} = pt_40:write(40019, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%%     end;
%% 
%%       
%% %% -----------------------------------------------------------------
%% %% 40020 批准/拒绝加入 
%% %% -----------------------------------------------------------------
%% handle(40020, Status, [PlayerId, Type]) ->
%% 	[Result, _Num] =  mod_guild:approve_guild_apply(Status, [PlayerId, Type]),
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40020, Result),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 								
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40021 发起弹劾
%% %% -----------------------------------------------------------------
%% handle(40021, Status, [PlayerId, GuildId]) ->
%% 	if 
%% 		Status#player.gold < 100 -> %% 元宝不足
%% 			Result = 10, 
%% 			NewStatus = Status;
%% 		true ->
%% 			[Result, _Time] =  mod_guild:accuse_chief(PlayerId, Status#player.nick, GuildId, Status#player.upst),
%% 			if 
%% 				Result =:= 1 orelse Result =:= 2 ->
%% 					NewStatus = lib_goods:cost_money(Status, 100, gold, 4021);
%% 				true ->
%% 					NewStatus = Status
%% 			end,
%% 			
%% 			lib_player:send_player_attribute2(NewStatus, 2)
%% 	end,
%% 			
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40021, Result),
%% 	lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData),
%% 	if 
%% 		NewStatus =/= Status ->
%% 			{ok, NewStatus};
%% 		true ->
%% 			ok
%% 	end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40022 获取弹劾信息
%% %% -----------------------------------------------------------------
%% handle(40022, Status, [GuildId]) ->
%% 	[Result, Guild, PlayerName] = mod_guild:get_accuse_info(Status, [GuildId]),
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40022, [Result, Guild, PlayerName]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40023 弹劾操作
%% %% -----------------------------------------------------------------
%% handle(40023, Status, [GuildId, Operation]) ->
%% 	[Result] = mod_guild:accuse_vote(Status, [GuildId, Operation]),
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40023, Result),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 解除职务
%% %% -----------------------------------------------------------------
%% handle(40024, Status, [PlayerId]) ->
%% 	DefaultPosition = data_guild:get_guild_config(default_position, []),
%% 	[Result, PlayerName, OldPosition, NewPosition, _PositionName] = mod_guild:release_member_post(Status, [Status#player.unid, PlayerId, DefaultPosition]),
%% 
%% 	case Result of
%% 		1 ->
%% 			{ok, BinData} = pt_40:write(40024, Result),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 			
%% 			% 通知联盟成员
%%             lib_guild:send_guild(1, Status#player.id, Status#player.unid, 
%% 								 guild_set_position, [2, PlayerId, PlayerName, OldPosition, NewPosition]),
%% 			
%% 			%% 邮件通知
%% 			Content = lists:concat(["很遗憾，您被盟主撤销了职位。"]),			
%% 			lib_guild_inner:send_guild_notice(1, [PlayerId], Content),	
%% 			
%% %% 			%%相对应的成员发即时信息	
%% %% 			lib_guild_inner:send_msg_to_player(PlayerId, guild_set_position, 
%% %% 											   [2, PlayerId, PlayerName, NewPosition]),
%% 
%% %% 			Param = [PlayerName, Status#player.nick, PositionName],
%% %% 			lib_guild:send_guild_mail(guild_set_position, Param),
%%             ok;
%%         _ ->
%%             {ok, BinData} = pt_40:write(40024, Result),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%             ok
%%     end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40025 联盟商店信息
%% %% -----------------------------------------------------------------
%% handle(40025, Status, [PlayerId]) ->
%% 	[Result, GuildShop, ShopList] = mod_guild:get_guild_shop_info(Status, [PlayerId]),
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40025, [Result, GuildShop, ShopList]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40026 购买联盟商店物品
%% %% -----------------------------------------------------------------
%% handle(40026, Status, [GoodsTypeId, Cell]) ->
%% 	[Result, ReDevo, GoodsList] = mod_guild:pay_guild_shop(Status, [GoodsTypeId, Cell]),
%% 	
%% 	if 
%% 		Result =:= 1 ->
%% 			case lists:member(GoodsTypeId, [460612,460610,470901]) of
%% 				true ->
%% 					spawn(fun()->lib_broadcast:broadcast_info(guild_shop, [Status#player.id, Status#player.nick, GoodsTypeId])end);
%% 				_ -> ok
%% 			end;
%% 		true ->
%% 			ok
%% 	end,
%% 
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40026, [Result, ReDevo]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	
%% 	if 
%% 		Result =:= 1->
%% 			%% 发送50000协议通知客户端更新背包系统数据
%% 			{ok, BinData1} = pt_50:write(50000, GoodsList),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData1),
%% 			
%% 			ok;
%% 			%lib_goods_use:add_pet_egg_timer(NewStatus),
%% 			
%% 			% 返回新状态
%% 			%lib_player:send_player_attribute2(NewStatus, 2),
%% 			%{ok, NewStatus};
%% 		true ->
%% 			ok
%% 	end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40027 刷新联盟商店物品
%% %% -----------------------------------------------------------------
%% handle(40027, Status, [PlayerId]) ->
%% 
%% %% 	[Result, GuildShop, NewStatus] = 
%% %% 	try 
%% %% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% %% 						{apply_call, lib_guild, guild_member_info, [PlayerId]}) of
%% %% 			 error -> 
%% %% 				 [0, [], Status];
%% %% 			 [Ret, _GuildLv, MemberInfo] -> 
%% %% 				 if 
%% %% 					 Ret =:= 1 ->						 
%% %% 						 lib_guild:refresh_guild_shop(Status, [PlayerId, MemberInfo#ets_guild_member.lv, MemberInfo#ets_guild_member.rmdv]);
%% %% 					 true ->
%% %% 						 [0, [], Status]				 
%% %% 				end
%% %% 		end	
%% %% 	catch
%% %% 		_:_Reason -> 
%% %% 			[0, [], Status]
%% %% 	end,	
%% %% 
%% %% 	%% 发送回应
%% %% 	{ok, BinData} = pt_40:write(40027, [Result, GuildShop]),
%% %% 	lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData),
%% %% 	
%% %% 	if 
%% %% 		NewStatus =/= Status ->
%% %% 			% 返回新状态
%% %% 			lib_player:send_player_attribute2(NewStatus, 2),
%% %% 			{ok, NewStatus};
%% %% 		true ->
%% %% 			ok
%% %% 	end;
%% ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40028 查询是否有入盟申请
%% %% -----------------------------------------------------------------
%% handle(40028, Status, []) ->
%% 	[Len, _Data] = mod_guild:list_guild_apply(Status, [Status#player.unid]),
%% 	if 
%% 		Len > 0 ->
%% 			Ret = 1;
%% 		true ->
%% 			Ret =0
%% 	end,
%% 	
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40028, [Ret]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40029 邀请加入联盟
%% %% -----------------------------------------------------------------
%% handle(40029, Status, [PlayerId]) ->
%% 	Ret = mod_guild:guild_invite_player(Status, [PlayerId]),		
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40029, [Ret]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40030 处理邀请加入联盟
%% %% -----------------------------------------------------------------
%% handle(40030, Status, [Type, GuildId]) ->
%% 	[Ret, GuildName] = mod_guild:response_guild_invite(Status, [Type, GuildId]),		
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40030, [Ret, Type, GuildId, GuildName]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40034 获取联盟神兽技能信息
%% %% -----------------------------------------------------------------
%% handle(40034, Status, []) ->
%% 	[Ret, Blv, _DpLv, Skills] = mod_guild:get_guild_beast(Status),		
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40034, [Ret, Blv, Skills]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40035 升级联盟神兽
%% %% -----------------------------------------------------------------
%% handle(40035, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, Blv, Funds] = [6, 0, 0];
%% 		Status#player.upst =/= 1 ->
%% 			[Ret, Blv, Funds] = [5, 0, 0];
%% 		true ->
%% 			[Ret, Blv, Funds] = mod_guild:upgrade_guild_beast(Status#player.id, Status#player.unid)
%% 	end,
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40035, [Ret, Blv, Funds]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40036 联盟技能研究
%% %% -----------------------------------------------------------------
%% handle(40036, Status, [SkillId]) ->
%% %% 	if 
%% %% 		Status#player.unid =:= 0 ->
%% %% 			[Ret, Lv, Funds] = [6, 0, 0];
%% %% 		Status#player.upst > 2 ->
%% %% 			[Ret, Lv, Funds] = [5, 0, 0];
%% %% 		true ->
%% %% 			[Ret, Lv, Funds] = mod_guild:upgrade_guild_skill(Status#player.id, Status#player.unid, SkillId)
%% %% 	end,
%% %% 	%% 发送回应
%% %% 	{ok, BinData} = pt_40:write(40036, [Ret, SkillId, Lv, Funds]),
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40037 获取自己的联盟技能信息
%% %% -----------------------------------------------------------------
%% handle(40037, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, Devo, Skills] = [2, 0, []];
%% 		true ->
%% 			[Ret, Devo, Skills] = mod_guild:get_member_skill(Status#player.id)
%% 	end,
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40037, [Ret, Devo, Skills]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 40038 升级自己的联盟技能
%% %% -----------------------------------------------------------------
%% handle(40038, Status, [SkillId]) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, Lv, Glv, Devo] = [2, 0, 0, 0];
%% 		true ->
%% 			[Ret, Lv, Glv, Devo] = mod_guild:upgrade_member_skill(Status#player.id, Status#player.unid, SkillId)
%% 	end,
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40038, [Ret, SkillId, Lv, Glv, Devo]),	
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	
%% 	if 
%% 		Ret =:= 1 ->			
%% 			%% 通知客户端更新联盟技能buff
%% 			handle(40039, Status, []),
%% 
%% 			lib_guild:get_guild_attr(Status#player.id),
%% 			
%% 			NewStatus = lib_player:count_player_attribute(Status), 
%% 			lib_pet2:refresh_all_pet(),
%% 			lib_player:send_player_attribute3(Status, NewStatus),
%%             %%通知成就系统： 学习联盟技能等级总和（每次学习升一级!?）
%% 			{ok, NewStatus};
%% 		true ->
%% 			ok
%% 	end;
%% 
%% %% -----------------------------------------------------------------
%% %% 40039 获取联盟技能buf
%% %% -----------------------------------------------------------------
%% handle(40039, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, Skills] = [2,[]];
%% 		true ->
%% 			[Ret, Skills] = mod_guild:get_member_skill_buf(Status#player.id)
%% 	end,
%% 
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40039, [Ret, Skills]),	
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),	
%% 	ok;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40040 升级联盟仓库
%% %% -----------------------------------------------------------------
%% handle(40040, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, Lv, Funds] = [6, 0, 0];
%% 		Status#player.upst =/= 1 ->
%% 			[Ret, Lv, Funds] = [5, 0, 0];
%% 		true ->
%% 			[Ret, Lv, Funds] = mod_guild:upgrade_guild_depot(Status#player.id, Status#player.unid)
%% 	end,
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40040, [Ret, Lv, Funds]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 获取本联盟捐献排名
%% %% -----------------------------------------------------------------
%% handle(40041, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, RankList] = [3, []];
%% 		true ->
%% 			[Ret, List] = mod_guild:get_guild_member_devo(Status#player.unid),
%% 			set_guild_member_devo(List),
%% 			RankList = rank_guild_member_devo(List)
%% 	end,
%% 	
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40041, [Ret, RankList]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 获取自己联盟旗帜信息
%% %% -----------------------------------------------------------------
%% handle(40042, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[Ret, Lv, FGold, NeedGold] = [2, 0, 0, 0];
%% 		true ->
%% 			[Ret, Lv, FGold, NeedGold] = mod_guild:get_guild_flag_info(Status#player.id, Status#player.unid)
%% 	end,
%% 	
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40042, [Ret, Lv, FGold, NeedGold]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 进行联盟旗帜镀金
%% %% -----------------------------------------------------------------
%% handle(40043, Status, [Num]) ->	
%% 	[Ret, Lv, FGold, NeedGold, Devo, RealNum] = mod_guild:upgrade_guild_flag(Status, Num),
%% 	
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40043, [Ret, Lv, FGold, NeedGold, Devo]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	
%% 	if 
%% 		Ret =:= 1 andalso RealNum =/= 0 ->
%% 			% 返回新状态
%% 			NewStatus = lib_goods:cost_money(Status, RealNum, gold, 4043),
%% 			lib_player:send_player_attribute2(NewStatus, 2),
%% 			{ok, NewStatus};
%% 		true ->
%% 			ok
%% 	end;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 获取退盟冷切时间和联盟旗帜buf
%% %% -----------------------------------------------------------------
%% handle(40044, Status, []) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			NowTime = util:unixtime(),
%% 			if 
%% 				Status#player.uqlt + ?QUIT_GUILD_TIME_LIMIT > NowTime ->
%% 					TimeRest = Status#player.uqlt + ?QUIT_GUILD_TIME_LIMIT - NowTime;
%% 				true ->
%% 					TimeRest = 0
%% 			end,
%% 			
%% 			Ret = 1,
%% 			List = [];
%% 		true ->
%% 			TimeRest = 0,
%% 			[Ret, List] = mod_guild:get_guild_flag_buf(Status#player.id, Status#player.unid),
%% 			put(player_flag_buf, List)
%% 	end,
%% 	
%% 	%% 发送回应
%% 	{ok, BinData} = pt_40:write(40044, [Ret, TimeRest, List]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%联盟打坐活动%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% -----------------------------------------------------------------
%% %% 获取联盟活动列表  以下屏蔽
%% %% -----------------------------------------------------------------
%% %% handle(40050, Status, [])  ->
%% %% 	%io:format("~s handle_40050 Result[~w] \n ",[misc:time_format(now()), test]),
%% %% 	mod_guild:guild_sit(Status#player.other#player_other.pid_send, Status#player.unid),
%% %% 	ok;
%% %% 
%% %% %% -----------------------------------------------------------------
%% %% %% 获取联盟打坐旗帜信息
%% %% %% -----------------------------------------------------------------
%% %% handle(40051, Status, [])  ->
%% %% 	DataFlag = data_guild:get_sit_flag_info(),
%% %% 	{ok, BinData} = pt_40:write(40051, [DataFlag]),
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 	ok;
%% %% 
%% %% %% -----------------------------------------------------------------
%% %% %% 开启打坐
%% %% %% -----------------------------------------------------------------
%% %% handle(40052, Status, [Type, Scene])  ->
%% %% %% 	io:format("~s handle_40052 Result[~w] \n ",[misc:time_format(now()), Scene]),
%% %% 	Ret =
%% %% 		case data_guild:get_sit_flag_info(Type) of
%% %% 			{_FlagType, _Raise, Cost, CostType, _Jade, _Devo} ->
%% %% 				MoneyType =
%% %% 					case CostType of
%% %% 						1 ->
%% %% 							gold;
%% %% 						_ ->
%% %% 							coin
%% %% 					end,
%% %% 				case goods_util:is_enough_money(Status, Cost, MoneyType) of
%% %% 					true ->
%% %% 						case data_player:is_open_scene(Scene, Status#player.scst) of
%% %% 							true ->
%% %% 								Res = mod_guild:guild_sit_start(Status, Type, Scene),
%% %% 								{ok, BinData} = pt_40:write(40052, [Res]),
%% %% 								if
%% %% 									Res =:= 1 ->
%% %% 										NewStatus = lib_goods:cost_money(Status, Cost, MoneyType, 4052),
%% %% 										lib_player:send_player_attribute2(NewStatus, 2),
%% %% 										{ok, NewStatus};
%% %% 									true ->
%% %% 										ok
%% %% 								end;
%% %% 							_ ->
%% %% 								{ok, BinData} = pt_40:write(40052, [7]),
%% %% 								ok
%% %% 						end;
%% %% 					_ ->
%% %% 						{ok, BinData} = pt_40:write(40052, [CostType + 1]),
%% %% 						ok
%% %% 				end;
%% %% 			_ ->
%% %% 				{ok, BinData} = pt_40:write(40052, [0]),
%% %% 				ok
%% %% 		end,
%% %% 	
%% %% %%  	io:format("~s handle_40052 Result[~p] \n ",[misc:time_format(now()), [BinData]]),
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 	Ret;
%% %% 
%% %% %% -----------------------------------------------------------------
%% %% %% 打坐召唤
%% %% %% -----------------------------------------------------------------
%% %% handle(40054, Status, _)  ->
%% %% 	mod_guild:guild_sit_call(Status),
%% %% 	ok;
%% %% 
%% %% 
%% %% %% -----------------------------------------------------------------
%% %% %% 参与打坐
%% %% %% -----------------------------------------------------------------
%% %% handle(40056, Status, [Type])  ->
%% %% 	%io:format("~s handle_40056 [~p] \n ",[misc:time_format(now()), [Type]]),
%% %% 	if 
%% %% 		Status#player.ftst band 1024 =:= 0 andalso Type =:= 1-> 
%% %% 			{ok, BinData} = pt_40:write(40056, [2, 0, 0, 0, 0, 0, 0, 0, 0]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
%% %% 		Status#player.unid =:= 0 andalso Type =:= 1 -> 
%% %% 			{ok, BinData} = pt_40:write(40056, [3, 0, 0, 0, 0, 0, 0, 0, 0]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
%% %% 		true ->
%% %% 			mod_guild:guild_sit_attend(Status, Type)
%% %% 	end,
%% %% 	
%% %% 	ok;
%% %% %% -----------------------------------------------------------------
%% %% %% 互动游戏
%% %% %% -----------------------------------------------------------------
%% %% handle(40057, Status, [PlayerId, Type, Ret])  ->
%% %% %% 	io:format("~s handle_40057 1[~p] \n ",[misc:time_format(now()), [PlayerId, Type, Ret]]),
%% %% 	
%% %% %% 	TimesOk = tool:is_operate_ok(pp_40057, 10),
%% %% 	if 
%% %% %% 		TimesOk =/= true ->
%% %% %% 			{ok, BinData} = pt_40:write(40057, [9, 0, 0]),
%% %% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData), %% 动作冷却中
%% %% %% 			
%% %% %% 			ok;
%% %% 		Status#player.ftst band 1024 =:= 0 -> 
%% %% 			{ok, BinData} = pt_40:write(40057, [4, 0, 0]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData), %% 未开启联盟功能
%% %% 			
%% %% 			ok;
%% %% 		Status#player.unid =:= 0 -> 
%% %% 			{ok, BinData} = pt_40:write(40057, [5, 0, 0]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData), %% 没有加入联盟
%% %% 			
%% %% 			ok;
%% %% 		true ->
%% %% 			[Res, Exp, Num] = mod_guild:interactive_sit_member(Status, PlayerId, Type, Ret),
%% %% %% 			io:format("~s handle_40057 [~p] \n ",[misc:time_format(now()), [Res, Exp, Num]]),
%% %% 			{ok, BinData} = pt_40:write(40057, [Res, Exp, Num]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData), 
%% %% 			if
%% %% 				Res =:= 1 ->
%% %% 					NewStatus = lib_player:add_exp(Status, Exp, 0, 0),
%% %% 					ActPetList = lib_formation:getActPet(),
%% %% 					Fun = fun(PetId) ->
%% %% 								  lib_pet2:add_pet_exp(NewStatus, PetId, Exp)
%% %% 						  end,
%% %% 					lists:foreach(Fun, ActPetList),
%% %% 					lib_player:send_player_attribute(NewStatus, 2),	
%% %% 					
%% %% 					if 
%% %% 						Type =/= 3 ->
%% %% 							{ok, ScnBin} = pt_40:write(40059, [Type, Status#player.id]),
%% %% 							mod_scene_agent:send_to_base_scene(Status#player.scn, ScnBin);
%% %% 						true ->
%% %% 							skip
%% %% 					end,
%% %% 			
%% %% 					{ok, NewStatus};
%% %% 				true ->
%% %% 					ok
%% %% 			end					
%% %% 	end;
%% %% 
%% %% 
%% %% %% 围观战旗
%% %% handle(40060, Status, [GuildName, Type])  ->	
%% %% 	if 
%% %% 		Status#player.ftst band 1024 =:= 0 -> 
%% %% 			{ok, BinData} = pt_40:write(40060, [5, 0]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData), %% 未开启联盟功能
%% %% 			
%% %% 			ok;
%% %% 		true ->
%% %% 			[Ret, Exp] = mod_guild:congested_guild_sit(Status, GuildName, Type),
%% %% 			{ok, BinData} = pt_40:write(40060, [Ret, Exp]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData), %% 未开启联盟功能
%% %% 			if
%% %% 				Ret =:= 1 ->
%% %% 					NewStatus = lib_player:add_exp(Status, Exp, 0, 0),
%% %% 					ActPetList = lib_formation:getActPet(),
%% %% 					Fun = fun(PetId) ->
%% %% 								  lib_pet2:add_pet_exp(NewStatus, PetId, Exp)
%% %% 						  end,
%% %% 					lists:foreach(Fun, ActPetList),
%% %% 					lib_player:send_player_attribute(NewStatus, 2),					
%% %% 			
%% %% 					{ok, NewStatus};
%% %% 				true ->
%% %% 					ok
%% %% 			end					
%% %% 	end;
%% %% 
%% %% %% -----------------------------------------------------------------
%% %% %% 获取鄙视旗帜详细信息
%% %% %% -----------------------------------------------------------------
%% %% handle(40063, Status, [GuildName])  ->	
%% %% 	%io:format("~s handle_400063 [~p] \n ",[misc:time_format(now()), GuildName]),
%% %% 	if 
%% %% 		Status#player.ftst band 1024 =:= 0 -> 
%% %% 			{ok, BinData} = pt_40:write(40063, [2, 0, <<>>, 0, 0]),
%% %% 			%io:format("~s handle_40063 no[~p] \n ",[misc:time_format(now()), [GuildName, Status#player.ftst]]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData); %% 未开启联盟功能
%% %% 		true ->
%% %% 			mod_guild:get_guild_sit_info(Status, GuildName)
%% %% 	end,
%% %% 	ok;
%% 
%% %% 联盟商店兑换商品
%% handle(40031, PlayerStatus, [GoodsTid]) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_40031]), 1),		%%包以1秒时间计
%% 	if 
%% 		Is_operate_ok =:= true ->
%% 			if
%% 				PlayerStatus#player.unid =:= 0 ->
%% 					ok;
%% 				true ->
%% 					Data = mod_guild:exchange_guild_goods(PlayerStatus, GoodsTid),
%% %% 					io:format("40031, Data:~p~n", [Data]),
%% 					{ok, BinData} = pt_40:write(40031, Data),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 					ok
%% 			end;
%% 		true ->
%% 			ok
%% 	end;
%% 
%% %% 联盟商店兑换记录
%% handle(40032, PlayerStatus, _) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_40032]), 1),		%%包以1秒时间计
%% 	if 
%% 		Is_operate_ok =:= true ->
%% 			if
%% 				PlayerStatus#player.unid =:= 0 ->
%% 					ok;
%% 				true ->
%% 					Data = mod_guild:get_exchange_log(PlayerStatus#player.unid),
%% 					{ok, BinData} = pt_40:write(40032, Data),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 					ok
%% 			end;
%% 		true ->
%% 			ok
%% 	end;
%% 
%% %% 联盟称号升级
%% handle(40033, PlayerStatus, _) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_40033]), 1),		%%包以1秒时间计
%% 	if 
%% 		Is_operate_ok =:= true ->
%% 			if
%% 				PlayerStatus#player.unid =:= 0 ->
%% 					ok;
%% 				true ->
%% 					Data = mod_guild:upgrade_guild_title(PlayerStatus#player.id),
%% 					{ok, BinData} = pt_40:write(40033, Data),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 					if
%% 						Data =:= [] ->
%% 							ok;
%% 						true ->
%% 							[Res, Title, _] = Data,
%% 							if
%% 								Res =:= 1 ->
%% 									put(guild_title, Title),
%% 									PlayerStatus1 = lib_guild:update_attr_by_guild_title(PlayerStatus),
%% 									PlayerStatus2 = lib_goods:useHpPackAct(PlayerStatus1),	%%使用气血包
%% 									lib_player:send_player_attribute(PlayerStatus2, 0),				%%通知前端更新人物属性
%% 									lib_player:send_player_attribute3(PlayerStatus, PlayerStatus2),	%%发送属性变化值
%% 									{ok, PlayerStatus2};
%% 								true ->
%% 									ok
%% 							end
%% 					end
%% 			end;
%% 		true ->
%% 			ok
%% 	end;
%% 	
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%联盟神兽%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% -----------------------------------------------------------------
%% %% 40100
%% %% -----------------------------------------------------------------
%% handle(40100, Status, [])  ->
%% 	[Ret, Blv, _DpLv, _Skills] = mod_guild:get_guild_beast(Status),	
%% 	if 
%% 		Ret =:= 1 ->
%% 			{Name,Icon,_,_} = data_guild:get_beast_data(Blv) ,
%% 			{ok,DataBin} = pt_40:write(40100,[Name,Icon]) ,
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin);
%% 		true ->
%% 			ok
%% 	end,
%% 	ok ;
%% 			
%% 	
%% %% -----------------------------------------------------------------
%% %% 40101 神兽基本信息
%% %% -----------------------------------------------------------------
%% handle(40101, _Status, [])  ->
%% %% 	BeastLv = lib_guild:get_beast_level(Status#player.unid) ,
%% %% 	{Name,Icon,AddAttrList,NeedFund} = data_guild:get_beast_data(BeastLv) ,
%% %% 	{_Name1,_Icon1,NextAddAttrList,_NeedFund1} = data_guild:get_beast_data(BeastLv+1) ,
%% %% 	case mod_guild:get_guild_info(shit,[Status#player.unid]) of
%% %% 		[1,Guild] ->
%% %% 			if
%% %% 				Status#player.upst =/= 1 ->
%% %% 					CanUpgrade = 3 ;
%% %% 				Guild#?ETS_GUILD.lv =< BeastLv ->
%% %% 					CanUpgrade = 2 ;
%% %% 				Guild#?ETS_GUILD.fund < NeedFund ->
%% %% 					CanUpgrade = 1 ;
%% %% 				true ->
%% %% 					CanUpgrade = 0
%% %% 			end ;
%% %% 		_ ->
%% %% 			CanUpgrade = 0
%% %% 	end ,
%% %% 	
%% %% 	[AddExp,AddSprt]  = lib_guild:get_beast_add_ratio(AddAttrList) ,
%% %% 	[NAddExp,NAddSprt] = lib_guild:get_beast_add_ratio(NextAddAttrList) ,
%% %% 	
%% %% 	{ok,DataBin} = pt_40:write(40101,[Name,Icon,BeastLv,NeedFund,CanUpgrade,AddExp,AddSprt,NAddExp,NAddSprt]) ,
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin),
%% 	ok ;
%% 			
%% 	
%% %% -----------------------------------------------------------------
%% %% 40102 神兽进阶
%% %% -----------------------------------------------------------------
%% handle(40102, Status, [])  ->
%% %% 	[Code,NeedFund] = 
%% %% 		case Status#player.upst =/= 1 of
%% %% 			true ->
%% %% 				[5,0] ;     %% 不是盟主
%% %% 			false ->
%% %% 				lib_guild:upgrade_beast(Status#player.unid) 
%% %% 		end ,
%% %% 	
%% %% 	case Code of
%% %% 		1 ->
%% %% 			mod_guild:cost_fund(Status,[Status#player.unid,NeedFund]) ;
%% %% 		_ ->
%% %% 			skip
%% %% 	end ,
%% %% 	
%% %% 	{ok,DataBin} = pt_40:write(40102,[Code]) ,
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin),
%% 	ok ;
%% 
%% 	
%% %% -----------------------------------------------------------------
%% %% 40103 神兽喂食次数
%% %% -----------------------------------------------------------------
%% handle(40103, Status, [])  ->
%% %% 	DataList = lib_guild:get_feed_times(Status#player.unid,Status#player.id) ,
%% %% 	{ok,DataBin} = pt_40:write(40103,DataList) ,
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin),
%% 	ok ;
%% 
%% 
%% 
%% 
%% 	
%% %% -----------------------------------------------------------------
%% %% 40104 神兽喂食
%% %% -----------------------------------------------------------------
%% handle(40104, Status, [FeedType])  ->
%% 	ok;
%% %% 	[Cost,AwardPrstg,BlessTimes,NeedVip] = data_guild:get_beast_upgrade_cost(FeedType) ,
%% %% 	
%% %% 	[Code] = 
%% %% 		case Status#player.viplv < NeedVip of
%% %% 			true ->
%% %% 				[4] ;
%% %% 			false ->
%% %% 				case Cost of
%% %% 					{coin,Number} ->
%% %% 						case goods_util:is_enough_money(Status,Number,coin) of
%% %% 							true -> 
%% %% 								lib_guild:feed_beast(Status#player.unid,Status#player.id,FeedType,BlessTimes) ;
%% %% 							false ->
%% %% 								[2]	 				%%铜钱不足
%% %% 						end ;
%% %% 					{gold,Number} ->
%% %% 						case goods_util:is_enough_money(Status,Number,gold) of
%% %% 							true -> 
%% %% 								
%% %% 								lib_guild:feed_beast(Status#player.unid,Status#player.id,FeedType,BlessTimes) ;
%% %% 							false ->
%% %% 								[3]	 				%%元宝不足
%% %% 						end ;
%% %% 					_ ->
%% %% 						[0]
%% %% 				end 
%% %% 		end ,
%% %% 	case Code of
%% %% 		1 ->
%% %% 			{MType,MNum} = Cost ,
%% %% 			AddPrstStatus = lib_player:add_prstg(Status,AwardPrstg,4014) ,
%% %% 			AddMoneyStatus = lib_goods:cost_money(AddPrstStatus,MNum,MType,4014) ,
%% %% 			lib_player:send_player_attribute2(AddMoneyStatus,2) ;
%% %% 		_ ->
%% %% 			AddMoneyStatus = Status 
%% %% 	end ,
%% %% 			
%% %% 	{ok,DataBin} = pt_40:write(40104,[Code]) ,
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% %% 	{ok ,AddMoneyStatus} ;
%% 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40105 神兽BUFF效果
%% %% -----------------------------------------------------------------
%% handle(40105, Status, [])  ->
%% 	[LeftTime,AddExp,AddSprt] = lib_guild:get_beast_buff(Status#player.unid,Status#player.id) ,
%% 	
%% 	{ok,DataBin} = pt_40:write(40105,[LeftTime,AddExp,AddSprt]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40105 神兽BUFF效果
%% %% -----------------------------------------------------------------
%% handle(40106, Status, [])  ->
%% 	DataList = data_guild:get_beast_feed() ,
%% 	
%% 	{ok,DataBin} = pt_40:write(40106,DataList) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40201 查询封魔成员
%% %% -----------------------------------------------------------------
%% handle(40201, Status, [])  ->
%% 	DataList = mod_magic:query_devils(Status) ,
%% 	
%% 	{ok,DataBin} = pt_40:write(40201,DataList) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40202 加入封魔
%% %% -----------------------------------------------------------------
%% handle(40202, Status, [])  ->
%% 	[Code] = 
%% 		case Status#player.unid > 0 of
%% 			true ->
%% 				mod_magic:player_enter(Status) ;
%% 			false ->
%% 				[2] 
%% 		end ,
%% %% 	io:format("======40202===~p~n", [Code]) ,
%% 	{ok,DataBin} = pt_40:write(40202,[Code]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40204 召唤散仙
%% %% -----------------------------------------------------------------
%% handle(40204, Status, [])  ->
%% 	[Code] = mod_magic:summon_virtual(Status) ,
%% %% 	io:format("======handle(40204:~p/~p/~p~n", [Status#player.id,Status#player.nick,Code]) ,
%% 	{ok,DataBin} = pt_40:write(40204,[Code]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% 
%% %% ========================联盟渔场==========================================
%% %% -----------------------------------------------------------------
%% %% 40500 玩家进入渔场
%% %% -----------------------------------------------------------------
%% handle(40500, Status, [])  ->
%% 	[_Ret, Lv, _FGold, _NeedGold] = mod_guild:get_guild_flag_info(Status#player.id, Status#player.unid) ,
%% 	DataList = mod_fish:player_enter(Status#player.id,Status#player.nick,Status#player.lv,Status#player.unid,Lv,Status#player.un) ,
%% %% 	io:format("======handle(40500==~p~n", [DataList]) ,
%% 	{ok,DataBin} = pt_40:write(40500,DataList) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40501 查询已有钓鱼记录
%% %% -----------------------------------------------------------------
%% handle(40501, Status, [])  ->
%% 	DataList = mod_fish:query_fish_reslut(Status#player.id) ,
%% 	{ok,DataBin} = pt_40:write(40501,DataList) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40502 开始甩杆钓鱼
%% %% -----------------------------------------------------------------
%% handle(40502, Status, [])  ->
%% 	[Code,CostCoin,CurBait,OnTime,OffTime] = 
%% 		case gen_server:call(Status#player.other#player_other.pid_goods, {'cell_num'}) =< 0 of
%% 			true ->
%% 				[5,0,0,0,0] ;
%% 			false ->
%% 				mod_fish:begin_fish(Status) 
%% 		end ,
%% 	case Code of
%% 		1 ->
%% 			NewStatus = lib_goods:cost_money(Status, CostCoin, coin, 4052) ,
%% 			lib_player:send_player_attribute2(NewStatus, 2) ;
%% 		_ ->
%% 			NewStatus = Status 
%% 	end ,
%% 	%% 	io:format("====&& &7=40502:~p~n",[CostCoin]) ,
%% 	{ok,DataBin} = pt_40:write(40502,[Code,CostCoin,CurBait,OnTime,OffTime]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	{ok,NewStatus} ;
%% 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40505 开始拉杆收鱼
%% %% -----------------------------------------------------------------
%% handle(40505, Status, [])  ->
%% 	[Code,SLv,Exp,MxExp,FTId,FType,Wight,RewardList]  = mod_fish:tie_fish(Status#player.id,Status#player.lv) ,
%% 	
%% 	case Code of
%% 		1 ->
%% 			
%% 			{AddCode, _, NewStatus, _GoodsList} = lib_goods:player_add_goods_1(Status, RewardList, 4055) ;
%% 		_ ->
%% 			AddCode = 0 ,
%% 			NewStatus = Status
%% 	end ,
%% 	spawn(fun() -> db_log_agent:log_fish([Status#player.id,Status#player.lv,SLv,Code,FTId,0,util:term_to_string(RewardList)]) end) ,
%% 	
%% 	case AddCode of
%% 		4 ->
%% 			NewCode = 6 ;
%% 		_ ->
%% 			NewCode = Code
%% 	end ,
%% 	
%% 	{ok,DataBin} = pt_40:write(40505,[NewCode,SLv,Exp,MxExp,FTId,FType,Wight,RewardList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	{ok,NewStatus} ;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40506 查询排行榜
%% %% -----------------------------------------------------------------
%% handle(40506, Status, [Type])  ->
%% 	[MyScore,DataList] = mod_fish:query_rank(Status#player.id,Type) ,
%% 	{ok,DataBin} = pt_40:write(40506,[MyScore,DataList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40507 玩家离开钓鱼
%% %% -----------------------------------------------------------------
%% handle(40507, Status, [])  ->
%% 	mod_fish:leave_fish(Status#player.id) ,
%% 	ok ;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40601 查询旗帜战利品
%% %% -----------------------------------------------------------------
%% handle(40601, Status, [])  ->
%% 	[Num,DataList] = mod_guild:query_grabed_flag(Status#player.unid) ,
%% 	{ok,DataBin} = pt_40:write(40601,[Num,DataList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%%   
%% %% -----------------------------------------------------------------
%% %% 40602 委任守护者
%% %% -----------------------------------------------------------------
%% handle(40602, Status, [UId])  ->
%% 	[Code,GNick] = mod_guild:auth_guard(Status#player.id,Status#player.unid,UId) ,
%% 	{ok,DataBin} = pt_40:write(40602,[Code,GNick]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40603 查询联盟旗帜列表
%% %% -----------------------------------------------------------------
%% handle(40603, Status, [Page])  ->
%% 	[Total,DataList] = mod_guild:query_flag_rank(Page) ,
%% 	{ok,DataBin} = pt_40:write(40603,[Total,DataList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40604 查询可使用道具
%% %% -----------------------------------------------------------------
%% handle(40604, Status, [])  ->
%% 	DataList = mod_guild:query_skills(Status#player.unid,Status#player.id) ,
%% 	{ok,DataBin} = pt_40:write(40604,DataList) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40605 使用道具
%% %% -----------------------------------------------------------------
%% handle(40605, Status, [SkillId])  ->
%% %% 	io:format("======40605====Format:~p~n",[SkillId]) ,
%% 	[Code,DataList] = 
%% 		case goods_util:is_enough_money(Status, 50, gold) of
%% 			true ->
%% 				mod_guild:pick_skill(Status#player.unid,Status#player.id,SkillId) ;
%% 			false ->
%% 				[5,[]]
%% 		end ,
%% 	case Code of
%% 		1 ->
%% 			NewStatus = lib_goods:cost_money(Status, 50, gold, 4605) ,
%% 			lib_player:send_player_attribute2(NewStatus, 3) ;
%% 		_ ->
%% 			NewStatus = Status 
%% 	end ,
%% 	{ok,DataBin} = pt_40:write(40605,[Code,DataList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	{ok,NewStatus} ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40606 抢旗
%% %% -----------------------------------------------------------------
%% handle(40606, Status, [RGuildId])  ->
%% 	{LBattleData, LFrmt} =  lib_battle:getPlayerBattleData(Status) ,
%% 	LBattleRecord = lib_battle:iniBattleRecord(LBattleData, LFrmt, 0) ,
%% 	[Code,FlagList,RewardList,WarBin] = mod_guild:loot_flag(Status#player.id,Status#player.unid,LBattleRecord,RGuildId) ,
%% 	case length(RewardList) > 0 of
%% 		true ->
%% 			{_,_,NewStatus} = lib_goods:player_add_goods_2(Status,RewardList,4606) ;
%% 		false ->
%% 			NewStatus = Status 
%% 	end ,
%% 	{ok,DataBin} = pt_40:write(40606,[Code,FlagList,RewardList,WarBin]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	{ok,NewStatus} ;
%% 
%% %% -----------------------------------------------------------------
%% %% 40607 夺旗
%% %% -----------------------------------------------------------------
%% handle(40607, Status, [GuildId])  ->
%% 	{LBattleData, LFrmt} =  lib_battle:getPlayerBattleData(Status) ,
%% 	LBattleRecord = lib_battle:iniBattleRecord(LBattleData, LFrmt, 0) ,
%% 	[Code,FlagList,WarBin] = mod_guild:retake_flag(Status#player.id,Status#player.unid,LBattleRecord,GuildId) ,
%% 	{ok,DataBin} = pt_40:write(40607,[Code,FlagList,WarBin]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% 
%% %% 40608 查询自己旗帜状态
%% %% -----------------------------------------------------------------
%% handle(40608, Status, [])  ->
%% 	[Sts,GId,GNm,GUId,GNick,Flag,LeftTime,BkNick] = mod_guild:query_flag_state(Status#player.unid) ,
%% 	
%% 	{ok,DataBin} = pt_40:write(40608,[Sts,GId,GNm,GUId,GNick,Flag,LeftTime,BkNick]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% %% 40609 开旗帜位置
%% %% -----------------------------------------------------------------
%% handle(40609, Status, [Start,End])  ->
%% 	io:format("======40609====Format:~p~n",[[Start,End]]) ,
%% 	[Code] = 
%% 		if
%% 			End < Start orelse Start < 5 ->
%% 				[0] ;
%% 			true ->
%% 				MaxCost = (End - 5) * 100 ,
%% 				Cost = get_cost(MaxCost, End, Start) ,
%% 				case goods_util:is_enough_money(Status, Cost, gold) of
%% 					true ->
%% 						mod_guild:add_flag_volumn(Status#player.unid,End) ;
%% 					false ->
%% 						[4]
%% 				end
%% 		end ,
%% 	io:format("======40609====Format:~p~n",[Code]) ,
%% 	case Code of
%% 		1 ->
%% 			NewStatus = lib_goods:cost_money(Status, 50, gold, 4609) ,
%% 			lib_player:send_player_attribute2(NewStatus, 3) ;
%% 		_ ->
%% 			NewStatus = Status 
%% 	end ,
%% 	{ok,DataBin} = pt_40:write(40609,[Code]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	{ok,NewStatus} ;
%% 
%% 
%% %% 40609 开旗帜位置
%% %% -----------------------------------------------------------------
%% handle(40610, Status, [Type])  ->
%% 	[MyScore,DataList] = mod_guild:query_rank(Status#player.unid,Type) ,
%% 	{ok,DataBin} = pt_40:write(40610,[MyScore,DataList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	ok ;
%% 
%% 
%% %% 40611 赎回自己的旗帜
%% %% -----------------------------------------------------------------
%% handle(40611, Status, [])  ->
%% 	[Code] = 
%% 		case goods_util:is_enough_money(Status, 200, gold) of
%% 			true ->
%% 				mod_guild:redeem_flag(Status#player.unid) ;
%% 			false ->
%% 				[2]
%% 		end ,
%% 	case Code of
%% 		1 ->
%% 			NewStatus = lib_goods:cost_money(Status, 200, gold, 4611) ,
%% 			lib_player:send_player_attribute2(NewStatus, 3) ;
%% 		_ ->
%% 			NewStatus = Status 
%% 	end ,	
%% 	{ok,DataBin} = pt_40:write(40611,[Code]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
%% 	{ok,NewStatus} ;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 错误处理
%% %% -----------------------------------------------------------------
%% handle(_Cmd, _Status, _Data) ->
%%     ?DEBUG("pp_guild no match", []),
%%     {error, "pp_guild no match"}.
%% 
%% 
%% get_cost(NeedCost,End,Start) ->
%% 	if
%% 		End =< Start ->
%% 			NeedCost ;
%% 		true ->
%% 			NewNeed = NeedCost + (End-5) * 100 ,
%% 			NewEnd = End - 1 ,
%% 			get_cost(NewNeed,NewEnd,Start) 
%% 	end .
%% 		
%% 
%% %% -----------------------------------------------------------------
%% %% 玩家进程数据
%% %% -----------------------------------------------------------------
%% set_guild_member_devo(List) ->
%% 	put(guild_member_devo, List).
%% 
%% update_guild_member_devo(PlayerId, AddDevo) ->
%% 	List = get(guild_member_devo),
%% 	if 
%% 		List =:= undefined ->
%% 			[];
%% 		true ->			
%% 			List1 = lists:map(fun(Data) ->
%% 				[Id, Name, All, Today | T] = Data,
%% 				if 
%% 					Id =:= PlayerId ->
%% 						[Id, Name, All + AddDevo, Today + AddDevo | T];
%% 					true ->
%% 						[Id, Name, All, Today | T]
%% 				end
%% 			end, List),
%% 			
%% 			put(guild_member_devo, List1),
%% 			
%% 			List2 = rank_guild_member_devo(List1),
%% 			
%% 			List2
%% %% 			L3 = [[Id1 | T1] || [Id1 | T1] <- List2, Id1 =:= PlayerId],
%% %% 			L3			
%% 	end.
%% 
%% 
%% rank_guild_member_devo(List) ->
%% 	List1 = lists:sort(fun sort_all_devo/2,List) ,
%% 	Fun = fun(D, {Index, Temp}) ->
%% 		[Id, Name, All, Today | _T ] = D,
%% 		NewTemp = [ [Id, Name, All, Today, Index, 0] | Temp],
%% 		{Index - 1, NewTemp}
%% 	end,
%% 	
%% 	Len = length(List1),
%% 	{_In, List11} = lists:foldr(Fun, {Len,[]}, List1),
%% 	
%% 	List2 = lists:sort(fun sort_today_devo/2, List11) ,
%% 	
%% 	
%% 	Fun2 = fun(D2, {Index2, Temp2}) ->
%% 		[Id2, Name2, All2, Today2, R2 | _T ] = D2,
%% 		NewTemp2 = [ [Id2, Name2, All2, Today2, R2, Index2] | Temp2],
%% 		{Index2 - 1, NewTemp2}
%% 	end,
%% 	
%% 	Len2 = length(List2),
%% 	{_In, List22} = lists:foldr(Fun2, {Len2,[]}, List2),
%% 	
%% 	List22.
%% 
%% sort_all_devo(Data1, Data2) ->
%% 	[_Id1, _Name1, All1 | _T1] = Data1,
%% 	[_Id2, _Name3, All2 | _T2] = Data2,
%% 	case All1 =< All2 of
%% 		true  -> false;
%% 		false -> true
%% 	end.
%% 
%% 
%% sort_today_devo(Data1, Data2) ->
%% 	[_Id1, _Name1, _All1, Today1 | _T1] = Data1,
%% 	[_Id2, _Name3, _All2, Today2 | _T2] = Data2,
%% 	case Today1 =< Today2 of
%% 		true  -> false;
%% 		false -> true
%% 	end.
%% 
%% 	
%% 
%% 
%% 
%% 
