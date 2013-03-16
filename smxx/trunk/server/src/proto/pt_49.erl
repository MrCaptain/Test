%%%-----------------------------------
%%% @Module  : pt_49
%%% @Author  : csj
%%% @Created : 2012.10.05
%%% @Description: 49 矿山系统
%%%-----------------------------------
-module(pt_49).
-export([read/2, write/2]).
-include("common.hrl").

%%%=========================================================================
%%% 解包函数
%%%=========================================================================
%% -----------------------------------------------------------------
%% 玩家进入矿区
%% -----------------------------------------------------------------
read(49001, _R) ->
    {ok, []};

%% -----------------------------------------------------------------
%% 我的矿车信息
%% -----------------------------------------------------------------
read(49002, _R) ->
    {ok, []};

%% -----------------------------------------------------------------
%% 玩家查看矿区的铜矿列表
%% -----------------------------------------------------------------
read(49003, <<CopperId:16>>) ->
    {ok, [CopperId]};

%% -----------------------------------------------------------------
%% 玩家查看矿区的铜矿列表
%% -----------------------------------------------------------------
read(49004, <<CopperId:16>>) ->
    {ok, [CopperId]};

%% -----------------------------------------------------------------
%% 设置自动提取标志
%% -----------------------------------------------------------------
read(49005, <<AutoDraw:8>>) ->
    {ok, [AutoDraw]};

%% -----------------------------------------------------------------
%% 停止挖矿
%% -----------------------------------------------------------------
read(49006, _R) ->
    {ok, []};


%% -----------------------------------------------------------------
%% 刷新矿车
%% -----------------------------------------------------------------
read(49007, _R) ->
    {ok, []};


%% -----------------------------------------------------------------
%% 申请采矿
%% -----------------------------------------------------------------
read(49010, <<CopperId:32>>) ->
    {ok, [CopperId]};


%% -----------------------------------------------------------------
%% 批准采矿
%% -----------------------------------------------------------------
read(49011, <<UId:32,Flag:8>>) ->
    {ok, [UId,Flag]};


%% -----------------------------------------------------------------
%% 申请采矿列表
%% -----------------------------------------------------------------
read(49012, _R) ->
    {ok, []};


%% -----------------------------------------------------------------
%% 申请采矿列表
%% -----------------------------------------------------------------
read(49013, _R) ->
    {ok, []};

%% -----------------------------------------------------------------
%% 申请采矿列表
%% -----------------------------------------------------------------
read(49014, _R) ->
    {ok, []};


%% -----------------------------------------------------------------
%% 设置挖矿档次
%% -----------------------------------------------------------------
read(49015, <<Class:8>>) ->
    {ok, [Class]};


%% -----------------------------------------------------------------
%% 踢出挖矿
%% -----------------------------------------------------------------
read(49016, <<UId:32>>) ->
    {ok, [UId]};


%% -----------------------------------------------------------------
%% 挑战矿主
%% -----------------------------------------------------------------
read(49020, <<CopperId:32,MUId:32>>) ->
    {ok, [CopperId,MUId]};


%% -----------------------------------------------------------------
%% 玩家退出矿区
%% -----------------------------------------------------------------
read(49030, _R) ->
    {ok, []};




%% -----------------------------------------------------------------
%% 玩家请求博物堂开启状态
%% -----------------------------------------------------------------
read(49100, _R) ->
    {ok, []};

%% -----------------------------------------------------------------
%% 玩家请求博物堂进贡记录
%% -----------------------------------------------------------------
read(49103, <<Page:8>>) ->
    {ok, [Page]};


%% -----------------------------------------------------------------
%% 玩家请求博物堂进贡记录
%% -----------------------------------------------------------------
read(49104, <<GoodsTypeId:32>>) ->
    {ok, [GoodsTypeId]};


%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.



%%%=========================================================================
%%% 组包函数
%%%=========================================================================
%% -----------------------------------------------------------------
%% 玩家进入矿山
%% -----------------------------------------------------------------
write(49001,[Code,ScnId]) ->
	Data = <<Code:8,ScnId:32>> ,
	{ok, pt:pack(49001, Data)};

