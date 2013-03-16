%%%-----------------------------------
%%% @Module  : lib_mon_state
%%% @Author  : chenzm
%%% @Created : 2013.1.22
%%% @Description:  场景中怪物管理
%%%-----------------------------------
-module(lib_mon).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-export([save_monster/1,
		 save_monster/4,
		 get_monsters/0,
		 get_monster/1,
		 load_monster/1,
		 update_hate/2,
		 update_hate/4,
		 get_attact_target/1,
		 get_screen_monsters/4,
		 get_matrix_monsters/4,
		 get_slice_monsters/4,
		 refresh_monsters/2,
		 save_monsters/1,
		 remove_hate/2,
		 save_monster_drops/1,
		 get_monster_drops/0]).



%% 怪物实例ID
get_monster_id() ->
	MonId = 
	case get(monster_id) of
		Data when is_integer(Data) ->
			Data + 1 ;
		_  ->
			100 
	end ,
	put(monster_id,MonId) ,
	MonId .

%% @spec 保存怪物掉落
save_monster_drops(DropList) ->
	put(?SECNE_DROP,DropList) .


%% @spec 获取场景中的怪物列表
get_monster_drops() ->
	case get(?SECNE_DROP) of
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

%% @去掉已经失效的掉落 
refresh_monster_drops([],DropList,_NowTime) ->
	DropList ;
refresh_monster_drops([DropRcd|LeftDropList],DropList,NowTime) ->
	DropTime = DropRcd#mon_drop_goods.drop_time ,
	case NowTime - DropTime > 0 of
		true ->
			NewDropList = [DropRcd|DropList] ;
		false ->
			NewDropList = DropList 
	end ,
	refresh_monster_drops(LeftDropList,NewDropList,NowTime) .
	

%% @spec 直接保存怪物列表
save_monsters(MonRcdList) ->
	put(?SECNE_MON, MonRcdList) .
	
