%%%------------------------------------
%%% @Module  : mod_mine
%%% @Author  : csj
%%% @Created : 2012.10.06
%%% @Description:  copper mine system
%%%------------------------------------
-module(mod_mine).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile([export_all]).
-include("common.hrl").
-include("record.hrl").

%% timer 
-record(state, {}).	
%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
    %%gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
	gen_server:start_link({local, ?MODULE}, ?MODULE, {?MODULE, 0}, []) .

start_link({ProcessName,SceneId}) ->
	gen_server:start_link({local, ProcessName},?MODULE, {ProcessName,SceneId}, []) .

stop() ->
    gen_server:call(?MODULE, stop).

%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------

init({ProcessName,SceneId}) ->
	process_flag(trap_exit, true),
	if 
		SceneId =:= 0 ->
			misc:write_monitor_pid(self(), mod_mine, {0}),
			case misc:register(local, ?MODULE, self()) of       
				yes ->
					%% create module ets
					%% load mine related scene
					lists:foreach(
					  fun(BSId) ->
							  AgentWorkerName = misc:create_process_name(?MODULE, [agent,BSId]),
							  mod_mine:start_link({AgentWorkerName, BSId})
					  end,lists:seq(1,10));
				_ ->
					skip
			end ;
		true -> 
			misc:register(local, ProcessName, self()),
			misc:write_monitor_pid(self(),mod_mine, {SceneId})
	end,
	
	State= #state{},		
	{ok, State}.
   

%%------------------------------------------------------------------
%%load guild guard process
%%spec get_mod_mine_pid -> pid
%%------------------------------------------------------------------
get_mod_mine_pid() ->
	case misc:whereis_name({local, ?MODULE}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;				
					false -> 
						start_mod_mine(?MODULE)
				end;
			_ ->
				start_mod_mine(?MODULE)
	end.

%%------------------------------------------------------------------
%%load guild guard process
%%spec get_mod_mine_pid -> pid
%%------------------------------------------------------------------
get_mod_mine_agent(SceneId) ->
	AgentWorkerName = misc:create_process_name(?MODULE, [agent,SceneId]),
	case misc:whereis_name({local, AgentWorkerName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;				
					false -> 
						get_mod_mine_pid()
				end;
			_ ->
				get_mod_mine_pid()
	end.


%%------------------------------------------------------------------
%%spec start_mod_mine -> pid
%%------------------------------------------------------------------
start_mod_mine(ProcessName) ->
	ProcessPid =
		case misc:whereis_name({local, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_mine(ProcessName)
				end;
			_ ->
				start_mine(ProcessName)
		end,	
	ProcessPid.

%%------------------------------------------------------------------
%%spec start_mine -> pid | undefined
%%------------------------------------------------------------------
start_mine(_ProcessName) ->
	case supervisor:start_child(
       		csj_server_sup, {mod_mine,
            		{mod_mine, start_link,[]},
               		permanent, 10000, supervisor, [mod_mine]}) of
		{ok, Pid} ->
			Pid;
		_ ->
			undefined
	end.
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({apply_call, Module, Method, Args}, _From, State) ->
	Reply  = 
		case (catch apply(Module, Method, Args)) of
			{'EXIT', _Reason} ->	
%% 				io:format("=====handle_call failed because: ~p=====",[Reason]),
				error;
			DataRet -> DataRet
		end,
    {reply, Reply, State}.


%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({apply_cast, Module, Method, Args}, State) ->
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_mine__apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State} .


handle_info(_Info, State) ->
    {noreply, State} .
%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
	misc:delete_system_info(self()),
    ok.
%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% --------------------------------------------------------------------
%% on_player_login
%% --------------------------------------------------------------------
on_player_login(Status) ->
	try 
		case gen_server:call(get_mod_mine_pid(),{apply_call, lib_mine, on_player_login,[Status]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49001 player enter fail for the reason:[~p]",[_Reason]),
			[0] 
	end .

%% --------------------------------------------------------------------
%% on_player_login
%% --------------------------------------------------------------------
on_player_logoff(UId,ScnId) ->
	try 
		case gen_server:call(get_mod_mine_pid(),{apply_call, lib_mine, on_player_logoff,[UId,ScnId]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49001 player enter fail for the reason:[~p]",[_Reason]),
			[0] 
	end .

%% --------------------------------------------------------------------
%% 49001 player_enter
%% --------------------------------------------------------------------
player_enter(Status,BaseScene) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, player_enter,[Status,BaseScene]}) of
			error ->
				[0,BaseScene] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49001 player enter fail for the reason:[~p]",[_Reason]),
			[0,BaseScene] 
	end .

%% --------------------------------------------------------------------
%% 49002 query_cart
%% --------------------------------------------------------------------
query_cart(UId,BaseScene) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, query_cart,[UId,BaseScene]}) of
			error ->
				[0,0,0,0,0,[]] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49002 query_cart fail for the reason:[~p]",[_Reason]),
			[0,0,0,0,0,[]] 
	end .
  
%% --------------------------------------------------------------------
%% 49003 get_copper_mines
%% --------------------------------------------------------------------
get_copper_miners(BaseScene,CopperId) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, get_copper_miners,[BaseScene,CopperId]}) of
			error ->
				[[],[]] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49003 get_copper_miners fail for the reason:[~p]",[_Reason]),
			[[],[]] 
	end .

%% --------------------------------------------------------------------
%% 49004 begin_exploit
%% --------------------------------------------------------------------
begin_exploit(UId,BaseScene,CopperId) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, begin_exploit,[UId,CopperId]}) of
			error ->
				[0,0,0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49004 begin_exploit fail for the reason:[~p]",[_Reason]),
			[0,0,0] 
	end .


%% --------------------------------------------------------------------
%% 49005 set_auto_draw
%% --------------------------------------------------------------------
set_auto_draw(UId,BaseScene,AutoDraw) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, set_auto_draw,[UId,BaseScene,AutoDraw]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49005 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[0] 
	end .


%% --------------------------------------------------------------------
%% 49006 stop_exploit
%% --------------------------------------------------------------------
stop_exploit(UId,BaseScene) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, stop_exploit,[UId,BaseScene]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49006 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[0] 
	end .

%% --------------------------------------------------------------------
%% 49007 fresh_cart
%% --------------------------------------------------------------------
fresh_cart(UId,BaseScene,FreshRatio,EngFlag) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, fresh_cart,[UId,BaseScene,FreshRatio,EngFlag]}) of
			error ->
				[0,0,0,0,0,0,0,[]] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49007 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[0,0,0,0,0,0,0,[]] 
	end .


