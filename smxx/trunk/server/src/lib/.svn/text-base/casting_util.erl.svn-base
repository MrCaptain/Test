%% Author: Administrator
%% Created: 2013-2-20
%% Description: TODO: Add description to casting_util
-module(casting_util).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("goods.hrl").
-include("debug.hrl").
-include("goods_record.hrl").
-include("log.hrl"). 

-define(MAX_STREN_STAR, 10). % 最大强化星级
%%
%% Exported Functions
%%
-compile(export_all).

%% 检查强化条件
check_strengthen(PS, [GoodsId, FirstUseFlag, AutoBuy, Type]) ->
    GoodsInfo = goods_util:get_goods(PS, GoodsId),
    CheckChooseList = [{bindfirst, FirstUseFlag}, {autobuy, AutoBuy}],
    Result = is_input_choose_legal(CheckChooseList, legal),
    if
        % 失败
        is_record(GoodsInfo, goods) =:= false orelse Result =/= legal ->
            {fail, ?RESULT_FAIL};
        GoodsInfo#goods.uid =/= PS#player.id orelse GoodsInfo#goods.type =/= ?GOODS_T_EQUIP ->
            {fail, ?RESULT_FAIL};
        GoodsInfo#goods.location =/= ?LOCATION_PLAYER
%%            andalso GoodsInfo#goods.location =/= ?LOCATION_PET
              andalso GoodsInfo#goods.location =/= ?LOCATION_BAG ->
            {fail, ?RESULT_FAIL};
        true ->
            MaxStrenLv = lib_goods:get_max_strenlv(GoodsInfo#goods.gtid), 
            Stren = GoodsInfo#goods.stren_lv,
            StrenPercent = GoodsInfo#goods.stren_percent / 100,
            GoodsStrenInfo = tpl_stren:get(?MAX_STREN_STAR * (Stren + StrenPercent)),
            if
                GoodsStrenInfo == [] ->
                    {fail, ?RESULT_FAIL};
                GoodsInfo#goods.stren_lv == MaxStrenLv andalso GoodsInfo#goods.stren_percent == ?MAX_STREN_DEGREE ->
                    {fail, 4};   % 强化已达上限
                true ->
					StoneInfo = lists:nth(1, GoodsStrenInfo#temp_stren.goods),
    				{StoneId, _StoneNum} = StoneInfo,
                    {SBindnum, SUbindnum} = get_bind_and_unbind(PS#player.id, StoneId),                
                    case Type of
                        1 -> loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, [{0, 0}, 0], {SBindnum, SUbindnum}, []);   % 最高强化
                        _ -> loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, {SBindnum, SUbindnum}, [])   % 单次强化
                    end
            end
    end.

%% desc: 单次强化
loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, {SBind, SUbind}, Cost) ->
	% 检查使用强化石
	case check_stren_stone(GoodsStrenInfo, AutoBuy, (SBind + SUbind)) of
		{fail, Res1} ->   {fail, Res1};		
		{ok, StonenumTuple} ->
			% 检查强化费用
			case check_stren_cost(PS, GoodsStrenInfo, StonenumTuple, Cost) of
				{fail, Res2} ->     {fail, Res2};
				{ok,  CostList} ->  
					% 计算本次强化随机完美度
					Rand = util:rand(1, ?MAX_STREN_RAND),
					NextDegree = 
						case Rand =< GoodsStrenInfo#temp_stren.stren_rate of
							true ->
								[MinStar, MaxStar] = GoodsStrenInfo#temp_stren.stren_succ,
								AddRandStar = util:rand(MinStar, MaxStar),
								GoodsInfo#goods.stren_percent + AddRandStar;
							false ->
								[MinStar, MaxStar] = GoodsStrenInfo#temp_stren.stren_fail,
								SubRandStar = util:rand(MinStar, MaxStar),
								max((GoodsInfo#goods.stren_percent - SubRandStar), 0)
						end,
				{ok, ?RESULT_OK, StonenumTuple, CostList, NextDegree, GoodsInfo, GoodsStrenInfo}
			end
	end.

%% desc: 循环强化
loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, [STtuple, LastDegree], {SBind, SUbind}, CostList) ->
	if
		GoodsInfo#goods.stren_percent < ?MAX_STREN_DEGREE andalso LastDegree < ?MAX_STREN_DEGREE ->
			 case loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, {SBind, SUbind}, CostList) of
                {fail, Res} ->   % 此次强化条件不足
                    {ok, Res, STtuple, CostList, LastDegree, GoodsInfo, GoodsStrenInfo};
                {ok, _Res, StonenumTuple, CostList1, NewDegree, GoodsInfo, GoodsStrenInfo} ->
                    NewClist = CostList1,
                    STtuple1 = calc_total_cost_num(STtuple, StonenumTuple),
                    {SBind1, SUbind1} = calc_left_rune_and_stone_num(FirstUseFlag, StonenumTuple, {SBind, SUbind}),
                    loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, [STtuple1, NewDegree], {SBind1, SUbind1}, NewClist)
            end;
		GoodsInfo#goods.stren_percent =:= ?MAX_STREN_DEGREE andalso LastDegree > ?MAX_STREN_DEGREE ->
            case loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, {SBind, SUbind}, CostList) of
                {fail, Res} ->   % 此次强化条件不足
                    {ok, Res, STtuple, CostList, LastDegree, GoodsInfo, GoodsStrenInfo};
                {ok, _Res, StonenumTuple, CostList1, NewDegree, GoodsInfo, GoodsStrenInfo} ->
                    NewClist = CostList1,
                    STtuple1= calc_total_cost_num(STtuple, StonenumTuple),
                    {SBind1, SUbind1} = calc_left_rune_and_stone_num(FirstUseFlag, StonenumTuple, {SBind, SUbind}),
                    loop_stren_to_maxhis(PS, GoodsInfo, GoodsStrenInfo, FirstUseFlag, AutoBuy, [STtuple1, NewDegree], {SBind1, SUbind1}, NewClist)
            end;
        true ->   % 不用最高强化
            {ok, ?RESULT_OK, STtuple, CostList, LastDegree, GoodsInfo, GoodsStrenInfo}
    end.

%% internal
%% desc: 累计本次强化和以前强化的强化石和完美符的消耗数量
calc_total_cost_num(STtuple, StonenumTuple) ->
    {Sauto1, Snum1} = STtuple,
    {Sauto2, Snum2} = StonenumTuple,
    NewSTuple = {Sauto1 + Sauto2, Snum1 + Snum2},  
    NewSTuple.

%% desc: 计算剩余存在背包中的强化石的数量
calc_left_rune_and_stone_num(FirstUseFlag, [{_Sauto, Snum}, Rnum], {SBind, SUbind}) ->
    case FirstUseFlag of
        ?BIND_FIRST ->
            Sbdiff = SBind - Snum,
            Sudiff = min(Sbdiff, 0) + SUbind,
            case Sudiff < 0 of
               true -> ?ERROR_MSG("failed to calc:~p", [ {[{_Sauto, Snum}, Rnum], {SBind, SUbind}} ]);
               false -> skip
            end,
             {max(Sbdiff, 0), max(Sudiff, 0)};
        _ ->
			Sudiff = SUbind - Rnum,
			Sbdiff = min(Sudiff, 0) + SBind,			
            case Sbdiff < 0 of
               true -> ?ERROR_MSG("failed to calc:~p", [ {[{_Sauto, Snum}, Rnum], {SBind, SUbind}} ]);
               false -> skip
            end,
             { max(Sbdiff, 0), max(Sudiff, 0) }
    end.

%% desc: {bindlistnum, unbindlistnum}
get_bind_and_unbind(PlayerId, GoodsTid) ->
    {
     goods_util:get_bag_goods_num(PlayerId, GoodsTid, ?BIND_ALREADY, ?LOCATION_BAG),
     goods_util:get_bag_goods_num(PlayerId, GoodsTid, ?BIND_ANY, ?LOCATION_BAG)
     }.

