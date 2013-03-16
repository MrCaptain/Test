-ifndef(__COMMON_LOG__).
-define(__COMMON_LOG__, common_log).

%%货币流通记录
%元宝类-define(EXPAND_PACK, 1001).  % 扩展背包

-define(CANCEL_COOL_DOWN, 1005).	%消除CD时间
-define(LOG_TREASURE_CURRENCY, 1006).	%%寻灵
-define(LOG_OPEN_REMOTE_SHOP, 1012).	%打开远程道具店

%金钱类
-define(LOG_GILING, 2009).			%镀金
-define(LOG_STREN, 2010).			%强化
-define(LOG_POLISH, 2011).			%洗练
-define(LOG_COMPOSE, 2012).			%宝石合成
-define(LOG_INLAY, 2013).			%宝石镶嵌
-define(LOG_BACLOUT, 2014).			%宝石拆除
-define(LOG_BREAKDOWN, 2015).		%装备分解
-define(LOG_EQUIP_UPG, 2016).		%装备升级
-define(LOG_EQUIP_ADV, 2017).		%装备进阶
-define(LOG_PRODUCE_COMPOSE, 2019).			%生产合成
-define(LOG_MARKET_FEE, 2020).		%拍卖手续费
-define(LOG_MAIL_FEE, 2021).		%邮件手续费
-define(LOG_CREATE_GUILD_FEE, 2022).		%创建帮派费
-define(LOG_MAIL_COIN, 2023).		%邮件寄送
-define(LOG_MARKET_BUY, 2024).		%拍卖行购买
-define(LOG_MARKET_SELL_MONEY, 2025).	%拍卖行挂售货币
-define(LOG_TASK_GOLD, 1039).	%任务系统的元宝花费
-define(LOG_AUTO_FINISH_TASK,1040). %消耗元宝自动完成任务
%综合类(元宝/金钱)
-define(LOG_BUY_GOODS, 3001).		%购买物品
-define(LOG_CONSUME_CURRENCY, 1).		%消费货币
-define(LOG_GAIN_CURRENCY, 2).			%获得货币

-define(LOG_CURRENCY_ERROR, 0).	%%错误货币类型
-define(LOG_GOLD, 1).		% 元宝
-define(LOG_BGOLD, 2).		% 绑定元宝
-define(LOG_COIN, 3).		% 金钱
-define(LOG_BCOIN, 4).		% 绑定金钱

%%背包物品操作日志
-define(LOG_USE_GOODS, 1).				%使用物品
-define(LOG_ABANDON_GOODS, 2).			%丢弃物品
-define(LOG_MAIL_GOODS, 3).				%邮寄物品
-define(LOG_MARKET_GOODS, 4).			%挂售物品

%%物品来源操作
%操作
-define(LOG_GOODS_TREA_REFRESH, 1).		%淘宝刷新物品
-define(LOG_GOODS_BUY, 2).				%购买物品
-define(LOG_GOODS_SELL, 3).				%售卖物品

-endif.