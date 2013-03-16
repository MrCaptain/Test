%%%--------------------------------------
%%% @Module  : battle_util
%%% @Author  : jack
%%% @Created : 
%%% @Description:战斗处理 
%%%--------------------------------------
-module(battle_util).
-export(
    [
	 	get_battle_type/2,
		get_der_list/7,
		get_der_player_list/6,
		get_der_mon_list/6,
		get_status/2,
		init_battle_info/2,
		check_att_area/5
    ]
).


-include("debug.hrl").
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(BATTLE_LEVEL,25). %新手保护级别 

%% 获取战斗类型
get_battle_type(AerType, DerType) ->
	if
		AerType =:= ?ELEMENT_PLAYER andalso DerType =:= ?ELEMENT_PLAYER -> ?BATTLE_TYPE_PVP;
		AerType /= DerType -> ?BATTLE_TYPE_PVE;
		true -> ?BATTLE_TYPE_PVE
	end.

%% 获取被攻击列表
%% AttackTargetNum 被攻击数
%% ret: [player,...] or [temp_mon_layout,...]
get_der_list(AerId, SceneId, X, Y, AttackArea, DerType, AttackTargetNum) ->
	if
		DerType =:= ?ELEMENT_PLAYER -> % 人
			{_, PlayerList} = get_der_player_list(AerId, SceneId, X, Y, AttackArea, AttackTargetNum),
			{PlayerList, []};
		DerType =:= ?ELEMENT_MONSTER -> % 怪物
			{_, MonList} = get_der_mon_list(AerId, SceneId, X, Y, AttackArea, AttackTargetNum),
			{[], MonList};
		true ->
			{PlayerNum, PlayerList} = get_der_player_list(AerId, SceneId, X, Y, AttackArea, AttackTargetNum),
			case PlayerNum =:= AttackTargetNum of
				true -> {PlayerList, []};
				false ->
					GetNum = AttackTargetNum - PlayerNum,
					{_, MonList} = get_der_mon_list(AerId, SceneId, X, Y, AttackArea, GetNum),
					{PlayerList, MonList}
			end
	end.

%% 获取指定数目的被攻击人物列表
get_der_player_list(AerId, SceneId, X, Y, AttackArea, AttackTargetNum) ->
	X1 = X + AttackArea,
	X2 = X - AttackArea,
	Y1 = Y + AttackArea,
	Y2 = Y - AttackArea,
	PlayerList = get_scene_user_for_battle(AerId, SceneId, X1, X2, Y1, Y2),
	PlayerListLen = length(PlayerList),
	if
		PlayerListLen > AttackTargetNum andalso AttackTargetNum >0 ->
			{AttackTargetNum, lists:sublist(PlayerList, AttackTargetNum)};
		PlayerListLen > 0 ->
			{PlayerListLen, lists:sublist(PlayerList, PlayerListLen)};
		true ->
			{0, []}
	end.

%% 获取指定数目的被攻击人物列表
get_der_mon_list(AerId, SceneId, X, Y, AttackArea, AttackTargetNum) ->
	X1 = X + AttackArea,
	X2 = X - AttackArea,
	Y1 = Y + AttackArea,
	Y2 = Y - AttackArea,
	MonList = get_scene_mon_battle(AerId, SceneId, X1, X2, Y1, Y2),
	MonListLen = length(MonList),
	if
		MonListLen > AttackTargetNum andalso AttackTargetNum > 0 ->
			{AttackTargetNum, lists:sublist(MonList, AttackTargetNum)};
		MonListLen > 0 ->
			{MonListLen, lists:sublist(MonList, MonListLen)};
		true ->
			{0, []}
	end.

%% 获取场景人或怪信息
get_status(Id, Type) ->
	if
		Type =:= ?ELEMENT_PLAYER -> % 人
			case lib_scene:get_scene_player(Id) of
				AerStatus1 when is_record(AerStatus1, player) -> 
					AerStatus1;
				_ ->
					?TRACE("get_status, Id:~p, Type:~p ~n", [Id, Type]),
					[]
			end;
		Type =:= ?ELEMENT_MONSTER -> % 怪
			case lib_mon:get_monster(Id) of
				AerStatus1 when is_record(AerStatus1, temp_mon_layout) ->
					AerStatus1;
				_ ->
					?TRACE("get_status, Id:~p, Type:~p ~n", [Id, Type]),
					[]
			end;
		true ->
			[]
	end.

%% 初始化人物或怪物战斗信息
init_battle_info(Status, Type) ->
	if
		Type =:= ?ELEMENT_PLAYER -> % 人
			Status#player.battle_attr;
		Type =:= ?ELEMENT_MONSTER -> % 怪
			Status#temp_mon_layout.battle_attr#battle_attr{x = Status#temp_mon_layout.pos_x,y = Status#temp_mon_layout.pos_y};
		true ->
			#battle_attr{}
	end.

%% 判断是否在攻击范围内
%% AX 攻击方X坐标
%% AY 攻击方y坐标
%% DX 被击方X坐标
%% DY 攻击方y坐标
%% AttArea 攻击距离
check_att_area(AX, AY, DX, DY, AttArea) ->
	NewAttArea = AttArea + 2,
    X = abs(AX - DX),
    Y = abs(AY - DY),
    X =< NewAttArea andalso Y =< NewAttArea.

%% 判断pvp战斗条件
check_pvp_condition(AerStatus, AerType, DerStatus, DerType) ->
	if
		AerType =:= ?ELEMENT_PLAYER andalso DerType =:= ?ELEMENT_PLAYER -> % 人
			%% 人VS人， 判断等级限制
			case AerStatus#player.level > ?BATTLE_LEVEL andalso DerStatus#player.level > ?BATTLE_LEVEL of
				true -> true;
				false -> false
			end;
		true ->
			false
	end.

get_scene_user_for_battle(AerId, SceneId, X1, X2, Y1, Y2) ->
	MS = ets:fun2ms(fun(P) when P#player.scene == SceneId andalso
									P#player.battle_attr#battle_attr.hit_point > 0 andalso P#player.id /= AerId andalso 
									P#player.battle_attr#battle_attr.x >= X2 andalso P#player.battle_attr#battle_attr.x =< X1 andalso 
									P#player.battle_attr#battle_attr.y >= Y2 andalso P#player.battle_attr#battle_attr.y =< Y1 -> P end),
	case ets:select(?ETS_ONLINE_SCENE, MS) of
		List when is_list(List) ->
			List;
		_ ->
			[]
	end .

%% 获得当前场景怪物信息(用于战斗)
get_scene_mon_battle(AerId, SceneId, X1, X2, Y1, Y2) ->
	MS = ets:fun2ms(fun(M) when M#temp_mon_layout.scene_id == SceneId andalso 
								M#temp_mon_layout.monid /= AerId andalso M#temp_mon_layout.battle_attr#battle_attr.hit_point > 0 andalso 
								M#temp_mon_layout.x >= X2 andalso M#temp_mon_layout.x =< X1 andalso
								M#temp_mon_layout.y >= Y2 andalso M#temp_mon_layout.y =< Y1 ->M end),
	case ets:select(?SECNE_MON, MS) of
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.