%% desc: 检查使用强化石
%% returns: {fail, Num} | {ok, {AutoBuyNum, Num}}
check_stren_stone(GoodsStrenInfo, AutoBuy, StoneNum) ->
	StoneInfo = lists:nth(1, GoodsStrenInfo#temp_stren.goods),
    {_, CostStoneNum} = StoneInfo#temp_stren.goods,
    case StoneNum < CostStoneNum of
        true ->
            case AutoBuy of
                ?AUTO_BUY_YES ->  {ok,  {CostStoneNum - StoneNum, StoneNum}};   % 此处表示有自动购买
                ?AUTO_BUY_NO ->   {fail, 5}   % 强化石不足
            end;
        false -> 
            {ok, {0, StoneNum}}
    end.

%% desc: 检查强化费用
check_stren_cost(PS, GoodsStrenInfo, {AutoStnum, _Stonenum}, Cost) ->
	StoneInfo = lists:nth(1, GoodsStrenInfo#temp_stren.goods),
    [{StoneTid, _}, {CoinTid, CoinCost}] = StoneInfo,
    YBcost = case AutoStnum > 0 of
                 true -> 
                     {Gold, _} = lib_shop:get_goods_price(StoneTid),
                     Gold * AutoStnum;
                 false -> 0
             end,
    F1 = fun({Cost1, Type}, List) ->
                 case lists:keyfind(Type, 2, List) of
                     {Tcost, Type} -> lists:keyreplace(Type, 2, List, {Tcost + Cost1, Type});
                     false -> [{Cost1, Type} | List]
                 end
         end,
    CostList = lists:foldl(F1, Cost, [{YBcost, ?MONEY_T_BGOLD}, {CoinCost, ?MONEY_T_BCOIN}]),
    case lib_money:can_pay(PS, CostList) of
        false ->   {fail, 3}; % 玩家金钱不足
        true ->    {ok, CostList}
    end.

%% 强化装备
stren_equip(PlayerStatus, GoodsStatus, CheckResult) ->
    [{AutoBuyStoneNum, Snum}, CostList, Degree, GoodsInfo, GoodsStrenInfo, FirstUseFlag] = CheckResult,
    % 扣除本次强化消耗掉的材料 和 钱
    NewPS = cost_stren_money(PlayerStatus, CostList),
    NewGS = cost_stren_material(GoodsStrenInfo, NewPS, GoodsStatus, Snum, FirstUseFlag),
    % 装备强化属性处理
    NewInfo = handle_stren_attri(NewPS, GoodsInfo, Degree, GoodsStrenInfo, normal),
    F = fun({COST, CT}, {Ctype, Num}) -> 
                case CT == Ctype of
                    true -> {Ctype, Num + COST};
                    false ->{Ctype, Num}
                end
        end,
    {_, GoldCost} = lists:foldl(F, {gold, 0}, CostList),
    {_, CoinCost} = lists:foldl(F, {coin, 0}, CostList),

%%  lib_equip:calc_equip_value(NewPS, NewInfo),
%%  mod_log:log_stren(GoodsInfo, CoinCost, GoldCost, GoodsInfo#goods.stren, NewInfo#goods.stren),
    ?TRACE("coin:~p, GoldCost:~p, AutoBuyStoneNum:~p Snum:~p ~n", [CoinCost, GoldCost, AutoBuyStoneNum, Snum]),
    {ok, ?RESULT_OK, NewGS, NewPS, NewInfo#goods.stren_lv, NewInfo#goods.stren_percent, (AutoBuyStoneNum + Snum), CoinCost, GoldCost}.

%% internal
%% desc: 强化属性处理
handle_stren_attri(PS, GoodsInfo, Degree, GoodsStrenInfo, Type) ->
    % 改变装备的强化属性记录
    NewInfo = change_goods_stren_data(PS, GoodsInfo, Degree, GoodsStrenInfo),
    % 改变装备的属性
    change_stren_attr_record(PS, GoodsInfo#goods.stren_lv, NewInfo, Type),
    NewInfo.

%% desc: 改变物品的记录中强化的信息
change_goods_stren_data(PS, GoodsInfo, NextDegree, GoodsStrenInfo) ->
	{NewStrenLv, NewStrenDegree} =
		case NextDegree > ?MAX_STREN_DEGREE of
			true -> {GoodsInfo#goods.stren_lv + 1, NextDegree - ?MAX_STREN_DEGREE - ?LEVEL_STREN_DEGREE};
			false -> {GoodsInfo#goods.stren_lv, NextDegree}
		end,
	Holes = get_stren_add_holes(GoodsInfo, NewStrenLv, GoodsStrenInfo),
    NewInfo = GoodsInfo#goods{stren_lv = NewStrenLv, stren_percent = NewStrenDegree, hole = Holes},
    lib_common:actin_new_proc(lib_casting, change_goods_stren_fields, [PS, NewInfo]),
    NewInfo.

%% desc: 计算强化插槽加成
get_stren_add_holes(GoodsInfo, NewStrenLv, GoodsStrenInfo) ->
	case GoodsInfo#goods.stren_lv < NewStrenLv of
		true ->
			case tpl_equipment:get(GoodsInfo#goods.gtid) of
				EquipInfo when is_record(EquipInfo, temp_item_equipment) ->
					GoodsInfo#goods.hole + GoodsStrenInfo#temp_stren.add_holes;
				_ -> GoodsInfo#goods.hole
			end;
		false -> GoodsInfo#goods.hole
	end.

%% desc: 改变装备的属性    
change_stren_attr_record(PS, OldStren, GoodsInfo, Type) ->
	ok.
%%     AttrList = lib_attribute:make_equip_base_attri_list(GoodsInfo),
%%     case Type of
%%         award ->   % 奖励强化物品
%%             case OldStren > 0 of
%%                 true ->   lib_casting:add_new_stren_attr(PS, GoodsInfo, AttrList);
%%                 false ->  skip
%%             end;
%%         normal ->   % 普通强化类型
%%             case OldStren == 0 of
%%                 true -> lib_casting:add_new_stren_attr(PS, GoodsInfo, AttrList);
%%                 false ->lib_casting:change_stren_attr(PS, GoodsInfo, AttrList)
%%             end
%%     end,
%%     % 额外属性处理
%%     lib_casting:handle_stren_extra_award_attr(GoodsInfo, OldStren, GoodsInfo#goods.stren_lv, Type).

%% desc: 扣除强化花费的费用
%% returns: NewPS
cost_stren_money(PlayerStatus, CostList) ->
    F = fun({Cost, Type}, PS) -> lib_money:cost_money(statistic, PS, Cost, Type, ?LOG_STREN) end, 
    lists:foldl(F, PlayerStatus, CostList).

%% desc: 扣除强化消耗的材料
cost_stren_material(GoodsStrenInfo, PS, GoodsStatus, Snum, FirstUseFlag) ->
    PlayerId = PS#player.id,    
	StoneInfo = lists:nth(1, GoodsStrenInfo#temp_stren.goods),
    {StoneTid, _StoneNum} = StoneInfo,
	{CostGoodsList1, CostGoodsList2} = get_band_unbind_goods(PlayerId, FirstUseFlag, StoneTid, Snum),
	StoneList = CostGoodsList1 ++ CostGoodsList2,
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, StoneList, Snum, ?LOG_STREN_GOODS),
    NewGS.

%% 洗练
polish(PS, GS, Stone, LockList, UseLockNum, GoodsInfo, GoldPrice, CoinPrice, IdList) ->
    PolishTuple = calc_polish_attri_tuple(PS, GoodsInfo, IdList),
    % 扣除洗炼铸造花费铜钱 
    PS1 = lib_money:cost_money(statistic, PS, CoinPrice, ?MONEY_T_BCOIN , ?LOG_POLISH),
    NewPstatus = 
		case GoldPrice > 0 of
			true ->	lib_money:cost_money(statistic, PS1, GoldPrice, ?MONEY_T_GOLD, ?LOG_POLISH);
			false -> PS1
		end,
    % 扣除洗炼材料
    NewState = del_polish_material(PS, GS, Stone, LockList, UseLockNum),
    % 将该属性放置于洗炼新列表中
    PolishType = save_calc_attris(PS, GoodsInfo, PolishTuple, IdList),
    % 改变洗炼状态
%%     change_polish_state(GoodsInfo),
   
    % 日志记录
%%     mod_log:log_polish(GoodsInfo, CoinCost, Price, Stone, PolishTuple),
    {ok, NewPstatus, NewState, PolishType}.

%% 装备洗炼检查
check_polish(PS, GoodsId, BindFirst, AutoBuy, AutoLock, IdList) ->
    Result = is_input_choose_legal([{bindfirst, BindFirst}, {autobuy, AutoBuy}, {autobuy, AutoLock}], legal),
    Result1 = (IdList == lists:filter(fun(Id) -> Id > 0 end, IdList)),
    GoodsInfo = goods_util:get_goods(PS, GoodsId),
    if
        % 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, 2};
        % 物品不属于你所有
        GoodsInfo#goods.uid =/= PS#player.id ->
            {fail, 3};
        % 物品位置不正确
        GoodsInfo#goods.location =/= ?LOCATION_PLAYER 
%%           andalso GoodsInfo#goods.location =/= ?LOCATION_PARTNER
            andalso GoodsInfo#goods.location =/= ?LOCATION_BAG ->
            {fail, 4};
        % 物品类型不正确
        GoodsInfo#goods.type =/= ?GOODS_T_EQUIP ->
            {fail, 5}; 
        % 参数错误
        Result =/= legal ->
            {fail, 6};
        Result1 =:= false ->
            {fail, 6};
        true ->
            check_polish_step_stone(PS, GoodsInfo, BindFirst, AutoBuy, AutoLock, IdList)
    end.

%% desc: 第一步检查洗炼石是否满足条件
check_polish_step_stone(PS, GoodsInfo, FirstUseFlag, AutoBuy, AutoLock, IdList) ->
    case get_polish_stone(GoodsInfo, FirstUseFlag, AutoBuy) of
        {} -> % 洗炼石不足
            {fail, 8}; 
        Stone ->
            check_polish_step_lock(PS, GoodsInfo, FirstUseFlag, AutoLock, Stone, IdList)
    end.

%% desc: 第二步检查洗炼锁是否满足条件
check_polish_step_lock(PS, GoodsInfo, FirstUseFlag, AutoLock, Stone, IdList) ->
    NeedLockNum = length(IdList),
    StonePrice = get_polish_stone_price(Stone),
    case get_polish_lock(GoodsInfo, FirstUseFlag, AutoLock, NeedLockNum) of
        [] when NeedLockNum > 0 -> % 洗炼锁不足
            {fail, 10};
        Other ->
            check_polish_cost_enough(PS, GoodsInfo, Other, NeedLockNum, StonePrice, Stone, IdList)
    end.

%% desc: 第三步检查洗炼费用是否足够
check_polish_cost_enough(PS, GoodsInfo, Other, NeedLockNum, StonePrice, Stone, IdList) ->
    [GoldPrice, LockList, UseLockNum] = 
        case Other of
            [{autobuy, LockTid, Num} | List] ->
                {Price, _PriceType} = lib_shop:get_goods_price(LockTid),
                TotalPrice = Price * Num + StonePrice,
                [TotalPrice, List, NeedLockNum - Num];
            List ->
                [StonePrice, List, NeedLockNum]
        end,
    CoinPrice = 0,
    case lib_money:can_pay(PS, [{GoldPrice, ?MONEY_T_GOLD}, {CoinPrice, ?MONEY_T_BCOIN}]) of
        false ->   % 玩家金钱不足 
            {fail, 7};
        true ->
%%             lib_achievement:do(shuffle,  {GoodsInfo#goods.color, 1}, PS),
            {ok, Stone, LockList, UseLockNum, GoodsInfo, GoldPrice, CoinPrice, IdList}
    end.

%% desc: 查询购买洗炼石的信息
get_polish_stone(GoodsInfo, FirstUseFlag, AutoBuy) ->
	case tpl_polish_goods:get(GoodsInfo#goods.quality) of
		PolishGoodsInfo when is_record(PolishGoodsInfo, temp_polish_goods) ->
		    StoneTid = PolishGoodsInfo#temp_polish_goods.goods,
		    case get_by_bind_choose(GoodsInfo#goods.uid, StoneTid, FirstUseFlag) of
		        {} ->
		            case AutoBuy of
		                ?AUTO_BUY_NO ->  {};
		                ?AUTO_BUY_YES -> {autobuy, StoneTid}
		            end;
		        Info -> Info
		    end;
		_ -> {}
	end.


%% desc: 查询需要多少个洗炼锁
%% returns: integer()
get_need_locknum(List) ->
    F = fun({_SeqId, _AttriId, _polishLv, _Val, IsLock}, Sum) ->
                case IsLock =:= ?WASH_LOCK of
                    true -> Sum + 1;
                    false -> Sum
                end
        end,
    lists:foldl(F, 0, List).


%% desc: 检查洗炼锁
get_polish_lock(GoodsInfo, FirstUseFlag, AutoBuy, NeedLockNum) ->
    LockTid = data_casting:wash_lock_tid(),
    List = get_list_by_bind_choose(GoodsInfo#goods.uid, LockTid, FirstUseFlag),
    CurNum =  lib_goods:calc_goodslist_total_nums(List),
    case CurNum >= NeedLockNum of
        true -> List;
        false ->
            case AutoBuy of
                ?AUTO_BUY_NO ->  [];
                ?AUTO_BUY_YES -> [{autobuy, LockTid, NeedLockNum - CurNum} | List]
            end
    end.
    

%% desc: 查询洗炼石价格
get_polish_stone_price(Stone) when is_record(Stone, goods) ->
    0;
get_polish_stone_price({autobuy, StoneTid}) ->
    {Price, _PriceType} = lib_shop:get_goods_price(StoneTid),
    Price.
    
%% 洗炼替换
replace_equip_polish_attri(PS, GoodsId) ->
	case get_polish_info(PS, GoodsId) of
		{} ->   
			{fail, 2};   % 物品无可替换属性
		Info ->
			if
				Info#casting_polish.uid =/= PS#player.id ->
					{fail, 3};   % 装备不是你的
				Info#casting_polish.new_attri == [] ->
					{fail, 2};   % 无可替换属性
				true ->
					NewAttri = Info#casting_polish.new_attri,
					NewInfo = Info#casting_polish{cur_attri = NewAttri, new_attri = []},
					lib_casting:update_db_polish_attri(NewInfo),
					lib_common:insert_ets_info(?ETS_CASTING_POLISH(PS), NewInfo),
					ok
			end,
			ok
	end.

%% returns: {} | #goods{}
%% get_info_by_bind_choose(PlayerId, GoodsTid, FirstUseFlag) ->
%%     case FirstUseFlag of
%%         ?UNBIND_FIRST ->  get_by_bind_choose(PlayerId, GoodsTid, ?UNBIND_FIRST);
%%         ?BIND_FIRST ->    get_by_bind_choose(PlayerId, GoodsTid, ?BIND_FIRST);
%%         _ ->	{}
%%     end.

%% desc: 
%% returns: {} | #goods{}
get_list_by_bind_choose(PlayerId, GoodsTid, FirstUseFlag) ->
    case FirstUseFlag of
        ?UNBIND_FIRST ->  get_list_by_choose(PlayerId, GoodsTid, ?UNBIND_FIRST);
        ?BIND_FIRST ->    get_list_by_choose(PlayerId, GoodsTid, ?BIND_FIRST);
        _ ->                    []
    end.

%% internal
%% desc: 根据是否选择绑定材料查询物品信息
%% returns: {} | #goods{}
get_by_bind_choose(PlayerId, GoodsTid, BindChoose) ->
    case BindChoose of
        ?UNBIND_FIRST ->
            goods_util:get_min_cell_info(PlayerId, GoodsTid, ?BIND_ANY);
        ?BIND_FIRST ->
            case goods_util:get_min_cell_info(PlayerId, GoodsTid, ?BIND_ALREADY) of
                {} ->
                    goods_util:get_min_cell_info(PlayerId, GoodsTid, ?BIND_ANY);
                Info ->
                    Info
            end;
        Error ->
            ?ERROR_MSG("bad arg bindchoose:~p, error:~p", [BindChoose, Error]),
            ?ASSERT(false),
            {}
    end.
%% desc: 根据是否选择绑定材料查询物品信息
%% returns: [] | List
get_list_by_choose(PlayerId, GoodsTid, BindChoose) ->
    case BindChoose of
        ?UNBIND_FIRST ->
            goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ANY);
        ?BIND_FIRST ->
            Blist = goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY),
            UnBlist = goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ANY),
            Blist ++ UnBlist;
        Error ->
            ?ERROR_MSG("bad arg bindchoose:~p, error:~p", [BindChoose, Error]),
            ?ASSERT(false),
            []
    end.

%% desc: 计算本次洗炼的结果元组
%% @returns: [{attriId, lv, val},...]
calc_polish_attri_tuple(PS, GoodsInfo, IdList) ->
	% 根据装备的品质，计算出洗炼属性最大条数
	AlreadyLen = length(IdList),
	case tpl_polish_goods:get(GoodsInfo#goods.quality) of
		PolishGoodsInfo when is_record(PolishGoodsInfo, temp_polish_goods) ->
			MaxPolishNum = PolishGoodsInfo#temp_polish_goods.max_polish,
			PolishNum = max(0, (MaxPolishNum - AlreadyLen)),
			PolishTempInfo = tpl_polish:get(GoodsInfo#goods.gtid),
			if
				?MAX_POLISH_NUM < PolishNum -> [];
				is_record(PolishTempInfo, temp_polish) =:= false -> [];
				true ->
					% 随机取PolishNum条属性
					TotalPolishNum = length(PolishTempInfo#temp_polish.polish_value),
					calc_polish_result_tuple(PolishTempInfo#temp_polish.polish_value, TotalPolishNum, PolishNum, [])
			end;
		_ -> []
	end.

%% desc: 计算洗炼结果
%% returns: [{AttriId, WashLv, Val}...]
calc_polish_result_tuple(AllPolishAtrri, TotalPolishNum, PolishNum, Result) -> 
	case PolishNum > 0 of
		true ->
		    % 随机获取一个洗炼属性
		    Random = util:rand(1, TotalPolishNum),
			PolishAtrriInfo = lists:nth(Random, AllPolishAtrri),
			PolishAtrriTuple = get_polish_atrri_tuple(PolishAtrriInfo),
			calc_polish_result_tuple(AllPolishAtrri, TotalPolishNum, PolishNum, PolishAtrriTuple ++ Result);
		false -> Result
	end.

%% 获取洗练属性元组
get_polish_atrri_tuple({Atrrikey, MinRandVal, MaxRandVal, PolishStar}) ->
	% 随机获取一个洗炼属性
	PolishVal = util:rand(MinRandVal, MaxRandVal),
	case PolishVal of
		hit_point_max ->              % 生命上限	
			[{?HIT_POINT_MAX, PolishVal, PolishStar}];
		magic_max ->                  % 法力值上限	
			[{?MAGIC_MAX, PolishVal, PolishStar}];              
		attack ->                     % 普通攻击力	
			[{?ATTACK, PolishVal, PolishStar}];            
		defense ->                    % 普通防御力
			[{?FATTACK, PolishVal, PolishStar}];             
		fattack ->                    % 仙攻值
			[{?MATTACK, PolishVal, PolishStar}];              
		mattack ->                    % 魔攻值	
			[{?DATTACK, PolishVal, PolishStar}];             
		dattack ->                    % 妖攻值
			[{?DEFENCE, PolishVal, PolishStar}];             
		fdefense ->                   % 仙防值
			[{?FDEFENCE, PolishVal, PolishStar}];
		mdefense ->                   % 魔防值
			[{?MDEFENCE, PolishVal, PolishStar}];          
		ddefense ->                   % 妖防值
			[{?DDEFENCE, PolishVal, PolishStar}];
		_ -> []
	end.
		
%% desc: 扣除洗炼材料
del_polish_material(PS, GS, Stone, LockList, UseLockNum) ->
    GS1 = del_polish_stone({PS, GS}, Stone),
    GS2 = del_polish_lock({PS, GS1}, LockList, UseLockNum),
    GS2.

%% function: del_wash_stone/2
%% desc: 扣除洗炼石
del_polish_stone({_PS, GS}, {autobuy, _}) -> GS;
del_polish_stone({PS, GS}, Stone) ->
    {ok, NewStatus, _} = lib_goods:delete_one(PS, GS, Stone, 1, ?LOG_POLISH_GOODS),
    NewStatus.

%% desc: 扣除洗炼锁
del_polish_lock({_PS, GS}, _LockList, 0) -> GS;
del_polish_lock({PS, GS}, LockList, UseLockNum) ->
    {ok, GS1} = lib_goods:delete_more({PS, GS}, LockList, UseLockNum, ?LOG_POLISH_GOODS),
    GS1.

%% desc: 保存新的洗炼属性
%% save_calc_attris(GoodsInfo, [{AttriId, Lv, Val} | Left]) ->
save_calc_attris(PS, GoodsInfo, List, IdList) ->
    case lib_casting:get_polish_info(PS, GoodsInfo#goods.id) of
        {} ->     save_in_polish_cur_attri(PS, GoodsInfo, List);
        Info ->  save_in_polish_new_attri(PS, Info, List, IdList)
    end.

%% desc: 保存入当前洗炼结果中
%% returns: cur_attri
save_in_polish_cur_attri(PS, GoodsInfo, List) ->
    F = fun({AttriId, Lv, Val}, [Num, ResList]) ->
                NewList = [{Num, AttriId, Lv, Val, ?WASH_UNLOCK} | ResList],
                [Num + 1, NewList]
        end,
    [_, CurAttri] = lists:foldl(F, [1, []], List),
    Info = #casting_polish{
                     gid = GoodsInfo#goods.id,
                     uid = GoodsInfo#goods.uid,
                     cur_attri = CurAttri
                              },
    lib_casting:insert_db_polish_attri(Info),
    lib_common:insert_ets_info(?ETS_CASTING_POLISH(PS), Info),
    cur_attri.

%% desc: 保存入新的洗炼结果中
%% returns: new_attri
save_in_polish_new_attri(PS, AttriInfo, List, IdList) ->
    F = fun({AttriId, Lv, Val}, [Num, ResList]) ->
                NewList = [{Num, AttriId, Lv, Val, ?WASH_UNLOCK} | ResList],
                [Num + 1, NewList]
        end,
    [_, NewAttri1] = lists:foldl(F, [1, []], List),
    {CurAttri, NewAttri} = add_lock_attri(AttriInfo#casting_polish.cur_attri, {[], NewAttri1}, IdList),
    NewInfo = AttriInfo#casting_polish{cur_attri = CurAttri, new_attri = NewAttri},
    lib_casting:update_db_polish_attri(NewInfo),
    lib_common:insert_ets_info(?ETS_CASTING_POLISH(PS), NewInfo),
    new_attri.
 
%% desc: 补充锁上的属性
add_lock_attri([], {CurAttri, NewAttri}, _IdList) ->
    {lists:reverse(CurAttri), NewAttri};
add_lock_attri([{SeqId, AttriId, WashLv, Val, _IsLock} | T], {CurList, NewList}, IdList) ->
    case lists:member(SeqId, IdList) of
        true ->  % 当前洗炼属性在新的列表中有则加锁
            NewSeq = length(NewList) + 1,
            NewAttri = [{NewSeq, AttriId, WashLv, Val, ?WASH_LOCK} | NewList],
            CurAttri = [{SeqId, AttriId, WashLv, Val, ?WASH_LOCK} | CurList],
            add_lock_attri(T, {CurAttri, NewAttri}, IdList);
        false ->   % 没有则解锁
            CurAttri = [{SeqId, AttriId, WashLv, Val, ?WASH_UNLOCK} | CurList],
            add_lock_attri(T, {CurAttri, NewList}, IdList)
    end.

%% desc: 查询装备的洗炼属性
get_polish_attri(PS, GoodsId) when is_integer(GoodsId) ->
    case goods_util:get_goods(PS, GoodsId) of
        GoodsInfo when is_record(GoodsInfo, goods) ->
            get_polish_attri(PS, GoodsInfo);
        _ -> {[], []}
    end;
get_polish_attri(PS, GoodsInfo) ->
    case get_polish_info(PS, GoodsInfo#goods.id) of
        {} ->
            {[], []};
        AttriInfo ->
            {AttriInfo#casting_polish.cur_attri, AttriInfo#casting_polish.new_attri}
    end.

%% desc: 查询装备的洗炼属性
get_polish_info(PS, GoodsId) ->
    lib_common:get_ets_info(?ETS_CASTING_POLISH(PS), GoodsId).

%% Local Functions
get_goodslist(PlayerId, GoodsTid, ?BIND_ALREADY) ->
    goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY);
get_goodslist(PlayerId, GoodsTid, ?BIND_ANY) ->
    goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ANY);
get_goodslist(PlayerId, GoodsTid, all) ->
    goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY) ++
        goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ANY).

%% 按顺序获取背包绑定和非绑定物品列表
get_band_unbind_goods(PlayerId, FirstUseFlag, GoodsTid, GetNum) ->
	UnBindGoodsTid = goods_util:goods_bind_to_unbind(GoodsTid),
	case FirstUseFlag of
		?UNBIND_FIRST ->
			UnBindGoodsList = goods_util:get_bag_goods_list(PlayerId, UnBindGoodsTid, ?BIND_ANY),
			case length(UnBindGoodsList) >= GetNum of
				true -> {UnBindGoodsList, []};
				false -> {UnBindGoodsList, goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY)}
			end;
		?BIND_FIRST ->
			BindGoodsList = goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY),
			case length(BindGoodsList) >= GetNum of
				true -> {BindGoodsList, []};
				false -> {BindGoodsList, goods_util:get_bag_goods_list(PlayerId, UnBindGoodsTid, ?BIND_ANY)}
			end
	end.

%% desc: 检查输入选择是否合法
is_input_choose_legal([], Res) ->
	Res;
is_input_choose_legal([ {Flag, H} | T ], Res) ->
	if
		Flag =:= bindfirst ->	
			get_check_result(?BIND_FIRST_MAX, H, T, Res);
		Flag =:= autobuy ->	
			get_check_result(?AUTO_BUY_MAX, H, T, Res);
		Flag =:= userune ->	
			get_check_result(?USE_RUNE_MAX, H, T, Res);
		true ->	
			illegal
	end.

%% desc: 计算检查结果
get_check_result(Max, H, T, Res) ->	
	if
		H > Max orelse H < 0 ->   
			is_input_choose_legal([], illegal);
		true ->                        
			is_input_choose_legal(T, Res)
	end.

%% 宝石镶嵌检查
check_inlay(PlayerStatus, GoodsId, StoneIdList) ->
    GoodsInfo = goods_util:get_goods(PlayerStatus, GoodsId),
	if
        % 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, 2};
        % 物品不属于你所有
        GoodsInfo#goods.uid =/= PlayerStatus#player.id ->
            {fail, 3};
        % 物品位置不正确
        GoodsInfo#goods.location =/= ?LOCATION_BAG
						andalso GoodsInfo#goods.location =/= ?LOCATION_PLAYER ->
            {fail, 4};
        % 非装备不能镶嵌
        GoodsInfo#goods.type =/= ?GOODS_T_EQUIP ->
            {fail, 5};
		% 职业不对
        GoodsInfo#goods.career =/= PlayerStatus#player.career andalso  GoodsInfo#goods.career =/= ?CAREER_ANY ->
            {fail, 14};
		true ->
			HoleStones = goods_util:get_goods_hole_stone_tid(GoodsInfo),
			if
				% 没有孔位
				GoodsInfo#goods.hole =:= 0 ->	{fail, 6};
				% 镶嵌宝石数量不对
				length(StoneIdList) + length(HoleStones) > GoodsInfo#goods.hole ->	{fail, 7};
				true ->
					case check_stoneinfo_list(PlayerStatus, StoneIdList, HoleStones) of
						{ok, StoneInfoList} ->
							case check_inlay_rule_list(StoneInfoList, 0) of
						        {fail, Res1} ->	{fail, Res1};
								{ok, Cost} ->
                                    case lib_money:has_enough_money(PlayerStatus, Cost, ?MONEY_T_BCOIN) of
                                        false ->  {fail, 13};                 % 金钱不足
                                        true -> {ok, GoodsInfo, StoneIdList, StoneInfoList, Cost}
                                    end
							end;
						{fail, Res} -> {fail, Res}
					end
			end
	end.

%% desc: 检查镶嵌宝石列表信息
check_stoneinfo_list(PlayerStatus, StoneIdList, HoleStones) ->
    StoneInfoList = lists:map(fun(Id) -> goods_util:get_goods(PlayerStatus, Id) end, StoneIdList),
	ElemsList = goods_util:get_compose_stone_typelist(HoleStones),
	[_, ResultList, _] = lists:foldl(fun check_stone_info/2, [PlayerStatus#player.id, [], 0, ElemsList], StoneInfoList),
	case lists:keyfind(fail, 1, ResultList) of
	    {fail, Res} ->                          {fail, Res};
		false when ResultList =/= [] ->     {ok, StoneInfoList};
		_Other ->                             ?ASSERT(false), {fail, ?RESULT_FAIL}
	end.

%% desc: 检查镶嵌装备位置是否正确
check_inlay_rule_list([], InlayCost) ->
	{ok, InlayCost};
check_inlay_rule_list([H|T], InlayCost) ->
	case tpl_item_gem:get(H) of
		GemInfo when is_record(GemInfo, temp_item_gem) ->			
			check_inlay_rule_list(T, InlayCost + GemInfo#temp_item_gem.coin_num);
		_ -> {fail, 10}	 % 镶嵌规则不存在
	end.

%% desc: 判断规则是否存在
is_rule_legal(Rule, [State, Table]) ->
	case is_record(Rule, Table) of
		true ->	[State, Table];
		false ->  [false, Table]
	end.
%% desc: 检查宝石信息
check_stone_info(Info, [PlayerId, List, StoneNum, Elems]) ->
	if
		is_record(Info, goods) =:= false -> % 物品不存在
			[  
			 	PlayerId,  [ {fail, 2} | List ],  StoneNum, Elems  
			];
		Info#goods.uid =/= PlayerId -> % 物品不属于你
			[   
			 	PlayerId,  [ {fail, 3} | List ],  StoneNum, Elems  
			];
		Info#goods.location =/= ?LOCATION_BAG -> % 物品位置不对
			[   
			 	PlayerId,  [ {fail, 4} | List ],  StoneNum, Elems  
			];
		% 镶嵌的宝石类型不正确
		Info#goods.type =/= ?GOODS_T_STONE orelse Info#goods.subtype =/= ?STONE_T_ATTR ->
			[
			 	PlayerId,  [ {fail, 8} | List ],  StoneNum, Elems
			];
		true ->
			{Itypeid, Isubtype} = {Info#goods.gtid, Info#goods.subtype},
			Res =	lists:member({Itypeid, Isubtype}, StoneNum, Elems),   % 检查同一宝石是否已镶嵌
			Res1 = lists:keyfind(Isubtype, 2, Elems),   % 检查同一类宝石是否已镶嵌
			if
				StoneNum < 5 andalso (Res =:= true orelse Res1 =/= false) ->
					% 该类宝石有重复
					[
					 	PlayerId,  [ {fail, 9} | List ],  StoneNum, Elems
					];
				true ->
					[
					    PlayerId,  
					 	[ {Itypeid, Isubtype} | List ], StoneNum + 1,
						[ {Itypeid, Isubtype} | Elems ]
					]
			end
	end.

%% desc: 宝石镶嵌
inlay(PlayerStatus, GoodsStatus, GoodsInfo, LogIdList, StoneInfoList, Cost) ->
    % 花费铸造铜钱数
    NewPstatus = lib_money:cost_money(statistic, PlayerStatus, Cost, ?MONEY_T_BCOIN, ?LOG_INLAY),
    % 扣掉宝石
    {ok, NewStatus, _} = lists:foldl(fun(Info, {ok, Status, _Num}) -> lib_goods:delete_one(PlayerStatus, Status, Info, 1, ?LOG_INLAY_GOODS) end, {ok, GoodsStatus, 0}, StoneInfoList),
    % 更新物品状态
    Bind = lib_goods:get_bind_status(GoodsInfo, StoneInfoList),
    {NewGoodsInfo, _} = lists:foldl(fun(Info, {PlayerStatus, OrInfo, HoleSeq}) -> lib_casting:inlay_stone({PlayerStatus, OrInfo, HoleSeq}, Info) end, {GoodsInfo, 1}, StoneInfoList),
	% 更新装备信息
    ets:insert(?ETS_GOODS_ONLINE(PlayerStatus), NewGoodsInfo),
	%%     mod_log:log_inlay(GoodsInfo, LogIdList, Cost), 
    {ok, 1, NewPstatus, NewStatus}.

%% 装备镀金检查
check_gilding(PS, GoodsId, BindFirst) ->
    Result = is_input_choose_legal([{bindfirst, BindFirst}], legal),
    GoodsInfo = goods_util:get_goods(PS, GoodsId),
    if
        % 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, 2};
        % 物品不属于你所有
        GoodsInfo#goods.uid =/= PS#player.id ->
            {fail, 3};
        % 物品位置不正确
        GoodsInfo#goods.location =/= ?LOCATION_PLAYER 
%%           andalso GoodsInfo#goods.location =/= ?LOCATION_PARTNER
            andalso GoodsInfo#goods.location =/= ?LOCATION_BAG ->
            {fail, 4};
        % 物品类型不正确
        GoodsInfo#goods.type =/= ?GOODS_T_EQUIP ->
            {fail, 5}; 
        % 参数错误
        Result =/= legal ->
            {fail, 6};
		true ->
			case tpl_equipment:get(GoodsInfo#goods.gtid) of
				EquipInfo when is_record(EquipInfo, temp_item_equipment) ->
					case EquipInfo#temp_item_equipment.max_gilding > GoodsInfo#goods.gilding_lv of
						true ->
							case tpl_gilding:get(GoodsInfo#goods.gilding_lv + 1, GoodsInfo#goods.subtype) of
								GildingInfo when is_record(GildingInfo, temp_gilding) ->
									[{CostGoodsTid, Num}, {CostCoin, Coin}] = GildingInfo#temp_gilding.goods,
									{Bindnum, Ubindnum} = get_bind_and_unbind(PS#player.id, CostGoodsTid),
									if
										Bindnum + Ubindnum < Num ->
											{fail, 7};
										true ->
											case lib_money:has_enough_money(PS, Coin, ?MONEY_T_BCOIN) of
												false ->	{fail, 8};                 % 金钱不足
												true ->		{ok, GoodsInfo, CostGoodsTid, Num, Coin}
											end
									end;
								_ -> {fail, 9}
							end;
						false -> {fail, 10}
					end;
				_ -> {fail, 11}
			end
    end.

%% 装备升级检查
check_upgrade(PS, GoodsId, BindFirst) ->
	Result = is_input_choose_legal([{bindfirst, BindFirst}], legal),
    GoodsInfo = goods_util:get_goods(PS, GoodsId),
    if
        % 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, 2};
        % 物品不属于你所有
        GoodsInfo#goods.uid =/= PS#player.id ->
            {fail, 3};
        % 物品位置不正确
        GoodsInfo#goods.location =/= ?LOCATION_PLAYER 
%%           andalso GoodsInfo#goods.location =/= ?LOCATION_PARTNER
            andalso GoodsInfo#goods.location =/= ?LOCATION_BAG ->
            {fail, 4};
        % 物品类型不正确
        GoodsInfo#goods.type =/= ?GOODS_T_EQUIP ->
            {fail, 5}; 
        % 参数错误
        Result =/= legal ->
            {fail, 6};
		true ->			
			case tpl_upgrade:get(GoodsInfo#goods.gtid) of
				UpgradeInfo when is_record(UpgradeInfo, temp_upgrade) ->
					NewGoodsInfo = lib_goods:get_goods_type_info(UpgradeInfo#temp_upgrade.target_gtid),
					CostGoodsFlag = check_cost_upgrade_goods(PS, UpgradeInfo#temp_upgrade.goods),
					if
						is_record(NewGoodsInfo, temp_goods) =:= false ->
							{fail, 10};
						 CostGoodsFlag =:= fail ->
							{fail, 7};
						true ->
							case lib_money:has_enough_money(PS, UpgradeInfo#temp_upgrade.cost_coin, ?MONEY_T_BCOIN) of
								false ->	{fail, 8};                 % 金钱不足
								true ->		{ok, GoodsInfo, UpgradeInfo#temp_upgrade.goods, UpgradeInfo#temp_upgrade.cost_coin}
							end
					end;
				_ -> {fail, 9}
			end
	end.

%% 检查升级消耗物品是否满足
check_cost_upgrade_goods(PS, []) ->
	ok;
check_cost_upgrade_goods(PS, [H|T]) ->
	{CostGoodsTid, CostNum} = H,
	{Bindnum, Ubindnum} = 
		get_bind_and_unbind(PS#player.id, CostGoodsTid),									
	case Bindnum + Ubindnum < CostNum of
		true ->	fail;
		false -> check_cost_upgrade_goods(PS, T)
	end.
		
%% 装备镀金
gilding_equip(PS, GoodsStatus, CheckResult) ->
    [GoodsInfo, CostGoodsTid, CostGoodsNum, CostCoin, FirstUseFlag] = CheckResult,
    % 扣除镀金消耗掉的材料 和 钱
	NewPS = lib_money:cost_money(statistic, PS, CostCoin, ?MONEY_T_BCOIN, ?LOG_GILING),
    NewGS = cost_gilding_material(NewPS, GoodsStatus, CostGoodsTid, CostGoodsNum, FirstUseFlag),
	NewInfo = GoodsInfo#goods{gilding_lv = GoodsInfo#goods.gilding_lv + 1},
    lib_common:actin_new_proc(lib_casting, change_goods_giling_fields, [NewPS, NewInfo]),
%%  lib_equip:calc_equip_value(NewPS, NewInfo),
%%  mod_log:log_gilding(GoodsInfo, CoinCost, GoldCost, GoodsInfo#goods.stren, NewInfo#goods.stren),
    ?TRACE("coin:~p ~n", [CostCoin]),
    {ok, ?RESULT_OK, NewGS, NewPS, NewInfo#goods.gilding_lv, CostCoin}.

%% desc: 扣除镀金消耗的材料
cost_gilding_material(PS, GoodsStatus, CostGoodsTid, CostGoodsNum, FirstUseFlag) ->
    PlayerId = PS#player.id,
	{CostGoodsList1, CostGoodsList2} = get_band_unbind_goods(PlayerId, FirstUseFlag, CostGoodsTid, CostGoodsNum),
	CostGoodsList = CostGoodsList1 ++ CostGoodsList2,
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, CostGoodsList, CostGoodsNum, ?LOG_GILING_GOODS),
    NewGS.

%% 装备升级
upgrade_equip(PS, GoodsStatus, CheckResult) ->
    [GoodsInfo, NewGoodsTmp, CostGoodsList, CostCoin, FirstUseFlag] = CheckResult,
    % 扣除升级消耗掉的材料 和 钱
	NewPS = lib_money:cost_money(statistic, PS, CostCoin, ?MONEY_T_BCOIN, ?LOG_GILING),
    NewGS = cost_upgrade_material(NewPS, GoodsStatus, CostGoodsList, FirstUseFlag),
	NewInfo = GoodsInfo#goods{gtid = NewGoodsTmp#temp_goods.gtid,
							  max_num = NewGoodsTmp#temp_goods.max_num,
							  expire_time = NewGoodsTmp#temp_goods.expire_time,
							  suit_id =  NewGoodsTmp#temp_goods.suit_id,
							  level = NewGoodsTmp#temp_goods.level
							  },
    lib_common:actin_new_proc(lib_casting, change_goods_upgrade_fields, [NewPS, NewInfo]),
%%  lib_equip:calc_equip_value(NewPS, NewInfo),
%%  mod_log:log_gilding(GoodsInfo, CoinCost, GoldCost, GoodsInfo#goods.stren, NewInfo#goods.stren),
    ?TRACE("coin:~p ~n", [CostCoin]),
    {ok, ?RESULT_OK, NewGS, NewPS, NewInfo#goods.level, CostCoin}.

%% desc: 扣除升级消耗的材料
cost_upgrade_material(_PS, GoodsStatus, [], _FirstUseFlag) ->
    GoodsStatus;
cost_upgrade_material(PS, GoodsStatus, [H|T], FirstUseFlag) ->
	{CostGoodsTid, CostGoodsNum} = H,
    PlayerId = PS#player.id,
	{CostGoodsList1, CostGoodsList2} = get_band_unbind_goods(PlayerId, FirstUseFlag, CostGoodsTid, CostGoodsNum),
	CostGoodsList = CostGoodsList1 ++ CostGoodsList2,
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, CostGoodsList, CostGoodsNum, ?LOG_UPG_GOODS),
    NewGS.

%% desc: 装备镀金预览
calc_gilding_info(PS, GoodsInfo) ->
	case tpl_gilding:get(GoodsInfo#goods.gtid, GoodsInfo#goods.subtype) of
		GildingInfo when is_record(GildingInfo, temp_gilding) ->
					NewGoodsInfo = GoodsInfo#goods{quality = ?COLOR_ORANGE},
					PolishAddAttri = lib_equip:get_upgrage_polish_attri(PS, NewGoodsInfo),
					StrenAddAttri = lib_equip:get_stren_attri(NewGoodsInfo),
					GildingAddAtrri = lib_equip:get_gilding_attri(NewGoodsInfo),
					[NewGoodsInfo, 0, PolishAddAttri ++ StrenAddAttri ++ GildingAddAtrri];
		_ ->
			[{}, 0, []]
	end.

%% desc: 升级装备预览
calc_upgrade_info(PS, GoodsInfo) ->
	case tpl_upgrade:get(GoodsInfo#goods.gtid) of
		UpgradeInfo when is_record(UpgradeInfo, temp_upgrade) ->
			case lib_goods:get_goods_type_info(UpgradeInfo#temp_upgrade.target_gtid) of
				GoodsTypeInfo when is_record(GoodsTypeInfo, temp_goods) ->
					NewGoodsInfo = GoodsInfo#goods{gtid = UpgradeInfo#temp_upgrade.target_gtid},
					PolishAddAttri = lib_equip:get_upgrage_polish_attri(PS, NewGoodsInfo),
					StrenAddAttri = lib_equip:get_stren_attri(NewGoodsInfo),
					GildingAddAtrri = lib_equip:get_gilding_attri(NewGoodsInfo),
					[NewGoodsInfo, 0, PolishAddAttri ++ StrenAddAttri ++ GildingAddAtrri];
				_ -> [{}, 0, []]
			end;
		_ ->
			[{}, 0, []]
	end.

%% 宝石合成检查
check_compose(PS, GoodsStatus, StoneTid, NeedComposeNum) ->
   StoneTmpInfo = lib_goods:get_goods_type_info(StoneTid),
    if
        % 物品不存在
        is_record(StoneTmpInfo, temp_goods) =:= false ->
            {fail, 5};
		true ->			
			case tpl_compose:get(StoneTid) of
				ComposeInfo when is_record(ComposeInfo, temp_compose) ->
					ComposeNum = check_cost_compose_goods(PS, ComposeInfo),
					if
						 ComposeNum =:= 0 ->
							{fail, 2};
						true ->
							NewComposeNum =
								case ComposeNum > NeedComposeNum of
									true -> NeedComposeNum;
									false -> ComposeNum
								end,
							CanComposeNum = check_compose_money(PS, ComposeInfo, NewComposeNum, 0),
							case CanComposeNum > 0 of
								true ->
									{BindStoneList, UnBindStoneList}= get_band_unbind_goods(PS#player.id, ?BIND_FIRST, ComposeInfo#temp_compose.gtid, CanComposeNum*ComposeInfo#temp_compose.goods_num),									
									{ok, BindStoneList ++ UnBindStoneList, ComposeNum*ComposeInfo#temp_compose.cost_coin, StoneTid, length(BindStoneList), length(UnBindStoneList)};
								false ->	{fail, 4}                 % 金钱不足
							end
					end;
				_ -> {fail, 3}
			end
	end.

%% 检查宝石消耗铜钱是否满足
check_compose_money(PS, ComposeInfo, ComposeNum, CanComposeNum) ->
	case ComposeNum > 0 andalso lib_money:has_enough_money(PS, ComposeInfo#temp_compose.cost_coin, ?MONEY_T_BCOIN) of
		false -> CanComposeNum;
		true -> check_compose_money(PS, ComposeInfo, ComposeNum - 1, CanComposeNum + 1)
	end.

%% 检查宝石消耗物品是否满足
check_cost_compose_goods(PS, ComposeInfo) ->
	{Bindnum, Ubindnum} = 
		get_bind_and_unbind(PS#player.id, ComposeInfo#temp_compose.gtid),
	util:floor((Bindnum + Ubindnum) / ComposeInfo#temp_compose.goods_num).

%% 获取宝石合成消耗宝石列表
get_cost_compose_stone(PlayerId, StoneTid, CostNum) ->
	BindStoneList = goods_util:get_bag_goods_list(PlayerId, StoneTid),
	case BindStoneList > CostNum of
		true -> {BindStoneList, []};
		false ->
			UnBindStoneTid = goods_util:goods_bind_to_unbind(StoneTid),
			UnBindStoneList = goods_util:get_bag_goods_list(PlayerId, UnBindStoneTid),
			{BindStoneList, UnBindStoneList}
	end.

%% 宝石合成
compose(PS, GoodsStatus, CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum) ->
	% 扣除镀金消耗掉的材料 和 钱
	NewPS = lib_money:cost_money(statistic, PS, CostCoin, ?MONEY_T_BCOIN, ?LOG_COMPOSE),
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, CostGoodsList, length(CostGoodsList), ?LOG_COMPOSE_GOODS),
	NewGS1 = 
		case NewBindStoneNum > 0 of
			true -> lib_goods:give_goods({StoneTid, NewBindStoneNum}, NewGS);
			false -> NewGS
		end,
	NewGS2 = 
		case NewStoneNum > 0 of
			true ->
				UnBindStoneTid = goods_util:goods_bind_to_unbind(StoneTid),
				lib_goods:give_goods({UnBindStoneTid, NewStoneNum}, NewGS1);
			false -> NewGS1
		end,
%%  mod_log:log_compose(GoodsInfo, CoinCost, GoldCost, GoodsInfo#goods.stren, NewInfo#goods.stren),
    ?TRACE("coin:~p ~n", [CostCoin]),
    {ok, ?RESULT_OK, NewGS2, NewPS, CostCoin}.

%% 拆除宝石
check_backout(PlayerStatus, GoodsStatus, [GoodsId, StoneTypeIdList]) ->
	GoodsInfo = goods_util:get_goods(PlayerStatus, GoodsId),
	if
		% 物品不存在
		is_record(GoodsInfo, goods) =:= false ->
			{fail, 2};
		% 物品所在位置不正确
		  GoodsInfo#goods.location =/= ?LOCATION_PLAYER 
%%           andalso GoodsInfo#goods.location =/= ?LOCATION_PARTNER
            andalso GoodsInfo#goods.location =/= ?LOCATION_BAG ->
			{fail, 3};	
		% 没有宝石可拆除
		StoneTypeIdList =:= [] ->
			{fail, 4};
		true ->
			case is_backout_stone_legal(StoneTypeIdList, GoodsInfo#goods.hole_goods) of
				false ->		{fail, 4};% 没有宝石可拆除
				true when length(StoneTypeIdList) > GoodsStatus#goods_status.null_cells ->	{fail, 5};% 背包空位不足
				true ->
                    check_backout_money(StoneTypeIdList, GoodsInfo, PlayerStatus)
            end
    end.

%% desc : 判断输入的宝石类型ID列表是否数据正确
%% returns : false | true
is_backout_stone_legal(StoneTypeIdList, Slist)	->
	F = fun(StoneInfo, Res) ->
				case lists:member(StoneInfo, Slist) of
					true ->
                        Res;
                    _ -> 
                        false	% 要拆除的宝石不存在
				end
		end,
	lists:foldl(F, true, StoneTypeIdList).

%% desc: 检查金钱是否满足条件
check_backout_money(StoneTypeIdList, GoodsInfo, PlayerStatus) ->
	BackoutCost = lists:foldl(fun({_Seq, StoneTid}, Sum) -> 
									  GemInfo = tpl_item_gem:get(StoneTid),
									  GemInfo#temp_item_gem.coin_num + Sum 
							  end, 0, StoneTypeIdList),
	NewCostList = [{BackoutCost, ?MONEY_T_BCOIN}],
	case lib_money:can_pay(PlayerStatus, NewCostList) of
		false ->   {fail, 6}; % 玩家金钱不足
		true ->    {ok, GoodsInfo, StoneTypeIdList, BackoutCost}  % 可以拆除
	end.

%% 宝石拆除
backout(PlayerStatus, GoodsStatus, [GoodsInfo, StoneTypeIdList, BackoutCost]) ->    
    % 扣铜钱
    PS = lib_money:cost_money(statistic, PlayerStatus, BackoutCost, ?MONEY_T_BCOIN, ?LOG_BACLOUT),                                  
    % 拆除宝石
     NewStatus = lib_casting:backout_stone(GoodsInfo, GoodsStatus, PS, StoneTypeIdList),
%%     mod_log:log_backout(GoodsInfo, StoneTypeIdList, BackoutCost),
    {ok, PS, NewStatus}.

%% 宝石神炼检查
check_godtried(PS, GoodsStatus, StoneTid, FirstUseFlag, NeedGodTriedNum) ->
   StoneTmpInfo = lib_goods:get_goods_type_info(StoneTid),
    if
        % 物品不存在
        is_record(StoneTmpInfo, temp_goods) =:= false ->
            {fail, 5};
		true ->			
			case tpl_god_tried:get(StoneTid) of
				GodTriedInfo when is_record(GodTriedInfo, temp_god_tried) ->
					GodTriedNum = check_cost_godtried_goods(PS, GodTriedInfo),
					if
						 GodTriedNum =:= 0 ->
							{fail, 7};
						true ->
							NewGodTriedNum =
								case GodTriedNum > NeedGodTriedNum of
									true -> NeedGodTriedNum;
									false -> GodTriedNum
								end,
							CanGodTriedNum = check_godtried_money(PS, GodTriedInfo, NewGodTriedNum, 0),
							case CanGodTriedNum > 0 of
								true ->
									{BindStoneList, UnBindStoneList} = 
										get_band_unbind_goods(PS#player.id, FirstUseFlag, GodTriedInfo#temp_god_tried.stone_tid, CanGodTriedNum),
									{BindStoneList1, UnBindStoneList1} = 
										get_band_unbind_goods(PS#player.id, FirstUseFlag, GodTriedInfo#temp_god_tried.god_stone_tid, CanGodTriedNum),
									Len = length(BindStoneList),
									Len1 = length(BindStoneList1),
									BindLen = min(Len, Len1),
									{ok, BindStoneList ++ UnBindStoneList ++ BindStoneList1 ++ UnBindStoneList1 , 
										CanGodTriedNum*GodTriedInfo#temp_god_tried.cost_coin, StoneTid, BindLen, CanGodTriedNum - BindLen};
								false ->	{fail, 8}                 % 金钱不足
							end
					end;
				_ -> {fail, 3}
			end
	end.

%% 检查宝石神炼消耗铜钱是否满足
check_godtried_money(PS, GodTriedInfo, GodTriedNum, CanGodTriedNum) ->
	case GodTriedNum > 0 andalso lib_money:has_enough_money(PS, CanGodTriedNum#temp_god_tried.cost_coin, ?MONEY_T_BCOIN) of
		false -> CanGodTriedNum;
		true -> check_godtried_money(PS, GodTriedInfo#temp_god_tried.cost_coin, GodTriedNum - 1, CanGodTriedNum + 1)
	end.

%% 检查宝石神炼消耗物品是否满足
check_cost_godtried_goods(PS, GodTriedInfo) ->
	{Bindnum, Ubindnum} = 
		get_bind_and_unbind(PS#player.id, GodTriedInfo#temp_god_tried.stone_tid),
	StoneNum = Bindnum + Ubindnum,
	case StoneNum > 0 of
		true ->
			{Bindnum1, Ubindnum1} = 
				get_bind_and_unbind(PS#player.id, GodTriedInfo#temp_god_tried.god_stone_tid),
			GodStoneNum = Bindnum1 + Ubindnum1,
			case GodStoneNum > 0 of
				true ->	min(StoneNum, GodStoneNum);
				false -> GodStoneNum
			end;
		false -> StoneNum			
	end.

%% 获取宝石神炼消耗宝石列表
get_cost_godtried_stone(PlayerId, StoneTid, CostNum) ->
	BindStoneList = goods_util:get_bag_goods_list(PlayerId, StoneTid),
	case BindStoneList > CostNum of
		true -> {BindStoneList, []};
		false ->
			UnBindStoneTid = goods_util:goods_bind_to_unbind(StoneTid),
			UnBindStoneList = goods_util:get_bag_goods_list(PlayerId, UnBindStoneTid),
			{BindStoneList, UnBindStoneList}
	end.

%% 宝石神炼
godtried(PS, GoodsStatus, CostGoodsList, CostCoin, StoneTid, NewBindStoneNum, NewStoneNum) ->
	% 扣除镀金消耗掉的材料 和 钱
	NewPS = lib_money:cost_money(statistic, PS, CostCoin, ?MONEY_T_BCOIN, ?LOG_GODTRIED),
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, CostGoodsList, length(CostGoodsList), ?LOG_GODTRIED_GOODS),
	NewGS1 = 
		case NewBindStoneNum > 0 of
			true -> lib_goods:give_goods({StoneTid, NewBindStoneNum}, NewGS);
			false -> NewGS
		end,
	NewGS2 = 
		case NewStoneNum > 0 of
			true ->
				UnBindStoneTid = goods_util:goods_bind_to_unbind(StoneTid),
				lib_goods:give_goods({UnBindStoneTid, NewStoneNum}, NewGS1);
			false -> NewGS1
		end,
%%  mod_log:log_godtried(GoodsInfo, CoinCost, GoldCost, GoodsInfo#goods.stren, NewInfo#goods.stren),
    ?TRACE("coin:~p ~n", [CostCoin]),
    {ok, ?RESULT_OK, NewGS2, NewPS, CostCoin}. 