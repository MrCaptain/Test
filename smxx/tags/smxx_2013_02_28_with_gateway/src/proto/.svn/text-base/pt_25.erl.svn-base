%%%------------------------------------
%%% @Module  : pt_25
%%% @Author  : csj
%%% @Created : 2011.08.15
%%% @Description: 经脉协议
%%%------------------------------------

-module(pt_25).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%查看穴道信息
read(25000, <<>>) ->
    {ok, []};

%%穴道升级
read(25001, <<MerID:8>>) ->
    {ok, MerID};

%%晶石修炼
read(25002, <<StoneType:32>>) ->
	{ok, StoneType};

read(25003,_) ->
	{ok,cooldown};

%%批量晶石修炼
read(25004, <<StoneType:32>>) ->
	{ok, StoneType};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%查看穴道信息
write(25000,[MerList, Clv,ResTime,ResFlag])->
	MerListLen = length(lists:delete([],MerList)),
	Data = 
		try
    		F = 
				fun([MerId, Merlv, MerState]) ->
            			<<MerId:8, Merlv:8, MerState:8>>
    				end,
    	LB = tool:to_binary([F(X) || X <- MerList, X /= []]),
		<<MerListLen:16, LB/binary>>
	catch
		_:_ -> 
			?WARNING_MSG("25000 List[~p],Num[~p]", [MerList, MerListLen]),
			<<0:16, <<>>/binary>>
	end,
	{ok,pt:pack(25000, <<Data/binary, Clv:32,ResTime:32,ResFlag:8>>)};

%%查看穴道升级
write(25001,[MeridianId, Result])->
	{ok,pt:pack(25001, <<MeridianId:8,Result:8>>)};

%%晶石修炼
write(25002,[Result, Clv,Restime])->
	{ok,pt:pack(25002, <<Result:8, Clv:32,Restime:32>>)};

write(25003,R) ->
%% 	?DEBUG("25003 ~p",[R]),
	{ok,pt:pack(25003,<<R:8>>)};

%%批量晶石修炼
write(25004, [Res, GoodTypeId, Num, ClvAdd, Restime])->
	{ok,pt:pack(25004, <<Res:8, GoodTypeId:32, Num:8, ClvAdd:16, Restime:16>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.
