%%%------------------------------------
%%% @Module  : mod_task
%%% @Author  : csj
%%% @Created : 2010.12.06
%%% @Description: 任务处理模块
%%%------------------------------------
-module(mod_task).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").
-compile(export_all).


-record(state, {player_id = 0,nowtime=0}).
-define(TIMER_1, 600000).

start_link([PlayerId])->
    gen_server:start_link(?MODULE, [PlayerId], []).

%% 关闭服务器时回调
stop() -> ok.

init([PlayerId])->
	misc:write_monitor_pid(self(),?MODULE, {}),
	State = #state{player_id=PlayerId,nowtime = util:unixtime()},
%% 	erlang:send_after(10000, self(), refresh),
	{ok,State}.

%%获取日常任务信息
handle_call({'get_daily_task',PlayerStatus}, _From, State) ->
	case lib_task:get_daily_task(PlayerStatus) of
		[] ->
			DailyTask1 = [];
		DailyTask ->
			%%io:format("~s get_daily_task[~p] \n ",[misc:time_format(now()), DailyTask]),
			{ok, BinData} = pt_30:write(30100, [1, DailyTask]),
			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
			DailyTask1 = DailyTask
	end,
	{reply,{ok, DailyTask1}, State};

%%免费刷新或花元宝刷新
handle_call({'refresh_daily_task',PlayerStatus}, _From, State) ->
	[Ret, DailyTask, NewStatus] = lib_task:refresh_daily_task(PlayerStatus),
	
	{ok, BinData} = pt_30:write(30100, [Ret, DailyTask]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),	
	
	if 
		NewStatus =/= PlayerStatus ->
			lib_player:send_player_attribute(NewStatus,3);
		true ->
			skip
	end,
	{reply,{ok, NewStatus}, State};

%%立即完成日常任务
handle_call({'finish_daily_task_now',PlayerStatus}, _From, State) ->
	[Ret, Coin, Exp, TasdId, NewStatus] = lib_task:finish_daily_task_now(PlayerStatus),
	{ok, BinData} = pt_30:write(30102, [Ret, Coin, Exp, TasdId]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),	
	if 
		Ret =:= 1 ->
			lib_player:send_player_attribute(NewStatus,3);
		true ->
			skip
	end,
	{reply,{ok, NewStatus, Exp}, State};

%%接受日常任务
handle_call({'trigger_daily_task',PlayerStatus, TaskId}, _From, State) ->
	[Ret, TaskId1] = lib_task:trigger_daily_task(PlayerStatus, TaskId),
	%%io:format("~s trigger_daily_task [~p/~p] \n ",[misc:time_format(now()), Ret, TaskId1]),
	{ok, BinData} = pt_30:write(30103, [Ret, TaskId1]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),	
	{reply,{ok, 1}, State};

%%放弃日常任务
handle_call({'abnegate_daily_task',PlayerStatus, TaskId}, _From, State) ->
	[Ret, TaskId1] = lib_task:abnegate_daily_task(PlayerStatus, TaskId),
	{ok, BinData} = pt_30:write(30104, [Ret, TaskId1]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),	
	{reply,{ok, 1}, State};

