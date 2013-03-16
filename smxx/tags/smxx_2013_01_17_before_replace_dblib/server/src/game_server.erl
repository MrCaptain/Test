%%%-----------------------------------
%%% @Module  : game_server
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 游戏服务器
%%%-----------------------------------
-module(game_server).
-export([start/1]).
-compile([export_all]).

start([Ip, Port, Node_id]) ->
	io:format("init start..\n"),
	misc:write_system_info(self(), tcp_listener, {Ip, Port, now()}),
	Node_1 = config:get_node_id_1(),
	Node_2 = Node_1 + 1,
	io:format("init Node1 ..~p\n",[Node_1]),
	io:format("init Node2 ..~p\n",[Node_2]),
	inets:start(),
	ok = start_kernel(),						%%开启核心服务
	ok = start_rand(),							%%随机种子
	ok = start_mon(),							%%开启怪物监控树
%%     ok = start_npc(),							%%开启npc监控树
    ok = start_client(),						%%开启客户端连接监控树
    ok = start_mail(),							%%开启邮件监控树
    ok = start_tcp(Port),						%%开启tcp listener监控树
	ok = start_scene(Node_id),							%%开启本节点场景(按照配置文件)		
	ok = start_scene_agent(),					%%开启场景代理监控树
    ok = start_disperse([Ip, Port, Node_id]),	%%开启服务器路由，连接其他节点	
	timer:sleep(1000),
	
	%%普通全局进程，分配到节点1
	
		
	%%开启杂项监控树
	start_node_application(start_misc,[], Node_1, Node_id),		
	%%开启商城监控树					
%% 	start_node_application(start_shop, [],Node_1, Node_id),
	
	%%开启好友
%% 	start_node_application(start_rela, [],Node_1, Node_id),
	%%开启离线
%% 	start_node_application(start_offline, [],Node_1, Node_id),
	
	
	
%% 	%%开启在线统计监控树		
%% 	start_node_application(start_online_count,[],1,Node_id),
	%%开启副本掉落统计控制树
%% 	start_node_application(start_dungeon_analytics, [],1, Node_id),
	%%开启vip监控树
%% 	start_node_application(start_vip,[],1,Node_id),	
	%%开启联盟监控树	
%% 	start_node_application(start_guild,[], Node_1, Node_id),
	
	%%开启联盟战监控树，联盟战和联盟进程必须在同一个节点
%% 	start_node_application(start_guild_battle,[], Node_1, Node_id),
	
	%%开启联盟守护战监控树，联盟战和联盟进程必须在同一个节点
%% 	start_node_application(start_guild_guard,[], Node_1, Node_id),

	%%开启排行榜监控树
%% 	start_node_application(start_rank,[], Node_1, Node_id),
	
%% 	start_node_application(start_light,[], 1, Node_id),
	%%开启巨兽进程(新版没有)
%% 	start_node_application(start_giant,[], Node_1, Node_id),   
	%%开启巨兽交互动态进程
%% 	start_node_application(start_giant_action,[], Node_1, Node_id),
%% 	%%开启巨兽ETS表读取进程
%% 	start_node_application(start_giant_get_data,[], Node_1, Node_id),
	
	%%开启时空冲突战进程
%% 	start_node_application(start_conflict,[], Node_1, Node_id),
	
	%%开启多人副本监控树		
%% 	start_node_application(start_team, [],Node_1, Node_id),
	
	%%开启多人副本代理进程
%% 	start_node_application(start_team_agent,[],Node_1, Node_id),
	
	%%开启世界BOSS主进程
%% 	start_node_application(start_boss, [],Node_1, Node_id),
	
	%%开启世界BOSS代理进程
%% 	start_node_application(start_boss_agent,[],Node_1, Node_id),
	
	%%开始统计进程
%% 	start_node_application(start_statistics,[],Node_1, Node_id),


	
	error_logger:info_msg("~s The global Pros ok! Please start the next node.. ~n", [misc:time_format(now())]),
	ok.	

%%开启核心服务
    %%初始ets表
    %%初始mysql
    %%初始化物品类型及规则列表
    %%经脉列表
start_kernel() ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {mod_kernel,
                {mod_kernel, start_link,[]},
                permanent, 10000, supervisor, [mod_kernel]}),
    ok.

%%随机种子
start_rand() ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {mod_rand,
                {mod_rand, start_link,[]},
                permanent, 10000, supervisor, [mod_rand]}),
    ok.


%%开启怪物监控树
start_mon() ->
    {ok, _} = supervisor:start_child(
               game_server_sup,
               {mod_mon_create,
                {mod_mon_create, start_link,[]},
                permanent, 10000, supervisor, [mod_mon_create]}),
    ok.

