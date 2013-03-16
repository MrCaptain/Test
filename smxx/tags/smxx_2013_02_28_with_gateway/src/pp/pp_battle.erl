%%%-------------------------------------------------------------------
%%% Module  : pp_battle
%%% Author  : 
%%% Description : 战斗
%%%-------------------------------------------------------------------
-module(pp_battle).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").


%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%% 发动攻击 - 玩家VS怪 
%% Id 怪物ID
%% SkillId 技能ID
handle(20001, PlayerStatus, [MonId, SkillId]) ->
	?TRACE("20001,id:~p  MonId:~p, SkillId:~p ~n", [PlayerStatus#player.id, MonId, SkillId]),
%% 	{ok, BinData} = pt_20:write(20005, [1, PlayerStatus#player.id]),
%% 	DerBattleResult = [[2, MonId, 100, 101, 10, 0, 0]],
%% 	{ok, BinData1} = pt_20:write(20001, [PlayerStatus#player.id, PlayerStatus#player.hit_point, PlayerStatus#player.magic, SkillId, 1, 50, 52, DerBattleResult]),
%% %%     lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData);
%% 	lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData1);
	case PlayerStatus#player.battle_attr#battle_attr.hit_point > 0 of 
		true ->
			% 检查技能合法性
%% 			case lib_skill:check_skill_usable(PlayerStatus, SkillId) of
%% 				true ->
					mod_scene:start_player_attack(PlayerStatus#player.other#player_other.pid_scene, PlayerStatus#player.id, MonId, ?ELEMENT_MONSTER, SkillId);
%% 				false ->
%% 					lib_battle:battle_fail(6, PlayerStatus, ?ELEMENT_PLAYER)
%% 			end;
		false ->
			?TRACE("20001, hp <= 0 MonId:~p, SkillId:~p ~n", [MonId, SkillId]),
			skip
	end;

%% 发动攻击 - 玩家VS玩家
%% DerId 被击方ID
%% SkillId 技能ID
handle(20002, PlayerStatus, [DerId, SkillId]) ->
	?TRACE("20002, DerId:~p, SkillId:~p ~n", [DerId, SkillId]),
%% 	DerBattleResult = [[1, DerId, 100, 101, 10, 0, 0]],
%% 	{ok, BinData1} = pt_20:write(20001, [PlayerStatus#player.id, PlayerStatus#player.hit_point, PlayerStatus#player.magic, SkillId, 1, 50, 52, DerBattleResult]),
%% 	lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData1);
	case PlayerStatus#player.battle_attr#battle_attr.hit_point > 0 andalso PlayerStatus#player.id /= DerId of
		true ->
			% 检查技能合法性
%% 			case lib_skill:check_skill_usable(PlayerStatus, SkillId) of
%% 				true ->
					mod_scene:start_player_attack(PlayerStatus#player.other#player_other.pid_scene, PlayerStatus#player.id, DerId, ?ELEMENT_PLAYER, SkillId);
%% 				false ->
%% 					lib_battle:battle_fail(6, PlayerStatus, ?ELEMENT_PLAYER)
%% 			end;				
		false ->
			?TRACE("20002, ac hp <= 0 or same player AerId:~p DerId:~p, SkillId:~p ~n", [PlayerStatus#player.id, DerId, SkillId]),
			skip
	end;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_battle no match"}.
