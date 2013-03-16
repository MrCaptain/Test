%%--------------------------------------
%% @Module: pt_44
%% Author: Auto Generated
%% Created: Tue Jan 29 14:41:34 2013
%% Description: 
%%--------------------------------------
-module(pt_44).

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
%%Protocol: 44000 获取座骑信息
%%--------------------------------------
read(44000, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44001 学习技能
%%--------------------------------------
read(44001,<<SkillId:8>>) ->
    {ok, [SkillId]};

%%--------------------------------------
%%Protocol: 44003 换装
%%--------------------------------------
read(44003,<<FashId:8>>) ->
    {ok, [FashId]};

%%--------------------------------------
%%Protocol: 44004 上坐骑
%%--------------------------------------
read(44004, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44005 下坐骑
%%--------------------------------------
read(44005, _) ->
    {ok, []};

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 44000 获取座骑信息
%%--------------------------------------
write(44000,[StCode]) ->
    {ok, pt:pack(44000, <<StCode:8>>)};
write(44000,[StCode,Level,Exp,Fashion,SkillList,FashionList]) ->
    Fun_SkillList = fun([SkillId,SkillLv]) ->
        <<SkillId:8,SkillLv:8>>
    end,
    SkillList_Len = length(SkillList),
    SkillList_ABin = any_to_binary(lists:map(Fun_SkillList,SkillList)),
    SkillList_ABinData = <<SkillList_Len:16, SkillList_ABin/binary>>,
    Fun_FashionList = fun([FashId]) ->
        <<FashId:8>>
    end,
    FashionList_Len = length(FashionList),
    FashionList_ABin = any_to_binary(lists:map(Fun_FashionList,FashionList)),
    FashionList_ABinData = <<FashionList_Len:16, FashionList_ABin/binary>>,
    {ok, pt:pack(44000, <<StCode:8,Level:8,Exp:32,Fashion:8,SkillList_ABinData/binary,FashionList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 44001 学习技能
%%--------------------------------------
write(44001,[Result]) ->
    {ok, pt:pack(44001, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 44003 换装
%%--------------------------------------
write(44003,[Result]) ->
    {ok, pt:pack(44003, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 44004 上坐骑
%%--------------------------------------
write(44004,[Result]) ->
    {ok, pt:pack(44004, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 44005 下坐骑
%%--------------------------------------
write(44005,[Result]) ->
    {ok, pt:pack(44005, <<Result:8>>)};

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

