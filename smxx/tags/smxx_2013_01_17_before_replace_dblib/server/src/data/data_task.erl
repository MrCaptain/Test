%%%---------------------------------------
%%% @Module  : data_task
%%% @Author  : csj
%%% @Created : 2010-11-03 17:08:37
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_task).

-compile(export_all).
-include("record.hrl").

count_daily_task_data(Grade, Coin, Exp) ->
	[Coin1,Exp1, Num] =
		case Grade of
			1 -> [1.0 * Coin, 1.0 * Exp, 1];
			2 -> [1.2 * Coin, 1.2 * Exp, 2];
			3 -> [1.5 * Coin, 1.5 * Exp, 3];
			4 -> [1.7 * Coin, 1.8 * Exp, 4];
			5 -> [2.0 * Coin, 2.3 * Exp, 5];
			_ -> [0, 0, 0]
		end,
	[trunc(Coin1), trunc(Exp1), Num].

task_daily_gold(Time) ->
	if 
		Time =< 0 -> 0;
		true -> 2
	end.

get_week_exp_coin(Level) ->
	if 
		Level =< 20 -> [60000, 12000];
		Level =< 30 -> [120000, 18000];
		Level =< 40 -> [150000, 24000];
		Level =< 50 -> [216000, 30000];
		Level =< 60 -> [360000, 36000];
		true -> [576000, 42000]
	end.

