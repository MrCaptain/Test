%%--------------------------------------
%% @Module: pt_21
%% Author: Auto Generated
%% Created: Fri Jan 18 15:27:24 2013
%% Description: 
%%--------------------------------------
-module(pt_21).

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
%%Protocol: 21000 获取技能列表
%%--------------------------------------
read(21000, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 21001 学习技能
%%--------------------------------------
read(21001,<<SkillId:8>>) ->
    {ok, [SkillId]};

%%--------------------------------------
%%Protocol: 21002 升级技能
%%--------------------------------------
read(21002,<<SkillId:8>>) ->
    {ok, [SkillId]};

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 21000 获取技能列表
%%--------------------------------------
write(21000,[SkillList]) ->
    Fun_SkillList = fun([SkillId,Level]) ->
        <<SkillId:8,Level:8>>
    end,
    SkillList_Len = length(SkillList),
    SkillList_ABin = any_to_binary(lists:map(Fun_SkillList,SkillList)),
    SkillList_ABinData = <<SkillList_Len:16, SkillList_ABin/binary>>,
    {ok, pt:pack(21000, <<SkillList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 21001 学习技能
%%--------------------------------------
write(21001,[Result]) ->
    {ok, pt:pack(21001, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 21002 升级技能
%%--------------------------------------
write(21002,[Result]) ->
    {ok, pt:pack(21002, <<Result:8>>)};

%%--------------------------------------
%% undefined command 
%%--------------------------------------
write(Cmd, _R) ->
    ?ERROR_MSG("~s_errorcmd_[~p] ",[misc:time_format(csj_timer:now()), Cmd]),
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

