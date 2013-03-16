%%%-------------------------------------- 
%%% @Module: lib_shop
%%% @Author:
%%% @Created:
%%% @Description:
%%%-------------------------------------- 
-module(lib_shop).

-include("common.hrl").
-include("record.hrl").
-include("goods_record.hrl").
-include("shop.hrl").
-include("goods.hrl").
-include("log.hrl"). 

-include_lib("stdlib/include/ms_transform.hrl").
-define(SHOP_LIMIT, 1).
-define(SHOP_NO_LIMIT, 10000).

-compile(export_all).

%% %% desc: 玩家登陆 
init_shop_info(PlayerId) ->
	load_buy_npcshop_log(PlayerId),
	load_buy_shop_log(PlayerId).

%% desc: 玩家登出
clear_shop_info(PlayerId) ->
	ets:match_delete(?ETS_NPC_SHOP_LOG, #ets_npc_shop_log{key = {PlayerId, _ = '_'}, _ = '_'}),
	ets:match_delete(?ETS_SHOP_LOG, #ets_shop_log{key = {PlayerId, _ = '_'}, _ = '_'}).

%% desc: 从数据库初始化商城数据
init_temp_shop_goods() ->
	case db_agent_goods:get_all_shop_goods() of
        [] ->
            skip;
       ShopGoodsList when is_list(ShopGoodsList) ->
			F = fun(Info) ->
					lib_common:insert_ets_info(?ETS_TEMP_SHOP, Info)
				end,
			lists:foreach(F, ShopGoodsList)
    end,
    ok.

%% 加载npc商店购买记录
load_buy_npcshop_log(PlayerId) ->
	case db_agent_shop_log:get_player_npc_shop_log(PlayerId) of
		[] -> skip;
		NpcShopGoodsLog when is_list(NpcShopGoodsLog) ->
			F = fun(Info) ->
						EtsInfo = #ets_npc_shop_log{key = {Info#buy_npc_shop_log.uid, Info#buy_npc_shop_log.shopid, Info#buy_npc_shop_log.gtid}, 
													buy_num = Info#buy_npc_shop_log.buy_num, buy_time = Info#buy_npc_shop_log.buy_time},
						lib_common:insert_ets_info(?ETS_NPC_SHOP_LOG, EtsInfo)
				end,
			lists:foreach(F, NpcShopGoodsLog)
	end.

%% 加载商城购买记录
load_buy_shop_log(PlayerId) ->
	case db_agent_shop_log:get_player_shop_log(PlayerId) of
		[] -> skip;
		ShopGoodsLog when is_list(ShopGoodsLog) ->
			F = fun(Info) ->
						EtsInfo = #ets_shop_log{key = {Info#buy_shop_log.uid, Info#buy_shop_log.shoptabid, Info#buy_shop_log.gtid}, 
													buy_num = Info#buy_shop_log.buy_num, buy_time = Info#buy_shop_log.buy_time},
						lib_common:insert_ets_info(?ETS_SHOP_LOG, EtsInfo)
				end,
			lists:foreach(F, ShopGoodsLog)
	end.

%% desc: 清理昨天的npc商店购买记录
del_yesterday_npc_shop_info(PlayerId) ->
	ets:match_delete(?ETS_NPC_SHOP_LOG, #ets_npc_shop_log{key = {PlayerId, _ = '_'}, _ = '_'}),
	db:delete(buy_npc_shop_log, [{player_id, PlayerId}]).

%% desc: 清理昨天的商城购买记录
del_yesterday_shop_info(PlayerId) ->
	ets:match_delete(?ETS_SHOP_LOG, #ets_shop_log{key = {PlayerId, _ = '_'}, _ = '_'}),
	db:delete(buy_shop_log, [{player_id, PlayerId}]).

%% desc: 获取npc商店物品列表
get_npc_shop_goods(PS, ShopId, PageNo) ->
	case tpl_npc_shop:get(ShopId, PageNo) of
		NpcShopInfo when is_record(NpcShopInfo, temp_npc_shop) ->
			NewShopGoods = filter_equip_by_carrer(PS#player.career, NpcShopInfo#temp_npc_shop.shop_goods),
			handle_check_left_goods_num(PS, ShopId, NpcShopInfo#temp_npc_shop.shop_type, NewShopGoods, []);
		_ -> []
	end.

%% 查询售卖商品剩余购买数量
handle_check_left_goods_num(_PS, _ShopId, _ShopType, [], Result) ->
	Result;
handle_check_left_goods_num(PS, ShopId, ShopType, [H|T], Result) ->
	case ShopType =:= ?SHOP_LIMIT of
		true ->
			{ShopGoodsTid, _, _, MaxNum} = H,
			BuyNum = get_today_buy_times(PS, ShopId, ShopGoodsTid),
			CanBuyNum = max(0, (MaxNum - BuyNum)),
			NewResult = [{ShopGoodsTid, CanBuyNum}] ++ Result,
			handle_check_left_goods_num(PS, ShopId, ShopType, T, NewResult);
		false ->
			{ShopGoodsTid, _, _, MaxNum} = H,
			NewResult = [{ShopGoodsTid, MaxNum}] ++ Result,
			handle_check_left_goods_num(PS, ShopId, ShopType, T, NewResult)
	end.

%% 获取今天在npc商店物品购买数量
get_today_buy_times(PS, ShopId, ShopGoodsTid) ->
    PlayerId = PS#player.id,
    Pattern = #ets_npc_shop_log{key = {PlayerId, ShopId, ShopGoodsTid},  _='_' },
    case lib_common:get_ets_info(?ETS_NPC_SHOP_LOG, Pattern) of
        {} ->
            0;
        Info ->
            Info#ets_npc_shop_log.buy_num
    end.

%% desc: 向NPC购买物品
handle_buy_npc_sells(GoodsStatus, PS, ShopId, PageNo, GoodsTid, Num) ->
    case check_buy_npc_goods(GoodsStatus, PS, ShopId, PageNo, GoodsTid, Num) of
        {fail, Res} ->
            [Res, PS];
        {ok, ShopGoodsTid, MaxNum, Cost, PriceType, AlreadyBuyNum} ->
            NewPS = lib_money:cost_money(PS, Cost, PriceType, ?LOG_BUY_NPC_GOODS, GoodsTid),
            case MaxNum > 0 andalso MaxNum < ?SHOP_NO_LIMIT of
                true -> update_npc_shop_log(PS#player.id, ShopId, ShopGoodsTid, Num, AlreadyBuyNum);
                false -> skip
            end,
            NewGS = lib_goods:give_goods({ShopGoodsTid, Num}, GoodsStatus),
			[?RESULT_OK, NewPS, NewGS];
		{ok, ShopGoodsTid, MaxNum, CostGoodsList, Blen, CostNum, AlreadyBuyNum} ->
			{ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, CostGoodsList, length(CostGoodsList)),
			case MaxNum > 0 andalso MaxNum < ?SHOP_NO_LIMIT of
				true -> update_npc_shop_log(PS#player.id, ShopId, ShopGoodsTid, Num, AlreadyBuyNum);
				false -> skip
			end,
			BindGoodsLen = util:ceil(Blen/CostNum),
			UnBindGoodsLen = Num - BindGoodsLen,
			NewGS1 = 
			case BindGoodsLen > 0 of
				true ->
					lib_goods:give_goods(?BIND_NOTYET, ?LOCATION_BAG, {ShopGoodsTid, BindGoodsLen}, NewGS);
				false -> NewGS
			end,
			NewGS2 = 
			case UnBindGoodsLen > 0 of
				true ->
					lib_goods:give_goods(?BIND_ANY, ?LOCATION_BAG, {ShopGoodsTid, Num}, NewGS1);
				false -> NewGS1
			end,
            [?RESULT_OK, PS, NewGS2];
		_ -> [?RESULT_FAIL, PS, GoodsStatus]
    end.

%% desc: 檢查購買條件
check_buy_npc_goods(GoodsStatus, PS, ShopId, PageNo, GoodsTid, Num) ->
	NpcShopInfo = tpl_npc_shop:get(ShopId, PageNo),
	NpcShopGoodsInfo = lists:keyfind(GoodsTid, 1, NpcShopInfo#temp_npc_shop.shop_goods),
    if
        is_integer(Num) =:= false orelse Num =< 0 ->
            {fail, ?RESULT_FAIL};   % 参数错误
		is_record(NpcShopInfo, temp_npc_shop) =:= false ->
			{fail, 2};
		NpcShopGoodsInfo =:= false ->
			{fail, 2};
        true ->			
		   {ShopGoodsTid, CostGoodsTid, CostNum, MaxNum} = NpcShopGoodsInfo,
		   CostType = lib_money:goods_to_money_type(CostGoodsTid),
		   AlreadyBuyNum = get_today_buy_times(PS, ShopId, ShopGoodsTid),
		   CanBuyNum = max(0, (MaxNum - AlreadyBuyNum)),
		   if
			   CanBuyNum >  Num ->
				   {fail, 5};
			   length(GoodsStatus#goods_status.null_cells) < Num ->
					{fail, 4};
				true ->
					case CostType =:= {} of
						true -> % 兑换物品
							{BindList, UnBindList} = 
										casting_util:get_band_unbind_goods(PS#player.id, ?BIND_FIRST, CostGoodsTid, Num*CostNum),
							Blen = length(BindList),
							UBlen = length(UnBindList),
							case (Blen + UBlen)  < Num*CostNum of
								true ->	{fail, 6};
								false -> {ok, ShopGoodsTid, MaxNum, BindList ++ UnBindList, Blen, CostNum, AlreadyBuyNum}
							end;
						false -> % 购买
				           	Cost = CostNum * Num,
				            case lib_money:has_enough_money(PS, Cost, CostType) of
				                false -> {fail, 3};   % 金额不足
				                true ->                   
				                    {ok, ShopGoodsTid, MaxNum, Cost, CostType, AlreadyBuyNum}
				            end
            		end
			end
    end.

%% 记录npc商店购买记录
update_npc_shop_log(PlayerId, ShopId, ShopGoodsTid, Num, AlreadyBuyNum) ->
	ShopGoodsInfo = #buy_npc_shop_log{uid = PlayerId,
									  shopid = ShopId,
									  gtid = ShopGoodsTid,
									  buy_num = Num,
									  buy_time = util:unixtime()
									 },
	case AlreadyBuyNum > 0 of
		true ->
			Field_Value_List = [{"buy_num", Num + AlreadyBuyNum}, {"buy_time", util:unixtime()}],
			Where_List = [{"uid", PlayerId}, {"shopid", ShopId}, {"gtid", ShopGoodsTid}],
			db_agent_shop_log:update_npc_shop_log(Field_Value_List, Where_List);
		false ->
			db_agent_shop_log:add_npc_shop_log(ShopGoodsInfo)
	end,
	EtsInfo = #ets_npc_shop_log{key = {ShopGoodsInfo#buy_npc_shop_log.uid, ShopGoodsInfo#buy_npc_shop_log.shopid, ShopGoodsInfo#buy_npc_shop_log.gtid}, 
													buy_num = ShopGoodsInfo#buy_npc_shop_log.buy_num, buy_time = ShopGoodsInfo#buy_npc_shop_log.buy_time},						
	lib_common:insert_ets_info(?ETS_NPC_SHOP_LOG, EtsInfo).

%% desc: 获取本职业装备兑换物品列表
filter_equip_by_carrer(Career, ShopList) ->
	F = fun({ShopGoodsTid, _, _, MaxNum}) ->
                case is_integer(ShopGoodsTid) andalso ShopGoodsTid > 0 of
                    true ->
						RealCareer = lib_goods:get_goods_career(ShopGoodsTid),
						(Career =:= RealCareer) orelse (RealCareer =:= ?CAREER_ANY);
					false ->
						false
                end
        end,
	lists:filter(F, ShopList).

%% desc: 取商店物品信息
get_shop_goods_info(ShopTabType, GoodsTid) ->
    Pattern = #temp_shop{shop_tab_page = ShopTabType, gtid = GoodsTid,  _='_' },
    lib_common:get_ets_info(?ETS_TEMP_SHOP, Pattern).

%% desc: 检查购买条件
check_pay(GoodsStatus, PS, ShopTabType, GoodsTid, GoodsNum) ->
	ShopGoodsInfo = get_shop_goods_info(ShopTabType, GoodsTid),
	if
		% 物品不存在
		is_record(ShopGoodsInfo, ets_shop) =:= false ->
			{fail, 2};
		length(GoodsStatus#goods_status.null_cells) < GoodsNum ->
			{fail, 4};
		ShopGoodsInfo#temp_shop.level_limit > PS#player.level ->
			{fail, 6};
		ShopGoodsInfo#temp_shop.real_price =:= 0 ->
			{fail, 7};
		true ->
			Cost = GoodsNum * ShopGoodsInfo#temp_shop.real_price,
			CostType = 
				case ShopGoodsInfo#temp_shop.gold_type =:= 1 of
					true -> ?MONEY_T_GOLD;
					false -> ?MONEY_T_BGOLD
				end,
			case lib_money:has_enough_money(PS, Cost, CostType) of
				false -> {fail, 3};   % 金额不足
				true ->                   
					{ok, Cost, CostType}
			end
	end.

%% desc: 购买商城物品
handle_buy_shop_goods(GoodsStatus, PS, ShopTabType, GoodsTid, GoodsNum) ->
	case check_pay(GoodsStatus, PS, ShopTabType, GoodsTid, GoodsNum) of
		{fail, Res} ->
			{fail, Res};
		{ok, Cost, CostType} ->
			NewPS = lib_money:cost_money(PS, Cost, CostType, ?LOG_SHOP_BUY),
			NewGS = lib_goods:give_goods([{GoodsTid, GoodsNum}], GoodsStatus, ?LOG_GOODS_SHOP_BUY),
			%% 			log:log_goods_source(NewPS#player_status.id, GoodsTid, Num, LogPriceType, Price, ?LOG_BUSINESS_SHOP, ?LOG_GOODS_BUY),
			{ok, ?RESULT_OK, NewGS, NewPS}
	end.