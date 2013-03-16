%%%--------------------------------------
%%% @Module  : pp_scene
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description:  场景
%%%--------------------------------------
-module(pp_scene).
-include("common.hrl").
-include("record.hrl").
-compile(export_all).


%% 玩家进入场景
handle(12001, Status, [SceneId]) ->
	BaseScene = 
		if
			SceneId < 100 ->
				100 ;
			SceneId < 999 ->
				SceneId div 100 ;
			true ->
				SceneId
		end ,
	case mod_scene:enter_scene(BaseScene,Status) of 
		{ok,PidScene,SubSceneId,NewPlayer} ->
			PlayerOther = Status#player.other#player_other{pid_scene = PidScene} ,
			NewPlayer = Status#player{scene = SubSceneId,other=PlayerOther} ,
			
			%%1.0  场景代理广播有新玩家加入
			{ok, BinData} = pt_12:write(12003, pt_12:pack_player(NewPlayer)),
   			mod_scene_agent:send_to_screen(NewPlayer#player.scene, NewPlayer#player.x,NewPlayer#player.y,BinData,NewPlayer#player.id) ,
			
			%%2.0  返回数据给调用者
			{ok,BinData} = pt_12:write(12001, [NewPlayer]) ,
			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) ,
			{ok, change_ets_table, NewPlayer} ;
		_ ->
			ok
	end ;
	
%% 查询场景元素(玩家，NPC，怪物)
handle(12002, Status, []) ->
	DataList =  mod_scene:get_scene_elem(Status#player.other#player_other.pid_scene, Status#player.scene) ,
	{ok,BinData} = pt_12:write(12002, [DataList]) ,
	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) ,
	ok ;


%% 玩家离开场景
handle(12004, Status, []) ->
	{ok, BinData} = pt_12:write(12004, Status#player.id),
	mod_scene_agent:send_to_screen(Status#player.scene, Status#player.x, Status#player.y, BinData),
	mod_scene:leave_scene(Status#player.other#player_other.pid_scene,Status#player.id),
	ok ;


%% 玩家走路广播
handle(12010, Status, [DestX,DestY,WarkPathBin]) ->
	
	%%1.0  告诉同屏的玩家，某人要开始走路了
	{ok, BinData} = pt_12:write(12004, [Status#player.id,DestX,DestY,WarkPathBin]) ,
	mod_scene_agent:send_to_screen(Status#player.scene, Status#player.x, Status#player.y, BinData) ,
	
	OldX = Status#player.x,
	OldY = Status#player.y,
	
	%%2.0 查看目标和当前位置的关系
	if 
		OldX =:=  DestX andalso OldY =:= DestY ->
			NewStatus = Status#player{x = DestX, y = DestY } ;
		true ->
			NewStatus = Status
	end ,
	
	{ok,NewStatus};
	

%% 玩家位置同步(在需要同步的客户端请求古协议)
handle(12011, Status, [DestX,DestY]) ->
	OldX = Status#player.x,
	OldY = Status#player.y,
	
	%%1.0 查看目标和当前位置的关系
	if 
		OldX =:=  DestX andalso OldY =:= DestY ->
			NewStatus = Status#player{x = DestX, y = DestY } ;
		true ->
			NewStatus = Status
	end ,
	
	%%2.0 修改玩家的当前位置
	mod_scene:update_postion(Status#player.other#player_other.pid_scene,NewStatus,DestX,DestY) ,
	
	{ok,NewStatus};

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
