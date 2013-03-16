%%%-----------------------------------
%%% @Module  : game_gateway_sup
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 网关监控树
%%%-----------------------------------
-module(game_gateway_sup).
-behaviour(supervisor).
-export([start_link/1]).
-export([init/1]).
-include("common.hrl").

start_link([Ip, Port, Node_id]) ->
	supervisor:start_link({local,?MODULE}, ?MODULE, [Ip, Port, Node_id]).

init([Ip, Port, Node_id]) ->
    {ok,
        {
            {one_for_one, 3, 10},
            [
                {
                    game_gateway,
                    {game_gateway, start_link, [Port]},
                    permanent,
                    10000,
                    supervisor,
                    [game_gateway]
                },
                {
                    mod_disperse,
                    {mod_disperse, start_link,[Ip, Port, Node_id]},
                    permanent,
                    10000,
                    supervisor,
                    [mod_disperse]
%%                 },
%%                 {
%%                     mod_police,
%%                     {mod_police, start_link, []},
%%                     permanent,
%%                     10000,
%%                     supervisor,
%%                     [mod_police]
                }
            ]
        }
    }.
