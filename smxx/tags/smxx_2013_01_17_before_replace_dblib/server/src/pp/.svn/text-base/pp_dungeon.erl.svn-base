%% Author: Administrator
%% Created: 2011-10-14
%% Description: TODO: Add description to pp_dungeon
-module(pp_dungeon).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
%%
%% Exported Functions
%%
-compile([export_all]).

%%
%% API Functions
%%

%%
%% TODO: Add description of handle/function_arity
%%

%% %% -----------------------------------------------------------------
%% %% 获取玩家场景副本数据
%% %% -----------------------------------------------------------------
%% handle(46001, Status, [ScreenId, Point]) ->
%%     DungeonList = lib_dungeon:get_dungeon_by_screenid(Status#player.id, ScreenId, Point),
%% 	
%% %% 	io:format("~s handle_46001 [~p/~p] \n ",[misc:time_format(now()), ScreenId, DungeonList]),
%%     {ok, BinData} = pt_46:write(46001, [DungeonList]),
%% 	%%io:format("~s handle_46001 1[~p] \n ",[misc:time_format(now()), BinData]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	
%% 	if
%% 		DungeonList =:= [] orelse DungeonList =:= undefined ->
%% 			ok;
%% %% 			io:format("~s handle_46001 [~p/~p/~p/~p] \n ",[misc:time_format(now()), Status, ScreenId,DungeonList,BinData]);
%% 		true ->
%% 			skip
%% 	end,		
%% 		
%%     ok;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 获取玩家指定副本数据
%% %% -----------------------------------------------------------------
%% handle(46003, Status, [ItemList]) ->
%%     DungeonList = lib_dungeon:get_dungeon_info(Status#player.id, ItemList),
%% %% 	io:format("~s handle_46003 [~p/~p] \n ",[misc:time_format(now()), ItemList, DungeonList]),
%%     {ok, BinData} = pt_46:write(46003, [DungeonList]),
%% 	%%io:format("~s handle_46001 1[~p] \n ",[misc:time_format(now()), BinData]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%%     ok;
%% 
%% %%进入指定副本点
%% handle(46004, Status, [Did]) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_46004]), 1),		%%包以1秒时间计, 减少发包影响
%% 	if 
%% 		Is_operate_ok =:= true ->
%% 			[Res, DungeonId, Sid, MonList] = lib_dungeon:enter_dungeon(Status, Did),
%% 			{ok, BinData} = pt_46:write(46004, [[Res, DungeonId, Sid, MonList]]),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 			if
%% 				Res =:= 1 ->
%% 					Status1 = Status#player{stts=2},						%%状态改为战斗中
%% 					mod_scene:update_player_position(Status1),				%%更新玩家的场景数据, 使之不会收到其他场景广播
%% 					{ok, Status1};
%% 				true ->
%% 					ok
%% 			end;
%% 		true ->
%% 			ok
%% 	end;
%% 
%% %%退出副本
%% handle(46005, Status, _) ->
%% 	[Res, OldS] = lib_dungeon:exit_dungeon(),
%% 	if
%% 		Res =:= 1 ->
%% 			Status1 = Status#player{stts=OldS},
%% 			mod_scene:update_player_position(Status1),						%%更新回玩家的进入副本前的状态
%% 			{ok, Status1};
%% 		true ->
%% 			ok
%% 	end;
%% 
%% handle(_Arg0, _Arg1, _Arg2) -> 
%% 	ok.
%% 
%% 
%% %%
%% %% Local Functions
%% %%
%% 
