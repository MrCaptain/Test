%%%------------------------------------
%%% @Module  : mod_mon_active
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 怪物活动状态
%%%------------------------------------
-module(mod_mon_active).
-behaviour(gen_fsm).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(RETIME, 5000). 				%% 回血时间
-define(MOVE_TIME, 60000). 			%% 自动移动时间
-define(DUNGEON_MOVE_TIME, 4000).

-record(state, {    
	battle_limit = 0,				%%  战斗时的一些受限制状态，1 定身，2昏迷，3沉默（封技）
	player_list = []
			   
}).

%% 开启一个怪物活动进程，每个怪物一个进程
start(Minfo) ->
    gen_fsm:start_link(?MODULE, Minfo, []).

%% init([M, Id, SceneId, X, Y, Type]) ->
%%     %% 打开战斗进程    
%% 	{ok, BattlePid} = mod_battle:start_link(),
%%     Minfo = M#ets_mon{
%%         id = Id,
%%         scene = SceneId,
%%         x = X,
%%         y = Y,
%%         d_x = X,
%%         d_y = Y,                
%%         skill = [],        
%%         pid = self(),
%%         pid_battle = BattlePid,
%%         battle_status = [],
%%         unique_key = {SceneId, Id},
%% 		status = 0,
%% 		relation = []
%%     },
%%     ets:insert(?ETS_SCENE_MON, Minfo),
%% 	misc:write_monitor_pid(self(),?MODULE, {}),
%% 	State = #state{},
%% 	RT = 
%% 		case Type == 0 of
%% 			true ->
%% 				?RETIME;
%% 			%% 怪物动态生成
%% 			false ->
%% 				{ok, ReviveBinData} = pt_12:write(12007, Minfo),
%%     			mod_scene_agent:send_to_area_scene(SceneId, X, Y, ReviveBinData),
%% 				{ok, BinData} = pt_20:write(20103, [X, Y, 1000, 10038]),
%%  				mod_scene_agent:send_to_area_scene(SceneId, X, Y, BinData),
%% 				1000
%% 		end,
%% 	put(delay_revive_timer, undefined),
%%     {ok, sleep, [[], Minfo, State], RT}.
%% 
%% handle_event(_Event, StateName, Status) ->
%%     {next_state, StateName, Status}.
%% 
%% handle_sync_event(_Event, _From, StateName, Status) ->
%%     {reply, ok, StateName, Status}.
%% 
%% %% 记录战斗结果
%% handle_info({'MON_BATTLE_RESULT', [Hp, Mp, CurAttId, CurAttPid, _AttCareer]}, StateName, [AttObj, Minfo, State]) ->
%% 	case Minfo#ets_mon.hp > 0 of
%% 		true ->
%% 			case lists:member(CurAttId,State#state.player_list) of
%% 				false->
%% 					PlayerList = [CurAttId | State#state.player_list],
%% 					NewState=State#state{player_list=PlayerList};
%% 				true->
%% 					NewState=State
%% 			end,
%% 			NewMinfo = Minfo#ets_mon{
%%                 hp = Hp,
%%                 mp = Mp
%%             },
%%             ets:insert(?ETS_SCENE_MON, NewMinfo),
%%             case Hp > 0 of
%%                 true ->
%%                     case StateName of
%%                         trace ->
%%                             {next_state, trace, [AttObj, NewMinfo, NewState]};
%%                         _ ->
%%                             gen_fsm:send_event_after(1000, repeat),
%%                             {next_state, trace, [[CurAttId, CurAttPid], NewMinfo, NewState]}	
%%                     end;
%%                 false ->
%%                     mon_revive(NewMinfo, NewState, StateName, AttObj, CurAttId)
%%             end;
%% 		false ->
%% 			mon_revive(Minfo, State, StateName, AttObj, CurAttId)
%% 	end;
%% 
%% %% 开始一个怪物持续流血的计时器	
%% handle_info({'START_HP_TIMER', CurAttId, CurAttPid, Hurt, Time, Interval}, StateName, [AttObj, Minfo, State]) ->	
%% 	misc:cancel_timer(bleed_timer),
%% 	case Minfo#ets_mon.hp > 0 of
%% 		true ->		
%% 			MHp = 
%% 				case Minfo#ets_mon.hp > Hurt of
%% 					true ->
%% 						Minfo#ets_mon.hp - Hurt;
%% 					false ->
%% 						AttId = 
%% 							case AttObj of
%% 								[PreAttId, _PreAttPid] ->
%% 									PreAttId;
%% 								_ ->
%% 									CurAttId
%% 							end,
%% 						lib_mon:mon_die(Minfo, AttId,State#state.player_list),
%% 						0
%% 				end,
%% 			NewMinfo = Minfo#ets_mon{
%% 				hp = MHp
%% 			},
%% 			ets:insert(?ETS_SCENE_MON, NewMinfo),
%%           	%% 更新怪物血量，广播给附近玩家
%%             {ok, BinData} = pt_12:write(12082, [NewMinfo#ets_mon.id, MHp]),                   
%%             mod_scene_agent:send_to_area_scene(NewMinfo#ets_mon.scene, NewMinfo#ets_mon.x, NewMinfo#ets_mon.y, BinData),
%% 			case MHp > 0 of
%% 				true ->
%% 					NewTime = Time - 1,
%% 					BleedTimer = 
%%     					case NewTime > 0 of
%%         					true ->
%%             					erlang:send_after(Interval, self(), {'START_HP_TIMER', CurAttId, CurAttPid, Hurt, NewTime, Interval});
%%         					false ->
%%             					undefined
%%     					end,
%% 					put(bleed_timer, BleedTimer),
%% 					{next_state, StateName, [AttObj, NewMinfo, State]};
%% 				false ->
%% 					mon_revive(NewMinfo, State, StateName, AttObj, CurAttId)
%% 			end;			
%% 		false ->
%% 			mon_revive(Minfo, State, StateName, AttObj, CurAttId)
%% 	end;
%% 
%% %% 更改怪物Buff
%% handle_info({'SET_MON_BUFF', Buff}, StateName, [AttObj, Minfo, State]) ->	
%% 	NewMinfo = Minfo#ets_mon{
%%         battle_status = Buff        
%%     },
%%     ets:insert(?ETS_SCENE_MON, NewMinfo),
%% 	{next_state, StateName, [AttObj, NewMinfo, State]};
%% 
%% handle_info('DELAY_REVIVE', StateName, [_AttObj, Minfo, _State]) ->
%% 	DelayReviveTimer = get(delay_revive_timer),
%% 	case DelayReviveTimer of
%% 		undefined ->
%% 			skip;	
%% 		_ ->
%% 			erlang:cancel_timer(DelayReviveTimer)
%% 	end,
%% 	put(delay_revive_timer, undefined),
%% 	NewMinfo = lib_mon:revive(Minfo, Minfo#ets_mon.d_x, Minfo#ets_mon.d_y),
%% 	NewState = #state{},
%% 	{next_state, StateName, [[], NewMinfo, NewState]};
%% 
%% %% 更改战斗限制状态
%% %% ChangeStatus 要更改的状态
%% %% CurStatus 当前的状态
%% handle_info({'CHANGE_BATTLE_LIMIT', ChangeStatus, CurStatus}, StateName, [AttObj, Minfo, State]) ->	
%% 	BattleLimit = 
%% 		case ChangeStatus of
%% 			%% 取消限制状态
%% 			0 ->
%% 				%% 判断当前状态是否一样
%% 				case State#state.battle_limit of
%% 					CurStatus ->
%% 						ChangeStatus;						
%% 					_ ->
%% 						State#state.battle_limit						
%% 				end;
%% 			_ ->
%% 				ChangeStatus				
%% 		end,
%% 	NewState = State#state{
%% 		battle_limit = BattleLimit					   
%% 	},
%%     case BattleLimit of
%%         0 ->
%%             case StateName == trace andalso length(AttObj) >= 2 of
%%                 true ->
%%                     {next_state, trace, [AttObj, Minfo, NewState]};
%%                 false ->
%%                     gen_fsm:send_event_after(1000, repeat),
%%                     {next_state, trace, [AttObj, Minfo, NewState]}
%%             end;
%%         _ ->
%%             {next_state, StateName, [AttObj, Minfo, NewState]}
%%     end;
%% 
%% %% 改变怪物速度
%% %% Speed 速度
%% handle_info({'CHANGE_SPEED', Speed}, StateName, [AttObj, Minfo, State]) ->	
%% 	NewMinfo = Minfo#ets_mon{
%%         speed = Speed        
%%     },
%% 	ets:insert(?ETS_SCENE_MON, NewMinfo),
%% 	{next_state, StateName, [AttObj, NewMinfo, State]};
%% 
%% %% 定时处理怪物信息
%% %% Interval 倒计时间
%% %% Message 要处理的消息
%% handle_info({'SET_TIME_MON', Interval, Message}, StateName, [AttObj, Minfo, State]) ->	
%% 	erlang:send_after(Interval, self(), Message),
%% 	{next_state, StateName, [AttObj, Minfo, State]};
%% 
%% handle_info({'SET_MON_LIMIT', Type, Data}, StateName, [AttObj, Minfo, State]) ->
%%     case Type of
%%         %% 减速度
%%         1 ->
%%             [PreSpeed, CurSpeed, Interval] = Data,
%%             Message = {'CHANGE_SPEED', PreSpeed},
%%             erlang:send_after(Interval, self(), Message),
%%             NewMinfo = Minfo#ets_mon{
%%                 speed = CurSpeed        
%%             },
%%             ets:insert(?ETS_SCENE_MON, NewMinfo),
%%             {next_state, StateName, [AttObj, NewMinfo, State]};
%%         %% 改变状态
%%         2 ->
%%             [BattleLimit, Interval] = Data,
%%             Message = {'CHANGE_BATTLE_LIMIT', 0, BattleLimit},
%%             erlang:send_after(Interval, self(), Message),
%%             handle_info({'CHANGE_BATTLE_LIMIT', BattleLimit, 0}, StateName, [AttObj, Minfo, State]);
%%         _ ->
%%             {next_state, StateName, [AttObj, Minfo, State]}
%%     end;	
%% 
%% %% 清除进程
%% handle_info(clear, _StateName, [AttObj, Minfo, State]) ->
%%     ets:delete(?ETS_SCENE_MON, {Minfo#ets_mon.scene, Minfo#ets_mon.id}),
%% 	%% 清除怪物战斗进程
%% 	gen_server:cast(Minfo#ets_mon.pid_battle, {stop, 1}),
%%     {stop, normal, [AttObj, Minfo, State]};
%% 
%% handle_info(Info, StateName, [AttObj, Minfo, State]) ->
%% ?WARNING_MSG("MON_NO_MSG: /~p/~n", [[Info, StateName, [AttObj, Minfo, State]]]),	
%%     {next_state, StateName, [AttObj, Minfo, State]}.
%% 
%% terminate(_Reason, _StateName, _Status) ->
%% 	misc:delete_monitor_pid(self()),
%%     ok.
%% 
%% code_change(_OldVsn, StateName, Status, _Extra) ->
%%     {ok, StateName, Status}.
%% 
%% 
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% 处理怪物所有状态
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% %% 静止状态并回血
%% sleep(timeout, [[], Minfo, State]) ->
%% 	case get(delay_revive_timer) of
%% 		undefined ->
%%             %% 判断是否死亡
%%             case Minfo#ets_mon.hp > 0 of
%%                 true ->
%%                     NewMinfo = 
%%                         case Minfo#ets_mon.status == 0 of
%%                             true ->
%%                                 Minfo;
%%                             false ->
%%                                 NMinfo = Minfo#ets_mon{
%%                                		status = 0
%%                                 },
%%                                 ets:insert(?ETS_SCENE_MON, NMinfo),
%%                                 NMinfo                		
%%                         end,
%%                     case NewMinfo#ets_mon.att_type of
%%                         %% 主动怪
%%                         1 ->                    
%%                             MonScene = NewMinfo#ets_mon.scene,
%%                             MonX = NewMinfo#ets_mon.x,
%%                             MonY = NewMinfo#ets_mon.y,
%%                             GuardArea = NewMinfo#ets_mon.guard_area,
%%                             case lib_scene:get_area_user_for_battle(MonScene, MonX, MonY, GuardArea) of
%%                                 [] ->
%%                                     auto_move(NewMinfo, State);                           
%%                                 [AttId, AttPid] ->
%%                                     gen_fsm:send_event_after(100, repeat),
%%                                     {next_state, trace, [[AttId, AttPid], NewMinfo, State]}
%%                             end;
%%                         
%%                         %% 被动怪
%%                         0 -> 
%%                             auto_move(NewMinfo, State)
%%                     end;
%%                 false ->
%%                     gen_fsm:send_event_after(Minfo#ets_mon.retime, repeat),
%%                     {next_state, revive, [[], Minfo, State]}
%%             end;
%% 		_ ->
%% 			{next_state, sleep, [[], Minfo, State]}
%% 	end;    
%% sleep(_R, Status) ->
%%     sleep(timeout, Status).
%% 
%% %% 跟踪目标
%% trace(timeout, [AttObj, Minfo, State])->
%% 	case lists:member(Minfo#ets_mon.type, [6, 7, 101]) of
%% 		true->
%% 			{next_state, sleep, [[], Minfo, State]};
%% 		false->
%%             case Minfo#ets_mon.status /= 1 andalso length(AttObj) >=2 of
%%                 true ->
%% 					[AttId, _AttPid] = AttObj,
%% 					case lib_mon:get_player(AttId, Minfo#ets_mon.scene) of 
%%                         [] ->
%%                             {next_state, back, [[], Minfo, State], 1000};
%% 						Player ->
%%                             X = Player#player.x,
%%                             Y = Player#player.y,
%%                             Hp = Player#player.hp,
%%                             case Hp > 0 of
%%                                 true ->
%%                                		attack_or_trace(Minfo, State, X, Y, AttObj, Player);
%%                                 false ->
%%                                     {next_state, back, [[], Minfo, State], 1000}
%%                             end
%%                     end;
%%                 false ->
%%                     {next_state, back, [[], Minfo, State], 1000}
%%             end
%%     end;
%% trace(repeat, Status) ->
%%     trace(timeout, Status);
%% trace(_R, Status) ->
%%     trace(timeout, Status).
%% 
%% %% 返回默认出生点
%% back(timeout, [[], Minfo, State]) ->
%%     {StateName, NewMinfo, Interval} = lib_mon:back(Minfo, State#state.battle_limit, Minfo#ets_mon.d_x, Minfo#ets_mon.d_y),
%%     {next_state, StateName, [[], NewMinfo, State], Interval};
%% back(_R, Status) ->
%%     sleep(timeout, Status).
%% 
%% %% 复活
%% revive(timeout, [_PidList, Minfo, State]) ->
%% 	stop_mon_timer(),
%% 	%% 重生时间大于0且不是副本怪
%%     case Minfo#ets_mon.retime > 0 andalso lib_scene:is_copy_scene(Minfo#ets_mon.scene) == false 
%% 			andalso Minfo#ets_mon.type /= 4 of
%%         true ->
%% 			case get(delay_revive_timer) of
%% 				undefined ->
%% 					DelayReviveTimer = erlang:send_after(2000, self(), 'DELAY_REVIVE'),
%% 					put(delay_revive_timer, DelayReviveTimer);
%% 				_ ->
%% 					skip
%% 			end,
%% 			{next_state, sleep, [[], Minfo, State]};
%% 		false when Minfo#ets_mon.scene rem 10000 =:= ?BOXS_PIECE_ID ->%%特殊情况，是新秘境副本  ---- by xiaomai
%% 			case get(delay_revive_timer) of
%% 				undefined ->
%% 					DelayReviveTimer = erlang:send_after(2000, self(), 'DELAY_REVIVE'),
%% 					put(delay_revive_timer, DelayReviveTimer);
%% 				_ ->
%% 					skip
%% 			end,
%% 			{next_state, sleep, [[], Minfo, State]};
%%         %% 不重生关闭怪物进程
%% 		false ->
%%             handle_info(clear, null, [[], Minfo, State])
%%     end;
%% revive(repeat, Status) ->
%% 	revive(timeout, Status);
%% revive(_R, Status) ->
%% 	revive(timeout, Status).
%% 
%% %% 怪物攻击移动
%% attack_move(Minfo, State, AttObj, X, Y) ->
%%     %% 判断是否障碍物
%%     case lib_scene:is_blocked(Minfo#ets_mon.scene, [X, Y]) of
%%         %% 无障碍物
%% 		true ->           
%%             [NewMinfo, Interval] = lib_mon:attack_move(Minfo, State#state.battle_limit, X, Y),
%%             gen_fsm:send_event_after(Interval, repeat),
%%             {next_state, trace, [AttObj, NewMinfo, State]};
%%         false ->
%%             {next_state, back, [[], Minfo, State], 1000}
%%     end.
%% 
%% %% 随机移动
%% auto_move(Minfo, State) ->
%% 	MT = 
%% 		case Minfo#ets_mon.type of
%% 			4 ->
%% 				?DUNGEON_MOVE_TIME;
%% 			_ ->
%% 				?MOVE_TIME
%% 		end,
%%     %% 判断有没有超出巡逻范围
%% 	case Minfo#ets_mon.type =:= 6 of
%% 		true ->
%% 			{next_state, sleep, [[], Minfo, State], MT};
%% 		false->
%%    			case Minfo#ets_mon.patrol_area > 0 andalso Minfo#ets_mon.speed > 0 of
%% 				true ->
%% 					Rand = random:uniform(4),
%%     				MoveArea = 2,
%%     				[X, Y] =
%% 						case Minfo#ets_mon.x == Minfo#ets_mon.d_x andalso Minfo#ets_mon.y == Minfo#ets_mon.d_y of
%% 							true ->				
%%                 				case Rand of
%%                     				1 ->
%%                         				[Minfo#ets_mon.x + MoveArea, Minfo#ets_mon.y];
%%                     				2 ->
%%                         				[Minfo#ets_mon.x, Minfo#ets_mon.y + MoveArea];
%%                     				3 ->
%%                         				[abs(Minfo#ets_mon.x - MoveArea), Minfo#ets_mon.y];
%%                     				_ ->
%%                         				[Minfo#ets_mon.x, abs(Minfo#ets_mon.y - MoveArea)]
%%                 				end;
%% 							false ->
%% 								[Minfo#ets_mon.d_x, Minfo#ets_mon.d_y]
%% 						end,
%% 					%% 判断有没有定身或昏迷
%% 				    BattleLimit = State#state.battle_limit,
%%   		            case (BattleLimit == 0 orelse BattleLimit == 3) andalso lib_scene:is_blocked(Minfo#ets_mon.scene, [X, Y]) of
%%    		           		true ->
%% 					 	  	NewMinfo = Minfo#ets_mon{
%%      		                   	x = X,
%%       		                   	y = Y
%%  		                  	},
%%   	                      	lib_scene:mon_move(X, Y, NewMinfo#ets_mon.id, NewMinfo#ets_mon.scene, Minfo#ets_mon.speed),
%% 	                      	ets:insert(?ETS_SCENE_MON, NewMinfo),
%%    	                 	  	Interval = MT + MT * (Minfo#ets_mon.id rem 20),
%%                       	  	{next_state, sleep, [[], NewMinfo, State], Interval};
%%                			
%% 						%% 有障碍物
%% 		                false -> 
%%  		               		{next_state, sleep, [[], Minfo, State], MT}
%% 		            end;
%%       		  	false ->
%%             		{next_state, sleep, [[], Minfo, State], MT}
%% 			end
%%     end.
%% 
%% attack_or_trace(Minfo, State, X, Y, AttObj, Player) ->
%%     case is_attack(Minfo, X, Y) of
%%         %% 可以进行攻击
%% 		attack ->
%%             %% 昏迷状态下不能攻击
%%             [Interval, RetMinfo] =
%% 				case State#state.battle_limit /= 2 of
%%                 	true ->
%%                     	case mod_battle:battle(Minfo#ets_mon.pid_battle, [[Minfo, 1], [Player, 2], 0]) of
%%                         	undefined ->
%% 								[Minfo#ets_mon.att_speed, Minfo];
%%                         	NewMinfo ->
%% 								[Minfo#ets_mon.att_speed * 2, NewMinfo]
%%                     	end;
%%                 	false ->
%% 						[Minfo#ets_mon.att_speed, Minfo]
%%             	end,
%% 			gen_fsm:send_event_after(Interval, repeat),
%%             {next_state, trace, [AttObj, RetMinfo, State]};
%% 		
%%         %% 还不能进行攻击就追踪
%% 		trace ->
%%             case lib_mon:trace_line(Minfo#ets_mon.x, Minfo#ets_mon.y, X, Y, Minfo#ets_mon.att_area) of
%%                 {MX, MY} ->                    
%% 					attack_move(Minfo, State, AttObj, MX, MY);
%%                 true ->
%%                     {next_state, back, [[], Minfo, State], 2000}
%%             end;
%% 		
%%         %% 停止追踪
%% 		back ->
%%             {next_state, back, [[], Minfo, State], 1000};
%% 		
%%         %% 死亡
%% 		die ->
%% 			gen_fsm:send_event_after(Minfo#ets_mon.retime, repeat),
%%           	{next_state, revive, [[], Minfo, State]}
%%     end.
%% 
%% %% 判断距离是否可以发动攻击
%% %% Minfo 怪物信息
%% %% X 被击方的X坐标
%% %% Y 被击方的Y坐标 
%% is_attack(Minfo, X, Y) ->    
%%     case Minfo#ets_mon.hp > 0 of
%%         true ->
%% 			lib_mon:trace_action(Minfo, X, Y);
%%         false ->
%%             die
%%     end.
%% 
%% mon_revive(Minfo, State, StateName, AttObj, CurAttId) ->
%% 	case StateName of
%% 		revive ->
%% 			{next_state, revive, [[], Minfo, State]};
%% 		_ ->
%%             AttId = 
%%                 case AttObj of
%%                     [PreAttId, _PreAttPid] ->
%%                         PreAttId;
%%                     _ ->
%%                         CurAttId
%%                 end,
%%             lib_mon:mon_die(Minfo, AttId,State#state.player_list),
%%             gen_fsm:send_event_after(Minfo#ets_mon.retime, repeat),
%%             {next_state, revive, [[], Minfo, State]}
%% 	end.
%% 
%% stop_mon_timer() ->
%% 	%% 取消持续流血定时器
%% 	misc:cancel_timer(bleed_timer).