%% -----------------------------------------------------------------
%% 我的矿车信息
%% -----------------------------------------------------------------
write(49002,[Code,CartMax,Rsved,AutoFlag,Class,GoodsList]) ->
	Len = length(GoodsList) ,
	F = fun({GoodsTypeID,Number}) ->
				<<GoodsTypeID:32,Number:32>> 
		end ,
	RB = tool:to_binary([F(S) || S <- GoodsList]) ,
	Data = <<Code:8,CartMax:32,Rsved:32,AutoFlag:8,Class:8,Len:16,RB/binary>> ,
	{ok, pt:pack(49002, Data)};

%% -----------------------------------------------------------------
%% 玩家查看矿区的铜矿列表
%% -----------------------------------------------------------------
write(49003,[CopperList,PlayerList]) ->
	CLen = length(CopperList) ,
	CF = fun({CId,Resv,Diggers,Type,MUId,Master,UNid,UNName,Left}) ->
				{NmLen,NmBin} = tool:pack_string(Master) ,
				{UNLen,UNBin} = tool:pack_string(UNName) ,
				<<CId:16,Resv:32,Diggers:16,Type:8,MUId:32,NmLen:16,NmBin/binary,UNid:32,UNLen:16,UNBin/binary,Left:32>> 
		end ,
	CRB = tool:to_binary([CF(S) || S <- CopperList]) ,
	
	PLen = length(PlayerList) ,
	PF = fun({UId,Stts}) ->
				<<UId:32,Stts:8>> 
		end ,
	PRB = tool:to_binary([PF(S) || S <- PlayerList]) ,
	
	Data = <<CLen:16,CRB/binary,PLen:16,PRB/binary>>,
    {ok, pt:pack(49003, Data)} ;

%% -----------------------------------------------------------------
%% 开始挖矿
%% -----------------------------------------------------------------
write(49004,[Code,CarhMax,AutoFlag,CopperId]) ->
	Data = <<Code:8,CarhMax:32,AutoFlag:8,CopperId:16>> ,
	{ok, pt:pack(49004, Data)};


%% -----------------------------------------------------------------
%% 设置自动提取标志
%% -----------------------------------------------------------------
write(49005,[Code]) ->
	Data = <<Code:8>> ,
	{ok, pt:pack(49005, Data)};

%% -----------------------------------------------------------------
%% 停止挖矿
%% -----------------------------------------------------------------
write(49006,[Code]) ->
	Data = <<Code:8>> ,
	{ok, pt:pack(49006, Data)};


%% -----------------------------------------------------------------
%% 刷新矿车
%% -----------------------------------------------------------------
write(49007,[Code,LeftTime,CartMax,Rsved,CurRsved,AutoFlag,Class,CostEng,GoodsList]) ->
	Len = length(GoodsList) ,
	F = fun({GoodsTypeID,Number}) ->
				<<GoodsTypeID:32,Number:32>> 
		end ,

	RB = tool:to_binary([F(S) || S <- GoodsList]) ,
	Data = <<Code:8,LeftTime:8,CartMax:32,Rsved:32,CurRsved:32,AutoFlag:8,Class:8,CostEng:8,Len:16,RB/binary>> ,
	{ok, pt:pack(49007, Data)};


%% -----------------------------------------------------------------
%% 通知玩家矿山被挖空
%% -----------------------------------------------------------------
write(49008,[CId,Stts]) ->
	Data = <<CId:16,Stts:8>> ,
	{ok, pt:pack(49008, Data)};


%% -----------------------------------------------------------------
%% 申请采矿
%% -----------------------------------------------------------------
write(49010,[Code]) ->
	Data = <<Code:8>> ,
	{ok, pt:pack(49010, Data)};


%% -----------------------------------------------------------------
%% 批准申请采矿
%% -----------------------------------------------------------------
write(49011,[Code]) ->
	Data = <<Code:8>> ,
	{ok, pt:pack(49011, Data)};



%% -----------------------------------------------------------------
%% 申请列表
%% -----------------------------------------------------------------
write(49012,ApplyList) ->
	Len = length(ApplyList) ,
	F = fun({UID,Nick,Lv}) ->
				{NmLen,NmBin} = tool:pack_string(Nick) ,
				<<UID:32,NmLen:16,NmBin/binary,Lv:16>> 
		end ,
	RB = tool:to_binary([F(S) || S <- ApplyList]) ,
	Data = <<Len:16,RB/binary>>,
    {ok, pt:pack(49012, Data)} ;


