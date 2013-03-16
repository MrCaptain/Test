%%%--------------------------------------
%%% @Module  : pp_goods
%%% @Author  : 
%%% @Created : 
%%% @Description:  物品操作
%%%--------------------------------------
-module(pp_goods).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include("shop.hrl").
-include("debug.hrl").

-compile(export_all).

%% desc: 查询物品详细信息(自己的)
handle(15000, PlayerStatus, GoodsId) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'info', PlayerStatus, GoodsId});

%% desc: 查询别人物品详细信息(同一场景)
handle(15001, PlayerStatus, [RoleId, GoodsId]) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'info_other', PlayerStatus, RoleId, GoodsId});

%% desc: 查询玩家某个位置的物品列表
handle(15002, PlayerStatus, Location) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'list', PlayerStatus, Location});

%% desc: 扩充背包
handle(15003, PlayerStatus, Location) ->
	[NewPlayerStatus, Res] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'extend', PlayerStatus, Location}),
	{ok, BinData} = pt_15:write(15003, [Res, NewPlayerStatus#player.cell_num, Location]),
	lib_send:send_one(NewPlayerStatus#player.other#player_other.socket, BinData),
%% 	goods_util:refresh_location(Res, NewPlayerStatus, Location),
	{ok, NewPlayerStatus};

%% desc: 拖动背包物品
handle(15004, PlayerStatus, [GoodsId, OldCell, NewCell]) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'drag', PlayerStatus, GoodsId, OldCell, NewCell});

%% desc: 物品拆分
handle(15005, PlayerStatus, [GoodsId, GoodsNum]) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'split', PlayerStatus, GoodsId, GoodsNum});

%% desc: 整理背包
handle(15006, PlayerStatus, _) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'clean', PlayerStatus});

%% desc: 出售物品
handle(15007, PlayerStatus, [GoodsId, GoodsNum]) ->
	[Res, NewPlayerStatus] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'sell', PlayerStatus, GoodsId, GoodsNum}),
	{ok, BinData} = pt_15:write(15007, [Res, GoodsId, GoodsNum]),
	lib_send:send_one(NewPlayerStatus#player.other#player_other.socket, BinData),
	lib_player:send_player_attribute3(NewPlayerStatus),
	{ok, NewPlayerStatus};

%% 寄售物品
handle(15008, PlayerStatus, [GoodsId, GoodsNum]) ->
	ok;

%% desc: 使用物品
handle(15009, PlayerStatus, [GoodsId, GoodsNum]) ->
	[Res, NewPlayerStatus, GoodsTypeId, NewNum] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'use', PlayerStatus, GoodsId, GoodsNum}, 5000000),
	{ok, BinData} = pt_15:write(15009, Res),
	lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),
	{ok, NewPlayerStatus};

%% desc: 商城--获取特价区物品
handle(15011, PS, _) ->
	List = mod_shop:handle_show_bargain(PS),
	lib_common:pack_and_send(PS, pt_15, 15011, List);

%% desc: 商城--购买特价区商品
handle(15012, PlayerStatus, [Num, Type]) ->
	{Res, NewPS, GoodsTid} = mod_shop:handle_pay_bargain(PlayerStatus, Num, Type),
	case Res =:= ?RESULT_OK of
		true ->
			mod_log:log_consume(?SHOP_N_BARGAIN, GoodsTid, PlayerStatus, NewPS);
		_ ->     skip
	end,
	lib_common:pack_and_send(NewPS, pt_15, 15012, [Res]),
	{ok, NewPS}; 

%% desc: 商城--获取物品列表
%% handle(15013, PlayerStatus, [ShopType, ShopSubtype, PageNo]) -> 
%% 	[ShopList, TotalPage] = mod_shop:handle_show_goods(PlayerStatus#player.id, ShopType, ShopSubtype, PageNo),
%% 	{ok, BinData} = pt_15:write(15013, [ShopType, ShopSubtype, ShopList, TotalPage]),
%% 	lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData);

%% desc: 商城--购买商城普通区物品
handle(15014, PlayerStatus, [ShopTabType, GoodsTid, GoodsNum]) ->
	[Res, NewPS] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, 
								   {'buy_shop_goods', PlayerStatus, ShopTabType, GoodsTid, GoodsNum}),	
	{ok, BinData} = pt_15:write(15014, Res),
	lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),
	{ok, NewPS};

%% desc: 商店--购买页--查看NPC出售列表
handle(15015, PlayerStatus, [ShopId, PageNo]) ->
	ShopGoodsList = lib_shop:get_npc_shop_goods(PlayerStatus, ShopId, PageNo),
	{ok, BinData} = pt_15:write(15015, [ShopId, PageNo, ShopGoodsList]),
	lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData);

