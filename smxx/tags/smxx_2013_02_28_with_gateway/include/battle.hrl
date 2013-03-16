% 避免头文件多重包含
-ifndef(_BATTLE_HEADER_).
-define(_BATTLE_HEADER_, 0).

%%战斗类型
-define(BATTLE_TYPE_PVE, 1).
-define(BATTLE_TYPE_PVP, 2).

%%伤害类型
-define(DAMAGE_TYPE_NORMAL,1).
-define(DAMAGE_TYPE_CRIT, 2).
-define(DAMAGE_TYPE_MISSED,3).



%%发起战斗结果类型
-define(ATTACK_SUCCESS,   1).   % 攻击成功
-define(ATTACK_NO_TARGET, 2).   % 攻击范围内没有攻击目标
-define(NOT_ATTACK_AREA,  3).   % 超出攻击范围

-endif.  %% _BATTLE_HEADER_