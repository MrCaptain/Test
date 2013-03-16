%% Author: Administrator
%% Created: 2011-10-14
%% Description: TODO: Add description to db_agent_dungeon
-module(db_agent_dungeon).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
%%
%% Exported Functions
%%
-compile(export_all).

%%
%% API Functions
%%

%% %% 加载玩家所有的副本任务
%% select_player_all_dungeon(PlayerId) ->
%% 	?DB_MODULE:select_all(dungeon_log, 
%% 								 "*", 
%% 								 [{uid, PlayerId}]).
%% 
%% update_state(PlayerId, DungId, State) ->
%% 	?DB_MODULE:update(dungeon_log,
%% 					[{stat, State}],
%% 					[{uid, PlayerId}, {did, DungId}]
%% 				   ).
%% 
%% update_dungeon(PlayerId, DungInfo) ->
%% 	?DB_MODULE:update(dungeon_log,
%% 					[{stat, DungInfo#dungeon_log.stat},
%% 					 {lstm, DungInfo#dungeon_log.lstm},
%% 					 {use, DungInfo#dungeon_log.use},
%% 					 {grade, DungInfo#dungeon_log.grade}],
%% 					[{uid, PlayerId}, {did, DungInfo#dungeon_log.did}]
%% 				   ).
%% 	
%% 
%% insert_dungeon(PlayerId, BaseDung, Use, State, Timestamp) ->
%% 	%%Timestamp = util:unixtime(),
%% 	DungInfo = #dungeon_log{
%% 			   uid = PlayerId,
%% 			   did = BaseDung#ets_base_dungeon.id,
%% 			   sid = BaseDung#ets_base_dungeon.sid,
%% 			   type = BaseDung#ets_base_dungeon.type,
%% 			   stype = BaseDung#ets_base_dungeon.stype,
%% 			   num = BaseDung#ets_base_dungeon.num,
%% 			   use = Use, 
%% 			   stat = State,
%% 			   lstm = Timestamp			  
%% 			  },
%% 	
%%     ValueList = lists:nthtail(2, tuple_to_list(DungInfo)),
%%     [id | FieldList] = record_info(fields, dungeon_log),
%% 	Ret = ?DB_MODULE:insert(dungeon_log, FieldList, ValueList),
%% 	NewDungInfo = DungInfo#dungeon_log{id = Ret},
%% 	NewDungInfo.
%% %% 	?DB_MODULE:select_row(dungeon_log,
%% %% 								 "*",
%% %% 								 [{id,Ret}],								
%% %% 								 [1]
%% %% 								).
%% 
%% select_dungeon(PlayerId, DungeonId) ->
%% 	?DB_MODULE:select_row(dungeon_log,
%% 								 "*",
%% 								 [{uid,PlayerId}, {did, DungeonId}],								
%% 								 [1]
%% 								).
%% 
%% is_dungeon_log_info(PlayerId, TaskId) ->
%% 	Data = ?DB_MODULE:select_row(dungeon_log, 
%% 						  "*",
%% 						  [{uid, PlayerId}, {tid, TaskId}], [], [1]),
%% 	
%% 	case Data of
%% 		[] -> false;
%% 		_ -> true
%% 	end.
%% 
%% 
%% %% 删除副本
%% delete_dungeon(PlayerId, Dungid) ->
%%     ?DB_MODULE:delete(dungeon_log, [{uid, PlayerId}, {did, Dungid}]).
%% 	
%% 	
%% %%
%% %% Local Functions
%% %%
%% 
%% %% 加载玩家所有的副本任务
%% select_player_dungeon(PlayerId) ->
%% 	?DB_MODULE:select_row(dungeon,
%% 						  "*",
%% 						  [{uid, PlayerId}],
%% 						  [1]).
%% 
%% 
%% insert_player_dungeon(PlayerId, DungeonInfo) ->
%% 	%%Timestamp = util:unixtime(),
%% 	DungInfo = #dungeon{uid = PlayerId, 
%% 						s1 = util:term_to_string(DungeonInfo#dungeon.s1), 
%% 						s2 = util:term_to_string(DungeonInfo#dungeon.s2),
%% 						s3 = util:term_to_string(DungeonInfo#dungeon.s3), 
%% 						s4 = util:term_to_string(DungeonInfo#dungeon.s4),
%% 						s5 = util:term_to_string(DungeonInfo#dungeon.s5), 
%% 						s6 = util:term_to_string(DungeonInfo#dungeon.s6),
%% 						s7 = util:term_to_string(DungeonInfo#dungeon.s7), 
%% 						s8 = util:term_to_string(DungeonInfo#dungeon.s8),
%% 						s9 = util:term_to_string(DungeonInfo#dungeon.s9),
%% 						s10 = util:term_to_string(DungeonInfo#dungeon.s10)},
%% 
%% 	
%%     ValueList = lists:nthtail(2, tuple_to_list(DungInfo)),
%%     [id | FieldList] = record_info(fields, dungeon),
%% 	Ret = ?DB_MODULE:insert(dungeon, FieldList, ValueList),
%% 	NewDungInfo = DungeonInfo#dungeon{id = Ret},
%% 	NewDungInfo.
%% 
%% update_player_dungeon(DungInfo) ->
%% 	?DB_MODULE:update(dungeon,
%% 					[{s1, util:term_to_string(DungInfo#dungeon.s1)},
%% 					 {s2, util:term_to_string(DungInfo#dungeon.s2)},
%% 					 {s3, util:term_to_string(DungInfo#dungeon.s3)},
%% 					 {s4, util:term_to_string(DungInfo#dungeon.s4)},
%% 					 {s5, util:term_to_string(DungInfo#dungeon.s5)},
%% 					 {s6, util:term_to_string(DungInfo#dungeon.s6)},
%% 					 {s7, util:term_to_string(DungInfo#dungeon.s7)},
%% 					 {s8, util:term_to_string(DungInfo#dungeon.s8)},
%% 					 {s9, util:term_to_string(DungInfo#dungeon.s9)},
%% 					 {s10, util:term_to_string(DungInfo#dungeon.s10)}],
%% 					[{id, DungInfo#dungeon.id}]
%% 				   ).
%% 
%% update_player_dungeon(Sid, DungInfo) ->
%% 	case Sid of
%% 		101 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s1, util:term_to_string(DungInfo#dungeon.s1)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		102 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s2, util:term_to_string(DungInfo#dungeon.s2)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		103 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s3, util:term_to_string(DungInfo#dungeon.s3)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		104 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s4, util:term_to_string(DungInfo#dungeon.s4)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		105 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s5, util:term_to_string(DungInfo#dungeon.s5)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		106 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s6, util:term_to_string(DungInfo#dungeon.s6)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		107 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s7, util:term_to_string(DungInfo#dungeon.s7)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		108 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s8, util:term_to_string(DungInfo#dungeon.s8)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		109 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s9, util:term_to_string(DungInfo#dungeon.s9)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		110 ->
%% 			?DB_MODULE:update(dungeon,
%% 							  [{s10, util:term_to_string(DungInfo#dungeon.s10)}],
%% 							  [{id, DungInfo#dungeon.id}]
%% 							 );
%% 		_ ->
%% 			update_player_dungeon(DungInfo)
%% 	end.
%% 
%% 	
%% 