%% desc: 向NPC商店购买物品
handle(15016, PlayerStatus, [ShopId, PageNo, GoodsTid, Num]) ->
	[Res, NewPS] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, 
								   {'buy_npc_shop_goods', PlayerStatus, ShopId, PageNo, GoodsTid, Num}),		
	{ok, BinData} = pt_15:write(15016, Res),
	lib_send:send_one(NewPS#player.other#player_other.socket, BinData),
	{ok, NewPS};

%% 装备物品（人物或宠物）
%% @para: PetId => 宠物唯一id（若是玩家穿装备，则为0；若是宠物穿装备，则为对应宠物的唯一id）
handle(15017, PS, [GoodsId, PetId]) ->
	[NewPS, Res, NewPetInfo, OldGoodsInfo] = gen_server:call(PS#player.other#player_other.pid_goods, 
																 {'equip', PS, GoodsId, PetId}, 500000),
	[OldGoodsId, OldGoodsCell] =
		case is_record(OldGoodsInfo, goods) of 
			true ->             [OldGoodsInfo#goods.id, OldGoodsInfo#goods.cell];
			false ->            [0, 0]
		end,
	?TRACE("GoodsId:~p, PetId:~p, OldGoodsId:~p, OldGoodsCell:~p ~n", [GoodsId, PetId, OldGoodsId, OldGoodsCell]),
	{ok, BinData} = pt_15:write(15017, [Res, GoodsId, PetId, OldGoodsId, OldGoodsCell]),
	lib_send:send_one(NewPS#player.other#player_other.socket, BinData),
	% 角色属性变更通知
	NewPS1 = lib_player:calc_player_battle_attr(NewPS),
	lib_player:send_player_attribute3(NewPS1),
	{ok, NewPS1};

%% 卸下装备
%% @para: PetId => 宠物唯一id（若是玩家卸装备，则为0；若是宠物卸装备，则为对应宠物的唯一id） 
handle(15018, PS, [GoodsId, PetId]) ->
	[NewPS, NewPartnerInfo, Res, GoodsInfo] = gen_server:call(PS#player.other#player_other.pid_goods, 
															  {'unequip', PS, [GoodsId, PetId]}, 500000),
	Cell =
		case is_record(GoodsInfo, goods) of
			true ->        GoodsInfo#goods.cell;
			false ->       0
		end,
	{ok, BinData} = pt_15:write(15018, [Res, GoodsId, PetId, Cell]),
	lib_send:send_one(NewPS#player.other#player_other.socket, BinData),
	% 角色属性变更通知
	NewPS1 = lib_player:calc_player_battle_attr(NewPS),
	lib_player:send_player_attribute3(NewPS1),
	{ok, NewPS1};

%% 装备强化
handle(15019, NewPlayerStatus, [GoodsId, BindFirst, AutoBuy, Type]) ->
	[Res, NewPS, NewStren, PerfectDigree, Tstonenum, CostCoin, CostGold] = 
		gen_server:call(NewPlayerStatus#player.other#player_other.pid_goods, {'strengthen', NewPlayerStatus, GoodsId, BindFirst, AutoBuy, Type}),
	NewPstatus = lib_player:calc_player_battle_attr(GoodsId, NewPS),
	lib_player:send_player_attribute3(NewPstatus),
	{ok, BinData} = pt_15:write(15019, [Res, GoodsId, NewStren, PerfectDigree, Tstonenum, CostCoin, CostGold]),
    lib_send:send_one(NewPstatus#player.other#player_other.socket, BinData),
	{ok, NewPstatus};

%% desc: 洗炼
handle(15020, PlayerStatus, [GoodsId, BindFirst, AutoBuy, AutoLock, IdList]) ->
	[Res, NewPlayerStatus, WashType] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, 
													   {'polish', PlayerStatus, [GoodsId, BindFirst, AutoBuy, AutoLock, IdList]}),
	{ok, BinData} = pt_15:write(15020, [Res, GoodsId]),
	lib_send:send_one(NewPlayerStatus#player.other#player_other.socket, BinData),
	% 角色属性变更通知
	NewPS = lib_player:calc_player_battle_attr(GoodsId, NewPlayerStatus),
	lib_player:send_player_attribute3(NewPS),
	{ok, NewPS};

%% desc: 查看装备的洗炼属性
handle(15021, PlayerStatus, GoodsId) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'GET_POLISH_ATTRI', PlayerStatus, GoodsId});

%% desc: 宝石镶嵌
handle(15022, PlayerStatus, [GoodsId, StoneIdList]) ->
	[Res, NewPlayerStatus] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'inlay', PlayerStatus, GoodsId, StoneIdList}, ?DELAY_CALL),
	{ok, BinData} = pt_15:write(15022, [Res, GoodsId]),
	lib_send:send_one(NewPlayerStatus#player.other#player_other.socket, BinData),
	% 角色属性变更通知
	NewPS = lib_player:calc_player_battle_attr(GoodsId, NewPlayerStatus),
	lib_player:send_player_attribute3(NewPS),
	{ok, NewPS};

%% desc: 宝石拆除
handle(15023, PlayerStatus, [GoodsId, List]) ->
	[Res, NewPlayerStatus] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'backout', PlayerStatus, [GoodsId,List]}, ?DELAY_CALL),
	{ok, BinData} = pt_15:write(15023, [Res, GoodsId]),
	lib_send:send_one(NewPlayerStatus#player.other#player_other.socket, BinData),
	% 角色属性变更通知
	NewPS = lib_player:calc_player_battle_attr(GoodsId, NewPlayerStatus),
	lib_player:send_player_attribute3(NewPS),
	{ok, NewPS};

%% desc: 宝石合成
handle(15024, PlayerStatus, [StoneTid, ComposeNum]) ->
	[Res, NewPS] = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'compose', PlayerStatus, StoneTid, ComposeNum}, ?DELAY_CALL),
	{ok, BinData} = pt_15:write(15024, Res),
	lib_send:send_one(NewPS#player.other#player_other.socket, BinData),
	{ok, NewPS};

%% desc: 查询玩家或武将的全身强化奖励类型
%% @para: TargetType => 1表示查询玩家，2表示查询宠物 
handle(15025, PlayerStatus, [TargetId, TargetType]) ->
	case (TargetType /= 1 andalso TargetType /= 2)
			 orelse (TargetId == 0) of
		true ->
			skip;
		false ->
			Flag = case TargetType of
					   1       -> [] =/= lib_player:get_online_info_fields(TargetId, [id]);
					   2       -> null =/= lib_partner:get_alive_partner(TargetId)
				   end,
			case Flag of
				false   -> skip;
				true    -> gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'GET_EQUIP_T_REWARD', PlayerStatus, TargetId, TargetType})
			end
	end;

