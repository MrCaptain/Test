%%%-------------------------------------- 
%%% @Module: mod_shop
%%% @Author: 
%%% @Created: 
%%% @Description: 商城
%%%-------------------------------------- 
-module(mod_shop).
-behaviour(gen_server).
-export([
		    start_link/0%%,
			 
%% 			handle_show_goods/4, 
%% 			handle_show_goods/5, 
%% 			handle_show_bargain/1,
%%             
%%             handle_get_mystery_log/0,
%%             handle_get_mystery_infos/1,
%%             handle_role_refresh_mystery/1,
%%             handle_client_refresh_mystery/1,
%%             handle_buy_mystery/2,
%% 			handle_add_mystery_log/3, 
%%             handle_add_trea_orange_record/3,
%%             handle_get_mystery_max_id/0,
%%             handle_get_bargain_record/2,
%%             
%% 			handle_pay_bargain/3,
%% 			handle_pay_goods/4,
%%             handle_buy_npc_sells/4,
%%             
%%             get_npc_goods_info/3,
%%             handle_get_emporium_goods_price/1,
%%             handle_get_mystery_goods_price/1,
%%             get_treasure/2,
%%             handle_reset_trea_cost/1,
%%             handle_add_trea_cost/2,
%%             buy_partner_card_record/1,
%% 
%%             rpc_get_global_variable/1
			
		  ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).


%%
%% Including Files
%%

-include("common.hrl").
-include("record.hrl").
-include("common_shop.hrl"). 
-include("goods.hrl").
-include("common_log.hrl").
-include("debug.hrl").
-define(GLOBAL_SHOP_DATE,      2).          %% 商城活动时间
-define(ETS_GLOBAL_VARIABLE, ets_global_variable).              %% 全局变量,从SQL读取
%%
%% API Functions
%%

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% -------------------------------------------
%% 特价区操作
%% -------------------------------------------

%% desc: 获取商店特价区信息 
handle_show_bargain(PS) ->
    gen_server:call({global, ?GLOBAL_SHOP_PROC}, {'SHOW_BARGAIN', PS}).

%% desc: 获取商店特价区记录
handle_get_bargain() ->
    gen_server:call({global, ?GLOBAL_SHOP_PROC}, 'GET_BARGAIN').

%% desc: 查询自己购买特价区某商品的记录
handle_get_bargain_record(PlayerId, GoodsTid) ->
    gen_server:call({global, ?GLOBAL_SHOP_PROC}, {'GET_MY_BARGAIN_RECORD', PlayerId, GoodsTid}).

%% desc: 添加一条购买记录
handle_add_bargain_record(PlayerId, GoodsTid, Num, Price, PriceType) ->
    gen_server:cast({global, ?GLOBAL_SHOP_PROC}, {'ADD_BARGAIN_RECORD', PlayerId, GoodsTid, Num, Price, PriceType}).
    
%% desc: 购买特价区物品
handle_pay_bargain(PS, Num, Type) ->
    BarInfos = handle_get_bargain(),
    case lib_shop:check_can_pay_bargain(BarInfos, PS, Num, Type) of
        {fail, Res} ->
            {Res, PS, 0};
        {ok, Price, PriceType, GoodsTid} ->
            NewPS = lib_money:cost_money(statistic, PS, Price, PriceType, ?LOG_BUY_GOODS, GoodsTid),
            handle_add_bargain_record(PS#player.id, GoodsTid, Num, Price, PriceType),
            goods_util:send_shopgoods_to_role(?BIND_NOTYET, ?LOCATION_BAG, [{GoodsTid, 1}], NewPS),
            % 记录藏宝阁限量物品在商城的卖出
            mod_trea_house:log_lim_goods_sales_at_RMB_shop(GoodsTid, Num),
			LogPriceType = log:change_currency_type(PriceType),
%% 			log:log_goods_source(NewPS#player_status.id, GoodsTid, Num, LogPriceType, Price, ?LOG_BUSINESS_SHOP, ?LOG_GOODS_BUY),
            {?RESULT_OK, NewPS, GoodsTid}
    end.

%% -----------------------------------------
%% 商城普通区部分
%% -----------------------------------------

%% desc: 获取商店物品列表
%% returns: [GoodsList, TotalPage]
handle_show_goods(PlayerId, ShopType, ShopSub, PageNo) ->
    handle_show_goods(PlayerId, ShopType, ShopSub, PageNo, 0).

handle_show_goods(PlayerId, ShopType, ShopSub, PageNo, TabNo) when erlang:is_integer(ShopType) ->
    case lib_shop:check_input_legal(ShopSub, PageNo) of
        legal ->    
            lib_shop:get_selected_data(PlayerId, ShopType, ShopSub, PageNo, TabNo);
        illegal ->  
            [[] , 1]
    end.

%% %% exports
%% %% desc: 购买商城物品
%% -define(PARTNER_CARD_LIST, [230700001, 230700002, 230700003, 230700004]).
%% handle_pay_goods(PS, GoodsTid, Num, {ShopType, ShopSub}) ->
%%     case lib_shop:check_pay(GoodsTid, PS, Num, ShopType, ShopSub) of
%%         {fail, Res} ->
%%             {Res, PS};
%%         {ok, Price, PriceType} ->
%%             NewPS = lib_money:cost_money(statistic, PS, Price, PriceType, ?LOG_BUY_GOODS, GoodsTid),
%%             {Type, SubType} = lib_goods:get_type_and_subtype(GoodsTid),
%%             BindState = case Type == ?GOODS_T_PARTNER_CARD andalso SubType == 07 of
%%                             true -> ?BIND_ALREADY;
%%                             false -> ?BIND_NOTYET
%%                         end,
%%             goods_util:send_shopgoods_to_role(BindState, ?LOCATION_BAG, [{GoodsTid, Num}], NewPS),
%% 			lib_shop:update_buy_shopgoods_info(GoodsTid, PS#player_status.id, Num),
%% 			LogPriceType = log:change_currency_type(PriceType),
%% 			% 完成用魔晶购买商品任务
%% 			case PriceType =:= ?MONEY_T_BCOIN of
%% 				true -> mod_player:notice_buy_mojing_shop(PS#player_status.pid);
%% 				false -> skip
%% 			end,
%% 			log:log_goods_source(NewPS#player_status.id, GoodsTid, Num, LogPriceType, Price, ?LOG_BUSINESS_SHOP, ?LOG_GOODS_BUY),
%%             % 记录藏宝阁限量物品在商城的卖出
%%             case ShopType =:= ?SHOP_T_EMPORIUM of
%%                 false -> skip;
%%                 true -> mod_trea_house:log_lim_goods_sales_at_RMB_shop(GoodsTid, Num)
%%             end,
%%             NewPS1 = 
%%                 case Type == ?GOODS_T_PARTNER_CARD andalso SubType == 07 of
%%                     true -> 
%%                         lib_common:actin_new_proc(mod_shop, buy_partner_card_record, [NewPS]),
%%                         NewPS#player_status{partner_card = 1};
%%                     false ->
%%                         NewPS
%%                 end,
%%             {?RESULT_OK, NewPS1}
%%     end.
%% 
%% 
%% %% -----------------------------------------
%% %% NPC 商人部分
%% %% -----------------------------------------
%% 
%% %% desc: 查询NPC全部商品Id列表
%% get_npc_goods_info(NpcId, GoodsTid, ShopSubType) ->
%%     NewNpcId = 
%%         case NpcId =:= 0 of
%%             true -> ?OBJECT_REMOTE_SHOP;
%%             false -> NpcId
%%         end,
%%     lib_shop:get_shop_info(NewNpcId, ShopSubType, GoodsTid).
%% 
%% %% desc: 向NPC购买物品
%% handle_buy_npc_sells(PS, NpcId, GoodsTid, Num) ->
%%     List = [get_npc_goods_info(NpcId, GoodsTid, ?NPC_SHOP_BUY)] ++ [get_npc_goods_info(NpcId, GoodsTid, ?NPC_SHOP_DUNGEON)],
%%     [SellInfo | _] = lists:filter(fun(Info) -> is_record(Info, ets_shop) end, List),
%%     IsDungeonShop = lib_shop:is_dungeon_shop(SellInfo),
%%     case lib_shop:check_buy_goods(PS, Num, SellInfo) of
%%         {fail, Res} ->
%%             [Res, PS];
%%         {ok, Cost, PriceType} ->
%%             NewPS = lib_money:cost_money(statistic, PS, Cost, PriceType, ?LOG_BUY_GOODS, GoodsTid),
%%             case IsDungeonShop of
%%                 true -> lib_shop:update_shop_dungeon_log(SellInfo, NewPS#player_status.id, Num);
%%                 false -> skip
%%             end,
%%             goods_util:send_shopgoods_to_role(?BIND_NOTYET, ?LOCATION_BAG, [{GoodsTid, Num}], NewPS),
%% 			LogPriceType = log:change_currency_type(PriceType),
%%             log:log_goods_source(NewPS#player_status.id, GoodsTid, Num, LogPriceType, Cost, ?LOG_NPC_SHOP, ?LOG_GOODS_BUY),
%%             mod_log:log_consume(?SHOP_N_NPC, GoodsTid, PS, NewPS),
%%             [?RESULT_OK, NewPS]
%%     end.
%%     
%%     
%% %% desc: 查询某一件商城物品的价格和价格类型
%% %% returns: {Price, PriceType}
%% handle_get_emporium_goods_price(GoodsTId) ->
%%     Pattern = #ets_shop{shop_type = ?OBJECT_EMPORIUM, goods_id = GoodsTId, _ = '_'},
%%     case lib_common:get_ets_info(?ETS_SHOP, Pattern) of
%%         Info when is_record(Info, ets_shop) ->
%%             {Info#ets_shop.price, Info#ets_shop.price_type};
%%         _a ->
%%             Tid1 = goods_convert:get_opp_tid(GoodsTId),
%%             case lib_common:get_ets_info(?ETS_SHOP, Pattern#ets_shop{goods_id = Tid1}) of
%%                 Info when is_record(Info, ets_shop) ->
%%                     {Info#ets_shop.price, Info#ets_shop.price_type};
%%                 _b ->   % 到非显示商城类型中查询价格
%%                     Pattern1 = #ets_shop{shop_type = ?SHOP_T_GOODS_PRICE, goods_id = GoodsTId, _ = '_'},
%%                     case lib_common:get_ets_info(?ETS_SHOP, Pattern1) of
%%                         Info when is_record(Info, ets_shop) ->
%%                             {Info#ets_shop.price, Info#ets_shop.price_type};
%%                         _c ->
%%                             case lib_common:get_ets_info(?ETS_SHOP, Pattern1#ets_shop{goods_id = Tid1}) of
%%                                 Info when is_record(Info, ets_shop) ->
%%                                     {Info#ets_shop.price, Info#ets_shop.price_type};
%%                                 _d ->
%%                                     %?ERROR_MSG("bad goods_tid in base_shop config table:~p", [GoodsTId]),
%%                                     {999999, 0}
%%                             end
%%                     end
%%             end
%%     end.
%%
%% Callback Functions
%%

init([]) ->
	process_flag(trap_exit, true),
	misc:register(global, ?GLOBAL_SHOP_PROC, self()),
	 
%% 	ets:new(?ETS_CONSUME_BAR, [named_table, {keypos, #ets_consume_bar.role_id}, duplicate_bag, public]),      % 商城物品ets表
%%     ets:new(?ETS_GLOBAL_VARIABLE, [{keypos, #ets_global_variable.id}, named_table, public, set]),    %% 全局变量
%%     mod_kernel:init_global_config(true),
%% 	 
%%     BarGoods = lib_shop:init_bargain_shop(),    % 初始化特价商品
%% 
%%     % 修改为手动控制
%%     refresh_bargain_event(),
%% 
%%     gen_server:cast({global, ?GLOBAL_TIMER}, {'DEL_MYSTERY_LOG', self(), ?START_TOMORROW, ?ONE_DAY_MSECONDS}),
%% 	
%% 	lib_shop:load_consume_bar_log(),
%%     MysteryLogId = handle_get_mystery_max_id(),
    
	?TRACE("---Shop Init Finished...!~n"),
	{ok, #shop_state{} }. 
	 
%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, State) -> 
	Reply = 
		case (catch apply(Module, Method, [State | Args])) of
			{'EXIT', Info} ->
				?ERROR_MSG("mod_shop_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
  				error;
  			DataRet -> 
				DataRet
		end,
    {reply, Reply, State};

%% %% desc: 查询特价区商品
%% handle_call({'SHOW_BARGAIN', PS}, _From, State) ->
%%     BarInfos = State#shop_state.barlist,
%%     NowTime = util:unixtime(),
%%     % Time = BarInfos#bar_shop.init_time,
%%     % LefTime = case Time + ?BAR_LASTING_TIME - NowTime > 0 of
%%     %               true ->     Time + ?BAR_LASTING_TIME - NowTime;
%%     %               false ->     0
%%     %           end,
%% 
%%     EndTime = BarInfos#bar_shop.end_time,
%%     LefTime = case EndTime > NowTime of
%%         true ->
%%             EndTime - NowTime;
%%         false ->
%%             0
%%     end,
%% 
%%     {Buy1, Buy2, Buy3} = lib_shop:get_bargain_buy_state(BarInfos, PS),
%%     List = [{Buy1, BarInfos#bar_shop.goods1}, {Buy2, BarInfos#bar_shop.goods2}, {Buy3, BarInfos#bar_shop.goods3}],
%%     {reply, [LefTime, List], State};
%% 
%% %% desc: 获取特价区记录
%% handle_call('GET_BARGAIN', _From, State) ->
%%     BarInfos = State#shop_state.barlist,
%%     {reply, BarInfos, State};
%% 
%% %% desc: 查询指定类型的特价区物品类型ID
%% handle_call({'GET_BARGAIN_TID', Type}, _From, State) ->
%%     BarInfos = State#shop_state.barlist,
%%     GoodsTid = lib_shop:get_bargain_t_id(BarInfos, Type),
%%     {reply, GoodsTid, State};
%% 
%% %% desc: 查询自己特价区消费记录
%% handle_call({'GET_MY_BARGAIN_RECORD', PlayerId, GoodsTid}, _From, State) ->
%%     Pattern = #ets_consume_bar{role_id = PlayerId, goods_t_id = GoodsTid, _ = '_'},
%%     Info = lib_common:get_ets_info(?ETS_CONSUME_BAR, Pattern),
%%     {reply, Info, State};
%% 
%% %% desc: 查询ETS全局变量信息
%% handle_call({'GET_GLOBAL_VARIABLE', Id}, _From, State) ->
%%     Info = lib_common:get_ets_info(?ETS_GLOBAL_VARIABLE, Id),
%%     {reply, Info, State};

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%% 统一模块+过程调用(cast)
handle_cast({apply_cast, Module, Method, Args}, State) -> 
		case (catch apply(Module, Method, [State | Args])) of
			{'EXIT', Info} ->
				?ERROR_MSG("mod_shop_apply_cast error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
  				error;
  			DataRet -> 
				DataRet
		end,
    {noreply, State};

%% %% desc: 改变特价区状态
%% handle_cast({'SET_BAR_STATE', NewBarlist}, State) ->
%%     NewState = State#shop_state{barlist = NewBarlist},
%% 	{noreply, NewState};
%% 
%% %% 更改特价区物品数量(目前仅gm使用)
%% handle_cast({'change_b_num', Type, NewNum}, State) ->
%%     BarInfos = State#shop_state.barlist,
%%     NewBarInfos = case Type of
%%                    1 -> 
%%                        [Tid, _Num, O, P, Pt] = BarInfos#bar_shop.goods1,
%%                        BarInfos#bar_shop{goods1 = [Tid, NewNum, O, P, Pt]};
%%                    2 -> 
%%                        [Tid, _Num, O, P, Pt] = BarInfos#bar_shop.goods2,
%%                        BarInfos#bar_shop{goods2 = [Tid, NewNum, O, P, Pt]};
%%                    3 -> 
%%                        [Tid, _Num, O, P, Pt] = BarInfos#bar_shop.goods3,
%%                        BarInfos#bar_shop{goods3 = [Tid, NewNum, O, P, Pt]};
%%                    _ ->
%%                        BarInfos
%%                end,
%%     NewState = State#shop_state{barlist = NewBarInfos},
%%     {noreply, NewState};
%% 
%% %% desc: 更改特价区物品数量
%% handle_cast({'ADD_BARGAIN_RECORD', PlayerId, GoodsTid, Num, Price, PriceType}, State) ->
%%     BarInfos = State#shop_state.barlist,
%%     [Tid1, Num1, O1, P1, Pt1] = BarInfos#bar_shop.goods1,
%%     [Tid2, Num2, O2, P2, Pt2] = BarInfos#bar_shop.goods2,
%%     [Tid3, Num3, O3, P3, Pt3] = BarInfos#bar_shop.goods3,
%%     NewInfos = case GoodsTid of
%%                    Tid1 ->  BarInfos#bar_shop{goods1 = [Tid1, Num1 - Num, O1, P1, Pt1]};
%%                    Tid2 ->  BarInfos#bar_shop{goods2 = [Tid2, Num2 - Num, O2, P2, Pt2]};
%%                    Tid3 ->  BarInfos#bar_shop{goods3 = [Tid3, Num3 - Num, O3, P3, Pt3]};
%%                    _ -> BarInfos
%%                end,
%%     lib_shop:add_bargain_record(PlayerId, GoodsTid, Num, Price, PriceType),
%%     {noreply, State#shop_state{ barlist = NewInfos} };
%% 
%% %% desc: 刷新特价区
%% handle_cast('refresh_bargain', State) ->
%%     lib_shop:clear_consume_bar_records(),
%%     NewBarlist = lib_shop:init_bargain_shop(),
%%     NewState = State#shop_state{barlist = NewBarlist},
%%     refresh_bargain_event(),
%%     {noreply, NewState};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% %% desc: 定时操作
%% %% 清除3个月前的销售记录
%% handle_info('refresh_consume', State) ->
%%     lib_shop:clear_consume_bar_records(),
%%     {noreply, State};
%% 
%% %% desc: 刷新特价区
%% handle_info('refresh_bargain', State) ->
%%     lib_shop:clear_consume_bar_records(),
%%     NewBarlist = lib_shop:init_bargain_shop(),
%%     NewState = State#shop_state{barlist = NewBarlist},
%%     refresh_bargain_event(),
%%     {noreply, NewState};

handle_info(_Msg, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
	
rpc_get_global_variable(Id) ->
    case catch gen_server:call({global, ?GLOBAL_SHOP_PROC}, {'GET_GLOBAL_VARIABLE', Id}) of
        {'EXIT', _Reason} ->
            {};
        Info ->
            Info
    end. 

refresh_bargain_event() ->
    {BegTime, EndTime} = case lib_common:get_ets_info(?ETS_GLOBAL_VARIABLE, ?GLOBAL_SHOP_DATE) of
        {} ->
            {0, 0}; 
        Info ->
%%             Info#ets_global_variable.value
			0
    end,

    Now         = util:unixtime(),

    case BegTime =< Now andalso EndTime > Now of
        false ->
            erlang:send_after(?REFRESH_INTERVAL * 1000, self(), 'refresh_bargain');
        true ->
            % {_, T}  = calendar:universal_time(),
            {_, T}  = calendar:local_time(),
            Secs    = calendar:time_to_seconds(T),
            LeftTimes = ?ONE_DAY_SECONDS - Secs,
            erlang:send_after(LeftTimes * 1000, self(), 'refresh_bargain')
    end.