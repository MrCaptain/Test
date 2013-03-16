%%--------------------------------------
%% @Module: pt_13
%% Author: Auto Generated
%% Created: Wed Jan 16 20:58:57 2013
%% Description: 
%%--------------------------------------
-module(pt_13).

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
%%Protocol: 13001 查询玩家自身信息
%%--------------------------------------
read(13001, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13002 查看其他玩家
%%--------------------------------------
read(13002,<<Uid:64>>) ->
    {ok, [Uid]};

%%--------------------------------------
%%Protocol: 13003 更新玩家信息
%%--------------------------------------
read(13003, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13004 更新玩家战力信息
%%--------------------------------------
read(13004, _) ->
    {ok, []};

%%--------------------------------------
%%Protocol: 13005 更新玩家金钱信息
%%--------------------------------------
read(13005, _) ->
    {ok, []};

%%--------------------------------------
%% undefined command
%%--------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.

%%--------------------------------------
%%Protocol: 13001 查询玩家自身信息
%%--------------------------------------
write(13001,[Uid,Gender,Level,Career,Speed,SceneId,X,Y,Hp,HpMax,Exp,ExpMax,Gold,BGold,Coin,BCoin,Name]) ->
    Name_StrBin = pack_string(Name),
    {ok, pt:pack(13001, <<Uid:64,Gender:8,Level:8,Career:8,Speed:8,SceneId:16,X:8,Y:8,Hp:32,HpMax:32,Exp:32,ExpMax:32,Gold:32,BGold:32,Coin:32,BCoin:32,Name_StrBin/binary>>)};

%%--------------------------------------
%%Protocol: 13002 查看其他玩家
%%--------------------------------------
write(13002,[StCode]) ->
    {ok, pt:pack(13002, <<StCode:8>>)};
write(13002,[StCode,Uid,Gander,Level,Career,Hp,Exp,Name]) ->
    Name_StrBin = pack_string(Name),
    {ok, pt:pack(13002, <<StCode:8,Uid:64,Gander:8,Level:8,Career:8,Hp:32,Exp:32,Name_StrBin/binary>>)};

%%--------------------------------------
%%Protocol: 13003 更新玩家信息
%%--------------------------------------
write(13003,[Hp,HpMax,Exp,ExpMax,Gold,BGold,Coin,BCoin]) ->
    {ok, pt:pack(13003, <<Hp:32,HpMax:32,Exp:32,ExpMax:32,Gold:32,BGold:32,Coin:32,BCoin:32>>)};

%%--------------------------------------
%%Protocol: 13004 更新玩家战力信息
%%--------------------------------------
write(13004,[Hp,HpMax,Exp,ExpMax]) ->
    {ok, pt:pack(13004, <<Hp:32,HpMax:32,Exp:32,ExpMax:32>>)};

%%--------------------------------------
%%Protocol: 13005 更新玩家金钱信息
%%--------------------------------------
write(13005,[Gold,BGold,Coin,BCoin]) ->
    {ok, pt:pack(13005, <<Gold:32,BGold:32,Coin:32,BCoin:32>>)};

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

