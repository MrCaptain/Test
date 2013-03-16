%% Author: Administrator
%% Created: 2011-9-27
%% Description: TODO: Add description to db_agent_pet
-module(db_agent_pet).

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

%%%%% begin lib_pet

%% 加载初始灵兽信息
%% 系统启动后的加载
load_base_pet() ->
	?DB_MODULE:select_all(base_pet, 
								 "*", 
								 []).

load_base_calendar() ->
	?DB_MODULE:select_all(base_calendar, 
								 "*", 
								 []).
	

select_all_pet() ->
	?DB_MODULE:select_all(pet, 
								 "*", 
								 []).
	

%% 加载玩家所有的灵兽
select_player_all_pet(PlayerId) ->
	?DB_MODULE:select_all(pet, 
								 "*", 
								 [{uid, PlayerId}]).

%% 更新宠物升级属性
%% upgate_pet_attribute(Pet) ->
%% 	?DB_MODULE:update(pet,
%% 					  [{lv,Pet#pet.lv},
%% 					   {exp,Pet#pet.exp},
%% 					   {hp, Pet#pet.hp},
%% 					   {pwn, Pet#pet.pwn},
%% 					   {tcn, Pet#pet.tcn},
%% 					   {mgn, Pet#pet.mgn},
%% 					   {rela, Pet#pet.rela},
%% 					   {cell, Pet#pet.cell},
%% 					   {nick, Pet#pet.nick},
%% 					   {rnct, Pet#pet.rnct},
%% 					   {tlv1, Pet#pet.tlv1}, 
%% 					   {tlv2, Pet#pet.tlv2}, 
%% 					   {tlv3, Pet#pet.tlv3},
%% 					   {speed, Pet#pet.speed}
%% 					  ],
%% 					  [{id, Pet#pet.id}]
%% 					 ).

%% change_pet_data(Pet) ->
%% 	?DB_MODULE:update(pet,
%% 					  [{lv,Pet#pet.lv},
%% 					   {icon, Pet#pet.icon},
%% 					   {race, Pet#pet.race},
%% 					   {crr, Pet#pet.crr},
%% 					   {qly, Pet#pet.qly},
%% 					   {rela, Pet#pet.rela},
%% 					   {psta, Pet#pet.psta},
%% %% 					   {pwrb, Pet#pet.pwrb},
%% %% 					   {tecb, Pet#pet.tecb},
%% %% 					   {mgcb, Pet#pet.mgcb},
%% %% 					   {pwup, Pet#pet.pwup},
%% %% 					   {tcup, Pet#pet.tcup},
%% %% 					   {mgup, Pet#pet.mgup},
%% %% 					   {cter, Pet#pet.cter},
%% %% 					   {dcrit, Pet#pet.dcrit},
%% %% 					   {dblck, Pet#pet.dblck},
%% %% 					   {mnup, Pet#pet.mnup},
%% 					   {teid, Pet#pet.teid},				   
%% 					   {exp,Pet#pet.exp},
%% %% 					   {mxhp, Pet#pet.mxhp},
%% 					   {hp, Pet#pet.hp},
%% %% 					   {dbas, Pet#pet.dbas},
%% %%                        {abas, Pet#pet.abas},
%% %% 					   {pwr, Pet#pet.pwr},
%% %% 					   {tech, Pet#pet.tech},
%% %% 					   {mgc, Pet#pet.mgc},
%% 					   {pwn, Pet#pet.pwn},
%% 					   {tcn, Pet#pet.tcn},
%% 					   {mgn, Pet#pet.mgn},
%% %% 					   {apwr, Pet#pet.apwr},
%% %% 					   {atech, Pet#pet.atech},
%% %% 					   {amgc, Pet#pet.amgc},
%% %% 					   {dpwr, Pet#pet.dpwr},
%% %% 					   {dtech, Pet#pet.dtech},
%% %% 					   {dmgc, Pet#pet.dmgc},
%% %% 					   {ddge, Pet#pet.ddge},
%% %% 					   {crit, Pet#pet.crit},
%% %% 					   {blck, Pet#pet.blck},
%% %% 					   {hit, Pet#pet.hit},
%% %% 					   {mana, Pet#pet.mana},
%% 					   {cell, Pet#pet.cell},
%% 					   {nick, Pet#pet.nick},
%% 					   {rnct, Pet#pet.rnct},
%% 					   {tlid, Pet#pet.tlid},
%% 					   {tlid1, Pet#pet.tlid1},
%% 					   {ptid, Pet#pet.ptid}
%% 					  ],
%% 					  [{id, Pet#pet.id}]
%% 					 ).

%% change_pet_data2(Pet) ->
%% 		?DB_MODULE:update(pet,
%% 					  [{icon, Pet#pet.icon},
%% 					   {teid, Pet#pet.teid},				   
%% 					   {speed, Pet#pet.speed},
%% 					   {crr, Pet#pet.crr}
%% 					  ],
%% 					  [{id, Pet#pet.id}]
%% 					 ).	
%% 
%% %%生成灵兽添加默认值
%% create_pet(PlayerId, PetTypeInfo, TalentId, TalentId1, Cell, AptitudeSpeed) ->
%%  	Maxhp = data_pet:get_upgrade_maxhp(PetTypeInfo#ets_base_pet.crr, 1, PetTypeInfo#ets_base_pet.qly),
%%    	Speed = trunc((AptitudeSpeed / 100) * data_player:get_speed_by_lv_crr(PetTypeInfo#ets_base_pet.crr, 1)),
%% 	Other = #pet_other{
%% 	    mxhp = Maxhp,                               %% 最大生命	
%% 	
%%       	hit = PetTypeInfo#ets_base_pet.hit,                                %% 命中	
%%       	crit = PetTypeInfo#ets_base_pet.crit,                               %% 暴击	
%%       	dcrit = PetTypeInfo#ets_base_pet.dcrit,                              %% 防暴击	
%%       	ddge = PetTypeInfo#ets_base_pet.ddge,                               %% 闪避	
%%       	blck = PetTypeInfo#ets_base_pet.blck,                               %% 格挡	
%%       	dblck = PetTypeInfo#ets_base_pet.dblck,                              %% 破格挡	
%%       	cter = PetTypeInfo#ets_base_pet.cter,                               %% 反击	
%%       	mana = PetTypeInfo#ets_base_pet.mana,                               %% 气势	
%% 
%%       	dpwr = PetTypeInfo#ets_base_pet.dpwr,                               %% 内功防御	
%%       	dtech = PetTypeInfo#ets_base_pet.dtech,                              %% 技法防御	
%%       	dmgc = PetTypeInfo#ets_base_pet.dmgc,                               %% 法力防御	
%% 
%%       	apwr = PetTypeInfo#ets_base_pet.apwr,                               %% 内功攻击	
%%       	atech = PetTypeInfo#ets_base_pet.atech,                              %% 技法攻击	
%%       	amgc = PetTypeInfo#ets_base_pet.amgc,                                %% 法力攻击
%% 		speed = Speed     	
%% 	},
%% 	%% 初始化宠物基本信息
%% 	Pet = #pet{
%% 			   uid = PlayerId,
%% 			   tlid = TalentId,
%% 			   tlid1 = TalentId1,
%% 			   ptid = PetTypeInfo#ets_base_pet.ptid,
%% 			   icon = PetTypeInfo#ets_base_pet.icon,
%% 			   nick = PetTypeInfo#ets_base_pet.nick,
%% 			   race = PetTypeInfo#ets_base_pet.race,
%% 			   crr = PetTypeInfo#ets_base_pet.crr,
%% 			   qly = PetTypeInfo#ets_base_pet.qly,
%% 			   %% 临时默认值
%% 			   rela = 0,
%% 			   lv = 1,
%% 			   psta = 0,
%% 			   rnct = 0,
%% 			   exp = 0,
%% 			   hp = Maxhp,
%% 			   speed = AptitudeSpeed,
%% 
%% 			   pwn = 0,
%% 			   tcn = 0,
%% 			   mgn = 0,
%% 
%% 			   cell = Cell, 
%% 
%% 			   teid = PetTypeInfo#ets_base_pet.sklid,
%% 			   tlv1 = 1,
%% 			   tlv2 = 1,
%% 			   tlv3 = 1,
%% 			   other = Other
%% 			  },
%% 	
%% 	NewPet = data_pet:get_talent_value(Pet),
%% 	NewPet1 = NewPet#pet{hp = NewPet#pet.other#pet_other.mxhp, other = 0},
%%     ValueList = lists:nthtail(2, tuple_to_list(NewPet1)),
%%     [id | FieldList] = record_info(fields, pet),
%% 	Ret = ?DB_MODULE:insert(pet, FieldList, ValueList),
%% 	case ?DB_MODULE =:= db_mysql of
%% 		true ->
%%     		Ret;
%% 		_ ->
%% 			{mongo, Ret}
%% 	end.
%% 
%% %%获取新生成的灵兽
%% get_new_pet(PlayerId) ->
%% 	?DB_MODULE:select_row(pet,
%% 								 "*",
%% 								 [{uid,PlayerId}],
%% 								 [{id, desc}],
%% 								 [1]
%% 								).
%% 
%% %% 更新宠物位置
%% update_pet_cell(PetId, Cell) ->
%%   ?DB_MODULE:update(pet,
%% 					[{cell, Cell}],
%% 					[{id, PetId}]
%% 				   ).
%% 
%% 
%% %% 灵兽放生
%% free_pet(PetId) ->
%% 	?DB_MODULE:delete(pet, [{id, PetId}]).
%% 
%% %% 灵兽改名
%% rename_pet(PetId, PetName) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{nick, PetName},
%% 								  {rnct, 1, add}],
%% 								 [{id, PetId}]
%% 								).
%% 
%% pet_update_spar(PetId, Pwn, Tcn, Mgn) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{pwn, Pwn}, {tcn, Tcn}, {mgn, Mgn}],
%% 								 [{id, PetId}]
%% 								).
%% 	
%% pet_update_aptitude(PetId, Pwr, Tech, Mgc) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{pwr, Pwr}, {tech, Tech}, {mgc, Mgc}],
%% 								 [{id, PetId}]
%% 								).
%% %% 更新灵兽状态
%% pet_update_status(PetId,S) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{psta, S}],
%% 								 [{id, PetId}]
%% 								).
%% 
%% %% 更新宠物当前血量
%% pet_update_hp(PetId, Hp) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{hp, Hp}],
%% 								 [{id, PetId}]
%% 								).
%% 
%% %% 更新宠物亲密度
%% pet_update_rela(PetId, Rela) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{rela, Rela}],
%% 								 [{id, PetId}]
%% 								).
%% 
%% %% 更新宠物经验和等级
%% pet_update_exp(PetId, Exp, Level) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{exp, Exp}, {lv, Level}],
%% 								 [{id, PetId}]
%% 								).
%% 
%% %% %%宠物放生/洗炼日志
%% %% free_pet_log(Pet,Type)->
%% %% 	Timestamp = util:unixtime(),
%% %% 	?DB_LOG_MODULE:insert(log_free_pet,
%% %% 						  [uid, ptid, lv, qly, pwr, tech, mgc, pwn, tcn, mgn, tlid, tlid1, nick, timestamp, type],
%% %% 						  [Pet#pet.uid, Pet#pet.ptid, Pet#pet.lv, Pet#pet.qly, Pet#pet.pwr, Pet#pet.tech,
%% %% 						   Pet#pet.mgc, Pet#pet.pwn, Pet#pet.tcn, Pet#pet.mgn, Pet#pet.tlid, Pet#pet.tlid1,
%% %% 						   Pet#pet.nick, Timestamp, Type]).
%% %% 
%% %% %%宠物升级日志
%% %% upgrate_pet_log(Pet,Type)->
%% %% 	Timestamp = util:unixtime(),
%% %% 	?DB_LOG_MODULE:insert(log_upgrate_pet,
%% %% 						  [uid, peid, ptid, lv, exp, pwr, tech, mgc, pwn, tcn, mgn, tlid, tlid1, timestamp, type],
%% %% 						  [Pet#pet.uid, Pet#pet.id, Pet#pet.ptid, Pet#pet.lv, Pet#pet.exp, Pet#pet.pwr,
%% %% 						   Pet#pet.tech, Pet#pet.mgc, Pet#pet.pwn, Pet#pet.tcn, Pet#pet.mgn, Pet#pet.tlid,
%% %% 						   Pet#pet.tlid1, Timestamp, Type]).
%% 
%% %% 获取玩家的某个灵兽信息
%% select_player_petid(PetId) ->
%% 	?DB_MODULE:select_all(pet, 
%% 								 "*", 
%% 								 [{id, PetId}]).
%% 
%% %% 获取玩家的某个灵兽信息
%% select_player_pet_type(PlayerId, PetTypeId) ->
%% 	?DB_MODULE:select_all(pet, 
%% 								 "id", 
%% 								 [{uid, PlayerId}, {ptid, PetTypeId}]).
%% 
%% 
%% open_grid(PlayerId, Num) ->
%% 	?DB_MODULE:update(player,
%% 								 [{psn, Num, add}],
%% 								 [{id, PlayerId}]
%% 								).
%% 
%% %% 删除角色
%% lp_delete_role(PlayerId) ->
%% 	?DB_MODULE:delete(pet, [{uid, PlayerId}]).
%% %%%%% end
%% 
%% 
%% %% 设置玩家宠物跟随
%% set_player_outPet(Id, OutPet) ->
%% 	?DB_MODULE:update(player, [{opid, OutPet}], [{id, Id}]).
%% 
%% updata_pet_star(PetId, Star, Sch) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{star, Star},{sch, Sch}],
%% 								 [{id, PetId}]
%% 								).
%% 
%% updata_pet_talent_level(Pet) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{tlv1, Pet#pet.tlv1}, {tlv2, Pet#pet.tlv2}, {tlv3, Pet#pet.tlv3}],
%% 								 [{id, Pet#pet.id}]
%% 					 ).
%% 
%% 
%% updata_pet_talent(Pet) ->
%% 	?DB_MODULE:update(pet,
%% 								 [{tlid, Pet#pet.tlid}, {tlid1, Pet#pet.tlid1}, {tlid2, Pet#pet.tlid2}],
%% 								 [{id, Pet#pet.id}]
%% 					 ).
%% 	
%% 
%% updata_pet_speed(PetId, Speed) ->
%% 	?DB_MODULE:update(pet,
%% 					[{speed, Speed}],
%% 					[{id, PetId}]
%% 					 ).
%% 	
%% 
%% 
%% %%
%% %% Local Functions
%% %%
%% 
