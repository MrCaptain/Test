%% Author: kexp
%% Created: 2011-10-14
%% Description: TODO: Add description to lib_dungeon
-module(lib_dungeon).

-compile(export_all).

-include("common.hrl").
-include("record.hrl").

%%
%% API Functions
%%

%% %%初始化基础副本表
%% init_base_dungeon() ->
%% 	ets:delete_all_objects(?ETS_BASE_DUNGEON),
%% 	 F = fun(Dungeon) ->
%% 			DungInfo = list_to_tuple([ets_base_dungeon] ++ Dungeon),	
%% 			
%% 			NewInfo = DungInfo#ets_base_dungeon{next = util:string_to_term(binary_to_list(DungInfo#ets_base_dungeon.next)),
%% 												mon = util:string_to_term(binary_to_list(DungInfo#ets_base_dungeon.mon))},
%%             ets:insert(?ETS_BASE_DUNGEON, NewInfo)
%%            end,
%% 	 
%% 	L = ?DB_MODULE:select_all(base_dungeon, "*", [], [], []),
%% 	lists:foreach(F, L),
%%     ok.
%% 
%% %%查询基础副本
%% get_base_dungeon(DungId) ->
%% 	lookup_one(?ETS_BASE_DUNGEON, DungId).
%% 
%% %% 登录后加载玩家副本
%% role_login(PlayerStatus) ->
%% 	get_player_all_dungeon(PlayerStatus#player.id),
%% 	check_load_all_dungeon(PlayerStatus#player.scst).			%%根据开通场景状态检查加载的副本
%% 
%% %% 第一次初始化玩家副本数据
%% init_player_dungeon(PlayerId) ->
%% %% 	BaseDungList = ets:tab2list(?ETS_BASE_DUNGEON),			%%全要查询
%% 	BaseDungList = match_all(?ETS_BASE_DUNGEON, #ets_base_dungeon{sid= 101, _='_'}),
%% 	DungInfo = #dungeon{id = 0, uid = PlayerId,
%% 						s1 = [], s2 = [],
%% 						s3 = [], s4 = [],
%% 						s5 = [], s6 = [],
%% 						s7 = [], s8 = [],
%% 						s9 = [], s10 = []},
%% 	%% 副本信息
%% 	put(player_dungeon_info, DungInfo),
%% 	case BaseDungList of
%% 		[] ->
%% 			NewDungeonList = [];
%% 		_ ->
%% 			Grade = 0,
%% 			F = fun(BaseDung)->
%% 						Did = BaseDung#ets_base_dungeon.id,
%% 						Sid = BaseDung#ets_base_dungeon.sid,
%% 						if
%% 							BaseDung#ets_base_dungeon.pre =:= 0 orelse BaseDung#ets_base_dungeon.task =:= 0 ->		%%前驱副本点为0的要状态为可通关
%% 								Stat = 2;								%%0 不能通关，1 已经通关, 2 可以通关, 3 通关次数用完
%% 							true ->
%% 								Stat = 0
%% 						end,
%% 						Data = [Sid, Did, Stat, 0, Grade],
%% 						insert_dungeon_info(Sid, Did, Data),	%%直接在副本信息中加
%% 						Data								   
%% 				end,
%% 			NewDungeonList = lists:map(F, BaseDungList),
%% 			NewDungeonList
%% 	end,
%% 	put(dungeon_list, NewDungeonList),		%%更新副本列表
%% 	DungeonInfo = get(player_dungeon_info),	
%% 	NewDungeonInfo = db_agent_dungeon:insert_player_dungeon(PlayerId, DungeonInfo),	
%% 	put(player_dungeon_info, NewDungeonInfo),	%%更新副本信息
%% 	NewDungeonList.
%% 
%% 
%% %% 获取玩家所有副本信息 
%% get_player_all_dungeon(PlayerId) ->
%% 	DungeonList = get(dungeon_list),	
%% 	if 
%% 		DungeonList =:= undefined ->
%% 			case db_agent_dungeon:select_player_dungeon(PlayerId) of
%% 				[] ->
%% 					NewDungeonList1 = init_player_dungeon(PlayerId),		%%新建初始化玩家副本数据
%% 					NewDungeonList1;				
%% 				Result ->
%% 					List = [dungeon | Result],
%% 					DungData = list_to_tuple(List),
%% 					NewDungData = DungData#dungeon{s1 = util:string_to_term(binary_to_list(DungData#dungeon.s1)),
%% 												   s2 = util:string_to_term(binary_to_list(DungData#dungeon.s2)),
%% 												   s3 = util:string_to_term(binary_to_list(DungData#dungeon.s3)),
%% 												   s4 = util:string_to_term(binary_to_list(DungData#dungeon.s4)),
%% 												   s5 = util:string_to_term(binary_to_list(DungData#dungeon.s5)),
%% 												   s6 = util:string_to_term(binary_to_list(DungData#dungeon.s6)),
%% 												   s7 = util:string_to_term(binary_to_list(DungData#dungeon.s7)),
%% 												   s8 = util:string_to_term(binary_to_list(DungData#dungeon.s8)),
%% 												   s9 = util:string_to_term(binary_to_list(DungData#dungeon.s9)),
%% 												   s10 = util:string_to_term(binary_to_list(DungData#dungeon.s10))},
%% 					put(player_dungeon_info, NewDungData),
%% %% 					NewDungeonList1 = NewDungData#dungeon.s1 ++ NewDungData#dungeon.s2 ++ NewDungData#dungeon.s3 ++ NewDungData#dungeon.s4 ++
%% %% 						  NewDungData#dungeon.s5 ++ NewDungData#dungeon.s6 ++ NewDungData#dungeon.s7 ++ NewDungData#dungeon.s8 ++ 
%% %% 						  NewDungData#dungeon.s9 ++ NewDungData#dungeon.s10,
%% 					F = fun(D, Acc) ->
%% 								[D|Acc]
%% 						end,
%% 					DList2 = lists:foldl(F, NewDungData#dungeon.s1, NewDungData#dungeon.s2),
%% 					DList3 = lists:foldl(F, DList2, NewDungData#dungeon.s3),
%% 					DList4 = lists:foldl(F, DList3, NewDungData#dungeon.s4),
%% 					DList5 = lists:foldl(F, DList4, NewDungData#dungeon.s5),
%% 					DList6 = lists:foldl(F, DList5, NewDungData#dungeon.s6),
%% 					DList7 = lists:foldl(F, DList6, NewDungData#dungeon.s7),
%% 					DList8 = lists:foldl(F, DList7, NewDungData#dungeon.s8),
%% 					DList9 = lists:foldl(F, DList8, NewDungData#dungeon.s9),
%% 					DList10 = lists:foldl(F, DList9, NewDungData#dungeon.s10),
%% 					put(dungeon_list, DList10),
%% 					DList10
%% 			end;
%% 		true ->
%% 			DungeonList
%% 	end.
%% 
%% %%检查是否加载指定场景的副本点，玩家进程调用
%% check_load_scene_dungeon(TheSceneId, SceneSt)->
%% 	SceneList = [{101, 1}, {102, 2}, {103, 4},{104, 8}, {105, 16}, {106, 32}, {107, 64},{108, 128},{109, 256}],
%% 	OpenSceneList = [SceneId||{SceneId, Op}<-SceneList, Op band SceneSt =/= 0, SceneId =:= TheSceneId],	%%检查是否开通此场景
%% 	if
%% 		OpenSceneList =/= [] ->
%% 			BaseDungList = match_all(?ETS_BASE_DUNGEON, #ets_base_dungeon{sid= TheSceneId, _='_'}),		%%此场景的所有副本点
%% 			case BaseDungList of
%% 				[] ->
%% 					AddNew = 0;
%% 				_ ->
%% 					AddNew = check_add_dungeon_list(BaseDungList, 0)	%%检查增加副本点列表
%% 			end;
%% 		true ->
%% 			AddNew = 0
%% 	end,
%% 	if
%% 		AddNew =:= 1 ->												%%有新加
%% 			DungeonInfo = get(player_dungeon_info),
%% 			db_agent_dungeon:update_player_dungeon(DungeonInfo);	%%保存副本数据
%% 		true ->
%% 			skip
%% 	end.
%% 
%% %%根据开通场景状态检查加载的副本点，玩家进程调用
%% check_load_all_dungeon(SceneSt)->
%% 	SceneList = [{101, 1}, {102, 2}, {103, 4},{104, 8}, {105, 16}, {106, 32}, {107, 64},{108, 128},{109, 256}],
%% 	OpenSceneList = [SceneId||{SceneId, Op}<-SceneList, Op band SceneSt =/= 0],		%%开通的场景列表
%% 	F = fun(SceneId, Add) ->
%% 				BaseDungList = match_all(?ETS_BASE_DUNGEON, #ets_base_dungeon{sid= SceneId, _='_'}),	%%此场景对应的所有副本点
%% 				case BaseDungList of
%% 					[] ->
%% 						Add;
%% 					_ ->
%% 						check_add_dungeon_list(BaseDungList, Add)	%%检查增加副本点列表
%% 				end
%% 		end,
%% 	AddNew = lists:foldl(F, 0, OpenSceneList),
%% 	if
%% 		AddNew =:= 1 ->												%%有新加
%% 			DungeonInfo = get(player_dungeon_info),
%% 			db_agent_dungeon:update_player_dungeon(DungeonInfo);	%%保存副本数据
%% 		true ->
%% 			skip
%% 	end.
%% 
%% %%检查增加副本点列表，玩家进程调用
%% check_add_dungeon_list(BaseDungList, InitAdd) ->
%% 	Grade = 0,
%% 	F = fun(BaseDung, Add)->
%% 				Did = BaseDung#ets_base_dungeon.id,
%% 				case get_dungeon_by_dungid(Did) of						
%% 					[] ->												%%在现有副本列表中没有
%% 						Sid = BaseDung#ets_base_dungeon.sid,
%% 						if
%% 							BaseDung#ets_base_dungeon.pre =:= 0 orelse BaseDung#ets_base_dungeon.task =:= 0 ->		%%前驱副本点为0的要状态为可通关
%% 								Stat = 2;								%%0 不能通关，1 已经通关, 2 可以通关, 3 通关次数用完
%% 							true ->
%% 								Stat = 0
%% 						end,
%% 						Data = [Sid, Did, Stat, 0, Grade],
%% 						insert_dungeon(Data),							%%新加副本点数据（包括在副本列表与副本信息中）
%% 						1;
%% 					_ ->
%% 						Add
%% 				end
%% 		end,
%% 	lists:foldl(F, InitAdd, BaseDungList).
%% 						
%% 
%% %% 获取指定场景的副本数据
%% get_dungeon_by_screenid(PlayerId, ScreenId, Point) ->
%% 	DungeonList = get_player_all_dungeon(PlayerId),	
%% 	NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungeonList, Sid1 =:= ScreenId],
%% 	if
%% 		Point =:= 0 ->		%%0的时候, 是该场景所有副本点
%% 			add_param_to_dungeon_list(NewDungList);
%% 		true ->				%%指定了传送点的副本
%% 			add_param_to_dungeon_list1(NewDungList, Point)
%% 	end.
%% 
%% %%给副本列表数据补齐参数
%% add_param_to_dungeon_list1(DungList, Point) ->	%%这个是指定了传送点的副本
%% 	case DungList of
%% 		[] ->
%% 			[];
%% 		_ ->
%% 			F = fun(D) ->
%% 						case D of
%% 							[Sid, Did, Stat, _Lstm, Grade] ->
%% 								case get_base_dungeon(Did) of
%% 									[] ->
%% 										[];
%% 									BaseDungeon ->
%% 										if
%% 											BaseDungeon#ets_base_dungeon.type =:= Point ->
%% 												[Did, Sid, BaseDungeon#ets_base_dungeon.type, BaseDungeon#ets_base_dungeon.num, 0, Stat, Grade, BaseDungeon#ets_base_dungeon.lv];
%% 											true ->
%% 												[]
%% 										end
%% 								end;
%% 							_ ->
%% 								[]
%% 						end
%% 				end,
%% 			NewDungList1 = lists:map(F, DungList),
%% 			NewDungList2 = [Dungeon||Dungeon<-NewDungList1, Dungeon =/= []],
%% 			lists:sort(NewDungList2)
%% 	end.
%% 
%% %%给副本列表数据补齐参数
%% add_param_to_dungeon_list(DungList) ->
%% 	case DungList of
%% 		[] ->
%% 			[];
%% 		_ ->
%% 			F = fun(D) ->
%% 						case D of
%% 							[Sid, Did, Stat, _Lstm, Grade] ->
%% 								case get_base_dungeon(Did) of
%% 									[] ->
%% 										[];
%% 									BaseDungeon ->
%% 										[Did, Sid, BaseDungeon#ets_base_dungeon.type, BaseDungeon#ets_base_dungeon.num, 0, Stat, Grade, BaseDungeon#ets_base_dungeon.lv]
%% 								end;
%% 							_ ->
%% 								[]
%% 						end
%% 				end,
%% 			NewDungList1 = lists:map(F, DungList),
%% 			NewDungList2 = [Dungeon||Dungeon<-NewDungList1, Dungeon =/= []],
%% 			lists:sort(NewDungList2)
%% 	end.
%% 			
%% 
%% %% 获取指定的副本数据
%% get_dungeon_by_dungid(DungId) ->
%% 	DungeonList = get(dungeon_list),
%% 	NewDungList = [[Sid, Did | T]|| [Sid, Did | T] <- DungeonList, Did =:= DungId],
%% 	case NewDungList of
%% 		[] -> [];
%% 		[Fisrt | _] -> Fisrt
%% 	end.
%% 
%% %%指定副本是否通关
%% get_dungeon_info(PlayerId, ItemList) ->
%% 	get_player_all_dungeon(PlayerId),
%% 	F = fun(DungId) ->
%% 				DungeonInfo = get_dungeon_by_dungid(DungId),
%% 				case DungeonInfo of
%% 					[] ->
%% 						{DungId, 0};
%% 					[_Sid, _Did, Stat, _Lstm, _Grade] ->
%% 						if
%% 							Stat =:= 1 ->
%% 								{DungId,1};
%% 							true ->
%% 								{DungId, 0}
%% 						end;
%% 					_ ->
%% 						{DungId, 0}
%% 				end
%% 		end,
%% 	lists:map(F, ItemList).	
%% 
%% 
%% %% 通关指定的副本任务
%% finish_dungeon(Status, DungId, NewGrade)->	
%% 	lib_task:event(finish_dungeon, [1], Status),
%% 	DungInfo = get_dungeon_by_dungid(DungId),
%% 	case DungInfo of
%% 		[Sid, Did, Stat, Lstm, Grade] ->
%% 			if
%% 				Stat =:= 1 ->			%%是已经通关的 			
%% 					if 
%% 						NewGrade > Grade ->			%%分数更高的用高分的
%% 							FinishDung = [Sid, Did, Stat, Lstm, NewGrade],
%% 							update_dungeon(FinishDung);		%%更新副本点列表
%% 						true ->
%% 							FinishDung = DungInfo
%% 					end;
%% 				true ->					%%是之前未通关的
%% 					Timestamp = util:unixtime(),
%% 					FinishDung = [Sid, Did, 1, Timestamp, NewGrade],
%% 					update_dungeon(FinishDung),	
%% 					%% 副本奖励排行榜
%% 					FinishNum = get_finish_dungeon_num(),							
%% 					if
%% 						FinishNum >= 60 -> 
%% 							mod_rank:player_dungeon_rank(Status#player.id, Status#player.nick, FinishNum, Status#player.rgt);
%% 						true ->
%% 							skip
%% 					end
%% 			end,
%% 			NextDungIdList = check_next_dungeon(Status, DungId),
%% 			NextDungList2 = [FinishDung | NextDungIdList],
%% 			NextDungList3 = add_param_to_dungeon_list(NextDungList2),
%% %% 			io:format("DungId:~p, FinishDung:~p, NextDungIdList:~p, NextDungList3:~p~n", [DungId, FinishDung, NextDungIdList, NextDungList3]),
%% 			%% 通知客户端更新副本任务
%% 			{ok, BinData} = pt_46:write(46002, [NextDungList3]),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 			if 
%% 				FinishDung =/= DungInfo orelse NextDungIdList =/= [] ->
%% 					DungeonInfo = get(player_dungeon_info),
%% 					if
%% 						NextDungIdList =:= [] ->	%%只更新指定的副本点
%% 							db_agent_dungeon:update_player_dungeon(Sid, DungeonInfo);
%% 						true ->
%% 							db_agent_dungeon:update_player_dungeon(DungeonInfo)
%% 					end;
%% 				true ->
%% 					ok
%% 			end;
%% 		_ ->
%% 			ok
%% 	end.
%% 
%% %%下面可开启的副本点
%% check_next_dungeon(Status, DungId) ->
%% 	BaseDung = get_base_dungeon(DungId),				%%当前副本的基础数据
%% 	NextDungIdList = BaseDung#ets_base_dungeon.next,	%%它的下面副本ID列表
%% 	F = fun(NextDungId) ->
%% 				BaseNextDung = get_base_dungeon(NextDungId),
%% 				case get_dungeon_by_dungid(NextDungId) of
%% 					[] ->					%%副本点列表数据中没有
%% 						if
%% 							BaseNextDung =:= [] ->		%%没有这个配置的基础副本, 跳过
%% 								[];
%% 							true ->						%%原来没加入此副本点,要新加
%% 								%% 判断是否能打开副本点
%% 								if
%% %% 									Status#player.lv < BaseNextDung#ets_base_dungeon.lv ->	%%等级不够
%% %% 										Stat = 0;
%% 									BaseNextDung#ets_base_dungeon.task =:= 0 ->				%% 没有任务限制
%% 										Stat = 2;		%%可通关
%% 									true -> %% 有指定承接任务，先判断任务是否已接
%% 										case lib_task:get_one_trigger(BaseNextDung#ets_base_dungeon.task, Status) of
%% 											false -> 
%% 												%% 是否已经完成
%% 												case lib_task:in_finish(BaseNextDung#ets_base_dungeon.task, Status) of
%% 													true -> 	%%任务已经完成
%% 														Stat = 2;
%% 													_ -> 
%% 														Stat = 0
%% 												end;
%% 											_ ->	%%有在接的任务
%% 												Stat = 2
%% 										end
%% 								end,
%% 								Did = BaseNextDung#ets_base_dungeon.id,
%% 								Sid = BaseNextDung#ets_base_dungeon.sid,
%% 								Grade = 0,
%% 								Data = [Sid, Did, Stat, 0, Grade],
%% 								insert_dungeon(Data),			%%往副本数据中加入此副本点
%% 								Data
%% 						end;
%% 					[Sid, Did, OldStat, Lstm, Grade] ->	%%副本点列表中已经有此副本点
%% 						if
%% 							BaseNextDung =:= [] ->		%%没有这个配置的基础副本
%% 								delete_dungeon([Sid, Did, OldStat, Lstm, Grade]),	%%从副本点列表中删除
%% 								[];
%% 							true ->
%% 								%% 判断是否能打开副本点
%% 								if
%% 									OldStat =:= 1 ->	%%原先已经通关的
%% 										Stat = 1;
%% %% 									Status#player.lv < BaseNextDung#ets_base_dungeon.lv ->	%%等级不够
%% %% 										Stat = 0;
%% 									BaseNextDung#ets_base_dungeon.task =:= 0 ->				%% 没有任务限制
%% 										Stat = 2;		%%可通关
%% 									true -> 			%% 有指定承接任务，先判断任务是否已接
%% 										case lib_task:get_one_trigger(BaseNextDung#ets_base_dungeon.task, Status) of
%% 											false -> 
%% 														%% 是否已经完成
%% 												case lib_task:in_finish(BaseNextDung#ets_base_dungeon.task, Status) of
%% 													true -> 	%%任务已经完成
%% 														Stat = 2;
%% 													_ -> 
%% 														Stat = 0
%% 												end;
%% 											_ ->				%%有在接的任务
%% 												Stat = 2
%% 										end
%% 								end,
%% 								if
%% 									Stat =/= OldStat ->			%%状态变, 需要更新
%% 										Data = [Sid, Did, Stat, Lstm, Grade],
%% 										update_dungeon(Data),	%%往副本数据中加入此副本点
%% 										Data;
%% 									true ->
%% 										[]
%% 								end
%% 						end;
%% 					_ ->
%% 						[]
%% 				end
%% 		end,
%% 	NextDungList = lists:map(F, NextDungIdList),
%% 	[DunInfo1 || DunInfo1 <- NextDungList, DunInfo1 =/= []].
%% 
%% 
%% %% 接受任务开放副本点
%% trigger_task(Status, TaskId) ->
%% 	BaseDung = 
%% 		case TaskId of
%% 			0 -> 
%% 				[];
%% 			_ ->
%% 				case match_one(?ETS_BASE_DUNGEON, #ets_base_dungeon{task=TaskId, _='_'}) of
%% 					[] ->
%% 						[];
%% 					BaseDung0 ->
%% 						BaseDung0
%% 				end
%% 		end,
%% 	if
%% 		BaseDung =/= [] ->
%% 			Timestamp = util:unixtime(),
%% 			case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.id) of		
%% 				[] ->			%%要新加
%% 					%% 判断是否能打开副本点
%% 					if
%% 						BaseDung#ets_base_dungeon.pre =:= 0 -> 				%%前驱副本点为0的, 可通关
%% 							Stat = 2;
%% %% 						Status#player.lv < BaseDung#ets_base_dungeon.lv ->	%%等级不够
%% %% 							Stat = 0;
%% 						true ->
%% 							case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.pre) of		%%找前驱副本的数据
%% 								[] -> 						%%若它没有前驱副本, 它自己要开启
%% 									Stat = 2;
%% 								[_, _, PreStat| _T] ->
%% 									if 
%% 										PreStat =:= 1 -> 	%% 前驱副本已经通过
%% 											Stat = 2;		
%% 										true -> 
%% 											Stat = 0
%% 									end;
%% 								_ ->
%% 									Stat = 2
%% 							end
%% 					end,
%% 					Timestamp = util:unixtime(),
%% 					Did = BaseDung#ets_base_dungeon.id,
%% 					Sid = BaseDung#ets_base_dungeon.sid,
%% 					Grade = 0,
%% 					Data = [Sid, Did, Stat, 0, Grade],
%% 					insert_dungeon(Data),			%%往副本数据中加入此副本点
%% 					NextDungList = [Data],
%% 					NextDungList1 = add_param_to_dungeon_list(NextDungList),
%% 					%% 通知客户端更新副本任务
%% 					{ok, BinData} = pt_46:write(46002, [NextDungList1]),
%% %%  					io:format("TaskId:~p, NextDungList:~p, NextDungList1:~p~n", [TaskId, NextDungList, NextDungList1]),
%% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 					DungeonInfo = get(player_dungeon_info),
%% 					db_agent_dungeon:update_player_dungeon(Sid, DungeonInfo);
%% 				[Sid, Did, OldStat, Lstm, Grade] ->
%% 					if
%% 						OldStat =:= 0 ->
%% 							if
%% 								BaseDung#ets_base_dungeon.pre =:= 0 -> 				%%前驱副本点为0的, 可通关
%% 									Stat = 2;
%% %% 								Status#player.lv < BaseDung#ets_base_dungeon.lv ->	%%等级不够
%% %% 									Stat = 0;
%% 								true ->
%% 									case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.pre) of		%%找前驱副本的数据
%% 										[] -> 						%%若它没有前驱副本, 它自己要开启
%% 											Stat = 2;
%% 										[_, _, PreStat| _T] ->
%% 											if 
%% 												PreStat =:= 1 -> 	%% 前驱副本已经通过
%% 													Stat = 2;		
%% 												true -> 
%% 													Stat = 0
%% 											end;
%% 										_ ->
%% 											Stat = 2
%% 									end
%% 							end,
%% 							Data = [Sid, Did, Stat, Lstm, Grade],
%% 							update_dungeon(Data),
%% 							NextDungList = [Data],
%% 							NextDungList1 = add_param_to_dungeon_list(NextDungList),
%% 							%% 通知客户端更新副本任务
%% 							{ok, BinData} = pt_46:write(46002, [NextDungList1]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 							DungeonInfo = get(player_dungeon_info),
%% 							db_agent_dungeon:update_player_dungeon(Sid, DungeonInfo);
%% 						true ->
%% 							ok
%% 					end;
%% 				_ ->
%% 					ok
%% 			end;
%% 		true ->
%% 			ok
%% 	end.
%% 
%% 
%% %% 放弃任务关闭副本点
%% abnegate_task(_Status, TaskId) ->
%% 	case TaskId of
%% 		0 -> ok;
%% 		_ ->
%% 			case match_one(?ETS_BASE_DUNGEON, #ets_base_dungeon{task=TaskId, _='_'}) of
%% 				[] ->
%% 					ok;
%% 				BaseDung ->
%% 					case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.id) of
%% 						[] -> ok;
%% 						[Sid, Did, Stat, Lstm, Grade] ->
%% 							if 
%% 								Stat =:= 2 ->
%% 									Data = [Sid, Did, 0, Lstm, Grade],
%% 									update_dungeon(Data),
%% 									DungeonInfo = get(player_dungeon_info),
%% 									db_agent_dungeon:update_player_dungeon(Sid, DungeonInfo);
%% 								true ->
%% 									skip
%% 							end
%% 					end
%% 			end
%% 	end.
%% 
%% %%判断是否打对应副本的怪物
%% can_fight_dungeon(Status, MonGroupId) ->
%% 	BeingDungeon = get(being_dungeon_info),
%% 	if
%% 		BeingDungeon =:= undefined orelse BeingDungeon =:= [] ->		%%正在进行的副本数据为空, 不能打
%% 			[3,0,0];
%% 		true ->
%% 			case BeingDungeon of
%% 				[_OldS, Did, BeingMonList] ->
%% 					BaseDungeon = get_base_dungeon(Did),
%% 					if
%% 						BaseDungeon =:= [] orelse BeingMonList =:= [] ->	%%找不到基础副本或怪物ID为空, 不能打
%% 							put(being_dungeon_info, []),					%%清除副本数据
%% 							[3,0,0];
%% 						true ->
%% 							case lists:keyfind(MonGroupId, 1, BeingMonList) of
%% 								false ->							%%在怪物列表中打不到对应的怪物, 不能打
%% 									[3,0,0];
%% 								{_MonId, No, St} ->
%% 									LenMon = length(BeingMonList),
%% 									if
%% 										No =:= LenMon ->			%%是最后一只怪
%% 											IsLast = 1;
%% 										true ->
%% 											IsLast = 0
%% 									end,
%% 									if
%% 										St =:= 2 ->					%%已经打过的不能再打
%% 											[3,0,0];
%% 										No =:= 1 ->					%%第一个怪
%% 											if
%% 												St =:= 0  ->		%%第一个怪是未过打状态
%% 													NeedEng = data_player:get_dung_eng(BaseDungeon#ets_base_dungeon.stype),
%% 													AllHasEng = lib_player:get_all_energy(Status),
%% 													if
%% 														Status#player.lv < BaseDungeon#ets_base_dungeon.lv ->	%%等级不够
%% 															put(being_dungeon_info, []),
%% 															[5,0,0];
%% 														AllHasEng < NeedEng ->			%%体力不够
%% 															[4,0,0];
%% 														true ->
%% 															[1,Did,IsLast]
%% 													end;
%% 												true ->				%%只剩下状态为1的
%% 													[1,Did,IsLast]			%%第一个怪是已打但未打过状态, 体力已扣, 可以再打
%% 											end;
%% 										true ->						%%非第一个
%% 											PreMon = [PreMonId||{PreMonId, PreNo, PreSt}<-BeingMonList, PreNo<No, PreSt=/=2],
%% 											if
%% 												PreMon =/= [] ->	%%有未打过的前怪, 不能越位打
%% 													[6,0,0];
%% 												true ->
%% 													[1,Did,IsLast]
%% 											end
%% 									end
%% 							end
%% 					end;
%% 				_ ->									%%副本数据不正确, 不能打
%% 					put(being_dungeon_info, []),		%%清除副本数据
%% 					[3,0,0]
%% 			end
%% 	end.
%% 
%% %%战斗后更新副本的怪物状态, Result:1赢了, 2输了
%% update_fight_dungeon(Status, MonGroupId, Result, Grade) ->
%% 	BeingDungeon = get(being_dungeon_info),
%% 	if
%% 		BeingDungeon =:= undefined orelse BeingDungeon =:= [] ->			%%正在进行的副本数据为空
%% 			Status;
%% 		true ->
%% 			case BeingDungeon of
%% 				[OldS, Did, BeingMonList] ->
%% 					BaseDungeon = get_base_dungeon(Did),
%% 					if
%% 						BaseDungeon =:= [] orelse BeingMonList =:= [] ->	%%找不到基础副本或怪物ID为空
%% 							put(being_dungeon_info, []),					%%清除副本数据
%% 							Status#player{stts=OldS};
%% 						true ->
%% 							case lists:keyfind(MonGroupId, 1, BeingMonList) of
%% 								false ->
%% 									Status;
%% 								{MonId, No, St} ->
%% 									if
%% 										No =:= 1 andalso St =:= 0 ->		%%第一怪且未打的
%% 											NeedEng = data_player:get_dung_eng(BaseDungeon#ets_base_dungeon.stype),
%% 											if
%% 												NeedEng > 0 ->
%% 													lib_task:event(over_dungeon, [1], Status),		%%单人副本打怪
%% 													Status1 = lib_player:cost_energy(Status, NeedEng, 2001),
%% 													lib_player:send_player_attribute2(Status1, 3);
%% 												true ->
%% 													Status1 = Status
%% 											end;
%% 										true ->
%% 											Status1 = Status
%% 									end,
%% 									if
%% 										Result =:= 1 ->		%%赢了
%% 											St1 = 2;		%%打赢了
%% 										true ->
%% 											St1 = 1			%%打了
%% 									end,
%% 									BeingMonList1 = lists:keyreplace(MonGroupId, 1, BeingMonList, {MonId, No, St1}),
%% 									LenMon = length(BeingMonList),
%% 									if
%% 										Result =:= 1 andalso No >= LenMon ->				%%打完最后一个怪了, 完成副本
%% 											finish_dungeon(Status1, Did, Grade);
%% 										true ->
%% 											skip
%% 									end,
%% 									put(being_dungeon_info, [OldS, Did, BeingMonList1]),	%%保存当前正在进行的副本
%% 									Status1
%% 							end
%% 					end;
%% 				_ ->
%% 					Status
%% 			end
%% 	end.
%% 
%% %%获取副本挂机所需要的体力、怪物ID列表, 玩家进程调用
%% get_eng_mon_for_hook(Did) ->
%% 	case get_base_dungeon(Did) of		%%基础副本不存在
%% 		[] ->
%% 			[0, 0,[]];
%% 		BaseDungeon ->
%% 			DungInfo = get_dungeon_by_dungid(Did),
%% 			case DungInfo of
%% 				[_Sid, _Did, Stat, _Lstm, _Grade] ->
%% 					if
%% 						Stat =/= 1 ->	%%不是已经通关的
%% 							[0, 0,[]];
%% 						true ->
%% 							NeedEng = data_player:get_dung_eng(BaseDungeon#ets_base_dungeon.stype),
%% 							[1, NeedEng, BaseDungeon#ets_base_dungeon.mon]
%% 					end;
%% 				_ ->
%% 					[0, 0,[]]
%% 			end
%% 	end.
%% 			
%% 
%% %%进入副本点
%% enter_dungeon(Status, Did) ->
%% 	[Res, DungeonId, Sid, MonList] = 
%% 		case get_dungeon_by_dungid(Did) of
%% 			[_Sid, _Did, Stat, _Lstm, _Grade] ->
%% 				if
%% 					Stat =:= 1 orelse Stat =:= 2 ->					%%已通关或可通关的
%% 						case get_base_dungeon(Did) of
%% 							[] ->
%% 								[0, 0, 0, []];
%% 							BaseDungeon ->
%% 								NeedEng = data_player:get_dung_eng(BaseDungeon#ets_base_dungeon.stype),
%% 								AllHasEng = lib_player:get_all_energy(Status),
%% 								if
%% 									Status#player.lv < BaseDungeon#ets_base_dungeon.lv ->	%%等级不够
%% 										[0, 0, 0, []];
%% 									AllHasEng < NeedEng ->			%%体力不够
%% 										[2, 0, 0, []];
%% 									true ->
%% 										[1, Did, BaseDungeon#ets_base_dungeon.sid, BaseDungeon#ets_base_dungeon.mon]
%% 								end
%% 						end;
%% 					true ->
%% 						[0, 0, 0, []]
%% 				end;
%% 			_ ->
%% 				[0, 0, 0, []]
%% 		end,
%% 	if
%% 		Res =/= 1 ->
%% 			[Res, DungeonId, Sid, MonList];
%% 		true ->
%% 			F = fun(MonId, Acc) ->
%% 						No = length(Acc) + 1,
%% 						[{MonId, No, 0}|Acc]
%% 				end,
%% 			BeingMonList = lists:foldl(F, [], MonList),
%% 			BeingDungeon = [Status#player.stts, DungeonId, BeingMonList],
%% 			put(being_dungeon_info, BeingDungeon),			%%保存当前正在进行的副本
%% 			[Res, DungeonId, Sid, MonList]
%% 	end.
%% 
%% %%退出副本
%% exit_dungeon() ->
%% 	BeingDungeon = get(being_dungeon_info),
%% 	if
%% 		BeingDungeon =:= undefined orelse BeingDungeon =:= [] ->			%%正在进行的副本数据为空
%% 			[0, 0];
%% 		true ->
%% 			case BeingDungeon of
%% 				[OldS, _, _] ->
%% 					put(being_dungeon_info, []),							%%清空正在进行的副本数据
%% 					[1, OldS];
%% 				_ ->
%% 					put(being_dungeon_info, []),
%% 					[0, 0]
%% 			end
%% 	end.
%% 	
%% 
%% %%是否在副本中
%% is_in_dungeon() ->
%% 	BeingDungeon = get(being_dungeon_info),
%% 	if
%% 		BeingDungeon =:= undefined orelse BeingDungeon =:= [] ->			%%正在进行的副本数据为空
%% 			0;
%% 		true ->
%% 			1
%% 	end.
%% 	
%% 	
%% %%
%% %% Local Functions
%% %%
%% %%更新副本列表数据
%% update_dungeon(DungInfo) ->
%% 	DungeonList = get(dungeon_list),
%%     [Sid, Did| _T] = DungInfo,
%% 	NewDungList = [[Sid1, Did1 | Data] || [Sid1, Did1 | Data] <- DungeonList, Did1 =/= Did],	%%除开此副本点的剩余数据
%% 	NewDungList1 = [DungInfo | NewDungList],
%% 	update_dungeon_info(Sid, Did, DungInfo),
%% 	put(dungeon_list, NewDungList1).
%% 
%% %%新加副本点数据
%% insert_dungeon(DungInfo) ->
%% 	DungeonList = get(dungeon_list),	
%% 	NewDungList = [DungInfo | DungeonList], 
%% 	[Sid, Did | _T] = DungInfo,
%% 	insert_dungeon_info(Sid, Did, DungInfo),
%% 	put(dungeon_list, NewDungList).
%% 
%% %%删除副本点数据
%% delete_dungeon(DungInfo) ->
%% 	DungeonList = get(dungeon_list),
%% 	[Sid, Did| _T] = DungInfo,
%% 	NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungeonList, Did1 =/= Did],
%% 	delete_dungeon_info(Sid, Did),			%%再从玩家副本数据中删除
%% 	put(dungeon_list, NewDungList).		%%更新副本点列表
%% 
%% %%已经通关的副本点个数
%% get_finish_dungeon_num() ->
%% 	DungeonList = get(dungeon_list),
%% 	List = [Sid || [Sid, _Did, Stat | _T] <- DungeonList,  Stat =:= 1],
%% 	length(List).
%% 	
%% %%更新玩家副本数据中的副本点
%% update_dungeon_info(Sid, Did, Data) ->
%% 	DungeonInfo = get(player_dungeon_info),
%% 	if
%% 		is_record(DungeonInfo, dungeon) ->
%% 			case Sid of
%% 				101 ->
%% 					DungList = DungeonInfo#dungeon.s1,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s1 = NewDungList1};
%% 				102 ->
%% 					DungList = DungeonInfo#dungeon.s2,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s2 = NewDungList1};
%% 				103 ->
%% 					DungList = DungeonInfo#dungeon.s3,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s3 = NewDungList1};
%% 				104 ->
%% 					DungList = DungeonInfo#dungeon.s4,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s4 = NewDungList1};
%% 				105 ->
%% 					DungList = DungeonInfo#dungeon.s5,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s5 = NewDungList1};
%% 				106 ->
%% 					DungList = DungeonInfo#dungeon.s6,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s6 = NewDungList1};
%% 				107 ->
%% 					DungList = DungeonInfo#dungeon.s7,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s7 = NewDungList1};
%% 				108 ->
%% 					DungList = DungeonInfo#dungeon.s8,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s8 = NewDungList1};
%% 				109 ->
%% 					DungList = DungeonInfo#dungeon.s9,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s9 = NewDungList1};
%% 				110 ->
%% 					DungList = DungeonInfo#dungeon.s10,
%% 					NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 					NewDungList1 = [Data | NewDungList],
%% 					NewDungeonInfo = DungeonInfo#dungeon{s10 = NewDungList1};
%% 				_ ->
%% 					NewDungeonInfo = DungeonInfo
%% 			end,
%% 			put(player_dungeon_info, NewDungeonInfo);
%% 		true ->
%% 			skip
%% 	end.
%% 
%% %%在玩家副本数据中新加副本点
%% insert_dungeon_info(Sid, _Did, Data) ->
%% 	DungeonInfo = get(player_dungeon_info),	
%% 	case Sid of
%% 		101 ->
%% 			DungList = DungeonInfo#dungeon.s1,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s1 = NewDungList};
%% 		102 ->
%% 			DungList = DungeonInfo#dungeon.s2,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s2 = NewDungList};
%% 		103 ->
%% 			DungList = DungeonInfo#dungeon.s3,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s3 = NewDungList};
%% 		104 ->
%% 			DungList = DungeonInfo#dungeon.s4,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s4 = NewDungList};
%% 		105 ->
%% 			DungList = DungeonInfo#dungeon.s5,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s5 = NewDungList};
%% 		106 ->
%% 			DungList = DungeonInfo#dungeon.s6,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s6 = NewDungList};
%% 		107 ->
%% 			DungList = DungeonInfo#dungeon.s7,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s7 = NewDungList};
%% 		108 ->
%% 			DungList = DungeonInfo#dungeon.s8,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s8 = NewDungList};
%% 		109 ->
%% 			DungList = DungeonInfo#dungeon.s9,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s9 = NewDungList};
%% 		110 ->
%% 			DungList = DungeonInfo#dungeon.s10,
%% 			NewDungList = [Data | DungList],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s10 = NewDungList};
%% 		_ ->
%% 			NewDungeonInfo = DungeonInfo
%% 	end,
%% 	put(player_dungeon_info, NewDungeonInfo).
%% 
%% delete_dungeon_info(Sid, Did) ->
%% 	DungeonInfo = get(player_dungeon_info),	
%% 	case Sid of
%% 		101 ->
%% 			DungList = DungeonInfo#dungeon.s1,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s1 = NewDungList};
%% 		102 ->
%% 			DungList = DungeonInfo#dungeon.s2,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s2 = NewDungList};
%% 		103 ->
%% 			DungList = DungeonInfo#dungeon.s3,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s3 = NewDungList};
%% 		104 ->
%% 			DungList = DungeonInfo#dungeon.s4,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s4 = NewDungList};
%% 		105 ->
%% 			DungList = DungeonInfo#dungeon.s5,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s5 = NewDungList};
%% 		106 ->
%% 			DungList = DungeonInfo#dungeon.s6,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s6 = NewDungList};
%% 		107 ->
%% 			DungList = DungeonInfo#dungeon.s7,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s7 = NewDungList};
%% 		108 ->
%% 			DungList = DungeonInfo#dungeon.s8,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s8 = NewDungList};
%% 		109 ->
%% 			DungList = DungeonInfo#dungeon.s9,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s9 = NewDungList};
%% 		110 ->
%% 			DungList = DungeonInfo#dungeon.s10,
%% 			NewDungList = [[Sid1, Did1 | T] || [Sid1, Did1 | T] <- DungList, Did1 =/= Did],
%% 			NewDungeonInfo = DungeonInfo#dungeon{s10 = NewDungList};
%% 		_ ->
%% 			NewDungeonInfo = DungeonInfo
%% 	end,
%% 	put(player_dungeon_info, NewDungeonInfo).	
%% 
%% %%开全副本, GM命令使用
%% open_all_dungeon(Status) ->
%% 	%%io:format("open_all_dungeon:~p\n",[test]),
%% 	role_login(Status),
%% 	List = match_all(?ETS_BASE_DUNGEON, #ets_base_dungeon{_='_'}),
%% 	case List of 
%% 		[] -> ok;
%% 		_ ->
%% 			F = fun(BaseDung) ->
%% 						Lstm = util:unixtime(),
%% 						Did = BaseDung#ets_base_dungeon.id,
%% 						Sid = BaseDung#ets_base_dungeon.sid,
%% 						Stat = 1,
%% 						Grade = 0,
%% 						Data = [Sid, Did,  Stat, Lstm, Grade],
%% 						case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.id) of
%% 							[_Sid, _Did, _Stat, _Lstm, _Grade] ->
%% 								update_dungeon(Data);
%% 							_ ->
%% 								insert_dungeon(Data)
%% 						end,
%% 						DungeonInfo = get(player_dungeon_info),
%% 						db_agent_dungeon:update_player_dungeon(Sid, DungeonInfo)
%% 				end,
%% 			lists:foreach(F, List),
%% 			ok							
%% 	end.	
%% 	
%% %%检查配置数据, 仅用于辅助检查配置数据
%% check_table_base_dungeon() ->
%% 	BaseDungeonList = ets:tab2list(?ETS_BASE_DUNGEON),
%% 	F = fun(BaseDungeon, Acc) ->
%% 				case lists:member(BaseDungeon#ets_base_dungeon.sid, [101,102]) of		%%对特定场景的副本点检查
%% 					true ->
%% 						if
%% 							BaseDungeon#ets_base_dungeon.mid =< 0 orelse BaseDungeon#ets_base_dungeon.sid =< 0
%% 							  orelse BaseDungeon#ets_base_dungeon.btid =< 0  ->
%% 								[BaseDungeon#ets_base_dungeon.id|Acc];
%% 							true ->
%% 								case lib_mon:get_base_mongroup(BaseDungeon#ets_base_dungeon.mid) of
%% 									[] ->
%% 										[BaseDungeon#ets_base_dungeon.id|Acc];
%% 									_ ->
%% 										if
%% 											is_list(BaseDungeon#ets_base_dungeon.mon) ->
%% 												NoMon = [MonGroupId||MonGroupId<-BaseDungeon#ets_base_dungeon.mon, lib_mon:get_base_mongroup(MonGroupId)=:=[]],
%% 												if
%% 													NoMon =/= [] ->						%%没有对应的怪物，错了
%% 														[BaseDungeon#ets_base_dungeon.id|Acc];
%% 													true ->
%% 														Acc
%% 												end
%% 										end
%% 								end
%% 						end;
%% 					_ ->
%% 						Acc
%% 				end
%% 		end,
%% 	WrongBaseDungeonList = lists:foldl(F, [], BaseDungeonList),
%% 	if
%% 		WrongBaseDungeonList =/= [] ->
%% 			io:format("check_table_base_dungeon, WrongBaseDungeonList:~p~n", [WrongBaseDungeonList]);
%% 		true ->
%% 			skip
%% 	end,
%% 	ok.
%% 
%% %% -----------------------------------------------------------------
%% %% 通用函数
%% %% -----------------------------------------------------------------
%% lookup_one(Table, Key) ->
%% 	%%io:format("lookup_one:~p\n",[Key]),
%%     Record = ets:lookup(Table, Key),
%% 	%%io:format("lookup_one1:~p\n",[Record]),
%%     if  Record =:= [] ->
%%             [];
%%         true ->
%%             [R|_] = Record,
%%             R
%%     end.
%% 
%% lookup_all(Table, Key) ->
%%     ets:lookup(Table, Key).
%% 
%% match_one(Table, Pattern) ->
%%     Record = ets:match_object(Table, Pattern),
%%     if  Record =:= [] ->
%%             [];
%%         true ->
%%             [R|_] = Record,
%%             R
%%     end.
%% 
%% match_all(Table, Pattern) ->
%%     ets:match_object(Table, Pattern).
%% 
%% getDungName(DungId) ->
%% 	case ets:match_object(?ETS_BASE_DUNGEON, #ets_base_dungeon{id=DungId, _='_'}) of
%% 		[] ->
%% 			"";
%% 		[BaseDungeon|_] ->
%% 			tool:to_list(BaseDungeon#ets_base_dungeon.sname)
%% 	end.
%% 
%% 
%% %% %% 登录后加载玩家副本
%% %% role_login(PlayerStatus) ->
%% %%     %%加载灵兽
%% %% 	get_player_all_dungeon(PlayerStatus#player.id).
%% %% 
%% %% %% 第一次初始化玩家副本数据
%% %% init_player_dungeon(PlayerId) ->
%% %% 	BaseDungList = match_all(?ETS_BASE_DUNGEON, #ets_base_dungeon{pre = 0, task=0, _='_'}),
%% %% 	case BaseDungList of
%% %% 		[] ->
%% %% 			NewDungeonList = [];
%% %% 		_ ->
%% %% 			Timestamp = util:unixtime(),
%% %% 			NewDungeonList1 = 
%% %% 				 lists:map(fun(BaseNextDung)->
%% %% 								   case db_agent_dungeon:insert_dungeon(PlayerId, BaseNextDung, 0, 2, Timestamp) of
%% %% 									   [] -> 
%% %% 										   [];
%% %% 									   NexDungInfo ->
%% %% 										   NexDungInfo%%list_to_tuple([dungeon_log | NexDungInfo])
%% %% 								   end
%% %% 								   end,BaseDungList),
%% %% 			NewDungeonList = [DungInfo1 || DungInfo1 <- NewDungeonList1, DungInfo1 =/= []]
%% %% 	end,
%% %% 	
%% %% 	put(player_dungeon, NewDungeonList),
%% %% 	
%% %% 	NewDungeonList.
%% %% 
%% %% insert_dungeon_list(Playerid, DungList) ->	
%% %% 	 Fun = fun(DungInfo) ->
%% %% 				  BaseNextDung = get_base_dungeon(DungInfo#dungeon_log.did),
%% %% 				  db_agent_dungeon:insert_dungeon(Playerid, BaseNextDung, DungInfo#dungeon_log.use, DungInfo#dungeon_log.stat, DungInfo#dungeon_log.lstm)
%% %%                   %%spawn(fun()->db_agent_dungeon:insert_dungeon(Playerid, BaseNextDung, DungInfo#dungeon_log.use, DungInfo#dungeon_log.stat, DungInfo#dungeon_log.lstm) end)
%% %%           end,
%% %%     lists:foreach(Fun, DungList).
%% %% 	
%% %% 	
%% %% 
%% %% %% 获取玩家所有副本信息 
%% %% get_player_all_dungeon(PlayerId) ->
%% %% 	DungeonList = get(player_dungeon),
%% %% 	
%% %% 	if 
%% %% 		DungeonList =:= undefined ->
%% %% 			 DungeonList1 = db_agent_dungeon:select_player_all_dungeon(PlayerId),
%% %% 			 
%% %% 			 NewDungeonList = 
%% %% 				 lists:map(fun(DungInfo)-> 
%% %% 								   Dung1 = list_to_tuple([dungeon_log | DungInfo]),
%% %% 								   DungNew = add_finish_time(Dung1, 0),
%% %% 								   
%% %% 								   if 
%% %% 									   DungNew#dungeon_log.stat =/= Dung1#dungeon_log.stat orelse DungNew#dungeon_log.use =/= Dung1#dungeon_log.use ->
%% %% 										   db_agent_dungeon:update_dungeon(PlayerId, DungNew);
%% %% 									   true -> skip
%% %% 								   end,
%% %% 										   
%% %% 								   DungNew end,DungeonList1),			 
%% %% 			
%% %% 			 case NewDungeonList of
%% %% 				 [] ->
%% %% 					 NewDungeonList1 = init_player_dungeon(PlayerId);					
%% %% 				 _ ->
%% %% 					  put(player_dungeon, NewDungeonList),
%% %% 					 NewDungeonList1 = NewDungeonList					 
%% %% 			 end,
%% %% 			
%% %% 			 NewDungeonList1;		
%% %% 		true ->
%% %% 			
%% %% 			DungeonList
%% %% 	end.
%% %% 
%% %% %% 获取指定场景的副本任务
%% %% get_dungeon_by_screenid(PlayerId, ScreenId) ->
%% %% 	DungeonList = get(player_dungeon),	
%% %% 	NewDungList = [DungInfo || DungInfo <- DungeonList, DungInfo#dungeon_log.sid =:= ScreenId],
%% %% 	
%% %% 	NewDungeonList = 
%% %% 				 lists:map(fun(DungInfo)-> 
%% %% 								   DungNew = add_finish_time(DungInfo, 0),
%% %% 								   
%% %% 								   if 
%% %% 									   DungNew#dungeon_log.stat =/= DungInfo#dungeon_log.stat orelse DungNew#dungeon_log.use =/= DungInfo#dungeon_log.use ->
%% %% 										   update_dungeon(PlayerId, DungNew);
%% %% 									   true -> skip
%% %% 								   end,
%% %% 										   
%% %% 								   DungNew end,NewDungList),
%% %% 	NewDungeonList.
%% %% 
%% %% %% 获取指定的副本任务
%% %% get_dungeon_by_dungid(DungId) ->
%% %% 	DungeonList = get(player_dungeon),
%% %% 	NewDungList = [add_finish_time(DungInfo, 0) || DungInfo <- DungeonList, DungInfo#dungeon_log.did =:= DungId],
%% %% 	
%% %% 	case NewDungList of
%% %% 		[] -> [];
%% %% 		[Fisrt | _] -> Fisrt
%% %% 	end.
%% %% 
%% %% %% 获取副本相关数据[是否能战斗（0不可战斗，1可以战斗），副本类型(0普通副本，1 boss副本，2精英副本), 是否已经通过, 怪物群组]
%% %% get_dungeon_data(DungId) ->
%% %% 	%%io:format("~s get_dungeon_data 1[~p] \n ",[misc:time_format(now()), DungId]),
%% %% 	case get_dungeon_by_dungid(DungId) of
%% %% 		[] -> [0, 0, 0, 0];
%% %% 		DungInfo ->
%% %% 			NewDung = add_finish_time(DungInfo, 0),
%% %% 			%%io:format("~s get_dungeon_data 2[~p] \n ",[misc:time_format(now()), NewDung]),
%% %% 			if 
%% %% 				NewDung#dungeon_log.stat =/= 1 andalso  NewDung#dungeon_log.stat =/= 2 ->
%% %% 					[0, 0, 0, 0];
%% %% 				true ->
%% %% 					if 
%% %% 						NewDung#dungeon_log.stat =:= 1 orelse NewDung#dungeon_log.stat =:= 3 -> Can = 1;
%% %% 						true -> Can = 0
%% %% 					end,
%% %% 					
%% %% 					BaseDung = get_base_dungeon(NewDung#dungeon_log.did),
%% %% 					
%% %% 					%%[Eng, Time] = data_dungeon:get_eng_time(NewDung#dungeon_log.stype),
%% %% 					%%io:format("~s get_dungeon_data 3[~p] \n ",[misc:time_format(now()), NewDung#dungeon_log.stype]),
%% %% 					[1, NewDung#dungeon_log.stype, Can, BaseDung#ets_base_dungeon.mid]
%% %% 			end
%% %% 	end.
%% %% 
%% %% 
%% %% add_finish_time(DungInfo, Times) ->
%% %% 	Timestamp = util:unixtime(),
%% %% 	%%io:format("~s add_finish_time 1[~p/~p] \n ",[misc:time_format(now()), DungInfo, Times]),
%% %% 
%% %% 	%% 获取当天0点和第二天0点
%% %% 	{Today, _NextDay} = util:get_midnight_seconds(Timestamp),
%% %% 	
%% %% 	if
%% %% 		DungInfo#dungeon_log.num =:= 0 -> 
%% %% 			if 
%% %% 				Times > 0 ->
%% %% 					NewDung = DungInfo#dungeon_log{stat = 1, lstm = Timestamp};
%% %% 				true ->
%% %% 					NewDung = DungInfo#dungeon_log{lstm = Timestamp}
%% %% 			end,
%% %% 					
%% %% 			NewDung;
%% %% 		true ->
%% %% 			if 
%% %% 				Today > DungInfo#dungeon_log.lstm ->
%% %% 					Use = 0;
%% %% 				true ->
%% %% 					Use = DungInfo#dungeon_log.use
%% %% 			end, 
%% %% 			
%% %% 			Remain = DungInfo#dungeon_log.num - Use - Times,			
%% %% 			if
%% %% 				Remain > 0 ->
%% %% 					NewDung = DungInfo#dungeon_log{use = Use + Times, stat = 1, lstm = Timestamp};
%% %% %% 					case Use of
%% %% %% 						0 ->
%% %% %% 							NewDung = DungInfo#dungeon_log{use = Times, lstm = Timestamp};
%% %% %% 						_ ->
%% %% %% 							NewDung = DungInfo#dungeon_log{use = Use + Times, stat = 1, lstm = Timestamp}
%% %% %% 					end;
%% %% 				true ->
%% %% 					NewDung = DungInfo#dungeon_log{use = Use + Times, stat = 3, lstm = Timestamp}
%% %% 			end,
%% %% 			NewDung
%% %% 	end.			
%% %% 			
%% %% 
%% %% %% 通关指定的副本任务
%% %% finish_dungeon(Status, DungId, Result, Grade)->	
%% %% 
%% %% 	if 
%% %% 		Result =:= 1 ->
%% %% 			DungInfo = get_dungeon_by_dungid(DungId),
%% %% 			lib_task:event(finish_dungeon, [1], Status),
%% %% 			
%% %% 			case DungInfo of
%% %% 				[] -> ok;
%% %% 				_ ->
%% %% 					%%io:format("~s finish_dungeon 1[~p] \n ",[misc:time_format(now()), DungInfo]),
%% %% 					if
%% %% 						DungInfo#dungeon_log.stat =/=2 -> 
%% %% 							FinishDung = add_finish_time(DungInfo, 1),
%% %% 							if 
%% %% 								Grade > FinishDung#dungeon_log.grade ->
%% %% 									FinishDung1 = FinishDung#dungeon_log{grade = Grade};
%% %% 								true ->
%% %% 									FinishDung1 = FinishDung
%% %% 							end,
%% %% 							
%% %% 							update_dungeon(Status#player.id,FinishDung1),
%% %% 
%% %% 							ok;
%% %% 						true ->						
%% %% 							
%% %% 							FinishDung = add_finish_time(DungInfo, 1),
%% %% 							if 
%% %% 								Grade > FinishDung#dungeon_log.grade ->
%% %% 									FinishDung1 = FinishDung#dungeon_log{grade = Grade};
%% %% 								true ->
%% %% 									FinishDung1 = FinishDung
%% %% 							end,
%% %% 							
%% %% 							update_dungeon(Status#player.id,FinishDung1),							
%% %% 							ok
%% %% 					end,
%% %% 					
%% %% 					NextDungIdList = check_next_dungeon(Status, DungId),
%% %% 					
%% %% 					NextDungList2 = [FinishDung1 | NextDungIdList],
%% %% 					%% 通知客户端更新副本任务
%% %% 					{ok, BinData} = pt_46:write(46002, [NextDungList2]),
%% %% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 					insert_dungeon_list(Status#player.id, NextDungIdList)
%% %% 			end;
%% %% 		true ->
%% %% 			ok
%% %% 	end.
%% %% 
%% %% check_next_dungeon(Status, DungId) ->
%% %% 	BaseDung = get_base_dungeon(DungId),
%% %% 	NextDungIdList = BaseDung#ets_base_dungeon.next,
%% %% 	NextDungList = lists:map(fun(NextDungId) ->
%% %% 		case get_dungeon_by_dungid(NextDungId) of
%% %% 			[] ->
%% %% 				BaseNextDung = get_base_dungeon(NextDungId),
%% %% 				%% 判断是否能打开副本点
%% %% 				CanOpen =
%% %% 					case BaseNextDung#ets_base_dungeon.task of
%% %% 						0 -> %% 没有任务限制
%% %% 							true;
%% %% 						_ -> %% 有指定承接任务，先判断任务是否已接
%% %% 							case lib_task:get_one_trigger(BaseNextDung#ets_base_dungeon.task, Status) of
%% %% 								false -> 
%% %% 									%% 是否已经完成
%% %% 									case lib_task:in_finish(BaseNextDung#ets_base_dungeon.task, Status) of
%% %% 										true -> true;
%% %% 										_ -> false
%% %% 									end;
%% %% 								_ -> true
%% %% 							end
%% %% 					end,
%% %% 				
%% %% 				case CanOpen of
%% %% 					true ->
%% %% 						Timestamp = util:unixtime(),
%% %% 						NewNexDungInfo = #dungeon_log{uid = Status#player.id,
%% %% 													  did = BaseNextDung#ets_base_dungeon.id,
%% %% 													  sid = BaseNextDung#ets_base_dungeon.sid,
%% %% 													  type = BaseNextDung#ets_base_dungeon.type,
%% %% 													  num = BaseNextDung#ets_base_dungeon.num,
%% %% 													  stype = BaseNextDung#ets_base_dungeon.stype,
%% %% 													  use = 0,
%% %% 													  stat = 2,
%% %% 													  lstm = Timestamp},
%% %% 						
%% %% 						insert_dungeon(NewNexDungInfo),
%% %% 						NewNexDungInfo;
%% %% 					false ->
%% %% 						[]
%% %% 				end;
%% %% 			_ ->
%% %% 				[]
%% %% 		end
%% %% 		end, NextDungIdList),
%% %%    	
%% %% 	NextDungList1 = [DunInfo1 || DunInfo1 <- NextDungList, DunInfo1 =/= []],
%% %% 	NextDungList1.
%% %% 
%% %% 
%% %% %% 接受任务开放副本点
%% %% trigger_task(Status, TaskId) ->
%% %% 	case TaskId of
%% %% 		0 -> ok;
%% %% 		_ ->
%% %% 			case match_one(?ETS_BASE_DUNGEON, #ets_base_dungeon{task=TaskId, _='_'}) of
%% %% 				[] ->
%% %% 					ok;
%% %% 				BaseDung ->
%% %% 					case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.id) of
%% %% 						[] ->
%% %% 							CanOpen = case BaseDung#ets_base_dungeon.pre of 
%% %% 										  0 -> true;
%% %% 										  _ ->
%% %% 											  case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.pre) of
%% %% 												  [] -> false;
%% %% 												  PreDung ->
%% %% 													  if 
%% %% 														  PreDung#dungeon_log.stat =:= 1 orelse PreDung#dungeon_log.stat =:= 3 -> true;%% 前驱副本已经通过
%% %% 														  true -> false
%% %% 													  end
%% %% 											  end
%% %% 									  end,
%% %% 							case CanOpen of
%% %% 								true ->
%% %% 									
%% %% 									Timestamp = util:unixtime(),
%% %% 									NewNexDungInfo = #dungeon_log{
%% %% 																uid = Status#player.id,
%% %% 																did = BaseDung#ets_base_dungeon.id,
%% %% 																sid = BaseDung#ets_base_dungeon.sid,
%% %% 																type = BaseDung#ets_base_dungeon.type,
%% %% 																stype = BaseDung#ets_base_dungeon.stype,
%% %% 																num = BaseDung#ets_base_dungeon.num,
%% %% 																use = 0,
%% %% 																stat = 2,
%% %% 																lstm = Timestamp},
%% %% 
%% %% 									insert_dungeon(NewNexDungInfo),
%% %% 									NextDungList = [NewNexDungInfo],
%% %% 									%% 通知客户端更新副本任务
%% %% 									{ok, BinData} = pt_46:write(46002, [NextDungList]),
%% %% 									lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 									
%% %% 									db_agent_dungeon:insert_dungeon(Status#player.id, BaseDung, 0, 2, Timestamp);
%% %% 									
%% %% 									%%spawn(fun()->db_agent_dungeon:insert_dungeon(Status#player.id, BaseDung, 0, 2, Timestamp) end);
%% %% 								false ->
%% %% 									ok
%% %% 							end;
%% %% 						_ ->
%% %% 							ok
%% %% 					end
%% %% 			end
%% %% 	end.
%% %% 
%% %% 
%% %% %% 放弃任务关闭副本点
%% %% abnegate_task(Status, TaskId) ->
%% %% 	case TaskId of
%% %% 		0 -> ok;
%% %% 		_ ->
%% %% 			case match_one(?ETS_BASE_DUNGEON, #ets_base_dungeon{task=TaskId, _='_'}) of
%% %% 				[] ->
%% %% 					ok;
%% %% 				BaseDung ->
%% %% 					case get_dungeon_by_dungid(BaseDung#ets_base_dungeon.id) of
%% %% 						[] -> ok;
%% %% 						DungInfo ->
%% %% 							if 
%% %% 								DungInfo#dungeon_log.stat =:= 1 ->
%% %% 									ok;
%% %% 								true ->
%% %% 									delete_dungeon(DungInfo),
%% %% 									db_agent_dungeon:delete_dungeon(Status#player.id, BaseDung#ets_base_dungeon.id)
%% %% 									%%spawn(fun()->db_agent_dungeon:delete_dungeon(Status#player.id, BaseDung#ets_base_dungeon.id) end)									
%% %% 							end
%% %% 					end
%% %% 			end
%% %% 	end.
%% %% 
%% %% %%
%% %% %% Local Functions
%% %% %%
%% %% update_dungeon(PlayerId,DungInfo) ->
%% %% 	DungeonList = get(player_dungeon),
%% %% 	NewDungList = [DungInfo1 || DungInfo1 <- DungeonList, DungInfo1#dungeon_log.did =/= DungInfo#dungeon_log.did],
%% %% 	NewDungList1 = [DungInfo | NewDungList], 
%% %% 	db_agent_dungeon:update_dungeon(PlayerId, DungInfo),
%% %% 	put(player_dungeon, NewDungList1).
%% %% 
%% %% insert_dungeon(DungInfo) ->
%% %% 	DungeonList = get(player_dungeon),	
%% %% 	NewDungList = [DungInfo | DungeonList], 
%% %% 	
%% %% 	put(player_dungeon, NewDungList).
%% %% 
%% %% delete_dungeon(DungInfo) ->
%% %% 	DungeonList = get(player_dungeon),
%% %% 	NewDungList = [DungInfo1 || DungInfo1 <- DungeonList, DungInfo1#dungeon_log.did =/= DungInfo#dungeon_log.did],
%% %% 	put(player_dungeon, NewDungList).	
%% %% 	
%% %% 	
%% %% %% -----------------------------------------------------------------
%% %% %% 通用函数
%% %% %% -----------------------------------------------------------------
%% %% lookup_one(Table, Key) ->
%% %% 	%%io:format("lookup_one:~p\n",[Key]),
%% %%     Record = ets:lookup(Table, Key),
%% %% 	%%io:format("lookup_one1:~p\n",[Record]),
%% %%     if  Record =:= [] ->
%% %%             [];
%% %%         true ->
%% %%             [R] = Record,
%% %%             R
%% %%     end.
%% %% 
%% %% lookup_all(Table, Key) ->
%% %%     ets:lookup(Table, Key).
%% %% 
%% %% match_one(Table, Pattern) ->
%% %%     Record = ets:match_object(Table, Pattern),
%% %%     if  Record =:= [] ->
%% %%             [];
%% %%         true ->
%% %%             [R] = Record,
%% %%             R
%% %%     end.
%% %% 
%% %% match_all(Table, Pattern) ->
%% %%     ets:match_object(Table, Pattern).
%% %% 
%% %% getDungName(DungId) ->
%% %% 	case ets:match_object(?ETS_BASE_DUNGEON, #ets_base_dungeon{id=DungId, _='_'}) of
%% %% 		[] ->
%% %% 			"";
%% %% 		[BaseDungeon|_] ->
%% %% 			tool:to_list(BaseDungeon#ets_base_dungeon.sname);
%% %% 		_ ->
%% %% 			""
%% %% 	end.
%% %% 		
%% %% 
%% %% 