%% @spec 保存怪物
save_monster(MonLayoutRcd) ->
	case  is_record(MonLayoutRcd, temp_mon_layout) of
		true ->
			MonList = get_monsters(),
			LeftMonList = lists:keydelete(MonLayoutRcd#temp_mon_layout.id, #temp_mon_layout.id, MonList),
			put(?SECNE_MON, [MonLayoutRcd|LeftMonList]) ;
		_ ->
			skip
	end,
	ok. 

%% @spec 保存怪物,并更新仇恨列表
save_monster(MonLayoutRcd,UId,Damaage,CurrentHp) ->
	case  is_record(MonLayoutRcd, temp_mon_layout) of
		true ->
			HateList = update_hate(UId,Damaage,MonLayoutRcd#temp_mon_layout.hate_list,CurrentHp) ,
			case CurrentHp > 0 of
				true ->
					if
						MonLayoutRcd#temp_mon_layout.monrcd#temp_npc.warn_range > 0 ->
							NewMonLayoutRcd = MonLayoutRcd#temp_mon_layout{hate_list = HateList} ;
						MonLayoutRcd#temp_mon_layout.target_uid =:= UId ->
							NewMonLayoutRcd = MonLayoutRcd#temp_mon_layout{hate_list = HateList} ;
						true ->
							NewMonLayoutRcd = MonLayoutRcd#temp_mon_layout{hate_list = HateList,
																		   target_uid = UId ,
																		   refresh_time = ?MON_STATE_LOOP_TIME,
																		   state = ?MON_STATE_2_TRYATT } 
					end ;
				false ->
					case lib_drop:get_drop_goods(MonLayoutRcd#temp_mon_layout.monrcd#temp_npc.drop_id) of
						[] ->
							skip ;
						DataList ->
							handle_monster_drop(MonLayoutRcd,DataList) 
					end ,
					NewMonLayoutRcd = MonLayoutRcd#temp_mon_layout{hate_list = [] , target_uid = 0 ,
																   refresh_time = get(fresh_time) + 1000*MonLayoutRcd#temp_mon_layout.revive_time ,
																   state = ?MON_STATE_6_DEAD} 
			end ,
			save_monster(NewMonLayoutRcd) ;
		_ ->
			skip
	end . 


handle_monster_drop(MonLayoutRcd,DataList) ->
	{DropX,DropY} = get_drop_postion(MonLayoutRcd#temp_mon_layout.pos_x,MonLayoutRcd#temp_mon_layout.pos_y) ,
	NowTime = util:unixtime() ,
	Fun = fun({GoodsId,GoodsNum}) ->
				  DropRcd = #mon_drop_goods{
											mon_id = MonLayoutRcd#temp_mon_layout.id ,
											goods_id = GoodsId ,
											goods_num = GoodsNum ,
											x = DropX ,
											y = DropY ,
											drop_time =  NowTime 
											} ,
				  DropRcd
		  end ,
	NewDataList = lists:map(Fun, DataList) ,
	OldDropList = get_monster_drops() ,
	NewDropList = refresh_monster_drops([NewDataList|OldDropList],[],NowTime) ,
	save_monster_drops(NewDropList) ,
	
	{ok,DropBin} = pt_12:write(12015, [NewDataList]) ,
	mod_scene_agent:send_to_same_screen(get(scene_id), 
										MonLayoutRcd#temp_mon_layout.pos_x, 
										MonLayoutRcd#temp_mon_layout.pos_y, DropBin, "") .
%% 获取物品掉落的坐标点
get_drop_postion(X,Y) ->
	X1 = 
		if 
			X - 10 < 0 ->
			   0 ;
			true ->
			   X - 10 
		end ,
	X2 = X + 10 ,
	Y1 = if
			 Y - 10 < 0 ->
				 0 ;
			 true ->
				 Y - 10
		 end ,
	Y2 = Y + 10 ,
	{util:rand(X1,X2),util:rand(Y1,Y2)} .
		
			 
	

%% @spec 获取场景中的怪物列表
get_monsters() ->
	case get(?SECNE_MON) of
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

%% @spec 根据怪物实例获取怪物信息
get_monster(InstId) ->
	lists:keyfind(InstId,  #temp_mon_layout.id, get_monsters()) .


%% @spec 获取场景怪物模板
get_temp_monster(SceneId) ->
	case SceneId > 999 of
		true ->
			ScnId = SceneId div 100 ;
		false ->
			ScnId = SceneId
	end ,
	MS = ets:fun2ms(fun(S) when S#temp_mon_layout.scene_id =:= ScnId -> S end),
	ets:select(?ETS_TEMP_MON_LAYOUT, MS) .


%% @spec加载本场景的怪物
load_monster(SceneId) ->
	case get_temp_monster(SceneId) of
		LayoutRcdList when is_list(LayoutRcdList) > 0 ->
			load_monster(LayoutRcdList,SceneId) ;
		_ ->
			skip
	end .
load_monster([], _SceneId) -> 
	ok;
load_monster([LayoutRcd|LeftList], SceneId) ->
	LayoutId = SceneId * 10000 + get_monster_id() ,
	case LayoutRcd#temp_mon_layout.move_time < 100 of
		true ->
			MoveTime = ?MON_STATE_LOOP_TIME ;
		false ->
			MoveTime = LayoutRcd#temp_mon_layout.move_time
	end ,
	case lib_scene:get_scene_npc(LayoutRcd#temp_mon_layout.monid) of
		MonRcd when is_record(MonRcd,temp_npc) ->
			MonCombatAttrRcd = lib_player:init_base_battle_attr(MonRcd#temp_npc.level, MonRcd#temp_npc.npc_type) ,
			NewLayoutRcd = LayoutRcd#temp_mon_layout{monrcd = MonRcd,
													 battle_attr = MonCombatAttrRcd,
													 scene_id = SceneId ,
													 move_time = MoveTime , 
													 pos_x = LayoutRcd#temp_mon_layout.x ,
													 pos_y = LayoutRcd#temp_mon_layout.y ,
													 move_path = [] ,
													 state = ?MON_STATE_1_GUARD , %%guard--move--fight--return--dead--guard
													 attack_skill = 1 ,
												     skill_lv = 1 ,
													 hate_list = [] ,
													 buff_list = [] ,	%%记录没次循环前的BUFF列表
													 id = LayoutId } ,
			save_monster(NewLayoutRcd) ;
		_ ->
			skip
	end ,
	load_monster(LeftList, SceneId) .



%%@spec 定时刷新场景中怪物状态
refresh_monsters(SceneId,NowTime) ->
	AllMons = get_monsters() ,
	refresh_monster(AllMons,SceneId,NowTime,[]) ,
	case AllMons of
		[] ->
			stop ;
		_ ->
			goon
	end .
refresh_monster([],SceneId,_NowTime,MonList) ->
	NewMonList = update_buff(SceneId,MonList,[]) ,
	save_monsters(NewMonList) ;
refresh_monster([Mon|LeftMons],SceneId,NowTime,MonList) ->
	NewMon =
		try
			TmpMon = do_refresh_monster(SceneId,Mon,NowTime),
			case is_record(TmpMon,temp_mon_layout) of
				true ->
					TmpMon;
				_ ->
					?TRACE("monster_loop error: ~w ~n",[Mon#temp_mon_layout.state]),
					Mon#temp_mon_layout{state = ?MON_STATE_5_RETURN }
			end 
		catch 
			Error:Reason ->
				?TRACE("=========refresh_monster:~w~n,~w~n,Info:~w",[Error, Reason, Mon]),
				?TRACE("get_stacktrace:~p",[erlang:get_stacktrace()]),
				Mon#temp_mon_layout{state = ?MON_STATE_5_RETURN }
		end,
	refresh_monster(LeftMons,SceneId,NowTime,[NewMon|MonList]) .

%%@spec 具体状态逻辑
do_refresh_monster(SceneId,Mon,NowTime) ->
	if
		Mon#temp_mon_layout.refresh_time =< NowTime ->
			BattleAttr = lib_skill:update_mon_battle_attr(Mon#temp_mon_layout.battle_attr,
															 Mon#temp_mon_layout.attack_skill,
															 Mon#temp_mon_layout.skill_lv) ,
			MonRcd = Mon#temp_mon_layout{battle_attr = BattleAttr} ,
			
			case MonRcd#temp_mon_layout.state of
					?MON_STATE_1_GUARD ->    
						lib_mon_state:do_guard(SceneId,MonRcd,NowTime) ;
					?MON_STATE_2_TRYATT ->
						lib_mon_state:do_try_attack(SceneId,MonRcd,NowTime) ;
					?MON_STATE_7_CHANT ->
						lib_mon_state:do_chant(SceneId,MonRcd,NowTime) ;
					?MON_STATE_3_MOVE ->
						lib_mon_state:do_move(SceneId,MonRcd,NowTime) ;
					?MON_STATE_4_FIGHT ->
						lib_mon_state:do_fight(SceneId,MonRcd,NowTime) ;
					?MON_STATE_5_RETURN ->
						lib_mon_state:do_return(SceneId,MonRcd,NowTime) ; 
					?MON_STATE_6_DEAD ->
						lib_mon_state:do_revive(SceneId,MonRcd,NowTime)  
				end ;
		true ->
			Mon
	end .

	
%%@spec 修改怪物的仇恨值列表
update_hate(UId,Damage,HateList,CurrentHp) ->
	case CurrentHp > 0 of
		true ->
			case lists:keyfind(UId, 1, HateList) of
				false ->
					NewHateList = [{UId,Damage,util:longunixtime()} | HateList] ;
				{UId,Hate,_} ->
					NewHateList = lists:keyreplace(UId,1,HateList, {UId,Hate+Damage,util:longunixtime()})
			end  ,
			NewHateList ;
		false ->
			[]
	end .

%%@spec 修改怪物当前BUFF列表
%% 1.判断BUFF有无变化
%% 2.广播有变化的BUFF列表
update_buff(_SceneId,[],NewMonList) ->
	NewMonList ;
update_buff(SceneId,[MonRcd|LeftMonList],NewMonList) ->
	NewBuffList = MonRcd#temp_mon_layout.battle_attr#battle_attr.skill_buff ,
	OldBuffList = MonRcd#temp_mon_layout.buff_list ,
	NewBuffIDList = lists:sort([BuffId || {BuffId,_} <- NewBuffList]) ,
	OldBuffIDList = lists:sort([BuffId || {BuffId,_} <- OldBuffList]) ,
	case NewBuffIDList =/= OldBuffIDList of
		true ->
			NewBuffList = [{MonRcd#temp_mon_layout.id,NewBuffList} ] ,
			{ok,BuffBin} = pt_12:write(12013,[NewBuffList]) ,
			%%起进程来搞OK
			mod_scene_agent:send_to_same_screen(SceneId, MonRcd#temp_mon_layout.battle_attr#battle_attr.x, MonRcd#temp_mon_layout.battle_attr#battle_attr.y, BuffBin,"")  ;
		false ->
			skip
	end ,
	NewMonRcd = MonRcd#temp_mon_layout{buff_list = NewBuffList} ,
	update_buff(SceneId,LeftMonList,[NewMonRcd|NewMonList]) .


%%@spec 修改怪物的仇恨值列表
%% 1.判断玩家是否在追击范围内，不在则清除仇恨值
%% 2.如果玩家之前在改区域内，则仇恨值叠加
update_hate([],HateList) ->
	HateList ;
update_hate([Player|LeftPlayers],HateList) ->
	case lists:keyfind(Player#player.id, 1, HateList) of
		false ->
			NewHateList = [{Player#player.id,1,util:longunixtime()} | HateList] ;
		{UId,Hate,_} ->
			NewHateList = lists:keyreplace(Player#player.id,1,HateList, {UId,Hate+1,util:longunixtime()})
	end ,
	update_hate(LeftPlayers,NewHateList) .


%%@spec 清楚仇恨值
remove_hate([],HateList) ->
	HateList ;
remove_hate([UId|LeftList],HateList) ->
	NewHateList = lists:keydelete(UId, 1, HateList) ,
	remove_hate(LeftList,NewHateList) .



%%@spec 根据仇恨列表获取攻击目标
get_attact_target(HateList) ->
	case length(HateList) > 0 of
		true ->
			[{UId,_,_}|_] = lists:reverse(lists:keysort(2, HateList)) ,
			lib_scene:get_scene_player(UId) ;
		false ->
			[]
	end .
%%@spec 警戒具体业务逻辑===end

%%==========================获取场景中的一定区域里面的怪物 begin==================================%%
%%@spec 获取跟指定坐标同屏的怪物
get_screen_monsters(X,Y,SolutX,SolutY) ->
	{X1,Y1,X2,Y2} = util:get_screen_posxy(X, Y, SolutX, SolutY) ,
	Fun = fun(Mon) ->
				  util:is_same_screen(Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,{X1,Y1,X2,Y2}) 
		  end ,
	lists:filter(Fun, get_monsters()) .



%@spec 获取跟指定坐标同九宫格区域的怪物
get_matrix_monsters(X,Y,SolutX,SolutY) ->
	MatrixPost = util:get_slice_matrix(X, Y,SolutX,SolutY) ,
	Fun = fun(Mon) ->
				  util:is_in_matrix(Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,MatrixPost) 
		  end ,
	
	lists:filter(Fun, get_monsters())  .


%@spec 获取跟指定坐标同一小格子的怪物
get_slice_monsters(X,Y,SolutX,SolutY) ->
	Fun = fun(Mon) ->
				  util:is_same_slice(X,Y,Mon#temp_mon_layout.pos_x,Mon#temp_mon_layout.pos_y,SolutX,SolutY)
		  end ,
	lists:filter(Fun, get_monsters()) .

%%==========================获取场景中的一定区域里面的怪物 end==================================%%
