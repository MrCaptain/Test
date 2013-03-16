%%%------------------------------------------------    
%%% File    : data_battle.erl    
%%% Author  : water
%%% Desc    : 战斗伤害计算参数公式
%%%------------------------------------------------
-module(data_battle).     
-compile(export_all).

-include("battle.hrl").
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%%断言以及打印调试信息宏
%%不需要时启用 -undefine行
%-define(battle_debug, 1).
-undefine(battle_debug).
-ifdef(battle_debug).
    -define(MYTRACE(Str), io:format(Str), ?INFO_MSG(Str, [])).
    -define(MYTRACE(Str, Args), io:format(Str, Args), ?INFO_MSG(Str, Args)).
-else.
    -define(MYTRACE(Str), void).
    -define(MYTRACE(Str, Args), void).
-endif.

%%向下取整,不小于0
round_down(Val) ->
    case Val > 0 of
        true  -> util:floor(Val);
        false -> 0
    end.

%%获取伤害值计算系数
get_coef(?BATTLE_TYPE_PVE) ->  %%玩家VS怪物
    [10000, 0.865, 0.5, 90000];
get_coef(?BATTLE_TYPE_PVP) -> %%玩家VS玩家
    [10000, 0.5, 0.865, 90000];
get_coef(_) ->            %%不知类型,随便算算
    [10000, 0.865, 0.5, 90000].

%%根据暴击等级(等)计算暴击系数
get_crit_coef(_) ->
    1.5.

