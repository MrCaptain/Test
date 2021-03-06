%%%--------------------------------------
%%% @Module  : db_agent
%%% @Author  : smxx
%%% @Created : 2013.01.10
%%% @Description: 数据库处理模块(杂）
%%%--------------------------------------
-module(db_agent).
-include("common.hrl").
-include("record.hrl").
-compile(export_all).

%%获取自动ID
get_user_id() ->
    case ?DB_MODULE =:= db_mysql of
        true ->
            0;
        _ ->
            ?DB_MODULE:select_one(auto_ids, "id", [{name, "user"}], [], [1])
    end.

%% 是否创建角色
is_create(Accname)->
    ?DB_MODULE:select_all(player, "id", [{account_name, Accname}], [], [1]).

%%获取账号信息
update_account_id(AccName) ->
    case ?DB_MODULE:select_row(user,"*",[{account_name, AccName}],[],[1]) of
        [] ->
            AccId = ?DB_MODULE:insert(user, [account_id, account_name, state, id_card_status], [0, AccName, 0, 0]),
            ?DB_MODULE:update(user, [{account_id, AccId}], [{id, AccId}]);
        Data ->
            [AccId, _Acnm, _State, _IdCardState] = Data
    end,
    AccId.

%%获取账号user
get_user_info(Acid,Acnm) ->
    ?DB_MODULE:select_row(user,"*",[{account_id, Acid},{account_name, Acnm}]).

%% 设置账号状态(0-正常，1-禁止)
set_user_status(Accid, Status) ->
    ?DB_MODULE:update(user, [{status, Status}], [{account_id, Accid}]).

%% 读取账户防沉迷类型
get_idcard_status(Accid) ->
    ?DB_MODULE:select_one(user, "id_card_status", [{account_id, Accid}], [], [1]).

%% 读取账户防沉迷类型
get_idcard_status(Accid, Accname) ->
    case ?DB_MODULE:select_one(user, "id_card_state", [{account_id, Accid}], [], [1]) of
        [] ->
            ?DB_MODULE:insert(user,[account_id, account_name, state, id_card_state],[Accid, Accname, 0, 0]),
            0;
        Val ->
            Val    
    end.

%% 读取账户防沉迷类型(只查不写)
get_idcard_status2(Accid, _Accname) ->
    case ?DB_MODULE:select_one(user, "id_card_state", [{account_id, Accid}], [], [1]) of
        [] ->
            0;
        Val ->
            Val    
    end.

%% 设置账户防沉迷类型
set_idcard_status(Accid, Idcard_status) ->
    ?DB_MODULE:update(user, [{id_card_state, Idcard_status}], [{account_id, Accid}]).

%% 根据账户读取账户上次离线时间（账户纳入防沉迷）    
get_infant_time_byuser(Accid) ->
    ?DB_MODULE:select_one(infant_ctrl_byuser, "last_login_time", [{account_id, Accid}], [], [1]).
    
%% 读取账户累计游戏时间（账户纳入防沉迷）    
get_gametime_byuser(Accid)->
    ?DB_MODULE:select_one(infant_ctrl_byuser, "total_time", [{account_id, Accid}], [], [1]).

%% 读取账户账户纳入防沉迷记录    
get_infant_ctrl_byuser(Accid)->
    ?DB_MODULE:select_row(infant_ctrl_byuser, "*", [{account_id, Accid}],[1]).

%% 增加账户累计游戏时间
add_gametime_byuser(Accid, T_time)-> 
    ?DB_MODULE:update(infant_ctrl_byuser, [{total_time, T_time, add}], [{account_id, Accid}]).

%% 设置账户累计游戏时间（账户纳入防沉迷）
set_gametime_byuser(Accid, T_time)->
    ?DB_MODULE:update(infant_ctrl_byuser, [{total_time, T_time}], [{account_id, Accid}]).    
    
%% 设置账户上次离线时间（账户纳入防沉迷）
set_last_logout_time_byuser(Accid, L_time)->
    ?DB_MODULE:update(infant_ctrl_byuser, [{last_login_time, L_time}], [{account_id, Accid}]).    
    
%% 记录被纳入防沉迷的账户，并记录上次登陆时间
add_idcard_num_acc(Accid, TT_time, L_time) ->
    case ?DB_MODULE:select_one(infant_ctrl_byuser, "*", [{account_id, Accid}], [], [1]) of
        [] ->
            ?DB_MODULE:insert(infant_ctrl_byuser,[account_id, total_time, last_login_time],[Accid,TT_time,L_time]);
        Id ->
            Id
    end.

insert_infant_ctrl_byuser(Accid) ->
    Now = util:unixtime(),
    ?DB_MODULE:insert(infant_ctrl_byuser,[account_id, total_time, last_login_time],[Accid, 0, Now]).


%%加入服务器集群
add_server([Ip, Port, Sid, Node]) ->
    ?DB_MODULE:replace(server, [{id, Sid}, {ip, Ip}, {port, Port}, {node, Node}, {num,0}]).

%%退出服务器集群
del_server(Sid) ->
    ?DB_MODULE:delete(server, [{id, Sid}]).

%% 获取所有服务器集群
select_all_server() ->
    ?DB_MODULE:select_all(server, "*", []).

%%查询玩家的游戏系统配置数据
get_player_sys_settings(PlayerId) ->
    ?DB_MODULE:select_row(player_sys_setting, "*", [{player_id, PlayerId}], [], [1]).

%%初始化数据库玩家系统配置数据
init_player_sys_settings(PlayerSysSet) ->
    ValueList = lists:nthtail(1, tuple_to_list(PlayerSysSet)),
    FieldList = record_info(fields, player_sys_setting),
    ?DB_MODULE:insert(player_sys_setting, FieldList, ValueList).

%%更新玩家数据库系统配置数据
update_player_sys_settings(ValueList, WhereList) ->
    ?DB_MODULE:update(player_sys_setting, ValueList, WhereList).

