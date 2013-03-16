%%%-----------------------------------
%%% @Module  : pt_11
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 11聊天信息
%%%-----------------------------------
-module(pt_11).
-export([read/2, write/2, write/3, write/4]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%世界聊天
read(11010, <<Bin/binary>>) ->
    {Msg, _} = pt:read_string(Bin),
    {ok, [Msg]};

%%集结号初始信息
read(11020, _) ->
    {ok, []};

%%集结号发送
read(11021, <<Type:8, Bin/binary>>) ->
	{Msg, _} = pt:read_string(Bin),
    {ok, [Type, Msg]};

%%氏族聊天
read(11030, <<Bin/binary>>) ->
    {Msg, _} = pt:read_string(Bin),
    {ok, [Msg]};

%%队伍聊天
read(11040, <<Bin/binary>>) ->
    {Msg, _} = pt:read_string(Bin),
    {ok, [Msg]};

%%场景聊天
read(11050, <<Bin/binary>>) ->
    {Msg, _} = pt:read_string(Bin),
    {ok, [Msg]};

%%传音
read(11060, <<Color:8, Bin/binary>>) ->
    {Msg, _} = pt:read_string(Bin),
    {ok, [Color, Msg]};

%%私聊
read(11070, <<Id:32, Bin/binary>>) ->
	{Msg, _} = pt:read_string(Bin),
    {ok, [Id, Msg]};

%%物品以及宠物展示
read(11100,<<Bin/binary>>) ->
%% 	?DEBUG("11100",[[1]]),
	{TypeString, Bin1} = pt:read_string(Bin),
	{Name, _} = pt:read_string(Bin1),
	{ok,[TypeString,Name]};



read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%世界
write(11010, [Id, Nick, Career, Sex, State,Bin]) ->
	pack_chat(11010, [Id, Nick, Career, Sex, State,Bin]);

%%世界错误
write(11011, [Errno, Value]) ->
	pack_error(11011, [Errno, Value]);

%%集结号初始信息
write(11020, [LNum, BNum]) ->
	{ok, pt:pack(11020, <<LNum:16, BNum:16>>)};

%%集结号发送
write(11021, [Res]) ->
	{ok, pt:pack(11021, <<Res:8>>)};

%%小集结号广播
write(11022, [Id, Nick, Career,  Sex, State, Bin]) ->
	pack_chat(11022, [Id, Nick, Career,  Sex, State, Bin]);

%%大集结号广播
write(11023, [Id, Nick, Career,  Sex, State, Bin]) ->
	pack_chat(11023, [Id, Nick, Career,  Sex, State, Bin]);

%%联盟
write(11030, [Id, Nick, Career,  Sex, State, Upst, Bin]) ->
	pack_chat(11030, [Id, Nick, Career,  Sex, State, Upst, Bin]);

%%联盟错误
write(11031, [Errno, Value]) ->
	pack_error(11031, [Errno, Value]);

%%队伍
write(11040, [Id, Nick, Lv, Sex, State, Bin]) ->
	pack_chat(11040, [Id, Nick, Lv,  Sex, State,Bin]);

%%队伍错误
write(11041, [Errno, Value]) ->
	pack_error(11041, [Errno, Value]);

%%场景
write(11050, [Id, Nick, Career,  Sex, State, Bin]) ->
	pack_chat(11050, [Id, Nick, Career,  Sex, State, Bin]);

%%场景错误
write(11051, [Errno, Value]) ->
	pack_error(11051, [Errno, Value]);

%%传音
write(11060, [Id, Nick, Lv,  Sex, Career, Color, State, Bin]) ->
    Nick1 = tool:to_binary(Nick),
    NickLen = byte_size(Nick1),
    Bin1 = tool:to_binary(Bin),
    BinLen = byte_size(Bin1),
    Data = <<Id:32, NickLen:16, Nick1/binary, Lv:8,  Sex:8, Career:8, Color:8, State:8,BinLen:16, Bin1/binary>>,
    {ok, pt:pack(11060, Data)};

%%传音错误
write(11061, [Errno, Value]) ->
	pack_error(11061, [Errno, Value]);

%%私聊
write(11070, [Id, Career, Sex, Nick, Bin]) ->
    Nick1 = tool:to_binary(Nick),
    Len = byte_size(Nick1),
    Bin1 = tool:to_binary(Bin),
    Len1 = byte_size(Bin1),
    Data = <<Id:32, Career:8, Sex:8, Len:16, Nick1/binary, Len1:16, Bin1/binary>>,
    {ok, pt:pack(11070, Data)};

%%私聊返回黑名单通知
write(11071, Id) ->
    {ok, pt:pack(11071, <<Id:32>>)};

%%私聊返回，假如对方不在线 
write(11072, Id) ->
    {ok, pt:pack(11072, <<Id:32>>)};

%%系统信息
write(11080, Msg) ->
    Msg1 = tool:to_binary(Msg),
    Len1 = byte_size(Msg1),
	Data = <<5:16, Len1:16, Msg1/binary>>,
	write(11080, 3, Data);


%%中央提示
write(11081, Msg) ->
    Msg1 = tool:to_binary(Msg),
    Len1 = byte_size(Msg1),
    Data = <<Len1:16, Msg1/binary>>,
    {ok, pt:pack(11081, Data)};

%%悬浮提示
write(11082, Msg) ->
    Msg1 = tool:to_binary(Msg),
    Len1 = byte_size(Msg1),
    Data = <<Len1:16, Msg1/binary>>,
    {ok, pt:pack(11082, Data)};

%%半夜12点提醒
write(11111, is_midnight) ->
    {ok, pt:pack(11111, <<>>)};

%%系统广播
%%BinList的打包
%% 参数类型 （0=>普通文本
%% 			10=>人物1 玩家ID~玩家名称~玩家名称
%% 			11=>人物2
%% 			20=>装备1 物品ID~物品形象ID~物品强化等级~物品品质颜色~物品名字
%% 			30=>物品
%% 			40=>巨兽
%% 			50=>宠物）
%% AttList为列表的列表，其中元素如上，如人物[玩家ID,玩家名字，玩家名字]
write(11090, [Type, AttList]) ->
	ListNum = length(AttList),
	F = fun(PerList) ->
%% 				io:format("110900000000 ~p~n",[1]),
				PerBin = pack_form(PerList, []),
%% 				io:format("110900000000 ~p~n",[2]),
				BinLen = byte_size(PerBin),
				<<BinLen:16, PerBin/binary>>
		end,
	LB = tool:to_binary([F(X) || X <- AttList, X /= []]),
    Data = <<Type:16, ListNum:16, LB/binary>>,
    {ok, pt:pack(11090, Data)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%%系统信息
write(11080, Type, Msg) ->
    Data = <<Type:8, Msg/binary>>,
	%io:format("~s write 11080[~p] \n ",[misc:time_format(now()), Data]),
    {ok, pt:pack(11080, Data)}.

write(11080, Show, Info, Msg) ->
    Msg1 = tool:to_binary(Msg),
    Len1 = byte_size(Msg1),
	Data = <<Info:16, Len1:16, Msg1/binary>>,
	write(11080, Show, Data).




%%聊天内容打包
pack_chat(11030, [Id, Nick, Lv,  Sex, State, Upst, Bin]) ->
    Nick1 = tool:to_binary(Nick),
    Len = byte_size(Nick1),
    Bin1 = tool:to_binary(Bin),
    Len1 = byte_size(Bin1),
    Data = <<Id:32, Len:16, Nick1/binary, Lv:8,  Sex:8, State:8, Upst:8, Len1:16, Bin1/binary>>,
    {ok, pt:pack(11030, Data)};

pack_chat(Cmd, [Id, Nick, Lv,  Sex, State, Bin]) ->
    Nick1 = tool:to_binary(Nick),
    Len = byte_size(Nick1),
    Bin1 = tool:to_binary(Bin),
    Len1 = byte_size(Bin1),
    Data = <<Id:32, Len:16, Nick1/binary, Lv:8,  Sex:8, State:8, Len1:16, Bin1/binary>>,
    {ok, pt:pack(Cmd, Data)}.

%% 11090的打包
pack_form(PerList, Content) ->
	if
		length(PerList) =:= 0 ->
			tool:to_binary(Content);
		true ->
			[H|T] = PerList,
			NewContent = 
				if
					Content =:= [] ->
						lists:concat([H]);
					true ->
						lists:concat([Content, "~", H])
				end,
			pack_form(T, NewContent)
	end.

%%错误打包
pack_error(Cmd, [Errno, Value]) ->
    Data = <<Errno:8, Value:32>>,
    {ok, pt:pack(Cmd, Data)}.
