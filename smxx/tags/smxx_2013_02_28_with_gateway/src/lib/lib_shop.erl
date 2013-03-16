%%%-------------------------------------- 
%%% @Module: lib_shop
%%% @Author: lxl
%%% @Created: 2011-12-27
%%% @Description: 
%%%-------------------------------------- 
-module(lib_shop).

%%
%% Including Files
%%

-include("common.hrl").
-include("record.hrl").
-include("goods_record.hrl").
-include("common_shop.hrl").   
-include("goods.hrl").
-include("common_log.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

-compile(export_all).
%% %% exports
%% %% desc: 玩家登陆 
%% role_login(PlayerId) ->
%%     load_mystery_infos(PlayerId, 0),
%%     load_dungeon_shop_infos(PlayerId),
%%     load_trea_infos(PlayerId),
%% 	load_buy_shopgoods_info(PlayerId).
%% 
%% %% exports
%% %% desc: 玩家登出
%% role_logout(PlayerId) ->
%%     ets:delete(?ETS_MYSTERY_SHOP, PlayerId),
%%     ets:delete(?ETS_DUNGEON_SHOP, PlayerId),
%%     ets:delete(?ETS_TREA_COST, PlayerId),
%% 	ets:match_delete(?ETS_BUY_GOODS_SHOP, #ets_buy_goods_shop{key = {PlayerId, _ = '_'}, _ = '_'}).
%% 
%% %% exports
%% %% func: load_goods_t_id_from_db/0
%% %% desc: 从数据库初始化商城数据
%% init_goods_t_id_from_db() -> 
%% 	ok = load_s_goods(). 
%% 
%% %% internal
%% %% desc: 将不会变动的物品加入ETS表
%% load_s_goods() -> 
%% 	F = fun([Id, ShopType, ShopSubType, TabNo, Page, Location, GoodsTid, Oprice, PriceType, Price, Max]) ->
%% 				Flag = case Max > 0 of
%% 						   true -> 1;
%% 						   false -> 0
%% 					   end,
%% 				Info = #ets_shop{
%%                                            id = Id,
%% 										   shop_type = ShopType,
%% 										   shop_subtype = ShopSubType,
%%                                            tabno        = TabNo,
%% 										   page = Page,
%%                                            location = Location,
%% 										   goods_id = GoodsTid,
%%                                            o_price = Oprice,
%%                                            price_type = PriceType,
%%                                            price = Price,
%%                                            max = Max,
%% 										   flag = Flag
%% 								     },
%% 				ets:insert(?ETS_SHOP, Info),
%% 				if
%% 					PriceType =:= 2 -> % 商城, 神秘商城, npc商人, 自动购买, 消耗元宝
%% 						NewGoodsTid = goods_convert:make_sure_game_tid(GoodsTid),
%% 						ets:insert(?ETS_SHOP_GOODS_TYPE, {NewGoodsTid});
%% 					true ->
%% 						skip
%% 				end				
%% 		 end,
%% 	
%% 	case db:select_all(base_shop, "id, shop_type, shop_subtype, tabno, page, location, goods_id, o_price, price_type, price, maxbuy", []) of
%% 		Data when is_list(Data) -> 	lists:foreach(F, Data);
%% 		_ -> skip
%% 	end.
%% 
%% %% internal
%% %% desc: 加载副本商人数据
%% load_dungeon_shop_infos(PlayerId) ->
%%     F = fun(Bcontent) ->
%%                 Content = util:bitstring_to_term(Bcontent),
%%                 Info = #ets_dungeon_shop{
%%                                          player_id = PlayerId,
%%                                          content = Content
%%                                          },
%%                 ets:insert(?ETS_DUNGEON_SHOP, Info)
%%          end,
%%     
%%     case db:select_row(shop_dungeon, "content", [{player_id, PlayerId}], [], [1]) of
%%         Data when is_list(Data) ->  lists:foreach(F, Data);
%%         _ -> skip
%%     end.
%% 
%% %% internal
%% %% desc: 加载商城购买数据
%% load_buy_shopgoods_info(PlayerId) ->
%%     ToDayBegin = util:get_date(),
%% 	case db:select_all(buy_shopgoods_info, "goods_id, buy_num", [{timestamp,">", ToDayBegin}, {player_id, PlayerId}]) of
%% 		List when is_list(List) ->
%% 			F = fun(Data) ->
%% 						[GoodsTid, Num] = Data,
%% 						case is_integer(GoodsTid) andalso is_integer(Num) of
%% 							true ->
%% 								Info = #ets_buy_goods_shop{
%% 					                               key = {PlayerId, GoodsTid},
%% 					                               buy_num = Num
%% 					                              },
%% 					                ets:insert(?ETS_BUY_GOODS_SHOP, Info);
%% 							false ->
%% 								skip
%% 						end
%% 				end,
%% 			lists:foreach(F, List);
%% 		_ -> skip
%% 	end.
%% 
%% %% exports
%% %% desc: 向商城添加热销商品
%% init_top_goods_into_ets() ->
%% 	GoodsIdList = get_top_goods(?TOP_TEN),
%% 	F = fun({GoodsTid, _Num}) -> 
%% 				Pattern = #ets_shop{goods_id = GoodsTid},
%% 				ets:insert(?ETS_SHOP, Pattern)
%% 		 end,
%% 	lists:foreach(F, GoodsIdList).
%% 
%% %% exports
%% %% desc: 初始化特价商店
%% init_bargain_shop() ->
%%     % init_bargain_shop_info().
%%     {BegTime, EndTime} = case lib_common:get_ets_info(?ETS_GLOBAL_VARIABLE, ?GLOBAL_SHOP_DATE) of
%%         {} ->
%%             {0, 0};
%%         Info ->
%%             Info#ets_global_variable.value
%%     end,
%% 
%%     Now         = util:unixtime(),
%% 
%%     case BegTime =< Now andalso EndTime > Now of
%%         false ->
%%             init_bargain_shop_info();
%%         true ->
%%             init_activity_shop_info()
%%     end.
%% 
%% init_bargain_shop_info() ->
%% 	GoodsList = data_shop:get_bargain_info(),
%% 	[{GoodsTid1, Num1, Oprice1, Price1, Price_type1}, LeftList1] = get_rand_goods(GoodsList),
%% 	[{GoodsTid2, Num2, Oprice2, Price2, Price_type2}, LeftList2] = get_rand_goods(LeftList1),
%% 	[{GoodsTid3, Num3, Oprice3, Price3, Price_type3}, _] = get_rand_goods(LeftList2),
%% 	NowTime = util:unixtime(),
%%     EndTime = NowTime + ?BAR_LASTING_TIME,
%% 	#bar_shop{
%%                    init_time = NowTime,
%%                    end_time  = EndTime,
%%                    goods1 = [GoodsTid1, Num1, Oprice1, Price1, Price_type1],
%%                    goods2 = [GoodsTid2, Num2, Oprice2, Price2, Price_type2],
%%                    goods3 = [GoodsTid3, Num3, Oprice3, Price3, Price_type3]
%%                    }.
%% 
%% init_activity_shop_info() ->
%%     NowTime         = util:unixtime(),
%% 
%%     {_, T}          = calendar:local_time(),
%%     GoneSecs        = calendar:time_to_seconds(T),
%%     EndTime         = NowTime + ?ONE_DAY_SECONDS - GoneSecs,
%% 
%%     [G1, G2, G3]    = data_chaos:get_shop_goods(),
%%     #bar_shop{
%%         init_time   = NowTime,
%%         end_time    = EndTime,
%%         goods1      = G1,
%%         goods2      = G2,
%%         goods3      = G3
%%     }.
%% 
%% %% exports
%% %% desc: 获取商城子页物品列表
%% init_record_state() ->
%% 	F = fun(SubType) ->
%% 				Shop = #ets_shop{shop_type = SubType, _ = '_' },
%% 				lib_common:get_ets_list(?ETS_SHOP, Shop)
%% 		 end, 
%% 	lists:map(F, [?EMPORIUM_SUB_NEW, ?EMPORIUM_SUB_USUAL, ?EMPORIUM_SUB_STONE, ?EMPORIUM_SUB_RARE]).
%% 
%% %% exports
%% %% desc: 加载神秘商城日志信息
%% load_mystery_log() ->
%%     F = fun([Id, PlayerId, Name, GoodsTid]) ->
%%                 Info = #mystery_log{
%%                                     id = Id, 
%%                                     player_id = PlayerId, 
%%                                     player_name = lib_common:make_sure_binary(Name),
%%                                     goods_tid = GoodsTid
%%                                     },
%%                 ets:insert(?ETS_MYSTERY_LOG, Info)
%%         end,
%%     case catch db:select_all(mystery_log, ?SQL_SELECT_ALL_MYSTERY_LOG, []) of
%%         List when is_list(List) ->
%%             lists:foreach(F, List);
%%         Error ->
%%             ?ERROR_MSG("load_mystery_log failed:~p", [Error]),
%%             ?ASSERT(false),
%%             skip
%%     end.
%% 
%% %% exports
%% %% desc: 加载商城限购优惠商品购买日志信息
%% load_consume_bar_log() ->
%%    F = fun([PlayerId, GoodsTid, Num, Price, PriceType]) ->
%%                Info = #ets_consume_bar{
%%                             role_id = PlayerId,
%%                             goods_t_id = GoodsTid,
%%                             num = Num,
%%                             price = Price,
%%                             price_type = PriceType
%%                             },
%%     		   ets:insert(?ETS_CONSUME_BAR, Info)
%%         end,
%%     case catch db:select_all(consume_bar_log, "role_id, goods_t_id, num, price, price_type", []) of
%%         List when is_list(List) ->
%%             lists:foreach(F, List);
%%         Error ->
%%             ?ERROR_MSG("load_consume_bar_log failed:~p", [Error]),
%%             ?ASSERT(false),
%%             skip
%%     end.
%% 
%% %% exports
%% %% desc: 添加一条神秘商店购买记录
%% add_mystery_log(PlayerId, RoleName, GoodsTid, Id) ->
%%     BinName = lib_common:make_sure_binary(RoleName),
%%     NewLog = #mystery_log{id = Id, player_id = PlayerId, player_name = BinName, goods_tid = GoodsTid},
%%     
%% 	db:insert(mystery_log, ["id", "player_id", "player_name", "goods_tid"], [Id, PlayerId, BinName, GoodsTid]),
%%     ets:insert(?ETS_MYSTERY_LOG, NewLog).
%% 
%% %% exports
%% %% desc: 花费金钱刷新神秘商店
%% role_refresh_cost(PS, Info) ->
%%     YBCost = data_shop:get_mystery_cost(),
%%     NexTime = ?REFRESH_MYSTERY_INTERVAL + util:unixtime(),
%%     ClearDate = erlang:date(),
%%     Sells = rand_get_sells(),
%%     NewInfo = Info#mystery_shop{sells = Sells, nextime = NexTime, clear_date = ClearDate},
%%     update_mystery_data(NewInfo),
%%     lib_money:cost_money(statistic, PS, YBCost, gold, ?LOG_MYSTERY_SHOP_REFRESH).
%% 
%% %% exports
%% %% desc: 免费刷新神秘商店
%% role_refresh_nocost(Info) ->
%%     NexTime = ?REFRESH_MYSTERY_INTERVAL + util:unixtime(),
%%     ClearDate = erlang:date(),
%%     Sells = rand_get_sells(),
%%     LeftClear = Info#mystery_shop.left_clear - 1,
%%     NewInfo = Info#mystery_shop{sells = Sells, nextime = NexTime, clear_date = ClearDate, left_clear = LeftClear},
%%     update_mystery_data(NewInfo).
%% 
%% %% exports
%% %% desc: 客户端刷新神秘商店
%% %% client_refresh_mystery(PlayerId) ->
%% %%     case lib_common:get_ets_info(?ETS_MYSTERY_SHOP, PlayerId) of
%% %%         {} -> skip;
%% client_refresh_mystery(Info) ->
%%     NexTime = ?REFRESH_MYSTERY_INTERVAL + util:unixtime(),
%%     ClearDate = erlang:date(),
%%     Sells = rand_get_sells(),
%%     NewInfo = Info#mystery_shop{sells = Sells, nextime = NexTime, clear_date = ClearDate},
%%     update_mystery_data(NewInfo).
%%     
%% %% exports
%% %% desc: 取商店物品列表
%% get_shop_list(Page, Shoptype) ->
%%     Pattern = #ets_shop{shop_type = Shoptype, page = Page, _ = '_'},
%%     lib_common:get_ets_list(?ETS_SHOP, Pattern).
%% 
%% %% exports
%% %% desc: 取商店物品信息
%% get_shop_info(ShopType, SubType, GoodsTid) ->
%%     Pattern = #ets_shop{ shop_type = ShopType, shop_subtype = SubType, goods_id = GoodsTid, _='_' },
%%     lib_common:get_ets_info(?ETS_SHOP, Pattern).
%% 
%% %% exports
%% %% desc: 检查购买条件
%% check_pay(GoodsTid, PS, Num, ShopType, ShopSub) ->
%%     ShopInfo = get_shop_info(ShopType, ShopSub, GoodsTid),
%%     IsMem = lists:member(GoodsTid, data_shop:partner_cards()),
%%     if
%%         % 物品不存在
%%         is_record(ShopInfo, ets_shop) =:= false ->
%%             {fail, 2};
%%         ShopSub =:= ?EMPORIUM_SUB_VIP andalso PS#player_status.vip =:= 0 ->
%%             {fail, 5};   % 非VIP不能购买VIP专区物品
%%         IsMem =:= true andalso PS#player_status.partner_card =:= 1->
%%             {fail, 6};   % 已购买过武将卡
%%         IsMem =:= true andalso Num > 1 ->
%%             {fail, 7};   % 已购买过武将卡, 不能重复购买
%%         true -> 
%%             case get_goods_price(GoodsTid) of
%%                 {0, 0} ->
%%                     ?ERROR_MSG("get_price failed:~p", [GoodsTid]),
%%                     ?ASSERT(false),
%%                     {fail, ?RESULT_FAIL}; 
%%                 {Price, PriceType} ->
%% 					case ShopInfo#ets_shop.max > 0 of
%% 						true ->
%% 							BuyNum = case lib_common:get_ets_info(?ETS_BUY_GOODS_SHOP, {PS#player_status.id, GoodsTid}) of
%% 						        	   		Info when is_record(Info, ets_buy_goods_shop) -> Info#ets_buy_goods_shop.buy_num;
%% 											_ -> 0
%% 									   end,		
%% 							case (BuyNum + Num) > ShopInfo#ets_shop.max of
%% 								true -> {fail, 8};   % 已超过购买数量
%% 								false -> check_money_and_bag(PS, Price, PriceType, GoodsTid, Num)
%% 							end;
%% 						 false ->
%%                     		check_money_and_bag(PS, Price, PriceType, GoodsTid, Num)
%% 					end
%%             end
%%     end.
%% 
%% %% desc: 检查是否钱足够
%% check_money_and_bag(PS, Price, PriceType, GoodsTid, Num) ->
%%     Cost = Price * Num,
%%     case lib_money:can_pay(PS, [{Cost, PriceType}]) of
%%         false ->
%%             {fail, 3};   % 金额不足
%%         true ->
%%             case goods_util:can_put_into_bag(PS, [GoodsTid]) of
%%                 true ->
%%                     {ok, Cost, PriceType};
%%                 false ->
%%                     {fail, 4}    % 背包格子不足
%%             end
%%     end.            
%% 
%% %% exports
%% %% desc: 檢查購買條件
%% check_buy_goods(PS, Num, SellInfo) ->
%%     if
%%         is_record(SellInfo, ets_shop) =:= false ->
%%             {fail, 2};   % 該NPC不出售此物品
%%         is_integer(Num) =:= false orelse Num =< 0 ->
%%             {fail, ?RESULT_FAIL};   % 参数错误
%%         true ->
%%             {Cost, PriceType} = {SellInfo#ets_shop.price * Num, SellInfo#ets_shop.price_type},
%%             case lib_money:has_enough_money(PS, Cost, PriceType) of
%%                 false -> {fail, 3};   % 金额不足
%%                 true ->  
%%                     case goods_util:can_put_into_bag(PS, [{SellInfo#ets_shop.goods_id, Num}]) of
%%                         false ->   {fail, 4};  % 背包格子不足
%%                         true ->    
%%                             case SellInfo#ets_shop.max > 0 of
%%                                 true ->   % 属于副本商人限购物品
%%                                     case check_can_buy_dungeon_shop_goods(PS#player_status.id, SellInfo#ets_shop.shop_type, SellInfo#ets_shop.goods_id, Num) of
%%                                         {fail, Res} -> {fail, Res};
%%                                         {ok, buy} ->  {ok, Cost, PriceType}
%%                                     end;
%%                                 false ->
%%                                     {ok, Cost, PriceType}
%%                             end
%%                     end
%%             end
%%     end.
%% 
%% %% internal
%% %% desc: 检查是否能卖副本伤人限购物品
%% check_can_buy_dungeon_shop_goods(PlayerId, NpcId, GoodsTid, Num) ->
%%     case lib_common:get_ets_info(?ETS_DUNGEON_SHOP, PlayerId) of
%%         {} ->
%%             {ok, buy};
%%         Info ->
%%             Content = Info#ets_dungeon_shop.content,
%%             case lists:keyfind({NpcId, GoodsTid}, 1, Content) of
%%                 false ->
%%                     {ok, buy};
%%                 {{NpcId, GoodsTid}, CurNum, Max, _Date} ->
%%                     case CurNum + Num > Max of
%%                         true ->  {fail, ?RESULT_FAIL};   % 数量已满
%%                         false -> {ok, buy}
%%                     end
%%             end
%%     end.
%% 
%% %% exports
%% %% desc: 判断是否副本商人
%% is_dungeon_shop(SellInfo) when is_record(SellInfo, ets_shop),  SellInfo#ets_shop.max > 0 -> true;
%% is_dungeon_shop(_) -> false.
%%     
%% 
%% %% exports
%% %% desc: 获取特价区物品信息
%% get_bargain_goods_data(BarInfos, Type) ->
%%     case Type of
%%         ?BARGAIN_1 -> BarInfos#bar_shop.goods1;
%%         ?BARGAIN_2 -> BarInfos#bar_shop.goods2;
%%         ?BARGAIN_3 -> BarInfos#bar_shop.goods3;
%%         _ -> ?ASSERT(false), [0,0,0,0,0]
%%     end.
%% 
%% %% exports
%% %% desc: 玩家购买记录增加相应数量       
%% add_bargain_record(PlayerId, GoodsTid, Num, Price, PriceType) ->
%%     Info = #ets_consume_bar{
%%                             role_id = PlayerId,
%%                             goods_t_id = GoodsTid,
%%                             num = Num,
%%                             price = Price,
%%                             price_type = PriceType
%%                             },
%%     ets:insert(?ETS_CONSUME_BAR, Info),
%% 	case GoodsTid =:= 580400501 of
%% 		true ->
%% 			lib_common:actin_new_proc(
%% 			  db, insert, [
%% 							  consume_bar_log,
%% 							  ["role_id", "goods_t_id", "num", "price", "price_type"],
%% 							  [PlayerId, GoodsTid, Num, Price, PriceType]
%% 						  ]
%% 			  );
%% 		false ->
%% 			skip
%% 	end.
%% 
%% %% exports	
%% %% desc: 获取特价商品的类型id
%% get_bargain_t_id(BarInfo, Type) ->
%%     case Type of
%%         ?BARGAIN_1 ->	 hd( BarInfo#bar_shop.goods1 );
%%         ?BARGAIN_2 ->	 hd( BarInfo#bar_shop.goods2 );
%%         ?BARGAIN_3 ->	 hd( BarInfo#bar_shop.goods3 );
%%         _ ->                ?ASSERT(false), 0
%% 	end.			
%% 	
%% %% exports
%% %% desc: 检查分页数据	
%% check_input_legal(ShopSubType, PageNum) ->
%%     if
%%         (ShopSubType >= 0 andalso ShopSubType =< ?SUB_MAX) 
%%           andalso PageNum > 0 ->
%%             legal;
%%         true ->
%%             illegal
%%     end.
%% 
%% %% exports
%% %% desc: 获取特价区物品的购买状态
%% get_bargain_buy_state(BarInfos, PS) ->
%%     case lib_common:get_ets_list(?ETS_CONSUME_BAR, #ets_consume_bar{role_id = PS#player_status.id, _ = '_'}) of
%%         [] ->
%%             {0, 0, 0};
%%         InfoList ->
%%             StateGoods1 = get_bar_goods_buy_state(InfoList, hd(BarInfos#bar_shop.goods1)), 
%%             StateGoods2 = get_bar_goods_buy_state(InfoList, hd(BarInfos#bar_shop.goods2)), 
%%             StateGoods3 = get_bar_goods_buy_state(InfoList, hd(BarInfos#bar_shop.goods3)), 
%%             {StateGoods1, StateGoods2, StateGoods3}
%%     end.
%% 
%% %% internal
%% %% desc: 查询商城特价区物品购买状态
%% get_bar_goods_buy_state(List, GoodsTid) ->
%%     F = fun(Info) -> Info#ets_consume_bar.goods_t_id =:= GoodsTid end,
%%     case lists:filter(F, List) of
%%         [] -> 0;
%%         _ -> 1
%%     end.
%%     
%% %% exports 
%% %% desc: 获取分页商品信息
%% get_selected_data(ShopType, SubType, PageNo) ->
%%     get_selected_data(ShopType, SubType, PageNo, 0).
%% get_selected_data(ShopType, SubType, PageNo, TabNo) ->
%%     List = get_shop_goods_list(ShopType, SubType, PageNo, TabNo),
%%     MaxPage = get_max_page(ShopType, SubType, TabNo),
%%     % 对List中的物品进行location排列
%%     SortedList = sort_list_by_location(List),
%%     [SortedList, MaxPage].
%% get_selected_data(PlayerId, ShopType, SubType, PageNo, TabNo) ->
%%     List = get_shop_goods_list(PlayerId, ShopType, SubType, PageNo, TabNo),
%%     MaxPage = get_max_page(ShopType, SubType, TabNo),
%%     % 对List中的物品进行location排列
%%     SortedList = sort_list_by_location(List),
%%     [SortedList, MaxPage].
%% %% exports
%% %% desc: 整理神秘商店当前信息
%% handle_mystery_infos(PS, Info) ->
%%     NowTime = util:unixtime(),
%%     CD = case NowTime < Info#mystery_shop.nextime of
%%              true -> Info#mystery_shop.nextime - NowTime;
%%              false -> 0
%%          end,
%%     LefTimes = Info#mystery_shop.left_clear,
%%     Gold = PS#player_status.coin,
%%     YB = PS#player_status.gold,
%%     Array = order_get_goods_price(Info#mystery_shop.sells),
%%     [CD, LefTimes, Gold, YB, Array].
%%     
%% %% internal
%% %% desc: 查询商店该页物品列表
%% get_shop_goods_list(ShopType, SubType, TabNo) ->
%%     Pattern = #ets_shop{shop_type = ShopType, shop_subtype = SubType, tabno = TabNo, _ = '_'},
%%     case lib_common:get_ets_list(?ETS_SHOP, Pattern) of
%%         [] -> [];
%%         List -> List
%%     end.
%% 
%% %% internal
%% %% desc: 查询商店该页物品列表
%% get_shop_goods_list(ShopType, SubType, PageNo, TabNo) ->
%%     Pattern = #ets_shop{shop_type = ShopType, shop_subtype = SubType, page = PageNo, tabno = TabNo, _ = '_'},
%%     case lib_common:get_ets_list(?ETS_SHOP, Pattern) of
%%         List when is_list(List) ->	List;
%% 			_ -> []
%%     end.
%% 
%% %% internal
%% %% desc: 查询商店该页物品列表
%% get_shop_goods_list(PlayerId, ShopType, SubType, PageNo, TabNo) ->
%%     Pattern = #ets_shop{shop_type = ShopType, shop_subtype = SubType, page = PageNo, tabno = TabNo, _ = '_'},
%%     case lib_common:get_ets_list(?ETS_SHOP, Pattern) of
%%         List when is_list(List) -> 
%% 			case ShopType =:= ?SHOP_T_EMPORIUM of % 对商城中限购物品计算剩余购买数量
%% 				true ->
%% 					F = fun(ShopInfo) -> 
%% 					  case lib_common:get_ets_info(?ETS_BUY_GOODS_SHOP, {PlayerId, ShopInfo#ets_shop.goods_id}) of
%% 					        Info when is_record(Info, ets_buy_goods_shop) ->
%% 								BuyNum = Info#ets_buy_goods_shop.buy_num,
%% 								ShopInfo#ets_shop{max = ShopInfo#ets_shop.max - BuyNum};
%% 					  		_ ->   % 没有购买记录
%% 					            ShopInfo
%% 					    end				            
%% 				    end,
%% 				    lists:map(F, List);
%% 				false ->
%% 					List
%% 			end;
%% 			_ -> []
%%     end.
%% 
%% %% internal
%% %% desc: 查询最大页
%% get_max_page(ShopType, SubType, TabNo) ->
%%     Pattern = #ets_shop{shop_type = ShopType, shop_subtype = SubType, tabno = TabNo, page = '$1', _ = '_'},
%%     NumList = ets:match(?ETS_SHOP, Pattern),
%%     case catch lists:max(NumList) of
%%         [Num] when is_integer(Num) ->
%%             Num;
%%         _ ->
%%             ?ERROR_MSG("lib_shop failed, ~p~p~p~n", [ShopType, SubType, TabNo]),
%%             ?ASSERT(false),
%%             1
%%     end.
%%         
%% 
%% 
%% %% internal
%% %% desc: 按位置排列顺序
%% sort_list_by_location(List) ->
%%     F = fun(Info1, Info2) -> Info1#ets_shop.location < Info2#ets_shop.location end,
%%     lists:sort(F, List).
%%     
%%     
%% %% exports
%% %% desc: 淘宝条件检查
%% check_get_treasure(PlayerStatus, Type,  Len) ->
%% 	[BagTypeId, Cost, Times] = data_shop:get_treasure(Type),
%%     IsMember_1 = lists:member(Type, [?TREA_TIMES_SILVER_1, ?TREA_TIMES_GOLD_1, ?TREA_TIMES_JADE_1]),
%%     IsMember_10 = lists:member(Type, [?TREA_TIMES_SILVER_10, ?TREA_TIMES_GOLD_10, ?TREA_TIMES_JADE_10]),
%%     IsMember_50 = lists:member(Type, [?TREA_TIMES_SILVER_50, ?TREA_TIMES_GOLD_50, ?TREA_TIMES_JADE_50]),
%% 	if
%% 		BagTypeId =:= 0 ->
%% 			{fail, 2};   % 淘宝类型不正确
%% 		PlayerStatus#player_status.gold < Cost ->
%% 			{fail, 3};   % 玩家金钱不足(默认使用元宝)
%%         IsMember_1 =:= true andalso Len < 1 ->
%%             {fail, 4};   % 淘宝仓库不足1格
%%         IsMember_10 =:= true andalso Len < 10 ->
%%             {fail, 5};   % 淘宝仓库不足10格
%%         IsMember_50 =:= true andalso Len < 50 ->
%%             {fail, 6};   % 淘宝仓库不足50格
%% 		true ->
%% 			{ok, [BagTypeId, Cost, Times]}
%% 	end.
%% 			
%% 	
%% %% exports
%% %% desc: 获取淘宝信息
%% get_trea_info_list(_) ->
%% 	LogList = sort_trea_info( ets:tab2list(?ETS_TREA_INFO), after_time ),
%%     GoodsTidList = head_8_goodstid(LogList),
%%     [GoodsTidList, LogList].
%% 
%% 
%% %% exports
%% %% desc: 刷新淘宝栏信息
%% refresh_trea_infos(PS) ->
%%     [TidList, InfoList] = gen_server:call({global, ?GLOBAL_SHOP_PROC}, {apply_call, lib_shop, get_trea_info_list, []}),
%%     {ok, BinData} = pt_15:write(15072, [TidList, InfoList]),
%%     lib_send:send_one(PS#player_status.socket, BinData).
%% 
%% %% exports
%% %% desc: 记录淘宝记录
%% record_goods_info(PS, TreaType, GoodsTid) ->
%%     TotalList = ets:tab2list(?ETS_TREA_INFO),
%%     case length( TotalList ) >= ?TREA_MAX_LOG_ITEM of
%%         true ->
%%             [Info1 | _T] = lib_shop:sort_trea_info(TotalList, before_time),
%%             ets:delete_object(?ETS_TREA_INFO, Info1);
%%         false ->
%%             skip
%%     end,
%%     NowTime = util:unixtime(),
%%     PlayerId = PS#player_status.id,
%%     PlayerName = PS#player_status.nickname,
%%     Info = #ets_trea{type = TreaType, role_id = PlayerId, time = NowTime, role_name = PlayerName, goods_t_id = GoodsTid},
%%     ets:insert(?ETS_TREA_INFO, Info).
%% 
%% %% internal
%% %% desc: 排列淘宝橙装记录
%% sort_trea_info(GoodsList, Type) ->
%%     case Type of
%%         before_time ->
%%             F = fun(Info1, Info2) -> Info1#ets_trea.time < Info2#ets_trea.time end, 
%%             lists:sort(F, GoodsList);
%%         after_time ->
%%             F = fun(Info1, Info2) -> Info1#ets_trea.time > Info2#ets_trea.time end, 
%%             lists:sort(F, GoodsList);
%%         _ ->
%%             sort_trea_info(GoodsList, before_time)
%%     end.
%% 
%% 
%% %% exports
%% %% desc: 获取背包中对应物品的数量
%% get_bag_goods_num(_PS, [], Res) ->
%%     Res;
%% get_bag_goods_num(PS, [ShopInfo | T], Res) ->
%%     % 根据物品tid类型规则，对于非给予类型的配置表使用的是非绑定tid，所以这类需要进行一次转化
%% 	case ShopInfo#ets_shop.shop_type =:= ?NPC_COIN_EXCHANGE of % 金币兑换
%% 		true ->
%% 			Tid = ShopInfo#ets_shop.goods_id;
%% 		false ->
%% 			Tid = goods_convert:make_sure_game_tid(ShopInfo#ets_shop.goods_id)
%% 	end,
%%     MateList = data_material:get(Tid),
%%     F = fun({GoodsTid, Num}) ->
%%                 CurNum = goods_util:get_bag_goods_num(PS, GoodsTid, ?LOCATION_BAG),
%%                 {GoodsTid, CurNum, Num}
%%         end,
%%     TupleList = lists:map(F, MateList),
%%     [GoodsTid, Stren, AttrList] = goods_util:get_stren_3_equip(ShopInfo#ets_shop.goods_id),
%%     get_bag_goods_num(PS, T, [{GoodsTid, Stren, AttrList, TupleList} | Res]).
%% 
%% 
%% 
%% 
%% %% --------------------------------------------------------------
%% %% 定时操作
%% %% --------------------------------------------------------------
%% 
%% %% 每日定时操作
%% do_clear_per_day(Time, Pid, Msg) ->
%% 	% todo
%% 	% todo 
%% 	erlang:send_after(Time, Pid, Msg).
%% 	
%% 
%% %% exports
%% %% desc: 清除玩家购买特价商品数量的记录
%% clear_consume_bar_records() ->
%%     {BegTime, EndTime} = case lib_common:get_ets_info(?ETS_GLOBAL_VARIABLE, ?GLOBAL_SHOP_DATE) of
%%         {} ->
%%             {0, 0};
%%         Info ->
%%             Info#ets_global_variable.value
%%     end,
%% 
%%     Now         = util:unixtime(),
%% 
%%     case BegTime =< Now andalso EndTime > Now of
%%         false ->
%% 	        ets:delete_all_objects(?ETS_CONSUME_BAR);
%%         true ->
%%             Ms = ets:fun2ms(fun(X) when X#ets_consume_bar.goods_t_id =/= 580400501 -> true end),
%%             ets:select_delete(?ETS_CONSUME_BAR, Ms)
%%     end.
%% 	% ets:delete_all_objects(?ETS_CONSUME_BAR).
%% 
%% %% exports
%% %% desc: 清除三个月前的销售记录
%% clear_consume_records() ->
%% 	{ {Y, M, D}, _} = calendar:local_time(),
%% 	CurDays = calendar:date_to_gregorian_days(Y, M, D),
%% 	TotalList = ets:tab2list(?ETS_D_SHOP),
%% 	F = fun(Info) ->
%% 				[Year, Month, Day] = [ Info#ets_d_shop.year, Info#ets_d_shop.month, Info#ets_d_shop.day ],
%% 				Days = calendar:date_to_gregorian_days(Year, Month, Day),
%% 				case CurDays - ?KEEP_DAYS >= Days of
%% 					true ->	ets:delete(?ETS_D_SHOP, Info#ets_d_shop.goods_id);
%% 					false ->  skip
%% 				end
%% 		 end,
%% 	lists:foreach(F, TotalList).
%%     
%% %% exports
%% %% desc: 广播消息特价区消息
%% %% BarInfos记录为#shop_state
%% broadcast_bar_new_info(BarInfos) ->
%%     %% desc: 获取商店特价区信息 
%%     List = get_bar_new_info(BarInfos),
%%     %% 广播消息
%%     {ok, BinData} = pt_15:write(15012, List),
%%     lib_send:send_to_all(BinData).
%%     
%% %% 查询特价区信息    
%% get_bar_new_info(BarInfos) ->
%%     NowTime = util:unixtime(),
%%     Time = BarInfos#bar_shop.init_time,
%%     List = BarInfos#bar_shop.goods1 ++ BarInfos#bar_shop.goods2,
%%     LefTime = 
%%         case Time + ?BAR_LASTING_TIME - NowTime > 0 of
%%             true ->                 Time + ?BAR_LASTING_TIME - NowTime;
%%             false ->                0
%%         end,
%%     [LefTime | List].   
%%     
%%     
%% %% exports
%% %% desc: 从ets表获取物品购买价格和价格类型
%% %% returns: {Price, PriceType} Price: 价格， Pricetype : 1-金币，2-元宝，3-战天币
%% get_goods_price(GoodsTid) ->
%%     mod_shop:handle_get_emporium_goods_price(GoodsTid).
%%     
%% %% exports
%% %% 查询vip续费物品信息
%% get_vip_renew_goods() ->
%%     VipTidList = [?VIP_TID_LV_2, ?VIP_TID_LV_3, ?VIP_TID_LV_4, ?VIP_TID_LV_5],
%%     F = fun(Tid) ->
%%                 {Price, PriceType} = get_goods_price(Tid),
%%                 {Tid, Price, PriceType}
%%         end,
%%     lists:map(F, VipTidList).
%%     
%% %% exports
%% %% desc: 改变神秘商店物品的出售状态
%% change_mystery_sells_state(Info, GoodsTid) ->
%%     Sells = Info#mystery_shop.sells,
%%     case lists:keyfind(GoodsTid, 1, Sells) of
%%         false -> 
%%             ?ERROR_MSG("change_mystery_sells_state failed, goods_tid:~p, sells:~p", [GoodsTid, Sells]),
%%             ?ASSERT(false),
%%             skip;
%%         {GoodsTid, _} ->
%%             NewSells = lists:keyreplace(GoodsTid, 1, Sells, {GoodsTid, ?BUY_STATE_ALREADY}),
%%             NewInfo = Info#mystery_shop{sells = NewSells},
%%             update_mystery_data(NewInfo)
%%     end.
%%  
%% %% exports
%% %% desc: 记录珍稀物品
%% record_rare_log(PS, GoodsTid) ->
%%     List = data_mystery_shop:get_mystery_rare(),
%%     case lists:member(GoodsTid, List) of
%%         false -> skip;
%%         true ->
%%              NewTid = case goods_convert:is_game_tid(GoodsTid) of
%%                          true -> GoodsTid;
%%                          false -> goods_convert:get_opp_tid(GoodsTid)
%%                      end,
%%             mod_shop:handle_add_mystery_log(PS#player_status.id, PS#player_status.nickname, NewTid),
%%             LogList = mod_shop:handle_get_mystery_log(),
%%             lib_common:pack_and_send(PS, pt_52, 52000, LogList)
%%     end.
%% 
%% %% exports
%% %% desc: 增加一条神秘商人记录
%% add_new_mystery_data(PlayerId) ->
%%     NexTime = util:unixtime() + ?REFRESH_MYSTERY_INTERVAL,
%%     ClearDate = date(),
%%     LeftClear = ?MYSTERY_CLEAN_TIMES,
%%     Sells = rand_get_sells(),
%%     
%%     Fields = ["player_id", "sells", "nextime", "clear_date", "left_clear"],
%%     Data = [PlayerId, util:term_to_string(Sells), NexTime, util:term_to_string(ClearDate), LeftClear],
%%     
%% 	db:insert(mystery_shop, Fields, Data),
%%     
%%     Info = #mystery_shop{player_id = PlayerId, sells = Sells, nextime = NexTime, clear_date = ClearDate, left_clear = LeftClear},
%%     ets:insert(?ETS_MYSTERY_SHOP, Info).
%%     
%% %% exports
%% %% desc: 抢购商品购买检查      
%% check_can_pay_bargain(BarInfos, PS, Num, Type) ->
%%     Now = util:unixtime(),
%%     if
%%         Type =/= ?BARGAIN_1 andalso Type =/= ?BARGAIN_2 andalso Type =/= ?BARGAIN_3 ->
%%             {fail, 2};   % 购买类型不对，物品不存在
%%         BarInfos#bar_shop.end_time  < Now ->
%%             {fail, 8};   % 出售时间结束
%%         Num =/= 1 ->
%%             {fail, 3};   % 数量不正确
%%         true ->
%%             [GoodsTid, LeftNum, _, Price, PriceType] = lib_shop:get_bargain_goods_data(BarInfos, Type),
%%             if
%%                 GoodsTid =:= 0 ->
%%                     {fail, 2};
%%                 LeftNum =:= 0 ->           
%%                     {fail, 4};   % 物品已售完
%%                 true ->
%%                     check_step_money_enough(PS, Price, PriceType, GoodsTid)
%%             end
%%     end.
%% 
%% %% desc: 检查是否钱足够
%% check_step_money_enough(PS, Price, PriceType, GoodsTid) ->
%%     case lib_money:can_pay(PS, [{Price, PriceType}]) of
%%         false ->
%%             {fail, 7};   % 金额不足
%%         true ->
%%             check_step_bag_enough(PS, Price, PriceType, GoodsTid)
%%     end.
%% 
%% %% desc: 检查背包空间是否足够
%% check_step_bag_enough(PS, Price, PriceType, GoodsTid) ->
%%     case goods_util:can_put_into_bag(PS, [GoodsTid]) of
%%         true ->
%%             case mod_shop:handle_get_bargain_record(PS#player_status.id, GoodsTid) of
%%                 {} ->
%%                     {ok, Price, PriceType, GoodsTid};
%%                 _Info ->
%%                     {fail, 5}    % 购买数量超过上限
%%             end;
%%         false ->
%%             {fail, 6}    % 背包格子不足
%%     end.
%% 
%% 
%% 
%% 
%% %% ---------------------------------------------
%% %% Local Functions
%% %% ---------------------------------------------
%% 
%% %% desc: 依次查询物品的价格和价格类型
%% order_get_goods_price(List) ->
%%     F = fun({Tid, State}) ->
%%                 {Price, PriceType} = mod_shop:handle_get_mystery_goods_price(Tid),
%%                 {Tid, State, Price, PriceType}
%%         end,
%%     lists:map(F, List).
%% 
%% %% desc: 随即抽选一样物品
%% get_rand_goods([]) ->
%%     [{0, 0, 0, 0, 0}, []];                 
%% get_rand_goods(GoodsList) ->
%%     Rand = util:rand(1, length(GoodsList) ),
%%     Goods = lists:nth(Rand, GoodsList),
%%     [Goods, lists:delete(Goods, GoodsList)].
%% 
%% %% desc: 获取排名靠前的物品ID列表
%% get_top_goods(TOP) ->
%%     TotalList = ets:tab2list(?ETS_D_SHOP),
%%     TupleList = count_same_goods_num(TotalList, []),
%%     SortedList = sort_tuples_by_num(TupleList),   % 由大到小排列
%%     lists:sublist(SortedList, 1, TOP).
%% 
%% %% desc: 统计同类物品的销售数量
%% count_same_goods_num([], Result) ->
%%     Result;
%% count_same_goods_num([ Info | T ], Result) ->
%%     [GoodsTid, GoodsNum] = [Info#ets_d_shop.goods_id, Info#ets_d_shop.sell_num],
%%     NewResult = case lists:keyfind(GoodsTid, 1, Result) of
%%                         false ->                            [ {GoodsTid, GoodsNum} | Result ];
%%                         {GoodsTid, Num} ->              lists:keyreplace(GoodsTid, 1, Result, {GoodsTid, Num + GoodsNum})
%%                    end,
%%     count_same_goods_num(T, NewResult).
%%     
%% %% desc: 由大到小排列物品
%% %% todo: 
%% sort_tuples_by_num(TupleList) ->
%%     F = fun({_, Num1}, {_, Num2}) -> Num1 >= Num2 end,
%%     lists:sort(F, TupleList).
%% 
%% %% desc: 随机获取神秘商店出售物品ID
%% rand_get_sells() ->
%%     {TidList, Num} = get_rare_goods(),
%%     TidList ++ get_usual_goods(Num).
%% 
%% %% desc: 获取神秘商店普通物品(5种) 
%% get_usual_goods(Num) ->
%%     List = data_mystery_shop:get_usual_mystery(),
%%     rand_myster_choose(List, Num).
%% 
%% %% desc: 获取神秘商店珍惜物品(1种) 
%% %% DropInfo: 
%% get_rare_goods() ->
%%     [DropInfo | _] = lib_drop:single_drop(9100, ?DROP_MYSTERY),
%%     case util:rand(1, 100) > 50 of
%%         true -> % 不出现
%%             {[], 6};
%%         false ->
%%             {[{DropInfo#ets_drop_content.goods_id, ?BUY_STATE_NOTYET}], 5}
%%     end.
%% 
%% %% desc: 随机选取列表中的元素
%% rand_myster_choose(List, Num) ->
%%     F = fun(_, [LeftList, Result]) ->
%%                 Rand = util:rand( 1, length(LeftList) ),
%%                 GoodsTid = lists:nth(Rand, LeftList),
%%                 NewLeft = lists:delete(GoodsTid, LeftList),
%%                 [NewLeft, 
%%                  [{GoodsTid, ?BUY_STATE_NOTYET} | Result]
%%                 ]
%%         end,
%%     [_, ResList] = lists:foldl(F, [List, []], lists:seq(1, Num)),
%%     ResList.
%%     
%% %% exports only for gm
%% %% desc: 更新神秘商店数据
%% update_mystery_data(Info) ->
%%     PlayerId = Info#mystery_shop.player_id,
%%     Sells = util:term_to_string(Info#mystery_shop.sells),
%%     NexTime = Info#mystery_shop.nextime,
%%     ClearDate = util:term_to_string(Info#mystery_shop.clear_date),
%%     LeftClear = Info#mystery_shop.left_clear,
%%     
%%     db:update(mystery_shop, ["sells", "nextime", "clear_date", "left_clear"], [Sells, NexTime, ClearDate, LeftClear], "player_id", PlayerId),
%%     ets:insert(?ETS_MYSTERY_SHOP, Info).
%% 
%% %% desc: 登录时更新ets表信息
%% login_insert_ets(PlayerId, Sells, NexTime, ClearDate, LeftClear) ->
%%     NewSells = util:bitstring_to_term(Sells),
%%     NewClearDate = util:bitstring_to_term(ClearDate),
%%     NewLeftClear = case NewClearDate =:= date() of
%%                        true -> LeftClear;
%%                        false -> ?MYSTERY_CLEAN_TIMES
%%                    end,
%%     Info = #mystery_shop{
%%                          player_id = PlayerId,
%%                          sells = NewSells,
%%                          nextime = NexTime,   
%%                          clear_date = NewClearDate,   
%%                          left_clear = NewLeftClear
%%                         },
%%     ets:insert(?ETS_MYSTERY_SHOP, Info).
%% 
%% %% desc: 查询前8条记录的物品类型ID列表
%% head_8_goodstid(LogList) ->
%%     Log8List = lists:sublist(LogList, 8),
%%     F = fun(Info) -> Info#ets_trea.goods_t_id end,
%%     lists:map(F, Log8List).
%% 
%% %% desc: 加载淘宝信息
%% load_trea_infos(PlayerId) ->
%%     F = fun(TreaCost) -> 
%%                 Info = #trea_total_cost{player_id = PlayerId, gold = TreaCost},
%%                 ets:insert(?ETS_TREA_COST, Info)
%%         end,
%%     
%%     case db:select_row(trea_total_cost, "gold", [{player_id,PlayerId}]) of
%%         List when is_list(List) ->
%%             lists:foreach(F, List);
%%         _Error ->?ASSERT(false), skip
%%     end.
%% 
%% %% desc: 加载神秘商店信息
%% load_mystery_infos(_PlayerId, 1) -> ?ASSERT(false), skip;
%% load_mystery_infos(PlayerId, 0) ->
%%     F = fun([Sells, NexTime, ClearDate, LeftClear]) ->
%%                 login_insert_ets(PlayerId, Sells, NexTime, ClearDate, LeftClear)
%%         end,
%%    
%%     case db:select_row(mystery_shop, ?SQL_SELECT_MYSTERY_SHOP, [{player_id,PlayerId}]) of
%%         [] ->
%%             add_new_mystery_data(PlayerId),
%%             load_mystery_infos(PlayerId, 1);
%%         List when is_list(List) ->
%%             lists:foreach(F, [List]),
%%             mod_shop:handle_client_refresh_mystery(PlayerId);
%%         _Error -> ?ASSERT(false), skip
%%     end.
%% 
%% 
%% %% desc: 通过ID查询物品在商城中的类型和子类型(仅限商城，否则返回{0, 0})
%% get_shop_goods_types(GoodsTid) ->
%%     Pattern = #ets_shop{shop_type = ?SHOP_T_EMPORIUM, goods_id = GoodsTid, _ = '_'},
%%     case lib_common:get_ets_info(?ETS_SHOP, Pattern) of
%%         {} ->    {0, 0};
%%         Info -> {?SHOP_T_EMPORIUM, Info#ets_shop.shop_subtype}
%%     end.
%%             
%% %% desc: 更新购买副本商人记录
%% update_shop_dungeon_log(SellInfo, PlayerId, Num) ->
%%     case lib_common:get_ets_info(?ETS_DUNGEON_SHOP, PlayerId) of
%%         {} ->   % 没有购买记录
%%             add_new_record(SellInfo, PlayerId, Num);
%%         Info ->
%%             update_dungeon_shop_record(Info, Num, SellInfo)
%%     end.
%% 
%% %% desc: 添加一条新的副本商人购买记录
%% add_new_record(SellInfo, PlayerId, Num) ->
%%     GoodsTid = SellInfo#ets_shop.goods_id,
%%     Key = {SellInfo#ets_shop.shop_type, GoodsTid},
%%     Content = [{Key, Num, SellInfo#ets_shop.max, util:get_date()}],
%%     Info = #ets_dungeon_shop{player_id = PlayerId, content = Content},
%%     ets:insert(?ETS_DUNGEON_SHOP, Info),
%%     db_add_new_dungeon_shop_record(Info).
%% 
%% %% desc: 更新的副本商人购买记录
%% update_dungeon_shop_record(Info, Num, SellInfo) ->
%%     GoodsTid = SellInfo#ets_shop.goods_id,
%%     Key = {SellInfo#ets_shop.shop_type, GoodsTid},
%%     OldList = Info#ets_dungeon_shop.content,
%%     NewList = 
%%         case lists:keyfind(Key, 1, OldList) of
%%             false -> [{Key, Num, SellInfo#ets_shop.max, util:get_date()} | OldList];
%%             {_, OldNum, _, _} ->
%%                 lists:keyreplace(Key, 1, OldList, {Key, Num + OldNum, SellInfo#ets_shop.max, util:get_date()})
%%         end,
%%     NewInfo = Info#ets_dungeon_shop{content = NewList},
%%     ets:insert(?ETS_DUNGEON_SHOP, NewInfo),
%%     db_update_dungeon_shop_record(NewInfo).
%%             
%% %% desc: 更新数据库中副本商人记录
%% db_update_dungeon_shop_record(Info) ->
%%     Content = Info#ets_dungeon_shop.content,
%%     Term = util:term_to_bitstring(Content),
%%     db:update(shop_dungeon, [content], [Term], "player_id", Info#ets_dungeon_shop.player_id).
%% 
%% %% desc: 添加一条副本商人记录
%% db_add_new_dungeon_shop_record(Info) ->
%%     Content = Info#ets_dungeon_shop.content,
%%     Term = util:term_to_bitstring(Content),
%%     db:insert(shop_dungeon, [player_id, content], [Info#ets_dungeon_shop.player_id, Term]).
%% 
%% %% exports
%% %% desc: 清理非今日的副本商人购买记录
%% handle_del_yesterday_dungeon_record(PlayerId) ->
%%     case lib_common:get_ets_info(?ETS_DUNGEON_SHOP, PlayerId) of
%%         {} -> skip;
%%         Info ->
%%             case lists:keyfind(util:get_date(), 4, Info#ets_dungeon_shop.content) of
%%                 false ->
%%                     case Info#ets_dungeon_shop.content == [] of
%%                         true -> skip;
%%                         false ->
%%                             NewInfo = Info#ets_dungeon_shop{content = []},
%%                             db_update_dungeon_shop_record(NewInfo),
%%                             ets:insert(?ETS_DUNGEON_SHOP, NewInfo)
%%                     end;
%%                 _ -> skip
%%             end
%%     end.
%% 
%% 
%% 
%% %% 增加或修改当天商城购买数量记录
%% update_buy_shopgoods_info(GoodsTid, PlayerId, Num) ->
%% 	case lib_common:get_ets_info(?ETS_BUY_GOODS_SHOP, {PlayerId, GoodsTid}) of
%%         Info when is_record(Info, ets_buy_goods_shop) ->
%% 			NewInfo = Info#ets_buy_goods_shop{buy_num = Info#ets_buy_goods_shop.buy_num + Num},
%% 			ets:insert(?ETS_BUY_GOODS_SHOP, NewInfo),			
%% 			spawn(fun()-> db:update(buy_shopgoods_info, [{buy_num,NewInfo#ets_buy_goods_shop.buy_num}], [{player_id, PlayerId}, {goods_id, GoodsTid}]) end);
%%   		_ ->   % 没有购买记录
%%             NewInfo = #ets_buy_goods_shop{
%%                                key = {PlayerId, GoodsTid},
%%                                buy_num = Num
%%                               },
%%             ets:insert(?ETS_BUY_GOODS_SHOP, NewInfo),
%% 			spawn(fun()-> handle_buy_shopgoods_info(PlayerId, GoodsTid, Num) end)
%%     end.
%% 
%% handle_buy_shopgoods_info(PlayerId, GoodsTid, Num) ->
%% 	db:delete(buy_shopgoods_info, [{player_id, PlayerId}, {goods_id, GoodsTid}]),
%% 	db:insert(buy_shopgoods_info, [player_id, goods_id, buy_num], [PlayerId, GoodsTid, Num]).
%% 
%% %% exports
%% %% desc: 清理昨天的商城购买记录
%% del_yesterday_shopgoods_info(PlayerId) ->
%% 	ets:match_delete(?ETS_BUY_GOODS_SHOP, #ets_buy_goods_shop{key = {PlayerId, _ = '_'}, _ = '_'}),
%% 	db:delete(buy_shopgoods_info, [{player_id, PlayerId}]).
%% 
%% %% exports
%% %% desc: 获取npc商人装备兑换物品列表
%% get_npc_equip_goods(Career, ShopType, ShopSub, PageNo, TabNo) when erlang:is_integer(ShopType) ->
%%     case check_input_legal(ShopSub, PageNo) of
%%         legal ->    
%% 			List = get_shop_goods_list(ShopType, ShopSub, TabNo),
%% 			NewList = filter_equip_by_carrer(Career, List),
%% 		    ListLength = length(NewList),
%%     		MaxPage = case ListLength > ?NPC_EXCHANGE_EQUIP_SHOW of
%% 							true ->
%% 								case (ListLength rem ?NPC_EXCHANGE_EQUIP_SHOW) =:= 0 of
%% 									true ->
%% 										ListLength div ?NPC_EXCHANGE_EQUIP_SHOW;
%% 									false ->
%% 										(ListLength div ?NPC_EXCHANGE_EQUIP_SHOW) + 1
%% 								end;
%% 							false ->
%% 								1
%% 					  end,
%% 			
%% 			BeginNum = (PageNo-1) * ?NPC_EXCHANGE_EQUIP_SHOW + 1,
%% 			ShopList = lists:sublist(NewList, BeginNum, ?NPC_EXCHANGE_EQUIP_SHOW),
%%     		% 对List中的物品进行location排列
%%     		SortedList = sort_list_by_location(ShopList),
%%     		[SortedList, MaxPage];
%%         illegal ->
%%             [[] , 1]
%%     end.
%% 
%% %% exports
%% %% desc: 获取npc装备商人物品列表
%% get_npc_equip_goods(PS, ShopType, ShopSub, PageNo) ->
%%     case check_input_legal(ShopSub, PageNo) of
%%         legal ->
%% 			List = get_shop_goods_list(ShopType, ShopSub, 0),
%% 			NewList = filter_equip_by_carrer(PS#player_status.career, List),
%% 		    ListLength = length(NewList),
%%     		MaxPage = case ListLength > ?NPC_EQUIP_SHOW of
%% 							true ->
%% 								case (ListLength rem ?NPC_EQUIP_SHOW) =:= 0 of
%% 									true ->
%% 										ListLength div ?NPC_EQUIP_SHOW;
%% 									false ->
%% 										(ListLength div ?NPC_EQUIP_SHOW) + 1
%% 								end;
%% 							false ->
%% 								1
%% 					  end,
%% 			
%% 			BeginNum = (PageNo-1) * ?NPC_EQUIP_SHOW + 1,
%% 			ShopList = lists:sublist(NewList, BeginNum, ?NPC_EQUIP_SHOW),
%% 			SortedList = sort_list_by_location(ShopList),
%%             List1 = case ShopSub == ?NPC_SHOP_DUNGEON of
%%                         true ->  goods_util:handle_check_left_goods_num(PS, ShopType, SortedList); % 副本商人，做购买个数检查
%%                         false -> goods_util:handle_add_left_num(SortedList)
%%                     end,
%%             [List1, MaxPage];
%%         illegal ->  
%%             [[] , 1]
%%     end.
%% 
%% %% exports
%% %% desc: 获取本职业装备兑换物品列表
%% %% returns: List
%% filter_equip_by_carrer(Career, ShopList) ->
%% 	F = fun(ShopInfo) ->
%% 				Tid = ShopInfo#ets_shop.goods_id,
%%                 case is_integer(Tid) andalso Tid > 0 of
%%                     true ->
%% 						RealCareer = lib_goods:get_goods_career(Tid),
%% 						(Career =:= RealCareer) orelse (RealCareer =:= ?CAREER_ALL);
%% 					false ->
%% 						false
%%                 end
%%         end,
%% 	lists:filter(F, ShopList).