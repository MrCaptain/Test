%%%-----------------------------------
%%% @Module  : game_gateway_app
%%% @Author  : csj
%%% @Created : 2010.08.18
%%% @Description: 启动网关应用
%%%-----------------------------------
-module(game_gateway_app).
-behaviour(application).
-export([start/2, stop/1]).   
-include("common.hrl"). 

start(_Type, _Args) ->
	ets:new(?ETS_SYSTEM_INFO, [set, public, named_table]),
	ets:new(?ETS_MONITOR_PID, [set, public, named_table]),
	ets:new(?ETS_STAT_SOCKET, [set, public, named_table]),
	ets:new(?ETS_STAT_DB, [set, public, named_table]),
	
	[Port, _Acceptor_num, _Max_connections] = config:get_tcp_listener(gateway),
	[Ip] = config:get_tcp_listener_ip(gateway),

	Log_level = config:get_log_level(gateway), 
	loglevel:set(tool:to_integer(Log_level)),	
	
	main:init_db(gateway),
	
    game_gateway_sup:start_link([Ip, tool:to_integer(Port)]).
%% 	game_timer:start(game_gateway_sup).
  
stop(_State) ->   
    void.
