%%%------------------------------------
%%% @Module  : mod_goods
%%% @Author  : 
%%% @Email   : 
%%% @Created :
%%% @Description: 物品模块
%%%------------------------------------
-module(mod_goods).
-behaviour(gen_server).
-export([start/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
		 get_goods_status/1,
		 handle_get_bag_null_cells_nums/1,
		 update_goods_status/2
		]).

-include("common.hrl").
-include("record.hrl").
-include("goods.hrl").
-include("debug.hrl").
-include("goods_record.hrl").
-include("log.hrl").

start(PlayerId, CellNum, GoodsEtsId) ->
    gen_server:start_link(?MODULE, [PlayerId, CellNum, GoodsEtsId], []).
    
%% 获取物品进程状态
%% TODO: 处理call超时的情况
get_goods_status(GoodsPid) when is_pid(GoodsPid) ->
	gen_server:call(GoodsPid, {'STATUS'});
get_goods_status(PS) ->
	gen_server:call(PS#player.other#player_other.pid_goods, {'STATUS'}).

%% desc: 获取背包空格子数
handle_get_bag_null_cells_nums(PS) ->
    gen_server:call(PS#player.other#player_other.pid_goods, {'BAG_NULL_CELL_NUMS'}).

%% desc: 扩展背包
extend_bag(GoodsPid, AddCellNum) ->
	gen_server:cast(GoodsPid, {'EXTEND_BAG', AddCellNum}).

%% 更新物品进程的状态
update_goods_status(GoodsPid, NewGoodsStatus) when is_pid(GoodsPid) ->
	?ASSERT(is_record(NewGoodsStatus, goods_status)),
	gen_server:cast(GoodsPid, {'SET_STATUS', NewGoodsStatus});
update_goods_status(PS, NewGoodsStatus) ->
	?ASSERT(is_record(NewGoodsStatus, goods_status)),
	gen_server:cast(PS#player.other#player_other.pid_goods, {'SET_STATUS', NewGoodsStatus}).

init([PlayerId, CellNum, GoodsEtsId]) ->
	PlayerOther = #player_other{goods_ets_id = GoodsEtsId},
    PS = #player{id = PlayerId, other = PlayerOther},
	% 加载物品信息
    ok = goods_util:init_goods_online(PS),
	goods_util:load_goods_cd_info(PlayerId),
	% 获取玩家背包空格子信息
	NullCells = goods_util:get_bag_null_cells(PS#player{cell_num = CellNum}),
    GoodsStatus = #goods_status{uid = PlayerId, null_cells = NullCells},
	% TODO: 目前暂时只做人物装备、坐骑的显示
    InitEquip = [?DEFAULT_T_WEAPON, ?DEFAULT_T_ARMOR, ?DEFAULT_T_FASHION, ?DEFAULT_T_WEAPONACCESSORIES, ?DEFAULT_T_WINGS],
	NewStatus = goods_util:get_current_equip(PS, GoodsStatus#goods_status{equip_current = InitEquip}, ?LOCATION_PLAYER),
    {ok, NewStatus}.

handle_info(_Reason, GoodsStatus) ->
    {noreply, GoodsStatus}.

terminate(_Reason, _GoodsStatus) ->
    ok.

code_change(_OldVsn, GoodsStatus, _Extra)->
    {ok, GoodsStatus}.

%%设置物品信息
handle_cast({'SET_STATUS', NewStatus}, _GoodsStatus) ->
    {noreply, NewStatus};


%% desc: 15000 获取物品详细信息
handle_cast({'info', PS, GoodsId}, GoodsStatus) ->
	                GoodsInfo = goods_util:get_goods_by_location(PS, GoodsId),
    [Info, Snum, AttrList] = case is_record(GoodsInfo, goods) andalso GoodsInfo#goods.type =:= ?GOODS_T_EQUIP of
                                           true when GoodsInfo#goods.suit_id > 0 -> 
                                               [GoodsInfo, 1, lib_equip:get_equip_add_attri(PS, GoodsInfo)];
                                           true ->
                                               [GoodsInfo, 0, lib_equip:get_equip_add_attri(PS, GoodsInfo)];
                                           false -> 
                                               [{}, 0, []]
                                       end,
    {ok, BinData} = pt_15:write_goods_info(15000, [Info, Snum, AttrList]),
    lib_send:send_one(PS#player.other#player_other.socket, BinData),
    {noreply, GoodsStatus};

%% desc: 15001 查询别人物品详细信息(同一场景查看)
handle_cast({'info_other', PS, RoleId, GoodsId}, GoodsStatus) ->
    [Info, SNum, AttriList] =
        case lib_common:get_ets_info(?ETS_ONLINE, RoleId) of
            {} -> % 玩家不在线                
                [{}, 0, []];
            Online ->
                case goods_util:get_goods(Online, GoodsId) of
                    GoodsInfo when is_record(GoodsInfo, goods) andalso GoodsInfo#goods.uid =:= RoleId
					  						andalso GoodsInfo#goods.type =:= ?GOODS_T_EQUIP ->
                        AttributeList = lib_equip:get_equip_add_attri(Online, GoodsInfo),
                        SuitNum = 0,
                        [GoodsInfo, SuitNum, AttributeList];
                    _Other ->
                        [{}, 0, []]
                end
        end,
    {ok, BinData} = pt_15:write_goods_info(15001, [Info, SNum, AttriList]),
    lib_send:send_one(PS#player.other#player_other.socket, BinData),
    {noreply, GoodsStatus};

%% desc: 15002 获取玩家物品列表信息
handle_cast({'list', PlayerStatus, Location}, GoodsStatus) ->
    [CellNum, TotalList] = 
    case Location of
        ?LOCATION_BAG ->   % 玩家背包
            Num = PlayerStatus#player.cell_num,
            List = goods_util:get_goods_list(PlayerStatus, ?LOCATION_BAG),
            [Num, List];     
        ?LOCATION_PLAYER ->   % 玩家主角装备
            Num = ?MAX_PLAYER_EQUIP_POS,
            EquipList = goods_util:get_kind_goods_list(PlayerStatus, ?GOODS_T_EQUIP, ?LOCATION_PLAYER),
            MountList = goods_util:get_kind_goods_list(PlayerStatus, ?GOODS_T_MOUNT, ?LOCATION_PLAYER),
            [Num, MountList ++ EquipList];
        _ -> 
            [0, []]
    end,
	?TRACE("TotalList:~p Location:~p ~n", [TotalList, Location]),
    {ok, BinData} = pt_15:write(15002, [Location, CellNum, TotalList]),
    lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),
    {noreply, GoodsStatus};

%% desc: 15004 背包拖动物品 即使是同类可叠加状态的物品也只能是交换位置
handle_cast({'drag', PlayerStatus, GoodsId, _OldCell, NewCell}, GoodsStatus) ->
    [Result, CellId1, TId1, CellId2, TId2, NewGS, OldCell, Location] =
        case goods_util:check_drag(PlayerStatus, GoodsStatus, GoodsId, NewCell) of
            {fail, Res} ->
                [Res, 0, 0, 0, 0, GoodsStatus, 0, 0];
            {ok, GoodsInfo} when GoodsInfo#goods.cell =:= NewCell ->
                [?RESULT_OK, 0, 0, 0, 0, GoodsStatus, 0, 0];
            {ok, GoodsInfo} ->
                case (catch goods_util:drag_goods(PlayerStatus, GoodsStatus, GoodsInfo, NewCell)) of
                    {ok, NewStatus, [OldCellId, OldTypeId, NewCellId, NewTypeId]} ->
                        [?RESULT_OK, OldCellId, OldTypeId, NewCellId, NewTypeId, NewStatus, GoodsInfo#goods.cell, GoodsInfo#goods.location];
                    Error ->
                        ?ERROR_MSG("mod_goods drag:~p", [Error]),
                        [?RESULT_FAIL, 0, 0, 0, 0, GoodsStatus, 0, 0]
                end
        end,
    {ok, BinData} = pt_15:write(15004, [Result, CellId1, TId1, OldCell, CellId2, TId2, NewCell]),
    lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),    
    goods_util:refresh_location(Result, PlayerStatus, Location),
    {noreply, NewGS};

% %% desc: 15005 拆分物品
handle_cast({'split', PlayerStatus, GoodsId, GoodsNum}, GoodsStatus) ->
    [Result, NewGS] = case goods_util:check_split(PlayerStatus, GoodsStatus, GoodsId, GoodsNum) of
                             {fail, Res} ->
                                 [Res, GoodsStatus];
                             {ok, GoodsInfo} ->
                                 case (catch lib_goods:split_goods({PlayerStatus, GoodsStatus}, GoodsInfo, GoodsNum)) of
                                     {ok, NewStatus} -> 
                                         [?RESULT_OK, NewStatus];
                                     Error ->
                                         ?ERROR_MSG("mod_goods split:~p", [Error]),
                                         [?RESULT_FAIL, GoodsStatus]
                                 end
                         end,
    {ok, BinData} = pt_15:write(15005, [Result, GoodsId, GoodsNum]),
    lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),
    goods_util:refresh_location(Result, PlayerStatus, ?LOCATION_BAG),
    {noreply, NewGS};

%% desc: 15006 整理背包
handle_cast({'clean', PS}, GoodsStatus) ->
	GoodsList = goods_util:get_goods_list(PS, ?LOCATION_BAG),
	NewGS = goods_util:clean_location(PS, GoodsList, GoodsStatus),
	{noreply, NewGS};

%% desc: 15021 查看装备的洗炼属性
handle_cast({'GET_POLISH_ATTRI', PS, GoodsId}, GS) ->
    case lib_equip:is_equip(PS, GoodsId) of
        {true, GoodsInfo} -> 
            {CurList, NewList} = casting_util:get_polish_attri(PS, GoodsInfo),
            SortCur = lists:sort(CurList),
            lib_common:pack_and_send(PS, pt_15, 15021, [GoodsId, SortCur, NewList]);
        false ->
            lib_common:pack_and_send(PS, pt_15, 15021, [0, [], []])
    end,
    {noreply, GS};

%% desc: 15025查询玩家或武将的全身强化奖励类型
handle_cast({'GET_EQUIP_T_REWARD', PS, TargetId, TargetType}, GS) ->
    Args = case TargetType of
             1 -> % 表示查询玩家
             	{player, PS, TargetId};
             2 -> % 表示查询武将
             	{partner, PS, TargetId}
         end,
%%     {RewardType, Num7, Num8, Num9, Num10, Num11, Num12} = lib_equip:get_total_stren_reward(Args),
%%     {ok, BinData} = pt_15:write(15025, [TargetId, TargetType, RewardType, ?ROLE_TOTAL_EQUIP_NUM, Num7, Num8, Num9, Num10, Num11, Num12]),
%%     lib_send:send_one(PS#player.other#player_other.socket, BinData),
    {noreply, GS};

%% desc: 15026 获取玩家物品列表信息
handle_cast({'list_other', PlayerStatus, RoleId}, GoodsStatus) ->
    [Res, GoodsList] = case ets:lookup(?ETS_ONLINE, RoleId) of
                           [] ->   % 玩家不在线、不存在或者在其他节点场景
                               case mod_arena:get_goods(RoleId) of
                                   {false, L0}  -> [?RESULT_FAIL, L0];
                                   {true, L0}   -> [?RESULT_OK, L0]
                               end;
                           [_R] ->
                               EquipList = goods_util:get_kind_goods_list(RoleId, ?GOODS_T_EQUIP, ?LOCATION_PLAYER),
                               MountList = goods_util:get_kind_goods_list(RoleId, ?GOODS_T_MOUNT, ?LOCATION_PLAYER),
                               [?RESULT_OK, MountList ++ EquipList]
                       end,
    {ok, BinData} = pt_15:write(15026, [Res, GoodsList]),
    lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),
    {noreply, GoodsStatus};

% 背包新增一个空位 （在市场挂售物品成功后会cast这个消息）
handle_cast({'add_null_cell', NewNullCell}, GoodsStatus) ->
	 NullCells = lists:sort([NewNullCell | GoodsStatus#goods_status.null_cells]),
	 NewStatus = GoodsStatus#goods_status{null_cells = NullCells},
	 %% TODO: 是否需调用refresh_client()??..
	 {noreply, NewStatus};

% 扩展背包
%% handle_cast({'EXTEND_BAG', Level}, GoodsStatus) ->
%% 	AddCellNum = 
%% 		case tpl_level_bag:get(Level) of
%% 			CellInfo when is_record(CellInfo, temp_level_bag) ->
%% 				CellInfo#temp_level_bag.cell_num;
%% 			_ -> 0
%% 		end,
%% 	 NullCells = lists:sort([NewNullCell | GoodsStatus#goods_status.null_cells]),
%% 	 NewStatus = GoodsStatus#goods_status{null_cells = NullCells},
%% 	 {noreply, NewStatus};


    
%% desc: 给玩家赠送物品
handle_cast({'give_goods', Location, GoodsList, Source}, GoodsStatus) ->
    case lib_goods:give_goods(Location, GoodsList, GoodsStatus, Source) of
        NewGS when is_record(NewGS, goods_status) ->
            {noreply, NewGS};
        _Error ->
            ?ERROR_MSG("mod_goods give_goods:~p", [_Error]),
            {noreply, GoodsStatus}
    end;
    
%% desc: 给玩家赠送商城购买物品
handle_cast({'give_shopgoods', BindState, Location, GoodsList}, GoodsStatus) ->
    case goods_util:give_shopgoods(BindState, Location, GoodsList, GoodsStatus) of
        NewGS when is_record(NewGS, goods_status) ->
            {noreply, NewGS};
        _Error ->
            ?ERROR_MSG("mod_goods give_goods:~p", [_Error]),
            {noreply, GoodsStatus}
    end;

%% desc: 查看某件装备最大+12的强化属性
handle_cast({'get_stren_max_info', PS, GoodsId}, GS) ->
    [Info, SNum, AList] =
        case lib_equip:is_equip(PS, GoodsId) of
            {true, GoodsInfo} -> casting_util:get_stren_max_info(PS, GoodsInfo);
            false ->               [{}, 0, []]
        end,
    lib_common:pack_and_send(PS, pt_15, write_goods_info, 15004, [Info, SNum, AList]),
    {noreply, GS};

%% desc: 15028 丢弃物品
handle_cast({'throw', PlayerStatus, GoodsId, GoodsNum}, GoodsStatus) ->
    {Result, NewGS}=  case goods_util:check_throw(PlayerStatus, GoodsStatus, GoodsId, GoodsNum) of
					        {fail, Res} -> {Res, GoodsStatus};
					        {ok, GoodsInfo} ->
					            case (catch lib_goods:delete_one(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum, ?LOG_ABANDON_GOODS)) of
					                {ok, NewStatus, _} ->
					                    {?RESULT_OK, NewStatus};
					                Error ->
					                    ?ERROR_MSG("mod_goods throw:~p", [Error]),
					                    {?RESULT_FAIL, GoodsStatus}
					            end
					    end,
	{ok, BinData} = pt_15:write(15028, [Result, GoodsId, GoodsNum]),
    lib_send:send_one(PlayerStatus#player.other#player_other.socket, BinData),
%%     goods_util:refresh_location(Result, PlayerStatus, ?LOCATION_BAG),
    {noreply, NewGS};

%% desc: 15030查看某件装备的镀金/升级属性
handle_cast({'GET_CASTING_INFO', PS, [GoodsId, Type]}, GS) ->
    [Info, Snum, AttrList] =
        case lib_equip:is_equip(PS, GoodsId) of
            {true, GoodsInfo} ->
				if
					Type =:= 1 -> % 镀金
						casting_util:calc_gilding_info(PS, GoodsInfo);
					Type =:= 2 -> % 升级
						casting_util:calc_upgrade_info(PS, GoodsInfo);
					true ->	
						[{}, 0, []]
				end;
            false ->
				[{}, 0, []]
        end,
    {ok, BinData} = pt_15:write_goods_info(15030, [Info, Snum, AttrList]),
    lib_send:send_one(PS#player.other#player_other.socket, BinData),
    {noreply, GS};

handle_cast(_R , GoodsStatus) ->
    {noreply, GoodsStatus}.

%% desc: 15003 扩充背包
handle_call({'extend', PlayerStatus, Location}, _From, GoodsStatus) ->
	Type = ?MONEY_T_GOLD,
    case goods_util:check_extend(PlayerStatus, Location, Type) of
        {fail, Res} ->
            {reply, [PlayerStatus, Res], GoodsStatus};
        {ok, Cost, AddCells, OldCells} ->
            case (catch goods_util:extend_bag(PlayerStatus, Cost, Type, AddCells, OldCells, Location, GoodsStatus)) of
                {ok, NewPlayerStatus, NewStatus} ->
                    {reply, [NewPlayerStatus, ?RESULT_OK], NewStatus};
				Error ->
                    ?ERROR_MSG("mod_goods extend:~p", [Error]),
                    {reply, [PlayerStatus, ?RESULT_FAIL], GoodsStatus}
            end
    end;

%% desc: 15007 出售物品
handle_call({'sell', PlayerStatus, GoodsId, GoodsNum}, _From, GoodsStatus) ->
    case goods_util:check_sell(PlayerStatus, GoodsStatus, GoodsId, GoodsNum) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus], GoodsStatus};
        {ok, GoodsInfo} ->
            case (catch goods_util:sell_goods(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum)) of
                {ok, NewPlayerStatus, NewStatus} ->
                    {reply, [?RESULT_OK, NewPlayerStatus], NewStatus};
                Error ->
                    ?ERROR_MSG("mod_goods sell:~p", [Error]),
                    {reply, [?RESULT_FAIL, PlayerStatus], GoodsStatus}
            end
    end;

%% 寄售物品

%% desc: 15009 使用物品
handle_call({'use', PlayerStatus, GoodsId, GoodsNum}, _From, GoodsStatus) ->
    case goods_util:check_use(GoodsStatus, GoodsId, GoodsNum, PlayerStatus) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus, 0, 0], GoodsStatus};
        {ok, GoodsInfo} ->
            case (catch goods_util:use_goods(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum)) of
                {ok, NewPlayerStatus, NewStatus, NewNum} ->
					VipMemeber = lists:member(GoodsInfo#goods.gtid, ?VIP_TID_LIST),
					Res = if VipMemeber == true ->
								 ?RESULT_OK;
							 GoodsInfo#goods.type == ?GOODS_T_CARD andalso GoodsInfo#goods.subtype == ?WING_CARD ->
								 ?RESULT_OK;
							 true -> ?RESULT_OK
						  end,
                     {reply, [Res, NewPlayerStatus, GoodsInfo#goods.gtid, NewNum], NewStatus};
                 _Error ->
                     {reply, [?RESULT_FAIL, PlayerStatus, 0, 0], GoodsStatus}
            end
    end;

%% 15014 向商城购买物品
handle_call({'buy_shop_goods', PlayerStatus, ShopTabType, GoodsTid, GoodsNum}, _From, GoodsStatus) ->
    case lib_shop:handle_buy_shop_goods(GoodsStatus, PlayerStatus, ShopTabType, GoodsTid, GoodsNum) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus], GoodsStatus};
        {ok, Res, NewStatus, NewPS} ->
			{reply, [Res, NewPS], NewStatus}			
	end;

%% 15016 向NPC商店购买物品
handle_call({'buy_npc_shop_goods', PlayerStatus, ShopId, PageNo, GoodsTid, Num}, _From, GoodsStatus) ->
    case lib_shop:handle_buy_npc_sells(GoodsStatus, PlayerStatus, ShopId, PageNo, GoodsTid, Num) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus], GoodsStatus};
        {ok, Res, NewStatus, NewPS} ->
			{reply, [Res, NewPS], NewStatus}			
	end;

%% desc: 15017 装备物品
handle_call({'equip', PlayerStatus, GoodsId, PetId}, _From, GoodsStatus) ->
	Location = 	case PetId =:= 0 of
					true -> ?LOCATION_PLAYER;    % 表示是玩家穿装备
					false -> ?LOCATION_PET   % 表示是宠物穿装备
				end,
	?TRACE("equip, goodsid: ~p, PetId: ~p, loc:~p~n", [GoodsId, PetId, Location]),
    case goods_util:check_equip(PlayerStatus, GoodsId, PetId, Location) of
        {fail, Res} ->
            {reply, [PlayerStatus, Res, {}, {}], GoodsStatus};
        {ok, GoodsInfo} ->
            case (catch goods_util:equip_goods(PlayerStatus, GoodsStatus, GoodsInfo, PetId, Location)) of
                {ok, NewPlayerStatus, NewPetInfo, NewStatus, OldGoodsInfo} ->
                	NewPlayerStatus1 =
					if Location =:= ?LOCATION_PLAYER ->
							NewPlayerStatus;
                		Location =:= ?LOCATION_PET -> 
							NewPlayerStatus;
                		true -> NewPlayerStatus
                	end,
                    {reply, [NewPlayerStatus1, ?RESULT_OK, NewPetInfo, OldGoodsInfo], NewStatus};
                Error ->
                    ?ERROR_MSG("mod_goods equip: ~p", [{Error, PetId, is_record(GoodsInfo, goods)}]),
                	?ASSERT(false),
                    {reply, [PlayerStatus, ?RESULT_FAIL, {}, {}], GoodsStatus}
            end
    end;

%% desc: 15018 卸下装备
handle_call({'unequip', PlayerStatus, [GoodsId, PetId]}, _From, GoodsStatus) ->
	Location = 	case PetId =:= 0 of
					true -> ?LOCATION_PLAYER;    % 表示是玩家卸装备
					false -> ?LOCATION_PET   % 表示是武将卸装备
				end,
    case goods_util:check_unequip(PlayerStatus, GoodsStatus, [GoodsId, PetId, Location]) of
        {fail, Res} ->
            {reply, [PlayerStatus, {}, Res, {}], GoodsStatus};
        {ok, GoodsInfo} ->
            case (catch goods_util:unequip_goods(PlayerStatus, GoodsStatus, GoodsInfo, PetId, Location)) of
                {ok, NewPlayerStatus, NewPetInfo, NewStatus, NewGoodsInfo} ->
                     {reply, [NewPlayerStatus, NewPetInfo, ?RESULT_OK, NewGoodsInfo], NewStatus};
                 Error ->
                     ?ERROR_MSG("mod_goods unequip:~p", [Error]),
                     {reply, [PlayerStatus, {}, ?RESULT_FAIL, {}], GoodsStatus}
            end
    end;

%% 15019 装备强化
handle_call({'strengthen', PS, GoodsId, FirstUseFlag, AutoBuy, Type}, _From, GS) ->
    case casting_util:check_strengthen(PS, [GoodsId, FirstUseFlag, AutoBuy, Type]) of
        {fail, Res} ->
            {reply, [Res, PS, 0, 0, 0, 0, 0], GS};
        {ok, Res, StoneTuple, CostList, Degree, GoodsInfo, GoodsStrenInfo} ->
			case handle_casting(equip_stren, PS, GS, [StoneTuple, CostList, Degree, GoodsInfo, GoodsStrenInfo, FirstUseFlag]) of
                [_Res, NewGS, NewPS, NewStren, NewDegree, CostSnum, CostCoin, CostGold] ->
					NewPS1 = lib_equip:appearance_handle(NewPS, GoodsInfo, NewStren),
                    {reply, [Res, NewPS1, NewStren, NewDegree, CostSnum, CostCoin, CostGold], NewGS};
                Error ->
                    ?ERROR_MSG("mod_goods equip_stren error:~p", [Error]),
                    {reply, [?RESULT_FAIL, PS, 0, 0, 0, 0, 0], GS}
            end
    end;

%% 15020 装备洗炼
handle_call({'polish', PlayerStatus, GoodsId, BindFirst, AutoBuy, AutoLock, IdList}, _From, GoodsStatus) ->
    case casting_util:check_polish(PlayerStatus, GoodsId, BindFirst, AutoBuy, AutoLock, IdList) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus, ?RESULT_FAIL], GoodsStatus};
        {ok, Stone, LockList, UseLockNum, GoodsInfo, GoldPrice, CoinPrice, IdList} ->
			case handle_casting(equip_polish, PlayerStatus, GoodsStatus, [Stone, LockList, UseLockNum,
															 GoodsInfo, GoldPrice, CoinPrice, IdList]) of
				[NewPStatus, NewGStatus, WashType] ->
					{reply, [?RESULT_OK, NewPStatus, WashType], NewGStatus};
				Error ->
					?ERROR_MSG("mod_goods wash error:~p", [Error]),
					{reply, [?RESULT_FAIL, PlayerStatus, ?RESULT_FAIL], GoodsStatus}
			end
	end;

%% 15022 宝石镶嵌(固定孔位)
handle_call({'inlay', PlayerStatus, GoodsId, StoneIdList}, _From, GoodsStatus) ->
    case casting_util:check_inlay(PlayerStatus, GoodsId, StoneIdList) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus], GoodsStatus};
		{ok, GoodsInfo, LogIdList, StoneInfoList, Cost} ->
			case handle_casting(equip_inlay, PlayerStatus, GoodsStatus, [GoodsInfo, LogIdList, StoneInfoList, Cost]) of
				[Res, NewStatus, NewGstatus] ->
					{reply, [Res, NewStatus], NewGstatus};
				Error ->
					?ERROR_MSG("mod_goods equip_inlay error:~p", [Error]),
					{reply, [?RESULT_FAIL, PlayerStatus], GoodsStatus}
			end
	end;

%% 15023 宝石拆除
handle_call({'backout', PlayerStatus, [GoodsId, List]}, _From, GoodsStatus) ->
    case casting_util:check_backout(PlayerStatus, GoodsStatus, [GoodsId, List]) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus, GoodsId], GoodsStatus};
        {ok, GoodsInfo, StoneTypeIdList, BackoutCost} ->
			case handle_casting(equip_backout, PlayerStatus, GoodsStatus, [GoodsInfo, StoneTypeIdList, BackoutCost]) of
				[Res, NewStatus, NewPS] ->
					{reply, [Res, NewPS, GoodsId], NewStatus};
				Error ->
					?ERROR_MSG("mod_goods equip_backout error:~p", [Error]),
					{reply, [?RESULT_FAIL, PlayerStatus, GoodsId], GoodsStatus}
			end
	end;

