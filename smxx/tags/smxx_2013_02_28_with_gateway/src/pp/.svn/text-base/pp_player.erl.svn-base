%%%--------------------------------------
%%% @Module  : pp_player
%%% @Author  : 
%%% @Created : 
%%% @Description: 角色功能管理  
%%%--------------------------------------
-module(pp_player).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%% API Functions
handle(Cmd, Player, Data) ->
    ?TRACE("pp_player: Cmd:~p, Player:~p, Level:~p, Data:~p~n", [Cmd, Player#player.id, Player#player.level, Data]),
    handle_cmd(Cmd, Player, Data).

%%--------------------------------------
%%Protocol: 13000 玩家自身信息(FULL)
%%--------------------------------------
handle_cmd(13000, Status, _) ->
    ExpNextLevel = data_player:next_level_exp(Status#player.career, Status#player.level),
	[Weapon, Armor, Fashion, WwaponAcc, Wing, Mount] = Status#player.other#player_other.equip_current,
    pack_and_send(Status, 13000, [ Status#player.id,
                                   Status#player.gender,
                                   Status#player.level,
                                   Status#player.career,
                                   Status#player.camp,
                                   Status#player.vip,
                                   Status#player.icon,
                                   Status#player.scene,
                                   Status#player.battle_attr#battle_attr.x,
                                   Status#player.battle_attr#battle_attr.y,
                                   Status#player.liveness,
                                   Status#player.exp,
                                   ExpNextLevel,
                                   Status#player.lilian,
                                   Status#player.gold,
                                   Status#player.bgold,
                                   Status#player.coin,
                                   Status#player.bcoin,
                                   Status#player.battle_attr#battle_attr.hit_point,
                                   Status#player.battle_attr#battle_attr.hit_point_max,
                                   Status#player.battle_attr#battle_attr.combopoint,
                                   Status#player.battle_attr#battle_attr.combopoint_max,
                                   Status#player.battle_attr#battle_attr.magic,
                                   Status#player.battle_attr#battle_attr.magic_max,
                                   Status#player.battle_attr#battle_attr.anger,
                                   Status#player.battle_attr#battle_attr.anger_max,
                                   Status#player.battle_attr#battle_attr.attack,
                                   Status#player.battle_attr#battle_attr.defense,
                                   Status#player.battle_attr#battle_attr.abs_damage,
                                   Status#player.battle_attr#battle_attr.fattack,
                                   Status#player.battle_attr#battle_attr.mattack,
                                   Status#player.battle_attr#battle_attr.dattack,
                                   Status#player.battle_attr#battle_attr.fdefense,
                                   Status#player.battle_attr#battle_attr.mdefense,
                                   Status#player.battle_attr#battle_attr.ddefense,
                                   Status#player.battle_attr#battle_attr.speed,
                                   Status#player.battle_attr#battle_attr.attack_speed,
                                   Status#player.battle_attr#battle_attr.hit_ratio,
                                   Status#player.battle_attr#battle_attr.dodge_ratio,
                                   Status#player.battle_attr#battle_attr.crit_ratio,
                                   Status#player.battle_attr#battle_attr.tough_ratio,
                                   Status#player.battle_attr#battle_attr.frozen_resis_ratio,
                                   Status#player.battle_attr#battle_attr.weak_resis_ratio,
                                   Status#player.battle_attr#battle_attr.flaw_resis_ratio,
                                   Status#player.battle_attr#battle_attr.poison_resis_ratio,
                                   Status#player.battle_attr#battle_attr.ignore_defense,
                                   Status#player.battle_attr#battle_attr.ignore_fdefense,
                                   Status#player.battle_attr#battle_attr.ignore_mdefense,
                                   Status#player.battle_attr#battle_attr.ignore_ddefense,
                                   Status#player.nick,
								   Weapon, Armor, Fashion, WwaponAcc, Wing, Mount
                                 ]);

%%--------------------------------------
%%Protocol: 13001 查询玩家自身信息(基本)
%%--------------------------------------
handle_cmd(13001, Status, _) ->
    ExpNextLevel = data_player:next_level_exp(Status#player.career, Status#player.level),
    pack_and_send(Status, 13001, [ Status#player.id,
                                   Status#player.gender,
                                   Status#player.level,
                                   Status#player.career,
                                   Status#player.battle_attr#battle_attr.speed,
                                   Status#player.scene,
                                   Status#player.battle_attr#battle_attr.x,
                                   Status#player.battle_attr#battle_attr.y,
                                   Status#player.battle_attr#battle_attr.hit_point,
                                   Status#player.battle_attr#battle_attr.hit_point_max,
                                   Status#player.exp,
                                   ExpNextLevel,
                                   Status#player.gold,
                                   Status#player.bgold,
                                   Status#player.coin,
                                   Status#player.bcoin,
                                   Status#player.nick
                                 ]);

%%--------------------------------------
%%Protocol: 13002 查看其他玩家
%%--------------------------------------
handle_cmd(13002, Status, [Uid]) ->
    case lib_player:get_user_info_by_id(Uid) of
        PlayerStatus when is_record(PlayerStatus, player) -> 
            skip;
        _Other ->
            PlayerStatus = []        
    end,
    if is_record(PlayerStatus, player) -> 
         ExpNextLevel = data_player:next_level_exp(PlayerStatus#player.career, PlayerStatus#player.level),
         pack_and_send(Status, 13002, [1,PlayerStatus#player.online_flag,
                                         PlayerStatus#player.id,
                                         PlayerStatus#player.gender,
                                         PlayerStatus#player.level,
                                         PlayerStatus#player.career,
                                         PlayerStatus#player.camp,
                                         PlayerStatus#player.vip,
                                         PlayerStatus#player.icon,
                                         PlayerStatus#player.scene,
                                         PlayerStatus#player.battle_attr#battle_attr.x,
                                         PlayerStatus#player.battle_attr#battle_attr.y,
                                         PlayerStatus#player.liveness,
                                         PlayerStatus#player.exp,
                                         ExpNextLevel,
                                         PlayerStatus#player.lilian,
                                         PlayerStatus#player.gold,
                                         PlayerStatus#player.bgold,
                                         PlayerStatus#player.coin,
                                         PlayerStatus#player.bcoin,
                                         PlayerStatus#player.battle_attr#battle_attr.hit_point,
                                         PlayerStatus#player.battle_attr#battle_attr.hit_point_max,
                                         PlayerStatus#player.battle_attr#battle_attr.combopoint,
                                         PlayerStatus#player.battle_attr#battle_attr.magic,
                                         PlayerStatus#player.battle_attr#battle_attr.magic_max,
                                         PlayerStatus#player.battle_attr#battle_attr.anger,
                                         PlayerStatus#player.battle_attr#battle_attr.anger_max,
                                         PlayerStatus#player.battle_attr#battle_attr.attack,
                                         PlayerStatus#player.battle_attr#battle_attr.defense,
                                         PlayerStatus#player.battle_attr#battle_attr.abs_damage,
                                         PlayerStatus#player.battle_attr#battle_attr.fattack,
                                         PlayerStatus#player.battle_attr#battle_attr.mattack,
                                         PlayerStatus#player.battle_attr#battle_attr.dattack,
                                         PlayerStatus#player.battle_attr#battle_attr.fdefense,
                                         PlayerStatus#player.battle_attr#battle_attr.mdefense,
                                         PlayerStatus#player.battle_attr#battle_attr.ddefense,
                                         PlayerStatus#player.battle_attr#battle_attr.speed,
                                         PlayerStatus#player.battle_attr#battle_attr.attack_speed,
                                         PlayerStatus#player.battle_attr#battle_attr.hit_ratio,
                                         PlayerStatus#player.battle_attr#battle_attr.dodge_ratio,
                                         PlayerStatus#player.battle_attr#battle_attr.crit_ratio,
                                         PlayerStatus#player.battle_attr#battle_attr.tough_ratio,
                                         PlayerStatus#player.nick
                                       ]);
    true ->
          pack_and_send(Status, 13002, [0])
    end;

%%--------------------------------------
%%Protocol: 13003 更新玩家信息
%%--------------------------------------
handle_cmd(13003, Status, _) ->
    lib_player:send_player_attribute1(Status);

%%--------------------------------------
%%Protocol: 13004 更新玩家战力信息
%%--------------------------------------
handle_cmd(13004, Status, _) ->
    lib_player:send_player_attribute2(Status);

%%--------------------------------------
%%Protocol: 13005 更新玩家信息(金钱)
%%--------------------------------------
handle_cmd(13005, Status, _) ->
    lib_player:send_player_attribute3(Status);

%%--------------------------------------
%%Protocol: 13006 关键常用玩家信息(金钱,经验)
%%--------------------------------------
handle_cmd(13006, Status, _) ->
    lib_player:send_player_attribute4(Status);

handle_cmd(Cmd, Player, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Id:~p, Data:~p~n", [Cmd, Player#player.id, Data]),
    {ok, error}.

pack_and_send(Player, Cmd, Data) ->
    ?TRACE("pp_player:pack_and_send Cmd:~p, Player:~p, Data:~p~n", [Cmd, Player#player.id, Data]),
    {ok, BinData} = pt_13:write(Cmd, Data),
    lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData).