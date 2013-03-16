%%--------------------------------------
%% @Module: pt_14
%% Author: Auto Generated
%% Created: Sat Feb 02 11:31:01 2013
%% Description: 
%%--------------------------------------
-module(pt_14).

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
%%Protocol: 14000 查找好友
%%--------------------------------------
read(14000,<<BinData/binary>>) ->
    {Name, _Name_DoneBin} = pt:read_string(BinData),
    {ok, [Name]};

%%--------------------------------------
%%Protocol: 14001 好友列表
%%--------------------------------------
read(14001, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 14002 获取最近联系人列表
%%--------------------------------------
read(14002, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 14003 获取仇人列表
%%--------------------------------------
read(14003, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 14011 加好友
%%--------------------------------------
read(14011,<<Uid:64>>) ->
    {ok, [Uid]};

%%--------------------------------------
%%Protocol: 14012 添加好友请求
%%--------------------------------------
read(14012, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 14013 同意加好友请求
%%--------------------------------------
read(14013,<<Uid:64,Agree:8>>) ->
    {ok, [Uid, Agree]};

%%--------------------------------------
%%Protocol: 14014 删除好友
%%--------------------------------------
read(14014,<<Uid:64>>) ->
    {ok, [Uid]};

%%--------------------------------------
%%Protocol: 14015 加到仇恨名单中
%%--------------------------------------
read(14015,<<Uid:64>>) ->
    {ok, [Uid]};

%%--------------------------------------
%%Protocol: 14016 从仇恨名单清除
%%--------------------------------------
read(14016,<<Uid:64>>) ->
    {ok, [Uid]};

%%--------------------------------------
%%Protocol: 14021 发送好友祝福通知
%%--------------------------------------
read(14021,<<Uid:64,Type:8>>) ->
    {ok, [Uid, Type]};

%%--------------------------------------
%%Protocol: 14022 接收好友祝福
%%--------------------------------------

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 14000 查找好友
%%--------------------------------------
write(14000,[StCode]) ->
    {ok, pt:pack(14000, <<StCode:8>>)};
write(14000,[StCode,Uid,Gender,Career]) ->
    {ok, pt:pack(14000, <<StCode:8,Uid:64,Gender:8,Career:8>>)};

%%--------------------------------------
%%Protocol: 14001 好友列表
%%--------------------------------------
write(14001,[FriendList]) ->
    Fun_FriendList = fun([Uid,Name,Gender,Career,OnlineFlag,FriendShip]) ->
        Name_StrBin = pack_string(Name),
        <<Uid:64,Name_StrBin/binary,Gender:8,Career:8,OnlineFlag:8,FriendShip:16>>
    end,
    FriendList_Len = length(FriendList),
    FriendList_ABin = any_to_binary(lists:map(Fun_FriendList,FriendList)),
    FriendList_ABinData = <<FriendList_Len:16, FriendList_ABin/binary>>,
    {ok, pt:pack(14001, <<FriendList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 14002 获取最近联系人列表
%%--------------------------------------
write(14002,[RecentList]) ->
    Fun_RecentList = fun([Uid,Name,Gender,Career,OnlineFlag,LastTime]) ->
        Name_StrBin = pack_string(Name),
        <<Uid:64,Name_StrBin/binary,Gender:8,Career:8,OnlineFlag:8,LastTime:32>>
    end,
    RecentList_Len = length(RecentList),
    RecentList_ABin = any_to_binary(lists:map(Fun_RecentList,RecentList)),
    RecentList_ABinData = <<RecentList_Len:16, RecentList_ABin/binary>>,
    {ok, pt:pack(14002, <<RecentList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 14003 获取仇人列表
%%--------------------------------------
write(14003,[RecentList]) ->
    Fun_RecentList = fun([Uid,Name,Gender,Career,OnlineFlag,Hostitily]) ->
        Name_StrBin = pack_string(Name),
        <<Uid:64,Name_StrBin/binary,Gender:8,Career:8,OnlineFlag:8,Hostitily:16>>
    end,
    RecentList_Len = length(RecentList),
    RecentList_ABin = any_to_binary(lists:map(Fun_RecentList,RecentList)),
    RecentList_ABinData = <<RecentList_Len:16, RecentList_ABin/binary>>,
    {ok, pt:pack(14003, <<RecentList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 14011 加好友
%%--------------------------------------
write(14011,[Result]) ->
    {ok, pt:pack(14011, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 14012 添加好友请求
%%--------------------------------------
write(14012,[RequestList]) ->
    Fun_RequestList = fun([Uid,Name,Career,Gender,Camp,Level]) ->
        Name_StrBin = pack_string(Name),
        <<Uid:64,Name_StrBin/binary,Career:8,Gender:8,Camp:8,Level:8>>
    end,
    RequestList_Len = length(RequestList),
    RequestList_ABin = any_to_binary(lists:map(Fun_RequestList,RequestList)),
    RequestList_ABinData = <<RequestList_Len:16, RequestList_ABin/binary>>,
    {ok, pt:pack(14012, <<RequestList_ABinData/binary>>)};

%%--------------------------------------
%%Protocol: 14013 同意加好友请求
%%--------------------------------------
write(14013,[Result]) ->
    {ok, pt:pack(14013, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 14014 删除好友
%%--------------------------------------
write(14014,[Result]) ->
    {ok, pt:pack(14014, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 14015 加到仇恨名单中
%%--------------------------------------
write(14015,[Result]) ->
    {ok, pt:pack(14015, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 14016 从仇恨名单清除
%%--------------------------------------
write(14016,[Result]) ->
    {ok, pt:pack(14016, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 14021 发送好友祝福通知
%%--------------------------------------
write(14021,[Result]) ->
    {ok, pt:pack(14021, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 14022 接收好友祝福
%%--------------------------------------
write(14022,[Uid,Name,Type]) ->
    Name_StrBin = pack_string(Name),
    {ok, pt:pack(14022, <<Uid:64,Name_StrBin/binary,Type:8>>)};

%%--------------------------------------
%% undefined command 
%%--------------------------------------
write(Cmd, _R) ->
    ?ERROR_MSG("cmd_[~p] ",[Cmd]),
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

