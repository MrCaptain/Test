%%--------------------------------------
%% @Module: pp_mount
%% Author:  water
%% Created: Tue Jan 29 2013
%% Description: 座骑协议处理
%%--------------------------------------
-module(pp_mount).

%%--------------------------------------
%% Include files
%%--------------------------------------
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%%--------------------------------------
%% Exported Functions
%%--------------------------------------
-compile(export_all).

%% API Functions
handle(Cmd, Status, Data) ->
    ?TRACE("pp_mount: Cmd: ~p, Id: ~p, Data:~p~n", [Cmd, Status#player.id, Data]),
    handle_cmd(Cmd, Status, Data).

%%--------------------------------------
%%Protocol: 44000 获取座骑信息
%%--------------------------------------
handle_cmd(44000, Status, _) ->
    Data = lib_mount:get_mount_info(Status),
    pack_and_send(Status, 44000, Data);

%%--------------------------------------
%%Protocol: 44001 学习技能
%%--------------------------------------
handle_cmd(44001, Status, [SkillId]) ->
    if Status#player.mount_flag > 0 ->
        case lib_mount:learn_skill(Status, SkillId) of
            {true, NewStatus} ->
                %%刷新战斗属性
                pack_and_send(Status, 44001, [1]),
                {ok, NewStatus};
            {false, Reason} ->
                pack_and_send(Status, 44001, [Reason])
        end;
    true ->
        pack_and_send(Status, 44001, [0])
    end;

%%--------------------------------------
%%Protocol: 44003 换装
%%--------------------------------------
handle_cmd(44003, Status, [FashId]) ->
    if Status#player.mount_flag > 0 ->
        case lib_mount:change_fashion(Status, FashId) of
            {true, NewStatus} ->
                %%刷新战斗属性
                pack_and_send(Status, 44003, [1]),
                {ok, NewStatus};
            {false, Reason} ->
                pack_and_send(Status, 44003, [Reason])
        end;
    true ->
        pack_and_send(Status, 44003, [0])
    end;

%%--------------------------------------
%%Protocol: 44004 上坐骑
%%--------------------------------------
handle_cmd(44004, Status, _) ->
    if Status#player.mount_flag =:= 2 ->  %%有座骑但不使用
        case lib_mount:get_on_mount(Status) of
            {true, NewStatus} ->
                %%刷新战斗属性
                pack_and_send(Status, 44004, [1]),
                {ok, NewStatus};
            {false, Reason} ->
                pack_and_send(Status, 44004, [Reason])
        end;
    true ->
        pack_and_send(Status, 44004, [0])
    end;

%%--------------------------------------
%%Protocol: 44005 下坐骑
%%--------------------------------------
handle_cmd(44005, Status, _) ->
    if Status#player.mount_flag =:= 1 ->  %%有座骑并且正使用
        NewStatus = lib_mount:get_off_mount(Status),
        {ok, NewStatus};
    true ->
        pack_and_send(Status, 44005, [0])
    end;

handle_cmd(Cmd, Status, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Status:~p, Data:~p~n", [Cmd, Status, Data]),
    {ok, error}.

pack_and_send(Status, Cmd, Data) ->
    ?TRACE("pp_mount send: Cmd: ~p, Id: ~p, Data:~p~n", [Cmd, Status#player.id, Data]),
    {ok, BinData} = pt_44:write(Cmd, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