%% 15024 宝石合成
handle_call({'compose', PlayerStatus, StoneTid, ComposeNum}, _From, GoodsStatus) ->
    case casting_util:check_compose(PlayerStatus, GoodsStatus, StoneTid, ComposeNum) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus], GoodsStatus};
        {ok, CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum} ->
			case handle_casting(equip_compose, PlayerStatus, GoodsStatus, [CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum]) of
				[Res, NewStatus, NewPS] ->
					{reply, [Res, NewPS], NewStatus};
				Error ->
					?ERROR_MSG("mod_goods equip_compose:~p", [Error]),
					{reply, [?RESULT_FAIL, PlayerStatus], GoodsStatus}
			end
	end;

%% 15027 洗炼替换
handle_call({'replace_polish_attri', PS, GoodsId}, _From, GS) ->
    case casting_util:replace_equip_polish_attri(PS, GoodsId) of
        {fail, Res} ->
            {reply, Res, GS};
        ok ->
            {reply, ?RESULT_OK, GS}
    end;

%% desc: 获取背包中某一种物品的个数
handle_call({'get_goods_num', GoodsTid, BindState}, _From, GoodsStatus) ->
    case lib_goods:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTid, BindState, ?LOCATION_BAG) of
        List when is_list(List) ->
            Num = lib_goods:calc_goodslist_total_nums(List),
            {reply, Num, GoodsStatus};
        _Error ->
            {reply, ?RESULT_FAIL, GoodsStatus}
    end;

