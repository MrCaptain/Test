%%--------------------------------------
%% @Module: pt_45
%% Author: Auto Generated
%% Created: Thu Mar 14 10:50:06 2013
%% Description: 
%%--------------------------------------
-module(pt_45).

%%--------------------------------------
%% Include files
%%--------------------------------------
-include("common.hrl").
-include("record.hrl").

%%--------------------------------------
%% Exported Functions
%%--------------------------------------
-compile(export_all).


%%--------------------------------------
%%Protocol: 45001 获取玩家经脉信息
%%--------------------------------------
read(45001, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 45002 提升经脉
%%--------------------------------------
read(45002,<<MerType:8>>) ->
    {ok, [MerType]};

%%--------------------------------------
%%Protocol: 45003 提升筋骨
%%--------------------------------------
read(45003,<<MerType:8,IfProtect:8>>) ->
    {ok, [MerType, IfProtect]};

%%--------------------------------------
%%Protocol: 45004 2小时候候完成经脉提升(经脉1)
%%--------------------------------------
read(45004, _) ->
    {ok, []};

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 45001 获取玩家经脉信息
%%--------------------------------------
write(45001,[Mer1List,Mer2List]) ->
    Fun_Mer1List = fun([MerType,MerLv,BonesLv]) ->
        <<MerType:8,MerLv:8,BonesLv:8>>
    end,
    Mer1List_Len = length(Mer1List),
    Mer1List_ABin = any_to_binary(lists:map(Fun_Mer1List,Mer1List)),
    Mer1List_ABinData = <<Mer1List_Len:16, Mer1List_ABin/binary>>,
    Fun_Mer2List = fun([MerType,MerLv,BonesLv]) ->
        <<MerType:8,MerLv:8,BonesLv:8>>
    end,
    Mer2List_Len = length(Mer2List),
    Mer2List_ABin = any_to_binary(lists:map(Fun_Mer2List,Mer2List)),
    Mer2List_ABinData = <<Mer2List_Len:16, Mer2List_ABin/binary>>,
    {ok, pt:pack(45001, <<Mer1List_ABinData/binary,Mer2List_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 45002 提升经脉
%%--------------------------------------
write(45002,[Result]) ->
    {ok, pt:pack(45002, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 45003 提升筋骨
%%--------------------------------------
write(45003,[Result]) ->
    {ok, pt:pack(45003, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 45004 2小时候候完成经脉提升(经脉1)
%%--------------------------------------
write(45004,[Result]) ->
    {ok, pt:pack(45004, <<Result:8>>)};

%%--------------------------------------
%% undefined command 
%%--------------------------------------
write(Cmd, _R) ->
    ?ERROR_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%%------------------------------------
%% internal function
%%------------------------------------
pack_string(Str) ->
    BinData = tool:to_binary(Str),
    Len = byte_size(BinData),
    <<Len:16, BinData/binary>>.

any_to_binary(Any) ->
    tool:to_binary(Any).

