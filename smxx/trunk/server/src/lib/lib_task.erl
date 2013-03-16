%%%-----------------------------------
%%% @Module  : lib_task
%%% @Author  : Johanathe_Yip
%%% @Created : 2013.01.13
%%% @Description: 任务
%%%-----------------------------------
-module(lib_task).
-compile(export_all).
-include("common.hrl").
-include("record.hrl"). 
-include("task.hrl").
-include("debug.hrl").
-include("log.hrl"). 

%--------------------------------
%        服务器初始化(现在暂不用)
%--------------------------------  

%%初始化任务任務模板
init_base_task() ->
	ets:delete_all_objects(?ETS_TPL_TASK),
	F = fun(Task) ->
				D = list_to_tuple([tpl_task|Task]), 
				TaskInfo = D#tpl_task{
									  goods_list = data_agent:task_valToTagCode(D#tpl_task.goods_list)	,	   
									  target_property =  data_agent:task_valToTagCode(D#tpl_task.target_property),
									  guild_goods_list = data_agent:task_valToTagCode(D#tpl_task.guild_goods_list) 
									 }, 
				%	?TRACE("tpl_task_init--tpl_task_item: ~p ~n",[TaskInfo]), 
				ets:insert(?ETS_TPL_TASK, TaskInfo) 
		end, 
	L =db_agent_task:get_all_tpl_task(), 
	lists:foreach(F, L),
	ok.

%%初始化任务任務模板子表
init_base_task_detail()->
	ets:delete_all_objects(?ETS_TASK_DETAIL),
		F = fun(Task) ->
				D = list_to_tuple([task_detail|Task]), 
				TaskInfo = D#task_detail{
									  time_limit = util:bitstring_to_term(D#task_detail.time_limit)
									 },  
				ets:insert(?ETS_TASK_DETAIL, TaskInfo) 
		end, 
	L =db_agent_task:get_all_task_detail(),
	lists:foreach(F, L), 
	ok. 

%--------------------------------
%        角色登陆服务器初始化
%--------------------------------  

%%初始化进程字典角色任务，日常数据 
init_pid_data()-> 
	put({role_task_list,0},[]),
	put({role_task_list,1},[]),
	put({daily_task_list,0},[]),
	put({daily_task_list,1},[]). 

%%初始化玩家已触发任务
init_trigger_task(PlayerId)-> 
	Result = db_agent_task:get_trigger_task_by_uid(PlayerId),   
	lists:foreach(fun(Task)->
						  D = list_to_tuple([task_process|Task]),
						  TaskInfo = D#task_process{
													id = {PlayerId,D#task_process.tid},
													mark = data_agent:task_valToTagCode(D#task_process.mark)
												   },
						  insert_pid(TaskInfo#task_process.type,TaskInfo#task_process.state,TaskInfo#task_process.tid),
					 	  ets:insert(?ETS_TASK_PROCESS, TaskInfo)
				  end, Result).

%%插入触发主线,支线任务到进程字典
insert_pid(Type,State,TaskId)when Type =:= ?MAIN_TASK orelse Type =:=?BRANCHE_TASK -> 
	case get({role_task_list,State}) of 
		undefined-> 
			put({role_task_list,State},[TaskId]),
			?ERROR_MSG("pid_dict not exit ~n",[]);
		Result->
			put({role_task_list,State},Result++[TaskId])end;
%%插入触发日常任务到进程字典
insert_pid(_,State,TaskId) -> 
	case get({daily_task_list,State}) of 
		undefined-> 
			put({daily_task_list,State},[TaskId]),
			?ERROR_MSG("pid_dict not exit ~n",[]);
		Result->
			put({daily_task_list,State},Result++[TaskId])end.

%%初始化玩家日常任务完成列表
init_daily_task_finish(PlayerId)->  
	Result = db_agent_task:get_daily_fin_by_uid(PlayerId),
	%%所有任务类型
	AllTaskType = ?ALL_TASK_TYPE,
	AllLen = length(AllTaskType),
	case length(Result) of
		0->%%玩家初次登陆游戏,为玩家初始化所有日常任务数据
			check_daily_task_fin(PlayerId) ;
		AllLen ->%%玩家之前已经登陆过游戏,直接加载玩家数据
			do_upd_daily_fin_login(Result);
		_ ->%%玩家有部分日常任务数据丢失,重新初始化丢失部分,直接加载已有部分
			do_upd_daily_fin_login(Result),
			check_daily_task_fin(PlayerId)
	end.
%%将数据库中的日常任务完成数据结构化为ets数据
prase_original_daily_data(Task)->
		Task#daily_task_finish{
								   uid = {Task#daily_task_finish.uid,Task#daily_task_finish.type},
								   count_detail = data_agent:task_valToTagCode(Task#daily_task_finish.count_detail),
								   cycle_datil= data_agent:task_valToTagCode(Task#daily_task_finish.cycle_datil),
								   trigger_detail = data_agent:task_valToTagCode(Task#daily_task_finish.trigger_detail),
								   reset_time =  Task#daily_task_finish.reset_time,
								   trigger_time = data_agent:task_valToTagCode(Task#daily_task_finish.trigger_time)
								  }.

%%将玩家日常任务表的数据加载到ets中
insert_daily_fin_in_ets(Task)->    
	TaskInfo = prase_original_daily_data(Task), 
	ets:insert(?ETS_TASK_DAILY_FINISH, TaskInfo).

%%用户登录时更新日常任务完成数据,尝试重置玩家日常任务
do_upd_daily_fin_login(Result)->
	lists:foreach(fun(Task)->
						  D = list_to_tuple([daily_task_finish|Task]), 
						  {ThatMidNight,_} = util:get_midnight_seconds( D#daily_task_finish.reset_time),
						  Now = util:unixtime(),
						  TimeSpend = Now-ThatMidNight,
						  if TimeSpend >=?RESET_TIME ->
								 reset_one_daily_fin(prase_original_daily_data(D), Now);
							 true->
								 insert_daily_fin_in_ets(D)
						  end
				  end, Result) . 

%%玩家检测日常完成表中有哪些数据空缺,空缺的添加到日常表中
check_daily_task_fin(PlayerId)->
	AllTaskType = ?ALL_TASK_TYPE,
	lists:foreach(fun(Type)->
						   case ets:lookup(?ETS_TASK_DAILY_FINISH, {PlayerId,Type}) of
							  []->
								  TaskDetail = task_detail:get(Type),
								   Now = util:unixtime(),  	
								  NewDailyFin = #daily_task_finish{
																   uid = {PlayerId,Type},                     
																   type = Type,                 
																   state = 0,                       
																   reset_time = Now,                   
																   count_detail = {TaskDetail#task_detail.trigger_time,0},                   
																   cycle_datil = {TaskDetail#task_detail.cycle_time,0},                   
																   total = 0,                     
																   trigger_time = date(),               
																   trigger_detail = {TaskDetail#task_detail.meanw_trigger,0,0}
																  },
								  ets:insert(?ETS_TASK_DAILY_FINISH, NewDailyFin),
								  db_agent_task:new_daily_task_fin(
									[ PlayerId, Type, 0, 
									  util:term_to_string({TaskDetail#task_detail.trigger_time,0}), 
									  util:term_to_string({TaskDetail#task_detail.cycle_time,0}),
									  util:term_to_string({TaskDetail#task_detail.meanw_trigger,0,0}),
									  Now, 
									  0,
									  util:term_to_string( date())
									] ); 
						  _->skip
						  end
				  end, AllTaskType).

%%初始化角色已完成主线/支线任务
init_fin_role_task(PlayerId)-> 
	case db_agent_task:get_task_finish(PlayerId) of
		[] ->
			NewTaskFinish = db_agent_task:new_task_finish(PlayerId);
		Result ->
			List = [task_finish | Result],			
			TaskFinish = list_to_tuple(List), 
			TF = TaskFinish#task_finish{td1 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td1)),
										td2 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td2)),
										td3 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td3)),
										td4 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td4)),
										td5 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td5)),
										td6 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td6)),
										td7 = util:string_to_term(binary_to_list(TaskFinish#task_finish.td7))},
			AllFinish = TF#task_finish.td1 ++
										   TF#task_finish.td2 ++ 
										   TF#task_finish.td3 ++
										   TF#task_finish.td4 ++ 
										   TF#task_finish.td5 ++
										   TF#task_finish.td6 ++ 
										   TF#task_finish.td7,
			NewTaskFinish = TF#task_finish{td = AllFinish}				
	end,   
	ets:insert(?ETS_TASK_FINISH, NewTaskFinish).
 

%-----------------------------
%         触发任务
%-----------------------------   

%%获取角色后五级可触发任务id
%%@param Type 任务类型
%%@param PS   玩家状态
get_rand_task(Type, PS)-> 
	Min = get_task_min_lv(PS), 
	F = fun(_, {Count, Result}) -> 
				List = tpl_task:get_by_type_level(Type, Count),
				IdList = [TD#tpl_task.tid || TD<-List, check_trigger_condition(TD, PS,TD#tpl_task.type)],
				{ok, {Count-1, Result++IdList}}	    
		end, 
	{ok,{ _, ResultList}} = util:for(PS#player.level, Min, F, {PS#player.level,[]}),
	ResultList.

%%获取角色前5级等级
get_task_min_lv(PS)->
	Result = PS#player.level-5,
	if Result>=0 ->
		   Result;
	   true ->
		   0
	end.    

%%判断任务触发条件
check_trigger_condition(TD, PS,TaskType) when is_record(TD, tpl_task)->
	Result = check_trigger(TD, PS,TaskType),   
	?INFO_MSG("player ~p result ~p ~n",[PS#player.id,Result]),
	Result =:= true ;
check_trigger_condition(_,_,_)->
	false.

%%尝试触发任务
trigger_task(TaskId, PS) ->
	case tpl_task:get(TaskId) of
		%%没有这个任务，不能接
		[] ->{false,?TASK_NOT_EXIT};
		TD -> 
			Result = check_trigger(TD, PS,TD#tpl_task.type),
			case Result of 
				true ->do_add_task(TD,PS), 
					   upd_daily_task_fin(PS#player.id,TD#tpl_task.type), 
					   refresh_active(PS),
					   {true,PS};
				_ -> {false,Result}
			end 
	end. 

%%触发日常任务时更新日常任务进度完成表
upd_daily_task_fin(PlayerId,Type) when Type =/= ?MAIN_TASK andalso Type =/= ?BRANCHE_TASK->
	case get_one_daily_task_fin(PlayerId, Type) of
		[TaskFin] when is_record(TaskFin, daily_task_finish) ->
	  Result = check_daily_task_can_tri(TaskFin,[]),
	  upd_daily_task_fin_2_db_mem(Result, TaskFin);
		_-> skip
	end;
upd_daily_task_fin(_,_)->
	skip.
%%获取玩家日常任务最新状态
get_daily_fin_state(TriggerDetail)->
	{CanTri,_,NowTri} = TriggerDetail,
	if CanTri-1 =:= NowTri ->
		   ?OUT_OF_MAX;
	   true->
		   ?CAN_TRIGGER
	end.
	   
%%更新日常任务完成表的trigger_detail(每次可触发任务数)字段,字段格式为{每次可同时触发任务数，已触发任务数}
check_daily_task_can_tri(TaskFin,Result)->
	{CanTri,FinTri,NowTri} = TaskFin#daily_task_finish.trigger_detail,
	if CanTri-1 > FinTri ->%%当已接任务数少于上限时,直接返回结果
		  [get_daily_fin_state(TaskFin#daily_task_finish.trigger_detail),
		   {CanTri,FinTri+1,NowTri+1}]++Result;
	    CanTri-1 == FinTri ->%%否则改变该字段状态并且更新玩家cycle_datil字段
			check_daily_task_can_cyc(TaskFin,[{CanTri,0,NowTri+1}]++Result)
	end.
%%更新日常任务完成表的cycle_datil字段 每轮可用次数{可触发次数，已触发次数}
check_daily_task_can_cyc(TaskFin,Result)->
	{CanCyc,NowCyc} = TaskFin#daily_task_finish.cycle_datil,
	if CanCyc-1 > NowCyc ->%%当已接任务次数少于上限时,直接返回结果
		  [get_daily_fin_state(TaskFin#daily_task_finish.trigger_detail),
		   {CanCyc,NowCyc+1}]++Result;
	    CanCyc-1 == NowCyc ->%%否则改变该字段状态并且更新玩家count_detail字段
			check_daily_task_can_count(TaskFin,[{CanCyc,0}]++Result)
	end.
%%更新日常任务完成表的 count_detail字段 本日可用次数{可用次数，已用次数}	
check_daily_task_can_count(TaskFin,Result)->
	{CanCount,Count} = TaskFin#daily_task_finish.count_detail,
	NewCount  = Count+1,
	case CanCount of
		NewCount ->%%当玩家已接任务轮数超过上限时,锁住玩家日常任务数据，不允许玩家再接同类日常任务
			[?CAN_NOT_TRIGGER,{CanCount,NewCount}]++Result;
		_-> %%否则,直接更新状态
			[get_daily_fin_state(TaskFin#daily_task_finish.trigger_detail),
			 {CanCount,NewCount}]++Result
	end.

%%更新日常完成任务进度到数据库与内存
upd_daily_task_fin_2_db_mem([State,CountDetail,CycDetail,TriDetail],TaskFin)->
	ets:insert(?ETS_TASK_DAILY_FINISH, TaskFin#daily_task_finish{
																 state = State,  
																 count_detail = CountDetail,               
																 cycle_datil = CycDetail,    
																 trigger_detail = TriDetail 
																}),
		db_agent_task:upd_daily_task_fin_2_db([State,CountDetail,CycDetail,TriDetail, TaskFin#daily_task_finish.uid]);
upd_daily_task_fin_2_db_mem([State,CycDetail,TriDetail],TaskFin)->
 	ets:insert(?ETS_TASK_DAILY_FINISH, TaskFin#daily_task_finish{ 
																 state = State,
																 cycle_datil = CycDetail,    
																 trigger_detail = TriDetail 
																}),
		db_agent_task:upd_daily_task_fin_2_db([State,CycDetail,TriDetail, TaskFin#daily_task_finish.uid]);
upd_daily_task_fin_2_db_mem([State,TriDetail],TaskFin)->
	ets:insert(?ETS_TASK_DAILY_FINISH, TaskFin#daily_task_finish{  
																 state = State,
																 trigger_detail = TriDetail 
																}),
		db_agent_task:upd_daily_task_fin_2_db([State,TriDetail, TaskFin#daily_task_finish.uid]).

%%任务限制判定 
check_trigger(TD, PS,Type) ->     
			case check_if_in_trigger(TD#tpl_task.tid, PS#player.id,TD#tpl_task.type) of
				%%该任务已经触发过了，不能接！
				true -> ?TASK_ALREADY_TRIGGER;
				false -> 
					case check_lvl(TD,PS) of
						%%您的等级不足，不能接
						false ->?TASK_LEVEL_NOTENOUGHT;
						true -> 
							case in_finish(TD#tpl_task.tid, PS#player.id)of	
								%%该任务已完成
								true->?TASK_ALREADY_FINISH;
								false -> %%判断玩家职业
									case check_career(TD#tpl_task.career,PS#player.career)of
										true-> %%判断玩家性别
											case check_sex(TD#tpl_task.gender,PS#player.gender) of
												true->
													%%判断前置任务
													case check_pre_task(TD#tpl_task.pre_tid,PS#player.id) of
														true->%%判断是否满足日常任务的触发条件
															case check_task_by_type(PS#player.id,Type) of
																true -> %%判断任务是否在可接时间段内
																	case check_time_limit(Type)of
																		true->true;
																		false->?TASK_TIME_LIMIT
																	end;
																false ->?DAILY_TASK_REJECT
															end;
														false->?PRE_TASK_UNFIN 
													end;
												false ->?TASK_WRONG_SEX 
											end;
										false->?TASK_WRONG_CAREER 
									end
							end
					end  
			end .  

%%获取指定日常完成任务
get_one_daily_task_fin(PlayerId,Type)->
	ets:lookup(?ETS_TASK_DAILY_FINISH, {PlayerId,Type}).

%%检测日常任务是否能触发,主线/支线忽略
check_task_by_type(PlayerId,Type) when Type =/= ?MAIN_TASK andalso Type =/=?BRANCHE_TASK-> 
   case get_one_daily_task_fin(PlayerId,Type) of
	   [TaskFin] when is_record(TaskFin,daily_task_finish) ->
		   case TaskFin#daily_task_finish.state of
			   0-> true;
			   _-> false
	end
   end;
check_task_by_type(_,_)->
	true.

%%检测现在是否在任务可接时间段中
 check_time_limit(Type)->
 	case task_detail:get(Type) of
		[]->
			?ERROR_MSG("no data in static data data_task with type ~p ~n",[Type]),
			false;
		Detail->
			do_check_time_limit(Detail#task_detail.time_limit,util:conver_time(time()))
	end.
%%进入检测时间限制逻辑
do_check_time_limit(TimeList,Now)->
	case TimeList of
		[]->true;
		_->
			lists:member(true,lists:map(fun(Time)->
												case Time of
													{Begin,End}->
														Now >= Begin andalso End >= Now;
													_->
														?ERROR_MSG("time data formater error~n",[]),
														false
												end
										end, TimeList))
	end.
	
%%判定玩家性别
check_sex(TaskSex,PlayerSex)->
	case TaskSex of
		?NULL_SEX->true;
		PlayerSex->true;
		_-> false end.

%%检测前置任务是否完成
check_pre_task(PreTask,PlayerId)->
	case PreTask of 
		-1->true;
		PreTaskId when is_integer(PreTaskId)->
			check_finish_data(PreTask,PlayerId);
		_->
			?WARNING_MSG("data error in pre_tid of ~p in temp_task",[PreTask]),
			false end.

%%在已完成任务列表中检测任务
check_finish_data(TaskId,PlayerId)->
	get_finish_role_data(TaskId,PlayerId).

%%检测任务是否在主/支线任务中
get_finish_role_data(TaskId,PlayerId)->
	case ets:lookup(?ETS_TASK_FINISH, PlayerId) of
		[Data] ->  
			lists:member(TaskId, Data#task_finish.td);
		[]->false end.

	 
%%判定玩家职业
check_career(TaskPro,PlayerPro)->
	case TaskPro of
		?NULL_CAREER -> true;
		PlayerPro ->true;
		_-> false end.

%% 判断主线/支线任务是否已触发过
check_if_in_trigger(TaskId, Rid,Type)when Type=:=?MAIN_TASK orelse Type=:=?BRANCHE_TASK->
	 ets:lookup(?ETS_TASK_PROCESS, {Rid, TaskId}) =/= [];
%%判断日常任务是否已触发过或是否满足同时最多触发任务个数 
check_if_in_trigger(TaskId, Rid,Type)-> 
	  case ets:lookup(?ETS_TASK_DAILY_FINISH, {Rid,Type}) of
		 [Data]->
			 case Data#daily_task_finish.state of 
				  ?CAN_TRIGGER-> 
				 	 ets:lookup(?ETS_TASK_PROCESS, {Rid, TaskId}) =/= [];
				  _->true
			 end;
			_->
				?WARNING_MSG("no task detial of player ~p in ~n",[{Rid,Type}]), 
				true
end.
%% 是否已在完成任务列表里
in_finish(TaskId, PlayerId)->
	case get_finish_task(PlayerId) of
		[] -> true;	%%无完成任务列表，说明玩家任务数据未正常加载，不让接任务的，不然在卡时可能会重复接做过的任务
		TF -> 
			lists:member(TaskId, TF#task_finish.td)
	end.

%%等级判定
check_lvl(TD,PS)->
	PS#player.level >= TD#tpl_task.level . 

%% 获取已完成任务
get_finish_task(PlayerId)   ->
	case ets:lookup(?ETS_TASK_FINISH, PlayerId) of
		[] ->[];
		[TF] -> TF
	end.   
%%添加角色任务判断处理逻辑
do_add_task(TD,PStatus)when TD#tpl_task.target_type =:= ?NPC_TALK_EVENT->
	add_task_process(TD,PStatus,1);
do_add_task(TD,PStatus)->
	add_task_process(TD,PStatus,0).
%%添加角色任务
add_task_process(TD,PStatus,State)->
	ResMark =  [TD#tpl_task.target_type|TD#tpl_task.target_property],
	TaskType = TD#tpl_task.type,
	Date = date(),
	NewRoleTask =  #task_process{id={PStatus#player.id, TD#tpl_task.tid},
								 uid=PStatus#player.id ,tid = TD#tpl_task.tid, 
								 trigger_time =Date, state=State,
								 mark = ResMark,type=TaskType },
	Data = [PStatus#player.id,TD#tpl_task.tid, State,util:unixtime(),TaskType,util:term_to_string(ResMark)],
	db_agent_task:insert_task_process_data(Data),
	insert_pid(TaskType,State,TD#tpl_task.tid),
	ets:insert(?ETS_TASK_PROCESS, NewRoleTask).

%-----------------------------
%    杀怪采集等更新任务进度
%-----------------------------   

%%统一任务事件调用接口
%%
%%参数 PlayerStatus：用户状态record 
%%     Event：任务事件类型（kill,item,npc....）
%%     Param: 事件参数 {对象ID,对象数量}
%%举例：
%%	    杀怪事件 call_event(PlayerStatus,kill,{MonId,MonNum}) 同采集事件
%%     	与npc对话事件 call_event(PlayerStatus,npc,{NpcId}) 同升级事件
%%      到指定副本层数事件 call_event(PlayerStatus,scene,{SceneId,FloorNum})
%%      天道令任务事件 call_event(PlayerStatus,scene,{})
%%      npc购物事件  call_event(PlayerStatus,npc_goods,{NpcId,ItemId,ItemNum})
%%
call_event(PlayerStatus,Event,Param)->
	gen_server:cast
	  (PlayerStatus#player.other#player_other.pid_task, {'task_event',PlayerStatus,Event,Param}).
%% 打怪事件成功
task_event(kill, MonInfo, PS) ->   
	upd_task_process(?KILL_EVENT, PS, MonInfo);
%%采集事件
task_event(item,ItemInfo,PS)->  
	upd_task_process(?COLLECT_EVENT, PS, ItemInfo) ;
%%商城购物
task_event(shopping,ItemInfo,PS)-> 
	upd_task_process(?SHOPPING_EVENT, PS, ItemInfo) ;
%%npc购物
task_event(npc_goods,ItemInfo,Ps)->
	upd_task_process(?NPC_GOODS_EVENT, Ps, ItemInfo) ;
%%npc对话事件
task_event(npc, Npc, PS)->  
	upd_task_process(?NPC_TALK_EVENT, PS, Npc);
%%升级事件
task_event(lv,Lv, PS)-> 
	upd_task_process(?LEVEL_EVENT, PS, Lv);
%%天道令事件
task_event(god_command,_, PS)-> 
	upd_task_process(?GOD_COMMAND_EVENT, PS, {});
%%到副本指定层数
task_event(scene,SceneInfo,Ps)->
	upd_task_process(?SCENE_EVENT, Ps, SceneInfo);
task_event(R1,R2,R3)->
	?INFO_MSG("miss ~p ~n",[{R1,R2,R3}]),
	skip.

%%获取所有未完成任务
get_all_unfinish_task(PlayerId)->  
	IdList =  get({daily_task_list, 0})++get({role_task_list, 0}),
	lists:map(fun(TaskId)->  
					  Res = ets:lookup(?ETS_TASK_PROCESS, {PlayerId,TaskId}),
					  case Res of
						  [Task] -> Task;
						  _->{TaskId} 
					  end
			   end,IdList). 

%%更新任务进度
upd_task_process(Type,Ps,ObjInfo) ->
	ResList =get_all_unfinish_task(Ps#player.id) , 
	case length(ResList) of
		0-> skip;
		_-> 
			F = fun(Task,Sum)-> %%匹配任务进度数据结构
					 	[_Type,Rest] = case Task#task_process.mark of
										   [Arg1,Arg2]->[Arg1,Arg2];
										   [Arg1]->[Arg1,-1];
										   _->[-1,-1]
									   end, 
						case _Type of
							Type ->   
								check_process_upd(Type,ObjInfo,Rest,Task,Sum,Ps);
							_->Sum 
						end 
				end ,
			Rest = lists:foldl(F, 0, ResList), 
			%%通知客户端更新对应的任务 
			call_back_task_process(Rest,30501,Ps) 
	end.

%----------------------------------
%    检查是否满足更新任务进度条件
%----------------------------------  

%%杀怪
check_process_upd(?KILL_EVENT,ObjInfo,MarkItem,Task,Sum,PS)->
	{MonId,_} = ObjInfo,
	case MarkItem of
		{MonId,_,_}->do_update(?KILL_EVENT, ObjInfo,Task,Sum,PS);  
		_-> Sum 
	end;
%%采集
check_process_upd(?COLLECT_EVENT,ObjInfo,MarkItem,Task,Sum,PS)-> 
	{ItemId,_} = ObjInfo,
	case MarkItem of
		{ItemId,_,_}->do_update(?COLLECT_EVENT, ObjInfo,Task,Sum,PS);  
		_-> Sum 
	end;
%%商城购物
check_process_upd(?SHOPPING_EVENT,ObjInfo,MarkItem,Task,Sum,PS)->
	{ItemId,_} = ObjInfo,
	case MarkItem of
		{ItemId,_,_}->do_update(?SHOPPING_EVENT, ObjInfo,Task,Sum,PS);  
		_-> Sum 
	end;
%%npc对话
check_process_upd(?NPC_TALK_EVENT,ObjInfo,MarkItem,Task,Sum,PS)->
	{NpcId} = ObjInfo,
	case MarkItem of
		{NpcId}->do_update(Task,Sum,PS);  
		_-> Sum 
	end;
%%到指定npc处购买指定商品
check_process_upd(?NPC_GOODS_EVENT,ObjInfo,MarkItem,Task,Sum,PS)->
	{NpcId,ItemId,_} = ObjInfo,
	case MarkItem of
		{NpcId,ItemId,_,_}->do_update(Task,Sum,PS);  
		_-> Sum 
	end;
%%升级
check_process_upd(?LEVEL_EVENT,ObjInfo,MarkItem,Task,Sum,PS)->
	{LV} = ObjInfo,
	case MarkItem of
		{LV}->do_update(Task,Sum,PS);  
		_-> Sum 
	end;
%%到达指定副本的指定层数
check_process_upd(?SCENE_EVENT,ObjInfo,MarkItem,Task,Sum,PS)->
	{SId,FloorNum} = ObjInfo,
	case MarkItem of
		{SId,FloorNum}->do_update(Task,Sum,PS);  
		_-> Sum 
	end;
%%npc天道令
check_process_upd(?GOD_COMMAND_EVENT,_,_,Task,Sum,PS)->
	do_update(Task,Sum,PS); 
check_process_upd(_,_,_,_,Sum,_)->
	Sum.
%%格式化并抽取task_progress中的数据
get_list_from_record(List)->
	if is_record(List, task_process_info) ->
		   {List#task_process_info.task_fin,List#task_process_info.task_unfinsh};
	   true->
		   {[],[]}end.

%%通知客户端更新对应的任务
call_back_task_process(0,_,_)->
	skip;
call_back_task_process(List,Proto,PS)-> 
	Len = length(List),
	case Len of
		0-> void;
		_->  
			case pt_30:write(Proto,[List,Len]) of
				{ok, Data} ->
					lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data);
				_ -> skip end end .

%%判断任务是自动完成还是更新进度(杀怪,采集等)
do_update(Type, ObjInfo,Task,Sum,PS) ->
	{_,ObjNum,FinNum,NowNum} = convert_mark_data(Type,ObjInfo,Task#task_process.mark),
	%%进入完成任务处理逻辑
	if ObjNum +NowNum >= FinNum ->
		  check_auto_fin(Type,Task,Sum,PS,FinNum);
	   true -> %%进入未完成任务处理逻辑  
		   upd_task_2_mem(Task,prase_mark_data(Type,Task#task_process.mark,ObjNum +NowNum),0),
		  util:make_list(Sum, {Task#task_process.tid,0,ObjNum +NowNum})
	end.
%%判断任务是自动完成还是更新进度(杀怪,采集等)
check_auto_fin(Type,Task,Sum,PS,FinNum)->
	case check_auto_finish_task(Task#task_process.tid, PS) of
		true-> 
			call_auto_fin_2_client(PS#player.other#player_other.pid_send,Task#task_process.tid),
			trigger_next_task(Task#task_process.tid,PS),
			Sum;
		false->
			 do_upd_task_process(Type,Task,FinNum,Sum);
		_->Sum
	end.

%%触发后置任务
trigger_next_task(TaskId,PS)->
	case tpl_task:get(TaskId) of
		TD when is_record(TD, tpl_task)->
				auto_trgger_task_one(TD#tpl_task.next_tid,PS);
		_->skip 
	end.

%%判断任务是自动完成还是更新进度(npc,升级)
do_update(Task,Sum,PS)->
	case check_auto_finish_task(Task#task_process.tid, PS) of
		true-> 
			call_auto_fin_2_client(PS#player.other#player_other.pid_send,Task#task_process.tid),
			trigger_next_task(Task#task_process.tid,PS),
			Sum;
		false->
			do_upd_task_process(Task,Sum);
		_->Sum
	end. 

%%执行更新任务进度操作(升级,和npc对话)
do_upd_task_process(Task,Sum)->
	%%进入完成任务处理逻辑  
	  upd_task_2_db_and_mem(Task,1), 
	  util:make_list(Sum,{Task#task_process.tid,1,0}).  

%%执行更新任务进度操作(杀怪,采集等)
do_upd_task_process(Type,Task,FinNum,Sum)-> 
		   upd_task_2_db_and_mem(Task,prase_mark_data(Type,Task#task_process.mark,FinNum),1),
		    util:make_list(Sum,{Task#task_process.tid,1,FinNum}). 

%%通知客户端有自动完成任务
call_auto_fin_2_client(PidSend,TaskId)->
	{ok,Data} = pt_30:write(30505, [TaskId]),
	lib_send:send_to_sid(PidSend, Data).

%%将不同类型任务转换为统一结构
convert_mark_data(?NPC_GOODS_EVENT,ObjInfo,Mark)->
	{_,ObjId,ObjNum} = ObjInfo,
	[_,{_,_,FinNum,NowNum}] = Mark,
	{ObjId,ObjNum,FinNum,NowNum};
convert_mark_data(_,ObjInfo,Mark)->
	{ObjId,ObjNum} = ObjInfo,
	[_,{_,FinNum,NowNum}] = Mark, 
	{ObjId,ObjNum,FinNum,NowNum}.
%%将不同类型任务转换为对应mark结构
prase_mark_data(?NPC_GOODS_EVENT,Mark,NewNum)->
	[_,{NpcId,ItemId,ItemNum,_}] = Mark,
	[?NPC_GOODS_EVENT,{NpcId,ItemId,ItemNum,NewNum}];
prase_mark_data(_,Mark,NewNum)->
	[Type,{ItemId,ItemNum,_}] = Mark,
	[Type,{ItemId,ItemNum,NewNum}]. 
%%检测自动完成任务
check_auto_finish_task(TaskId,PS)->
	case tpl_task:get(TaskId) of 
		TD when is_record(TD, tpl_task)->
		 	case TD#tpl_task.end_npc of 
				?TASK_AUTO_FIN_FLAG ->
					cast_player_give_goods(PS,TD#tpl_task.goods_list),
					do_finish(TD,PS#player.id,0,local),
					true;
				_->false 
			end;
		_->false
	end.
%%委托玩家进程给玩家赠送任务奖励
cast_player_give_goods(PS,GoodList)->
	gen_server:cast(PS#player.other#player_other.pid, {give_present,GoodList}).

%%更新任务进度到内存
upd_task_2_mem(Task,NewMark,NewState)->
	ets:insert(?ETS_TASK_PROCESS, Task#task_process{ mark = NewMark, state  = NewState}).
upd_task_2_mem(Task,NewState)->
	ets:insert(?ETS_TASK_PROCESS, Task#task_process{ state  = NewState}).

%%分别更新任务进度到内存与数据库
upd_task_2_db_and_mem(Task,NewMark,NewState)-> 
	upd_task_in_pid(Task#task_process.tid,Task#task_process.type),
	upd_task_2_mem(Task,NewMark,NewState),
	db_agent_task:upd_task_process_data([NewState,util:term_to_string(NewMark),Task#task_process.uid,Task#task_process.tid]).
upd_task_2_db_and_mem(Task,NewState)->
	upd_task_in_pid(Task#task_process.tid,Task#task_process.type),
	upd_task_2_mem(Task,NewState),
	db_agent_task:upd_task_process_data([NewState,Task#task_process.uid,Task#task_process.tid]).

%%当任务满足完成条件时更新进程字典
upd_task_in_pid(TaskId,Type)when Type=:=?MAIN_TASK orelse Type=:=?BRANCHE_TASK->
	UnFinish =get({role_task_list,0}),
	put({role_task_list,0},lists:delete(TaskId, UnFinish)),
	Finish = get({role_task_list,1}),
	put({role_task_list,1},Finish++[TaskId]);
upd_task_in_pid(TaskId,_)->
	UnFinish =get({daily_task_list,0}),
	put({daily_task_list,0},lists:delete(TaskId, UnFinish)),
	Finish = get({daily_task_list,1}),
	put({daily_task_list,1},Finish++[TaskId]).

%-----------------------------
%         玩家完成任务 
%----------------------------- 

%%在ets表中检测该任务状态
check_task_in_trigger(TaskId,PlayerId)->  
	case ets:lookup(?ETS_TASK_PROCESS, {PlayerId,TaskId}) of
		[Task] when is_record(Task, task_process)->
			case Task#task_process.state of
				%%该任务未完成
				0 -> {false,?TASK_UNFINISH};
				1->true 
			end;
		%%角色没有触发任务
		_-> 
			?INFO_MSG("task not in trigger ~p ~n",[ {PlayerId,TaskId}]),
			{false,?TASK_NOT_IN_PROCESS}
	end.

%%检测任务完成函数
finish_task(TaskId,PS)-> 
	case tpl_task:get(TaskId) of
		Task when is_record(Task, tpl_task)->
			case check_task_in_trigger(Task#tpl_task.tid,PS#player.id) of
				true->
					case do_player_get_goods(Task#tpl_task.goods_list,PS) of
						NewPs when is_record(NewPs, player)-> 
							do_finish(Task,PS#player.id,1,remote),  
							auto_trgger_task_one(Task#tpl_task.next_tid,PS), 
							%%完成任务后更新可接任务
							refresh_active(PS),
							{true,NewPs};
						R->
							?ERROR_MSG("give task award to player fail ~p ~n",[R]),
							{false,?GET_GOOD_FAIL}
					end;
				Other->
					Other 
			end;
		%%该任务不存在
		_->{false,?TASK_NOT_EXIT}
	end.
	
%%处理用户获取任务奖励逻辑
do_player_get_goods(GoodList,PS)->  
	case parse_good_list(GoodList,PS) of
		AvailableList when length(AvailableList) >0 ->  
	 		%%这里到时候要多调用物品模块的一个接口
 		Result = goods_util:send_goods_and_money(AvailableList, PS, ?LOG_GOODS_TASK),
			Result;
		_->
			skip
	end. 

%%解析任务奖励物品列表
parse_good_list(List,PS) when is_list(List)->  
	F = fun(Goods)->
			{_,_,ItemId,ItemNum} = Goods,
			{ItemId,ItemNum}
	end,
		[F(Item)||Item<-List,parse_one_good(Item,PS)].
 
%-----------------------------
%     解析ets任务奖励数据  
%-----------------------------
parse_one_good({?NULL_TASK_FLAG,_,ItemId,ItemNum},_)->  
	true;
parse_one_good({?CAREER_TASK_FLAG,ItemCareer,ItemId,ItemNum},PS)-> 
	if ItemCareer =:=PS#player.career-> true;
	   ItemCareer =:= 0 -> true;
	   true->  false
	end;
parse_one_good(_,_)->
	false.

%%执行完成任务逻辑 State:任务状态
do_finish(Task,PlayerId,State,CallType)-> 
	ets:delete(?ETS_TASK_PROCESS, {PlayerId,Task#tpl_task.tid}),
	case ets:lookup(?ETS_ONLINE, PlayerId) of
		[]->skip;
		[PS]-> 
			do_del_dict(CallType,State,Task,PS)
	end,
	spawn(db_agent_task,syn_db_task_bag_delete,[[PlayerId,Task#tpl_task.tid]]),
	do_normal_finish(Task,PlayerId).

%%在进程字典中删除任务判断逻辑,是本地调用还是跨进程
do_del_dict(local,State,Task,_)->  
	del_finish_task(Task#tpl_task.type,Task#tpl_task.tid,State);
do_del_dict(remote,State,Task,PS)->
	gen_server:cast(PS#player.other#player_other.pid_task,
							{'del_dict',{Task#tpl_task.type,Task#tpl_task.tid,State}}).

%%角色任务完成逻辑
do_normal_finish(Task,PlayerId)when Task#tpl_task.type=:=?BRANCHE_TASK orelse Task#tpl_task.type=:=?MAIN_TASK->
	TaskFinish = get_finish_task(PlayerId),
	NewTaskFin = upd_finish_task(TaskFinish,Task#tpl_task.level,Task#tpl_task.tid),
	ets:insert(?ETS_TASK_FINISH, NewTaskFin),
	db_agent_task:save_finish_task(NewTaskFin, Task#tpl_task.level);
do_normal_finish(Task,PlayerId) ->
	case get_one_daily_task_fin(PlayerId, Task#tpl_task.type) of
		[TD]->  
			{CanTri,FinTri,NowTri} = TD#daily_task_finish.trigger_detail,
			NewTriDetail = util:term_to_string({CanTri,FinTri,NowTri-1}),
			case TD#daily_task_finish.state of
				?OUT_OF_MAX->
					ets:insert(?ETS_TASK_DAILY_FINISH, TD#daily_task_finish{
																			state = 0,   
																			trigger_detail = {CanTri,FinTri,NowTri-1} 
																		   }),
					db_agent_task:upd_daily_task_fin_total_state([TD#daily_task_finish.total+1,NewTriDetail,TD#daily_task_finish.uid]);
				_->
					ets:insert(?ETS_TASK_DAILY_FINISH, TD#daily_task_finish{
																			trigger_detail = {CanTri,FinTri,NowTri-1} 
																		   }),
					db_agent_task:upd_daily_task_fin_total([TD#daily_task_finish.total+1,NewTriDetail,TD#daily_task_finish.uid])
			end;
		_->skip
	end.


%%在进程字典中删除任务 State:任务状态
del_finish_task(Type,TaskId,State)when Type =:= ?BRANCHE_TASK orelse Type=:=?MAIN_TASK->
	RoleTask = get({role_task_list,State}),
	put({role_task_list,State},lists:delete(TaskId, RoleTask));
del_finish_task(_,TaskId,State) ->
	DailyTask = get({daily_task_list,State}), 
	put({daily_task_list,State},lists:delete(TaskId, DailyTask)).

%%重新格式化内存中的已完成任务
upd_finish_task(TF, Level, TaskId) ->
	if 
		Level < 11 ->
			List = [TaskId | TF#task_finish.td1],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td1 = List, td = List1};
		Level < 21 ->
			List = [TaskId | TF#task_finish.td2],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td2 = List, td = List1};
		Level < 31 ->
			List = [TaskId | TF#task_finish.td3],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td3 = List, td = List1};
		Level < 41 ->
			List = [TaskId | TF#task_finish.td4],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td4 = List, td = List1};
		Level < 51 ->
			List = [TaskId | TF#task_finish.td5],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td5 = List, td = List1};
		Level < 61 ->
			List = [TaskId | TF#task_finish.td6],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td6 = List, td = List1};
		Level < 71 ->
			List = [TaskId | TF#task_finish.td7],
			List1 = [TaskId | TF#task_finish.td],
			NewTF = TF#task_finish{td7 = List, td = List1};
		true ->
			NewTF = TF
	end, 
	NewTF.		


%%在ets中获取单条任务数据
get_one_task_process(TId,PlayerId)->
	case ets:lookup(?ETS_TASK_PROCESS, {PlayerId,TId}) of
		[Task] when is_record(Task, task_process)->
			Task;
		[]->null end. 

%-----------------------------
%     更新可接任务列表
%-----------------------------

%% 更新角色可接任务 
refresh_active(PS) -> 
	MainActiveTids = [TD#tpl_task.tid || TD<- tpl_task:get_by_type(0), check_trigger_condition(TD, PS,0)],
	BtanchActiveTids =[TD#tpl_task.tid ||  TD<-tpl_task:get_by_type(1), check_trigger_condition(TD, PS,1)]  , 
	IdList = MainActiveTids++BtanchActiveTids,  
	ets:insert(?ETS_TASK_QUERY_CACHE, {PS#player.id, IdList}),	
	TriId = auto_trgger_task(IdList,PS),	 
	call_auto_task_2_player(PS,TriId,30501).
 

%%通知客户端服务器已为客户端自动触发任务
call_auto_task_2_player(PS,List,Proto)when is_list(List)->
	Len = length(List),
	case Len of
		0->skip;
		_->
	case pt_30:write(Proto,[List,Len]) of
		{ok, Data} ->
			lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data);
		_ -> 
			?ERROR_MSG("make proto ~p error ~n",[Proto]),
			skip 
		end
	end;
call_auto_task_2_player(_,_,_)->
	[].
 
%%检测自动触发任务(列表)
auto_trgger_task(IdList,PS)-> 
	lists:foldl(fun(TaskId,TaskList)->
						case tpl_task:get(TaskId) of
							Task when is_record(Task, tpl_task)-> 
								if Task#tpl_task.start_npc =:=?TASK_AUTO_TRIG_FLAG ->
									   add_task_process(Task,PS,TaskId),  
									   util:make_list(TaskList,{TaskId,?TASK_AUTO_TRIGGER,0}); 
								   true ->
									   TaskList
								end;
							[]-> TaskList
						end 
					end, 0, IdList).

%%检测自动后置触发任务
auto_trgger_task_one(TaskId,PS)-> 
	case tpl_task:get(TaskId) of
		Task when is_record(Task, tpl_task)->  
				   case check_trigger_condition(Task, PS,Task#tpl_task.type) of
					   true ->
						   add_task_process(Task,PS,TaskId),  
						   case  pt_30:write(30501,[{TaskId,?TASK_AUTO_TRIGGER,0},1]) of
							   {ok,Data} ->
								   lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data);
							   _->?WARNING_MSG("make proto 30501 error ~n",[])
						   end;
					   _->
						   skip 
				   end; 
		_->skip
	end.

%-----------------------------
%     玩家退出逻辑
%----------------------------- 

%%玩家退出
player_exit(PlayerId)->
	 do_unfin_data(PlayerId),
	 do_fin_data(PlayerId),
	 do_daily_fin(PlayerId),
	 ets:delete(?ETS_TASK_QUERY_CACHE,PlayerId),
	 ets:delete(?ETS_TASK_FINISH,PlayerId).

%%完成日常任务逻辑
do_daily_fin(PlayerId)->
	AllType = ?ALL_TASK_TYPE,
	lists:foreach(fun(Type)->
						  ets:delete(?ETS_TASK_DAILY_FINISH,{PlayerId,Type})
				  end, AllType).

%%未完成任务逻辑
do_unfin_data(PlayerId)->
    List = get({role_task_list,0})++get({daily_task_list,0}),
     lists:foreach(fun(TaskId)->
	case ets:lookup(?ETS_TASK_PROCESS, {PlayerId,TaskId}) of
		[Task] when is_record(Task,task_process) ->
			  	erlang:spawn(db_agent_task,upd_task_process_data,[[Task#task_process.state,util:term_to_string(Task#task_process.mark),Task#task_process.uid,Task#task_process.tid]]);
		_->skip end,
 		ets:delete(?ETS_TASK_PROCESS, {PlayerId,TaskId}) 
 			end
	, List). 

%%完成任务逻辑	
do_fin_data(PlayerId)->
	List = get({role_task_list,1})++get({daily_task_list,1}),
	lists:foreach(fun(TaskId)->
		ets:delete(?ETS_TASK_PROCESS, {PlayerId,TaskId})
			end
	, List). 
 
%-----------------------------
%         npc状态
%----------------------------- 

%%检测npc是否有可接任务
check_in_active(NpcId,PlayerId)->
	case ets:lookup(?ETS_TASK_QUERY_CACHE, PlayerId) of
		[{PlayerId,ActiveList}]->	
		 	Result = lists:foldl(fun(TaskId,Sum)->
										 case tpl_task:get(TaskId) of
											 Task when is_record(Task, tpl_task) ->
												 case Task#tpl_task.start_npc of
													 NpcId ->Sum+1;
													 _->Sum
												 end;
											 _-> Sum 
										 end
								  end, 0, ActiveList),
			if Result=/=0 ->
				   ?NPC_CAN_TRIGGER;
			   true ->
				   ?NPC_NO_TASK
				   end;
		_-> ?NPC_NO_TASK 
			end.
	
%%检测npc是否有未完成任务
check_in_trigger(NpcId)->
	List = get({role_task_list,0})++get({daily_task_list,0}),
	case check_npc_in_pid(List,NpcId) of
		true->?NPC_UNFIN_TASK;
		false -> ?NPC_NO_TASK;
		_-> ?ERROR_MSG("charge npc state error ~n",[]),
			?NPC_NO_TASK
			end.

%%检测npc是否有已完成任务
check_in_finish(NpcId)->
	List = get({role_task_list,1})++get({daily_task_list,1}),
	case check_npc_in_pid(List,NpcId) of
		true->?NPC_FINISH_TASK;
		false -> ?NPC_NO_TASK;
		_->?ERROR_MSG("charge npc state error ~n",[]),
		   ?NPC_NO_TASK
		   end. 

%%在进程字典中检测对应的npc状态
check_npc_in_pid(List,NpcId)->
	Result = lists:foldl(fun(TaskId,Sum)->
								 case tpl_task:get(TaskId) of
									 Task when is_record(Task, tpl_task) ->
										 case Task#tpl_task.end_npc of
											 NpcId ->Sum+1;
											 _->Sum
										 end;
									 _-> Sum
								 end
						  end, 0, List),
	Result=/=0. 

%%检查单个npc状态
 check_npc_state(NpcId,PlayerId)->
	Result = [?NPC_NO_TASK,check_in_trigger(NpcId),check_in_finish(NpcId),check_in_active(NpcId,PlayerId)],
	{NpcId,lists:max(Result)}.

%%接收npc列表,通知客户端所有npc的状态
check_npc_list_state(NpcList,PS)->
 	Result = lists:map(fun(NpcId)->
							   check_npc_state(NpcId,PS#player.id) end, NpcList),
	case length(Result) of
		0->skip;
		Len->
			case pt_30:write(30005,[Result,Len]) of
				{ok, Data} ->
					lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data);
				_->
					?WARNING_MSG("make data of proto 30005 error ~n",[])
					end
	end. 

%--------------------------------
%         获取npc任务数据
%--------------------------------
query_npc_task_info(NpcId,PS)->
	?INFO_MSG("show npc ~p ~n",[NpcId]),
	TriList = util:check_list(get_npc_in_data(NpcId,0)), 
	FinList = util:check_list(get_npc_in_data(NpcId,1)), 
	QueryList = util:check_list(get_npc_in_active(NpcId,PS#player.id)),
	?INFO_MSG("QueryList ~p ~n",[QueryList]),
	call_client_npc_info(TriList++FinList++QueryList,PS).

%%通知客户端npc任务数据
call_client_npc_info(List,PS)->
	{ok,Data} = pt_30:write(30008, [List]),
	lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data).

%%在可接任务中获取npc任务信息 ets_task_query_cache
get_npc_in_active(NpcId,PlayerId)->
	?INFO_MSG("get_npc_in_active ~p ~n",[{NpcId,PlayerId}]),
	case ets:lookup(?ETS_TASK_QUERY_CACHE, PlayerId) of
		[{PlayerId,List}]->get_npc_data_from_query(List,NpcId);
			_->[]
end.
	
%%获取npc任务信息
get_npc_in_data(NpcId,State)->
	List = get({role_task_list,State})++get({daily_task_list,State}),
 		get_npc_data_from_pid(List,NpcId,State).  

%%在进程字典中获取npc任务信息
get_npc_data_from_pid(List,NpcId,State)-> 
	lists:foldl(fun(TaskId,Sum)->
						case tpl_task:get(TaskId) of
							Task when is_record(Task, tpl_task)-> 
								case Task#tpl_task.end_npc of
									NpcId->
										util:make_list(Sum, {Task#tpl_task.tid,State});
									_->
										Sum
								end;
							_-> 
								Sum
						end
				end,0,List). 

%%从可接任务中获取npc任务信息
get_npc_data_from_query(List,NpcId)->
	lists:foldl(fun(TaskId,Sum)->
						case tpl_task:get(TaskId) of
							Task when is_record(Task, tpl_task)-> 
								case Task#tpl_task.start_npc of
									NpcId->
										util:make_list(Sum, {Task#tpl_task.tid,?TASK_CAN_TRIGGER});
									_->
										Sum
								end;
							_->
								Sum
						end
				end,0,List).                                                
%-------------------------------
%         任务查询函数
%-------------------------------

%%获取角色所有任务
get_all_task()->
	get({role_task_list,0})++get({role_task_list,1})++get({daily_task_list,0})++get({daily_task_list,1}).

%%获取玩家所有完成/未完成任务到客户端
get_all_task_2_client(PS,Size)->
	List = get_all_task(), 
    F=fun(_,{List,Result})-> 
			  [TaskId|Rest] = List,
					case ets:lookup(?ETS_TASK_PROCESS, {PS#player.id,TaskId}) of
						[Task]->
							{ok,{Rest,Result++
								[{TaskId,Task#task_process.state, get_mark_info(Task#task_process.mark)}]}};
						[]->{ok,{Rest,Result}}
					end 
	  end,  
	{ok,{_,Result}} = util:for(1, erlang:min(length(List), Size), F, {List, []}),
	case pt_30:write(30006,[Result,length(Result)]) of
				{ok, Data} -> 
					lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data);
				_->
					?WARNING_MSG("make data of proto 30006 error ~n",[])
					end .
%%获取任务进度参数
get_mark_info(Mark)->
	case Mark of
		[_,{_,_,NowNum}]-> NowNum;
		[_,{_}]-> 0;
		[_,{_,_}]->0;
		[_,{_,_,_,NowNum}]-> NowNum;
		Err->
			?ERROR_MSG("error task mark ~p in get_mark_info",[Err]),
			0
	end.
%-----------------------------
%   晚上12点重置玩家日常任务
%-----------------------------  

%%获取所有在线玩家的日常任务信息 
get_all_player()->
	ets:tab2list(?ETS_ONLINE).

%%重置所有日常任务
reset_all_daily_fin()->
	case get_all_player() of
		[]->skip;
		Data when is_list(Data) ->
			lists:foreach(fun(Player)->
								  reset_player_daily_task(Player) end, Data)
			  end.

%%重置玩家的日常任务
reset_player_daily_task(PS)->
	PlayerId = PS#player.id,
	Now = util:unixtime(),
	Result = lists:foldl(fun(Type,Sum)->
								 case get_one_daily_task_fin(PlayerId, Type) of
									 [Task]when is_record(Task,daily_task_finish) ->
										reset_one_daily_fin(Task,Now),
										{_,Type} =Task#daily_task_finish.uid,
									    util:make_list(Sum, Type);
									 []-> Sum
								 end
						 end, 0, ?ALL_TASK_TYPE),
	if is_list(Result) ->
		   case pt_30:write(30507,[Result,length(Result)]) of
			   {ok,Data} ->
				   lib_send:send_to_sid(PS#player.other#player_other.pid_send, Data);
			   _->
				   ?WARNING_MSG("make data of proto 30507 error ~n",[])
		   end;
	   true ->
		   skip 
	end.

%%重置单个日常任务
reset_one_daily_fin(Task,Now)->
	{FinCount,_} = Task#daily_task_finish.count_detail,                         
    {FinCyc,_}= Task#daily_task_finish.cycle_datil,      
	ets:insert(?ETS_TASK_DAILY_FINISH,Task#daily_task_finish{
														count_detail = 	{FinCount,0},
														cycle_datil = {FinCyc,0},
														state = 0
															 } ),
	db_agent_task:reset_daily_task_fin({FinCount,0},{FinCyc,0},Task#daily_task_finish.uid,Now).
%-----------------------------
%   消耗元宝自动完成任务
%-----------------------------   

%%通过任务id获取任务子表数据
get_task_detail_by_tid(TaskId)->
	case  tpl_task:get(TaskId) of
		Tpl when is_record(Tpl, tpl_task) ->
			case task_detail:get(Tpl#tpl_task.type) of
				Task when is_record(Task, task_detail) ->
					Task;
				_-> 
					?ERROR_MSG("no data in table task_detail ~n",[]),
					{false,?UNKNOW_ERROR}%任务不在任务模板子表
			end;
		_-> 
			?ERROR_MSG("no data in table temp_task ~n",[]),
			{false,?UNKNOW_ERROR}%任务模板不存在
	end.

%%消耗元宝自动完成任务
auto_finish_task_by_coin(PS,TaskId)->
	case ets:lookup(?ETS_TASK_PROCESS, {PS#player.id,TaskId}) of
		[_] ->
			case get_task_detail_by_tid(TaskId) of
				{false,Reason}->
					{false,Reason};
				Task->
					check_coin_auto_finish(Task#task_detail.coin,PS,TaskId)
			end;
		_->
			{false,?TASK_NOT_IN_PROCESS}
	end.
%%检测任务是否支持消耗元宝完成		
check_coin_auto_finish(Cost,PS,TaskId)->
		case Cost of
			0-> 
			{false,?NOT_COIN_TASK};
			Data ->
			do_coin_auto_finish(Data,PS,TaskId)
		end.

%%尝试消耗元宝完成任务（调用游戏币模块） 改逻辑
do_coin_auto_finish(Cost,PS,TaskId)->	 
	case lib_money:cost_money(statistic, PS, Cost, ?MONEY_T_GOLD, ?LOG_AUTO_FINISH_TASK) of
		NewPs1 when is_record(NewPs1, player)->   
			case do_coin_auto_success(NewPs1,TaskId) of
				NewPs2 when is_record(NewPs2,player)->
					{ok,NewPs2};
				_->
					?ERROR_MSG("give present to player fail ~n",[]),
					{ok, NewPs1}
			end;
		_->
			{false,?TASK_NOT_ENOUGH_COIN}
	end.

%%消耗元宝完成任务逻辑处理成功
do_coin_auto_success(PS,TaskId)->
	case tpl_task:get(TaskId) of
		[]->skip;
		Task->
			do_finish(Task,PS#player.id,1,remote),  
			auto_trgger_task_one(Task#tpl_task.next_tid,PS),
			do_player_get_goods(Task#tpl_task.goods_list,PS)
	end.
%------------------------------------
%   判断玩家采集的物品是否与任务有关
%------------------------------------ 

%%判断玩家采集的物品是否与指定任务有关
check_collect_task(TaskId,ItemId,PlayerId)->  
  case get_one_task_process(TaskId,PlayerId) of
	  null ->
		  ?WARNING_MSG("no task process~n",[]),
		  false;
	  Task -> 
		  case Task#task_process.mark of
			  [?COLLECT_EVENT,{ItemId,_,_}]->true;
			  _->  
				  false
		  end
  end.