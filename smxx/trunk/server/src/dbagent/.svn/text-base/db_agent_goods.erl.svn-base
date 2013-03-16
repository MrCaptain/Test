%%%--------------------------------------
%%% @Module  : db_agent_player
%%% @Author  :
%%% @Created :
%%% @Description: 物品处理模块
%%%--------------------------------------
-module(db_agent_goods).

-include("common.hrl").
-include("record.hrl").

-compile(export_all).


%% 获取商城模版数据
get_all_shop_goods() ->
	case ?DB_MODULE:select_all(temp_shop, "*", []) of
		DataList when is_list(DataList) andalso length(DataList) >  0 ->
			Fun = fun(DataItem) ->
						  list_to_tuple([temp_shop|DataItem])
				  end ,
			lists:map(Fun,DataList);
		_ ->
			[]
	end.

%%获取在线玩家背包物品表
%%玩家登陆成功后获取
get_player_goods_by_uid(PlayerId) ->	
	case ?DB_MODULE:select_all(goods, "*", [{uid, PlayerId}]) of
		DataList when is_list(DataList) andalso length(DataList) >  0 ->
			Fun = fun(DataItem) ->
						  list_to_tuple([goods|DataItem])
				  end ,
			lists:map(Fun,DataList) ;
		_ ->
			[]
	end .

%%删除物品
delete_goods(GoodsId) ->
	?DB_MODULE:delete(goods, [{id, GoodsId}]).

%%添加新物品
add_goods(GoodsInfo) ->
    ValueList = lists:nthtail(2, tuple_to_list(GoodsInfo)),
    [id | FieldList] = record_info(fields, goods),
	Ret = ?DB_MODULE:insert_get_id(goods, FieldList, ValueList),
    Ret.

%% 获取物品ID的信息
%% 对要判断物品是否存在时查询
get_goods_by_id(GoodsId) ->
	?DB_MODULE:select_row(goods, "*",
								 [{id, GoodsId}],
								 [],
								 [1]).
%% 获取物品ID的信息(交易时批量查询)
get_goods_by_ids(GoodsIdList) ->
	?DB_MODULE:select_all(goods, "*", [{id, "in", GoodsIdList}]).

%% 更新物品信息
update_goods(Field, Data, Key, Value) ->
	?DB_MODULE:update(goods, Field, Data, Key, Value).

%%添加物品附加属性
add_goods_attri(GoodsAtrriInfo) ->
    ValueList = lists:nthtail(2, tuple_to_list(GoodsAtrriInfo)),
    [id | FieldList] = record_info(fields, goods_attribute),
	Ret = ?DB_MODULE:insert_get_id(goods_attribute, FieldList, ValueList),
    Ret.

%%删除物品附加属性
del_goods_attri(GoodsId, StoneTypeId, HoleSeq) ->
	?DB_MODULE:delete(goods, [{id, GoodsId}, {stone_type_id, StoneTypeId}, {hole_seq, HoleSeq}]).

%% 玩家登陆成功后获取物品cd
get_goods_cd_by_uid(PlayerId) ->	
	case ?DB_MODULE:select_all(goods_cd, "*", [{uid, PlayerId}]) of
		DataList when is_list(DataList) andalso length(DataList) >  0 ->
			Fun = fun(DataItem) ->
						  list_to_tuple([goods_cd|DataItem])
				  end ,
			lists:map(Fun,DataList) ;
		_ ->
			[]
	end.

%% 更新物品cd信息
update_goods_cd(Field, Data, Key, Value) ->
	?DB_MODULE:update(goods_cd, Field, Data, Key, Value).

%%添加物品cd
add_goods_cd(GoodsCDInfo) ->
    ValueList = lists:nthtail(2, tuple_to_list(GoodsCDInfo)),
    [id | FieldList] = record_info(fields, goods_cd),
	Ret = ?DB_MODULE:insert_get_id(goods_cd, FieldList, ValueList),
    Ret.

%%删除物品cd
del_goods_cd(GoodsCDId) ->
	?DB_MODULE:delete(goods_cd, [{id, GoodsCDId}]).