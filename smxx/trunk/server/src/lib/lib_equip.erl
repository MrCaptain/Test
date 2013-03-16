%%%-------------------------------------- 
%%% @Module: lib_equip
%%% @Author:
%%% @Created:
%%% @Description: 
%%%-------------------------------------- 
-module(lib_equip).

-include("common.hrl").
-include("goods.hrl").
-include("goods_record.hrl").
-include("record.hrl").
-include("debug.hrl").

-compile(export_all).

-define(MIN_REWARD_STREN_LV, 3).
-define(MAX_EQUIP_REWARD_STREN, 10).

%% 获取装备基础属性列表
get_equip_attri_list(EquipList) ->
	F = fun(GoodsInfo, Result) ->
			case tpl_equipment:get(GoodsInfo#goods.gtid) of
				EquipAttri when is_record(EquipAttri, temp_item_equipment) ->
					EquipAttri#temp_item_equipment.equip_attr ++ Result;
				_ -> Result			
			end
        end,
    lists:foldl(F, [], EquipList).

%% 获取装备铸造属性
get_equip_casting_attri(PS, EquipList) ->
	[].

%% 获取全身强化奖励
get_equip_stren_reward(PS, EquipList) ->
	case length(EquipList) > ?MAX_EQUIP_REWARD_STREN of
		true ->
			[EquipInfo|T] = EquipList,
			if
				EquipInfo#goods.stren_lv < ?MIN_REWARD_STREN_LV ->
					[];
				true ->
					MinStrenLv = 
						case EquipInfo#goods.stren_percent =:= 100 of
							true -> EquipInfo#goods.stren_lv;
							false -> EquipInfo#goods.stren_lv - 1
						end,
					StrenLv = get_min_strenlv(T, MinStrenLv),
					tpl_all_stren_reward:get(StrenLv)
			end;
		false ->
			[]
	end.

get_min_strenlv([], MinStrenLv) ->
	MinStrenLv;
get_min_strenlv([EquipInfo|T], MinStrenLv) ->
	if
		EquipInfo#goods.stren_lv < ?MIN_REWARD_STREN_LV ->
			EquipInfo#goods.stren_lv;
		EquipInfo#goods.stren_lv < MinStrenLv ->
			case EquipInfo#goods.stren_percent =:= 100 of
				true -> get_min_strenlv(T, EquipInfo#goods.stren_lv);
				false -> get_min_strenlv(T, EquipInfo#goods.stren_lv - 1)
			end;
		true ->
			get_min_strenlv(T, MinStrenLv)
	end.			  

%% 获取镶嵌全身加成
get_equip_inlay_reward(PS, EquipList) -> [].
%% 	Fun = fun(GoodsInfo, Total) ->	length(GoodsInfo#goods.hole_goods) + Total	end,
%% 	GemNum = lists:foldl(Fun, 0, EquipList),
%% 	tpl_all_gem_reward:get(GemNum).

%% 套装装备加成
get_equip_suit_reward(PS, EquipList) ->
	[].

%% 镀金加成
get_equip_gilding_reward(PS, EquipList) ->
	[].

%% exports
%% desc: 检查是否装备类型的物品
%% returns: {true, GoodsInfo} | false
is_equip(_PS, 0) -> false;
is_equip(PS, GoodsId) ->
    case goods_util:get_goods(PS, GoodsId) of
        GoodsInfo when is_record(GoodsInfo, goods) ->
            case GoodsInfo#goods.type =:= ?GOODS_T_EQUIP of
                true ->  {true, GoodsInfo};
                false -> false
            end;
        _Error ->
            %?ERROR_MSG("bag arg goods_id:~w", [{GoodsId, erlang:get_stacktrace()}]),
            false
    end.    
%%
%% %% exports
%% %% desc: 检查某个物品是否套装
%% %% returns: bool()
%% is_suit(PS, GoodsId) when is_integer(GoodsId) ->
%%     case goods_util:get_goods(PS, GoodsId) of
%%         GoodsInfo when is_record(GoodsInfo, goods) ->
%%             is_suit(PS, GoodsInfo);
%%         _Error ->
%%             ?ERROR_MSG("bag arg goods_id:~p", [GoodsId]),
%%             false
%%     end;  
%% is_suit(_PS, GoodsInfo) ->
%%     GoodsInfo#goods.suit_id > 0.
%% 
%% %% exports
%% %% desc: 计算装备的孔数
%% %% returns: integer()
%% calc_equip_new_holes(Stren, Hole) -> 
%%     case Hole >= ?EQUIP_MAX_HOLES of
%%         true ->
%%             ?EQUIP_MAX_HOLES;
%%         false ->
%%             case Stren =:= ?EQUIP_MAX_STREN of
%%                 true ->   Hole + 1;
%%                 false ->  Hole
%%             end
%%     end.
%% calc_equip_new_holes(Stren, Hole, Color) -> 
%%     case Color >= ?COLOR_ORANGE of
%%         true ->
%%             calc_equip_new_holes(Stren, 3);
%%         false ->
%%             calc_equip_new_holes(Stren, Hole) 
%%     end.
%% 
%% exports
%% desc: 查询物品的附加属性
%% 洗练、强化、镀金
get_equip_add_attri(PS, GoodsId) when is_integer(GoodsId) ->
    case goods_util:get_goods(PS, GoodsId) of
        GoodsInfo when is_record(GoodsInfo, goods) ->
            get_equip_add_attri(PS, GoodsInfo);
        _ ->
            []
    end;
get_equip_add_attri(PS, GoodsInfo) ->
	PolishAddAttri = get_polish_attri(GoodsInfo),
	StrenAddAttri = get_stren_attri(GoodsInfo),
	GildingAddAtrri = get_gilding_attri(GoodsInfo),
	PolishAddAttri ++ StrenAddAttri ++ GildingAddAtrri.

%% 获取洗练附加属性
get_polish_attri(GoodsInfo) ->
	case GoodsInfo#goods.polish_num > 0 of
		true ->
			[];
		false ->
			[]
	end.

%% 获取强化加成属性
%% 基础属性*强化加成比例
get_stren_attri(GoodsInfo) ->
	case GoodsInfo#goods.stren_lv > 0 orelse GoodsInfo#goods.stren_percent > 0 of
		true ->
			[];
		false ->
			[]
	end.

%% 获取镀金加成属性
%% 基础属性*（1+强化加成比例）*镀金加成比例
get_gilding_attri(GoodsInfo) ->
	case GoodsInfo#goods.stren_lv > 0 orelse GoodsInfo#goods.stren_percent > 0 of
		true ->
			[];
		false ->
			[]
	end.

%% desc: 查询某一类型的铸造属性列表
get_casting_attri_list(GoodsInfo, AttriType) when is_record(GoodsInfo, goods) -> % 洗炼属性用15006协议查询
    GoodsId = GoodsInfo#goods.id,
    PlayerId = GoodsInfo#goods.uid,
    Pattern = #goods_attribute{ gid=GoodsId, attribute_type=AttriType, _='_'},
    lib_common:get_ets_list(?ETS_GOODS_ATTRIBUTE(PlayerId), Pattern);
get_casting_attri_list(PS, GoodsId) -> ok.
%%     case lib_common:get_ets_info(?ETS_GOODS_ONLINE(PS), GoodsId) of
%%         {} -> [];
%%         _GoodsInfo ->
%%             Pattern = #goods_attribute{ gid=GoodsId, _='_'},
%%             Attri1 = lib_common:get_ets_list(?ETS_GOODS_ATTRIBUTE(PS), Pattern),
%%             Attri1 ++ get_wash_attri_list(PS, GoodsId)
%%     end.

%% 
%% %% exports
%% %% desc: 查询装备的洗炼属性
%% get_wash_attri(PS, GoodsId) when is_integer(GoodsId) ->
%%     case goods_util:get_goods(PS, GoodsId) of
%%         GoodsInfo when is_record(GoodsInfo, goods) ->
%%             get_wash_attri(PS, GoodsInfo);
%%         _ -> {[], []}
%%     end;
%% get_wash_attri(PS, GoodsInfo) ->
%%     case lib_attribute:get_wash_info(PS, GoodsInfo#goods.id) of
%%         {} ->
%%             {[], []};
%%         AttriInfo ->
%%             {AttriInfo#ets_casting_wash.cur_attri, AttriInfo#ets_casting_wash.new_attri}
%%     end.
%% 
%% %% exports
%% %% desc: 对装备进行评分
%% %% args: GoodsId | GoodsInfo
%% %% returns: NewGoodsInfo | {}
%% calc_equip_value(PS, GoodsId) when is_integer(GoodsId) ->   % 对非仓库物品进行评分 %% todo: 仓库物品未评分
%%     calc_equip_value(PS, goods_util:get_goods(PS, GoodsId) );
%% calc_equip_value(PS, GoodsInfo) when is_record(GoodsInfo, goods) ->
%%     case GoodsInfo#goods.type =:= ?GOODS_T_EQUIP orelse GoodsInfo#goods.type =:= ?GOODS_T_PAR_EQUIP of
%%         true ->      
%%             Value = calc_grade(PS, GoodsInfo),
%%             
%%             db:update(goods, ["score"], [Value], "id", GoodsInfo#goods.id),
%%             NewInfo = GoodsInfo#goods{score = Value},
%%             ets:insert(?ETS_GOODS_ONLINE(PS), NewInfo),
%%             NewInfo;
%%         false ->     
%%             GoodsInfo
%%     end;
%% calc_equip_value(_, _) ->
%%     {}.
%% 
%% %% exports
%% %% desc: 对装备评分
%% calc_grade(PS, GoodsInfo) ->
%%     StrenAttri = get_calc_stren_attri(PS, GoodsInfo),
%%     WashAttri = lib_attribute:get_wash_attr_base(PS, GoodsInfo#goods.id),
%%     InlayAttri = lib_attribute:get_inlay_attr_base(PS, GoodsInfo),
%%     AddEattri = lib_attribute:get_equiplist_add_attri([GoodsInfo]),
%%     EquipGrade = calc_total_base_grade(GoodsInfo#goods.level, StrenAttri, WashAttri, InlayAttri, AddEattri),
%%     HolesGrade = get_holes_grade(GoodsInfo),
%%     SuitGrade = get_suit_grade(GoodsInfo),
%%     EquipGrade + SuitGrade + HolesGrade + 10.
%% 
%% %% desc: 对装备预览评分
%% calc_grade(PS, GoodsInfo, StrenAttri) ->
%%     WashAttri = lib_attribute:get_wash_attr_base(PS, GoodsInfo#goods.id),
%%     InlayAttri = lib_attribute:get_inlay_attr_base(PS, GoodsInfo),
%%     AddEattri = lib_attribute:get_equiplist_add_attri([GoodsInfo]),
%%     EquipGrade = calc_total_base_grade(GoodsInfo#goods.level, StrenAttri, WashAttri, InlayAttri, AddEattri),
%%     HolesGrade = get_holes_grade(GoodsInfo),
%%     SuitGrade = get_suit_grade(GoodsInfo),
%%     EquipGrade + SuitGrade + HolesGrade + 10.
%% 
%% %% exports
%% %% func: calc_init_equip_score/1
%% calc_init_equip_score(GoodsInfo) when GoodsInfo#goods.type =:= ?GOODS_T_EQUIP; GoodsInfo#goods.type =:= ?GOODS_T_PAR_EQUIP ->
%%    	AddEattri = lib_attribute:get_equiplist_add_attri([GoodsInfo]),
%% 	EquipGrade = calc_total_base_grade(GoodsInfo#goods.level, get_calc_stren_attri(GoodsInfo), [], [], AddEattri),
%%     HolesGrade = get_holes_grade(GoodsInfo),
%%     SuitGrade = get_suit_grade(GoodsInfo),
%%     EquipGrade + SuitGrade + HolesGrade + 10;
%% calc_init_equip_score(_) ->
%%     0.
%%                 
%% %% exports
%% %% desc: 装备使用自动提示
%% %% returns: {Res, GoodsId, GoodsTid}
%% equip_prompt(PS, GoodsTid, MainPartner, VicePartner) ->
%%     case count_equip_prompt_attri(GoodsTid, PS, MainPartner, VicePartner) of
%%         {fail, Res} ->
%%             {Res, 0, 0};
%%         {ok, PartnerId, GoodsId} ->
%%             {?RESULT_OK, PartnerId, GoodsId};
%% 		_ ->
%% 			{?RESULT_FAIL, 0, 0}
%%     end.
%% 
%% %% exports
%% %% desc: 查询玩家或武将的全身强化奖励类型
%% %% returns: {integer(), integer()}
%% get_total_stren_reward({Type, _PS, TargetId}) ->
%%     EquipList = 
%%         case Type of
%%             player ->  % 查询玩家
%%                 goods_util:get_kind_goods_list(TargetId, ?GOODS_T_EQUIP, ?LOCATION_PLAYER);
%%             partner -> % 查询武将
%%                 case lib_partner:get_alive_partner(TargetId) of
%%                     null ->
%%                         ?ASSERT(false, TargetId),
%%                         [];
%%                     TargetPar ->
%%                         OwnerId = TargetPar#ets_partner.uid,
%%                         goods_util:get_partner_equip_list(OwnerId, TargetId)
%%                 end;
%%             _Error ->
%%                 ?ERROR_MSG("get_total_stren_reward(), bag arg type:~p", [Type]), 
%%                 []
%%         end,
%%     get_total_stren_reward(EquipList);
%% get_total_stren_reward(EquipList) ->
%%     get_total_stren_reward(EquipList, {0, 0, 0, 0, 0, 0}). % 初始强化等级7, 8,9,10,11,12个数
%% 
%% %% exports
%% desc: 获取自身装备
get_own_equip_list(Location, PS) ->
    PlayerId = PS#player.id,
    case Location of
        ?LOCATION_PLAYER ->
            Pattern = #goods{uid = PlayerId, location = Location, _ = '_'},
            lib_common:get_ets_list(?ETS_GOODS_ONLINE(PS), Pattern);
        _ -> []
    end.

%% 获取身上装备强化等级
%% [Weapon, Armor, Fashion, WwaponAcc, Wing]
get_equip_strenlv([], _PS, Result) ->
	lists:reverse(Result);
get_equip_strenlv([H|T], PS, Result) ->
	if
		H =:= 0 ->
			get_equip_strenlv(T, PS, [0] ++ Result);
		true ->
			Pattern = #goods{uid = PS#player.id, gtid = H, location = ?LOCATION_PLAYER, _ = '_'},
			case lib_common:get_ets_list(?ETS_GOODS_ONLINE(PS), Pattern) of
				[GoodsInfo] when is_record(GoodsInfo, goods) ->
					get_equip_strenlv(T, PS, [GoodsInfo#goods.stren_lv] ++ Result);
				_-> get_equip_strenlv(T, PS, [0] ++ Result)
			end
	end.

%% 装备强化后,外观变化
appearance_handle(PS, GoodsInfo, StrenLevel) ->
	case GoodsInfo#goods.type /= ?GOODS_T_EQUIP of
		true -> PS;
		false ->
			EquipInfo = tpl_equipment:get(GoodsInfo#goods.gtid),
			{Flag, NewPS} = 
				if
					is_record(EquipInfo, temp_item_equipment) =:= false ->
						{0, PS};
					GoodsInfo#goods.subtype =:= ?EQUIP_T_WEAPON -> % 武器
						case lists:member(StrenLevel, EquipInfo#temp_item_equipment.stren_change) of
							true ->  
								PlayerOther = PS#player.other#player_other{weapon_strenLv = StrenLevel},
								{1, PS#player{other = PlayerOther}};
							false -> {0, PS}
						end;						
					GoodsInfo#goods.subtype =:= ?EQUIP_T_ARMOR ->  % 盔甲
						case lists:member(StrenLevel, EquipInfo#temp_item_equipment.stren_change) of
							true ->  
								PlayerOther = PS#player.other#player_other{armor_strenLv = StrenLevel},
								{1, PS#player{other = PlayerOther}};
							false -> {0, PS}
						end;					
					GoodsInfo#goods.subtype =:= ?EQUIP_T_FASHION -> % 时装
						case lists:member(StrenLevel, EquipInfo#temp_item_equipment.stren_change) of
							true ->  
								PlayerOther = PS#player.other#player_other{fashion_strenLv = StrenLevel},
								{1, PS#player{other = PlayerOther}};
							false -> {0, PS}
						end;					
					GoodsInfo#goods.subtype =:= ?EQUIP_T_WEAPONACCESSORIES -> % 武饰
						case lists:member(StrenLevel, EquipInfo#temp_item_equipment.stren_change) of
							true ->  
								PlayerOther = PS#player.other#player_other{wapon_accstrenLv = StrenLevel},
								{1, PS#player{other = PlayerOther}};
							false -> {0, PS}
						end;					
					GoodsInfo#goods.subtype =:= ?EQUIP_T_WINGS ->	% 翅膀
						case lists:member(StrenLevel, EquipInfo#temp_item_equipment.stren_change) of
							true ->  
								PlayerOther = PS#player.other#player_other{wing_strenLv = StrenLevel},
								{1, PS#player{other = PlayerOther}};
							false -> {0, PS}
						end;
					true -> {0, PS}
				end,
			case Flag =:= 1 of
				true -> 
					{ok, BinData} = pt_12:write(12022, [PS#player.id, GoodsInfo#goods.gtid, StrenLevel]),
					mod_scene_agent:send_to_same_screen(PS#player.scene, PS#player.battle_attr#battle_attr.x, PS#player.battle_attr#battle_attr.y, BinData, 0);
				false -> skip
			end,
			NewPS
	end.

%% 
%% %% exports
%% %% desc: 获取场景中翅膀资源类型ID
%% get_wing_typeid(PS) ->
%%     [_, _, Wing, _] = PS#player_status.equip_current, % 武器，衣服，翅膀，时装
%%     goods_convert:get_opp_tid(Wing).
%% 
%% %% exports
%% %% desc: 获取场景中装备资源ID
%% get_scene_equip_icons(PS) when is_record(PS, player_status)->
%% 	get_scene_equip_icons([PS#player_status.career, PS#player_status.sex, PS#player_status.equip_current]);
%% get_scene_equip_icons([Career, Sex, Equip_current]) ->
%% 	[WQ, YF, E4, E3] = Equip_current, % 武器，衣服，翅膀，时装
%%     NewYF = get_equip_icon(scene, cloth, YF, Career, Sex),
%% 	NewGtid = goods_convert:get_goods_typeid(E4),
%% 	%NewE4 =	get_equip_icon(scene, wings, E4, Career, Sex),
%%     [WQ, NewYF, NewGtid, E3].
%% 
%% %% exports
%% %% desc: 获取战斗中装备资源ID
%% get_battle_equip_icons(PS) ->
%%     [WQ, YF, E4, _E3] = PS#player_status.equip_current, % 武器，衣服，时装，坐骑
%%     NewYF = get_equip_icon(battle, cloth, YF, PS),
%%     [WQ, NewYF, E4].
%% 
%% %% internal
%% %% desc: 根据装备的类型ID获取其对应的配置表图片资源ID
%% get_equip_icon(Type, Pos, GoodsTid, PS) ->
%% 	get_equip_icon(Type, Pos, GoodsTid, PS#player_status.career, PS#player_status.sex).
%% get_equip_icon(Type, Pos, GoodsTid, Career, Sex) ->
%% 	% 查看玩家服装资源，此时服装等全部是绑定的装备，所以这里需要转换一下匹配查询ID    
%% 	DefalutLv = 0,
%% 	case goods_convert:is_game_tid(GoodsTid) of
%% 		false ->
%% 			case Pos of
%% 				cloth ->
%% 					case data_chg_cloth:get_cloth(1, Career, Sex, DefalutLv) of
%% 						{} ->
%% 							0;
%% 						Info ->
%% 							case Type of
%% 								scene ->  Info#base_chg_cloth.scene_icon;
%% 								battle -> Info#base_chg_cloth.battle_icon
%% 							end
%% 					end;
%% 				wings ->
%% 					case data_chg_cloth:get_cloth(GoodsTid, Career, Sex, DefalutLv) of
%% 						{} ->
%% 							0;
%% 						Info ->
%% 							case Type of
%% 								scene ->  Info#base_chg_cloth.scene_icon;
%% 								battle -> Info#base_chg_cloth.battle_icon
%% 							end
%% 					end
%% 			end;
%% 		true ->
%% 			NewGtid = goods_convert:get_opp_tid(GoodsTid),
%% 			case data_chg_cloth:get_cloth(NewGtid, Career, Sex, DefalutLv) of
%% 				{} ->
%% 					case data_chg_cloth:get_cloth(1, Career, Sex, DefalutLv) of
%% 						{} ->
%% 							?ERROR_MSG("failed to get chg cloth record from cfg:~p", [{Type, GoodsTid}]),
%% 							0;
%% 							%Info = lib_common:get_ets_info(?BASE_CHG_CLOTH, #base_chg_cloth{key = {1, Career, Sex, DefalutLv}, _ = '_'}),
%% 							%Info#base_chg_cloth.scene_icon;
%% 						Info ->
%% 							case Type of
%% 								scene ->  Info#base_chg_cloth.scene_icon;
%% 								battle -> Info#base_chg_cloth.battle_icon
%% 							end
%% 					end;
%% 				Info ->
%% 					case Type of
%% 						scene ->  Info#base_chg_cloth.scene_icon;
%% 						battle -> Info#base_chg_cloth.battle_icon
%% 					end
%% 			end
%% 	end.
%% 
%% %% desc: 对装备进行强化
%% %% returns: #goods{} | skip
%% stren_equip_goods(PlayerId, GoodsInfo) when is_integer(PlayerId) ->
%%     case lib_player:get_online_info_fields(PlayerId, [goo_ets_id]) of
%%         [] -> skip;
%%         [Id] ->
%%             PS = #player_status{id = PlayerId, goo_ets_id = Id},   
%%             % 本次强化只会用到ps中的2个字段，所以这里直接取这两个字段值即可，
%%             % award类型不会主动通知成功消息，所以nickname字段也可以设置为空
%%             stren_equip_goods(PS, GoodsInfo)
%%     end;
%% stren_equip_goods(PS, GoodsInfo) ->
%%     stren_equip_goods(PS, GoodsInfo, GoodsInfo#goods.stren).
%% stren_equip_goods(PS, GoodsInfo, Stren) ->
%%     Degree = GoodsInfo#goods.stren_his,
%%     Info = GoodsInfo#goods{stren = Stren, stren_his = 0},
%%     casting_util:handle_stren_attri(PS, Info, GoodsInfo#goods.bind, Degree, award).
%%     
%% %% desc: 给与非邮件有强化等级的装备进行属性增加
%% add_bag_equip_stren_attr(GoodsInfo) ->
%%     case GoodsInfo#goods.stren > 0 andalso GoodsInfo#goods.location =/= ?LOCATION_MAIL andalso GoodsInfo#goods.type == ?GOODS_T_EQUIP of
%%         true ->   % 给与强化属性
%% 
%%             stren_equip_goods(GoodsInfo#goods.uid, GoodsInfo);
%%         false ->
%%             skip
%%     end.
%% 
%% %% ----------------------------------------------------------------
%% %% Local Fuctions
%% %% ----------------------------------------------------------------
%% %% internal
%% %% desc: 查看强化属性
%% %% returns: #base_attri{}
%% get_calc_stren_attri(GoodsInfo) ->
%%     case GoodsInfo#goods.stren > 0 of
%%         false -> lib_attribute:make_equip_base_attri_list(GoodsInfo);
%%         true ->  lib_attribute:get_stren_attr_base(GoodsInfo)
%%     end.
%% get_calc_stren_attri(PS, GoodsInfo) ->
%%     case GoodsInfo#goods.stren > 0 of
%%         false -> lib_attribute:make_equip_base_attri_list(GoodsInfo);
%%         true ->  lib_attribute:get_stren_attr_base(PS, GoodsInfo)
%%     end.
%% 
%% %% internal
%% %% desc: 计算装备自身属性的评分
%% %% returns: integer()
%% calc_total_base_grade(EquipLv, StrenAttri, WashAttri, InlayAttri, AddEattri) ->
%%     TotalBase = lists:foldl(fun lib_attribute:add_base_attri/2, #base_attri{}, StrenAttri ++ WashAttri ++ InlayAttri),
%% 	Key = trunc(EquipLv/10),
%% 	EquipScoreInfo = data_equip_score:get(Key),
%%     util:ceil(
%%       (TotalBase#base_attri.value_phy_att + AddEattri#base_attri.value_phy_att) * EquipScoreInfo#equip_score_attri.phy_att
%%       + (TotalBase#base_attri.value_mag_att + AddEattri#base_attri.value_mag_att) * EquipScoreInfo#equip_score_attri.mag_att
%% 	  + (TotalBase#base_attri.value_hp_lim + AddEattri#base_attri.value_hp_lim) * EquipScoreInfo#equip_score_attri.hp
%%       + (TotalBase#base_attri.value_phy_def + AddEattri#base_attri.value_phy_def) * EquipScoreInfo#equip_score_attri.phy_def
%%       + (TotalBase#base_attri.value_mag_def + AddEattri#base_attri.value_mag_def) * EquipScoreInfo#equip_score_attri.mag_def
%%       + (TotalBase#base_attri.value_crit + AddEattri#base_attri.value_crit) * EquipScoreInfo#equip_score_attri.crit
%%       + (TotalBase#base_attri.value_ten + AddEattri#base_attri.value_ten) * EquipScoreInfo#equip_score_attri.ten
%%       + (TotalBase#base_attri.value_dodge + AddEattri#base_attri.value_dodge) * EquipScoreInfo#equip_score_attri.dodge
%%       + (TotalBase#base_attri.value_hit + AddEattri#base_attri.value_hit) * EquipScoreInfo#equip_score_attri.hit
%%       + (TotalBase#base_attri.value_block + AddEattri#base_attri.value_block) * EquipScoreInfo#equip_score_attri.block
%%       + (TotalBase#base_attri.value_withs + AddEattri#base_attri.value_withs) * EquipScoreInfo#equip_score_attri.withs
%%       + (TotalBase#base_attri.value_fight_order_factor + AddEattri#base_attri.value_fight_order_factor) * EquipScoreInfo#equip_score_attri.fight_order_factor
%%       + (TotalBase#base_attri.value_spr_att + AddEattri#base_attri.value_spr_att) * EquipScoreInfo#equip_score_attri.spr_att
%%       + (TotalBase#base_attri.value_spr_def + AddEattri#base_attri.value_spr_def) * EquipScoreInfo#equip_score_attri.spr_def
%%       + (TotalBase#base_attri.value_pro_sword + AddEattri#base_attri.value_pro_sword) * EquipScoreInfo#equip_score_attri.pro_sword
%%       + (TotalBase#base_attri.value_pro_bow + AddEattri#base_attri.value_pro_bow) * EquipScoreInfo#equip_score_attri.pro_bow
%%       + (TotalBase#base_attri.value_pro_spear + AddEattri#base_attri.value_pro_spear) * EquipScoreInfo#equip_score_attri.pro_spear
%%       + (TotalBase#base_attri.value_pro_mag + AddEattri#base_attri.value_pro_mag) * EquipScoreInfo#equip_score_attri.pro_mag
%% 	  + (TotalBase#base_attri.value_resis_sword + AddEattri#base_attri.value_resis_sword) * EquipScoreInfo#equip_score_attri.resis_sword
%% 	  + (TotalBase#base_attri.value_resis_bow + AddEattri#base_attri.value_resis_bow) * EquipScoreInfo#equip_score_attri.resis_bow
%% 	  + (TotalBase#base_attri.value_resis_spear + AddEattri#base_attri.value_resis_spear) * EquipScoreInfo#equip_score_attri.resis_spear
%% 	  + (TotalBase#base_attri.value_resis_mag + AddEattri#base_attri.value_resis_mag) * EquipScoreInfo#equip_score_attri.resis_mag
%%             ). 
%%     
%% %% internal
%% %% desc: 计算开孔评分
%% get_holes_grade(GoodsInfo) ->
%%     BaseHoles = GoodsInfo#goods.hole,
%%     BaseHoles * 2.
%% 
%% %% internal
%% %% desc: 计算等级评分
%% get_suit_grade(GoodsInfo) ->
%%     case GoodsInfo#goods.suit_id > 0 of
%%         true -> 10;
%%         false -> 0
%%     end.
%% 
%% %% internal
%% %% desc: 检查装备是否有属性加成
%% %% returns: bool()
%% has_attribute(GoodsInfo) ->
%%     List = [GoodsInfo#goods.hole1_goods, GoodsInfo#goods.hole2_goods, GoodsInfo#goods.hole3_goods, GoodsInfo#goods.hole4_goods],
%%     Slist = lists:filter(fun(X) -> X > 0 end, List),
%%     case GoodsInfo#goods.type =:= ?GOODS_T_EQUIP of
%%         true when Slist =/= [] -> true;   % 有镶嵌属性
%%         true when GoodsInfo#goods.wash > 0 -> true;   % 有洗炼属性
%%         true when GoodsInfo#goods.stren > 0 -> true;   % 有强化属性
%%         true when GoodsInfo#goods.suit_id > 0 -> true;   % 有套装属性
%%         _ -> false
%%     end.
%% 
%% %% desc: 对装备评分进行
%% %% 对新装备和身上的同部位装备进行判断，提示更好的一件
%% count_equip_prompt_attri(GoodsTid, PS, MainPartner, VicePartner) when is_integer(GoodsTid) ->
%% 	case goods_util:get_bag_goods_list(PS#player_status.id, GoodsTid) of
%% 		[] ->
%% 			{fail, ?RESULT_FAIL};
%% 		List -> 
%% 			[GoodsInfo | _] = lib_goods:sort(List, id),
%% 			?TRACE("List:~p ~n GoodsInfo:~p ~n", [List, GoodsInfo]),
%% 			GoodsTypeInfo = lib_goods:get_goods_type_info(GoodsTid),
%% 	    	count_equip_prompt_attri(GoodsInfo, GoodsTypeInfo, PS, MainPartner, VicePartner)
%% 	end.
%% count_equip_prompt_attri(GoodsInfo, GoodsTypeInfo, PS, MainPartner, VicePartner) ->
%%     if
%%         is_record(GoodsTypeInfo, ets_goods_type) =:= false ->
%%             ?ERROR_MSG("bad goods_tid of GoodsTypeInfo:~p", [GoodsTypeInfo]),
%%             ?ASSERT(false),
%%             {fail, ?RESULT_FAIL};
%% 		is_record(GoodsInfo, goods) =:= false ->
%% 			?ERROR_MSG("bad goods_tid of GoodsInfo:~p", [GoodsInfo]),
%%             ?ASSERT(false),
%%             {fail, ?RESULT_FAIL};
%%         true ->
%%             [Type, Career] = [GoodsTypeInfo#ets_goods_type.type, GoodsTypeInfo#ets_goods_type.career], 
%%              if 
%% 				 Type =:= ?GOODS_T_EQUIP -> % 主角装备
%% 	                if
%% 						Career =/= PS#player_status.career
%% 		                    andalso Career =/= ?CAREER_ALL ->
%% 	                   		 {fail, 3};   % 职业不符
%% 		                true ->
%% 		                    compare_equip_attri(GoodsInfo, PS)
%% 					end;
%% 				 Type =:= ?GOODS_T_PAR_EQUIP -> % 武将装备
%% 		                compare_partner_equip_attri(GoodsInfo, PS, MainPartner, VicePartner, Career);
%% 				 true ->
%% 					 {fail, 2}   % 不是装备
%% 			 end
%%     end.
%% 
%% %% desc: 查询玩家身上进行对比的装备
%% get_compare_equip(Tinfo, PS) when is_record(Tinfo, ets_goods_type) ->
%%     Type = Tinfo#ets_goods_type.type,
%%     SubType = Tinfo#ets_goods_type.subtype,
%%     Pattern = #goods{type = Type, subtype = SubType, location = ?LOCATION_PLAYER, uid = PS#player_status.id, _ = '_'},
%%     lib_common:get_ets_info(?ETS_GOODS_ONLINE(PS), Pattern);
%% get_compare_equip(Ginfo, PS) when is_record(Ginfo, goods) ->
%%     Type = Ginfo#goods.type,
%%     SubType = Ginfo#goods.subtype,
%%     Pattern = #goods{type = Type, subtype = SubType, location = ?LOCATION_PLAYER, uid = PS#player_status.id, _ = '_'},
%%     lib_common:get_ets_info(?ETS_GOODS_ONLINE(PS), Pattern).
%% 
%% get_partner_equip(PartnerId, Ginfo, PS) when is_record(Ginfo, goods) ->
%%     Type = Ginfo#goods.type,
%%     SubType = Ginfo#goods.subtype,
%%     Pattern = #goods{type = Type, subtype = SubType, location = ?LOCATION_PARTNER, uid = PS#player_status.id, partner_id = PartnerId, _ = '_'},
%%     lib_common:get_ets_info(?ETS_GOODS_ONLINE(PS), Pattern).
%% 
%% %% desc: 比较两件装备的评分
%% compare_equip_attri(CompareGoodsInfo, PS) ->
%%     case get_compare_equip(CompareGoodsInfo, PS) of
%%         {} ->
%%             {ok, 0, CompareGoodsInfo#goods.id};
%%         BodyGoodsInfo ->
%% 			case BodyGoodsInfo#goods.score < CompareGoodsInfo#goods.score of
%% 	        	false ->
%% 	            	{fail, 5};% 新装备属性不比原装备高
%% 				true ->
%% 	                {ok, 0, CompareGoodsInfo#goods.id}
%% 			end
%%     end.
%% 
%% %% 对比武将装备
%% compare_partner_equip_attri(GoodsInfo, PS, MainPartner, VicePartner, Career) ->
%% 	ParList = case is_record(MainPartner, ets_partner) of
%% 				  true -> 
%% 					  MainPartner1 = case lib_goods:check_partner_equip_career(MainPartner#ets_partner.career, Career) of
%% 								  	 	true ->	[MainPartner];
%% 										false -> []
%% 									 end,
%% 					  case is_record(VicePartner, ets_partner) of 
%% 						  true ->
%% 							 VicePartner1 = case lib_goods:check_partner_equip_career(VicePartner#ets_partner.career, Career) of
%% 								  	 	true ->	[VicePartner];
%% 										false -> []
%% 									 end,
%% 							  MainPartner1 ++ VicePartner1;
%% 						  _ -> MainPartner1
%% 					  end;
%% 				  _ -> 
%% 					  case is_record(VicePartner, ets_partner) of 
%% 						   true ->
%% 								 case lib_goods:check_partner_equip_career(VicePartner#ets_partner.career, Career) of
%% 								  	 	true ->	[VicePartner];
%% 										false -> []
%% 								end;
%% 						   _ -> []
%% 					   end
%% 			  end,
%% 	compare_partner_equip_attri(GoodsInfo, PS, ParList).
%% 
%% compare_partner_equip_attri(_GoodsInfo, _PS, []) ->
%% 	{fail, 5};% 新装备属性不比原装备高
%% compare_partner_equip_attri(GoodsInfo, PS, [Partner|T]) ->
%% 	case get_partner_equip(Partner#ets_partner.id, GoodsInfo, PS) of
%% 			{} ->
%% 			   	{ok, Partner#ets_partner.id, GoodsInfo#goods.id};
%% 			BodyGoodsInfo ->
%% 				case BodyGoodsInfo#goods.score < GoodsInfo#goods.score of
%% 				    false ->
%% 				        compare_partner_equip_attri(GoodsInfo, PS, T);
%% 					true ->
%% 				        {ok, Partner#ets_partner.id, GoodsInfo#goods.id}
%% 			    end
%% 	end.
%% 
%% %% desc: 计算全身强化奖励件数
%% get_total_stren_reward([], {Num7, Num8, Num9, Num10, Num11, Num12}) ->
%%     Over7 = Num7 + Num8 + Num9 + Num10 + Num11 + Num12,
%%     Over8 = Num8 + Num9 + Num10 + Num11 + Num12,
%% 	Over9 = Num9 + Num10 + Num11 + Num12,
%% 	Over10 = Num10 + Num11 + Num12,
%% 	Over11 = Num11 + Num12,
%%     if
%%         Num7 > 0 andalso Over7 >= 8 -> {?STREN_TOTAL_REWARD_7, 8, Over8, Over9, Over10, Over11, Num12};
%%         Num8 > 0 andalso Over8 >= 8 -> {?STREN_TOTAL_REWARD_8, 8, 8, Over9, Over10, Over11, Num12};
%%         Num9 > 0 andalso Over9 >= 8 -> {?STREN_TOTAL_REWARD_9, 8, 8, 8, Over10, Over11, Num12};
%% 		Num10 > 0 andalso Over10 >= 8 -> {?STREN_TOTAL_REWARD_10, 8, 8, 8, 8, Over11, Num12};
%% 		Num11 > 0 andalso Over11 >= 8 -> {?STREN_TOTAL_REWARD_11, 8, 8, 8, 8, 8, Num12};
%% 		Num12 >= 8 -> {?STREN_TOTAL_REWARD_12, 8, 8, 8, 8, 8, 8};
%%         true ->
%%             {?STREN_TOTAL_REWARD_NONE, Over7, Over8, Over9, Over10, Over11, Num12}
%%     end;
%% get_total_stren_reward([Info | Tail], {Num7, Num8, Num9, Num10, Num11, Num12}) ->
%%     if
%%         Info#goods.stren =:= 7 andalso Info#goods.stren_his =:= ?MAX_STREN_DEGREE -> 
%% 			get_total_stren_reward(Tail, {Num7 + 1, Num8, Num9, Num10, Num11, Num12});
%%         Info#goods.stren =:= 8 andalso Info#goods.stren_his =:= ?MAX_STREN_DEGREE -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8 + 1, Num9, Num10, Num11, Num12});
%% 		Info#goods.stren =:= 8 -> 
%% 			get_total_stren_reward(Tail, {Num7 + 1, Num8, Num9, Num10, Num11, Num12});
%%         Info#goods.stren =:= 9 andalso Info#goods.stren_his =:= ?MAX_STREN_DEGREE -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9 + 1, Num10, Num11, Num12});
%% 		Info#goods.stren =:= 9 -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8 + 1, Num9, Num10, Num11, Num12});
%% 		Info#goods.stren =:= 10 andalso Info#goods.stren_his =:= ?MAX_STREN_DEGREE -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9, Num10 + 1, Num11, Num12});
%% 		Info#goods.stren =:= 10 -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9 + 1, Num10, Num11, Num12});
%% 		Info#goods.stren =:= 11 andalso Info#goods.stren_his =:= ?MAX_STREN_DEGREE ->
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9, Num10, Num11 + 1, Num12});
%% 		Info#goods.stren =:= 11 ->
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9, Num10 + 1, Num11, Num12});
%% 		Info#goods.stren >= 12 andalso Info#goods.stren_his =:= ?MAX_STREN_DEGREE -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9, Num10, Num11, Num12 + 1});
%% 		Info#goods.stren >= 12 -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9, Num10, Num11 + 1, Num12});
%%         true -> 
%% 			get_total_stren_reward(Tail, {Num7, Num8, Num9, Num10, Num11, Num12})
%%     end.
%% 
%% %% 获取玩家身上装备强化等级
%% get_role_equip_strenlv(PS) ->
%% 	{RewardType, _Num7, _Num8, _Num9, _Num10, _Num11, _Num12} = get_total_stren_reward({player, PS, PS#player_status.id}),
%% 	RewardType + ?STREN_BASE_REWARD.
%% 
%% %% 重新计算玩家身上装备强化等级
%% recalculate_all_equip_strenlv(PS, GoodsInfo, _OldGoodsInfo) ->
%% 	case GoodsInfo#goods.type =:= ?GOODS_T_EQUIP of
%% 		true -> 
%% 			%% 获取全身装备强化等级
%% 			RewardType =  lib_equip:get_role_equip_strenlv(PS),
%% 			if
%% 				PS#player_status.all_equip_strenlv =/= RewardType ->
%% 					{ok, BinData} = pt_12:write(12137, [PS#player_status.id, RewardType]),
%% 					lib_send:send_to_area_scene(PS#player_status.scene, PS#player_status.line_id, PS#player_status.x, PS#player_status.y, BinData),
%% 					PS#player_status{all_equip_strenlv = RewardType};
%% 				true ->
%% 					PS
%% 			end;
%% 		false -> PS
%% 	end.
%% recalculate_all_equip_strenlv(PS, GoodsInfo) ->
%% 	case GoodsInfo#goods.type =:= ?GOODS_T_EQUIP of
%% 		true -> 
%% 			if
%% 				PS#player_status.all_equip_strenlv >= 7 ->
%% 					{ok, BinData} = pt_12:write(12137, [PS#player_status.id, 0]),
%% 					lib_send:send_to_area_scene(PS#player_status.scene, PS#player_status.line_id, PS#player_status.x, PS#player_status.y, BinData);
%% 				true ->
%% 					skip
%% 			end,
%% 			PS#player_status{all_equip_strenlv = 0};
%% 		false -> PS
%% 	end.