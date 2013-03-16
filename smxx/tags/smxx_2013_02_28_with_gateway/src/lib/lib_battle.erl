%%%--------------------------------------
%%% @Module  : lib_battle
%%% @Author  : jack
%%% @Created : 2013.01.18
%%% @Description:战斗处理 
%%%--------------------------------------
-module(lib_battle).
-export(
    [
	 	start_player_attack/4,
		start_mon_attack/7,
		notice_leave_scene/5,
		battle_fail/3    ]
).

-include("debug.hrl").
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl").

%% 攻击者为人
%% AerId 攻击方
%% DerId 被击方
%% SkillId 技能ID
%% DerType: 1表示人, 2表示怪
start_player_attack(AerId, DerId, DerType, SkillId) ->
	AerStatus = battle_util:get_status(AerId, ?ELEMENT_PLAYER),
	DerStatus = battle_util:get_status(DerId, DerType),
	case AerStatus /= [] andalso DerStatus /= [] of
		true ->
%% 			Ret = check_pvp_condition(NewAerStatus, AerType, DerStatus, DerType),
%% 			lib_battle:battle_fail(10, NewAerStatus, 2),
			{NewSkillId, SkillLv} = {SkillId, 1},
%% 		        case AerType =:= ?ELEMENT_PLAYER of % 人
%% 		            ture ->
%% 						 case lists:keyfind(SkillId, 1, AerStatus#player.other#player_other.skill_list) of
%% 		                    false ->
%% 		                        {0, 0};
%% 		                    {_SkillId, Lv} ->
%% 		                        {SkillId, Lv}
%% 		                end;
%% 		            false ->
%% 		               {SkillId, 1}
%% 		        end,
			attack_operation(AerStatus, ?ELEMENT_PLAYER, DerStatus, DerType, NewSkillId, SkillLv, AerStatus#player.battle_attr#battle_attr.x, AerStatus#player.battle_attr#battle_attr.y);
		false ->
			skip
	end.

%% 攻击者为怪物
%% AerStatus 攻击方
%% DerStatus 被击方
%% SkillId 技能ID
%% DerType: 1表示人, 2表示怪
%% SkillLv 技能等级
%% 攻击点x坐标
%% 攻击点y坐标
start_mon_attack(AerStatus, DerStatus, DerType, SkillId, SkillLv, X, Y) ->
%% 	?TRACE("start_mon_attack AerId:~p, DerId:~p, DerType:~p, SkillId:~p, SkillLv:~p, X:~p, Y:~p ~n", [AerId, DerId, DerType, SkillId, SkillLv, X, Y]),
	attack_operation(AerStatus, ?ELEMENT_MONSTER, DerStatus, DerType, SkillId, SkillLv, X, Y).

%% %% @spec 攻击者为怪物 by chenzm
%% %% 输入：
%% %% 		AttackMon 攻击方
%% %% 		DefPlayer 被击方
%% %% 		SkillId 技能ID
%% %% 		SkillLv 技能等级
%% %% 返回：
%% %% 		1 - 攻击成功
%% %% 		2 - 攻击失败,不在攻击范围
%% start_mon_attack(AttackMon,DefPlayer,SkillId, SkillLv) ->
%% 	?TRACE("start_mon_attack AttackMon:~p,  DefPlayer:~p, SkillId:~p, SkillLv:~p ~n", [AttackMon, DefPlayer, SkillId, SkillLv]),
%% 	
%% 	AerBattleInfo = battle_util:init_battle_info(AttackMon, ?ELEMENT_MONSTER),
%% 	{_AttackArea, AttackTargetNum} = data_skill:get_skill_aoe(SkillId),
%% 	AttackArea = 5,
%% 	
%% 	case AttackTargetNum > 1 of
%% 		true -> % 群攻
%% 			DerType1 = ?ELEMENT_ALL,
%% 			multi_active_skill(AttackMon, AerBattleInfo, SkillId, SkillLv, AttackArea, AttackTargetNum, 1, DerType1, DefPlayer#player.x, DefPlayer#player.y) ,
%% 			AttactResult =  1 ;
%% 		false -> % 单攻
%% 			DerBattleInfo = battle_util:init_battle_info(DefPlayer, ?ELEMENT_PLAYER),
%% 			case battle_util:check_att_area(AerBattleInfo#battle_attr.x, AerBattleInfo#battle_attr.y, 
%% 											DerBattleInfo#battle_attr.x, DerBattleInfo#battle_attr.y, AttackArea) of
%% 				true ->
%% 					single_active_skill(AttackMon, DefPlayer, AerBattleInfo, DerBattleInfo, SkillId, SkillLv, ?ELEMENT_MONSTER, ?ELEMENT_PLAYER) ,
%% 					AttactResult =  1 ;
%% 				false -> % 不在攻击范围
%% 					AttactResult = 2 
%% 			end
%% 	end ,
%% 	AttactResult .


%% AerStatus 攻击方信息
%% DerStatus 被击方
%% SkillId 技能ID
%% SkillLv 技能等级
%% (AerType、DerType: 1表示人, 2表示怪)
attack_operation(AerStatus, AerType, DerStatus, DerType, SkillId, SkillLv, X, Y) ->
	AerBattleInfo = battle_util:init_battle_info(AerStatus, AerType),
	{AttackArea, AttackTargetNum} = data_skill:get_skill_aoe(SkillId),
%% 	AttackArea = 5,
%% 	?TRACE("AttackArea:~p, AttackTargetNum:~p,Skill:~p ~n", [AttackArea, AttackTargetNum,SkillId]),
%% 	{AttackArea, AttackTargetNum} = {1000, 1},
	case AttackTargetNum > 1 of
		true -> % 群攻
			DerType1 = ?ELEMENT_ALL,
			multi_active_skill(AerStatus, AerBattleInfo, SkillId, SkillLv, AttackArea, AttackTargetNum, AerType, DerType1, X, Y);
		false -> % 单攻
			DerBattleInfo = battle_util:init_battle_info(DerStatus, DerType),
			case battle_util:check_att_area(AerBattleInfo#battle_attr.x, AerBattleInfo#battle_attr.y, 
											DerBattleInfo#battle_attr.x, DerBattleInfo#battle_attr.y, AttackArea) of
				true ->
					single_active_skill(AerStatus, DerStatus, AerBattleInfo, DerBattleInfo, SkillId, SkillLv, AerType, DerType);
				false -> % 不在攻击范围
					battle_fail(4, AerStatus, AerType),
					{?NOT_ATTACK_AREA, []}
			end
	end.

%% 群攻
multi_active_skill(AerStatus, AerBattleInfo, SkillId, SkillLv, AttackArea, AttackTargetNum, AerType, DerType, X, Y) ->
	{DerPlayerList, DerMonList} = 
		if
			AerType =:= ?ELEMENT_PLAYER -> % 人
				battle_util:get_der_list(AerStatus#player.id, AerStatus#player.scene, X, Y, AttackArea, DerType, AttackTargetNum);
			AerType =:= ?ELEMENT_MONSTER ->
				battle_util:get_der_list(AerStatus#temp_mon_layout.monid, AerStatus#temp_mon_layout.scene_id, X, Y, AttackArea, DerType, AttackTargetNum);
			true -> []
		end,
		DerBattleResultList = 
		if
			DerPlayerList /= [] andalso DerMonList /= [] ->
				DerBattleRes1 = derlist_to_battleresult(AerStatus, AerBattleInfo, SkillId, SkillLv, AerType, ?ELEMENT_PLAYER, DerPlayerList),
				DerBattleRes2 = derlist_to_battleresult(AerStatus, AerBattleInfo, SkillId, SkillLv, AerType, ?ELEMENT_MONSTER, DerMonList),
				DerBattleRes2 ++ DerBattleRes1;
			DerPlayerList /= [] ->
				derlist_to_battleresult(AerStatus, AerBattleInfo, SkillId, SkillLv, AerType, ?ELEMENT_PLAYER, DerPlayerList);
			DerMonList /= [] ->
				derlist_to_battleresult(AerStatus, AerBattleInfo, SkillId, SkillLv, AerType, ?ELEMENT_MONSTER, DerMonList);
			true ->
				[]
		end,
%% 		?TRACE("DerBattleResultList:~p ~n", [DerBattleResultList]),
		case length(DerBattleResultList) > 0 of
			true ->
				send_battle_msg(AerStatus, AerType, SkillId, SkillLv, DerBattleResultList),
				if
					AerType =:= ?ELEMENT_MONSTER ->
						AttackRes = get_mon_attack_result(DerBattleResultList),
						{?ATTACK_SUCCESS, AttackRes};
					true ->
						{?ATTACK_SUCCESS, []}
				end;
		false -> {?ATTACK_NO_TARGET, []}
	end.

%% 单攻
single_active_skill(AerStatus, DerStatus, AerBattleInfo, DerBattleInfo, SkillId, SkillLv, AerType, DerType) ->
	BattleType = battle_util:get_battle_type(AerType, DerType),
	% 计算单个受击者伤害
	%% 	{DamageType, DamegeNum} = data_battle:get_damage(BattleType, AerBattleInfo, DerBattleInfo, SkillId, SkillLv),
	{DamageType, DamegeNum}  = {10,5} ,
	DerBattleResult = update_target_info(AerStatus, AerType, DerStatus, DerType, DamegeNum, DamageType),
%% 	?TRACE("DerBattleResult:~p ~n", [DerBattleResult]),	
	case length(DerBattleResult) > 0 of
		true ->
			send_battle_msg(AerStatus, AerType, SkillId, SkillLv, DerBattleResult),
			if
				AerType =:= ?ELEMENT_MONSTER ->
					AttackRes = get_mon_attack_result(DerBattleResult),
					{?ATTACK_SUCCESS, AttackRes};
				true ->
					{?ATTACK_SUCCESS, []}
			end;
		false ->
			{?ATTACK_NO_TARGET, []}
	end.

get_mon_attack_result(DerBattleResult) ->
	F = fun(Info, Result) ->
		{DerType, DerId, Hp, _Mp, _NewHpDamege, _MpDamege, _DamageType} = Info,
		if
			Hp > 0 -> Result;
			true -> [{DerId, DerType}] ++ Result
		end
	end,
	lists:foldl(F, [], DerBattleResult).

%% 通知删除场景中玩家
notice_leave_scene(PlayerId, SceneId, _ScenePid, X, Y) ->
	{ok, BinData} = pt_12:write(12004, [PlayerId]),
	mod_scene_agent:send_to_matrix(SceneId, X, Y, BinData, PlayerId),
	lib_scene:leave_scene(PlayerId,SceneId).

%% 计算群攻伤害结果
derlist_to_battleresult(AerStatus, AerBattleInfo, SkillId, SkillLv, AerType, DerType, DerList) ->
	F = fun(DerStatus, Result) ->
         NewDerBattleInfo = battle_util:init_battle_info(DerStatus, DerType),
				BattleType = battle_util:get_battle_type(AerType, DerType),
				% 计算单个受击者伤害
				{DamageType, DamegeNum} = data_battle:get_damage(BattleType, AerBattleInfo, NewDerBattleInfo, SkillId, SkillLv),
				update_target_info(AerStatus, AerType, DerStatus, DerType, DamegeNum, DamageType) ++ Result
        end,
     lists:foldl(F, [], DerList).

%% 更新玩家或怪物信息
%% AerStatus 攻击方信息
%% DerStatus 被击方信息
%% (AerType、DerType: 1表示人, 2表示怪)
update_target_info(AerStatus, AerType, DerStatus, TargetType, DamegeNum, DamageType) ->
	if
		TargetType =:= ?ELEMENT_PLAYER ->
			CurrentHP = max(0, DerStatus#player.battle_attr#battle_attr.hit_point - DamegeNum),
			NewHpDamege = DerStatus#player.battle_attr#battle_attr.hit_point - CurrentHP,
			NewBattleAttr = DerStatus#player.battle_attr#battle_attr{hit_point = CurrentHP},
			NewDerStatus = DerStatus#player{battle_attr = NewBattleAttr},
			lib_scene:save_scene_player(NewDerStatus),
			gen_server:cast(NewDerStatus#player.other#player_other.pid, {reducehpmp, NewHpDamege}),
			[{?ELEMENT_PLAYER, DerStatus#player.id, NewDerStatus#player.battle_attr#battle_attr.hit_point, NewDerStatus#player.battle_attr#battle_attr.magic, NewHpDamege, 0, DamageType}];
		TargetType =:= ?ELEMENT_MONSTER ->
			CurrentHP = max(0, DerStatus#temp_mon_layout.battle_attr#battle_attr.hit_point - DamegeNum),
			NewHpDamege = DerStatus#temp_mon_layout.battle_attr#battle_attr.hit_point - CurrentHP,
			NewBattleAttr = DerStatus#temp_mon_layout.battle_attr#battle_attr{hit_point = CurrentHP},			 
			NewDerStatus = DerStatus#temp_mon_layout{battle_attr = NewBattleAttr} ,
			if
				AerType =:= ?ELEMENT_PLAYER ->
					lib_mon:save_monster(NewDerStatus,AerStatus#player.id,DamegeNum,CurrentHP) ,
                    case CurrentHP =:= 0 of % 人杀死怪  
						%%修改by Johnathe_Yip 
						true ->lib_task:call_event(AerStatus,kill,{DerStatus#temp_mon_layout.monid,1}); 
					false -> skip
				end;
				true ->
					lib_mon:save_monster(NewDerStatus)
			end ,
			[{?ELEMENT_MONSTER, DerStatus#temp_mon_layout.id, NewDerStatus#temp_mon_layout.battle_attr#battle_attr.hit_point, NewDerStatus#temp_mon_layout.battle_attr#battle_attr.magic, NewHpDamege, 0, DamageType}];
		true -> % 攻击类型错误
			[]
	end.


%% 战斗发起失败
%% Code 错误码
%% Aer 攻击方
%% AerType 1人, 2怪
battle_fail(Code, Aer, AerType) ->
    case AerType =:= ?ELEMENT_PLAYER of
        true ->
            {ok, BinData} = pt_20:write(20005, [Code, Aer#player.id]),
            lib_send:send_to_sid(Aer#player.other#player_other.pid_send, BinData);
   		false ->
            skip
    end. 

%% 发送战斗结果消息
%% DerBattleResult 受击者列表
send_battle_msg(AerStatus, AerType, SkillId, Slv, DerBattleResult) ->
	case DerBattleResult /= [] of
		true ->
			{NewBinData, SceneId, X, Y} = 
		        if
					AerType =:= ?ELEMENT_PLAYER -> 	% 人攻击
		            	{ok, BinData} = pt_20:write(20001, [AerStatus#player.id, AerStatus#player.battle_attr#battle_attr.hit_point, AerStatus#player.battle_attr#battle_attr.magic, 
															SkillId, Slv, AerStatus#player.battle_attr#battle_attr.x, AerStatus#player.battle_attr#battle_attr.y, DerBattleResult]),
						{BinData, AerStatus#player.scene, AerStatus#player.battle_attr#battle_attr.x, AerStatus#player.battle_attr#battle_attr.y};                          
		            AerType =:= ?ELEMENT_MONSTER ->	% 怪攻击
						{ok, BinData} = pt_20:write(20003, [AerStatus#temp_mon_layout.id, AerStatus#temp_mon_layout.battle_attr#battle_attr.hit_point, AerStatus#temp_mon_layout.battle_attr#battle_attr.magic, 
															SkillId, Slv, AerStatus#temp_mon_layout.x, AerStatus#temp_mon_layout.y, DerBattleResult]),
						{BinData, AerStatus#temp_mon_layout.scene_id, AerStatus#temp_mon_layout.x, AerStatus#temp_mon_layout.y}
		        end,
		   	mod_scene_agent:send_to_matrix(SceneId, X, Y, NewBinData,"");
		false ->
			skip
	end.