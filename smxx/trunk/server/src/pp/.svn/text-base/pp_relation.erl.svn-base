%%--------------------------------------
%% @Module: pp_relation
%% Author:  water
%% Created: Fri Feb 01 2013
%% Description:  关系模块
%%--------------------------------------
-module(pp_relation).

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
    ?TRACE("~p: Cmd: ~p, Id: ~p, Data:~p~n", [?MODULE, Cmd, Status#player.id, Data]),
    handle_cmd(Cmd, Status, Data).

%%--------------------------------------
%%Protocol: 14001 好友列表
%%--------------------------------------
handle_cmd(14001, Status, _) ->
    Data = lib_relation:get_friend_info(Status),
    pack_and_send(Status, 14001, [Data]);

%%--------------------------------------
%%Protocol: 14002 获取最近联系人列表
%%--------------------------------------
handle_cmd(14002, Status, _) ->
    Data = lib_relation:get_recent_info(Status),
    pack_and_send(Status, 14002, [Data]);

%%--------------------------------------
%%Protocol: 14003 获取仇人列表
%%--------------------------------------
handle_cmd(14003, Status, _) ->
    Data = lib_relation:get_foe_info(Status),
    pack_and_send(Status, 14003, [Data]);

%%--------------------------------------
%%Protocol: 14011 加好友
%%--------------------------------------
handle_cmd(14011, Status, [Uid]) ->
    case lib_relation:add_friend_request(Status, Uid) of
        true ->    
            pack_and_send(Status, 14011, [1]);
        {false, Reason} ->
            pack_and_send(Status, 14011, [Reason])
    end;

%%--------------------------------------
%%Protocol: 14012 好友请求列表
%%--------------------------------------
handle_cmd(14012, Status, _) ->
    ReqList = lib_relation:get_friend_req(Status),
    pack_and_send(Status, 14012, [ReqList]);

%%--------------------------------------
%%Protocol: 14013 同意加好友请求
%%--------------------------------------
handle_cmd(14013, Status, [Uid, Agree]) ->
    case lists:member(Uid, lib_relation:get_request_uids()) of  %%检查Uid有效性
        true ->
            if Agree =:= 1 ->  %%同意加为好友
                   lib_relation:add_friend_response(Status, Uid),
                   pack_and_send(Status, 14013, [1]);
               Agree =:= 2 ->  %%同意并加对方为好友
                   lib_relation:add_friend_response(Status, Uid),
                   case lib_relation:add_to_friend_list(Status, {Uid}) of
                        true ->
                            pack_and_send(Status, 14013, [1]);
                        {false, Reason} ->
                            pack_and_send(Status, 14013, [Reason])
                   end;
               true ->  %%不同意
                   pack_and_send(Status, 14013, [1])
            end;
       false ->
            pack_and_send(Status, 14013, [0])  %%Uid不是服务端发出的请求
   end;

%%--------------------------------------
%%Protocol: 14014 删除好友
%%--------------------------------------
handle_cmd(14014, Status, [Uid]) ->
    case lib_relation:delete_from_friend_list(Status#player.id, Uid) of
        true ->
             pack_and_send(Status, 14014, [1]);
        {false, Reason} ->
             pack_and_send(Status, 14014, [Reason])
    end;

%%--------------------------------------
%%Protocol: 14015 加到仇恨名单中
%%--------------------------------------
handle_cmd(14015, Status, [Uid]) ->
    case lib_relation:add_to_foe_list(Status, {Uid}) of
        true ->    
            pack_and_send(Status, 14015, [1]);
        {false, Reason} ->
            pack_and_send(Status, 14015, [Reason])
    end;

%%--------------------------------------
%%Protocol: 14016 从仇恨名单清除
%%--------------------------------------
handle_cmd(14016, Status, [Uid]) ->
    case lib_relation:delete_from_foe_list(Status#player.id, Uid) of
        true ->
             pack_and_send(Status, 14016, [1]);
        {false, Reason} ->
             pack_and_send(Status, 14016, [Reason])
    end;

%%--------------------------------------
%%Protocol: 14021 发送好友祝福通知
%%--------------------------------------
handle_cmd(14021, Status, [Uid,Type]) ->
    case lib_relation:send_bless_to_friend(Status, Uid, Type) of
        true ->
             pack_and_send(Status, 14021, [1]);
        {false, Reason} ->
             pack_and_send(Status, 14021, [Reason])
    end;

handle_cmd(Cmd, Status, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Status:~p, Data:~p~n", [Cmd, Status, Data]),
    {ok, error}.

pack_and_send(Status, Cmd, Data) ->
    ?TRACE("~p pack_and_send: Cmd: ~p, Id: ~p, Data:~p~n", [?MODULE, Cmd, Status#player.id, Data]),
    {ok, BinData} = pt_14:write(Cmd, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

