-ifndef(__LOG__).
-define(__LOG__, log).

%%货币流通记录
%元宝类
-define(EXPAND_PACK, 1001).  % 扩展背包

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
-define(LOG_GODTRIED, 2015).		%宝石神炼
-define(LOG_EQUIP_UPG, 2016).		%装备升级
-define(LOG_PRODUCE_COMPOSE, 2019).	%生产合成
-define(LOG_MARKET_FEE, 2020).		%拍卖手续费
-define(LOG_MAIL_FEE, 2021).		%邮件手续费
-define(LOG_CREATE_GUILD_FEE, 2022).%创建帮派费
-define(LOG_MAIL_COIN, 2023).		%邮件寄送
-define(LOG_MARKET_BUY, 2024).		%拍卖行购买
-define(LOG_MARKET_SELL_MONEY, 2025).%拍卖行挂售货币
-define(LOG_TASK_GOLD, 1039).		%任务系统的元宝花费
-define(LOG_AUTO_FINISH_TASK,1040). %消耗元宝自动完成任务
-define(LOG_BUY_NPC_GOODS, 3001).	%购买NPC商店物品
-define(LOG_SHOP_BUY, 3002).		%购买商城物品


%% 物品消耗类型操作日志
-define(LOG_USE_GOODS, 1).				%使用物品
-define(LOG_ABANDON_GOODS, 2).			%丢弃物品
-define(LOG_MAIL_GOODS, 3).				%邮寄物品
-define(LOG_MARKET_GOODS, 4).			%挂售物品
-define(LOG_SELL_GOODS, 5).				%出售物品
-define(LOG_INLAY_GOODS, 6).			% 镶嵌宝石
-define(LOG_POLISH_GOODS, 7).			% 洗练消耗
-define(LOG_STREN_GOODS, 8).			% 强化消耗
-define(LOG_GILING_GOODS, 9).			% 镀金
-define(LOG_UPG_GOODS, 10).		%装备升级
-define(LOG_COMPOSE_GOODS, 11).			%宝石合成
-define(LOG_GODTRIED_GOODS, 12).		%宝石神炼

%%物品来源操作
-define(LOG_GOODS_TREA_REFRESH, 1).		%淘宝刷新物品
-define(LOG_GOODS_SHOP_BUY, 2).			%商城购买物品
-define(LOG_GOODS_SELL, 3).				%售卖物品
-define(LOG_GOODS_MAIL, 4).             %邮件系统发放

-define(LOG_GOODS_TASK, 1000).     % 任务奖励
-define(LOG_GOODS_MON, 2000).     % 打怪掉落

-endif.
