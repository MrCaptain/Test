%%--------------------------------------
%% @Module: pt_44
%% Author: Auto Generated
%% Created: Fri Mar 15 15:10:47 2013
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
%%Protocol: 44001 升级技能
%%--------------------------------------
read(44001, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44002 确认技能升级(刷新技能经验)
%%--------------------------------------
read(44002, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44003 换装
%%--------------------------------------
read(44003,<<FashId:8>>) ->
    {ok, [FashId]};

%%--------------------------------------
%%Protocol: 44004 上坐骑(休息)
%%--------------------------------------
read(44004, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44005 下坐骑(休息)
%%--------------------------------------
read(44005, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44006 升星
%%--------------------------------------
read(44006, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 44007 升阶
%%--------------------------------------
read(44007, _) ->
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
write(44000,[StCode,Level,Star,Exp,Fashion,Riding,SkillList,FashionList,OldFashionList]) ->
    Fun_SkillList = fun([SkillId,SkillLv,SkillExp]) ->
        <<SkillId:8,SkillLv:8,SkillExp:16>>
    end,
    SkillList_Len = length(SkillList),
    SkillList_ABin = any_to_binary(lists:map(Fun_SkillList,SkillList)),
    SkillList_ABinData = <<SkillList_Len:16, SkillList_ABin/binary>>,
    Fun_FashionList = fun([FashId,ExpireTime]) ->
        <<FashId:8,ExpireTime:32>>
    end,
    FashionList_Len = length(FashionList),
    FashionList_ABin = any_to_binary(lists:map(Fun_FashionList,FashionList)),
    FashionList_ABinData = <<FashionList_Len:16, FashionList_ABin/binary>>,
    Fun_OldFashionList = fun([FashId,ExpireTime]) ->
        <<FashId:8,ExpireTime:32>>
    end,
    OldFashionList_Len = length(OldFashionList),
    OldFashionList_ABin = any_to_binary(lists:map(Fun_OldFashionList,OldFashionList)),
    OldFashionList_ABinData = <<OldFashionList_Len:16, OldFashionList_ABin/binary>>,
    {ok, pt:pack(44000, <<StCode:8,Level:8,Star:8,Exp:32,Fashion:8,Riding:8,SkillList_ABinData/binary,FashionList_ABinData/binary,OldFashionList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 44001 升级技能
%%--------------------------------------
write(44001,[StCode]) ->
    {ok, pt:pack(44001, <<StCode:8>>)};
write(44001,[StCode,CodeA,CodeB,CodeC,CodeD]) ->
    {ok, pt:pack(44001, <<StCode:8,CodeA:8,CodeB:8,CodeC:8,CodeD:8>>)};

%%--------------------------------------
%%Protocol: 44002 确认技能升级(刷新技能经验)
%%--------------------------------------
write(44002,[StCode]) ->
    {ok, pt:pack(44002, <<StCode:8>>)};
write(44002,[StCode,SkillList]) ->
    Fun_SkillList = fun([SkillId,SkillLv,SkillExp]) ->
        <<SkillId:8,SkillLv:8,SkillExp:16>>
    end,
    SkillList_Len = length(SkillList),
    SkillList_ABin = any_to_binary(lists:map(Fun_SkillList,SkillList)),
    SkillList_ABinData = <<SkillList_Len:16, SkillList_ABin/binary>>,
    {ok, pt:pack(44002, <<StCode:8,SkillList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 44003 换装
%%--------------------------------------
write(44003,[Result]) ->
    {ok, pt:pack(44003, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 44004 上坐骑(休息)
%%--------------------------------------
write(44004,[Result]) ->
    {ok, pt:pack(44004, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 44005 下坐骑(休息)
%%--------------------------------------
write(44005,[Result]) ->
    {ok, pt:pack(44005, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 44006 升星
%%--------------------------------------
write(44006,[StCode]) ->
    {ok, pt:pack(44006, <<StCode:8>>)};
write(44006,[StCode,Type,NewExp,NewStar]) ->
    {ok, pt:pack(44006, <<StCode:8,Type:8,NewExp:16,NewStar:8>>)};

%%--------------------------------------
%%Protocol: 44007 升阶
%%--------------------------------------
write(44007,[Result]) ->
    {ok, pt:pack(44007, <<Result:8>>)};

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

