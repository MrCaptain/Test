%%%--------------------------------------
%%% @Module  : goods_util
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description : 物品实用工具类
%%%--------------------------------------
-module(goods_util).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).
%% %% -export(
%% %%     [
%% %%         init_goods/0,
%% %%         init_goods_online/3,
%% %%         goods_offline/2,
%% %%         get_ets_info/2,
%% %%         get_ets_list/2,
%% %% 		get_base_goods/1,
%% %%         get_goods_name/1,
%% %% 		get_goods_sell/1,
%% %%         get_task_mon/1,
%% %%         get_goods_num/3,
%% %% 		get_goods_num/2,
%% %% 		get_goods_num_unbind/3,
%% %%         get_new_goods/1,
%% %% %% 		get_new_goods/2,
%% %% 		chk_new_equit_goods/2,
%% %% 		get_new_goods_add_attribute/1,
%% %%         get_goods/1,
%% %% 		get_goods/2,
%% %% 		get_goods_by_type/3,
%% %% 		get_new_goods_by_type/2,
%% %% 		get_player_goods_from_db/1,
%% %%         get_goods_type/1,
%% %%         get_goods_by_id/1,
%% %%         get_goods_by_cell/3,
%% %%         get_goods_list/2,
%% %% 		get_type_goods_list/2,
%% %%         get_type_goods_list/4,
%% %%         get_type_goods_list/3,
%% %% 		get_type_goods_info/3,
%% %% 		get_good_gtid_list/2,
%% %% 		get_equip_list/2,
%% %%         get_equip_list/3,
%% %% %%         get_shop_list/2,
%% %% %%         get_shop_info/2,
%% %% 		get_add_attribute_by_type/1,
%% %%         count_role_equip_attribute/3,
%% %%         get_equip_attribute/1,
%% %% 		get_equip_singleatt/1,
%% %%         get_equip_suit/1,
%% %%         get_suit_num/2,
%% %%         change_equip_suit/3,
%% %%         get_stren_factor/1,
%% %%         get_stren_color_factor/1,
%% %%         get_goods_attribute_id/1,
%% %%         get_goods_use_num/1,
%% %%         get_goods_attrition/2,
%% %%         get_mend_cost/2,
%% %%         get_equip_cell/2,
%% %%         get_null_cell_num/3,
%% %%         get_null_cells/3,
%% %%         get_goods_exp/1,
%% %%         sort/2,
%% %%         is_enough_money/3,
%% %% 		is_enough_money_chk_db/3,
%% %% 		is_enough_gold_by_id/2,
%% %% %% 		is_enough_honor/3,
%% %%         get_cost/3,
%% %% 		add_money/3,
%% %% 		add_money_vip/2,
%% %%         get_price_type/1,
%% %%         has_attribute/1,
%% %%         can_equip/4,
%% %% 		can_equip_giant/2,
%% %% 		get_equip_cell_giant/2,
%% %%         get_goods_totalnum/1,
%% %%         get_consume_type/1,
%% %%         deeploop/3,
%% %%         list_handle/3,
%% %% 		get_make_position_goods/2,
%% %% 		get_goods_anti_attribute_info/2,
%% %% 		get_attribute_id_by_name/1,
%% %% 		get_attribute_name_by_id/1,
%% %% %% 		search_goods/1,
%% %% 		level_to_step/1,
%% %% 		parse_goods_other_data/1,
%% %% 		parse_goods_other_data/2,
%% %% 		get_goods_cd_list/1,
%% %% 		get_goods_other_data/1,
%% %% 		get_one_equip/2,
%% %% 		get_mount_info/1,
%% %% 		get_color_hex_value/1,
%% %% 		get_realm_to_name/1,
%% %% 		get_equip_fb/1,
%% %% 		is_full_suit/1,
%% %% 		delete_goods_attribute/3,
%% %% 		get_goods_hp_attribute_info/2,
%% %% 		get_equip_id_list/3,
%% %% 		get_holiday_goods/1,
%% %% 		get_fash_img/1,
%% %% 		get_normal_img/1,
%% %% 		get_equip_img/1,
%% %% 		get_fash_flag/1,
%% %% 		get_player_now_img/3,
%% %% 		chk_equip_suit/3,
%% %% 		get_add_goods/5,
%% %% 		check_table_base_goods_suit/0,
%% %% 		check_table_base_holiday_goods/0,
%% %% 		check_table_base_goods/0
%% %%     ]
%% %% ).
%% 
%% init_goods() ->
%%     %% 初始化物品类型列表
%% %%     ok = init_goods_type(),
%%     %% 初始化装备类型附加属性表
%% %%     ok = init_goods_add_attribute(),
%% %% 	%% 初始化装备套装基础表
%% %%     ok = init_goods_suit(),
%% %%     %% 初始化装备套装属性表
%% %%     ok = init_goods_suit_attribute(),
%% %%     %% 初始化装备强化规则表
%% %%     ok = init_goods_strengthen(),
%% %%     %% 初始化防具强化抗性规则表
%% %%     ok = init_goods_strengthen_anti(),
%% %%     %% 初始化装备强化额外信息表
%% %%     ok = init_goods_strengthen_extra(),
%% %%     %% 初始化法宝修炼规则表
%% %%     ok = init_goods_practise(),
%% %%     %% 初始化宝石合成规则表
%% %%     ok = init_goods_compose(),
%% %% 	%% 初始化装备分解规则表
%% %% 	ok = init_goods_idecompose(),
%% %% 	%% 初始化材料合成规则表
%% %% 	ok = init_goods_icompose(),
%% %% 	%% 天降彩石规则表
%% %% 	ok = init_goods_ore_rule(),
%% %%     %% 初始化物品掉落数量规则表
%% %%     ok = init_goods_drop_num(),
%%     %% 初始化物品掉落规则表
%% %%     ok = init_goods_drop_rule(),
%%     %% 初始化商店表
%% %%     ok = init_shop(),
%% 	
%%     ok.
%% 
%% init_goods_online(PlayerId, LLoginTime, NowTime) ->
%%     %% 初始化在线玩家背包物品表
%%     ok = init_goods(PlayerId),
%% %%     %% 初始化在线玩家物品属性表
%% %%     ok = init_goods_attribute(PlayerId),
%% 	%% 初始化在线玩家物品buff表
%%     ok.
%% 
%% %%当玩家下线时，删除ets物品表
%% goods_offline(PlayerId, _N) ->
%% %%     ets:match_delete(?ETS_GOODS_ONLINE, #goods{uid=PlayerId, _='_' }),
%% %%     ets:match_delete(?ETS_GOODS_ATTRIBUTE, #goods_attribute{uid=PlayerId, _='_' }),
%% %% 	ets:match_delete(?ETS_GOODS_BUFF, #goods_buff{uid = PlayerId, _='_'}),
%% %% 	ets:match_delete(?ETS_GOODS_CD,#ets_goods_cd{uid = PlayerId, _='_'}), 
%% %%     io:format("offline goods clear[~p]~n", [N]),
%%     ok.
%% 
%% %%删除goods_attribute中的数据
%% delete_goods_attribute(Player_Id,Gid,AttributeType) ->
%% %% 	ets:match_delete(?ETS_GOODS_ATTRIBUTE, #goods_attribute{uid=Player_Id,gtid=Gid, atype=AttributeType, _='_' }),
%% 	db_agent:del_goods_attribute(Player_Id,Gid,AttributeType).
%% 
%% %% 初始化物品类型列表
%% init_goods_type() ->
%% 	ets:delete_all_objects(?ETS_BASE_GOODS),
%%     F = fun(GoodsType) ->
%% 				GoodsInfo = list_to_tuple([ets_base_goods] ++ GoodsType),
%% 				NewGoodsInfo =
%% 					if
%% 						GoodsInfo#ets_base_goods.type =:= 10 ->
%% 							GoodsInfo#ets_base_goods{atbt = util:string_to_term(binary_to_list(GoodsInfo#ets_base_goods.atbt))};
%% 						true ->
%% 							GoodsInfo#ets_base_goods{atbt = []}
%% 					end,
%% %% 				io:format("~s ___________________________init_goods_type[~p]\n",[misc:time_format(now()), {GoodsInfo#ets_base_goods.other_data}]),
%%                   ets:insert(?ETS_BASE_GOODS, NewGoodsInfo)
%%            end,
%%     case db_agent:get_base_goods_info() of
%%         [] -> skip;
%%         GoodsTypeList when is_list(GoodsTypeList) ->
%%             lists:foreach(F, GoodsTypeList);
%%         _ -> skip
%%     end,
%%     ok.
%% 
%% %% %% 初始化装备类型附加属性表
%% %% init_goods_add_attribute() ->
%% %%      F = fun(Attribute) ->
%% %%                 AttributeInfo = list_to_tuple([ets_base_goods_add_attribute] ++ Attribute),
%% %%                 ets:insert(?ETS_BASE_GOODS_ADD_ATTRIBUTE, AttributeInfo)
%% %%          end,
%% %%     case db_agent:get_base_goods_add_attribute() of
%% %%         [] -> skip;
%% %%         AttributeList when is_list(AttributeList) ->
%% %%             lists:foreach(F, AttributeList);
%% %%         _ -> skip
%% %%     end,
%% %%     ok.
%% 
%% %% 初始化装备套装基础表
%% init_goods_suit() ->
%% 	ets:delete_all_objects(?ETS_BASE_GOODS_SUIT),
%% 	F = fun(BaseSuit) ->
%% 				BaseSuitInfo = list_to_tuple([ets_base_goods_suit] ++ BaseSuit),
%% 				NewBaseSuitInfo = BaseSuitInfo#ets_base_goods_suit{
%% 																   suit_goods = util:string_to_term(binary_to_list(BaseSuitInfo#ets_base_goods_suit.suit_goods)),
%% 																   suit_effect = util:string_to_term(binary_to_list(BaseSuitInfo#ets_base_goods_suit.suit_effect))
%% 																  },
%% 				ets:insert(?ETS_BASE_GOODS_SUIT,NewBaseSuitInfo)
%% 		end,
%% 	case db_agent:get_base_goods_suit() of
%% 		[] ->skip;
%% 		SuitList when is_list(SuitList) ->
%% 			lists:foreach(F, SuitList);
%% 		_ ->skip
%% 	end,
%% 	ok.
%% 
%% %% 初始化装备套装属性表
%% %% init_goods_suit_attribute() ->
%% %% 	F = fun(SuitAttribute) ->
%% %% 				SuitAttributeInfo = list_to_tuple([ets_base_goods_suit_attribute] ++ SuitAttribute),
%% %% 				ets:insert(?ETS_BASE_GOODS_SUIT_ATTRIBUTE,SuitAttributeInfo)
%% %% 		end,
%% %% 	case db_agent:get_base_goods_suit_attribute() of
%% %% 		[] ->skip;
%% %% 		SuitAttributeList when is_list(SuitAttributeList) ->
%% %% 			lists:foreach(F, SuitAttributeList);
%% %% 		_ ->skip
%% %% 	end,
%% %% 	ok.
%% 
%% %% %% 初始化物品掉落数量规则表
%% %% init_goods_drop_num() ->
%% %%      F = fun(GoodsDropNum) ->
%% %% 				GoodsDropNumInfo = list_to_tuple([ets_base_goods_drop_num] ++ GoodsDropNum),
%% %%                 ets:insert(?ETS_BASE_GOODS_DROP_NUM, GoodsDropNumInfo)
%% %%          end,
%% %%     case db_agent:get_base_goods_drop_num() of
%% %%         [] -> skip;
%% %%         GoodsDropNumList when is_list(GoodsDropNumList) ->
%% %%             lists:foreach(F, GoodsDropNumList);
%% %%         _ -> skip
%% %%     end,
%% %%     ok.
%% 
%% %% 初始化物品掉落规则表
%% %% init_goods_drop_rule() ->
%% %%  	F = fun(GoodsDropRule) ->
%% %% 		GoodsDropRuleInfo = list_to_tuple([ets_base_goods_drop_rule] ++ GoodsDropRule),
%% %%    		ets:insert(?ETS_BASE_GOODS_DROP_RULE, GoodsDropRuleInfo)
%% %%   	end,
%% %%     case db_agent:get_base_goods_drop_rule() of
%% %%         [] -> skip;
%% %%         GoodsDropRuleList when is_list(GoodsDropRuleList) ->
%% %%             lists:foreach(F, GoodsDropRuleList);
%% %%         _ -> skip
%% %%     end,
%% %%     ok.
%% 
%% %% 初始化商店表
%% %% init_shop() ->
%% %% 	ets:delete_all_objects(?ETS_BASE_SHOP),
%% %%      F = fun(Shop) ->
%% %% 				ShopInfo = list_to_tuple([ets_shop] ++ Shop),
%% %%                 ets:insert(?ETS_BASE_SHOP, ShopInfo)
%% %%          end,
%% %%     case db_agent:get_shop_info() of
%% %%         [] -> skip;
%% %%         ShopList when is_list(ShopList) ->
%% %%             lists:foreach(F, ShopList);
%% %%         _ -> skip
%% %%     end,
%% %%     ok.
%% 
%% 
%% 
%% %% 初始化在线玩家背包物品表
%% init_goods(PlayerId) ->
%% 	Now = util:unixtime(),
%% 	F = fun(Goods) ->
%% 				GoodsInfo = list_to_tuple([goods|Goods]),
%% 				if GoodsInfo#goods.eprt > Now orelse GoodsInfo#goods.eprt =:= 0 ->
%% 					   NewGoodsInfo =
%% 						   if
%% 							   GoodsInfo#goods.type =:= 10 ->
%% 								   GoodsInfo#goods{atbt = util:string_to_term(binary_to_list(GoodsInfo#goods.atbt)),
%% 												   othdt = util:string_to_term(binary_to_list(GoodsInfo#goods.othdt))};
%% 							   true ->
%% 								   GoodsInfo
%% 						   end,
%% 					   ets:insert(ets_goods_online, NewGoodsInfo);
%% 				   true ->
%% 					   db_agent:delete_goods(GoodsInfo#goods.id),
%% 					   spawn(fun()->lib_goods:send_goods_eprt_notice(PlayerId, GoodsInfo#goods.gtid) end),
%% 					   spawn(fun()->db_log_agent:log_goods_handle([PlayerId,
%% 																   GoodsInfo#goods.id,
%% 																   GoodsInfo#goods.gtid,
%% 																   GoodsInfo#goods.num,
%% 																   6])end)
%% 				end
%% 		end,
%% 	case db_agent:get_online_player_goods_by_id(PlayerId) of
%% 		[] -> 
%% 			%% 			io:format("~s __init_goods_type[~p]\n",[misc:time_format(now()), 1]),
%% 			skip;
%% 		GoodsList when is_list(GoodsList) ->
%% 			%% 			io:format("~s __init_goods_type[~p]\n",[misc:time_format(now()), 2]),
%% 			lists:foreach(F, GoodsList);
%% 		_ -> skip
%% 	end,
%% 	ok.
%% 
%% %% %% 初始化在线玩家物品属性表
%% %% init_goods_attribute(PlayerId) ->
%% %%     F = fun(Attribute) ->
%% %% 				AttributeInfo = list_to_tuple([goods_attribute] ++ Attribute),
%% %%                 ets:insert(?ETS_GOODS_ATTRIBUTE, AttributeInfo)
%% %%          end,
%% %%     case db_agent:get_online_player_goods_attribute_by_id(PlayerId) of
%% %%         [] -> skip;
%% %%         AttributeList when is_list(AttributeList) ->
%% %%             lists:foreach(F, AttributeList);
%% %%         _ -> skip
%% %%     end,
%% %%     ok.
%% 
%% 
%% 
%% %% 取物品类型信息
%% %% @spec get_ets_info(Tab, Id) -> record()
%% get_ets_info(Tab, Id) ->
%%     L = case is_integer(Id) of
%%             true -> ets:lookup(Tab, Id);
%%             false -> ets:match_object(Tab, Id)
%%         end,
%%     case L of
%%         [Info|_] -> Info;
%%         _ -> {}
%%     end.
%% 
%% get_ets_list(Tab, Pattern) ->
%%     ets:match_object(Tab, Pattern).
%% 	%%io:format("~s get_ets_list[~p]\n",[misc:time_format(now()), L]),
%% %%     case is_list(L) of
%% %%         true -> L;
%% %%         false -> []
%% %%     end.
%% 
%% %%根据物品ID查询基础物品
%% get_base_goods(GoodsTypeId) ->
%% 	case ets:lookup(?ETS_BASE_GOODS, GoodsTypeId) of
%% 		[] ->
%% 			[];
%% 		[BaseGoods|_] ->
%% 			BaseGoods
%% 	end.
%% 	
%% 
%% %% 取物品名称
%% %% @spec get_goods_name(GoodsTypeId) -> string
%% get_goods_name(GoodsTypeId) ->
%%     GoodsTypeInfo = get_ets_info(?ETS_BASE_GOODS, GoodsTypeId),
%%     case is_record(GoodsTypeInfo, ets_base_goods) of
%%         true -> GoodsTypeInfo#ets_base_goods.name;
%%         false -> <<>>
%%     end.
%% 
%% get_goods_sell(GoodsTypeId) ->
%%     GoodsTypeInfo = get_ets_info(?ETS_BASE_GOODS, GoodsTypeId),
%%     case is_record(GoodsTypeInfo, ets_base_goods) of
%%         true -> [GoodsTypeInfo#ets_base_goods.ptp, GoodsTypeInfo#ets_base_goods.spri];
%%         false -> [0, 0]
%%     end.
%% 
%% %% 取任务怪ID
%% %% @spec get_task_mon(GoodsTypeId) -> mon_id | 0
%% %% get_task_mon(GoodsTypeId) ->
%% %%     Pattern = #ets_base_goods_drop_rule{ goods_id=GoodsTypeId, _='_' },
%% %%     RuleInfo = get_ets_info(?ETS_BASE_GOODS_DROP_RULE, Pattern),
%% %%     case is_record(RuleInfo, ets_base_goods_drop_rule) of
%% %%         true -> RuleInfo#ets_base_goods_drop_rule.mon_id;
%% %%         false -> 0
%% %%     end.
%% 
%% 
%% 
%% %%kexp_2011.7.27
%% %%由基础数据转换成goods数据
%% %% get_new_goods(GoodsTypeInfo) ->
%% %% 	get_new_goods(GoodsTypeInfo, 0).
%% 
%% get_new_goods(GoodsTypeInfo) ->
%% 	case GoodsTypeInfo#ets_base_goods.type of
%% 		28 ->
%% 			Now = util:unixtime(),
%% 			OtherData = GoodsTypeInfo#ets_base_goods.other_data,  %%宠物蛋BUFF数据
%% 			Ovalue = goods_util:parse_goods_other_data(OtherData, buff),
%% 			
%% 			case Ovalue of
%% 				[buff, pet_egg, _Data, LastTime] ->					
%% 					ExpireTime = Now + LastTime * 60;     %%创建时间
%% 				_ ->
%% 					ExpireTime =  GoodsTypeInfo#ets_base_goods.eprt
%% 			end;
%% 		_ ->
%% 			if GoodsTypeInfo#ets_base_goods.eprt > 0 ->
%% 				   ExpireTime = GoodsTypeInfo#ets_base_goods.eprt + util:unixtime();
%% 			   true ->
%% 				   ExpireTime = 0
%% 			end
%% 	end,
%% 	
%% 	TmpGoods = #goods{
%% 					  gtid = GoodsTypeInfo#ets_base_goods.gtid,
%% 					  type = GoodsTypeInfo#ets_base_goods.type,
%% 					  stype = GoodsTypeInfo#ets_base_goods.stype,
%% 					  qly = GoodsTypeInfo#ets_base_goods.qly,
%% 					  drp = GoodsTypeInfo#ets_base_goods.drp,
%% 					  ptp = GoodsTypeInfo#ets_base_goods.ptp,
%% 					  gpri = GoodsTypeInfo#ets_base_goods.gpri,
%% 					  spri = GoodsTypeInfo#ets_base_goods.spri,
%% 					  
%% 					  lv = GoodsTypeInfo#ets_base_goods.lv,
%% 					  crr = GoodsTypeInfo#ets_base_goods.crr,
%% 					  
%% 					  stid = GoodsTypeInfo#ets_base_goods.stid,
%% 					  atbt = GoodsTypeInfo#ets_base_goods.atbt,
%% 					  img = GoodsTypeInfo#ets_base_goods.img,
%% 					  %%stlv = GoodsTypeInfo#ets_base_goods.stlv,
%% 					  
%% %% 					  othdt = GoodsTypeInfo#ets_base_goods.other_data,  %%取消看有没有错
%% 					  
%% 					  %%         bind = GoodsTypeInfo#ets_base_goods.bind,
%% 					  %%         tlv = GoodsTypeInfo#ets_base_goods.tlv,
%% 					  %% 		tval = GoodsTypeInfo#ets_base_goods.tval,
%% 					  %%         fct = GoodsTypeInfo#ets_base_goods.fct,
%% 					  %% 暂时不使用
%% 					  %%spec = GoodsTypeInfo#ets_base_goods.spec,
%% 					  %%ustm = get_goods_use_num(GoodsTypeInfo#ets_base_goods.attrition),
%% 					  eprt = ExpireTime
%% 					 },
%% 	Qly = case get(equip_qly) of
%% 			  Res when is_integer(Res) ->
%% 				  Res;
%% 			  _ ->
%% 				  0
%% 		  end,
%% 	chk_new_equit_goods(TmpGoods, Qly).
%% %% 	chk_new_equit_goods_qly(TmpGoods1, Qly).
%% 
%% %% %%由基础数据生成新装备（新版）
%% %% get_new_equit(TargetEquitTypeInfo) ->
%% %% 	GoodsInfo = get_new_goods(TargetEquitTypeInfo),
%% %% 	chk_new_equit_goods(NewGoods)
%% %% 	if 
%% %% 		GoodsTypeInfo#ets_base_goods.type =:= 10 andalso BArena =:= true ->  %%竞技套装
%% %% 			EquipQly = 2,
%% %% 			OtherData = [{1,0,0}],
%% %% 			Ovalue = goods_util:parse_goods_other_data(OtherData),
%% %% 			GoodsInfo = GoodsInfoT#goods{othdt = Ovalue, qly = EquipQly};
%% %% 		GoodsTypeInfo#ets_base_goods.type =:= 10 andalso GoodsTypeInfo#ets_base_goods.stype =/= 20 ->                          %%装备(不包含时装)
%% %% 			EquipQly = data_stren:rand_equip_qly(),
%% %% 			OtherData = [{1,0,0}],
%% %% 			Ovalue = goods_util:parse_goods_other_data(OtherData),
%% %% 			%% 	StrenAttList = data_stren:get_stren_info(GoodsInfo#goods.gtid, GoodsInfo#goods.stype, GoodsInfo#goods.lv, TargetLv),
%% %% 			%%io:format("~s ____________get_new_equit__________[~p]\n",[misc:time_format(now()), TargetLv]),
%% %% 			GoodsInfo = GoodsInfoT#goods{othdt = Ovalue, qly = EquipQly};
%% %% 		true ->
%% %% 	EquipQly = data_stren:rand_equip_qly(),
%% %% 	OtherData = TargetEquitTypeInfo#ets_base_goods.other_data,
%% %% 	Ovalue = goods_util:parse_goods_other_data(OtherData),
%% %% 	%% 	StrenAttList = data_stren:get_stren_info(GoodsInfo#goods.gtid, GoodsInfo#goods.stype, GoodsInfo#goods.lv, TargetLv),
%% %% 	%%io:format("~s ____________get_new_equit__________[~p]\n",[misc:time_format(now()), TargetLv]),
%% %% 	GoodsInfo#goods{othdt = Ovalue, qly = EquipQly}.
%% 
%% %%对新物品生成进行装备类物品的检测
%% chk_new_equit_goods(NewGoods, Qly) ->
%% 	BArena = lists:member(NewGoods#goods.stid, data_stren:get_arena_stid()),
%% %% 	io:format("~s ____________get_new_equit__________[~p]\n",[misc:time_format(now()), BArena]),
%% 	if 
%% 		NewGoods#goods.type =:= 10 andalso BArena =:= true ->  %%竞技套装
%% 			EquipQly = 
%% 				if Qly > 0 -> Qly;
%% 				   true -> 2
%% 				end,
%% 			OtherData = [{1,0,0}],
%% %% 			Ovalue = goods_util:parse_goods_other_data(OtherData),
%% 			NewGoods#goods{othdt = OtherData, qly = EquipQly};
%% 		NewGoods#goods.type =:= 10 andalso NewGoods#goods.stid =:= 8001 ->  %%皇邪套装
%% 			EquipQly = 
%% 				if Qly > 0 -> Qly;
%% 				   true -> 4
%% 				end,
%% 			OtherData = [{1,0,0}],
%% %% 			Ovalue = goods_util:parse_goods_other_data(OtherData),
%% 			NewGoods#goods{othdt = OtherData, qly = EquipQly};
%% 		NewGoods#goods.type =:= 10 andalso NewGoods#goods.stype =/= 20 ->   %%装备(不包含时装)
%% 			EquipQly = 
%% 				if Qly > 0 -> Qly;
%% 				   true -> data_stren:rand_equip_qly()
%% 				end,
%% 			OtherData = [{1,0,0}],
%% %% 			Ovalue = goods_util:parse_goods_other_data(OtherData),
%% 			NewGoods#goods{othdt = OtherData, qly = EquipQly};
%% 		true ->
%% 			NewGoods
%% 	end.
%% 
%% %% %%新装备生成品质
%% %% chk_new_equit_goods_qly(NewGoods, Qly) ->
%% %% 	if Qly > 0 andalso NewGoods#goods.type  ->
%% %% 		   NewGoods#goods{qly = Qly};
%% %% 	   true ->
%% %% 		   NewGoods
%% %% 	end.
%% 	   
%% 
%% 
%% 
%% %% %%由基础数据生成指定等级装备（旧版）
%% %% get_new_equit(TargetEquitTypeInfo, TargetLv) ->
%% %% %%io:format("~s ____________get_new_equit__________[~p]\n",[misc:time_format(now()), TargetEquitTypeInfo]),
%% %% 	GoodsInfo = get_new_goods(TargetEquitTypeInfo),
%% %% 	StrenAttList = data_stren:get_stren_info(GoodsInfo#goods.gtid, GoodsInfo#goods.stype, GoodsInfo#goods.lv, TargetLv),
%% %% %%io:format("~s ____________get_new_equit__________[~p]\n",[misc:time_format(now()), TargetLv]),
%% %% 	GoodsInfo#goods{atbt = StrenAttList, stlv = TargetLv}.
%% 
%% %% kexp
%% %%由基础附加属性规则生成附加属性
%% get_new_goods_add_attribute(Base_goods_add_attribute) ->
%% 	%%[Hp,Mp,Forza,Agile,Wit,Physique,Crit,Dodge,Anti_wind,Anti_fire,Anti_water,Anti_thunder,Anti_soil] =
%% 	%%get_add_attribute_by_type(Base_goods_add_attribute),
%% 	#goods_attribute{
%% 		atype = 1,		
%% 		atid = Base_goods_add_attribute#ets_base_goods_add_attribute.id,
%% 		mxhp = Base_goods_add_attribute#ets_base_goods_add_attribute.mxhp,
%% 		pwr = Base_goods_add_attribute#ets_base_goods_add_attribute.pwr,
%% 		tech = Base_goods_add_attribute#ets_base_goods_add_attribute.tech,
%% 		mgc = Base_goods_add_attribute#ets_base_goods_add_attribute.mgc,
%% 		hit = Base_goods_add_attribute#ets_base_goods_add_attribute.hit,
%% 		crit = Base_goods_add_attribute#ets_base_goods_add_attribute.crit,
%% 		ddge = Base_goods_add_attribute#ets_base_goods_add_attribute.ddge,
%% 		blck = Base_goods_add_attribute#ets_base_goods_add_attribute.blck,
%% 		mnup = Base_goods_add_attribute#ets_base_goods_add_attribute.mnup,
%% 		agup = Base_goods_add_attribute#ets_base_goods_add_attribute.agup,
%% 		dpwr = Base_goods_add_attribute#ets_base_goods_add_attribute.dpwr,
%% 		dtech  = Base_goods_add_attribute#ets_base_goods_add_attribute.dtech,
%% 		dmgc = Base_goods_add_attribute#ets_base_goods_add_attribute.dmgc,
%% 		apwr = Base_goods_add_attribute#ets_base_goods_add_attribute.apwr,
%% 		atech = Base_goods_add_attribute#ets_base_goods_add_attribute.atech,
%% 		amgc = Base_goods_add_attribute#ets_base_goods_add_attribute.amgc		 
%% 	}.
%% 	
%% %% %% 取当前装备的武器、衣服,坐骑不能从装备信息取
%% %% get_current_equip(GoodsStatus) ->
%% %%     EquipList = goods_util:get_equip_list(GoodsStatus#goods_status.uid, 10, 1),
%% %%     [NewStatus, _] = get_current_equip_by_list(EquipList, [GoodsStatus, on]),
%% %%     NewStatus.
%% %% 
%% %% get_current_equip_by_list(GoodsList, [GoodsStatus, Type]) ->
%% %%     lists:foldl(fun get_current_equip_by_info/2, [GoodsStatus, Type], GoodsList).
%% %% 
%% %% %%ps 此函数注意，似乎没有需要，迟点整理后删除。
%% %% get_current_equip_by_info(GoodsInfo, [GoodsStatus, Type]) ->
%% %%     [Wq, Yf, Zq] = GoodsStatus#goods_status.equip_current,
%% %%     case is_record(GoodsInfo, goods) of
%% %%         true when GoodsInfo#goods.type =:= 10 andalso GoodsInfo#goods.stype < 14 ->
%% %%             CurrentEquip = case Type of
%% %%                                 on -> [GoodsInfo#goods.gtid, Yf, Zq];
%% %%                                 off -> [0, Yf, Zq]
%% %%                            end;
%% %%         true when GoodsInfo#goods.type =:= 10 andalso GoodsInfo#goods.stype =:= 24 ->
%% %%             CurrentEquip = case Type of
%% %%                                 on -> [Wq, GoodsInfo#goods.gtid, Zq];
%% %%                                 off -> [Wq, 0, Zq]
%% %%                            end;
%% %%         _ ->
%% %%             CurrentEquip = [Wq, Yf, Zq]
%% %%     end,
%% %%     NewGoodsStatus = GoodsStatus#goods_status{ equip_current=CurrentEquip },
%% %%     [NewGoodsStatus, Type].
%% 
%% 			
%% %% %%返回类型列表
%% %% get_goods(GoodsTypeId, PlayerId) ->
%% %% 	Pattern = #goods{gtid = GoodsTypeId, uid = PlayerId, _='_'},
%% %% 	GoodsInfoList = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %% 	[M || M <- GoodsInfoList, M#goods.loc =/= 10]. %%排除在回购列表中的物品..
%% %% 
%% %% %%根据类型、子类型获取物品列表
%% %% get_goods_by_type(Uid, Type, SType) ->
%% %% 	Pattern = #goods{type = Type, stype = SType, uid = Uid, _='_'},
%% %% 	get_ets_list(?ETS_GOODS_ONLINE, Pattern).
%% %% 	
%% %% 
%% %% %%根据物品类型ID获取最新生成都物品信息
%% %% get_new_goods_by_type(Goods_Id,PlayerId) ->
%% %% 	GoodsList = get_goods(Goods_Id, PlayerId),
%% %% 		if							
%% %% 			length(GoodsList) > 1 ->
%% %% 				lists:max(GoodsList);
%% %% 			length(GoodsList) == 1 ->
%% %% 				lists:nth(1, GoodsList);
%% %% 			true ->
%% %% 				#goods{}
%% %% 		end.
%% %% 
%% %% %%获取玩家数据库物品信息
%% %% %% 初始化在线玩家背包物品表
%% %% get_player_goods_from_db(PlayerId) ->
%% %%      F = fun(Goods) ->
%% %% 				list_to_tuple([goods] ++ Goods)
%% %%          end,
%% %%     case db_agent:get_online_player_goods_by_id(PlayerId) of
%% %%         [] -> [];
%% %%         GoodsList when is_list(GoodsList) ->
%% %%             lists:map(F, GoodsList);
%% %%         _ -> []
%% %%     end.
%% %% 
%% %% 			
%% %% %%取goods base信息
%% %% get_goods_type(GoodsTypeId) ->
%% %%     get_ets_info(?ETS_BASE_GOODS, GoodsTypeId).
%% %% 
%% %% %% 取新加入的装备
%% %% get_add_goods(PlayerId, GoodsTypeId, Location, Cell, Num) ->
%% %%     Goods = (catch db_agent:get_add_goods(PlayerId, GoodsTypeId, Location, Cell, Num)),
%% %% 	GoodsInfo = list_to_tuple([goods] ++ Goods),
%% %% 	if
%% %% 		GoodsInfo#goods.type =:= 10 ->
%% %% 			GoodsInfo#goods{atbt = util:string_to_term(binary_to_list(GoodsInfo#goods.atbt)),
%% %% 							othdt = util:string_to_term(binary_to_list(GoodsInfo#goods.othdt))};
%% %% 		true ->
%% %% 			GoodsInfo
%% %% 	end.
%% %% 
%% %% %% @spec get_goods_by_id(GoodsId) -> record()
%% %% get_goods_by_id(GoodsId) ->
%% %%     Goods = (catch db_agent:get_goods_by_id(GoodsId)),
%% %% 	GoodsInfo = list_to_tuple([goods] ++ Goods),
%% %% 	if
%% %% 		GoodsInfo#goods.type =:= 10 andalso GoodsInfo#goods.stype =/= 9->
%% %% 			GoodsInfo#goods{atbt = util:string_to_term(binary_to_list(GoodsInfo#goods.atbt)),
%% %% 							othdt = util:string_to_term(binary_to_list(GoodsInfo#goods.othdt))};
%% %% 		true ->
%% %% 			GoodsInfo
%% %% 	end.
%% %% 
%% %% get_goods_by_cell(PlayerId, Location, Cell) ->
%% %%     Pattern = #goods{ uid=PlayerId, loc=Location, cell=Cell, _='_' },
%% %%     get_ets_info(?ETS_GOODS_ONLINE, Pattern).
%% %% 
%% %% %% 取物品列表
%% %% get_goods_list(PlayerId, all) ->
%% %% 	Pattern = #goods{ uid=PlayerId, _='_' },
%% %%     get_ets_list(?ETS_GOODS_ONLINE, Pattern);
%% %% get_goods_list(PlayerId, Location) ->
%% %% 	%%io:format("get_goods_list: ~p~n",[[50000, PlayerId, Location]]),
%% %%    	Pattern = #goods{ uid=PlayerId, loc=Location, _='_' },
%% %%     get_ets_list(?ETS_GOODS_ONLINE, Pattern).
%% %% 
%% %% %% 获取同类物品列表
%% %% get_type_goods_list(PlayerId, GoodsTypeId, _Bind, Location) ->
%% %% %%    	Pattern = #goods{ uid=PlayerId, gtid=GoodsTypeId, bind=Bind, loc=Location, _='_' },
%% %% 	Pattern = #goods{ uid=PlayerId, gtid=GoodsTypeId, loc=Location, _='_' },
%% %%     get_ets_list(?ETS_GOODS_ONLINE, Pattern).
%% %% 
%% %% get_type_goods_list(PlayerId, GoodsTypeId, Location) ->
%% %%     Pattern = #goods{ uid=PlayerId, gtid=GoodsTypeId, loc=Location, _='_' },
%% %%     get_ets_list(?ETS_GOODS_ONLINE, Pattern).
%% %% 
%% %% get_type_goods_list(PlayerId, GoodsTypeId) ->
%% %%     Pattern = #goods{ uid=PlayerId, gtid=GoodsTypeId, _='_' },
%% %%     GoodsList = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %% 	[M || M <- GoodsList, M#goods.loc =/= 10]. %%排除在回购列表中的物品.
%% %% 
%% %% %% 获取同类物品的一个
%% %% get_type_goods_info(PlayerId,GoodsTypeId,Location)->
%% %% 	TypInfoList = get_type_goods_list(PlayerId, GoodsTypeId, Location),
%% %% 	case length(TypInfoList) > 0 of
%% %% 		true ->
%% %% 			hd(TypInfoList);
%% %% 		false ->
%% %% 			TypInfoList
%% %% 	end.
%% %% 
%% %% %% 取物品类型gtid
%% %% get_good_gtid_list(PlayerId, Type) ->
%% %% 	Pattern = #goods{uid=PlayerId, type=Type, _='_' },
%% %%     List = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %% 	[Goods#goods.gtid || Goods <- List].
%% %% 
%% %% %% 取装备列表
%% %% get_equip_list(PlayerId, Type) ->
%% %%     Pattern = #goods{uid=PlayerId, type=Type, _='_' },
%% %%     List = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %% 	List.
%% %% 
%% %% %% 取装备列表
%% %% get_equip_list(PlayerId, Type, Location) ->
%% %%     Pattern = #goods{uid=PlayerId, type=Type, loc=Location, _='_' },
%% %%     List = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %% 	List.
%% %% 
%% %% %% 取装备列表id
%% %% get_equip_id_list(PlayerId, Type, Location) ->
%% %% 	Pattern = #goods{uid=PlayerId, type=Type, loc=Location, _='_' },
%% %%     List = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %% 	[Goods#goods.gtid || Goods <- List].
%% %% 
%% %% %% 获取节日新增物品, Type匹配类型
%% %% get_holiday_goods(Type) ->
%% %% 	BaseList = ets:tab2list(?ETS_BASE_HOLIDAY_GOODS),		%%先找出所有基础列表数据
%% %% 	if is_list(BaseList) andalso BaseList =/= [] ->
%% %% 		   %%根据Type、当前时间找到匹配的数据
%% %% 		   Now = util:unixtime(),
%% %% 		   HolidayGoods = [H||H <- BaseList, H#ets_base_holiday_goods.type =:= Type,  H#ets_base_holiday_goods.btime =< Now, H#ets_base_holiday_goods.etime >= Now],
%% %% 		   if
%% %% 			   HolidayGoods =:= [] ->
%% %% 				   [];
%% %% 			   true ->
%% %% 				   [H|_] = HolidayGoods,
%% %% 				   GoodsList = H#ets_base_holiday_goods.goods,				%%找到对应的配置物品列表
%% %% 				   Fun = fun(GoodsM) ->
%% %% 								 {GoodsId, GoodsR, MinNum, MaxNum} = GoodsM,
%% %% 								 GoodsRNow = GoodsR,     					%%获得概率
%% %% 								 RatioGet = util:rand(1, 10000),
%% %% 								 if RatioGet =< GoodsRNow ->				%%可获得
%% %% 										RatioNum = util:rand(1, 10000),		%%再随机数量
%% %% 										GoodsNum = MinNum + util:ceil((RatioNum * (MaxNum - MinNum + 1)) / 10000) - 1,
%% %% 										{GoodsId, GoodsNum};
%% %% 									true ->
%% %% 										0									%%无获得
%% %% 								 end
%% %% 						 end,
%% %% 				   Goods = lists:map(Fun, GoodsList),						%%随机取奖励物品, 根据概率算, 可能会有多种
%% %% 				   NewGoodsT = lists:filter(fun(GoodsM1) -> GoodsM1 =/= 0 end, Goods),		%%过滤0无获得
%% %% 				   NewGoodsT
%% %% 		   end;
%% %% 	   true ->
%% %% 		   []
%% %% 	end.
%% %% 
%% %% %% 取商店物品列表
%% %% %% get_shop_list(ShopType, ShopSubtype) ->
%% %% %%     case ShopSubtype > 0 of
%% %% %%         true ->  Pattern = #ets_shop{ shop_type=ShopType, shop_subtype=ShopSubtype, _='_' };
%% %% %%         false -> Pattern = #ets_shop{ shop_type=ShopType, _='_' }
%% %% %%     end,
%% %% %%     get_ets_list(?ETS_BASE_SHOP, Pattern).
%% %% 
%% %% %% 取商店物品信息
%% %% %% get_shop_info(ShopType, GoodsTypeId) ->
%% %% %%     Pattern = #ets_shop{ shop_type=ShopType, goods_id=GoodsTypeId, _='_' },
%% %% %%     get_ets_info(?ETS_BASE_SHOP, Pattern).
%% %% 
%% %% %% %% 取新加入的装备属性
%% %% %% get_add_goods_attribute(PlayerId, GoodsId, AttributeType, AttributeId) ->
%% %% %%     Attribute = (catch db_agent:get_add_goods_attribute(PlayerId, GoodsId, AttributeType, AttributeId)),
%% %% %% 	AttributeInfo = list_to_tuple([goods_attribute] ++ Attribute),
%% %% %% 	AttributeInfo.
%% %% 
%% %% %% %% 取装备属性信息
%% %% %% get_goods_attribute_info(PlayerId, GoodsId, AttributeType) ->
%% %% %%     Pattern = #goods_attribute{ uid=PlayerId, gid=GoodsId, atype=AttributeType, _='_'},
%% %% %%     get_ets_info(?ETS_GOODS_ATTRIBUTE, Pattern).
%% %% %% 
%% %% %% get_goods_attribute_info(PlayerId,GoodsId,AttributeType,AttributeId) ->
%% %% %% 	Pattern = #goods_attribute{uid = PlayerId,gid = GoodsId,atid = AttributeId,atype=AttributeType,_='_'},
%% %% %% 	get_ets_info(?ETS_GOODS_ATTRIBUTE,Pattern).
%% %% %% 
%% %% %% %%取装备属性列表
%% %% %% get_goods_attribute_list(PlayerId, GoodsId, AttributeType) ->
%% %% %%     Pattern = #goods_attribute{ uid=PlayerId, gid=GoodsId, atype=AttributeType, _='_'},
%% %% %%     get_ets_list(?ETS_GOODS_ATTRIBUTE, Pattern).
%% %% 
%% %% %% get_goods_attribute_list(PlayerId, GoodsId) ->
%% %% %%     Pattern = #goods_attribute{ uid=PlayerId, gid=GoodsId, _='_'},
%% %% %%     get_ets_list(?ETS_GOODS_ATTRIBUTE, Pattern).
%% %% %% 
%% %% %% get_offline_goods_attribute_list(PlayerId,GoodsId,AttributeType)->
%% %% %% 	db_agent:gu_get_offline_goods_attribute_list(goods_attribute,PlayerId,GoodsId,AttributeType).
%% %% %% 																								
%% %% %% get_offline_goods_attribute_list(PlayerId, GoodsId) ->
%% %% %%     db_agent:gu_get_offline_goods_attribute_list(goods_attribute, PlayerId, GoodsId).
%% %% 
%% %% 
%% %% %%关键函数！！%%人物装备属性重新计算
%% %% count_role_equip_attribute(PlayerStatus, GoodsStatus, _GoodsInfo) ->
%% %% 	%% 装备属性
%% %% 	Effect = get_equip_attribute(PlayerStatus#player.id),
%% %% 	
%% %% 	%% 更新人物属性
%% %% 	PlayerStatus1 = PlayerStatus#player{
%% %% 										other = PlayerStatus#player.other#player_other{
%% %% 																					   equip_attribute = Effect
%% %% 																					  }
%% %% 									   },
%% %% 	{ok, PlayerStatus1, GoodsStatus}.
%% %% 
%% %% %% 取装备的属性加成
%% %% %% 获取所有装备的属性加成
%% %% get_equip_attribute(PlayerId) ->
%% %% 	EquipList = get_equip_list(PlayerId, 10, 1),
%% %% 	F = fun(GoodsInfo, EquipSuit) ->
%% %% 				change_equip_suit(EquipSuit, 0, GoodsInfo#goods.stid)
%% %% 		end,
%% %% 	EquipSuit = lists:foldl(F, [], EquipList),
%% %% %% 	io:format("~s count_player_attribute__1_1[~p] ~n",[misc:time_format(now()),[EquipList, EquipSuit]]),
%% %% 	EquipAtList = lists:foldl(
%% %% 					fun(X, Acc0) ->
%% %% 							CytAttList =
%% %% 								if
%% %% 									X#goods.othdt =:= <<>> orelse X#goods.othdt =:= undefined ->
%% %% 										[];
%% %% 									true ->
%% %% 										[data_giant_s:chk_atr_num1(data_crystal:get_cyt_att(CytTypeId))||{_HoleNum, CytTypeId, _CytType}<-X#goods.othdt, CytTypeId =/= 0]
%% %% 								end,
%% %% %% 							CytAttList1 = data_giant_s:get_field_num_list(CytAttList),
%% %% %% 							io:format("~s count_player_attribute__1_2[~p] ~n",[misc:time_format(now()),CytAttList, CytAttList1]]),
%% %% 							{_DisList, AtbtList} = get_equip_singleatt(X),
%% %% 							lists:merge3(CytAttList, AtbtList, Acc0)
%% %% 					end, 
%% %% 					[], 
%% %% 					EquipList
%% %% 							 ),
%% %% 	SuitAtbtList = get_suit_attribute(EquipSuit),   %%计算套装属性
%% %% %% 	io:format("~s count_player_attribute__1_2[~p] ~n",[misc:time_format(now()),[EquipAtList, SuitAtbtList]]),
%% %% 	lists:merge(SuitAtbtList, EquipAtList).
%% %% 
%% %% %%获取单件装备自有属性
%% %% get_equip_singleatt(Equip) ->
%% %% 	if
%% %% 		Equip#goods.stype >= 20 ->     %%非强化类装备
%% %% 			GoogsTypeInfo = get_goods_type(Equip#goods.gtid),
%% %% 			{GoogsTypeInfo#ets_base_goods.atbt, data_giant_s:get_field_num_list(GoogsTypeInfo#ets_base_goods.atbt)};      %%基础表是按属性ID配置的,并从基础表获得属性
%% %% 		Equip#goods.stype > 0 ->
%% %% 			data_stren:get_stren_info(Equip#goods.gtid, Equip#goods.type, Equip#goods.qly, Equip#goods.stid, Equip#goods.stlv);  %%实时计算强化类装备属性
%% %% 		true ->
%% %% 			{[], []}
%% %% 	end.
%% %% 
%% %% %%     %% 装备套装属性加成
%% %% %%     [_Hp_lim2, _Mp_lim2,Max_attack2,Min_attack2,Def2, Hit2,Dodge2, Crit2, _Forza2,_Physique2,_Agile2,_Wit2,Anti_wind2,Anti_fire2,Anti_water2,Anti_thunder2,Anti_soil2] = get_suit_attribute(EquipSuit),
%% %% %%     [Hp, Mp ,MaxAtt+Max_attack2, MinAtt+Min_attack2, Def+Def2, Hit+Hit2, Dodge+Dodge2, Crit+Crit2, Anti_wind + Anti_wind2,Anti_fire + Anti_fire2, Anti_water + Anti_water2 ,Anti_thunder + Anti_thunder2 ,Anti_soil + Anti_soil2].
%% %% 
%% %% %%辅助
%% %% count_goods_attribute_effect(AttributeInfo, [Mxhp, Pwr, Tech, Mgc, Hit, Crit, Ddge, Blck, Cter, Mnup, Agup, Dpwr, Dtech, Dmgc, Apwr, Atech, Amgc]) ->
%% %% 	[Mxhp + AttributeInfo#goods_attribute.mxhp,
%% %% 	 Pwr + AttributeInfo#goods_attribute.pwr,
%% %% 	 Tech + AttributeInfo#goods_attribute.tech,
%% %% 	 Mgc + AttributeInfo#goods_attribute.mgc,
%% %%      Hit + AttributeInfo#goods_attribute.hit,
%% %%      Crit + AttributeInfo#goods_attribute.crit,
%% %%      Ddge + AttributeInfo#goods_attribute.ddge,
%% %%      Crit + AttributeInfo#goods_attribute.crit,
%% %%      Blck + AttributeInfo#goods_attribute.blck,
%% %% 	 Cter + AttributeInfo#goods_attribute.cter,
%% %% 	 Mnup + AttributeInfo#goods_attribute.mnup,
%% %% 	 Agup + AttributeInfo#goods_attribute.agup,
%% %% 	 Dpwr + AttributeInfo#goods_attribute.dpwr,
%% %% 	 Dtech + AttributeInfo#goods_attribute.dtech,
%% %% 	 Dmgc + AttributeInfo#goods_attribute.dmgc,
%% %% 	 Apwr + AttributeInfo#goods_attribute.apwr,
%% %% 	 Atech + AttributeInfo#goods_attribute.atech,
%% %% 	 Amgc + AttributeInfo#goods_attribute.amgc
%% %% 	].
%% %% 
%% %% %%获取套装信息[{suit_id,suit_num}]
%% %% %%根据玩家ID，物品类型和位置查找所有相应的装备列表
%% %% %%   从装备列表中找出对应装备ID的装备
%% %% %
%% %% get_equip_suit(PlayerId) ->
%% %%     EquipList = goods_util:get_equip_list(PlayerId, 10, 1),
%% %%     F = fun(GoodsInfo, EquipSuit) ->
%% %%             change_equip_suit(EquipSuit, 0, GoodsInfo#goods.stid)
%% %%         end,
%% %%     EquipSuit = lists:foldl(F, [], EquipList),
%% %%     EquipSuit.
%% %% 
%% %% %%套装属性(新版)
%% %% get_suit_attribute(EquipSuit) ->
%% %% 	F = fun({SuitId,SuitNum},List) ->
%% %% 				if
%% %% 					SuitNum >= 2 ->
%% %% 						Pattern = #ets_base_goods_suit{suit_id=SuitId, _='_'},
%% %% 						SuitInfo = get_ets_info(?ETS_BASE_GOODS_SUIT, Pattern),
%% %% 						SuitAllAtrList = SuitInfo#ets_base_goods_suit.suit_effect,    %%数据结构[[{AtrId, AtrNum},..],..]
%% %% 						if
%% %% 							SuitNum >= 6 ->     %%套装最多6件
%% %% 								SuitAtrList = lists:flatten(SuitAllAtrList);
%% %% 							SuitNum >= 4 ->
%% %% 								SuitAtrList = lists:flatten(lists:sublist(SuitAllAtrList, 2));
%% %% 							SuitNum >= 2 ->
%% %% 								SuitAtrList = lists:flatten(lists:sublist(SuitAllAtrList, 1));
%% %% 							true ->
%% %% 								SuitAtrList = []
%% %% 						end,
%% %% 						data_giant_s:get_field_num_list(SuitAtrList) ++ List;
%% %% 					true ->
%% %% 						List
%% %% 				end         
%% %% 		end,
%% %% 	lists:foldl(F, [], EquipSuit).
%% %% 
%% %% %% %%套装属性
%% %% %% %%[Hp_lim, Mp_lim, Max_attack,Min_attack,Def, Hit,Dodge, Crit, Forza,Physique,Agile,Wit,Anti_wind,Anti_fire,Anti_water,Anti_thunder,Anti_soil]
%% %% %% get_suit_attribute(EquipSuit) ->
%% %% %% 	%%?DEBUG("########equip_suit:~p",[EquipSuit]),
%% %% %% 	F = fun({SuitId,SuitNum},List) ->
%% %% %% 			if
%% %% %% 				SuitNum >= 2 ->
%% %% %% 					Pattern = #ets_base_goods_suit_attribute{ suit_id=SuitId, _='_'},
%% %% %%     				SuitAttributeInfo = get_ets_info(?ETS_BASE_GOODS_SUIT_ATTRIBUTE, Pattern),
%% %% %% 					SuitNumAttributeInfo = get_suit_num_attribute({SuitId,SuitNum},SuitAttributeInfo),
%% %% %% 					if
%% %% %% 						is_record(SuitNumAttributeInfo,ets_base_goods_suit_attribute) ->
%% %% %% 							[SuitNumAttributeInfo|List];
%% %% %% 						true ->
%% %% %% 							List
%% %% %% 					end;
%% %% %% 				true ->
%% %% %% 					List
%% %% %% 			end         
%% %% %%         end,
%% %% %%     SuitAttributeList = lists:foldl(F, [], EquipSuit),
%% %% %% 	%%?DEBUG("##########equip_suit_list:~p",[SuitAttributeList]),
%% %% %%     F2 = fun(SuitAttribute,Effect) ->
%% %% %%             count_suit_attribute_effect(SuitAttribute,Effect)
%% %% %%         end,
%% %% %%     SuitAttribute = lists:foldl(F2, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], SuitAttributeList),
%% %% %% 	%%?DEBUG("###########suit_attribute:~p",[SuitAttribute]),
%% %% %% 	SuitAttribute.
%% %% 	
%% %% %% 根据套装数量获取属性
%% %% get_suit_num_attribute({SuitId,SuitNum},SuitAttributeInfo) ->
%% %% 	Pattern = #ets_base_goods_suit{suit_id = SuitId ,_='_'},
%% %% 	BaseGoodsSuit = get_ets_info(?ETS_BASE_GOODS_SUIT,Pattern),
%% %% 	if
%% %% 		is_record(BaseGoodsSuit ,ets_base_goods_suit) ->
%% %% 			SuitEffect = util:string_to_term(tool:to_list(BaseGoodsSuit#ets_base_goods_suit.suit_effect)),
%% %% 			AttributeIdList = 
%% %% 				case SuitNum of
%% %% 					2 ->
%% %% 						Spt = lists:member(SuitId, [36,37,38,39,40]),%%饰品套
%% %% 						if
%% %% 							Spt ->
%% %% 								SuitEffect;
%% %% 							true ->
%% %% 								lists:sublist(SuitEffect, 1)
%% %% 						end;
%% %% 					3 -> lists:sublist(SuitEffect, 1);
%% %% 					4 -> lists:sublist(SuitEffect, 2);
%% %% 					5 -> lists:sublist(SuitEffect, 2);
%% %% 					6 -> SuitEffect
%% %% 				end,
%% %% 			F = fun(AttributeId,_SuitAttributeInfo) ->
%% %% 					AttributeName = get_attribute_name_by_id(AttributeId),
%% %% 					case AttributeName of
%% %% 							hp ->_SuitAttributeInfo;
%% %% 							mp ->_SuitAttributeInfo;
%% %% 							max_attack ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{max_attack = SuitAttributeInfo#ets_base_goods_suit_attribute.max_attack,
%% %% 																				 min_attack = SuitAttributeInfo#ets_base_goods_suit_attribute.min_attack };
%% %% 							def ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{def =SuitAttributeInfo#ets_base_goods_suit_attribute.def };
%% %% 							hit ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{hit =SuitAttributeInfo#ets_base_goods_suit_attribute.hit };
%% %% 							dodge ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{dodge =SuitAttributeInfo#ets_base_goods_suit_attribute.dodge };
%% %% 							crit ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{crit =SuitAttributeInfo#ets_base_goods_suit_attribute.crit };
%% %% 							min_attack ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{min_attack =SuitAttributeInfo#ets_base_goods_suit_attribute.min_attack,
%% %% 																				 max_attack = SuitAttributeInfo#ets_base_goods_suit_attribute.max_attack};
%% %% 							physique ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{physique =SuitAttributeInfo#ets_base_goods_suit_attribute.physique};
%% %% 							anti_wind ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{anti_wind =SuitAttributeInfo#ets_base_goods_suit_attribute.anti_wind};
%% %% 							anti_fire ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{anti_fire =SuitAttributeInfo#ets_base_goods_suit_attribute.anti_fire};
%% %% 							anti_water ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{anti_water =SuitAttributeInfo#ets_base_goods_suit_attribute.anti_water};
%% %% 							anti_thunder ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{anti_thunder =SuitAttributeInfo#ets_base_goods_suit_attribute.anti_thunder};
%% %% 							anti_soil ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{anti_soil =SuitAttributeInfo#ets_base_goods_suit_attribute.anti_soil};
%% %% 							forza ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{forza =SuitAttributeInfo#ets_base_goods_suit_attribute.forza};
%% %% 							agile ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{agile =SuitAttributeInfo#ets_base_goods_suit_attribute.agile};
%% %% 							wit -> 
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{wit =SuitAttributeInfo#ets_base_goods_suit_attribute.wit};
%% %% 							speed -> _SuitAttributeInfo;
%% %% 							hp_lim ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{hp_lim =SuitAttributeInfo#ets_base_goods_suit_attribute.hp_lim};
%% %% 							mp_lim ->
%% %% 								_SuitAttributeInfo#ets_base_goods_suit_attribute{mp_lim =SuitAttributeInfo#ets_base_goods_suit_attribute.mp_lim};
%% %% 							_ ->_SuitAttributeInfo
%% %% 					end
%% %% 				end,
%% %% 			NewSuitAttributeInfo = #ets_base_goods_suit_attribute{id=SuitAttributeInfo#ets_base_goods_suit_attribute.id,
%% %% 																  career_id =SuitAttributeInfo#ets_base_goods_suit_attribute.career_id,
%% %% 																  suit_id = SuitAttributeInfo#ets_base_goods_suit_attribute.suit_id,
%% %% 																  suit_num = SuitAttributeInfo#ets_base_goods_suit_attribute.suit_num,
%% %% 																  level = SuitAttributeInfo#ets_base_goods_suit_attribute.level
%% %% 																 },
%% %% 			lists:foldl(F, NewSuitAttributeInfo, AttributeIdList);
%% %% 			%%?DEBUG("______________SUIT_EFFECT:~p",[SuitAttributeInfo]),
%% %% 			%%?DEBUG("______________SUIT_EFFECT:~p",[NewSuitAttributeInfo2]);
%% %% 		true ->
%% %% 			skip
%% %% 	end.
%% %% 
%% %% 
%% %% 
%% %% %% 需要修改（kexp）
%% %% %%辅助
%% %% count_goods_mult_attribute_effect(AttributeInfo,[Mult_hp,Mult_crit,Max_att]) ->
%% %% 	[Mult_hp + AttributeInfo#goods_attribute.mxhp,
%% %% 	 Mult_crit + AttributeInfo#goods_attribute.crit,
%% %% 	 Max_att + AttributeInfo#goods_attribute.atech
%% %% 	].
%% %% 	
%% %% %%辅助
%% %% count_suit_attribute_effect(SuitAttribute, [Hp_lim, Mp_lim, Max_attack,Min_attack,Def, Hit,Dodge, Crit, Forza,Physique,Agile,Wit,Anti_wind,Anti_fire,Anti_water,Anti_thunder,Anti_soil]) ->
%% %%     [ Hp_lim + SuitAttribute#ets_base_goods_suit_attribute.hp_lim,
%% %%       Mp_lim + SuitAttribute#ets_base_goods_suit_attribute.mp_lim,
%% %% 	  Max_attack + SuitAttribute#ets_base_goods_suit_attribute.max_attack,
%% %% 	  Min_attack + SuitAttribute#ets_base_goods_suit_attribute.min_attack,
%% %% 	  Def + SuitAttribute#ets_base_goods_suit_attribute.def,
%% %%       Hit + SuitAttribute#ets_base_goods_suit_attribute.hit,
%% %%       Dodge + SuitAttribute#ets_base_goods_suit_attribute.dodge,
%% %%       Crit + SuitAttribute#ets_base_goods_suit_attribute.crit,
%% %%       Forza + SuitAttribute#ets_base_goods_suit_attribute.forza,
%% %%       Physique + SuitAttribute#ets_base_goods_suit_attribute.physique,
%% %%       Agile + SuitAttribute#ets_base_goods_suit_attribute.agile,
%% %%       Wit + SuitAttribute#ets_base_goods_suit_attribute.wit, 
%% %%       Anti_wind + SuitAttribute#ets_base_goods_suit_attribute.anti_wind,
%% %%       Anti_fire + SuitAttribute#ets_base_goods_suit_attribute.anti_fire,
%% %%       Anti_water + SuitAttribute#ets_base_goods_suit_attribute.anti_water,
%% %%       Anti_thunder + SuitAttribute#ets_base_goods_suit_attribute.anti_thunder,
%% %%       Anti_soil + SuitAttribute#ets_base_goods_suit_attribute.anti_soil
%% %% 	   ].
%% %% 
%% %% %%合并属性
%% %% merge_goods_effect(Effect1,Effect2) ->
%% %% 	[Hp1, Mp1, MaxAtt1, MinAtt1, Def1, Hit1, Dodge1, Crit1, Anti_wind1,Anti_fire1,Anti_water1,Anti_thunder1,Anti_soil1] = Effect1,
%% %% 	[Hp2, Mp2, MaxAtt2, MinAtt2, Def2, Hit2, Dodge2, Crit2, Anti_wind2,Anti_fire2,Anti_water2,Anti_thunder2,Anti_soil2] = Effect2,
%% %% 	[Hp1+Hp2, Mp1+Mp2, MaxAtt1+MaxAtt2, MinAtt1+MinAtt2, Def1+Def2, Hit1+Hit2, Dodge1+Dodge2, Crit1+Crit2, Anti_wind1+Anti_wind2,Anti_fire1+Anti_fire2,Anti_water1+Anti_water2,Anti_thunder1+Anti_thunder2,Anti_soil1+Anti_soil2].
%% %% 
%% %% %%查找suitid的当前数量
%% %% get_suit_num(EquipSuit, SuitId) ->
%% %%     case SuitId > 0 of
%% %%         true ->
%% %%             case lists:keyfind(SuitId, 1, EquipSuit) of
%% %%                 false -> 0;
%% %%                 {SuitId, SuitNum} -> SuitNum
%% %%             end;
%% %%         false -> 0
%% %%     end.
%% %% 	
%% %% %%动态增删
%% %% change_equip_suit(EquipSuit, OldSuitId, NewSuitId) ->
%% %%     %% 删除
%% %%     EquipSuit1 = if OldSuitId > 0 ->
%% %%                         case lists:keyfind(OldSuitId, 1, EquipSuit) of
%% %%                             false ->
%% %%                                 EquipSuit;
%% %%                             {OldSuitId, SuitNum} when SuitNum > 1 ->
%% %%                                 lists:keyreplace(OldSuitId, 1, EquipSuit, {OldSuitId, SuitNum-1});
%% %%                             {OldSuitId, _} ->
%% %%                                 lists:keydelete(OldSuitId, 1, EquipSuit)
%% %%                         end;
%% %%                     true -> EquipSuit
%% %%                 end,
%% %%     %% 添加
%% %%     EquipSuit2 = if NewSuitId > 0 ->
%% %%                         case lists:keyfind(NewSuitId, 1, EquipSuit1) of
%% %%                             false ->
%% %%                                 [{NewSuitId, 1} | EquipSuit1];
%% %%                             {NewSuitId, SuitNum2} ->
%% %%                                 lists:keyreplace(NewSuitId, 1, EquipSuit1, {NewSuitId, SuitNum2+1})
%% %%                         end;
%% %%                     true -> EquipSuit1
%% %%                 end,
%% %%     %io:format("EquipSuit:~p~n",[EquipSuit2]),
%% %%     EquipSuit2.
%% %% 
%% %% %%检查是否已经穿完整一套 return 0/suitId
%% %% is_full_suit(EquipSuit)->
%% %% 	F = fun(ES,{CurSuitId,CurSuitNum}) ->
%% %% 				case ES of
%% %% 					{SuitId,SuitNum} ->
%% %% 						if
%% %% 							SuitNum > CurSuitNum ->
%% %% 								{SuitId,SuitNum};
%% %% 							true ->
%% %% 								{CurSuitId,CurSuitNum}
%% %% 						end;
%% %% 					_ ->
%% %% 						{CurSuitId,CurSuitNum}
%% %% 				end
%% %% 		end,
%% %% 	GetSuit = lists:foldl(F, {0,0}, EquipSuit),
%% %% 	case GetSuit of
%% %% 		{GetSuitId,6} ->
%% %% 			GetSuitId;
%% %% 		_ ->
%% %% 			0
%% %% 	end.
%% %% 
%% %% %% 取装备类型附加属性值 [气血,内功,技法，法术，命中，暴击，闪避，格挡,反击,气势基础附加值,怒气基础附加值,内功防御附加值,技法防御附加值,法力防御附加值, 内功攻击附加值,技法攻击附加值,法力攻击附加值]
%% %% %%@spec get_add_attribute_by_type(BaseAddAttributeInfo) -> [forza, agile, wit,physique, crit, dodge]
%% %% get_add_attribute_by_type(AttributeList) ->
%% %% 	[BaseAddAttributeInfo] = AttributeList,
%% %% 	NewList = [{mxhp, BaseAddAttributeInfo#ets_base_goods_add_attribute.mxhp},
%% %% 			   {pwr, BaseAddAttributeInfo#ets_base_goods_add_attribute.pwr},
%% %% 			   {tech, BaseAddAttributeInfo#ets_base_goods_add_attribute.tech},
%% %% 			   {mgc, BaseAddAttributeInfo#ets_base_goods_add_attribute.mgc},
%% %% 			   {hit, BaseAddAttributeInfo#ets_base_goods_add_attribute.hit},
%% %% 			   {crit, BaseAddAttributeInfo#ets_base_goods_add_attribute.crit},
%% %% 			   {ddge, BaseAddAttributeInfo#ets_base_goods_add_attribute.ddge},
%% %% 			   {blck, BaseAddAttributeInfo#ets_base_goods_add_attribute.blck},
%% %% 			   {mnup, BaseAddAttributeInfo#ets_base_goods_add_attribute.mnup},
%% %% 	{agup, BaseAddAttributeInfo#ets_base_goods_add_attribute.agup},
%% %% 	{dpwr, BaseAddAttributeInfo#ets_base_goods_add_attribute.dpwr},
%% %% 	{dtech, BaseAddAttributeInfo#ets_base_goods_add_attribute.dtech},
%% %% 	{dmgc, BaseAddAttributeInfo#ets_base_goods_add_attribute.dmgc},
%% %% 	{apwr, BaseAddAttributeInfo#ets_base_goods_add_attribute.apwr},
%% %% 	{atech, BaseAddAttributeInfo#ets_base_goods_add_attribute.atech},
%% %% 	{amgc, BaseAddAttributeInfo#ets_base_goods_add_attribute.amgc}
%% %% 	 ],
%% %% 	F = fun(Attribute) ->
%% %% 				{_, X} = Attribute,
%% %% 				if X =:= 0 ->
%% %% 					   false;
%% %% 				   true ->
%% %% 					   true
%% %% 				end
%% %% 		end,
%% %% 	lists:filter(F, NewList).
%% %% 
%% %% %% 装备强化加成系数
%% %% get_stren_factor(Stren) ->
%% %%     case Stren of
%% %%         0  -> 0;
%% %%         1  -> 0.06;
%% %%         2  -> 0.15;
%% %%         3  -> 0.26;
%% %%         4  -> 0.38;
%% %%         5  -> 0.48;
%% %%         6  -> 0.6;
%% %%         7  -> 0.74;
%% %%         8  -> 0.82;
%% %%         9  -> 0.9;
%% %%         10 -> 1;
%% %%         _  -> 0
%% %%     end.
%% %% 
%% %% %% 装备强化颜色系数
%% %% get_stren_color_factor(Color) ->
%% %%     case Color of
%% %%         0  -> 0.9;
%% %%         1  -> 0.95;
%% %%         2  -> 1;
%% %%         3  -> 1.1;
%% %%         4  -> 1.25;
%% %%         _  -> 0.9
%% %%     end.
%% %% 
%% %% % 装备加成属性类型ID 这里决定加攻或是加防或是加移动速度
%% %% get_goods_attribute_id(Subtype) ->
%% %%     if
%% %%         Subtype >= 9 andalso  Subtype =< 13 ->
%% %%             3;
%% %% 		Subtype =:= 22 ->
%% %% 			18;
%% %% 		Subtype =:= 24 ->
%% %% 			1;
%% %%         true ->
%% %%             4
%% %%     end.
%% %% 
%% %% 
%% %% 
%% %% 
%% %% %% 取得装备的使用次数
%% %% %% @spec get_goods_use_num(Attrition) -> UseNum
%% %% get_goods_use_num(Attrition) ->
%% %%     Attrition * 10.
%% %% 
%% %% %% 取得装备的耐久度
%% %% %% @spec get_goods_attrition(UseNum) -> Attrition
%% %% get_goods_attrition(OldAttrition, UseNum) ->
%% %%     Attrition = case OldAttrition > 0 of
%% %%                     false -> 0;
%% %%                     true -> round( UseNum / 10 + 0.5 )
%% %%                 end,
%% %%     case Attrition > OldAttrition of
%% %%         true -> OldAttrition;
%% %%         false -> Attrition
%% %%     end.
%% %% 
%% %% %% 取修理装备价格
%% %% get_mend_cost(Attrition, UseNum) ->
%% %%     TotalUseNum = get_goods_use_num(Attrition),
%% %%     Cost = trunc( (TotalUseNum - UseNum) * 1 ),
%% %%     Cost.
%% %% 
%% %% %%默认装备格子位置, 0 默认位置，1 帽子，2 衣服，3 鞋子，4 武器，5 戒指， 6 项链
%% %% get_equip_cell(_PlayerStatus, Subtype) ->
%% %%     case Subtype of
%% %% 		1 -> 4;     % 剑
%% %%         2 -> 4;    	% 法卷
%% %% 		3 -> 4;		% 杖
%% %% 		4 -> 2;		% 衣服
%% %% 		5 -> 1;		% 帽子
%% %%         6 -> 3;    	% 鞋子
%% %%         7 -> 6;    	% 项链
%% %%         8 -> 5;    	% 戒指
%% %% 		20 -> 7;    %%时装
%% %% 		21 -> 8     %%法器
%% %%     end.
%% %% %% 取属性ID
%% %% get_attribute_id_by_name(Name) ->
%% %% 	case Name of
%% %% 		hp ->1;
%% %% 		mp ->2;
%% %% 		max_attack ->3;
%% %% 		def ->4;
%% %% 		hit ->5;
%% %% 		dodge ->6;
%% %% 		crit ->7;
%% %% 		min_attack -> 8;
%% %% 		physique -> 9;
%% %% 		anti_wind ->10;
%% %% 		anti_fire ->11;
%% %% 		anti_water ->12;
%% %% 		anti_thunder ->13;
%% %% 		anti_soil ->14;
%% %% 		forza ->15;
%% %% 		agile ->16;
%% %% 		wit -> 17;
%% %% 		speed ->18;
%% %% 		hp_lim ->19;
%% %% 		mp_lim ->20;
%% %% 		_ -> 0
%% %% 	end.
%% %% %%取属性名称
%% %% get_attribute_name_by_id(Id) ->
%% %% 	case Id of
%% %% 		1 -> hp ;
%% %% 		2 -> mp ;
%% %% 		3 -> max_attack ;
%% %% 		4 -> def ;
%% %% 		5 -> hit ;
%% %% 		6 -> dodge ;
%% %% 		7 -> crit ;
%% %% 		8 -> min_attack ;
%% %% 		9 -> physique ;
%% %% 		10 -> anti_wind ;
%% %% 		11 -> anti_fire ;
%% %% 		12 -> anti_water ;
%% %% 		13 -> anti_thunder ;
%% %% 		14 -> anti_soil ;
%% %% 		15 -> forza ;
%% %% 		16 -> agile ;
%% %% 		17 -> wit;
%% %% 		18 ->speed;
%% %% 		19 -> hp_lim;
%% %% 		20 -> mp_lim;
%% %% 		_ -> undefined
%% %% 	end.
%% %% 
%% %% 
%% %% %% 经验卡对应的经验
%% %% get_goods_exp(Color) ->
%% %%     case Color of
%% %%         0 -> 1000;    % 初级经验卡
%% %%         1 -> 5000;    % 中级经验卡
%% %%         2 -> 10000;   % 高级经验卡
%% %%         _  -> 0
%% %%     end.
%% %% 
%% %% %% 检查物品还需要多少格子数
%% %% get_null_cell_num(GoodsList, MaxNum, GoodsNum) ->
%% %%     case MaxNum > 1 of
%% %%         true ->
%% %%             TotalNum = lists:foldl(fun(X, Sum) -> X#goods.num + Sum end, 0, GoodsList),
%% %%             CellNum = util:ceil( (TotalNum+GoodsNum)/ MaxNum ),
%% %% %%             ( CellNum - length(GoodsList) );
%% %% 			%%返回数值经过修改--xiaomai
%% %% 			case CellNum =< length(GoodsList) of
%% %% 				true ->%%能够全部合并进去了，所以直接返回0
%% %% 					0;
%% %% 				false ->%%需要多出来的格子
%% %% 					CellNum -length(GoodsList)
%% %% 			end;
%% %%         false ->
%% %%             GoodsNum
%% %%     end.
%% %% 
%% %% %% 获取背包仓库空位
%% %% get_null_cells(PlayerId, CellNum, Location) ->
%% %%     Pattern = #goods{ uid=PlayerId, loc=Location, _='_' },
%% %%     List = get_ets_list(?ETS_GOODS_ONLINE, Pattern),
%% %%     Cells = lists:map(fun(GoodsInfo) -> [GoodsInfo#goods.cell] end, List),
%% %%     AllCells = lists:seq(1, CellNum),
%% %%     NullCells = lists:filter(fun(X) -> not(lists:member([X], Cells)) end, AllCells),
%% %%     NullCells.
%% %% 
%% %% %% 按格子位置排序
%% %% sort(GoodsList, Type) ->
%% %%     case Type of
%% %%         cell -> F = fun(G1, G2) -> G1#goods.cell < G2#goods.cell end;
%% %%         goods_id -> F = fun(G1, G2) -> G1#goods.gtid < G2#goods.gtid end;
%% %%         _ -> F = fun(G1, G2) -> G1#goods.cell < G2#goods.cell end
%% %%     end,
%% %%     lists:sort(F, GoodsList).
%% %% 
%% %% %% %% 判断荣誉是否足够
%% %% %% is_enough_honor(PlayerStatus,Cost,_Type) ->
%% %% %% 	[Honor] = db_agent:query_player_honor(PlayerStatus#player.id),
%% %% %% 	?DEBUG("____________________COST~p,honor~p",[Cost,Honor]),
%% %% %% 	Honor >= Cost.
%% %% 	
%% %% 
%% %% %% 判断金钱是否充足，true为充足，false为不足
%% %% %% Type为 coin / gold
%% %% is_enough_money(PlayerStatus, NewCost, Type) ->
%% %% 	if NewCost < 0 ->false;
%% %% 	   true->
%% %% %% 		   NewCost = Cost,
%% %% 		   case Type of
%% %% 			   coin ->
%% %% 				   if
%% %% 					   NewCost >= 50000 ->
%% %% 						   [_Gold,Coin] = db_agent:query_player_money(PlayerStatus#player.id),
%% %% 						   Coin >= NewCost;
%% %% 					   true ->
%% %% 						   PlayerStatus#player.coin >= NewCost
%% %% 				   end;
%% %% 			   gold ->
%% %% 				   [Gold,_Coin] = db_agent:query_player_money(PlayerStatus#player.id),
%% %% 				   Gold >= NewCost;
%% %% 			   _ -> false
%% %% 			end
%% %%     end.
%% %% 
%% %% %% 检查数据库并判断金钱是否充足，true为充足，false为不足
%% %% %% Type为 coin / gold
%% %% is_enough_money_chk_db(PlayerStatus, NewCost, Type) ->
%% %% 	if NewCost < 0 ->false;
%% %% 	   true->
%% %% %% 		   NewCost = Cost,
%% %% 		   [Gold,Coin] = db_agent:query_player_money(PlayerStatus#player.id),
%% %% 		   case Type of
%% %% 			   coin ->
%% %% 				   Coin >= NewCost;
%% %% 			   gold ->
%% %% 				   Gold >= NewCost;
%% %% 			   _ -> false
%% %% 			end
%% %%     end.
%% %% 
%% %% %% 检查数据库并判断元宝是否充足
%% %% is_enough_gold_by_id(PlayerId, Cost) ->
%% %% 	if 
%% %% 		Cost < 0 ->false;
%% %% 	   	true->
%% %% 		   [Gold, _Coin] = db_agent:query_player_money(PlayerId),
%% %% 			Gold >= Cost
%% %%     end.
%% %% 
%% %% %% 计算消费
%% %% get_cost(PlayerStatus, Cost, Type) ->
%% %% 	NewCost = abs(Cost),
%% %%     case Type of
%% %%         coin ->
%% %% 			NewPlayerStatus = PlayerStatus#player{coin = (PlayerStatus#player.coin - NewCost)};
%% %%         gold ->
%% %% 			[Gold,_Coin] = db_agent:query_player_money(PlayerStatus#player.id),
%% %% 			NewPlayerStatus = PlayerStatus#player{ gold = (Gold - NewCost) }
%% %%     end,
%% %%     NewPlayerStatus.
%% %% 
%% %% %% 添加金钱
%% %% add_money(PlayerStatus,Sum,Type) ->
%% %% 	NewSum = abs(Sum),
%% %% 	case Type of
%% %% 		coin ->
%% %% 			NewPlayerStatus = PlayerStatus#player{coin = (PlayerStatus#player.coin + NewSum)};
%% %% 		gold ->
%% %% 			NewPlayerStatus = PlayerStatus#player{gold = (PlayerStatus#player.gold + NewSum)}
%% %% 	end,
%% %% 	%% 需添加日志
%% %% %% 	spawn(fun()->catch(db_agent:add_money_to_db(Type,NewSum))end),
%% %% 	NewPlayerStatus.
%% %% 
%% %% 
%% %% %% 添加vip金钱
%% %% add_money_vip(PlayerStatus,Sum) ->
%% %% 	NewSum = abs(Sum),
%% %% 	NewPlayerStatus = PlayerStatus#player{gold = (PlayerStatus#player.gold + NewSum)},
%% %% 	%% 需添加日志
%% %% %% 	spawn(fun()->catch(db_agent:add_money_to_db(gold,NewSum))end),
%% %% 	NewPlayerStatus.
%% %% 
%% %% 
%% %% 	
%% %% %% 取价格类型
%% %% get_price_type(Type) ->
%% %%     case Type of
%% %%         1 -> coin;      % 铜钱
%% %%         2 -> cash;    	% 礼金
%% %%         3 -> gold;      % 元宝
%% %%         4 -> bcoin;     % 绑定的铜钱
%% %%         _ -> coin       % 铜钱
%% %%     end.
%% %% %%等级换算成阶
%% %% level_to_step(Level) ->
%% %% 	case Level > 0 of
%% %% 		true when Level < 10 -> 1;
%% %% 		true when Level < 20 -> 2;
%% %% 		true when Level < 30 -> 3;
%% %% 		true when Level < 40 -> 4;
%% %% 		true when Level < 50 -> 5;
%% %% 		true when Level < 60 -> 6;
%% %% 		true when Level < 70 -> 7;
%% %% 		true when Level < 80 -> 8;
%% %% 		true when Level < 90 -> 9;
%% %% 		true when Level < 100 -> 10;
%% %% 		false -> 1
%% %% 	end.
%% %% 
%% %% %% 检查装备是否有属性加成
%% %% has_attribute(GoodsInfo) ->
%% %%     case is_record(GoodsInfo,goods) andalso GoodsInfo#goods.type =:= 10 of
%% %%         true when GoodsInfo#goods.stlv > 0 -> true;
%% %%         true when GoodsInfo#goods.qly > 0 -> true;
%% %%         true when GoodsInfo#goods.stid > 0 -> true;
%% %%         _ -> false
%% %%     end.
%% %% 
%% %% %% 检查装备是否可穿
%% %% can_equip(PlayerStatus, GoodsTypeId, Cell ,_SkipCheck) ->
%% %%     GoodsTypeInfo = get_goods_type(GoodsTypeId),
%% %% 	%%装备对应cell
%% %% 	case is_record(GoodsTypeInfo, ets_base_goods) of
%% %% 		false -> {false, 0};
%% %% 		true ->
%% %% 			DefCell = get_equip_cell(PlayerStatus,GoodsTypeInfo#ets_base_goods.stype),
%% %% 			NewCell = case (Cell =< 0 orelse Cell > 8) of
%% %% 						  true -> DefCell;
%% %% 						  false -> Cell
%% %% 					  end,
%% %% 			if
%% %% 				NewCell =/= DefCell ->
%% %% 					{false, 6};
%% %% 				GoodsTypeInfo#ets_base_goods.lv > PlayerStatus#player.lv ->
%% %% 					{false, 7};%%等级不符合
%% %% 				GoodsTypeInfo#ets_base_goods.crr > 0 andalso GoodsTypeInfo#ets_base_goods.crr =/= PlayerStatus#player.crr ->
%% %% 					{false, 8};%%职业不符合
%% %% 				true ->
%% %% 					NewCell
%% %% 			end
%% %% 	end.
%% %% 
%% %% %% 检查巨兽是否可装备此物品
%% %% can_equip_giant(GoodsTypeId, GiantType) ->
%% %%     FitGiantTypeL = data_stren:get_equip_giant_type(GoodsTypeId),		%%根据物品类型ID返回可用此物品的巨兽类型ID
%% %% 	lists:member(GiantType, FitGiantTypeL).
%% %% 
%% %% 
%% %% %% 返回巨兽物品的装备格子位置
%% %% get_equip_cell_giant(Type, Stype) ->
%% %%     data_stren:get_equip_cell_giant(Type, Stype).		%%根据物品类型、子类型匹配格子位置
%% %% 
%% %% 
%% %% %% 取物品总数
%% %% get_goods_totalnum(GoodsList) ->
%% %% 	F = fun(X,Sum) ->
%% %% 				if
%% %% 					is_record(X,goods) ->
%% %% 						X#goods.num + Sum;
%% %% 					true ->
%% %% 						Sum
%% %% 				end
%% %% 		end,					
%% %%     lists:foldl(F, 0, GoodsList).
%% %% 
%% %% %% 取消费类型
%% %% get_consume_type(Type) ->
%% %%     case Type of
%% %%         pay -> 1;
%% %%         mend -> 2;
%% %%         %%quality_upgrade -> 3;
%% %%         %%quality_backout -> 4;
%% %%         strengthen -> 5;
%% %%         hole -> 6;
%% %%         compose -> 7;
%% %%         inlay -> 8;
%% %%         backout -> 9;
%% %%         wash -> 10;
%% %%         _ -> 0
%% %%     end.
%% %% 
%% %% deeploop(F, N, Data) ->
%% %%     case N > 0 of
%% %%         true ->
%% %%             [N1, Data1] = F(N, Data),
%% %%             deeploop(F, N1, Data1);
%% %%         false ->
%% %%             Data
%% %%     end.
%% %% 
%% %% %% @spec list_handle(F, Data, List) -> {ok, NewData} | Error
%% %% list_handle(F, Data, List) ->
%% %%     if length(List) > 0 ->
%% %%             [Item|L] = List,
%% %%             case catch(F(Item, Data)) of
%% %%                 {ok, Data1} -> list_handle(F, Data1, L);
%% %%                 Error -> Error
%% %%             end;
%% %%         true ->
%% %%             {ok, Data}
%% %%     end.
%% %% 
%% %% 
%% %% %%获取打造装备位置约定信息
%% %% get_make_position_goods(PlayerId,Position) ->
%% %% 	case Position of
%% %% 		%% 1装备强化  约定信息 返回宝石 type=15
%% %% 		1 when PlayerId > 0 ->
%% %% 				Pattern = #goods{uid=PlayerId, type=15, _='_' },
%% %%             	get_ets_list(?ETS_GOODS_ONLINE, Pattern);
%% %% 		_ ->
%% %% 			[]
%% %% 	end.
%% %% 
%% %% %%取装备强化附加抗性属性信息
%% %% get_goods_anti_attribute_info(PlayerId,GoodsId) ->
%% %% 	Pattern = #goods_attribute{uid=PlayerId, gid=GoodsId, atype=4,atid =0, _='_'},
%% %% 	get_ets_info(?ETS_GOODS_ATTRIBUTE, Pattern).
%% %% 
%% %% 
%% %% %%取时装强化附加气血上限属性信息
%% %% get_goods_hp_attribute_info(PlayerId,GoodsId) ->
%% %% 	Pattern = #goods_attribute{uid=PlayerId, gid=GoodsId, atype=2,atid =1, _='_'},
%% %% 	get_ets_info(?ETS_GOODS_ATTRIBUTE, Pattern).
%% %% 
%% %% 
%% %% 
%% %% %%查找物品
%% %% %% search_goods(Name)->
%% %% %% 	BaseGoodsList = ets:tab2list(?ETS_BASE_GOODS),
%% %% %% 	ShopGoodsList = ets:tab2list(?ETS_BASE_SHOP),
%% %% %% 	F =fun(BaseGoodsInfo,GetList)  ->
%% %% %% 		GoodsName = tool:to_list(BaseGoodsInfo#ets_base_goods.name),
%% %% %% 		F = string:str(GoodsName,Name),
%% %% %% 		case F of
%% %% %% 			0 ->
%% %% %% 				GetList;				
%% %% %% 			_-> 
%% %% %% 				[BaseGoodsInfo#ets_base_goods.gtid|GetList]
%% %% %% 		end		
%% %% %% 	end,
%% %% %% 	SearchInBase = lists:foldl(F, [], BaseGoodsList),
%% %% %% 	F2 = fun(ShopGoodsInfo,TargetList) ->
%% %% %% 			T =lists:member(ShopGoodsInfo#ets_shop.goods_id, SearchInBase),
%% %% %% 			if
%% %% %% 				T =:= true andalso ShopGoodsInfo#ets_shop.shop_type =:= 1 ->
%% %% %% 					[[ShopGoodsInfo#ets_shop.goods_id,ShopGoodsInfo#ets_shop.shop_subtype]|TargetList];
%% %% %% 				true ->
%% %% %% 					TargetList
%% %% %% 			end
%% %% %% 		 end,
%% %% %% 	lists:foldl(F2,[],ShopGoodsList).
%% %% 
%% %% 
%% %% %%解析other_data 数据 "[a,b,c];[d,e,f]" => [[a,b,c],[d,e,f]]
%% %% %%other_data的格式有:
%% %% %%数值			value
%% %% %%礼包			[{24400,1,2},{23204,1,2}]
%% %% %%随机礼包		[{24000,1,2,80}] %%礼包格式+ 80 概率
%% %% %%价格			[shop,lq,5];[shop,th,6];[shop,jf,7]
%% %% %%buff			[buff,mp_lim,1.45,0.5]
%% %% %% type 类型 shop,buff,gift,value
%% %% parse_goods_other_data(Other_data) ->
%% %% 	String = tool:to_list(Other_data),
%% %% 	List = string:tokens(String, ";"),
%% %% 	F = fun(S) ->
%% %% 				util:string_to_term(S)
%% %% 		end,
%% %% 	lists:map(F, List).
%% %% parse_goods_other_data(Other_data,Type) ->
%% %% 	Trans = parse_goods_other_data(Other_data),
%% %% 	get_type_other_data(Trans,Type).
%% %% 
%% %% get_type_other_data([],_Type) ->
%% %% 	error;
%% %% get_type_other_data([One|Trans],Type)->
%% %% 	case One of
%% %% 		[shop|_] when Type == shop -> One;
%% %% 		[buff|_] when Type == buff -> One;
%% %% 		[farm|_] when Type == farm -> One;
%% %% 		[{_chenge,Id}|_] when Type ==chenge ->Id;
%% %% 		[{_Id,_N,_B}|_] when Type == gift ->One;
%% %% 		[{_Id,_N,_B,_R}|_] when Type ==rgift -> One;
%% %% 		V  when is_integer(V),Type == value -> One;
%% %% 		_ -> get_type_other_data(Trans,Type)
%% %% 	end.
%% %% 		
%% %% 
%% %% %% 获取物品基础数据的other_data数据
%% %% get_goods_other_data(TypeId) ->
%% %% 	TypeInfo = get_goods_type(TypeId),
%% %% 	if
%% %% 		is_record(TypeInfo,ets_base_goods) ->
%% %% 			TypeInfo#ets_base_goods.other_data;
%% %% 		true ->
%% %% 			<<>>
%% %% 	end.
%% %% %% 获取物品cd列表
%% %% get_goods_cd_list(PlayerId) ->
%% %% 	Now =util:unixtime(),
%% %% 	MS_cd = ets:fun2ms(fun(T) when T#ets_goods_cd.uid == PlayerId andalso T#ets_goods_cd.eprtm > Now  -> 
%% %% 			T 
%% %% 		end),
%% %% 	ets:select(?ETS_GOODS_CD, MS_cd).
%% %% 
%% %% 
%% %% %% 获取一件新手法宝
%% %% get_one_equip(PlayerId,Color) ->
%% %% 	MS = ets:fun2ms(fun(T) when T#goods.uid == PlayerId andalso T#goods.type == 10 andalso T#goods.stype >= 9 andalso T#goods.stype =< 13 andalso T#goods.qly == Color ->
%% %% 							T
%% %% 					end),
%% %% 	GoodsList = ets:select(?ETS_GOODS_ONLINE,MS),
%% %% 	F = fun(GoodsInfo) ->
%% %% 				if
%% %% 					GoodsInfo#goods.gtid div 1000 =:= 17 ->
%% %% 						true;
%% %% 					true ->
%% %% 						false
%% %% 				end
%% %% 		end,
%% %% 	FilterList = lists:filter(F, GoodsList),
%% %% 	if
%% %% 		is_list(FilterList) andalso length(FilterList) > 0 ->
%% %% 			lists:nth(1, FilterList);
%% %% 		true ->
%% %% 			{}
%% %% 	end.
%% %% 
%% %% %%获取身上的一件法宝
%% %% get_equip_fb(PlayerId) ->
%% %% 	MS = ets:fun2ms(fun(T) when T#goods.uid == PlayerId andalso T#goods.type == 10 andalso T#goods.stype >= 9 andalso T#goods.stype =< 13 andalso T#goods.loc =:= 1 ->
%% %% 							T
%% %% 					end),
%% %% 	GoodsList = ets:select(?ETS_GOODS_ONLINE,MS),
%% %% 	case length(GoodsList) > 0 of
%% %% 		true ->
%% %% 			GoodsInfo = lists:nth(1, GoodsList),
%% %% 			if
%% %% 				is_record(GoodsInfo,goods)->
%% %% 					GoodsInfo;
%% %% 				true ->
%% %% 					#goods{}
%% %% 			end;
%% %% 		false ->
%% %% 			#goods{}
%% %% 	end.
%% %% 
%% %% %% 获取坐骑加成速度
%% %% get_mount_info(Player) ->
%% %% 	case Player#player.mnt of
%% %% 		0 ->
%% %% 			[0,0,0];
%% %% 		MountId ->
%% %% 			MountInfo = get_goods(MountId),
%% %% 			if
%% %% 				is_record(MountInfo,goods) ->
%% %% 					[MountInfo#goods.id,0,MountInfo#goods.stlv];
%% %% 				true ->
%% %% 					[0,0,0]
%% %% 			end
%% %% 	end.
%% %% %% 获取color对应的16进制值
%% %% get_color_hex_value(Color) ->
%% %% 	case Color of
%% %% 		0 ->"#FFFFFF";
%% %% 		1 ->"#00FF33";
%% %% 		2 ->"#313bdd";
%% %% 		3 ->"#F8EF38";
%% %% 		4 ->"#8800FF";
%% %% 		_ ->"#FFFFFF"
%% %% 	end.
%% %% %% 获取realm对应部落名称
%% %% get_realm_to_name(Id) ->
%% %% 	case Id of
%% %% 		1 ->"女娲";
%% %% 		2 ->"神农";
%% %% 		3 ->"伏羲";
%% %% 		100 ->"新手";
%% %% 		_ ->"未知"
%% %% 	end.
%% %% 
%% %% handle_pay_goods_addition(PlayerName, GiveGoods, 2, GoodsNum, Title, Cont, MaxOverlap) ->
%% %% 	case GoodsNum =< 0 of
%% %% 		false ->
%% %% 			{NewNum, ResNum} =
%% %% 				if
%% %% 					MaxOverlap > 1 andalso MaxOverlap > GoodsNum ->
%% %% 						{GoodsNum, 0};
%% %% 					MaxOverlap > 1 andalso MaxOverlap =< GoodsNum ->
%% %% 						{MaxOverlap, GoodsNum - MaxOverlap};
%% %% 					true ->
%% %% 						{1, 0}
%% %% 				end,
%% %% 			Content = io_lib:format("~s~p~s", [Cont,NewNum, "个"]),
%% %% 			lib_goods:add_new_goods_by_mail(PlayerName, GiveGoods, 2, NewNum, Title, Content),
%% %% 			handle_pay_goods_addition(PlayerName, GiveGoods, 2, ResNum, Title, Cont, MaxOverlap);
%% %% 		true ->
%% %% 			skip
%% %% 	end.
%% %% 
%% %% %%获取时装形象ID
%% %% get_fash_img(Player) ->
%% %% 	PlayerId = Player#player.id,
%% %% 	Pattern = #goods{uid = PlayerId, type=10, stype = 20, loc = 1,  _='_'},
%% %%     FashInfo = get_ets_info(?ETS_GOODS_ONLINE, Pattern),
%% %% 	case is_record(FashInfo, goods) of
%% %% 		true ->
%% %% 			case FashInfo#goods.img of
%% %% 				FashImg when is_integer(FashImg) ->
%% %% 					FashImg;
%% %% 				_ ->
%% %% 					0
%% %% 			end;
%% %% 		_ ->
%% %% 			0
%% %% 	end.
%% %% 
%% %% %%获取衣服装备形象ID
%% %% get_normal_img(Player) ->
%% %% 	PlayerId = Player#player.id,
%% %% 	Pattern = #goods{uid = PlayerId, type=10, stype = 4, loc = 1,  _='_'},
%% %%     GoodsInfo = get_ets_info(?ETS_GOODS_ONLINE, Pattern),
%% %% 	case is_record(GoodsInfo, goods) of
%% %% 		true ->
%% %% 			case GoodsInfo#goods.img of
%% %% 				Img when is_integer(Img) ->
%% %% 					Img;
%% %% 				_ ->
%% %% 					0
%% %% 			end;
%% %% 		_ ->
%% %% 			0
%% %% 	end.
%% %% 
%% %% 
%% %% %%获取装备的人物外显形象ID（衣服或时装）
%% %% get_equip_img(GoodsInfo) ->
%% %% 	case GoodsInfo#goods.img of
%% %% 		FashImg when is_integer(FashImg) ->
%% %% 			FashImg;
%% %% 		_ ->
%% %% 			0
%% %% 	end.
%% %% 
%% %% %%获取玩家当前的形象ID(EquipImg-衣服形象Id, FashImg-时装形象Id, Flag-是否显示时装（0：不显示，1：显示）)
%% %% get_player_now_img(EquipImg, FashImg, Flag) ->
%% %% 	case Flag of
%% %% 		1 ->
%% %% 			if FashImg > 0 -> FashImg;
%% %% 			   true -> EquipImg
%% %% 			end;
%% %% 		_ ->
%% %% 			EquipImg
%% %% 	end.
%% %% 
%% %% %%获取玩家上线时的时装标志位
%% %% get_fash_flag(Player) ->
%% %% 	Img = get_normal_img(Player),
%% %% 	if Player#player.img =/= Img ->
%% %% 		   1;
%% %% 	   true ->
%% %% 		   0
%% %% 	end.
%% %% 
%% %% 
%% %% %%检测物品套装是否装备到指定数量，并且达到某一品质（开服活动使用）
%% %% chk_equip_suit(PlayerId, LimitSuitNum, LimitEquipQly)->
%% %% 	EquipList = get_equip_list(PlayerId, 10, 1),
%% %% 	F = fun(GoodsInfo, EquipSuit) ->
%% %%             change_equip_suit(EquipSuit, 0, GoodsInfo#goods.stid)
%% %%         end,
%% %%     EquipSuit = lists:foldl(F, [], EquipList),
%% %% 	SuitNumL = [{SuitId, SNum}||{SuitId, SNum}<-EquipSuit, SNum >= LimitSuitNum],
%% %% 	Fun = fun({SuitId, _SNum}, AccNum) ->
%% %% 				  SuitMinQly = lists:min([Eqp#goods.qly||Eqp<-EquipList, Eqp#goods.stid =:= SuitId]),
%% %% 				  if SuitMinQly >= LimitEquipQly ->
%% %% 						 AccNum bor 1;
%% %% 					 true ->
%% %% 						 AccNum
%% %% 				  end
%% %% 		  end,
%% %% 	Res = lists:foldl(Fun, 0, SuitNumL),
%% %% 	if Res > 0 ->
%% %% 		   true;
%% %% 	   true ->
%% %% 		   false
%% %% 	end.
%% %% 
%% %% %%查询套装基础数据
%% %% get_base_goods_suit(BaseSuitId) ->
%% %% 	case ets:lookup(?ETS_BASE_GOODS_SUIT, BaseSuitId) of
%% %% 		[] ->
%% %% 			[];
%% %% 		[BaseSuit|_] ->
%% %% 			BaseSuit
%% %% 	end.
%% %% 
%% %% 
%% %% %%检查配置数据, 仅用于辅助检查配置数据
%% %% check_table_base_goods_suit() ->
%% %% 	BaseSuitList = ets:tab2list(?ETS_BASE_GOODS_SUIT),
%% %% 	F = fun(BaseSuit, Acc) ->
%% %% 				if
%% %% 					is_list(BaseSuit#ets_base_goods_suit.suit_goods) andalso is_list(BaseSuit#ets_base_goods_suit.suit_effect) ->
%% %% 						NoGoods = [GoodsTypeId||GoodsTypeId<-BaseSuit#ets_base_goods_suit.suit_goods, get_base_goods(GoodsTypeId)=:=[]],
%% %% 						WrongData = [{Type, Num}||{Type, Num}<-BaseSuit#ets_base_goods_suit.suit_effect, Type < 1 orelse Type > 19 orelse Num =< 0 ],
%% %% 						if
%% %% 							NoGoods =/= [] orelse WrongData =/= [] ->
%% %% 								[BaseSuit#ets_base_goods_suit.suit_id|Acc];
%% %% 							true ->
%% %% 								Acc
%% %% 						end;
%% %% 					true ->
%% %% 						[BaseSuit#ets_base_goods_suit.suit_id|Acc]
%% %% 				end
%% %% 		end,
%% %% 	WrongBaseSuitList = lists:foldl(F, [], BaseSuitList),
%% %% 	if
%% %% 		WrongBaseSuitList =/= [] ->
%% %% 			io:format("check_table_base_goods_suit, WrongBaseSuitList:~p~n", [WrongBaseSuitList]);
%% %% 		true ->
%% %% 			skip
%% %% 	end,
%% %% 	ok.
%% %% 	
%% %% %%检查配置数据, 仅用于辅助检查配置数据
%% %% check_table_base_holiday_goods() ->
%% %% 	BaseGoodsList = ets:tab2list(?ETS_BASE_HOLIDAY_GOODS),
%% %% 	F = fun(BaseGoods, Acc) ->
%% %% 				if
%% %% 					is_list(BaseGoods#ets_base_holiday_goods.goods) ->
%% %% 						NoGoods = [GoodsTypeId||{GoodsTypeId,_, MinNum, MaxNum}<-BaseGoods#ets_base_holiday_goods.goods, goods_util:get_base_goods(GoodsTypeId)=:=[] orelse MinNum =< 0 orelse MaxNum =< 0 orelse MinNum > MaxNum],
%% %% 						TotalRatio = lists:sum([Ratio||{_, Ratio, _, _}<-BaseGoods#ets_base_holiday_goods.goods]),
%% %% 						if
%% %% 							NoGoods =/= [] orelse TotalRatio =/= 10000 ->
%% %% 								[BaseGoods#ets_base_holiday_goods.id|Acc];
%% %% 							true ->
%% %% 								Acc
%% %% 						end;
%% %% 					true ->
%% %% 						[BaseGoods#ets_base_holiday_goods.id|Acc]
%% %% 				end
%% %% 		end,
%% %% 	WrongBaseGoodsList = lists:foldl(F, [], BaseGoodsList),
%% %% 	if
%% %% 		WrongBaseGoodsList =/= [] ->
%% %% 			io:format("check_table_base_holiday_goods, WrongBaseGoodsList:~p~n", [WrongBaseGoodsList]);
%% %% 		true ->
%% %% 			skip
%% %% 	end,
%% %% 	ok.
%% %% 	
%% %% 						
%% %% 				  
%% %% %%检查配置数据, 仅用于辅助检查配置数据
%% %% check_table_base_goods() ->
%% %% 	BaseGoodsList = ets:tab2list(?ETS_BASE_GOODS),
%% %% 	F = fun(BaseGoods, Acc) ->
%% %% 				if
%% %% 					BaseGoods#ets_base_goods.icon =< 0  andalso BaseGoods#ets_base_goods.type =/= 21 ->
%% %% 						[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 					BaseGoods#ets_base_goods.type =:= 10 ->
%% %% 						BaseSuit = get_base_goods_suit(BaseGoods#ets_base_goods.stid),
%% %% 						if
%% %% 							BaseGoods#ets_base_goods.stid > 0 andalso BaseSuit =:= [] ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 							true ->
%% %% 								Atbt = BaseGoods#ets_base_goods.atbt,
%% %% 								if
%% %% 									is_list(Atbt) ->
%% %% 										WrongData = [{Type, Num}||{Type, Num}<-Atbt, Type < 1 orelse Type > 19 orelse Num =< 0 ],
%% %% 										if
%% %% 											WrongData =/= [] ->
%% %% 												[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 											true ->
%% %% 												Acc
%% %% 										end;
%% %% 									true ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 								end
%% %% 						end;
%% %% 					BaseGoods#ets_base_goods.type =:= 11 andalso BaseGoods#ets_base_goods.stype =:= 4 ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						case OtherData of
%% %% 							[exp, Num] ->
%% %% 								if
%% %% 									Num > 0 ->
%% %% 										Acc;
%% %% 									true ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 								end;
%% %% 							_ ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					(BaseGoods#ets_base_goods.type =:= 11 andalso (BaseGoods#ets_base_goods.stype =:= 5 orelse BaseGoods#ets_base_goods.stype =:= 6)) 
%% %% 					  orelse (BaseGoods#ets_base_goods.type =:= 20 andalso (BaseGoods#ets_base_goods.stype =:= 1 orelse BaseGoods#ets_base_goods.stype =:= 2)) ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						if
%% %% 							is_list(OtherData) ->
%% %% 								NoGoods = [GoodsTypeId||{GoodsTypeId,Num}<-OtherData, goods_util:get_base_goods(GoodsTypeId)=:=[] orelse Num =< 0 ],
%% %% 								if
%% %% 									NoGoods =/= [] ->						%%没有对应物品，错了
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 									true ->
%% %% 										Acc
%% %% 								end;
%% %% 							true ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					BaseGoods#ets_base_goods.type =:= 27 andalso BaseGoods#ets_base_goods.stype =:= 1 ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						case OtherData of
%% %% 							[buff,vip_card,[{viplv,VipLv}],Time] ->
%% %% 								if
%% %% 									VipLv > 0 andalso Time > 0 ->
%% %% 										Acc;
%% %% 									true ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 								end;
%% %% 							_ ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					BaseGoods#ets_base_goods.type =:= 28 andalso BaseGoods#ets_base_goods.stype =:= 2 ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						case OtherData of
%% %% 							[creat_pet,BasePetId] ->
%% %% 								case lib_pet2:get_base_pet(BasePetId) of
%% %% 									[] ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 									_ ->
%% %% 										Acc
%% %% 								end;
%% %% 							_ ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					BaseGoods#ets_base_goods.type =:= 45 ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						if
%% %% 							is_list(OtherData) ->
%% %% 								NoGoods = [GoodsTypeId||{GoodsTypeId,_, MinNum, MaxNum}<-OtherData, goods_util:get_base_goods(GoodsTypeId)=:=[] orelse MinNum =< 0 orelse MaxNum =< 0 orelse MinNum > MaxNum],
%% %% 								TotalRatio = lists:sum([Ratio||{_, Ratio, _, _}<-OtherData]),
%% %% 								if
%% %% 									NoGoods =/= [] orelse TotalRatio =/= 10000 ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 									true ->
%% %% 										Acc
%% %% 								end;
%% %% 							true ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					BaseGoods#ets_base_goods.type =:= 46 ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						if
%% %% 							is_list(OtherData) ->
%% %% 								CharList = [mxhp,ddge,blck,crit,hit,dpwr,dtech,dmgc,mana,apwr,atech,amgc,speed],
%% %% 								WrongData = [{Type, Num}||{Type, Num}<-OtherData, lists:member(Type, CharList)=:= false orelse Num =< 0],
%% %% 								if
%% %% 									WrongData =/= [] ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 									true ->
%% %% 										Acc
%% %% 								end;
%% %% 							true ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					BaseGoods#ets_base_goods.type =:= 48 ->
%% %% 						OtherData = util:string_to_term(binary_to_list(BaseGoods#ets_base_goods.other_data)),
%% %% 						if
%% %% 							is_list(OtherData) ->
%% %% 								case OtherData of
%% %% 									[creat_giant,GiantTypeId] ->
%% %% 										case lib_giant_s:getBaseGiantInfo(GiantTypeId) of
%% %% 											[] ->
%% %% 												[BaseGoods#ets_base_goods.gtid|Acc];
%% %% 											_ ->
%% %% 												Acc
%% %% 										end;
%% %% 									_ ->
%% %% 										[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 								end;
%% %% 							true ->
%% %% 								[BaseGoods#ets_base_goods.gtid|Acc]
%% %% 						end;
%% %% 					true ->
%% %% 						Acc
%% %% 				end
%% %% 		end,
%% %% 	WrongBaseGoodsList = lists:foldl(F, [], BaseGoodsList),
%% %% 	if
%% %% 		WrongBaseGoodsList =/= [] ->
%% %% 			io:format("check_table_base_goods, WrongBaseGoodsList:~p~n", [WrongBaseGoodsList]);
%% %% 		true ->
%% %% 			skip
%% %% 	end,
%% %% 	ok.
%% %% 								
