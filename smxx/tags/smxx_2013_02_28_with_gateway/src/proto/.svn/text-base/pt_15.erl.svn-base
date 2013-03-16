%%-----------------------------------
%% @Module  : pt_15
%% @Author  : 
%% @Email   : 
%% @Created :
%% @Description: 15物品信息
%%-----------------------------------
-module(pt_15).
-include("record.hrl").
-include("common.hrl").
-export([read/2, write/2, write_goods_info/2]).

%%
%%客户端 -> 服务端 ----------------------------
%%
%% 查询物品详细信息
read(15000, <<GoodsId:64>>) ->
    {ok, GoodsId};

%% 查询别人物品详细信息(在线玩家身上的装备、坐骑信息)
read(15001, <<RoleId:64, GoodsId:64>>) ->
    {ok, [RoleId, GoodsId]};

%%查询物品列表
read(15002, <<Location:8>>) ->
    {ok, Location};

%% 扩充背包
read(15003, <<Location:8>>) ->
    {ok, Location};

%% 背包内拖动物品
read(15004, <<GoodsId:64, OldCell:16, NewCell:16>>) ->
    {ok, [GoodsId, OldCell, NewCell]};

%% 物品拆分
read(15005, <<GoodsId:64, GoodsNum:16>>) ->
    {ok, [GoodsId, GoodsNum]};

%% 整理背包
read(15006, _) ->
    {ok, []};

%% 出售物品
read(15007, <<GoodsId:64, GoodsNum:16>>) ->
    {ok, [GoodsId, GoodsNum]};

%% 寄售物品
read(15008, <<GoodsUniId:64, Price:32, PriceType:8, SellTime:8, WantBroadcast:8>>) ->
    {ok, [GoodsUniId, Price, PriceType, SellTime, WantBroadcast]};

%% 使用物品 
read(15009, <<GoodsId:64, GoodsNum:16>>) ->
    {ok, [GoodsId, GoodsNum]};

%% 获取特价商店列表
read(15011, _) ->
    {ok, bar_shop};

%% 购买特价物品 
read(15012, <<GoodsTid:32, Num:16>>) ->
    {ok, [GoodsTid, Num]};

%% 获取商店列表  
read(15013, <<ShopType:8, ShopSubtype:8, PageNo:8>>) ->
    {ok, [ShopType, ShopSubtype, PageNo]};

%% 购买物品 
read(15014, <<GoodsTypeId:32, GoodsNum:16, ShopType:8, ShopSubType:8>>) ->
    {ok, [GoodsTypeId, GoodsNum, ShopType, ShopSubType]};

%% 查看NPC商人出售的物品
read(15015, <<NpcId:32, ShopSubType:8, PageNo:8>>) ->
    {ok, [NpcId, ShopSubType, PageNo]};

%% 購買NPC商人出售的物品
read(15016, <<NpcId:32, GoodsTid:32, Num:16>>) ->
    {ok, [NpcId, GoodsTid, Num]};

%% 装备物品  
read(15017, <<GoodsId:64, PartnerId:64>>) ->
    {ok, [GoodsId, PartnerId]};

%% 卸下装备 
read(15018, <<GoodsId:64, PartnerId:64>>) ->
    {ok, [GoodsId, PartnerId]};

% ===============================================================================
%% 铸造相关功能
%% ===============================================================================
%% 装备强化  
read(15019, <<GoodsId:64, UnbindOnly:8, AutoBuy:8, Type:8>>) ->
    {ok, [GoodsId, UnbindOnly, AutoBuy, Type]};

%% 洗附加属性, RuneId - 洗炼石id，GoodsId - 装备id  
read(15020, <<GoodsId:64, BindFirst:8, AutoBuy:8, AutoLock:8, AttriLen:16, AttriBin/binary>>) ->
    IdList = parse_id_list(AttriLen, AttriBin, []),
    {ok, [GoodsId, BindFirst, AutoBuy, AutoLock, IdList]};

%% 查看装备的洗炼属性
read(15021, <<GoodsId:64>>) ->
	{ok, GoodsId};

