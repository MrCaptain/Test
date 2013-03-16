%%%------------------------------------
%%% @Module  : mod_goods
%%% @Author  : csj
%%% @Created : 2011.8.23
%%% @Description: 物品模块
%%%------------------------------------
-module(mod_goods).
-behaviour(gen_server).
-compile(export_all).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include("debug.hrl").

start(PlayerId, CellNum, LastLoginTime, NowTime, Socket) ->
     gen_server:start_link(?MODULE, [PlayerId, CellNum, LastLoginTime, NowTime, Socket], []).

init([PlayerId, CellNum, LLoginTime, NowTime,PidSend]) ->
     process_flag(trap_exit, true),
     %ok = goods_util:init_goods_online(PlayerId, LLoginTime, NowTime),
     GoodsStatus = #goods_status{ uid = PlayerId, 
                                  null_cells = CellNum,
                                  pid_send = PidSend
                                },
     misc:write_monitor_pid(self(),?MODULE, {}),
     {ok, GoodsStatus}.
 
%%设置物品信息
handle_cast({'SET_STATUS', NewStatus}, _GoodsStatus) ->
    {noreply, NewStatus}.

%%获取位置物品全部信息
%% handle_cast({'get_all',PlayerId,Location},GoodsStatus) ->
%%     [Res,AllGoodsInfoList] =
%%     if
%%         Location =:= 1 orelse Location =:= 4 ->
%%             GoodsList = goods_util:get_goods_list(PlayerId, Location),
%%             F = fun(GoodsInfo) ->
%%                     %%类似获取单个物品信息的方法
%%                     case is_record(GoodsInfo, goods) of
%%                         true when GoodsInfo#goods.uid == GoodsStatus#goods_status.uid ->
%%                             case goods_util:has_attribute(GoodsInfo) of
%%                                 true -> AttributeList = goods_util:get_goods_attribute_list(GoodsStatus#goods_status.uid, GoodsInfo#goods.id);
%%                                 false -> AttributeList = []
%%                             end,
%%                             SuitNum = goods_util:get_suit_num(GoodsStatus#goods_status.equip_suit, GoodsInfo#goods.stid),
%%                             %%加成计算
%%                             NewGoodsInfo = goods_util:parse_goods_addition(GoodsInfo),
%%                             [NewGoodsInfo, SuitNum, AttributeList];
%%                         false ->
%%                             []
%%                     end
%%                 end,
%%             GetList = lists:map(F, GoodsList),
%%             [1,GetList];
%%         true ->
%%             [0,[]]
%%     end,
%%     {ok,BinData} = pt_15:write(15017,[Res,Location,AllGoodsInfoList]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send,BinData),
%%     {noreply,GoodsStatus};
%% 
%% %%背包拖动物品(15040)
%% handle_cast({'drag_15040',Cell_num, GoodsId, OldCell, NewCell}, GoodsStatus) ->
%%     [Res, R_OldCellId, R_OldTypeId, R_OldNum, R_NewCellId, R_NewTypeId, R_NewNum, R_GoodsStatus] =
%%     case check_drag(GoodsStatus, GoodsId, OldCell, NewCell, Cell_num, 4) of
%%         {fail, _Res} ->
%%             [_Res, 0, 0, 0, 0, 0, 0,GoodsStatus];
%%         {ok, GoodsInfo} ->
%%             case (catch lib_goods:drag_goods(GoodsStatus, GoodsInfo, OldCell, NewCell, 4)) of
%%                 {ok, NewStatus, [OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum]} ->
%%                     [1, OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum, NewStatus];
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods drag:~p", [Error]),
%%                     [0, 0, 0, 0, 0, 0, 0, GoodsStatus]
%%             end
%%     end,
%%     {ok, BinData} = pt_15:write(15040, [Res, R_OldCellId, R_OldTypeId, OldCell, R_OldNum, R_NewCellId, R_NewTypeId, NewCell, R_NewNum]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%     {noreply,R_GoodsStatus};
%% 
%% %%物品存入仓库 (15041)
%% handle_cast({'movein_bag_15041', Store_num,GoodsId, GoodsNum},GoodsStatus) ->
%%     [Res, CellNum, GoodsType, NewNum, NewId, R_GoodsStatus] =
%%     case check_movein_bag(GoodsStatus, GoodsId, GoodsNum) of
%%         {fail, _Res} ->
%%             [_Res, 0, 0, 0, 0, GoodsStatus];
%%         {ok, GoodsInfo, GoodsTypeInfo} ->
%% %%             io:format("~s 15041_______________[~p]\n",[misc:time_format(now()), [GoodsStatus]]),
%%             case (catch lib_goods:movein_bag(GoodsStatus, GoodsInfo, GoodsNum, GoodsTypeInfo, Store_num)) of
%%                 {ok, Cell, GNum, GId, NewStatus} ->
%%                     [1, Cell, GoodsInfo#goods.gtid, GNum, GId, NewStatus];
%%                 {fail, Cell, GNum, GId, full} ->
%%                     [6, Cell, 0, GNum, GId, GoodsStatus];                
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods movein_bag:~p", [Error]),
%%                     [0, 0, 0, 0, 0, GoodsStatus]
%%             end
%%     end,
%% %%     io:format("~s write_15041_______________[~p]\n",[misc:time_format(now()), [Store_num, Res]]),
%%     {ok, BinData} = pt_15:write(15041, [Res, GoodsId, NewId, GoodsType, CellNum, NewNum]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%     {noreply, R_GoodsStatus};
%% 
%% %%从仓库取出物品 (15042)
%% handle_cast({'moveout_bag_15042',Store_num, GoodsId, GoodsNum},GoodsStatus) ->
%%     [Res, CellNum, GoodsType, NewNum, NewId, R_GoodsStatus] =
%%     case check_moveout_bag(GoodsStatus, GoodsId, GoodsNum) of
%%         {fail, _Res} ->
%%             [_Res, 0, 0, 0, 0, GoodsStatus];
%%         {ok, GoodsInfo, GoodsTypeInfo} ->
%%             case lib_goods:moveout_bag(GoodsStatus, GoodsInfo, GoodsNum, GoodsTypeInfo, Store_num) of
%%                 {ok, Cell, GNum, GId, NewStatus} ->
%%                     [1, Cell, GoodsInfo#goods.gtid, GNum, GId, NewStatus];
%%                 {fail, Cell, GNum, GId, full} ->
%%                     [6, Cell, 0, GNum, GId, GoodsStatus];
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods moveout_bag:~p", [Error]),
%%                     [0, 0, 0, 0, 0, GoodsStatus]
%%             end
%%     end,
%%     {ok, BinData} = pt_15:write(15042, [Res, GoodsId, NewId, GoodsType, CellNum, NewNum]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%     {noreply, R_GoodsStatus};
%% 
%% %%拖动仓库物品(15043)
%% handle_cast({'drag_15043',Cell_num, GoodsId, OldCell, NewCell}, GoodsStatus) ->
%% %% io:format("~s drag_15043[~p/~p]\~n",[misc:time_format(now()), GoodsId, Cell_num]),
%%     [Res, R_OldCellId, R_OldTypeId, R_OldNum, R_NewCellId, R_NewTypeId, R_NewNum, R_GoodsStatus] =
%%     case check_drag(GoodsStatus, GoodsId, OldCell, NewCell, Cell_num, 5) of
%%         {fail, _Res} ->
%%             [_Res, 0, 0, 0, 0, 0, 0, GoodsStatus];
%%         {ok, GoodsInfo} ->
%%             case (catch lib_goods:drag_goods(GoodsStatus, GoodsInfo, OldCell, NewCell, 5)) of
%%                 {ok, NewStatus, [OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum]} ->
%%                     [1, OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum, NewStatus];
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods drag:~p", [Error]),
%%                     [0, 0, 0, 0, 0, 0, 0, GoodsStatus]
%%             end
%%     end,
%%     {ok, BinData} = pt_15:write(15043, [Res, R_OldCellId, R_OldTypeId, OldCell, R_OldNum, R_NewCellId, R_NewTypeId, NewCell, R_NewNum]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%     {noreply,R_GoodsStatus};
%% 
%% %%仓库背包物品交换
%% handle_cast({'drag_15044', Location, DepotCell_num, Bag_Cell_num, GoodsId, DepCell, BagCell}, GoodsStatus) ->
%% %% io:format("~s drag_15043[~p/~p]\~n",[misc:time_format(now()), GoodsId, Cell_num]),
%%     [Res, R_OldCellId, R_OldTypeId, R_OldNum, R_NewCellId, R_NewTypeId, R_NewNum, R_GoodsStatus] =
%%         case check_drag_15044(GoodsStatus, GoodsId, DepCell, BagCell, DepotCell_num, Bag_Cell_num, Location) of
%%             {fail, _Res} ->
%%                 [_Res, 0, 0, 0, 0, 0, 0, GoodsStatus];
%%             {ok, GoodsInfo} ->
%%                 [OriCell, TarCell] =
%%                     case Location of
%%                         4 ->
%%                             [BagCell, DepCell];
%%                         _ ->
%%                             [DepCell, BagCell]
%%                     end,
%%                 case (catch lib_goods:drag_goods_15044(GoodsStatus, GoodsInfo, OriCell, TarCell, Location)) of
%%                     {ok, NewStatus, [OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum]} ->
%%                         case Location of
%%                             5 ->
%%                                 [1, OldCellId, OldTypeId, OldNum, NewCellId, NewTypeId, NewNum, NewStatus];
%%                             _ ->
%%                                 [1, NewCellId, NewTypeId, NewNum, OldCellId, OldTypeId, OldNum, NewStatus]
%%                         end;
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods drag:~p", [Error]),
%%                         [0, 0, 0, 0, 0, 0, 0, GoodsStatus]
%%             end
%%     end,
%%     {ok, BinData} = pt_15:write(15044, [Res, R_OldCellId, R_OldTypeId, DepCell, R_OldNum, R_NewCellId, R_NewTypeId, BagCell, R_NewNum]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%     {noreply,R_GoodsStatus};
%% 
%% %%丢弃物品(15051)
%% handle_cast({'throw_15051', PlayerStatus,GoodsId, GoodsNum}, GoodsStatus) ->
%%     %%io:format("~s mod_goods:throw_15051[~p/~p]\~n",[misc:time_format(now()), GoodsId, GoodsNum]),
%%     [Res,R_GoodsStatus] =
%%     case check_throw(PlayerStatus,GoodsStatus, GoodsId, GoodsNum) of
%%         {fail, _Res} ->
%%         %%    io:format("~s mod_goods:throw_15051_fail[~p]\~n",[misc:time_format(now()), _Res]),
%%             [_Res, GoodsStatus];
%%         {ok, GoodsInfo} ->
%%             %%io:format("~s mod_goods:throw_15051_ok[~p]\~n",[misc:time_format(now()), test]),
%%             case (catch lib_goods:delete_one(GoodsStatus, GoodsInfo, GoodsNum)) of
%%                 {ok, NewStatus, _} ->
%%                 %%    io:format("~s mod_goods:throw_15051_delete_ok[~p]\~n",[misc:time_format(now()), test]),
%%                     if
%%                         GoodsInfo#goods.stlv >= 25 
%%                           orelse GoodsInfo#goods.type =:= 46 ->
%%                             spawn(fun()->db_log_agent:log_goods_handle([PlayerStatus#player.id,
%%                                                                         GoodsInfo#goods.id,
%%                                                                         GoodsInfo#goods.gtid,
%%                                                                         GoodsInfo#goods.num,
%%                                                                         3])end);
%% %%                             spawn(fun()->log:log_throw([PlayerStatus#player.id,PlayerStatus#player.nick,
%% %%                                                         GoodsInfo#goods.id,GoodsInfo#goods.gtid,GoodsInfo#goods.qly,1])end);
%%                         true ->
%%                             skip
%%                     end,
%%                     [1, NewStatus];
%%                 Error ->
%%                     %%io:format("~s mod_goods:throw_15051_delete_ERROR[~p]\~n",[misc:time_format(now()), test]),
%%                     ?ERROR_MSG("mod_goods throw:~p", [Error]),
%%                     [0, GoodsStatus]
%%             end
%%     end,
%%     {ok, BinData} = pt_15:write(15051, [Res, GoodsId, GoodsNum]),
%%     lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%%     {noreply,R_GoodsStatus};
%% 
%% %% 整理背包仓库(15052)
%% %% Location 物品位置4为背包 5为仓库， Cell_num 对于位置的剩余格子数
%% handle_cast({'clean_15052', Location, Cell_num},GoodsStatus) ->
%%     %%io:format("~s clean_15052[~p]\~n",[misc:time_format(now()), Cell_num]),
%%     %% 查询背包物品列表
%%     GoodsList = goods_util:get_goods_list(GoodsStatus#goods_status.uid, Location),
%%     %% 按物品类型ID排序
%%     GoodsList1 = lists:reverse(goods_util:sort(GoodsList, goods_id)),
%%     %% 整理
%%     %%[Num, _] = lists:foldl(fun lib_goods:clean_bag/2, [1, {}], GoodsList1),
%%     [Num,_] = lib_goods:clean_bag(GoodsList1,[], Location),
%%     %% 重新计算
%%     NewGoodsList = goods_util:get_goods_list(GoodsStatus#goods_status.uid, Location),
%%     NullCells =
%%         case (catch lists:seq(Num, Cell_num)) of
%%             {'EXIT', Info} ->
%%                 ?ERROR_MSG("clean bag error : Module=~p, Method=~p, Reason=~p",[goods, clean_15052,Info]),
%%                 [];
%%             _NullCells -> _NullCells
%%         end,
%%     NewGoodsStatus =
%%         case Location of
%%             4 ->
%%                 GoodsStatus#goods_status{  null_cells = NullCells };
%%             _ ->
%%                 GoodsStatus#goods_status{  null_depot_cells = NullCells }
%%         end,
%%     {ok, BinData} = pt_15:write(15052, [NewGoodsList, Location]),
%%     lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData),
%%     %%io:format("~s send_to_sid[~p/~p]\~n",[misc:time_format(now()), GoodsStatus#goods_status.pid_send, BinData]),
%%     {noreply , NewGoodsStatus};
%% 
%% %%定时内存回收
%% handle_cast('garbage_collect',GoodsStatus)->
%%     garbage_collect(self()),
%%     {noreply,GoodsStatus};
%% 
%% %% %%扩充VIP背包
%% %% handle_cast({'extend_vip',Loc,PlayerStatus},GoodsStatus) ->
%% %%     case PlayerStatus#player.clln =:=  108 of
%% %%         false->{noreply, GoodsStatus};
%% %%         true->
%% %%             {_,_,Award} = lib_vip:get_vip_award(bag,PlayerStatus),
%% %%             case Award of
%% %%                 false->{noreply, GoodsStatus};
%% %%                 true->
%% %%                      case (catch lib_goods:extend(PlayerStatus, 0, Loc)) of
%% %%                         {ok, NewPlayerStatus, NullCells} ->
%% %%                             NewGoodsStatus = GoodsStatus#goods_status{null_cells = NullCells},
%% %%                              {ok, BinData} = pt_15:write(15022, [Loc, 1, NewPlayerStatus#player.gold, NewPlayerStatus#player.clln]),
%% %%                                 lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %%                             {noreply, NewGoodsStatus};
%% %%                         {ok, _NewPlayerStatus} ->
%% %%                             {noreply,GoodsStatus};
%% %%                         Error ->
%% %%                             ?ERROR_MSG("mod_goods extend_bag_vip:~p", [Error]),
%% %%                                 {noreply, GoodsStatus}
%% %%                          end
%% %%             end
%% %%     end;
%% 
%% 
%% %%停止进程
%% handle_cast({stop, _Reason}, GoodsStatus) ->
%%     {stop, normal, GoodsStatus};
%% 
%% handle_cast(_R , GoodsStatus) ->
%%     {noreply, GoodsStatus}.
%% 
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_call/3
%% %% Description: Handling call messages
%% %% Returns: {reply, Reply, State}          |
%% %%          {reply, Reply, State, Timeout} |
%% %%          {noreply, State}               |
%% %%          {noreply, State, Timeout}      |
%% %%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
handle_call({'STATUS'} , _From, GoodsStatus) ->
    {reply, GoodsStatus, GoodsStatus};
 
%%设置物品信息
handle_call({'SET_STATUS', NewGoodsStatus}, _From, _GoodsStatus) ->
     {reply, ok, NewGoodsStatus};
%% 
%% %%获取物品详细信息 只获取在线物品信息
%% handle_call({'info',GoodsId},_From,GoodsStatus) ->
%%     GoodsInfo = goods_util:get_goods(GoodsId),
%%     case is_record(GoodsInfo,goods) of
%%         true ->
%%             case goods_util:has_attribute(GoodsInfo) of
%%                 true -> AttributeList = goods_util:get_goods_attribute_list(GoodsStatus#goods_status.uid, GoodsId);
%%                 false -> AttributeList = []
%%             end,
%%             SuitNum = goods_util:get_suit_num(GoodsStatus#goods_status.equip_suit, GoodsInfo#goods.stid),
%%             {reply, [GoodsInfo, SuitNum, AttributeList], GoodsStatus};
%%         _Error ->
%%             {reply, [{}, 0, []], GoodsStatus}
%%     end;
%% 
%% %%获取物品详细信息 
%% handle_call({'info', GoodsId, Location}, _From, GoodsStatus) ->
%%     case Location =:= 5 of
%%         true -> GoodsInfo = goods_util:get_goods_by_id(GoodsId);
%%         false -> GoodsInfo = goods_util:get_goods(GoodsId)
%%     end,
%%     case is_record(GoodsInfo, goods) of
%%         true when GoodsInfo#goods.uid == GoodsStatus#goods_status.uid ->
%%             case goods_util:has_attribute(GoodsInfo) of
%%                 true -> AttributeList = goods_util:get_goods_attribute_list(GoodsStatus#goods_status.uid, GoodsId);
%%                 false -> AttributeList = []
%%             end,
%%             SuitNum = goods_util:get_suit_num(GoodsStatus#goods_status.equip_suit, GoodsInfo#goods.stid),
%%             {reply, [GoodsInfo, SuitNum, AttributeList], GoodsStatus};
%%         Error ->
%%             ?ERROR_MSG("mod_goods info:~p", [[GoodsId,Error]]),
%%             {reply, [{}, 0, []], GoodsStatus}
%%     end;
%% 
%% %% 查看玩家背包是否存在指定ID物品
%% %% PlayerId 玩家ID
%% %% GoodsTypeId 物品类型ID
%% handle_call({'goods_find', PlayerId, GoodsTypeId}, _From, GoodsStatus) ->
%%     Reply = lib_goods:goods_find(PlayerId, GoodsTypeId),
%%     {reply, Reply, GoodsStatus};
%% 
%% %%获取背包里可使用的气血包ID，为[]表示没有
%% handle_call({'hp_pack_goods_find', PlayerId}, _From, GoodsStatus) ->
%%     Reply = lib_goods:hpPack_goods_find(PlayerId),
%%     {reply, Reply, GoodsStatus};
%% 
%% %%集结号个数查询，返回{小集结号个数，大集结号个数}
%% handle_call({'goods_count_chat', PlayerId}, _From, GoodsStatus) ->
%%     LChatCount = goods_util:get_goods_num(PlayerId, 360101, 4),
%%     BChatCount = goods_util:get_goods_num(PlayerId, 360201, 4),
%%     {reply, [LChatCount, BChatCount], GoodsStatus};
%% 
%% %%删除玩家的ets_goods表的所有数据
%% handle_call({'delete_goods_ets', PlayerId}, _From, GoodsStatus)->
%%     Pattern1 = #goods{uid = PlayerId, _='_'},
%% %%     ets:match_delete(?ETS_GOODS_ONLINE, Pattern1),
%%     Pattern2 = #goods_attribute{ uid = PlayerId, _='_'},
%% %%     ets:match_delete(?ETS_GOODS_ATTRIBUTE, Pattern2),
%%     Pattern3 = #goods_buff{uid = PlayerId, _='_'},
%% %%     ets:match_delete(?ETS_GOODS_BUFF,Pattern3),
%%     Pattern4 = #ets_goods_cd{uid = PlayerId, _='_'},
%% %%     ets:match_delete(?ETS_GOODS_CD, Pattern4),
%%     {reply, ok, GoodsStatus};
%% 
%% %% 获取玩家物品列表信息
%% handle_call({'list', PlayerStatus, Location}, _From, GoodsStatus) ->
%%     case Location > 0 of
%%         %% 装备
%%         true when Location == 1 ->
%%             NewLocation = Location,
%%             CellNum = 12,
%%             EquipList = goods_util:get_equip_list(PlayerStatus#player.id, 10, NewLocation),
%%             List = EquipList;
%%         true ->
%%             NewLocation = Location,
%%             case Location =:= 5 of
%%                 true -> CellNum = PlayerStatus#player.dpn;  %% 仓库
%%                 false -> CellNum = PlayerStatus#player.clln
%%             end,
%%             List = goods_util:get_goods_list(PlayerStatus#player.id, NewLocation);
%%         false ->
%%             NewLocation = 0,
%%             CellNum = 0,
%%             List =[]
%%     end,
%%     {reply, [NewLocation, CellNum, List], GoodsStatus};
%% 
%% %% 精炼装备
%% handle_call({'refine_equip', PlayerStatus, GoodsId, AutoBuy}, _From, GoodsStatus) ->
%%     GoodsInfo = goods_util:get_goods(GoodsId),
%%     case is_record(GoodsInfo, goods) of
%%         true ->
%%             BRecord = true,
%%             MaxQly = data_stren:get_refine_max(),
%%             Qly = GoodsInfo#goods.qly;
%%         _ ->
%%             BRecord = false,
%%             MaxQly = 0,
%%             Qly = 0
%%     end,
%% %%     io:format("~s GoodsInfo#goods.qly ___________  [~p]\n",[misc:time_format(now()), Qly]),
%%     [Reply, NewGoodsStatus] =
%%         if
%%             BRecord =:= false ->
%%                 %% 失败，物品不存在
%%                 [[PlayerStatus, 2, 0], GoodsStatus];
%%             GoodsInfo#goods.uid =/= PlayerStatus#player.id ->
%%                 %% 失败，物品不属于你所有
%%                 [[PlayerStatus, 3, 0], GoodsStatus];
%%             GoodsInfo#goods.type =/= 10 ->
%%                 %% 失败，物品类型不正确
%%                 [[PlayerStatus, 5, 0], GoodsStatus];
%%             GoodsInfo#goods.stid =< 0 ->
%%                 %% 失败，非套装装备不能精炼
%%                 [[PlayerStatus, 10, 0], GoodsStatus];
%%             Qly >= MaxQly -> %% ((GoodsInfo#goods.lv + 20) div 20) * 20 - 1  ->
%%                 %% 失败，精炼已达该品质上限
%%                 [[PlayerStatus, 6, 0], GoodsStatus];            
%% %%             Stlv =:= 70 ->
%% %%                 %% 失败，强化已达上限
%% %%                 [[PlayerStatus, 8, 0], GoodsStatus];
%%             true ->
%% %%                 CostCoin = data_stren:get_refine_cost(GoodsInfo#goods.stid, GoodsInfo#goods.qly),
%% %%                 case goods_util:is_enough_money(PlayerStatus, CostCoin, coin) of
%% %%                     true ->
%%                         case lib_goods:check_refine_material(PlayerStatus#player.id, GoodsInfo, Qly + 1, AutoBuy) of
%%                             error ->
%%                                 %% 失败，配置数据错误
%%                                 [[PlayerStatus, 0, 0], GoodsStatus];
%%                             not_enough ->
%%                                 %% 材料不够
%%                                 [[PlayerStatus, 9, 0], GoodsStatus];
%%                             {MaterialList, GoldCost} ->
%%                                 %%                         lib_task:event(strengthen, null, PlayerStatus),
%%                                 %%                         lib_task:event(streng_lv, NewGoodsInfo#goods.stlv, PlayerStatus),
%%                                 if GoldCost > 0 ->
%%                                        case goods_util:is_enough_money(PlayerStatus,GoldCost,gold) of
%%                                            true ->
%%                                                BMoney = 1;
%%                                            _ ->
%%                                                BMoney = 0
%%                                        end;
%%                                    true ->
%%                                        BMoney = 1
%%                                 end,
%%                                 case BMoney of
%%                                     1 ->
%%                                         case lib_goods:delete_compose_material(MaterialList, GoodsStatus) of
%%                                             error ->
%%                                                 %% 扣除材料失败
%%                                                 [[PlayerStatus, 0, 0], GoodsStatus];
%%                                             GoodsStatus1 ->
%%                                                 if GoldCost > 0 ->
%%                                                        NewPlayerStatus = lib_goods:cost_money(PlayerStatus, GoldCost, gold, 1557);
%%                                                    true ->
%%                                                        NewPlayerStatus = PlayerStatus
%%                                                 end,
%%                                                 lib_goods:equip_refine(GoodsInfo),
%%                                                 case GoodsInfo#goods.loc of
%%                                                     1 ->  %%精炼人物身上的装备要刷新属性
%%                                                         Effect = goods_util:get_equip_attribute(NewPlayerStatus#player.id), %% GoodsStatus#goods_status.equip_suit),
%%                                                         NewPlayerStatus1 = NewPlayerStatus#player{other=NewPlayerStatus#player.other#player_other{equip_attribute = Effect }};
%%                                                     _ ->
%%                                                         NewPlayerStatus1 = NewPlayerStatus
%%                                                 end,
%%                                                 [[NewPlayerStatus1, 1, Qly + 1], GoodsStatus1]
%%                                         end;
%%                                     _ ->
%%                                         %%元宝不够
%%                                         [[PlayerStatus, 7, 0], GoodsStatus]
%%                                 end;
%%                             _ ->
%%                                 [[PlayerStatus, 0, 0], GoodsStatus]
%%                         end
%% %%                     _ ->
%% %%                         %%铜币不够
%% %%                         [[PlayerStatus, 7, 0], GoodsStatus]
%% %%                 end
%%         end,
%%     {reply, Reply, NewGoodsStatus};
%% 
%% %% 强化装备
%% handle_call({'strengthen', PlayerStatus, GoodsId, StrStoneType}, _From, GoodsStatus) ->
%%     GoodsInfo = goods_util:get_goods(GoodsId),
%%     case is_record(GoodsInfo, goods) of
%%         true ->
%%             BRecord = true,
%%             MaxStLv = data_stren:get_max_stlv(GoodsInfo#goods.gtid, GoodsInfo#goods.stid),
%%             Stlv = GoodsInfo#goods.stlv;
%%         _ ->
%%             BRecord = false,
%%             MaxStLv = 0,
%%             Stlv = 0
%%     end,
%% %%     io:format("~s StrStoneType ___________  [~p]\n",[misc:time_format(now()), StrStoneType]),
%%     [Reply, NewGoodsStatus] =
%%         if
%%             BRecord =:= false ->
%%                 %% 失败，物品不存在
%%                 [[PlayerStatus, 2, 0], GoodsStatus];
%%             GoodsInfo#goods.uid =/= PlayerStatus#player.id ->
%%                 %% 失败，物品不属于你所有
%%                 [[PlayerStatus, 3, 0], GoodsStatus];
%%             GoodsInfo#goods.type =/= 10 ->
%%                 %% 失败，物品类型不正确
%%                 [[PlayerStatus, 5, 0], GoodsStatus];
%% %%             Stlv >=  PlayerStatus#player.lv - 1 ->
%% %%                 %% 失败，装备等级不能超过人物等级
%% %%                 [[PlayerStatus, 10, 0], GoodsStatus];
%%             Stlv >= MaxStLv -> %% ((GoodsInfo#goods.lv + 20) div 20) * 20 - 1  ->
%%                 %% 失败，强化已达该品质上限
%%                 [[PlayerStatus, 6, 0], GoodsStatus];            
%% %%             Stlv =:= 70 ->
%% %%                 %% 失败，强化已达上限
%% %%                 [[PlayerStatus, 8, 0], GoodsStatus];
%%             true ->
%%                 case data_stren:get_stren_cost(GoodsInfo#goods.stype, GoodsInfo#goods.stid, Stlv + 1) of
%%                     Cost when is_integer(Cost) ->
%%                         %%                 ?DEBUG("pp_goods/handle1506222222222222222 ~p ~n",[{GoodsInfo#goods.gtid, GoodsInfo#goods.lv}]),
%%                         if
%%                             Cost > PlayerStatus#player.coin ->
%%                                 %% 失败，玩家铜钱不足
%%                                 [[PlayerStatus, 7, 0], GoodsStatus];
%%                             true ->
%%                                 %%io:format("~s ___________________________get_stren_info[~p]\n",[misc:time_format(now()), StrenAttList]),
%%                                 StrStoneTypeInfo = goods_util:get_goods_type(StrStoneType),
%%                                 case is_record(StrStoneTypeInfo, ets_base_goods) of
%%                                     true ->
%%                                         case StrStoneTypeInfo#ets_base_goods.type of
%%                                             47 ->
%%                                                 StoneNum = goods_util:get_goods_num(PlayerStatus#player.id, StrStoneType, 4),
%%                                                 if StoneNum > 0 ->
%%                                                        GoodsStatus1 = lib_goods:pay_essence([{StrStoneType, 1}], GoodsStatus),
%%                                                        BAddRatio = data_stren:get_str_ratio_stone(StrStoneTypeInfo#ets_base_goods.stype);
%%                                                    true ->
%%                                                        GoodsStatus1 = GoodsStatus,
%%                                                        BAddRatio = 0
%%                                                 end;
%%                                             _ ->
%%                                                 GoodsStatus1 = GoodsStatus,
%%                                                 BAddRatio = 0
%%                                         end;
%%                                     _ ->
%%                                         GoodsStatus1 = GoodsStatus,
%%                                         BAddRatio = 0
%%                                 end, 
%%                                 EquipRatio = data_stren:get_equip_str_ratio(GoodsInfo#goods.stlv),
%%                                 AllRatio = EquipRatio + BAddRatio,
%%                                 RandNum = util:rand(1, 10000),
%%                                 NewPlayerStatus = lib_goods:cost_money(PlayerStatus, Cost, coin, 1561),
%%                                 if RandNum =< AllRatio * 100 ->  %%强化成功
%%                                        NewGoodsInfo = GoodsInfo#goods{stlv = Stlv + 1}, %%atbt = StrenAttList,
%% %%                                        ets:insert(?ETS_GOODS_ONLINE, NewGoodsInfo),
%%                                        db_agent:update_goods_stren_info(NewGoodsInfo#goods.id, util:term_to_string([]), Stlv + 1),
%%                                        lib_task:event(strengthen, null, PlayerStatus),
%%                                        lib_task:event(streng_lv, NewGoodsInfo#goods.stlv, PlayerStatus),
%%                                        Effect = goods_util:get_equip_attribute(NewPlayerStatus#player.id), %% GoodsStatus#goods_status.equip_suit),
%%                                        NewPlayerStatus_1 = NewPlayerStatus#player{other=NewPlayerStatus#player.other#player_other{equip_attribute = Effect }},
%%                                        if
%%                                            NewGoodsInfo#goods.stlv >= 9 ->
%%                                                spawn(fun()-> lib_broadcast:broadcast_info(strengthen, [PlayerStatus#player.id,PlayerStatus#player.nick,NewGoodsInfo]) end);
%%                                            true ->
%%                                                ok
%%                                        end,
%%                                        [[NewPlayerStatus_1, 1, Stlv + 1], GoodsStatus1];
%%                                    true ->
%%                                        [[NewPlayerStatus, 8, Stlv], GoodsStatus1]
%%                                 end
%%                         end;
%%                     _ ->  %%配置或传入数据异常
%%                         [[PlayerStatus, 0, 0], GoodsStatus]
%%                 end
%%         end,
%%     {reply, Reply, NewGoodsStatus};
%% 
%% %%物品合成(非装备) RollerId:合成卷轴; Flag:是否使用元宝, 0使用 , 1不使用
%% handle_call({'compose_stuff', PlayerStatus, RollerId, Flag}, _From, GoodsStatus) ->
%%     
%%     %%验证五行珠背包满了没
%%     case goods_util:get_goods(RollerId) of
%%         RollerInfo when is_record(RollerInfo, goods) ->
%%             IsExist = true ,
%%             case RollerInfo#goods.type =:= 44 andalso RollerInfo#goods.stype =:= 1 of
%%                 true ->
%%                     IsBeadFull = lib_bead:check_storage(PlayerStatus#player.id) ;
%%                 false ->
%%                     IsBeadFull = false 
%%             end ;
%%         _ ->
%%             RollerInfo = [] ,
%%             IsExist = false ,
%%             IsBeadFull = false 
%%     end ,
%%     
%%     
%%     {Reply, NewGoodsId, NewGoodsType, NewGoodsStatus1, NewPlayerStatus1} =
%%         if
%%             IsExist =:= false ->
%%                 %% 失败，物品不存在
%%                 {2, 0,0, GoodsStatus, PlayerStatus};
%%             RollerInfo#goods.uid =/= PlayerStatus#player.id ->
%%                 %% 失败，物品不属于你所有
%%                 {3, 0,0, GoodsStatus, PlayerStatus};
%%             IsBeadFull =:= true ->
%%                 {9, 0,0, GoodsStatus, PlayerStatus};
%%             true ->
%%                 case Flag of
%%                     0 ->
%%                         case lib_vip:check_equ_com(RollerInfo#goods.stype,PlayerStatus#player.viplv) of
%% %%                         case true of
%%                             true ->
%%                                 case lib_goods:check_compose_material_vip(PlayerStatus#player.id, RollerInfo#goods.gtid) of
%%                                     error ->
%%                                         %% 失败，合成组合有误
%%                                         {4, 0,0, GoodsStatus, PlayerStatus};
%%                                     {0,M} ->
%%                                         %%直接用元宝, 不使用材料
%%                                         case goods_util:is_enough_money(PlayerStatus,M,gold) of
%%                                             true ->
%%                                                 %%开始合成
%%                                                 {NewGoodsStatus, NewStuff, _TargetStuffTypeInfo} = lib_goods:stuff_compose(RollerInfo, GoodsStatus),
%%                                                 %% 成功，且要发送50000协议 更新背包
%%                                                 {ok, BinData1} = pt_50:write(50000, [NewStuff]),
%%                                                 lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%%                                                 Nstatus = lib_goods:cost_money(PlayerStatus, M, gold, 1559),
%%                                                 %%更新角色金钱
%%                                                 lib_player:send_player_attribute2(Nstatus, 1),
%%                                                 if 
%%                                                     NewStuff#goods.qly =:= 4 ->
%%                                                         spawn(fun()-> lib_broadcast:broadcast_info(compose_stuff, [Nstatus#player.id, Nstatus#player.nick, NewStuff]) end);
%%                                                     true ->
%%                                                         ok
%%                                                 end,
%%                                                 %pp_goods:compose_broadcast(Nstatus,NewStuff,TargetStuffTypeInfo),
%%                                                 {1, NewStuff#goods.id, NewStuff#goods.type, NewGoodsStatus, Nstatus};
%%                                             _ ->
%%                                                 %%元宝不足
%%                                                 {6, 0,0, GoodsStatus, PlayerStatus}
%%                                         end;
%%                                     {MaterialList,M} ->
%% %%                                         ?DEBUG("~p",[M]),
%%                                         case goods_util:is_enough_money(PlayerStatus,M,gold) of
%%                                             true ->
%%                                                 case lib_goods:delete_compose_material(MaterialList, GoodsStatus) of
%%                                                     error ->
%%                                                         %% 扣除材料失败
%%                                                         {0, 0,0, GoodsStatus, PlayerStatus};
%%                                                     GoodsStatus1 ->
%%                                                         %% 扣除材料成功，开始合成
%%                                                         {NewGoodsStatus, NewStuff, _TargetStuffTypeInfo} = lib_goods:stuff_compose(RollerInfo, GoodsStatus1),
%%                                                         %% 成功，且要发送50000协议 更新背包
%%                                                         {ok, BinData1} = pt_50:write(50000, [NewStuff]),
%%                                                         lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%%                                                         Nstatus = lib_goods:cost_money(PlayerStatus, M, gold, 1559),
%%                                                         %%更新角色金钱
%%                                                         lib_player:send_player_attribute2(Nstatus, 1),
%%                                                         
%%                                                         if 
%%                                                             NewStuff#goods.qly =:= 4 ->
%%                                                                 spawn(fun()-> lib_broadcast:broadcast_info(compose_stuff, [Nstatus#player.id,Nstatus#player.nick,NewStuff]) end);
%%                                                             true ->
%%                                                                 ok
%%                                                         end,
%%                                                         %pp_goods:compose_broadcast(Nstatus,NewStuff,TargetStuffTypeInfo),
%%                                                         {1, NewStuff#goods.id,NewStuff#goods.type,NewGoodsStatus, Nstatus}
%%                                                 end;
%%                                             _ ->
%%                                                 %%元宝不足
%%                                                 {6, 0,0, GoodsStatus, PlayerStatus}
%%                                         end
%%                                 end;
%%                             _ ->
%%                                 {7, 0,0, GoodsStatus, PlayerStatus}
%%                         end;
%%                     _ ->
%%                         case lib_goods:check_compose_material(PlayerStatus#player.id, RollerInfo#goods.gtid) of
%%                             error ->
%%                                 %% 失败，合成组合有误
%%                                 {4, 0,0, GoodsStatus, PlayerStatus};
%%                             not_enough ->
%%                                 %% 失败，材料不足
%%                                 {5, 0,0, GoodsStatus, PlayerStatus};
%%                             MaterialList ->
%%                                 case lib_goods:delete_compose_material(MaterialList, GoodsStatus) of
%%                                     error ->
%%                                         %% 扣除材料失败
%%                                         {0,0,0, GoodsStatus, PlayerStatus};
%%                                     GoodsStatus1 ->
%%                                         %% 扣除材料成功，开始合成
%%                                         {NewGoodsStatus, NewStuff, _TargetStuffTypeInfo} = lib_goods:stuff_compose(RollerInfo, GoodsStatus1),
%%                                         
%%                                         if 
%%                                             NewStuff#goods.qly =:= 4 ->
%%                                                 spawn(fun()-> lib_broadcast:broadcast_info(compose_stuff, [PlayerStatus#player.id,PlayerStatus#player.nick, NewStuff]) end);
%%                                             true ->
%%                                                 ok
%%                                         end,
%%                                         %pp_goods:compose_broadcast(PlayerStatus,NewStuff,TargetStuffTypeInfo),
%%                                         {ok, BinData1} = pt_50:write(50000, [NewStuff]),
%%                                         lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%%                                         %% 成功，且要发送50000协议
%%                                         {1, NewStuff#goods.id,NewStuff#goods.type,NewGoodsStatus, PlayerStatus}
%%                                 end
%%                         end
%%                 end
%%         end,
%%     {reply, {Reply, NewGoodsId, NewGoodsType, NewPlayerStatus1}, NewGoodsStatus1};
%% 
%% %% 合成装备(EquitId目标装备类型ID, Flag没有用：没有元宝替换材料功能)
%% handle_call({'compose', PlayerStatus, _RollerId, EquitId, _Flag}, _From, GoodsStatus) ->
%% %%     EquitInfo = goods_util:get_goods_type(EquitId),
%% %%     {Reply, NewGoodsStatus1, NewPlayerStatus1} =
%% %%         if
%% %%             is_record(EquitInfo, ets_base_goods) =:= false ->   %%is_record(RollerInfo, goods) =:= false orelse 
%% %%                 %% 失败，物品不存在
%% %%                 {2, GoodsStatus, PlayerStatus};
%% %%             true ->
%% %%                 CostCoin = data_stren:get_equip_compose_cost(EquitInfo#ets_base_goods.stid),
%% %%                 Is_Enough_money = if CostCoin > 0 ->
%% %%                                          goods_util:is_enough_money(PlayerStatus, CostCoin, coin);
%% %%                                      true ->
%% %%                                          true
%% %%                                   end,
%% %%                 if length(GoodsStatus#goods_status.null_cells) =< 0 ->
%% %%                        {9, GoodsStatus, PlayerStatus};  %%背包满
%% %%                    EquitInfo#ets_base_goods.type =/= 10 ->   %%非装备不能合成
%% %%                        {7, GoodsStatus, PlayerStatus};
%% %%                    Is_Enough_money =/= true ->              %%铜币不足
%% %%                        {6, GoodsStatus, PlayerStatus};
%% %%                    true ->
%% %%                         case lib_goods:check_compose_material(PlayerStatus#player.id, 1, EquitId) of
%% %%                             error ->
%% %%                                 %% 失败，合成组合有误
%% %%                                 {4, GoodsStatus, PlayerStatus};
%% %%                             not_enough ->
%% %%                                 %% 失败，材料不足
%% %%                                 {5, GoodsStatus, PlayerStatus};
%% %%                             MaterialList ->
%% %%                                 case lib_goods:delete_compose_material(MaterialList, GoodsStatus) of
%% %%                                     error ->
%% %%                                         %% 扣除材料失败
%% %%                                         {0, GoodsStatus, PlayerStatus};
%% %%                                     GoodsStatus1 ->
%% %%                                         %% 扣除材料成功，开始合成
%% %%                                         if CostCoin > 0 ->
%% %%                                                NewPlayerStatus = lib_goods:cost_money(PlayerStatus, CostCoin, coin, 1559);
%% %%                                            true ->
%% %%                                                NewPlayerStatus = PlayerStatus
%% %%                                         end,
%% %%                                         {NewGoodsStatus, NewEquit, _TargetEquitTypeInfo} = lib_goods:euqit_compose(1, EquitInfo, GoodsStatus1),
%% %%                                         %%io:format("~s euqit_compose_111112222_ok[~p]\n",[misc:time_format(now()), NewEquit]),
%% %%                                         {ok, BinData1} = pt_50:write(50000, [NewEquit]),
%% %%                                         lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%                                         {R, NewG, Ns} =
%% %% %%                                         end,
%% %%                                         spawn(fun()->db_log_agent:log_compose([NewPlayerStatus#player.id,0,0,0,0,MaterialList,NewEquit#goods.gtid,NewEquit#goods.id,0])end),
%% %% 
%% %%                                         %%根据合成物品类别更新通知成就系统
%% %%                                         if EquitInfo#ets_base_goods.type =:= 46 ->
%% %%                                               %通知成就系统 水晶等级列表
%% %%                                               GoodsList = goods_util:get_equip_list(PlayerStatus#player.id, 46),
%% %%                                               achi_crynum_notice(PlayerStatus#player.other#player_other.pid, GoodsList, compose);
%% %%                                            EquitInfo#ets_base_goods.type =:= 10 andalso EquitInfo#ets_base_goods.stype =:= 20 ->
%% %%                                               %通知成就系统 时装类 XXX珠数量 
%% %%                                               GoodsList = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                                               achi_clothes_notice(PlayerStatus#player.other#player_other.pid, GoodsList, compose);
%% %%                                            EquitInfo#ets_base_goods.type =:= 10 andalso EquitInfo#ets_base_goods.stid =/= 0 ->
%% %%                                               %%取套装物品列表
%% %%                                               GoodsList = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                                               achi_suit_notice(PlayerStatus, GoodsList, compose);
%% %%                                            true ->  %%不是关注种类
%% %%                                               skip
%% %%                                         end,
%% %%                                         
%% %%                                         if 
%% %%                                             NewEquit#goods.qly =:= 4 ->
%% %%                                                 spawn(fun()-> lib_broadcast:broadcast_info(compose_stuff, [NewPlayerStatus#player.id, NewPlayerStatus#player.nick,NewEquit]) end);
%% %%                                             true ->
%% %%                                                 ok
%% %%                                         end,
%% %%                                         %pp_goods:compose_broadcast(NewPlayerStatus,NewEquit,TargetEquitTypeInfo),
%% %%                                         lib_task:event(train_equip, [NewEquit#goods.gtid], NewPlayerStatus),%%更新装备合成任务
%% %%                                         {R, NewG, Ns}
%% %%                                 end
%% %%                         end
%% %%                 end
%% %%         end,
%%     {reply, {reply, PlayerStatus}, GoodsStatus};
%% 
%% %%水晶镶嵌以及卸载
%% handle_call({'cyt_handler', PlayerStatus, GoodsId, CytTypeId, Oper, HoleNum}, _From, GoodsStatus) ->
%% %%     case check_cyt_handle(PlayerStatus, GoodsStatus, GoodsId, CytTypeId, Oper, HoleNum) of
%% %%         {fail, Res} ->
%% %%             {reply, [PlayerStatus, Res], GoodsStatus};
%% %%         {ok, GoodsInfo} ->
%% %%             case (catch lib_goods:cyt_handler(PlayerStatus, GoodsStatus, GoodsInfo, CytTypeId, Oper, HoleNum)) of
%% %%                 {Res1, NewPlayerStatus, NewGoodsStatus} ->
%% %%                     %%镶嵌以及卸载都更新成就
%% %%                     if Res1 =:= 1 -> %andalso Oper =:= 1 ->
%% %%                         %%取已装备的物品列表
%% %%                         GoodsList = goods_util:get_goods_list(PlayerStatus#player.id,1),
%% %% %%                         achi_crylv_notice(PlayerStatus#player.other#player_other.pid, GoodsList, cyt_handler);
%% %%                     true -> 
%% %%                         skip
%% %%                     end,
%% %% 
%% %%                     NewPlayer =
%% %%                         case Res1 of
%% %%                             1 ->
%% %%                                 Effect = goods_util:get_equip_attribute(NewPlayerStatus#player.id), %% GoodsStatus#goods_status.equip_suit),
%% %%                                 NewPlayerStatus#player{other=NewPlayerStatus#player.other#player_other{equip_attribute = Effect }};
%% %%                             _ ->
%% %%                                 NewPlayerStatus
%% %%                         end,
%% %%                      {reply, [NewPlayer, Res1], NewGoodsStatus};
%% %%                  Error ->
%% %%                      ?ERROR_MSG("mod_goods hole:~p", [Error]),
%% %%                      {reply, [PlayerStatus, 0], GoodsStatus}
%% %%             end
%% %%     end;
%%     ok;
%% 
%% %% 装备开孔
%% handle_call({'open_hole', PlayerStatus, GoodsId, HoleNum}, _From, GoodsStatus) ->
%%     case check_hole(PlayerStatus, GoodsId, HoleNum) of
%%         {fail, Res} ->
%%             {reply, [PlayerStatus, Res], GoodsStatus};
%%         {ok, GoodsInfo, Cost} ->
%%             case (catch lib_goods:open_hole(PlayerStatus, GoodsStatus, GoodsInfo, HoleNum, Cost)) of
%%                 {ok, NewPlayerStatus, NewStatus} ->
%%                      {reply, [NewPlayerStatus, 1], NewStatus};
%%                  Error ->
%%                      ?ERROR_MSG("mod_goods hole:~p", [Error]),
%%                      {reply, [PlayerStatus, 0], GoodsStatus}
%%             end
%%     end;
%% 
%% %% 宝石合成(水晶及强化石)
%% handle_call({'cyt_compose', PlayerStatus, CytTypeId, Num}, _From, GoodsStatus) ->
%%     %io:format("~s cyt_compose[~p] \n ",[misc:time_format(now()), [CytTypeId, Num]]),
%% %%     case check_cyt_compose(PlayerStatus, GoodsStatus, CytTypeId, Num) of
%% %%         {fail, Res} ->
%% %%             {reply, Res, GoodsStatus};
%% %%         {ok, TgtTypeInfo, CytTypeInfo, GoodsList} ->
%% %%             case (catch lib_goods:cyt_compose(PlayerStatus, GoodsStatus, TgtTypeInfo, Num, CytTypeInfo, GoodsList)) of
%% %%                 {1, PlayerStatus1, NewStatus} ->
%% %%                      %%取物品列表, 不算已装备的(水晶及强化石也不能直接装备)
%% %%                      NewGoodsList = goods_util:get_goods_list(PlayerStatus#player.id,4),
%% %%                      %%水晶物品数量
%% %%                      achi_crynum_notice(PlayerStatus#player.other#player_other.pid, NewGoodsList, compose),
%% %%                      {reply, {1, PlayerStatus1}, NewStatus};
%% %%                  Error ->
%% %%                      ?ERROR_MSG("mod_goods cyt_compose:~p", [Error]),
%% %%                      {reply, 0, GoodsStatus}
%% %%             end
%% %%     end;
%%     ok ;
%% 
%% %% 水晶转换
%% handle_call({'cyt_chg_type', PlayerStatus, SCytTypeId, TgtTypeId, Num }, _From, GoodsStatus) ->
%%     %io:format("~s cyt_compose[~p] \n ",[misc:time_format(now()), [CytTypeId, Num]]),
%%     case check_cyt_chg_type(PlayerStatus, GoodsStatus, SCytTypeId, TgtTypeId, Num) of
%%         {fail, Res} ->
%%             {reply, Res, GoodsStatus};
%%         {ok, TgtTypeInfo, CytTypeInfo, _GoodsList} ->
%%             case (catch lib_goods:cyt_chg_type(PlayerStatus, GoodsStatus, CytTypeInfo, TgtTypeInfo, Num)) of
%%                 {1, NewPlayerStatus, NewStatus} ->
%%                      {reply, {1, NewPlayerStatus}, NewStatus};
%%                  Error ->
%%                      ?ERROR_MSG("mod_goods cyt_compose:~p", [Error]),
%%                      {reply, 0, GoodsStatus}
%%             end
%%     end;
%% 
%% 
%% %%获取指定位置指定的物品数量
%% handle_call({'get_goods_num', PlayerId, GoodsTypeId, Location}, _From, GoodsStatus) ->
%%     Res = goods_util:get_goods_num(PlayerId, GoodsTypeId, Location),
%%     {reply, Res, GoodsStatus};
%% 
%% %%获取不固定位置（背包）的物品数量 （新版不要获取仓库）
%% handle_call({'get_goods_num', PlayerId, GoodsTypeId}, _From, GoodsStatus) ->
%%     Res4 = goods_util:get_goods_num(PlayerId, GoodsTypeId, 4),
%% %%     Res5 = goods_util:get_goods_num(PlayerId, GoodsTypeId, 5),
%%     Res = Res4,
%%     {reply, Res, GoodsStatus};
%% 
%% %%删除指定数量的物品（在背包及仓库里）
%% handle_call({'pay_goods_num', PlayerId, GoodsList}, _From, GoodsStatus) ->
%%     case lib_goods:check_essence(GoodsList, PlayerId) of
%%         enough ->
%%             Res = 1,
%%             GoodsStatus1 = lib_goods:pay_essence(GoodsList, GoodsStatus);
%%         _ ->
%%             Res = 0,
%%             GoodsStatus1 = GoodsStatus
%%     end,
%%     {reply, Res, GoodsStatus1};
%% 
%% %%购买物品
%% handle_call({'pay', PlayerStatus, GoodsTypeId, GoodsNum, ShopType ,ShopSubtype}, _From, GoodsStatus) ->
%% %%     case check_pay(PlayerStatus, GoodsStatus, GoodsTypeId, GoodsNum, ShopType, ShopSubtype) of
%% %%         {fail, Res} ->            
%% %%             %%io:format("~s pay_fail[~p]\n",[misc:time_format(now()), Res]),
%% %%             {reply, [PlayerStatus, Res, []], GoodsStatus};
%% %%         {ok, GoodsTypeInfo, GoodsList, Cost, PriceType, _BagNullCells, GoodsStatus1} ->
%% %%             %%io:format("~s pay_ok[~p]\n",[misc:time_format(now()), GoodsList]),
%% %%             case (catch lib_goods:pay_goods(GoodsStatus1, GoodsTypeInfo, GoodsList, GoodsNum)) of
%% %%                 {ok, NewStatus} ->
%% %%                     %% 根据商店类型扣除对应属性值
%% %%                     case ShopType of
%% %%                         10219 ->
%% %%                             NewPlayerStatus = lib_goods:cost_score(PlayerStatus,Cost);
%% %%                         20207 ->
%% %%                             {ok,NewPlayerStatus}= lib_skyrush:deduct_player_feat(PlayerStatus, Cost);
%% %%                         20800 ->
%% %%                             lib_td:cost_hor_td(PlayerStatus#player.id, Cost),
%% %%                             NewPlayerStatus = PlayerStatus;
%% %%                         20901 ->
%% %%                             NewPlayerStatus = lib_goods:cost_money(PlayerStatus, Cost, PriceType,1520);
%% %%                         _ ->
%% %%                             NewPlayerStatus = lib_goods:cost_money(PlayerStatus, Cost, PriceType,1520)
%% %%                     end,
%% %% %%                     %% 购买某物品有附加物品
%% %% %%                     goods_util:pay_goods_addition(PlayerStatus,GoodsTypeId,GoodsNum, GoodsTypeInfo#ets_base_goods.mxnum),
%% %%                     NewGoodsList = goods_util:get_goods_list(PlayerStatus#player.id, 4),
%% %%                     case ShopType of 
%% %%                         1->
%% %%                             spawn(fun()-> lib_task:event(shopping, {GoodsTypeId}, NewPlayerStatus)end);
%% %%                         _->
%% %%                             spawn(fun()-> lib_task:event(buy_equip, {GoodsTypeId}, NewPlayerStatus)end)
%% %%                     end,
%% %% 
%% %%                     if GoodsTypeInfo#ets_base_goods.type =:= 46 ->
%% %%                           %通知成就系统 水晶等级列表
%% %%                           GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 46),
%% %%                           achi_crynum_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, pay);
%% %%                        GoodsTypeInfo#ets_base_goods.type =:= 10 andalso GoodsTypeInfo#ets_base_goods.stype =:= 20 ->
%% %%                           %通知成就系统 时装类 XXX珠数量 
%% %%                           GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                           achi_clothes_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, pay);
%% %%                        GoodsTypeInfo#ets_base_goods.type =:= 10 andalso GoodsTypeInfo#ets_base_goods.stid =/= 0 ->
%% %%                           %%取套装物品列表
%% %%                           GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                           achi_suit_notice(PlayerStatus, GoodsList1, pay);
%% %%                        true ->  %%不是关注种类
%% %%                           skip
%% %%                     end,
%% %%                     {reply, [NewPlayerStatus, 1, NewGoodsList], NewStatus};
%% %%                 Error ->
%% %%                     ?ERROR_MSG("mod_goods pay:~p", [Error]),
%% %%                     {reply, [PlayerStatus, 0, []], GoodsStatus1}
%% %%             end
%% %%     end;
%%     ok ;
%% 
%% %%竞技场商店购买物品
%% handle_call({'buy_arena_shop', GoodsTypeId}, _From, GoodsStatus) ->
%%     {Reply, NewGoodsStatus} =
%%         case lib_goods:check_arena_shop(GoodsStatus#goods_status.uid, GoodsTypeId) of
%%             error ->
%%                 %% 失败，物品不存在
%%                 {2, GoodsStatus};
%%             not_enough ->
%%                 %% 失败，勋章不足
%%                 {3, GoodsStatus};
%%             MedalList ->
%%                 GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%%                 if is_record(GoodsTypeInfo, ets_base_goods) =:= false ->
%%                        {2, GoodsStatus};
%%                    true ->
%%                        case lib_goods:is_enough_backpack_cell(GoodsStatus, GoodsTypeInfo, 1) of
%%                            %%背包格子不足
%%                            no_enough -> 
%%                                {4, GoodsStatus};
%%                            {enough, _GoodsList, _CellNum} ->
%%                                case lib_goods:pay_essence(MedalList, GoodsStatus) of  %%可以和灵粹扣除共用同一接口
%%                                    error ->
%%                                        %%                                 %%io:format("~s essence_shop[~p] \n ",[misc:time_format(now()), EssenceList]),
%%                                        %% 支付勋章失败
%%                                        {0, GoodsStatus};
%%                                    GoodsStatus1 ->
%%                                        %% 支付勋章成功，开始兑换
%%                                        %%                                 BagNullCells = 
%%                                        %%                                     lists:sublist(GoodsStatus1#goods_status.null_cells, CellNum+1, (length(GoodsStatus1#goods_status.null_cells)-CellNum)),
%%                                        %%                                 GoodsInfo = goods_util:get_arena_goods(GoodsTypeInfo),
%%                                        case (catch lib_goods:add_goods_base(GoodsStatus1, GoodsTypeInfo, 1)) of
%%                                            {ok, NewStatus} ->
%%                                                NewGoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 4),
%%                                                case MedalList of
%%                                                    %% 日志只记录单勋章的兑换(合并到旧版的灵粹兑换日志使用)
%%                                                    [{MedalType, MedalNum}] ->
%%                                                        spawn(fun() -> lib_goods:add_cost_goods_log(GoodsStatus#goods_status.uid, MedalList, 19)end),  %%物品消耗流水日志
%%                                                        spawn(fun() -> lib_goods:add_get_goods_log(GoodsStatus#goods_status.uid,   %%物品产出日志
%%                                                                                                   [{GoodsTypeId, 1}],
%%                                                                                                   0,
%%                                                                                                   19) end),
%%                                                        spawn(fun()->db_log_agent:log_essence_exchange([GoodsStatus#goods_status.uid,
%%                                                                                                        GoodsTypeInfo#ets_base_goods.gtid, 
%%                                                                                                        MedalType, MedalNum])end);
%%                                                    _->
%%                                                        skip
%%                                                end,
%%                                                {ok, BinData1} = pt_50:write(50000, NewGoodsList),                                    
%%                                                lib_send:send_to_sid(GoodsStatus#goods_status.pid_send, BinData1),
%%                                                {1, NewStatus};
%%                                            Error ->
%%                                                %io:format("~s essence_shop[~p] \n ",[misc:time_format(now()), 22222]),
%%                                                ?ERROR_MSG("mod_goods pay:~p", [Error]),
%%                                                {0, GoodsStatus}
%%                                        end
%%                                end
%%                        end
%%                 end
%%         end,
%%     {reply, Reply, NewGoodsStatus};
%% 
%% %% 灵粹兑换
%% handle_call({'essence_shop', PlayerStatus, GoodsTypeId}, _From, GoodsStatus) ->
%%     {Reply, NewGoodsStatus, TotalGoodsList} =
%%         case lib_goods:check_essence_shop(PlayerStatus#player.id, GoodsTypeId, PlayerStatus#player.prstg) of
%%             error ->
%%                 %% 失败，物品不存在
%%                 {2, GoodsStatus, []};
%%             not_enough ->
%%                 %% 失败，灵粹不足
%%                 {3, GoodsStatus, []};
%%             not_enough_prstg ->
%%                 %% 失败，战勋不足
%%                 {5, GoodsStatus, []};
%%             EssenceList ->
%%                 GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%%                 case lib_goods:is_enough_backpack_cell(GoodsStatus, GoodsTypeInfo, 1) of
%%                     %%背包格子不足
%%                     no_enough -> 
%%                         {4, GoodsStatus, []};
%%                     {enough, GoodsList, _CellNum} ->
%%                         case lib_goods:pay_essence(EssenceList, GoodsStatus) of
%%                             error ->
%% %%                                 %%io:format("~s essence_shop[~p] \n ",[misc:time_format(now()), EssenceList]),
%%                                 %% 支付灵粹失败
%%                                 {0, GoodsStatus, []};
%%                             GoodsStatus1 ->
%%                                 %% 支付灵粹成功，开始兑换
%% %%                                 BagNullCells = 
%% %%                                     lists:sublist(GoodsStatus1#goods_status.null_cells, CellNum+1, (length(GoodsStatus1#goods_status.null_cells)-CellNum)),
%%                                 GoodsInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%                                 case (catch lib_goods:add_goods_base(GoodsStatus1, GoodsTypeInfo, 1, GoodsInfo, GoodsList)) of
%%                                     {ok, NewStatus} ->
%%                                         NewGoodsList = goods_util:get_type_goods_list(PlayerStatus#player.id, GoodsTypeId, 4),
%%                                         case EssenceList of
%%                                             %% 日志只记录单灵粹的兑换
%%                                             [{EssType, EssNum}] ->
%%                                                 spawn(fun()->db_log_agent:log_essence_exchange([PlayerStatus#player.id,
%%                                                                                               GoodsInfo#goods.gtid, 
%%                                                                                               EssType, EssNum])end);
%%                                             _->
%%                                                 skip
%%                                         end,
%%                                         {1, NewStatus, NewGoodsList};
%%                                     Error ->
%%                                         %io:format("~s essence_shop[~p] \n ",[misc:time_format(now()), 22222]),
%%                                         ?ERROR_MSG("mod_goods pay:~p", [Error]),
%%                                         {0, GoodsStatus, []}
%%                                 end
%%                         end
%%                 end
%%         end,
%%     {reply, {Reply, TotalGoodsList}, NewGoodsStatus};
%% 
%% 
%% %% 灵粹兑换巨兽
%% handle_call({'essence_giant_shop', PlayerStatus, GiantTypeId, {EssenceType, EssenceNum}}, _From, GoodsStatus) ->
%%     {Reply, NewGoodsStatus, TotalGoodsList} =
%% %%         case lib_goods:check_essence([{EssenceType, EssenceNum}], PlayerStatus#player.id) of
%% %%             not_enough ->
%% %%                 %% 失败，灵粹不足
%% %%                 {3, GoodsStatus, []};
%% %%             _ ->
%% %%                 case lib_giant:handle_creat_new_giant(PlayerStatus, GiantTypeId) of
%% %%                     %% 兑换成功
%% %%                     1 -> 
%%                         case lib_goods:pay_essence([{EssenceType, EssenceNum}], GoodsStatus) of
%%                             error ->
%%                                 %% 支付灵粹失败
%%                                 {0, GoodsStatus, []};
%%                             GoodsStatus1 ->
%%                                 NewGoodsList = goods_util:get_goods_list(PlayerStatus#player.id, 4),
%%                                 spawn(fun()->db_log_agent:log_essence_exchange([PlayerStatus#player.id,
%%                                                                               GiantTypeId,
%%                                                                               EssenceType, 
%%                                                                               EssenceNum])end),
%%                                 {1, GoodsStatus1, NewGoodsList}
%%                         end,
%% %%                     %% 兑换失败
%% %%                     Result ->
%% %%                         {Result, GoodsStatus, []}
%% %%                 end
%% %%         end,
%% %%     io:format("~s essence_giant_shop----[~p]\n",[misc:time_format(now()), Reply]),
%%     {reply, {Reply, TotalGoodsList}, NewGoodsStatus};
%% 
%%   
%% %% ------------------------------------
%% %% 15071 批量购买商店物品
%% %% ------------------------------------
%% handle_call({'buy_multi', PlayerStatus, ShopType, ShopSubType, GoodsList}, _From, GoodsStatus) ->
%%     LenBuyGoodsList = length(GoodsList),
%%     case PlayerStatus#player.coin >= 0 of
%%         true ->        
%%     case LenBuyGoodsList > length(GoodsStatus#goods_status.null_cells) of
%%         false  ->
%%             PriceType = case ShopSubType of
%%                             1 ->
%%                                 coinonly;
%%                             2 ->
%%                                 bcoin
%%                         end,
%%             case multi_check_pay(ok, 1, PlayerStatus, GoodsStatus, GoodsList, ShopType, ShopSubType, []) of
%%                 {fail, Res} ->
%%                     case ShopSubType of 
%%                         1 ->
%%                             Money = PlayerStatus#player.coin;
%%                         2 ->
%%                             Money = PlayerStatus#player.coin
%%                     end,
%%                     {reply, [Res, ShopSubType, Money, PlayerStatus], GoodsStatus};
%%                 {ok, GoodsTypeInfos} ->
%%                     BuyResult = multi_pay_goods(PriceType, PlayerStatus, GoodsStatus, GoodsTypeInfos),
%%                     case BuyResult of
%%                         {'EXIT', _} ->%%执行失败了
%%                             case ShopSubType of 
%%                                 1 ->
%%                                     Money = PlayerStatus#player.coin;
%%                                 2 ->
%%                                     Money = PlayerStatus#player.coin
%%                             end,
%%                             {reply, [0, ShopSubType, Money, PlayerStatus], GoodsStatus};
%%                         _ ->            
%%                             {FinalPlayerStatus, FinalResult, FinalGoodsStatus} = BuyResult,
%%                             case ShopSubType of 
%%                                 1 ->
%%                                     Money = FinalPlayerStatus#player.coin;
%%                                 2 ->
%%                                     Money = FinalPlayerStatus#player.coin
%%                             end,
%%                             case FinalResult of
%%                                 0 ->
%%                                     {reply, [FinalResult, ShopSubType, Money, PlayerStatus], GoodsStatus};
%%                                 1 ->
%%                                     {reply, [FinalResult, ShopSubType, Money, FinalPlayerStatus], FinalGoodsStatus}
%%                             end
%%                     end
%%             end;
%%         true ->
%%             {reply, [4, ShopSubType, 0, PlayerStatus], GoodsStatus}
%%     end;
%%         false ->
%%             {reply, [3, ShopSubType, 0, PlayerStatus], GoodsStatus}
%%     end;
%% 
%% %% ------------------------------------
%% %% 判断需要添加的物品能否被添加
%% %%    1 - 背包有空闲
%% %%    2 - 物品不存在
%% %%  4 - 背包满
%% %% ------------------------------------
%% handle_call({'check_goods_status', PlayerStatus, GoodsList}, _From, GoodsStatus) ->
%%     LenGetGoodsList = length(GoodsList),    
%%     case LenGetGoodsList > length(GoodsStatus#goods_status.null_cells) of
%%         false  ->
%%             case multi_check_get(ok, 1, PlayerStatus, GoodsStatus, GoodsList, []) of
%%                 {fail, Res} ->
%%                     {reply, Res, GoodsStatus} ;
%%                 {ok, _GoodsTypeInfos} ->
%%                     {reply, 1, GoodsStatus} 
%%             end ;
%%         true ->
%%             {reply, 4, GoodsStatus}
%%     end ;
%%     
%% %% ------------------------------------
%% %% 批量获取物品
%% %% ------------------------------------
%% handle_call({'get_multi', PlayerStatus, GoodsList}, _From, GoodsStatus) ->
%%     %%io:format("~s handle_call get_multi[~p/~p] \n ",[misc:time_format(now()), PlayerStatus, GoodsList]),
%% %%     LenGetGoodsList = length(GoodsList),    
%% %%     case LenGetGoodsList > length(GoodsStatus#goods_status.null_cells) of
%% %%         false  ->
%% %%             case catch(multi_check_get(ok, 1, PlayerStatus, GoodsStatus, GoodsList, [])) of
%% %%                 {fail, Res} ->
%% %%                     %%io:format("~s multi_check_get 1[~p] \n ",[misc:time_format(now()), Res]),
%% %%                     {reply, Res, GoodsStatus};
%% %%                 {ok, GoodsTypeInfos} ->
%% %%                     %%io:format("~s handle_call get_multi 1[~p/~p] \n ",[misc:time_format(now()), PlayerStatus, GoodsTypeInfos]),
%% %% %%                     GetResult = multi_get_goods(PlayerStatus, GoodsStatus, GoodsTypeInfos),
%% %%                     %%io:format("~s handle_call get_multi 2[~p/~p] \n ",[misc:time_format(now()), GetResult, GoodsList]),
%% %%                     case multi_get_goods(PlayerStatus, GoodsStatus, GoodsTypeInfos) of
%% %%                         {1, FinalGoodsStatus} ->
%% %%                             BagGoodsList = goods_util:get_goods_list(FinalGoodsStatus#goods_status.uid, 4),
%% %%                             %% 发送50000协议通知客户端更新背包系统数据
%% %%                             {ok, BinData1} = pt_50:write(50000, BagGoodsList),                                    
%% %%                             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%                             lib_goods_use:add_pet_egg_timer(PlayerStatus),
%% %%                             
%% %%                             %%多件物品，不检查了类别了直接调用。
%% %%                             %通知成就系统 水晶等级列表
%% %%                             GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 46),
%% %%                             achi_crynum_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, get_multi),
%% %%                             %通知成就系统 时装类 XXX珠数量 
%% %%                             GoodsList2 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                             achi_clothes_notice(PlayerStatus#player.other#player_other.pid, GoodsList2, get_multi),
%% %%                             %%取套装物品列表
%% %%                             achi_suit_notice(PlayerStatus, GoodsList2, get_multi),
%% %%                             lib_task:event(item, GoodsList, PlayerStatus),            %%获得物品任务事件
%% %%                             {reply, 1, FinalGoodsStatus};
%% %%                         _ ->
%% %%                             {reply, 0, GoodsStatus}
%% %%                     end;
%% %% %%                         {'EXIT', _} ->%%执行失败了
%% %% %%                             {reply, 0, GoodsStatus};
%% %% %%                         _ ->            
%% %% %%                             {FinalResult, FinalGoodsStatus} = GetResult,
%% %% %%                             case FinalResult of
%% %% %%                                 0 ->
%% %% %%                                     {reply, FinalResult, GoodsStatus};
%% %% %%                                 1 ->
%% %% %%                                     BagGoodsList = goods_util:get_goods_list(FinalGoodsStatus#goods_status.uid, 4),
%% %% %%                                     %% 发送50000协议通知客户端更新背包系统数据
%% %% %%                                     {ok, BinData1} = pt_50:write(50000, BagGoodsList),                                    
%% %% %%                                      lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %% %%                                     
%% %% %%                                     lib_goods_use:add_pet_egg_timer(PlayerStatus),
%% %% %%                                     {reply, FinalResult, FinalGoodsStatus}
%% %% %%                             end
%% %% %%                     end;
%% %%                 _ ->
%% %%                     {reply, 0, GoodsStatus}
%% %%             end;
%% %%         true ->
%% %%             {reply, 4, GoodsStatus}
%% %%     end;
%%  ok ;
%% 
%% %%出售物品
%% handle_call({'sell', PlayerStatus, GoodsId, GoodsNum}, _From, GoodsStatus) ->
%%     case check_sell(GoodsStatus, GoodsId, GoodsNum) of
%%         {fail, Res} ->
%%             %%io:format("~s sell_fail[~p]\n",[misc:time_format(now()), Res]),
%%             {reply, [PlayerStatus, Res, 0], GoodsStatus};
%%         {ok, GoodsInfo} ->            
%%             case (catch lib_goods:sell_goods(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum)) of
%%                 {ok, NewPlayerStatus, NewStatus} ->
%% %%                     if
%% %%                         GoodsInfo#goods.type =:= 10 
%% %%                           orelse GoodsInfo#goods.type =:= 46 ->
%%                             spawn(fun()->db_log_agent:log_goods_handle([PlayerStatus#player.id,
%%                                                                         GoodsInfo#goods.id,
%%                                                                         GoodsInfo#goods.gtid,
%%                                                                         GoodsInfo#goods.num,
%%                                                                         2])end),
%% %%                             spawn(fun()->log:log_throw([PlayerStatus#player.id,PlayerStatus#player.nick,
%% %%                                                         GoodsInfo#goods.id,GoodsInfo#goods.gtid,GoodsInfo#goods.qly,1])end);
%% %%                         true ->
%% %%                             skip
%% %%                     end,
%%                     %%io:format("~s sell_ok[~p]\n",[misc:time_format(now()), test]),
%%                     {reply, [NewPlayerStatus, 1, GoodsInfo#goods.gtid], NewStatus};
%%                 Error ->
%%                     %%io:format("~s sell_error[~p]\n",[misc:time_format(now()), test]),
%%                     ?ERROR_MSG("mod_goods sell:~p", [Error]),
%%                     {reply, [PlayerStatus, 0, GoodsInfo#goods.gtid], GoodsStatus}
%%             end
%%     end;
%% 
%% %%回购物品
%% handle_call({'buy_back', PlayerStatus, GoodsId, GoodsNum}, _From, GoodsStatus) ->
%%     if
%%         length(GoodsStatus#goods_status.null_cells) =:= 0 ->
%%             {reply, [7, PlayerStatus, 0, 0], GoodsStatus};
%%         true ->
%%             case (catch lib_goods:buyBackGoods(PlayerStatus, GoodsStatus, GoodsId, GoodsNum)) of
%%                 [Res, NewPlayerStatus, NewStatus, GoodsTypeId, Cell] ->
%%                     %%io:format("~s sell_ok[~p]\n",[misc:time_format(now()), test]),
%%                     {reply, [Res, NewPlayerStatus, GoodsTypeId, Cell], NewStatus};
%%                 Error ->
%%                     %%io:format("~s sell_error[~p]\n",[misc:time_format(now()), test]),
%%                     ?ERROR_MSG("mod_goods sell:~p", [Error]),
%%                     {reply, [0, PlayerStatus, 0, 0], GoodsStatus}
%%             end
%%     end;
%% 
%% %% ------------------------------------
%% %% 15072 批量出售物品
%% %% ------------------------------------
%% %% handle_call({'sell_multi', PlayerStatus, GoodsList}, _From, GoodsStatus) ->
%% %%     case lib_goods:check_goods_diff(GoodsList) of
%% %%         false ->%%没有相同的id
%% %%             {CheckResult,GoodsInfoList} = multi_check_sell(GoodsList,GoodsStatus),
%% %%             case CheckResult of
%% %%                 0 ->
%% %%             {reply, [CheckResult, 1, PlayerStatus#player.coin, PlayerStatus], GoodsStatus};
%% %%                 1 ->
%% %%                     SellResult = mutli_sell_goods(PlayerStatus, GoodsStatus, GoodsInfoList),
%% %%                     case SellResult of
%% %%                         {'EXIT', _} ->%%执行失败了
%% %%                             {reply, [0, 1, PlayerStatus#player.coin, PlayerStatus], GoodsStatus};
%% %%                         _ ->
%% %%                             {FinalResult, FinalPlayerStatus, FinalGoodsStatus} = SellResult,
%% %% %%                            ?DEBUG("handle_call  sell_multi result [~p], newcoin[~p]", [FinalResult, FinalPlayerStatus#player.coin]),
%% %%                             case FinalResult of
%% %%                                 0 ->
%% %%                                     {reply, [FinalResult, 1, PlayerStatus#player.coin, PlayerStatus], GoodsStatus};
%% %%                                 1 ->
%% %%                                     {reply, [FinalResult, 1, FinalPlayerStatus#player.coin, FinalPlayerStatus], FinalGoodsStatus}
%% %%                             end
%% %%                     end
%% %%             end;
%% %%         true ->%%有相同的id
%% %%             {reply, [0, 1, PlayerStatus#player.coin, PlayerStatus], GoodsStatus}
%% %%     end;
%% 
%% %%装备物品
%% handle_call({'equip', PlayerStatus, GoodsId, Cell}, _From, GoodsStatus) ->
%% %%     case check_equip(PlayerStatus, GoodsId, Cell) of
%% %%         {fail, Res} ->
%% %%             {reply, [PlayerStatus, Res, {}, {}, []], GoodsStatus};
%% %%         {ok, GoodsInfo, Location, NewCell} ->
%% %%             case (catch lib_goods:equip_goods(PlayerStatus, GoodsStatus, GoodsInfo, Location, NewCell)) of
%% %%                 {ok, NewPlayerStatus, NewStatus, OldGoodsInfo, Effect2} ->
%% %% %%                  spawn(fun()->lib_task:event(equip, {GoodsInfo#goods.gtid}, PlayerStatus)end),
%% %%                     %%添加时装BUFF
%% %%                     lib_goods_use:equip_fash_buff(NewStatus, GoodsInfo),
%% %%                     %%装备的物品似乎有镶嵌东西
%% %%                     if is_list(GoodsInfo#goods.othdt) ->
%% %%                         %%取已装备的物品列表
%% %%                         GoodsList = goods_util:get_goods_list(PlayerStatus#player.id,1),
%% %%                         achi_crylv_notice(PlayerStatus#player.other#player_other.pid, GoodsList, equip);
%% %%                     true ->
%% %%                         skip
%% %%                     end,
%% %%                     {reply, [NewPlayerStatus, 1, GoodsInfo, OldGoodsInfo, Effect2], NewStatus};
%% %%                  Error ->
%% %%                      ?ERROR_MSG("mod_goods equip:~p", [Error]),
%% %%                      {reply, [PlayerStatus, 0, {}, []], GoodsStatus}
%% %%             end
%% %%     end;
%% ok ;
%% 
%% %%卸下装备
%% handle_call({'unequip', PlayerStatus, GoodsId}, _From, GoodsStatus) ->
%%     case check_unequip(GoodsStatus, GoodsId, 1) of
%%         {fail, Res} ->
%%             {reply, [PlayerStatus, Res, {}], GoodsStatus};
%%         {ok, GoodsInfo} ->
%%             case (catch lib_goods:unequip_goods(PlayerStatus, GoodsStatus, GoodsInfo)) of
%%                 {ok, NewPlayerStatus, NewStatus, NewGoodsInfo} ->
%%                     lib_goods_use:unequip_fash_buff(NewStatus, GoodsInfo),
%%                     {reply, [NewPlayerStatus, 1, NewGoodsInfo], NewStatus};
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods unequip:~p", [Error]),
%%                     {reply, [PlayerStatus, 0, {}], GoodsStatus}
%%             end
%%     end;
%% 
%% %%巨兽装备物品
%% handle_call({'equip_giant', PlayerStatus, GoodsId}, _From, GoodsStatus) ->
%%     case check_equip_giant(PlayerStatus, GoodsId) of    %%判断物品是否符合装备逻辑
%%         {fail, Res} ->                                                    %%不符合
%%             {reply, [Res, PlayerStatus, {}], GoodsStatus};
%%         {ok, GoodsInfo, Location, NewCell} ->
%%             case (catch lib_goods:equip_goods_giant(GoodsStatus, GoodsInfo, Location, NewCell)) of
%%                 {ok, NewStatus, NewGoodsInfo} ->                        %%成功
%%                     {reply, [1, GoodsInfo, NewGoodsInfo], NewStatus};
%%                  Error ->
%%                      ?ERROR_MSG("mod_goods equip_giant:~p", [Error]),
%%                      {reply, [0, PlayerStatus, {}], GoodsStatus}
%%             end;
%%         _ ->                                                            %%未知返回
%%               {reply, [0, PlayerStatus, {}], GoodsStatus}                %%按错误处理
%%     end;
%% 
%% %%巨兽卸下物品, 处理此物品信息
%% handle_call({'unequip_giant', PlayerStatus, GoodsId}, _From, GoodsStatus) ->
%%     case check_unequip_giant(GoodsStatus, GoodsId, 0) of
%%         {fail, Res} ->                                                    %%不符合卸下逻辑
%%             {reply, [Res, PlayerStatus, {}], GoodsStatus};
%%         {ok, GoodsInfo} ->                                                %%符合卸下逻辑, 更新此物品信息
%%             case (catch lib_goods:unequip_goods_giant(GoodsStatus, GoodsInfo)) of
%%                 {ok, NewStatus, NewGoodsInfo} ->                        %%更新成功
%%                      {reply, [1, PlayerStatus, NewGoodsInfo], NewStatus};
%%                  Error ->
%%                      ?ERROR_MSG("mod_goods unequip:~p", [Error]),
%%                      {reply, [0, PlayerStatus, {}], GoodsStatus}        %%更新失败
%%             end;
%%         _ ->                                                            %%未知返回
%%               {reply, [0, PlayerStatus, {}], GoodsStatus}                %%按错误处理
%%     end;
%% 
%% %%使用物品
%% handle_call({'use', PlayerLv, PlayerNick, GoodsId, GoodsNum}, _From, GoodsStatus) ->
%% %%     io:format("handle_call_use[~p/~p] ~n",[GoodsId, GoodsNum]),
%%     case lib_goods_use:check_use(PlayerLv,GoodsStatus, GoodsId, GoodsNum) of
%%         {fail, Res} ->
%% %%             io:format("handle_call_use_fail[~p] ~n",[Res]),
%%             {reply, [Res, [], []], GoodsStatus};
%%         {ok, GoodsInfo} ->
%% %%             io:format("handle_call_use_ok[~p] ~n",[GoodsInfo]),
%%             case lists:member(GoodsInfo#goods.gtid, [450301,450302,450303,450304,450305,450311,450401,450402,450403,450404,450405,450407,450408,450409,450410,450417]) of
%%                 true ->  %%随机礼包只能一次只能使用一个，防止被刷为指定物品
%%                     TrueGoodsNum = 1;
%%                 _ ->
%%                     TrueGoodsNum = GoodsNum
%%             end,
%%             case (catch lib_goods:use_goods(GoodsStatus, GoodsInfo, TrueGoodsNum)) of
%%                 {ok, Result, NewStatus, VtlGoodsList} ->
%%                      %%io:format("handle_call_use_ok[~p/~p] ~n",[Result, GoodsList]),
%%                     GoodsTypeId = GoodsInfo#goods.gtid,
%%                     case lists:member(Result, [1,32,1002,1010,1011]) of
%%                         true ->
%%                             %%　临时处理
%%                             %%spawn(fun()->lib_team:update_team_player_info(NewPlayerStatus)end),
%%                             spawn(fun()->catch(log:log_use([GoodsStatus#goods_status.uid,
%%                                                             PlayerNick,
%%                                                             GoodsId,
%%                                                             GoodsInfo#goods.gtid,
%%                                                             GoodsInfo#goods.type,
%%                                                             GoodsInfo#goods.stype,
%%                                                             TrueGoodsNum
%%                                                            ]))end),
%%                             {reply, [Result, GoodsTypeId, VtlGoodsList], NewStatus};
%% %%                         1000 ->  %%气血包使用
%% %%                             spawn(fun()->lib_task:event(use_goods, {GoodsInfo#goods.gtid}, PlayerStatus)end),
%% %%                              spawn(fun()->catch(log:log_use([PlayerStatus#player.id,
%% %%                                        PlayerStatus#player.nick,
%% %%                                        GoodsId,
%% %%                                        GoodsInfo#goods.gtid,
%% %%                                        GoodsInfo#goods.type,
%% %%                                        GoodsInfo#goods.stype,
%% %%                                        GoodsNum
%% %%                                         ]))end),
%% %%                             {reply, [NewPlayerStatus, Result, GoodsList, VtlGoodsList], NewStatus};
%% %%                         1002 ->  %%幻化珠使用
%% %%                              spawn(fun()->catch(log:log_use([GoodsStatus#goods_status.uid,
%% %%                                        PlayerNick,
%% %%                                        GoodsId,
%% %%                                        GoodsInfo#goods.gtid,
%% %%                                        GoodsInfo#goods.type,
%% %%                                        GoodsInfo#goods.stype,
%% %%                                        TrueGoodsNum
%% %%                                         ]))end),
%% %%                             %%使用幻化珠时通知成就系统时装类更新。
%% %%                             GoodsList11 = goods_util:get_equip_list(GoodsStatus#goods_status.uid, 10),
%% %%                             achi_clothes_notice(GoodsStatus#goods_status.uid, GoodsList11, use),
%% %%                             {reply, [Result, GoodsTypeId, VtlGoodsList], NewStatus};
%% %%                         1003 ->  %%VIP体验卡
%% %%                             spawn(fun()->lib_task:event(use_goods, {GoodsInfo#goods.gtid}, PlayerStatus)end),
%% %%                              spawn(fun()->catch(log:log_use([PlayerStatus#player.id,
%% %%                                        PlayerStatus#player.nick,
%% %%                                        GoodsId,
%% %%                                        GoodsInfo#goods.gtid,
%% %%                                        GoodsInfo#goods.type,
%% %%                                        GoodsInfo#goods.stype,
%% %%                                        GoodsNum
%% %%                                         ]))end),
%% %%                             {reply, [NewPlayerStatus, Result, GoodsList, VtlGoodsList], NewStatus};
%% %%                         1004 ->  %%宠物蛋
%% %%                             spawn(fun()->lib_task:event(use_goods, {GoodsInfo#goods.gtid}, PlayerStatus)end),
%% %%                              spawn(fun()->catch(log:log_use([PlayerStatus#player.id,
%% %%                                        PlayerStatus#player.nick,
%% %%                                        GoodsId,
%% %%                                        GoodsInfo#goods.gtid,
%% %%                                        GoodsInfo#goods.type,
%% %%                                        GoodsInfo#goods.stype,
%% %%                                        GoodsNum
%% %%                                         ]))end),
%% %%                             {reply, [NewPlayerStatus, Result, GoodsList, VtlGoodsList], NewStatus};
%% %%                         1008 ->  %%积分兑换的宠物蛋
%% %%                             spawn(fun()->lib_task:event(use_goods, {GoodsInfo#goods.gtid}, PlayerStatus)end),
%% %%                              spawn(fun()->catch(log:log_use([PlayerStatus#player.id,
%% %%                                        PlayerStatus#player.nick,
%% %%                                        GoodsId,
%% %%                                        GoodsInfo#goods.gtid,
%% %%                                        GoodsInfo#goods.type,
%% %%                                        GoodsInfo#goods.stype,
%% %%                                        GoodsNum
%% %%                                         ]))end),
%% %%                             {reply, [NewPlayerStatus, Result, GoodsList, VtlGoodsList], NewStatus};
%% %%                         2022 ->
%% %%                             spawn(fun()->lib_task:event(use_goods, {GoodsInfo#goods.gtid}, PlayerStatus)end),
%% %%                              spawn(fun()->catch(log:log_use([PlayerStatus#player.id,
%% %%                                        PlayerStatus#player.nick,
%% %%                                        GoodsId,
%% %%                                        GoodsInfo#goods.gtid,
%% %%                                        GoodsInfo#goods.type,
%% %%                                        GoodsInfo#goods.stype,
%% %%                                        GoodsNum
%% %%                                         ]))end),
%% %%                             {reply, [NewPlayerStatus, Result, GoodsList, VtlGoodsList], NewStatus};
%%                         _ ->
%%                             {reply, [Result, GoodsTypeId, VtlGoodsList], NewStatus}
%%                     end;
%%                  Error ->
%%                      %%io:format("handle_call_use_Error[~p] ~n",[test]),
%%                      ?ERROR_MSG("mod_goods use_error:~p", [Error]),
%%                      {reply, [0, 0, []], GoodsStatus}
%%             end
%%     end;
%% 
%% 
%% %%删除多个物品
%% handle_call({'delete_one', GoodsId, GoodsNum}, _From, GoodsStatus) ->
%%     GoodsInfo = goods_util:get_goods(GoodsId),                
%%     if
%%         %% 物品不存在
%%         is_record(GoodsInfo, goods) =:= false ->
%%             {reply, [2, 0], GoodsStatus};
%%         %% 物品数量不正确
%%         GoodsInfo#goods.num < GoodsNum ->
%%             {reply, [3, 0], GoodsStatus};
%%         true ->
%%             case (catch lib_goods:delete_one(GoodsStatus, GoodsInfo, GoodsNum)) of
%%                 {ok, NewStatus, NewNum} ->
%%                      lib_player:refresh_client(GoodsStatus#goods_status.pid_send, 2),
%%                      {reply, [1, NewNum], NewStatus};
%%                  Error ->
%%                      ?ERROR_MSG("mod_goods delete_one:~p", [Error]),
%%                      {reply, [0, 0], GoodsStatus}
%%             end
%%     end;
%% %% 
%% %% %%删除多个同类型物品（穴道使用龙晶）
%% %% handle_call({'delete_more_meridian', PlayerStatus, GoodsTypeId, Num}, _From, GoodsStatus) ->
%% %%     GoodsList = 
%% %%         case goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 4) of
%% %%             [] ->
%% %%                 goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 5);
%% %%             GoodsList4 ->
%% %%                 GoodsList4
%% %%         end,
%% %%     if
%% %%         length(GoodsList) =:= 0 ->
%% %%             {reply, 2, GoodsStatus};    %% 物品不存在        
%% %%         true ->
%% %%             [GoodsInfo|_] = GoodsList,
%% %%                    case (catch lib_goods:delete_one(GoodsStatus, GoodsInfo, Num)) of
%% %%                 {ok, NewStatus, _} ->
%% %%                     if
%% %%                         (GoodsInfo#goods.gtid >= 132002 andalso GoodsInfo#goods.gtid =< 132004) orelse Num >= 5 ->
%% %%                             spawn(fun()->log:log_use([PlayerStatus#player.id,PlayerStatus#player.nick,GoodsInfo#goods.id,GoodsInfo#goods.gtid,GoodsInfo#goods.type,GoodsInfo#goods.stype,Num])end);
%% %%                         true ->
%% %%                             skip
%% %%                     end,
%% %%                     {reply, 1, NewStatus};    %% 成功
%% %%                  Error ->
%% %%                     ?ERROR_MSG("mod_goods delete_more:~p", [Error]),
%% %%                     {reply, 0, GoodsStatus}    %% 失败
%% %%             end
%% %%     end;
%% 
%% %%删除多个同类型物品
%% handle_call({'delete_more', GoodsTypeId, GoodsNum}, _From, GoodsStatus) ->
%%     GoodsList4 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 4),
%% %%     GoodsList5 = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 5),
%%     GoodsList = GoodsList4,
%%     TotalNum = goods_util:get_goods_totalnum(GoodsList),
%%     if
%%         length(GoodsList) =:= 0 ->
%%             {reply, 2, GoodsStatus};    %% 物品不存在        
%%         TotalNum < GoodsNum ->
%%             {reply, 3, GoodsStatus};    %% 物品数量不足
%%         true ->
%%             case (catch lib_goods:delete_more(GoodsStatus, GoodsList4, GoodsNum)) of
%%                 {ok, NewStatus} ->
%%                      lib_player:refresh_client(GoodsStatus#goods_status.pid_send, 2),
%%                      {reply, 1, NewStatus};    %% 成功
%%                  Error ->
%%                      ?ERROR_MSG("mod_goods delete_more:~p", [Error]),
%%                      {reply, 0, GoodsStatus}    %% 失败
%%             end
%%     end;
%% 
%% %%删除多个同类型非绑定的物品
%% handle_call({'delete_more_unbind', GoodsTypeId, GoodsNum}, _From, GoodsStatus) ->
%%     GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid,GoodsTypeId,0, 4),
%%     TotalNum = goods_util:get_goods_totalnum(GoodsList),
%%     if
%%         length(GoodsList) =:= 0 ->
%%             {reply, 2, GoodsStatus};    %% 物品不存在        
%%         TotalNum < GoodsNum ->
%%             {reply, 3, GoodsStatus};    %% 物品数量不足
%%         true ->
%%             case (catch lib_goods:delete_more(GoodsStatus, GoodsList, GoodsNum)) of
%%                 {ok, NewStatus} ->
%%                     lib_player:refresh_client(GoodsStatus#goods_status.pid_send, 2),
%%                     {reply, 1, NewStatus};    %% 成功
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods delete_more:~p", [Error]),
%%                     {reply, 0, GoodsStatus}    %% 失败
%%             end
%%     end;
%% 
%% %%删除任务物品 注意！任务物品不改变物品状态 GoodsStatus
%% handle_call({'delete_task_goods', GoodsTypeId, GoodsNum}, _From, GoodsStatus) ->
%%     
%%     %%io:format("handle_call delete_task_goods:[~p/~p]\n",[GoodsTypeId, GoodsNum]),
%%     GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId),
%%     TotalNum = goods_util:get_goods_totalnum(GoodsList),
%%     if
%%         %% 物品不存在
%%         length(GoodsList) =:= 0 ->
%%             {reply, 2, GoodsStatus};
%%         %% 物品数量不足
%%         TotalNum < GoodsNum ->
%%             {reply, 3, GoodsStatus};
%%         true ->
%%             case (catch lib_goods:delete_task_more(GoodsStatus, GoodsList, GoodsNum)) of
%%                 {ok} ->
%%                     {reply, 1, GoodsStatus};
%%                  Error ->
%%                     ?ERROR_MSG("mod_goods delete_more:~p", [Error]),
%%                     {reply, 0, GoodsStatus}
%%             end
%%     end;
%% 
%% %%丢弃物品
%% handle_call({'throw', PlayerStatus,GoodsId, GoodsNum}, _From, GoodsStatus) ->
%%     case check_throw(PlayerStatus,GoodsStatus, GoodsId, GoodsNum) of
%%         {fail, Res} ->
%%             {reply, Res, GoodsStatus};
%%         {ok, GoodsInfo} ->
%%             case (catch lib_goods:delete_one(GoodsStatus, GoodsInfo, GoodsNum)) of
%%                 {ok, NewStatus, _} ->
%%                     {reply, 1, NewStatus};
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods throw:~p", [Error]),
%%                     {reply, 0, GoodsStatus}
%%             end
%%     end;
%% 
%% %%丢弃同类型物品
%% %% GoodsTypeList = [GoodsTypeId1, GoodsTypeId2, ...]
%% handle_call({'throw_more', GoodsTypeList}, _From, GoodsStatus) ->
%%     case (catch goods_util:list_handle(fun lib_goods:delete_type_goods/2, GoodsStatus, GoodsTypeList)) of
%%         {ok, NewStatus} ->
%%             lib_player:refresh_client(NewStatus#goods_status.pid_send, 2),
%%             {reply, ok, NewStatus};
%%          {Error, Status} ->
%%              ?ERROR_MSG("mod_goods throw_more:~p", [Error]),
%%              {reply, Error, Status}
%%     end;
%% 
%% %%扩充背包仓库
%% handle_call({'extend', Loc, ExtendCellNum, PlayerStatus}, _From, GoodsStatus) ->
%%     case check_extend(PlayerStatus, Loc, ExtendCellNum) of
%%         {fail, NewPlayerStatus,Res} ->
%%             {reply, [NewPlayerStatus, Res, 0], GoodsStatus};
%%         {ok, NewPlayerStatus1, Cost} ->
%%             case (catch lib_goods:extend(NewPlayerStatus1, Cost, Loc, ExtendCellNum)) of
%%                 {ok, NewPlayerStatus2, NullCells, NewNum} ->
%%                     NewGoodsStatus = 
%%                         case Loc of
%%                             4 -> GoodsStatus#goods_status{null_cells = NullCells};
%%                             _ -> GoodsStatus#goods_status{null_depot_cells = NullCells}
%%                         end,
%%                     {reply, [NewPlayerStatus2, 1, NewNum], NewGoodsStatus};
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods extend_bag:~p", [Error]),
%%                     {reply, [NewPlayerStatus1, 0, 0], GoodsStatus}
%%             end
%%     end;
%% 
%%             
%% %%拆分物品
%% handle_call({'destruct',PlayerStatus,GoodsId,Num,Pos},_From,GoodsStatus) ->
%%     case check_destruct(GoodsStatus,GoodsId,Num,Pos) of
%%         {fail,Res} ->
%%             {reply,[PlayerStatus,Res],GoodsStatus};
%%         {ok,GoodsInfo} ->
%%             case (catch lib_goods:destruct(GoodsStatus,GoodsInfo,Num,Pos)) of
%%                 {ok,NewGoodsStatus} ->
%%                     {reply,[PlayerStatus,1],NewGoodsStatus};
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods destruct goods :~p",[Error]),
%%                     {reply,[PlayerStatus,0],GoodsStatus}
%%             end
%%     end;
%% 
%% 
%% %%%%%%%
%% %% 整理背包
%% %% handle_call({'clean', PlayerStatus}, _From, GoodsStatus) ->
%% %%     %% 查询背包物品列表
%% %%     GoodsList = goods_util:get_goods_list(GoodsStatus#goods_status.uid, 4),
%% %%     %% 按物品类型ID排序
%% %%     GoodsList1 = goods_util:sort(GoodsList, goods_id),
%% %%     %% 整理
%% %%     [Num, _] = lists:foldl(fun lib_goods:clean_bag/2, [1, {}], GoodsList1),
%% %%     %% 重新计算
%% %%     NewGoodsList = goods_util:get_goods_list(GoodsStatus#goods_status.uid, 4),
%% %%     %% ps
%% %%     NullCells = lists:seq(Num, PlayerStatus#player.clln),
%% %%     NewGoodsStatus = GoodsStatus#goods_status{  null_cells = NullCells },
%% %%    {reply, NewGoodsList, NewGoodsStatus};
%% 
%% 
%% 
%% %% 赠送物品
%% %handle_call({'give_goods', _PlayerStatus, GoodsTypeId, GoodsNum}, _From, GoodsStatus) ->
%% handle_call({'give_goods', PlayerStatus, GoodsTypeId, GoodsNum}, _From, GoodsStatus) ->
%% %%     case (catch lib_goods:give_goods({GoodsTypeId, GoodsNum}, GoodsStatus)) of
%% %%         {ok, NewStatus} ->
%% %%             %%io:format("give ok..~n"),
%% %%             %% 发送50000协议通知客户端更新背包系统数据
%% %%             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 0, 4),
%% %%             {ok, BinData1} = pt_50:write(50000, GoodsList),
%% %%             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%             lib_goods_use:add_pet_egg_timer(PlayerStatus),
%% %% 
%% %%             GiveGoods = goods_util:get_goods_type(GoodsTypeId),
%% %%             if GiveGoods#ets_base_goods.type =:= 46 ->
%% %%                   %通知成就系统 水晶等级列表
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 46),
%% %%                   achi_crynum_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, give_goods);
%% %%                GiveGoods#ets_base_goods.type =:= 10 andalso GiveGoods#ets_base_goods.stype =:= 20 ->
%% %%                   %通知成就系统 时装类 XXX珠数量 
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                   achi_clothes_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, give_goods);
%% %%                GiveGoods#ets_base_goods.type =:= 10 andalso GiveGoods#ets_base_goods.stid =/= 0 ->
%% %%                   %%取套装物品列表
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                   achi_suit_notice(PlayerStatus, GoodsList1, give_goods);
%% %%                true ->  %%不是关注种类变化
%% %%                   skip
%% %%             end,
%% %% 
%% %%             %lib_player:refresh_client(NewStatus#goods_status.pid_send, 2),
%% %%             {reply, ok, NewStatus};
%% %%         {fail, Error, Status} ->
%% %%             %%io:format("give failed..~n"),
%% %%             {reply, Error, Status}
%% %%     end;
%%  ok;
%% %% 进程间调用添加物品，可设置绑定状态 0未绑定1暂不用2绑定
%% handle_call({'give_goods',PlayerStatus,GoodsTypeId,GoodsNum,Bind},_From,GoodsStatus) ->
%% %%     case (catch lib_goods:give_goods({GoodsTypeId, GoodsNum ,Bind}, GoodsStatus)) of
%% %%         {ok, NewStatus} ->
%% %%             %%io:format("give ok..~n"),
%% %%             %lib_player:refresh_client(NewStatus#goods_status.pid_send, 2),
%% %%             %% 发送50000协议通知客户端更新背包系统数据
%% %%             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 0, 4),
%% %%             {ok, BinData1} = pt_50:write(50000, GoodsList),
%% %%             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%             lib_goods_use:add_pet_egg_timer(PlayerStatus),
%% %% 
%% %%             GiveGoods = goods_util:get_goods_type(GoodsTypeId),
%% %%             if GiveGoods#ets_base_goods.type =:= 46 ->
%% %%                   %通知成就系统 水晶等级列表
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 46),
%% %%                   achi_crynum_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, give_goods);
%% %%                GiveGoods#ets_base_goods.type =:= 10 andalso GiveGoods#ets_base_goods.stype =:= 20 ->
%% %%                   %通知成就系统 时装类 XXX珠数量 
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                   achi_clothes_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, give_goods);
%% %%                GiveGoods#ets_base_goods.type =:= 10 andalso GiveGoods#ets_base_goods.stid =/= 0 ->
%% %%                   %%取套装物品列表
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                   achi_suit_notice(PlayerStatus, GoodsList1, give_goods);
%% %%                true ->  %%不是关注种类
%% %%                   skip
%% %%             end,
%% %%             {reply, ok, NewStatus};
%% %%         {fail, Error, Status} ->
%% %%             %%io:format("give failed..~n"),
%% %%             {reply, Error, Status}
%% %%     end;
%%  ok ;
%% %% %%仅提供给邮件收取附件使用，若其他模块调用，请先联系xiaomai
%% %% handle_call({'give_goods_exsit', GoodsId, PlayerId}, _From, GoodsStatus) ->
%% %%     case length(GoodsStatus#goods_status.null_cells) > 0 of
%% %%         false ->
%% %%             NewGoodsStatus = GoodsStatus,
%% %%             Reply = {error, 2};
%% %%         true ->
%% %%             case db_agent:mail_get_goods_by_id(GoodsId) of
%% %%                 [] ->
%% %%                     NewGoodsStatus = GoodsStatus,
%% %%                     Reply = {error, 4};
%% %%                 [Goods] ->
%% %%                     [Cell|NullCells] = GoodsStatus#goods_status.null_cells,
%% %%                     lib_mail:add_online_goods(Goods, Cell, PlayerId),
%% %%                     NewNullCells = lists:sort(NullCells),
%% %%                     %% 更新背包空格列表
%% %%                     NewGoodsStatus = GoodsStatus#goods_status{null_cells = NewNullCells},
%% %%                     lib_player:refresh_client(NewGoodsStatus#goods_status.pid_send, 2),   %% 刷新背包
%% %%                     Reply = {ok, 1}
%% %%             end
%% %%     end,
%% %%     {reply, Reply, NewGoodsStatus};
%% %%                     
%% %%                     
%% %%                     
%%                     
%%             
%%                     
%%                     
%% %% 赠送物品
%% %% GoodsList = [{GoodsTypeId, GoodsNum},...]
%% handle_call({'give_more', _PlayerStatus, GoodsList}, _From, GoodsStatus) ->
%%     case (catch goods_util:list_handle(fun lib_goods:give_goods/2, GoodsStatus, GoodsList)) of
%%         {ok, NewStatus} ->
%%             lib_player:refresh_client(NewStatus#goods_status.pid_send, 2),
%%             {reply, ok, NewStatus};
%%         {fail, Error, Status} ->
%%             {reply, Error, Status}
%%     end;
%% 
%% %%添加任务物品 
%% handle_call({'give_task_goods', PlayerStatus, GoodsTypeId, GoodsNum, TaskTypeId}, _From, GoodsStatus) ->
%% %%     if TaskTypeId =:= 501010010 ->  %%第一个任务需要完美品质的装备
%% %%            put(equip_qly, 4);
%% %%        true ->
%% %%            skip
%% %%     end,
%% %%     case (catch lib_goods:give_task_goods({GoodsTypeId, GoodsNum},GoodsStatus))of
%% %%         {ok, NewStatus} ->
%% %%             %% 发送50000协议通知客户端更新背包系统数据
%% %%             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, 0, 4),
%% %%             {ok, BinData1} = pt_50:write(50000, GoodsList),
%% %%             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%             
%% %%             {ok, BinData} = pt_30:write(30010, GoodsList),
%% %%             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% %%             
%% %%             lib_goods_use:add_pet_egg_timer(PlayerStatus),
%% %%             %%lib_player:refresh_client(GoodsStatus#goods_status.socket, 2),
%% %% 
%% %%             GiveGoods = goods_util:get_goods_type(GoodsTypeId),
%% %%             if GiveGoods#ets_base_goods.type =:= 46 ->
%% %%                   %通知成就系统 水晶等级列表
%% %%                   GoodsList1 = goods_util:get_equip_list(PlayerStatus#player.id, 46),
%% %%                   achi_crynum_notice(PlayerStatus#player.other#player_other.pid, GoodsList1, give_goods);
%% %%                GiveGoods#ets_base_goods.type =:= 10 andalso GiveGoods#ets_base_goods.stype =:= 20 ->
%% %%                   %通知成就系统 时装类 XXX珠数量 
%% %%                   GoodsList2 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                   achi_clothes_notice(PlayerStatus#player.other#player_other.pid, GoodsList2, give_goods);
%% %%                GiveGoods#ets_base_goods.type =:= 10 andalso GiveGoods#ets_base_goods.stid =/= 0 ->
%% %%                   %%取套装物品列表
%% %%                   GoodsList3 = goods_util:get_equip_list(PlayerStatus#player.id, 10),
%% %%                   achi_suit_notice(PlayerStatus, GoodsList3, give_goods);
%% %%                true ->  %%不是关注种类
%% %%                   skip
%% %%             end,
%% %%             erase(equip_qly),
%% %%             {reply, ok, NewStatus};
%% %%         {fail, Error} ->
%% %%             erase(equip_qly),
%% %%             {reply, Error, GoodsStatus}
%% %%     end;
%% ok ;
%% 
%% %%怪物掉落任务物品
%% handle_call({'mon_drop_task_goods',PlayerId,GoodsTypeId,GoodsNum,GoodsTypeInfo},_From,GoodsStatus)->
%%     %% 任务物品不影响Status
%%     Pattern = #goods{uid=PlayerId, gtid=GoodsTypeId, loc=6, _='_'},
%% %%     GoodsInfo = goods_util:get_ets_info(?ETS_GOODS_ONLINE, Pattern),
%% %%     case is_record(GoodsInfo, goods) of
%% %%         true ->
%% %%             NewNum = GoodsInfo#goods.num + GoodsNum,
%% %%             lib_goods:change_goods_num(GoodsInfo, NewNum);
%% %%         false ->   
%% %%             GoodsInfo1 = goods_util:get_new_goods(GoodsTypeInfo),
%% %%             GoodsInfo2 = GoodsInfo1#goods{uid=PlayerId, loc=6, num=GoodsNum },
%% %%             lib_goods:add_goods(GoodsInfo2),
%% %%             NewNum = GoodsNum
%% %%      end,         
%%    {reply, {ok,2}, GoodsStatus};
%%   
%% 
%% %% 获取空格子数
%% handle_call({'cell_num'}, _From, GoodsStatus) ->
%%     {reply, length(GoodsStatus#goods_status.null_cells), GoodsStatus};
%% %% 获取空格子情况
%% handle_call({'null_cell'} , _From, GoodsStatus) ->
%%     {reply, GoodsStatus#goods_status.null_cells, GoodsStatus};
%% 
%% %% 坐骑状态切换
%% handle_call({'changeMountStatus',PlayerStatus,MountId},_From,GoodsStatus) ->
%%     case check_change_mount_status(PlayerStatus,MountId) of
%%         {fail,Res} ->
%%             {reply,[Res,0,PlayerStatus],GoodsStatus};
%%         {ok,MountInfo} ->
%%             case (catch lib_goods:change_mount_status(PlayerStatus,MountInfo)) of
%%                 {ok,NewPlayerStatus,MountType} ->
%%                     {reply,[1,MountType,NewPlayerStatus],GoodsStatus};
%%                 Error ->
%%                     ?ERROR_MSG("mod_goods changeMountStatusErr:~p",[Error]),
%%                     {reply,[0,0,PlayerStatus],GoodsStatus}
%%             end
%%     end;
%% %%卸下坐骑
%% handle_call({'force_off_mount',PlayerStatus},_From,GoodsStatus) ->
%%     case (catch lib_goods:force_off_mount(PlayerStatus)) of
%%         {ok,NewPlayerStatus} ->
%%             {reply,[1,NewPlayerStatus],GoodsStatus};
%%         Error ->
%%             ?ERROR_MSG("mod_goods forceOffMount:~p",[Error]),
%%             {reply,[0,PlayerStatus],GoodsStatus}
%%     end;
%% 
%% 
%% %% 使用各种长生界卡(15090)
%% handle_call({'use_csj_card',PlayerStatus,CardString},_From,GoodsStatus)->
%%     Len = length(GoodsStatus#goods_status.null_cells),
%%     if
%%         Len > 0 ->
%%             [Ret,Key] = lib_goods:active_csj_card(PlayerStatus,CardString),
%%              PhoneC = "sj",
%%             case [Ret,Key] of
%%                 [ok, Gtid] ->
%%                     case (catch lib_goods:give_goods({Gtid, 1 ,2}, GoodsStatus)) of
%%                         {ok,NewGoodsStatus} ->
%%                             %% 发送50000协议通知客户端更新背包系统数据
%%                             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, Gtid, 0, 4),
%%                             {ok, BinData1} = pt_50:write(50000, GoodsList),
%%                             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%                             lib_player:refresh_client(NewGoodsStatus#goods_status.pid_send, 2),
%%                             
%%                             lib_goods_use:add_pet_egg_timer(PlayerStatus),
%%                             {reply,[1,PlayerStatus],NewGoodsStatus};
%%                         _ ->
%%                             {reply, [0,PlayerStatus], GoodsStatus}
%%                     end;
%%                 [1,PhoneC] ->
%%                     %%绑定手机号码礼包
%%                     case (catch lib_goods:give_goods({205001, 1 ,2}, GoodsStatus)) of
%%                         {ok,NewGoodsStatus} ->
%%                             %% 发送50000协议通知客户端更新背包系统数据
%%                             GoodsList = goods_util:get_type_goods_list(GoodsStatus#goods_status.uid, 205001, 0, 4),
%%                             {ok, BinData1} = pt_50:write(50000, GoodsList),
%%                             lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData1),
%% %%                             lib_player:refresh_client(NewGoodsStatus#goods_status.pid_send, 2),
%%                             
%%                             lib_goods_use:add_pet_egg_timer(PlayerStatus),
%%                             {reply,[Ret,PlayerStatus],NewGoodsStatus};
%%                         _ ->
%%                             {reply, [0,PlayerStatus], GoodsStatus}
%%                     end;
%%                 _->
%%                     {reply, [Ret,PlayerStatus], GoodsStatus}
%%             end;
%%         true ->
%%             {reply, [6,PlayerStatus], GoodsStatus}            %%背包已满
%%     end;
%%     
%% %% 检测背包是否满
%% handle_call({'chk_backpack', GoodsList},_From,GoodsStatus)->
%%     case multi_check_get(ok, 1, [], GoodsStatus, GoodsList, []) of
%%         {fail, Res} ->
%%             {reply, Res, GoodsStatus};
%%         {ok, _GoodsTypeInfos} ->
%%             {reply, 1, GoodsStatus};
%%         _ ->
%%             {reply, 0, GoodsStatus}
%%     end;
%% 
handle_call(_R , _From, GoodsStatus) ->
     ?ERROR_MSG("mod_goods: receive unknown call: ~p  GoodStatus: ~p~n", [_R, GoodsStatus]),
     {reply, ok, GoodsStatus}.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_info/2
%% %% Description: Handling all non call/cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% 
%% %%物品快照
%% handle_info('snapshot',GoodsStatus) ->
%%     spawn(fun()->
%%             Playerid = GoodsStatus#goods_status.uid,
%%             Row = log:get_log_goods_list(Playerid),
%%             if
%%                 Row /= [] ->
%%                     [_,SnapshotData] = Row,
%%                     Snapshot=util:string_to_term(tool:to_list(SnapshotData));
%%                 true ->
%%                     Snapshot = []
%%             end,
%%             NowGoodsList = goods_util:get_goods_list(Playerid,all),
%%             F = fun(Ginfo,Infolist) ->
%%                         Pre = {Ginfo#goods.id,Ginfo#goods.gtid,Ginfo#goods.num},
%%                         [Pre|Infolist]
%%                 end,
%%             CurList = lists:foldl(F, [], NowGoodsList),
%%             Time = util:unixtime(),
%%             CurInfo = {Time,CurList},
%%             %%记录3天历史记录
%%             case length(Snapshot) >= 3 of
%%                 true ->
%%                     DecSnapshot = lists:reverse(tl(lists:reverse(Snapshot))),
%%                     NewSnapshot = [CurInfo|DecSnapshot];
%%                 false ->
%%                     NewSnapshot = [CurInfo|Snapshot]
%%             end,
%%             NewSnapshotData = util:term_to_string(NewSnapshot),
%%             log:log_goods_list([Playerid,NewSnapshotData])
%%     end),
%%     {noreply, GoodsStatus};
%% 
%% %%
%% %%物品内存数据库对比，用于检测，运营服不开启。
%% handle_info({'mem_diff',T},GoodsStatus) ->
%%     misc:cancel_timer(mem_diff_timer),
%%     spawn(fun()->
%%                   Playerid = GoodsStatus#goods_status.uid,
%%                   NowGoodsList = goods_util:get_goods_list(Playerid,all),
%%                   NowGoodsListDb = goods_util:get_player_goods_from_db(Playerid),
%%                   %%检查每个物品的数量是否一致
%%                   lists:foreach(fun(Dbg)->
%%                                         lists:foreach(fun(Mg)->
%%                                                               if
%%                                                                   Mg#goods.id == Dbg#goods.id andalso 
%%                                                                                                Mg#goods.num /= Dbg#goods.num ->
%%                                                                       log:log_goods_diff([Playerid,T,Mg#goods.gtid,Mg#goods.id,Dbg#goods.num,Mg#goods.num]);
%%                                                                   true ->
%%                                                                       skip
%%                                                               end
%%                                                       end
%%                                                               ,
%%                                                        NowGoodsListDb)
%%                                 end,
%%                                 NowGoodsList),
%%                   %%获取id列表
%%                   F_getid = fun(GList) ->
%%                                     lists:map(fun(Ginfo) ->Ginfo#goods.id end, GList)
%%                             end,
%%                   %%根据id获取物品信息
%%                   F_getinfo = fun(Id,GList) ->
%%                                       lists:foldl(fun(Ginfo,Get)-> 
%%                                                         if Ginfo#goods.id == Id ->
%%                                                                [Ginfo|Get];
%%                                                            true ->
%%                                                                Get
%%                                                         end
%%                                                 end,[], GList)
%%                               end,
%%                   %%检查物品个数是否一致
%%                   Len1 = length(NowGoodsList),
%%                   Len2 = length(NowGoodsListDb),
%%                   if
%%                       Len1 > Len2 ->
%%                           MoreList = F_getid(NowGoodsList),
%%                           LessList = F_getid(NowGoodsListDb);
%%                       Len1 < Len2 ->
%%                           MoreList = F_getid(NowGoodsListDb),
%%                           LessList = F_getid(NowGoodsList);
%%                       true ->
%%                           MoreList = [],
%%                           LessList = []                  
%%                   end,
%%                   lists:foreach(fun(Id)->
%%                                     case lists:member(Id, LessList) of
%%                                         true ->
%%                                             skip;
%%                                         false ->
%%                                             ErrGoodList = F_getinfo(Id,NowGoodsList),
%%                                             if
%%                                                 ErrGoodList /= [] ->
%%                                                     ErrGood = hd(ErrGoodList),
%%                                                     log:log_goods_diff([Playerid,T,ErrGood#goods.gtid,ErrGood#goods.id,0,ErrGood#goods.num]);
%%                                                 true ->
%%                                                     skip
%%                                             end
%%                                     end
%%                                 end,
%%                             MoreList
%%                     )
%%                   
%%           end),
%%     erlang:send_after(1000 * 10 , self(),{'mem_diff',1}),
%%     {noreply,GoodsStatus};
%% 
%% %% 检测玩家失效物品（时间控制）
%% handle_info({'CHECK_GOODS_CD', Type}, Status) ->
%%     misc:cancel_timer(goods_cd_timer),
%%     case Type of
%%         auto ->
%%             Timer = erlang:send_after(60*1000, self(),{'CHECK_GOODS_CD', auto}),
%%             put(goods_cd_timer, Timer);
%%         _ ->
%%             skip
%%     end,
%% %%     io:format("~s CHECK_GOODS_CD___[~p]\~n",[misc:time_format(now()), self()]),
%%     NewStatus = lib_goods:check_time_goods(Status),
%% %%     case BChg of
%% %%         1 ->
%% %%             lib_player:send_player_attribute3(Status, NewStatus),
%% %%             {ok, NewStatus};
%% %%         _ ->
%% %%             ok
%% %%     end,
%%     {noreply, NewStatus};
%% 
%% %% 时装装备Buff到期（时间控制）
%% handle_info({'FASH_BUFF_TIME_OUT', BuffId}, Status) ->
%% %%     misc:cancel_timer(fash_goods_buff_timer),
%% %% %%     io:format("~s FASH_BUFF_TIME_OUT_1__[~p]\~n",[misc:time_format(now()), BuffId]),
%% %%     case ets:lookup(?ETS_GOODS_BUFF, BuffId) of
%% %%         [Buff] when is_record(Buff, goods_buff) ->
%% %%             Now = util:unixtime(),
%% %% %%             io:format("~s FASH_BUFF_TIME_OUT_2_[~p]\~n",[misc:time_format(now()), [Buff#goods_buff.eprtm, Now]]),
%% %%             if Buff#goods_buff.eprtm > Now andalso Buff#goods_buff.eprtm =/= 0->
%% %%                    lib_goods_use:add_fash_buff_timer(Status#goods_status.uid);
%% %%                Buff#goods_buff.eprtm =:= 0 ->
%% %%                    skip;
%% %%                true ->
%% %%                    ets:delete(?ETS_GOODS_BUFF, Buff#goods_buff.id),
%% %%                    db_agent:del_goods_buff(Buff#goods_buff.id),
%% %%                    {ok, BinData} = pt_13:write(13014, [[Buff#goods_buff.gtid, 0, 0]]),
%% %%                    spawn(fun()->lib_send:send_to_sid(Status#goods_status.pid_send, BinData) end),
%% %%                    erlang:send_after(100, self(), {'CHECK_GOODS_CD', auto})
%% %%             end;
%% %%         _ ->
%% %%             skip
%% %%     end,
%% %%     {noreply, Status};        
%% ok ;
%% 
 handle_info(_Reason, GoodsStatus) ->
     {noreply, GoodsStatus}.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: terminate/2
%% %% Description: Shutdown the server
%% %% Returns: any (ignored by gen_server)
%% %% --------------------------------------------------------------------
 terminate(_Reason, GoodsStatus) ->
     %%删除商店中待回购物品
     %SoldGoods = get(soldGoods),
     %Total_money_r = get(total_money_data),
     %spawn(fun() -> db_log_agent:money_to_db_total(GoodsStatus#goods_status.uid,Total_money_r) end),
     
     %%取消timer
     %misc:cancel_timer(fash_goods_buff_timer),
     %misc:cancel_timer(goods_cd_timer),
     %misc:cancel_timer(mem_diff_timer),
     %misc:delete_monitor_pid(self()),
     ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, GoodsStatus, _Extra)->
    {ok, GoodsStatus}.

