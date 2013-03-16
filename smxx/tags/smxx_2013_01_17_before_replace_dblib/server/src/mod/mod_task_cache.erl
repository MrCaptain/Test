%%%------------------------------------
%%% @Module  : mod_task_cache
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 任务数据回写
%%%------------------------------------
-module(mod_task_cache).
-behaviour(gen_server).
-export(
    [
        start_link/0
        ,stop/0
        ,add_log/6
        ,del_log/2
        ,add_trigger/8
        ,upd_trigger/4
        ,del_trigger/2
        ,compress/2
        ,write_back/1,
		write_back_all/0
    ]
).
-compile(export_all).
-include("common.hrl").

%% -record(state, {id = 1, interval = 0, limit = 0, cache = []}).
%% 定时器1间隔时间
-define(TIMER_1, 60*1000).

%% 添加完成日志
add_log(Rid, Tid,Type, TriggerTime, FinishTime, Rgt) ->
	Data=[Rid, Tid, Type,TriggerTime, FinishTime, Rgt],
	erlang:spawn(db_log_agent,syn_db_task_log_insert,[Data]).
	%%erlang:spawn(fun()->catch(task_count(Rid, Tid))end).
%%     gen_server:cast(?MODULE, {log, Rid, Tid, [Rid, Tid, Type,TriggerTime, FinishTime]}).

%%  删除完成日志
del_log(Rid, Tid) ->
	Data = [Rid, Tid],
	erlang:spawn(db_agent,syn_db_task_log_delete,[Data]).
%%     gen_server:cast(?MODULE, {del_log, Rid, Tid, [Rid, Tid]}).

%% 添加触发
add_trigger(Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark,TaskType, Rgt) ->
	Data = [Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark,TaskType, Rgt],
	db_agent:syn_db_task_bag_insert(Data).
	%%erlang:spawn(db_agent,syn_db_task_bag_insert,[Data]).
    %%gen_server:cast(?MODULE, {add, Rid, Tid, [Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark,TaskType]}).

%% 更新任务记录器
upd_trigger(Rid, Tid, TaskState, TaskMark) ->
	Data = [TaskState, TaskMark, Rid, Tid],
	
	%%io:format("upd_trigger..~p/~n", [Data]),
	erlang:spawn(db_agent,syn_db_task_bag_update,[Data]).
    %%gen_server:cast(?MODULE, {upd, Rid, Tid, [TaskState, TaskMark, Rid, Tid]}).

%% 删除触发的任务
del_trigger(Rid, Tid) ->
	Data = [Rid, Tid],
	erlang:spawn(db_agent,syn_db_task_bag_delete,[Data]).
    %%gen_server:cast(?MODULE, {del, Rid, Tid, [Rid, Tid]}).

%% 立即回写单个玩家缓存
write_back(Rid) ->
    gen_server:cast(?MODULE, {'write_back',Rid}).

%%回写所有数据
write_back_all() ->
	gen_server:cast(?MODULE, {'write_back_all'}).

start_link()->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 关闭服务器时回调
stop() ->
    ok.

init([])->
	misc:write_monitor_pid(self(),?MODULE, {}),
	case  ?DB_MODULE =:= db_mysql of
		true->
    		erlang:send_after(10000, self(), syn_db);
		_->skip
	end,
	{ok,[task_cache]}.

%% 同步任务数据
syn_db([]) ->
    ok;
%%添加任务日志
syn_db([{log, _, _, Data} | List]) ->
%%     db_agent:syn_db_task_log_insert(Data),
	erlang:spawn(db_log_agent,syn_db_task_log_insert,[Data]),
    syn_db(List);

%%添加任务信息
syn_db([{add, _, _, Data} | List]) ->
%%     db_agent:syn_db_task_bag_insert(Data),
	erlang:spawn(db_agent,syn_db_task_bag_insert,[Data]),
	syn_db(List);