%% desc: 查询别人身上装备列表(同一场景)
handle(15026, PlayerStatus, PlayerId) ->
	gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'list_other', PlayerStatus, PlayerId});

%% desc: 洗炼替换
handle(15027, PlayerStatus, GoodsId) ->
	Res = gen_server:call(PlayerStatus#player.other#player_other.pid_goods, {'replace_polish_attri', PlayerStatus, GoodsId}),
	NewPstatus = lib_player:calc_player_battle_attr(GoodsId, PlayerStatus),
	lib_player:send_player_attribute3(NewPstatus),
	lib_common:pack_and_send(NewPstatus, pt_15, 15027, [Res, GoodsId]),
	{ok, NewPstatus};

%% desc: 丢弃物品
handle(15028, PlayerStatus, [GoodsId, GoodsNum]) ->
    gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'throw', PlayerStatus, GoodsId, GoodsNum});

%% 装备镀金
handle(15029, NewPlayerStatus, [GoodsId, BindFirst]) ->
	[Res, NewPS, NewGildingLv, _CostCoin] = 
		gen_server:call(NewPlayerStatus#player.other#player_other.pid_goods, {'gilding', NewPlayerStatus, GoodsId, BindFirst}),
	NewPstatus = lib_player:calc_player_battle_attr(GoodsId, NewPS),
	lib_player:send_player_attribute3(NewPstatus),
	{ok, BinData} = pt_15:write(15029, [Res, GoodsId, NewGildingLv]),
    lib_send:send_one(NewPstatus#player.other#player_other.socket, BinData),
	{ok, NewPstatus};

%% desc: 查看某件装备的镀金、升级属性
handle(15030, PlayerStatus, [GoodsId, Type]) ->
    gen_server:cast(PlayerStatus#player.other#player_other.pid_goods, {'GET_CASTING_INFO', PlayerStatus, [GoodsId, Type]});

%% 装备升级
handle(15031, NewPlayerStatus, [GoodsId, BindFirst]) ->
	[Res, NewPS] = 
		gen_server:call(NewPlayerStatus#player.other#player_other.pid_goods, {'upgrade', NewPlayerStatus, GoodsId, BindFirst}),
	NewPstatus = lib_player:calc_player_battle_attr(GoodsId, NewPS),
	lib_player:send_player_attribute3(NewPstatus),
	{ok, BinData} = pt_15:write(15031, [Res, GoodsId]),
    lib_send:send_one(NewPstatus#player.other#player_other.socket, BinData),
	{ok, NewPstatus};

%% 神炼
handle(15032, NewPlayerStatus, [GoodsTid, BindFirst, Num]) ->
	[Res, NewPS] = 
		gen_server:call(NewPlayerStatus#player.other#player_other.pid_goods, {'godtried', NewPlayerStatus, GoodsTid, BindFirst}),		
	{ok, BinData} = pt_15:write(15032, Res),
    lib_send:send_one(NewPS#player.other#player_other.socket, BinData),
	{ok, NewPS};

%% 容错处理
handle(_Cmd, _Status, _Data) ->
	%%     ?DEBUG_MSG("pp_goods no match", []),
	{error, "pp_goods no match"}.