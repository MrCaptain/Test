%% Author: Administrator
%% Created: 2012-1-4
%% Description: TODO: Add description to db_agent_task
-module(db_agent_task).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
%%
%% Exported Functions
%%
-compile(export_all).

%%
%% API Functions
%%

%% get_task_finish(PlayerId) ->
%% 	?DB_MODULE:select_row(task_finish, "*", [{uid, PlayerId}],
%% 						  [], [1]).	
%% 
%% new_task_finish(PlayerId) ->
%% 	TaskFinish = #ets_task_finish{
%% 				 uid = PlayerId,
%% 				 td1 = util:term_to_string([]),
%% 				 td2 = util:term_to_string([]),
%% 				 td3 = util:term_to_string([]),
%% 				 td4 = util:term_to_string([]),
%% 				 td5 = util:term_to_string([]),
%% 				 td6 = util:term_to_string([]),
%% 				 td7 = util:term_to_string([]),
%% 				 td = util:term_to_string([])				
%% 				},
%% 	
%% 	ValueList = lists:nthtail(2, tuple_to_list(TaskFinish)),
%%     [id | FieldList] = record_info(fields, ets_task_finish),
%% 	Ret = ?DB_MODULE:insert(task_finish, FieldList, ValueList),	
%% 	TaskFinish1 = #ets_task_finish{id = Ret, uid = PlayerId,
%% 								  td1 = [], td2 = [],
%% 								  td3 = [], td4 = [],
%% 								  td5 = [], td6 = [],
%% 								  td7 = [], td = []},
%% 	TaskFinish1.
%% 
%% save_finish_task(TF) ->
%% 	BD1 = util:term_to_string(TF#ets_task_finish.td1),
%% 	BD2 = util:term_to_string(TF#ets_task_finish.td2),
%% 	BD3 = util:term_to_string(TF#ets_task_finish.td3),
%% 	BD4 = util:term_to_string(TF#ets_task_finish.td4),
%% 	BD5 = util:term_to_string(TF#ets_task_finish.td5),
%% 	BD6 = util:term_to_string(TF#ets_task_finish.td6),
%% 	BD7 = util:term_to_string(TF#ets_task_finish.td7),
%% 	BD = util:term_to_string([]),
%% 	?DB_MODULE:update(task_finish, 
%% 					  [{td1, BD1},{td2, BD2},
%% 					   {td3, BD3},{td4, BD4},
%% 					   {td5, BD5},{td6, BD6},
%% 					   {td7, BD7},{td, BD}], 
%% 					  [{uid, TF#ets_task_finish.uid}]).
%% 
%% save_finish_task(TF, Level) ->
%% 	if 
%% 		Level < 11 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td1),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td1, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		Level < 21 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td2),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td2, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		Level < 31 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td3),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td3, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		Level < 41 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td4),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td4, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		Level < 51 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td5),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td5, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		Level < 61 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td6),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td6, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		Level < 71 ->
%% 			Bindata = util:term_to_string(TF#ets_task_finish.td7),
%% 			?DB_MODULE:update(task_finish, 
%% 					  [{td7, Bindata}], 
%% 					  [{uid, TF#ets_task_finish.uid}]);
%% 		true ->
%% 			skip
%% 	end.	
%% 
%% delete_task_finish(PlayerId) ->
%% 	?DB_MODULE:delete(task_finish, [{uid, PlayerId}]).
%% 	
%% 
%% %% new_task_guild(PlayerId, Crrt) ->
%% %% 	TaskGuild = #task_guild{
%% %% 				 uid = PlayerId,
%% %% 				 rt  = 0,
%% %% 			     st  = 2,
%% %% 				 crtt = Crrt
%% %% 				},
%% %% 	ValueList = lists:nthtail(2, tuple_to_list(TaskGuild#task_guild{aw = util:term_to_string(TaskGuild#task_guild.aw)})),
%% %%     [id | FieldList] = record_info(fields, task_guild),
%% %% 	Ret = ?DB_MODULE:insert(task_guild, FieldList, ValueList),
%% %% 	TaskGuild#task_guild{id = Ret}.
%% %% 
%% %% get_task_guild(PlayerId) ->
%% %% 	D = ?DB_MODULE:select_row(task_guild, "*", [{uid, PlayerId}],
%% %% 						  [], [1]),
%% %% 	case D of
%% %% 		[] ->
%% %% 			[];
%% %% 		_ ->
%% %% 			TaskGuild = list_to_tuple([task_guild | D]),
%% %% 			Aw = util:string_to_term(tool:to_list(TaskGuild#task_guild.aw)),
%% %% 			TaskGuild#task_guild{aw=Aw}
%% %% 	end.
%% %% 
%% %% delete_task_guild(PlayerId) ->
%% %% 	?DB_MODULE:delete(task_guild, [{uid, PlayerId}]).
%% %% 
%% %% update_task_guild(TaskGuild) ->
%% %% 	Aw = util:term_to_string(TaskGuild#task_guild.aw),
%% %% 	?DB_MODULE:update(task_guild,[{tid,TaskGuild#task_guild.tid},{rt,TaskGuild#task_guild.rt},
%% %% 								  {ft,TaskGuild#task_guild.ft},{rft,TaskGuild#task_guild.rft},
%% %% 								  {st,TaskGuild#task_guild.st},{qly,TaskGuild#task_guild.qly},
%% %% 								  {aw,Aw}],
%% %% 					  [{uid,TaskGuild#task_guild.uid}]).
%% 
%% %% %% 获取任务日志信息
%% %% get_task_log_info(PlayerId) ->
%% %% 	?DB_LOG_MODULE:select_all(log_task, 
%% %% 						  "uid, tid,type, ttm, ftm",
%% %% 						  [{uid, PlayerId}]).
%% %% 
%% %% is_task_log_info(PlayerId, TaskId) ->
%% %% 	Data = ?DB_LOG_MODULE:select_row(log_task, 
%% %% 						  "*",
%% %% 						  [{uid, PlayerId}, {tid, TaskId}], [], [1]),
%% %% 	
%% %% 	case Data of
%% %% 		[] -> false;
%% %% 		_ -> true
%% %% 	end.
%% %% %% 删除任务日志信息
%% %% delete_task_log(PlayerId) ->
%% %% 	?DB_LOG_MODULE:delete(log_task, [{uid, PlayerId}]).
%% %% 
%% %% %% 同步任务数据(插入任务日志)
%% %% syn_db_task_log_insert(Data)->
%% %% 	?DB_LOG_MODULE:insert(log_task, [uid, tid,type, ttm, ftm], Data).
%% 
%% %%%%% 
%% %%%%% 
%% new_daily_task(PlayerId) ->
%% 	DailyTask = #task_daily{
%% 				 uid = PlayerId,
%% 				 num = 20,
%% 				 use = 0,
%% 				 frtm =1,
%% 				 frus = 0,
%% 				 lstm =0		 
%% 				},
%% 	ValueList = lists:nthtail(2, tuple_to_list(DailyTask#task_daily{cont = util:term_to_string(DailyTask#task_daily.cont)})),
%%     [id | FieldList] = record_info(fields, task_daily),
%% 	Ret = ?DB_MODULE:insert(task_daily, FieldList, ValueList),
%% 	DailyTask1 = DailyTask#task_daily{id = Ret},
%% 	DailyTask1.
%% 
%% select_daily_by_playerid(PlayerId) ->	
%% 	?DB_MODULE:select_row(task_daily, "*", [{uid, PlayerId}],
%% 						  [], [1]).	
%% 
%% delete_daily_by_playerid(PlayerId) ->
%% 	?DB_MODULE:delete(task_daily, "*", [{uid, PlayerId}]).
%% 
%% updata_daily_task(DailyTask) ->	
%% 	Bindata = util:term_to_string(DailyTask#task_daily.cont),
%% 	?DB_MODULE:update(task_daily, 
%% 					  [{cont, Bindata}], 
%% 					  [{id, DailyTask#task_daily.id}]).
%% 
%% save_daily_task(DailyTask) ->
%% 	Bindata = util:term_to_string(DailyTask#task_daily.cont),
%% 	Use = DailyTask#task_daily.use,
%% 	FreeUse = DailyTask#task_daily.frus,
%% 	Lstm = DailyTask#task_daily.lstm,
%% 	Rstm = DailyTask#task_daily.rstm,
%% 	Rftm = DailyTask#task_daily.rftm,
%% 	WeekUse = DailyTask#task_daily.wuse,
%% 	WeekBin = util:term_to_string(DailyTask#task_daily.week),
%% 	?DB_MODULE:update(task_daily, 
%% 					  [{cont, Bindata},
%% 					   {use, Use},
%% 					   {frus, FreeUse},
%% 					   {lstm, Lstm},
%% 					   {rstm, Rstm},
%% 					   {rftm, Rftm},
%% 					   {wuse, WeekUse},
%% 					   {week, WeekBin}], 
%% 					  [{id, DailyTask#task_daily.id}]).
%% 
%% 
%% select_all_task_bag() ->
%% 	?DB_MODULE:select_all(task_bag, 
%% 								 "uid, tid, state, mark", 
%% 								 []).
%% 
%% select_all_task_cycle(PlayerId) ->
%% 	CycleTaskList = ?DB_MODULE:select_all(task_cycle, 
%% 						  "id, uid, tid, type, ttm, ftm, st, ktn, ctn, ftask",
%% 						  [{uid, PlayerId}]),
%% 	F = fun(Task) ->
%% 				[Id, PlayerId, Tid, Type, TTM, FTM, St, Ktn, Ctn, Ftask] = Task,
%% 				Ftask1 = util:string_to_term(tool:to_list(Ftask)),
%% 				[Id, PlayerId, Tid, Type, TTM, FTM, St, Ktn, Ctn,  Ftask1]
%% 		end,
%% 	lists:map(F, CycleTaskList).
%% 
%% new_cycle_task(Data) ->
%% 	[PlayerId, Tid, Type, Time] = Data,
%% 	CycleTask = #ets_task_cycle{
%% 				 uid = PlayerId,
%% 				 tid = Tid,
%% 				 type = Type,
%% 				 ftm =Time
%% 				},
%% %% 	ValueList = lists:nthtail(2, tuple_to_list(CycleTask)),
%% %%     [id | FieldList] = record_info(fields, ets_task_cycle),
%% 	Ftask = util:term_to_string([]),
%% 	ValueList = [PlayerId, Tid, Type, Time, 2,Ftask],
%% 	FieldList = [uid, tid, type, ftm, st, ftask],
%% 	Ret = ?DB_MODULE:insert(task_cycle, FieldList, ValueList),
%% 	CycleTask1 = CycleTask#ets_task_cycle{id = Ret, st=2, ftask=[]},
%% 	CycleTask1.
%% 
%% updata_cycle_task(TaskId, Ftm) ->
%% 	?DB_MODULE:update(task_cycle, 
%% 					  [{ftm,  Ftm}], 
%% 					  [{id, TaskId}]).
%% 
%% updata_cycle_task6(TaskCycle) ->
%% %% 	io:format("updata_cycle_task6, TaskCycle:~p~n",[TaskCycle]),
%% 	Ftask = util:term_to_string(TaskCycle#ets_task_cycle.ftask),
%% 	?DB_MODULE:update(task_cycle, 
%% 					  [{tid,TaskCycle#ets_task_cycle.tid}, {ttm, TaskCycle#ets_task_cycle.ttm}, {ftm,  TaskCycle#ets_task_cycle.ftm},
%% 					   {st,TaskCycle#ets_task_cycle.st},{ktn,TaskCycle#ets_task_cycle.ktn},{ctn,TaskCycle#ets_task_cycle.ctn},{ftask,Ftask}], 
%% 					  [{id, TaskCycle#ets_task_cycle.id}]).
%% 
%% 
%% %%根据角色ID查询玩家的新版每日任务实例
%% select_task_day_by_playerid(PlayerId) ->	
%% 	?DB_MODULE:select_row(task_day, "*", [{uid, PlayerId}], [], [1]).	
%% 
%% %%新生成一玩家的新版每日任务
%% new_task_day(PlayerId) ->
%% 	Now = util:unixtime(),
%% 	TaskDay = #ets_task_day{uid = PlayerId, lstm = Now, cnt=[]},
%% 	ValueList = lists:nthtail(2, tuple_to_list(TaskDay#ets_task_day{cnt = util:term_to_string([])})),
%%     [id | FieldList] = record_info(fields, ets_task_day),
%% 	Ret = ?DB_MODULE:insert(task_day, FieldList, ValueList),
%% 	TaskDay#ets_task_day{id = Ret}.
%% 
%% %%更新玩家新版每日任务实例
%% update_task_day(TaskDay) ->
%% %% 	io:format("updata_cycle_task6, TaskCycle:~p~n",[TaskCycle]),
%% 	Cnt = util:term_to_string(TaskDay#ets_task_day.cnt),
%% 	?DB_MODULE:update(task_day, 
%% 					  [{lstm,TaskDay#ets_task_day.lstm}, {cnt,Cnt}], 
%% 					  [{id, TaskDay#ets_task_day.id}]).
%% 
%% 
%% %%
%% %% Local Functions
%% %%
%% 