%% -----------------------------------------------------------------
%% 申请列表
%% -----------------------------------------------------------------
write(49013,DiggerList) ->
	Len = length(DiggerList) ,
	F = fun({UID,Nick,Lv}) ->
				{NmLen,NmBin} = tool:pack_string(Nick) ,
				<<UID:32,NmLen:16,NmBin/binary,Lv:16>> 
		end ,
	RB = tool:to_binary([F(S) || S <- DiggerList]) ,
	Data = <<Len:16,RB/binary>>,
    {ok, pt:pack(49013, Data)} ;


%% -----------------------------------------------------------------
%% 提取铜钱
%% -----------------------------------------------------------------
write(49014,[Code,Cions,GoodsList]) ->
	Len = length(GoodsList) ,
	F = fun({GoodsTypeID,Number}) ->
				<<GoodsTypeID:32,Number:32>> 
		end ,
	RB = tool:to_binary([F(S) || S <- GoodsList]) ,
	
	Data = <<Code:8,Cions:32,Len:16,RB/binary>> ,
	{ok, pt:pack(49014, Data)};


%% -----------------------------------------------------------------
%% 设置挖矿状态
%% -----------------------------------------------------------------
write(49015,[Code]) ->
	Data = <<Code:8>> ,
	{ok, pt:pack(49015, Data)};


%% -----------------------------------------------------------------
%% 踢出挖矿
%% -----------------------------------------------------------------
write(49016,[Code]) ->
	Data = <<Code:8>> ,
	{ok, pt:pack(49016, Data)};


%% -----------------------------------------------------------------
%% 踢出挖矿
%% -----------------------------------------------------------------
write(49018,[UId,Nick]) ->
	{NmLen,NmBin} = tool:pack_string(Nick) ,
	Data = <<UId:32,NmLen:16,NmBin/binary>> ,
	{ok, pt:pack(49018, Data)};


%% -----------------------------------------------------------------
%% 玩家状态广播
%% -----------------------------------------------------------------
write(49019,[UId,Stts]) ->
	Data = <<UId:32,Stts:8>> ,
	{ok, pt:pack(49019, Data)};


%% -----------------------------------------------------------------
%% 铜矿爆炸
%% -----------------------------------------------------------------
write(49021,[CId]) ->
	Data = <<CId:16>> ,
	{ok, pt:pack(49021, Data)};

%% -----------------------------------------------------------------
%% 玩家离开矿区
%% -----------------------------------------------------------------
write(49030,[Code,Coins,GoodsList]) ->
	Len = length(GoodsList) ,
	F = fun({GoodsTypeID,Number}) ->
				<<GoodsTypeID:32,Number:32>> 
		end ,
	RB = tool:to_binary([F(S) || S <- GoodsList]) ,
	
	Data = <<Code:8,Coins:32,Len:16,RB/binary>> ,
	{ok, pt:pack(49030, Data)};



%% -----------------------------------------------------------------
%% 玩家请求活动开启状态
%% -----------------------------------------------------------------
write(49100,[Flag,StartTime,Duration,CurTime]) ->
	Data = <<Flag:8,StartTime:32,Duration:32,CurTime:32>> ,
	{ok, pt:pack(49100, Data)};



%% -----------------------------------------------------------------
%% 玩家请求活动开启状态
%% -----------------------------------------------------------------
write(49101,[]) ->
	Data = <<>> ,
	{ok, pt:pack(49101, Data)};

%% -----------------------------------------------------------------
%% 玩家离开矿区
%% -----------------------------------------------------------------
write(49103,[Code,LeftTime,CountDown,TotalPage,CurPage,DataList]) ->
	Len = length(DataList) ,
	F = fun({GTID,UID,Nick}) ->
				{NmLen,NmBin} = tool:pack_string(Nick) ,
				<<GTID:32,UID:32,NmLen:16,NmBin/binary>> 
		end ,
	RB = tool:to_binary([F(S) || S <- DataList]) ,
	Data = <<Code:8,LeftTime:32,CountDown:32,TotalPage:8,CurPage:8,Len:16,RB/binary>> ,
	{ok, pt:pack(49103, Data)};




%% -----------------------------------------------------------------
%% 玩家进贡珍贵材料
%% -----------------------------------------------------------------
write(49104,[Code,AwardList]) ->
	Len = length(AwardList) ,
	F = fun({GoodsTypeID,Number}) ->
				<<GoodsTypeID:32,Number:32>> 
		end ,
	RB = tool:to_binary([F(S) || S <- AwardList]) ,
	Data = <<Code:8,Len:16,RB/binary>> ,
	{ok, pt:pack(49104, Data)};







write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.


	

