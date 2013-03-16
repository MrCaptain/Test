%%--------------------------------------
%% @Module: pt_19
%% Author: Auto Generated
%% Created: Thu Feb 07 14:24:21 2013
%% Description: 
%%--------------------------------------
-module(pt_19).

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
%%Protocol: 19001 玩家反馈到GM
%%--------------------------------------
read(19001,<<Type:8,BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [Type, Content]};

%%--------------------------------------
%%Protocol: 19002  获取GM反馈
%%--------------------------------------
read(19002, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 19010  是否有未读邮件
%%--------------------------------------
read(19010, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 19011  邮件列表
%%--------------------------------------
read(19011, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 19012  邮件具体内容
%%--------------------------------------
read(19012,<<MailId:32>>) ->
    {ok, [MailId]};

%%--------------------------------------
%%Protocol: 19013 回复邮件
%%--------------------------------------
read(19013,<<MailId:32,BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [MailId, Content]};

%%--------------------------------------
%%Protocol: 19014 收取附件
%%--------------------------------------
read(19014,<<MailId:32>>) ->
    {ok, [MailId]};

%%--------------------------------------
%%Protocol: 19015 删除邮件
%%--------------------------------------
read(19015,<<MailId:32>>) ->
    {ok, [MailId]};

%%--------------------------------------
%%Protocol: 19016 发送邮件
%%--------------------------------------
read(19016,<<BinData/binary>>) ->
    {Title, _Title_DoneBin} = pt:read_string(BinData),
    {Content, _Content_DoneBin} = pt:read_string(_Title_DoneBin),
    <<RecvListLen:16, RecvListBin/binary>> = _Content_DoneBin,
    Fun_RecvList = fun(_Idx, {RestBin, ResultList}) ->
        {Name, _Name_DoneBin} = pt:read_string(RestBin),
        {_Name_DoneBin, [Name|ResultList]}
    end,
    {_RecvList_DoneBin, RecvList} = lists:foldl(Fun_RecvList, {RecvListBin, []}, lists:seq(1,RecvListLen)),
    {ok, [Title, Content, lists:reverse(RecvList)]};

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 19001 玩家反馈到GM
%%--------------------------------------
write(19001,[Result]) ->
    {ok, pt:pack(19001, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 19002  获取GM反馈
%%--------------------------------------
write(19002,[FbList]) ->
    Fun_FbList = fun([FbId,Type,State,ContentList]) ->
        Fun_ContentList = fun([Name,Content,Date]) ->
            Name_StrBin = pack_string(Name),
            Content_StrBin = pack_string(Content),
            <<Name_StrBin/binary,Content_StrBin/binary,Date:32>>
        end,
        ContentList_Len = length(ContentList),
        ContentList_ABin = any_to_binary(lists:map(Fun_ContentList,ContentList)),
        ContentList_ABinData = <<ContentList_Len:16, ContentList_ABin/binary>>,
        <<FbId:32,Type:8,State:8,ContentList_ABinData/binary>>
    end,
    FbList_Len = length(FbList),
    FbList_ABin = any_to_binary(lists:map(Fun_FbList,FbList)),
    FbList_ABinData = <<FbList_Len:16, FbList_ABin/binary>>,
    {ok, pt:pack(19002, <<FbList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 19010  是否有未读邮件
%%--------------------------------------
write(19010,[Num]) ->
    {ok, pt:pack(19010, <<Num:8>>)};

%%--------------------------------------
%%Protocol: 19011  邮件列表
%%--------------------------------------
write(19011,[MailList]) ->
    Fun_MailList = fun([MailId,Type,State,Date,SName,Title]) ->
        SName_StrBin = pack_string(SName),
        Title_StrBin = pack_string(Title),
        <<MailId:32,Type:8,State:8,Date:32,SName_StrBin/binary,Title_StrBin/binary>>
    end,
    MailList_Len = length(MailList),
    MailList_ABin = any_to_binary(lists:map(Fun_MailList,MailList)),
    MailList_ABinData = <<MailList_Len:16, MailList_ABin/binary>>,
    {ok, pt:pack(19011, <<MailList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 19012  邮件具体内容
%%--------------------------------------
write(19012,[StCode]) ->
    {ok, pt:pack(19012, <<StCode:8>>)};
write(19012,[StCode,MailId,Content,GoodList]) ->
    Content_StrBin = pack_string(Content),
    Fun_GoodList = fun([GoodTypeId,GoodsNum,Exist]) ->
        <<GoodTypeId:32,GoodsNum:8,Exist:8>>
    end,
    GoodList_Len = length(GoodList),
    GoodList_ABin = any_to_binary(lists:map(Fun_GoodList,GoodList)),
    GoodList_ABinData = <<GoodList_Len:16, GoodList_ABin/binary>>,
    {ok, pt:pack(19012, <<StCode:8,MailId:32,Content_StrBin/binary,GoodList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 19013 回复邮件
%%--------------------------------------
write(19013,[Result]) ->
    {ok, pt:pack(19013, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 19014 收取附件
%%--------------------------------------
write(19014,[Result]) ->
    {ok, pt:pack(19014, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 19015 删除邮件
%%--------------------------------------
write(19015,[Result]) ->
    {ok, pt:pack(19015, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 19016 发送邮件
%%--------------------------------------
write(19016,[Result,ErrRecvList]) ->
    Fun_ErrRecvList = fun([ErrName]) ->
        ErrName_StrBin = pack_string(ErrName),
        <<ErrName_StrBin/binary>>
    end,
    ErrRecvList_Len = length(ErrRecvList),
    ErrRecvList_ABin = any_to_binary(lists:map(Fun_ErrRecvList,ErrRecvList)),
    ErrRecvList_ABinData = <<ErrRecvList_Len:16, ErrRecvList_ABin/binary>>,
    {ok, pt:pack(19016, <<Result:8,ErrRecvList_ABinData/binary>>)};

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