%%伤害计算过程
%% Aer 攻方战斗属性
%% Der 守方战斗属性
%% SkillId, SkillLv 技能ID, 
%% 返回值: {伤害类型, 伤害值}
get_damage(BattleType, Aer, Der, SkillId, SkillLv) ->
     [Coef1, _Coef2, _Coef3, _Coef4] = get_coef(BattleType),
     case is_hit(Aer#battle_attr.hit_ratio, Der#battle_attr.dodge_ratio) of
         true  ->   %%命中
             case is_crit(Aer#battle_attr.crit_ratio, Der#battle_attr.tough_ratio) of
                 true  -> 
                     %%属性伤害
                     FmdDamage = case Aer#battle_attr.career of
                                     ?CAREER_F -> 
                                         crit_fattack_damage(BattleType, Aer, Der) * 
                                         ((Coef1 - Der#battle_attr.avoid_fattack_ratio)/Coef1) * 
                                         ((Coef1 - Der#battle_attr.avoid_crit_fattack_ratio)/Coef1);
                                     ?CAREER_M -> 
                                         crit_mattack_damage(BattleType, Aer, Der) * 
                                         ((Coef1 - Der#battle_attr.avoid_mattack_ratio)/Coef1) *
                                         ((Coef1 - Der#battle_attr.avoid_crit_mattack_ratio)/Coef1);
                                     ?CAREER_D -> 
                                         crit_dattack_damage(BattleType, Aer, Der) * 
                                         ((Coef1 - Der#battle_attr.avoid_dattack_ratio)/Coef1) *
                                         ((Coef1 - Der#battle_attr.avoid_crit_dattack_ratio)/Coef1) ;
                                     _Other -> 
                                         0
                                 end,
                     %%普攻伤害
                     Damage = crit_attack_damage(BattleType, Aer, Der) * ((Coef1 - Der#battle_attr.avoid_attack_ratio)/Coef1) *
                              ((Coef1 - Der#battle_attr.avoid_crit_attack_ratio)/Coef1),
                     %%技能伤害
                     SkillDamage = crit_skill_damage(Aer, SkillId, SkillLv),
                     TotalDamage = round_down(Aer#battle_attr.abs_damage + Damage + SkillDamage + FmdDamage),
                     ?MYTRACE("CRIT: Fmddamage: ~p damage: ~p skill: ~p,  total: ~p~n", [FmdDamage,  Damage,  SkillDamage, TotalDamage]),
                     ?MYTRACE("Aer: ~s~n", [tool:recinfo(record_info(fields, battle_attr), Aer)]),
                     ?MYTRACE("Der: ~s~n", [tool:recinfo(record_info(fields, battle_attr), Der)]),
                     {?DAMAGE_TYPE_CRIT,  TotalDamage};
                 false -> 
                     %%属性伤害
                      FmdDamage = case Aer#battle_attr.career of
                                     ?CAREER_F -> 
                                         fattack_damage(BattleType, Aer, Der) *
                                         ((Coef1 - Der#battle_attr.avoid_fattack_ratio)/Coef1);
                                     ?CAREER_M -> 
                                         mattack_damage(BattleType, Aer, Der) *
                                         ((Coef1 - Der#battle_attr.avoid_mattack_ratio)/Coef1);
                                     ?CAREER_D -> 
                                         dattack_damage(BattleType, Aer, Der) * 
                                         ((Coef1 - Der#battle_attr.avoid_dattack_ratio)/Coef1);
                                     _Other    -> 
                                         0
                                 end,
                     %%普攻伤害
                     Damage = attack_damage(BattleType, Aer, Der) * ((Coef1 - Der#battle_attr.avoid_attack_ratio)/Coef1),
                     %%技能伤害
                     SkillDamage = skill_damage(SkillId, SkillLv),
                     TotalDamage = round_down(Aer#battle_attr.abs_damage + Damage + SkillDamage + FmdDamage),
                     ?MYTRACE("NORMAL: Fmddamage: ~p damage: ~p skill: ~p,  total: ~p~n", [FmdDamage,  Damage,  SkillDamage, TotalDamage]),
                     ?MYTRACE("Aer: ~s~n", [tool:recinfo(record_info(fields, battle_attr), Aer)]),
                     ?MYTRACE("Der: ~s~n", [tool:recinfo(record_info(fields, battle_attr), Der)]),
                     {?DAMAGE_TYPE_NORMAL, TotalDamage}
             end;
         false -> %%不命中
             ?MYTRACE("MISS: ~n"),
             ?MYTRACE("Aer: ~s~n", [tool:recinfo(record_info(fields, battle_attr), Aer)]),
             ?MYTRACE("Der: ~s~n", [tool:recinfo(record_info(fields, battle_attr), Der)]),
             {?DAMAGE_TYPE_MISSED, 0} 
     end.


%%计算是否可以暴击,
%% AerCrit为攻击暴击等级, Der为守方坚韧等级
%% 返回 true为暴击, false为一般攻击
is_crit(AerCrit, DerTough) ->
    CritRatio = round_down(10000 * AerCrit / (AerCrit + DerTough * 10)),
    CritCmp = util:rand(1, 10000),
    ?MYTRACE("is_crit: AerCrit: ~p, DerTough: ~p, CritRatio: ~p,  Random: ~p  ", [AerCrit, DerTough, CritRatio, CritCmp]),
    ?MYTRACE("return: ~p~n", [(CritCmp =< CritRatio)]),
    CritRatio >= CritCmp.

%%计算是否可以命中,
%% AerHit为攻击方命中等级, DerDodge为守方躲闪等级
%% 返回 true为命中, false为不命中 
is_hit(AerHit, DerDodge) ->
    HitRatio = round_down(10000  - (2500 + AerHit*10000/(AerHit + DerDodge))),
    HitCmp = util:rand(1, 10000),
    ?MYTRACE("is_hit: AerHit: ~p, DerDodge: ~p, HitRatio: ~p,  Random: ~p  ", [AerHit, DerDodge, HitRatio, HitCmp]),
    ?MYTRACE("return: ~p~n", [(HitRatio >= HitCmp)]),
    HitRatio =< HitCmp.

%%普攻伤害值
%%参数: 
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
attack_damage(BattleType, Aer, Der) ->  %%怪造成的伤害
    [Coef1, Coef2, _Coef3, Coef4] = get_coef(BattleType),
    AerAttack = Aer#battle_attr.attack *(Coef1 + Aer#battle_attr.attack_ratio)/Coef1,
    DerDefense = Der#battle_attr.defense * (Coef1 + Der#battle_attr.defense_ratio)/Coef1 - Aer#battle_attr.ignore_defense,
    if AerAttack >= DerDefense ->
        round_down((AerAttack - DerDefense) * Coef2) + 
        round_down((Der#battle_attr.defense * (Coef1 + Der#battle_attr.defense_ratio) - Coef1*Aer#battle_attr.ignore_defense)/Coef4);
    true ->
        round_down(AerAttack * (Coef1 + Aer#battle_attr.attack_ratio)/Coef4)
    end.
    

%%技能伤害值
%%参数: 
%%      SkillId,    技能ID
%%      SkillLv,    技能等级
%%返回: 伤害值
skill_damage(SkillId, SkillLv) ->
    {SkillDamage, SkillCoef} = data_skill:get_abs_damage(SkillId, SkillLv),
    Damage = round_down(SkillDamage * SkillCoef), 
    round_down(Damage).

%%仙攻伤害值
%%参数: 
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
fattack_damage(BattleType, Aer, Der) ->
    [Coef1, _Coef2, Coef3, Coef4] = get_coef(BattleType),
    AerFAttack = Aer#battle_attr.fattack *(Coef1 + Aer#battle_attr.fattack_ratio)/Coef1,
    DerFDefense = Der#battle_attr.fdefense * (Coef1 + Der#battle_attr.fdefense_ratio)/Coef1 - Aer#battle_attr.ignore_fdefense,
    if AerFAttack >= DerFDefense ->
        round_down((AerFAttack - DerFDefense) * Coef3) + 
        round_down((Der#battle_attr.fdefense * (Coef1 + Der#battle_attr.fdefense_ratio) - Coef1*Aer#battle_attr.ignore_fdefense)/Coef4);
    true ->
        round_down(AerFAttack * (Coef1 + Aer#battle_attr.fattack_ratio)/Coef4)
    end.

%%魔攻伤害值
%%参数: 
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
mattack_damage(BattleType, Aer, Der) ->
    [Coef1, _Coef2, Coef3, Coef4] = get_coef(BattleType),
    AerMAttack = Aer#battle_attr.mattack *(Coef1 + Aer#battle_attr.mattack_ratio)/Coef1,
    DerMDefense = Der#battle_attr.mdefense * (Coef1 + Der#battle_attr.mdefense_ratio)/Coef1 - Aer#battle_attr.ignore_mdefense,
    if AerMAttack >= DerMDefense ->
        round_down((AerMAttack - DerMDefense) * Coef3) + 
        round_down((Der#battle_attr.mdefense * (Coef1 + Der#battle_attr.mdefense_ratio) - Coef1*Aer#battle_attr.ignore_mdefense)/Coef4);
    true ->
        round_down(AerMAttack * (Coef1 + Aer#battle_attr.mattack_ratio)/Coef4)
    end.

%%妖攻伤害值
%%参数: 
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
dattack_damage(BattleType, Aer, Der) ->
    [Coef1, _Coef2, Coef3, Coef4] = get_coef(BattleType),
    AerDAttack = Aer#battle_attr.dattack *(Coef1 + Aer#battle_attr.dattack_ratio)/Coef1,
    DerDDefense = Der#battle_attr.ddefense * (Coef1 + Der#battle_attr.ddefense_ratio)/Coef1 - Aer#battle_attr.ignore_ddefense,
    if AerDAttack >= DerDDefense ->
        round_down((AerDAttack - DerDDefense) * Coef3) + 
        round_down((Der#battle_attr.ddefense * (Coef1 + Der#battle_attr.ddefense_ratio) - Coef1*Aer#battle_attr.ignore_ddefense)/Coef4);
    true ->
        round_down(AerDAttack * (Coef1 + Aer#battle_attr.dattack_ratio)/Coef4)
    end.

%%暴击伤害值
%%参数: 
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
crit_attack_damage(BattleType, Aer, Der) ->
    CritCoef = get_crit_coef(Aer#battle_attr.crit_ratio),
    round_down(attack_damage(BattleType, Aer, Der) * CritCoef).     

%%技能暴击伤害值
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%      SkillId,    技能ID
%%      SkillLv,    技能等级
%%返回: 伤害值
crit_skill_damage(Aer, SkillId, SkillLv) ->
    CritCoef = get_crit_coef(Aer#battle_attr.crit_ratio),
    round_down(skill_damage(SkillId, SkillLv) * CritCoef).     

%%仙攻暴攻伤害值
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
crit_fattack_damage(BattleType, Aer, Der) ->
    CritCoef = get_crit_coef(Aer#battle_attr.crit_ratio),
    round_down(fattack_damage(BattleType, Aer, Der) * CritCoef). 

%%魔攻暴击伤害值
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
crit_mattack_damage(BattleType, Aer, Der) ->
    CritCoef = get_crit_coef(Aer#battle_attr.crit_ratio),
    round_down(mattack_damage(BattleType, Aer, Der) * CritCoef). 

%%妖攻暴击伤害值
%%      BattleType, 战斗类型(PVP, PVE)
%%      Aer,        攻击战斗属性
%%      Der,        守方战斗属性
%%返回: 伤害值
crit_dattack_damage(BattleType, Aer, Der) ->
    CritCoef = get_crit_coef(Aer#battle_attr.crit_ratio),
    round_down(dattack_damage(BattleType, Aer, Der) * CritCoef). 
