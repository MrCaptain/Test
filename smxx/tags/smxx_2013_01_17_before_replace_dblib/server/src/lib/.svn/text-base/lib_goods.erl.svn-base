%%%--------------------------------------
%%% @Module  : lib_goods
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description : 物品信息
%%%--------------------------------------
-module(lib_goods).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).
%% -export(
%%     [
%%         add_goods/1,
%% %% 		add_attribute_by_type/1,
%%         add_goods_attribute/4,
%% 		add_goods_attribute/5,
%%         mod_goods_attribute/2,
%%         del_goods_attribute/1,
%%         del_goods_attribute/3,
%% 		del_goods_attribute/4,
%%         pay_goods/4,
%% 		multi_pay_goods/3,
%% 		multi_get_goods/3,
%%         sell_goods/4,
%% 		buyBackGoods/4,
%%         equip_goods/5,
%% 		equip_goods_giant/4,
%%         unequip_goods/3,
%% 		unequip_goods_giant/2,
%%         drag_goods/5,
%% 		drag_goods_15044/5,
%%         use_goods/3,
%%         delete_more/3,
%% 		delete_more/4,
%%         delete_one/3,
%%         delete_type_goods/2,
%%         movein_bag/5,
%%         moveout_bag/5,
%%         extend/4,
%%         mend_goods/3,
%%         clean_bag/3,
%%         give_goods/2,
%% 		give_task_goods/2,
%%         add_goods_base/3,
%%         add_goods_base/4,
%%         add_goods_base/5,
%% 		add_task_goods_base/5,
%%         update_overlap_goods/2,
%%         add_overlap_goods/2,
%%         add_nonlap_goods/2,
%%         attrit_equip/2,
%%         cost_money/4,
%% 		add_money/4,
%% 		add_money_vip/3,
%% 		add_only_money_vip/3,
%%         delete_role/1,
%% 		mod_goods_attribute_by_name/2,
%% 		update_goods_buff/1,
%% 		update_goods_buff/2,
%% 		do_logout/1,
%% 		destruct/4,
%% 		cd_check/2,
%% 		change_mount_status/2,
%% 		force_off_mount/1,
%% 		delete_goods/1,
%% 		change_goods_num/2,
%%         goods_find/2,
%% 		stren_count_status/2,
%% 		add_new_goods_by_mail/6,
%% 		is_enough_backpack_cell/3,
%% 		delete_task_more/3,
%% 		delete_task_one/3,
%% 		mod_goods_otherdata/2,
%% 		cd_add/2,
%% 		cd_add_ets/2,
%% 		get_goods_info_from_db/2,
%% 		active_csj_card/2,
%% 		check_goods_diff/1,
%% 		goods_buff_trans_to_proto/1,
%% 		useHpPackAct/1,
%% 		hpPack_goods_find/1,
%% 		check_compose_material/2,
%% 		check_compose_material/3,
%% 		check_compose_material_vip/2,
%% 		check_compose_material_vip/3,
%% 		check_refine_material/4,
%% 		delete_compose_material/2,
%% 		stuff_compose/2,
%% 		euqit_compose/3,
%% 		equip_refine/1,
%% 		check_essence/2,
%% 		check_essence_shop/3,
%% 		pay_essence/2,
%% 		open_hole/5,
%% 		cyt_compose/6,
%% 		cyt_chg_type/5,
%% 		cyt_handler/6,
%% 		buy_pet_goods/3,
%% 		get_suit_all_equip/1,
%% 		get_equip_compose_info/2,
%% 		player_add_goods_1/3,
%% 		player_add_goods_2/3,
%% 		player_add_goods_3/4,
%% 		add_virtual_goods/3,
%% 		chk_player_add_goods_3/2,
%% 		check_arena_shop/2,
%% 		split_goods/1,
%% 		get_buy_back_goods_list/1,
%% 		check_time_goods/1,
%% 		get_player_level_gift_info/1,
%% 		send_goods_eprt_notice/2,
%% 		add_get_goods_log/4,
%% 		add_cost_goods_log/3,
%% 		public_add_get_goods_log/4
%% 	]).
%% 
%% 
%% %% 保存物品信息
%% %% @spec set_goods_info(GoodsId, Field, Data) -> ok
%% %set_goods_info(GoodsId, Field, Data) ->
%% %    db_agent:set_goods_info(GoodsId, Field, Data),
%% %    ok.
%% 
%% 
%% %%注意！！不能外部调用，添加新类型物品应用 add_goods_base
%% %% 添加新物品信息 
%% add_goods(GoodsInfo) ->
%% %%io:format("~s add_goods___________________________[~p]\n",[misc:time_format(now()), GoodsInfo#goods.atbt]),
%% %% 	GoodsInfo = goods_util:chk_new_equit_goods(GoodsInfoT),
%% 	case db_agent:add_goods(GoodsInfo) of
%% 		{mongo,Ret} ->
%% 			NewGoodsInfo = GoodsInfo#goods{id = Ret};
%% 		_Ret ->
%%     		NewGoodsInfo = goods_util:get_add_goods(GoodsInfo#goods.uid,
%% 											GoodsInfo#goods.gtid,
%% 											GoodsInfo#goods.loc,
%% 											GoodsInfo#goods.cell,
%% 											GoodsInfo#goods.num)
%% 	end,
%% 	ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     NewGoodsInfo.	
%% %% 
%% %% %% @spec add_goods(PlayerId, Cell, Num, Location, GoodsTypeInfo) -> GoodsInfo
%% %% add_goods(GoodsInfo) ->
%% %%     add_goods(GoodsInfo,[]).
%% %% %%AttributeList = {attribute_id,identify}
%% %% add_goods(GoodsInfo,AttributeList) ->
%% %% 	io:format("~s add_goods[~p]\n",[misc:time_format(now()), AttributeList]),
%% %% 
%% %% 	io:format("~s add_goods[~p]\n",[misc:time_format(now()), GoodsInfo]),
%% %% 	NewGoodsInfo_1 =
%% %%     	case is_record(GoodsInfo, goods) of
%% %%         	true ->
%% %% 				Add_AttbuteList =
%% %% 					case length(AttributeList) > 0 of
%% %% 						true ->
%% %% 							%%获取固定附加属性
%% %% 							add_attribute_by_attribute_id(GoodsInfo,AttributeList);
%% %% 						false ->
%% %% 							%%获取多个附加属性
%% %%             				add_attribute_by_type(GoodsInfo)
%% %% 					end,
%% %% io:format("~s Add_AttbuteList@@@@@@@@@@@@@@@@@@@@@@[~p]\n",[misc:time_format(now()), Add_AttbuteList]),
%% %% 				GoodsInfo#goods{atbt = Add_AttbuteList};
%% %%         	false -> skip
%% %%     	end,
%% %% 	case db_agent:add_goods(NewGoodsInfo_1) of
%% %% 		{mongo,Ret} ->
%% %% 			NewGoodsInfo = GoodsInfo#goods{id = Ret};
%% %% 		_Ret ->
%% %%     		NewGoodsInfo = goods_util:get_add_goods(NewGoodsInfo_1#goods.uid,
%% %% 											NewGoodsInfo_1#goods.gtid,
%% %% 											NewGoodsInfo_1#goods.loc,
%% %% 											NewGoodsInfo_1#goods.cell,
%% %% 											NewGoodsInfo_1#goods.num)
%% %% 	end,
%% %% 	ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%% %%     NewGoodsInfo.
%% 
%% %% %% 返回附加属性列表     
%% %% add_attribute_by_type(GoodsInfo) ->
%% %% io:format("~s add_attribute_by_type[~p]\n",[misc:time_format(now()), {is_record(GoodsInfo,goods), GoodsInfo#goods.qly, GoodsInfo#goods.type}]),	
%% %%      if is_record(GoodsInfo,goods) andalso GoodsInfo#goods.type =:= 10->
%% %% 			Pattern = #ets_base_goods_add_attribute{ gtid=GoodsInfo#goods.gtid, _='_' },
%% %% 			io:format("~s add_goods111[~p]\n",[misc:time_format(now()), test]),
%% %%             %%获取某goods_id 物品添加的所有属性 类型值
%% %%             AttributeList = goods_util:get_ets_list(?ETS_BASE_GOODS_ADD_ATTRIBUTE, Pattern),
%% %% 			io:format("~s add_goods222[~p]\n",[misc:time_format(now()), AttributeList]),
%% %% 			if
%% %% 				length(AttributeList) > 0 ->
%% %% 					goods_util:get_add_attribute_by_type(AttributeList);
%% %% %%             		[add_base_attribute(GoodsInfo, AttributeInfo) || AttributeInfo <- AttributeList ];
%% %% 				true ->
%% %% 					[]
%% %% 			end;
%% %%          true -> 
%% %% 			 []
%% %%      end.
%% 
%% %% %%添加固定附加属性 AttidList = [id,id]
%% %% add_attribute_by_attribute_id(GoodsInfo,AttidList) ->
%% %% 	F = fun({Attid, _Identify}) ->
%% %% 			Pattern = #ets_base_goods_add_attribute{ gtid=GoodsInfo#goods.gtid,color=GoodsInfo#goods.qly,id = Attid, _='_' },
%% %%     		AttributeInfo = goods_util:get_ets_info(?ETS_BASE_GOODS_ADD_ATTRIBUTE, Pattern),
%% %% 			if
%% %% 				is_record(AttributeInfo,ets_base_goods_add_attribute) ->
%% %% 					%%NewAttributeInfo = AttributeInfo#ets_base_goods_add_attribute{identify = Identify},
%% %% 					add_base_attribute(GoodsInfo,AttributeInfo);
%% %% 				true ->
%% %% 					skip
%% %% 			end
%% %% 		end,
%% %% 	lists:foreach(F, AttidList).
%% 
%% %% 添加附加属性
%% add_base_attribute(GoodsInfo, BaseAttributeInfo) ->
%% 	%%io:format("~s add_base_attribute________________[~p]\n",[misc:time_format(now()), BaseAttributeInfo]),
%%      %%类型值的效果值
%%      Effect = goods_util:get_add_attribute_by_type(BaseAttributeInfo),
%% %% 	 Status = 0,
%% 	%%	 case BaseAttributeInfo#ets_base_goods_add_attribute.identify of
%% 	%%		 0 -> 1; %% 0 不需要鉴定 = 1已鉴定
%% 	%%		 1 -> 0; %% 1 要鉴定 = 0 没鉴定
%% 	%%		 _ -> 0
%% 	%%	 end,
%% %% 	 Effect2 = [Status|Effect],
%%      %%将效果添加到物品
%% 	 AttributeType = 
%% 		 case GoodsInfo#goods.stype =:= 24 of
%% 			 true -> 6;
%% 			 false -> 1
%% 		 end,		 
%%      add_goods_attribute(GoodsInfo, AttributeType, BaseAttributeInfo#ets_base_goods_add_attribute.id, Effect).
%% 
%% %%关键函数！！
%% %% 把属性添加到goods_attribute 表 。添加的属性类型 1附加 2强化+7加成 3镶嵌4防具强化抗性加成5强化+8攻击加成 6时装洗炼属性
%% %% 添加装备属性valueType 暂时不用
%% %%Effect情况	1：Effect长度为13 2：Effect长度为14用于附加属性 3：effect长度18镶嵌
%% %%Effect效果可额外增加，判断长度即可。
%% add_goods_attribute(GoodsInfo, AttributeType, AttributeId, Effect) ->
%% 	add_goods_attribute(GoodsInfo,AttributeType,AttributeId,Effect,0),
%% 	ok.
%% add_goods_attribute(GoodsInfo, AttributeType, AttributeId, Effect, _ValueType) ->
%% %%	?DEBUG("lib_goods/add_goods_attribute/effect/~p",[Effect]),
%% 	%%io:format("~s add_goods_attribute_______1111111111________________[~p]\n",[misc:time_format(now()), length(Effect)]),
%% 	AttributeInfo =
%% 		case length(Effect) of
%% 			16 ->
%% 				%%常用添加属性
%% 				[Mxhp, Pwr,Tech, Mgc, Hit, Crit, Ddge, Blck, Mnup, Agup, Dpwr, Dtech, Dmgc, Apwr, Atech, Amgc] = Effect,
%% 				case db_agent:add_goods_attribute(GoodsInfo, AttributeType, AttributeId, Mxhp, Pwr,
%% 												  Tech, Mgc, Hit, Crit, Ddge, Blck, Mnup, Agup,
%% 												  Dpwr, Dtech, Dmgc, Apwr, Atech, Amgc) of
%% 					{mongo,GoodsAttribute,Ret} ->
%% 						GoodsAttribute#goods_attribute{id=Ret};
%% 					_Ret ->
%% 						goods_util:get_add_goods_attribute(GoodsInfo#goods.uid, GoodsInfo#goods.id, AttributeType, AttributeId)
%% 				end;
%% 			_ ->
%% 			error
%% 		end,  
%%    
%% %%	?DEBUG("lib_goods/add_goods_attribute/attributeinfo/~p",[AttributeInfo]),
%%     if is_record(AttributeInfo, goods_attribute) ->		   
%%             %%回写到ets，同步装备属性
%%             ets:insert(?ETS_GOODS_ATTRIBUTE, AttributeInfo);
%%         true -> skip
%%     end,
%% 	ok.
%% 
%% %% 修改装备属性
%% mod_goods_attribute(AttributeInfo, Effect) ->
%%     [Mxhp, Pwr, Tech, Mgc, Hit, Crit, Ddge, Blck, Cter, Mnup, Agup, Dpwr, Dtech, Dmgc, Apwr, Atech, Amgc] = Effect,
%%     db_agent:mod_goods_attribute(AttributeInfo, Mxhp, Pwr, Tech, Mgc, Hit, Crit, Ddge, Blck, Cter, Mnup, Agup, Dpwr, Dtech, Dmgc, Apwr, Atech, Amgc),
%%     NewAttributeInfo = AttributeInfo#goods_attribute{ mxhp=Mxhp, pwr=Pwr, tech=Tech, mgc = Mgc, hit=Hit, crit=Crit, ddge=Ddge, blck=Blck, cter=Cter, mnup=Mnup, agup=Agup, dpwr=Dpwr ,dtech=Dtech, dmgc=Dmgc, apwr=Apwr, atech=Atech, amgc=Amgc},
%% 	ets:insert(?ETS_GOODS_ATTRIBUTE, NewAttributeInfo),
%%     ok.
%% 
%% %% 由[name,value]的形式修改装备属性
%% mod_goods_attribute_by_name(AttributeInfo,[Attribute_name,Value]) ->	
%% 	NewAttributeInfo =
%% 	case Attribute_name of
%% 		ddge -> AttributeInfo#goods_attribute{ddge= Value};
%% 		%%dodge -> AttributeInfo#goods_attribute{dodge= Value};
%% 		%%crit -> AttributeInfo#goods_attribute{crit = Value};
%% 		%%physique -> AttributeInfo#goods_attribute{physique = Value};
%% 		%%forza -> AttributeInfo#goods_attribute{forza = Value};
%% 		%%agile -> AttributeInfo#goods_attribute{agile = Value};
%% 		%%wit -> AttributeInfo#goods_attribute{wit = Value};
%% 		_ ->AttributeInfo
%% 	end,
%% 	db_agent:mod_goods_attribute(NewAttributeInfo),
%% 	ets:insert(?ETS_GOODS_ATTRIBUTE, NewAttributeInfo),
%%     ok.
%% %% 删除装备属性
%% del_goods_attribute(PlayerId, GoodsId, AttributeType) ->
%%     db_agent:del_goods_attribute(PlayerId, GoodsId, AttributeType),
%%     Pattern = #goods_attribute{ uid=PlayerId, gid=GoodsId, atype=AttributeType, _='_'},
%%     ets:match_delete(?ETS_GOODS_ATTRIBUTE, Pattern),
%%     ok.
%% del_goods_attribute(PlayerId,GoodsId,AttributeType,AttributeId) ->
%% 	db_agent:del_goods_attribute(PlayerId, GoodsId, AttributeType,AttributeId),
%%     Pattern = #goods_attribute{ uid=PlayerId, id=GoodsId, atype=AttributeType,atid= AttributeId, _='_'},
%%     ets:match_delete(?ETS_GOODS_ATTRIBUTE, Pattern),
%%     ok.
%% %% 删除装备属性
%% del_goods_attribute(Id) ->
%%     db_agent:del_goods_attribute(Id),
%%     ets:delete(?ETS_GOODS_ATTRIBUTE, Id),
%%     ok.
%% 
%% %% 修改物品other_data数据 
%% mod_goods_otherdata(GoodsInfo,String) ->	
%% 	case is_record(GoodsInfo,goods) of
%% 		true ->
%% 			NewString = 
%% 				if
%% 					is_list(String) ->
%% 						String;
%% 					true ->
%% 						tool:to_list(String)
%% 				end,
%% 			NewGoodsInfo=GoodsInfo#goods{othdt = list_to_binary(NewString)},
%% 			ets:insert(?ETS_GOODS_ONLINE,NewGoodsInfo),
%% 			spawn(fun()->db_agent:mod_goods_otherdata(NewGoodsInfo#goods.id,NewString)end),
%% 			NewGoodsInfo;				
%% 		false ->
%% 			GoodsInfo
%% 	end.
%% 
%% %% 购买物品
%% %% @spec pay_goods(GoodsStatus, GoodsTypeInfo, GoodsNum) -> ok | Error
%% pay_goods(GoodsStatus, GoodsTypeInfo, GoodsList, GoodsNum) ->
%%     GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%     add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList).
%% 
%% %% 购买多个物品
%% %% @spec multi_pay_goods(GoodsStatus, GoodsTypeInfo, GoodsNum) -> ok | Error
%% multi_pay_goods(GoodsStatus, GoodsTypeInfo, GoodsNum) ->
%% 	GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%% 	add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo).
%% 
%% %% 获得多个物品
%% %% @spec multi_get_goods(GoodsStatus, GoodsTypeInfo, GoodsNum) -> ok | Error
%% multi_get_goods(GoodsStatus, GoodsTypeInfo, GoodsNum) ->
%% %% 	io:format("~s multi_get_goods1[~p] \n ",[misc:time_format(now()), 11111]),
%% 	GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%% %% 	io:format("~s multi_get_goods2[~p] \n ",[misc:time_format(now()), 22222]),
%% 	add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo).
%% 
%% %% 出售物品
%% %% @spec sell_goods(GoodsInfo, GoodsNum) -> ok | Error
%% sell_goods(PlayerStatus, Status, GoodsInfo, GoodsNum) ->
%% 	Amount1 = GoodsInfo#goods.spri * GoodsNum,
%% 	if GoodsInfo#goods.type =:= 10 andalso GoodsInfo#goods.stlv > 0 ->  %%强化过的装备要返还铜币
%% 		   case data_stren:get_stren_back_coin(GoodsInfo#goods.stlv, GoodsInfo#goods.stid) of
%% 			   StrCoin when is_integer(StrCoin) ->
%% 				   Amount = Amount1 + StrCoin;
%% 			   _ ->
%% 				   Amount = Amount1
%% 		   end;
%% 	   true ->
%% 		   Amount = Amount1
%% 	end,
%% 	NewPlayerStatus = lib_goods:add_money(PlayerStatus,Amount,coin,1504),
%% 	{ok, NewStatus, _NewNum} = lib_goods:delete_one(Status, GoodsInfo, GoodsNum),
%% %% 	SoldGoods = get(soldGoods),
%% %% 	if
%% %% 		SoldGoods =/= undefined ->
%% %% 			NewSoldGoods =
%% %% 				if
%% %% 					length(SoldGoods) < 15 ->
%% %% 						SoldGoods ++ [GoodsInfo];
%% %% 					true ->
%% %% 						[DumpGoods|LeftGoods] = SoldGoods,
%% %% 						ets:delete(?ETS_GOODS_ONLINE, DumpGoods#goods.id),
%% %% 						db_agent:delete_goods(DumpGoods#goods.id),
%% %% 						LeftGoods ++ [GoodsInfo]
%% %% 			end,
%% %% 			put(soldGoods, NewSoldGoods);
%% %% 		true ->
%% %% 			put(soldGoods, [GoodsInfo])
%% %% 	end,
%% %% 	NullCells = lists:sort([GoodsInfo#goods.cell|Status#goods_status.null_cells]),
%% %% 	NewStatus = Status#goods_status{ null_cells=NullCells },
%% %%     %% 删除物品 把ETS里面的loc改成10
%% %% 	NewGoodsInfo = GoodsInfo#goods{loc = 10},
%% %% 	ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     {ok, NewPlayerStatus, NewStatus}.
%% 
%% 
%% %% 回购物品
%% %% @spec buyBackGoods(PlayerStatus, Status, GoodsId, GoodsNum) -> ok | Error
%% buyBackGoods(PlayerStatus, Status, GoodsId, GoodsNum) ->
%% 	SoldGoods = get(soldGoods),
%% 	if
%% 		SoldGoods =/= undefined ->
%% 			ListBuy = [ M || M <- SoldGoods, M#goods.id =:= GoodsId andalso M#goods.num =:= GoodsNum],
%% 			if
%% 				length(ListBuy) =/=1 ->
%% 					[4, PlayerStatus, Status, 0, 0];
%% 				true ->
%% 					[GoodsInfo] = ListBuy,
%% 					Cost = GoodsInfo#goods.spri * GoodsNum,
%% 					case goods_util:is_enough_money(PlayerStatus,Cost,coin) of
%% 						true ->
%% 							
%% 							ListOther = [ M || M <- SoldGoods, M#goods.id =/= GoodsId ],
%% 							put(soldGoods, ListOther),
%% 							[NullCell|NewNullCells] = Status#goods_status.null_cells,
%% 							NewGoodsInfo = GoodsInfo#goods{cell = NullCell, loc = 4},
%% 							ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%% 							db_agent:change_goods_cell(4, NullCell, NewGoodsInfo#goods.id),
%% 							NewStatus = Status#goods_status{ null_cells=NewNullCells },
%% 							if
%% 								GoodsInfo#goods.stlv >= 25 
%% %% 								  orelse (GoodsInfo#goods.gtid >= 132002 andalso GoodsInfo#goods.gtid =< 132004) 
%% 								  orelse GoodsInfo#goods.type =:= 46 ->
%% 									spawn(fun()->db_log_agent:log_goods_handle([PlayerStatus#player.id,
%% 																				GoodsInfo#goods.id,
%% 																				GoodsInfo#goods.gtid,
%% 																				GoodsInfo#goods.num,
%% 																				1])end);
%% 								true ->
%% 									skip
%% 							end,
%% 							NewPlayerStatus = cost_money(PlayerStatus, Cost, coin, 1524),
%% 							[1, NewPlayerStatus, NewStatus, NewGoodsInfo#goods.gtid, NewGoodsInfo#goods.cell];
%% 						_ ->
%% 							[6, PlayerStatus, Status, 0, 0]
%% 					end
%% 			end;
%% 		true ->
%% 			[4, PlayerStatus, Status, 0, 0]
%% 	end.
%% 
%% %%装备物品(liujing 2012-10 change)
%% %% @spec equip_goods(PlayerId, GoodsInfo) -> {ok, 1, Effect} | Error
%% equip_goods(PlayerStatus, Status, GoodsInfo, Location, Cell) ->
%% 	OldGoodsInfo = goods_util:get_goods_by_cell(PlayerStatus#player.id, Location, Cell),
%% 	%%io:format("~s equip_goods_______________________[~p]\n",[misc:time_format(now()), {OldGoodsInfo,Cell}]),
%% 	case is_record(OldGoodsInfo, goods) of
%% 		%% 存在已装备的物品，则替换
%% 		true ->
%% 			%%空格
%% 			NullCells = lists:sort([GoodsInfo#goods.cell | Status#goods_status.null_cells]),
%% 			[OldGoodsCell|NullCells2] = NullCells,
%% 			%%卸下物品 原来已经装备的物品 OldGoodsInfo ,OldGoodsCell为原来已经装备的物品卸下的位置
%% 			NewOldGoodsInfo = change_goods_cell(OldGoodsInfo, 4, OldGoodsCell),
%% 			%%装上需要的物品
%% 			NewGoodsInfo = change_goods_cell(GoodsInfo, Location, Cell),
%% 			%%如果是套装的要处理
%% 			EquipSuit = goods_util:change_equip_suit(Status#goods_status.equip_suit, OldGoodsInfo#goods.stid, GoodsInfo#goods.stid),
%% 			%%空格子为NullCells2
%% 			NewStatus = Status#goods_status{ null_cells=NullCells2, equip_suit=EquipSuit };
%% 		%% 不存在
%% 		false ->
%% 			NewOldGoodsInfo = OldGoodsInfo,
%% 			%%直接装上吧
%% 			NewGoodsInfo = change_goods_cell(GoodsInfo, Location, Cell),
%% 			%%装上就多了一个空间了
%% 			NullCells = lists:sort([GoodsInfo#goods.cell | Status#goods_status.null_cells]),
%% 			EquipSuit = goods_util:change_equip_suit(Status#goods_status.equip_suit, 0, GoodsInfo#goods.stid),
%% 			NewStatus = Status#goods_status{ null_cells=NullCells, equip_suit=EquipSuit}
%% 	end,
%% 	SuitID = goods_util:is_full_suit(EquipSuit),
%% 	Effect = goods_util:get_equip_attribute(PlayerStatus#player.id),  %% NewStatus#goods_status.equip_suit),
%% 	%% 武器的强化等级记录到player
%% 	NewPlayerStatus = 
%% 		if
%% 			NewGoodsInfo#goods.type =:= 10 andalso NewGoodsInfo#goods.stype =:= 4 ->  %%衣服
%% 				Img = goods_util:get_equip_img(NewGoodsInfo),   %%data_player:get_img(NewGoodsInfo#goods.lv),
%% 				FashImg = goods_util:get_fash_img(PlayerStatus),    %%获取人物的时装形象，兼容新版幻化珠装备,
%% 				NowImg = goods_util:get_player_now_img(Img, FashImg, PlayerStatus#player.other#player_other.fash_flag),
%% 				if PlayerStatus#player.img =:= NowImg ->  %%形象有无改变
%% 					   PlayerStatus#player{other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}};
%% 				   true ->
%% 					   {ok, BinData} = pt_13:write(13080,[PlayerStatus#player.id,
%% 														  PlayerStatus#player.sex,
%% 														  PlayerStatus#player.crr,
%% 														  NowImg,
%% 														  PlayerStatus#player.mnt_sts,
%% 														  PlayerStatus#player.other#player_other.maskId]),
%% 					   mod_scene_agent:send_to_scene(PlayerStatus#player.scn, BinData),
%% 					   PlayerStatus#player{img = NowImg, other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}}
%% 				end;
%% 			NewGoodsInfo#goods.type =:= 10 andalso NewGoodsInfo#goods.stype =:= 20 ->  %%时装，兼容新版幻化珠装备,
%% 				FashImg = goods_util:get_equip_img(NewGoodsInfo),
%% 				Img = goods_util:get_normal_img(PlayerStatus),
%% 				NowImg = goods_util:get_player_now_img(Img, FashImg, PlayerStatus#player.other#player_other.fash_flag),
%% 				if PlayerStatus#player.img =:= NowImg ->
%% 					   PlayerStatus#player{other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}};
%% 				   true ->
%% 					   {ok, BinData} = pt_13:write(13080,[PlayerStatus#player.id,
%% 														  PlayerStatus#player.sex,
%% 														  PlayerStatus#player.crr,
%% 														  NowImg,
%% 														  PlayerStatus#player.mnt_sts,
%% 														  PlayerStatus#player.other#player_other.maskId]),
%% 					   mod_scene_agent:send_to_scene(PlayerStatus#player.scn, BinData),
%% 					   PlayerStatus#player{img = NowImg, other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect }}
%% 				end;
%% 			true ->
%% 				PlayerStatus#player{other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect }}
%% 		end,
%% 	%%io:format("~s equip_goods_NewGoodsInfo2[~p]\n",[misc:time_format(now()), NewOldGoodsInfo]),
%% 	{ok, NewPlayerStatus, NewStatus, NewOldGoodsInfo, ok}.
%% 
%% %%卸下装备
%% %% @spec unequip_goods(PlayerId, Cell, GoodsInfo, GoodsTab) -> {ok, 1, [HP, MP, Attack, Defense, Strengh, Physique, Agility]}
%% unequip_goods(PlayerStatus, Status, GoodsInfo) ->
%% 	%%取一个空格
%% 	[Cell|NullCells] = Status#goods_status.null_cells,
%% 	NewGoodsInfo = change_goods_cell(GoodsInfo, 4, Cell),
%% 	%% 检查是否是武器、衣服
%% 	%%  [Wq, Yf, Zq] = Status#goods_status.equip_current,
%% 	%%  if  NewGoodsInfo#goods.stype =:= 10 ->
%% 	%%          CurrentEquip = [0, Yf, Zq];
%% 	%%      NewGoodsInfo#goods.stype =:= 24 ->
%% 	%%          CurrentEquip = [Wq, 0, Zq];
%% 	%%      true ->
%% 	%%         CurrentEquip = [Wq, Yf, Zq]
%% 	%%  end,
%% 	EquipSuit = goods_util:change_equip_suit(Status#goods_status.equip_suit, GoodsInfo#goods.stid, 0),
%% 	NewStatus = Status#goods_status{ null_cells=NullCells, equip_suit=EquipSuit},
%% 	
%% 	SuitID = goods_util:is_full_suit(EquipSuit),
%% 	Effect = goods_util:get_equip_attribute(PlayerStatus#player.id), %% EquipSuit),
%% 	%% 武器的强化等级记录到player
%% 	if
%% 		NewGoodsInfo#goods.type =:= 10 andalso NewGoodsInfo#goods.stype =:= 4 ->
%% 			Img = 0,
%% 			FashImg = goods_util:get_fash_img(PlayerStatus),    %%获取人物的时装形象，兼容新版幻化珠装备,
%% 			NowImg = goods_util:get_player_now_img(Img, FashImg, PlayerStatus#player.other#player_other.fash_flag),
%% 			if PlayerStatus#player.img =:= NowImg ->  %%形象有无改变
%% 				   NewPlayerStatus = PlayerStatus#player{other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect }};
%% 			   true ->
%% 				   NewPlayerStatus = PlayerStatus#player{img = NowImg, other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}},
%% 				   {ok, BinData} = pt_13:write(13080,[NewPlayerStatus#player.id, 
%% 													  NewPlayerStatus#player.sex, 
%% 													  NewPlayerStatus#player.crr, 
%% 													  NewPlayerStatus#player.img, 
%% 													  NewPlayerStatus#player.mnt_sts,
%% 													  NewPlayerStatus#player.other#player_other.maskId]),
%% 				   mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData)
%% 			end;
%% 		NewGoodsInfo#goods.type =:= 10 andalso NewGoodsInfo#goods.stype =:= 20 ->  %%时装，兼容新版幻化珠装备,
%% 			FashImg = 0,
%% 			Img = goods_util:get_normal_img(PlayerStatus),
%% 			NowImg = goods_util:get_player_now_img(Img, FashImg, PlayerStatus#player.other#player_other.fash_flag),
%% 			%% 			if Img =< 0 ->
%% 			%% 				   NewPlayerStatus = PlayerStatus#player{img = 0, other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect }};
%% 			%% 			   true ->
%% 			%% 				   NewPlayerStatus = PlayerStatus#player{img = Img, other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}}
%% 			%% 			end,
%% 			if PlayerStatus#player.img =:= NowImg ->  %%形象有无改变
%% 				   NewPlayerStatus = PlayerStatus#player{other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}};
%% 			   true ->
%% 				   NewPlayerStatus = PlayerStatus#player{img = NowImg, other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}},
%% 				   {ok, BinData} = pt_13:write(13080,[NewPlayerStatus#player.id, 
%% 													  NewPlayerStatus#player.sex, 
%% 													  NewPlayerStatus#player.crr, 
%% 													  NewPlayerStatus#player.img, 
%% 													  NewPlayerStatus#player.mnt_sts,
%% 													  NewPlayerStatus#player.other#player_other.maskId]),
%% 				   mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData)
%% 			end;
%% 		true ->
%% 			NewPlayerStatus = PlayerStatus#player{other=PlayerStatus#player.other#player_other{suitid=SuitID, equip_attribute = Effect}}
%% 	end,
%% 	{ok, NewPlayerStatus, NewStatus, NewGoodsInfo}.
%% 
%% 
%% %%巨兽装备物品, 更新此物品信息
%% equip_goods_giant(Status, GoodsInfo, Location, Cell) ->
%%     %%直接装上吧
%%     NewGoodsInfo = change_goods_cell(GoodsInfo, Location, Cell),							%%修改物品的格位
%%     %%装上就多了一个空间了
%%     NullCells = lists:sort([GoodsInfo#goods.cell | Status#goods_status.null_cells]),		%%重新整理物品的空格位
%%     NewStatus = Status#goods_status{ null_cells=NullCells},
%%     {ok, NewStatus, NewGoodsInfo}.
%% 
%% %%巨兽卸下物品
%% unequip_goods_giant(Status, GoodsInfo) ->
%%     %%取一个空格
%%     [Cell|NullCells] = Status#goods_status.null_cells,
%%     NewGoodsInfo = change_goods_cell(GoodsInfo, 4, Cell),									%%修改物品的格位
%% 	NewStatus = Status#goods_status{ null_cells=NullCells},									%%重新整理物品的空格位
%%     {ok, NewStatus, NewGoodsInfo}.
%% 
%% %% 强化过后人物属性的处理
%% %% 此函数必须在人物进程中调用
%% %% Res 强化结果 
%% stren_count_status(Res, PlayerStatus) ->
%% 	if
%% 		Res =:= 1 ->
%% %% 			MeridianInfo = get(player_meridian),
%% 			NewPlayerStatus = lib_player:count_player_attribute(PlayerStatus),
%% 			NewPlayerStatus;
%% %% 			if
%% %% 				PlayerStatus#player.hp =/= NewPlayerStatus#player.hp orelse PlayerStatus#player.mxhp =/= NewPlayerStatus#player.mxhp ->
%% %% 					NewPlayerStatus_1 = useHpPackAct(NewPlayerStatus), 
%% %% 					spawn(fun()->lib_player:send_player_attribute2(NewPlayerStatus_1, 3)end),
%% %% 					NewPlayerStatus_1;
%% %% 				true ->
%% %% 					NewPlayerStatus
%% %% 			end;
%% 		true ->
%% 			PlayerStatus
%% 	end.
%% 
%% %% 背包/仓库 拖动物品
%% %% @spec drag_goods(Status, GoodsInfo, OldCell, NewCell, Location) -> {ok, NewStatus, [OldCellId, OldTypeId, NewCellId, NewTypeId]}
%% drag_goods(Status, GoodsInfo, OldCell, NewCell, Location) ->
%%     OldGoodsInfo = goods_util:get_goods_by_cell(Status#goods_status.uid, Location, NewCell),
%%     case is_record(OldGoodsInfo, goods) of
%%         false ->
%%             %% 新位置没有物品
%%             change_goods_cell(GoodsInfo, Location, NewCell),
%% 			NewStatus = 
%% 				case Location of
%% 					4 ->
%%             			NullCells = lists:delete(NewCell, Status#goods_status.null_cells),
%%             			NullCells1 = lists:sort([OldCell|NullCells]),
%%             			Status#goods_status{ null_cells=NullCells1 };
%% 					_ ->
%%             			NullCells = lists:delete(NewCell, Status#goods_status.null_depot_cells),
%%             			NullCells1 = lists:sort([OldCell|NullCells]),
%%             			Status#goods_status{ null_depot_cells=NullCells1 }
%% 				end,
%%             OldCellId = 0,
%%             OldTypeId = 0,
%% 			OldNum = 0,
%%             NewCellId = GoodsInfo#goods.id,
%%             NewTypeId = GoodsInfo#goods.gtid,
%% 			NewNum = GoodsInfo#goods.num;
%%         true ->
%%             %% 新位置有物品
%% 			OldGoodsTypeInfo = goods_util:get_goods_type(OldGoodsInfo#goods.gtid),
%% 			if
%% 				OldGoodsInfo#goods.gtid =/= GoodsInfo#goods.gtid orelse OldGoodsTypeInfo#ets_base_goods.mxnum < 1 ->
%% 					%%物品类型不同或者不能叠加
%%             		change_goods_cell(GoodsInfo, Location, NewCell),
%%             		change_goods_cell(OldGoodsInfo, Location, OldCell),
%%             		NewStatus = Status,
%% 					OldNum = OldGoodsInfo#goods.num,
%% 					NewNum = GoodsInfo#goods.num,
%% 					OldCellId = OldGoodsInfo#goods.id,
%% 					OldTypeId = OldGoodsInfo#goods.gtid,
%% 					NewCellId = GoodsInfo#goods.id,
%% 					NewTypeId = GoodsInfo#goods.gtid;
%% 				true ->
%% 					if
%% 						OldGoodsInfo#goods.num =:= OldGoodsTypeInfo#ets_base_goods.mxnum ->
%% 							%%物品类型一样，新位置的物品的数量已达上限
%% 							NewStatus = Status,
%% 							OldNum = GoodsInfo#goods.num,
%% 							NewNum = OldGoodsInfo#goods.num;
%% 						OldGoodsInfo#goods.num + GoodsInfo#goods.num =< OldGoodsTypeInfo#ets_base_goods.mxnum ->
%% 							%%物品类型一样，且两物品可以完全堆成一叠
%% 							NewStatus = 
%% 								case Location of
%% 									4 ->
%% 										NullCells = Status#goods_status.null_cells,
%% 										NullCells1 = lists:sort([OldCell|NullCells]),
%% 										Status#goods_status{ null_cells=NullCells1 };
%% 									_ ->
%% 										NullCells = Status#goods_status.null_depot_cells,
%% 										NullCells1 = lists:sort([OldCell|NullCells]),
%% 										Status#goods_status{ null_depot_cells=NullCells1 }
%% 								end,
%% 							OldNum = 0,
%% 							NewNum = OldGoodsInfo#goods.num + GoodsInfo#goods.num,
%% 							change_goods_num(OldGoodsInfo, NewNum),
%% 							delete_goods(GoodsInfo#goods.id);
%% 						true ->
%% 							%%物品类型一样，且两物品可以不能完全堆成一叠
%% 							NewStatus = Status,
%% 							NewNum = OldGoodsTypeInfo#ets_base_goods.mxnum,
%% 							OldNum = OldGoodsInfo#goods.num + GoodsInfo#goods.num - NewNum,
%% 							change_goods_num(OldGoodsInfo, NewNum),
%% 							change_goods_num(GoodsInfo, OldNum)
%% 					end,
%% 					OldCellId = GoodsInfo#goods.id,
%% 					OldTypeId = GoodsInfo#goods.gtid,
%% 					NewCellId = OldGoodsInfo#goods.id,
%% 					NewTypeId = OldGoodsInfo#goods.gtid
%% 			end
%%     end,
%%     {ok, NewStatus, [OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum]}.
%% 
%% %% 背包/仓库 拖动物品
%% %% @spec drag_goods(Status, GoodsInfo, OldCell, NewCell, Location) -> {ok, NewStatus, [OldCellId, OldTypeId, NewCellId, NewTypeId]}
%% drag_goods_15044(Status, GoodsInfo, OldCell, NewCell, Location) ->
%% 	NewLocation = 
%% 		case Location of
%% 			4 ->
%% 				5;
%% 			_ ->
%% 				4
%% 		end,
%%     OldGoodsInfo = goods_util:get_goods_by_cell(Status#goods_status.uid, NewLocation, NewCell),
%%     case is_record(OldGoodsInfo, goods) of
%%         false ->
%%             %% 新位置没有物品
%%             change_goods_cell(GoodsInfo, NewLocation, NewCell),
%% 			NewStatus = 
%% 				case Location of
%% 					4 ->
%%             			NullCells_dep = lists:delete(NewCell, Status#goods_status.null_depot_cells),
%%             			NullCells_bag = lists:sort([OldCell|Status#goods_status.null_cells]),
%%             			Status#goods_status{ null_cells=NullCells_bag,  null_depot_cells=NullCells_dep};
%% 					_ ->
%%             			NullCells_bag = lists:delete(NewCell, Status#goods_status.null_cells),
%%             			NullCells_dep = lists:sort([OldCell|Status#goods_status.null_depot_cells]),
%%             			Status#goods_status{ null_cells=NullCells_bag,  null_depot_cells=NullCells_dep}
%% 				end,
%%             OldCellId = 0,
%%             OldTypeId = 0,
%% 			OldNum = 0,
%%             NewCellId = GoodsInfo#goods.id,
%%             NewTypeId = GoodsInfo#goods.gtid,
%% 			NewNum = GoodsInfo#goods.num;
%%         true ->
%%             %% 新位置有物品
%% 			OldGoodsTypeInfo = goods_util:get_goods_type(OldGoodsInfo#goods.gtid),
%% 			if
%% 				OldGoodsInfo#goods.gtid =/= GoodsInfo#goods.gtid orelse OldGoodsTypeInfo#ets_base_goods.mxnum < 1 ->
%% 					%%物品类型不同或者不能叠加
%%             		change_goods_cell(GoodsInfo, NewLocation, NewCell),
%%             		change_goods_cell(OldGoodsInfo, Location, OldCell),
%%             		NewStatus = Status,
%% 					OldNum = OldGoodsInfo#goods.num,
%% 					NewNum = GoodsInfo#goods.num,
%% 					OldCellId = OldGoodsInfo#goods.id,
%% 					OldTypeId = OldGoodsInfo#goods.gtid,
%% 					NewCellId = GoodsInfo#goods.id,
%% 					NewTypeId = GoodsInfo#goods.gtid;
%% 				true ->
%% 					if
%% 						OldGoodsInfo#goods.num =:= OldGoodsTypeInfo#ets_base_goods.mxnum ->
%% 							%%物品类型一样，新位置的物品的数量已达上限
%% 							NewStatus = Status,
%% 							OldNum = GoodsInfo#goods.num,
%% 							NewNum = OldGoodsInfo#goods.num;
%% 						OldGoodsInfo#goods.num + GoodsInfo#goods.num =< OldGoodsTypeInfo#ets_base_goods.mxnum ->
%% 							%%物品类型一样，且两物品可以完全堆成一叠
%% 							NewStatus = 
%% 								case Location of
%% 									4 ->
%% 										NullCells = Status#goods_status.null_cells,
%% 										NullCells1 = lists:sort([OldCell|NullCells]),
%% 										Status#goods_status{ null_cells=NullCells1 };
%% 									_ ->
%% 										NullCells = Status#goods_status.null_depot_cells,
%% 										NullCells1 = lists:sort([OldCell|NullCells]),
%% 										Status#goods_status{ null_depot_cells=NullCells1 }
%% 								end,
%% 							OldNum = 0,
%% 							NewNum = OldGoodsInfo#goods.num + GoodsInfo#goods.num,
%% 							change_goods_num(OldGoodsInfo, NewNum),
%% 							delete_goods(GoodsInfo#goods.id);
%% 						true ->
%% 							%%物品类型一样，且两物品可以不能完全堆成一叠
%% 							NewStatus = Status,
%% 							NewNum = OldGoodsTypeInfo#ets_base_goods.mxnum,
%% 							OldNum = OldGoodsInfo#goods.num + GoodsInfo#goods.num - NewNum,
%% 							change_goods_num(OldGoodsInfo, NewNum),
%% 							change_goods_num(GoodsInfo, OldNum)
%% 					end,
%% 					OldCellId = GoodsInfo#goods.id,
%% 					OldTypeId = GoodsInfo#goods.gtid,
%% 					NewCellId = OldGoodsInfo#goods.id,
%% 					NewTypeId = OldGoodsInfo#goods.gtid
%% 			end
%%     end,
%%     {ok, NewStatus, [OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum]}.
%% 
%% %% 使用物品
%% %% @spec use_goods(PlayerStatus, Status, GoodsInfo, GoodsNum) -> {ok, NewPlayerStatus, NewStatus1, NewNum}
%% use_goods(Status, GoodsInfo, GoodsNum) ->
%% 	lib_goods_use:use_goods(Status, GoodsInfo, GoodsNum).
%% 
%% 
%% %%添加长CD记录到ets
%% cd_add_ets(PlayerStatus,GoodsInfo) ->
%% 	case cd_check(PlayerStatus,GoodsInfo) of
%% 		{ok,Now} ->
%% 			Minute1 = lists:member(GoodsInfo#goods.gtid, [23000,23001,23002,23100,23101,23102,23009,23109]),
%% 			ExpireTime = 
%% 				if
%% 					Minute1 -> Now + 60;
%% 					true -> 
%% 						Now + 10
%% 				end,
%% 			NewCd = #ets_goods_cd{id= Now,uid = PlayerStatus#player.id, gtid = GoodsInfo#goods.gtid, eprtm = ExpireTime},
%% 			ets:insert(?ETS_GOODS_CD, NewCd);
%% 		{fail} ->
%% 			skip
%% 	end.
%% 
%% %%添加长CD记录到数据库		
%% cd_add(PlayerStatus,GoodsInfo) ->
%% 	case cd_check(PlayerStatus,GoodsInfo) of
%% 		{ok,Now} ->
%% 			Halfhour = lists:member(GoodsInfo#goods.gtid, [28200]),%% 28200回城石
%% 			Onehour = lists:member(GoodsInfo#goods.gtid, [28007,28008]),%% 28007 28008 功德丸
%% %% 			MinutePeach = lists:member(GoodsInfo#goods.goods_id, [23409, 23410,23411]),%% 蟠桃
%% 			ExpireTime = 
%% 				if
%% 					Halfhour -> Now +1800; %% 半小时
%% 					Onehour -> Now + 3600; %% 一小时
%% %% 					MinutePeach -> Now + 5; %%5秒
%% 					true ->
%% 						Now + 60
%% 				end,
%% 			case db_agent:add_new_goods_cd(PlayerStatus#player.id,GoodsInfo#goods.gtid,ExpireTime) of
%% 				{mongo,Ret} ->
%% 					NewCd = #ets_goods_cd{id= Ret,uid = PlayerStatus#player.id, gtid = GoodsInfo#goods.gtid, eprtm = ExpireTime};
%% 				_Ret ->
%% 					CdData = db_agent:get_new_goods_cd(PlayerStatus#player.id,GoodsInfo#goods.gtid),
%% 					NewCd = list_to_tuple([ets_goods_cd]++CdData)
%% 			end,
%% 			if
%% 				is_record(NewCd,ets_goods_cd) ->
%% 					ets:insert(?ETS_GOODS_CD, NewCd),
%% 					{ok};
%% 				true ->
%% 					skip
%% 			end;
%% 		{fail} ->
%% 			skip
%% 	end.
%% 
%% %%长cd检验
%% cd_check(PlayerStatus,GoodsInfo) ->
%% 	%%先删除过期的
%% 	del_goods_cd(PlayerStatus#player.id),
%% 	Now =util:unixtime(),
%% 	MS_cd = ets:fun2ms(fun(T) when T#ets_goods_cd.uid == PlayerStatus#player.id andalso T#ets_goods_cd.eprtm > Now  -> 
%% 			T 
%% 		end),
%% 	CdList = ets:select(?ETS_GOODS_CD, MS_cd),
%% 	F = fun(GCD,Flag) ->
%% 			CdType = GCD#ets_goods_cd.gtid div 100 ,
%% 			GoodsType = GoodsInfo#goods.gtid div 100 ,
%% 			if
%% 				%%功德丸特例
%% 				GCD#ets_goods_cd.gtid == 28007 andalso GoodsInfo#goods.gtid == 28008 ->
%% 					Flag;
%% 				GCD#ets_goods_cd.gtid == 28008 andalso GoodsInfo#goods.gtid == 28007 ->
%% 					Flag;
%% 				%%蟠桃特例(三种判断)
%% 				GCD#ets_goods_cd.gtid == 23409 
%% 				  andalso GoodsInfo#goods.gtid == 23410
%% 				  andalso GoodsInfo#goods.gtid == 23411->
%% 					Flag;
%% 				CdType == GoodsType ->
%% 					Flag +1;
%% 				true ->
%% 					Flag
%% 			end
%% 	end,
%% 	Ret = lists:foldl(F, 0, CdList),
%% 	if
%% 		Ret > 0 ->
%% 			{fail};
%% 		true ->
%% 			{ok,Now}
%% 	end.
%% 
%% %% 删除多个物品
%% %% @spec delete_more(Status, GoodsList, GoodsNum) -> {ok, NewStatus}
%% delete_more(Status, GoodsList, GoodsNum) ->
%%     GoodsList1 = goods_util:sort(GoodsList, cell),
%%     F1 = fun(GoodsInfo, [Num, Status1]) ->
%%             case Num > 0 of
%%                 true ->
%%                     {ok, NewStatus1, Num1} = delete_one(Status1, GoodsInfo, Num),
%%                     case Num1 > 0 of
%%                         true -> NewNum = 0;
%%                         false -> NewNum = Num - GoodsInfo#goods.num
%%                     end,
%%                     [NewNum, NewStatus1];
%%                 false ->
%%                     [Num, Status1]
%%             end
%%          end,
%% 
%%     [_, NewStatus] = lists:foldl(F1, [GoodsNum, Status], GoodsList1),	
%%     {ok, NewStatus}.
%% 
%% %% 删除多个物品（在仓库和背包中删除）
%% %% @spec delete_more(Status, GoodsList, GoodsNum) -> {ok, NewStatus}
%% delete_more(Status, GoodsList4, GoodsList5, GoodsNum) ->
%%     GoodsList41 = goods_util:sort(GoodsList4, cell),
%% 	GoodsList51 = goods_util:sort(GoodsList5, cell),
%% 	NewGoodsList = GoodsList41 ++ GoodsList51,
%%     F1 = fun(GoodsInfo, [Num, Status1]) ->
%%             case Num > 0 of
%%                 true ->
%%                     {ok, NewStatus1, Num1} = delete_one(Status1, GoodsInfo, Num),
%%                     case Num1 > 0 of
%%                         true -> NewNum = 0;
%%                         false -> NewNum = Num - GoodsInfo#goods.num
%%                     end,
%%                     [NewNum, NewStatus1];
%%                 false ->
%%                     [Num, Status1]
%%             end
%%          end,
%%     [_, NewStatus] = lists:foldl(F1, [GoodsNum, Status], NewGoodsList),	
%%     {ok, NewStatus}.
%% 
%% %% 删除多个任务物品
%% delete_task_more(GoodsStatus, GoodsList,GoodsNum) ->
%% 	  F1 = fun(GoodsInfo, Num) ->
%%             case Num > 0 of
%%                 true ->
%%                     {ok,Num1} = delete_task_one(GoodsStatus, GoodsInfo, Num),
%%                     case Num1 > 0 of
%%                         true -> NewNum = 0;
%%                         false -> NewNum = Num - GoodsInfo#goods.num
%%                     end,
%%                     NewNum;
%%                 false ->
%%                     Num
%%             end
%%          end,
%%     lists:foldl(F1,GoodsNum, GoodsList),
%%     {ok}.
%% 
%% %% 删除一个物品
%% %% @spec use_goods(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum) -> {ok, [HP, MP]}
%% delete_one(Status, GoodsInfo, GoodsNum) ->
%%     case GoodsInfo#goods.num > GoodsNum of
%%         true when GoodsInfo#goods.id >0 ->
%%             %% 部分使用
%%             NewNum = GoodsInfo#goods.num - GoodsNum,
%%             change_goods_num(GoodsInfo, NewNum),
%%             NewStatus = Status;
%%         false when GoodsInfo#goods.id >0 ->
%%             %% 全部使用
%%             NewNum = 0,
%%             delete_goods(GoodsInfo#goods.id),
%%             if  GoodsInfo#goods.loc == 4 ->
%%                     NullCells = lists:sort([GoodsInfo#goods.cell|Status#goods_status.null_cells]),
%%                     NewStatus = Status#goods_status{ null_cells=NullCells };
%%             	GoodsInfo#goods.loc == 5 ->
%%                     NullCells = lists:sort([GoodsInfo#goods.cell|Status#goods_status.null_depot_cells]),
%%                     NewStatus = Status#goods_status{ null_depot_cells=NullCells };
%% 				GoodsInfo#goods.loc == 1 ->
%% 					NewStatus = Status,
%% 					PGidT  = lib_player:get_player_pid(NewStatus#goods_status.uid),
%% 					gen_server:cast(PGidT, {'reflash_equip'});
%%                 true ->
%%                     NewStatus = Status
%%             end;
%%         _ ->
%%             NewNum = GoodsNum,
%%             NewStatus = Status
%%     end,
%% 	
%% %% 	case lists:member(GoodsInfo#goods.gtid, [320101, 320201, 330101, 330201, 400101, 390201, 340301, 
%% %% 											 350101, 350201, 380101, 380201, 380301, 340101]) of
%% %% 		true ->
%% %% 			spawn(fun()->db_log_agent:log_goods_handle([NewStatus#goods_status.uid,
%% %% 														GoodsInfo#goods.id,
%% %% 														GoodsInfo#goods.gtid,
%% %% 														GoodsInfo#goods.num,
%% %% 														4])end);
%% %% 		_ ->
%% %% 			skip
%% %% 	end,
%% 	
%% 	if 
%% 		NewNum =/= GoodsInfo#goods.num ->
%% 			NewGoods = GoodsInfo#goods{num = NewNum},
%% 			{ok, BinData1} = pt_50:write(50000, [NewGoods]),
%% 			lib_send:send_to_sid(NewStatus#goods_status.pid_send, BinData1);
%% %% 			PGid  = lib_player:get_player_pid(NewStatus#goods_status.uid),
%% %% 			io:format("~s delete_one___[~p]\~n",[misc:time_format(now()), BinData1]);
%% %% 			gen_server:cast(PGid, {send_to_sid, BinData1});
%% 		true ->
%% 			ok
%% 	end,
%% 			
%%     {ok, NewStatus, NewNum}.
%% 
%% %% 删除一个任务物品
%% delete_task_one(GoodsStatus, GoodsInfo,GoodsNum) ->
%% 	case GoodsInfo#goods.num > GoodsNum of
%%         true when GoodsInfo#goods.id >0 ->
%%             %% 部分使用
%%             NewNum = GoodsInfo#goods.num - GoodsNum,
%%             change_goods_num(GoodsInfo, NewNum);
%%         false when GoodsInfo#goods.id >0 ->
%%             %% 全部使用
%%             NewNum = 0,
%%             delete_goods(GoodsInfo#goods.id)
%%     end,
%% 	
%% 	if 
%% 		NewNum =/= GoodsInfo#goods.num ->
%% 			NewGoods = GoodsInfo#goods{num = NewNum},
%% 			{ok, BinData1} = pt_50:write(50000, [NewGoods]),
%% 			
%% 			PGid  = lib_player:get_player_pid(GoodsStatus#goods_status.uid),
%% 			gen_server:cast(PGid, {send_to_sid, BinData1});
%% 		true ->
%% 			ok
%% 	end,
%% 	
%%     {ok, NewNum}.
%% 
%% %% 删除一个任务物品
%% delete_plant_one(GoodsInfo,GoodsNum) ->
%% 	case GoodsInfo#goods.num > GoodsNum of
%%         true when GoodsInfo#goods.id >0 ->
%%             %% 部分使用
%%             NewNum = GoodsInfo#goods.num - GoodsNum,
%%             change_goods_num(GoodsInfo, NewNum);
%%         false when GoodsInfo#goods.id >0 ->
%%             %% 全部使用
%%             NewNum = 0,
%%             delete_goods(GoodsInfo#goods.id)
%%     end,
%%     {ok, NewNum}.
%% 
%% %% 删除一类物品
%% %% @spec delete_type_goods(GoodsTypeId, GoodsStatus) -> {ok, NewStatus} | Error
%% delete_type_goods(GoodsTypeId, GoodsStatus) ->
%%     GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 4),
%%     if length(GoodsList) > 0 ->
%%             TotalNum = goods_util:get_goods_totalnum(GoodsList),
%%             case (catch delete_more(GoodsStatus, GoodsList, TotalNum)) of
%%                 {ok, NewStatus} -> {ok, NewStatus};
%%                  Error -> {fail, Error, GoodsStatus}
%%             end;
%%         true ->
%%             {ok, GoodsStatus}
%%     end.
%% 
%% %%物品存入仓库
%% movein_bag(Status, GoodsInfo, GoodsNum, GoodsTypeInfo, Store_num) ->
%%     GoodsList = goods_util:get_goods_list(GoodsInfo#goods.uid, 5),
%% 	Store_count = length(GoodsList),
%% 	if 
%% 		Store_count >= Store_num ->
%% 			{fail, 0, 0, 0, full};
%% 		true ->
%% 			if 
%% 				GoodsNum =/= GoodsInfo#goods.num ->
%% 				%%仓库不支持部分存入
%% 					Cell = 0,
%% 					NewNum = 0,
%% 					NewId = 0,
%%             		NewStatus = Status;
%% 				true ->
%% 				%%全部存入
%% 					%%查找是不是已经有同类物品？
%% 					GoodsList1 = lists:filter(fun(G) -> 
%% 													  G#goods.gtid =:= GoodsInfo#goods.gtid 
%% 											  			andalso G#goods.num + GoodsNum =< GoodsTypeInfo#ets_base_goods.mxnum 
%% 											  	end, 
%% 											  GoodsList),
%% 					if
%% 						length(GoodsList1) > 0 ->
%% 							%% 存在且可叠加
%% 							[OverlapGoods|_] = goods_util:sort(GoodsList1, id),
%% 							NewNum = OverlapGoods#goods.num + GoodsNum,
%% 							change_goods_num(OverlapGoods, NewNum),
%% 							delete_goods(GoodsInfo#goods.id),
%% 							NullDepotCell = Status#goods_status.null_depot_cells,
%% 							Cell = OverlapGoods#goods.cell,
%% 							NewId = OverlapGoods#goods.id;
%% 						true ->
%% 							%% 不存在或者不可叠加，且直接移入仓库
%% 							NewNum = GoodsNum,
%% 							NewId = 0,
%% 							[Cell|NullDepotCell] = Status#goods_status.null_depot_cells,
%% 							change_goods_cell(GoodsInfo, 5, Cell)
%% 					end,
%%             		NullCells = lists:sort([GoodsInfo#goods.cell|Status#goods_status.null_cells]),
%%             		NewStatus = Status#goods_status{ null_cells = NullCells, 
%% 													 null_depot_cells = NullDepotCell}
%%     		end,
%%     		{ok, Cell, NewNum, NewId, NewStatus}
%% 	end.
%% 				
%% %%从仓库取出物品
%% moveout_bag(Status, GoodsInfo, GoodsNum, GoodsTypeInfo, Store_num) ->
%%     GoodsList = goods_util:get_goods_list(GoodsInfo#goods.uid, 4),
%% 	Store_count = length(GoodsList),
%% 	if 
%% 		Store_count >= Store_num ->
%% 			{fail, 0, 0, 0, full};
%% 		true ->
%% 			if 
%% 				GoodsNum =/= GoodsInfo#goods.num ->
%% 				%%仓库不支持部分取出
%% 					Cell = 0,
%% 					NewNum = 0,
%% 					NewId = 0,
%%             		NewStatus = Status;
%% 				true ->
%% 				%%全部取出
%% 					%%查找是不是已经有同类物品？
%% 					GoodsList1 = lists:filter(fun(G) -> 
%% 													  G#goods.gtid =:= GoodsInfo#goods.gtid 
%% 											  			andalso G#goods.num + GoodsNum =< GoodsTypeInfo#ets_base_goods.mxnum 
%% 											  	end, 
%% 											  GoodsList),
%% 					if
%% 						length(GoodsList1) > 0 ->
%% 							%% 存在且可叠加
%% 							[OverlapGoods|_] = goods_util:sort(GoodsList1, id),
%% 							NewNum = OverlapGoods#goods.num + GoodsNum,
%% 							change_goods_num(OverlapGoods, NewNum),
%% 							delete_goods(GoodsInfo#goods.id),
%% 							NullCells = Status#goods_status.null_cells,
%% 							Cell = OverlapGoods#goods.cell,
%% 							NewId = OverlapGoods#goods.id;
%% 						true ->
%% 							%% 不存在或者不可叠加，且直接移入背包
%% 							NewNum = GoodsNum,
%% 							NewId = 0,
%% 							[Cell|NullCells] = Status#goods_status.null_cells,
%% 							change_goods_cell(GoodsInfo, 4, Cell)
%% 					end,
%%             		NullDepotCell = lists:sort([GoodsInfo#goods.cell|Status#goods_status.null_depot_cells]),
%%             		NewStatus = Status#goods_status{ null_cells = NullCells, 
%% 													 null_depot_cells = NullDepotCell}
%%     		end,
%%     		{ok, Cell, NewNum, NewId, NewStatus}
%% 	end.
%% 
%% %% 扩展背包/仓库
%% extend(PlayerStatus, Cost, Loc, ExtendCellNum) ->
%% 	PlayerStatus1 = lib_goods:cost_money(PlayerStatus, Cost, gold, 1522),
%% 	case Loc of
%% 		4 ->
%%     		NewNum = PlayerStatus1#player.clln + ExtendCellNum,
%%     		NewPlayerStatus = PlayerStatus1#player{clln = NewNum },
%% 			NellCells = goods_util:get_null_cells(PlayerStatus#player.id, NewNum, 4),
%% 			db_agent:extend_bag(NewNum,NewPlayerStatus#player.id),
%% 			{ok, NewPlayerStatus, NellCells, NewNum};
%% 		_ ->
%% 			NewNum = PlayerStatus1#player.dpn + ExtendCellNum,
%% 			NewPlayerStatus = PlayerStatus1#player{dpn = NewNum },
%% 			NellCells = goods_util:get_null_cells(PlayerStatus#player.id, NewNum, 5),
%% 			db_agent:extend_store(NewNum,NewPlayerStatus#player.id),
%% 			{ok, NewPlayerStatus, NellCells, NewNum}
%% 	end.
%% 
%% %% 装备拆分
%% destruct(GoodsStatus,GoodsInfo,Num,_Pos) ->
%% 	NewNum = GoodsInfo#goods.num - Num,
%% 	change_goods_num(GoodsInfo,NewNum),
%% 	GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),
%% 	NewGoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%% %% %% 	临时处理
%% %% 	NewGoodsInfo2 = NewGoodsInfo#goods{bind = GoodsInfo#goods.bind},
%% 	add_goods_base(GoodsStatus,GoodsTypeInfo,Num,NewGoodsInfo,[]).
%% 
%% 	
%% %%修理装备
%% %% @spec mend_goods(PlayerId, GoodsInfo) -> {ok, NewCoin, Cost, [HP, MP, Attack, Defense]} | {error, Res}
%% mend_goods(PlayerStatus, GoodsStatus, GoodsInfo) ->
%%     UseNum = goods_util:get_goods_use_num(1),
%%     change_goods_use(GoodsInfo, UseNum),
%%     %% 扣费
%%     Cost = goods_util:get_mend_cost(1, GoodsInfo#goods.ustm),
%%     NewPlayerStatus = cost_money(PlayerStatus, Cost, coin,1551),
%%     case GoodsInfo#goods.ustm =< 0 of
%%         %% 之前磨损为0
%%         true ->
%%             %% 人物属性重新计算
%%             EquipSuit = goods_util:change_equip_suit(GoodsStatus#goods_status.equip_suit, 0, GoodsInfo#goods.stid),
%%             Status = GoodsStatus#goods_status{ equip_suit=EquipSuit },
%%             {ok, NewPlayerStatus2, NewStatus} = goods_util:count_role_equip_attribute(NewPlayerStatus, Status, GoodsInfo);
%%         false ->
%%             NewPlayerStatus2 = NewPlayerStatus,
%%             NewStatus = GoodsStatus
%%      end,
%%      {ok, NewPlayerStatus2, NewStatus}.
%% 
%% %%重写整理背包 
%% clean_bag([],[], _Location)->
%% 	[0,{}];
%% clean_bag([],GroupList, Location)->
%% 	F = fun(Group,Cell) ->
%% 			case length(Group) > 0 of
%% 				true ->
%% 					One = hd(Group),
%% 					GoodsTypeInfo = goods_util:get_goods_type(One#goods.gtid),
%% 					case GoodsTypeInfo#ets_base_goods.mxnum > 1 of
%% 						true ->
%% 							%%可以叠加
%% 							TotalNum = goods_util:get_goods_totalnum(Group),
%% 							F_cell = fun(Good,[Left,NowCell]) ->
%% 											 case Left > 0 of
%% 												 true ->
%% 											 		if
%% 												 		Left > GoodsTypeInfo#ets_base_goods.mxnum ->
%% 													 		change_goods_cell_and_num(Good, Location, NowCell, GoodsTypeInfo#ets_base_goods.mxnum),
%% 															NewLeft = Left - GoodsTypeInfo#ets_base_goods.mxnum,
%% 															[NewLeft, NowCell + 1];
%% 														true ->
%% 															change_goods_cell_and_num(Good, Location, NowCell, Left),
%% 															[0, NowCell + 1]
%% 													end;
%% 												 false ->
%% 													 delete_goods(Good#goods.id),
%% 													 [0, NowCell]
%% 											 end
%% 									 end,
%% 							[_,NewCell] = lists:foldl(F_cell, [TotalNum,Cell], Group),
%% 							NewCell;					
%% 						false ->
%% 							%%不能叠加，每一个物品分配cell
%% 							F_cell = fun(Good,NowCell) ->
%% 									change_goods_cell(Good, Location, NowCell),
%% 									NowCell + 1
%% 							end,
%% 							lists:foldl(F_cell,Cell, Group)
%% 					end;
%% 				false ->
%% 					Cell
%% 			end
%% 		end,
%% 	TotalCell = lists:foldl(F, 1, GroupList),
%% 	[TotalCell,{}];
%% 
%% clean_bag(GoodsList,GroupList, Location) ->
%% 	OneGood = hd(GoodsList),
%% 		F_filter = fun(Good) ->
%% %% %% 							临时处理
%% 						   Good#goods.gtid == OneGood#goods.gtid
%% %% 						   Good#goods.gtid == OneGood#goods.gtid andalso
%% %% 															   Good#goods.bind == OneGood#goods.bind
%% 				   end,
%% 	Filter_list = lists:filter(F_filter, GoodsList),
%% 	Tail_list = lists:foldl(fun(Good,Left) -> lists:delete(Good, Left) end,
%% 							GoodsList, Filter_list),
%% 	clean_bag(Tail_list,[Filter_list|GroupList], Location).
%% 	
%% 
%% %%任务物品
%% give_task_goods({GoodsTypeId, GoodsNum}, GoodsStatus)->
%% 	GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%%     case is_record(GoodsTypeInfo, ets_base_goods) of
%%         %% 物品不存在
%%         false ->
%%             {fail, {GoodsTypeId, not_found}};
%%         true ->
%%             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 1, 4),
%%             GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%             case (catch add_task_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList)) of
%%                  {ok, NewGoodsStatus} ->
%%                      {ok, NewGoodsStatus};
%%                   Error ->
%%                   %?DEBUG("mod_goods give_goods:~p", [Error]),
%%                       {fail, Error}
%%             end
%%     end.
%% 
%% %% 赠送物品
%% %% @spec give_goods(GoodsStatus, GoodsTypeId, GoodsNum) -> {ok, NewGoodsStatus} | {fail, Error, GoodsStatus}
%% give_goods({GoodsTypeId, GoodsNum}, GoodsStatus) ->
%%     GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%%     case is_record(GoodsTypeInfo, ets_base_goods) of
%%         %% 物品不存在
%%         false ->
%%             {fail, {GoodsTypeId, not_found}, GoodsStatus};
%%         true ->
%% %%             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, GoodsTypeInfo#ets_base_goods.bind, 4),
%% 			GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 0, 4),
%%             %%空格子的个数
%%             CellNum = goods_util:get_null_cell_num(GoodsList, GoodsTypeInfo#ets_base_goods.mxnum, GoodsNum),
%%             case length(GoodsStatus#goods_status.null_cells) < CellNum of
%%                 %% 背包格子不足
%%                 true ->
%%                     {fail, cell_num, GoodsStatus};
%%                 false ->
%%                     GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%                     case (catch add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList)) of
%%                         {ok, NewStatus} ->
%%                             {ok, NewStatus};
%%                         Error ->
%%                             %?DEBUG("mod_goods give_goods:~p", [Error]),
%%                             {fail, Error, GoodsStatus}
%%                     end
%%             end
%%     end;
%% %%可设物品绑定状态
%% give_goods({GoodsTypeId, GoodsNum ,Bind}, GoodsStatus) ->
%%     GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%% %% 	case Bind of
%% %% 		0 ->
%% %% 			GoodsTypeInfo = GoodsTypeInfo0#ets_base_goods{bind = Bind};
%% %% 		2 ->
%% %% 			GoodsTypeInfo = GoodsTypeInfo0#ets_base_goods{bind = Bind};
%% %% 		_ ->
%% %% 			GoodsTypeInfo = GoodsTypeInfo0
%% %% 	end,
%%     case is_record(GoodsTypeInfo, ets_base_goods) of
%%         %% 物品不存在
%%         false ->
%%             {fail, {GoodsTypeId, not_found}, GoodsStatus};
%%         true ->
%% %%             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, GoodsTypeInfo#ets_base_goods.bind, 4),
%% 			GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 0, 4),
%%             %%空格子的个数
%%             CellNum = goods_util:get_null_cell_num(GoodsList, GoodsTypeInfo#ets_base_goods.mxnum, GoodsNum),
%%             case length(GoodsStatus#goods_status.null_cells) < CellNum of
%%                 %% 背包格子不足
%%                 true ->
%%                     {fail, cell_num, GoodsStatus};
%%                 false ->
%%                     GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%                     case (catch add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList)) of
%%                         {ok, NewStatus} ->
%%                             {ok, NewStatus};
%%                         Error ->
%%                             %?DEBUG("mod_goods give_goods:~p", [Error]),
%%                             {fail, Error, GoodsStatus}
%%                     end
%%             end
%%     end.
%% 
%% 
%% %% 更新原有的可叠加物品
%% update_overlap_goods(GoodsInfo, [Num, MaxOverlap]) ->
%%     case Num > 0 of
%%         true when GoodsInfo#goods.num =/= MaxOverlap andalso MaxOverlap > 0 ->
%%             case Num + GoodsInfo#goods.num > MaxOverlap of
%%                 %% 总数超出可叠加数
%%                 true ->
%%                     OldNum = MaxOverlap,
%%                     NewNum = Num + GoodsInfo#goods.num - MaxOverlap;
%%                 false ->
%%                     OldNum = Num + GoodsInfo#goods.num,
%%                     NewNum = 0
%%             end,
%%             change_goods_num(GoodsInfo, OldNum);
%%         true ->
%%             NewNum = Num;
%%         false ->
%%             NewNum = 0
%%     end,
%%     [NewNum, MaxOverlap].
%% 
%% %% 添加物品
%% %% @spec add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsInfo, GoodsNum) -> {ok, NewGoodsStatus}
%% add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum) ->
%%     GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%     add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo).
%% 
%% add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo) ->
%% 	%%如果可以叠加，添加叠加物品
%%     case GoodsTypeInfo#ets_base_goods.mxnum > 1 of
%%         true ->
%% %% %% 			临时处理
%% 			List = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeInfo#ets_base_goods.gtid, 0, 4),
%% %%             List = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeInfo#ets_base_goods.gtid, GoodsInfo#goods.bind, 4),
%%             GoodsList = goods_util:sort(List, cell);
%%         false ->
%%             GoodsList = []
%%     end,
%%     add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList).
%% 
%% add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList) ->
%%     %% 插入物品记录
%%     case GoodsTypeInfo#ets_base_goods.mxnum > 1 of
%%         true ->
%%             %% 更新原有的可叠加物品
%%             [GoodsNum2,_] = lists:foldl(fun update_overlap_goods/2, [GoodsNum, GoodsTypeInfo#ets_base_goods.mxnum], GoodsList),
%%             %% 添加新的可叠加物品
%%             [NewGoodsStatus,_,_,_] = goods_util:deeploop(fun add_overlap_goods/2, GoodsNum2, [GoodsStatus, GoodsInfo, 4, GoodsTypeInfo#ets_base_goods.mxnum]);
%%         false ->
%%             %% 添加新的不可叠加物品
%%             AllNums = lists:seq(1, GoodsNum),
%%             [NewGoodsStatus,_,_] = lists:foldl(fun add_nonlap_goods/2, [GoodsStatus, GoodsInfo, 4], AllNums)
%%     end,
%%     {ok, NewGoodsStatus}.
%% 
%% %%添加任务物品
%% add_task_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList) ->
%%     %% 插入物品记录
%%     case GoodsTypeInfo#ets_base_goods.mxnum > 1 of
%%         true ->
%%             %% 更新原有的可叠加物品
%%             [GoodsNum2,_] = lists:foldl(fun update_overlap_goods/2, [GoodsNum, GoodsTypeInfo#ets_base_goods.mxnum], GoodsList),
%%             %% 添加新的可叠加物品
%%             [NewGoodsStatus,_,_,_] = goods_util:deeploop(fun add_overlap_goods/2, GoodsNum2, [GoodsStatus, GoodsInfo, 4, GoodsTypeInfo#ets_base_goods.mxnum]);
%%         false ->
%%             %% 添加新的不可叠加物品
%%             AllNums = lists:seq(1, GoodsNum),
%%             [NewGoodsStatus,_,_] = lists:foldl(fun add_nonlap_goods/2, [GoodsStatus, GoodsInfo, 4], AllNums)
%%     end,
%%     {ok, NewGoodsStatus}.
%% 
%% %% 添加新的可叠加物品 不检查空间
%% add_overlap_goods(Num, [PlayerId,GoodsInfo, Location, MaxOverlap]) when is_integer(PlayerId) ->
%%     case Num > MaxOverlap of
%%         true ->
%%             NewNum = Num - MaxOverlap,
%%             OldNum = MaxOverlap;
%%         false ->
%%             NewNum = 0,
%%             OldNum = Num
%%     end,
%%     case OldNum > 0 of
%%         true  ->
%%             NewGoodsInfo = GoodsInfo#goods{ uid=PlayerId, loc=Location, num=OldNum },
%%             add_goods(NewGoodsInfo);
%%          _ ->
%% 			skip
%%     end,
%%     [NewNum, [PlayerId,GoodsInfo, Location, MaxOverlap]];
%% 
%% %% 添加新的可叠加物品  检查空间
%% add_overlap_goods(Num, [GoodsStatus, GoodsInfo, Location, MaxOverlap]) ->
%%     case Num > MaxOverlap of
%%         true ->
%%             NewNum = Num - MaxOverlap,
%%             OldNum = MaxOverlap;
%%         false ->
%%             NewNum = 0,
%%             OldNum = Num
%%     end,
%%     case OldNum > 0 of
%%         true when length(GoodsStatus#goods_status.null_cells) > 0 ->
%%             [Cell|NullCells] = GoodsStatus#goods_status.null_cells,
%%             NewGoodsStatus = GoodsStatus#goods_status{null_cells=NullCells },
%%             NewGoodsInfo = GoodsInfo#goods{ uid=GoodsStatus#goods_status.uid, loc=Location, cell=Cell, num=OldNum },
%%             add_goods(NewGoodsInfo);
%%          _ ->
%%              NewGoodsStatus = GoodsStatus
%%     end,
%%     [NewNum, [NewGoodsStatus, GoodsInfo, Location, MaxOverlap]].
%% 
%% 
%% %% 添加新的不可叠加物品   不检查空间
%% add_nonlap_goods(_, [PlayerId,GoodsInfo, Location]) when is_integer(PlayerId)->
%%    	NewGoodsInfo3 = GoodsInfo#goods{uid=PlayerId, loc=Location, num=1 },
%%     add_goods(NewGoodsInfo3),
%%     [PlayerId,GoodsInfo, Location];
%% 
%% %% 添加新的不可叠加物品   检查空间
%% add_nonlap_goods(_, [GoodsStatus, GoodsInfo, Location]) ->
%%     case length(GoodsStatus#goods_status.null_cells) > 0 of
%%         true ->
%%             [Cell|NullCells] = GoodsStatus#goods_status.null_cells,
%%             NewGoodsStatus = GoodsStatus#goods_status{ null_cells=NullCells },
%%             NewGoodsInfo3 = GoodsInfo#goods{uid=GoodsStatus#goods_status.uid, loc=Location, cell=Cell, num=1 },
%%             add_goods(NewGoodsInfo3);
%%         false ->
%%             NewGoodsStatus = GoodsStatus
%%     end,
%%     [NewGoodsStatus, GoodsInfo, Location].
%% 
%% 
%% %% 装备磨损
%% attrit_equip(GoodsInfo, [UseNum, ZeroEquipList]) ->
%%     case GoodsInfo#goods.ustm > 0 of
%%         %% 耐久度降为0
%%         true when GoodsInfo#goods.ustm =< UseNum ->
%%             NewGoodsInfo = GoodsInfo#goods{ ustm=0 },
%%             ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%             [UseNum, [NewGoodsInfo|ZeroEquipList]];
%%         true ->
%%             NewUseNum = GoodsInfo#goods.ustm - UseNum,
%%             NewGoodsInfo = GoodsInfo#goods{ ustm=NewUseNum },
%%             ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%             [UseNum, ZeroEquipList];
%%         false ->
%%             [UseNum, ZeroEquipList]
%%     end.
%% 
%% %% 更改物品格子位置
%% change_goods_cell(GoodsInfo, Location, Cell) ->
%%     db_agent:change_goods_cell(Location, Cell, GoodsInfo#goods.id),
%%     NewGoodsInfo = GoodsInfo#goods{ loc=Location, cell=Cell },
%% %%io:format("~s ___________________________change_goods_cell[~p]\n",[misc:time_format(now()), {NewGoodsInfo#goods.atbt, GoodsInfo#goods.atbt}]),
%%     ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     NewGoodsInfo.
%% 
%% %%更改物品品质
%% change_goods_qly(GoodsInfo, Qly) ->
%% 	db_agent:change_goods_qly(GoodsInfo#goods.id, Qly),
%% 	NewGoodsInfo = GoodsInfo#goods{qly = Qly},
%%     ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     NewGoodsInfo.
%% 
%% %% 更改物品数量
%% change_goods_num(GoodsInfo, Num) ->
%%     db_agent:change_goods_num(GoodsInfo#goods.id, Num),
%%     NewGoodsInfo = GoodsInfo#goods{ num=Num },
%%     ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     NewGoodsInfo.
%% 
%% %% 更改物品格子位置和数量
%% change_goods_cell_and_num(GoodsInfo, Location, Cell, Num) ->
%%     db_agent:change_goods_cell_and_num(GoodsInfo, Location, Cell, Num),
%%     NewGoodsInfo = GoodsInfo#goods{ loc=Location, cell=Cell, num=Num },
%%     ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     NewGoodsInfo.
%% 
%% %% 更改物品耐久度
%% change_goods_use(GoodsInfo, UseNum) ->
%%     db_agent:change_goods_use(GoodsInfo, UseNum),
%%     NewGoodsInfo = GoodsInfo#goods{ ustm=UseNum },
%%     ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%     NewGoodsInfo.
%% 
%% %% 邮件发送新物品 return record goods 先生成物品，再发送邮件。Bind是否绑定状态。
%% add_new_goods_by_mail(ToNickname,TypeId,Bind,Num,Title,Content) ->
%% 	GoodsTypeInfo = goods_util:get_goods_type(TypeId),
%% 	if
%% 		is_record(GoodsTypeInfo,ets_base_goods) ->
%% 			NewNum =
%% 			if
%% 				GoodsTypeInfo#ets_base_goods.mxnum > 1 andalso GoodsTypeInfo#ets_base_goods.mxnum > Num ->
%% 					Num;
%% 				GoodsTypeInfo#ets_base_goods.mxnum > 1 andalso GoodsTypeInfo#ets_base_goods.mxnum =< Num ->
%% 					GoodsTypeInfo#ets_base_goods.mxnum;
%% 				true ->
%% 					1
%% 			end,			
%% 			NewGoods = goods_util:get_new_goods(GoodsTypeInfo),
%% 			NewGoods2 = NewGoods#goods{uid = 0,loc = 4 ,cell = 0,num = NewNum},
%% 			NewGoodsInfo=add_goods(NewGoods2),
%% 			%%清理ets
%% 			Pattern1=#goods{id=NewGoodsInfo#goods.id},
%% 			Pattern2=#goods_attribute{uid = 0,id=NewGoodsInfo#goods.id},
%% 			ets:match_delete(?ETS_GOODS_ONLINE, Pattern1),
%% 			ets:match_delete(?ETS_GOODS_ATTRIBUTE, Pattern2),
%% 			%%
%% 			Name = tool:to_list(ToNickname),			
%% 			lib_mail:send_sys_mail([Name], Title, Content, NewGoodsInfo#goods.id,NewGoodsInfo#goods.gtid,NewGoodsInfo#goods.num, 0,0),
%% 			NewGoodsInfo;
%% 		true ->
%% 			{}
%% 	end.
%% 				
%% %%保存物品buff信息
%% save_goods_buff(PlayerStatus) ->
%% 	Now = util:unixtime(),
%% %% 	%%更新玩家buff的时间  %%去掉动态更新
%% %% 	db_agent:update_pbuff_time(Now, PlayerStatus#player.id),
%% 	%%保存数值有变化的 现在只有气血包和法力包及体力BUFF, 时装的gtid和有效时间有可能被替换，所以下线要保存
%% %% 	MS = ets:fun2ms(fun(T) when T#goods_buff.uid == PlayerStatus#player.id 
%% %% 																			andalso T#goods_buff.eprtm > Now ->
%% %% 							%% 																									 andalso (T#goods_buff.gtid div 1000 =:= 1010) -> 
%% %% 							T 
%% %% 					end),
%% %% 	BuffList = ets:select(?ETS_GOODS_BUFF, MS),
%% %% 	F = fun(GoodsBuff) ->
%% %% 				db_agent:update_goods_buff(GoodsBuff#goods_buff.id,
%% %% 										   GoodsBuff#goods_buff.uid,
%% %% 										   GoodsBuff#goods_buff.gtid,
%% %% 										   GoodsBuff#goods_buff.eprtm,
%% %% 										   tool:to_list(GoodsBuff#goods_buff.data)
%% %% 										  )
%% %% 		end,
%% %% 	lists:foreach(F, BuffList),
%% 	%%删除过期的和数值小于0的
%% 	MS2 = ets:fun2ms(fun(T2) when T2#goods_buff.uid == PlayerStatus#player.id  ->
%% 							 T2									 
%% 					 end),
%% 	AllBuff = ets:select(?ETS_GOODS_BUFF,MS2),
%% 	F2 = fun(PerGoodsBuff) ->
%% 				 if
%% 					 PerGoodsBuff#goods_buff.eprtm < Now andalso PerGoodsBuff#goods_buff.eprtm =/= 0 ->
%% 						 db_agent:del_goods_buff(PerGoodsBuff#goods_buff.id);
%% %% 					 PerGoodsBuff#goods_buff.gtid == 23006 orelse PerGoodsBuff#goods_buff.gtid == 23106 ->
%% %% 						 V =tool:to_integer(tool:to_list(PerGoodsBuff#goods_buff.data)),
%% %% 						 if
%% %% 							 V =< 0 ->
%% %% 								 db_agent:del_goods_buff(PerGoodsBuff#goods_buff.id);
%% %% 							 true ->
%% %% 								 skip
%% %% 						 end;
%% 					 true ->
%% 						 skip
%% 				 end				   
%% 		 end,
%% 	lists:foreach(F2,AllBuff).
%% 	
%% %%更新玩家物品buff效果 return {yes/no,newPlayer}
%% update_goods_buff(PlayerStatus) ->
%% 	update_goods_buff(PlayerStatus,auto).
%% 
%% update_goods_buff(PlayerStatus, Type)  ->
%% 	Now = util:unixtime(),
%% 	MS = ets:fun2ms(fun(T) when (T#goods_buff.uid == PlayerStatus#player.id andalso T#goods_buff.eprtm > Now) orelse T#goods_buff.eprtm =:= 0 -> 
%% 							T 
%% 					end),
%% 	BuffList = ets:select(?ETS_GOODS_BUFF, MS),
%% 	if
%% 		PlayerStatus#player.hp > 0 ->
%% 			F = fun(GoodsBuff,PS) ->
%% 					if  
%% 						%%气血包
%% 						GoodsBuff#goods_buff.gtid == 111001 orelse  GoodsBuff#goods_buff.gtid == 111002 ->
%% %% 							DiffHP = PS#player.mxhp - PS#player.hp,
%% %% 							DataValue = tool:to_integer(tool:to_list(GoodsBuff#goods_buff.data)),
%% %% %%						?DEBUG("value:~p,diff:~p",[DataValue,DiffHP]),
%% %% 							case DiffHP > 0 andalso DataValue > 0 andalso PlayerStatus#player.hp > 0 of
%% %% 								true ->
%% %% 									if 
%% %% 										DataValue > DiffHP ->
%% %% 											NewGoodsBuff = GoodsBuff#goods_buff{data = DataValue - DiffHP},
%% %% 											HP = PS#player.mxhp;
%% %% 										true ->
%% %% 											HpExpireTime = 
%% %% 												case lib_hook:is_auto_use_goods(PS, 23006, 1) of
%% %% 													true ->
%% %% 														GoodsBuff#goods_buff.eprtm;
%% %% 													false ->
%% %% 														Now + 1
%% %% 												end,											
%% %% 											NewGoodsBuff = GoodsBuff#goods_buff{data =0, eprtm = HpExpireTime},
%% %% 											HP = PS#player.hp + DataValue
%% %% 									end,			
%% %% 									ets:insert(?ETS_GOODS_BUFF,NewGoodsBuff),
%% %% 									NewPS = PS#player{hp = HP},
%% %% 									%%发送气血包改变值
%% %% 									TransGoodsBuff = goods_buff_trans_to_proto([NewGoodsBuff]),
%% %% %% io:format("13014_1_~p_~n",[TransGoodsBuff]),								
%% %% 									{ok, BinData} = pt_13:write(13014, TransGoodsBuff),
%% %%     								spawn(fun() -> lib_send:send_to_sid(NewPS#player.other#player_other.pid_send, BinData) end),
%% %% 									NewPS;
%% %% 								false ->
%% %% 									PS
%% %% 							end;
%% 							PS;
%% 						%%其他buff效果
%% 						true ->
%% %% 							Data = util:string_to_term(tool:to_list(GoodsBuff#goods_buff.data)),
%% 							Data = GoodsBuff#goods_buff.data,
%% 							NewPs =
%% 							case Data of 
%% 								[buff,def_mult,V] ->
%% 									PS#player{other = PS#player.other#player_other{goods_buff=
%% 																					   PS#player.other#player_other.goods_buff#goods_cur_buff{def_mult =V}}};
%% 								[buff,spi_mult,V] ->
%% 									PS#player{other = PS#player.other#player_other{goods_buff=
%% 																					   PS#player.other#player_other.goods_buff#goods_cur_buff{spi_mult =V}}};
%% 								[buff,exp_mult,V] ->
%% 									PS#player{other = PS#player.other#player_other{goods_buff=
%% 																					   PS#player.other#player_other.goods_buff#goods_cur_buff{exp_mult =V}}};
%% 								[buff,pet_mult,V] ->
%% 									PS#player{other = PS#player.other#player_other{goods_buff=
%% 																					   PS#player.other#player_other.goods_buff#goods_cur_buff{pet_mult =V}}};
%% 								[buff,peach_mult,V] ->
%% 									PS#player{other = PS#player.other#player_other{goods_buff=
%% 																					   PS#player.other#player_other.goods_buff#goods_cur_buff{peach_mult =V}}};		
%% 								_ ->
%% 									PS 
%% 							end,
%% 							NewPs
%% 					end
%% 				end,
%% 			%%记录上一次的加成系数
%% 			Pre_hp = PlayerStatus#player.hp,
%% 			Pre_mult_def = PlayerStatus#player.other#player_other.goods_buff#goods_cur_buff.def_mult,
%% 			Pre_mult_spi = PlayerStatus#player.other#player_other.goods_buff#goods_cur_buff.spi_mult,
%% 			Pre_mult_exp = PlayerStatus#player.other#player_other.goods_buff#goods_cur_buff.exp_mult,
%% 			Pre_mult_pet = PlayerStatus#player.other#player_other.goods_buff#goods_cur_buff.pet_mult,
%% 			Pre_mult_peach = PlayerStatus#player.other#player_other.goods_buff#goods_cur_buff.peach_mult,
%% 			%%重设所有buff效果 
%% 			PlayerStatus2 = PlayerStatus#player{other=PlayerStatus#player.other#player_other{goods_buff=#goods_cur_buff{mp_lim =1 ,def_mult =1,spi_mult =1,exp_mult =1,pet_mult =1,peach_mult=1}}},
%% 
%% 			PlayerStatus3 = lists:foldl(F, PlayerStatus2, BuffList),
%% 			%%遍历过程中有数值改变，再取一次
%% 			BuffList2 = ets:select(?ETS_GOODS_BUFF, MS),
%% 			Hp = PlayerStatus3#player.hp,
%% 
%% 			Mult_mp = PlayerStatus3#player.other#player_other.goods_buff#goods_cur_buff.mp_lim,
%% 
%% 			Mult_def = PlayerStatus3#player.other#player_other.goods_buff#goods_cur_buff.def_mult,
%% 			
%% 			Mult_spi = PlayerStatus3#player.other#player_other.goods_buff#goods_cur_buff.spi_mult,
%% 			
%% 			Mult_exp = PlayerStatus3#player.other#player_other.goods_buff#goods_cur_buff.exp_mult,
%% 			
%% 			Mult_pet = PlayerStatus3#player.other#player_other.goods_buff#goods_cur_buff.pet_mult,
%% 			
%% 			Mult_peach = PlayerStatus3#player.other#player_other.goods_buff#goods_cur_buff.peach_mult,
%% 			if
%% 				%%加成系数值有改变则重新统计人物属性
%% 				Pre_mult_def =/= Mult_def ->
%% %% 					MeridianInfo = get(player_meridian),
%% 					PlayerStatus4 = lib_player:count_player_attribute(PlayerStatus3),
%% 					spawn(fun() -> lib_player:send_player_attribute(PlayerStatus4, 3) end);
%% 				true ->
%% 					PlayerStatus4 = PlayerStatus3
%% 			end,
%% 			%%获取最新数值
%% 			if
%% 				%%auto 且有变化更新
%% 				(Type =:= auto) andalso (Pre_mult_def =/= Mult_def orelse Pre_mult_spi =/= Mult_spi orelse Pre_mult_exp =/= Mult_exp orelse Pre_mult_pet =/= Mult_pet orelse Pre_mult_peach =/= Mult_peach) ->
%% 					NewBuffList = goods_buff_trans_to_proto(BuffList2),
%% %% io:format("13014_3_~p_~n",[[BuffList, NewBuffList]]),					
%% 					{ok, BinData} = pt_13:write(13014, NewBuffList),
%%     				lib_send:send_to_sid(PlayerStatus4#player.other#player_other.pid_send, BinData),
%% 					Change = yes;
%% 				%%auto 
%% 				Type =:= auto ->
%% 					if
%% 						Pre_hp =/= Hp ->
%% 							Change = yes;
%% 						true ->
%% 							Change = no
%% 					end;
%% 				%%force 强制更新
%% 				true ->	
%% 					NewBuffList = goods_buff_trans_to_proto(BuffList2),
%% %% io:format("13014_4_~p_~n",[[BuffList, NewBuffList]]),					
%% 					{ok, BinData} = pt_13:write(13014, NewBuffList),
%%     				lib_send:send_to_sid(PlayerStatus4#player.other#player_other.pid_send, BinData),
%% 					Change = yes
%% 			end,
%% 			%% 定时保存数据
%% 			case Now rem 600 of
%% 				0 ->
%% 					%%借助定时器清理垃圾内存
%% 					gen_server:cast(PlayerStatus4#player.other#player_other.pid_goods,'garbage_collect'),
%% 					spawn(fun() ->save_goods_buff(PlayerStatus4) end);
%% 				_ ->
%% 					skip
%% 			end,				
%% 			{Change,PlayerStatus4};
%% 		true ->
%% 			{no,PlayerStatus}
%% 	end.
%% 
%% goods_buff_trans_to_proto(GoodsBuffList) ->
%% 	Now = util:unixtime(),
%% 	F = fun(GoodsBuff) ->
%% 				if
%% 					GoodsBuff#goods_buff.gtid == 23006 orelse GoodsBuff#goods_buff.gtid == 23106 ->
%% 						Value= util:string_to_term(tool:to_list(GoodsBuff#goods_buff.data)),
%% 						LeftTime =
%% 							if
%% 								GoodsBuff#goods_buff.eprtm > Now + 10 ->
%% 									0;
%% 								true ->
%% 									trunc(GoodsBuff#goods_buff.eprtm) - Now
%% 							end;
%% 					GoodsBuff#goods_buff.gtid =:= 111001 ->
%% 						Value= util:string_to_term(tool:to_list(GoodsBuff#goods_buff.data)),
%% 						LeftTime = 0;
%% 					GoodsBuff#goods_buff.gtid =:= 113001 ->
%% 						Value= util:string_to_term(tool:to_list(GoodsBuff#goods_buff.data)),
%% 						LeftTime = 0;
%% 					GoodsBuff#goods_buff.gtid div 1000 =:= 270 ->
%% 						Value= util:string_to_term(tool:to_list(GoodsBuff#goods_buff.data)),
%% 						LeftTime = 
%% 							if trunc(GoodsBuff#goods_buff.eprtm) > Now ->
%% 								   trunc(GoodsBuff#goods_buff.eprtm) - Now;
%% 							   true ->
%% 								   0
%% 							end;
%% 					true ->
%% 						Value = 0,
%% 						LeftTime = 
%% 							if trunc(GoodsBuff#goods_buff.eprtm) > Now andalso GoodsBuff#goods_buff.eprtm =/= 0 ->
%% 								   trunc(GoodsBuff#goods_buff.eprtm) - Now;
%% 							   GoodsBuff#goods_buff.eprtm =:= 0 ->
%% 								   -1;
%% 							   true ->
%% 								   0
%% 							end
%% 				end,
%% 				[GoodsBuff#goods_buff.gtid,Value,LeftTime]
%% 		end,
%% 	lists:map(F, GoodsBuffList).
%% 
%% %% 删除物品
%% delete_goods(GoodsId) ->
%%     db_agent:delete_goods(GoodsId),
%% %%     Pattern = #goods_attribute{ gtid=GoodsId, _='_'},
%% %%     ets:match_delete(?ETS_GOODS_ATTRIBUTE, Pattern),
%% 	ets:delete(?ETS_GOODS_ONLINE,GoodsId),
%%     ok.
%% 
%% 
%% 
%% 
%% %%-------------------------------------
%% %%角色金钱修改的统一接口 返回PlayerStatus
%% %%-------------------------------------
%% %% 扣除角色金钱
%% %% Type为 coin / gold
%% %%PointId消费点  根据协议ID自定义，比如协议为 15*** 那么pointId 为 1501 1502
%% cost_money(PlayerStatus, Cost, Type, PointId) ->
%% 	[H1, H2, _H3, _H4] = integer_to_list(PointId),
%% 	Is_Enough_Money =
%% 		case [H1, H2] of
%% 			"17" ->
%% 				goods_util:is_enough_money_chk_db(PlayerStatus,Cost,Type);
%% 			"18" ->
%% 				goods_util:is_enough_money_chk_db(PlayerStatus,Cost,Type);
%% 			_ ->
%% 				goods_util:is_enough_money(PlayerStatus,Cost,Type)
%% 		end,
%% 	case Is_Enough_Money of
%% 		true ->
%% 			NewCost = abs(Cost),
%%     		NewPlayerStatus = goods_util:get_cost(PlayerStatus, NewCost, Type),
%% %% 			spawn(fun()->catch(db_agent:cost_money_to_db(Type,Cost))end),
%% 			db_agent:cost_money(PlayerStatus, NewCost, Type, PointId),
%% 			%% 元宝消费 任务
%% 			case Type of
%% 				gold ->
%% 					lib_task:event(cost_gold, [Cost], NewPlayerStatus);
%% 				coin ->
%% 					lib_task:event(cost_coin, [Cost], NewPlayerStatus);
%% 				_ -> skip
%% 			end;
%% 		false ->
%% 			NewPlayerStatus = PlayerStatus
%% 	end, 
%% %% 	?DEBUG("~p",[Cost]),
%% %% 	?DEBUG("~p",[Type]),
%% 	case Type of
%% 		coin ->
%% 			Total_money_r = get(total_money_data),
%% %% 			?DEBUG("~p",[Total_money_r]),
%% 			if is_record(Total_money_r,total_money) =:= true ->
%% 				NewTotal_money_r = Total_money_r#total_money{ccos = Total_money_r#total_money.ccos + Cost},
%% %% 				?DEBUG("~p",[Cost]),
%% %% 				?DEBUG("~p",[NewTotal_money_r]),
%% 				put(total_money_data,NewTotal_money_r);
%% 			   true ->
%% 				   skip
%% 			end;
%% 		gold ->
%% 			Total_money_r = get(total_money_data),
%% %% 			?DEBUG("~p",[Total_money_r]),
%% 			if is_record(Total_money_r,total_money) =:= true ->
%% 				NewTotal_money_r = Total_money_r#total_money{gcos = Total_money_r#total_money.gcos + Cost},
%% 				put(total_money_data,NewTotal_money_r);
%% 			   true ->
%% 				   skip
%% 			end
%% 	end,
%% 	
%%     NewPlayerStatus.
%% 
%% %% 加角色金钱
%% %%PointId消费点
%% add_money(PlayerStatus,Sum,Type,PointId) ->
%% 	NewSum = abs(Sum),
%% 	NewPlayerStatus = goods_util:add_money(PlayerStatus,NewSum,Type),
%% 	db_agent:add_money(PlayerStatus,NewSum,Type, PointId),
%% 	
%% 	case Type of
%% 		coin ->
%%             %%通知成就系统：玩家的铜钱数目（玩家进程及非玩家进程调用）
%%             lib_achi:event({NewPlayerStatus#player.id, ?ACHI_HAS_COIN, sum, NewPlayerStatus#player.coin}),
%% 			Total_money_r = get(total_money_data),
%% 			if is_record(Total_money_r,total_money) =:= true->
%% 				NewTotal_money_r = Total_money_r#total_money{coin = Total_money_r#total_money.coin + Sum},
%% 				put(total_money_data,NewTotal_money_r);
%% 			   true ->
%% 				   skip
%% 			end;
%% 		gold ->
%% 			Total_money_r = get(total_money_data),
%% 			if is_record(Total_money_r,total_money)=:= true ->
%% 				NewTotal_money_r = Total_money_r#total_money{gold = Total_money_r#total_money.gold + Sum},
%% 				put(total_money_data,NewTotal_money_r);
%% 			   true ->
%% 				   skip
%% 			end
%% 	end,
%% 	
%% 	NewPlayerStatus.
%% 
%% 
%% %% 加角色vip金钱
%% %%PointId消费点
%% add_money_vip(PlayerStatus,Sum,PointId) ->
%% 	NewSum = abs(Sum),
%% 	db_agent_vip:add_vipmt(PlayerStatus#player.id,Sum),
%% 	NewPlayerStatus = goods_util:add_money_vip(PlayerStatus,NewSum),
%% 	db_agent:add_money(NewPlayerStatus,NewSum, gold,PointId),
%% 	ResStatus = lib_vip:set_viplv_online(NewPlayerStatus),
%% %% 	io:format("add_money_vip_[~p]\n", [[Sum, ResStatus#player.clln]]),
%% 	if ResStatus#player.clln > PlayerStatus#player.clln ->
%% 		   gen_server:cast(ResStatus#player.other#player_other.pid_goods, {'reset_cell_num', ResStatus#player.clln, ResStatus#player.id});
%% 	   true ->
%% 		   skip
%% 	end,
%% 	ResStatus.
%% 
%% add_only_money_vip(PlayerStatus,Sum,_PointId) ->
%% 	NewSum = abs(Sum),
%% 	db_agent_vip:add_vipmt(PlayerStatus#player.id,NewSum),
%% 	PlayerStatus1 = PlayerStatus#player{vipmt = (PlayerStatus#player.vipmt + Sum)},
%% 	ResStatus = lib_vip:set_viplv_online(PlayerStatus1),
%% 	if ResStatus#player.clln > PlayerStatus1#player.clln ->
%% 		   gen_server:cast(ResStatus#player.other#player_other.pid_goods, {'reset_cell_num', ResStatus#player.clln, ResStatus#player.id});
%% 	   true ->
%% 		   skip
%% 	end,
%% 	ResStatus.
%% 
%% 
%% 
%% %%end.
%% 	
%% %% %% 物品绑定
%% %% bind_goods(GoodsInfo) ->
%% %%     db_agent:bind_goods(GoodsInfo),
%% %%     NewGoodsInfo = GoodsInfo#goods{ bind=2, spri=0 },
%% %%     ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%% %%     NewGoodsInfo.
%% 
%% %%-----------
%% %%坐骑相关
%% %%-----------
%% 
%% 			
%% %%坐骑状态切换开关
%% change_mount_status(PlayerStatus,MountInfo) ->
%% 	case PlayerStatus#player.mnt of
%% 		%%原来没有坐骑
%% 		0 ->
%% 			NewPlayerStatus = get_on_mount(PlayerStatus,MountInfo),
%% 			{ok,NewPlayerStatus,MountInfo#goods.gtid};
%% 		%%有坐骑
%% 		OldMountId ->				
%% 			%%新旧相同则卸下
%% 			case OldMountId =:= MountInfo#goods.id of
%% 				true ->
%% 					NewPlayerStatus = get_off_mount(PlayerStatus,MountInfo),
%% 					{ok,NewPlayerStatus,0};
%% 				%%不同则先卸旧装备新
%% 				false ->
%% 					OldMountInfo = goods_util:get_goods(OldMountId),
%% 					if
%% 						is_record(OldMountInfo,goods) ->
%% 							PlayerStatus2 = get_off_mount(PlayerStatus,OldMountInfo);
%% 						true ->
%% 							PlayerStatus2 = PlayerStatus
%% 					end,
%% 					NewPlayerStatus = get_on_mount(PlayerStatus2,MountInfo),
%% 					{ok,NewPlayerStatus,MountInfo#goods.gtid}
%% 			end
%% 	end.
%% %%装备坐骑			
%% get_on_mount(PlayerStatus,MountInfo) ->
%% 	if
%% 		is_record(MountInfo,goods) ->
%% %% 			if
%% %% 				MountInfo#goods.bind =/= 2 ->
%% %% 					NewMountInfo = bind_goods(MountInfo),
%% %% 					{ok, BIN} = pt_15:write(15000, [NewMountInfo, 0, []]),
%% %%     				lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BIN);		
%% %% 				true ->
%% %% 					skip
%% %% 			end,
%% 			Speed = PlayerStatus#player.spd + 1,
%% 			NewPlayerStatus = PlayerStatus#player{
%%                            mnt = MountInfo#goods.id,
%% 						   spd = Speed,
%% 						   other = PlayerStatus#player.other#player_other{
%% 								mount_stren = MountInfo#goods.stlv
%% 								}
%%             	},
%% 			spawn(fun()->db_agent:change_mount_status(MountInfo#goods.id,NewPlayerStatus#player.id)end),
%% 			{ok, BinData} = pt_12:write(12010, [NewPlayerStatus#player.id, 1, MountInfo#goods.gtid,MountInfo#goods.id,MountInfo#goods.stlv]),
%%     		spawn(fun()->mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData)end),
%% 			NewPlayerStatus;
%% 		true ->
%% 			PlayerStatus
%% 	end.
%% %%卸下坐骑			
%% get_off_mount(PlayerStatus,MountInfo) ->
%% 	if
%% 		is_record(MountInfo,goods) ->
%% 			Speed = 
%% 				if 
%% %% 					PlayerStatus#player.spd - MountInfo#goods.speed > 0 ->
%% %% 						PlayerStatus#player.spd - MountInfo#goods.speed;
%% 					PlayerStatus#player.spd > 0 ->
%% 						PlayerStatus#player.spd;
%% 					%% 临时处理
%% 					true ->
%% 						PlayerStatus#player.spd
%% 				end,
%% 			%%时装显示设置判断
%% 			[_Player_Id, _ShieldRole, _ShieldSkill, _ShieldRela, _ShieldTeam, _ShieldChat, _Music, _SoundEffect,Fasheffect] = lib_syssetting:query_player_sys_setting(PlayerStatus#player.id),
%% 			case Fasheffect == 1 of
%% 				true ->
%% 					NewPlayerStatus = PlayerStatus#player{
%%                            mnt = 0,
%% 						   spd = Speed,
%% 						   other = PlayerStatus#player.other#player_other{
%% 								mount_stren = 0
%% 								}
%%             	};
%% 				false ->
%% 					NewPlayerStatus = PlayerStatus#player{
%%                            mnt = 0,
%% 						   spd = Speed,
%% 						   other = PlayerStatus#player.other#player_other{
%% 								mount_stren = 0
%% 								}
%%             	}
%% 			end,
%% 			spawn(fun()->db_agent:change_mount_status(0,NewPlayerStatus#player.id)end),
%% 			{ok, BinData} = pt_12:write(12010, [NewPlayerStatus#player.id, Speed, 0,MountInfo#goods.id,0]),
%%     		spawn(fun()->mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData)end),
%% 			NewPlayerStatus;
%% 		true ->
%% 			PlayerStatus
%% 	end.
%% %%卸下坐骑
%% force_off_mount(PlayerStatus) ->
%% 	if
%% 		PlayerStatus#player.mnt > 0 ->
%% 			MountInfo = goods_util:get_goods(PlayerStatus#player.mnt),
%% 			NewPlayerStatus = get_off_mount(PlayerStatus,MountInfo),
%% 			spawn(fun()->lib_player:send_player_attribute(NewPlayerStatus,3)end),
%% 			{ok,NewPlayerStatus};		
%% 		true ->
%% 			{ok,PlayerStatus}
%% 	end.
%% 			
%% 
%% 					
%% %%-----------
%% %%清除处理操作
%% %%-----------
%% %%当玩家删除角色时，删除有关于这角色的数据
%% delete_role(PlayerId) ->
%%     db_agent:lg_delete_role(PlayerId),
%%     ok.
%% %%删除玩家物品的过期cd。
%% del_goods_cd(PlayerId) ->
%% 	Now = util:unixtime(),
%% 	MS_cd = ets:fun2ms(fun(T) when T#ets_goods_cd.uid == PlayerId  -> 
%% 			T 
%% 		end),
%% 	CdList = ets:select(?ETS_GOODS_CD, MS_cd),
%% 	F = fun(GoodsCd) ->
%% 				if
%% 					GoodsCd#ets_goods_cd.eprtm =< Now andalso GoodsCd#ets_goods_cd.id > 0 ->
%% 						ets:delete_object(?ETS_GOODS_CD, GoodsCd),
%% 						db_agent:del_goods_cd(GoodsCd#ets_goods_cd.id);
%% 					GoodsCd#ets_goods_cd.eprtm =< Now ->
%% 						ets:delete_object(?ETS_GOODS_CD, GoodsCd);
%% 					true ->
%% 						skip
%% 				end
%% 		end,
%% 	lists:map(F, CdList).
%% 
%% %%处理玩家下线物品相关操作
%% do_logout(PlayerStatus) ->
%% 	save_goods_buff(PlayerStatus),
%% 	del_goods_cd(PlayerStatus#player.id).
%% 	
%% %% 查看玩家是否存在指定ID物品（背包+仓库）
%% %% PlayerId 玩家ID
%% %% GoodsTypeId 物品类型ID
%% goods_find(PlayerId, GoodsTypeId) ->
%% 	G = goods_util:get_goods_list(PlayerId, all),
%% 	case is_list(G) of
%% 		true ->
%% 			lists:keyfind(GoodsTypeId, 4, G);
%% 		false ->
%% 			false
%% 	end.
%% 
%% %%获取自动使用的气血包ID，为空表示背包里没有气血包
%% hpPack_goods_find(PlayerId) ->
%% 	G = goods_util:get_goods_list(PlayerId, 4),
%% 	case is_list(G) of
%% 		true ->
%% 			case G of
%% 				[] ->
%% 					[];
%% 				_ ->
%% 					case [Goods1||Goods1 <- G, Goods1#goods.gtid =:= 111001] of
%% 						[] ->
%% 							case [Goods2||Goods2 <- G, Goods2#goods.gtid =:= 111002] of
%% 								[] ->
%% 									case [Goods3||Goods3 <- G, Goods3#goods.gtid =:= 111003] of
%% 										[] ->
%% 											case [Goods4||Goods4 <- G, Goods4#goods.gtid =:= 111004] of
%% 												[] ->
%% 													case [Goods5||Goods5 <- G, Goods5#goods.gtid =:= 111005] of
%% 														[] ->
%% 															case [Goods6||Goods6 <- G, Goods6#goods.gtid =:= 111006] of
%% 																[] ->
%% 																	case [Goods7||Goods7 <- G, Goods7#goods.gtid =:= 111007] of
%% 																		[] ->
%% 																			[];
%% 																		[BigHpPack6|_] ->
%% 																			BigHpPack6#goods.id
%% 																	end;
%% 																[BigHpPack5|_] ->
%% 																	BigHpPack5#goods.id
%% 															end;
%% 														[BigHpPack4|_] ->
%% 															BigHpPack4#goods.id
%% 													end;
%% 												[BigHpPack3|_] ->
%% 													BigHpPack3#goods.id
%% 											end;
%% 										[BigHpPack2|_] ->
%% 											BigHpPack2#goods.id
%% 									end;
%% 								[BigHpPack|_] ->
%% 									BigHpPack#goods.id
%% 							end;
%% 						[HpPack|_] ->
%% 							HpPack#goods.id
%% 					end
%% 			end;
%% 		false ->
%% 			[]
%% 	end.
%% 									
%% 									
%% 
%% %% 判断是否有足够的背包格子
%% %% GoodsStatus 玩家物品信息
%% %% GoodsTypeInfo 物品类型信息
%% %% GoodsNum 物品数量
%% is_enough_backpack_cell(GoodsStatus, GoodsTypeInfo, GoodsNum) ->
%% 	GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, 
%% 											   GoodsTypeInfo#ets_base_goods.gtid, 0, 4),
%% %% 				  								GoodsTypeInfo#ets_base_goods.gtid, GoodsTypeInfo#ets_base_goods.bind, 4),
%%     CellNum = goods_util:get_null_cell_num(GoodsList, GoodsTypeInfo#ets_base_goods.mxnum, GoodsNum),
%%     case length(GoodsStatus#goods_status.null_cells) >= CellNum of
%% 		true ->
%% 			{enough, GoodsList, CellNum};
%% 		false ->
%% 			no_enough
%% 	end.
%% 
%%  
%% %% 从数据表获取物品信息
%% get_goods_info_from_db(Player_id,Gid)->
%% 	GoodsInfo = goods_util:get_goods_by_id(Gid),
%% 	case is_record(GoodsInfo,goods) of
%% 		true ->
%% 			case goods_util:has_attribute(GoodsInfo) of
%% 				true ->
%% 					AttributeList = goods_util:get_offline_goods_attribute_list(Player_id,Gid),
%% 					%%SuitNum = goods_util:get_suit_num(GoodsStatus#goods_status.equip_suit, GoodsInfo#goods.suit_id);
%% 					SuitNum = 0;
%% 				false ->
%% 					AttributeList =[],
%% 					SuitNum = 0
%% 			end,
%% 			[GoodsInfo, SuitNum, AttributeList];
%% 		Error ->
%% 			?DEBUG("mod_goods info_other:~p", [[Player_id, Gid, Error]]),
%%             [{}, 0, []]
%% 	end.
%% 
%% 
%% %%长生界卡类激活
%% active_csj_card(Player,Cardstring) ->
%% 	CardInfo  = db_agent:check_csj_card(Cardstring),	%%用卡号查卡记录
%% 	Player_id = Player#player.id,
%% 	Accname   = Player#player.acnm,
%% 	Time      = util:unixtime(),
%% 	case CardInfo of
%% 		[_CardId,_Cardstring1,Begtime,Endtime,Active,_Pid,Key,_Type,Gtid] ->	%%在数据库有对应的卡号
%% 			CheckUsed = db_agent:check_csj_card_used(Key,Player_id),			%%是否该玩家是否已经使用过同类卡型
%% 			if
%% 				Active =/= 0 ->
%% 					[2,<<>>];			%%卡被已经使用过
%% 				Begtime =/= 0 andalso Time < Begtime ->
%% 					[3,<<>>];			%%不在有效时间范围内使用
%% 				Endtime =/= 0 andalso Time > Endtime ->
%% 					[4,<<>>];			%%已过期
%% 				CheckUsed =/= []->
%% 					[5,<<>>];			%%玩家已经领取过
%% 				true ->					%%未使用过
%% 					spawn(fun()->db_agent:active_csj_card(Cardstring,Player_id)end),		%%把玩家ID写入卡记录中
%% 					[ok,Gtid]
%% 			end;
%% 		_ ->	%%算法生成的卡号
%% 			PlatFormName = config:get_platform_name(),
%% 			ServerNum = config:get_server_num(),
%% %% 			CardKey = config:get_card_key(),
%% 			CardKey = "Cdf*75EpervREawo%$",
%% 			case PlatFormName of
%% %% 				"4399" ->				%%4399平台也有使用算法生成的卡, 注释掉此部分
%% %% 					[0,<<>>];
%% 				undefined ->
%% 					[0,<<>>];
%% 				_ ->
%% 					if
%% 						ServerNum /= undefined andalso CardKey /= undefined ->
%% 							GameName = "cszd",
%% 							Key = "sj",
%% 							MakeCardString = util:md5(lists:concat([CardKey,GameName,"S",tool:to_list(ServerNum),Accname,Key])),
%% 							if
%% 								MakeCardString =:= Cardstring ->
%% 									spawn(fun() -> db_agent:active_use_csj_card(Cardstring,Player_id,Key, 8) end),  %%在数据库中插入一条卡记录
%% 									[1,Key];
%% 								true ->
%% 									[0,<<>>]
%% 							end;
%% 						true ->
%% 							[0,<<>>]
%% 					end
%% 			end
%% 	end.
%% 			
%% check_goods_diff(GoodsList) ->
%% 	check_diff_good(false, GoodsList, GoodsList).
%% 
%% check_diff_good(true, _GoodsList, _RemainGoodsList) ->
%% 	true;
%% check_diff_good(false, _GoodsList, []) ->
%% 	false;
%% check_diff_good(false, GoodsList, [{GoodsId, Num}|ReaminGoodsList]) ->
%% 	NewGoodsList = lists:delete({GoodsId, Num}, GoodsList),
%% 	Result = lists:any(fun(Elem) ->
%% 							   {GoodsIdInner, _NumInner} = Elem,
%% 							   GoodsIdInner =:= GoodsId
%% 					   end, NewGoodsList),
%% %% 	io:format("Result:~p\n",[Result]),
%% 	check_diff_good(Result, GoodsList, ReaminGoodsList).
%% 
%% %%气血包效果使用（不同于气血包物品使用，气血包物品使用是修改ETS_GOODS_BUFF及数据库goods_buff表，有物品进程调用
%% %%本函数是实施补血效果，由玩家进程调用（因为宠物在玩家进程字典里））
%% useHpPackAct(PlayerStatus) ->
%% %% 	PlayerStsw = PlayerStatus#player.stsw,
%% %% 	<<_TmpSw1:31, HpPackSw:1>> = <<PlayerStsw:32>>,
%% 	HpPackSw = 0,   %%新版不需要使用气血包
%% 	case HpPackSw of     %%判断是否扣血及使用气血包
%% 		0 ->    
%% 			Sta1 = sysAddAllHp(PlayerStatus),
%% %% 			io:format("useHpPackAct1:~p\n",[Sta1]),
%% 			Sta1;
%% 		1 ->
%% 			if PlayerStatus#player.mxhp < PlayerStatus#player.hp ->
%% 				   NewPlayerStatus = PlayerStatus#player{hp = PlayerStatus#player.mxhp},
%% 				   lib_player:send_player_attribute(NewPlayerStatus, 3),
%% 				   NewPlayerStatus;
%% 			   true ->
%% 				   	MS = ets:fun2ms(fun(T) when T#goods_buff.uid == PlayerStatus#player.id andalso T#goods_buff.gtid =:= 111001 -> 
%% 		 									T 
%% 		 							end),
%% 		 			BuffList = ets:select(?ETS_GOODS_BUFF, MS),
%% 		 			case BuffList of
%% 		 				[] ->
%% 		 					{ok, BinData} = pt_15:write(15151, [2]),       %%通知客户端使用气血包
%% 		 					spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end),
%% 		 					PlayerStatus;
%% 		 				[GoodsBuff|_] when is_record(GoodsBuff, goods_buff) ->
%% 		 					HpPackDataOld = tool:to_integer(tool:to_list(GoodsBuff#goods_buff.data)),
%% 							%%io:format("useHpPackAct_HpPackDataOld:~p\n",[HpPackDataOld]),
%% 		 					if HpPackDataOld > 0 ->
%% %% 		 							ActPetIdList = lib_formation:getActPet(),
%% %% 		 							io:format("useHpPackAct0:~p\n",[ActPetIdList]),
%% 		 							PetList = get(player_pet),
%% %% 									PetList = [PM1||PM1<-PetListTmp, PM1#pet.cell =:= 0],  %%取消，已经取消宠物仓库
%% 		 							case PetList of
%% 		 								[] ->
%% 		 									HpPackData = HpPackDataOld;
%% 		 								undefined ->
%% 		 									HpPackData = HpPackDataOld;
%% 		 								_ ->
%% 		 									AllPetIdList = [PetM#pet2.id||PetM <- PetList],
%% 											NewAllPetIdList = AllPetIdList,
%% 		 									%%io:format("useHpPackAct1:~p\n",[AllPetIdList]),
%% %% 		 									TmpPetIdList = AllPetIdList -- ActPetIdList,
%% 		 									%%io:format("useHpPackAct2:~p\n",[TmpPetIdList]),
%% %% 		 									NewAllPetIdList = ActPetIdList ++ TmpPetIdList,     %%将出战宠物排在前面
%% 		 									%%io:format("useHpPackAct3:~p\n",[NewAllPetIdList]),
%% 		 									HpPackData = addPetHpPack(PetList, NewAllPetIdList, HpPackDataOld)
%% 		 		%% 							put(player_pet, NewPetList)
%% 		 							end,
%% 									%%io:format("useHpPackAct_HpPackData:~p\n",[HpPackData]),
%% 		 							if HpPackData > 0 ->
%% 		 								   DiffHP = PlayerStatus#player.mxhp - PlayerStatus#player.hp,
%% 										   %%io:format("useHpPackAct_DiffHP:~p\n",[DiffHP]),
%% 		 						   		   if DiffHP > 0 ->
%% 		 								  		  if HpPackData > DiffHP ->
%% 		 										 		 NewGoodsBuff = GoodsBuff#goods_buff{data = HpPackData - DiffHP},
%% 		 												 {ok, BinData} = pt_15:write(15151, [1]),       %%通知客户端使用气血包补满血（聊天框显示）
%% 		 												 spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end),
%% 		 												 NewPlayerHp = PlayerStatus#player.mxhp;
%% 		 											 true ->
%% 		 												 NewGoodsBuff = GoodsBuff#goods_buff{data = 0},
%% 		 												 NewPlayerHp = PlayerStatus#player.hp + HpPackData,
%% 		 												 {ok, BinData} = pt_15:write(15151, [2]),       %%通知客户端使用气血包
%% 		 												 spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end)
%% 		 										  end,
%% 		 										  ets:insert(?ETS_GOODS_BUFF,NewGoodsBuff),
%% 		 										  NewPlayerStatus = PlayerStatus#player{hp = NewPlayerHp},
%% 		 										  lib_player:send_player_attribute(NewPlayerStatus, 3),
%% 		 										  TransGoodsBuff = goods_buff_trans_to_proto([NewGoodsBuff]),
%% 		 										  {ok, BinData1} = pt_13:write(13014, TransGoodsBuff),         %%通知客户端修改气血包数据
%% 		 		    							  spawn(fun() -> lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1) end),
%% 		 										  NewPlayerStatus;
%% 		 %% 									  DiffHP < 0 ->
%% 		 %% 										  if HpPackData =:= HpPackDataOld ->     %%宠物没有扣血
%% 		 %% 												 NewPlayerStatus = PlayerStatus#player{hp = PlayerStatus#player.mxhp},
%% 		 %% 										  		 lib_player:send_player_attribute(NewPlayerStatus, 3),
%% 		 %% 												 NewPlayerStatus;
%% 		 %% 											 true -> 
%% 		 %% 										  		 NewGoodsBuff = GoodsBuff#goods_buff{data = HpPackData},
%% 		 %% 										  		 ets:insert(?ETS_GOODS_BUFF,NewGoodsBuff),
%% 		 %% 										  		 TransGoodsBuff = goods_buff_trans_to_proto([NewGoodsBuff]),
%% 		 %% 												 {ok, BinData} = pt_15:write(15151, [1]),       %%通知客户端使用气血包补满血（聊天框显示）
%% 		 %% 												 spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end),
%% 		 %% 										  		 {ok, BinData1} = pt_13:write(13014, TransGoodsBuff),        %%通知客户端修改气血包数据
%% 		 %% 		    							  		 spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1) end),
%% 		 %% 										  		 NewPlayerStatus = PlayerStatus#player{hp = PlayerStatus#player.mxhp},
%% 		 %% 										  		 lib_player:send_player_attribute(NewPlayerStatus, 3),
%% 		 %% 												 NewPlayerStatus
%% 		 %% 										  end;
%% 		 									  true ->          %%玩家没有扣血
%% 		 										  if HpPackData =:= HpPackDataOld ->     %%宠物没有扣血
%% 		 												 PlayerStatus;
%% 		 											 true -> 
%% 		 										  		 NewGoodsBuff = GoodsBuff#goods_buff{data = HpPackData},
%% 		 										  		 ets:insert(?ETS_GOODS_BUFF,NewGoodsBuff),
%% 		 										  		 TransGoodsBuff = goods_buff_trans_to_proto([NewGoodsBuff]),
%% 		 												 {ok, BinData} = pt_15:write(15151, [1]),       %%通知客户端使用气血包补满血（聊天框显示）
%% 		 												 spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end),
%% 		 										  		 {ok, BinData1} = pt_13:write(13014, TransGoodsBuff),        %%通知客户端修改气血包数据
%% 		 		    							  		 spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1) end),
%% 		 										  		 PlayerStatus
%% 		 										  end
%% 		 								   end;
%% 		 							   true ->
%% 		 								   if HpPackDataOld > 0 ->
%% 		 										  NewGoodsBuff = GoodsBuff#goods_buff{data = 0},
%% 		 										  ets:insert(?ETS_GOODS_BUFF,NewGoodsBuff),
%% 		 										  TransGoodsBuff = goods_buff_trans_to_proto([NewGoodsBuff]),
%% 		 										  {ok, BinData} = pt_13:write(13014, TransGoodsBuff),   %%通知客户端修改气血包数据
%% 		 		    							  spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end);
%% 		 									  true ->
%% 		 										  skip
%% 		 								   end,
%% 		 								   {ok, BinData1} = pt_15:write(15151, [2]),       %%通知客户端使用气血包
%% 		 								   spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1) end),
%% 		 					               PlayerStatus
%% 		 							end;
%% 		 					   true ->
%% 		 						   {ok, BinData} = pt_15:write(15151, [2]),       %%通知客户端使用气血包
%% 		 						   spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end),
%% 		 					       PlayerStatus
%% 		 					end;
%% 		 				_ ->
%% 		 					{ok, BinData} = pt_15:write(15151, [2]),       %%通知客户端使用气血包
%% 		 					spawn(fun() -> lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData) end),
%% 		 					PlayerStatus
%% 		 			end
%% 			end
%% 
%% 	end.
%% 		
%% %%系统加满玩家及所有宠物气血
%% sysAddAllHp(PlayerStatus) ->
%% 	case get(player_pet) of
%% 		[] ->
%% 			skip;
%% 		undefined ->
%% 			skip;
%% 		PetList when is_list(PetList) ->
%% 			Fun1 = fun(M) ->
%% 						  if M#pet2.hp =:= M#pet2.other#pet_other.mxhp ->
%% 								 skip;
%% 							 true ->
%% 								 Hp = M#pet2.other#pet_other.mxhp,
%% 								 lib_pet2:update_pet_hp(M#pet2.id, Hp)
%% 						  end
%% 				  end,
%% 			lists:foreach(Fun1, PetList);
%% 		_ ->
%% 			skip
%% 	end,
%% 	Hp = PlayerStatus#player.mxhp,
%% 	PlayerStatus#player{hp = Hp}.
%% 
%% %%气血包加全部宠物气血
%% addPetHpPack(_PetList, [], HpPackDataOld) ->
%% 	HpPackDataOld;
%% 
%% addPetHpPack(_PetList, _AllPetIdList, 0) ->
%% 	0;
%% 
%% addPetHpPack(PetList, AllPetIdList, HpPackDataOld) ->
%% 	[PetId|NewAllPetIdList] = AllPetIdList,
%% %% 	io:format("useHpPackAct_PetList:~p\n",[PetList]),
%% 	case [Pet||Pet <- PetList, Pet#pet2.id =:= PetId] of
%% 		[] ->
%% 			addPetHpPack(PetList, NewAllPetIdList, HpPackDataOld);
%% 		[OldPet|_] when is_record(OldPet, pet2) ->
%% 			DiffHp = OldPet#pet2.other#pet_other.mxhp - OldPet#pet2.hp,
%% 			if DiffHp > 0 ->
%% 				   if HpPackDataOld > DiffHp ->
%% 						  Hp = OldPet#pet2.other#pet_other.mxhp,
%% 						  HpPackData = HpPackDataOld - DiffHp;
%% 					  true ->
%% 						  Hp = OldPet#pet2.hp + HpPackDataOld,
%% 						  HpPackData = 0
%% 				   end,
%% 				   lib_pet2:update_pet_hp(PetId, Hp),
%% %%  				   io:format("useHpPackAct_PetList1:[~p][~p][~p][~p][~p]\n",[OldPet#pet.other#pet_other.mxhp, OldPet#pet.hp, PetId, DiffHp, Hp]),
%% %% 				   NewPet = OldPet#pet{hp = Hp},
%% %% 				   TmpPetList = [Pet||Pet <- PetList, Pet#pet.id =/= PetId],
%% %% 				   NewPetList = TmpPetList ++ [NewPet],
%% 				   addPetHpPack(PetList, NewAllPetIdList, HpPackData);
%% 			   true ->
%% 				   addPetHpPack(PetList, NewAllPetIdList, HpPackDataOld)
%% 			end;
%% 		_ ->
%% 			addPetHpPack(PetList, NewAllPetIdList, HpPackDataOld)
%% 	end.
%% 
%% %% 根据列表检查材料是否足够 非vip
%% %% not_enough 物品不足     enough 物品足够
%% check_material([], _PlayerId) ->
%% 	enough;
%% check_material(MaterialList, PlayerId) ->
%% 	[{MaterialTypeId, Num}|RestList] = MaterialList,
%% 	HoldSum = goods_util:get_goods_num(PlayerId, MaterialTypeId, 4),
%% 	if
%% 		HoldSum < Num ->
%% 			not_enough;
%% 		true ->
%% 			check_material(RestList, PlayerId)
%% 	end.
%% 
%% 
%% %% 根据列表检查材料是否足够 非vip
%% %% not_enough 物品不足     enough 物品足够
%% check_material_autobuy(MaterialList, PlayerId) ->
%% 	check_material_autobuy(MaterialList, PlayerId, 0).
%% 
%% check_material_autobuy([], _PlayerId, CostGold) ->
%% 	{ok, CostGold};
%% check_material_autobuy(MaterialList, PlayerId, CostGold) ->
%% 	[{MaterialTypeId, Num}|RestList] = MaterialList,
%% 	HoldSum = goods_util:get_goods_num(PlayerId, MaterialTypeId, 4),
%% 	if
%% 		HoldSum < Num ->
%% 			case data_shop:get_pet_goods_shop_info(MaterialTypeId) of
%% 				[_, _, _, Cost, _] ->
%% 					NewCostGold = (Num - HoldSum) * Cost + CostGold,
%% 					check_material_autobuy(RestList, PlayerId, NewCostGold);
%% 				_ ->
%% 					error
%% 			end;
%% 		true ->
%% 			check_material_autobuy(RestList, PlayerId, CostGold)
%% 	end.
%% 
%% %%检查精炼材料
%% check_refine_material(PlayerId, GoodsInfo, TgQly, AutoBuy) ->
%% 	case data_stren:get_refine_material_list(GoodsInfo#goods.stid, TgQly) of
%% 		error ->
%% 			error;
%% 		MaterialList ->
%% 			case AutoBuy of
%% 				1 ->
%% 					case check_material_autobuy(MaterialList, PlayerId) of
%% 						{ok, CostGold} ->
%% 							{MaterialList, CostGold};
%% 						_ ->
%% 							error
%% 					end;
%% 				_ ->
%% 					case check_material(MaterialList, PlayerId) of
%% 						not_enough ->
%% 							not_enough;
%% 						_ ->
%% 							{MaterialList, 0}
%% 					end
%% 			end
%% 	end.
%% 
%% %% 检查合成所需材料(非装备)
%% %% 返回：  error 合成组合有误    not_enough 物品不足     GoodsList 物品足够
%% check_compose_material(PlayerId, RollerTypeId) ->
%% 	case data_stren:get_compose_material_list(RollerTypeId) of
%% 		error ->
%% 			error;
%% 		MaterialList ->
%% 			case check_material(MaterialList, PlayerId) of
%% 				not_enough ->
%% 					not_enough;
%% 				_ ->
%% 					MaterialList
%% 			end
%% 	end.
%% 
%% %% 检查合成所需材料
%% %% 返回：  error 合成组合有误    not_enough 物品不足     GoodsList 物品足够
%% check_compose_material(PlayerId, _RollerTypeId, EquitTypeId) ->
%% %% 	case data_stren:get_compose_material_list(RollerTypeId, EquitTypeId) of
%% 	case data_stren:get_equip_compose_material_list(EquitTypeId) of
%% 		error ->
%% 			error;
%% 		MaterialList ->
%% 			case check_material(MaterialList, PlayerId) of
%% 				not_enough ->
%% 					not_enough;
%% 				_ ->
%% 					MaterialList
%% 			end
%% 	end.
%% 
%% 
%% %% 根据列表检查材料是否足够 vip
%% %% not_enough 物品不足     enough 物品足够
%% check_material_vip([], _PlayerId, M) ->
%% 	M;
%% check_material_vip(MaterialList, PlayerId, M) ->
%% 	[{MaterialTypeId, Num}|RestList] = MaterialList,
%% 	HoldSum = goods_util:get_goods_num(PlayerId, MaterialTypeId, 4),
%% 	if
%% 		HoldSum < Num ->
%% %% 			?DEBUG("~p",[HoldSum]),
%% 			P = get_material_vip_gold(MaterialTypeId),
%% 			NewM = M+P*(Num - HoldSum),
%% 			check_material_vip(RestList, PlayerId, NewM);
%% 		true ->
%% 			NewM = M,
%% 			check_material_vip(RestList, PlayerId, NewM)
%% 	end.
%% 	
%% get_material_vip_gold(MaterialTypeId) ->
%% 	GoodsTypeInfo = goods_util:get_goods_type(MaterialTypeId),
%% 	Other_data = tool:to_list(GoodsTypeInfo#ets_base_goods.other_data),
%% %% 	?DEBUG("~p",[Other_data]),
%% 	case util:string_to_term(Other_data) of
%% 		[] ->
%% 			Gold = 0;
%% 		[Gold ] ->
%% 			[]
%% 	end,
%% %% 	?DEBUG("~p",[Gold]),
%% 	Gold.
%% 
%% %% 检查合成所需材料
%% %% 返回：  error 合成组合有误    not_enough 物品不足     GoodsList 物品足够
%% check_compose_material_vip(PlayerId, RollerTypeId) ->
%% 	Gold = data_stren:get_compose_gold_most(RollerTypeId),			%%先查询合成物品所需要的最多元宝数
%% 	if Gold =:= error ->
%% 			error;
%% 	   is_integer(Gold) andalso Gold > 0 ->
%% 		   {0,Gold};
%% 	   true ->														%%未返回正确元宝数的, 用材料计算
%% 		   case data_stren:get_compose_material_list(RollerTypeId) of
%% 			   error ->
%% 				   error;
%% 			   MaterialList ->
%% 				   M = check_material_vip(MaterialList, PlayerId,0),
%% 				   {MaterialList,M}
%% 		   end
%% 	end.
%% 
%% %% 检查合成所需材料
%% %% 返回：  error 合成组合有误    not_enough 物品不足     GoodsList 物品足够
%% check_compose_material_vip(PlayerId, RollerTypeId, EquitTypeId) ->
%% 	case data_stren:get_compose_material_list(RollerTypeId, EquitTypeId) of
%% 		error ->
%% 			error;
%% 		MaterialList ->
%% 			M = check_material_vip(MaterialList, PlayerId,0),
%% 			{MaterialList,M}
%% 	end.
%% 
%% 
%% 
%% %% 扣除合成所需材料
%% %% 返回新的GoodsStatus
%% delete_compose_material([], GoodsStatus) ->
%% 	GoodsStatus;
%% delete_compose_material(MaterialList, GoodsStatus) ->
%% 	[{MaterialTypeId, Num}|RestList] = MaterialList,
%%     GoodsList4 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, MaterialTypeId, 4),
%% %% 	GoodsList5 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, MaterialTypeId, 5),	
%% 	{ok, NewStatus} = delete_more(GoodsStatus, GoodsList4, Num),
%% 	delete_compose_material(RestList, NewStatus).
%% %% 	delete_compose_material(RestList, GoodsStatus).
%% 
%% %% 物品合成(非装备)
%% %% 返回新的 GoodsStatus 和新的物品信息
%% stuff_compose(RollerInfo, GoodsStatus) ->
%% 	TargetStuffId = data_stren:get_compose_target(RollerInfo#goods.gtid),			%%获取合成目标物品类型ID
%% 	TargetStuffTypeInfo = goods_util:get_ets_info(?ETS_BASE_GOODS, TargetStuffId),	%%从ETS表取得该物品基础信息
%% 	TargetStuffInfo = goods_util:get_new_goods(TargetStuffTypeInfo),				%%由基础数据转换成goods数据
%% 	{ok, GoodsStatus1, _} = delete_one(GoodsStatus, RollerInfo, 1),					%%删除合成卷轴
%% 	NewStuffInfo= TargetStuffInfo#goods{uid = RollerInfo#goods.uid, loc = RollerInfo#goods.loc, cell = RollerInfo#goods.cell, num = 1}, %%更新物品所属uid、格位
%% 	NewStuff = add_goods(NewStuffInfo),		%%已有格位, 可直接调用add_goods
%% 	{GoodsStatus1, NewStuff, TargetStuffTypeInfo}.
%% 
%% %% 装备合成
%% %% 返回新的 GoodsStatus 和新的装备信息
%% euqit_compose(_RollerInfo, TargetEquitTypeInfo, GoodsStatus) ->
%% 	GoodsInfo = goods_util:get_new_goods(TargetEquitTypeInfo),
%% %% 	TargetEquitInfo = goods_util:chk_new_equit_goods(GoodsInfo),
%% %% 	{ok, GoodsStatus1, _} = delete_one(GoodsStatus, RollerInfo, 1),
%% %% 	%% 在原装备位置生成新装备，所以以下操作不更新GoodsStatus
%% %% 	{ok, _GoodsStatus2, _} = delete_one(GoodsStatus1, EquitInfo, 1),
%% 	[Cell|Null_Cells] = GoodsStatus#goods_status.null_cells,
%% 	NewEquitInfo= GoodsInfo#goods{uid = GoodsStatus#goods_status.uid, 
%% 								  loc = 4, 
%% 								  cell = Cell,
%% 								  num = 1},
%% 	GoodsStatus1 = GoodsStatus#goods_status{null_cells = Null_Cells},
%% 	%%io:format("~s euqit_compose_11111_ok[~p]\n",[misc:time_format(now()), NewEquitInfo]),
%% 	NewEquit = add_goods(NewEquitInfo),
%% 	{GoodsStatus1, NewEquit, TargetEquitTypeInfo}.
%% 
%% %%执行装备精炼
%% equip_refine(GoodsInfo) ->
%% 	NewQly = GoodsInfo#goods.qly + 1,
%% 	GoodsInfo1 = change_goods_qly(GoodsInfo, NewQly),
%% 	GoodsInfo1.
%% 	
%% 
%% 
%% %% 根据列表检查灵粹是否足够
%% %% not_enough 物品不足     enough 物品足够
%% check_essence([], _PlayerId) ->
%% 	enough;
%% check_essence(EssenceList, PlayerId) ->
%% 	[{EssenceTypeId, Num}|RestList] = EssenceList,
%% 	HoldSum = goods_util:get_goods_num(PlayerId, EssenceTypeId, 4),
%% 	if
%% 		HoldSum < Num ->
%% 			not_enough;
%% 		true ->
%% 			check_essence(RestList, PlayerId)
%% 	end.
%% 
%% %% 检查竞技场商店所需材料
%% %% 返回：  error 合成组合有误    not_enough 物品不足     GoodsList 物品足够
%% check_arena_shop(PlayerId, GoodsTypeId) ->
%% 	case data_shop:get_medal_shop_list(GoodsTypeId) of
%% 		error ->
%% 			error;
%% 		MedalList ->
%% 			case check_essence(MedalList, PlayerId) of
%% 				not_enough ->
%% 					not_enough;
%% 				_ ->
%% 					MedalList
%% 			end
%% 	end.
%% 
%% %% 检查灵粹商店所需材料
%% %% 返回：  error 合成组合有误    not_enough 物品不足     GoodsList 物品足够
%% check_essence_shop(PlayerId, GoodsTypeId, Prstg) ->	
%% 	NeedPrstg = data_shop:get_need_prstg(GoodsTypeId),
%% 	if
%% 		NeedPrstg > Prstg ->
%% 			not_enough_prstg;
%% 		true ->
%% 			case data_shop:get_essence_shop_list(GoodsTypeId) of
%% 				error ->
%% 					error;
%% 				EssenceList ->
%% 					case check_essence(EssenceList, PlayerId) of
%% 						not_enough ->
%% 							not_enough;
%% 						_ ->
%% 							EssenceList
%% 					end
%% 			end
%% 	end.
%% 
%% %% 支付灵粹
%% %% 返回新的GoodsStatus
%% pay_essence([], GoodsStatus) ->
%% 	GoodsStatus;
%% pay_essence(EssenceList, GoodsStatus) ->
%% 	[{EssenceTypeId, Num}|RestList] = EssenceList,
%%     GoodsList4 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, EssenceTypeId, 4),
%% %% 	GoodsList5 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, EssenceTypeId, 5),	
%% 	{ok, NewStatus} = delete_more(GoodsStatus, GoodsList4, Num),	
%% 	pay_essence(RestList, NewStatus).
%% 
%% %% 水晶开孔
%% open_hole(PlayerStatus, GoodsStatus, GoodsInfo, HoleNum, Cost)->
%% 	NewOthdt = GoodsInfo#goods.othdt ++ [{HoleNum, 0, 0}],
%% 	NewGoodsInfo = GoodsInfo#goods{othdt = NewOthdt},
%% 	db_agent:update_goods_othdt(NewGoodsInfo),
%% 	ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%% 	NewPlayerStatus = lib_goods:cost_money(PlayerStatus, Cost, gold, 1514),
%% 	{ok, NewPlayerStatus, GoodsStatus}.
%% 
%% %% 水晶转换(消耗铜币)
%% cyt_chg_type(PlayerStatus, GoodsStatus, CytTypeInfo, TgtTypeInfo, Num) ->
%% 	case pay_cyt(CytTypeInfo#ets_base_goods.gtid, Num, GoodsStatus) of
%% 		error ->
%% %% 			io:format("~s pay_cyt_error[~p] \n ",[misc:time_format(now()), {CytTypeInfo#ets_base_goods.gtid, Num * 3}]),
%% 			%% 支付水晶失败
%% 			{0, PlayerStatus, GoodsStatus};
%% 		GoodsStatus1 ->
%% 			%% 支付水晶成功，开始转换
%% 			case (catch add_goods_base(GoodsStatus1, TgtTypeInfo, Num)) of
%% 				{ok, NewStatus} ->
%% 					CostCoin = data_crystal:get_cyt_chg_cost(TgtTypeInfo#ets_base_goods.stype, Num), 
%% 					NewPlayerStatus = cost_money(PlayerStatus, CostCoin, coin, 1515),
%% 					NewGoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, TgtTypeInfo#ets_base_goods.gtid),
%% 					%% 日志记录
%% 					spawn(fun()->db_log_agent:log_get_crystal(GoodsStatus#goods_status.uid,
%% 															  TgtTypeInfo#ets_base_goods.gtid,
%% 															  0, 0, Num, 0)end),
%% 					{ok, BinData} = pt_50:write(50000, NewGoodsList),
%% 					lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%                      
%% 					{1, NewPlayerStatus, NewStatus};
%% 				Error ->
%% 					?ERROR_MSG("mod_goods_cyt_chg:~p", [Error]),
%% 					{0, PlayerStatus, GoodsStatus}
%% 			end
%% 	end.	
%% 	
%% 	
%% 
%% %% 水晶及强化石合成
%% cyt_compose(PlayerStatus, GoodsStatus, TgtTypeInfo, Num, CytTypeInfo, GoodsList) ->
%% 	case pay_cyt(CytTypeInfo#ets_base_goods.gtid, Num * 3, GoodsStatus) of
%% 		error ->
%% %% 			io:format("~s pay_cyt_error[~p] \n ",[misc:time_format(now()), {CytTypeInfo#ets_base_goods.gtid, Num * 3}]),
%% 			%% 支付水晶失败
%% 			{0, GoodsStatus};
%% 		GoodsStatus1 ->
%% 			%% 支付水晶成功，开始合成
%% 			TgtGoodsInfo = goods_util:get_new_goods(TgtTypeInfo),
%% 			case (catch add_goods_base(GoodsStatus1, TgtTypeInfo, Num, TgtGoodsInfo, GoodsList)) of
%% 				{ok, NewStatus} ->
%% 					CostCoin = data_crystal:get_cyt_com_cost(TgtTypeInfo#ets_base_goods.type, TgtTypeInfo#ets_base_goods.stype, Num), 
%% 					NewPlayerStatus = cost_money(PlayerStatus, CostCoin, coin, 1518),
%% 					NewGoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, TgtTypeInfo#ets_base_goods.gtid),
%% 					%% 日志记录
%% 					spawn(fun()->db_log_agent:log_get_crystal(GoodsStatus#goods_status.uid,
%% 															  TgtTypeInfo#ets_base_goods.gtid,
%% 															  0, 0, Num, 0)end),
%% 					{ok, BinData} = pt_50:write(50000, NewGoodsList),
%% 					lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%                     
%% 					{1, NewPlayerStatus, NewStatus};
%% 				Error ->
%% 					%io:format("~s essence_shop[~p] \n ",[misc:time_format(now()), 22222]),
%% 		    		?ERROR_MSG("mod_goods pay:~p", [Error]),
%% 		    		{0, GoodsStatus}
%% 			end
%% 	end.	
%% 
%% %% 水晶扣除原料
%% pay_cyt(CytTypeId, Num, GoodsStatus) ->
%%     GoodsList4 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, CytTypeId, 4),
%% %% 	GoodsList5 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, CytTypeId, 5),	
%% 	{ok, NewStatus} = delete_more(GoodsStatus, GoodsList4, Num),
%% 	NewStatus.
%% 
%% %% 水晶镶嵌以及卸载
%% cyt_handler(PlayerStatus, GoodsStatus, GoodsInfo, CytTypeId, Oper, HoleNum) ->
%% 	if
%% 		Oper =:= 1 ->
%% 			%% 水晶镶嵌
%% 			case pay_cyt(CytTypeId, 1, GoodsStatus) of
%% 				error ->
%% %% 					io:format("~s pay_cyt_error(cyt_handler)[~p] \n ",[misc:time_format(now()), {CytTypeId, 1}]),
%% 					%% 支付水晶失败
%% 					{0, PlayerStatus, GoodsStatus};
%% 				GoodsStatus1 ->
%% 					%% 支付水晶成功，开始镶嵌
%% 					spawn(fun() -> add_cost_goods_log(GoodsStatus#goods_status.uid, [{CytTypeId, 1}], 7)end),  %%物品消耗流水日志
%% 					NewOthdt = lists:keyreplace(HoleNum, 1, GoodsInfo#goods.othdt, {HoleNum, CytTypeId, CytTypeId rem 100}),
%% 					NewGoodsInfo = GoodsInfo#goods{othdt = NewOthdt},
%% 					db_agent:update_goods_othdt(NewGoodsInfo),
%% 					ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%% 
%%                     
%% 					{1, PlayerStatus, GoodsStatus1}
%% 			end;
%% 		true ->
%% 			%% 水晶拆卸
%% 			CytTypeInfo = goods_util:get_goods_type(CytTypeId),
%% 			CytInfo = goods_util:get_new_goods(CytTypeInfo),
%% 			GoodsList = goods_util:get_type_goods_list(PlayerStatus#player.id, CytTypeId, 4),
%% 			case (catch lib_goods:add_goods_base(GoodsStatus, CytTypeInfo, 1, CytInfo, GoodsList)) of
%% 				{ok, NewStatus} ->
%% %% 					io:format("mod_goods cyt_handler :~p ~n",[NewStatus]),
%% 					%% 开始拆卸
%% 					CostCoin = data_crystal:get_cyt_unload_cost(CytTypeInfo#ets_base_goods.stype), 
%% 					NewPlayerStatus = cost_money(PlayerStatus, CostCoin, coin, 1519),
%% 					NewOthdt = lists:keyreplace(HoleNum, 1, GoodsInfo#goods.othdt, {HoleNum, 0, 0}),
%% 					NewGoodsInfo = GoodsInfo#goods{othdt = NewOthdt},
%% 					db_agent:update_goods_othdt(NewGoodsInfo),
%% 					ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%% 					NewGoodsList = goods_util:get_type_goods_list(PlayerStatus#player.id, CytTypeId, 4),
%% 					spawn(fun() -> lib_goods:add_get_goods_log(GoodsStatus#goods_status.uid,   %%物品产出日志
%% 															   [{CytTypeId, 1}],
%% 															   0,
%% 															   9) end),
%% %% 					%% 日志记录
%% %% 						spawn(fun()->db_log_agent:log_essence_exchange([PlayerStatus#player.id,
%% %% 																	  GoodsInfo#goods.gtid, 
%% %% 																	  EssType, EssNum])end),
%% 					{ok, BinData} = pt_50:write(50000, NewGoodsList),
%% 					lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%% 					{1, NewPlayerStatus, NewStatus};
%% 				Error ->
%% 					%io:format("~s essence_shop[~p] \n ",[misc:time_format(now()), 22222]),
%% 		    		?ERROR_MSG("mod_goods cyt_handler error:~p", [Error]),
%% 		    		{0, PlayerStatus, GoodsStatus}
%% 			end
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 商城购买
%% %% -----------------------------------------------------------------
%% buy_pet_goods(Status, TypeId, Cost) ->
%% 	Info = data_pet:get_pet_shop_info(TypeId),
%% 	case Info of
%% 		[] ->
%% 			%%找不到则为物品
%% 			case gen_server:call(Status#player.other#player_other.pid_goods, {'give_goods', Status, TypeId, 1}) of
%% 				ok ->
%% 					spawn(fun() -> lib_goods:add_get_goods_log(Status#player.id,   %%物品产出日志
%% 															   [{TypeId, 1}],
%% 															   Cost,
%% 															   1) end),
%% 					Result = 1;
%% 				{_GoodsTypeId, not_found} ->
%% 					Result = 7;
%% 				cell_num ->
%% 					Result = 6;
%% 				_Error ->
%% 					Result = 0
%% 			end,
%% 			if
%% 				Result =:= 1 ->
%% 					NewStatus = lib_goods:cost_money(Status, Cost, gold, 1511),
%% 					
%% 					%% 神兵活动，商城购买3级生命水晶
%% 					if
%% 						TypeId =:= 460301 ->
%% 							lib_reward:reward_event(crystal, [NewStatus]);
%% 						true ->
%% 							ok
%% 					end,
%% 					
%% 					if 
%% 						TypeId =:=  480101 ->
%% 							spawn(fun()-> lib_broadcast:broadcast_info(buy_giant, [Status#player.id, Status#player.nick,TypeId]) end);
%% 						true -> ok
%% 					end,
%% 					
%% 					if 
%% 						TypeId =:=  280201 ->
%% 							spawn(fun()-> lib_broadcast:broadcast_info(buy_pet, [Status#player.id, Status#player.nick, TypeId]) end);
%% 						true -> ok
%% 					end,
%% 						
%% 					
%% 					[1, NewStatus];
%% 				true ->
%% 					[Result, Status]
%% 			end;
%% 		[PetTypeId, _T1,_T2 | _T] ->
%% 			[Result, _PetId, _PetName, _Status] = lib_pet2:create_pet(Status,[PetTypeId, 1, 1]),
%% 			if
%% 				Result =:= 1 ->					
%% 					NewStatus = lib_goods:cost_money(Status, Cost, gold, 1511),
%% 					[1, NewStatus];
%% 				true ->
%% 					[0, Status]
%% 			end
%% 	end.
%% 
%% %%获取回购物品列表->[{}]
%% get_buy_back_goods_list(Uid) ->
%% 	MS2 = ets:fun2ms(fun(T) when T#goods.uid == Uid andalso T#goods.loc == 10 -> T end),
%% 	ets:select(?ETS_GOODS_ONLINE,MS2).
%% 
%% %%获取套装的全装备信息
%% get_suit_all_equip(Stid) ->
%% 	Pattern = #ets_base_goods{type = 10, stid=Stid, _='_' },
%%     goods_util:get_ets_list(?ETS_BASE_GOODS, Pattern).
%% 	
%% %%获取装备可合成信息
%% get_equip_compose_info(PlayerId, EquipList) ->
%% 	Fun = fun(EquipTypeInfo, Acc) ->
%% 				  EquipTypeId = EquipTypeInfo#ets_base_goods.gtid,
%% 				  Nick = EquipTypeInfo#ets_base_goods.name,
%% 				  ComNum = chk_compose_num(PlayerId, EquipTypeId),
%% 				  {{EquipTypeId, Nick, ComNum}, Acc + ComNum}
%% 		  end,
%% 	lists:mapfoldl(Fun, 0, EquipList).
%% 
%% %%检测合成装备可合成数量
%% chk_compose_num(PlayerId, EquipTypeId) ->
%% 	case data_stren:get_equip_compose_material_list(EquipTypeId) of
%% 		error ->
%% 			0;
%% 		MaterialList ->
%% 			Fun = fun({GoodsTypeId, Num}) ->
%% 						  NowNum = goods_util:get_goods_num(PlayerId, GoodsTypeId, 4),
%% 						  NowNum div Num
%% 				  end,
%% 			lists:min(lists:map(Fun, MaterialList))
%% 	end.
%% 
%% %%检测物品失效时间(到期物品做删除处理，并通知玩家进程更新属性和背包)（物品进程使用）
%% check_time_goods(GoodsStatus) ->
%% %% 	io:format("~s check_time_goods_1_[~p] \n ",[misc:time_format(now()), GoodsStatus]),
%% 	Uid = GoodsStatus#goods_status.uid,
%% 	Now = util:unixtime(),
%% 	MS = ets:fun2ms(fun(T) when T#goods.uid =:= Uid, T#goods.eprt =< Now, T#goods.eprt > 0 -> T end),
%% 	case ets:select(?ETS_GOODS_ONLINE, MS) of
%% 		[] ->
%% 			GoodsStatus;
%% 		DelGoodsList ->
%% 			Fun = fun(M, AccSta) ->
%% 						  if is_record(M, goods) =:= true  ->
%% %% 								 io:format("~s check_time_goods_2_[~p] \n ",[misc:time_format(now()), AccSta]),
%% 								 {ok, NewSta, _Num} = lib_goods:delete_one(AccSta, M, M#goods.num),
%% 								 spawn(fun()->send_goods_eprt_notice(Uid, M#goods.gtid) end),
%% 								 spawn(fun()->db_log_agent:log_goods_handle([Uid,
%% 																			 M#goods.id,
%% 																			 M#goods.gtid,
%% 																			 M#goods.num,
%% 																			 6])end),
%% 								 NewSta;
%% 							 true ->
%% 								 AccSta
%% 						  end
%% 				  end,
%% 			lists:foldl(Fun, GoodsStatus, DelGoodsList)
%% 	end.
%% 
%% 
%% %%注意要”物品进程调用“
%% %%检测背包是否足够
%% chk_player_add_goods_3(GoodsStatus, GoodsList) ->
%% 	case GoodsList of
%% 		[{_ChkId, _ChkNum}|_] ->
%% 			{BagGoodsList, _VtlGoodsList} = split_goods(GoodsList),
%% 			case mod_goods:multi_check_get(ok, 1, [], GoodsStatus, BagGoodsList, []) of
%% 				{fail, Res} ->
%% 					Res;
%% 				{ok, GoodsTypeInfos} ->
%% 					{1, GoodsTypeInfos};
%% 				_ ->
%% 					0
%% 			end;
%% 		_ ->
%% 			0
%% 	end.
%% 			
%% 
%% %%注意要”物品进程调用“
%% %%获取物品到背包公共接口（包括虚拟物品）:错误码为添加背包的错误码，如果成功返回虚拟物品列表（虚拟物品列表的添加需要到人物进程处理）
%% %% Flag增加经验标识符：1-只加人物，2-只加宠物，3-人物和宠物都加(取消，由物品ID判定)
%% player_add_goods_3(GoodsStatus, GoodsList, CostPoint, GoodsType) ->
%% 	case GoodsList of
%% 		[{_ChkId, _ChkNum}|_] ->
%% 			{BagGoodsList, VtlGoodsList} = split_goods(GoodsList),
%% 			LenGetGoodsList = length(BagGoodsList),	
%% 			case LenGetGoodsList > length(GoodsStatus#goods_status.null_cells) of    %%防止使用礼包类物品（有随机掉落不同物品）时被刷为指定物品
%% 				false  ->
%% 					case BagGoodsList of
%% 						[] ->
%% 							case GoodsType of
%% 								20 ->  %%礼包
%% 									{1, GoodsStatus, [GoodsList, VtlGoodsList, CostPoint]};
%% 								45 ->  %%随机箱子
%% 									{1, GoodsStatus, [GoodsList, VtlGoodsList, CostPoint]};
%% 								_ ->
%% 									{1, GoodsStatus, [[], VtlGoodsList, CostPoint]}
%% 							end;
%% 						_ ->
%% 							case catch(mod_goods:multi_check_get(ok, 1, [], GoodsStatus, BagGoodsList, [])) of
%% 								{fail, Res} ->
%% 									%% 							io:format("~s player_add_goods_3___[~p]_____________~n",[misc:time_format(now()), Res]),
%% 									{Res, GoodsStatus, []};
%% 								{ok, GoodsTypeInfos} ->
%% 									GetResult = mod_goods:multi_get_goods([], GoodsStatus, GoodsTypeInfos),
%% 									case GetResult of
%% 										{1, FinalGoodsStatus} ->
%% 											spawn(fun() -> public_add_get_goods_log(GoodsStatus#goods_status.uid,   %%物品产出日志
%% 																					BagGoodsList,
%% 																					0,
%% 																					CostPoint) end),
%% 											Fun = fun(GoodsTypeId, AccList) ->
%% 														  TmpBGoodsL = goods_util:get_type_goods_list(FinalGoodsStatus#goods_status.uid, GoodsTypeId),
%% 														  case TmpBGoodsL of
%% 															  [TmpR|_] when is_record(TmpR, goods) ->
%% 																  AccList ++ TmpBGoodsL;
%% 															  _ ->
%% 																  AccList
%% 														  end
%% 												  end,
%% 											NewBagGoodsList = lists:foldl(Fun, [], lists:usort([TmpId||{TmpId, _TmpNum}<-BagGoodsList])),
%% 											%% 发送50000协议通知客户端更新背包系统数据
%% 											{ok, BinData1} = pt_50:write(50000, NewBagGoodsList),									
%% 											lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData1),
%% 											TmpPlayer = #player{id = FinalGoodsStatus#goods_status.uid, other = #player_other{pid_send = GoodsStatus#goods_status.pid_send}},
%% 											%%lib_goods_use:add_pet_egg_timer(TmpPlayer),
%% 											case GoodsType of
%% 												20 ->  %%礼包
%% 													{1, FinalGoodsStatus, [GoodsList, VtlGoodsList, CostPoint]};
%% 												45 ->  %%随机物品
%% 													{1, FinalGoodsStatus, [GoodsList, VtlGoodsList, CostPoint]};
%% 												_ ->
%% 													{1, FinalGoodsStatus, [[], VtlGoodsList, CostPoint]}
%% 											end;
%% 										_ ->
%% 											{0, GoodsStatus, []}
%% 									end;
%% 								_ ->
%% 									{0, GoodsStatus, []}
%% 							end
%% 					end;
%% 				_ ->
%% 					{4, GoodsStatus, []}
%% 			end;
%% 		_ ->
%% 			{0, GoodsStatus, []}
%% 	end.
%% 
%% 
%% %%注意要”非物品进程调用“。并且调用时不能使用catch来容错，这种方式有可能产生物品被刷，如果出现异常
%% %%获取物品到背包公共接口（包括虚拟物品）:先添加虚拟物品再加背包，错误码为添加背包的错误码，并返回剩余背包物品列表
%% %% Flag增加经验标识符：1-只加人物，2-只加宠物，3-人物和宠物都加
%% %% player_add_goods_1(Player, GoodsList, CostPoint) ->   %%容错防刷处理
%% %% 	case catch (player_add_goods_1_handle(Player, GoodsList, CostPoint)) of
%% %% 		{Res, PChg, Player1, GoodsL} when is_integer(Res) ->
%% %% 			{Res, PChg, Player1, GoodsL};
%% %% 		_ ->                         %%出现异常当做成功,并添加日志表
%% %% 			spawn(fun() -> db_log_agent:log_add_goods_err([Player#player.id, CostPoint, GoodsList]) end),
%% %% 			{1, 0, Player, []}
%% %% 	end.
%% 	
%% player_add_goods_1(Player, GoodsList, CostPoint) ->
%% 	case GoodsList of
%% 		[{_ChkId, _ChkNum}|_] ->
%% 			{BagGoodsList, VtlGoodsList} = split_goods(GoodsList),
%% 			{PChg, Player1} = add_virtual_goods(Player, VtlGoodsList, CostPoint),
%% 			case BagGoodsList of
%% 				[] ->
%% 					{1, PChg, Player1, []};
%% 				_ ->
%% 					case catch (gen_server:call(Player1#player.other#player_other.pid_goods, {'get_multi', Player1, BagGoodsList})) of
%% 						1 ->
%% 							if
%% 								CostPoint =/= 4702 ->									%%挂机的物品日志集中写了
%% 									spawn(fun() -> public_add_get_goods_log(Player#player.id,   %%物品产出日志
%% 																	BagGoodsList,
%% 																	0,
%% 																	CostPoint) end);
%% 								true ->
%% 									skip
%% 							end,
%% 							{1, PChg, Player1, []};
%% 						ErrorNum when is_integer(ErrorNum) ->      %%错误码（0-执行失败, 2- 物品不存在, 4-背包格子不够）
%% 							{ErrorNum, PChg, Player1, BagGoodsList};
%% 						_ ->
%% %% 							spawn(fun() -> db_log_agent:log_add_goods_err([Player#player.id, CostPoint, BagGoodsList]) end),
%% 							{0, PChg, Player1, BagGoodsList}
%% 					end
%% 			end;
%% 		_ ->
%% 			{0, 0, Player, GoodsList}
%% 	end.
%% 
%% %%注意要”非物品进程调用“。
%% %%获取物品到背包公共接口（包括虚拟物品）:先添加背包物品再加虚拟物品，返回错误码表示没有添加任何物品（包括虚拟物品）
%% player_add_goods_2(Player, GoodsList, CostPoint) ->
%% 	case GoodsList of
%% 		[{_ChkId, _ChkNum}|_] ->
%% 			{BagGoodsList, VtlGoodsList} = split_goods(GoodsList),
%% 			case BagGoodsList of
%% 				[] ->
%% 					{PChg, Player1} = add_virtual_goods(Player, VtlGoodsList, CostPoint),
%% 					{1, PChg, Player1};
%% 				_ ->
%% 					case catch(gen_server:call(Player#player.other#player_other.pid_goods, {'get_multi', Player, BagGoodsList})) of
%% 						1 ->
%% 							spawn(fun() -> public_add_get_goods_log(Player#player.id,   %%物品产出日志
%% 																	BagGoodsList,
%% 																	0,
%% 																	CostPoint) end),
%% 							{PChg, Player1} = add_virtual_goods(Player, VtlGoodsList, CostPoint),
%% 							{1, PChg, Player1};
%% 						ErrorNum when is_integer(ErrorNum) ->      %%错误码（0-执行失败, 2- 物品不存在, 4-背包格子不够）
%% 							{ErrorNum, 0, Player};
%% 						_ ->
%% %% 							spawn(fun() -> db_log_agent:log_add_goods_err([Player#player.id, CostPoint, GoodsList]) end),
%% 							{0, 0, Player}
%% 					end
%% 			end;
%% 		_ ->
%% 			{0, 0, Player}
%% 	end.
%% 
%% 
%% %%分离出虚拟物品和背包物品
%% split_goods(GoodsList) ->
%% 	Fun = fun({GoodsId, GNum}, {BGoodsList, VGoodsList}) ->
%% 				  case GoodsId of
%% 					  210101 -> %%铜币
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210201 -> %%元宝
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210301 -> %%全部经验（即加人物和宠物）
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  212001 -> %%人物经验
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  212101 -> %%宠物经验
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210401 -> %%体力
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210501 -> %%灵力
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210601 -> %%战勋
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210701 -> %%联盟贡献度
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210801 -> %%元魂
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  210901 -> %%灵魄
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211001 -> %%联盟玉牌
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211101 -> %%蓝色兽魂
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211201 -> %%紫	色兽魂
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211301 -> %%橙色兽魂
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211701 -> %%蓝色兽魄(精魄)
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211801 -> %%紫色兽魄(气魄)
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211901 -> %%橙色兽魄(神魄)
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211401 -> %%兽灵残页
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211501 -> %%兽灵残章
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  211601 -> %%兽灵残卷
%% 						  {BGoodsList, VGoodsList ++ [{GoodsId, GNum}]};
%% 					  _ ->
%% 						  {BGoodsList ++ [{GoodsId, GNum}], VGoodsList}
%% 				  end
%% 		  end,	
%% 	{BagGoodsList, VtlGoodsList} = lists:foldl(Fun, {[], []}, GoodsList),
%% 	{BagGoodsList, VtlGoodsList}.
%% 
%% %%添加虚拟物品
%% add_virtual_goods(Player, VtlGoodsList, CostPoint) ->
%% 	case catch(add_virtual_goods_handle(Player, VtlGoodsList, CostPoint)) of
%% 		{PChg, Player1} when is_integer(PChg) ->
%% 			{PChg, Player1};
%% 		_ ->
%% 			spawn(fun() -> db_log_agent:log_add_goods_err([Player#player.id, CostPoint, VtlGoodsList]) end),
%% 			{0, Player}
%% 	end.
%% 
%% add_virtual_goods_handle(Player, VtlGoodsList, CostPoint) ->
%% 	Fun = fun({GoodsId, GNum}, {BChg, BPlayer}) ->
%% 				  case GoodsId of
%% 					  210101 -> %%铜币
%% 						  EPlayer = lib_goods:add_money(BPlayer, GNum, coin, CostPoint),
%% 						  {BChg bor 1, EPlayer};
%% 					  210201 -> %%元宝
%% 						  EPlayer = lib_goods:add_money(BPlayer, GNum, gold, CostPoint),
%% 						  {BChg bor 1, EPlayer};
%% 					  210301 -> %%全部经验（即加人物和宠物）
%% 						  EPlayer = lib_player:add_exp(BPlayer, GNum, 0, 0),
%% 						  ActPetList = lib_formation:getActPet(),
%% 						  [lib_pet2:add_pet_exp(BPlayer, PetId, GNum)||PetId<-ActPetList],
%% 						  {BChg bor 1, EPlayer};
%% 					  212001 -> %%人物经验
%% 						  EPlayer = lib_player:add_exp(BPlayer, GNum, 0, 0),
%% 						  {BChg bor 1, EPlayer};
%% 					  212101 -> %%宠物经验
%% 						  ActPetList = lib_formation:getActPet(),
%% 						  [lib_pet2:add_pet_exp(BPlayer, PetId, GNum)||PetId<-ActPetList],
%% 						  {BChg, BPlayer};
%% 					  210401 -> %%体力
%% 						  EPlayer = lib_player:add_energy(BPlayer, GNum, CostPoint),
%% 						  {BChg bor 1, EPlayer};
%% 					  210501 -> %%灵力
%% 						  EPlayer = lib_player:add_goth(BPlayer, GNum),
%% 						  {BChg bor 1, EPlayer};
%% 					  210601 -> %%战勋
%% 						  EPlayer = lib_player:add_prstg(BPlayer, GNum, CostPoint),
%% 						  {BChg bor 1, EPlayer};
%% 					  210701 -> %%联盟贡献度
%% 						  {BChg, BPlayer};
%% 					  210801 -> %%元魂
%% 						  {BChg, BPlayer};
%% 					  210901 -> %%灵魄
%% 						  EPlayer = lib_ghost:add_spr(BPlayer, GNum, CostPoint),
%% 						  {BChg bor 1, EPlayer};
%% 					  211001 -> %%联盟玉牌
%% 						  {BChg, BPlayer};
%% 					  211101 -> %%蓝色兽魂
%% 						  lib_hunt2:add_hunt_soul(BPlayer, 1, GNum, CostPoint),
%% 						  {BChg, BPlayer};
%% 					  211201 -> %%紫色兽魂
%% 						  lib_hunt2:add_hunt_soul(BPlayer, 2, GNum, CostPoint),
%% 						  {BChg, BPlayer};
%% 					  211301 -> %%橙色兽魂
%% 						  lib_hunt2:add_hunt_soul(BPlayer, 3, GNum, CostPoint),
%% 						  {BChg, BPlayer};
%% 					  211401 -> %%兽灵残页
%% 						  lib_giant_s:add_giant_subbook(BPlayer, 1, GNum),
%% 						  {BChg, BPlayer};
%% 					  211501 -> %%兽灵残章
%% 						  lib_giant_s:add_giant_subbook(BPlayer, 2, GNum),
%% 						  {BChg, BPlayer};
%% 					  211601 -> %%兽灵残卷
%% 						  lib_giant_s:add_giant_subbook(BPlayer, 3, GNum),
%% 						  {BChg, BPlayer};
%% 					  211701 -> %%精魄
%% 						  lib_giant_s:add_giant_soul(BPlayer, 1, GNum),
%% 						  {BChg, BPlayer};
%% 					  211801 -> %%气魄
%% 						  lib_giant_s:add_giant_soul(BPlayer, 2, GNum),
%% 						  {BChg, BPlayer};
%% 					  211901 -> %%神魄
%% 						  lib_giant_s:add_giant_soul(BPlayer, 3, GNum),
%% 						  {BChg, BPlayer};
%% 					  _ ->
%% 						  {BChg, BPlayer}
%% 				  end
%% 		  end,	
%% 	{PChg, Player1} = lists:foldl(Fun, {0, Player}, VtlGoodsList),
%% 	case PChg of
%% 		1 ->
%% 			lib_player:send_player_add_exp1(Player1, Player),
%% 			lib_player:send_player_attribute2(Player1, 3);
%% 		_ ->
%% 			skip
%% 	end,
%% 	{PChg, Player1}.
%% 
%% %%发送玩家物品到期删除的通知
%% send_goods_eprt_notice(Uid, GoodsTypeId) ->
%% 	GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%% %% 	io:format("~s send_goods_eprt_notice_1_[~p] \n ",[misc:time_format(now()), GoodsTypeInfo]),
%% 	Content = lists:concat(["<font color = '#FF6C00'>",tool:to_list(GoodsTypeInfo#ets_base_goods.name),"</font> 超过有效期，系统已自动删除！"]),
%% %% 	io:format("~s send_goods_eprt_notice_2_[~p] \n ",[misc:time_format(now()), Content]),
%% 	lib_notice:mail_to_one(Uid, 0, 18, Content, GoodsTypeId).
%% 
%% %%查询玩家的等级礼包(月光宝盒)信息
%% get_player_level_gift_info(PlayerStatus) ->
%% 	GoodsList1 = goods_util:get_goods_by_type(PlayerStatus#player.id, 20, 2),				%%寻找20类型、2子类型的物品(现在不止月光宝盒是这种类型了)
%% 	if
%% 		GoodsList1 =:= [] ->
%% 			[0,0,[],0,0,[]];	%%没有
%% 		true ->
%% 			BoxesIdList = [200101, 200102, 200103, 200104],			%%所以要过滤出月光宝盒
%% 			GoodsList2 = [Goods||Goods<-GoodsList1, lists:member(Goods#goods.gtid, BoxesIdList)],
%% 			if 
%% 				GoodsList2 =:= [] -> 				%%物品不存在
%% 					[0,0,[],0,0,[]];
%% 				true ->
%% 					[GoodsInfo|_] = GoodsList2,
%% 					NeedLv = GoodsInfo#goods.lv,
%% 					F = fun(Goods) ->								%%用于过渡掉盒子本身
%% 								{Gtid, _} = Goods,
%% 								case lists:member(Gtid, BoxesIdList) of
%% 									false ->
%% 										true;
%% 									true ->
%% 										false
%% 								end
%% 						end,
%% 					if
%% 						PlayerStatus#player.lv >= NeedLv ->			%%当前的盒子可打开
%% 							CurGiftTid = GoodsInfo#goods.gtid,
%% 							GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),	%%基础物品
%% 							CurGiftLv = GoodsTypeInfo#ets_base_goods.lv,
%% 							CurGiftGoods2 = util:string_to_term(tool:to_list(GoodsTypeInfo#ets_base_goods.other_data)),
%% 							
%% 							CurGiftGoods3 = lists:filter(F, CurGiftGoods2),		%%把里面的盒子过渡掉
%% 							
%% 							NextGift = [Gtid || {Gtid,_}<-CurGiftGoods2, lists:member(Gtid, BoxesIdList)],
%% 							if
%% 								NextGift =:= [] ->			%%里面没有下一阶段的盒子
%% 									NextGiftTid    = 0,
%% 									NextGiftLv     = 0,
%% 									NextGiftGoods2 = [];
%% 								true ->
%% 									[NextGiftTid|_] = NextGift,
%% 									NextGiftGoodsTypeInfo = goods_util:get_goods_type(NextGiftTid),	%%基础物品
%% 									NextGiftLv = NextGiftGoodsTypeInfo#ets_base_goods.lv,
%% 									NextGiftGoods2 = util:string_to_term(tool:to_list(NextGiftGoodsTypeInfo#ets_base_goods.other_data))
%% 							end,
%% 							NextGiftGoods3 = lists:filter(F, NextGiftGoods2),
%% 							[CurGiftTid, CurGiftLv, CurGiftGoods3, NextGiftTid, NextGiftLv, NextGiftGoods3];
%% 						true ->									%%当前的盒子不可打开
%% 							CurGiftTid = 0,
%% 							CurGiftLv = 0,
%% 							CurGiftGoods = [],
%% 							
%% 							NextGiftTid = GoodsInfo#goods.gtid,
%% 							GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),	%%基础物品
%% 							NextGiftLv = GoodsTypeInfo#ets_base_goods.lv,
%% 							NextGiftGoods2 = util:string_to_term(tool:to_list(GoodsTypeInfo#ets_base_goods.other_data)),
%% 							NextGiftGoods3 = lists:filter(F, NextGiftGoods2),		%%把里面的盒子过渡掉
%% 							[CurGiftTid, CurGiftLv, CurGiftGoods, NextGiftTid, NextGiftLv, NextGiftGoods3]
%% 					end
%% 			end
%% 	end.
%% 
%% %%合并相同类型的物品数量
%% sum_goods_num(GoodsList) ->
%% 	Fun = fun({GoodsId, GoodsNum}, AccList) ->
%% 				  case [{GoodsId1, GoodsNum1}||{GoodsId1, GoodsNum1} <- AccList, GoodsId1 =:= GoodsId] of
%% 					  [] ->
%% 						  [{GoodsId, GoodsNum}|AccList];
%% 					  [{GoodsId2, GoodsNum2}|_] ->
%% 						  NewGoodsNum = GoodsNum2 + GoodsNum,
%% 						  lists:keyreplace(GoodsId2, 1, AccList, {GoodsId2, NewGoodsNum});
%% 					  _ ->
%% 						  AccList
%% 				  end
%% 		  end,
%% 	lists:foldl(Fun, [], GoodsList).
%% 
%% %%分离普通物品和商城物品, 并附加元宝消耗单价
%% split_shop_goods(GoodsList, CostGold) ->
%% 	if CostGold > 0 ->
%% 		   case GoodsList of
%% 			   [] ->
%% 				   [];
%% 			   _ ->
%% 				   ShopGoodsList = data_shop:get_shop_goods_list(),
%% 				   Fun = fun({GoodsId, Num}, {AccL1, AccL2, AccNum}) ->
%% 								 case lists:member(GoodsId, ShopGoodsList) of
%% 									 true ->
%% 										 {[{GoodsId, Num}|AccL1], AccL2, AccNum + Num};
%% 									 _ ->
%% 										 {AccL1, [{GoodsId, Num}|AccL2], AccNum}
%% 								 end
%% 						 end,
%% 				   {GetShopLTmp, OtherLTmp, ShopAllNum} = lists:foldl(Fun, {[], [], 0}, GoodsList),
%% 				   if
%% 					   ShopAllNum > 0 ->
%% 						   Pric1 = round(CostGold / ShopAllNum);
%% 					   true ->
%% 						   Pric1 = CostGold
%% 				   end,
%% 				   GetShopL = [{GoodsId1, Num1, Pric1}||{GoodsId1, Num1}<-GetShopLTmp],
%% 				   OtherL = [{GoodsId2, Num2, 0}||{GoodsId2, Num2}<-OtherLTmp],
%% 				   lists:merge(GetShopL, OtherL)
%% 		   end;
%% 	   true ->
%% 		   [{GoodsId, Num, 0}||{GoodsId, Num}<-GoodsList]
%% 	end.
%% 
%% %%物品消耗流水日志（批量添加）
%% add_cost_goods_log(PlayerId, GoodsList, Type) ->
%% 	Fun = fun({GoodsTypeId, Num}) ->
%% 				  db_log_agent:log_goods_handle([PlayerId,   %%物品消耗流水日志
%% 												 0,
%% 												 GoodsTypeId,
%% 												 Num,
%% 												 Type])
%% 		  end,
%% 	lists:foreach(Fun, GoodsList).
%% 
%% %%物品获得流水日志(这里只记元宝消费价格)
%% add_get_goods_log(PlayerId, GoodsList, CostGold, Type) ->
%% 	SumGoodsList = sum_goods_num(GoodsList),
%% 	ChkGoodsList = split_shop_goods(SumGoodsList, CostGold),
%% 	Fun = fun({Id, Num, Pric}) ->
%% 				  db_log_agent:log_get_goods_handle([PlayerId,Id,Num,Type,Pric,1])
%% 		  end,
%% 	lists:foreach(Fun, ChkGoodsList).
%% 	
%% %%消费点转换物品产出类型
%% point_to_goods_get_type(Point) ->
%% 	Type = Point div 100,
%% 	if 
%% 		Type =:= 71 -> 2;
%% 		Type =:= 72 -> 3;
%% 		true ->
%% 			case Point of
%% 				1511 -> 1;		%%商城购买			->	商城购买
%% 				1514 -> 8;		%%装备开孔			-> 	物品合成
%% 				1515 -> 8;		%%水晶转换 			-> 	物品合成
%% 				1518 -> 8;	    %%水晶及强化石合成 	->	物品合成
%% 				1519 -> 9;		%%水晶拆卸			->	装备上摘除水晶等
%% 				1520 -> 1;		%%购买普通物品		->	商城购买
%% 				1557 -> 8;		%%精炼装备 	 		-> 	物品合成
%% 				1559 -> 8;		%%装备合成			->	物品合成
%% 				1561 -> 8;		%%装备强化			->	物品合成
%% 				1571 -> 1;		%%购买装备			->	商城购买
%% 				1580 -> 3;		%%使用物品			->	使用物品
%% 				1706 -> 1;		%%买家购买东西		->	商城购买
%% 				1810 -> 16;   	%%多人竞技替身娃娃	->	多人竞技替身娃娃
%% 				1811 -> 15;   	%%世界BOSS替身娃娃	->	世界BOSS替身娃娃
%% 				2002 -> 4;		%%战斗掉落			->	单人打怪掉落
%% 				3004 -> 18;		%%完成任务奖励		->	任务奖励
%% 				3100 ->	11;		%%活动礼包领取		->	系统赠送（运营活动奖励，系统补偿等）
%% 				3102 ->	18;		%%立即完成日常任务	->	任务奖励
%% 				3105 -> 18;		%%正常完成日常任务	->	任务奖励
%% 				3110 ->	18;		%%每周日常奖励		->	任务奖励
%% 				3161 ->	18;		%%收藏游戏奖励		->	任务奖励
%% 				3082 -> 18;		%%联盟任务奖励		->	任务奖励
%% 				3229 -> 8;		%%重铸五行珠			->	物品合成
%% 				3504 -> 6;		%%多人副本掉落		->	多人副本掉落
%% 				3601 -> 7;		%%世界BOSS掉落		->	世界BOSS掉落
%% 				4026 ->	1;		%%联盟商店购买		->	商城购买
%% 				4124 -> 1;		%%宠物商店买宠物		-> 	商城购买
%% 				4213 -> 17;		%%砸圣树果实			->	圣树奖励
%% 				4214 -> 17;		%%圣树注灵			->	圣树奖励
%% 				4528 -> 19;		%%兑换经验丹			->	兑换
%% 				4702 -> 4;		%%挂机副本			->	单人打怪掉落
%% 				4914 -> 10;		%%挖矿所得			->	挖矿掉落
%% 				5211 ->	18;		%%每日签到奖励		->	任务奖励
%% 				5212 -> 18;		%%领取7日签到奖励	->  任务奖励
%% 				5213 ->	18;     %%领取准点签到奖励	->  任务奖励
%% 				5612 -> 2;		%%开礼包箱子			->	开礼包
%% 				5624 ->	13;		%%竞技场排名奖励		->	单人竞技场排名奖励
%% 				5901 -> 18;		%%长生目标奖励		->  任务奖励
%% 				6011 -> 7;		%%挑战者领取战斗奖励	->	世界BOSS掉落
%% 				6312 ->	5;		%%精英副本奖励		->  精英副本掉落
%% 				_ -> 11      %%默认系统赠送
%% 
%% 			end
%% 	end.
%% 
%% %%公共接口添加物品获得流水日志
%% public_add_get_goods_log(PlayerId, GoodsList, CostGold, Point) ->
%% 	GetType = point_to_goods_get_type(Point),
%% 	add_get_goods_log(PlayerId, GoodsList, CostGold, GetType).
%% 				
%% 				
%% 
%% 
