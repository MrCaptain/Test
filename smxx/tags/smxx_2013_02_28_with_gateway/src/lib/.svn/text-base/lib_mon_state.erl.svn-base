%%%-----------------------------------
%%% @Module  : lib_mon_state
%%% @Author  : chenzm
%%% @Created : 2013.1.22
%%% @Description:  场景中怪物状态切换管理
%%%-----------------------------------
-module(lib_mon_state).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-include("battle.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-export([do_guard/3,
		 do_try_attack/3,
		 do_chant/3,
		 do_move/3,
		 do_revive/3,
		 do_fight/3,
		 do_return/3,
		 make_move_path/5
		]).


%%@spec 警戒具体业务逻辑===begin
%% 1. 普通小怪无仇恨，谁第一个打它它就将谁设置成攻击目标
%% 2. BOSS怪物则需要根据攻击警戒范围来确定攻击目标
%% 3. 确定攻击目标后，试图发起攻击
do_guard(SceneId,Mon,NowTime) ->
	%% 	?TRACE("===do_guard: Mon: ~p, ~n", [[SceneId, Mon#temp_mon_layout.pos_x, Mon#temp_mon_layout.pos_y, Mon#temp_mon_layout.monrcd#temp_npc.warn_range]]) ,
	if
		Mon#temp_mon_layout.monrcd#temp_npc.warn_range > 0 andalso Mon#temp_mon_layout.monrcd#temp_npc.npc_type >= 20 ->
			case lib_scene:get_squre_players(SceneId, Mon#temp_mon_layout.pos_x, Mon#temp_mon_layout.pos_y, Mon#temp_mon_layout.monrcd#temp_npc.warn_range) of
				Players when length(Players) > 0 ->
					HateList = lib_mon:update_hate(Players,Mon#temp_mon_layout.hate_list) ;
				_ ->
					HateList = Mon#temp_mon_layout.hate_list 
			end ,
			case lib_mon:get_attact_target(HateList) of
				%% 找到攻击目标，切换到下一个状态
				Player when is_record(Player,player) ->    	
					Mon#temp_mon_layout{target_uid = Player#player.id , 
										state = ?MON_STATE_2_TRYATT , 
										refresh_time = NowTime+?MON_STATE_LOOP_TIME ,
										hate_list = HateList} ;
				%%无攻击目标
				_ ->  						
					Mon
			end ;
		%% 被动怪物自己先不动
		true ->   							
			Mon#temp_mon_layout{refresh_time = NowTime+1000000000000} 
	end .



%%@spec 试图攻击业务逻辑=== 
%% 1. 如果在技能的攻击范围内，则发起攻击
%% 2. 不在攻击范围内，则走过去
%% 3. 
do_try_attack(SceneId,Mon,NowTime) ->
	%% 获取怪物的攻击技能
	?TRACE("===do_try_attack: Mon: ~p, ~n", [[SceneId, Mon#temp_mon_layout.pos_x, Mon#temp_mon_layout.pos_y, Mon#temp_mon_layout.monrcd#temp_npc.warn_range]]) ,
	BuffList = Mon#temp_mon_layout.battle_attr#battle_attr.skill_buff ,
	BuffTime = has_unskill_buff(BuffList) ,
	
	if
		BuffTime > 0 ->	
			Mon#temp_mon_layout{ state = ?MON_STATE_1_GUARD, refresh_time = NowTime + ?MON_STATE_LOOP_TIME } ;
		Mon#temp_mon_layout.target_uid =< 0  ->
			Mon#temp_mon_layout{ state = ?MON_STATE_1_GUARD, refresh_time = NowTime + ?MON_STATE_LOOP_TIME } ;
		true ->
			%% 获取攻击技能
			{SkillId,SkillLv} = get_attack_skill(Mon#temp_mon_layout.monrcd#temp_npc.act_skilllist) ,
			{ActtakDist,_} = data_skill:get_skill_aoe(SkillId) ,
			{CanBreak,SingTime} = data_skill:get_sing(SkillId) ,
			?TRACE("===do_try_attack: Mon: ~p, ~n", [SingTime]) ,
			if
				SingTime > 0 ->
					spawn(fun() -> broad_monster_chant(SceneId,Mon,SkillId,CanBreak,SingTime) end ) ,
					Mon#temp_mon_layout{attack_skill = SkillId ,skill_lv = SkillLv , begin_sing = util:longunixtime() ,
										state = ?MON_STATE_7_CHANT, refresh_time = NowTime + SingTime }  ;
				true ->
					%% 获取怪物攻击目标
					case lib_scene:get_scene_player(SceneId, Mon#temp_mon_layout.target_uid) of
						Player when is_record(Player,player) ->
							case battle_util:check_att_area(Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y,ActtakDist) of
								true ->		
									Mon#temp_mon_layout{attack_skill = SkillId , skill_lv = SkillLv ,
														state = ?MON_STATE_4_FIGHT , refresh_time = NowTime + ?MON_STATE_LOOP_TIME } ;
								false ->
									MovePath = make_move_path(Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y,[]) ,
									case length(MovePath) > 0 of
										true ->
											broad_monster_move(SceneId,Mon#temp_mon_layout.id,Mon#temp_mon_layout.x,Mon#temp_mon_layout.y,MovePath) ;
										false ->
											skip
									end ,
									Mon#temp_mon_layout{attack_skill = SkillId , skill_lv = SkillLv , move_path = MovePath ,
														state = ?MON_STATE_3_MOVE,refresh_time = NowTime + ?MON_STATE_LOOP_TIME}
							end ;
						_ ->
							Mon#temp_mon_layout{target_uid = 0 , attack_skill = 0 , skill_lv = 0 , move_path = [] ,
												state = ?MON_STATE_1_GUARD,refresh_time = NowTime + ?MON_STATE_LOOP_TIME} 
					end  
			end 
	
	end .

%% 判断有无不能使用技能的BUFF
has_unskill_buff(BuffList) ->
	Fun = fun({BuffId,ExpireTime}) ->
				  case tpl_buff:get(BuffId) of
					  BuffRcd when is_record(BuffRcd,temp_buff) ->
						  case lists:member(BuffRcd#temp_buff.type,[4,5]) of
							  true ->
								  ExpireTime ;
							  false ->
								  0
						  end ;
					  _ ->
						  0
				  end 
		  end ,
	NewBuffList = lists:map(Fun,BuffList) ,
	lists:sum(NewBuffList) .

%% 判断有无不能使用技能的BUFF
has_unmove_buff(BuffList) ->
	Fun = fun({BuffId,ExpireTime}) ->
				  case tpl_buff:get(BuffId) of
					  BuffRcd when is_record(BuffRcd,temp_buff) ->
						  case lists:member(BuffRcd#temp_buff.type,[3,5]) of
							  true ->
								  ExpireTime ;
							  false ->
								  0
						  end ;
					  _ ->
						  0
				  end 
		  end ,
	NewBuffList = lists:map(Fun,BuffList) ,
	lists:sum(NewBuffList) .

%% 获取攻击技能和技能等级		  
get_attack_skill(SkillList) ->
	case length(SkillList) > 0 of
		true ->
			Index = random:uniform(length(SkillList)) ,
			{SkillId,SkillLv} = lists:nth(Index, SkillList) ;
		false ->
			SkillId = 1 ,
			SkillLv = 1 
	end ,
	{SkillId,SkillLv} .

broad_monster_chant(SceneId,MonRcd,SkillId,CanBreak,SingTime) ->
	{ok,ChantBin} = pt_12:write(12014,[MonRcd#temp_mon_layout.id,SkillId,CanBreak,SingTime]) ,
	X = MonRcd#temp_mon_layout.pos_x ,
	Y = MonRcd#temp_mon_layout.pos_y ,
	mod_scene_agent:send_to_same_screen(SceneId, X, Y, ChantBin,"") .
	

%%@spec 怪物吟唱具体业务逻辑(有吟唱的不追击)=== 
do_chant(_SceneId,Mon,NowTime) ->
	Mon#temp_mon_layout{state = ?MON_STATE_4_FIGHT, refresh_time = NowTime+?MON_STATE_LOOP_TIME } .



%%@spec 走动具体业务逻辑=== 
do_move(SceneId,Mon,NowTime) ->
	%% 	?TRACE("===do_move: Players: ~p ~n", [Mon#temp_mon_layout.move_path]),
	BuffList = Mon#temp_mon_layout.battle_attr#battle_attr.skill_buff ,
	BuffTime = has_unmove_buff(BuffList) ,
	if
		BuffTime > 0 ->	
			Mon#temp_mon_layout{refresh_time = NowTime + ?MON_STATE_LOOP_TIME } ;
		length(Mon#temp_mon_layout.move_path) =< 2 ->     %% 这里如果写成0 ，有点停顿的感觉
			Mon#temp_mon_layout{move_path = [] , state = ?MON_STATE_4_FIGHT,refresh_time = NowTime } ;
		true ->  %%还未走到目标位置，继续走路
			[{NextX,NextY}|LeftPath] = Mon#temp_mon_layout.move_path ,
			Distance = util:distance({Mon#temp_mon_layout.x,Mon#temp_mon_layout.y}, {NextX,NextY}) ,
			case Distance > Mon#temp_mon_layout.monrcd#temp_npc.fire_range of
				true ->
					handle_return(SceneId,Mon,NowTime) ;
				false ->
					Mon#temp_mon_layout{pos_x = NextX,pos_y = NextY,move_path= LeftPath} 
			end     %%走到了目标位置，开始战斗
	
	end.



%%@spec 战斗具体业务逻辑=== 
%% -define(ATTACK_SUCCESS,   1).   % 攻击成功
%% -define(ATTACK_NO_TARGET, 2).   % 攻击范围内没有攻击目标
%% -define(NOT_ATTACK_AREA,  3).   % 超出攻击范围
do_fight(SceneId,Mon,NowTime) ->
	?TRACE("===do_fight: Players: ~p ~n", [Mon#temp_mon_layout.move_path]),
	case lib_scene:get_scene_player(SceneId, Mon#temp_mon_layout.target_uid) of
		Player when is_record(Player,player) ->
			case lib_battle:start_mon_attack(Mon, Player, ?ELEMENT_PLAYER, Mon#temp_mon_layout.attack_skill, Mon#temp_mon_layout.skill_lv, Player#player.battle_attr#battle_attr.x, Player#player.battle_attr#battle_attr.y) of
				{?ATTACK_SUCCESS, DataList} ->      %% 有攻击目标,要清楚仇恨值
					case lists:keyfind(Mon#temp_mon_layout.target_uid, 1, DataList) of
						false ->                    %% 继续打丫的
							Mon#temp_mon_layout{refresh_time = NowTime + 2*?MON_STATE_LOOP_TIME} ;
						_ ->						%% 丫死了死了，找下一个来虐
							?TRACE("=444==do_fight: Players: ~p ~n", [DataList]),
							HateList = lib_mon:remove_hate([Mon#temp_mon_layout.target_uid],Mon#temp_mon_layout.hate_list) ,
							case lib_mon:get_attact_target(HateList) of
								Player when is_record(Player,player) ->    
									Mon#temp_mon_layout{target_uid = Player#player.id, state = ?MON_STATE_2_TRYATT, hate_list = HateList, refresh_time = NowTime + ?MON_STATE_LOOP_TIME} ;
								_ ->  						
									handle_return(SceneId,Mon,NowTime)
							end 
					end ;
				_ ->          %% 继续追击
					Path = make_move_path(Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,Player#player.battle_attr#battle_attr.x,Player#player.battle_attr#battle_attr.y,[]) ,
					case length(Path) > 0 of
						true ->
							spawn(fun() -> broad_monster_move(SceneId,Mon#temp_mon_layout.id,Mon#temp_mon_layout.x,Mon#temp_mon_layout.y,Path) end) ;
						false ->
							skip
					end ,
					Mon#temp_mon_layout{state = ?MON_STATE_3_MOVE ,move_path = Path , refresh_time = NowTime + 2*?MON_STATE_LOOP_TIME} 
			end ;
		_ ->
			handle_return(SceneId,Mon,NowTime)
	end .
	
%%@spec 好吧，没事干了，回去
handle_return(SceneId,Mon,NowTime) ->
	RPath =  make_move_path(Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,Mon#temp_mon_layout.x,Mon#temp_mon_layout.y,[]) ,
	case length(RPath) > 0 of
		true ->
			spawn(fun() -> broad_monster_move(SceneId,Mon#temp_mon_layout.id,Mon#temp_mon_layout.x,Mon#temp_mon_layout.y,RPath) end ) ;
		false ->
			skip
	end ,
	Mon#temp_mon_layout{target_uid = 0 , hate_list = [] , move_path = RPath ,
						state = ?MON_STATE_5_RETURN , refresh_time = NowTime + ?MON_STATE_LOOP_TIME } .



%%@spec 返回具体业务逻辑=== 
do_return(_SceneId,Mon,NowTime) ->
 	?TRACE("===do_return: Players: ~p ~n", [Mon#temp_mon_layout.move_path]),
	case length(Mon#temp_mon_layout.move_path) > 0 of
		 true ->	
			[{NextX,NextY}|LeftPath] = Mon#temp_mon_layout.move_path ,
			Mon#temp_mon_layout{pos_x = NextX, pos_y = NextY, move_path= LeftPath} ;
		_-> 	
			Mon#temp_mon_layout{pos_x = Mon#temp_mon_layout.x ,
								pos_y = Mon#temp_mon_layout.y ,
								move_path = [] ,
								state = ?MON_STATE_1_GUARD,refresh_time = NowTime + ?MON_STATE_LOOP_TIME}
	end.


%%@spec 复活具体业务逻辑===begin
do_revive(SceneId,Mon,NowTime) ->
	?TRACE("===do_revive: Players: ~p ~n", [Mon#temp_mon_layout.move_path]),
	BattleAttrRcd = Mon#temp_mon_layout.battle_attr ,
	NewBattleAttrRcd = BattleAttrRcd#battle_attr{hit_point = BattleAttrRcd#battle_attr.hit_point_max,
												 magic = BattleAttrRcd#battle_attr.magic_max} ,
	NewMonRcd = Mon#temp_mon_layout{target_uid = 0 ,
									state = ?MON_STATE_1_GUARD ,
									refresh_time = NowTime + ?MON_STATE_LOOP_TIME ,
									pos_x = Mon#temp_mon_layout.x ,
									pos_y = Mon#temp_mon_layout.y ,
									battle_attr = NewBattleAttrRcd } ,
	{ok,MonBin} = pt_12:write(12007, [NewMonRcd]) ,
	?TRACE("===do_revive: Mon: ~p ~n", [Mon#temp_mon_layout.id]),
	mod_scene_agent:send_to_matrix(SceneId, NewMonRcd#temp_mon_layout.x, NewMonRcd#temp_mon_layout.y, MonBin) ,
	NewMonRcd .




%%@spec 获取怪物追击路径
make_move_path(StartX,StartY,EndX,EndY,Path) ->
	if
		StartX =:= EndX andalso StartY =:= EndY ->
			Path ;
		StartX =:= EndX ->
			NextX = StartX ,
			NextY = make_next_step(StartY,EndY) ,
			NewPath = Path ++ [{NextX,NextY}] ,
			make_move_path(NextX,NextY,EndX,EndY,NewPath) ;
		StartY =:= EndY ->
			NextX = make_next_step(StartX,EndX) ,
			NextY = EndY ,
			NewPath = Path ++ [{NextX,NextY}] ,
			make_move_path(NextX,NextY,EndX,EndY,NewPath) ;
		true ->
			NextX = make_next_step(StartX,EndX) ,
			NextY = make_next_step(StartY,EndY)  ,
			NewPath = Path ++ [{NextX,NextY}] ,
			make_move_path(NextX,NextY,EndX,EndY,NewPath) 
	end .
make_next_step(Current,Target) ->
	if Current > Target ->
		   if Current - Target > 1 ->
				  Current - 1;
			  true ->
				  Target
		   end;
	   true ->
		   if Target - Current > 1 ->
				  Current + 1;
			  true ->
				  Target
		   end
	end.
				
%%@spec 广播怪物走路
broad_monster_move(SceneId,MonId,X,Y,Path) ->
	case length(Path) > 0 of
		true ->
			{ok,MoveBin} = pt_12:write(12012, [MonId,Path]) ,
			mod_scene_agent:send_to_matrix(SceneId, X,Y, MoveBin) ;
		false ->
			skip
	end .
