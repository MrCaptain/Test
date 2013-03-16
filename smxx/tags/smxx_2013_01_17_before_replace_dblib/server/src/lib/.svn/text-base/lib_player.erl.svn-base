%%%--------------------------------------
%%% @Module  : lib_player
%%% @Author  : 
%%% @Created : 2010.10.05
%%% @Description:角色相关处理
%%%--------------------------------------
-module(lib_player).
-compile(export_all).

-include("common.hrl").
-include("record.hrl"). 
%-include("battle.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%检测某个角色是否在线
is_online(PlayerId) ->
    case get_player_pid(PlayerId) of
        [] -> false;
        _Pid -> true
    end.

%%取得在线角色的进程PID
get_player_pid(PlayerId) ->
    PlayerProcessName = misc:player_process_name(PlayerId),
    case misc:whereis_name({global, PlayerProcessName}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true -> Pid;
                _ ->
                    []
            end;
        _ -> []
    end.

%% 根据角色名称查找ID
get_role_id_by_name(Name) ->
    db_agent_player:get_role_id_by_name(Name).

%%根据角色id查找名称
get_role_name_by_id(Id)->
    db_agent_player:get_role_name_by_id(Id).

%%检测指定名称的角色是否已存在
is_accname_exists(AccName) ->
    case db_agent_player:is_accname_exists(AccName) of
        []     -> false;
        _Other -> true
    end.

%% %% 获取角色禁言信息
%% get_donttalk_status(PlayerId) ->
%%     try
%%         case db_agent:get_donttalk_status(PlayerId) of
%%             [] -> [undefined, undefined];
%%             [TimeStart, Stop_chat_minutes] ->
%%                 [TimeStart, Stop_chat_minutes]
%%         end
%%     catch
%%         _:_ ->
%%             [undefined, undefined]
%%     end.


%%检测指定名称的角色是否已存在
is_exists_name(Name) ->
    case get_role_id_by_name(Name) of
         []    -> false;
        _Other -> true
    end.

%%取得在线角色的角色状态
get_online_info(Id) ->
    case ets:lookup(?ETS_ONLINE, Id) of
           [] ->
                get_user_info_by_id(Id);
           [R] ->
               case misc:is_process_alive(R#player.other#player_other.pid) of
                   true -> 
                    R;
                   false ->
                       ets:delete(?ETS_ONLINE, Id),
                       []
               end
    end.

%%获取玩家信息
get_user_info_by_id(Id) ->
    case get_player_pid(Id) of
        []  -> [];
        Pid ->
             case catch gen:call(Pid, '$gen_call', 'PLAYER', 2000) of
                 {'EXIT',_Reason} ->
                      [];
                 {ok, Player} ->
                    Player
             end
    end.

%%获取用户信息(按字段需求)
get_online_info_fields(Id, L) when is_integer(Id) ->
    case get_player_pid(Id) of
        [] -> 
            [];
        Pid ->
            get_online_info_fields(Pid, L)
    end;

get_online_info_fields(Pid, L) when is_pid(Pid) ->
    case catch gen:call(Pid, '$gen_call', {'PLAYER', L}, 2000) of
           {'EXIT',_Reason} ->
                  [];
           {ok, PlayerFields} ->
                   PlayerFields
    end.

%%增加人物经验入口(FromWhere)
add_exp(Status, Exp, _FromWhere) ->
     NewExp = Status#player.exp + Exp,
     Status#player{exp = NewExp}.
    
%% %% 经验
next_lv_exp(Career, Lv) ->
     TempPlayer = data_player:get(Career, Lv+1),
     TempPlayer#temp_player.exp.

% 发送角色经验和金钱属性改变通知
send_player_attribute(Status) ->
    ExpNextLevel = lib_player:next_lv_exp(Status#player.career, Status#player.level),
    Data = [ Status#player.hit_point,
             Status#player.hit_point_max,
             Status#player.exp,
             ExpNextLevel,
             Status#player.gold,
             Status#player.bgold,
             Status#player.coin,
             Status#player.bcoin ],
    {ok, BinData} = pt_13:write(13003, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%发送角色属性经验改变通知
send_player_attribute2(Status) ->
    ExpNextLevel = lib_player:next_lv_exp(Status#player.career, Status#player.level),
    Data = [ Status#player.hit_point,
             Status#player.hit_point_max,
             Status#player.exp,
             ExpNextLevel],
    {ok, BinData} = pt_13:write(13004, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%发送角色属性金钱改变通知
send_player_attribute3(Status) ->
    Data = [ Status#player.gold,
             Status#player.bgold,
             Status#player.coin,
             Status#player.bcoin ],
    {ok, BinData} = pt_13:write(13005, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%发送角色属性数值变化, 前端显示属性变化特效用
send_player_attribute3(_OldStatus, _NewStatus) ->
    skip.

%% 同步更新ETS中的角色数据
save_online(Player) ->
    %%更新本地ets里的用户信息
    ets:insert(?ETS_ONLINE, Player).
    %%更新对应场景中的用户信息
    %%mod_scene:update_player(Player).

%% 增加铜钱
add_coin(Status, 0) ->  
    Status;

add_coin(Status, Num) ->
    Coin = Status#player.coin + Num,
    case Coin >0 of
        false -> Status#player{coin = 0};
        true ->  Status#player{coin = Coin}
    end.

%% 增加铜钱
add_gold(Status, 0) ->  
    Status;

add_gold(Status, Num) ->
    Gold = Status#player.gold + Num,
    case Gold > 0 of
        false -> Status#player{gold = 0};
        true  -> Status#player{gold = Gold}
    end.
    

