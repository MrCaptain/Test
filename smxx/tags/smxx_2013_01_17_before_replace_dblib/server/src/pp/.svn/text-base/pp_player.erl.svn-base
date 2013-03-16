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
%%Protocol: 13001 查询玩家自身信息
%%--------------------------------------
handle_cmd(13001, Status, _) ->
    ExpNextLevel = lib_player:next_lv_exp(Status#player.career, Status#player.level),
    pack_and_send(Status, 13001, [ Status#player.id,
                                   Status#player.gender,
                                   Status#player.level,
                                   Status#player.career,
                                   Status#player.speed,
                                   Status#player.scene,
                                   Status#player.x,
                                   Status#player.y,
                                   Status#player.hit_point,
                                   Status#player.hit_point_max,
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
            case db_agent_player:get_info_by_id(Uid) of
                [] -> 
                    PlayerStatus = 0;
                R  -> 
                    PlayerStatus = list_to_tuple([player|R])
            end
    end,
    if is_record(PlayerStatus, player) -> 
        pack_and_send(Status, 13002, [1, PlayerStatus#player.id,
                                         PlayerStatus#player.gender,
                                         PlayerStatus#player.level,
                                         PlayerStatus#player.career,
                                         PlayerStatus#player.hit_point,
                                         PlayerStatus#player.exp,
                                         PlayerStatus#player.nick
                                         ]);
    true ->
          pack_and_send(Status, 13002, [0])
    end;

%%--------------------------------------
%%Protocol: 13003 更新玩家信息
%%--------------------------------------
handle_cmd(13003, Status, _) ->
    lib_player:send_player_attribute(Status);

%%--------------------------------------
%%Protocol: 13004 更新玩家战力信息
%%--------------------------------------
handle_cmd(13004, Status, _) ->
    lib_player:send_player_attribute2(Status);

%%--------------------------------------
%%Protocol: 13005 更新玩家金钱信息
%%--------------------------------------
handle_cmd(13005, Status, _) ->
    lib_player:send_player_attribute3(Status);

handle_cmd(Cmd, Player, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Id:~p, Data:~p~n", [Cmd, Player#player.id, Data]),
    {ok, error}.

pack_and_send(Player, Cmd, Data) ->
    ?TRACE("pp_player:pack_and_send Cmd:~p, Player:~p, Data:~p~n", [Cmd, Player#player.id, Data]),
    {ok, BinData} = pt_13:write(Cmd, Data),
    lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData).

