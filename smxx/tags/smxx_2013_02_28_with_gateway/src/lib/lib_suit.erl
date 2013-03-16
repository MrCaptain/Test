%%%-------------------------------------- 
%%% @Module: lib_suit
%%% @Author: lxl
%%% @Created: 2012-1-18
%%% @Description: 
%%%-------------------------------------- 
-module(lib_suit).

-include("common.hrl").
-include("record.hrl").
-include("goods.hrl").

%% -export([
%%               init_login_suit/2,
%% %%               change_role_suit/3,
%%               get_goods_suit_num/2,
%%               count_par_suit_infos/2,
%%               change_partner_suit/3,
%%               
%%               get_data_suit_attr/1,
%%               get_data_direct_add_list/2,
%%               get_data_not_direct_add_list/1
%%          ]).
%% 
%% 
%% 
%% 
%% %% exports
%% %% desc: 登录初始化玩家(suit_attri, role_suit)和在线武将的套装信息(suit_attr, partner_suit)
%% %% returns: [SuitList, AttriList] 玩家信息
%% init_login_suit(PlayerId, GoodsEtsId) ->
%%     init_role_suit(PlayerId, GoodsEtsId).
%% 
%% 
%% %% internal
%% %% desc: 初始化玩家套装信息
%% init_role_suit(PlayerId, GoodsEtsId) ->
%%     GoosEtsName = misc:create_goos_ets_name(GoodsEtsId),
%%     count_suit_infos(PlayerId, GoosEtsName).   % 统计该玩家的role_suit信息
%% 
%% 
%% %% exports
%% %% desc: 统计玩家套装信息
%% %% returns: [{SuitId, Num}....]
%% count_suit_infos(PlayerId, GoodsEtsName) ->
%%     Pattern = #goods{uid = PlayerId, location = ?LOCATION_PLAYER, _ = '_'},
%%     case lib_common:get_ets_list(GoodsEtsName, Pattern) of
%%         List when is_list(List) ->
%%             lists:foldl(fun count_suit/2, [], List);
%%         _ ->
%%             []
%%     end.
%% 
%% %% internal
%% %% desc: 计算套装
%% count_suit(GoodsInfo, Result) ->
%%     case GoodsInfo#goods.suit_id > 0 of
%%         false ->
%%             Result; 
%%         true ->
%%             case lists:keyfind(GoodsInfo#goods.suit_id, 1, Result) of
%%                 false ->                   [{GoodsInfo#goods.suit_id, 1} | Result];
%%                 {SuitId, Num} ->         lists:keyreplace(SuitId, 1, Result, {SuitId, Num + 1})
%%             end
%%     end.
%% 
%% %% internal
%% %% @doc: 查询可以直接对玩家产生影响的套装属性被动效果名
%% %% todo--让策划进行配置
%% %% @ret: list{}
%% get_use_directly_passis() ->
%%     [
%%      stu_att_add_rate,
%%      phy_def_add_rate,
%%      mag_def_add_rate,
%%      stu_def_add_rate,
%%      
%%      crit_rate_add,
%%      dodge_rate_add,
%%      block_rate_add
%%     ].
%% 
%% 
%% 
%% %% exports
%% %% @doc: 读取套装属性配置表，并对被动格式进行转化
%% %% @ret: list()
%% %% get_data_suit_attr(SuitId, SuitNum) ->
%% %%     List = data_suit:get_suit_attri(SuitId, SuitNum),
%% %%     get_data_suit_attr(List).
%% get_data_suit_attr([]) -> [];
%% get_data_suit_attr(List) -> 
%%     Fun = fun(Tuple, Rest) ->
%%                   case Tuple of
%%                       {_AttrId, _Val} -> 
%%                           [Tuple | Rest];
%%                       {_EffName, _EffValue, _LastingTurn, _MaxOverlap, _Proba, _CanRecalc} ->
%%                           New = lib_battle_common:convert_passi_eff_to_record(Tuple),
%%                           [New | Rest];
%%                       _ ->
%%                           Rest
%%                   end
%%           end,
%%     lists:foldl(Fun, [], List).
%% 
%% %% exports
%% %% @doc: 查询可以 不能 直接加属性的被动格式套装属性
%% %% @ret: lists()
%% get_data_not_direct_add_list(RoleInfo) ->
%%     SuitInfos = case is_record(RoleInfo, player_status) of
%%                     true -> RoleInfo#player_status.role_suit;
%%                     false -> RoleInfo#ets_partner.partner_suit
%%                 end,
%%     
%%     FunGetSuitList = fun({SuitId, SuitNum}, List) -> get_data_not_direct_add_list(SuitId, SuitNum) ++ List end,
%%     lists:foldl(FunGetSuitList, [], SuitInfos).
%% 
%% get_data_not_direct_add_list(SuitId, SuitNum) when is_integer(SuitId), is_integer(SuitNum) ->
%%     List = data_suit:get_suit_attri(SuitId, SuitNum),
%% 
%%     % 转化格式
%%     List1 = get_data_suit_attr(List),
%%     get_data_not_direct_add_list(List1, []);
%% 
%% get_data_not_direct_add_list([], Res) -> Res;
%% get_data_not_direct_add_list([Tuple | Left], Res) ->
%%     case is_record(Tuple, data_passi_eff) of
%%         true ->
%%             List = get_use_directly_passis(),
%%             case lists:member(Tuple#data_passi_eff.eff_name, List) of
%%                 true ->  get_data_not_direct_add_list(Left, Res);
%%                 false -> get_data_not_direct_add_list(Left, [Tuple | Res])
%%             end;
%%         false ->
%%             get_data_not_direct_add_list(Left, Res)
%%     end.
%% 
%% %% exports
%% %% @doc: 查询套装属性可以直接加属性的元组列表
%% %% @ret: list()
%% get_data_direct_add_list([], Res) -> Res;
%% get_data_direct_add_list([Tuple | Left], Res) ->
%%     case is_record(Tuple, data_passi_eff) of
%%         true ->
%%             List = get_use_directly_passis(),
%%             case lists:member(Tuple#data_passi_eff.eff_name, List) of
%%                 false ->  get_data_direct_add_list(Left, Res);
%%                 true -> get_data_direct_add_list(Left, [Tuple | Res])
%%             end;
%%         false ->
%%             get_data_direct_add_list(Left, [Tuple | Res])
%%     end.
%% 
%% %% exports
%% %% desc: 统计武将套装信息
%% count_par_suit_infos(PartnerInfo, GoodsEtsId) -> ok.
%% %%     Pattern = #goods{partner_id = PartnerInfo#ets_partner.id, location = ?LOCATION_PARTNER, _ = '_'},
%% %%     case lib_common:get_ets_list(?ETS_GOODS_ONLINE(#player_status{goo_ets_id = GoodsEtsId}), Pattern) of
%% %%         List when is_list(List) ->
%% %%             lists:foldl(fun count_suit/2, [], List);
%% %%         _ ->
%% %%             []
%% %%     end.
%% 
%% %% exports
%% %% desc: 玩家自己穿卸一件套装
%% %% returns: NewPlayerStatus 
%% %% 穿上一件装备
%% change_role_suit(equip, PlayerStatus, [{}, GoodsInfo]) when GoodsInfo#goods.suit_id > 0 ->
%%     NewSuitList = add_suit_num(GoodsInfo#goods.suit_id, PlayerStatus#player_status.role_suit),
%%     PlayerStatus#player_status{role_suit = NewSuitList};
%% %% 替换一件装备
%% change_role_suit(equip, PlayerStatus, [OldGoodsInfo, GoodsInfo]) when is_record(OldGoodsInfo, goods) ->
%%     % 改变套装件数
%%     NewPS = case OldGoodsInfo#goods.suit_id > 0 of
%%                 true ->             change_role_suit(unequip, PlayerStatus, OldGoodsInfo);
%%                 false ->            PlayerStatus
%%             end,
%%     case GoodsInfo#goods.suit_id > 0 of
%%         true ->    change_role_suit(equip, NewPS, [{}, GoodsInfo]);
%%         false ->   NewPS
%%     end;
%% %% 脱下一件装备
%% change_role_suit(unequip, PlayerStatus, GoodsInfo) when GoodsInfo#goods.suit_id > 0 ->
%%     NewSuitList = sub_suit_num(GoodsInfo#goods.suit_id, PlayerStatus#player_status.role_suit),
%%     PlayerStatus#player_status{role_suit = NewSuitList};
%% change_role_suit(_, PlayerStatus, _GoodsInfo) ->
%%     PlayerStatus.
%% 
%% 
%% %% exports
%% %% desc: 获取装备的套装件数信息
%% get_goods_suit_num(GoodsInfo, PS) -> 
%%     case GoodsInfo#goods.partner_id > 0 of
%%         false ->  get_suit_num(GoodsInfo#goods.suit_id, PS#player_status.role_suit);
%%         true ->
%%             case lib_partner:get_alive_partner(GoodsInfo#goods.partner_id) of
%%                 null -> 1;
%%                 ParInfo -> get_suit_num(GoodsInfo#goods.suit_id, ParInfo#ets_partner.partner_suit)
%%             end
%%     end.
%% 
%% %% internal
%% %% desc: 获取玩家某套装的件数
%% get_suit_num(SuitId, SuitList) ->
%%     case lists:keyfind(SuitId, 1, SuitList) of
%%         {SuitId, Num} -> 
%%             Num;
%%         false -> 
%%             1
%%     end.
%% 
%% %% internal
%% %% desc: 增加该套装一件数量
%% add_suit_num(SuitId, SuitList) ->
%%     case lists:keyfind(SuitId, 1, SuitList) of
%%         false ->               [{SuitId, 1} | SuitList];
%%         {SuitId, Num} ->     lists:keyreplace(SuitId, 1, SuitList, {SuitId, Num + 1})
%%     end.
%%     
%% %% internal
%% %% desc: 减少该套装一件数量
%% sub_suit_num(SuitId, SuitList) ->
%%     case lists:keyfind(SuitId, 1, SuitList) of
%%         false ->               [];
%%         {SuitId, 1} ->        lists:delete({SuitId, 1}, SuitList);
%%         {SuitId, Num} ->     lists:keyreplace(SuitId, 1, SuitList, {SuitId, Num - 1})
%%     end.
%% 
%% %% exports
%% %% desc: 给武将穿卸一件装备
%% %% returns: NewPartnerInfo
%% change_partner_suit(equip, PartnerInfo, GoodsInfo) when GoodsInfo#goods.suit_id > 0 ->
%%     NewSuitList = add_suit_num(GoodsInfo#goods.suit_id, PartnerInfo#ets_partner.partner_suit),
%%     PartnerInfo#ets_partner{partner_suit = NewSuitList};
%% change_partner_suit(unequip, PartnerInfo, GoodsInfo) when GoodsInfo#goods.suit_id > 0 ->
%%     % 改变装备
%%     NewSuitList = sub_suit_num(GoodsInfo#goods.suit_id, PartnerInfo#ets_partner.partner_suit),
%%     PartnerInfo#ets_partner{partner_suit = NewSuitList};
%% change_partner_suit(_, PartnerInfo, _GoodsInfo) ->
%%     PartnerInfo.
