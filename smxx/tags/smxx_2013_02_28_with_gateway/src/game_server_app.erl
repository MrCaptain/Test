%%%-----------------------------------
%%% @Module  : game_server_app
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 游戏服务器应用启动
%%%-----------------------------------
-module(game_server_app).
-behaviour(application).
-export([start/2, stop/1]).
-include("common.hrl").
-include("record.hrl").

start(normal, []) ->    
    ping_gateway(),
    
    ets:new(?ETS_SYSTEM_INFO, [set, public, named_table]),
    ets:new(?ETS_MONITOR_PID, [set, public, named_table]),
    ets:new(?ETS_STAT_SOCKET, [set, public, named_table]),
    ets:new(?ETS_STAT_DB, [set, public, named_table]),
    
    [Port, Node_id, _Acceptor_num, _Max_connections] = config:get_tcp_listener(server),
    [Ip] = config:get_tcp_listener_ip(server),
    Log_level = config:get_log_level(server),
    loglevel:set(tool:to_integer(Log_level)),    
    {ok, SupPid} = game_server_sup:start_link(),
    game_timer:start(game_server_sup),
    game_server:start(
                  [Ip, tool:to_integer(Port), tool:to_integer(Node_id)]
                ),
    {ok, SupPid}.
  
stop(_State) ->   
    void. 

ping_gateway()->
    case config:get_gateway_node(server) of
        undefined -> no_action;
        Gateway_node ->    
            catch net_adm:ping(Gateway_node)
    end.



