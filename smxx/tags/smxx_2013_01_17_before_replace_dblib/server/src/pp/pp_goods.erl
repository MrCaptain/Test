%%%--------------------------------------
%%% @Module  : pp_goods
%%% @Author  : csj
%%% @Created : 2011.8.23
%%% @Description:  物品操作
%%%--------------------------------------

-module(pp_goods).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-compile(export_all).
%%查询物品详细信息
%% handle(15000, PlayerStatus, [GoodsId]) ->
%%     gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'info_15000', GoodsId}),
%%     ok;
%% 
%% %%查询别人物品详细信息 此接口只查询在线物品信息 玩家离线不返回物品信息
%% handle(15001, PlayerStatus, [OtherPlayerId, GoodsId]) ->
%%     gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'info_15001', PlayerStatus#player.id, OtherPlayerId, GoodsId}),
%%     ok;	
%% 
%% %%获取强化CD
%% handle(15002,PlayerStatus, _) ->
%% 	{Data,F} = lib_cooldown:get_cd(1),
%% 	case F of
%% 		true ->
%% 			Flg = 0;
%% 		_ ->
%% 			Flg = 1
%% 	end,
%% 	{ok, BinData} = pt_15:write(15002, [Flg,Data]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %%查询别人物品详细信息  玩家离线返回物品信息
%% %%处理暂时只读数据表,优化可做缓存
%% handle(15003, PlayerStatus, [OtherPlayerId, GoodsId]) ->
%%     gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'info_15003', PlayerStatus#player.id, OtherPlayerId, GoodsId}),
%%     ok;	
%% 
%% %%查询类型物品的高级信息
%% handle(15004,PlayerStatus,[Goods_id]) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 							{'typeinfo_15004',Goods_id}),
%% 	ok;
%% 
%% handle(15005,PlayerStatus, _) ->
%% 	{Res,NStatus} = lib_cooldown:clear_cd(1,PlayerStatus,1505),
%% 	%%?DEBUG("read: ~p",[Res]), 
%% 
%% 	{ok, BinData} = pt_15:write(15005, Res),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	lib_player:send_player_attribute2(NStatus,[]),
%% 	{ok,NStatus};	
%% 
%% %%查询玩家某个位置的物品列表
%% handle(15010, PlayerStatus, Location) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 					{'list_15010', PlayerStatus, Location}),
%% 	ok;
%% 
%% %%查询别人身上装备列表
%% handle(15011, PlayerStatus, OtherPlayerId) ->
%%    gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 				   {'list_other_15011', OtherPlayerId}),
%%    ok;
%% 
%% %%获取要修理装备列表
%% handle(15012, PlayerStatus, mend_list) ->
%%    gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 				   {'mend_list_15012', 1}),
%%    ok;
%% 
%% %% 取商店物品列表
%% handle(15013, PlayerStatus, [ShopType, ShopSubtype]) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 				   {'shop_15013', ShopType, ShopSubtype}),
%% 	ok;
%% 
%% %% 列出背包打造装备列表
%% handle(15014, PlayerStatus, make_list) ->
%%    	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 					 {'make_list_15014'}),
%% 	ok;
%% 
%% %% 列出装备打造位置约定信息
%% handle(15015,PlayerStatus,[Position]) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 					{'make_position_goods_15015',Position}),
%% 	ok;
%% 
%% 
%% %% 列出物品cd列表
%% handle(15016,PlayerStatus,cd_list) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 					{'cd_list_15016'}),
%% 	ok;
%% 	
%% 
%% %% 获取物品位置全部物品信息
%% handle(15017,PlayerStatus,[Location]) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 					{'all_info_list_15017',
%% 					 PlayerStatus#player.id,
%% 					 Location}),
%% 	ok;
%% 
%% 
%% %%购买物品
%% %% handle(15020, PlayerStatus, [GoodsTypeId, GoodsNum, ShopType ,ShopSubtype]) ->
%% %% 	Is_operate_ok = tool:is_operate_ok(pp_15020,1),
%% %% 	case Is_operate_ok of
%% %%     	true ->
%% %% 			[NewPlayerStatus, Res, GoodsList] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'pay', PlayerStatus, GoodsTypeId, GoodsNum, ShopType ,ShopSubtype}),
%% %% %% 			if
%% %% %% 				%%增加特惠区购买记录
%% %% %% 				ShopType =:= 1 andalso ShopSubtype =:= 6 andalso Res =:=1 ->
%% %% %% 					case misc:whereis_name({global, mod_shop_process}) of
%% %% %% 						Pid when is_pid(Pid) ->	
%% %% %% 							gen_server:cast(Pid,{'th_sell_add',GoodsTypeId});
%% %% %% 						_ ->
%% %% %% 							skip
%% %% %% 					end;
%% %% %% 				true ->
%% %% %% 					skip
%% %% %% 			end,
%% %% 			if
%% %% 				Res =:= 1 ->
%% %% 					%% 发送50000协议通知客户端更新背包系统数据
%% %% 					{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 					
%% %% 					lib_goods_use:add_pet_egg_timer(PlayerStatus);
%% %% 				true ->
%% %% 					ok
%% %% 			end;
%% %% 		 _ ->
%% %% 			[NewPlayerStatus, Res] = [PlayerStatus,10]
%% %% 	end,
%% %% 	
%% %% 	{ok, BinData} = pt_15:write(15020, [Res, NewPlayerStatus#player.coin, NewPlayerStatus#player.gold]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 	
%% %%     {ok, NewPlayerStatus};
%% 
%% 
%% %%出售物品
%% handle(15021, PlayerStatus, [GoodsId, GoodsNum]) ->
%% 	%%io:format("~s handle_15021[~p/~p]\n",[misc:time_format(now()), GoodsId, GoodsNum]),
%%     [NewPlayerStatus, Res, GoodsTypeId] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'sell', PlayerStatus, GoodsId, GoodsNum}),
%%     {ok, BinData} = pt_15:write(15021, [Res, GoodsId, GoodsTypeId, GoodsNum, NewPlayerStatus#player.coin]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%%     {ok, NewPlayerStatus};
%% 
%% %%回购物品
%% handle(15024, PlayerStatus, [GoodsId, GoodsNum]) ->
%% 	%%io:format("~s handle_15024[~p/~p]\n",[misc:time_format(now()), GoodsId, GoodsNum]),
%%     [Res, NewPlayerStatus, GoodsTypeId, Cell] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'buy_back', PlayerStatus, GoodsId, GoodsNum}),
%%     {ok, BinData} = pt_15:write(15024, [Res, GoodsId, GoodsTypeId, Cell, GoodsNum, NewPlayerStatus#player.coin]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%%     {ok, NewPlayerStatus};
%% 
%% %%购买灵粹
%% handle(15025, PlayerStatus, [GoodsTypeId]) ->
%% 	if 
%% 		GoodsTypeId =:= 100901 orelse GoodsTypeId =:= 1 orelse GoodsTypeId =:= 3 ->	%%若是兑换龙鞍、巨兽，不通过此接口，所以要返回失败
%% 		   {ok, BinData} = pt_15:write(15025, [0, GoodsTypeId]),
%% 		   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 		   ok;
%% 	   true ->
%% 		   case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'essence_shop', PlayerStatus, GoodsTypeId}) of
%% 			   {Res, GoodsList} ->
%% 				   if
%% 					   Res =:= 1 ->
%% 						   %% 发送50000协议通知客户端更新背包系统数据
%% 						   {ok, BinData1} = pt_50:write(50000, GoodsList),
%% 						   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% 						   
%% 						   lib_goods_use:add_pet_egg_timer(PlayerStatus);
%% 					   true ->
%% 						   ok
%% 				   end,
%% 				   {ok, BinData} = pt_15:write(15025, [Res, GoodsTypeId]),
%% 				   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 				   ok;
%% 			   _ ->
%% 				   error
%% 		   end
%% 	end;
%% 
%% 
%% %%扩充背包/仓库
%% handle(15022, PlayerStatus, [Loc, ExtendCellNum]) ->
%%     [NewPlayerStatus, Res, New_num] = 
%% 		gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'extend', Loc, abs(ExtendCellNum), PlayerStatus}),
%%     {ok, BinData} = pt_15:write(15022, [Loc, Res, NewPlayerStatus#player.gold, New_num]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%%     {ok, NewPlayerStatus};
%% %% 
%% %% %%拆分物品
%% %% handle(15023,PlayerStatus,[GoodsId,Num,Pos]) ->
%% %% 	[NewPlayerStatus,Res] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'destruct',PlayerStatus,GoodsId,Num,Pos}),
%% %% 	{ok,BinData} = pt_15:write(15023,[Res]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayerStatus};
%% 
%% %%装备物品
%% handle(15030, PlayerStatus, [GoodsId, Cell]) ->
%% 	%%io:format("~s handle_15030[~p/~p]\n",[misc:time_format(now()), GoodsId, Cell]),
%% 	TempInfo = goods_util:get_goods(GoodsId),
%% 	if
%% 		is_record(TempInfo,goods) ->
%% 			%%防止短时间发包
%% 			DefCell = goods_util:get_equip_cell(PlayerStatus,TempInfo#goods.stype),
%% 			Is_operate_ok = tool:is_operate_ok(lists:concat([pp_15030_,DefCell]),1),
%% 			%%io:format("~s Is_operate_ok[~p]\n",[misc:time_format(now()), Is_operate_ok]),
%% 			if
%% 				Is_operate_ok == true ->
%% 					[NewPlayerStatus, Res, GoodsInfo, OldGoodsInfo, Effect] = 
%% 						gen_server:call(PlayerStatus#player.other#player_other.pid_goods, 
%% 								{'equip', PlayerStatus, GoodsId, Cell}),
%%     				case is_record(OldGoodsInfo, goods) of
%%          				true ->
%%              				OldGoodsId = OldGoodsInfo#goods.id,
%%              				OldGoodsTypeId = OldGoodsInfo#goods.gtid,
%%              				OldGoodsCell = OldGoodsInfo#goods.cell;
%%          				false ->
%%              				OldGoodsId = 0,
%%              				OldGoodsTypeId = 0,
%%              				OldGoodsCell = 0
%%     				end,
%% 					%%io:format("~s eqeqeqeqeqeq[~p]\n",[misc:time_format(now()), {Res, GoodsId, OldGoodsId}]),
%%     				{ok, BinData} = pt_15:write(15030, [Res, GoodsId, OldGoodsId, OldGoodsTypeId, OldGoodsCell, Effect]),
%%     				spawn(fun()->lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)end),
%% 					NewPlayerStatus_Count = 
%% 						case is_record(GoodsInfo,goods) andalso Res =:= 1 of
%% 							true ->
%% 								%%长生目标
%% %% 								if GoodsInfo#goods.lv =:= 1 ->
%% 									   [_NewLocation, _CellNum, EquList_tar] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,{'list', PlayerStatus, 1}),
%% %% 									   io:format("goods equip ~p~n",[EquList_tar]),
%% %% 									   F_tar = fun(CD_tar) ->
%% %% %% 													   io:format("goods equip1 ~p~n",[CD_tar]),
%% %% 													   if CD_tar#goods.lv =:= 1 ->
%% %% 															  true;
%% %% 														  true ->
%% %% 															  false
%% %% 													   end
%% %% 											   end,
%% %% 									   EquTarList = lists:filter(F_tar,EquList_tar),
%% %% 									   io:format("goods equip2 ~p~n",[EquTarList]),
%% 									   Num_tar = length(EquList_tar),
%% %% 									   io:format("goods equip3 ~p~n",[Num_tar]),
%% 									   if Num_tar =:= 6 ->
%% 											  lib_target:target(equip_fy6,Num_tar);
%% 										  true ->
%% 											  ok
%% 									   end,
%% %% 								   true ->
%% %% 									   ok
%% %% 								end,
%% 						
%% 								
%% 								
%% %% 								%% 武器强化效果广播   （新版不需要）
%% %% 								Is_FB = lists:member(GoodsInfo#goods.stype, [9,10,11,12,13]),
%% %% 								if
%% %% 									Is_FB andalso GoodsInfo#goods.stlv >= 7 ->
%% %% 										{ok,BinData2} = pt_12:write(12032,[NewPlayerStatus#player.id,1,GoodsInfo#goods.stlv]),
%% %% 										mod_scene_agent:send_to_area_scene(NewPlayerStatus#player.scn, NewPlayerStatus#player.x, NewPlayerStatus#player.y, BinData2);
%% %% 									true ->
%% %% 										skip
%% %% 								end,
%% %% 								%% 套装效果广播 （新版不需要）
%% %% 								if
%% %% 									PlayerStatus#player.other#player_other.suitid =:= 0 andalso NewPlayerStatus#player.other#player_other.suitid > 0 ->
%% %% 				  						{ok,BinData3} = pt_12:write(12032,[NewPlayerStatus#player.id,2,NewPlayerStatus#player.other#player_other.suitid]),
%% %% 										mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData3);
%% %% 									true ->
%% %% 										skip
%% %% 								end,
%% %% 								MeridianInfo = get(player_meridian),
%% 								chk_open_server_7(NewPlayerStatus),   %%开服活动
%% 								NewPlayerStatus_1 = lib_player:count_player_attribute(NewPlayerStatus),
%% 								lib_player:send_player_attribute3(PlayerStatus, NewPlayerStatus_1),	%%发送属性变化值
%% 								lib_goods:useHpPackAct(NewPlayerStatus_1);
%% 							_ ->
%% 								NewPlayerStatus
%% 						end,
%% 					spawn(fun()->lib_player:send_player_attribute2(NewPlayerStatus_Count, 3)end),
%% 					pp_player:handle(13085, NewPlayerStatus_Count, []),
%%     				{ok, NewPlayerStatus_Count};
%% 				true ->
%% 					{ok,PlayerStatus}
%% 			end;
%% 		true ->
%% 			{ok,PlayerStatus}
%% 	end;			
%%     
%% 
%% %%卸下装备
%% handle(15031, PlayerStatus, GoodsId) ->
%% 	%%io:format("~s handle_15031[~p]\n",[misc:time_format(now()), GoodsId]),
%%     [NewPlayerStatus, Res, GoodsInfo] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'unequip', PlayerStatus, GoodsId}),
%%     case is_record(GoodsInfo, goods) of
%%          true ->
%% 			 %%io:format("~s handle_15031_true[~p]\n",[misc:time_format(now()), GoodsId]),
%%              TypeId = GoodsInfo#goods.gtid,
%%              Cell = GoodsInfo#goods.cell;
%%          false ->
%% 			 %%io:format("~s handle_15031_fail[~p]\n",[misc:time_format(now()), GoodsId]),
%%              TypeId = 0,
%%              Cell = 0
%%     end,
%% 	%%io:format("~s handle_15031[~p/~p/~p]\n",[misc:time_format(now()), GoodsId, TypeId, Cell]),
%% 	%%io:format("~s handle_15031[~p/~p/~p]\n",[misc:time_format(now()), GoodsId, GoodsInfo#goods.gtid, GoodsInfo#goods.cell]),
%%     {ok, BinData} = pt_15:write(15031, [Res, GoodsId, TypeId, Cell]),
%%     spawn(fun()->lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)end),
%% 	NewPlayerStatus_Count =
%%     	case is_record(GoodsInfo,goods) andalso Res =:= 1 of
%% 			true ->
%% %% 				%% 法宝强化效果广播
%% %% 				Is_FB = lists:member(GoodsInfo#goods.stype, [9,10,11,12,13]),
%% %% 				if
%% %% 					Is_FB andalso GoodsInfo#goods.stlv >= 7 ->
%% %% 						{ok,BinData2} = pt_12:write(12032,[NewPlayerStatus#player.id,1,0]),
%% %% 						mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData2);
%% %% 					true ->
%% %% 						skip
%% %% 				end,
%% %% 				%% 套装效果广播  （新版不需要）
%% %% 				if
%% %% 					PlayerStatus#player.other#player_other.suitid > 0 andalso NewPlayerStatus#player.other#player_other.suitid =:= 0 ->
%% %% 				  		{ok,BinData3} = pt_12:write(12032,[NewPlayerStatus#player.id,2,0]),
%% %% 						mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData3);
%% %% 					true ->
%% %% 						skip
%% %% 				end,
%% 				%%io:format("~s handle_15031111111 \n",[misc:time_format(now())]),
%% %% 				MeridianInfo = get(player_meridian),
%% 				NewPlayerStatus_1 = lib_player:count_player_attribute(NewPlayerStatus),
%% 				lib_player:send_player_attribute3(PlayerStatus, NewPlayerStatus_1),	%%发送属性变化值
%% 				lib_goods:useHpPackAct(NewPlayerStatus_1);
%% 			_ ->
%% 				NewPlayerStatus
%% 		end,
%%     spawn(fun()->lib_player:send_player_attribute2(NewPlayerStatus_Count, 3)end),
%% 	pp_player:handle(13085, NewPlayerStatus_Count, []),
%%     {ok, NewPlayerStatus_Count};
%% 
%% %% %%巨兽装备物品
%% %% %%GoodsId:要装备的物品ID; TargetId:目标巨兽ID
%% %% handle(15032, PlayerStatus, [GoodsId, _TargetId]) ->
%% %% 	if GoodsId > 0 ->
%% %% 		%%防止短时间发包
%% %% 		Is_operate_ok = tool:is_operate_ok(lists:concat([pp_15032]), 1),		%%15032包以1秒时间计
%% %% 		if Is_operate_ok =:= true ->						%%若是合法时间发的包
%% %% 			TempInfo = goods_util:get_goods(GoodsId),		%%从ets表取在线goods信息
%% %% 			if is_record(TempInfo,goods) ->					%%是存在的物品
%% %% 				   OldCell = TempInfo#goods.cell,			%%物品原格子位置
%% %% 				   GoodsTypeInfo = goods_util:get_goods_type(TempInfo#goods.gtid),	%%取基本物品信息
%% %% 				   
%% %% 				   if TempInfo#goods.uid =/= PlayerStatus#player.id ->				%%不是自己的物品
%% %% 						  Res = 2;							%%非法物品
%% %% 					  true ->
%% %% 						  %%先取得该玩家的巨兽列表
%% %% 						  GiantList = case get(my_giant_list) of
%% %% 										   NullGiant when (NullGiant =:= undefined orelse NullGiant =:= []) ->   %%没做巨兽登录处理
%% %% 											   misc:cancel_timer(player_log_on_giant_timer),
%% %% 											   lib_giant:handle_giant_log_on(PlayerStatus#player.id, PlayerStatus#player.lv),
%% %% 										       get(my_giant_list);
%% %% 								   		   My_giant_list ->
%% %% 											   My_giant_list
%% %% 									   end,
%% %% 						   if is_list(GiantList) andalso GiantList =/= [] ->%%是存在的巨兽
%% %% 								   GiantList2 = [M||M<-GiantList, M#ets_giant.msid =:= 0],
%% %% 								   if GiantList2 =:= [] ->		
%% %% 										  Res = 5;			%%已有龙鞍
%% %% 									  true ->
%% %% 								   		  [Res, _GoodsInfo, _NewGoodsInfo] = 
%% %% 											  gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'equip_giant', PlayerStatus, GoodsId}),
%% %%     							   			  case Res of
%% %% 												  1 ->					%%成功则更新巨兽龙鞍
%% %% 													  F = fun(M1) ->
%% %% 																  spawn(fun() -> db_agent_giant:update_giant_msid(M1#ets_giant.id, GoodsId, GoodsTypeInfo#ets_base_goods.icon) end),%%更新数据库
%% %% 																  M1#ets_giant{msid = GoodsId,msiid = GoodsTypeInfo#ets_base_goods.icon}
%% %% 														  end, 
%% %% 													  NewGiantList = lists:map(F, GiantList),
%% %% 													  put(my_giant_list, NewGiantList),							%%更新进程字典
%% %% 													  %%mod_giant:change_giant_ms(TargetId, GoodsId);
%% %% 												  	  %% 发送50001协议通知客户端更新背包系统数据
%% %% 													  {ok, BinData1} = pt_50:write(50001, [TempInfo]),	%%通过50001接口发，实际发的是50000
%% %% 													  lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1);
%% %% 									   			  _ ->
%% %% 													  ok
%% %%     						       			  end
%% %% 								   end;
%% %% 						        true ->		
%% %% 						   		    Res = 4		%%非法巨兽
%% %% 						   end
%% %% 					end,
%% %% 
%% %%     				{ok, BinData} = pt_15:write(15032, [Res, GoodsTypeInfo#ets_base_goods.icon, OldCell]),
%% %%     				spawn(fun()->lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)end),
%% %% 				    if Res =:= 1 ->		%%成功装备龙鞍后, 更新角色属性
%% %% 						   lib_saddle:first_equip_saddle(PlayerStatus),
%% %% 						   PlayerStatus0 = lib_saddle:update_attr_by_saddle(PlayerStatus),
%% %% 						   PlayerStatus1 = lib_goods:useHpPackAct(PlayerStatus0),	%%使用气血包
%% %% 						   lib_player:send_player_attribute(PlayerStatus1, 0),				%%通知前端更新人物属性
%% %% 						   spawn(fun()->lib_player:send_player_attribute3(PlayerStatus, PlayerStatus1)end);	%%发送属性变化值
%% %% 					   true ->
%% %% 						   PlayerStatus1 = PlayerStatus
%% %% 				    end,
%% %%     				{ok, PlayerStatus1};
%% %% 				true ->							%%查不到该物品, 不处理		
%% %% 					{ok,PlayerStatus}
%% %% 			end;
%% %% 		true ->				%%距离发包不到1秒不处理
%% %% 			{ok,PlayerStatus}
%% %% 		end;
%% %% 	true ->					%%非法数字ID，不处理
%% %% 		{ok,PlayerStatus}
%% %% 	end;	
%% %% 
%% %% 
%% %% %%巨兽卸下物品(2012-03-30根据策划意见不可卸下巨兽龙鞍,所以改为不处理)
%% %% %%TargetId:目标巨兽ID
%% %% handle(15033, PlayerStatus, [_TargetId]) ->
%% %% 	%%防止短时间发包
%% %% %% 		   Is_operate_ok = tool:is_operate_ok(lists:concat([pp_15033]), 1),		%%15033包以1秒时间计
%% %% 	Is_operate_ok = false,
%% %% 		   if Is_operate_ok =:= true ->				%%若是合法时间发的包
%% %% 				  %%先取得该玩家的巨兽列表
%% %% 				  GiantList = case get(my_giant_list) of
%% %% 								  NullGiant when (NullGiant =:= undefined orelse NullGiant =:= []) ->   %%没做巨兽登录处理
%% %% 									  misc:cancel_timer(player_log_on_giant_timer),
%% %% 								      lib_giant:handle_giant_log_on(PlayerStatus#player.id, PlayerStatus#player.lv),
%% %% 									  get(my_giant_list);
%% %% 								  My_giant_list ->
%% %% 									  My_giant_list
%% %% 							  end,
%% %% 				  if is_list(GiantList) andalso GiantList=/= [] -> %%是存在的巨兽
%% %% 						 GiantList2 = [M||M<-GiantList, M#ets_giant.msid =/= 0],
%% %% 						  if GiantList2 =:= [] ->
%% %% 								 Cell = 0,
%% %% 								 Res = 5;						%%巨兽未装备龙鞍
%% %% 							 true ->
%% %% 								%%处理巨兽要卸下的物品信息
%% %% 								 [Giant|_T] = GiantList2,
%% %% 								 [Res, _NewPlayerStatus, NewGoodsInfo] = 
%% %% 									 gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'unequip_giant', PlayerStatus, Giant#ets_giant.msid}),
%% %%     							   	 case Res of
%% %% 										 1 ->					%%成功则更新巨兽龙鞍
%% %% 											 Cell = NewGoodsInfo#goods.cell,						%%物品新格子位置
%% %% 											 F = fun(M1)->
%% %% 														 spawn(fun() -> db_agent_giant:update_giant_msid(M1#ets_giant.id, 0, 0) end),		%%更新数据库
%% %% 														 M1#ets_giant{msid = 0, msiid = 0}
%% %% 												 end,
%% %% 											 NewGiantList = lists:map(F,GiantList),
%% %% 											 put(my_giant_list, NewGiantList),						%%更新进程字典
%% %% 											 %%mod_giant:change_giant_ms(TargetId, GoodsId);
%% %% 										     %% 发送50000协议通知客户端更新背包系统数据
%% %% 					 						{ok, BinData1} = pt_50:write(50000, [NewGoodsInfo]),
%% %% 					 						lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1);
%% %% 										 _ ->
%% %% 											 Cell = 0,
%% %% 											 ok
%% %%     						       	 end
%% %% 							end;
%% %% 					  true ->
%% %% 						  Cell = 0,
%% %% 						  Res = 4		%%非法巨兽
%% %% 				  end,
%% %% 				  {ok, BinData} = pt_15:write(15033, [Res, Cell]),
%% %%     			  spawn(fun()->lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData)end),
%% %%     			  {ok, PlayerStatus};
%% %% 				true ->									%%距离发包不到1秒不处理
%% %% 					{ok,PlayerStatus}
%% %% 			end;	
%% 
%% %% 商城搜索
%% %% handle(15034, PlayerStatus, [Name]) ->
%% %% 	GoodsList = goods_util:search_goods(Name),
%% %% 	Code =
%% %% 		case length(GoodsList) of
%% %% 			0 -> 0;
%% %% 			_ -> 1
%% %% 		end,
%% %% 	{ok,BinData} = pt_15:write(15034,[Code,GoodsList]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 	
%% 
%% %%拖动背包物品
%% handle(15040, PlayerStatus, [GoodsId, OldCell, NewCell]) ->
%% 	if
%% 		OldCell =/= NewCell ->
%% 			gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'drag_15040',
%% 							PlayerStatus#player.clln,
%% 							GoodsId, OldCell, NewCell});
%% 		true ->
%% 			skip
%% 	end,
%% 	ok;
%%    
%% %%物品存入仓库
%% handle(15041, PlayerStatus, [GoodsId, GoodsNum]) ->
%% %% io:format("~s 15041_______________[~p]\n",[misc:time_format(now()), [GoodsId, GoodsNum]]),
%%     gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 					{'movein_bag_15041',
%% 					PlayerStatus#player.dpn,
%% 					GoodsId, GoodsNum}),
%% 	ok;
%% 
%% 
%% %%从仓库取出物品
%% handle(15042, PlayerStatus, [GoodsId, GoodsNum]) ->
%%     gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 					{'moveout_bag_15042',
%% 					 PlayerStatus#player.clln,
%% 					 GoodsId, GoodsNum}),
%% 	ok;
%% 
%% 
%% %%拖动仓库物品
%% handle(15043, PlayerStatus, [GoodsId, OldCell, NewCell]) ->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 					{'drag_15043',
%% 					PlayerStatus#player.dpn,
%% 					GoodsId, OldCell, NewCell}),
%% 	ok;
%% 
%% %%仓库背包物品交换
%% handle(15044, PlayerStatus, [Location, GoodsId, OldCell, NewCell]) ->
%% 	if
%% 		OldCell =/= NewCell ->
%% 			%%io:format("~s handle:15044[~p]\~n",[misc:time_format(now()), [Location, GoodsId, OldCell, NewCell]]),
%% 			gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'drag_15044', Location,
%% 							PlayerStatus#player.dpn,
%% 							PlayerStatus#player.clln,
%% 							GoodsId, OldCell, NewCell});
%% 		true ->
%% 			skip
%% 	end,
%% 	ok;
%%  
%% %% 使用物品
%% handle(15050, PlayerStatus, [GoodsId, GoodsNum]) ->
%% %%  	io:format("~s 15050 use_goods [~p][~p]\n",[misc:time_format(now()), GoodsId, GoodsNum]),
%% 	GoodsInfo = goods_util:get_goods(GoodsId),
%% 	if is_record(GoodsInfo, goods) ->
%% 			case chk_use_goods(PlayerStatus, GoodsInfo) of
%% 				{1, _FlagNum} ->
%% 					case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'use', PlayerStatus#player.lv, PlayerStatus#player.nick, GoodsId, GoodsNum},8000) of
%% 						[Res, GoodsTypeId, VtlGoodsInfo] ->
%% 							case Res of
%% 								1 ->
%% 									[_AllGetList, VtlGoodsList, CostPoint] = VtlGoodsInfo,
%% 									{PChg, NewPlayerStatus} = lib_goods:add_virtual_goods(PlayerStatus, VtlGoodsList, CostPoint),
%% 									{ok, BinData} = pt_15:write(15050, [1]);
%% 								32 ->
%% 									[AllGetList, VtlGoodsList, CostPoint] = VtlGoodsInfo,
%% 									{PChg, NewPlayerStatus} = lib_goods:add_virtual_goods(PlayerStatus, VtlGoodsList, CostPoint),
%% %% 									io:format("~s 15050 use_goods [~p][~p]\n",[misc:time_format(now()), GoodsId, AllGetList]),
%% 									{ok, BinData} = pt_15:write(15050, [32, AllGetList]);
%% 								1002 ->   %%   成功使用幻化珠
%% 									NewPlayerStatus = PlayerStatus,
%% 									PChg = 0,
%% 									{ok, BinData} = pt_15:write(15050, [1]);
%% 								1010 ->  %%   成功扣除巨兽封印卷轴
%% 									GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),
%% 									[creat_giant, GiantType] = util:string_to_term(tool:to_list(GoodsTypeInfo#ets_base_goods.other_data)),
%% 									lib_giant_s:creat_giant_by_type(PlayerStatus, GiantType),
%% 									NewPlayerStatus = PlayerStatus,
%% 									PChg = 0,
%% 									{ok, BinData} = pt_15:write(15050, [1]);
%% 								1011 ->  %%   成功扣除宠物蛋
%% 									GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),
%% 									[creat_pet, PetType] = util:string_to_term(tool:to_list(GoodsTypeInfo#ets_base_goods.other_data)),
%% 									lib_pet2:create_pet(PlayerStatus,[PetType, 1, 1]),
%% 									NewPlayerStatus = PlayerStatus,
%% 									PChg = 0,
%% 									{ok, BinData} = pt_15:write(15050, [1]);
%% 								_ ->
%% 									NewPlayerStatus = PlayerStatus,
%% 									PChg = 0,
%% 									{ok, BinData} = pt_15:write(15050, [Res])
%% 							end,
%% 
%% 							if
%% 								Res =/= 1007 andalso Res =/= 1004 andalso Res =/= 1008 ->
%% 									lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData);
%% 								true ->
%% 									skip
%% 							end,
%% 							case Res of
%% 								1 ->
%% 									spawn(fun()->lib_task:event(use_goods, {GoodsTypeId}, NewPlayerStatus)end),
%% 									lib_goods_use:add_pet_egg_timer(NewPlayerStatus),
%% 									%% 发送50000协议通知客户端更新背包系统数据 (物品进程已做处理)
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% 									case PChg of
%% 										1 ->
%% 											{ok, NewPlayerStatus};
%% 										_ ->
%% 											ok
%% 									end;
%% 								32 ->
%% 									spawn(fun()->lib_task:event(use_goods, {GoodsTypeId}, NewPlayerStatus)end),
%% 									lib_goods_use:add_pet_egg_timer(NewPlayerStatus),
%% 									case PChg of
%% 										1 ->
%% 											{ok, NewPlayerStatus};
%% 										_ ->
%% 											ok
%% 									end;
%% %% 								1000 -> %%需要判断是否是使用气血包
%% %% 									NewPlayerStatus1 = lib_goods:useHpPackAct(NewPlayerStatus), %%气血包加血处理
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus1};
%% 								1002 -> %%使用了幻化珠
%% 									spawn(fun()->lib_task:event(use_magic, [1], NewPlayerStatus)end),
%% 									spawn(fun()->lib_task:event(use_goods, {GoodsTypeId}, NewPlayerStatus)end),
%% 									lib_goods_use:addMaskBuffTimer(NewPlayerStatus),   %%添加定时器
%% 									NewPlayerStatus1 = lib_goods_use:refMaskBuff(NewPlayerStatus),
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(NewPlayerStatus1#player.other#player_other.pid_send, BinData1),
%% 									{ok, NewPlayerStatus1};
%% %% 								1003 -> %%使用VIP体验卡
%% %% 									NewPlayerStatus1 = lib_goods_use:add_vipcard_timer(NewPlayerStatus),   %%添加定时器
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(NewPlayerStatus1#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus1};
%% %% 								1004 -> %%开启宠物蛋
%% %% 									{NewPlayerStatus1,PetTypeId} = lib_goods_use:open_pet_egg(NewPlayerStatus),   %%开启宠物蛋，生成宠物
%% %% 									{ok, BinData1004} = pt_15:write(15050, [33, PetTypeId]),
%% %% 									lib_send:send_to_sid(NewPlayerStatus1#player.other#player_other.pid_send, BinData1004),
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(NewPlayerStatus1#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus1};
%% %% 								1005 ->
%% %% 									%% 发送50000协议通知客户端更新背包系统数据
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus};
%% %% 								1006 ->
%% %% 									GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),
%% %% 									GiantExp = tool:to_integer(GoodsTypeInfo#ets_base_goods.other_data),
%% %% 									AllGiantExp = GiantExp * GoodsNum,
%% %% 									ActGiant1 = lib_giant:get_self_active_giant(NewPlayerStatus#player.id, NewPlayerStatus#player.lv),
%% %% 									lib_giant:giant_addexp(ActGiant1, AllGiantExp),
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus};
%% %% 								1007 ->
%% %% 									%% 发送50000协议通知客户端更新背包系统数据
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus};
%% %% 								1008 ->	%%积分兑换的宠物蛋
%% %% 									PetTypeId = lib_pet2:create_the_pet(NewPlayerStatus, 5),
%% %% 									{ok, BinData1008} = pt_15:write(15050, [33, PetTypeId]),
%% %% 									lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1008),
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 									{ok, NewPlayerStatus};
%% %% 								2022 -> %%活动礼包
%% %% 									lib_goods_use:add_pet_egg_timer(NewPlayerStatus),
%% %% 									%% 发送50000协议通知客户端更新背包系统数据
%% %% 									{ok, BinData1} = pt_50:write(50000, GoodsList),
%% %% 									lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% 									GoodsTypeInfo = goods_util:get_goods_type(GoodsInfo#goods.gtid),
%% %% 									[_Coin, _Gold, GoodsOtherList] = util:string_to_term(tool:to_list(GoodsTypeInfo#ets_base_goods.other_data)),
%% %% 									%% 紫色兽魂,兽灵残章(紫色),兽灵残卷(橙色),灵魄,橙色兽魂
%% %% 									NotGoodsId = [211201,211501,211601,210901,211301],
%% %% 									VtlGoodsList = [{Gtid, Num}||{Gtid, Num}<-GoodsOtherList, Num > 0, lists:member(Gtid, NotGoodsId) =:= true],	
%% %% 									{_PChg, Player1} = lib_goods:add_virtual_goods(NewPlayerStatus, VtlGoodsList, 15050, 3),
%% %% 									{ok, Player1};
%% 								_ ->
%% 									skip
%% 							end;
%% 						_Err ->
%% 							skip
%% 					end;
%% 				{0, FlagNum} ->
%% 					{ok, BinData} = pt_15:write(15050, [FlagNum]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 					ok;
%% 				_ ->
%% 					skip
%% 			end;
%% 	   true ->
%% 		   skip
%% 	end;
%% 
%% 
%% %%丢弃物品
%% handle(15051, PlayerStatus, [GoodsId, GoodsNum]) ->
%%     gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 					{'throw_15051', PlayerStatus, GoodsId, GoodsNum}),
%% 	ok;
%% 
%% %% 整理背包或者仓库
%% handle(15052, PlayerStatus, [Location]) ->
%% 	%%io:format("~s handle:15052[~p]\~n",[misc:time_format(now()), test]),
%% 	%%case lib_trade:get_trade_limit(trade_limit) of
%% 	%%	true ->%%在交易之后3秒内不能整理
%% 			%%io:format("~s handle:15052_true[~p]\~n",[misc:time_format(now()), test]),
%% 	case Location of
%% 		4 ->
%% 			gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'clean_15052', 4,
%% 							 PlayerStatus#player.clln});
%% 		_ ->
%% 			gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, 
%% 							{'clean_15052', 5,
%% 							 PlayerStatus#player.dpn})
%% 	end,
%% 	%%	false ->
%% 	%%		skip
%% 	%%end,
%% 	ok;
%%     
%% %% %%节日道具使用
%% %% handle(15054,Player,[GoodsId,GoodsNum,Nickname]) ->
%% %% 	gen_server:cast(Player#player.other#player_other.pid_goods,
%% %% 					{'usefestivaltool_15054',Player,GoodsId,GoodsNum,Nickname,1}),
%% %% 	
%% %% 	ok;
%% %% 
%% %% %% 屏幕弹出框
%% %% handle(15056,Player,[Type,PlayerId,Msg]) ->
%% %% 	gen_server:cast(Player#player.other#player_other.pid_goods,
%% %% 					{'alert_win_15056',Player#player.nick,Type,PlayerId,Msg}),
%% %% 	ok;
%% 
%% %% 装备精炼(AutoBuy:1-自动补齐精炼石，2-不自动补齐精炼石)
%% handle(15057,Player,[EquipId, AutoBuy]) ->
%% 	case gen_server:call(Player#player.other#player_other.pid_goods, {'refine_equip',Player,EquipId,AutoBuy}) of
%% 		[NewPlayer, 1, NewEquipQly] ->
%% 			lib_player:send_player_attribute2(NewPlayer, 3),
%% 			chk_open_server_7(NewPlayer),
%% 			{ok, BinData} = pt_15:write(15057, [1, NewEquipQly]),
%% 			lib_send:send_to_sid(NewPlayer#player.other#player_other.pid_send, BinData),
%% 			{ok, NewPlayer};
%% 		[_NewPlayer, ErrNum, _NewEquipQly] ->
%% 			{ok, BinData} = pt_15:write(15057, [ErrNum, 0]),
%% 			lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData),
%% 			ok;
%% 		_ ->
%% 			{ok, BinData} = pt_15:write(15057, [0, 0]),
%% 			lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData),
%% 			ok
%% 	end;
%% 	
%% %% 
%% %% %% 装备分解/预览
%% %% handle(15058,Player,[Type,GoodsList]) ->
%% %% 	[NewPlayer,Res,Cost,Glist]=gen_server:call(Player#player.other#player_other.pid_goods,
%% %% 					{'idecompose',Player,Type,GoodsList}),
%% %% 	%%?DEBUG("-------------------GLIST:~p",[Glist]),
%% %% 	{ok,BinData} = pt_15:write(15058,[Res,Type,Cost,Glist]),
%% %% 	lib_send:send_to_sid(NewPlayer#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayer};
%% %% 
%% %% %% 材料合成
%% %% handle(15059,Player,[Mid]) ->
%% %% 	[NewPlayer,Res] = gen_server:call(Player#player.other#player_other.pid_goods,
%% %% 					{'icompose',Player,Mid}),
%% %% 	{ok,BinData} = pt_15:write(15059,[Res]),
%% %% 	lib_send:send_to_sid(NewPlayer#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayer};
%% %% 
%% %% %%紫装融合预览
%% %% handle(15060,PlayerStatus,[Gid1,Gid2,Gid3]) ->
%% %% 	%%?DEBUG("pp_goods/handle15060______~p ~p ~p",[Gid1,Gid2,Gid3]),
%% %% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,{'suit_merge_preview',PlayerStatus,Gid1,Gid2,Gid3}),
%% %% 	ok;
%% 	
%% 
%% %% 装备合成（传入的是要合成的装备类型ID）
%% handle(15059, PlayerStatus, [RollerId, EquitId,Flag]) ->
%% 	if EquitId =:= 0 ->			%%装备ID为0，非装备
%% 		   {Res, _,_,_} = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'compose_stuff', PlayerStatus, RollerId, Flag}),
%% 		   {ok, BinData} = pt_15:write(15059, [Res]),
%% 		   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% 	   true ->
%% 		   case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'compose', PlayerStatus, RollerId, EquitId,Flag}) of
%% 			   {1, NewPlayerStatus} ->
%% 				   {ok, BinData} = pt_15:write(15059, [1]),
%% 				   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 				   %%长生目标
%% 				   Tar_Type = EquitId,
%% 				   if Tar_Type =:= 101001 ->
%% 						  lib_target:target(equ_lg_wep,1);
%% 					  Tar_Type =:= 102001 ->
%% 						  lib_target:target(equ_lg_wep,1);
%% 					  Tar_Type =:= 103001 ->
%% 						  lib_target:target(equ_lg_wep,1);
%% 					  true ->
%% 						  ok
%% 				   end,
%% 				   lib_player:send_player_attribute2(NewPlayerStatus, 3),
%% 				   {ok, NewPlayerStatus};
%% 			   {Res, _} ->
%% 				   {ok, BinData} = pt_15:write(15059, [Res]),
%% 				   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 				   ok;
%% 			   _ ->
%% 				   {ok, BinData} = pt_15:write(15059, [0]),
%% 				   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 				   ok
%% 		   end
%% 	end;
%% 
%% %% 物品合成(非装备)     RollerId:合成卷轴; Flag:是否使用元宝, 0使用 1不使用
%% handle(15060, PlayerStatus, [RollerId,Flag]) ->
%% 	{Res, GoodsId,GoodsType,_} = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'compose_stuff', PlayerStatus, RollerId, Flag}),
%% 	{ok, BinData} = pt_15:write(15060, [Res]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	
%% 	%% 直接使用五行珠
%% 	case GoodsId > 0 andalso GoodsType =:= 41 andalso Res =:= 1 of 
%% 		true ->
%% 			handle(15050, PlayerStatus, [GoodsId, 1]) ;
%% 		false ->
%% 			skip
%% 	end ,
%% 	ok;
%% 
%% %% 查询当前装备的强化成功率
%% handle(15061,PlayerStatus, _) ->
%% 	%%?DEBUG("pp_goods/handle15061___0___~p",[PlayerStatus#player.other#player_other.strenTime]),
%% 	NowTime = util:unixtime(),
%% 	if
%% 		PlayerStatus#player.lv < 13 ->
%% 			%% 广播强化概率
%% 			bc_stren_rate(PlayerStatus, 100, 1),
%% 			NewPlayerStatus = PlayerStatus#player{other = PlayerStatus#player.other#player_other{strenRate = 100, strenTime = 1, strenTrend = 1}},
%% 			{ok, NewPlayerStatus};			
%% 		NowTime - PlayerStatus#player.other#player_other.strenTime >= 180 ->
%% 			%%?DEBUG("pp_goods/handle15061___1___~p",[test]),
%% 			{Rate, Time, Trend} = mod_misc:get_stren_info(),						
%% 			bc_stren_rate(PlayerStatus, Rate, Trend),
%% 			NewPlayerStatus = PlayerStatus#player{other = PlayerStatus#player.other#player_other{strenRate = Rate, strenTime = Time, strenTrend = Trend}},
%% 			{ok, NewPlayerStatus};
%% 		true ->
%% 			%%?DEBUG("pp_goods/handle15061___2___~p",[test]),
%% 			bc_stren_rate(PlayerStatus, 
%% 						  PlayerStatus#player.other#player_other.strenRate, 
%% 						  PlayerStatus#player.other#player_other.strenTrend),
%% 			ok
%% 	end;
%% 
%% %% 装备强化
%% handle(15062, PlayerStatus, [GoodsId, StrStoneType]) ->
%% %% 	NowTime = util:unixtime(),
%% 	Cd_equ =goods_util:get_goods(GoodsId),
%%     [NewPlayerStatus, Res, NewLv] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'strengthen', PlayerStatus, GoodsId, StrStoneType}),
%% 	%%长生目标
%% 	target_cd_work(NewLv,Cd_equ),
%% 	{ok, BinData} = pt_15:write(15062, [Res, GoodsId, NewLv, NewPlayerStatus#player.coin]),
%% 	lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData),
%% 	case Res of
%% 		1 ->  %%强化成功
%% 			PlayerStatusCount = lib_player:count_player_attribute(NewPlayerStatus),
%% %% 			PlayerStatusCount = lib_goods:stren_count_status(Res, NewPlayerStatus),
%% 			lib_player:send_player_attribute2(PlayerStatusCount,[]),
%% 			lib_player:send_player_attribute3(PlayerStatus, PlayerStatusCount),	%%发送属性变化值
%%             %%通知成就系统：强化装备一次
%% 			{ok, PlayerStatusCount};
%% 		8 ->  %%强化未成功
%% 			lib_player:send_player_attribute2(NewPlayerStatus,[]),
%%             %%通知成就系统：强化装备一次
%% 			{ok, NewPlayerStatus};
%% 		_ ->  %%错误
%% 			ok
%% 	end;
%% 
%% %% 
%% %% %% 洗附加属性
%% %% handle(15067, PlayerStatus, [GoodsId, RuneId]) ->
%% %%     [NewPlayerStatus, Res, NewRuneNum] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'wash', PlayerStatus, GoodsId, RuneId}),
%% %%     {ok, BinData} = pt_15:write(15067, [Res, GoodsId, NewRuneNum, NewPlayerStatus#player.coin,NewPlayerStatus#player.coin]),
%% %%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %%     {ok, NewPlayerStatus};
%% %% 
%% %% %% 鉴定属性
%% %% handle(15068, PlayerStatus,[GoodsId,StoneId]) ->
%% %% 	[NewPlayerStatus,Res,StoneNum,AttributeList] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,{'identify',PlayerStatus,GoodsId,StoneId}),
%% %% 	{ok,BinData} = pt_15:write(15068,[Res,GoodsId,StoneNum,AttributeList]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayerStatus};
%% %% %%法宝修炼
%% %% handle(15069,PlayerStatus,[GoodsId]) ->
%% %% 	%%?DEBUG("pp_goods/15069/goodsid/~p",[GoodsId]),
%% %% 	[NewPlayerStatus,Res] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,{'practise',PlayerStatus,GoodsId}),
%% %% 	{ok,BinData} = pt_15:write(15069,[Res,NewPlayerStatus#player.goth]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayerStatus};
%% 
%% %%物品启用剩余时间
%% handle(15070,PlayerStatus,[GoodsId]) ->
%% 	GoodsInfo =goods_util:get_goods(GoodsId),
%% 	if 
%% 		is_record(GoodsInfo,goods) == false -> %%物品不存在
%% 			Ret = 2,
%% 			Loc = 0,
%% 			Cell = 0,			
%% 			LeftTime = 0;
%% 		GoodsInfo#goods.uid =/= PlayerStatus#player.id -> %%物品不属于你
%% 			Ret = 2,
%% 			Loc = 0,
%% 			Cell = 0,			
%% 			LeftTime = 0;
%% 		true ->
%% 			Ret = 1,
%% 			NowTime = util:unixtime(),
%% 			if 
%% 				NowTime > GoodsInfo#goods.eprt ->
%% 					LeftTime = 0;
%% 				true ->
%% 					LeftTime = GoodsInfo#goods.eprt - NowTime
%% 			end,
%% 			Loc = GoodsInfo#goods.loc,
%% 			Cell = GoodsInfo#goods.cell
%% 	end,
%% 
%% 	
%% 	{ok,BinData} = pt_15:write(15070,[Ret, Loc, Cell, LeftTime, GoodsId]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 	ok;
%% 
%% %% %%法宝融合
%% %% handle(15070,PlayerStatus,[GoodsId1,GoodsId2]) ->
%% %% 	%%?DEBUG("pp_goods/15070/goodsid_1/~p/goodsid_2/~p",[GoodsId1,GoodsId2]),
%% %% 	[NewPlayerStatus,Res] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,{'merge',PlayerStatus,GoodsId1,GoodsId2}),
%% %% 	{ok,BinData} = pt_15:write(15070,[Res]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayerStatus};
%% %% 
%% %% %% ------------------------------------
%% %% %% 15071 批量购买商店物品
%% %% %% ------------------------------------
%% %% handle(15071, PlayerStatus, [ShopType, ShopSubType, GoodsList]) ->
%% %% 	%%添加商店子类型的强制性判断
%% %% 	case ShopSubType =:= 1 orelse ShopSubType =:= 2 of
%% %% 		false ->
%% %% 			Result = 0,
%% %% 			MoneyType = 0,
%% %% 			Money = 0,
%% %% 			NewPlayerStatus = PlayerStatus;
%% %% 		true ->
%% %% %% 			io:format("pp_goods 15071 buy much goods: ~p\n", [length(GoodsList)]),
%% %% 			case length(GoodsList) =:= 0 of 
%% %% 				true ->%%长度为零，不用操作，直接返回
%% %% %% 					io:format("length is 0\n"),
%% %% 					[Result, MoneyType, Money, NewPlayerStatus] = [0, 0, 0, PlayerStatus];
%% %% 				false ->
%% %% %% 					io:format("length is not 0\n"),
%% %% 					[Result, MoneyType, Money, NewPlayerStatus] = 
%% %% 						gen_server:call(PlayerStatus#player.other#player_other.pid_goods, 
%% %% 										{'buy_multi', PlayerStatus, ShopType, ShopSubType, GoodsList})
%% %% 			end
%% %% 	end,
%% %% 	{ok, BinData} = pt_15:write(15071, [Result, MoneyType, Money]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 	lib_player:send_player_attribute(NewPlayerStatus, 2),
%% %% 	{ok,NewPlayerStatus};
%% 	
%% %% ------------------------------------
%% %% 15072 批量出售物品
%% %% ------------------------------------
%% %% handle(15072, PlayerStatus, [GoodsList]) ->
%% %% %% 	io:format("pp_goods 15072 sell much goods: ~p\n", [length(GoodsList)]),
%% %% 	case length(GoodsList) =:= 0 of
%% %% 		true ->%%长度为零，不用操作，直接返回
%% %% %% 			io:format("length is 0\n"),
%% %% 			[Result, MoneyType, Money, NewPlayerStatus] = [0, 1, PlayerStatus#player.coin, PlayerStatus];
%% %% 		false ->
%% %% %% 			io:format("length is not 0\n"),
%% %% 			[Result, MoneyType, Money, NewPlayerStatus] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,
%% %% 																		  {'sell_multi', PlayerStatus, GoodsList})
%% %% 	end,
%% %% 	{ok, BinData} = pt_15:write(15072, [Result, MoneyType, Money]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %% 	lib_player:send_player_attribute(NewPlayerStatus, 2),
%% %% 	{ok,NewPlayerStatus};
%% 
%% %% %% -------------------------------------------------------------
%% %% %% 15073 查询物品详细信息(拍卖或者交易的时候用到的查看物品信息)
%% %% %% -------------------------------------------------------------
%% %% handle(15073, PlayerStatus, [GoodsId]) ->
%% %% 	?DEBUG("pp_goods 15073 get goods information:[~p]", [GoodsId]),
%% %% 	[GoodsInfo, SuitNum, AttributeList] = mod_player:get_goods_info_by_gid(PlayerStatus, {'info', GoodsId}),
%% %%     {ok, BinData} = pt_15:write(15073, [GoodsInfo, SuitNum, AttributeList]),
%% %% 	%%?DEBUG("pt_15/15000/attributelist/~p",[AttributeList]),
%% %%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);
%% %% 
%% %% %%物品融合预览
%% %% handle(15074,PlayerStatus,[GoodsId1,GoodsId2]) ->
%% %% 	[GoodsInfo,SuitNum,AttributeList] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,
%% %% 														{'merge_preview',PlayerStatus,GoodsId1,GoodsId2}),
%% %% 	{ok,BinData} = pt_15:write(15074,[GoodsInfo,SuitNum,AttributeList]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData);	
%% %% 
%% %% 
%% %% %%装备评价
%% %% handle(15080,PlayerStatus,[GoodsId]) ->
%% %% 	[Res, Score, Status] = lib_goods:give_score(PlayerStatus, GoodsId),
%% %% %% ?DEBUG("15080:~p", [[Res, Score, Status#player.coin]]),
%% %% 	{ok,BinData} = pt_15:write(15080,[Res, GoodsId, Score, Status#player.coin, Status#player.coin]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	{ok,Status};	
%% %% 
%% %% %%60套紫装淬炼
%% %% handle(15081,PlayerStatus,[GoodsId,GoodsList]) ->
%% %% 	[Ret,Repair,NewPlayer] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods,
%% %% 													{'smelt',PlayerStatus,GoodsId,GoodsList}),
%% %% 	{ok,BinData} = pt_15:write(15081,[Ret,Repair,NewPlayer#player.coin,NewPlayer#player.coin]),
%% %% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% %% 	{ok,NewPlayer};
%% 
%% %%查询月光宝盒
%% handle(15080, PlayerStatus, _) ->
%% 	Data = lib_goods:get_player_level_gift_info(PlayerStatus),
%% 	{ok, BinData} = pt_15:write(15080, Data),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 	ok;
%% 
%% 
%% %%各种卡号使用
%% handle(15090,PlayerStatus,[CardString]) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_15090]), 3),		%%15090包以3秒时间计
%% 	if Is_operate_ok =:= true ->
%% %% 		   [Res,NewStatus]=gen_server:call(PlayerStatus#player.other#player_other.pid_goods,
%% %% 							{'use_csj_card',PlayerStatus,CardString}),
%%  		   [Res, PChg, NewStatus] = lib_reward:reward_event(csj_card, [PlayerStatus, CardString]),
%% 		   {ok,BinData} = pt_15:write(15090,[Res]),
%% 		   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 		   if
%% 			   PChg =:= 1 ->
%% 				   {ok,NewStatus};
%% 			   true ->
%% 				   ok
%% 		   end;
%% 	   true ->
%% 		   ok
%% 	end;
%% 
%% %%查询各种礼包卡是否领取过
%% handle(15091,PlayerStatus, _) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_15091]), 3),		%%15091包以3秒时间计
%% 	if Is_operate_ok =:= true ->
%% 		   case db_agent:get_card_type_list(PlayerStatus#player.id) of    	%% 查询卡表中玩家用过的卡类型
%% 			   error ->
%% 				   Res = 0,
%% 				   Sum = 0;
%% 			   List1 when is_list(List1)->
%% 				   Sum = lists:foldl(fun(X, R)-> R bor X end, 0, List1),
%% 				   Res = 1;
%% 		       _ ->
%% 				   Res = 0,
%% 				   Sum = 0
%% 			end,
%% 		   {ok,BinData} = pt_15:write(15091,[Res, Sum]),
%% 		   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 		   ok;
%% 	   true ->
%% 		   ok
%% 	end;
%% 
%% %%水晶装备初始化
%% handle(15101,PlayerStatus,[GoodsId])->
%% 	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods,
%% 							{'cyt_info_15101',GoodsId}),
%% 	ok;
%% 
%% %%水晶镶嵌以及卸载
%% handle(15103,PlayerStatus,[GoodsId, CytTypeId, Oper, HoleNum])->
%% 	[NewPlayerStatus, Res] = 
%% 		gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'cyt_handler', PlayerStatus, GoodsId, CytTypeId, Oper, HoleNum}),
%% %% 	io:format("~s ________15103________[~p]\n",[misc:time_format(now()), [Res, CytTypeId, Oper, HoleNum]]),
%%     {ok, BinData} = pt_15:write(15103, [Res, CytTypeId, Oper, HoleNum]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	case Res of
%% 		1 ->
%% 			PlayerStatusCount = lib_player:count_player_attribute(NewPlayerStatus),
%% %% 			PlayerStatusCount = lib_goods:stren_count_status(1, NewPlayerStatus),
%% 			lib_player:send_player_attribute2(PlayerStatusCount,[]),
%% 			lib_player:send_player_attribute3(PlayerStatus, PlayerStatusCount),	%%发送属性变化值;
%% 			{ok, PlayerStatusCount};
%% 		_ ->
%% 			ok
%% 	end;
%% 
%% %%水晶镶嵌激活格子
%% handle(15104,PlayerStatus,[GoodsId, HoleNum])->
%% 	[NewPlayerStatus, Res] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'open_hole', PlayerStatus, GoodsId, HoleNum}),
%%     {ok, BinData} = pt_15:write(15104, [Res]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	case Res of
%% 		1 ->
%% 			lib_player:send_player_attribute2(NewPlayerStatus, 2),
%% 			{ok, NewPlayerStatus};
%% 		_ ->
%% 			ok
%% 	end;
%% 
%% %%水晶合成
%% handle(15106,PlayerStatus,[CytTypeId, Num])->
%% 	case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'cyt_compose', PlayerStatus, CytTypeId, Num}) of
%% 		{1, NewPlayerStatus} ->
%% 			Res = 1;
%% 		Res when is_integer(Res) ->
%% 			NewPlayerStatus = PlayerStatus;
%% 		_ ->
%% 			Res = 0,
%% 			NewPlayerStatus = PlayerStatus
%% 	end,
%% 	{ok, BinData} = pt_15:write(15106, [Res]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	case Res of
%% 		1 ->
%% 			lib_player:send_player_attribute2(NewPlayerStatus, 2),
%% 			{ok, NewPlayerStatus};
%% 		_ ->
%% 			ok
%% 	end;
%%     
%% 
%% %%自动使用气血包
%% handle(15152,PlayerStatus,_Data) ->
%% 	case gen_server:call(PlayerStatus#player.other#player_other.pid_goods,{'hp_pack_goods_find', PlayerStatus#player.id}) of
%% 		[] ->
%% 			{ok,BinData} = pt_15:write(15152, [2]),
%% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData);
%% 		HpPackId ->
%% 			%%io:format("~s 15152_____[~p]\n",[misc:time_format(now()), HpPackId]),
%% 			case handle(15050, PlayerStatus, [HpPackId, 1])of
%% 				{ok, NewPlayerStatus} ->
%% 					{ok,BinData} = pt_15:write(15152, [1]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 					{ok, NewPlayerStatus};
%% 				_ ->
%% 					skip
%% 			end			
%% 	end;
%% 
%% %%列出玩家抢购物品列表 
%% handle(15110,PlayerStatus,_Data) ->
%% 	case misc:whereis_name({global, mod_shop_process}) of
%% 		Pid when is_pid(Pid) ->	
%% 			gen_server:cast(Pid,{'get_th_goods',PlayerStatus#player.id,PlayerStatus#player.other#player_other.pid_send});
%% 		_ ->
%% 			skip
%% 	end,
%% 	ok;
%% 
%% %%抢购物品
%% %%GoodsType为商品类型，不是物品类型
%% handle(15111,PlayerStatus,[Index, GoodsType]) ->
%% 	PreChk =
%% 		if
%% 			GoodsType >= 100 -> %% 大于100为物品
%% 				NullCellNum = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'cell_num'}),
%% 				if
%% 					NullCellNum =:= 0 ->
%% 						6;%% 背包已满
%% 					true ->
%% 						1
%% 				end;
%% 			true ->
%% 				StockList = lib_pet2:get_stock_pet(PlayerStatus#player.id),
%% 				PetCount = length(StockList),
%% 				Cell = lib_pet2:select_use_cell(StockList, PlayerStatus#player.psn),
%% 				if
%% 					PetCount >= PlayerStatus#player.psn ->
%% 						5; %% 宠物数已满
%% 					Cell =< 0 orelse Cell > PlayerStatus#player.psn -> 
%% 						5;%% 宠物数已满
%% 					true ->
%% 						1
%% 				end
%% 		end,
%% 	if
%% 		PreChk =:= 1 ->
%% 			case misc:whereis_name({global, mod_shop_process}) of
%% 				Pid when is_pid(Pid) ->	
%% 					{CheckBuy, Cost} = gen_server:call(Pid, {'thall_buy', PlayerStatus#player.id, Index, GoodsType}),
%% 					case CheckBuy of
%% 						1 ->
%% 							[Res, NewStatus] = lib_goods:buy_pet_goods(PlayerStatus, GoodsType, Cost),
%% 							lib_player:send_player_attribute2(NewStatus, 1),
%% 							{ok, BinData} = pt_15:write(15111, [Res]),
%% 							lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 							{ok, NewStatus};
%% 						ErrCode ->
%% 							{ok, BinData} = pt_15:write(15111, [ErrCode]),
%% 							lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 							ok
%% 					end;
%% 				_ ->
%% 					{ok, BinData} = pt_15:write(15111, [0]),
%% 					lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 					ok
%% 			end;
%% 		true ->
%% 			{ok, BinData} = pt_15:write(15111, [PreChk]),
%% 			lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 			ok
%% 	end;
%% 
%% %%取消幻化珠状态
%% handle(15171,PlayerStatus,_Data) ->
%% 	misc:cancel_timer(mask_goods_buff_timer),
%% 	case lib_goods_use:eraseMaskBuff(PlayerStatus) of
%% 		ok ->
%% 			misc:cancel_timer(mask_goods_buff_timer),
%% 			PlayerStatus1 = lib_goods_use:refMaskBuff(PlayerStatus);
%% 		_ ->
%% 			PlayerStatus1 = PlayerStatus
%% 	end,
%% 	BinData = pt:pack(15171, <<1:8>>),
%% 	lib_send:send_to_sid(PlayerStatus1#player.other#player_other.pid_send,BinData),
%% 	{ok, PlayerStatus1};
%% 
%% %%获取物品BUFF剩余时间
%% handle(15172,PlayerStatus, [GoodsTypeId]) ->
%% 	LeftTime = lib_goods_use:getGoodsBuffLeftTime(PlayerStatus, GoodsTypeId),
%% 	BinData = pt:pack(15172, <<LeftTime:32>>),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 	ok;
%% 
%% %%获取所有套装装备合成信息
%% handle(15200,PlayerStatus, _Data) ->
%% 	AllStidL = data_stren:get_all_stid_list(),
%% 	Fun = fun({Lv, Stid}) ->
%% 				  EquipList = lib_goods:get_suit_all_equip(Stid),
%% 				  {EquipComInfoList, AllComNum} = lib_goods:get_equip_compose_info(PlayerStatus#player.id, EquipList),
%% 				  {Lv, AllComNum, EquipComInfoList}
%% 		  end,
%% 	AllInfoList = lists:map(Fun, AllStidL),
%% 	{ok, BinData} = pt_15:write(15200, [AllInfoList]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 	ok;
%% 
%% %%获取单件套装装备合成信息
%% handle(15201,PlayerStatus, [EquipTypeId]) ->
%% 	case goods_util:get_goods_type(EquipTypeId) of
%% 		EquipTypeInfo when is_record(EquipTypeInfo, ets_base_goods) ->
%% 			case data_stren:get_equip_compose_material_list(EquipTypeId) of
%% 				error ->
%% 					Res = 0,
%% 					MaterialList = [],
%% 					CostCoin = 0;
%% 				MaterialList ->
%% 					Res = 1,
%% 					CostCoin = data_stren:get_equip_compose_cost(EquipTypeInfo#ets_base_goods.stid)
%% 			end;
%% 		_ ->
%% 			Res = 0,
%% 			MaterialList = [],
%% 			CostCoin = 0
%% 	end,
%% 	PlayerId = PlayerStatus#player.id,
%% 	{ok, BinData} = pt_15:write(15201, [PlayerId, Res, CostCoin, MaterialList]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 	ok;				
%% 					
%% %%装备精炼信息查询
%% handle(15210,PlayerStatus, [EquipId]) ->
%% 	GoodsInfo = goods_util:get_goods(EquipId),
%% 	case is_record(GoodsInfo, goods) of
%% 		true ->
%% 			BRecord = true,
%% 			MaxQly = data_stren:get_refine_max(),
%% 			Qly = GoodsInfo#goods.qly;
%% 		_ ->
%% 			BRecord = false,
%% 			MaxQly = 0,
%% 			Qly = 0
%% 	end,
%% 	Res =
%% 		if
%% 			BRecord =:= false ->
%% 				%% 失败，物品不存在
%% 				0;
%% 			GoodsInfo#goods.uid =/= PlayerStatus#player.id ->
%% 				0;
%% 			GoodsInfo#goods.type =/= 10 ->
%% 				2;
%% 			GoodsInfo#goods.stid =< 0 ->
%% 				2;
%% 			Qly >= MaxQly -> 
%% 				6;			
%% 			true ->
%% 				1
%% 		end,
%% 	{ok, BinData} = pt_15:write(15210, [Res, GoodsInfo]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send,BinData),
%% 	ok;
%% 
%% %%竞技场商店购买物品
%% handle(15211, PlayerStatus, [GoodsTypeId]) ->
%% 	case gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'buy_arena_shop', GoodsTypeId}) of
%% 		Res when is_integer(Res) ->
%% 			ok;
%% 		_ ->
%% 			Res = 0
%% 	end,
%% 	{ok, BinData} = pt_15:write(15211, [Res]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %%获取回购物品列表
%% handle(15212, PlayerStatus, _) ->
%% 	GoodsList = lib_goods:get_buy_back_goods_list(PlayerStatus#player.id),
%% 	{ok, BinData} = pt_15:write(15212, GoodsList),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %%获取物品的剩余有效时间
%% handle(15213, PlayerStatus, [GoodsId]) ->
%% 	GoodsInfo = goods_util:get_goods(GoodsId),
%% 	if is_record(GoodsInfo, goods) ->
%% 		   if GoodsInfo#goods.eprt =:= 0 ->
%% 				  Res = {3, 0};
%% 			  true ->
%% 				  Now = util:unixtime(),
%% 				  Res = {1, tool:int_format(GoodsInfo#goods.eprt - Now)}
%% 		   end;
%% 	   true ->
%% 		   Res = {2, 0}
%% 	end,
%% 	{ok, BinData} = pt_15:write(15213, Res),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% handle(_Cmd, _Status, _Data) ->
%%     ?DEBUG("pp_goods no match", []),
%%     {error, "pp_goods no match"}.
%% 
%% 
%% 
%% %% 强化时处理长生目标及cd
%% target_cd_work(NewLv,Cd_equ) ->
%% 	if NewLv+1 =:= 5 ->
%% 		   lib_target:target(str_equip_lv5,1);
%% 			   NewLv+1 =:= 35 ->
%% 				   lib_target:target(str_equip_lv35,1);
%% 			   NewLv+1 =:= 50 ->
%% 				   lib_target:target(str_equip_lv50,1);
%% 			   NewLv+1 =:= 60 ->
%% 				   lib_target:target(str_equip_lv60,1);
%% 			   true ->
%% 				   ok
%% 			end,
%% 			if Cd_equ#goods.lv =:= 1 -> Add = 4*60;
%% 			   Cd_equ#goods.lv =:= 20 -> Add = 7*60;
%% 			   Cd_equ#goods.lv =:= 40 -> Add = 14*60;
%% 			   Cd_equ#goods.lv =:= 60 -> Add = 28*60;
%% 			   true -> Add = 0
%% 			end,
%% 			if NewLv > 0 ->
%% 					lib_cooldown:add_cd(1,Add);
%% 			   true ->
%% 				   skip
%% 			end.
%% 
%% %% 查询强化规律的特殊处理
%% bc_stren_rate(PlayerStatus, Rate, Trend) ->
%% 	BcRate =
%% 		if
%% 			PlayerStatus#player.lv =< 20 andalso Rate >= 80 ->
%% 				100;
%% 			PlayerStatus#player.lv =< 20 ->
%% 				Rate + 20;
%% 			true ->
%% 				Rate
%% 		end,
%% 	{ok, BinData} = pt_15:write(15061, [BcRate, Trend]),
%% 	lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData).
%% 
%% 
%% %%装备合成公告 
%% compose_broadcast(PlayerStatus,GoodInfo,BaseInfo) ->
%% 	MsgType = 1,
%% %% 	io:format("110900000000nick ~p~n",[PlayerStatus#player.nick]),
%% %% 	io:format("110900000000name ~p~n",[BaseInfo#ets_base_goods.name]),
%% 	PlayerPackList = [PlayerStatus#player.id,
%% 					  PlayerStatus#player.nick,
%% 					  PlayerStatus#player.nick],
%% 	Clr = data_broadcast:get_chatbox_color(GoodInfo#goods.qly),
%% 	EquitList = [GoodInfo#goods.id,
%% 				 GoodInfo#goods.gtid,
%% 				 GoodInfo#goods.stlv,
%% 				 Clr,
%% 				 tool:to_list(BaseInfo#ets_base_goods.name)],
%% 	{ok, BinData} = pt_11:write(11090,  [MsgType, [PlayerPackList, EquitList]]),
%% 	lib_send:send_to_all(BinData).
%% 
%% %%开服活动7（装备大收集，新版）
%% chk_open_server_7(NewPlayer) ->
%% 	case lib_reward:check_reward_by_event(equip) of
%% 		true ->
%% 			case goods_util:chk_equip_suit(NewPlayer#player.id, 6, 2) of
%% 				true ->
%% 					lib_reward:reward_event(equip, [NewPlayer]);
%% 				_ ->
%% 					skip
%% 			end;
%% 		_ ->
%% 			skip
%% 	end.
%% 
%% %%玩家进程对物品使用的检测
%% chk_use_goods(PlayerStatus, GoodsInfo) ->
%% 	case [GoodsInfo#goods.type,GoodsInfo#goods.stype] of
%% 		[48, 1] ->	%% 巨兽封印卷轴
%% 			case lib_giant_s:chk_giant_null_cell(PlayerStatus) of
%% 				1 ->
%% 					CheckFlag = {1, 1};
%% 				2 ->
%% 					CheckFlag = {0, 22};
%% 				0 ->
%% 					CheckFlag = {0, 23};
%% 				_ ->
%% 					CheckFlag = {0, 0}
%% 			end;
%% 		[28, 2] ->  %%宠物蛋
%% 			
%% 			case lib_pet2:check_use_cell(PlayerStatus) of
%% 				1 ->
%% 					CheckFlag = {1, 1};
%% 				0 ->
%% 					CheckFlag = {0, 24};
%% 				2 ->
%% 					CheckFlag = {0, 25};
%% 				_ ->
%% 					CheckFlag = {0, 0}
%% 			end;
%% 		_ ->
%% 			CheckFlag = {1, 1}
%% 	end,
%% 	CheckFlag.
%% 
%% 
%% 
%% 
%% 
%% 
