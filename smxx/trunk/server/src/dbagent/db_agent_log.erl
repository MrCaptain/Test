%% Author: Administrator
%% Created: 2013-3-6
%% Description: TODO: Add description to db_agent_log
-module(db_agent_log).

-include("common.hrl").
-include("record.hrl").

-compile(export_all).

%% 铜钱消耗日志
insert_cost_coin(PlayerId, CostCoin, CostBCoin, CostType) ->
	?DB_LOG_MODULE:insert(log_cost_coin, [uid, coin, bcoin, cost_type], [PlayerId, CostCoin, CostBCoin, CostType]).

%% 元宝消耗日志
insert_cost_gold(PlayerId, CostGold, CostBGold, CostType) ->
	?DB_LOG_MODULE:insert(log_cost_gold, [uid, gold, bgold, cost_type], [PlayerId, CostGold, CostBGold, CostType]).

%% 物品消耗
insert_cost_goods(PlayerId, Gtid, GoodsNum, Bind, Source) ->
	?DB_LOG_MODULE:insert(log_cost_goods, [uid, gtid, num, bind, cost_type], [PlayerId, Gtid, GoodsNum, Bind, Source]).

%% 发放铜钱
insert_add_coin(PlayerId, Money, Source) ->
	?DB_LOG_MODULE:insert(log_add_coin, [uid, num, type, source], [PlayerId, Money, 1, Source]).

%% 发放绑定铜钱
insert_add_bcoin(PlayerId,Money, Source) ->
	?DB_LOG_MODULE:insert(log_add_coin, [uid, num, source], [PlayerId, Money, Source]).

%% 发放元宝
insert_add_gold(PlayerId,Money, Source) ->
	?DB_LOG_MODULE:insert(log_add_gold, [uid, num, type, source], [PlayerId, Money, 1, Source]).

%% 发放绑定元宝
insert_add_bgold(PlayerId,Money, Source) ->
	?DB_LOG_MODULE:insert(log_add_gold, [uid, num, source], [PlayerId, Money, Source]).

%% 发放物品
insert_add_goods(PlayerId, Gtid, GoodsNum, Bind, Source) ->
	?DB_LOG_MODULE:insert(log_add_goods, [uid, gtid, num, bind, add_type], [PlayerId, Gtid, GoodsNum, Bind, Source]).