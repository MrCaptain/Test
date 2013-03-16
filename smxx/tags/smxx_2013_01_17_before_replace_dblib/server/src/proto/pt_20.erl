%%%-----------------------------------
%%% @Module  : pt_20
%%% @Author  : csj
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
read(20001, <<MonGId:32, DungId:32>>) ->
    {ok, [MonGId, DungId]};

%%人打人
read(20002, <<Id:32>>) ->
    {ok, [Id]} ;


%% -----------------------------------------------------------------
%% 多人副本战斗,修改了协议输入
%% -----------------------------------------------------------------
read(20003, <<Flag:8>>) ->
    {ok, [Flag]};

%%战斗怪物物品掉落拾取
read(20006, _Req) ->
	{ok, []};

%%获取单个物品
read(20007, <<GoodsId:32>>) ->
	{ok, [GoodsId]};

%%获取战斗冷却时间
read(20008, _R) ->
	{ok, []};

%%清除冷却时间
read(20010,_R) ->
	{ok,[]};

%%挑战者打BOSS
read(20011,<<MonGrpId:32>>) ->
	{ok,[MonGrpId]};

%%挑战者打守护者
read(20012,<<RPlayerId:32>>) ->
	{ok,[RPlayerId]};

%%联盟战战斗协议
read(20013,<<FortId:32,RPlayerId:32,BClazz:8>>) ->
	{ok,[FortId,RPlayerId,BClazz]};

%%守护联盟战战斗协议
read(20015,_R) ->
	{ok,[]};

read(20021,_R) ->
	{ok,[]};

read(20022,<<Id:32>>) ->
	{ok,[Id]};

read(20031, _R) ->
	{ok,[]};

read(20032, _R) ->
	{ok,[]};

read(20033, _R) ->
	{ok,[]};

read(_Cmd, _R) ->
    {error, no_match}.
%% 
%% -----------------------------------------------------------------
%% 多人副本战斗返回
%% -----------------------------------------------------------------
write(20003, [Code]) ->
    Data = <<Code:8>>,
    {ok, pt:pack(20003, Data)};

%%战斗怪物物品掉落全部拾取
write(20006, [Code]) ->
	Data = <<Code:8>>,
    {ok, pt:pack(20006, Data)};

%%战斗怪物物品掉落单个拾取
write(20007, [Code]) ->
	Data = <<Code:8>>,
    {ok, pt:pack(20007, Data)};

write(20010, [Res]) ->
    {ok, pt:pack(20010, <<Res:8>>)};

write(20021, [Res]) ->
	{Id, LName, RName} = Res,
	LNameBin = tool:to_binary(LName),
	LNameBinLen = byte_size(LNameBin),
	RNameBin = tool:to_binary(RName),
	RNameBinLen = byte_size(RNameBin),
	AllBin = <<1:8, Id:32, LNameBinLen:16, LNameBin/binary, RNameBinLen:16, RNameBin/binary>>,
	{ok, pt:pack(20021, AllBin)};

write(20022, [Res]) ->
	[ResBin, WarMod, RId] = Res,
	{ok, pt:pack(20022, <<1:8, WarMod:8, RId:32, ResBin/binary>>)};

write(20031, BossGoodsList) ->
	GoodsLen = length(BossGoodsList),
	if GoodsLen > 0 ->
		   Fun = fun(GoodsM) ->
						  {GoodsId, _GoodsRadio, GoodsMinNum, _GoodsMaxNum} = GoodsM,
						  <<GoodsId:32, 0:32, GoodsMinNum:32, 0:8>>
				  end,
		   BossGoodsBinList = lists:map(Fun, BossGoodsList),
		   BossGoodsBin = list_to_binary(BossGoodsBinList),
		   BossGoodsBinAll = <<GoodsLen:16, BossGoodsBin/binary>>;
	   true ->
		   BossGoodsBinAll = <<0:16>>
	end,
	{ok, pt:pack(20031, BossGoodsBinAll)};

write(_Cmd, _R) ->
    {ok, pt:pack(0, <<>>)}.


