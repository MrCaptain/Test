%%%-----------------------------------
%%% @Module  : lib_scene
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 场景信息
%%%-----------------------------------
-module(lib_scene).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).
-define(MOVE_SOCKET,2).

-define(SLICEWIDTH, 500).
-define(SLICEHEIGHT, 300).

-define(SOLUT_X,1280) .  		%% 默认手机分表率X
-define(SOLUT_Y,760) .			%% 默认手机分表率Y
-define(GRID_WIDTH,64) .     	%% 划分格子的默认宽度
-define(GRID_HEIGHT,64) .	 	%% 划分格子的默认高度



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
			case data_scene:get_scene_npc(NpcLayoutRcd#temp_npc_layout.npcid) of
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
			case data_scene:get_scene_npc(MonLayoutRcd#temp_mon_layout.monid) of
				MonRcd when is_record(MonRcd,temp_mon_layout) ->
					NewMonLayoutRcd = MonLayoutRcd#temp_mon_layout{monrcd = MonRcd} ,
					ets:insert(?ETS_TEMP_MON_LAYOUT, NewMonLayoutRcd) ;
				_ ->
					skip
			end ;
		true ->
			skip
	end ,
	add_monlayout_to_ets(LeftList) .




%% 是否的子场景的工作场景(copy)
is_copy_scene(UniqueId) ->
    UniqueId > 9999.

%% 场景实例化，确定场景的实例和NPC
load_scene(SceneId) ->
	case data_scene:get_scene_tmpl(SceneId div 100) of
		Scn when is_record(Scn,temp_scene) ->
			case Scn#temp_scene.type =< 3 of
				false ->
					ok ;   %% 非主场景
				true ->
					ets:insert(?ETS_SCENE, Scn#temp_scene{id = SceneId, npc=[]})
			end  ;
		_ ->
			skip
	end .


%% @spec 玩家进入场景
%% 1、需要发送场景内的人物，NPC，怪物信息给玩家
%% 2、需要广播有玩家进入场景(如果放在pp里面做，可能会导致)
enter_scene(SubScnId,PidScene,Status) ->
	PlayerOther = Status#player.other#player_other{pid_scene = PidScene} ,
	NewPlayer = Status#player{scene = SubScnId,other=PlayerOther} ,
    ets:insert(?ETS_ONLINE_SCENE, NewPlayer) ,
	
	PlayerList = data_scene:get_scene_players(SubScnId)  ,
	{ok,BinData} = pt_12:write(12002, [PlayerList,[],[]]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) .
	
%%离开当前场景
leave_scene(PlayerId) ->
	catch ets:delete(?ETS_ONLINE_SCENE, PlayerId).

%% 获取场景元素(玩家，NPC，怪物)
get_scene_elem(SceneId) ->
	PlayerList = data_scene:get_scene_players(SceneId)  ,
	[PlayerList,[],[]] .


%% 同步玩家的目的位置
update_postion(Status,DestX,DestY) ->
	case data_scene:get_scene_player(Status#player.id) of
		Player when is_record(Player,player) ->
			OldX = Player#player.x ,
			OldY = Player#player.y ,
			{OldX1,OldY1,OldX2,OldY2} = get_screen_posxy(OldX,OldY,Player#player.resolut_x,Player#player.resolut_y) ,
			{DestX1,DestY1,DestX2,DestY2} = get_screen_posxy(DestX,DestY,Status#player.resolut_x,Status#player.resolut_y) ,
			
			
			%% 玩家离开
			{ok, LeaveBinData} = pt_12:write(12004, [Player#player.id]),
			%% 玩家进入
			{ok, EnterBinData} = pt_12:write(12003, [Status]) ,	
			mod_scene_agent:broadcast_move(Player, {OldX1,OldY1,OldX2,OldY2}, {DestX1,DestY1,DestX2,DestY2}, LeaveBinData, EnterBinData) ;
		_ ->
			skip
	end ,
	ets:insert(?ETS_ONLINE_SCENE, Status).


%%当人物移动的时候广播
broadcast_move(Status, OldPosXY, NewPosXY, LeaveBinData, EnterBinData) ->
	%%1.0 获取旧区域的玩家
	ScenePlayers = data_scene:get_scene_players(Status#player.scene) ,
	OldPlayers = data_scene:get_screen_players(ScenePlayers,OldPosXY) ,
	DestPlayers = data_scene:get_screen_players(ScenePlayers,NewPosXY) ,
	{OldList,NewList,_SameList} = split_players(OldPlayers,DestPlayers) ,
	broadcast_data(OldList,LeaveBinData) ,
	broadcast_data(NewList,EnterBinData) .


%%发送消息给玩家列表
broadcast_data([],_DataBin) ->
	skip ;
broadcast_data([Player|LeftPlayers],DataBin) ->
	lib_send:send_to_sid(Player#player.other#player_other.pid_send, DataBin) ,
	broadcast_data(LeftPlayers,DataBin) .


%% 从玩家列表里面获取指定区域里面的所有玩家
get_screen_players(Players,{X1,Y1,X2,Y2}) ->
	Fun = fun(Player,SPlayers) ->
				  case is_same_screen(Player#player.x, Player#player.y, {X1, Y1, X2, Y2}) of
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


%%--------------------------同屏处理函数---------------------------
%% @spec 相同区域算法
%% get_screen_posxy(X, Y, SolutX, SolutY) ->
%% 	{ScreenWidth,ScreenHeight} = 
%% 		if
%% 			SolutX =:= 0 orelse SolutY =:= 0 ->
%% 				{util:ceil(SolutX/?GRID_WIDTH), util:ceil(SolutY/?GRID_WIDTH)} ;
%% 			true ->
%% 				{util:ceil(?SOLUT_X/?GRID_WIDTH),util:ceil(?SOLUT_Y/?GRID_WIDTH)}
%% 		end ,
%% 		
%% 	X1 = X div ScreenWidth * ScreenWidth ,
%% 	Y1 = Y div ScreenHeight * ScreenHeight,
%% 	{X1 - ScreenWidth, Y1 - ScreenHeight, X1 + ScreenWidth * 2, Y1 + ScreenHeight * 2}.

%% @spec 相同区域算法,玩家在屏幕的正中央，因此只需要算出该玩家边框的4个坐标点
get_screen_posxy(X, Y, SolutX, SolutY) ->
	{HalfScreenWidth,HalfScreenHeight} = 
		if
			SolutX =/= 0 andalso SolutY =/= 0 ->
				{util:ceil(SolutX/?GRID_WIDTH/2), util:ceil(SolutY/?GRID_WIDTH/2)} ;
			true ->
				{util:ceil(?SOLUT_X/?GRID_WIDTH/2),util:ceil(?SOLUT_Y/?GRID_WIDTH/2)}
		end ,
		
	{X - HalfScreenWidth, Y - HalfScreenHeight, X + HalfScreenWidth, Y + HalfScreenHeight}.

%% 判断X,Y是否在所在的框里面。
is_same_screen(X, Y, {X1, Y1, X2, Y2}) ->
	if 
		X1=<X andalso X2>=X andalso Y1=<Y andalso Y2>=Y ->
			true;
		true ->
			false
	end.

%%判断两个坐标是否在同一个屏幕里面
is_same_screen([X1, Y1, X2, Y2],[SolutX,SolutY]) ->
	{ScreenWidth,ScreenHeight} = 
		if
			SolutX =/= 0 andalso SolutY =/= 0 ->
				{util:ceil(SolutX/?GRID_WIDTH), util:ceil(SolutY/?GRID_WIDTH)} ;
			true ->
				{util:ceil(?SOLUT_X/?GRID_WIDTH),util:ceil(?SOLUT_Y/?GRID_WIDTH)}
		end ,
%% 	io:format("=====~p:~p~n",[ScreenWidth,ScreenHeight]) ,
	SX1 = X1 div ScreenWidth,
	SY1 = Y1 div ScreenHeight,
	SX2 = X2 div ScreenWidth,
	SY2 = Y2 div ScreenHeight,

	if 
		SX1 == SX2 andalso SY1 == SY2 ->
			true;
		true ->
			false
	end.

%% 把整个地图共有100*100个格子，0，0坐标点为原点，
%% 以10*10为一个格子，从左到右编号1，2，3，4最终成为10*10的正方形
%获取当前所在的格子
get_xy(X, Y) ->
	Y div 15 * 10 + X div 10 + 1.

is_in_area(XY1, XY2) ->
	XY1 == XY2 orelse 
	XY1 == XY2 + 1 orelse 
	XY1 == XY2 - 1 orelse 
	XY1 == XY2 - 10 orelse 
	XY1 == XY2 + 10 orelse 
	XY1 == XY2 - 11 orelse 
	XY1 == XY2 + 11 orelse 
	XY1 == XY2 - 9 orelse 
	XY1 == XY2 + 9.	

%% %%获得基础场景信息
%% get_base_scene_info(SceneId) ->
%%  	case ets:lookup(?ETS_BASE_SCENE, SceneId) of
%% 		[] -> [];
%% 		[Scene] -> Scene
%% 	end.
%% 
%% %% 获得当前场景用户信息 
%% get_scene_user(SceneId) ->
%% %%  	io:format("SceneId~p~n", [SceneId]),
%% 	R = get_scene_user_from_ets(SceneId, ?ETS_ONLINE_SCENE),
%% % 	io:format("R~p~n", [R]),
%% 	R.
%% 
%% %% 查询邻近等级的在线玩家
%% close_level_players(PlayerId,PlayerLv,FloatLv,MinLv) ->
%% 	MS = ets:fun2ms(fun(T) when T#player.lv >= MinLv andalso T#player.lv >= (PlayerLv-FloatLv) andalso T#player.lv =< (PlayerLv+FloatLv) andalso T#player.id =/= PlayerId -> T end),
%% 	ets:select(?ETS_ONLINE, MS) .
%% 
%% 
%% %% 获得当前场景用户信息 (本节点)
%% get_scene_user_node(SceneId) ->
%% 	get_scene_user_from_ets(SceneId, ?ETS_ONLINE).
%% 
%% %%从ets获得用户信息 
%% get_scene_user_from_ets(SceneId, EtsTab) ->													
%%    	MS = ets:fun2ms(fun(T) when T#player.scn == SceneId ->
%% 		[
%%             T#player.id,
%%             T#player.nick,
%%             T#player.x,
%%             T#player.y,
%%             T#player.hp,
%%             T#player.mxhp,
%%             T#player.eng,
%%             T#player.lv,
%%             T#player.crr,
%%             T#player.spd,
%%             T#player.sex,
%% 			T#player.other#player_other.out_pet_type_id,
%% 			T#player.other#player_other.out_pet_name,
%%             T#player.other#player_other.pid,
%%             T#player.camp,
%%             T#player.un,
%%             T#player.stts,
%% 			T#player.other#player_other.stren,
%% 			T#player.other#player_other.suitid,
%% 			T#player.viplv,
%% 			T#player.img,
%% 			T#player.mnt_sts,            %%坐骑的形象ID
%% 			T#player.other#player_other.mount_stren,
%% 			T#player.tid,									%%人物称号
%% 			T#player.other#player_other.maskId,
%% 			T#player.other#player_other.ghost_fllw
%% 		]
%% 	end),
%%    	ets:select(EtsTab, MS).	
%% 
%% 
%% %%获取指定场景的npc列表
%% get_scene_ele(SceneId) ->
%% 	MS = #ets_npc{
%%    		id = '$1',
%%        	nid = '$2',
%%       	name = '$3',
%%       	x = '$4',
%%       	y = '$5',
%%        	icon = '$6',
%% 		npctype = '$7',
%%       	scn = SceneId,
%%        	_ = '_'
%%    	},
%% 	ets:match(?ETS_SCENE_NPC, MS).
%% 
%% %%初始化用户场景
%% init_player_scene(PlayerStatus) ->
%% 	SceneId =
%% 		if
%% 			PlayerStatus#player.scn < 1000 ->
%% 				auto_scene(PlayerStatus#player.scn);
%% 			true ->
%% 				get_scene(PlayerStatus#player.scn)
%% 		end,
%% 	PlayerStatus#player{scn = SceneId}.
%% 
%% %%自动分配场景
%% auto_scene(BaseSceneId) ->
%% 	case ets:match(?ETS_GET_SCENE,{get_scene,'$1'}) of
%% 		[[LS]] ->
%% %% io:format("get_scene_list_1_/~p/~n",[LS]),	
%% 			check_scene(BaseSceneId, LS, 1);
%% 		[LS] ->
%% %% io:format("get_scene_list_2_/~p/~n",[LS]),
%% 			check_scene(BaseSceneId, LS, 1);
%% 		[] ->
%% 			BaseSceneId * 100 + 1
%% 			%% 默认是01场景
%% 	end.	
%% 	
%% %%检查符合条件的场景并分配
%% check_scene(_BaseSceneId, _LS, ?SCENE_COPY_NUMBER + 1) ->
%% 	error;
%% check_scene(BaseSceneId, LS, ScCopyNum) ->
%% 	SceneId = BaseSceneId * 100 + ScCopyNum,
%% %% io:format("check_scene__/~p/~n",[{SceneId, LS}]),
%% 	case lists:keysearch(SceneId, 1, LS) of
%% 		false ->
%% 			check_scene(BaseSceneId, LS, ScCopyNum + 1);
%% 		{value,{_sceneid, Total}} ->
%% 			if
%% 				Total < ?SCENE_PLAYER_MAX_NUMBER ->
%% 					SceneId;
%% 				true ->
%% 					check_scene(BaseSceneId, LS, ScCopyNum + 1)
%% 			end	
%% 	end.
%% 
%% %%检查某场景的人数
%% chk_scn(BaseSceneId) ->
%% 	case ets:match(?ETS_GET_SCENE,{get_scene,'$1'}) of
%% 		[[LS]] ->
%% %% io:format("get_scene_list_1_/~p/~n",[LS]),	
%% 			chk_scn(BaseSceneId, LS, 1);
%% 		[LS] ->
%% %% io:format("get_scene_list_2_/~p/~n",[LS]),
%% 			chk_scn(BaseSceneId, LS, 1);
%% 		[] ->
%% 			io:format("chk_scn_error /~p/~n",[BaseSceneId])
%% 			%% 检查场景出错
%% 	end.
%% chk_scn(BaseSceneId, _LS, ?SCENE_COPY_NUMBER + 1) ->
%% 	io:format("chk_scn /~p   /~p ~n",[BaseSceneId, finish]);
%% chk_scn(BaseSceneId, LS, ScCopyNum) ->
%% 	SceneId = BaseSceneId * 100 + ScCopyNum,
%% %% io:format("check_scene__/~p/~n",[{SceneId, LS}]),
%% 	case lists:keysearch(SceneId, 1, LS) of
%% 		false ->
%% 			io:format("chk_scn /~p   /~p ~n",[SceneId, unfound]),
%% 			chk_scn(BaseSceneId, LS, ScCopyNum + 1);
%% 		{value,{_sceneid, Total}} ->
%% 			List = get_scene_user(SceneId),
%% 			Player_num = length(List),
%%  			io:format("chk_scn /~p   /~p  /~p ~n",[SceneId, Total, Player_num]),
%% 			chk_scn(BaseSceneId, LS, ScCopyNum + 1)
%% 	end.
%% 
%% %% 分配指定场景
%% get_scene(SceneId) ->
%% %% io:format("get_scene_list_222_/~p/~n",[ets:match(?ETS_GET_SCENE,{get_scene,'$1'})]),
%% 	case ets:match(?ETS_GET_SCENE,{get_scene,'$1'}) of
%% 		[[LS]] ->
%% %% io:format("get_scene_list_222_/~p/~n",[LS]),
%% 			case lists:keysearch(SceneId, 1, LS) of
%% 				false ->
%% 					check_scene(SceneId div 100, LS, 1);
%% 				{value,{_sceneid, Total}} ->
%% 					if
%% 						Total > ?SCENE_PLAYER_MAX_NUMBER ->
%% 							check_scene(SceneId div 100, LS, 1);
%% 						Total < ?SCENE_PLAYER_MIN_NUMBER andalso SceneId rem 100 =/= 1->
%% 							check_scene(SceneId div 100, LS, 1);
%% 						true ->
%% 							SceneId
%% 					end	
%% 			end;
%% 		[] -> error
%% 	end.	
%% 
%% %%   
%% %% 	MS = ets:fun2ms(fun(S) when S#ets_scene.type =/= 2,S#ets_scene.type =/= 3,S#ets_scene.id =:= PlayerStatus#player.scn -> S end), 
%% %%     case ets:select(?ETS_BASE_SCENE, MS) of
%% %%         []  -> 	%% 是副本 
%% %% 			PlayerStatus;
%% %%         [Scene] -> 	%% 是普通场景
%% %% 			case Scene#ets_scene.type =:= 5 of
%% %% 				true ->%%氏族领地
%% %% 					case PlayerStatus#player.unid of
%% %% 						0 ->
%% %% 							{SceneId, X, Y} = data_guild:get_manor_send_out(PlayerStatus#player.scn),
%% %% 							NewPlayerStatus = PlayerStatus#player{scn = SceneId, x = X, y = Y},
%% %% 							NewPlayerStatus;
%% %% 						_ ->
%% %% 							{ok, ScenePid} = mod_guild_manor:get_guild_manor_pid(500, PlayerStatus#player.unid, PlayerStatus#player.id, self()),
%% %% %% 							io:format("init manor ~p\n", [ScenePid]),
%% %% 							UniqueSceneId = lib_guild_manor:get_unique_manor_id(PlayerStatus#player.scn, PlayerStatus#player.unid),
%% %% 							NewPlayerStatus = PlayerStatus#player{scn = UniqueSceneId,
%% %% 																  other = PlayerStatus#player.other#player_other{pid_scene = ScenePid}},
%% %% 							NewPlayerStatus
%% %% 						end;
%% %% 				false ->
%% %% 					io:format("make the pid OMG \n"),
%% %% 					_ScenePid = mod_scene:get_scene_pid(PlayerStatus#player.scn, undefined, undefined),
%% %% 					io:format("init normal ~p\n", [_ScenePid]),
%% %% 					PlayerStatus
%% %% 			end
%% %% 	end.
%% 
%% %% 获取场景基本信息
%% get_scene_info(SceneId, _X, _Y, _PlayerId) ->
%% 	%%当前场景玩家信息
%% %% 	SceneUser = get_broadcast_user(SceneId, X, Y), 
%% 	SceneUser = get_scene_user(SceneId),
%% 	%%当前npc信息
%%     SceneNpc = get_scene_ele(SceneId div 100),
%% 	%io:format("~s get_scene_info[~p][~p]\n",[misc:time_format(now()), SceneId, SceneNpc]),
%% 	[SceneUser, SceneNpc].			
%% 	

%% 
%% %%进入当前场景
%% enter_scene(Player) ->
%% %% 	io:format("enter_scene_____________________ ~p ~n", [Player#player.other]),	
%%     {ok, BinData} = pt_12:write(12003, pt_12:trans_to_12003(Player)),
%%     mod_scene_agent:send_to_scene(Player#player.scn, BinData),
%% 	ets:insert(?ETS_ONLINE_SCENE, Player).
%% 
%% %%向场景表插入一个玩家
%% insert_scene(Player) ->
%% 	ets:insert(?ETS_ONLINE_SCENE, Player).
%% 
%% 
%% %%进入联盟场景,并向其他已进入同盟场景的玩家广播
%% enter_scene_union(Player) ->
%% 	%%io:format("enter_union_scene_____________________ ~p ~n", [Player#player.other]),	
%%     {ok, BinData} = pt_12:write(12003, pt_12:trans_to_12003(Player)),
%% 	ets:insert(?ETS_ONLINE_SCENE, Player),				%%插入ets
%% 	spawn(fun()->boradcast_to_scene_union(Player, BinData) end).			%%广播自身进入
%% 
%% %%向进入与Player同盟场景的玩家广播BinData
%% boradcast_to_scene_union(Player, BinData)->
%% 	SceneUser = get_scene_user(Player#player.scn),
%% 	SceneUser2 = split_same_union_scene_user(Player#player.un, SceneUser),	%%分离出相同同盟的场景玩家
%% 	F = fun(User) ->
%% 				if User =/= [] ->
%% 					   Uid = lists:nth(1, User),
%% 					   lib_send:send_to_uid(Uid,BinData);
%% 				   true ->
%% 					   skip
%% 				end
%% 		end,
%% 	lists:foreach(F , SceneUser2).
%% 	
%% 
%% %%获取场景信息，唯一id，区分是不是副本
%% get_data(SceneId) ->
%% 	MS = ets:fun2ms(fun(S) when S#ets_scene.type =/= 2,S#ets_scene.type =/= 3,S#ets_scene.id =:= SceneId -> S end), 
%%     case ets:select(?ETS_BASE_SCENE, MS) of
%%         []  -> 	%% 是副本
%% 			data_agent:scene_get(SceneId);
%%         [S] -> 	%% 是普通场景
%% 			S
%%     end.
%% 
%% %% 进入场景条件检查
%% check_enter(Status, Scene_Id) ->
%% 	{BaseSceneId, SceneId} =
%% 		if
%% 			Scene_Id < 1000 ->
%% 				{Scene_Id, auto_scene(Scene_Id)};
%% 			true ->
%% 				{Scene_Id div 100, Scene_Id}
%% 	end,
%%     case get_data(BaseSceneId) of
%%         [] ->
%%             {false, 0, 0, 0, <<"场景不存在!">>, 0, []};
%%         Scene ->
%% 			case Scene#ets_scene.type of
%% 				0 -> %% 普通场景
%% 					enter_normal_scene(SceneId, Scene, Status);
%% 				1 -> %% 普通场景
%% 					enter_normal_scene(SceneId, Scene, Status);
%% 				2 -> %% 普通场景
%% 					enter_normal_scene(SceneId, Scene, Status);
%% 				10 -> %% 挂机场景
%% 					enter_normal_scene(SceneId, Scene, Status);
%% 				11 -> %% 联盟场景
%% 					if Status#player.unid > 0 ->
%% 						   enter_normal_scene(SceneId, Scene, Status);
%% 					   true ->
%% 						   {false, 0, 0, 0, <<"场景不存在!">>, 0, []}
%% 					end;
%% %% 				13 ->	%%宠物岛
%% %% 					IslandSceneId = lib_island:check_enter_scene(Status),
%% %% 					if
%% %% 						SceneId =/= IslandSceneId ->
%% %% 							{false, 0, 0, 0, <<"您不能进入!">>, 0, []};
%% %% 						true ->
%% %% 							enter_normal_scene(SceneId, Scene, Status)
%% %% 					end
%% 				_ ->
%% 					{false, 0, 0, 0, <<"场景不存在!">>, 0, []}
%% 			end
%%     end.
%% 
%% %% %% 进入副本场景条件检查
%% %% check_enter_dungeon(Status, SceneId, Scene) ->
%% %% 	%% io:format("Here_1_ ~p ~n",[Status#player.other#player_other.pid_dungeon]),
%% %% 	if 
%% %% 		Status#player.id >= 450 ->  %% 临时处理：红名状态不能进入副本
%% %% 			{false, 0, 0, 0, <<"您处于红名状态，不能进入副本!">>, 0, []};
%% %% 		true ->						   
%% %% 			Now_dungeon_res_id = get_scene_id_from_scene_unique_id(Status#player.scn),
%% %% 			Dungeon_alive = misc:is_process_alive(Status#player.other#player_other.pid_dungeon),
%% %% 			if 
%% %% 				Dungeon_alive, SceneId =:= Now_dungeon_res_id ->
%% %% 					enter_dungeon_scene(Scene, Status); %% 已经有副本服务进程
%% %% %% 					case catch gen:call(Status#player.other#player_other.pid_dungeon, '$gen_call', {info_id}, 2000) of
%% %% %% 						{'EXIT', _Reason} ->
%% %% %% 							{false, 0, 0, 0, <<"无法进入副本，请稍候重试。">>, 0, []};
%% %% %% 						{ok, ExistingScid} ->
%% %% %% 							if
%% %% %% 								ExistingScid =:= SceneId ->
%% %% %% 									%% io:format("Here_2_ ~p ~n",[Status#player.other#player_other.pid_dungeon]),
%% %% %% 									enter_dungeon_scene(Scene, Status); %% 已经有副本服务进程
%% %% %% 								true ->
%% %% %% 									{false, 0, 0, 0, <<"队伍中存在其它副本或者封神台，无法创建新副本。">>, 0, []}
%% %% %% 							end
%% %% %% 					end;
%% %% %% 				Dungeon_alive =:= false andalso Status#player.other#player_other.leader =:= 2 ->
%% %% %% 					{false, 0, 0, 0, <<"队长才能创建新副本!">>, 0, []};
%% %%                 true -> %% 还没有副本服务进程
%% %% 					%% io:format("Here_3_ ~p ~n",[Status#player.other#player_other.pid_dungeon]),										
%% %% 					Result = 
%% %% 						case misc:is_process_alive(Status#player.other#player_other.pid_team) of
%% %% 							false -> %% 没有队伍，角色进程创建副本服务器
%% %% 								%% io:format("Here_4_ ~p ~n",[Status#player.other#player_other.pid_dungeon]),												
%% %% 								mod_dungeon:start(0, self(), SceneId, [{Status#player.id, 
%% %% 												Status#player.other#player_other.pid, Status#player.other#player_other.pid_dungeon}]);
%% %% 							true -> %% 有队伍且是队长，由队伍进程创建副本服务器
%% %% 								%% io:format("Here_5_ ~p ~n",[Status#player.other#player_other.pid_dungeon]),
%% %%                               	mod_team:create_dungeon(Status#player.other#player_other.pid_team, self(), 
%% %% 													SceneId, [SceneId, Status#player.id, 
%% %% 													Status#player.other#player_other.pid,
%% %% 													Status#player.other#player_other.pid_dungeon])
%% %% 						end,
%% %% 					case Result of 
%% %% 						{ok, Pid} ->
%% %% 							enter_dungeon_scene(Scene, Status#player{other=Status#player.other#player_other{pid_dungeon = Pid}});										
%% %% 						{fail, Msg} ->
%% %% 							{false, 0, 0, 0, Msg, 0, []}
%% %% 					end
%% %% 			end
%% %% 	end.
%% 
%% 
%% %%进入普通场景
%% enter_normal_scene(SceneId, Scene, Status) ->	
%% 	{true, SceneId, Scene#ets_scene.x, Scene#ets_scene.y, Scene#ets_scene.name, Scene#ets_scene.sid, 0, 0, Status}.
%% 
%% %% 临时屏蔽 以后处理分线问题
%% %% %%进入雷泽的分线
%% %% enter_normal_scene(SceneId,Scene,Status) when SceneId == 101 orelse SceneId == 190 orelse SceneId == 191 ->
%% %% 	%% 判断场景切换坐标位置
%% %% 	case check_change_scene(Status, SceneId) of
%% %% 		true ->
%% %%             case [{X, Y} || [Id, _Name, X, Y] <- Scene#ets_scene.elem, Id =:= Status#player.scn] of
%% %%                 [] -> 
%% %%                 %% 雷泽切线				
%% %%                     {true, SceneId, Status#player.x, Status#player.y , Scene#ets_scene.name, get_res_id(Scene#ets_scene.sid), 0, 0, Status};
%% %%                 %% 其他场景进入雷泽分线
%% %%                 [{X, Y}] -> 
%% %%                     case get_data(101) of
%% %%                         [] ->
%% %%                             {true, SceneId, Scene#ets_scene.x, Scene#ets_scene.y , Scene#ets_scene.name, Scene#ets_scene.sid, 0, 0, Status};
%% %%                         ResScene->
%% %%                             {true, SceneId, X, Y, Scene#ets_scene.name, ResScene#ets_scene.sid, 0, 0, Status}
%% %%                     end
%% %%             end;
%% %% 		false ->
%% %% 			{false, 0, 0, 0, <<"场景出错_那边没有返回本场景出口!">>, 0, []}	
%% %% 	end;
%% %% %%走出雷泽的分线
%% %% enter_normal_scene(SceneId, Scene, Status) when Status#player.scn == 101 orelse  Status#player.scn == 190 orelse  Status#player.scn == 191 ->
%% %% 	case [{X, Y} || [Id, _Name, X, Y] <- Scene#ets_scene.elem, Id =:= 101] of
%% %% 		 [] -> 
%% %% %% 			 io:format("Here_0100_ /~p// ~n",[SceneId]),				
%% %% 			{false, 0, 0, 0, <<"场景出错_那边没有返回本场景出口!">>, 0, []};
%% %%         [{X, Y}] -> 
%% %% 			%% 判断场景切换坐标位置
%% %% 			case check_change_scene(Status, SceneId) of
%% %% 				true ->
%% %% 					{true, SceneId, X, Y, Scene#ets_scene.name, Scene#ets_scene.sid, 0, 0, Status};
%% %% 				false ->
%% %% 					{false, 0, 0, 0, <<"场景出错_那边没有返回本场景出口!">>, 0, []}
%% %% 			end
%% %%     end;
%% 
%% %%     case [{X, Y} || [Id, _Name, X, Y] <- Scene#ets_scene.elem, Id =:= Status#player.scn] of
%% %%         [] -> 
%% %% 			%% io:format("Here_0100_ /~p// ~n",[SceneId]),				
%% %% 			{false, 0, 0, 0, <<"场景出错_那边没有返回本场景出口!">>, 0, []};
%% %%         [{X, Y}] ->
%% %% 			%% 判断场景切换坐标位置
%% %% 			case check_change_scene(Status, SceneId) of
%% %% 				true ->
%% %% 					{true, SceneId, X, Y, Scene#ets_scene.name, Scene#ets_scene.sid, 0, 0, Status};
%% %% 				false ->
%% %% 					{false, 0, 0, 0, <<"场景出错_那边没有返回本场景出口!">>, 0, []}
%% %% 			end
%% %%     end.
%% 
%% %% %% 进入副本场景
%% %% enter_dungeon_scene(Scene, Status) ->
%% %% 	%% io:format("Here_8_ ~p ~n",[[Scene#ets_scene.sid, Scene, Status#player.other#player_other.pid_dungeon]]),	
%% %%     case mod_dungeon:check_enter(Scene#ets_scene.sid, Scene#ets_scene.type, Status#player.other#player_other.pid_dungeon) of
%% %%         {false, Msg} ->
%% %% 			%% io:format("Here_9_ ~p ~n",[Msg]),			
%% %%             {false, 0, 0, 0, Msg, 0, []};
%% %%         {true, UniqueId} ->
%% %% 			%% io:format("Here_10_ ~p ~n",[[UniqueId, Status#player.scn]]),	
%% %% 			%% 次数限定：玩家每天可进入副本15次，超过15次则不能允许进入副本
%% %% 			if Status#player.id < 0 -> %%临时处理
%% %% 				   {false, 0, 0, 0, <<"临时处理！">>, 0, []};
%% %% 			   true->
%% %%                     Dungeon_maxtimes_default = 15,
%% %% 					{_NewPlayerStatus,_Auto,AwardTimes} = lib_vip:get_vip_award(dungeon,Status),
%% %% 					Dungeon_maxtimes =Dungeon_maxtimes_default+AwardTimes,
%% %%                     case check_dungeon_times(Status#player.id, Scene#ets_scene.sid, Dungeon_maxtimes) of
%% %%                         fail ->
%% %%                             Warning = lists:concat(["每天进入副本不能超过", Dungeon_maxtimes,"次!"]),
%% %%                             {false, 0, 0, 0, tool:to_binary(Warning), 0, []};
%% %%                         {pass, Counter} ->
%% %%                             Now_dungeon_res_id = get_scene_id_from_scene_unique_id(Status#player.scn),
%% %%                             MS = ets:fun2ms(fun(T) when T#ets_scene.sid =:= Now_dungeon_res_id -> T end), 
%% %%                             L = ets:select(?ETS_BASE_SCENE, MS),					
%% %%                             case L of
%% %%                                 []  -> 
%% %%         %% io:format("Here_11_ ~p ~n",[[UniqueId, Status#player.scn]]),					
%% %%                                     {false, 0, 0, 0, <<"场景出错_2!">>, 0, []};
%% %%                                 [S] ->
%% %%                                     %%进入副本场景卸下坐骑
%% %%                                     {ok, NewStatus} = lib_goods:force_off_mount(Status),
%% %% %% ?DEBUG("Here_11_sce_b4_dg__222_~p/",[[UniqueId, Status#player.scn]]),
%% %% 									if
%% %% 										Scene#ets_scene.sid =:= 911 ->
%% %% 											put(sce_b4_dg, Status#player.scn);
%% %% 										true ->
%% %% 											ok
%% %% 									end,
%% %% 									%% 更新人物延时保存信息
%% %% 									mod_delayer:update_delayer_info(NewStatus#player.id, NewStatus#player.other#player_other.pid_dungeon, NewStatus#player.other#player_other.pid_fst, NewStatus#player.other#player_other.pid_team),
%% %% 									Msg= io_lib:format("您的队友~s进入了~s",[NewStatus#player.nick, Scene#ets_scene.name]),
%% %% 									{ok,TeamBinData} = pt_15:write(15055,[Msg]),
%% %% 									gen_server:cast(NewStatus#player.other#player_other.pid_team,
%% %% 													{'SEND_TO_OTHER_MEMBER', NewStatus#player.id, TeamBinData}),
%% %% 									%% 临时处理，不做检查
%% %% 									{true, UniqueId, Scene#ets_scene.x, Scene#ets_scene.y, Scene#ets_scene.name, Scene#ets_scene.sid, Counter, Dungeon_maxtimes, NewStatus}
%% %% %%                                     case [{X, Y} || [Id0, _Name, X, Y] <- Scene#ets_scene.elem, Id0 =:= S#ets_scene.sid] of
%% %% %%                                         [] -> 							
%% %% %%                                             {true, UniqueId, Scene#ets_scene.x, Scene#ets_scene.y, Scene#ets_scene.name, Scene#ets_scene.sid, Counter, Dungeon_maxtimes, NewStatus};
%% %% %%                                         [{X, Y}] -> 						
%% %% %%                                             {true, UniqueId, X, Y, Scene#ets_scene.name, Scene#ets_scene.sid, Counter, Dungeon_maxtimes, NewStatus}
%% %% %%                                     end
%% %%                             end
%% %%                     end
%% %% 			end
%% %%     end.
%% 
%% %% 检查进入副本场景次数限制
%% %% check_dungeon_times(Player_id, Dungeon_id, MaxTimes) ->
%% %% 	case db_agent:get_log_dungeon(Player_id, Dungeon_id) of
%% %% 		[] -> 
%% %% 			S = 0,
%% %% 			M = 0,
%% %% 			Counter = 0;
%% %% 		LogInfo -> 
%% %% 			Log_dungeon = list_to_tuple([log_dungeon] ++ LogInfo),
%% %% %% 			S = Log_dungeon#log_dungeon.first_dungeon_time rem 1000000,
%% %% %% 			M = util:floor(Log_dungeon#log_dungeon.first_dungeon_time / 1000000),
%% %% %% 			Counter = Log_dungeon#log_dungeon.dungeon_counter
%% %% 			[S, M, Counter] = [1,1,1]  %% 临时处理
%% %% 	end,
%% %% 
%% %% 	Type =
%% %% 		case Dungeon_id of
%% %% 			998 ->
%% %% 				tds;
%% %% 			999 ->
%% %% 				tdm;
%% %% 			Val when Val > 1000 ->
%% %% 				fst;
%% %% 			_ ->
%% %% 				tool:to_atom( "fb_" ++ tool:to_list(Dungeon_id))
%% %% 		end,
%% %% 	T1 = misc:date_format({M, S, 0}),
%% %% 	T2 = misc:date_format(now()),
%% %% 	if T1 =/= T2 ->
%% %% 			if S =:= 0, M =:= 0 ->
%% %% 				   	spawn(fun()->db_agent:insert_log_dungeon(Player_id, Dungeon_id, util:unixtime(), 1)end);
%% %% 			   true ->
%% %% 				   	spawn(fun()->db_agent:update_log_dungeon(Player_id, Dungeon_id, util:unixtime(), 1)end)
%% %% 			end,
%% %% 			spawn(fun()->db_agent:update_join_data(Player_id, Type)end),
%% %% 			{pass, 1};
%% %% 		true ->
%% %% 			if Counter < MaxTimes ->
%% %% 				 spawn(fun()->db_agent:update_log_dungeon(Player_id, Dungeon_id, util:unixtime(), Counter + 1)end),
%% %% 				 spawn(fun()->db_agent:update_join_data(Player_id, Type)end),
%% %% 				 {pass, Counter + 1};
%% %% 			   true ->
%% %% 				 fail
%% %% 			end
%% %% 	end.
%% 
%% %% 创建全局唯一的副本场景ID(包含 SceneId和SceneType信息) 
%% create_unique_scene_id(SceneId, AutoIncId) ->
%% 	AutoIncId*10000 + SceneId.
%%  
%% %% 从全局唯一副本场景 ID获取SceneId
%% get_scene_id_from_scene_unique_id(UniqueId) ->
%% 	UniqueId rem 10000.
%% 
%% %% 是子场景，唯一id

%% 
%% %% 用唯一id获取场景的资源id
%% get_res_id(UniqueId) ->
%%     case is_copy_scene(UniqueId) of
%%         false -> 
%% 			if
%% 				UniqueId == 190 orelse UniqueId == 191 ->
%% 					101;
%% 				true ->
%% 					UniqueId    %% 无需转换
%% 			end;
%%         true ->
%% 			get_scene_id_from_scene_unique_id(UniqueId)
%%     end.
%% 
%% %% 是否为副本场景，UniqueId唯一id，会检查是否存在这个场景
%% is_dungeon_scene(UniqueId) ->
%%     case is_copy_scene(UniqueId) of
%%         false -> false;
%%         true ->
%% 			Id = get_scene_id_from_scene_unique_id(UniqueId),
%%             case ets:lookup(?ETS_BASE_SCENE, Id) of
%%                 [] -> false;
%%                 [S] -> S#ets_scene.type =:=2
%%             end			
%%     end.
%% 
%% %% 判断在场景SID的[X,Y]坐标是否有障碍物
%% is_blocked(SID, [X, Y]) ->
%%     case ets:lookup(?ETS_BASE_SCENE_POSES, {SID, X, Y}) of
%%             [] -> true; % 无障碍物
%%             [_] -> false % 有障碍物
%%     end.
%% 
%% %% %% 刷新npc任务状态
%% %% refresh_npc_ico(PlayerId) when is_integer(PlayerId)->
%% %%     case lib_player:get_player_pid(PlayerId) of
%% %%         [] -> ok;
%% %%         Pid -> gen_server:cast(Pid, {cast, {?MODULE, refresh_npc_ico, []}})
%% %%     end;
%% %% 
%% %% %% 刷新npc任务状态
%% %% refresh_npc_ico(Pid) when is_pid(Pid)->
%% %%    gen_server:cast(Pid, {cast, {?MODULE, refresh_npc_ico, []}});
%% %% 
%% %% %% 刷新npc任务状态
%% %% refresh_npc_ico(Status) ->
%% %%     NpcList = mod_scene:get_scene_npc(Status#player.scn),
%% %% 
%% %%     L = [[NpcId, lib_task:get_npc_state(NpcId, Status)]|| [NpcId | _] <- NpcList],
%% %% %%  L = [[NpcId, gen_server:call(Status#player.other#player_other.pid_task,{'get_npc_state',Status,NpcId})]|| [NpcId | _] <- NpcList],
%% %% %% io:format("refresh_npc_ico:__/~p / ~p / ~p /_ ~n",[Status#player.scn, NpcList, L]),	
%% %%     {ok, BinData} = pt_12:write(12020, [L]),
%% %%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).
%% 
%% %% 获取战斗被击方信息
%% %% PlayerId 玩家ID
%% %% SceneId 场景ID
%% get_battle_der(PlayerId, SceneId) ->
%% 	case ets:lookup(?ETS_ONLINE, PlayerId) of
%%    		[] ->
%% 			case lib_player:get_user_info_by_id(PlayerId) of
%% 				[] -> 					
%% 					call_fail;
%% 				Player ->
%% 					case Player#player.scn == SceneId of
%% 						true ->
%% 							Player;
%% 						false ->
%% 							no_find
%% 					end
%% 			end;
%%    		[Player] ->
%%        		case is_process_alive(Player#player.other#player_other.pid) of
%%            		true ->
%% 					case Player#player.scn == SceneId of
%% 						true ->
%% 							Player;
%% 						false ->
%% 							no_find
%% 					end;
%%            		false ->               		
%%                		no_find
%%        		end
%% 	end.
%% 
%% %% %% 获取所有场景的相邻关系
%% %% get_border() ->
%% %% 	MS = ets:fun2ms(fun(S) when S#ets_scene.type =/= 2,S#ets_scene.type =/= 3 -> S end), 
%% %% 	L = ets:select(?ETS_BASE_SCENE, MS),
%% %%     get_border_list(L, []).
%% 
%% %% %% 抽取相邻关系
%% %% get_border_list([], List) -> List;
%% %% get_border_list([S | T], List) ->
%% %%     BL = get_border_id_list(S#ets_scene.elem, []),
%% %%     B = {S#ets_scene.id, BL},
%% %%     get_border_list(T, [B | List]).
%% 
%% %% %% 抽取相邻场景的ID列表
%% %% get_border_id_list([], List) ->
%% %%     List;
%% %% get_border_id_list([[Id, _, _, _] | T], List) ->
%% %%     get_border_id_list(T, [Id | List]).
%% 
%% %%--------------------------九宫格加载场景---------------------------
%% 把整个地图共有100*100个格子，0，0坐标点为原点，以64*64为一个格子，从左到右编号1，2，3，4最终成为10*10的正方形
%获取当前所在的格子
%% get_xy(X, Y) ->
%% 	Y div 15 * 10 + X div 10 + 1.
%% 
%% %%  获取场景内要广播的范围用户信息
%% get_broadcast_user(SceneId, X, Y) ->
%% %%io:format("get_broadcast_user_###########################_~p/~p ~n",[X, Y]),
%%     AllUser = get_scene_user(SceneId),
%%     XY = get_xy(X, Y),
%%     get_broadcast_user_loop(AllUser, XY, []).
%% 
%% %%  获取场景内要广播的范围用户信息(本节点)
%% get_broadcast_user_node(SceneId, X, Y) ->
%%     AllUser = get_scene_user_node(SceneId),
%%     XY = get_xy(X, Y),
%%     get_broadcast_user_loop(AllUser, XY, []).
%% 
%% get_broadcast_user_loop([], _XY2, D) -> D;
%% get_broadcast_user_loop([P | U], XY, D) ->
%%     [_Id, _Nick, X, Y, _Hp, _MxHp, _Eng, _Lv, _Career, _Speed, _Sex, _OutPetType, _OutPetName, _Pid, _Camp, _Un,  _Sta,  _Stren, _SuitID, _Vip, _Img, _Mnt, _MountStren,_Tid] = P,
%%     UserXY = get_xy(X, Y),
%% 	case is_in_area(UserXY, XY) of
%% 		true ->
%% 			get_broadcast_user_loop(U, XY, [P | D]);
%% 		false ->
%% 			get_broadcast_user_loop(U, XY, D)
%% 	end.
%% 
%% %% %%  获取场景内要广播的范围怪物信息(本节点)
%% %% get_broadcast_mon(SceneId, X, Y) ->
%% %% 	AllMon = get_area_scene_mon(SceneId, X, Y),
%% %%     XY = get_xy(X, Y),
%% %%     get_broadcast_mon_loop(AllMon, XY, []).
%% %% 
%% %% get_broadcast_mon_loop([], _XY, D) -> D;
%% %% get_broadcast_mon_loop([M | T], XY, D) ->
%% %%     [_Id, _Name, X, Y, _Hp, _HpLim, _Mp, _MpLim, _Lv, _Mid, _Icon, _Type, _AttArea] = M,
%% %% 	MonXY = get_xy(X, Y),
%% %% 	case is_in_area(MonXY, XY) of
%% %% 		true ->
%% %% 			get_broadcast_mon_loop(T, XY, [M | D]);
%% %% 		false ->
%% %% 			get_broadcast_mon_loop(T, XY, D)
%% %% 	end.
%% 
%% %% %% 获取场景所有队长
%% %% %% SceneId 玩家所在的场景ID
%% %% get_scene_team_info(SceneId, X, Y) ->	
%% %% 	MS = ets:fun2ms(fun(P) when P#player.scn == SceneId 
%% %% 						 andalso P#player.other#player_other.leader == 1 
%% %% 						 andalso P#player.x > X - 16 andalso X + 16 > P#player.x
%% %% 						 andalso P#player.y > Y - 16 andalso Y + 16 > P#player.y ->
%% %% 		[
%% %%             P#player.id,
%% %%             P#player.nick,
%% %%             P#player.lv,
%% %%             P#player.crr,
%% %% 			P#player.camp,           
%% %%             P#player.other#player_other.pid,            
%% %%             P#player.other#player_other.pid_team                        
%% %% 		]
%% %% 	end),
%% %%    	AllUser = ets:select(?ETS_ONLINE_SCENE, MS),
%% %%     get_scene_team_info_loop(AllUser, []).
%% 
%% %% %% 遍历获取场景所有队长
%% %% %% AllUser 场景所有的玩家
%% %% %% Data 存放该场景队长数据的累加器
%% %% get_scene_team_info_loop([], Data) -> Data;
%% %% get_scene_team_info_loop([[Id, Nick, Lv, Career, Realm, Pid, TeamPid] | T], Data) ->
%% %%     case misc:is_process_alive(Pid) andalso is_pid(TeamPid) of                
%% %%         true ->
%% %%             case catch gen_server:call(TeamPid, 'GET_TEAM_INFO') of
%% %%                 {'EXIT', _} ->
%% %%                     get_scene_team_info_loop(T, Data);
%% %%                 TeamInfo ->
%% %%                     Num = length(TeamInfo#team.member),
%% %% 					Auto = TeamInfo#team.auto_access,
%% %%                     get_scene_team_info_loop(T, [[Id, Nick, Lv, Career, Realm, Num, Auto] | Data])
%% %%             end;                        
%% %%         false ->
%% %%             get_scene_team_info_loop(T, Data)
%% %%     end.
%% 
%% %% 获取范围内的玩家(怪物使用)
%% get_area_user_for_battle(SceneId, X, Y, GuardArea) ->	
%%     X1 = X + GuardArea,
%%     X2 = X - GuardArea,
%%     Y1 = Y + GuardArea,
%%     Y2 = Y - GuardArea,	
%% 	MS = ets:fun2ms(fun(P) when P#player.scn == SceneId andalso P#player.hp > 0 andalso
%% 								P#player.x >= X2 andalso P#player.x =< X1 andalso 
%% 								P#player.y >= Y2 andalso P#player.y =< Y1 ->
%% 		[
%% 			P#player.id, 
%% 			P#player.other#player_other.pid, 
%% 			P#player.x, 
%% 			P#player.y			
%% 		]
%% 	end),
%% 	AllUser = ets:select(?ETS_ONLINE_SCENE, MS),
%%     get_area_user_for_battlle_loop(AllUser, X, Y, 1000000, []).
%% %% 获取一个最近的玩家
%% get_area_user_for_battlle_loop([], _MX, _MY, _Len, Ret) -> 
%% 	Ret;
%% get_area_user_for_battlle_loop([[Id, Pid, X, Y] | U], MX, MY, Len, Ret) ->
%%     Dist = abs(X - MX) + abs(Y - MY),    
%%     {NewLen, NewRet} =
%%         case Dist < Len of
%%             true -> 
%% 				{Dist, [Id, Pid]};
%%             false -> 
%% 				{Len, Ret}
%%         end,
%%     get_area_user_for_battlle_loop(U, MX, MY, NewLen, NewRet).
%% 
%% %% 获取场景内要广播的范围用户ID(本节点)
%% get_broadcast_id_node(SceneId, X, Y) ->
%%    	Pattern = ets:fun2ms(fun(P) when P#player.scn == SceneId ->
%% 		[
%%        		P#player.id,
%%       		P#player.x,
%%        		P#player.y
%% 		]
%% 	end),
%%    	AllUser = ets:select(?ETS_ONLINE, Pattern),
%%     XY = get_xy(X, Y),
%%     get_broadcast_id_loop(AllUser, XY, []).
%% 
%% get_broadcast_id_loop([], _XY, D) -> D;
%% get_broadcast_id_loop([[Id, X, Y] | T], XY, D) ->
%%     NewXY = get_xy(X, Y),
%% 	case is_in_area(NewXY, XY) of
%% 		true ->
%% 			get_broadcast_id_loop(T, XY, [Id | D]);
%% 		false ->
%% 			get_broadcast_id_loop(T, XY, D)
%% 	end.
%% 
%% is_in_area(XY1, XY2) ->
%% 	XY1 == XY2 orelse XY1 == XY2 + 1 orelse XY1 == XY2 - 1 orelse XY1 == XY2 - 10 orelse XY1 == XY2 + 10 orelse XY1 == XY2 - 11 orelse XY1 == XY2 + 11 orelse XY1 == XY2 - 9 orelse XY1 == XY2 + 9.	
%% 
%% %% %% 复活进入场景
%% %% %% ReviveType 1高级稻草人； 2稻草人； 3安全复活
%% %% revive_to_scene(Player, ReviveType, FromType) ->
%% %% 	lib_hack:reset_speed_mark(),
%% %%     case ReviveType of
%% %% %%         %% 高级稻草人
%% %% %%         1 ->
%% %% %% 			special_revive_to_scene(Player, ReviveType, FromType, 28401, ?ADVANCED_REVIVE_COST, 2001, 1);
%% %% %%         %% 稻草人
%% %% %%         2 ->
%% %% %% 			special_revive_to_scene(Player, ReviveType, FromType, 28400, ?REVIVE_COST, 2002, 2);
%% %% 		%% 竞技场死亡复活
%% %% 		4 ->
%% %% 			[X, Y] = 
%% %% 				case Player#player.other#player_other.leader of
%% %% 					8 ->
%% %% 						[11, 60];
%% %% 					9 ->
%% %% 						[60, 62];
%% %% 					_ ->
%% %% 						[Player#player.x, Player#player.y]
%% %% 				end,
%% %% 			NewPlayer = Player#player{
%% %%                 hp = Player#player.mxhp,                           
%% %%                 x = X,
%% %%                 y = Y
%% %%             },
%% %% 			revive_to_scene_agent(NewPlayer, Player, ReviveType);
%% %% 		_ ->
%% %% 			NewPlayer = Player#player{
%% %% 				hp = trunc(Player#player.mxhp / 10),
%% %% 				stts = 0 							 
%% %% 			},
%% %% 			{ok, HookBinData} = pt_26:write(26003, [0, 0]),
%% %%     		lib_send:send_to_sid(NewPlayer#player.other#player_other.pid_send, HookBinData),
%% %%             revive_to_scene_agent(NewPlayer, Player, ReviveType)            
%% %%     end.
%% %% 
%% %% %% 稻草人复活
%% %% special_revive_to_scene(Player, ReviveType, FromType, GoodsId, Cost, CostType, HpParam) ->
%% %% 	case FromType of
%% %%         hook ->
%% %%             case lib_goods:goods_find(Player#player.id, GoodsId) of
%% %%                 false ->
%% %%               		Player;                                            
%% %%                 _Goods ->
%% %% 					gen_server:cast(Player#player.other#player_other.pid_goods, {'DELETE_MORE_inBAG', GoodsId, 1}),
%% %%                     NewPlayer = Player#player{
%% %%                         hp = trunc(Player#player.mxhp / HpParam)                          
%% %%                     },
%% %%                     revive_to_scene_agent(NewPlayer, Player, ReviveType)
%% %%             end;
%% %%         battle ->
%% %% 			RetPlayer =
%% %%                 case lib_goods:goods_find(Player#player.id, GoodsId) of
%% %%                     false ->                                            	
%% %%                    		case lib_player:player_status(Player) of
%% %%                      		3 ->										
%% %%                      			lib_goods:cost_money(Player, Cost, gold, CostType);
%% %%                        		_ ->
%% %%                           		Player
%% %%                       	end;
%% %%                     _Goods ->
%% %% 						gen_server:cast(Player#player.other#player_other.pid_goods, {'DELETE_MORE_inBAG', GoodsId, 1}),
%% %%                         Player
%% %%                 end,
%% %% 			NewPlayer = RetPlayer#player{
%% %%      			hp = trunc(RetPlayer#player.mxhp / HpParam)                           			                        
%% %%           	},
%% %%          	revive_to_scene_agent(NewPlayer, RetPlayer, ReviveType);
%% %%         _ ->
%% %%       		Player
%% %%     end.
%% %% 
%% %% revive_to_scene_agent(NewPlayer, Player, ReviveType) ->
%% %% 	RetPlayer = 
%% %% 		case NewPlayer#player.stts of
%% %% 			%% 挂机状态
%% %% 			5 ->
%% %% 				NewPlayer;
%% %% 			_Other ->
%% %% 				NewPlayer#player{
%% %% 					stts = 0
%% %% 				}											
%% %% 		end,
%% %% 	case RetPlayer#player.scn == Player#player.scn of
%% %% 		true ->
%% %%             BinData = pt_12:trans_to_12003(RetPlayer),
%% %%             NewReviveType = ReviveType,
%% %%             %% 复活到场景
%% %%             mod_scene_agent:revive_to_scene(Player#player.other#player_other.pid, 
%% %%                     Player#player.id, NewReviveType,
%% %%                     RetPlayer#player.scn, RetPlayer#player.x, RetPlayer#player.y,
%% %%                     Player#player.scn, Player#player.x, Player#player.y, BinData),
%% %% 			lib_player:send_player_attribute(RetPlayer, 1);
%% %% 		false ->
%% %% 			%% 通知本屏玩家你离开死亡点
%% %% 			{ok, BinData} = pt_12:write(12011, [[], [Player#player.id], [], []]),
%% %% 			mod_scene_agent:send_to_scene(Player#player.scn, BinData),
%% %% 			pp_scene:handle(12004, Player, Player#player.scn),
%% %% 			lib_player:send_player_attribute(RetPlayer, 0)
%% %% 	end,
%% %% 	lib_team:update_team_player_info(RetPlayer),
%% %% 	RetPlayer.
%% %% 
%% %% %% 复活进入场景(本节点)
%% %% revive_to_scene_node(PlayerPid, PlayerId, ReviveType, NewSceneId, X1, Y1, SceneId, X2, Y2, Bin12003) ->
%% %% 	%% 通知本屏玩家你离开死亡点
%% %% 	if 
%% %% 		ReviveType == 3 orelse ReviveType == 4 orelse ReviveType == 5 ->
%% %% 		   	{ok, DieLeaveBinData} = pt_12:write(12011, [[], [PlayerId], [], []]),
%% %% 			lib_send:send_to_local_scene(SceneId, X2, Y2, DieLeaveBinData);
%% %% 		true -> 
%% %% 			no_action
%% %% 	end,
%% %% 	
%% %% 	%% 通知本玩家
%% %%     EnterUser = get_broadcast_user_node(NewSceneId, X1, Y1),
%% %%     LeaveUser = get_broadcast_id_node(SceneId, X2, Y2),
%% %% 	if 	
%% %% 		length(EnterUser) + length(LeaveUser) > 0  ->
%% %%     		{ok, EnterLeaveBinData} = pt_12:write(12011, [EnterUser, LeaveUser]),
%% %% 			gen_server:cast(PlayerPid, {send_to_sid, EnterLeaveBinData});
%% %% 		true -> no_send
%% %% 	end,
%% %% 
%% %% 	{ok, EnterBroadcastBinData} = pt_12:write(12003, Bin12003),
%% %% 	gen_server:cast(PlayerPid, {send_to_sid, EnterBroadcastBinData}).
%% 
%% %% %% 当人物移动时候的广播(节点代理处理)
%% %% %% 终点要X1, Y1，原点是X2, Y2
%% %% move_broadcast_node(SceneId, PlayerPid, X1, Y1, X2, Y2,PlayerId,Ps,MoveBinData, LeaveBinData, EnterBinData) ->
%% %% 	
%% %% 	%%更新当前移动玩家的场景数据 x,y,status
%% %% 	Pattern = #player{id = PlayerId,scn = SceneId ,_='_'},
%% %% 	MovePlayer = goods_util:get_ets_info(?ETS_ONLINE_SCENE,Pattern),
%% %% 	if
%% %% 		is_record(MovePlayer,player) ->
%% %% 			ets:insert(?ETS_ONLINE_SCENE, MovePlayer#player{x=X1,y=Y1,stts = Ps});
%% %% 		true ->
%% %% 			skip
%% %% 	end,
%% %%     XY1 = get_xy(X1, Y1),
%% %%     XY2 = get_xy(X2, Y2),
%% %%     %%当前场景玩家信息
%% %% 	MS = ets:fun2ms(fun(T) when T#player.scn == SceneId ->
%% %% 		[
%% %% 		 T#player.x,
%% %% 		 T#player.y,
%% %% 		 T#player.id,
%% %% 		 T#player.camp,
%% %% 		 T#player.stts,
%% %% 		 T#player.img,
%% %% 		 T#player.nick,
%% %% 		 T#player.spd,
%% %% 		 T#player.mnt,
%% %% 		 T#player.other#player_other.mount_stren,
%% %% 		 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3],
%% %% 		 T#player.other#player_other.pid
%% %% 		]
%% %% 	end),
%% %%    	AllUser = ets:select(?ETS_ONLINE, MS),
%% %% 	%%?DEBUG("---------------USER:~p~n",[length(AllUser)]),
%% %%     %% 加入和移除玩家
%% %% 	[EnterUser, LeaveUser] = 
%% %%         if
%% %%             XY2 == XY1 -> %% 同一个格子内
%% %%                 move_loop1(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 + 1 == XY1 -> %% 向右
%% %%                 move_loop2(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 - 1 == XY1 -> %% 向左
%% %%                 move_loop3(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 - 8 == XY1 -> %% 向上
%% %%                 move_loop4(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 + 8 == XY1 -> %% 向下
%% %%                 move_loop5(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 - 9 == XY1 -> %% 向左上
%% %%                 move_loop6(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 + 7 == XY1 -> %% 向左下
%% %%                 move_loop7(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 - 7 == XY1 -> %% 向右上
%% %%                 move_loop8(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             XY2 + 9 == XY1 -> %% 向右下
%% %%                 move_loop9(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], []);
%% %%             true ->
%% %%                 move_loop1(AllUser, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], [], [])
%% %%         end,    
%% %% 	if 	
%% %% 		length(EnterUser) + length(LeaveUser) > 0  ->
%% %%     		{ok, Data} = pt_12:write(12011, [EnterUser, LeaveUser]),
%% %% 			gen_server:cast(PlayerPid, {send_to_sid2, Data});
%% %% 		true -> 
%% %% 			no_send
%% %% 	end.
%% 
%% %% 当人物移动时候的广播(节点代理处理)
%% %% 终点要X1, Y1，原点是X2, Y2
%% move_broadcast_node(SceneId, PlayerPid, X1, Y1, X2, Y2,PlayerId,Ps,MoveBinData, LeaveBinData, EnterBinData) ->
%% 	
%% 	%%更新当前移动玩家的场景数据 x,y,status
%% 	Pattern = #player{id = PlayerId,scn = SceneId ,_='_'},
%% 	MovePlayer = goods_util:get_ets_info(?ETS_ONLINE_SCENE,Pattern),
%% 	if
%% 		is_record(MovePlayer,player) ->
%% 			ets:insert(?ETS_ONLINE_SCENE, MovePlayer#player{x=X1,y=Y1,stts = Ps});
%% 		true ->
%% 			skip
%% 	end,
%% %%     XY1 = get_xy(X1, Y1),
%% %%     XY2 = get_xy(X2, Y2),
%%     %%当前场景玩家信息
%% 	MS = ets:fun2ms(fun(T) when T#player.scn == SceneId ->
%% 		[
%% 		 T#player.x,
%% 		 T#player.y,
%% 		 T#player.id,
%% 		 T#player.camp,
%% 		 T#player.stts,
%% 		 T#player.img,
%% 		 T#player.nick,
%% 		 T#player.spd,
%% 		 T#player.mnt,
%% 		 T#player.other#player_other.mount_stren,
%% 		 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3],
%% 		 T#player.other#player_other.pid
%% 		]
%% 	end),
%%    	AllUser = ets:select(?ETS_ONLINE, MS),
%% 	
%% 	move_loop_all(AllUser, MoveBinData).
%% 
%% %% 当人物在联盟场景移动时候的广播(节点代理处理)
%% %% 终点要X1, Y1，原点是X2, Y2
%% move_broadcast_node_union(SceneId, Un, X1, Y1,PlayerId,Ps,MoveBinData) ->
%% 	
%% 	%%更新当前移动玩家的场景数据 x,y,status
%% 	Pattern = #player{id = PlayerId,scn = SceneId ,_='_'},
%% 	MovePlayer = goods_util:get_ets_info(?ETS_ONLINE_SCENE,Pattern),
%% 	if
%% 		is_record(MovePlayer,player) ->
%% 			ets:insert(?ETS_ONLINE_SCENE, MovePlayer#player{x=X1,y=Y1,stts = Ps});
%% 		true ->
%% 			skip
%% 	end,
%% 	
%%     %%当前联盟场景玩家信息
%% 	MS = ets:fun2ms(fun(T) when T#player.scn == SceneId andalso T#player.un =:= Un ->
%% 		[
%% 		 T#player.x,
%% 		 T#player.y,
%% 		 T#player.id,
%% 		 T#player.camp,
%% 		 T#player.stts,
%% 		 T#player.img,
%% 		 T#player.nick,
%% 		 T#player.spd,
%% 		 T#player.mnt,
%% 		 T#player.other#player_other.mount_stren,
%% 		 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3],
%% 		 T#player.other#player_other.pid
%% 		]
%% 	end),
%%    	AllUser = ets:select(?ETS_ONLINE, MS),
%% 	
%% 	move_loop_all(AllUser, MoveBinData).
%% 
%% move_loop_all([], _) -> ok;
%% move_loop_all([D | T], MoveBinData) ->
%% %%     [_Id, _Nick, X, Y, _Hp, _Hp_lim, _Mp, _Mp_lim, _Lv, _Career, Sids | _] = D,
%% 	[_X, _Y, _Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid | _] = D,
%% 	spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%% 	move_loop_all(T, MoveBinData).
%% 
%% 
%% move_loop1([], _, EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop1([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [_Id, _Nick, X, Y, _Hp, _Hp_lim, _Mp, _Mp_lim, _Lv, _Career, Sids | _] = D,
%% 	[X, Y, _Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid | _] = D, 
%%     XY = get_xy(X, Y),
%% 	
%%     if
%% 		MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 + 1 orelse XY == XY2 -1 orelse XY == XY2 -10 orelse XY == XY2 +10 orelse XY == XY2 -11 orelse XY == XY2 +11 orelse XY == XY2 -9  orelse XY == XY2+9) ->
%% 			%%io:format("--------x:~p-----y:~p~n",[X,Y]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end);
%%         true ->
%% 			skip
%%     end,
%% 	move_loop1(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser).
%% 
%% move_loop2([], _, EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop2([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %% 	io:format("-------------~p ~n",[D]),
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%% 	[X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%%     XY = get_xy(X, Y),	
%%     if
%% 		XY == XY1 + 1 orelse XY == XY1 + 11 orelse XY == XY1 - 9 -> % 进入
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			%%?DEBUG("-----------------ENTER---2:~p~n",[Id]),
%% 			move_loop2(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);			
%%         XY == XY2 - 1 orelse XY == XY2 - 11 orelse XY == XY2 + 9 -> % 离开
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop2(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%% 		MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 + 1  orelse XY == XY2 -10 orelse XY == XY2 +10 orelse XY == XY2 + 11 orelse XY == XY2 - 9) -> % 公共区域
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop2(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop2(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop3([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop3([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%% 	[X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%% 	XY = get_xy(X, Y),	
%%     if
%% 		XY == XY1 - 1 orelse XY == XY1 - 11 orelse XY == XY1 + 9 -> % 进入
%% 			%%?DEBUG("-----------------ENTER---3:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop3(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);			
%%         XY == XY2 + 1 orelse XY == XY2 + 11 orelse XY == XY2 - 9 -> % 离开
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%              move_loop3(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%% 		MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 - 11 orelse XY == XY2 -1 orelse XY == XY2 -10 orelse XY == XY2 +10 orelse XY == XY2+9) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop3(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop3(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop4([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop4([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%% 	[X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%% 	XY = get_xy(X, Y),	
%%     if
%% 		XY == XY1 - 10 orelse XY == XY1 - 11 orelse XY == XY1 - 9 ->
%% 			%%?DEBUG("-----------------ENTER---4:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop4(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         XY == XY2 + 10 orelse XY == XY2 + 11 orelse XY == XY2 + 9 -> % 离开
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop4(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%%         MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 + 1 orelse XY == XY2 - 1 orelse XY == XY2 - 10 orelse XY == XY2 - 11 orelse XY == XY2 - 9) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop4(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop4(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop5([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop5([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%%     [X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%% 	XY = get_xy(X, Y),
%%     if
%% 		XY == XY1 + 10 orelse XY == XY1 + 11 orelse XY == XY1 + 9 ->
%% 			%%?DEBUG("-----------------ENTER---5:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop5(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);			
%%         XY == XY2 - 10 orelse XY == XY2 - 11 orelse XY == XY2 - 9 -> % 离开
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop5(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%%         MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 + 1 orelse XY == XY2 - 1 orelse XY == XY2 + 10 orelse XY == XY2 + 11 orelse XY == XY2 + 9) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop5(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop5(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop6([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop6([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%% 	[X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%% 	XY = get_xy(X, Y),
%%     if
%% 		XY == XY1 - 1 orelse XY == XY1 - 11 orelse XY == XY1 - 10 orelse XY == XY1 - 9 orelse XY == XY1 + 9 ->
%% 			%%?DEBUG("-----------------ENTER---6:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop6(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         XY == XY2 + 1 orelse XY == XY2 + 11 orelse XY == XY2 + 10 orelse XY == XY2 + 9 orelse XY == XY2 - 9 ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop6(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%%         MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 - 11 orelse XY == XY2 - 1 orelse XY == XY2 - 10) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop6(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop6(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop7([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop7([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%% 	[X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%% 	XY = get_xy(X, Y),
%%     if
%% 		XY == XY1 - 11 orelse XY == XY1 - 1 orelse XY == XY1 + 9 orelse XY == XY1 + 10 orelse XY == XY1 + 11 ->
%% 			%%?DEBUG("-----------------ENTER---7:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop7(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         XY == XY2 + 11 orelse XY == XY2 + 1 orelse XY == XY2 - 9 orelse XY == XY2 - 10 orelse XY == XY2 - 11 ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop7(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%%         MoveBinData /= 3 andalso (XY == XY2 orelse XY == XY2 - 1 orelse XY == XY2 + 10 orelse XY == XY2 + 9) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop7(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop7(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop8([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop8([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids,Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%% 	[X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%%     XY = get_xy(X, Y),
%%     if
%% 		XY == XY1 + 1 orelse XY == XY1 + 11 orelse XY == XY1 - 9 orelse XY == XY1 - 10 orelse XY == XY1 - 11 ->
%% 			%%?DEBUG("-----------------ENTER---8:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop8(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         XY == XY2 - 1 orelse XY == XY2 - 11 orelse XY == XY2 + 9 orelse XY == XY2 + 10 orelse XY == XY2 + 11 ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop8(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%%         MoveBinData /= 3 andalso (XY == XY2 orelse XY == XY2 + 1 orelse XY == XY2 - 10 orelse XY == XY2 - 9) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop8(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop8(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% move_loop9([],_ , EnterUser, LeaveUser) -> [EnterUser, LeaveUser];
%% move_loop9([D | T], [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser) ->
%% %%     [Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Sids, Speed, EquipCurrent, Sex, Out_pet, Pid, Leader, Pid_team, Realm, Guild_name, Evil, Status,Carry_Mark,ConVoy_Npc,Stren,SuitID, Arena,Vip,MountStren,PeachRevel,CharmTitle] = D,
%%     [X, Y, Id, _Camp, _Stts, _Img, _Nick, _Spd, _Mnt, _MntStren, Sids, _Pid] = D, 
%% 	XY = get_xy(X, Y),
%%     if
%% 		XY == XY1 + 1 orelse XY == XY1 + 9 orelse XY == XY1 + 10 orelse XY == XY1 + 11 orelse XY == XY1 - 9 ->
%% 			%%?DEBUG("-----------------ENTER---9:~p~n",[Id]),
%% 			spawn(fun()->lib_send:send_to_sids(Sids, EnterBinData,?MOVE_SOCKET)end),
%% 			move_loop9(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         XY == XY2 - 1 orelse XY == XY2 - 9 orelse XY == XY2 - 10 orelse XY == XY2 - 11 orelse XY == XY2 + 9 ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, LeaveBinData,?MOVE_SOCKET)end),
%%             move_loop9(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, [Id | LeaveUser]);
%%         MoveBinData /= 0 andalso (XY == XY2 orelse XY == XY2 + 1 orelse XY == XY2 + 10 orelse XY == XY2 + 11) ->
%% 			spawn(fun()->lib_send:send_to_sids(Sids, MoveBinData,?MOVE_SOCKET)end),
%%             move_loop9(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser);
%%         true ->
%%             move_loop9(T, [XY1, XY2, MoveBinData, LeaveBinData, EnterBinData], EnterUser, LeaveUser)
%%     end.
%% 
%% 
%% %% 基础_所有场景初始化
%% init_base_scene() ->
%% 	L = ?DB_MODULE:select_all(base_scene, "sid", []),
%% 	Scene_id_list = lists:flatten(L),
%% 	lists:map(fun load_base_scene/1, Scene_id_list),
%% 	ok.
%% 
%% %% 基础_某一场景初始化
%% load_base_scene(SceneId) ->
%% 	L = ?DB_MODULE:select_row(base_scene, "*", [{sid, SceneId}], [], [1]),	
%%     if 
%%         L == [] ->
%%             ?ERROR_MSG("LOAD BASE SCENE DATA FAIL: ~w", [SceneId]);
%%         is_list(L) ->
%%             Scene = list_to_tuple([ets_scene | L]),
%%             NpcList = util:string_to_term(tool:to_list(Scene#ets_scene.npc)),
%% 			load_base_npc(NpcList, SceneId, 1),
%% %% 			lists:foreach(fun(X) -> load_base_npc(X, SceneId, 1) end, NpcList),
%%             NewScene = Scene#ets_scene{
%%                 id = SceneId,
%%                 npc = NpcList
%%             },
%%             ets:insert(?ETS_BASE_SCENE, NewScene);
%%         true ->
%%             ?ERROR_MSG("LOAD BASE SCENE DATA FAIL: ~w", [SceneId])
%%     end.
%% 
%% %% 加载基础_NPC 
%% load_base_npc([], _, _) -> ok;
%% %% load_base_npc([[NpcId, X, Y] | T], SceneId, Autoid) ->
%% load_base_npc([NpcId | T], SceneId, Autoid) ->
%%      case data_agent:npc_get(NpcId) of
%%         [] ->
%%             ok;
%%         N ->
%%             N1 = N#ets_npc{
%%                 id = Autoid,
%% %%                 x = X,
%% %%                 y = Y,
%%                 scn = SceneId, 
%% 				unique_key = {SceneId, Autoid}
%%             },
%%             ets:insert(?ETS_BASE_SCENE_NPC, N1)
%%     end,	
%%     load_base_npc(T, SceneId, Autoid+1).
%% 
%% %% 从地图的mask中构建ETS坐标表，表中存放的是可移动的坐标
%% %% load_mask(Mask,0,0)，参数1表示地图的mask列表，参数2和3为当前产生的X,Y坐标
%% load_base_mask([], _, _, _) ->  null;
%% load_base_mask([H|T], X, Y, SceneId) ->
%%     case H of
%%         10 -> % 等于\n
%%             load_base_mask(T, 0, Y+1, SceneId);
%%         13 -> % 等于\r
%%             load_base_mask(T, X, Y, SceneId);
%%         48 -> % 0
%%             load_base_mask(T, X+1, Y, SceneId);
%%         49 -> % 1
%%             ets:insert(?ETS_BASE_SCENE_POSES, {{SceneId, X, Y}}),
%%             load_base_mask(T, X+1, Y, SceneId);
%%         50 -> % 2
%%             load_base_mask(T, X+1, Y, SceneId);
%%         Other ->
%%             ?ERROR_MSG("Unknown element in scene_mask: ~p", [[Other, X, Y, SceneId]])
%%     end.
%% 

%% 
%% %% 本节点加载NPC
%% load_npc([], _) -> ok;
%% %% 临时去掉 X Y，并默认为 1 1
%% %% load_npc([[NpcId, X, Y] | T], SceneId) ->
%% %% 	mod_npc_create:create_npc([NpcId, SceneId, X, Y]),
%% load_npc([NpcId | T], SceneId) ->
%%     mod_npc_create:create_npc([NpcId, SceneId, 1, 1]),
%%     load_npc(T, SceneId).
%% 
%% %% 本节点加载mon
%% load_mon([], _) -> ok;
%% load_mon([[MonId, X, Y, _Type] | T], SceneId) ->
%% %% io:format("new_mon:/~p/ ~n", [[[MonId, SceneId, X, Y, 0, []]]]),
%%     mod_mon_create:create_mon([MonId, SceneId, X, Y, 0, []]),
%%     load_mon(T, SceneId).
%% %% 复制一个副本场景
%% copy_scene(UniqueId, SceneId) ->
%%     case data_agent:scene_get(SceneId) of
%%         [] ->
%%             ok;
%%         S ->
%%             load_npc(S#ets_scene.npc, UniqueId),
%%             ets:insert(?ETS_SCENE, S#ets_scene{id = UniqueId, npc=[]}),
%%             ok
%%     end.
%% 
%% %% 清除场景
%% clear_scene(SceneId) ->
%%     mod_mon_create:clear_scene_mon(SceneId),    %% 清除怪物 
%%     ets:match_delete(?ETS_SCENE_NPC, #ets_npc{scn=SceneId, _ = '_'}),%% 清除npc
%%     ets:delete(?ETS_SCENE, SceneId).         %% 清除场景
%% 
%% %% 更改玩家位置
%% %% Player 玩家信息
%% %% X 目的点X坐标
%% %% Y 目的点Y坐标
%% change_player_position(Player, X, Y, SX, SY) ->	
%% 	%% 走路
%% 	{ok, MoveBinData} = pt_12:write(12001, [X, Y, SX, SY, Player#player.id]),
%%     %% 移除
%%     {ok, LeaveBinData} = pt_12:write(12004, Player#player.id),
%%     %% 有玩家进入
%%     {ok, EnterBinData} = pt_12:write(12003, pt_12:trans_to_12003(Player)),	
%% 	mod_scene_agent:move_broadcast(Player#player.scn, Player#player.other#player_other.pid, 
%% 			X, Y, Player#player.x, Player#player.y,Player#player.id,Player#player.stts, MoveBinData, LeaveBinData, EnterBinData).
%% 
%% %% 更改联盟场景中玩家位置
%% %% Player 玩家信息
%% %% X 目的点X坐标
%% %% Y 目的点Y坐标
%% change_player_position_union(Player, X, Y, SX, SY) ->	
%% 	%% 走路
%% 	{ok, MoveBinData} = pt_12:write(12001, [X, Y, SX, SY, Player#player.id]),
%% 	mod_scene_agent:move_broadcast_union(Player#player.scn,Player#player.un, 
%% 			X, Y, Player#player.id,Player#player.stts, MoveBinData).
%% 
%% special_change_player_position(Player, X, Y) ->
%% 	%% 走路
%%     {ok, MoveBinData} =  pt_12:write(12110, [Player#player.id, X, Y]),
%%     %% 移除
%%     {ok, LeaveBinData} = pt_12:write(12004, Player#player.id),
%%     %% 有玩家进入
%%     {ok, EnterBinData} = pt_12:write(12003, pt_12:trans_to_12003(Player)),
%% 	mod_scene_agent:move_broadcast(Player#player.scn, Player#player.other#player_other.pid, 
%% 			X, Y, Player#player.x, Player#player.y,Player#player.id,Player#player.stts, MoveBinData, LeaveBinData, EnterBinData).
%% 
%% %%	ver_location(Sceneid, [X, Y], Type)
%% %% 所处位置判断
%% %% Type为判断类型 （safe 安全区判断 	exc 凝神修炼区判断）
%% 	
%% 
%% 
%% %% get_dungeon_times(Player_id, Dungeon_id) ->
%% %% 	case db_agent:get_log_dungeon(Player_id, Dungeon_id) of
%% %% 		[] -> 
%% %% 			0;
%% %% 		LogInfo -> 
%% %% 			Log_dungeon = list_to_tuple([log_dungeon] ++ LogInfo),
%% %% %% 			S = Log_dungeon#log_dungeon.first_dungeon_time rem 1000000,
%% %% %% 			M = util:floor(Log_dungeon#log_dungeon.first_dungeon_time / 1000000),
%% %% %% 			T1 = misc:date_format({M, S, 0}),
%% %% %% 			T2 = misc:date_format(now()),
%% %% %% 			if T1 =/= T2 ->0;
%% %% %% 				true->
%% %% %% 				Log_dungeon#log_dungeon.dungeon_counter
%% %% %% 			end
%% %% 			5 %%临时处理
%% %% 	end.
%% %% 
%% %% 
%% %% get_dungeon_times_list(_PlayerId,[],_MaxTimes,DungeonInfo)-> 
%% %% 	{ok,DungeonInfo};
%% %% get_dungeon_times_list(PlayerId,[DungeonId|DungeonList],MaxTimes,DungeonInfo)->
%% %% 	Times = get_dungeon_times(PlayerId, DungeonId),
%% %% 	Info = {DungeonId,Times,MaxTimes},
%% %% 	get_dungeon_times_list(PlayerId,DungeonList,MaxTimes,[Info|DungeonInfo]).
%% 
%% %% 判断上一个切换场景的位置
%% %% Player 玩家Record
%% %% SceneId 切换的场景
%% check_change_scene(Player, SceneId) ->
%% 	%% 临时处理，不处理外挂
%% 	true.
%% %% 	case lists:member(Player#player.scn, [101, 190, 191]) andalso lists:member(SceneId, [101, 190, 191]) of
%% %% 		false ->
%% %%             NewSceneId = 
%% %%                 case SceneId == 191 orelse SceneId == 190 of
%% %%                     true ->
%% %%                         101;
%% %%                     false ->
%% %%                         SceneId
%% %%                 end,
%% %%             case get_data(Player#player.scn) of
%% %%                 [] ->
%% %%                     true;
%% %%                 Scene ->
%% %% 					true
%% %% 					case abs(Player#player.x - X) + abs(Player#player.y - Y) > 10 of
%% %% 						true ->
%% %% 							%% 切换场景异常
%% %% 							Now = util:unixtime(),
%% %% 							spawn(fun()-> db_agent:insert_kick_off_log(Player#player.id, Player#player.nick, 9, Now, Player#player.scn, Player#player.x, Player#player.y, []) end),
%% %% 							mod_player:stop(Player#player.other#player_other.pid, 2),
%% %% 							false;
%% %% 						false ->
%% %% 							true
%% %% 					end
%% %%             end;
%% %% 		true ->
%% %% 			true
%% %% 	end.
%% 
%% %% 更新玩家的坐标信息
%% update_player_position(PlayerId, X, Y, Sta) ->
%% 	MS = ets:fun2ms(fun(P) when P#player.id == PlayerId -> P end),
%%    	case ets:select(?ETS_ONLINE_SCENE, MS) of
%%    		[] -> 
%% 			skip;
%%   		[Player | _] ->
%% 			NewPlayer = Player#player{
%% 				x = X,
%% 				y = Y,
%% 				stts = Sta						  
%% 			},
%% 			ets:insert(?ETS_ONLINE_SCENE, NewPlayer)
%%     end.
%% 
%% %%更新玩家场景信息
%% update_player_info_fields(PlayerId,ValueList) ->
%% 	Pattern = #player{id = PlayerId,_='_'},
%% 	Player = goods_util:get_ets_info(?ETS_ONLINE_SCENE,Pattern),
%% 	if
%% 		is_record(Player,player) ->
%% 			NewPlayer = lib_player_rw:set_player_info_fields(Player,ValueList),
%% 			ets:insert(?ETS_ONLINE_SCENE, NewPlayer);
%% 		true ->
%% 			skip
%% 	end.
%% 
%% 
%% %%从场景玩家中分离与指定玩家相同联盟的场景玩家, 供联盟场景中显示用
%% split_same_union_scene_user(UnName, SceneUser) ->
%% 	F = fun(User) ->
%% 				if User =/= [] ->
%% 					   Un = lists:nth(16,User),
%% 					   if UnName =:= Un ->		%%相同联盟名称
%% 							  true;
%% 						  true ->
%% 							  false
%% 					   end;
%% 				   true ->
%% 					   false
%% 				end
%% 		end,
%% 	lists:filter(F, SceneUser).
	
