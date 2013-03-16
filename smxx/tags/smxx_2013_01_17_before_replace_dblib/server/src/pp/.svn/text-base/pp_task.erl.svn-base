%%%------------------------------------
%%% @Module     : pp_task
%%% @Author     : csj
%%% @Created    : 2010.10.06
%%% @Description: 任务模块
%%%------------------------------------
-module(pp_task).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").

%% 临时处理


%% %% 获取任务列表
%% handle(30000, PlayerStatus, []) ->
%% 	%%io:format("~s 30000300003000030000____________[~p]\n",[misc:time_format(now()), test]),
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'task_list',PlayerStatus});
%% %% 	lib_task:init_item_task(PlayerStatus);
%% 	
%% %%已接任务列表
%% handle(30001,PlayerStatus,[])->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'trigger_task',PlayerStatus});
%% 
%% %% 接受任务
%% handle(30003, PlayerStatus, [TaskId]) ->
%% 	%%io:format("begining 30003....~n"),
%% 	case tool:is_operate_ok(pp_30003, 1) of
%% 		true ->
%% 			%%io:format("is trigger true....~n"),
%% 			case lib_task:trigger(TaskId, PlayerStatus,0) of
%% 				{true, NewPlayerStatus} ->						
%% 					
%% 					%%io:format("lib_task:trigger true....~n"),
%% 					{ok, BinData1} = pt_30:write(30003, [100]),
%% 				 	lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1),
%% 					%%io:format("before preact_finish ~n"),
%% 				   	lib_task:preact_finish(TaskId, NewPlayerStatus),
%% 					%%io:format("after preact_finish ~n"),
%% 							
%% 					%%lib_scene:refresh_npc_ico(NewPlayerStatus),
%% 					%%io:format("after refresh_npc_ico ~n"),
%% 					
%% 					%% 接受任务开放副本点
%% 					lib_dungeon:trigger_task(NewPlayerStatus, TaskId),
%% 							
%% 					%% 杀怪测试
%% 					%%test_kill_mon(PlayerStatus, TaskId),
%% 					updata_item_task(PlayerStatus, TaskId),							
%% 							
%% %% 					next_task_cue(TaskId, NewPlayerStatus,1),    %% 显示npc的默认对�?
%% 					if PlayerStatus =:=NewPlayerStatus ->ok;
%% 					   true->
%% 					   lib_player:send_player_attribute(NewPlayerStatus, 1)
%% 					end,
%% 					
%% 					%% 场景开启
%% 					case data_player:open_scene(TaskId) of
%% 						0 ->
%% 							NewPlayerStatus1 = NewPlayerStatus;
%% 						Scene -> %% 开启新的场景点							
%% 							NewPlayerStatus1 = NewPlayerStatus#player{scst = Scene bor NewPlayerStatus#player.scst},
%% 							{ok, BinData2} = pt_13:write(13030, [NewPlayerStatus1#player.scst, NewPlayerStatus1#player.scus]),
%% 							lib_send:send_to_sid(NewPlayerStatus1#player.other#player_other.pid_send, BinData2),
%% 							spawn(fun()->db_agent:change_scene_state(NewPlayerStatus1#player.scst, NewPlayerStatus1#player.scus, NewPlayerStatus1#player.id) end)
%% 							%% 开启猎兽NPC
%% %% 							case Scene of
%% %% %% 								8 -> lib_hunt:open_hunt(NewPlayerStatus1, 4);
%% %% %% 								16 -> lib_hunt:open_hunt(NewPlayerStatus1#player.id, 8);
%% %% %% 								32 -> lib_hunt:open_hunt(NewPlayerStatus1#player.id, 16);
%% %% 								_ -> skip
%% %% 							end
%% 					end,
%% 					
%% 					
%% 					NewPlayerStatus2 = lib_task:open_function(NewPlayerStatus1, [{TaskId, 0}]),					
%% 					NewPlayerStatus3 = lib_task:other_function(NewPlayerStatus2, [{TaskId, 0}]),
%% 					
%% 					if 
%% 						NewPlayerStatus3#player.stsw band 4 =/= 0 -> %% 开启猎兽功能
%% 							skip;
%% 							%lib_hunt:open_hunt(NewPlayerStatus3, 0);
%% 						true -> skip
%% 					end,	
%% 					
%% 					TD = lib_task:get_data(TaskId),
%% 					gen_server:cast(NewPlayerStatus3#player.other#player_other.pid_task,{'task_event',NewPlayerStatus3,talk, {TaskId, TD#task.start_npc}}),
%% 					
%% 					{ok, NewPlayerStatus3};
%% 				{false, Reason} ->
%% 					%%io:format("lib_task:trigger false....~n"),
%% 					{ok, BinData1} = pt_30:write(30003, [Reason]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% 					ok;
%% 				_ ->
%% 					%%io:format("lib_task:trigger exit....~n"),
%% 					{ok, BinData2} = pt_30:write(30003, [113]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData2),
%% 					ok
%% 			end;
%% 		false->skip
%% 	end;
%% 
%% %% 完成任务
%% handle(30004, PlayerStatus, [TaskId, SelectItemList])->	
%% 	%%io:format("begining 30004....~n"),
%% 	case tool:is_operate_ok(pp_30004, 1) of
%% 		true ->
%% 		    case lib_task:finish(TaskId, SelectItemList, PlayerStatus) of
%% 				{true, NewPlayerStatus} ->
%% 					lib_task:delete_item_goods(TaskId),
%% 					
%% 					NewPlayerStatus1 = lib_task:open_function(NewPlayerStatus,[{TaskId, 2}]),
%% 					
%% 					NewPlayerStatus2 = lib_task:other_function(NewPlayerStatus1, [{TaskId, 2}]),
%% 										
%% 					{ok, BinData} = pt_30:write(30004, [100]),
%% 					lib_send:send_to_sid(NewPlayerStatus2#player.other#player_other.pid_send, BinData),
%% 					%%lib_scene:refresh_npc_ico(NewPlayerStatus2),           %% 刷新npc图标
%% %% 					next_task_cue(TaskId, NewPlayerStatus2,0),    %% 显示npc的默认对�?
%% 					
%% 					spawn(fun()->lib_player:send_player_attribute(NewPlayerStatus2,3)end),						
%% %% 					TGAward = lib_task:check_task_guild_award(TaskId, PlayerStatus#player.id),		%%根据任务ID检查是否有联盟任务奖励
%% %% 					if TGAward =:= [] ->									%%没有
%% %% 						   ok;
%% %% 					   true ->
%% %% 						   {ok, BinData1} = pt_30:write(30081, [1,TGAward]),%%有则通知前端
%% %% 						   lib_send:send_to_sid(NewPlayerStatus2#player.other#player_other.pid_send, BinData1)
%% %% 					end,
%% 					lib_target:for_task_target(TaskId),		%%触发任务类型的长生目标
%% 					
%% 					if
%% 						TaskId =:= 502020001 ->
%% 							lib_help:chang_help_data(NewPlayerStatus2, next_day);
%% 						true -> ok
%% 					end,
%% 
%% 					if 
%% 						TaskId =:= 501020110 ->
%% 							{ok, BinData0} = pt_41:write(41050, [5]),
%% 							lib_send:send_to_sid(NewPlayerStatus2#player.other#player_other.pid_send, BinData0);
%% 						true ->
%% 							ok
%% 					end,
%% 					if
%% 						TaskId =:= 501010070 ->		%%这个任务有送月光宝盒，送了进行提示
%% 							pp_goods:handle(15080, NewPlayerStatus2, []);
%% 						true ->
%% 							skip
%% 					end,
%% 					
%% 					if
%% 						TaskId =:= 501010010  ->	%%在第一个任务后送符合奖励规则的测试玩家奖励
%% 							lib_reward:reward_for_test_player(NewPlayerStatus2#player.id, NewPlayerStatus2#player.acnm);
%% 						true ->
%% 							skip
%% 					end,
%% 					
%%                     {ok, NewPlayerStatus2};
%% 				
%% 				{false, Reason} ->
%% 					{ok, BinData} = pt_30:write(30004, [Reason]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 				_ ->
%% 					{ok, BinData2} = pt_30:write(30004, [113]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData2)
%% 			end;
%% 		false->skip
%% 	end;
%% 
%% %% 放弃任务
%% handle(30005, PlayerStatus, [TaskId])->	
%% 	{BinData1,NewPS} = case lib_task:abnegate(TaskId, PlayerStatus) of
%%         {true,PS} -> 
%% %% 			lib_task:cancel_task_guild(TaskId, PlayerStatus#player.id),		%%若是联盟任务, 取消它(里面会判断是不是联盟任务)
%% 			lib_task:refresh_active(PlayerStatus),	%%刷新可接任务列表(取消联盟任务后再刷新)
%% 			lib_task:delete_item_goods(TaskId),
%% 			%% 放弃任务关闭副本点 
%% 			lib_dungeon:abnegate_task(PlayerStatus, TaskId),
%%             %%lib_scene:refresh_npc_ico(PlayerStatus),
%%             {ok, BinData} = pt_30:write(30005, [1]),
%%             {BinData,PS};
%%         {false,PS} -> 
%%             {ok, BinData} = pt_30:write(30005, [0]),
%%             {BinData,PS}
%%     end,
%% 	
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% 	if PlayerStatus =/= NewPS->
%% 		{ok,NewPS};
%% 	   true->skip
%% 	end;
%% 
%% 
%% %%任务可完成状态进行功能开启
%% handle(30011,PlayerStatus,[TaskList])->	
%% 	
%% 	NewPlayerStatus = lib_task:open_function(PlayerStatus, TaskList),
%% 	
%% 	NewPlayerStatus1 = lib_task:other_function(NewPlayerStatus, TaskList),	
%% 	
%% 	
%% %% 	Fun = fun({TaskId1, _TaskState1}) ->
%% %% 				  lib_theurgy:taskOpenThr(PlayerStatus, TaskId1)  %%开启神通
%% %% 		  end,
%% %% 	lists:foreach(Fun, TaskList),
%% 
%% 	IsTask = [ TaskId || {TaskId, _TaskState}<-TaskList, TaskId =:= 501010090],
%% 	
%% 	IsTask1 = [ TaskId1 || {TaskId1, _TaskState}<-TaskList, TaskId1 =:= 501010210],
%% 	
%% 	if 
%% 		IsTask =:= [] ->
%% 			skip;
%% 		true ->
%% 			%% 判断是否已经赠送过
%% 			case lib_pet2:get_pet_by_type(NewPlayerStatus1#player.id, 613101002) of
%% 				[] -> 
%% 					%% 赠送霹雳虎
%% 					Data = lib_pet2:create_pet(NewPlayerStatus1, [613101002, 1, 1]),
%% 					[Ret ,PetId | _T] = Data,
%% 					case Ret of
%% 						1 ->
%% 							Pet = lib_pet2:get_own_pet(PlayerStatus#player.id, PetId),
%% 							Pet1 = Pet#pet2{lv = 5},
%% 							NewPet = lib_pet2:upgate_pet_attribute(Pet1, 1, 1),
%% 							lib_pet2:update_own_pet(NewPet),
%% 							{ok, BinData} = pt_41:write(41050, [2]),
%% 							lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 						_ ->
%% 							skip
%% 					end;
%% 				_List ->
%% 					skip					
%% 			end
%% 	end,
%% 	if 
%% 		IsTask1 =:= [] ->
%% 			skip;
%% 		true ->
%% 			%% 判断是否已经赠送过
%% 			case lib_pet2:get_pet_by_type(NewPlayerStatus1#player.id, 613101001) of
%% 				[] -> 
%% 					%% 赠送霹雳虎
%% 					Data1 = lib_pet2:create_pet(NewPlayerStatus1, [613101001, 1, 1]),
%% 					[Ret1 ,PetId1 | _T1] = Data1,
%% 					case Ret1 of
%% 						1 ->
%% 							Pet2 = lib_pet2:get_own_pet(PlayerStatus#player.id, PetId1),
%% 							Pet3 = Pet2#pet2{lv = 12},
%% 							NewPet1 = lib_pet2:upgate_pet_attribute(Pet3, 1, 1),
%% 							lib_pet2:update_own_pet(NewPet1),
%% 							
%% 							{ok, BinData0} = pt_41:write(41050, [3]),
%% 							lib_send:send_to_sid(NewPlayerStatus1#player.other#player_other.pid_send, BinData0);
%% 						_ ->
%% 							skip
%% 					end;
%% 				_ ->
%% 					skip					
%% 			end
%% 	end,
%% 	
%% 	case PlayerStatus /= NewPlayerStatus1 of
%% 		true->
%% 			{ok,NewPlayerStatus1};
%% 		false ->
%% 			skip
%% 	end;
%% 	
%% 				
%% %%检查是否有在线奖励
%% handle(30070,PlayerStatus,[])->
%% 	{_,NewPlayerStatus,Data} = lib_online_gift:check_online_gift(PlayerStatus),
%% 	%%io:format("~s handle 30070[~p]\n",[misc:time_format(now()), Data]),
%% 	{ok, BinData} = pt_30:write(30070, Data),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	case PlayerStatus /= NewPlayerStatus of
%% 		true->
%% 			{ok,NewPlayerStatus};
%% 		false ->
%% 			skip
%% 	end;
%% 
%% %%获取在线物品奖励
%% handle(30071,_PlayerStatus,[])->
%% 	ok;
%% %% 	{_,NewPlayerStatus,Data} = lib_online_gift:get_online_gift(PlayerStatus),
%% %% 	{ok,BinData} = pt_30:write(30071,Data),
%% %% 	lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	[Ret, _Num, Gold] = Data,
%% %% 	if 
%% %% 		Ret =:= 1 ->
%% %% 			NewStatus = lib_goods:add_money_vip(NewPlayerStatus,Gold,3071),
%% %% 			lib_player:send_player_attribute(NewStatus, 3);
%% %% 		true ->
%% %% 			NewStatus = NewPlayerStatus
%% %% 	end,
%% %% 	
%% %% 	case PlayerStatus /= NewStatus of
%% %% 		true->
%% %% 			{ok,NewStatus};
%% %% 		false ->
%% %% 			skip
%% %% 	end;
%% 
%% %%获取日常任务信息
%% handle(30100,PlayerStatus,[])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'get_daily_task', PlayerStatus})) of
%% 				{ok, _Res} ->
%% 					ok;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%免费刷新或花元宝刷新
%% handle(30101,PlayerStatus,[])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'refresh_daily_task', PlayerStatus})) of
%% 				{ok, NewStatus} ->
%% 					if				
%% 						NewStatus =/= PlayerStatus ->
%% 							lib_player:send_player_attribute2(NewStatus, 0),				%%通知前端更新人物属性
%% 							{ok, NewStatus};
%% 						true ->
%% 							ok
%% 					end;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%立即完成日常任务
%% handle(30102,PlayerStatus,[])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'finish_daily_task_now', PlayerStatus})) of
%% 				{ok, NPStatus, Exp} ->
%% 					%%长生目标
%% 					lib_target:target(daily_task,1),
%% 					
%% 					if 
%% 						Exp =/= 0 ->
%% 							NewStatus = lib_player:add_exp(NPStatus, Exp, 0, 3102),
%% 							%% 给出战宠物加经验
%% 							lib_pet2:add_exp_to_fight(NewStatus, Exp);
%% 						true ->
%% 							NewStatus = NPStatus
%% 					end,
%% 					
%% 					lib_help:chang_help_data(NewStatus, daily_task),
%% 					
%% 					if
%% 						NewStatus =/= PlayerStatus ->
%% 							lib_player:send_player_attribute(NewStatus, 0),				%%通知前端更新人物属性
%% 							{ok, NewStatus};
%% 						true ->
%% 							ok
%% 					end;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%接受日常任务
%% handle(30103,PlayerStatus,[TaskId])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'trigger_daily_task', PlayerStatus, TaskId})) of
%% 				{ok, _Res} ->
%% 					ok;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%放弃日常任务
%% handle(30104,PlayerStatus,[TaskId])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'abnegate_daily_task', PlayerStatus, TaskId})) of
%% 				{ok, _Res} ->
%% 					ok;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%完成日常任务
%% handle(30105,PlayerStatus,[TaskId])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'finish_daily_task', PlayerStatus, TaskId})) of
%% 				{ok, NPStatus, Exp} ->
%% 					%%长生目标			
%% 					lib_target:target(daily_task,1),
%% 					if 
%% 						Exp =/= 0 ->
%% 							%% 给出战宠物加经验
%% 							NewStatus = lib_player:add_exp(NPStatus, Exp, 0, 3105),
%% 							lib_pet2:add_exp_to_fight(NewStatus, Exp);
%% 						true ->
%% 							NewStatus = NPStatus
%% 					end,
%% 					
%% 					lib_help:chang_help_data(NewStatus, daily_task),
%% 					
%% 					if
%% 						NewStatus =/= PlayerStatus ->
%% 							lib_player:send_player_attribute(NewStatus, 0),				%%通知前端更新人物属性
%% 							{ok, NewStatus};
%% 						true ->
%% 							ok
%% 					end;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%重置日常任务
%% handle(30106,PlayerStatus,[])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'reset_daily_task', PlayerStatus})) of
%% 				{ok, NewStatus} ->
%% 					if
%% 						NewStatus =/= PlayerStatus ->
%% 							lib_player:send_player_attribute2(NewStatus, 0),				%%通知前端更新人物属性
%% 							{ok, NewStatus};
%% 						true ->
%% 							ok
%% 					end;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 		
%% %%满星刷新日常任务
%% handle(30107,PlayerStatus,[])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'prefect_daily_task', PlayerStatus})) of
%% 				{ok, NewStatus} ->
%% 					if
%% 						NewStatus =/= PlayerStatus ->
%% 							lib_player:send_player_attribute2(NewStatus, 0),				%%通知前端更新人物属性
%% 							{ok, NewStatus};
%% 						true ->
%% 							ok
%% 					end;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%领取周奖励
%% handle(30110,PlayerStatus,[WeekId])->
%% 	if 
%% 		PlayerStatus#player.ftst band 131072 =:= 0 ->
%% 			ok;
%% 		true ->
%% 			case catch(gen_server:call(PlayerStatus#player.other#player_other.pid_task, {'receive_daily_week', PlayerStatus, WeekId})) of
%% 				{ok, NPStatus, Exp} ->
%% 					if 
%% 						Exp =/= 0 ->
%% 							%% 给出战宠物加经验
%% 							NewStatus = lib_player:add_exp(NPStatus, Exp, 0, 3110),
%% 							lib_pet2:add_exp_to_fight(NewStatus, Exp);
%% 						true ->
%% 							NewStatus = NPStatus
%% 					end,
%% 					
%% 					if
%% 						NewStatus =/= PlayerStatus ->
%% 							lib_player:send_player_attribute(NewStatus, 0),				%%通知前端更新人物属性
%% 							{ok, NewStatus};
%% 						true ->
%% 							ok
%% 					end;
%% 				{error, Res} ->
%% 					{error, Res};
%% 				_Other ->
%% 					{error, _Other}
%% 			end
%% 	end;
%% 
%% %%刷新联盟任务奖励
%% handle(30081, _PlayerStatus, []) ->
%% 	ok;
%% %% 	Data = lib_task:refresh_task_guild_award(PlayerStatus),
%% %% %% 	io:format("handle(30081, Data:~p~n", [Data]),
%% %% 	case Data of
%% %% 		{false, Res} ->
%% %% 			PlayerStatus2  = PlayerStatus,
%% %% 			{ok, BinData1} = pt_30:write(30081, [Res,[]]);
%% %% 	   _ ->
%% %% 		   {Cost, TaskData} = Data,
%% %% 		   if Cost > 0 ->
%% %% 				  PlayerStatus2 = lib_goods:cost_money(PlayerStatus, Cost, gold, 3081),	%%有扣元宝
%% %% 				  lib_player:send_player_attribute(PlayerStatus2, 0);				%%通知前端更新人物属性
%% %% 			  true ->
%% %% 				  PlayerStatus2 = PlayerStatus
%% %% 		   end,
%% %% 		   {ok, BinData1} = pt_30:write(30081, [1,TaskData])
%% %% 	end,
%% %% 	lib_send:send_to_sid(PlayerStatus2#player.other#player_other.pid_send, BinData1),
%% %% 	{ok,PlayerStatus2};
%% 
%% 
%% %%领取联盟任务奖励
%% handle(30082, _PlayerStatus, []) ->
%% %% 	TGAward = lib_task:get_task_guild_award(PlayerStatus#player.id),		%%领取联盟任务奖励
%% %% 	if TGAward =:= [] ->
%% %% 		   PlayerStatus1 = PlayerStatus;
%% %% 	   true ->
%% %% 		   lib_task:refresh_active(PlayerStatus),	%%刷新可接任务列表
%% %% 		   [Coin,PlayerDevo,GuildFund,GuildDevo,Jade] = TGAward,
%% %% 		   PlayerStatus1 = lib_goods:add_money(PlayerStatus, Coin, coin, 3082),		%%加铜钱
%% %% 		   lib_player:send_player_attribute2(PlayerStatus1, 0),						%%通知前端金钱变化
%% %% 		   %%通过联盟模块加相应的贡献
%% %% 		   mod_guild:guild_task_devo(PlayerStatus1#player.id, PlayerDevo, GuildDevo, GuildFund,Jade),	%%玩家ID，个人贡献，联盟贡献，联盟资金, 联盟玉牌
%% %% 		   {ok, BinData} = pt_30:write(30082, [1]),
%% %% 		   lib_send:send_to_sid(PlayerStatus1#player.other#player_other.pid_send, BinData),
%% %% 		   gen_server:cast(PlayerStatus1#player.other#player_other.pid_task,{'task_list',PlayerStatus1})
%% %% 	end,
%% %% 	{ok,PlayerStatus1};
%% 	ok;
%% 
%% 	
%% 
%% %% 
%% %% %%日常任务
%% %% handle(30600,PlayerStatus,[])->
%% %% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'daily_task',PlayerStatus});
%% 
%% 
%% %% %%获取目标奖励信息
%% %% handle(30072,PlayerStatus,[])->
%% %% 	{_,NewPlayerStatus,Day,TargetBag} = lib_target_gift:check_target_gift(PlayerStatus),
%% %% 	{ok, BinData} = pt_30:write(30072, [Day,TargetBag]),
%% %%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 	case PlayerStatus /= NewPlayerStatus of
%% %% 		true->
%% %% 			{ok,NewPlayerStatus};
%% %% 		false ->
%% %% 			skip
%% %% 	end;
%% %% 
%% %% %%获取目标奖励
%% %% handle(30073,PlayerStatus,[Day,Times])->
%% %% 	case lib_target_gift:get_target_gift(PlayerStatus,Day,Times) of
%% %% 		{ok,NewPlayerStatus,Data}->
%% %% 			{ok, BinData} = pt_30:write(30073, Data),
%% %%     		lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 			{ok,NewPlayerStatus};
%% %% 		{error,Data}->
%% %% 			{ok, BinData} = pt_30:write(30073, Data),
%% %%     		lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)
%% %% 	end;
%% %% 	
%% %% %%选择国家
%% %% handle(30080,PlayerStatus,[Type,Realm]) ->
%% %% 	case PlayerStatus#player.realm =:= 100 of
%% %% 		true->
%% %% %% 			{PS, Data} =gen_server:call(PlayerStatus#player.other#player_other.pid_task,{'select_realm',PlayerStatus,Type,Realm}),
%% %% 			{_, PS, Data} = lib_task:select_nation(PlayerStatus,Type,Realm),
%% %% 			{ok,BinData} = pt_30:write(30080, Data),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 			lib_task:event(select_nation, Realm, PS),
%% %% 			next_task_cue(20219, PS,0),%% 显示npc的默认对话
%% %% 			lib_player:send_player_attribute(PS, 1),
%% %% 			{ok,PS};
%% %% %% 			%%自动完成任务 
%% %% %% 			case gen_server:call(PS#player.other#player_other.pid_task,{'finish',PS,20219,0}) of
%% %% %% 				{true, NewPS} ->
%% %% %% 					%%通知客户端刷新任务列表
%% %% %% 					{ok, BinData1} = pt_30:write(30006, [1,0]),
%% %% %%      		       lib_send:send_to_sid(NewPS#player.other#player_other.pid_send, BinData1),
%% %% %% 					%%传送到主城
%% %% %% 					SceneId = lib_task:get_sceneid_by_realm(NewPS#player.realm),
%% %% %% 					pp_scene:handle(12005, NewPS, SceneId);
%% %% %% 				_ ->
%% %% %% 					{ok,PS}
%% %% %% 			end;
%% %% 		false->
%% %% 			skip
%% %% 	end;
%% %% 
%% %% %%筋斗云(1:Npc、2：怪物,3场景)
%% %% handle(30090,PlayerStatus,[TaskId,Type,Id])->
%% %% 	%%使用小飞鞋
%% %% 	case lib_task:check_shoe_use(PlayerStatus,Type,TaskId) of
%% %% 		{ok,_}->
%% %% 			case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'delete_more', 28201, 1}) of
%% %% 				1->
%% %% 					%%查找目的地的场景id和坐标
%% %% 					{SceneId,_,X1,Y1} = get_secne(PlayerStatus#player.realm,Id,Type,PlayerStatus#player.scene,PlayerStatus#player.lv),
%% %% 					case SceneId of
%% %% 						0->
%% %% 							
%% %% 							ErrorCode = case Type of
%% %% 											1->3;
%% %% 											2->4;
%% %% 											_->5
%% %% 										end,
%% %% 							gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'give_goods', PlayerStatus,28201, 1,0}),
%% %% 							{ok,BinData} = pt_30:write(30090,[ErrorCode]),
%% %% 							lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 						_->
%% %% 							case lib_deliver:check_scene_enter(SceneId) of
%% %% 								false->
%% %% 									gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'give_goods', PlayerStatus,28201, 1,0}),
%% %% 									{ok,BinData} = pt_30:write(30090,[7]),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 								true->
%% %% %% 									lib_scene:set_hooking_state(PlayerStatus,SceneId),
%% %% 									NewStatus=lib_deliver:deliver(PlayerStatus,SceneId,X1,Y1,3),
%% %% 									{ok,NewStatus}
%% %% 							end
%% %% 					end;
%% %% 				_->
%% %% 					{ok,BinData} = pt_30:write(30090,[1]),
%% %% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 					{ok,PlayerStatus}
%% %% 			end;
%% %% 	   {error,Result}->
%% %% 			{ok,BinData} = pt_30:write(30090,[Result]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 			{ok,PlayerStatus}
%% %% 	end;
%% %% 
%% %% %%每日传送(Type:1:Npc、2：怪物,3场景)
%% %% handle(30091,PlayerStatus,[Type,Id,MoneyType])->
%% %% 	case lib_task:check_send(PlayerStatus,MoneyType) of
%% %% 		{ok,_}->
%% %% 			case Type < 3 of
%% %% 				true->
%% %% 					%%查找目的地的场景id和坐标
%% %% 					{SceneId,_,X1,Y1} = get_secne(PlayerStatus#player.realm,Id,Type,PlayerStatus#player.scene,PlayerStatus#player.lv),
%% %% 					case SceneId of
%% %% 						0->
%% %% 							ErrorCode = case Type of
%% %% 											1->4;
%% %% 											2->5;
%% %% 											_->6
%% %% 										end,
%% %% 							{ok,BinData} = pt_30:write(30091,[ErrorCode]),
%% %% 							lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 						_->
%% %% 							case lib_deliver:check_scene_enter(SceneId) of
%% %% 								false->
%% %% 									{ok,BinData} = pt_30:write(30091,[8]),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 								true->
%% %% 									case  MoneyType =:= 3 of
%% %% 										true->
%% %% 										   case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, 
%% %% 													{'delete_more', 28201, 1}) of
%% %% 											   1->
%% %% %% 												   lib_scene:set_hooking_state(PlayerStatus,SceneId),
%% %% 												   NewStatus=lib_deliver:deliver(PlayerStatus,SceneId,X1,Y1,MoneyType),
%% %% 												   {ok,NewStatus};
%% %% 											   _->
%% %% 												   {ok,BinData} = pt_30:write(30091,[7]),
%% %% 													lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)
%% %% 										  end;
%% %% 									   false->
%% %% %% 										   lib_scene:set_hooking_state(PlayerStatus,SceneId),
%% %% 										   NewStatus=lib_deliver:deliver(PlayerStatus,SceneId,X1,Y1,MoneyType),
%% %% 										   NewPlayerStatus = case MoneyType of
%% %% 																 1->lib_goods:cost_money(NewStatus,3,gold,3004);
%% %% 																 _->lib_goods:cost_money(NewStatus,5000,coin,3004)
%% %% 															  end,
%% %% 											lib_player:send_player_attribute(NewPlayerStatus, 1),
%% %% 											{ok,NewPlayerStatus}
%% %% 									end
%% %% 							end
%% %% 					end;
%% %% 				false->
%% %% 					case lib_deliver:check_scene_enter(Id) of
%% %% 						false->
%% %% 							{ok,BinData} = pt_30:write(30091,[8]),
%% %% 							lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 						true->
%% %% 							case gen_server:call(PlayerStatus#player.other#player_other.pid_goods,{'delete_more', 28201, 1}) of
%% %% 								1->
%% %% 									case lib_scene:get_base_scene_info(Id) of
%% %% 										[]->
%% %% 											{ok,BinData} = pt_30:write(30091,[6]),
%% %% 											lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 										SceneInfo->
%% %% %% 											lib_scene:set_hooking_state(PlayerStatus,Id),
%% %% 											NewStatus=lib_deliver:deliver(PlayerStatus,Id,SceneInfo#ets_scene.x,SceneInfo#ets_scene.y,MoneyType),
%% %% 											{ok,NewStatus}
%% %% 									end;
%% %% 								_->
%% %% 									{ok,BinData} = pt_30:write(30091,[7]),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)
%% %% 							end
%% %% 					end
%% %% 				end;
%% %% 					
%% %% 		{error,Result}->
%% %% 			{ok,BinData} = pt_30:write(30091,[Result]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)
%% %% 	end;
%% %% 
%% %% %%查询国运时间
%% %% handle(30300,PlayerStatus,[])->
%% %% 	mod_carry:check_carry_time_info(PlayerStatus);
%% %% 
%% %% %%查询指定部落国运时间
%% %% %% handle(30301,PlayerStatus,[])->
%% %% %% 	mod_carry:check_carry_time_by_realm(PlayerStatus);
%% %% 
%% %% %%查询委托任务列表
%% %% handle(30400,PlayerStatus,[])->
%% %% 	ConsignInfo = lib_consign:get_consign_times_list(PlayerStatus#player.id),
%% %% 	mod_consign:check_consign_task(PlayerStatus,ConsignInfo);
%% %% 
%% %% %%发布委托任务
%% %% handle(30401,PlayerStatus,TaskInfo)->
%% %% %% 	case gen_server:call(PlayerStatus#player.other#player_other.pid_task,{'publish_consign_task',PlayerStatus,TaskInfo}) of
%% %% 	case lib_task:publish_consign_task(PlayerStatus,TaskInfo) of
%% %% 		{error,Result}->
%% %% 			{ok,BinData} = pt_30:write(30401,[Result]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 		{ok,NewPlayerStatus}->
%% %% 			{ok,BinData} = pt_30:write(30401,[1]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 			{ok,NewPlayerStatus}
%% %% 	end;
%% %% 
%% %% 
%% %% %%接受委托任务
%% %% handle(30402,PlayerStatus,[Id,TaskId])->
%% %% %% 	case gen_server:call(PlayerStatus#player.other#player_other.pid_task,{'accept_task_consign',PlayerStatus,Id,TaskId})of
%% %% 	case lib_task:accept_task_consign(PlayerStatus,[Id,TaskId]) of	
%% %% 		{error,Result}->
%% %% 			{ok,BinData} = pt_30:write(30402,[Result]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 		{ok,NewPlayerStatus}->{ok,NewPlayerStatus}
%% %% 	end;
%% %% 
%% %% 
%% %% %%取消委托任务
%% %% handle(30403,PlayerStatus,[Id])->
%% %% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'cancel_task_consign',PlayerStatus,Id});
%% %% 
%% %% %% 	mod_consign:accept_consign_task(PlayerStatus,Id,TaskId);
%% %% 
%% %% %%答题
%% %% %% handle(30500,PlayerStatus,[TaskId,QuestionId])->
%% %% %% 	lib_task:event(question, {QuestionId}, PlayerStatus),
%% %% %% 	case gen_server:call(PlayerStatus#player.other#player_other.pid_task,{'finish',PlayerStatus,TaskId,0}) of
%% %% %% 		{true, NewPlayerStatus} ->
%% %% %% 			%%通知客户端刷新任务列表
%% %% %% 			{ok, BinData1} = pt_30:write(30006, [1,0]),
%% %% %%      		lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% %% 			{ok,NewPlayerStatus};
%% %% %% 		_ ->skip
%% %% %% 	end;
%% %% %%查询商车信息
%% %% handle(30700,PlayerStatus,[])->
%% %% 	BusinessInfo = lib_business:check_car_info(PlayerStatus),
%% %% 	{ok, BinData1} = pt_30:write(30700, BusinessInfo),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1);
%% %% 
%% %% %%刷新商车
%% %% handle(30701,PlayerStatus,[Times,Color])->
%% %% 	case lib_business:refresh_car(PlayerStatus,Times,Color) of
%% %% 		{fail,Error}->
%% %% 			{ok, BinData1} = pt_30:write(30701, [Error,0,0,0,0,0]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1);
%% %% 		{ok,NewPlayerStatus,[Res,Total,NewColor,Free,MaxFree,FreeTime]}->
%% %% 			{ok, BinData1} = pt_30:write(30701, [Res,Total,NewColor,Free,MaxFree,FreeTime]),
%% %% 			lib_player:send_player_attribute(NewPlayerStatus, 1),
%% %% 			lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 			{ok,NewPlayerStatus}
%% %% 	end;
%% %% 
%% %% %%请求刷新有缘人时间CD
%% %% handle(30800,PlayerStatus,[])->
%% %% 	{ok,Timestamp}= lib_love:check_refresh(PlayerStatus#player.id),
%% %% 	{ok, BinData} = pt_30:write(30800, [Timestamp]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%%%刷新有缘人
%% %% handle(30801,PlayerStatus,[Type])->
%% %% 	case lib_love:refresh(PlayerStatus,Type) of
%% %% 		{error,Error}->
%% %% 			{ok, BinData} = pt_30:write(30801, [Error,0,[]]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 		{ok,NewPlayer,PlayerList,Timestamp}->
%% %% 			{ok, BinData} = pt_30:write(30801, [1,Timestamp,PlayerList]),
%% %% 			lib_send:send_to_sid(NewPlayer#player.other#player_other.pid_send, BinData),
%% %% 			if PlayerStatus=/=NewPlayer ->
%% %% 				   lib_player:send_player_attribute(NewPlayer, 1),
%% %% 				   {ok,NewPlayer};
%% %% 			   true->skip
%% %% 			end
%% %% 	end;
%% %% 
%% %% %%查看玩家当前状态
%% %% handle(30802,PlayerStatus,[PlayerId])->
%% %% 	{_,Res}= lib_love:check_invite(PlayerId),
%% %% 	{ok, BinData} = pt_30:write(30802, [Res]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%邀请有缘人
%% %% handle(30803,PlayerStatus,[Type,Name])->
%% %% 	{_,Res}=lib_love:invite(PlayerStatus,Name,Type),
%% %% 	if Type=:=1 andalso Res=:=1->
%% %% 		   {ok,NewPlayerStatus} = lib_love:del_invite_gold(PlayerStatus,30),
%% %% 		   lib_love:invite_msg_gold(NewPlayerStatus,30);
%% %% 	   true->NewPlayerStatus = PlayerStatus
%% %% 	end,
%% %% 	{ok, BinData} = pt_30:write(30803, [Res]),
%% %% 	lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 	if PlayerStatus=/=NewPlayerStatus ->
%% %% 		   lib_player:send_player_attribute(NewPlayerStatus, 1),
%% %% 		   {ok,NewPlayerStatus} ;
%% %% 	   true->skip
%% %% 	end;
%% %% 	
%% %% 
%% %% %%收到邀请
%% %% handle(30804,PlayerStatus,[PlayerId,Name,Career,Sex])->
%% %% 	lib_love:accept_invite_msg(PlayerStatus),
%% %% 	{ok, BinData} = pt_30:write(30804, [PlayerId,Name,Career,Sex]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%接受、拒绝邀请
%% %% handle(30805,PlayerStatus,[Res,PlayerId])->
%% %% 	case lib_love:accept_invite(PlayerStatus,PlayerId,Res) of
%% %% 		{ok,Player}->
%% %% 			{ok, BinData} = pt_30:write(30805, [Res,PlayerStatus#player.id,
%% %% 												PlayerStatus#player.nickname,
%% %% 												PlayerStatus#player.career,
%% %% 												PlayerStatus#player.sex]),
%% %% 			case Res of
%% %% 				1->
%% %% 					pp_relationship:handle(14001, PlayerStatus, [1, Player#player.id, Player#player.nickname]);
%% %% 				_->skip
%% %% 			end,
%% %% 			lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData);
%% %% 		_->skip
%% %% 	end;
%% %% 
%% %% %%取消邀请
%% %% handle(30808,PlayerStatus,[PlayerId])->
%% %% 	case lib_love:cancel_invite(PlayerId,PlayerStatus#player.nickname) of
%% %% 		{ok,Player}->
%% %% 			{ok, BinData} = pt_30:write(30808,[PlayerStatus#player.nickname]),
%% %% 			lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData);
%% %% 		_->skip
%% %% 	end;
%% %% 
%% %% %%赠送礼物
%% %% handle(30806,PlayerStatus,[InviteId,Mult])->
%% %% 	case lib_love:present_gift(PlayerStatus,InviteId,Mult) of
%% %% 		{error,Error}->
%% %% 			{ok, BinData} = pt_30:write(30806,[Error]),
%% %% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 		{ok,NewPlayerStatus}->
%% %% 			{ok, BinData} = pt_30:write(30806,[1]),
%% %% 			lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData),
%% %% %% 			lib_player:send_player_attribute(NewPlayerStatus, 1),
%% %% 			{ok,NewPlayerStatus}
%% %% 	end;
%% %% 
%% %% %%评价以及赠送鲜花
%% %% handle(30810,PlayerStatus,[PlayerId,App,Flower])->
%% %% 	{_,Res}=lib_love:evaluate(PlayerStatus,PlayerId,App,Flower),
%% %% 	{ok, BinData} = pt_30:write(30810,[Res]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%推送评价
%% %% handle(30811,PlayerStatus,[PlayerId,Name,Career,Sex,App,Flower,_Charm])->
%% %% %% 	NewPlayerStatus = lib_love:get_evaluate(PlayerStatus,Charm),
%% %% 	{ok, BinData} = pt_30:write(30811,[PlayerId,Name,Career,Sex,App,Flower]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% %% 	{ok,NewPlayerStatus};
%% %% 
%% %% %%默契度测试
%% %% handle(30813,PlayerStatus,[Answer])->
%% %% 	NewPlayer = lib_love:answer(PlayerStatus,Answer),
%% %% 	{ok,NewPlayer};
%% %% 
%% %% %%查询登陆抽奖信息
%% %% handle(30075,PlayerStatus,[])->
%% %% 	[GoodsId,Days,Times,GoodsList]=lib_lucky_draw:get_luckydraw_info(PlayerStatus#player.id),
%% %% 	{ok, BinData} = pt_30:write(30075,[GoodsId,Days,Times,GoodsList]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%登陆抽奖
%% %% handle(30076,PlayerStatus,[])->
%% %% 	case lib_lucky_draw:lucky_draw(PlayerStatus) of
%% %% 		{error,Error}->
%% %% 			{ok, BinData} = pt_30:write(30076,[Error,0]);
%% %% 		{ok,GoodsId} ->
%% %% 			{ok, BinData} = pt_30:write(30076,[1,GoodsId])
%% %% 	end,
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%领取物品
%% %% handle(30077,PlayerStatus,[])->
%% %% 	case lib_lucky_draw:get_goods(PlayerStatus) of
%% %% 		{ok,GoodsId,LD}->
%% %% 			{ok, BinData} = pt_30:write(30077,[1,GoodsId,LD#ets_luckydraw.days,LD#ets_luckydraw.times,LD#ets_luckydraw.goodslist]);
%% %% 		{error,Error}->
%% %% 			{ok, BinData} = pt_30:write(30077,[Error,0,0,0,[0,0,0,0,0,0,0,0,0,0,0,0]])
%% %% 	end,
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%查询目标引导
%% %% handle(30078,PlayerStatus,[])->
%% %% 	TargetList =  lib_target_lead:target_lead_info(PlayerStatus#player.id),
%% %% 	{ok, BinData} = pt_30:write(30078,TargetList),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%更新目标引导
%% %% handle(30079,PlayerStatus,[Lv])->
%% %% 	lib_target_lead:update_targetlead(PlayerStatus#player.id,Lv);
%% %% 		
%% %% %% 测试接口，清除某个任务
%% %% handle(30100, PlayerStatus, [TaskId]) ->
%% %%     case lib_task:abnegate(TaskId, PlayerStatus) of
%% %%         true -> 
%% %%             lib_scene:refresh_npc_ico(PlayerStatus),
%% %% 			{ok, BinData} = pt_30:write(30006, [1,0]),
%% %% %% io:format("30006_8_ ~n"),			
%% %%     		lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %%         false -> false
%% %%     end,
%% %%     ok;
%% %% 
%% %% %% 测试接口，清除所有任务
%% %% handle(30200, PlayerStatus, []) ->
%% %%     lists:map(
%% %%         fun(RT) ->
%% %%             srv_task:del_trigger(PlayerStatus#player.id, RT#role_task.task_id),
%% %%             srv_task:del_log(PlayerStatus#player.id, RT#role_task.task_id)
%% %%         end,
%% %%         lib_task:get_trigger(PlayerStatus)
%% %%     ),
%% %% 	lib_task:delete_role_task(PlayerStatus#player.id),
%% %%     lib_task:flush_role_task(PlayerStatus),
%% %%     lib_scene:refresh_npc_ico(PlayerStatus),
%% %% 	{ok, BinData} = pt_30:write(30006, [1,0]),
%% %% %% io:format("30006_9_ ~n"),	
%% %%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %%     ok;
%% 
%% handle(_Cmd, _PlayerStatus, _Data) ->
%%     {error, bad_request}.
%% 
%% %% 完成任务后是否弹结束npc的默认对话
%% %% next_task_cue(TaskId, PlayerStatus,Type) ->
%% %% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'next_task_cue',PlayerStatus,TaskId,Type}).
%% 
%% updata_item_task(PlayerStatus, TaskId)->
%% 	TipList = lib_task:get_tip(trigger, TaskId, PlayerStatus),
%% 	lists:foreach(fun([Type, Finish, ItemId, _, Num, NowNum, Duplicate | _]) ->
%% 				    %%lib_dungeon:finish_dungeon(PlayerStatus, Duplicate, 1),
%% 					
%% 					if 
%% 						Type =:= 4 andalso Finish =:= 0 ->
%% 							lib_task:add_item_goods(TaskId, Duplicate, ItemId, Num, NowNum);
%% 							
%% 							%% 测试用
%% %% 							TaskGoods = lib_task:get_item_goods(PlayerStatus, Duplicate),
%% %% 							if
%% %% 								TaskGoods =/= [] ->
%% %% 									case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'get_multi', PlayerStatus, TaskGoods}) of
%% %% 										1 ->
%% %% 											lib_task:event(item, TaskGoods, PlayerStatus);
%% %% 										_ErrorNum ->      %%错误码（0-执行失败, 2- 物品不存在, 4-背包格子不够）
%% %% 											ok
%% %% 									end;
%% %% 								true ->
%% %% 									ok
%% %% 							end;
%% 						true ->
%% 							ok
%% 						end										
%% 					end, TipList).	
%% 	
%% 	
%% %% 自动杀怪测试
%% test_kill_mon(PlayerStatus, TaskId) ->
%% 	%%模拟打怪完成{'task_event',PlayerStatus,Event,Param}
%% 	%%io:format("test_kill_mon ~p~n", [TaskId]),
%% 	Event = kill,
%% 	TD = lib_task:get_data(TaskId),
%% 	Content = TD#task.content,
%% 	MonIdList = get_monid_list(Content),
%% 	%%io:format("after monid ~p~n", [MonIdList]),
%% 	case MonIdList of
%% 		[] -> ok;
%% 		_ ->
%% 			%%io:format("simulation of killing monster...~n"),
%% 			gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'task_event',PlayerStatus,Event,MonIdList})
%% 	end.
%% 					
%% %%testing Content=[[0,0,kill,602011001,1,0],[1,1,end_talk,302010003,3254]]
%% get_monid_list(Content) ->
%% 	case Content of
%% 		[] -> [];
%% 		_ ->
%% 			[{MonId, Num} || [_S1, _S2, Action, MonId, Num | _S3] <- Content, Action =:= kill]			
%% 	end.
