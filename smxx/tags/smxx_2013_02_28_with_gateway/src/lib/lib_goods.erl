%%%--------------------------------------
%%% @Module  : lib_goods
%%% @Author  : 
%%% @Email   : 
%%% @Created :
%%% @Description : 物品信息
%%%--------------------------------------
-module(lib_goods).
-include("common.hrl").
-include("record.hrl").
-include("goods.hrl").
-include("common_log.hrl").
-include("debug.hrl").

-compile(export_all).

%% 添加新物品信息
%% 该接口仅限于对在线玩家发送物品
%% @spec add_goods(GoodsInfo) -> #goods{} | skip
%% @spec add_goods(GoodsInfo, GooETSname) -> #goods{} | skip
add_goods(GoodsInfo) ->
    add_goods(GoodsInfo, ?ETS_GOODS_ONLINE(GoodsInfo#goods.uid)).
add_goods(Info, GoodsEtsName) ->
%% 	[NewTid, Bind, Trade] = get_tid_and_bind(Info#goods.goods_id, Info#goods.bind, Info#goods.trade),
	[NewTid, Bind, Trade] =[Info#goods.gtid, 0, 0],
    GoodsInfo = case NewTid == 0 of
                       true ->   % 转化出错
                           ?ERROR_MSG("get_tid_and_bind error:~p", [{Info#goods.gtid, NewTid, Bind, Trade}]),?ASSERT(false),
                           Info;
                       false ->
                           Info
                   end,
    if
        GoodsInfo#goods.gtid > 0 ->
            case db_agent_goods:add_goods(GoodsInfo) of
                InsertId when is_integer(InsertId), InsertId > 0 ->
                    NewInfo = GoodsInfo#goods{id = InsertId},
                    case GoodsEtsName of
                        no_insert -> skip;
                        Name -> lib_common:insert_ets_info(Name, NewInfo)
                    end,
                    NewInfo;
                _Error ->
                    ?ERROR_MSG("insert new goods record error:~p", [_Error]),
                    skip
            end;
        true ->
            ?ERROR_MSG("add new goods record error:~p", [{Bind, Trade, GoodsInfo#goods.gtid}]),
            skip
    end.

%% 删除多个物品(按格子编号由小到大)
%% @spec delete_more(Status, GoodsList, GoodsNum) -> {ok, NewStatus}
delete_more({PS, Status}, GoodsList, GoodsNum) ->
    GoodsList1 = sort(GoodsList, cell),
    F1 = fun(GoodsInfo, [Num, Status1]) ->
            case Num > 0 of
                true ->
                    {ok, NewStatus1, Num1} = delete_one(PS, Status1, GoodsInfo, Num),
                    case Num1 > 0 of
                        true -> NewNum = 0;
                        false -> NewNum = Num - GoodsInfo#goods.num
                    end,
                    [NewNum, NewStatus1];
                false ->
                    [Num, Status1]
            end
         end,
    [_, NewStatus] = lists:foldl(F1, [GoodsNum, Status], GoodsList1),
    {ok, NewStatus}.

%% 删除多个物品(按物品由小到大)
%% @spec delete_more(Status, GoodsList, GoodsNum) -> {ok, NewStatus}
delete_more(num_min_first, {PS, Status}, GoodsList, GoodsNum) ->
%% 	A1 = lists:map(fun(X) -> X#goods.num end, GoodsList),
    GoodsList1 = sort(GoodsList, num),
    F1 = fun(GoodsInfo, [Num, Status1]) ->
            case Num > 0 of
                true ->
                    {ok, NewStatus1, Num1} = delete_one(PS, Status1, GoodsInfo, Num),
                    case Num1 > 0 of
                        true -> NewNum = 0;
                        false -> NewNum = Num - GoodsInfo#goods.num
                    end,
                    [NewNum, NewStatus1];
                false ->
                    [Num, Status1]
            end
         end,
    [_, NewStatus] = lists:foldl(F1, [GoodsNum, Status], GoodsList1),
    {ok, NewStatus};

%% 删除多个物品
%% @spec delete_more(Status, GoodsList, GoodsNum) -> {ok, NewStatus}
delete_more(keep_order, {PS, Status}, GoodsList1, GoodsNum) ->
    F1 = fun(GoodsInfo, [Num, Status1]) ->
            case Num > 0 of
                true ->
                    {ok, NewStatus1, Num1} = delete_one(PS, Status1, GoodsInfo, Num),
                    case Num1 > 0 of
                        true -> NewNum = 0;
                        false -> NewNum = Num - GoodsInfo#goods.num
                    end,
                    [NewNum, NewStatus1];
                false ->
                    [Num, Status1]
            end
         end,
    [_, NewStatus] = lists:foldl(F1, [GoodsNum, Status], GoodsList1),
    {ok, NewStatus}.

%% 删除一个物品
%% @spec use_goods(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum) -> {ok, [HP, MP]}
delete_one(PS, Status, GoodsInfo, GoodsNum) ->
    case GoodsInfo#goods.num > GoodsNum of
        true when GoodsInfo#goods.id > 0 ->
            % 部分使用
            NewNum = GoodsInfo#goods.num - GoodsNum,
            change_goods_num(PS, GoodsInfo, NewNum),
%% 			log:log_goods_operation(PS#player.id, GoodsInfo#goods.gtid, GoodsNum, ?LOG_USE_GOODS),
            NewStatus = Status;
        false when GoodsInfo#goods.id > 0 ->
            % 全部使用
%% 			log:log_goods_operation(PS#player.id, GoodsInfo#goods.gtid, GoodsNum, ?LOG_USE_GOODS),
            NewNum = 0,
            NewStatus = delete_goods(PS, GoodsInfo, Status);
        _ ->
            NewNum = GoodsNum,
            NewStatus = Status
    end,
    {ok, NewStatus, NewNum}.
 
%% 删除一类物品
%% @spec delete_type_goods(GoodsTypeId, GoodsStatus) -> {ok, NewStatus} | Error
delete_type_goods(GoodsTypeId, {PS, GoodsStatus}) ->
    GoodsList = get_type_goods_list(GoodsStatus#goods_status.uid, GoodsTypeId, ?LOCATION_BAG),
    if length(GoodsList) > 0 ->
            TotalNum = calc_goodslist_total_nums(GoodsList),
            case (catch delete_more({PS, GoodsStatus}, GoodsList, TotalNum)) of
                {ok, NewStatus} -> {ok, NewStatus};
                 Error -> {fail, Error, GoodsStatus}
            end;
        true ->
            {ok, GoodsStatus}
    end.

%% 整理背包 
clean_bag(GoodsInfo, [Num, OldGoodsInfo, PS]) ->
    case is_record(OldGoodsInfo, goods) of
        % 与上一格子物品类型相同
        true when GoodsInfo#goods.gtid =:= OldGoodsInfo#goods.gtid
                    andalso GoodsInfo#goods.bind =:= OldGoodsInfo#goods.bind ->
            GoodsTypeInfo = get_goods_type_info(GoodsInfo#goods.gtid),
            case GoodsTypeInfo#temp_goods.max_num > 1 of
                % 可叠加
                true ->
                    [_, NewGoodsNum, _] = update_overlap_goods(OldGoodsInfo, [PS, GoodsInfo#goods.num, GoodsTypeInfo#temp_goods.max_num]),
                    case NewGoodsNum > 0 of
                        % 还有剩余
                        true ->
                            NewGoodsInfo = change_goods_location_and_cell_and_num(PS, GoodsInfo, ?LOCATION_BAG, Num, NewGoodsNum),
                            [Num + 1, NewGoodsInfo, PS];
                        % 没有剩余
                        false ->
                            delete_goods(PS, GoodsInfo#goods.id),
                            lib_common:delete_ets_info(?ETS_GOODS_ONLINE(PS), GoodsInfo#goods.id),
                            NewGoodsNum1 = OldGoodsInfo#goods.num + GoodsInfo#goods.num,
                            NewOldGoodsInfo = OldGoodsInfo#goods{ num=NewGoodsNum1 },
                            [Num, NewOldGoodsInfo, PS]
                    end;
                % 不可叠加
                false ->
                    NewGoodsInfo = change_goods_location_and_cell(PS, GoodsInfo, ?LOCATION_BAG, Num),
                    [Num + 1, NewGoodsInfo, PS]
            end;
        % 与上一格子类型不同
        true ->
            NewGoodsInfo = change_goods_location_and_cell(PS, GoodsInfo, ?LOCATION_BAG, Num),
            [Num + 1, NewGoodsInfo, PS];
		% 第一格
        false ->
            NewGoodsInfo = change_goods_location_and_cell(PS, GoodsInfo, ?LOCATION_BAG, Num),
            [Num + 1, NewGoodsInfo, PS]
    end.

%% 更新原有的可叠加物品
update_overlap_goods(GoodsInfo, [PS, Num, MaxOverlap]) ->
    case Num > 0 of
        true when GoodsInfo#goods.num =/= MaxOverlap andalso MaxOverlap > 0 ->
            case Num + GoodsInfo#goods.num > MaxOverlap of
                % 总数超出可叠加数
                true ->
                    OldNum = MaxOverlap,
                    NewNum = Num + GoodsInfo#goods.num - MaxOverlap;
                false ->
                    OldNum = Num + GoodsInfo#goods.num,
                    NewNum = 0
            end,
            change_goods_num(PS, GoodsInfo, OldNum);
        true ->
            NewNum = Num;
        false ->
            NewNum = 0
    end,
    [PS, NewNum, MaxOverlap].



%% 向存储位置添加物品
%% @spec add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsInfo, GoodsNum) -> {ok, NewGoodsStatus}
add_goods_base({PS, GoodsStatus}, GoodsTinfo, GoodsNum, GoodsInfo, GoodsList, Location) ->
    MaxOverlap = GoodsTinfo#temp_goods.max_num,
    case MaxOverlap > 1 of   % 插入物品记录
        true ->   % 更新原有的可叠加物品
            [_, GoodsNum2, _] = lists:foldl(fun update_overlap_goods/2, [PS, GoodsNum, MaxOverlap], GoodsList),
            % 添加新的可叠加物品
            [NewGStatus, _, _, _] = goods_util:deeploop(fun add_overlap_goods/2, GoodsNum2, [GoodsStatus, GoodsInfo, Location, MaxOverlap]);
        false ->   % 添加新的不可叠加物品
            AllNums = lists:seq(1, GoodsNum),
            [NewGStatus, _, _] = lists:foldl(fun add_nonlap_goods/2, [GoodsStatus, GoodsInfo, Location], AllNums)
    end,
    {ok, NewGStatus}.



%% 添加新的可叠加物品
add_overlap_goods(Num, [GoodsStatus, GoodsInfo, Location, MaxOverlap]) ->
    [NewNum, OldNum] = case Num > MaxOverlap of
                           true ->   [Num - MaxOverlap, MaxOverlap];
                           false ->  [0, Num]
                       end,
    NewGoodsStatus = 
    case OldNum > 0 of
        true when length(GoodsStatus#goods_status.null_cells) > 0 ->
            [Cell | NullCells] = GoodsStatus#goods_status.null_cells,
            NewGStatus = GoodsStatus#goods_status{ null_cells = NullCells },
            NewGoodsInfo = GoodsInfo#goods{uid = GoodsStatus#goods_status.uid, location=Location, cell=Cell, num=OldNum },
            add_goods(NewGoodsInfo),
            NewGStatus;
         _ ->
             GoodsStatus
    end,
    [NewNum, [NewGoodsStatus, GoodsInfo, Location, MaxOverlap]].


%% 添加新的不可叠加物品
add_nonlap_goods(_, [GoodsStatus, GoodsInfo, Location]) ->
    NewGoodsStatus = 
    case length(GoodsStatus#goods_status.null_cells) > 0 of
        true ->
            [Cell|NullCells] = GoodsStatus#goods_status.null_cells,
            NewGStatus = GoodsStatus#goods_status{ null_cells=NullCells },
            NewGoodsInfo3 = GoodsInfo#goods{ uid=GoodsStatus#goods_status.uid, location=Location, cell=Cell, num=1 },
            add_goods(NewGoodsInfo3),
            NewGStatus;
        false ->
            GoodsStatus
    end,
    [NewGoodsStatus, GoodsInfo, Location].

%% @desc: 整理物品
%% @type: type 包括：cell, gtid, num, id
%% @returns: list()
sort(GoodsList, Type) ->
    case Type of
        cell -> F = fun(G1, G2) -> G1#goods.cell < G2#goods.cell end;
        gtid -> F = fun(G1, G2) -> {G1#goods.gtid, G1#goods.bind} < {G2#goods.gtid, G2#goods.bind} end;
        num -> F = fun(G1, G2) -> G1#goods.num < G2#goods.num end;
        id -> F = fun(G1, G2) -> G1#goods.id > G2#goods.id end;
        bag_sort ->
            FcolorConvert = fun(C) -> case C of
                                ?COLOR_WHITE -> 1;
                                ?COLOR_GREEN -> 2;
                                ?COLOR_BLUE -> 3;
                                ?COLOR_PURPLE -> 4;
                                ?COLOR_ORANGE -> 5;
                                _ -> 0
                              end
                            end,
            F = fun(G1, G2) ->
                        {G1#goods.type, G1#goods.subtype, FcolorConvert(G1#goods.quality), G1#goods.gtid, -1 * G1#goods.bind} <
                        {G2#goods.type, G2#goods.subtype, FcolorConvert(G2#goods.quality), G2#goods.gtid, -1 * G2#goods.bind} 
                end;
        _ -> F = fun(G1, G2) -> G1#goods.cell < G2#goods.cell end
    end,
    lists:sort(F, GoodsList).

%% desc: 改变背包中物品的格子
change_bag_cell(GoodsInfo, Cell) ->
	db_agent_goods:update_goods([{cell, Cell}], [id, GoodsInfo#goods.id]),
    NewInfo = GoodsInfo#goods{cell=Cell},
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE, NewInfo),
    NewInfo.

%% 更改物品格子位置
change_goods_location_and_cell(PS, GoodsInfo, Location, Cell) ->
	db_agent_goods:update_goods(["location", "cell"], [Location, Cell], "id", GoodsInfo#goods.id),
    NewGoodsInfo = GoodsInfo#goods{ location=Location, cell=Cell },
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE(PS), NewGoodsInfo),
    NewGoodsInfo.

%% 装备被穿上后，更新装备信息
update_goods_after_equip(Goods, Location, PetId, EquipPos) ->
	% 更新到db
	case Location of
		?LOCATION_PLAYER ->   % 穿在玩家身上
			db_agent_goods:update_goods(["location", "pet_id", "cell", "bind"], [Location, 0, EquipPos, Goods#goods.bind], "id", Goods#goods.id),
    		NewGoodsInfo = Goods#goods{location = Location, pet_id = 0, cell = EquipPos};
		?LOCATION_PET ->  % 穿在武将身上
			?ASSERT(PetId > 0),
			db_agent_goods:update_goods(["location", "pet_id", "cell", "bind"], [Location, PetId, EquipPos, Goods#goods.bind], "id", Goods#goods.id),
    		NewGoodsInfo = Goods#goods{location = Location, pet_id = PetId, cell = EquipPos}
	end,
	% 更新到ets
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE(Goods#goods.uid), NewGoodsInfo),
    NewGoodsInfo.
    
% 装备被脱下后，更新装备信息   
update_goods_after_unequip(Goods, NewCell) ->
    Location = case Goods#goods.subtype of
        ?EQUIP_T_WINGS ->
            ?LOCATION_WINGS;
        _ ->
            ?LOCATION_BAG
    end,
    update_goods_after_unequip(Goods, NewCell, Location).
    
% 装备被脱下后，更新装备信息   
update_goods_after_unequip(Goods, NewCell, Location) ->
	?ASSERT(Goods#goods.location =:= ?LOCATION_PLAYER orelse Goods#goods.location =:= ?LOCATION_PET),
	% 更新到db
	db_agent_goods:update_goods(["location", "pet_id", "cell"], [Location, 0, NewCell], "id", Goods#goods.id),
    NewGoodsInfo = Goods#goods{location = Location, pet_id = 0, cell = NewCell},
	% 更新到ets
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE(Goods#goods.uid), NewGoodsInfo),
    NewGoodsInfo.

%% 更改物品数量
change_goods_num(PlayerId, GoodsInfo, Num) when is_integer(PlayerId) ->
	db_agent_goods:update_goods(["num"], [Num], "id", GoodsInfo#goods.id),
    NewGoodsInfo = GoodsInfo#goods{ num=Num },
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE(PlayerId), NewGoodsInfo),
    NewGoodsInfo;
change_goods_num(PS, GoodsInfo, Num) ->
	db_agent_goods:update_goods(["num"], [Num], "id", GoodsInfo#goods.id),
    NewGoodsInfo = GoodsInfo#goods{ num=Num },
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE(PS), NewGoodsInfo),
    NewGoodsInfo.

%% 更改物品格子位置和数量
change_goods_location_and_cell_and_num(PS, GoodsInfo, Location, Cell, Num) ->
	db_agent_goods:update_goods(["location", "cell", "num"], [Location, Cell, Num], "id", GoodsInfo#goods.id),
    NewGoodsInfo = GoodsInfo#goods{ location=Location, cell=Cell, num=Num },
    lib_common:insert_ets_info(?ETS_GOODS_ONLINE(PS), NewGoodsInfo),
    NewGoodsInfo.

%% 
%% 删除物品
delete_goods(GoodsId) when is_integer(GoodsId) ->
    db_agent_goods:delete_goods(GoodsId).
%%     db:delete(goods_attribute, [{gid,GoodsId}]),
%%     db:delete(casting_wash, [{gid,GoodsId}]).

%% 删除物品
delete_goods(PS, GoodsId) ->
	db_agent_goods:delete_goods(GoodsId),
%% 	db:delete(goods_attribute, [{gid,GoodsId}]),
%% 	db:delete(casting_wash, [{gid,GoodsId}]),
%%     Pattern = #goods_attribute{ gid=GoodsId, _='_'},
	lib_common:delete_ets_info(?ETS_GOODS_ONLINE(PS), GoodsId),
%%     lib_common:delete_ets_info(?ETS_CASTING_WASH(PS), GoodsId),
%%     lib_common:delete_ets_list(?ETS_GOODS_ATTRIBUTE(PS), Pattern),
    ok.
%% returns: NewGS
delete_goods(PS, GoodsInfo, GoodsStatus) ->
    Cell = GoodsInfo#goods.cell,
    delete_goods(PS, GoodsInfo#goods.id),
    case GoodsInfo#goods.location of
        ?LOCATION_BAG ->
            NewNullCell = lists:sort([Cell | GoodsStatus#goods_status.null_cells]),
            GoodsStatus#goods_status{null_cells = NewNullCell};
        ?LOCATION_TREA ->
            NewNullCell = lists:sort([Cell | GoodsStatus#goods_status.trea_null_cells]),
            GoodsStatus#goods_status{trea_null_cells = NewNullCell};
        _ ->
            GoodsStatus
    end.

%% desc:绑定物品
bind_goods(GoodsInfo) when GoodsInfo#goods.bind =:= ?BIND_EQUIP ->
	GoodsInfo#goods{bind = ?BIND_ALREADY};
%% 	db_agent_goods:update_goods(["bind"], [?BIND_ALREADY], "id", GoodsInfo#goods.id),
%%     NewGoodsInfo = GoodsInfo#goods{bind = ?BIND_ALREADY},
%%     lib_common:insert_ets_info(?ETS_GOODS_ONLINE(GoodsInfo#goods.uid), NewGoodsInfo),
%%     NewGoodsInfo;
bind_goods(GoodsInfo) ->
    GoodsInfo.

%%当玩家删除角色时，删除有关于这角色的数据
delete_role(PlayerId) ->
	db:delete(goods_attribute, [{uid, PlayerId}]),
	db:delete(goods, [{uid,PlayerId}]),
    ok.

%% desc: 根据物品列表获取各自的规则
get_rule_list(InfoList, Table) ->
	F = fun(Info) -> lib_common:get_ets_info(Table, Info#goods.gtid) end,
	lists:map(F, InfoList).

%% desc: 物品拆分
split_goods({PS, GoodsStatus}, GoodsInfo, GoodsNum) ->
	MovedNum = GoodsInfo#goods.num - GoodsNum,
	% OldGoodsInfo-拆分后原位置物品，NewGoodsInfo-拆分后新位置物品
	change_goods_num(PS, GoodsInfo, MovedNum),
	[NewCell | Rest] = GoodsStatus#goods_status.null_cells,
	NewStatus = GoodsStatus#goods_status{null_cells = Rest},
	MidInfo = GoodsInfo#goods{num = GoodsNum, cell = NewCell},
	add_goods(MidInfo),
	{ok, NewStatus}.		

%% desc: 获取base_goods中指定物品信息
%% returns: {} | #temp_goods{}
get_goods_type_info(GoodsTid) ->
    lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTid).

%% 取物品名称
%% @spec get_goods_name(GoodsTypeId) -> list()
get_goods_name(GoodsTid) ->
    case lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTid) of
        {} ->
            [];
        GoodsTinfo ->
            GoodsTinfo#temp_goods.name
    end.

%% desc: 通过物品类型ID获取颜色
%% returns: integer()
get_goods_color(GoodsTid) ->
    case lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTid) of
        {} ->
            ?ERROR_MSG("get_goods_color failed:~p", [GoodsTid]),
            0;
        GoodsTinfo ->
            GoodsTinfo#temp_goods.quality
    end.

%% desc: 查询物品的职业限制类型
%% returns: integer()
get_goods_career(GoodsTid) ->
    case lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTid) of
        {} -> 
            ?ERROR_MSG("get_goods_career:~p", [GoodsTid]),
            ?CAREER_ANY;
        TypeInfo ->
            TypeInfo#temp_goods.career
    end.

%% desc: 查询物品的叠加上限
get_goods_overlap(GoodsTid) ->
    case get_goods_type_info(GoodsTid) of
        {} -> 0;
        Info -> Info#temp_goods.max_num
    end.

%% desc: 查询类型和子类型
get_type_and_subtype(GoodsTid) ->
    case lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTid) of
        {} -> 
            ?ERROR_MSG("get_type_and_subtype:~p", [GoodsTid]),
            {0, 0};
        GoodsTinfo ->
            {GoodsTinfo#temp_goods.type, GoodsTinfo#temp_goods.subtype}
    end.

%% desc: 查询装备的配置强化最高等级
get_max_strenlv(GoodsTid) ->
    case tpl_equipment:get(GoodsTid) of
        [] -> 0;
        Info ->
        	Info#temp_item_equipment.max_stren
    end.

%% desc: 处理使用VIP卡
%% returns: {ok, NewPS, NewGstatus, NewNum}
handle_use_vip_card(PS, GoodsStatus, GoodsInfo) ->
    {ok, NewGS, NewNum} = delete_one(PS, GoodsStatus, GoodsInfo, 1),   % 删除VIP卡
    NewPS = to_be_vip(PS, GoodsInfo#goods.gtid),
    {ok, NewPS, NewGS, NewNum}.


%% desc: vip状态修改
%% returns: NewPS
to_be_vip(PS, GoodsTid) ->
    LastingTime = data_goods:get_vip_lasting_time(GoodsTid),
    VipLv = data_goods:get_vip_lv_by_goodstid(GoodsTid),
	?TRACE("to_be_vip VipLv:~p, oldvip:~p ~n", [VipLv, PS#player.vip]),
    NewPS = case VipLv > PS#player.vip of
                true -> % 使用更高等级VIP卡
                    Time = util:unixtime() + LastingTime,
					change_vip_data(PS, VipLv, Time);
                false -> % 使用同等级VIP卡，持续时间叠加
                    Time = PS#player.vip_expire_time + LastingTime,
					change_vip_data(PS, Time)
            end,
    lib_player:handle_use_vip_refresh_data(NewPS),
	NewPS.

%% desc: 处理使用礼包的效果
handle_use_awardbag_effect(PS, GoodsStatus, GoodsInfo) when is_record(PS, player) ->	
	GoodsList = open_gift(GoodsInfo#goods.gtid, GoodsInfo#goods.bind),	
	handle_use_awardbag_effect(GoodsList, {PS, GoodsStatus}, GoodsInfo);
handle_use_awardbag_effect(GoodsList, {PS, GoodsStatus}, GoodsInfo) ->
	{ok, NewStatus, NewNum} = delete_one(PS, GoodsStatus, GoodsInfo, 1),   % 删除旧的礼包
    case give_goods_and_money(GoodsList, PS, NewStatus) of
        {NewPS, NewGS} when is_record(NewGS, goods_status) ->
            {ok, {NewPS, NewGS}, NewNum};
        _Error ->
            ?ERROR_MSG("handle_use_awardbag_effect failed:~p", [_Error]),
            ?ASSERT(false),
            {ok, {PS, NewStatus}, NewNum}
    end.

%% func: calc_goodslist_total_nums/1
%% desc: 计算物品列表中所有物品的总个数
%% returns: integer()
calc_goodslist_total_nums(GoodsList) ->
	lists:foldl(fun(Info, Sum) -> Info#goods.num + Sum end, 0, GoodsList).

get_bind_status(GoodsInfo, StoneInfoList) ->
	GoodsBind = GoodsInfo#goods.bind,
	F = fun(Info, Status) ->
				case Info#goods.bind =:= ?BIND_ALREADY of
					true ->
						?BIND_ALREADY;
					false ->
						Status
				end
		  end,
	lists:foldl(F, GoodsBind, StoneInfoList).


%% desc: 获取背包扩展信息
get_extend_info(Location, PlayerStatus) ->
	[
	 ?COST_EXTEND_BAG,
	 PlayerStatus#player.cell_num,
	 ?CELL_NUM_MAX_BAG
	].


%% 
%% desc: 获取开启后的总格子数
get_new_extend_num(Cells, CellNum, MaxCell) ->
	case Cells + CellNum >= MaxCell of
		true ->  MaxCell;
		false -> Cells + CellNum
	end.

%% desc: 获取开启成功后背包空格子列表
get_new_cells_list(GoodsStatus, List, PlayerStatus, CellNum) ->
	NullList = GoodsStatus#goods_status.null_cells ++ List,
	NewStatus = GoodsStatus#goods_status{null_cells = NullList},
	[NewStatus, 0, CellNum].
 
%% desc: 添加一个物品(不自动叠加)
add_goods_no_clean(GoodsTid, {cell_list, CellList, Condition}) when is_integer(GoodsTid) ->
    add_goods_no_clean({GoodsTid, 1, 0}, {cell_list, CellList, Condition});
add_goods_no_clean({GoodsTid, Num}, {cell_list, CellList, Condition}) ->
    add_goods_no_clean({GoodsTid, Num, 0}, {cell_list, CellList, Condition});
add_goods_no_clean({GoodsTid, Num, StrenLv}, {cell_list, CellList, OldCondition}) ->
    Condition = 
    case StrenLv == 0 of
        true ->  OldCondition;
        false -> 
            Degree = case StrenLv > 0 of true -> ?MAX_STREN_DEGREE; false -> 0 end,
            replace_list_elem_by_key([{stren_lv, StrenLv}, {stren_percent, Degree}], OldCondition)
    end,
    
    case get_goods_record(GoodsTid) of
        Info1 when is_record(Info1, goods), Num > 0 ->
			Info = convert_bind_state(Info1),
            MaxOverlap = get_goods_overlap(GoodsTid),
            case MaxOverlap >= Num of
                true ->
                    [_, LeftList] = do_give_goods_noclean(Info, CellList, Condition, Num),
                    {cell_list, LeftList, Condition};
                false ->
                    [_, LeftList] = do_give_goods_noclean(Info, CellList, Condition, MaxOverlap),
                    add_goods_no_clean({GoodsTid, Num - MaxOverlap, StrenLv}, {cell_list, LeftList, Condition})
            end;
        _ ->
            case Num == 0 of
                true -> skip;
                false -> ?ERROR_MSG("badarg GoodsTid no clean:~p, Num:~p, SendConditions:~w", [GoodsTid, Num, Condition])
            end,
            {cell_list, CellList, Condition}
    end;
add_goods_no_clean(_, {cell_list, CellList, Condition}) ->
    {cell_list, CellList, Condition}.

%% 如果物品为捡取绑定
convert_bind_state(GoodsInfo) ->
	case GoodsInfo#goods.bind =:= ?BIND_NOTYET of
		true -> GoodsInfo#goods{bind = ?BIND_ALREADY};
		false -> GoodsInfo
	end.

%% returns: temp_goods
get_base_goods_record(GoodsTypeId) ->
    lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTypeId).

get_goods_record(GoodsTypeId) ->
    case lib_common:get_ets_info(?ETS_TEMP_GOODS, GoodsTypeId) of
		Info when is_record(Info, temp_goods) ->
			Bind = case ?BIND_NOTYET =:= Info#temp_goods.limit of
					   true -> ?BIND_ALREADY;
					   false -> Info#temp_goods.limit
				   end,
			#goods{
				   gtid = Info#temp_goods.gtid,
				   type = Info#temp_goods.type,
				   subtype = Info#temp_goods.subtype,
				   quality = Info#temp_goods.quality,
				   sell_price = Info#temp_goods.sell_price,
				   career = Info#temp_goods.career,
				   gender = Info#temp_goods.gender,
				   level = Info#temp_goods.level,
				   bind = Bind,
				   max_num = Info#temp_goods.max_num,
				   expire_time = Info#temp_goods.expire_time,
				   suit_id = Info#temp_goods.suit_id
				  };
%% 			if
%% 				Info#temp_goods.type =:= ?GOODS_T_EQUIP ->
%% 					skip;
%% 				true -> skip
%% 			end;
		_ -> []
	end.

%% desc: 给予物品中间操作(不自动叠加)
do_give_goods_noclean(GoodsInfo, CellList, Condition, Num) ->
    [LeftList, NewCond] = replace_condtions(CellList, Condition, Num),
    % 给物品赋予玩家属性
    NewGoodsInfo = change_goods_base_fields(NewCond, GoodsInfo),
    % 添加至ETS表和数据库
    NewInfo = add_goods(NewGoodsInfo),
%%     lib_equip:add_bag_equip_stren_attr(NewInfo),
    [NewInfo, LeftList].
do_give_goods_noclean_no_insert_ets(GoodsInfo, CellList, Condition, Num) ->
    [LeftList, NewCond] = replace_condtions(CellList, Condition, Num),
    % 给物品赋予玩家属性
    NewGoodsInfo = change_goods_base_fields(NewCond, GoodsInfo),
    % 添加至ETS表和数据库
    NewInfo = add_goods(NewGoodsInfo, no_insert),
%%     lib_equip:add_bag_equip_stren_attr(NewInfo),
    [NewInfo, LeftList].

%% desc: 修改给予条件
%% returns: [LeftList, NewConditions]
replace_condtions(CellList, Condition, Num) ->
    case CellList =:= [] of
        true ->            
            case lists:keyfind(location, 1, Condition) of
                {location, _Local} ->
                    New = lists:keyreplace(location, 1, Condition, {location, ?LOCATION_MAIL}),
                    NewCond = [{num, Num}, {cell, 0} | New],
                    [[], NewCond];
                false ->
                    NewCond = [{num, Num}, {cell, 0}, {location, ?LOCATION_MAIL} | Condition],
                    [[], NewCond]
            end;
        false ->
            [Cell | Left] = CellList,
            NewCond = [{num, Num}, {cell, Cell} | Condition],
            [Left, NewCond]
    end.

%% exports
%% desc: 按条件给goods记录赋值
change_goods_base_fields([], NewInfo) ->
    NewInfo;
change_goods_base_fields([Cond | T], GoodsInfo) ->
    NewInfo = 
    case Cond of
        {num, X} -> GoodsInfo#goods{num = X};
        {cell, X} -> GoodsInfo#goods{cell = X};
        {bind, X} -> GoodsInfo#goods{bind = X};
        {uid, X} -> GoodsInfo#goods{uid = X};
        {location, X} -> GoodsInfo#goods{location = X};
        {stren_lv, X} -> GoodsInfo#goods{stren_lv = X};
        {stren_percent, X} -> GoodsInfo#goods{stren_percent = X};
        _ -> GoodsInfo
    end,
    change_goods_base_fields(T, NewInfo).        

%% desc: 添加一个物品(自动叠加)
add_goods_clean(GoodsTid, {cell_list, CellList, Condition}) when is_integer(GoodsTid) ->
    add_goods_clean({GoodsTid, 1, 0}, {cell_list, CellList, Condition});
add_goods_clean({GoodsTid, Num}, {cell_list, CellList, Condition}) ->
    add_goods_clean({GoodsTid, Num, 0}, {cell_list, CellList, Condition});
add_goods_clean({GoodsTid, Num, StrenLv}, {cell_list, CellList, OldCondition}) -> % To-Do：这块有些绕，需要重构
    case get_goods_record(GoodsTid) of
        Info when is_record(Info, goods), Num > 0 ->
            Condition = 
                case StrenLv == 0 of
                    true ->  OldCondition;
                    false -> 
                        Degree = case StrenLv > 0 of true -> ?MAX_STREN_DEGREE; false -> 0 end,
                        replace_list_elem_by_key([{stren_lv, StrenLv}, {stren_percent, Degree}], OldCondition)
                end,
            
            MaxOverlap = get_goods_overlap(GoodsTid),
            case MaxOverlap >= Num of
                true ->
                    LeftList = do_give_goods(Info, Num, Condition, CellList, MaxOverlap),
                    {cell_list, LeftList, Condition};
                false ->
                    LeftList = do_give_goods(Info, MaxOverlap, Condition, CellList, MaxOverlap),
                    add_goods_clean({GoodsTid, Num - MaxOverlap, StrenLv}, {cell_list, LeftList, Condition}) 
            end;
        _ ->
            case Num == 0 of
                true -> skip;
                false -> 
					?ERROR_MSG("badarg GoodsTid clean:~p, Num:~p, Conditions:~p", [GoodsTid, Num, OldCondition]),
					?ASSERT(false, gtid_is_zero)
            end,
            {cell_list, CellList, OldCondition}
    end;
add_goods_clean(_, {cell_list, CellList, Condition}) ->
    {cell_list, CellList, Condition}.

%% desc: 给与物品中间操作
%% returns: CellList
do_give_goods(GInfo, Num, Condition, CellList, MaxOverlap) ->
    % 给物品赋予玩家属性
    GoodsInfo = change_goods_base_fields([{num, Num} | Condition], GInfo),
    % 自动叠加
    GoodsList = get_type_goods_list(GoodsInfo#goods.uid, GoodsInfo#goods.gtid, GoodsInfo#goods.bind, GoodsInfo#goods.location),
    % 获取未满物品列表
    NoOverlapList = get_no_overlap_list(GoodsList, MaxOverlap),
    SortedList = sort(NoOverlapList, cell),
    % 自动补满物品
    add_overlap_goods_num(SortedList, GoodsInfo, MaxOverlap, CellList, GoodsInfo#goods.uid).

%% desc: 筛选未达到叠加上限的物品列表（同一种物品中选取）
get_no_overlap_list(GoodsList, MaxOverlap) ->
    lists:filter(fun(GoodsInfo) -> GoodsInfo#goods.num < MaxOverlap end, GoodsList).

%% internal
%% desc: 将元素加入列表中，有则替换，没有则添加
replace_list_elem_by_key([], List) ->
    List;
replace_list_elem_by_key([{Key, Val} | T], List) ->
    List1 = lists:keydelete(Key, 1, List),
    NewList = [{Key, Val} | List1],
    replace_list_elem_by_key(T, NewList).


%% desc: 自动补充物品数量
add_overlap_goods_num(_, GoodsInfo, _MaxOverlap, CellList, _PlayerId) when GoodsInfo#goods.num =:= 0 ->
    CellList;
add_overlap_goods_num([], GoodsInfo, _MaxOverlap, [], PlayerId) ->
    %% 没有位置可以填充物品了, 放入邮箱中
    give_goods(GoodsInfo#goods.bind, ?LOCATION_MAIL, [{GoodsInfo#goods.gtid, GoodsInfo#goods.num}], #goods_status{uid = PlayerId}),
    [];
add_overlap_goods_num([], GoodsInfo, _MaxOverlap, [Cell | LeftList], _PlayerId) ->
    case add_goods( GoodsInfo#goods{cell = Cell} ) of
        NewInfo when is_record(NewInfo, goods) ->
%%             lib_equip:add_bag_equip_stren_attr(NewInfo);
			   skip;
        _ -> skip
    end,
    LeftList;
add_overlap_goods_num([GoodsInfo | T], Info, MaxOverlap, CellList, PlayerId) ->
    Num = Info#goods.num,                                                                        
    %% 计算补充一组后，剩余的数量
    [CurGoodsNum, LeftInfo] = 
    case GoodsInfo#goods.num + Num > MaxOverlap of
        true ->            
            Lft = Info#goods{num = GoodsInfo#goods.num + Num - MaxOverlap},
            [MaxOverlap, Lft];
        false ->           
            [GoodsInfo#goods.num + Num, Info#goods{num = 0}]
    end,
    %% 修改物品数量
    change_goods_num(PlayerId, GoodsInfo, CurGoodsNum),
    add_overlap_goods_num(T, LeftInfo, MaxOverlap, CellList, PlayerId).

%% desc: 查詢背包物品綁定數量和不綁定的數量
%% returns: {Unbind, Bind}
get_bind_and_unbind_num(PS, Tid) ->
    {
     goods_util:get_bag_goods_num(PS, Tid, ?BIND_NOTYET, ?LOCATION_BAG),
     goods_util:get_bag_goods_num(PS, Tid, ?BIND_ALREADY, ?LOCATION_BAG)
    }.           


%% desc: 修改db中的 vip 数据
%% returns: NewPS
change_vip_data(PS, Time) ->
    change_vip_data(PS, PS#player.vip, Time).
change_vip_data(PS, VipLv, Time) -> 
	db:update(player, ["vip", "vip_expire_time"], [VipLv, Time], "id", PS#player.id),
	PS#player{vip = VipLv, vip_expire_time = Time}.

%% desc: 使用掉背包的一个空格
%% returns: [NewGS, OldCellList]
sub_bag_null_cell(PS, GoodsStatus, Info) ->            
    [Cell | Left] = GoodsStatus#goods_status.null_cells,
    change_goods_location_and_cell(PS, Info, ?LOCATION_BAG, Cell),
    NewGS = GoodsStatus#goods_status{null_cells = Left},
    [NewGS, [Info#goods.cell]].    


%% desc: 开启礼包
open_gift(GoodsTid, Bind) ->
	case is_login_gfit(GoodsTid) of
		true -> open_login_gift(GoodsTid);
		false ->
			case is_lv_gift(GoodsTid) of
				true -> 
					open_lv_gift(GoodsTid);
				false ->
					skip
			end	
	end.

%% desc: 是否登陆礼包
is_login_gfit(GoodsTid) ->
    get_type_and_subtype(GoodsTid) == {?GOODS_T_GIFT, 07}.

%% desc: 是否等级礼包
is_lv_gift(GoodsTid) ->
    data_goods:get_lv_gift(GoodsTid) /= [].

%% desc: 开启登陆礼包
open_login_gift(GoodsTid) ->
	ok.

%% desc: 开启等级礼包
open_lv_gift(GoodsTid) ->
    data_goods:get_lv_gift(GoodsTid).


%%  
%% desc: 在聊天框提示玩家获得了什么物品 
prompt_goods_in_chat(PlayerId, TidList) -> 
    F = fun(Tid) ->
            {T,N} = if
                        is_integer(Tid) -> {Tid, 1};
                        is_tuple(Tid) andalso erlang:tuple_size(Tid) == 2 -> Tid;
                        is_tuple(Tid) andalso erlang:tuple_size(Tid) == 3 -> {Id, Num, _} = Tid, {Id, Num};
                        true -> {0, 0}
                    end,
%%             Name = get_goods_name(T),
            case T > 0 of 
                true ->
					lib_player:display_gain_item(PlayerId, ?DISPLAY_GOODS, N, T);
%%                     Msg = Name ++ "," ++ integer_to_list(N),
%%                     lib_chat:show_info_in_channel_for_one(PlayerId, 0, Msg);
                false ->
                    skip
            end
    end,
    lists:foreach(F, TidList).

%% 提示背包满了
notice_bag_full(PlayerId) ->
	{ok, Bin} = pt_15:write(15010, []),
    lib_send:send_to_uid(PlayerId, Bin).

%% 如果材料中有绑定材料,则兑换物品为绑定状态
get_goodstid_by_material_type([], _PlayerId, GoodsTid) ->
	goods_convert:make_sure_game_tid(GoodsTid);
get_goodstid_by_material_type([{MaterialGoodsTid, _Nums} | T], PlayerId, GoodsTid) ->
	 % 判断是否有绑定物品
	case goods_util:get_bag_goods_list(PlayerId, MaterialGoodsTid, ?BIND_ALREADY) of
		[] ->	get_goodstid_by_material_type(T, PlayerId, GoodsTid);
		_ ->	goods_convert:get_goods_typeid(GoodsTid) 												   
	end.

%% function: get_type_goods_list/3
%% desc: 获取指定位置配置表类型相同的物品goods ETS表信息列表
get_type_goods_list(PlayerId, GoodsTypeId, Location) when is_integer(PlayerId) ->
	Pattern = #goods{uid=PlayerId, gtid=GoodsTypeId, location=Location, _='_' },
	lib_common:get_ets_list(?ETS_GOODS_ONLINE(PlayerId), Pattern);
get_type_goods_list(PS, GoodsTypeId, Location) ->
	PlayerId = PS#player.id,
	
	Pattern = #goods{uid=PlayerId, gtid=GoodsTypeId, location=Location, _='_' },
	lib_common:get_ets_list(?ETS_GOODS_ONLINE(PS), Pattern).

%% function: get_type_goods_list/4
get_type_goods_list(PlayerId, GoodsTypeId, Bind, Location) when is_integer(PlayerId) ->
	Pattern = #goods{ uid=PlayerId, gtid=GoodsTypeId, bind=Bind, location=Location, _='_' },
	lib_common:get_ets_list(?ETS_GOODS_ONLINE(PlayerId), Pattern);

get_type_goods_list(PS, GoodsTypeId, Bind, Location) ->
	PlayerId = PS#player.id,
	Pattern = #goods{ uid=PlayerId, gtid=GoodsTypeId, bind=Bind, location=Location, _='_' },
	lib_common:get_ets_list(?ETS_GOODS_ONLINE(PS), Pattern).

%% desc: 循环
deeploop(F, N, Data) ->
    case N > 0 of
        true ->
            [N1, Data1] = F(N, Data),
            deeploop(F, N1, Data1);
        false ->
            Data
    end.

%% desc: 给予玩家物品和金钱
%% returns: {NewPS, NewGS}
give_goods_and_money([], PS, GoodsStatus) ->
    {PS, GoodsStatus};
give_goods_and_money(GoodsList, PS, GoodsStatus) ->
    give_goods_and_money(default, ?LOCATION_BAG, GoodsList, PS, GoodsStatus).
give_goods_and_money(_BindState, _Location, [], PS, GoodsStatus) ->
    {PS, GoodsStatus};
give_goods_and_money(BindState, Location, GoodsList, PS, GoodsStatus) ->
    % 从GoodsList 中选出钱，给予玩家
    [NewPS, LeftList] = lib_money:give_role_money(GoodsList, PS, []), 
    NewGS = give_goods(BindState, Location, LeftList, GoodsStatus),
    {NewPS, NewGS}.

%% desc: 给玩家物品(在线)
%% GoodsList: [{GoodsTid, Num(,StrenLv)}, ....] 或 [GoodsTid1, GoodsTid2...], 强化等级可以不填，不填默认为0, 如果有强化等级，则默认完美度为100%
%% returns: NewGS | error | skip
give_goods(GoodsList, GoodsStatus) ->
    give_goods(?LOCATION_BAG, GoodsList, GoodsStatus).
give_goods(Location, GoodsList, GoodsStatus) ->
    give_goods(?BIND_NOTYET, Location, GoodsList, GoodsStatus).
give_goods(BindState, Location, GoodsList, GoodsStatus) -> 
    [Coin, Gold, Content] = [0, 0, "背包已满，请及时清理！"],
    give_goods(BindState, Location, GoodsList, GoodsStatus, {Content, Coin, Gold}).
give_goods(BindState, Location, GoodsList, GoodsStatus, Content) when BindState < 3; BindState == default ->  % BindState: 0-不允许绑定，1-未绑定，2-已绑定
 	give_goods(BindState, Location, GoodsList, GoodsStatus, Content, not_from_shop_goods).
give_goods(BindState, Location, GoodsList, GoodsStatus, Content, GetGoodsType) ->
    Res = lists:member(Location, [?LOCATION_BAG, ?LOCATION_TREA, ?LOCATION_MAIL, ?LOCATION_WINGS]),
    case Res == true of
        true when Location =:= ?LOCATION_MAIL ->  % 将东西放入邮箱
            goods_util:send_to_mail(GoodsList, GoodsStatus#goods_status.uid, Content),
            GoodsStatus;  
        true ->
			case Location =:= ?LOCATION_BAG of %检查背包是否满了
                true -> 
					check_bag_capacity(GoodsStatus);
                false ->
					skip
			end,
            
            % 聊天框通知玩家获得某某某物品
%%             lib_common:actin_new_proc(lib_goods, prompt_goods_in_chat, [GoodsStatus#goods_status.uid, GoodsList]),
			% 记录商城有售物品在游戏中(商城以外地方)的产出
%% 			case GetGoodsType =:= not_from_shop_goods of
%% 				true -> goods_util:log_shopgoods_output(GoodsList, Location);
%% 				false -> skip
%% 			end,
            Conditions = goods_util:recount_goods_conditions(BindState, GoodsStatus#goods_status.uid, Location),
            CellList = get_cell_list(GoodsStatus, Location),
            case give_goods_to_role(clean, GoodsList, CellList, Conditions) of
                {cell_list, NewCellList} ->
                    NewGS = replace_old_cells(GoodsStatus, NewCellList, Location),
                    NewGS;
                _Error ->
                    ?INFO_MSG("give goods failed:~p", [_Error]),
                    GoodsStatus
            end;
        false ->
            GoodsStatus
    end.

%% desc: 给予玩家物品(不进行背包整理)
%% PS: #player{}
%% GoodsStatus: #goods_status{}
%% GoodsList: [ {GoodsTid, Num}, {GoodsTid2, Num2} ... ]  注意，Num 不能超过 GoodsTid 的默认叠加上限
%% returns: {cell_list, NewCellList}  |  error
%% GoodsStatus#goods_status.null_cells
give_goods_to_role(no_clean, GoodsList, CellList, Conditions) when is_list(CellList) ->
    case lists:foldl(fun add_goods_no_clean/2, {cell_list, CellList, Conditions}, GoodsList) of
        {cell_list, LeftList, _Conditions} ->
            {cell_list, LeftList};
        Error ->
            ?ERROR_MSG("give to role failed:~p", [Error]),
            error
    end;
%% desc: 给予玩家物品(进行背包整理，即产生叠加效果)
give_goods_to_role(clean, GoodsList, CellList, Conditions) when is_list(CellList) ->
    case lists:foldl(fun add_goods_clean/2, {cell_list, CellList, Conditions}, GoodsList) of
        {cell_list, LeftList, _Conditions} ->
            {cell_list, LeftList};
        Error ->
            ?ERROR_MSG("give to role failed:~p", [Error]),
            error
    end;
give_goods_to_role(_Type, _List, _State, _Conditions) ->
    ?ERROR_MSG("give to role failed args:~p", [{_Type, _List, _State, _Conditions}]),
    error.

%% desc: 根据location选择对应的空格子编号列表
get_cell_list(GoodsStatus, Location) ->
    case Location of
        ?LOCATION_BAG ->     GoodsStatus#goods_status.null_cells;
        ?LOCATION_TREA ->     GoodsStatus#goods_status.trea_null_cells;
        ?LOCATION_MAIL ->     GoodsStatus#goods_status.mail_cells;
        ?LOCATION_WINGS ->  [1];   % 这里的1无意义，只是保证列表不为空   
        _ -> []
    end.

%% desc: 根据location修改GoodsStatus中对应的空格子编号列表
%% returns: NewGS
replace_old_cells(GoodsStatus, CellList, Location) ->
    case Location of
        ?LOCATION_BAG ->    GoodsStatus#goods_status{null_cells = CellList};
        ?LOCATION_TREA ->    GoodsStatus#goods_status{trea_null_cells = CellList};
        ?LOCATION_MAIL ->    GoodsStatus#goods_status{mail_cells = CellList};
        ?LOCATION_WINGS ->  GoodsStatus;   % 这里的1无意义，只是保证列表不为空
        % 其余的可以在此处加上
        % todo
        
        _ -> GoodsStatus
    end.

%%检查背包是否满了，满了就提示
check_bag_capacity(GoodsStatus) ->
	case GoodsStatus#goods_status.null_cells =:= [] of
		true ->
			notice_bag_full(GoodsStatus#goods_status.uid),
			ok;
		false ->
			fail
	end.

%% desc: 增加物品的属性
add_goods_attri_type(PS, Gid, AttriType, StoneTid, AtrriId, Val, ValueType, HoleSeq) ->
	GoodsAtrriInfo = #goods_attribute{
									  uid = PS#player.id,
									  gid = Gid,
									  attribute_type = AttriType,
									  stone_type_id = StoneTid,
									  attribute_id = AtrriId,
									  value = Val,
									  value_type = ValueType,
									  hole_seq = HoleSeq,
									  status = 1
									  },
    case db_agent_goods:insert_get_id(GoodsAtrriInfo) of
        InsertId when is_integer(InsertId), InsertId > 0 ->
            ets:insert(?ETS_GOODS_ATTRIBUTE(PS), GoodsAtrriInfo#goods_attribute{id = InsertId});
        _Error ->
            ?ERROR_MSG("add new attri failed:~p", [_Error]),
            skip
    end.