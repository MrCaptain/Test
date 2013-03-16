%%%--------------------------------------
%%% @Module  : lib_account
%%% @Author  : 
%%% @Created : 2010.10.05
%%% @Description:用户账户处理
%%%--------------------------------------
-module(lib_account).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%% 检查账号是否存在
check_account(PlayerId, Accid) ->
    case db_agent_player:get_accountid_by_id(PlayerId) of
        [] ->
            false;
        AccountId ->
            case AccountId =:= Accid of
                true ->
                    true;
                false ->
                    false
            end
    end.

%% 通过帐号名称取得帐号信息
get_info_by_id(PlayerId) ->
    db_agent_player:get_info_by_id(PlayerId).

%% 取得指定帐号的角色列表
get_role_list(Accid, Accname) ->
    db_agent_player:get_role_list(Accid, Accname).

%% 创建角色
create_role(AccId, AccName, Name, Career, Sex) ->
    TempPlayer = data_player:get(1, Career),    
    %SceneId = lib_scene:auto_scene(101),
    SceneId = ?INIT_SCENE_ID,
    {X,Y} = ?INIT_SCENE_XY,
    Sex1 = if Sex == 1 ->    
               ?GENDER_MALE;     %男
            true ->
               ?GENDER_FEMALE    %女
            end,
    Career1 = if Career =:= ?CAREER_F orelse
                 Career =:= ?CAREER_M orelse
                 Career =:= ?CAREER_D ->    
                    Career;
              true ->
                    ?CAREER_F   %发错默认为神
              end,
    Time = util:unixtime(),
    %% 创建角色增加插入默认字段
    db_agent_player:create_role(AccId, AccName, Career1, Sex1, Name, Time, Time, SceneId, X, Y,
                              TempPlayer#temp_player.hit_point_max,
                              TempPlayer#temp_player.magic_max,
                              TempPlayer#temp_player.anger_max,
                              TempPlayer#temp_player.attack,
                              TempPlayer#temp_player.defense,
                              TempPlayer#temp_player.fattack,
                              TempPlayer#temp_player.mattack,
                              TempPlayer#temp_player.dattack,
                              TempPlayer#temp_player.fdefense,
                              TempPlayer#temp_player.mdefense,
                              TempPlayer#temp_player.ddefense,
                              TempPlayer#temp_player.speed,
                              TempPlayer#temp_player.attack_speed),
    Ret = lib_player:get_role_id_by_name(Name),
    Ret.


%% 删除角色
delete_role(PlayerId, Accid) ->
    case db_agent_player:delete_role(PlayerId, Accid) of
        1 -> true;
        _ -> false
    end.

getin_createpage(Accid) ->
    Nowtime = util:unixtime(),
    spawn(fun() -> db_agent:getin_createpage(Nowtime, Accid) end).


get_def_name(Acid) ->
    Name = lists:concat([?DEFAULT_NAME ++ "_"++integer_to_list(Acid)]),
    Name.

%%检查名字是否符合默认起名规则，如果符合，则允许修改
check_def_name(Name) ->
    case string:tokens(Name, "_") of
        [?DEFAULT_NAME,_] ->
            true;
        _ ->
            false
    end.

%% 创建角色后, 真正进入游戏, 写记录
real_play(Uid) ->
    spawn(fun()->db_log_agent:log_real_play(Uid)end).