%% %% 复活
%% %% @param Type 复活类型，1高级复活，2中级复活（普通稻草人），3安全复活
%% read(20004, <<Type:8>>) ->
%%     {ok, Type};
%% 
%% %% 使用辅助技能
%% read(20006, <<Id:32, SkillId:32>>) ->
%%     {ok, [Id, SkillId]};
%% 
%% %%采集
%% read(20100,<<MonId:32>>)->
%% 	{ok,[MonId]};
%% 
%% %%取消采集
%% read(20102,<<MonId:32>>)->
%% 	{ok,[MonId]};
%% 
%% read(_Cmd, _R) ->
%%     {error, no_match}.
%% 
%% %%
%% %%服务端 -> 客户端 ------------------------------------
%% %%
%% 
%% %% 广播战斗结果 - 玩家VS怪物
%% write(20001, [Id, Hp, Mp, Sid, Slv, X, Y, DefList]) ->
%%     Data1 = <<Id:32, Hp:32, Mp:32, Sid:32, Slv:8, X:16, Y:16>>,
%%     Data2 = def_list(DefList),
%%     Data = <<Data1/binary, Data2/binary>>,
%%     {ok, pt:pack(20001, Data)};
%% 
%% %% 广播战斗结果 - 怪物PK玩家
%% write(20003, [Id, Hp, Mp, Sid, Slv, X, Y, DefList]) ->
%%     Data1 = <<Id:32, Hp:32, Mp:32, Sid:32, Slv:8, X:16, Y:16>>,
%%     Data2 = def_list(DefList),
%%     Data = <<Data1/binary, Data2/binary>>,
%%     {ok, pt:pack(20003, Data)};
%% 
%% %% 复活
%% write(20004, Res) ->
%%     {ok, pt:pack(20004, <<Res:8>>)};
%% 
%% %% 战斗失败
%% write(20005, [State, Sign, UserId]) ->
%%     Data = <<State:8, Sign:8, UserId:32>>, 
%%     {ok, pt:pack(20005, Data)};
%% 
%% %% 广播战斗结果 - 辅助技能
%% write(20006, [Id, Sid, Slv, MP, DerInfo]) ->
%%     Data1 = <<Id:32, Sid:32, Slv:8, MP:32>>,
%%     Data2 = assist_list(DerInfo),
%%     Data = << Data1/binary, Data2/binary>>,
%%     {ok, pt:pack(20006, Data)};
%% 
%% %% 更改战斗状态
%% %% Sign 信号，1进入战斗状态，2脱离战斗状态
%% write(20007, Sign) ->
%%     {ok, pt:pack(20007, <<Sign:8>>)};
%% 
%% %% 更改蓝名状态
%% %% PlayerId 玩家ID
%% %% Sign 信号，1进入战斗状态，2脱离战斗状态
%% write(20008, [PlayerId, Sign]) ->
%%     {ok, pt:pack(20008, <<PlayerId:32, Sign:8>>)};
%% 
%% %% 更改玩家速度
%% %% PlayerId 玩家ID
%% %% Speed 速度
%% %% Sign 1怪、2人
%% write(20009, [PlayerId, Speed]) ->
%% 	{ok, pt:pack(20009, <<PlayerId:32, Speed:16>>)};
%% 
%% %% 战斗时同步玩家坐标
%% %% PlayerId 玩家ID
%% %% Sign 1怪、2人
%% %% x X坐标
%% %% y Y坐标
%% write(20010, [PlayerId, Sign, X, Y]) ->
%% 	{ok, pt:pack(20010, <<PlayerId:32, Sign:8, X:16, Y:16>>)};
%% 
%% %% 移除场景怪物
%% %% MonId 怪物ID
%% write(20011, MonId) ->
%% 	{ok, pt:pack(20011, <<MonId:32>>)};
%% 
%% %%采集
%% write(20100,[Result])->
%% 	{ok,pt:pack(20100,<<Result:16>>)};
%% 
%% %%取消采集
%% write(20102,[MonId])->
%% 	{ok,pt:pack(20102,<<MonId:32>>)};
%% 
%% %% 持续范围伤害广播
%% write(20103, [X, Y, Last, SkillId])->
%% 	{ok,pt:pack(20103, <<X:16, Y:16, Last:16, SkillId:32>>)};
%% 
%% %% %%区域广播采集信息
%% %% write(20101, [PlayerId,MonType,MonId,MonHp]) ->
%% %%     Data = <<PlayerId:32,MonType:16, MonId:32, MonHp:32>>,
%% %%     {ok, pt:pack(20101, Data)};
%% 
%% write(Cmd, _R) ->
%% ?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
%%     {ok, pt:pack(0, <<>>)}.
%% 
%% def_list([]) ->
%%     <<0:16, <<>>/binary>>;
%% def_list(DefList) ->
%%     Rlen = length(DefList),
%%     F = fun([Sign, Id, Hp, Mp, HpHurt, MpHurt, S]) ->
%%   		<<Sign:8, Id:32, Hp:32, Mp:32, HpHurt:32, MpHurt:32, S:8>>
%%     end,
%%     RB = tool:to_binary([F(D) || D <- DefList]),
%%     <<Rlen:16, RB/binary>>.
%% 
%% assist_list([]) ->
%%     <<0:16, <<>>/binary>>;
%% assist_list(List) ->
%%     Rlen = length(List),
%%     F = fun([Id, Hp]) ->
%%         <<Id:32, Hp:32>>
%%     end,
%%     RB = tool:to_binary([F(D) || D <- List]),
%%     <<Rlen:16, RB/binary>>.
