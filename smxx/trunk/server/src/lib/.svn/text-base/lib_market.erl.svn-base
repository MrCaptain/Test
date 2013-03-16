%%%-----------------------------------
%%% @Module  : lib_market
%%% @Author  :
%%% @Email   : 
%%% @Created :
%%% @Description: 市场交易系统
%%%-----------------------------------

-module(lib_market).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("market.hrl").
-include("goods.hrl").
-include("log.hrl"). 
-include("debug.hrl").

-compile(export_all).

%% %% 从数据库加载市场挂售记录和上架物品信息到ets
%% init_market_from_db() ->
%% 	?TRACE("init market from db...~n"),
%% 	
%% 	case db:select_all(market_selling, ?SQL_QUERY_MK_SELLING, []) of
%% 		[] ->  % 没有数据
%% 			?TRACE("[MARKET]There are not any selling goods!!!~n"),
%% 			skip;
%% 		SqlRet when is_list(SqlRet) ->
%% 			SellRecords = [make_sell_record(X) || X <- SqlRet],
%% 			% 写入ets表中
%% 			[ets:insert(?ETS_MARKET_SELLING, X) || X <- SellRecords],
%% 			% load市场上架物品信息到ets
%% 			[load_market_goods_info_from_db(X#ets_mk_selling.goods_uni_id) || X <- SellRecords],
%% 			% load市场上架物品附加属性信息到ets
%% 			[load_market_goods_attr_from_db(X#ets_mk_selling.goods_uni_id) || X <- SellRecords];
%% 		_ ->  % db读取出错
%% 			?ASSERT(false),
%% 			skip
%% 	end.
%% 	
%% 
%% make_sell_record(SrcData) ->
%% 	[Id, SellerId, GoodsUniId, GoodsId, GoodsName, Type, SubType, SubsubType, Color, Level, Career, StackNum, Price, PriceType, MoneyToSell, MoneyToSellType, StartTime, EndTime, Status] = SrcData,
%% 	?TRACE("MK_RcdId: ~p, goodsType: ~p, UniId: ~p, money: ~p~n", [Id, GoodsId, GoodsUniId, MoneyToSell]),
%% 	%% 检验数据的合法性
%% 	?ASSERT(is_binary(GoodsName)),
%% 	?ASSERT(SellerId =/= 0),
%% 	?ASSERT(Price > 0),
%% 	?ASSERT(PriceType =:= ?MONEY_T_COIN orelse PriceType =:= ?MONEY_T_GOLD),
%% 	?ASSERT(Status =:= ?MK_SELL_R_STATUS_SELLING),
%% 	case GoodsId =/= 0 of
%% 		true ->   % 表示对应的挂售记录是物品
%% 			?ASSERT(Type =/= ?GOODS_T_MONEY),
%% 			?ASSERT(MoneyToSell =:= 0),
%% 			?ASSERT(MoneyToSellType =:= ?MONEY_T_INVALID);
%% 			%% TODO： 其他断言验证: 将type, subtype, color, level, carrer与ets_goods， ets_goods_attr的对应数据比较， 正常应该是相等的。
%% 		false ->  % 表示对应的挂售记录是货币
%% 			?ASSERT(Type =:= ?GOODS_T_MONEY),
%% 			?ASSERT(GoodsUniId =:= 0),
%% 			?ASSERT(MoneyToSell > 0),
%% 			?ASSERT(MoneyToSellType =/= ?MONEY_T_INVALID),
%% 			?ASSERT(MoneyToSellType =/= PriceType)
%% 	end,
%% 	#ets_mk_selling{
%% 			id = Id,
%% 			seller_id = SellerId,
%% 			goods_uni_id = GoodsUniId,
%% 			goods_id = GoodsId,
%% 			goods_name = GoodsName,
%%   			type = Type,      
%%   			sub_type = SubType,
%%   			subsub_type = SubsubType,
%%   			color = Color,
%%   			level = Level,
%%   			career = Career,
%%   			stack_num = StackNum,
%% 			price = Price,
%% 			price_type = PriceType,
%% 			money_to_sell = MoneyToSell,
%% 			money_to_sell_type = MoneyToSellType,
%% 			start_time = StartTime,
%% 			end_time = EndTime,
%% 			status = Status
%% 		}.
%% 	
%% 
%% 
%% %% 广播挂售所需的费用（目前是2000游戏币）
%% -define(BROADCAST_SELL_NEED_MONEY, 2000).	
%% 
%% %% 计算挂售物品时对应需扣的手续费（包括广播挂售所需的费用）
%% %% @para: Price => 挂售价格， 
%% %%        PriceType => 挂售价格的类型， 
%% %%        SellTime_Hour => 挂售时间（单位：小时）
%% %%        WantBroadcast => 是否要广播挂售（1：是，0：否）
%% calc_custody_fee(Price, PriceType, SellTime_Hour, WantBroadcast) ->
%% 	NeedMoney = case PriceType of
%% 					?MONEY_T_COIN ->
%% 						max( util:floor(Price * 0.06 * SellTime_Hour / 24),  1);
%% 					?MONEY_T_GOLD ->
%% 						max( util:floor(Price * 20 * SellTime_Hour / 24),  1);
%% 					_ ->
%% 						?ASSERT(false, PriceType),
%% 						999999999  % 返回一个较大的数值，以防万一出bug的话被玩家利用
%% 				end,
%% 	case WantBroadcast of
%% 		1 ->
%% 			NeedMoney + ?BROADCAST_SELL_NEED_MONEY;
%% 		0 ->
%% 			NeedMoney
%% 	end.
%% 	
%% 
%% 
%% %% 扣手续费（包括扣广播挂售所需的费用）
%% %% @para: WantBroadcast => 是否要广播挂售（1：是，0：否）
%% %% @return：玩家的新状态
%% handle_cost_custody_fee(PS, Price, PriceType, SellTime, WantBroadcast) ->
%% 	CustodyFee = calc_custody_fee(Price, PriceType, SellTime, WantBroadcast),
%% 	NewPS = lib_money:cost_money(statistic, PS, CustodyFee, coin, ?LOG_MARKET_FEE),
%% 	NewPS.
%% 	
%% 	
%% 		
%% % 通知玩家更新其上架物品列表	
%% notify_my_sell_list_changed(PlayerId) ->
%% 	?TRACE("notify_my_sell_list_changed(),  playerid: ~p~n", [PlayerId]),
%%    	gen_server:cast({global, misc:player_process_name(PlayerId)}, {'NOTIFY_MY_SELL_LIST_CHANGED'}).
%% 	
%% 	
%% %% 获取玩家的上架物品的件数
%% %% 注: 目前是利用db做统计 
%% %%     如果改为用ets匹配做统计，则注意需要用远程call（因为市场系统迁移到世界节点了）
%% get_my_sell_count(PS) ->
%%     case db:select_one(market_selling, "COUNT(*)", [{seller_id,PS#player_status.id}]) of
%%         Count when is_integer(Count) ->
%%         	?TRACE("my market sell count: ~p~n", [Count]),
%%             Count;
%%         _Any -> % db出错
%%         	?ASSERT(false, _Any),
%%         	0
%%     end.
%% 
%% 
%% 
%% %% 广播挂售
%% %% @para: SellR => 挂售记录
%% broadcast_sell(SellR) ->
%% 	{ok, BinData} = pt_26:write(?PT_MK_BROADCAST_SELL, SellR),
%% 	lib_send:send_to_all(BinData).
%% 	
%% 	
%% 
%% 	
%% 	
%% 	
%% 	
%% 
%% 
%% %% ==================================== local function ==================================	
%% 	
%% %% 从数据库load市场物品信息到ets
%% %% rename to: load_market_goods_info_to_ets_from_db()???
%% load_market_goods_info_from_db(GoodsUniId) ->
%% 	?IFC (GoodsUniId /= 0)
%% 		% 从数据库load物品基础数据，并插入ets
%%     	case db:select_row(goods, ?SQL_QRY_GOODS_BASE_INFO, [{id,GoodsUniId}, {location,?LOCATION_MARKET}]) of
%%     		[] -> % load失败，加错误日志
%%     			?ERROR_MSG("[MARKET_ERR]load_market_goods_info_from_db() err!! goods uni id:~p", [GoodsUniId]),
%%     			?ASSERT(false, GoodsUniId),
%%     			skip;
%%     		GoodsInfo when is_list(GoodsInfo) ->
%%     			Goods = goods_util:make_info(goods, GoodsInfo),
%%     			?ASSERT(is_record(Goods, goods)),
%%     			?ASSERT(Goods#goods.player_id =:= 0),
%%     			?ASSERT(Goods#goods.location =:= ?LOCATION_MARKET),
%%     			ets:insert(?ETS_MARKET_GOODS_ONLINE, Goods);
%%     		_ ->  % db操作出错
%%     			?ASSERT(false),
%%     			skip
%%     	end
%%     ?END.
%% 	
%% 
%% 
%% %% 从数据库load市场物品附加属性到ets
%% load_market_goods_attr_from_db(GoodsUniId) ->
%% 	?IFC (GoodsUniId /= 0)
%% 		case db:select_all(goods_attribute, ?SQL_QRY_GOODS_ATTR, [{gid,GoodsUniId}]) of
%%     		[] -> % 表示没有附加属性，直接跳过处理
%%     			skip;
%%     		AttrList when is_list(AttrList) ->
%%     			F = fun(Info) ->
%%     					GoodsAttrInfo = goods_util:make_info(goods_attribute, Info),
%%     					?ASSERT(is_record(GoodsAttrInfo, goods_attribute)),
%%     					ets:insert(?ETS_MARKET_GOODS_ATTR, GoodsAttrInfo)
%%     				end,
%%     			lists:foreach(F, AttrList);
%%     		_ -> % db操作出错
%%     			?ASSERT(false),
%%     			skip
%%     	end
%%     ?END.
%%     
%% 
%% %% VIP增加挂售次数
%% vip_privilege(VipLv) ->
%% 	case VipLv of
%% 		?VIP_LV_4 ->
%% 			2;
%% 		?VIP_LV_5 ->
%% 			5;
%% 		_ ->
%% 			0
%% 	end.