%%开启npc监控树
%% start_npc() ->
%%     {ok,_} = supervisor:start_child(
%%                game_server_sup,
%%                {mod_npc_create,
%%                 {mod_npc_create, start_link,[]},
%%                 permanent, 10000, supervisor, [mod_npc_create]}),
%%     ok.

%%开启任务监控树
start_task() ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {mod_task_cache,
                {mod_task_cache, start_link,[]},
                permanent, 10000, supervisor, [mod_task_cache]}),
    ok.

%%开启联盟监控树
start_guild() ->
	_Pid = mod_guild:get_mod_guild_pid(),
	ok.

%%开启邮件监控树
start_mail() ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {mod_mail,
                {mod_mail, start_link,[]},
                permanent, 10000, supervisor, [mod_mail]}),
    ok.

%% %%开启843监控树
%% start_police() ->
%%     {ok,_} = supervisor:start_child(
%%                game_server_sup,
%%                {mod_police,
%%                 {mod_police, start_link,[]},
%%                 permanent, 10000, supervisor, [mod_police]}),
%%     ok.

start_notice() ->
	{ok,_} = supervisor:start_child(
               game_server_sup,
               {mod_notice,
                {mod_notice, start_link,[]},
                permanent, 10000, supervisor, [start_notice]}),
    ok.
  
%%开启排行榜监控树
start_rank() ->
	_Pid = mod_rank:get_mod_rank_pid(),
%% 	io:format("===========mod rank is started:~p........~n",[Pid]),
    ok.

%%开启杂项监控树
start_misc() ->
	_Pid = mod_misc:get_mod_misc_pid(),	
    ok.

%%开启商城监控树
start_shop() ->
	_Pid = mod_shop:get_mod_shop_pid(),
	ok.

%% %%开启在线统计监控树
%% start_online_count()->
%% 	_Pid = mod_online_count:get_mod_online_count_pid(),
%% 	ok.


%% 开启本节点场景(按照配置文件，以及节点ID)
start_scene(Node_id) ->
	%% io:format("start_scene_sever_0:____/~p/~p/ ~n",[Node_id, config:get_scene_here(server)]),
	lists:foreach(fun(SId)->
						  %% io:format("start_scene_sever_1:____/~p/~p/ ~n",[Node_id, SId]),
						  mod_scene:start_scene_by_baseId(SId, Node_id)
				  end, 
				  config:get_scene_here(server)),
	ok.

%%开启场景代理监控树
start_scene_agent() ->
	{ok,_} = supervisor:start_child(
			   game_server_sup,
			   {mod_scene_agent,
				{mod_scene_agent, start_link, [{mod_scene_agent, 0}]},
				permanent, 10000, supervisor, [mod_scene_agent]}),
	ok.



%% %% 开启副本掉落统计控制树
%% start_dungeon_analytics() ->
%% 	_Pid = mod_dungeon_analytics:get_mod_dungeon_analytics_pid(),
%% 	ok.

%% %%开启VIP监控树
%% start_vip()->
%% 	_Pid = mod_vip:get_mod_vip_pid(),
%% 	ok.

%%开启客户端监控树
start_client() ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {game_tcp_client_sup,
                {game_tcp_client_sup, start_link,[]},
                transient, infinity, supervisor, [game_tcp_client_sup]}),
    ok.

%%开启tcp listener监控树
start_tcp(Port) ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {game_tcp_listener_sup,
                {game_tcp_listener_sup, start_link, [Port]},
                transient, infinity, supervisor, [game_tcp_listener_sup]}),
    ok.

%%开启多线
start_disperse([Ip, Port, Node_id]) ->
    {ok,_} = supervisor:start_child(
               game_server_sup,
               {mod_disperse,
                {mod_disperse, start_link,[Ip, Port, Node_id]},
                permanent, 10000, supervisor, [mod_disperse]}),
    ok.

start_node_application(Fun, Item,Type, NodeId) ->
	case NodeId =:= Type of
		true ->
			erlang:apply(?MODULE,Fun, Item);
		false ->
			skip
	end.

%% %%开启巨兽进程
%% start_giant() ->
%% 	_Pid = mod_giant:get_mod_giant_pid(),
%% 	ok.
%% 
%% %%开启巨兽交互动态进程
%% start_giant_action() ->
%% 	_Pid = mod_giant_action:start_mod_giant_action(),
%% 	ok.
%% 
%% %%开启巨兽ETS表读取进程
%% start_giant_get_data() ->
%% 	_Pid = mod_get_giant_data:start_mod_get_giant(),
%% 	ok.