%%完成日常任务
handle_call({'finish_daily_task',PlayerStatus, TaskId}, _From, State) ->
	[Ret, Coin, Exp, _TasdId1, NewStatus] = lib_task:finish_daily_task(PlayerStatus, TaskId),
	{ok, BinData} = pt_30:write(30105, [Ret, Coin, Exp,TaskId]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
	if 
		Ret =:= 1 ->
			lib_player:send_player_attribute(NewStatus,3);
		true ->
			skip
	end,
	{reply,{ok, NewStatus, Exp}, State};

%%重置日常任务
handle_call({'reset_daily_task',PlayerStatus}, _From, State) ->
	[Ret, NewStatus] = lib_task:reset_daily_task(PlayerStatus),
	{ok, BinData} = pt_30:write(30106, [Ret]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),	
	
	if 
		NewStatus =/= PlayerStatus ->
			lib_player:send_player_attribute(NewStatus,3);
		true ->
			skip
	end,
	
	{reply,{ok, NewStatus}, State};

%%满星刷新日常任务
handle_call({'prefect_daily_task',PlayerStatus}, _From, State) ->
	[Ret, DailyTask, NewStatus] = lib_task:prefect_daily_task(PlayerStatus),
	{ok, BinData} = pt_30:write(30100, [Ret, DailyTask]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
	
	if 
		NewStatus =/= PlayerStatus ->
			lib_player:send_player_attribute(NewStatus,3);
		true ->
			skip
	end,
	
	{reply,{ok, NewStatus}, State};

%%领取周奖励
handle_call({'receive_daily_week',PlayerStatus, Weekid}, _From, State) ->
	[Ret, NewStatus, AddExp] = lib_task:receive_daily_week(PlayerStatus, Weekid),
	{ok, BinData} = pt_30:write(30110, [Ret, Weekid]),
	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
	
	if 
		NewStatus =/= PlayerStatus ->
			lib_player:send_player_attribute(NewStatus,3);
		true ->
			skip
	end,
	
	{reply,{ok, NewStatus, AddExp}, State};

%%保存日常任务
handle_call({'save_daily_task',PlayerStatus}, _From, State) ->
	lib_task:save_daily_task(PlayerStatus),
	{reply,{ok}, State};

%%保存日常任务
handle_call({'test_daily_task',PlayerStatus}, _From, State) ->
	lib_task:test_daily_task(PlayerStatus),
	{reply,{ok}, State};

handle_call(_Null, _From, State) ->
	{reply,[], State}.

%%获取任务列表
%% handle_cast({'task_list',PlayerStatus}, State) ->
%% 	lib_task:refresh_active_next_day(PlayerStatus),	%%刷新可接任务列表
%% 	ActiveIds = lib_task:get_active(PlayerStatus),
%% %% 	io:format("activeids ~p~n", [ActiveIds]),
%%     ActiveList = lists:map(
%%         fun(Tid) ->
%% 			case lib_task:get_data(Tid) of
%% 				[]->skip;
%% 				TD->
%% 					case lib_task:is_hero_task(TD)of
%% 						true->skip;
%% 						false->
%%             				TipList = lib_task:get_tip(active, Tid, PlayerStatus),
%% 							%%io:format("activeids TipList ~p~n", [TipList]),
%% 							[Exp,_Times] = 
%% 								case lib_task:is_normal_daily_task(TD)==true of
%% 									true->
%% 										[round(TD#task.exp),0];
%% 									false->
%% 										[TD#task.exp,0]%%封神贴任务不出现在玩家可接任务列表中，此处可以不处理奖励
%% 								end,
%% 							if
%% 								TD#task.type =:= 6 ->
%% 									{Exp2, Coin2} = lib_task:get_task_cycle_reward2(TD#task.level, TD#task.exp, TD#task.coin, PlayerStatus#player.lv);
%% 								true ->
%% 									Exp2  = Exp,
%% 									Coin2 = TD#task.coin
%% 							end,
%% 							AwardList1 = lib_task:get_award_item(TD, PlayerStatus),			%%普通任务奖励
%% %% 							AwardList2 = lib_task:get_base_task_guild_award(TD#task.id),	%%联盟任务奖励
%% 							{TD#task.id, TD#task.level, TD#task.type,TD#task.child, TD#task.name,
%% 							 TD#task.desc,TD#task.start_npc,TD#task.end_npc, TD#task.gold, Coin2, Exp2,TipList,
%% 							 AwardList1, TD#task.award_select_item}
%% 					end
%% 			end
%% 		end, 
%%         ActiveIds
%%     ),
%% 	
%% 	lib_task:check_expire_cycle_task(PlayerStatus),
%%     %% 已接任务
%%     TriggerBag = lib_task:get_trigger(PlayerStatus), %% 获取已触发的任务
%% %% 	io:format("TriggerBag ~p~n", [TriggerBag]),
%%     TriggerList = lists:map(
%%         fun(RT) ->
%% 				case is_record(RT,role_task) of
%% 					true->
%% 						%%io:format("here3~n"),
%% 						case RT#role_task.state =/= 2 of
%% 							true->
%% 								%%　获取任务详细数据
%% 								case lib_task:get_data(RT#role_task.tid) of 
%% 									[]->skip;
%% 									TD->
%% 										%%io:format("here2~n"),
%%         		    					TipList = lib_task:get_tip(trigger, RT#role_task.tid, PlayerStatus),
%% 										%%io:format("here21~n"),
%% 										[Exp,_Times1] = 
%% 											%%　是否日常任务
%% 											%%io:format("here3~n"),
%% 											case lib_task:is_normal_daily_task(TD)==true of														
%% 												true->
%% 													[round(TD#task.exp),0];
%% 												false-> 
%% 													[TD#task.exp,0]													
%% 											end,
%% 										if
%% 											TD#task.type =:= 6 ->
%% 												{Exp2, Coin2} = lib_task:get_task_cycle_reward2(TD#task.level, TD#task.exp, TD#task.coin, PlayerStatus#player.lv);
%% 											true ->
%% 												Exp2  = Exp,
%% 												Coin2 = TD#task.coin
%% 										end,
%% 										if
%% 											TD#task.type =:= 5 andalso TD#task.gold > 0 ->
%% 												AwardList0 = lib_task:get_award_item(TD, PlayerStatus),			%%普通任务奖励
%% 												AwardList1 = [{210201, TD#task.gold}|AwardList0];
%% 											true ->
%% 												AwardList1 = lib_task:get_award_item(TD, PlayerStatus)			%%普通任务奖励
%% 										end,
%% %% 										AwardList2 = lib_task:get_base_task_guild_award(TD#task.id),	%%联盟任务奖励	
%% 										%%io:format("here24~n"),
%% 										{TD#task.id, TD#task.level, TD#task.type, TD#task.child,
%% 								 		TD#task.name, TD#task.desc,TD#task.start_npc,TD#task.end_npc,
%% 										 TD#task.gold,Coin2, Exp2, TipList,
%% 										 AwardList1, TD#task.award_select_item}
%% 										 %TD#task.start_talk, TD#task.unfinished_talk, TD#task.end_talk}
%% 								end;
%% 							false->skip
%% 						end;
%% 					false->
%% 						skip
%% 				end
%% 						
%%         end,
%%         TriggerBag
%%     ),
%% 	
%% 	%%io:format("TriggerList ~p~n", [TriggerBag]),
%% 	
%% 	
%% 	%%下一级主线任务
%% 	%%io:format("here1~n"),
%% 	TriggerBag_id =[Rt#role_task.tid||Rt<-TriggerBag],
%% 	%%io:format("TriggerBag_id ~p~n", [TriggerBag_id]),
%% 	NextBag = lib_task:next_lev_list(PlayerStatus,ActiveIds++TriggerBag_id),
%% 	%%io:format("NextBag ~p~n", [NextBag]),
%% 	NextList = lists:map(
%% 		fun(Tid)->
%% 			case lib_task:get_data(Tid) of
%% 				[]->skip;
%% 				TD->
%% 					TipList = lib_task:get_tip(next,Tid,PlayerStatus),
%% 					%%io:format("next TriggerBag_id ~p/~p~n", [Tid, TipList]),
%% 					[Exp,_Times] = 
%% 								case lib_task:is_normal_daily_task(TD)==true of
%% 									true->
%% 										[round(TD#task.exp),0];
%% 									false->
%% 										[TD#task.exp,0]%%封神贴任务不出现在玩家可接任务列表中，此处可以不处理奖励
%% 								end,		
%% 					AwardList1 = lib_task:get_award_item(TD, PlayerStatus),			%%普通任务奖励
%% %% 					AwardList2 = lib_task:get_base_task_guild_award(TD#task.id),	%%联盟任务奖励	
%% 					%[Exp,Times2] = [TD#task.exp,0],
%% 					{TD#task.id, TD#task.level, TD#task.type,TD#task.child,
%% 					 TD#task.name, TD#task.desc,TD#task.start_npc,TD#task.end_npc, TD#task.gold,
%% 					 TD#task.coin,Exp,TipList,
%% 					 AwardList1, TD#task.award_select_item}
%% 					%TD#task.start_talk, TD#task.unfinished_talk, TD#task.end_talk}
%% 			end
%% 		 end,
%% 		 NextBag
%% 	),
%% 	
%% 	
%% 	case pt_30:write(30000, [ActiveList++NextList, TriggerList]) of
%% 		{ok, BinData} ->
%% 			%%io:format("30000 binData: ~p~n",[BinData]),
%% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 		_ ->
%% 			ok
%% 	end,
%% 	
%% 	lib_task:check_week_level(PlayerStatus),
%% 	
%% 	Process_id = self(),
%% 	spawn(erlang, garbage_collect, [Process_id]),
%% 	{noreply,State};

%% %%已接任务列表
%% handle_cast({'trigger_task',PlayerStatus},State)->
%% 	
%% 	lib_task:check_expire_cycle_task(PlayerStatus),
%% 	%% 已接任务
%%     TriggerBag = lib_task:get_trigger(PlayerStatus),
%%     TriggerList = lists:map(
%%         fun(RT) ->		
%%             case is_record(RT,role_task) of
%% 				true->
%% 					%%发布的雇佣任务不显示
%% 					case RT#role_task.state =/= 2 of
%% 						true->
%% 							%%　获取任务详细数据
%% 							case lib_task:get_data(RT#role_task.tid) of
%% 								[]->skip;
%% 								TD->
%%         		   					TipList = lib_task:get_tip(trigger, RT#role_task.tid, PlayerStatus),
%% 									[Exp,_Times] = case lib_task:is_normal_daily_task(TD)==true of
%% 													   true->
%% 														   [round(TD#task.exp),0];
%% 													   false->
%% 														   [TD#task.exp,0]
%% 												   end,
%% 									if
%% 										TD#task.type =:= 6 ->
%% 											{Exp2, Coin2} = lib_task:get_task_cycle_reward2(TD#task.level, TD#task.exp, TD#task.coin, PlayerStatus#player.lv);
%% 										true ->
%% 											Exp2  = Exp,
%% 											Coin2 = TD#task.coin
%% 									end,
%% 									if
%% 										TD#task.type =:= 5 andalso TD#task.gold > 0 ->
%% 											AwardList0 = lib_task:get_award_item(TD, PlayerStatus),			%%普通任务奖励
%% 											AwardList1 = [{210201, TD#task.gold}|AwardList0];
%% 										true ->
%% 											AwardList1 = lib_task:get_award_item(TD, PlayerStatus)			%%普通任务奖励
%% 									end,
%% %% 					                AwardList2 = lib_task:get_base_task_guild_award(TD#task.id),	%%联盟任务奖励
%% 									{TD#task.id, TD#task.level, TD#task.type, TD#task.child,
%% 									 TD#task.name, TD#task.desc,TD#task.start_npc,TD#task.end_npc,
%% 									 TD#task.gold,Coin2, Exp2, TipList,
%% 									 AwardList1, TD#task.award_select_item}
%% 							end;
%% 						false->skip
%% 					end;
%% 				false->
%% 					skip
%% 			end
%%         end,
%%         TriggerBag
%%     ),
%% 	{ok, BinData} = pt_30:write(30001, [TriggerList]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	{noreply,State};

%% %%更新已接任务列表
%% handle_cast({'update_trigger_task',PlayerStatus},State)->
%% 	%% 是否有过期的活动任务
%% 	lib_task:check_expire_cycle_task(PlayerStatus),
%% 	%% 已接任务
%%     TriggerBag = lib_task:get_trigger(PlayerStatus),
%%     TriggerList = lists:map(
%%         fun(RT) ->		
%%             case is_record(RT,role_task) of
%% 				true->
%% 					%%发布的雇佣任务不显示
%% 					case RT#role_task.state =/= 2 of
%% 						true->
%% 							%%　获取任务详细数据
%% 							case lib_task:get_data(RT#role_task.tid) of
%% 								[]->skip;
%% 								TD->
%%         		   					TipList = lib_task:get_tip(trigger, RT#role_task.tid, PlayerStatus),
%% 									[Exp,_Times] = case lib_task:is_normal_daily_task(TD)==true of
%% 													   true->
%% 														   [round(TD#task.exp),0];
%% 													   false->
%% 														   [TD#task.exp,0]
%% 												   end,
%% 												  
%% 									{TD#task.id, TD#task.level, TD#task.type, TD#task.child,
%% 									 TD#task.name, TD#task.desc,TD#task.start_npc,TD#task.end_npc,
%% 									 TD#task.gold,TD#task.coin, Exp, TipList}
%% 							end;
%% 						false->skip
%% 					end;
%% 				false->
%% 					skip
%% 			end
%%         end,
%%         TriggerBag
%%     ),
%% 	%%io:format("update_trigger_task: ~p~n",[TriggerList]),
%% 	{ok, BinData} = pt_30:write(30080, [TriggerList]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	{noreply,State};


%% 初始化玩家任务
handle_cast({'init_task',PlayerStatus},State)->
	lib_task:flush_role_task(PlayerStatus),
%% 	lib_task:init_task_guild(PlayerStatus),
	lib_task:init_daily_task(PlayerStatus),
	lib_task:preact_finish(PlayerStatus),
	{noreply,State};

%%任务事件
handle_cast({'task_event',PlayerStatus,Event,Param},State) ->
	lib_task:task_event(Event, Param, PlayerStatus),
	{noreply,State};

%%刷新任务列表
handle_cast({'refresh_task',PlayerStatus},State)->
	lib_task:refresh_active(PlayerStatus),
%% 	{ok, BinData} = pt_30:write(30006, [1,0]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
	{noreply,State};

%%停止进程
handle_cast({stop, PlayerStatus}, State) ->
	lib_task:save_daily_task(PlayerStatus),
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% %%零点刷新任务
%% handle_info(refresh, State) ->
%% 	case ets:lookup(?ETS_ONLINE, State#state.player_id) of
%% 		[] ->
%% 			erlang:send_after(?TIMER_1, self(), refresh),
%% 			NewState = State;
%% 		[PlayerStatus] ->
%% 			Timestamp = State#state.nowtime,
%% 			case check_new_day(Timestamp) of
%% 				true->
%% 					NewState = State,
%% 					erlang:send_after(?TIMER_1, self(), refresh);
%% 				false->
%% 					lib_task:refresh_active(PlayerStatus),
%% 					{ok, BinData} = pt_30:write(30006, [1,0]),
%%     				lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 		   			erlang:send_after(?TIMER_1, self(), refresh),
%% 					NewState = State#state{nowtime=util:unixtime()}
%% 			end
%% 	end,
%% 	{noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% %%检查第二天
%% check_new_day(Timestamp)->
%% 	if Timestamp =/= 0 ->
%% 		NDay = (util:unixtime()+8*3600) div 86400,
%% 		TDay = (Timestamp+8*3600) div 86400,
%% 		NDay=:=TDay;
%% 	   true->
%% 		   true
%% 	end.

%% next_task_cue(PlayerStatus,TaskId,Type)->
%% 	case lib_task:get_data(TaskId) of 
%%         [] -> skip;
%%         TD ->
%%             case TD#task.next_cue of
%%                 0 -> skip;
%%                 _ -> 
%% 					case Type of
%% 						1->
%%                    			Npc = lib_npc:get_data(TD#task.start_npc),
%% 							TaskList = lib_task:get_npc_task_list(TD#task.start_npc, PlayerStatus);
%% 						_->
%% 							Npc = lib_npc:get_data(TD#task.end_npc),
%% 							TaskList = lib_task:get_npc_task_list(TD#task.end_npc, PlayerStatus)
%% 					end,
%% 					io:format("next_task_cue, TaskList:~p~n",[TaskList]),
%% 				   if TaskList/=[] ->
%% 						  case Type of
%% 							  1->
%% 						  		Id = mod_scene:get_npc_unique_id(TD#task.start_npc, PlayerStatus#player.scn);
%% 							  _->
%% 								  Id = mod_scene:get_npc_unique_id(TD#task.end_npc, PlayerStatus#player.scn)
%% 						  end,
%% 						  case PlayerStatus#player.camp =:=100 orelse length(TaskList) =:= 1 of
%% 							  true->
%% 								  case lib_task:check_npc_type(Npc) of
%% 									  true->
%% 										   case check_task_state(TaskList) of
%% 											  true->
%% 										  		%%[[20100,3, <<229,145,189,232,191,144,228,185,139,229,173,144>>,4]]
%% 								  				[[NextTaskId|_]|_Other]=TaskList,
%% 					              				pp_npc:handle(32001, PlayerStatus, [Id, NextTaskId]);
%% 											   false->skip
%% 										   end;
%% 									  false->
%% 										  case check_task_state(TaskList) of
%% 											  true->
%% 										  		TalkList = data_agent:talk_get(Npc#ets_npc.talk),
%% 								  		  		{ok, BinData} = pt_32:write(32000, [Id, TaskList, TalkList]),
%% 								   		  		lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 											  false->skip
%% 										  end
%% 								  end;
%% 							   false->
%% 								   case check_task_state(TaskList) of
%% 									   true->
%% 										   TalkList = data_agent:talk_get(Npc#ets_npc.talk),
%% 										   {ok, BinData} = pt_32:write(32000, [Id, TaskList, TalkList]),
%% 										   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 									   false->skip
%% 								   end
%% 						  end;
%% 					   true->
%% 						   skip
%% 				   end
%% 			end
%%     end.

%% check_task_state([])->
%% 	false;
%% check_task_state(TaskList)->
%% 	[[_NextTaskId,State|_]|Other]=TaskList,
%% 	if State =/= 2 ->
%% 		   true;
%% 	   true->check_task_state(Other)
%% 	end.

%% %% [剩余次数,总次数]
%% get_daily_task_num(Status) ->
%% 	if (Status#player.ftst band 131072) =/= 0 ->
%% 		   case catch(gen_server:call(Status#player.other#player_other.pid_task, {'get_daily_task', Status})) of
%% 			   {ok, DailyTask} ->
%% 				   case DailyTask of
%% 					   [] ->
%% 						   [0, 0];
%% 					   _ ->
%% 						   DailyNum = DailyTask#task_daily.num,
%% 						   DailyUse = DailyTask#task_daily.use,
%% 						   [DailyNum - DailyUse, DailyNum]
%% 				   end;
%% 			   _Other ->
%% 				   [0,0]
%% 		   end;
%% 	   true ->
%% 		   [0, 0]
%% 	end.
	