%% --------------------------------------------------------------------
%% 49010 apply a new copper
%% --------------------------------------------------------------------
digge_apply(UId,Eng,BaseScene,CopperId) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, digge_apply,[UId,Eng,BaseScene,CopperId]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49010 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[0] 
	end .
	
%% --------------------------------------------------------------------
%% 49011 apply a new copper
%% --------------------------------------------------------------------
digge_authorize(MUId,BaseScene,UId,Flag) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, digge_authorize,[MUId,BaseScene,UId,Flag]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49010 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[0] 
	end .
	
%% --------------------------------------------------------------------
%% 49013 apply list
%% --------------------------------------------------------------------
apply_list(UId,BaseScene) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, apply_list,[UId,BaseScene]}) of
			error ->
				[] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49013 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[] 
	end .
	
	
%% --------------------------------------------------------------------
%% 49013 apply list
%% --------------------------------------------------------------------
digge_list(UId,BaseScene) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, digge_list,[UId,BaseScene]}) of
			error ->
				[] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49014 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[] 
	end .
	
	
%% --------------------------------------------------------------------
%% 49014 apply list
%% --------------------------------------------------------------------	
draw_cart(UId,BaseScene,Status) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, draw_cart,[UId,BaseScene,Status]}) of
			error ->
				[0,0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49014 set_auto_draw fail for the reason:[~p]",[_Reason]),
			[0,0] 
	end .
	

%% --------------------------------------------------------------------
%% 49015 set_dig_class
%% --------------------------------------------------------------------
set_dig_class(UId,BaseScene,Class)	->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, set_dig_class,[UId,BaseScene,Class]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49015 set_dig_class fail for the reason:[~p]",[_Reason]),
			[0] 
	end .
	
%% --------------------------------------------------------------------
%% 49016 kick_digger
%% --------------------------------------------------------------------
kick_digger(MUId,BaseScene,UId) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, kick_digger,[MUId,BaseScene,UId]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49015 set_dig_class fail for the reason:[~p]",[_Reason]),
			[0] 
	end .
	
  
%% --------------------------------------------------------------------
%% 49020 launch_fight
%% --------------------------------------------------------------------
launch_fight(BaseScene,CUId,CEng,CopperId,MUId,LBattleRecord,RBattleRecord) ->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, launch_fight,[BaseScene,CUId,CEng,CopperId,MUId,LBattleRecord,RBattleRecord]}) of
			error ->
				[0,0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49015 set_dig_class fail for the reason:[~p]",[_Reason]),
			[0,0] 
	end .
	
			
			
%% --------------------------------------------------------------------
%% 49030 player_leave
%% --------------------------------------------------------------------
player_leave(UId,BaseScene,Status) 	->
	try 
		case gen_server:call(get_mod_mine_agent(BaseScene),{apply_call, lib_mine, player_leave,[UId,BaseScene,Status]}) of
			error ->
				[0] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("49015 set_dig_class fail for the reason:[~p]",[_Reason]),
			[0] 
	end .

	

	