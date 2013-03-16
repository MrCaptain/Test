%%%-----------------------------------
%%% @Module  : lib_scene
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 场景信息
%%%-----------------------------------
-module(lib_scene).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).



%% -define(GRID_WIDTH,64) .     	%% 划分格子的默认宽度
%% -define(GRID_HEIGHT,64) .	 	%% 划分格子的默认高度


%%@spec 各个分场景的ETS名字
get_ets_name(SceneId) ->
	EtsName = misc:create_atom(?ETS_ONLINE_SCENE,[SceneId]) ,
	EtsName .

%%@spec 各个分场景的ETS名字
create_scene_online() ->
	create_scene_online(ets:tab2list(?ETS_TEMP_SCENE)) .
create_scene_online([]) ->
  skip ;
create_scene_online([BaseScn|LeftBaseScn]) ->
	lists:foreach(fun(SubId) ->
						  EstName = get_ets_name(100*BaseScn#?ETS_TEMP_SCENE.sid+SubId) ,
						  ets:new(EstName, [{keypos,#player.id}, named_table, public, set,{read_concurrency,true}])
				  end , lists:seq(1, ?SCENE_MAX_NUMBER)) ,
	create_scene_online(LeftBaseScn) .
	


%%@spec  ETS操作函数 begin==========
get_city_scene() ->
	MS = ets:fun2ms(fun(S) when 1==1 ->  S#temp_scene.sid end) ,
	ets:select(?ETS_TEMP_SCENE, MS) .

%%spec 获取场景模板
get_scene_tmpl(SceneId) ->
	case SceneId > 999 of
		true ->
			ScnId = SceneId div 100 ;
		false ->
			ScnId = SceneId
	end ,
	case ets:lookup(?ETS_TEMP_SCENE, ScnId)of
		[S|_] ->
			S ;
		_ ->
			[]
	end .

%%spec 获取场景实例
get_scene(SceneId) ->
	case SceneId > 999 of
		true ->
			ScnId = SceneId ;
		false ->
			ScnId = SceneId * 100 + 1 
	end ,
	case ets:lookup(?ETS_SCENE, ScnId)of
		[S|_] ->
			S ;
		_ ->
			[]
	end .

%%spec 获取场景实例
%% get_new_scene_id(SceneId) ->
%% 	case SceneId > 999 of
%% 		true ->
%% 			ScnId = SceneId div 100 ;
%% 		false ->
%% 			ScnId = SceneId  
%% 	end ,
%% 	MS = ets:fun2ms(fun(S) when S#temp_scene.sid =:= ScnId ->  S  end) ,
%% 	DataList = ets:select(?ETS_TEMP_SCENE, MS) ,
%% 	ScnId * 100 + length(DataList) + 1 . 

		
%% @spec 获取NPC模板数据
get_scene_npc(NpcId) ->
	case ets:lookup(?ETS_NPC, NpcId)of
		[S|_] ->
			S ;
		_ ->
			[]
	end .

%% @spec 获取NPC实例数据
get_npc_layout(NpcId) ->
	case ets:lookup(?ETS_NPC_LAYOUT, NpcId)of
		[S|_] ->
			S ;
		_ ->
			[]
	end .



%%spec 获取子场景玩家
get_scene_players(SceneId) ->
	EtsName = get_ets_name(SceneId) ,
	ets:tab2list(EtsName) .
%% 	MS = ets:fun2ms(fun(S) when S#player.scene =:= SceneId -> S end),
%% 	case ets:select(?ETS_ONLINE_SCENE, MS) of
%% 		List when is_list(List) ->
%% 			List ;
%% 		_ ->
%% 			[]
%% 	end .
	

%%spec 获取场景玩家
get_scene_player(SceneId,PlayerId) ->
	case get_scene_player(PlayerId) of
		Player when is_record(Player,player) ->
			case Player#player.scene =:= SceneId of
				true ->
					Player ;
				false ->
					[]
			end ;
		_ ->
			[]
	end .

get_scene_player(PlayerId) ->
	case ets:lookup(?ETS_ONLINE_SCENE, PlayerId) of
		[P|_] ->
			P ;
		_ ->
			[]
	end .




%%@spec 加载场景基础数据到ETS表
load_temp_scene() ->
	ScnRcdList =  db_agent_scene:select_scene() ,
	add_scene_to_ets(ScnRcdList) .
add_scene_to_ets([]) ->
	skip ;
add_scene_to_ets([ScnRcd|LeftList]) ->
	if
		is_record(ScnRcd,temp_scene) ->
			ets:insert(?ETS_TEMP_SCENE, ScnRcd) ;
		true ->
			skip
	end ,
	add_scene_to_ets(LeftList) .

%%@spec 加载NPC模板数据到ETS表
load_temp_npc() ->
	NpcRcdList =  db_agent_scene:select_npc() ,
	add_npc_to_ets(NpcRcdList) .
add_npc_to_ets([]) ->
	skip ;
add_npc_to_ets([NpcRcd|LeftList]) ->
	if
		is_record(NpcRcd,temp_npc) ->
			ets:insert(?ETS_NPC, NpcRcd) ;
		true ->
			skip
	end ,
	add_npc_to_ets(LeftList) .

%%@spec 加载NPC模板、实例 数据到ETS表
load_temp_npc_layout() ->
	NpcLayoutRcdList =  db_agent_scene:select_npc_layout() ,
	add_npclayout_to_ets(NpcLayoutRcdList) .
add_npclayout_to_ets([]) ->
	skip ;
add_npclayout_to_ets([NpcLayoutRcd|LeftList]) ->
	if
		is_record(NpcLayoutRcd,temp_npc_layout) ->
			case get_scene_npc(NpcLayoutRcd#temp_npc_layout.npcid) of
				NpcRcd when is_record(NpcRcd,temp_npc_layout) ->
					NewNpcLayoutRcd = NpcLayoutRcd#temp_npc_layout{npcrcd = NpcRcd} ,
					ets:insert(?ETS_NPC_LAYOUT, NewNpcLayoutRcd) ;
				_ ->
					skip
			end ;
		true ->
			skip
	end ,
	add_npclayout_to_ets(LeftList) .

%%@spec 加载MON模板数据到ETS表
load_temp_mon_layout() ->
	MonLayoutRcdList = db_agent_scene:select_mon_layout() ,
	add_monlayout_to_ets(MonLayoutRcdList) .
add_monlayout_to_ets([]) ->
	skip ;
add_monlayout_to_ets([MonLayoutRcd|LeftList]) ->
	if
		is_record(MonLayoutRcd,temp_mon_layout) ->
			case get_scene_npc(MonLayoutRcd#temp_mon_layout.monid) of
				MonRcd when is_record(MonRcd,temp_npc) ->
					MonCombatAttrRcd = lib_player:init_base_battle_attr(MonRcd#temp_npc.level, MonRcd#temp_npc.npc_type) ,
					NewMonLayoutRcd = MonLayoutRcd#temp_mon_layout{monrcd = MonRcd,battle_attr = MonCombatAttrRcd } ,
					ets:insert(?ETS_TEMP_MON_LAYOUT, NewMonLayoutRcd) ;
				_ ->
					skip
			end ;
		true ->
			skip
	end ,
	add_monlayout_to_ets(LeftList) .




%% 是否是副本进程
%% 基础场景
is_copy_scene(UniqueId) ->
	UniqueId > 99999.

%% 场景实例化，确定场景的实例和NPC
load_scene(SceneId) ->
	case get_scene_tmpl(SceneId div 100) of
		Scn when is_record(Scn,temp_scene) ->
			%%子场景实例
			ets:insert(?ETS_SCENE, Scn#temp_scene{id = SceneId, npc=[]}) ,
			ets:insert(?ETS_TEMP_SCENE, Scn#temp_scene{scene_num = Scn#temp_scene.scene_num + 1});
		_ ->
			skip
	end .


%% @spec保存玩家信息
save_scene_player(PlayerStatus) ->
	EtsName = get_ets_name(PlayerStatus#player.scene) ,
	ets:insert(EtsName, PlayerStatus) ,
	ets:insert(?ETS_ONLINE_SCENE, PlayerStatus) .


%% @spec 玩家进入场景前的检查
%% 1、进入新场景
%% 2、刷新进入
%% 3、断线重连
check_eneter(SceneId,Status,PosX,PosY) ->
	case get_scene_player(SceneId,Status#player.id) of
		Player when is_record(Player,player) ->  %%断线重连的情况
			{Player#player.scene,Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y} ;
		_ ->
			if
				SceneId > 999 ->		%%刷新进入或者重新登陆
					BaseScn = SceneId div 100 ;	
				true ->					%%进入新场景
					BaseScn = SceneId
			end ,
			auto_scene(BaseScn,Status#player.level,PosX,PosY) 
	end .


%%自动分配场景
auto_scene(BaseSceneId,Lv,PosX,PosY) ->
	case get_scene_tmpl(BaseSceneId) of
		TempScn when is_record(TempScn,temp_scene) ->
			if 
				Lv < TempScn#temp_scene.level_limit ->    %% 等级不足
					{0,0,0} ;  
				true ->
					SceneNum = TempScn#temp_scene.scene_num ,
%% 					?TRACE("====auto_scene:~p~n", [SceneNum]) ,
					SubSceneId = check_scene(BaseSceneId,1,SceneNum) ,
					{SubSceneId,PosX,PosY } 
			end ;
		_ ->
			{0,0,0}
	end .
		
check_scene(BaseSceneId,SubId,MaxScnNum)  ->
	SubSceneId = BaseSceneId * 100 + SubId ,
	case SubId > MaxScnNum of
		true ->
			case SubId =< ?SCENE_MAX_NUMBER of 
				true ->
					SubSceneId ;
				false ->
					0
			end ;
		false ->
			PlayerList = get_scene_players(SubSceneId) ,
			case length(PlayerList) < ?SCENE_PLAYER_MAX_NUMBER of
				true ->
					SubSceneId ;
				false ->
					check_scene(BaseSceneId, SubId + 1, MaxScnNum) 
			end 
	end .

get_sub_scene_number(BaseScnId) ->
	case get_scene_tmpl(BaseScnId) of
		ScnRcd when is_record(ScnRcd,temp_scene) ->
			ScnRcd#temp_scene.scene_num ;
		_ ->
			0
	end .

%% @spec 玩家进入场景
%% 1、需要发送场景内的人物，NPC，怪物信息给玩家
%% 2、需要广播有玩家进入场景(如果放在pp里面做，可能会导致)
enter_scene(Status) ->
	%%1.0 保存玩家信息
    save_scene_player(Status) ,
	
	%%2.0 获取场景上的怪物信息
	PosX = Status#player.battle_attr#battle_attr.x ,
	PoxY = Status#player.battle_attr#battle_attr.y ,
	ResolutX = Status#player.resolut_x ,
	ResolutY = Status#player.resolut_y ,
	
	PlayerList 	= get_matrix_players(Status#player.scene,PosX,PoxY,ResolutX,ResolutY) ,
	MonList 	= lib_mon:get_screen_monsters(PosX,PoxY,ResolutX,ResolutY) ,
	DropList 	= lib_mon:get_screen_drops(PosX,PoxY,ResolutX,ResolutY) ,
	
	{ok,BinData} = pt_12:write(12002, [PlayerList,MonList,DropList]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) .
	


%%离开当前场景
leave_scene(PlayerId,SceneId) ->
	EtsName = get_ets_name(SceneId) ,
	ets:delete(EtsName, PlayerId) ,
	ets:delete(?ETS_ONLINE_SCENE, PlayerId) .

%% %% 获取场景元素(玩家，NPC，怪物)
%% get_scene_elem(SceneId) ->
%% 	PlayerList = get_scene_players(SceneId)  ,
%% 	[PlayerList,[]] .


%% 同步玩家的目的位置
update_postion(Status,DestX,DestY) ->
	{SolutX,SolutY} = {Status#player.resolut_x,Status#player.resolut_y} ,
	SceneId = Status#player.scene ,
	BattleAttr = Status#player.battle_attr#battle_attr{x = DestX, y = DestY} ,
	NewStatus = Status#player{battle_attr = BattleAttr} ,
	case get_scene_player(Status#player.scene,Status#player.id) of
		Player when is_record(Player,player) ->
			OldX = Player#player.battle_attr#battle_attr.x ,
			OldY = Player#player.battle_attr#battle_attr.y ,
			%%跨过了九宫格的小格子才发起同步
			case util:is_same_slice(OldX,OldY,DestX,DestY,Status#player.resolut_x,Status#player.resolut_y) of
				false ->
					%% 1.0 玩家离开就小格子和进入新下格子
					{ok, LeaveBinData} = pt_12:write(12004, [Player#player.id]),
					{ok, EnterBinData} = pt_12:write(12003, [Status]) ,	
					mod_scene_agent:broadcast_move(Status#player.scene,{OldX,OldY}, {DestX,DestY}, {SolutX,SolutY}, LeaveBinData, EnterBinData) ,
					
					%% 2.0 发送新区域的场景元素给该玩家
					%%SlicePlayers = get_slice_players(SceneId,DestX,DestY,SolutX,SolutY) ,
					%%SliceMons = get_slice_monsters(SceneId,DestX,DestY,SolutX,SolutY) ,
					
					SlicePlayers = get_screen_players(SceneId,DestX,DestY,SolutX,SolutY) ,
					SliceMons = lib_mon:get_screen_monsters(DestX,DestY,SolutX,SolutY) ,
					DropList 	= lib_mon:get_screen_drops(DestX,DestY,SolutX,SolutY) ,
					{ok,BinData} = pt_12:write(12002, [SlicePlayers,SliceMons,DropList]) ,
					lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData)  ;
					
				    %% 3.0 后期扩展，掉落，采集等
				true ->
					skip
			end ;
		_ ->
			skip
	end ,
	ets:insert(?ETS_ONLINE_SCENE, NewStatus).


%%当人物移动的时候广播
broadcast_move(SceneId, {OldPosX,OldPosY}, {NewPosX,NewPosY}, {SolutX,SolutY}, LeaveBinData, EnterBinData) ->
	%%1.0 获取旧区域的玩家
	OldPlayers = get_screen_players(SceneId,OldPosX,OldPosY,SolutX,SolutY) ,
	DestPlayers = get_screen_players(SceneId,NewPosX,NewPosY,SolutX,SolutY) ,
%% 	{OldList,NewList,_SameList} = split_players(OldPlayers,DestPlayers) ,
	
	broadcast_data(OldPlayers,LeaveBinData) ,
	broadcast_data(DestPlayers,EnterBinData) .


%%发送消息给玩家列表
broadcast_data([],_DataBin) ->
	skip ;
broadcast_data([Player|LeftPlayers],DataBin) ->
	lib_send:send_to_sid(Player#player.other#player_other.pid_send, DataBin) ,
	broadcast_data(LeftPlayers,DataBin) .


%% 从玩家列表里面获取指定区域里面的所有玩家
get_screen_players(Players,{X1,Y1,X2,Y2}) ->
	Fun = fun(Player,SPlayers) ->
				  case util:is_same_screen(Player#player.battle_attr#battle_attr.x, Player#player.battle_attr#battle_attr.y, {X1, Y1, X2, Y2}) of
					  true ->
						  [Player|SPlayers] ;
					  false ->
						  SPlayers 
				  end 
		  end ,
	lists:foldl(Fun, [], Players) .

%%@spec 从两个玩家列表中分离出
%%%%%% 		1. A 在 B中不存在的 
%%%%%% 		2. B 在 A中不存在的
%%%%%% 		3. 在 A 和 B中都存在的
split_players(APlayerList,BPlayerList) ->
	%%1.0 先从AList中找出在BList中也存在的玩家
	Fun = fun(APlayer,{AList,CList}) ->
				  case lists:keyfind(APlayer#player.id, #player.id, BPlayerList) of
					  Player when is_record(Player,player) ->
						 ALeftList = lists:keydelete(APlayer#player.id, #player.id, AList) ,
						 {ALeftList,[Player|CList]} ;
					  _ ->
						 {AList,CList} 
						 
				  end 
		  end ,
	{APList,CPList} = lists:foldl(Fun, {APlayerList,[]}, APlayerList) ,
	
	%%2.0 先从BList中找出在BList中也存在的玩家
	DFun = fun(BPlayer,BList) ->
				  case lists:keyfind(BPlayer#player.id, #player.id, CPList) of
					  Player when is_record(Player,player) ->
						 BLeftList = lists:keydelete(BPlayer#player.id, #player.id, BList) ,
						 BLeftList ;
					  _ ->
						 BList 
						 
				  end 
		  end ,
	BPList = lists:foldl(DFun, [], BPlayerList) ,
	
	{APList,BPList,CPList} .



%% 按照字段更新玩家场景信息
update_player_info_fields(PlayerId,ValueList) ->
	Pattern = #player{id = PlayerId,_='_'},
	Player = ets:match(?ETS_ONLINE_SCENE,Pattern),
	if
		is_record(Player,player) ->
			NewPlayer = lib_player_rw:set_player_info_fields(Player,ValueList),
			EtsName = get_ets_name(NewPlayer#player.scene) ,
			ets:insert(EtsName, NewPlayer) ,
			ets:insert(?ETS_ONLINE_SCENE, NewPlayer);
		true ->
			skip
	end.


%% 怪物掉落拾取
pick_drop(_MonId, GoodsId, PosX, PosY) ->
	%% 	io:format("========1===pick_drop:~p~n",[lib_mon:get_monster_drops()]) ,
	%% 	io:format("========2===pick_drop:~p~n",[[MonId, GoodsId, PosX, PosY]]) ,
	
	%%根据掉落列表就行拆分
	DropFun = fun(D) ->
					  D#mon_drop_goods.goods_id =:= GoodsId andalso 
										   D#mon_drop_goods.x =:= PosX andalso
																D#mon_drop_goods.y =:= PosY
			  end ,
	{MonDropList,LeftList} = lists:splitwith(DropFun, lib_mon:get_monster_drops()) ,
	lib_mon:save_monster_drops(LeftList) ,

	%%过滤出需要返回的字段
	RFun = fun(D) ->
				   {D#mon_drop_goods.goods_id,D#mon_drop_goods.goods_num}
		   end ,
	PickedDrops = lists:map(RFun, MonDropList) ,
	
	[1,PickedDrops] .
			
  

%@spec 获取跟指定坐标同一小格子的玩家
get_slice_players(SceneId,X,Y,SolutX,SolutY) ->
	AllPlayer = get_scene_players(SceneId) ,
	Fun = fun(Player) ->
				  util:is_same_slice(X,Y,Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y,SolutX,SolutY) 
		  end ,
	lists:filter(Fun, AllPlayer) .



%@spec 获取跟指定坐标同屏的玩家
get_screen_players(SceneId,X,Y,SolutX,SolutY) ->
	AllPlayer = get_scene_players(SceneId) ,
	{X1,Y1,X2,Y2} = util:get_screen_posxy(X, Y, SolutX, SolutY) ,
	Fun = fun(Player) ->
				  util:is_same_screen(Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y,{X1,Y1,X2,Y2}) 
		  end ,
	lists:filter(Fun, AllPlayer) .



%@spec 获取跟指定坐标同九宫格区域的玩家
get_matrix_players(SceneId,X,Y,SolutX,SolutY) ->
	AllPlayer = get_scene_players(SceneId) ,
	MatrixPost = util:get_slice_matrix(X, Y,SolutX,SolutY) ,
	Fun = fun(Player) ->
				  util:is_in_matrix(Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y,MatrixPost) 
		  end ,
	lists:filter(Fun, AllPlayer) .

%@spec 获取跟指定坐标同九宫格区域的玩家
get_squre_players(SceneId,X,Y,Range) ->
	AllPlayer = get_scene_players(SceneId) ,
	X1 = X - Range ,
	X2 = X + Range ,
	Y1 = Y - Range ,
	Y2 = Y + Range ,
	
	%%找出指定区域里面的存活的玩家
	Fun = fun(Player) ->
				  Player#player.battle_attr#battle_attr.x >= X1 andalso 
				  Player#player.battle_attr#battle_attr.x =< X2 andalso 
				  Player#player.battle_attr#battle_attr.y >= Y1 andalso 
				  Player#player.battle_attr#battle_attr.y =< Y2 andalso 
				  Player#player.battle_attr#battle_attr.hit_point > 0 
		  end ,
	lists:filter(Fun, AllPlayer) .


%%--------------------------------------------------
%% @spec 玩家进入小村镇的初始坐标和场景标识
get_default_scene() ->
	{10101,util:rand(2, 10),util:rand(3, 10)} .

test(Players) ->
	lists:foreach(fun(P) ->
						  io:format("==Player:~p~n", [[P#player.scene,
													   P#player.other#player_other.pid_scene,
													   P#player.nick,
													   P#player.battle_attr#battle_attr.hit_point,
													   P#player.battle_attr#battle_attr.x,P#player.battle_attr#battle_attr.y]])
				  end, Players) .
test() ->
	test(ets:tab2list(?ETS_ONLINE)) .
	
