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
-include("common_log.hrl"). 

-define(MAX_STREN_STAR, 10). % 最大强化星级
%%
%% Exported Functions
%%
-compile(export_all).

%%
%% API Functions
%%
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
	StoneList = get_band_unbind_goods(PlayerId, FirstUseFlag, StoneTid, Snum),
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, StoneList, Snum),
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
    case lib_money:can_pay(PS, [{GoldPrice, gold}, {CoinPrice, coin}]) of
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
    {ok, NewStatus, _} = lib_goods:delete_one(PS, GS, Stone, 1),
    NewStatus.

%% desc: 扣除洗炼锁
del_polish_lock({_PS, GS}, _LockList, 0) -> GS;
del_polish_lock({PS, GS}, LockList, UseLockNum) ->
    {ok, GS1} = lib_goods:delete_more({PS, GS}, LockList, UseLockNum),
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
	case FirstUseFlag of
		?UNBIND_FIRST ->
			UnBindGoodsList = goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ANY),
			case length(UnBindGoodsList) >= GetNum of
				true -> UnBindGoodsList;
				false -> UnBindGoodsList ++ goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY)
			end;
		?BIND_FIRST ->
			BindGoodsList = goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ALREADY),
			case length(BindGoodsList) >= GetNum of
				true -> BindGoodsList;
				false -> BindGoodsList ++ goods_util:get_bag_goods_list(PlayerId, GoodsTid, ?BIND_ANY)
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
    {ok, NewStatus, _} = lists:foldl(fun(Info, {ok, Status, _Num}) -> lib_goods:delete_one(PlayerStatus, Status, Info, 1) end, {ok, GoodsStatus, 0}, StoneInfoList),
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

%% 镀金装备
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
	CostGoodsList = get_band_unbind_goods(PlayerId, FirstUseFlag, CostGoodsTid, CostGoodsNum),
    {ok, NewGS} = lib_goods:delete_more(keep_order, {PS, GoodsStatus}, CostGoodsList, CostGoodsNum),
    NewGS.

%% desc: 升级装备预览
calc_upgrage_info(PS, GoodsInfo) -> ok.
%%     case data_equip_upg:get(GoodsInfo#goods.goods_id) of
%%         [0 | _] ->
%%             [{}, 0, []];
%%         [GoodsTid | _] ->
%%             NewTinfo = lib_goods:get_goods_type_info(GoodsTid),
%%             NewInfo1 = lib_goods:convert_basegoods_to_goods(NewTinfo),
%%             Hole = case GoodsInfo#goods.stren of
%%                        ?EQUIP_MAX_STREN -> 
%%                            case GoodsInfo#goods.color =:= ?COLOR_ORANGE of
%%                                true -> 4;
%%                                false -> GoodsInfo#goods.hole
%%                            end;
%%                        _ -> 
%%                            case GoodsInfo#goods.color =:= ?COLOR_ORANGE of
%%                                true -> 3;
%%                                false -> GoodsInfo#goods.hole
%%                            end
%%                    end,
%%             NewInfo2 = NewInfo1#goods{id = GoodsInfo#goods.id, stren = GoodsInfo#goods.stren, wash = GoodsInfo#goods.wash, hole = Hole},
%%             SuitNum = case lib_equip:is_suit(PS, NewInfo2) of
%%                   true ->  1;
%%                   false -> 0
%%               end,
%%             AttriList = calc_adv_upg_attri_list(PS, NewInfo2, GoodsInfo),
%%             [NewInfo2, SuitNum, AttriList]
%%     end.
