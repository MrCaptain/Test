%%%------------------------------------
%%% @Module     : mod_misc
%%% @Author     : 
%%% @Created    : 2011.08.22
%%% @Description: 杂项处理进程
%%%------------------------------------
-module(mod_misc).
-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).

%% 定时器间隔时间(每24小时)
-define(TIMER, 24*3600).

%% 杂项处理进程信息表    
-record(state, {}).

start_link() -> %%启动服务
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%动态加载杂项处理进程
get_mod_misc_pid() ->
    ProcessName = mod_misc_process,
    case misc:whereis_name({local, ProcessName}) of
            Pid when is_pid(Pid) ->
                case misc:is_process_alive(Pid) of
                    true -> 
                        Pid;
                    false -> 
                        start_mod_misc(ProcessName)
                end;
            _ ->
                start_mod_misc(ProcessName)
    end.

%%启动杂项处理模块 (加锁保证全局唯一)
start_mod_misc(ProcessName) ->
    global:set_lock({ProcessName, node()}),
    ProcessPid =
        case misc:whereis_name({local, ProcessName}) of
            Pid when is_pid(Pid) ->
                case misc:is_process_alive(Pid) of
                    true -> 
                        Pid;
                    false -> 
                        start_misc()
                end;
            _ ->
                start_misc()
        end,    
    global:del_lock({ProcessName, node()}),
    ProcessPid.

%%启动杂项处理模块
start_misc() ->
    case supervisor:start_child(
           game_server_sup, {mod_misc,
                    {mod_misc, start_link,[]},
                       permanent, 10000, supervisor, [mod_misc]}) of
        {ok, Pid} ->
                timer:sleep(1000),
                Pid;
        _ ->
                undefined
    end.

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) -> 
    process_flag(trap_exit, true),
    ProcessName = mod_misc_process,        %% 多节点的情况下， 仅启用一个杂项处理进程
     case misc:register(local, ProcessName, self()) of
        yes ->
            misc:write_monitor_pid(self(),?MODULE, {}),
            misc:write_system_info(self(), mod_misc, {}),  
            State = #state{}, 
            Now = util:unixtime(),
            {_TodayNidNight, NextMidNight} = util:get_midnight_seconds(Now),  
            SecToNextDay = max(1, NextMidNight - Now), 
            %%半夜十二点通知玩家进程
            erlang:send_after(SecToNextDay*1000, self(), midnight),
            {ok, State};
        _ ->
            {stop,normal,#state{}}
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
%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, State) ->
    Reply  = 
    case (catch apply(Module, Method, Args)) of
         {'EXIT', Info} ->    
             ?WARNING_MSG("mod_misc__apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
             error;
         DataRet -> DataRet
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 统一模块+过程调用(cast)
handle_cast({apply_cast, Module, Method, Args}, State) ->
    case (catch apply(Module, Method, Args)) of
         {'EXIT', Info} ->    
             ?WARNING_MSG("mod_misc__apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
             error;
         _ -> ok
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 半夜十二点处理
handle_info(midnight, State) -> 
    erlang:send_after(?TIMER * 1000, self(), midnight), 
    spawn(fun() -> notice_midnight() end),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.


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

%%=========================================================================
%% 业务处理函数
%%=========================================================================
notice_midnight() ->
    UserList = ets:tab2list(?ETS_ONLINE),
    F = fun(User) ->
         case misc:is_process_alive(User#player.other#player_other.pid) of
             true  -> gen_server:cast(User#player.other#player_other.pid, midnight);
             false -> skip
         end
    end,
    lists:foreach(F, UserList).
