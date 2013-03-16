%%--------------------------------------
%% @Module: pt_13
%% Author: Auto Generated
%% Created: Mon Feb 18 19:27:48 2013
%% Description: 
%%--------------------------------------
-module(pt_13).

%%--------------------------------------
%% Include files
%%--------------------------------------
-include("common.hrl").
-include("record.hrl").

%%--------------------------------------
%% Exported Functions
%%--------------------------------------
-compile(export_all).


%%--------------------------------------
%%Protocol: 13000 玩家自身信息(FULL)
%%--------------------------------------
read(13000, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13001 查询玩家自身信息(基本)
%%--------------------------------------
read(13001, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13002 查看其他玩家
%%--------------------------------------
read(13002,<<Uid:64>>) ->
    {ok, [Uid]};

%%--------------------------------------
%%Protocol: 13003 更新玩家信息(战斗力)
%%--------------------------------------
read(13003, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13004 更新玩家战斗信息(基本)
%%--------------------------------------
read(13004, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13005 更新玩家信息(金钱)
%%--------------------------------------
read(13005, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13006 关键常用玩家信息(金钱,经验)
%%--------------------------------------
read(13006, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13010 刷新属性
%%--------------------------------------

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 13000 玩家自身信息(FULL)
%%--------------------------------------
write(13000,[Uid,Gender,Level,Career,Camp,Vip,Icon,SceneId,X,Y,Liveness,Exp,ExpMax,Lilian,Gold,BGold,Coin,BCoin,Hp,HpMax,Combopoint,CombopointMax,Magic,MagicMax,Anger,AngerMax,Attack,Defense,Abs_damage,Fattack,Mattack,Dattack,Fdefense,Mdefense,Ddefense,Speed,Attack_speed,Hit_ratio,Dodge_ratio,Crit_ratio,Tough_ratio,Frozen_resis_ratio,Weak_resis_ratio,Flaw_resis_ratio,Poison_resis_ratio,Ignore_defense,Ignore_fdefense,Ignore_mdefense,Ignore_ddefense,Name,Weapon, Armor, Fashion, WwaponAcc, Wing, Mount, WeaponStrenLv, ArmorStrenLv, FashionStrenLv, WaponAccStrenLv, WingStrenLv]) ->
    Name_StrBin = pack_string(Name),
    {ok, pt:pack(13000, <<Uid:64,Gender:8,Level:8,Career:8,Camp:8,Vip:8,Icon:8,SceneId:16,X:8,Y:8,Liveness:16,Exp:32,ExpMax:32,Lilian:32,Gold:32,BGold:32,Coin:32,BCoin:32,Hp:32,HpMax:32,Combopoint:8,CombopointMax:8,Magic:32,MagicMax:32,Anger:32,AngerMax:32,Attack:32,Defense:32,Abs_damage:32,Fattack:32,Mattack:32,Dattack:32,Fdefense:32,Mdefense:32,Ddefense:32,Speed:8,Attack_speed:8,Hit_ratio:16,Dodge_ratio:16,Crit_ratio:16,Tough_ratio:16,Frozen_resis_ratio:16,Weak_resis_ratio:16,Flaw_resis_ratio:16,Poison_resis_ratio:16,Ignore_defense:32,Ignore_fdefense:32,Ignore_mdefense:32,Ignore_ddefense:32,Name_StrBin/binary, Weapon:32, Armor:32, Fashion:32, WwaponAcc:32, Wing:32, Mount:32, WeaponStrenLv:8, ArmorStrenLv:8, FashionStrenLv:8,WaponAccStrenLv:8, WingStrenLv:8>>)};

%%--------------------------------------
%%Protocol: 13001 查询玩家自身信息(基本)
%%--------------------------------------
write(13001,[Uid,Gender,Level,Career,Speed,SceneId,X,Y,Hp,HpMax,Exp,ExpMax,Gold,BGold,Coin,BCoin,Name]) ->
    Name_StrBin = pack_string(Name),
    {ok, pt:pack(13001, <<Uid:64,Gender:8,Level:8,Career:8,Speed:8,SceneId:16,X:8,Y:8,Hp:32,HpMax:32,Exp:32,ExpMax:32,Gold:32,BGold:32,Coin:32,BCoin:32,Name_StrBin/binary>>)};

%%--------------------------------------
%%Protocol: 13002 查看其他玩家
%%--------------------------------------
write(13002,[StCode]) ->
    {ok, pt:pack(13002, <<StCode:8>>)};
write(13002,[StCode,OnlineFlag,Uid,Gender,Level,Career,Camp,Vip,Icon,SceneId,X,Y,Liveness,Exp,ExpMax,Lilian,Gold,BGold,Coin,BCoin,Hp,HpMax,Combopoint,Magic,MagicMax,Anger,AngerMax,Attack,Defense,Abs_damage,Fattack,Mattack,Dattack,Fdefense,Mdefense,Ddefense,Speed,Attack_speed,Hit_ratio,Dodge_ratio,Crit_ratio,Tough_ratio,Name]) ->
    Name_StrBin = pack_string(Name),
    {ok, pt:pack(13002, <<StCode:8,OnlineFlag:8,Uid:64,Gender:8,Level:8,Career:8,Camp:8,Vip:8,Icon:8,SceneId:16,X:8,Y:8,Liveness:16,Exp:32,ExpMax:32,Lilian:32,Gold:32,BGold:32,Coin:32,BCoin:32,Hp:32,HpMax:32,Combopoint:8,Magic:32,MagicMax:32,Anger:32,AngerMax:32,Attack:32,Defense:32,Abs_damage:32,Fattack:32,Mattack:32,Dattack:32,Fdefense:32,Mdefense:32,Ddefense:32,Speed:8,Attack_speed:8,Hit_ratio:16,Dodge_ratio:16,Crit_ratio:16,Tough_ratio:16,Name_StrBin/binary>>)};

%%--------------------------------------
%%Protocol: 13003 更新玩家信息(战斗力)
%%--------------------------------------
write(13003,[Exp,ExpMax,Hp,HpMax,Combopoint,CombopointMax,Magic,MagicMax,Anger,AngerMax,Attack,Defense,Abs_damage,Fattack,Mattack,Dattack,Fdefense,Mdefense,Ddefense,Speed,Attack_speed,Hit_ratio,Dodge_ratio,Crit_ratio,Tough_ratio]) ->
    {ok, pt:pack(13003, <<Exp:32,ExpMax:32,Hp:32,HpMax:32,Combopoint:8,CombopointMax:8,Magic:32,MagicMax:32,Anger:32,AngerMax:32,Attack:32,Defense:32,Abs_damage:32,Fattack:32,Mattack:32,Dattack:32,Fdefense:32,Mdefense:32,Ddefense:32,Speed:8,Attack_speed:8,Hit_ratio:16,Dodge_ratio:16,Crit_ratio:16,Tough_ratio:16>>)};

%%--------------------------------------
%%Protocol: 13004 更新玩家战斗信息(基本)
%%--------------------------------------
write(13004,[Hp,HpMax,Combopoint,CombopointMax,Magic,MagicMax,Anger,AngerMax]) ->
    {ok, pt:pack(13004, <<Hp:32,HpMax:32,Combopoint:8,CombopointMax:8,Magic:32,MagicMax:32,Anger:32,AngerMax:32>>)};

%%--------------------------------------
%%Protocol: 13005 更新玩家信息(金钱)
%%--------------------------------------
write(13005,[Gold,BGold,Coin,BCoin]) ->
    {ok, pt:pack(13005, <<Gold:32,BGold:32,Coin:32,BCoin:32>>)};

%%--------------------------------------
%%Protocol: 13006 关键常用玩家信息(金钱,经验)
%%--------------------------------------
write(13006,[Exp,Lilian,Coin,BCoin,BGold]) ->
    {ok, pt:pack(13006, <<Exp:32,Lilian:32,Coin:32,BCoin:32,BGold:32>>)};

%%--------------------------------------
%%Protocol: 13010 刷新属性
%%--------------------------------------
write(13010,[Code]) ->
    {ok, pt:pack(13010, <<Code:8>>)};

%%--------------------------------------
%% undefined command 
%%--------------------------------------
write(Cmd, _R) ->
    ?ERROR_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%%------------------------------------
%% internal function
%%------------------------------------
pack_string(Str) ->
    BinData = tool:to_binary(Str),
    Len = byte_size(BinData),
    <<Len:16, BinData/binary>>.

any_to_binary(Any) ->
    tool:to_binary(Any).

