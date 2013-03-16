%%%-----------------------------------
%%% @Module  : pt
%%% @Author  : smxx_game
%%% @Created : 2010.10.05
%%% @Description: 协议公共函数
%%%-----------------------------------
-module(pt).
-include("common.hrl").
-include("record.hrl").
-export([read_string/1,pack/2, pack_string/1]).

%%读取字符串
read_string(Bin) ->
    case Bin of
        <<Len:16, Bin1/binary>> ->
            case Bin1 of
                <<Str:Len/binary-unit:8, Rest/binary>> ->
                    {binary_to_list(Str), Rest};
                _R1 ->
                    {[],<<>>}
            end;
        _R1 ->
            {[],<<>>}
    end.

pack_string(Str) ->
    BinData = tool:to_binary(Str),
    Len = byte_size(BinData),
    <<Len:16, BinData/binary>>.

%% 打包信息，添加消息头 
pack(Cmd, Data) ->
%%	pack_stat(Cmd),
	L = byte_size(Data) + 4,
	%% 选择压缩的协议
	ZipList = [],
	IsListMem = lists:member(Cmd, ZipList),
	if 
		IsListMem =:= true -> %% 需要进行压缩
		   NewData = zlib:compress(Data),
		   NL = byte_size(NewData) + 6,
		   <<NL:16, Cmd:16, NewData/binary>>;
	   true ->
		   <<L:16, Cmd:16, Data/binary>>
	end.

%% 统计输出数据包 
%% pack_stat(Cmd) ->
%% 	if Cmd =/= 10006 andalso Cmd =/= 12008 ->
%% 		?INFO_MSG("~s_write_[~p] ",[misc:time_format(game_timer:now()), Cmd]);
%%    		true -> no_out
%% 	end,
%% 	[NowBeginTime, NowCount] = 
%% 	case ets:match(?ETS_STAT_SOCKET,{Cmd, socket_out , '$3', '$4'}) of
%% 		[[OldBeginTime, OldCount]] ->
%% 			[OldBeginTime, OldCount+1];
%% 		_ ->
%% 			[game_timer:now(),1]
%% 	end,	
%% 	ets:insert(?ETS_STAT_SOCKET, {Cmd, socket_out, NowBeginTime, NowCount}).
