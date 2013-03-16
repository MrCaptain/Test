%%--------------------------------------
%% @Module: pt_11
%% Author: Auto Generated
%% Created: Tue Feb 05 16:48:44 2013
%% Description: 
%%--------------------------------------
-module(pt_11).

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
%%Protocol: 11000 信息
%%--------------------------------------

%%--------------------------------------
%%Protocol: 11001 发送世界信息
%%--------------------------------------
read(11001,<<BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [Content]};

%%--------------------------------------
%%Protocol: 11002 发送场景信息
%%--------------------------------------
read(11002,<<BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [Content]};

%%--------------------------------------
%%Protocol: 11003 发送帮派信息
%%--------------------------------------
read(11003,<<BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [Content]};

%%--------------------------------------
%%Protocol: 11004 发送私聊信息
%%--------------------------------------
read(11004,<<PeerId:64,BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [PeerId, Content]};

%%--------------------------------------
%%Protocol: 11005 GM指令
%%--------------------------------------
read(11005,<<Type:8,BinData/binary>>) ->
    {Content, _Content_DoneBin} = pt:read_string(BinData),
    {ok, [Type, Content]};

%%--------------------------------------
%%Protocol: 11010 系统信息/广播
%%--------------------------------------

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 11000 信息
%%--------------------------------------
write(11000,[Uid,Name,Type,Content]) ->
    Name_StrBin = pack_string(Name),
    Content_StrBin = pack_string(Content),
    {ok, pt:pack(11000, <<Uid:64,Name_StrBin/binary,Type:8,Content_StrBin/binary>>)};

%%--------------------------------------
%%Protocol: 11001 发送世界信息
%%--------------------------------------
write(11001,[Result]) ->
    {ok, pt:pack(11001, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 11002 发送场景信息
%%--------------------------------------
write(11002,[Result]) ->
    {ok, pt:pack(11002, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 11003 发送帮派信息
%%--------------------------------------
write(11003,[Result]) ->
    {ok, pt:pack(11003, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 11004 发送私聊信息
%%--------------------------------------
write(11004,[Result]) ->
    {ok, pt:pack(11004, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 11005 GM指令
%%--------------------------------------
write(11005,[Result]) ->
    {ok, pt:pack(11005, <<Result:8>>)};

%%--------------------------------------
%%Protocol: 11010 系统信息/广播
%%--------------------------------------
write(11010,[Type,Content]) ->
    Content_StrBin = pack_string(Content),
    {ok, pt:pack(11010, <<Type:8,Content_StrBin/binary>>)};

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

