%% Author: Administrator
%% Created: 2012-3-10
%% Description: TODO: Add description to pt_23
-module(pt_23).
-export([read/2, write/2]).
-include("common.hrl").
-include("record.hrl").

%%
%% API Functions
%%
%%
%%客户端 -> 服务端 ------------------------------------------------------------
%%

%%查询称号列表信息
read(23000, _) ->
%%     io:format("read: ~p~n",[23000]),
    {ok, []};

%%启用称号
read(23003, <<TitleId:32>>) ->
    {ok, [TitleId]};

%%启用称号
read(23004, <<TitleId:32>>) ->
    {ok, [TitleId]};

read(_Cmd, _R) ->
	%%io:format("read: ~p~n",[[_Cmd, _R]]),
	{error, no_match}.


%%
%%服务端 -> 客户端 -------------------------------------------------------------
%%

%%返回称号列表信息
write(23000, [Res, TitleList]) ->
%% 	io:format("write23000, Res:~p, TitleList:~p~n",[Res, TitleList]),
	ListNum = length(TitleList),
	F = fun(Title) ->
				{Tid, State, Time, Num, Seq} = Title,
				<<Tid:32, State:8, Time:32, Num:32, Seq:8>>
		end,
   	ListBin = tool:to_binary(lists:map(F, TitleList)),
	{ok, pt:pack(23000, <<Res:8, ListNum:16, ListBin/binary>>)};

%%服务器发送新获得称号
write(23001, [Tid, Time]) ->
%% 	io:format("write23001, Tid:~p, Time:~p~n",[Tid, Time]),
	{ok, pt:pack(23001, <<Tid:32, Time:32>>)};

%%服务器发送称号过期
write(23002, [Tid, Num]) ->
%% 	io:format("write23002, Tid:~p~n",[Tid]),
	{ok, pt:pack(23002, <<Tid:32, Num:32>>)};

%%返回启用称号结果
write(23003, [Res, Time]) ->
%% 	io:format("write23003, Res:~p, Time:~p~n",[Res, Time]),
	{ok, pt:pack(23003, <<Res:32, Time:32>>)};

%%返回停用称号结果
write(23004, [Res]) ->
%% 	io:format("write23004, Res:~p, Time:~p~n",[Res, Time]),
	{ok, pt:pack(23004, <<Res:32>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.
%%
%% Local Functions
%%

