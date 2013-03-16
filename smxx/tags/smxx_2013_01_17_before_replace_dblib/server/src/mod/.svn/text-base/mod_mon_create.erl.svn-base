%%%------------------------------------
%%% @Module  : mod_mon_create
%%% @Author  : ygzj
%%% @Created : 2010.10.06
%%% @Description: 生成所有怪物进程
%%%------------------------------------
-module(mod_mon_create).
-behaviour(gen_server).
-export(
 	[
		start_link/0, 
		create_mon/1,		
		clear_scene_mon/1
	]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").
-record(state, {auto_id}).

%% 创建怪物
create_mon([MonId, Scene, X, Y, Type, Other]) ->
    gen_server:call(?MODULE, {create, [MonId, Scene, X, Y, Type, Other]}).

%% 清除场景怪物
clear_scene_mon(SceneId)->
    gen_server:call(?MODULE, {clear_scene_mon, SceneId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
	misc:write_monitor_pid(self(), ?MODULE, {}),	
    State = #state{
		auto_id = 1
	},
    {ok, State}.

handle_cast(_R , State) ->
    {noreply, State}.

%% %% Type 0静态生成，1动态BOSS技能生成
%% handle_call({create, [MonId, SceneId, X, Y, Type, Other]} , _FROM, State) ->
%% 	NewAutoId = 
%%    		case State#state.auto_id > ?MON_LIMIT_NUM of
%% 			true ->
%% 		   	    1;
%% 	   		false -> 
%%                 State#state.auto_id
%%         end,
%% 	[MonPid, RetAutoId] = 
%%         case data_agent:mon_get(MonId) of
%%             [] ->
%%                 [undefined, NewAutoId];
%%             Minfo ->
%%                 case Minfo#ets_mon.type == 3 orelse Minfo#ets_mon.type == 5 orelse Minfo#ets_mon.type ==  8 orelse Minfo#ets_mon.type >= 10 of
%%                     %% BOSS怪
%%                     true ->
%% 						%% 雷泽分线不生成野外BOSS
%% 						case Minfo#ets_mon.type == 3 andalso (SceneId == 190 orelse SceneId == 191) of
%% 							false ->
%%                                 case Minfo#ets_mon.relation of
%%                                     %% 生命共享怪
%%                                     [1, ShareMonId] ->
%%                                         NewAutoId1 = NewAutoId + 1,
%%                                         NewAutoId2 = NewAutoId + 2,
%%                                         case mod_mon_boss_active:start([Minfo, NewAutoId1, SceneId, X, Y, 3, NewAutoId2]) of
%%                                             {ok, Pid} ->
%%                                                 case data_agent:mon_get(ShareMonId) of
%%                                                     [] ->
%%                                                         skip;
%%                                                     ShareMinfo ->
%%                                                         mod_mon_boss_active:start([ShareMinfo, NewAutoId2, SceneId, X + 4, Y + 4, 3, NewAutoId1])
%%                                                 end,										
%%                                                 [Pid, NewAutoId2];
%%                                             _ ->
%%                                                 [undefined, NewAutoId]
%%                                         end;
%%                                     _ ->
%%                                         NAutoId = NewAutoId + 1,
%%                                         case mod_mon_boss_active:start([Minfo, NAutoId, SceneId, X, Y, Type, Other]) of
%%                                             {ok, Pid} ->
%%                                                 [Pid, NAutoId];
%%                                             _ ->
%%                                                 [undefined, NewAutoId]
%%                                         end
%%                                 end;
%% 							true ->
%% 								[undefined, NewAutoId]	
%% 						end;
%%                     false ->
%% 						NAutoId = NewAutoId + 1,
%%                         case mod_mon_active:start([Minfo, NAutoId, SceneId, X, Y, Type]) of
%%                             {ok, Pid} ->
%%                                 [Pid, NAutoId];
%%                             _ ->
%%                                 [undefined, NewAutoId]
%%                         end
%%                 end
%%         end,
%%     NewState = State#state{
%% 		auto_id = RetAutoId
%% 	},
%%     {reply, {ok, RetAutoId, MonPid}, NewState};
%% 
%% %% 清除场景mon
%% handle_call({clear_scene_mon, SceneId}, _From, State) ->
%%     L = ets:match(?ETS_SCENE_MON, #ets_mon{pid = '$1', scene = SceneId, _ = '_'}),
%%     [Pid ! clear|| [Pid] <- L, misc:is_process_alive(Pid)],
%%     {reply, true, State};

handle_call(_R , _FROM, State) ->
    {reply, ok, State}.

handle_info(_Reason, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

code_change(_OldVsn, State, _Extra)->
	{ok, State}.
