%%%-----------------------------------
%%% @Module  : pt_60
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 60 网关
%%%-----------------------------------
-module(pt_60).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%% 请求服务器列表
read(60000, <<Accid:32, Tstamp:32, Bin/binary>>) ->
	{Accname, _R} = pt:read_string(Bin),
%% io:format("60000 get_____________________~p ~n",[[0]]),
    {ok, [Accid,Tstamp, Accname]};


%% 是否有角色
read(60001, <<_Sn:16, Bin/binary>>) ->
    {Accname, _} = pt:read_string(Bin),
    {ok, [ Accname]};


read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%% 服务器列表
write(60000, []) ->
    {ok, pt:pack(0, <<>>)};
write(60000, [List]) ->
    Rlen = length(List),
    F = fun({ServId, Domain, ServName, ServIp, ServPort, State, Crrer, Sex, Level, Nick}) ->
				{ServNameLen,ServNameBin} = tool:pack_string(ServName) ,
				{NickLen,NickBin} = tool:pack_string(Nick) ,
				{ServIpLen,ServIpBin} = tool:pack_string(ServIp) ,
				<<ServId:16,Domain:16,ServNameLen:16,ServNameBin/binary,ServIpLen:16,ServIpBin/binary,ServPort:16,State:8, Crrer:8, Sex:8, Level:16, NickLen:16,NickBin/binary>> 
    end,
    RB = tool:to_binary([F(D) || D <- List]),
    {ok, pt:pack(60000, <<Rlen:16, RB/binary>>)};


%% 是否有角色
write(60001, Is) ->
    {ok, pt:pack(60001, <<Is:8>>)};

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.