get_new_week_list(_Status) ->
	%%174001 十年灵粹  174002 百年灵粹 174003 千年灵粹
	%[Exp, Coin] = get_week_exp_coin(Status#player.lv),
	
	WeekList = [[1, 0, 0, 5,[{210301,0}]], 
			 [2, 0, 0, 10, [{210301,0}]],
			 [3, 0, 0, 15, [{210301,0}]],
			 [4, 0, 0, 20, [{210301,0}]]],
	
	WeekList.

get_week_goodslist_by_id(Id, Lv) ->
	[Exp, Coin] = get_week_exp_coin(Lv),

	case Id of
		1 -> {trunc(0.1 * Coin), [{210301,trunc(0.1 * Exp)}]};
		2 -> {trunc(0.2 * Coin), [{210301,trunc(0.2 * Exp)}]};
		3 -> {trunc(0.3 * Coin), [{210301,trunc(0.3 * Exp)}]};
		4 -> {trunc(0.4 * Coin), [{210301,trunc(0.4 * Exp)}]};
		_ -> {0, []}
	end.
	
	
			
%%获取联盟任务的刷新规则
get_task_guild_conf(Type, Param) ->
	case Type of
		level ->
			15;								%%联盟任务需要的最低人物等级
		most_times  ->
			5;								%%每天能做的任务数
		cost ->
			2*Param;						%%刷新所需元宝
		qly ->
			if Param =< 200 ->
				   {1,1,1};					%%奖励品质, 奖励加倍系数, 玉牌加倍系数
			   Param > 200 andalso Param =< 570 ->
				   {2,1.5,1.15};
			   Param > 570 andalso Param =< 770 ->
				   {3,2.25,1.4};
			   Param > 770 andalso Param =< 920 ->
				   {4,3.5,1.7};
			   Param > 920 andalso Param =< 1000 ->
				   {5,5,2};
			   true ->
				   {1,1,1}
			end
	end.

%%新版每日任务ID列表
get_task_day_id_list() ->
	[1,2].

%%根据每日任务的类型得到任务ID
get_task_day_id_by_type(TaskType) ->
	case TaskType of
		water_tree ->
			1;
		guild_donate ->
			2;
		_ ->
			0
	end.

%%根据新版每日任务ID获取任务完成条件
get_task_day_finish_condition(Tid) ->
	case Tid of
		1 ->
			2;
		2 ->
			20000;
		_ ->
			0
	end.
	
				   
%%根据新版每日任务ID获取奖励物品
get_task_day_reward(Tid, Lv) ->
	case Tid of
		1 ->
			[{210101, 10+Lv}];
		2 ->
			[{210101, 10+Lv}];
		_ ->
			[]
	end.

daily_task_reward(Lv, Grade) ->
	if
		Lv =< 30 -> [Coin, Exp] = [30, 130];
		Lv =< 43 -> [Coin, Exp] = [30, 160];
		Lv =< 50 -> [Coin, Exp] = [30, 200];
		Lv =< 60 -> [Coin, Exp] = [30, 260];
		true -> [Coin, Exp] = [30, 340]
	end,
	case Grade of
		1 -> [Coin * Lv * Grade, Exp * Lv * Grade];
		2 -> [Coin * Lv * Grade, Exp * Lv * Grade];
		3 -> [Coin * Lv * Grade, Exp * Lv * Grade];
		4 -> [Coin * Lv * Grade, Exp * Lv * Grade];
		5 -> [Coin * Lv * 6, Exp * Lv * 6];
		_ -> [0, 0]
	end.

		
%% %% 临时屏蔽
%% -export([get/2,
%% 		get_id_list/0,
%% 		get_main_id_list/0,
%% 		get_btanch_id_list/0,
%% 		get_daily_id_list/0,
%% 		get_carry_id_list/1,
%% 		get_novice_id_list/0,
%% 		 get_cycle_id_list/0
%% 		]).
%% -include("common.hrl").
%% -include("record.hrl").
%% 
%% %%所有任务id
%% get_id_list() ->
%% 	[20100,20201,20202,20203,20204,20205,20206,20207,20208,20209,20210,20211,20212,20213,20214,20215,20216,20217,20218,20219,20223,30100,30101,40100].
%% 	
%% %%新手任务
%% get_novice_id_list() ->
%% 	[20100,20201,20202,20203,20204,20205,20206,20207,20208,20209,20210,20211,20212,20213,20214,20215,20216,20217,20218,20219,20223].
%% 	
%% %%主线任务id列表
%% get_main_id_list()->
%% 	[20100,20201,20202,20203,20204,20205,20206,20207,20208,20209,20210,20211,20212,20213,20214,20215,20216,20217,20218,20219,20223].
%% 	
%% %%支线任务id列表
%% get_btanch_id_list()->
%% 	[40100 ].
%% 
%% %%日常任务id列表
%% get_daily_id_list()->
%% 	[].
%% 
%% %%循环任务列表
%% get_cycle_id_list()->
%% 	[].
%% 
%% %%运镖任务id列表 
%% get_carry_id_list(1) ->
%% 	[30101];
%% get_carry_id_list(2) ->
%% 	[30100];
%% get_carry_id_list(3) ->
%% 	[].	
%% get(20100, _PS) ->
%% 	#task{
%% 		id=20100, 
%% 		name = <<"命运之子">>, 
%% 		desc = <<"与九天玄女对话，背负命运的使命。">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 1,
%% 		repeat = 0,
%% 		camp = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 0,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 0,
%% 		end_npc = 10103,
%% 		start_talk = 0,
%% 		end_talk = 1970,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10103, 1970]],
%% 		state = 0,
%% 		exp = 150,
%% 		coin = 50,
%% 		gold = 0,
%% 		spt = 60,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20201, _PS) ->
%% 	#task{ 
%% 		id=20201, 
%% 		name = <<"仙子赠物">>, 
%% 		desc = <<"NPC独白啊独白还没搞出来~">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 2,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20100,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10103,
%% 		end_npc = 10103,
%% 		start_talk = 2000,
%% 		end_talk = 0,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10103, 0]],
%% 		state = 0,
%% 		exp = 2000,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20202, _PS) ->
%% 	#task{ 
%% 		id=20202, 
%% 		name = <<"蓬莱仙翁">>, 
%% 		desc = <<"寻找蓬莱仙翁">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 3,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20201,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10103,
%% 		end_npc = 10101,
%% 		start_talk = 1997,
%% 		end_talk = 2002,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10101, 2002]],
%% 		state = 0,
%% 		exp = 2000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20203, _PS) ->
%% 	#task{ 
%% 		id=20203, 
%% 		name = <<"前尘往事">>, 
%% 		desc = <<"与蓬莱仙翁对话知前尘后事！">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 3,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20202,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10101,
%% 		start_talk = 1990,
%% 		end_talk = 0,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10101, 0]],
%% 		state = 0,
%% 		exp = 2500,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20204, _PS) ->
%% 	#task{ 
%% 		id=20204, 
%% 		name = <<"初试身手">>, 
%% 		desc = <<"消灭鱼精，初试身手!">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 4,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20203,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10101,
%% 		start_talk = 1991,
%% 		end_talk = 2001,
%% 		unfinished_talk = 2004,
%% 		condition = [],
%% 		content = [[0,0, kill, 10113, 2, 0],[1,1, end_talk, 10101, 2001]],
%% 		state = 1,
%% 		exp = 30000,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20205, _PS) ->
%% 	#task{ 
%% 		id=20205, 
%% 		name = <<"参见师傅">>, 
%% 		desc = <<"拜灵儿为师">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 4,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20204,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10107,
%% 		start_talk = 1974,
%% 		end_talk = 1975,
%% 		unfinished_talk = 1976,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10107, 1975]],
%% 		state = 0,
%% 		exp = 3000,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20206, _PS) ->
%% 	#task{ 
%% 		id=20206, 
%% 		name = <<"技能学习">>, 
%% 		desc = <<"灵儿教你学技能！">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 5,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20205,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10107,
%% 		end_npc = 10107,
%% 		start_talk = 1982,
%% 		end_talk = 0,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10107, 0]],
%% 		state = 0,
%% 		exp = 40000,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20207, _PS) ->
%% 	#task{ 
%% 		id=20207, 
%% 		name = <<"再试身手">>, 
%% 		desc = <<"使用技能消灭3个熊人！">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 5,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20206,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10107,
%% 		end_npc = 10107,
%% 		start_talk = 2014,
%% 		end_talk = 2015,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 10121, 3, 0],[1,1, end_talk, 10107, 2015]],
%% 		state = 1,
%% 		exp = 1000,
%% 		coin = 100,
%% 		binding_coin = 0,
%% 		spt = 100,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 0
%% 	};
%% get(20208, _PS) ->
%% 	#task{ 
%% 		id=20208, 
%% 		name = <<"先行一步">>, 
%% 		desc = <<"打倒鱼精王收集一张【引路符咒】。">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 6,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20207,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10107,
%% 		end_npc = 10107,
%% 		start_talk = 1985,
%% 		end_talk = 1979,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 10122, 1, 0],[1,1, end_talk, 10107, 1979]],
%% 		state = 1,
%% 		exp = 5000,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20209, _PS) ->
%% 	#task{ 
%% 		id=20209, 
%% 		name = <<"夺回草药">>, 
%% 		desc = <<"替采药人去灵芝妖那收集5个草药。">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 6,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20208,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10102,
%% 		end_npc = 10102,
%% 		start_talk = 1986,
%% 		end_talk = 1980,
%% 		unfinished_talk = 2003,
%% 		condition = [],
%% 		content = [[0,0, kill, 20111, 5, 0],[1,1, end_talk, 10102, 1980]],
%% 		state = 1,
%% 		exp = 5000,
%% 		coin = 50,
%% 		binding_coin = 0,
%% 		spt = 50,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 0
%% 	};
%% get(20210, _PS) ->
%% 	#task{ 
%% 		id=20210, 
%% 		name = <<"使用血包">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 6,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20209,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10102,
%% 		end_npc = 10102,
%% 		start_talk = 2042,
%% 		end_talk = 0,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10102, 0]],
%% 		state = 0,
%% 		exp = 1000,
%% 		coin = 100,
%% 		binding_coin = 0,
%% 		spt = 100,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20211, _PS) ->
%% 	#task{ 
%% 		id=20211, 
%% 		name = <<"妖魔作乱">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 7,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20210,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10105,
%% 		end_npc = 10105,
%% 		start_talk = 2017,
%% 		end_talk = 2018,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 20114, 5, 0],[1,1, end_talk, 10105, 2018]],
%% 		state = 1,
%% 		exp = 2500,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20212, _PS) ->
%% 	#task{ 
%% 		id=20212, 
%% 		name = <<"养生蜂蜜">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 7,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20211,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10105,
%% 		end_npc = 10104,
%% 		start_talk = 2025,
%% 		end_talk = 2026,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 20114, 5, 0],[1,1, end_talk, 10104, 2026]],
%% 		state = 1,
%% 		exp = 1000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20213, _PS) ->
%% 	#task{ 
%% 		id=20213, 
%% 		name = <<"拯救白狐">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 8,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20212,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10104,
%% 		end_npc = 10104,
%% 		start_talk = 2027,
%% 		end_talk = 2028,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 20115, 5, 0],[1,1, end_talk, 10104, 2028]],
%% 		state = 1,
%% 		exp = 3500,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 0
%% 	};
%% get(20214, _PS) ->
%% 	#task{ 
%% 		id=20214, 
%% 		name = <<"召唤灵兽">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 8,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20213,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10104,
%% 		end_npc = 10104,
%% 		start_talk = 2043,
%% 		end_talk = 0,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10104, 0]],
%% 		state = 0,
%% 		exp = 2500,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20215, _PS) ->
%% 	#task{ 
%% 		id=20215, 
%% 		name = <<"归城之路">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 8,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20214,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10104,
%% 		end_npc = 10108,
%% 		start_talk = 2030,
%% 		end_talk = 2031,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10108, 2031]],
%% 		state = 0,
%% 		exp = 5000,
%% 		coin = 500,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20216, _PS) ->
%% 	#task{ 
%% 		id=20216, 
%% 		name = <<"慈父孽子">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 9,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20215,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10108,
%% 		end_npc = 10106,
%% 		start_talk = 2032,
%% 		end_talk = 2033,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10106, 2033]],
%% 		state = 0,
%% 		exp = 5000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20217, _PS) ->
%% 	#task{ 
%% 		id=20217, 
%% 		name = <<"人面妖心">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 9,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20216,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10106,
%% 		end_npc = 10106,
%% 		start_talk = 2034,
%% 		end_talk = 2035,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 20116, 5, 0],[1,1, end_talk, 10106, 2035]],
%% 		state = 1,
%% 		exp = 5000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 0
%% 	};
%% get(20218, _PS) ->
%% 	#task{ 
%% 		id=20218, 
%% 		name = <<"执迷不悟 ">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 1,
%% 		level = 10,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20217,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10106,
%% 		end_npc = 10108,
%% 		start_talk = 2036,
%% 		end_talk = 2037,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, kill, 20116, 5, 0],[1,1, end_talk, 10108, 2037]],
%% 		state = 1,
%% 		exp = 5000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(20219, _PS) ->
%% 	#task{ 
%% 		id=20219, 
%% 		name = <<"进城送信">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 10,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20218,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10108,
%% 		end_npc = 10111,
%% 		start_talk = 2038,
%% 		end_talk = 2039,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10111, 2039]],
%% 		state = 0,
%% 		exp = 5000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 0
%% 	};
%% get(20223, _PS) ->
%% 	#task{ 
%% 		id=20223, 
%% 		name = <<"装备法宝">>, 
%% 		desc = <<"描述">>,
%% 		type = 4,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 4,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 20203,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10101,
%% 		start_talk = 2040,
%% 		end_talk = 2041,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,1, end_talk, 10101, 2041]],
%% 		state = 0,
%% 		exp = 200,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(30100, _PS) ->
%% 	#task{ 
%% 		id=30100, 
%% 		name = <<"运镖任务">>, 
%% 		desc = <<"给夫子送书">>,
%% 		type = 2,
%% 		child = 3,
%% 		kind = 0,
%% 		level = 3,
%% 		repeat = 1,
%% 		realm = 2,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 0,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10102,
%% 		start_talk = 2005,
%% 		end_talk = 2006,
%% 		unfinished_talk = 0,
%% 		condition = [{daily_limit, 3}],
%% 		content = [[0,1, end_talk, 10102, 2006]],
%% 		state = 0,
%% 		exp = 10000,
%% 		coin = 10000,
%% 		binding_coin = 0,
%% 		spt = 1000,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 0
%% 	};
%% get(30101, _PS) ->
%% 	#task{ 
%% 		id=30101, 
%% 		name = <<"运镖任务">>, 
%% 		desc = <<"描述">>,
%% 		type = 2,
%% 		child = 3,
%% 		kind = 0,
%% 		level = 3,
%% 		repeat = 1,
%% 		realm = 1,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 0,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10103,
%% 		start_talk = 2011,
%% 		end_talk = 2012,
%% 		unfinished_talk = 0,
%% 		condition = [{daily_limit, 3}],
%% 		content = [[0,1, end_talk, 10103, 2012]],
%% 		state = 0,
%% 		exp = 1000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(40100, _PS) ->
%% 	#task{ 
%% 		id=40100, 
%% 		name = <<"借书">>, 
%% 		desc = <<"描述">>,
%% 		type = 1,
%% 		child = 0,
%% 		kind = 0,
%% 		level = 1,
%% 		repeat = 0,
%% 		realm = 0,
%% 		career = 0,
%% 		accept_time = [],
%% 		prev = 0,
%% 		next = 0,
%% 		start_item = [],
%% 		end_item = [],
%% 		start_npc = 10101,
%% 		end_npc = 10101,
%% 		start_talk = 2007,
%% 		end_talk = 2008,
%% 		unfinished_talk = 0,
%% 		condition = [],
%% 		content = [[0,0, talk, 10102, 2010],[1,1, end_talk, 10101, 2008]],
%% 		state = 1,
%% 		exp = 1000,
%% 		coin = 0,
%% 		binding_coin = 0,
%% 		spt = 0,
%% 		attainment = 0,
%% 		contrib = 0,
%% 		guild_exp = 0,
%% 		award_item = [],
%% 		award_select_item = [],
%% 		award_select_item_num = 0,
%% 		award_gift = [],
%% 		start_cost = 0,
%% 		end_cost = 0,
%% 		next_cue = 1
%% 	};
%% get(_An, _) ->
%% 	null.