%% 宝石镶嵌 
read(15022, <<GoodsId:64, Num:16, Bin/binary>>) ->
	F = fun(_, [Bindata, List]) ->
				<<StoneId:64, Rest/binary>> = Bindata,
				[Rest, [StoneId | List]]
		end,
	[_, StoneIdList] = lists:foldl(F, [Bin, []], lists:seq(1, Num)),
	{ok, [GoodsId, StoneIdList]};

%% 宝石拆除
read(15023, <<GoodsId:64, BindFirst:8, AutoBuy:8, Num:16, Bin/binary>>) ->
	F = fun(_, [Bindata, List]) ->
				<<StoneTypeId:32, Rest/binary>> = Bindata,
				[Rest, [StoneTypeId | List]]
		end,
	[_, StoneTypeIdList] = lists:foldl(F, [Bin, []], lists:seq(1, Num)),
	{ok, [GoodsId, StoneTypeIdList, BindFirst, AutoBuy]};

%% 宝石合成 
read(15024, <<RuneTypeId:32, UseRune:8, BindFirst:8, AutoBuy:8, Num:16, Bin/binary>>) ->
	F = fun(_, [Bin1,L]) ->
				<<GoodsId:64, GoodsNum:16, Rest/binary>> = Bin1,
				L1 = [
					  [GoodsId, GoodsNum] | L
					 ],
				[Rest, L1]
		end,
	[_, StoneList] = lists:foldl(F, [Bin, []], lists:seq(1, Num)),
	{ok, [RuneTypeId, UseRune, BindFirst, AutoBuy, StoneList]};

%% desc: 查询玩家或宠物的全身奖励类型
read(15025, <<TargetId:64, TargetType:8>>) ->
    {ok, [TargetId, TargetType]};

%% 获取别人身上装备列表
read(15026, <<PlayerId:64>>) ->
    {ok, PlayerId};

%% 洗炼替换
read(15027, <<GoodsId:64>>) ->
    {ok, GoodsId};

%% 物品丢弃  finish
read(15028, <<GoodsId:64, GoodsNum:16>>) ->
    {ok, [GoodsId, GoodsNum]};

%% 装备镀金 
read(15029, <<GoodsId:64, UnbindOnly:8>>) ->
    {ok, [GoodsId, UnbindOnly]};

%% 装备镀金 
read(15030, <<GoodsId:64, Type:8>>) ->
    {ok, [GoodsId, Type]};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%
