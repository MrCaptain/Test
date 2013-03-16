%%%--------------------------------------
%%% @Module  : pp_scene
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description:  场景
%%%--------------------------------------
-module(pp_scene).
-include("common.hrl").
-include("log.hrl").
-include("record.hrl").
-compile(export_all).


%% 玩家进入场景
%% 1、进入新场景
%% 2、刷新进入
%% 3、断线重连
%% 4、进入副本不修改玩家结构上的scene
handle(12001, Status, [SceneId,PosX,PosY]) ->
	{NewSceneId,X,Y} = lib_scene:check_eneter(SceneId,Status,PosX,PosY) ,
	if
		NewSceneId > 0 ->
			case mod_scene:enter_scene(NewSceneId,Status,X,Y) of 
				{ok,NewPlayer} ->
					%%1.0  场景代理广播有新玩家加入
					{ok, EnterBin} = pt_12:write(12003, [NewPlayer]),
					mod_scene_agent:send_to_matrix(NewPlayer#player.scene, NewPlayer#player.battle_attr#battle_attr.x,NewPlayer#player.battle_attr#battle_attr.y,EnterBin,NewPlayer#player.id) ,
					
					%%2.0  返回数据给调用者
					{ok,DataBin} = pt_12:write(12001, [NewSceneId,X,Y]) ,
					lib_send:send_to_sid(NewPlayer#player.other#player_other.pid_send, DataBin) ,
					
					%%3.0 离开原来的场景
					case Status#player.scene =/= NewSceneId andalso Status#player.scene > 999 of
						true ->
							lib_scene:leave_scene(Status#player.id, Status#player.scene) ,
							{ok,LeaveBin} = pt_12:write(12004, [Status#player.id]) ,
							mod_scene_agent:send_to_matrix(Status#player.scene, Status#player.battle_attr#battle_attr.x, Status#player.battle_attr#battle_attr.y, LeaveBin) ;
						false ->
							skip
					end ,
					{ok, NewPlayer} ;
				_ ->
					ok
			end ;
		true ->
			%%2.0  返回数据给调用者
			{ok,BinData} = pt_12:write(12001, [0,0,0]) ,
			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) ,
			ok 
	end ;
	

%% %% 查询场景元素(玩家，NPC，怪物)
%% handle(12002, Status, []) ->
%% 	DataList =  mod_scene:get_scene_elem(Status#player.other#player_other.pid_scene, Status#player.scene) ,
%% 	{ok,BinData} = pt_12:write(12002, [DataList]) ,
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) ,
%% 	ok ;


%% 玩家离开场景
handle(12004, Status, []) ->
	{ok, BinData} = pt_12:write(12004, [Status#player.id]),
	mod_scene_agent:send_to_matrix(Status#player.scene, Status#player.battle_attr#battle_attr.x, Status#player.battle_attr#battle_attr.y, BinData,Status#player.id),
	mod_scene:leave_scene(Status#player.scene,Status#player.other#player_other.pid_scene,Status#player.id),
	ok ;


%% 玩家走路广播
handle(12010, Status, [DestX,DestY,WarkPathBin]) ->
	
	%%1.0  告诉同屏的玩家，某人要开始走路了
	{ok, BinData} = pt_12:write(12010, [Status#player.id,DestX,DestY,WarkPathBin]) ,
	mod_scene_agent:send_to_matrix(Status#player.scene, 
										Status#player.battle_attr#battle_attr.x, 
										Status#player.battle_attr#battle_attr.y, 
										BinData,Status#player.id) ,
	
	OldX = Status#player.battle_attr#battle_attr.x,
	OldY = Status#player.battle_attr#battle_attr.y,
	
	%%2.0 查看目标和当前位置的关系
	if 
		OldX =/=  DestX andalso OldY =/= DestY ->
			BattleAttr = Status#player.battle_attr#battle_attr{x = DestX, y = DestY } ,
			NewStatus = Status#player{battle_attr = BattleAttr } ;
		true ->
			NewStatus = Status
	end ,
	
	{ok,NewStatus};
	

%% 玩家位置同步(在需要同步的客户端请求协议)
handle(12011, Status, [DestX,DestY]) ->
	OldX = Status#player.battle_attr#battle_attr.x,
	OldY = Status#player.battle_attr#battle_attr.y,
	
	%%1.0 查看目标和当前位置的关系
	if 
		abs(OldX - DestX) + abs(OldY - DestY) > 2 ->   %% 位置差距6个格子以上，一同步
			%%2.0 修改玩家的当前位置
			mod_scene:update_postion(Status#player.other#player_other.pid_scene,Status,DestX,DestY) ,
			BattleAttr = Status#player.battle_attr#battle_attr{x = DestX, y = DestY } ,
			NewStatus = Status#player{battle_attr = BattleAttr } ,
			{ok,NewStatus};
		true ->
			ok
	end ;


%% 怪物掉落拾取
handle(12016, Status, [MonId, GoodsId,PosX,PosY]) ->
	[Code,GoodsList] = mod_scene:pick_drop(Status#player.other#player_other.pid_scene,MonId, GoodsId,PosX,PosY) ,
	{ok,DropBin} = pt_12:write(12016, [Code]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, DropBin) ,
	
	%% 拾取成功后要广播
	case Code of
		1 ->
			NewStatus = goods_util:send_goods_and_money(GoodsList, Status, ?LOG_GOODS_MON) ,
			%% 场景广播
			{ok,BroadBin} = pt_12:write(12023, [MonId,GoodsId,PosX,PosY]) ,
			mod_scene_agent:send_to_same_screen(Status#player.scene, PosX, PosY, BroadBin, "") ,
			
			{ok,NewStatus} ;
		_ ->
			ok
	end  ;


%% 玩家开始采集
handle(12017, Status, [TaskId,NpcId]) ->
	[Code] = 
		case  lib_task:check_collect_task(TaskId,NpcId,Status#player.id) of
			true ->
				case tpl_npc_layout:get(Status#player.scene div 100, NpcId) of
					NpcLayout when is_record(NpcLayout,temp_npc_layout) ->
						DistX = abs(NpcLayout#temp_npc_layout.x - Status#player.battle_attr#battle_attr.x ) ,
						DistY = abs(NpcLayout#temp_npc_layout.y - Status#player.battle_attr#battle_attr.y ) ,
						case DistX > 1 andalso DistY > 1 of
							false ->
								put(player_collect,{TaskId,NpcId,util:unixtime()}) ,
								[1] ;
							true ->
								[4] 
						end ;
					_ ->
						[3] 
				end ;
			false ->
				[2] 
		end ,
	{ok,CBin} = pt_12:write(12017, [Code]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, CBin) ,
	ok ;

%% 
%% %% 玩家中断采集
handle(12018, Status, []) ->
	erase(player_collect) ,
	{ok,CBin} = pt_12:write(12018, [1]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, CBin) ,
	ok ;
%% 
%% %% 玩家结束采集
handle(12019, Status, [TaskId,NpcId]) ->
	NowTime = util:unixtime() ,
	[Code] = 
		case  get(player_collect) of
			{BTaskId,BNpcId,BTime}  ->
				if
					TaskId =/= BTaskId orelse NpcId =/= BNpcId ->
						[2] ;
					NowTime - BTime < 2 ->
						[3] ;
					true ->
						lib_task:call_event(Status,item,{NpcId,1}) ,
						erase(player_collect) ,
						[1]
				end ;
			_ ->
				[2] 
		end ,
	
	{ok,CBin} = pt_12:write(12019, [Code]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, CBin) ,
	ok ;

%% 玩家原地复活
handle(12020, Status, []) ->
	GoodsTypeId = data_config:get_revive_googs() ,
	case goods_util:del_bag_goods(Status, GoodsTypeId, 1, 12020) of
		true ->
			NewStatus = lib_player:revive(Status, here),  %#player{hit_point = Status#player.hit_point_max} ,
			%% 同步玩家状态到场景
			{ok, BinData} = pt_12:write(12003, [NewStatus]),
			mod_scene_agent:send_to_matrix(NewStatus#player.scene, NewStatus#player.battle_attr#battle_attr.x,NewStatus#player.battle_attr#battle_attr.y,BinData,"") ,
	
			%% 发送复活结果给玩家
			{ok, DataBin} = pt_12:write(12020, [1]) ,
			lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
			{ok,NewStatus} ;
		_ ->
			{ok, DataBin} = pt_12:write(12020, [0]) ,
			lib_send:send_to_sid(Status#player.other#player_other.pid_send, DataBin) ,
			ok 
	end ;
	

	
	

%% 玩家回城复活
handle(12021, Status, [_SceneId]) ->
	NewStatus = lib_player:revive(Status, city),  %#player{hit_point = round(Status#player.hit_point_max * 0.2) } ,
	%% 1.0 获取复活场景
	case lib_scene:get_scene(NewStatus#player.scene) of
		Scene when is_record(Scene,temp_scene) ->
			case Scene#temp_scene.revive_sid > 0 of
				true ->
					{ok, DataBin} = pt_12:write(12021, [1,Scene#temp_scene.revive_sid,Scene#temp_scene.revive_x,Scene#temp_scene.revive_y]) ,
					lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, DataBin) ,
					{ok,NewStatus} ;
				false ->
					{ok, DataBin} = pt_12:write(12021, [2,Scene#temp_scene.revive_sid,Scene#temp_scene.revive_x,Scene#temp_scene.revive_y]) ,
					lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, DataBin) ,
					ok
			end ;
		_ ->
			{ok, DataBin} = pt_12:write(12021, [0,0,0,0]) ,
			lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, DataBin) ,
			ok 
	end  ;

    



%% 
%% %%切换场景
%% handle(12005, Status, SceneId) ->
%% 	case lib_dungeon:is_in_dungeon() of
%% 		1 ->		%%在进入副本中, 不处理场景
%% 			skip;
%% 		_ ->
%% 			%% 	DungeonSceneId = lib_scene:get_scene_id_from_scene_unique_id(Status#player.scn),
%% 			%% 	HookingScene = lists:member(SceneId,[]),
%% 			if SceneId =:= 200 orelse SceneId div 100 =:= 200 ->
%% 				   put(before_boss_scene,[Status#player.x,Status#player.y,Status#player.scn]);
%% 			   true ->
%% 				   ok
%% 			end,
%% 			
%% 			BaseSceneId =
%% 				if
%% 					SceneId < 1000 ->
%% 						SceneId;
%% 					true ->
%% 						SceneId div 100
%% 				end ,
%% 			
%% 			case lib_scene:check_enter(Status, SceneId) of
%% 				{false, _, _, _, Msg, _, _} ->
%% 					%% 					Process_id = self(),
%% 					%% 					spawn(erlang, garbage_collect, [Process_id]),
%% 					{ok, BinData} = pt_12:write(12005, [0, 0, 0, Msg, 0, 0, 0, 0]),
%% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
%% 				{true, NewSceneId, X, Y, Name, SceneResId, Dungeon_times, Dungeon_maxtimes, Status1} ->
%% 					if 
%% 						NewSceneId =:= 200 orelse NewSceneId div 100 =:= 200 ->		%%是从世界BOSS场景出来, 恢复到原场景坐标
%% 							handle(12004, Status, Status#player.scn),								%%告诉原来场景玩家你已经离开
%% 							
%% 							[MyX,MyY] = data_boss:get_default_post() ,
%% 							NewStatus = Status1#player{scn = NewSceneId, x = MyX, y = MyY},
%% 							%%此时的Status#player.x,Status#player.y，前端已经通过发36004时，恢复到进入之前的坐标了
%% 							{ok, BinData} = pt_12:write(12005, [NewSceneId, MyX,MyY, Name, SceneResId, Dungeon_times, Dungeon_maxtimes, 0]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 							put(change_scene_xy , [MyX,MyY]),
%% 							{ok, change_ets_table, NewStatus};
%% 						%% 如果是进入联盟战场景，则需要存当前的坐标
%% 						(NewSceneId >= 210 andalso  NewSceneId =< 240) orelse (NewSceneId div 100 >= 210 andalso  NewSceneId div 100 =< 240) ->
%% 							handle(12004, Status, Status#player.scn),								%%告诉原来场景玩家你已经离开
%% 							[MyX,MyY] = data_boss:get_default_post() ,
%% 							
%% 							NewStatus = Status1#player{scn = NewSceneId, x = MyX, y = MyY},
%% 							{ok, BinData} = pt_12:write(12005, [NewSceneId, MyX,MyY, Name, SceneResId, Dungeon_times, Dungeon_maxtimes, 0]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 							put(change_scene_xy , [MyX,MyY]),
%% 							{ok, change_ets_table, NewStatus};
%% 						
%% 						%% 进入联盟守护战场景，需要根据挑战者或者守护者改变坐标
%% 						NewSceneId =:= 600 orelse NewSceneId div 100 =:= 600->
%% 							handle(12004, Status, Status#player.scn),								%%告诉原来场景玩家你已经离开
%% 							[MyX,MyY] = mod_guild_guard_agent:get_default_xy(Status#player.unid,Status#player.x,Status#player.y) ,
%% 							NewStatus = Status1#player{scn = NewSceneId, x = MyX, y = MyY},
%% 							{ok, BinData} = pt_12:write(12005, [NewSceneId, MyX,MyY, Name, SceneResId, Dungeon_times, Dungeon_maxtimes, 0]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 							put(change_scene_xy , [MyX,MyY]),
%% 							{ok, change_ets_table, NewStatus};
%% 						
%% 						true ->
%% 							%% 					Process_id = self(),
%% 							%% 					spawn(erlang, garbage_collect, [Process_id]),
%% 							%%告诉原来场景玩家你已经离开
%% 							handle(12004, Status, Status#player.scn),
%% 							%%告诉客户端新场景情况
%% 							{ok, BinData} = pt_12:write(12005, [NewSceneId, X, Y, Name, SceneResId, Dungeon_times, Dungeon_maxtimes, 0]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 							Status2 = Status1#player{scn = NewSceneId, x = X, y = Y},
%% 							put(change_scene_xy , [X, Y]),
%% 							
%% 							%%加入打坐状态取消--bigen
%% 							{ok, Status3} =              
%% 								case Status2#player.stts of
%% 									6 ->
%% 										lib_player:cancelSitStatus(Status2);   %% 从打坐状态恢复正常状态
%% 									2 ->
%% 										{ok, Status2#player{stts = 0}};
%% 									_ ->
%% 										{ok, Status2}
%% 								end,
%% 							%%------------------end
%% 							%% 					io:format("12005_____1:__/~p ~n",[SceneId]),
%% 							%% 是否第一次进入场景
%% 							case data_player:is_first_enter(BaseSceneId, Status3#player.scst, Status3#player.scus) of
%% 								0 ->
%% 									{ok, change_ets_table, Status3};
%% 								Used ->
%% 									OldBaseSceneId =
%% 										if
%% 											Status#player.scn < 1000 ->
%% 												Status#player.scn;
%% 											true ->
%% 												Status#player.scn div 100
%% 										end,
%% 									case lists:member(OldBaseSceneId, [151,152,153,154,155,156,157,158,159,160,161,162,163,164]) of		%%从矿区进入其它场景不广播
%% 										false ->
%% 											lib_dungeon:check_load_scene_dungeon(BaseSceneId, Status3#player.scst),						%%加载场景副本点
%% 											OldScene = lib_scene:get_data(OldBaseSceneId),
%% 											Msg = io_lib:format("<font color='#fee400'><b>通告</b>   </font><a href='event:name_~p,~s'><font color='#ffd800'><u>~s</u></font></a>完成了<font color='#ffd800'>~s</font>的使命，飞往<font color='#ffd800'>~s</font>。",
%% 														[Status#player.id, Status#player.nick, Status#player.nick, OldScene#ets_scene.name, Name]),
%% 											spawn(fun() ->lib_chat:broadcast_sys_msg(1, Msg) end);
%% 										_ ->
%% 											skip
%% 									end,
%% 									%%io:format("~s is_first_enter [~p/~p/~p/~p] \n ",[misc:time_format(now()), SceneId, Used, Status2#player.scst, Status2#player.scus]),
%% 									Status4 = Status3#player{scus = Used bor Status3#player.scus},
%% 									{ok, BinData2} = pt_13:write(13030, [Status4#player.scst, Status4#player.scus]),
%% 									lib_send:send_to_sid(Status4#player.other#player_other.pid_send, BinData2),
%% 									spawn(fun()->db_agent:change_scene_state(Status4#player.scst, Status4#player.scus, Status4#player.id) end),
%% 									{ok, change_ets_table, Status4}
%% 							end
%% 					end
%% 			end
%% 	end;
%% 
%% 
%% %% %% 获取场景相邻关系数据
%% %% handle(12080, Status, []) ->
%% %% io:format("12080_____1:__/~p ~n",[xx]),
%% %% %% io:format("______mod_player/handle_12080__0000_____get_process_memory:~p~n",[process_info(self(),memory)]),
%% %%     BL = lib_scene:get_border(),
%% %% %% io:format("______mod_player/handle_12080__1111_____get_process_memory:~p~n",[process_info(self(),memory)]),
%% %%     {ok, BinData} = pt_12:write(12080, [BL]),
%% %%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 	Process_id = self(),
%% %% 	spawn(erlang, garbage_collect, [Process_id]),
%% %% %% io:format("______mod_player/handle_12080__2222_____get_process_memory:~p~n",[process_info(self(),memory)]),
%% %% 	ok;
%% 
%% %% %%获取副本次数列表
%% %% handle(12100,Status,[])->
%% %% 	DungeonList = data_agent:common_dungeon_get_id_list(),
%% %% 	{NewPlayerStatus,_,AwardTimes} = lib_vip:get_vip_award(dungeon,Status),
%% %% 	{ok,DTimesList} = lib_scene:get_dungeon_times_list(Status#player.id,DungeonList,15+AwardTimes,[]),
%% %% 	{NewPlayerStatus1,_,FstAwardTimes} = lib_vip:get_vip_award(fst,NewPlayerStatus),
%% %% 	{ok,FstTimesList} = lib_scene:get_dungeon_times_list(Status#player.id,[1001],3+FstAwardTimes,[]),
%% %% 	{ok,TdTimesList} = lib_scene:get_dungeon_times_list(Status#player.id,[998,999],1,[]),
%% %% %% 	io:format("TdTimesList~p~n",[TdTimesList]),
%% %% 	{ok,BinData} = pt_12:write(12100, DTimesList++FstTimesList++TdTimesList),
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 	if
%% %% 		NewPlayerStatus1 =:= Status ->
%% %% 			ok;
%% %% 		true ->
%% %% 			{ok,NewPlayerStatus1}
%% %% 	end;
%% 
handle(_Cmd, _Status, _Data) ->
	%%     ?DEBUG("pp_scene no match", []),
	{error, "pp_scene no match"}.