%%开启时空冲突战进程
start_conflict() ->
	_Pid = mod_conflict:start_mod_conflict(),
	ok.

%% %%孔明灯
%% start_light() ->
%% 	_Pid = mod_light:get_mod_light_pid(),
%% 	ok.

%% %%好友
%% start_relationship() ->
%% 	_Pid = mod_relationship:get_mod_relationship_pid(),
%% 	ok.

%%好友
start_rela() ->
	_Pid = mod_rela:get_mod_rela_pid(),
	ok.


%%竞技场
start_theater() ->
	_Pid = mod_theater:get_mod_theater_pid(),
	ok.

%%斗兽场
%% start_arena() ->
%% 	_Pid = mod_arena:get_mod_arena_pid(),
%% 	ok.

%%离线消息
start_offline() ->
	_Pid = mod_offline:get_mod_offline_pid(),
	ok.

%% 开启多人副本监控树
start_team() ->
	Pid = mod_team:get_mod_team_pid(),
	io:format("===========mod team process is started:~p.........~n",[Pid]),
	ok.

%%开启多人副本监控树
%% start_team_agent() ->
%% 	{ok,_} = supervisor:start_child(
%%                game_server_sup,
%%                {mod_team_agent,
%%                 {mod_team_agent, start_link, [{mod_team_agent, 0}]},
%%                 permanent, 10000, supervisor, [mod_team_agent]}),
%% 	io:format("===========mod team agent process is started........~n"),
%% 	ok .


%%世界BOSS
start_boss() ->
	%% boss 主进程
	Pid = mod_boss:get_mod_boss_pid(),
	io:format("===========mod start_boss is started:~p........~n",[Pid]),
	ok.


start_subs_doll() ->
	%% boss 主进程
	Pid = mod_substitute:get_mod_substitute_pid(),
	io:format("===========mod start_substitute is started:~p........~n",[Pid]),
	ok.

	%% 矿山系统主进程
start_mine() ->
	Pid = mod_mine:get_mod_mine_pid(),
	io:format("===========mod mine is started:~p........~n",[Pid]),
	ok.

	%% 封魔进程
start_magic() ->
	Pid = mod_magic:get_mod_magic_pid(),
	io:format("===========mod magic is started:~p........~n",[Pid]),
	ok.



	%% 博物堂系统主进程
start_tribute() ->
	Pid = mod_tribute:get_mod_tribute_pid(),
	io:format("===========mod tribute is started:~p........~n",[Pid]),
	ok.
  
	%% 博物堂系统主进程
start_fish() ->
	Pid = mod_fish:get_mod_fish_pid(),
	io:format("===========mod fish is started:~p........~n",[Pid]),
	ok.

%%世界BOSS
%% start_guild_battle() ->
%% 	%% boss 主进程
%% 	Pid = mod_guild_battle:get_mod_guild_battle_pid(),
%% 	io:format("===========mod guild_battle is started:~p........~n",[Pid]),
%% 	ok.



%% start_guild_battle_agent() ->
%% 	{ok,_} = supervisor:start_child(
%%                game_server_sup,
%%                {mod_guild_battle_agent,
%%                 {mod_guild_battle_agent, start_link, [{mod_guild_battle_agent, 0}]},
%%                 permanent, 10000, supervisor, [mod_guild_battle_agent]}),
%% 	ok .


%%世界BOSS
%% start_guild_guard() ->
%% 	%% boss 主进程
%% 	Pid = mod_guild_guard:get_mod_guild_guard_pid(),
%% 	io:format("===========mod guild_guard is started:~p........~n",[Pid]),
%% 	ok.



start_statistics() ->
	{ok, _Pid} = mod_statistics:start(),
	io:format("===========mod statistics process is started........~n"),
	ok.

%%百仙过海
%% start_cross() ->
%% 	_Pid = mod_cross:get_mod_cross_pid(),
%% 	ok.

start_week_rank() ->
	%% 周排行榜  主进程
%% 	_Pid = mod_week_rank:get_main_mod_week_rank_pid(),
%%  	io:format("===========mod week_rank is started:~p........~n",[Pid]),
	ok.

%% start_slave() ->
%% 	%% 成王败寇  主进程
%% 	_Pid = mod_slave:get_main_mod_slave_pid(),
%% %%  	io:format("===========mod week_rank is started:~p........~n",[Pid]),
%% 	ok.
	
%%宠物岛
%% start_island() ->
%% 	_Pid = mod_island:get_mod_island_pid(),
%% 	ok.


%%圣树
start_tree() ->
	_Pid = mod_tree:get_mod_tree_pid(),
	ok.

%%精英副本
start_elite() ->
	_Pid = mod_elite:get_mod_elite_pid(),
	ok.
