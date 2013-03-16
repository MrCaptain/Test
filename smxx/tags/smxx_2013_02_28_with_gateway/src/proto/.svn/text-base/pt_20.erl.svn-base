%%%-----------------------------------
%%% @Module  : pt_20
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 20战斗信息
%%%-----------------------------------
-module(pt_20).
-export([read/2, write/2]).
-include("common.hrl").
%%
%%客户端 -> 服务端 ----------------------------
%%

%%人打怪
read(20001, <<Id:32, SkillId:32>>) ->
    {ok, [Id, SkillId]};

%%人打人
read(20002, <<Id:64, SkillId:32>>) ->
    {ok, [Id, SkillId]};

%% 复活
%% @param Type 复活类型，1高级复活，2中级复活（普通稻草人），3安全复活
read(20004, <<Type:8>>) ->
    {ok, Type};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%% 广播战斗结果 - 玩家VS怪物
write(20001, [Id, Hp, Mp, Sid, Slv, X, Y, DefList]) ->
    Data1 = <<Id:64, Hp:32, Mp:32, Sid:32, Slv:8, X:8, Y:8>>,
    Data2 = def_list(DefList),
    Data = <<Data1/binary, Data2/binary>>,
    {ok, pt:pack(20001, Data)};

%% 广播战斗结果 - 怪物PK玩家
write(20003, [Id, Hp, Mp, Sid, Slv, X, Y, DefList]) ->
    Data1 = <<Id:32, Hp:32, Mp:32, Sid:32, Slv:8, X:8, Y:8>>,
    Data2 = def_list(DefList),
    Data = <<Data1/binary, Data2/binary>>,
    {ok, pt:pack(20003, Data)};

%% 复活
write(20004, Res) ->
    {ok, pt:pack(20004, <<Res:8>>)};

%% 战斗失败
write(20005, [State, UserId]) ->
    Data = <<State:8, UserId:64>>, 
    {ok, pt:pack(20005, Data)};

write(Cmd, _R) ->
    {ok, pt:pack(0, <<>>)}.

def_list([]) ->
    <<0:16, <<>>/binary>>;
def_list(DefList) ->
    Rlen = length(DefList),
    F = fun({Type, Id, Hp, Mp, HpHurt, MpHurt, Status}) ->
		case Type =:= ?ELEMENT_PLAYER of
			true -> <<Type:8, Id:64, Hp:32, Mp:32, HpHurt:32, MpHurt:32, Status:8>>;
			false -> <<Type:8, Id:32, Hp:32, Mp:32, HpHurt:32, MpHurt:32, Status:8>>
		end
    end,
    RB = tool:to_binary([F(D) || D <- DefList]),
    <<Rlen:16, RB/binary>>.