%%%------------------------------------
%%% @Module  :
%%% @Author  :
%%% @Created :
%%% @Description: 宠物
%%%------------------------------------

-module(pt_25).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%获取宠物信息
read(25001, <<>>) ->
    {ok, []};

%%宠物展示
read(25002, <<MerID:8>>) ->
    {ok, MerID};

%%宠物名称更改
read(25003, <<StoneType:32>>) ->
	{ok, StoneType};

read(25003,_) ->
	{ok,cooldown};

%%宠物休息/参战
read(25004, <<StoneType:32>>) ->
	{ok, StoneType};

%%洗髓
read(25005, <<StoneType:32>>) ->
	{ok, StoneType};

%%幻化
read(25006, <<StoneType:32>>) ->
	{ok, StoneType};

%%进阶
read(25007, <<StoneType:32>>) ->
	{ok, StoneType};

%%成长进化
read(25008, <<StoneType:32>>) ->
	{ok, StoneType};

%%提示资质
read(25009, <<StoneType:32>>) ->
	{ok, StoneType};

%%刷新技能书
read(25010, <<StoneType:32>>) ->
	{ok, StoneType};

%%获得技能书
read(25011, <<StoneType:32>>) ->
	{ok, StoneType};

%%封印
read(25012, <<StoneType:32>>) ->
	{ok, StoneType};

%% 删除宠物技能
read(25013, <<StoneType:32>>) ->
	{ok, StoneType};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%获取宠物信息
write(25001,[MeridianId, Result])->
	{ok,pt:pack(25001, <<MeridianId:8,Result:8>>)};

%%宠物展示
write(25002,[Result, Clv,Restime])->
	{ok,pt:pack(25002, <<Result:8, Clv:32,Restime:32>>)};

%%宠物名称更改
write(25003,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%宠物休息/参战
write(25004, [Res, GoodTypeId, Num, ClvAdd, Restime])->
	{ok,pt:pack(25004, <<Res:8, GoodTypeId:32, Num:8, ClvAdd:16, Restime:16>>)};

%%洗髓
write(25005, R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%幻化
write(25006, R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%进阶
write(25007,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%成长进化
write(25008,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%提示资质
write(25009,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%刷新技能书
write(25010,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%% 获得技能书
write(25011,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%封印
write(25012,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

%%删除宠物技能
write(25013,R) ->
	{ok,pt:pack(25003,<<R:8>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.