%%更新任务信息
syn_db([{upd, _, _, Data} | List]) ->
%%     db_agent:syn_db_task_bag_update(Data),
	erlang:spawn(db_agent,syn_db_task_bag_update,[Data]),
    syn_db(List);

%%删除任务信息
syn_db([{del, _, _, Data} | List]) ->
%%     db_agent:syn_db_task_bag_delete(Data),
	erlang:spawn(db_agent,syn_db_task_bag_delete,[Data]),
    syn_db(List);

%%删除任务日志
syn_db([{del_log, Rid, Tid, _} | List]) ->
    Data = [Rid, Tid],
%%     db_agent:syn_db_task_log_delete(Data),
	erlang:spawn(db_agent,syn_db_task_log_delete,[Data]),
    syn_db(List).

%% 数据压缩
compress([], Result) ->
    Result; %% 旧 -> 新

compress([{FirType, FirRid, FirTid, FirData} | T ], Result) ->
    R = lists:foldl(fun(X, R)-> compress(X, R) end, {FirType, FirRid, FirTid, FirData, []}, T),
    {_, _, _, _, Cache} = R,
    compress(lists:reverse(Cache), [{FirType, FirRid, FirTid, FirData} | Result]);
    
% compress({XType, XRid, XTid, XData}, {add, Rid, Tid, Data, Cache}) ->
%     case  XRid =:= Rid andalso XTid =:= Tid andalso XType =:= upd of
%         false -> {add, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
%         true -> {add, Rid, Tid, Data, Cache}
%     end;

compress({XType, XRid, XTid, XData}, {upd, Rid, Tid, Data, Cache}) ->
    case  XRid =:= Rid andalso XTid =:= Tid andalso XType =:= upd of
        false -> {upd, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
        true -> {upd, Rid, Tid, Data, Cache}
    end;

compress({XType, XRid, XTid, XData}, {del, Rid, Tid, Data, Cache}) ->
    case  XRid =:= Rid andalso XTid =:= Tid andalso (XType =:= upd orelse XType =:= add) of
        false -> {del, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
        true -> {del, Rid, Tid, Data, Cache}
    end;

%% 测试用
compress({XType, XRid, XTid, XData}, {del_log, Rid, Tid, Data, Cache}) ->
    case  XRid =:= Rid andalso XTid =:= Tid andalso XType =:= log of
        false -> {del_log, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
        true -> {del_log, Rid, Tid, Data, Cache}
    end;

compress(Elem, {Type, Rid, Tid, Data, Cache}) ->
    {Type, Rid, Tid, Data, [Elem | Cache]}.



%% %% 回写单个玩家数据到数据库
%% handle_cast({'write_back',PlayerId}, _State) ->
%%     NewCache = compress(get_task_cache(PlayerId), []), 
%%     syn_db(NewCache),
%% 	delete_task_cache(PlayerId),
%% 	{noreply,ok};
%% 
%% 
%% 
%% %%回写所有玩家数据到数据库
%% handle_cast({'write_back_all'}, _State) ->
%%     [save_player_task(PlayerId,TaskCache)||{PlayerId,TaskCache}<-get_task_cache_all()],
%% 	{reply,ok};
%% 
%% %% 将要更新的数据加入到缓存中
%% handle_cast(Elem, _State) ->
%% 	case ?DB_MODULE =:= db_mysql of
%% 		true->
%%    			{_,PlayId,_,_} = Elem,
%% 			TaskCache = get_task_cache(PlayId),
%% 			{noreply, insert_task_cache(PlayId,[Elem|TaskCache])};
%% 		_ ->
%% 			NewCache = compress([Elem], []), 
%%     		syn_db(NewCache), 
%% 			{noreply, ok}
%% 	end.
%% 
%% %% handle_cast(_Message,State)->
%% %% 	{noreply,State}.
%% 
%% handle_call(_Request, _From, State) ->
%%     {noreply, State}.
%% 
%% handle_info(syn_db, State) ->
%%     %% 开始异步回写
%%     spawn(
%%         fun() -> 
%% 			[save_player_task(PlayerId,TaskCache)||{PlayerId,TaskCache}<-get_task_cache_all()]
%%             %% ?DEBUG("需回写任务数据[~w]，压缩并回写[~w]", [length(State#state.cache), length(NewCache)]) 
%%         end
%% 		
%%     ),
%%     %% 再次启动闹钟
%%     erlang:send_after(?TIMER_1, self(), syn_db),
%% 	 {noreply, State};
%% %%     {noreply, State#state{cache = []}};
%% 
%% 
%% 
%% handle_info(_Info, State) ->
%%     {noreply, State}.
%% 
%% terminate(_Reason, _State) ->
%% 	io:format("~s terminate begined************  [~p]\n",[misc:time_format(now()), mod_task_cache]),
%% 	misc:delete_monitor_pid(self()),
%% 	io:format("~s terminate finished************  [~p]\n",[misc:time_format(now()), mod_task_cache]),
%%     ok.
%% 
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.
%% 
%% save_player_task(Id,Cache)->
%% 	NewCache = compress(Cache, []),
%% 	syn_db(NewCache),
%% 	delete_task_cache(Id).
%% 
%% 
%% %%成就系统任务统计
%% %% task_count(PlayerId,TaskId)->
%% %% 	if TaskId =:=70115 ->%%循环
%% %% 		   lib_chieve:check_achieve_finish(PlayerId, 18, [1]);
%% %% 	   true->
%% %% 		   Td = lib_task:get_data(TaskId),
%% %% 		   case lib_task:is_carry_task(Td) of%%运镖 12
%% %% 			   true->lib_chieve:check_achieve_finish(PlayerId, 12, [1]);
%% %% 			   false->
%% %% 				   case lib_task:is_dug_task(Td) of%%副本 7
%% %% 					   true->lib_chieve:check_achieve_finish(PlayerId, 7, [1]);
%% %% 					   false->
%% %% 						   case lib_task:is_guild_task(Td) of%%氏族 4
%% %% 							   true->lib_chieve:check_achieve_finish(PlayerId, 4, [1]);
%% %% 							   false->
%% %% 								   case lib_task:is_hero_task(Td) of%%封神贴 16
%% %% 									   true->lib_chieve:check_achieve_finish(PlayerId, 16, [1]);
%% %% 									   false->
%% %% 										   case lib_task:is_culture_task(Td) of%%修为
%% %% 											   true->lib_chieve:check_achieve_finish(PlayerId, 10, [1]);
%% %% 											   false->
%% %% 												   case lib_task:is_business_task(Td) of%%跑商
%% %% 													   true->lib_chieve:check_achieve_finish(PlayerId, 14, [1]);
%% %% 													   false->
%% %% 														   case lib_task:is_daily_pk_mon_task(Td) of%%日常打怪
%% %% 															   true->lib_chieve:check_achieve_finish(PlayerId, 14, [2]);
%% %% 															   false->
%% %% 														   			skip
%% %% 														   end
%% %% 												   end
%% %% 										   end
%% %% 								   end
%% %% 						   end
%% %% 				   end
%% %% 		   end
%% %% 	end.
%% %%**************缓存区操作**************%%
%% %% 获取单个玩家任务信息
%% get_task_cache(PlayerId) ->
%%     case ets:lookup(?ETS_TASK_CACHE, PlayerId) of
%%         [] ->[];
%%         [{_,TaskCache}] -> TaskCache
%%     end.
%% 
%% %%获取所有玩家任务信息
%% get_task_cache_all()->
%%    	ets:tab2list(?ETS_TASK_CACHE).
%% 
%% insert_task_cache(PlayerId,Cache) ->
%% 	ets:insert(?ETS_TASK_CACHE, {PlayerId,Cache}).
%% 
%% delete_task_cache(PlayerId) ->
%% 	ets:match_delete(?ETS_TASK_CACHE,{PlayerId,_='_'}).