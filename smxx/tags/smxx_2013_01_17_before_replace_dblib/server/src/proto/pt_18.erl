%%%-----------------------------------
%%% @Module  : pt_18
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 18 邮件和系统广播
%%%-----------------------------------
-module(pt_18).
-export([read/2, write/2]).
-include("common.hrl").

%%%=========================================================================
%%% 解包函数
%%%=========================================================================

%%读取邮件
read(18001, <<NId:32>>) ->
    {ok, [NId]};
%% -----------------------------------------------------------------
%% 读取通知中的内容
%% -----------------------------------------------------------------
read(18003, _R) ->
    {ok, []};

read(18004, <<NId:32>>) ->
    {ok, [NId]};


%%替身娃娃查询
read(18100,_R) ->
	{ok,[]};

%%替身娃娃设置
read(18101,<<Flag:8,Type:8,Index:8>>) ->
	{ok,[Flag,Type,Index]};


read(_Cmd, _R) ->
    {error, no_match}.


%%%=========================================================================
%%% 组包函数
%%%=========================================================================

%% -----------------------------------------------------------------
%% 消息通知
%% -----------------------------------------------------------------
write(18001, NoticeList) ->
	Len = length(NoticeList) ,
	BinData = 
		case Len =:= 0 of
			true ->
				<<>> ;
			false ->
				lists:map(
				  fun(X) ->
						  [Type,Content|T] = X ,
						  CntBin = tool:to_binary(Content),
						  CntBinLen = byte_size(CntBin),
						   case T of
							  	[] ->					%%若是空的，Nid，OtherId都置为0
								  Nid     = 0,
								  OtherId = 0;
							  	_ ->
								  [Nid,OtherId] = T
						  	end,
%%  						  io:format("write(18001, Nid=~p, OtherId=~p~n",[Nid, OtherId]),
						  <<Nid:32,Type:8,CntBinLen:16,CntBin/binary,OtherId:32>>
				  end,NoticeList)
		end ,
	Records = tool:to_binary(BinData) ,
	{ok, pt:pack(18001, <<Len:16, Records/binary>>)};
	

%% -----------------------------------------------------------------
%% 系统广播
%% -----------------------------------------------------------------
write(18002, Content) ->
	CntBin = tool:to_binary(Content),
	CntBinLen = byte_size(CntBin),
	Data = <<CntBinLen:16,CntBin/binary>>,
    {ok, pt:pack(18002, Data)};

%% -----------------------------------------------------------------
%% 系统通知
%% -----------------------------------------------------------------
write(18003, NoticeList) ->
	case NoticeList of
		[] ->
			Len = 0 ,
			BinData = <<>> ;
		_ ->
			Len = length(NoticeList) ,
			BinData = lists:map(fun({NId,NClaz,Exp,Eng,Gold,Coin,Prstg,GoodsList,Cont}) ->
										GoodsLen = length(GoodsList)  ,
										GoodsBinList = lists:map(fun({GoodTypeId,GoodsNum}) ->
																	 <<GoodTypeId:32,GoodsNum:32>>
															 end , GoodsList) ,
										GoodsBin = tool:to_binary(GoodsBinList) ,
										
										CntBin = tool:to_binary(Cont) ,
										CntBinLen = byte_size(CntBin) ,
										<<NId:32,NClaz:8,Exp:32,Eng:32,Gold:32,Coin:32,Prstg:32,GoodsLen:16,GoodsBin/binary,CntBinLen:16,CntBin/binary>> 
										end,NoticeList)
	end ,
	Records = tool:to_binary(BinData) ,
    {ok, pt:pack(18003, <<Len:16,Records/binary>>)};

%% -----------------------------------------------------------------
%% 领取通知附件结果
%% -----------------------------------------------------------------
write(18004, [Code,GoodsList,Cont]) ->
	Len = length(GoodsList) ,
	F = fun({GoodTypeId,Number}) ->
				<<GoodTypeId:32,Number:32>>
		end ,
	RB = tool:to_binary([F(D) || D <- GoodsList]) ,
	{CntBinLen,ContBin} = tool:pack_string(Cont) ,
    {ok, pt:pack(18004, <<Code:8,Len:16,RB/binary,CntBinLen:16,ContBin/binary>>)};






%%替身娃娃查询
write(18100, DataList) ->
    NLen = length(DataList) ,
	F = fun({Type,Index,State,Attend,AwardList}) ->
				ALen = length(AwardList) ,
				FA = fun({GoodsTypeId,Number}) ->
							 <<GoodsTypeId:32,Number:32>>
					 end ,
				ARB = tool:to_binary([FA(D) || D <- AwardList]) ,
				<<Type:8,Index:8,State:8,Attend:8,ALen:16,ARB/binary>> 
		end ,
	RB = tool:to_binary([F(D) || D <- DataList]) ,
	Data = <<NLen:16,RB/binary>> ,
    {ok, pt:pack(18100, Data)} ;


%%设置替身娃娃
write(18101, [Code]) ->
    Data = <<Code:8>> ,	
    {ok, pt:pack(18101, Data)} ;

%%取消替身娃娃
write(18102, [Type,Index,Attnd]) ->
    Data = <<Type:8,Index:8,Attnd:8>> ,	
    {ok, pt:pack(18102, Data)} ;



write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