%%查询物品详细信息
write_goods_info(Cmd, [GoodsInfo, SNum, AttributeList]) ->
    [GoodsId, TypeId, Cell, Num, Bind, Color, Stren, Hole, HoleLen, HoleBin,
     SuitId, SuitNum, AttriLen, AttriBin] =
    case is_record(GoodsInfo, goods) of
        true ->
            [GoodsInfo#goods.id,
            GoodsInfo#goods.gtid,
            GoodsInfo#goods.cell,
            GoodsInfo#goods.num,
            GoodsInfo#goods.bind,
            GoodsInfo#goods.quality,
            GoodsInfo#goods.stren_lv,
            GoodsInfo#goods.hole,
			length(GoodsInfo#goods.hole_goods),
			list_to_binary( lists:map(fun convert_HoleInfo/1, GoodsInfo#goods.hole_goods)),
            GoodsInfo#goods.suit_id,
			SNum,
            length(AttributeList),
            list_to_binary( lists:map(fun convert_attri/1, AttributeList) )];
        false ->
            lists:duplicate(9, 0) ++ [<<>>] ++ lists:duplicate(3, 0) ++ [<<>>]
    end,
    {ok, pt:pack(Cmd, <<GoodsId:64, TypeId:32, Cell:16, Num:16, Bind:16, Color:16, Stren:16, 
						Hole:16, HoleLen:16, HoleBin/binary, SuitId:16, SuitNum:16,
                       AttriLen:16, AttriBin/binary>>)}.

%% 查询玩家物品列表
write(15002, [Location, CellNum, Coin, BCoin, Gold, BGold, GoodsList]) ->
    ListNum = length(GoodsList),
    F = fun(GoodsInfo) ->
            GoodsId = GoodsInfo#goods.id,
            TypeId = GoodsInfo#goods.gtid,
            Cell = GoodsInfo#goods.cell, 
            GoodsNum = GoodsInfo#goods.num,
            Stren = GoodsInfo#goods.stren_lv,
            Bind = GoodsInfo#goods.bind,
            <<GoodsId:64, TypeId:32, Cell:16, GoodsNum:16, Stren:8, Bind:8>>
        end,
    ListBin = list_to_binary(lists:map(F, GoodsList)),
    {ok, pt:pack(15002, <<Location:16, CellNum:16, Coin:32, BCoin:32, Gold:32, BGold:32, ListNum:16, ListBin/binary>>)};

%%扩充背包
write(15003, [Res, NewCoin, NewCellNum]) ->
    {ok, pt:pack(15003, <<Res:16, NewCellNum:16>>)};

%%背包拖动物品
write(15004, [Res, GoodsId1, GoodsTypeId1, OldCell, GoodsId2, GoodsTypeId2, NewCell]) ->
    {ok, pt:pack(15004, <<Res:16, GoodsId1:64, GoodsTypeId1:32, OldCell:16, GoodsId2:64, GoodsTypeId2:32, NewCell:16>>)};

%% 拆分物品
write(15005, [Res, GoodsId, GoodsNum]) ->
	{ok, pt:pack(15005, <<Res:16, GoodsId:64, GoodsNum:16>>)};

%%出售物品
write(15007, [Res, GoodsId, GoodsNum]) ->
    {ok, pt:pack(15007, <<Res:8, GoodsId:64, GoodsNum:16>>)};

%% 给洗炼属性加锁/解锁
write(15008, [Res, State]) ->
    {ok, pt:pack(15008, <<Res:8, State:8>>)};

%% 物品提示
write(15009, [Res, GoodsId, GoodsTid, AttriId, Value, NexTid, TaskId]) ->
    {ok, pt:pack(15009, <<Res:8, GoodsId:64, GoodsTid:32, AttriId:8, Value:32, NexTid:32, TaskId:32>>)};

%% 寄售物品
write(15008, [GoodsUniId, SellRecordId, RetCode]) ->
    Data = <<RetCode:8, GoodsUniId:64, SellRecordId:64>>,
    {ok, pt:pack(15008, Data)};

%% 使用物品
write(15009, [Res]) ->
      {ok, pt:pack(15009, <<Res:16>>)};

%% desc: 背包已满
write(15010, _) ->
    {ok, pt:pack(15108, <<>>)};

%% 查看特价区信息
write(15011, [Ltime, List]) ->
    F = fun({State, [Gtid, Gnum, Oprice, Price]}) ->
                <<Gtid:32, Gnum:16, Oprice:32, Price:32, State:8>>
        end,
    Bin = list_to_binary( lists:map(F, List) ),
    Len = length(List),
    {ok, pt:pack(15011, <<Ltime:32, Len:16, Bin/binary>>)};

%% 购买特价物品
write(15012, Res) ->
    {ok, pt:pack(15012, <<Res:8>>)};

%% %% 取商店物品列表
%% write(15013, [ShopType, ShopSubtype, ShopList, TotalPage]) ->
%%     ListNum = length(ShopList),
%%     F = fun(ShopInfo) -> 
%%             GoodsTid = ShopInfo#ets_shop.gtid,
%%             Oprice = ShopInfo#ets_shop.o_price,
%%             CurPrice = ShopInfo#ets_shop.price,
%% 			MaxBuy = ShopInfo#ets_shop.max,
%% 			Flag = ShopInfo#ets_shop.flag,
%%             <<GoodsTid:32, Oprice:32, CurPrice:32, MaxBuy:32, Flag:8>>
%%          end,
%%      ListBin = list_to_binary(lists:map(F, ShopList)),
%%     {ok, pt:pack(15013, <<ShopType:16, ShopSubtype:16, TotalPage:16, ListNum:16, ListBin/binary>>)};
%% 
%% %%购买物品
%% write(15014, [Res, GoodsTypeId, GoodsNum, ShopType, NewCoin, NewBcoin, NewGold, GoodsList]) ->
%%     ListNum = length(GoodsList),
%%     F = fun(GoodsInfo) ->
%%             GoodsId = GoodsInfo#goods.id,
%%             TypeId = GoodsInfo#goods.gtid,
%%             Cell = GoodsInfo#goods.cell,
%%             Num = GoodsInfo#goods.num,
%%             <<GoodsId:64, TypeId:32, Cell:16, Num:16>>
%%         end,
%%        ListBin = list_to_binary(lists:map(F, GoodsList)),
%%     {ok, pt:pack(15014, <<Res:16, GoodsTypeId:32, GoodsNum:16, ShopType:16, NewCoin:32, NewBcoin:32, NewGold:32, ListNum:16, ListBin/binary>>)};
%% 
%% %% 查看NPC商人出售的物品
%% write(15015, [List, TotalPage]) ->
%%     F = fun(GoodsSinfo) -> 
%%             GoodsTid = GoodsSinfo#ets_shop.gtid,
%%             PriceType = GoodsSinfo#ets_shop.price_type,
%%             CurPrice = GoodsSinfo#ets_shop.price,
%%             LeftNum = GoodsSinfo#ets_shop.max,
%%             <<GoodsTid:32, PriceType:8, CurPrice:32, LeftNum:16>>
%%          end,
%%     {Len, ListBin} = pack_array(List, F),
%%     {ok, pt:pack(15015, <<TotalPage:8, Len:16, ListBin/binary>>)};
%% 
%% %% 购买NPC商人出售的物品
%% write(15016, Res) ->
%%     {ok, pt:pack(15016, <<Res:8>>)};
%% 
%%装备物品
write(15017, [Res, GoodsId, PartnerId, OldGoodsId, OldGoodsCell]) ->
	{ok, pt:pack(15017, <<Res:8, GoodsId:64, PartnerId:64, OldGoodsId:64, OldGoodsCell:16>>)};

%%卸下装备
write(15018, [Res, GoodsId, PartnerId, Cell]) ->
    {ok, pt:pack(15018, <<Res:16, GoodsId:64, PartnerId:64, Cell:16>>)};

%%装备强化
write(15019, [Res, GoodsId, NewStrengthen, Degree, CostStone, CostGold, CostCoin]) ->
	{ok, pt:pack(15019, <<Res:8, GoodsId:64, NewStrengthen:8, Degree:8, CostStone:16, CostGold:16, CostCoin:16>>)};

%%洗附加属性
write(15020, [Res, GoodsId]) ->
    {ok, pt:pack(15020, <<Res:16, GoodsId:64>>)};

%% 查看装备的洗炼属性
write(15021, [GoodsId, CurList, NewList]) ->
    Result = ?RESULT_OK,
    F = fun({SeqId, AttriId, WashLv, Val, IsLock}) -> 
                <<SeqId:32, AttriId:16, WashLv:16, Val:16, IsLock:16>>
        end,
    CurLen = length(CurList),
    NewLen = length(NewList),
    CurBin = list_to_binary( lists:map(F, CurList) ),
    NewBin = list_to_binary( lists:map(F, NewList) ),
    {ok, pt:pack(15021, <<Result:8, GoodsId:64, CurLen:16, CurBin/binary, NewLen:16, NewBin/binary>>)};

%%宝石镶嵌
write(15022, [Res, GoodsId]) ->
    {ok, pt:pack(15022, <<Res:16, GoodsId:64>>)};
%% 
%% %%宝石拆除
%% write(15023, [Res, GoodsId, NewCoin]) ->
%%     {ok, pt:pack(15023, <<Res:16, GoodsId:64, NewCoin:32>>)};
%% 
%% %%宝石合成
%% write(15024, [Res, NewTid]) ->
%%     {ok, pt:pack(15024, <<Res:16, NewTid:32>>)};
%% 
%% %% desc: 查询玩家或武将的全身强化奖励类型
%% write(15025, [TargetId, TargetType, RewardType, Tnum, Num7, Num8, Num9, Num10, Num11, Num12]) ->
%% 	{ok, pt:pack(15025, <<TargetId:64, TargetType:8, RewardType:8, Num7:8, Num8:8, Num9:8, Tnum:8, Num10:8, Num11:8, Num12:8>>)};
%% 
%% %% 查询其他玩家装备列表
%% write(15026, [Res, GoodsList]) -> 
%%     ListNum = length(GoodsList),
%%     F = fun(GoodsInfo) ->
%%             GoodsId = GoodsInfo#goods.id,
%%             TypeId = GoodsInfo#goods.gtid,
%%             Cell = GoodsInfo#goods.cell,
%%             GoodsNum = GoodsInfo#goods.num,
%%             Stren   = GoodsInfo#goods.stren,
%%             <<GoodsId:64, TypeId:32, Cell:16, GoodsNum:16, Stren:8>>
%%         end,
%%     ListBin = list_to_binary(lists:map(F, GoodsList)),
%%     {ok, pt:pack(15002, <<Res:8, ListNum:16, ListBin/binary>>)};
%% 
%% 洗炼替换
write(15027, [Res, GoodsId]) ->
    {ok, pt:pack(15027, <<Res:8, GoodsId:64>>)};

%% 丢弃物品
write(15028, [Res, GoodsId, GoodsNum]) ->
    {ok, pt:pack(15028, <<Res:8, GoodsId:64, GoodsNum:16>>)};

%% 丢弃物品
write(15029, [Res, GoodsId, GildingLv]) ->
    {ok, pt:pack(15029, <<Res:8, GoodsId:64, GildingLv:8>>)};

write(_Cmd, _R) ->
    {ok, pt:pack(0, <<>>)}.
%% 
%% %% internal
%% %% desc: 将掉落信息转换为二进制
%% convert_drop_info(DropList) ->
%% 	List = lists:map(fun(Info) -> 
%% 							 GoodsTypeId = Info#ets_drop_content.gtid,
%% 							 Num = Info#ets_drop_content.num,
%% 							 <<GoodsTypeId:32, Num:32>> 
%% 					   end, DropList),
%% 	list_to_binary(List).
%% 
%% %% internal
%% %% desc: 选取属性字段
convert_attri(AttributeInfo) -> ok.
%%     AttriType = AttributeInfo#goods_attribute.attribute_type,
%%     AttriId = AttributeInfo#goods_attribute.attribute_id,  %0血，1物理攻击，2法术攻击，3绝技攻击，4物理防御，5法术防御，6绝技防御，7追击，8格挡，9命中，10躲避，11暴击
%%     AttriPublic = AttributeInfo#goods_attribute.public,   % 该值表示：镶嵌宝石的孔位置/洗炼属性的星级 
%%     AttriStone = AttributeInfo#goods_attribute.stone_type_id,
%%     AttriVal = AttributeInfo#goods_attribute.value,
%%     <<AttriType:16, AttriId:16, AttriPublic:16, AttriStone:32, AttriVal:32>>.
%% 
convert_HoleInfo(HolesInfo) ->
	{Id, GoodsTid} = HolesInfo,
	<<Id:8, GoodsTid:32>>.

%% %% internal
%% %% 数组打包
%% pack_array(List, Func) ->
%%     {length(List), list_to_binary( lists:map(Func, List) )}.
%% 
%% pack_medicine_info(Career,MedInfo) ->
%% 	ok.
%% 
%% %% desc: 转换为ID列表
parse_id_list(0, _, List) -> List;
parse_id_list(AttriLen, <<Id:32, Res/binary>>, List) -> List.
%%     parse_id_list(AttriLen - 1, Res, [Id | List]).