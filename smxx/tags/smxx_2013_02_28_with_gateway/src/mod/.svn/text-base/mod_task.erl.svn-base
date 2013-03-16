%%%------------------------------------
%%% @Module  : mod_task
%%% @Author  : Johanathe_Yip
%%% @Created : 2013.01.13
%%% @Description: 任务处理模块
%%%------------------------------------
-module(mod_task).
-behaviour(gen_server).
-compile(export_all).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").


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


handle_call(_Null, _From, State) ->
	{reply,[], State}.
 

%% 初始化玩家任务
handle_cast({'init_task',PlayerStatus},State)->  
	lib_task:init_pid_data() ,
 	lib_task:init_trigger_task(PlayerStatus#player.id),
	lib_task:init_daily_task_finish(PlayerStatus#player.id),
	lib_task:init_fin_role_task(PlayerStatus#player.id),
	lib_task:refresh_active(PlayerStatus), 
	{noreply,State};

%%任务事件(打怪等)
handle_cast({'task_event',PlayerStatus,Event,Param},State) ->
	lib_task:task_event(Event, Param, PlayerStatus),
	{noreply,State};

%%刷新任务列表
handle_cast({'refresh_task',PlayerStatus},State)->
	lib_task:refresh_active(PlayerStatus),
 	{noreply,State};

%%停止进程
handle_cast({stop, PlayerStatus}, State) ->
	{stop, normal, State};
 
%%接受任务
handle_cast({'accept_task', PlayerStatus, [TaskId]}, State)->  
	 	case tool:is_operate_ok(pp_30003, 0) of
		true -> 
			case lib_task:trigger_task(TaskId, PlayerStatus) of
				{true, NewPlayerStatus} ->						
					{ok, BinData1} = pt_30:write(30003, [100]),
				 	lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1), 
					{ok, PlayerStatus};
				{false, Reason} -> 
				 	{ok, BinData1} = pt_30:write(30003, [Reason]),
					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
					ok;
				_ ->
			 		{ok, BinData2} = pt_30:write(30003, [113]),
					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData2),
					ok
			end;
		false->skip
	end,
	{noreply, State};
%%完成任务
handle_cast({'finish_task', PlayerStatus, [TaskId]}, State)->  
		case tool:is_operate_ok(pp_30004, 0) of
		true -> 
			case lib_task:finish_task(TaskId, PlayerStatus) of
				{true, NewPlayerStatus} ->	   
					{ok, BinData1} = pt_30:write(30004, [100]),
				 	lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1), 
					{ok, PlayerStatus};
				{false, Reason} -> 
					{ok, BinData1} = pt_30:write(30004, [Reason]),
					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
					ok;
				_ ->
			 		{ok, BinData2} = pt_30:write(30004, [113]),
					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData2),
					ok
			end;
		false->skip
	end,
	{noreply, State};
%%显示玩家任务列表
handle_cast({'show_all_task', PlayerStatus, [Size]}, State)->  
	 lib_task:get_all_task_2_client(PlayerStatus, Size),
	{noreply, State};
%%检查任务npc状态
handle_cast({'check_npc', PlayerStatus, [Npclist]}, State)->
	lib_task:check_npc_list_state(Npclist, PlayerStatus),
	{noreply, State};
%%删除进程字典中指定的任务
handle_cast({'del_dict',{Type,Tid,TState}}, State)-> 
	lib_task:del_finish_task(Type,Tid,TState), 
	{noreply, State};  
handle_cast(_Msg, State) ->
	{noreply, State}. 

handle_info(_Info, State) ->
	{noreply, State}.

terminate(normal, _State) -> 
	lib_task:player_exit(_State#state.player_id), 
	misc:delete_monitor_pid(self()), 
 	ok;
terminate(_, _) -> 
 	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
 

