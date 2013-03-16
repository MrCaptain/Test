%%%------------------------------------
%%% @Module  : pp_task
%%% @Author  : Johanathe_Yip
%%% @Created : 2013.01.13
%%% @Description: 任务模块
%%%------------------------------------
-module(pp_task).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%% 获取任务列表
handle(30000, PlayerStatus, []) ->
	 gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'task_list',PlayerStatus});
 
%%已接任务列表
handle(30001,PlayerStatus,[])->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_task,{'trigger_task',PlayerStatus});

%% 接受任务
handle(30003, PlayerStatus, [TaskId]) -> 
	gen_server:cast
			(PlayerStatus#player.other#player_other.pid_task, {'accept_task',PlayerStatus, [TaskId]}),
   	lib_task:call_event(PlayerStatus,kill,{1,10});
%% 	lib_task:call_event(PlayerStatus,item,{2,5}),
%% 	lib_task:call_event(PlayerStatus,npc,{1}),
%% 	lib_task:call_event(PlayerStatus,shopping,{1,5}),
%% 	lib_task:call_event(PlayerStatus,npc_goods,{1,1,5}),
%% 	lib_task:call_event(PlayerStatus,god_command,{}),
%% 	lib_task:call_event(PlayerStatus,scene,{1,5});

%% 完成任务(还没处理逻辑:1.获取任务奖励，删除任务物品 2.更新角色状态并发送到客户端)
handle(30004, PlayerStatus, [TaskId])->	  
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
%% 	 gen_server:cast
%% 			(PlayerStatus#player.other#player_other.pid_task, {'finish_task', PlayerStatus, [TaskId]});
%% 检测npc状态
handle(30005, PlayerStatus, [Npclist])->	  
	 gen_server:cast
			(PlayerStatus#player.other#player_other.pid_task, {'check_npc', PlayerStatus, [Npclist]});
handle(30006, PlayerStatus, [Size])->	  
	 gen_server:cast
			(PlayerStatus#player.other#player_other.pid_task, {'show_all_task', PlayerStatus, [Size]});
%%消耗元宝完成任务
handle(30007, PlayerStatus, [TaskId])-> 
	case lib_task:auto_finish_task_by_coin(PlayerStatus, TaskId) of
		{ok,NewPs}->
			{ok,Data} = pt_30:write(30007, 100),
			lib_send:send_to_sid(NewPs#player.other#player_other.pid_send, Data),
			{ok,NewPs};
		{false,Reason}->
			{ok,Data} = pt_30:write(30007, Reason),
			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, Data)
	end;
handle(_Cmd, _PlayerStatus, _Data) ->
    {error, bad_request}. 
  
