
%%%---------------------------------------
%%% @Module  : data_scene
%%% @Author  : csj
%%% @Created : 2010-11-03 21:25:12
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_scene).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).

%%@spec  ETS操作函数 begin==========
get_city_scene() ->
	MS = ets:fun2ms(fun(S) when S#temp_scene.type =:= 3 ->  S#temp_scene.sid end) ,
	ets:select(?ETS_TEMP_SCENE, MS) .

%%spec 获取场景模板
get_scene_tmpl(SceneId) ->
	MS = ets:fun2ms(fun(S) when S#temp_scene.sid =:= SceneId -> S end) ,
	case ets:select(?ETS_TEMP_SCENE, MS) of
		[S|_] ->
			S ;
		_ ->
			[]
	end .
		
%% @spec 获取NPC模板数据
get_scene_npc(NpcId) ->
	MS = ets:fun2ms(fun(S) when S#temp_npc.nid =:= NpcId -> S end),
	ets:select(?ETS_NPC, MS) .

%% @spec 获取NPC实例数据
get_npc_layout(NpcId) ->
	MS = ets:fun2ms(fun(S) when S#temp_npc_layout.npcid =:= NpcId -> S end),
	case ets:select(?ETS_NPC_LAYOUT, MS) of
		[S|_] ->
			S ;
		_ ->
			[]
	end .

%% @spec 获取场景怪物模板
get_temp_mon(SceneId) ->
	MS = ets:fun2ms(fun(S) when S#temp_npc_layout.scene_id =:= SceneId -> S end),
	ets:select(?ETS_TEMP_MON_LAYOUT, MS) .


%% @spec 获取场景上的怪物实例
get_scene_mon(SceneId) ->
	MS = ets:fun2ms(fun(S) when S#temp_npc_layout.scene_id =:= SceneId -> S end),
	ets:select(?ETS_MON_LAYOUT, MS) .

%% @spec 根据怪物实例获取怪物信息
get_mon(InstId) ->
	MS = ets:fun2ms(fun(S) when S#temp_npc_layout.id =:= InstId -> S end),
	ets:select(?ETS_MON_LAYOUT, MS) .


%%spec 获取子场景玩家
get_scene_players(SceneId) ->
	MS = ets:fun2ms(fun(S) when S#player.scene =:= SceneId -> S end),
	case ets:select(?ETS_ONLINE_SCENE, MS) of
		List when is_list(List) ->
			List ;
		_ ->
			[]
	end .

%%spec 获取场景玩家
get_scene_player(PlayerId) ->
	MS = ets:fun2ms(fun(S) when S#player.id =:= PlayerId -> S end),
	case ets:select(?ETS_ONLINE_SCENE, MS) of
		[Player|_List] when is_record(Player,player) ->
			Player ;
		_ ->
			[]
	end .