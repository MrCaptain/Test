%%%------------------------------------
%%% @Module  : mod_kernel
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 核心服务
%%%------------------------------------
-module(mod_kernel).
-behaviour(gen_server).
-export([   start_link/0,
			load_base_data/0,
			load_base_data/1
        ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").
-include("goods.hrl").

-define(AUTO_LOAD_GOODS, 10*60*1000).  %%每10分钟加载一次数据(正式上线后，去掉)


start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) ->
	misc:write_monitor_pid(self(),?MODULE, {0}),
	%%初始ets表
    init_ets(),
	%%初始数据库
	main:init_db(server),
	%% 加载模板数据 
	load_base_data(),
	%% 创建物品表
    ok = init_goods_ets(),
	ok = goods_util:init_goods_rule(),

	{ok, 1}.

handle_cast({set_load, Load_value}, Status) ->
%% 	io:format("~s Server stopping......~n",[misc:time_format(now())]),	
	misc:write_monitor_pid(self(),?MODULE, {Load_value}),
	{noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info({event, load_data}, Status) ->
	%% 加载基础数据
	load_base_data(),
	erlang:send_after(?AUTO_LOAD_GOODS, self(), {event, load_data}),  %% 重复加载一次数据
	{noreply, Status};

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(normal, Status) ->
	misc:delete_monitor_pid(self()),
	io:format("~s terminate finished************  [~p]\n",[misc:time_format(now()), mod_kernel]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% ================== 私有函数 =================
%% 加载基础数据
load_base_data() ->
	%%io:format("~s load_base_data......~n",[misc:time_format(now())]),
	load_base_data(scene),				%%加载场景模板
	load_base_data(task),				%%加载任务数据
	load_base_data(npc),				%%加载场景模板
	load_base_data(npc_layout),			%%加载场景模板
	load_base_data(mon_layout),			%%加载场景模板
	ok .

%%@spec 加载场景模板
load_base_data(scene) ->
	lib_scene:load_temp_scene() ,
	ok ;

%%@spec 加载NPC模板
load_base_data(npc) ->
	lib_scene:load_temp_npc() ,
	ok ;

%%@spec 加载NPC布局模板
load_base_data(npc_layout) ->
	lib_scene:load_temp_npc_layout() ,
	ok ;

%%@spec 加载怪物
load_base_data(mon_layout) ->
	lib_scene:load_temp_mon_layout() ,
	ok ;
 
%%@spec 加载任务
load_base_data(task) ->
  	ok = lib_task:init_base_task(),  
	ok = lib_task:init_base_task_detail(),
%% 	ok = lib_npc:init_base_talk(),    %%初始化基础对话
	ok;

load_base_data(_) ->  
	ok.

%%初始ETS表
init_ets() ->
	ets:new(?ETS_ONLINE, [{keypos,#player.id}, named_table, public, set,{read_concurrency,true}]), 				%%本节点在线用户列表
 	ets:new(?ETS_ONLINE_SCENE, [{keypos,#player.id}, named_table, public, set,{read_concurrency,true}]),  		%%本节点加载场景在线用户列表
	ets:new(?ETS_TEMP_SCENE, [{keypos, #temp_scene.id}, named_table, public, set,{read_concurrency,true}]), 	%%基础场景配置
	ets:new(?ETS_SCENE, [{keypos, #temp_scene.id}, named_table, public, set,{read_concurrency,true}]), 			%%场景实例
	ets:new(?ETS_NPC, [{keypos, #temp_npc.nid}, named_table, public, set,{read_concurrency,true}]), 			%%基础NPC配置
	ets:new(?ETS_NPC_LAYOUT, [{keypos, #temp_npc_layout.id}, named_table, public, set,{read_concurrency,true}]), 	%%NPC布局实例
	ets:new(?ETS_TEMP_MON_LAYOUT,[named_table, public, bag,{read_concurrency,true}]) ,								%%怪物布局配置
	ets:new(?SECNE_MON,[{keypos, #temp_mon_layout.id}, named_table, public, set]) ,	        %%怪物布局实例表
    ets:new(?ETS_TEMP_GOODS, [{keypos, #temp_goods.gtid}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_MOUNT, [{keypos, #mount.uid}, named_table, public, set, {read_concurrency,true}]),            %%座骑记录
	ets:new(?ETS_RELATION, [{keypos, #relation.uid}, named_table, public, set, {read_concurrency,true}]),            %%关系记录	
    ets:new(?ETS_TASK_PROCESS, [{keypos, #task_process.id}, named_table, public, set]), %% 任务进度
    ets:new(?ETS_TPL_TASK, [{keypos, #tpl_task.tid}, named_table, public, set]), %% 任务模板
	ets:new(?ETS_TASK_FINISH, [{keypos, #task_finish.uid}, named_table, public, set]),%% 主线/支线任务历史记录
    ets:new(?ETS_TASK_QUERY_CACHE, [named_table, public, set]),	%% 当前所有可接任务
  	ets:new(?ETS_TASK_DAILY_FINISH, [{keypos, #daily_task_finish.uid},named_table, public, set]), %%日常任务完成进度
	ets:new(?ETS_TASK_DETAIL,[{keypos, #task_detail.task_type},named_table, public, set]), %%任务模板子表
	
	ok. 

%% desc: 创建物品表
init_goods_ets() ->
	F = fun(Num) ->
				GoodsEtsName = misc:create_goods_ets_name(Num),
%% 				GoodsEtsAttrName = misc:create_goos_attr_ets_name(Num),
				GoodsPolishName = misc:create_goods_polish_ets_name(Num),
				ets:new(GoodsEtsName, [{keypos, #goods.id}, named_table, public, set])  %% 在线玩家的背包物品表
%%				ets:new(GoodsPolishName, [{keypos, #casting_polish.gid}, named_table, public, set])  %% 在线玩家的装备洗炼表
%% 				ets:new(GoodsEtsAttrName, [{keypos, #goods_attribute.id}, named_table, public, set]),  %% 在线玩家的背包物品属性表
%% 				TaskLogName = misc:create_task_log_ets_name(Num),
%% 				ets:new(TaskLogName, [{keypos, #role_task_log.role_id},named_table, public, bag])	%% 在线玩家任务记录表
		end,
	lists:foreach(F, lists:seq(1, ?MAX_GOODS_ETS_NUM)).