%% desc: 删除背包中某一种物品指定个数
handle_call({'delete_bag_goods', PS, GoodsTid, BindState, Num, Source}, _From, GoodsStatus) ->
    case lib_goods:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTid, BindState, ?LOCATION_BAG) of
        List when is_list(List) ->
            Nums = lib_goods:calc_goodslist_total_nums(List),
            case Nums >= Num of
                false ->
                    % 数量不足，不能扣除
                    {reply, {false, not_enough}, GoodsStatus};
                true ->
                    {ok, NewStatus} = lib_goods:delete_more({PS, GoodsStatus}, List, Num, Source),
                    {reply, true, NewStatus}
            end;
        _Error ->
            ?ERROR_MSG("delete_bag_goods failed:~p", [_Error]),
            {reply, {error, bad_args}, GoodsStatus}
    end;

%% desc: 删除一类物品（对同一格子编号的物品而言）
handle_call({'delete_one', PS, GoodsId, GoodsNum, Source}, _From, GoodsStatus) ->
    GoodsInfo = goods_util:get_goods(PS, GoodsId),
    if
        % 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {reply, [2, 0], GoodsStatus};
        % 物品数量不正确
        GoodsInfo#goods.num < GoodsNum ->
            {reply, [3, 0], GoodsStatus};
        true ->
            case (catch lib_goods:delete_one(PS, GoodsStatus, GoodsInfo, GoodsNum, Source)) of
                {ok, NewStatus, NewNum} ->
                     lib_player:refresh_client(GoodsStatus#goods_status.uid, 2),
                     {reply, [?RESULT_OK, NewNum], NewStatus};
                 Error ->
                     ?ERROR_MSG("mod_goods delete_one:~p", [Error]),
                     {reply, [?RESULT_FAIL, 0], GoodsStatus}
            end
    end;

%% desc: 删除多个格子的同类型物品
handle_call({'delete_more', PS, GoodsTypeId, GoodsNum, Source}, _From, GoodsStatus) ->
    GoodsList = lib_goods:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, ?LOCATION_BAG),
    TotalNum = lib_goods:calc_goodslist_total_nums(GoodsList),
    if 
        % 物品不存在
        length(GoodsList) =:= 0 ->
            {reply, 2, GoodsStatus};
        % 物品数量不足
        TotalNum < GoodsNum ->
            {reply, 3, GoodsStatus};
        true ->
            case (catch lib_goods:delete_more({PS, GoodsStatus}, GoodsList, GoodsNum, Source)) of
                {ok, NewStatus} ->
                     lib_player:refresh_client(GoodsStatus#goods_status.uid, 2),
                     {reply, ?RESULT_OK, NewStatus};
                 Error ->
                     ?ERROR_MSG("mod_goods delete_more:~p", [Error]),
                     {reply, ?RESULT_FAIL, GoodsStatus}
            end
    end;

handle_call({'give_goods', Location, GoodsList, Source}, _From, GoodsStatus) ->
    case lib_goods:give_goods(Location, GoodsList, GoodsStatus, Source) of
        NewGS when is_record(NewGS, goods_status) ->
            {reply, ok, NewGS};
        _Error ->
            ?ERROR_MSG("mod_goods give_goods:~p", [_Error]),
            {reply, failed, GoodsStatus}
    end;

%% desc: 给玩家赠送物品和钱
handle_call({'give_goods_and_money', PS, Location, GoodsList, Source}, _From, GoodsStatus) ->
    case lib_goods:give_goods_and_money(Location, GoodsList, PS, GoodsStatus, Source) of
        {NewPS, NewGS} when is_record(NewGS, goods_status) ->
            {reply, NewPS, NewGS};
        _Error ->
            ?ERROR_MSG("mod_goods give_goods_and_money:~p", [_Error]),
            {reply, PS, GoodsStatus}
    end;

%% desc: 获取物品状态
handle_call({'STATUS'} , _From, GoodsStatus) ->
    {reply, GoodsStatus, GoodsStatus};

%% desc: 设置物品信息
handle_call({'SET_STATUS', NewGoodsStatus}, _From, _GoodsStatus) ->
    {reply, ok, NewGoodsStatus};

%% desc: 获取背包空格子数
handle_call({'BAG_NULL_CELL_NUMS'} , _From, GoodsStatus) ->
    {reply, length(GoodsStatus#goods_status.null_cells), GoodsStatus};

%% desc: 获取背包空格子数
handle_call({'TREA_NULL_CELL_NUMS'} , _From, GoodsStatus) ->
    {reply, length(GoodsStatus#goods_status.trea_null_cells), GoodsStatus};

%% 15029 装备镀金
handle_call({'gilding', PS, GoodsId, FirstUseFlag}, _From, GS) ->
    case casting_util:check_gilding(PS, GoodsId, FirstUseFlag) of
        {fail, Res} ->
            {reply, [Res, PS, 0], GS};
        {ok, Res, GoodsInfo, CostGoodsTid, CostGoodsNum, CostCoin} ->
			case handle_casting(gilding, PS, GS, [GoodsInfo, CostGoodsTid, CostGoodsNum, CostCoin, FirstUseFlag]) of
                [ok, Res1, NewGS, NewPS, NewGildingLv, _CostCoin] ->
%% 					NewPS1 = lib_equip:appearance_handle(NewPS, GoodsInfo, NewStren),
                    {reply, [Res1, NewPS, NewGildingLv], NewGS};
                Error ->
                    ?ERROR_MSG("mod_goods equip_stren error:~p", [Error]),
                    {reply, [?RESULT_FAIL, PS, 0], GS}
            end
    end;

%% 15031 装备升级
handle_call({'upgrade', PS, GoodsId, FirstUseFlag}, _From, GS) ->
    case casting_util:check_upgrade(PS, GoodsId, FirstUseFlag) of
        {fail, Res} ->
            {reply, [Res, PS], GS};
        {ok, Res, GoodsInfo, NewGoodsTmp, CostGoodsList, CostCoin} ->
			case handle_casting(upgrade, PS, GS, [GoodsInfo, NewGoodsTmp, CostGoodsList, CostCoin, FirstUseFlag]) of
                [ok, Res1, NewGS, NewPS, _NewEquipLv, _CostCoin] ->
%% 					NewPS1 = lib_equip:appearance_handle(NewPS, GoodsInfo, NewStren),
                    {reply, [Res1, NewPS], NewGS};
                Error ->
                    ?ERROR_MSG("mod_goods equip_stren error:~p", [Error]),
                    {reply, [?RESULT_FAIL, PS], GS}
            end
    end;

%% 15032 宝石神炼
handle_call({'godtried', PlayerStatus, StoneTid, FirstUseFlag, Num}, _From, GoodsStatus) ->
    case casting_util:check_godtried(PlayerStatus, GoodsStatus, StoneTid, FirstUseFlag, Num) of
        {fail, Res} ->
            {reply, [Res, PlayerStatus], GoodsStatus};
        {ok, CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum} ->
			case handle_casting(equip_godtried, PlayerStatus, GoodsStatus, [CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum]) of
				[Res, NewStatus, NewPS] ->
					{reply, [Res, NewPS], NewStatus};
				Error ->
					?ERROR_MSG("mod_goods equip_compose:~p", [Error]),
					{reply, [?RESULT_FAIL, PlayerStatus], GoodsStatus}
			end
	end;

%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, State) ->
    Reply  = 
    case (catch apply(Module, Method, Args)) of
         {'EXIT', Info} ->  
              ?WARNING_MSG("mod_guild__apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
             error;
         DataRet -> DataRet
    end,
    {reply, Reply, State};

%% 错误处理
handle_call(_R , _From, GoodsStatus) ->
    {reply, ok, GoodsStatus}.

%% 装备洗炼
handle_casting(equip_polish, PlayerStatus, GoodsStatus, [Stone, LockList, UseLockNum, GoodsInfo, GoldPrice, CoinPrice, IdList]) ->	
	case ( catch casting_util:polish(PlayerStatus, GoodsStatus, Stone, LockList, UseLockNum, GoodsInfo, GoldPrice, CoinPrice, IdList) ) of
		{ok, NewPStatus, NewGStatus, WashType} ->
            [NewPStatus, NewGStatus, WashType];
		Error -> 
            Error
	end;

%% 宝石合成
handle_casting(equip_compose, PlayerStatus, GoodsStatus, [CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum]) ->
	case ( catch casting_util:compose(PlayerStatus, GoodsStatus, CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum) ) of
		{ok, NewPS, NewStatus, _CostCoin} ->
			[?RESULT_OK, NewStatus, NewPS];
        {fail, NewPS, NewStatus} ->
			[?RESULT_FAIL, NewStatus, NewPS];
		Error -> 
            Error
    end;

%% 宝石镶嵌
handle_casting(equip_inlay, PlayerStatus, GoodsStatus, [GoodsInfo, LogIdList, StoneInfoList, Cost]) ->		
	case (catch casting_util:inlay(PlayerStatus, GoodsStatus, GoodsInfo, LogIdList, StoneInfoList, Cost)) of
		{ok, Res, NewPStatus, NewGStatus} ->
            [Res, NewPStatus, NewGStatus];
		Error -> 
            Error
	end;
			
%% 装备强化	
handle_casting(equip_stren, PlayerStatus, GoodsStatus, CheckResult) ->	
	case (catch casting_util:stren_equip(PlayerStatus, GoodsStatus, CheckResult) ) of
        {ok, Res, NewGS, NewPS, Stren, Degree, CostCoin, CostGold} ->
            [Res, NewGS, NewPS, Stren, Degree, CostCoin, CostGold];
		Error -> 
            Error
	end;

%% 宝石拆除
handle_casting(equip_backout, PlayerStatus, GoodsStatus, CheckResult) ->		
	case ( catch casting_util:backout(PlayerStatus, GoodsStatus, CheckResult) ) of
		{ok, NewPStatus, NewGStatus} -> 
            [?RESULT_OK, NewGStatus, NewPStatus];
		Error ->  
            Error
	end;

%% 装备镀金	
handle_casting(gilding, PlayerStatus, GoodsStatus, CheckResult) ->	
	case (catch casting_util:gilding_equip(PlayerStatus, GoodsStatus, CheckResult) ) of
        {ok, Res, NewGS, NewPS, GildingLv, CostCoin} ->
            [Res, NewGS, NewPS, GildingLv, CostCoin];
		Error -> 
            Error
	end;

%% 装备升级	
handle_casting(upgrade, PlayerStatus, GoodsStatus, CheckResult) ->	
	case (catch casting_util:upgrade_equip(PlayerStatus, GoodsStatus, CheckResult) ) of
        {ok, Res, NewGS, NewPS, NewEquipLv, CostCoin} ->
            [Res, NewGS, NewPS, NewEquipLv, CostCoin];
		Error -> 
            Error
	end;

%% 宝石神炼
handle_casting(equip_godtried, PlayerStatus, GoodsStatus, [CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum]) ->
	case ( catch casting_util:godtried(PlayerStatus, GoodsStatus, CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum) ) of
		{ok, NewPS, NewStatus, _CostCoin} ->
			[?RESULT_OK, NewStatus, NewPS];
        {fail, NewPS, NewStatus} ->
			[?RESULT_FAIL, NewStatus, NewPS];
		Error -> 
            Error
    end.