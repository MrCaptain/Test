%%%--------------------------------------
%%% @Module  : lib_pet
%%% @Author  : csj
%%% @Created : 2011.11.22
%%% @Description : 宠物信息
%%%--------------------------------------
-module(lib_pet).
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl"). 
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).
%% 
%% 
%% %% 系统启动后的加载
%% %% 从数据库获取所有宠物基础信息
%% load_base_pet() ->
%%     BasePetList = db_agent_pet:load_base_pet(),
%%     lists:map(fun load_base_pet_into_ets/1, BasePetList),
%% 	ok.
%% 
%% %% 宠物基础信息存放到ETS表
%% load_base_pet_into_ets(PetInfo) ->
%%     BasePet =list_to_tuple([ets_base_pet]++PetInfo),
%%     ets:insert(?ETS_BASE_PET, BasePet).
%% 
%% %% 获取宠物基础信息
%% get_base_pet(PetTypeId) ->
%% 	%%io:format("get_base_pet:~p\n",[PetTypeId]),
%%     lookup_one(?ETS_BASE_PET, PetTypeId).
%% 
%% %% 系统启动后的加载
%% %% 从数据库获取所有宠物基础阴阳历
%% load_base_calendar() ->
%% 	BaseCalendar = db_agent_pet:load_base_calendar(),
%%     lists:map(fun load_base_calendar_into_ets/1, BaseCalendar),
%% 	ok.
%% 
%% %% 宠物基础阴阳历信息存放到ETS表
%% load_base_calendar_into_ets(Calendar) ->
%% 	BaseCalendar = list_to_tuple([ets_base_calendar]++Calendar),	
%% 	Cont = util:string_to_term(binary_to_list(BaseCalendar#ets_base_calendar.cont)),
%% 	BaseCalendar1 = BaseCalendar#ets_base_calendar{cont = Cont},
%% 	%%io:format("~s load_base_calendar_into_ets[~p] \n ",[misc:time_format(now()), [BaseCalendar1]]),
%%     ets:insert(?ETS_BASE_CALENDAR, BaseCalendar1).
%% 
%% %% 获取宠物基础阴阳历信息
%% get_base_calendar(Date) ->
%% 	%%io:format("get_base_pet:~p\n",[PetTypeId]),
%%     lookup_one(?ETS_BASE_CALENDAR, Date).
%% 
%% 
%% %% 登录后加载玩家自身的宠物
%% role_login(PlayerStatus) ->
%% 	%% 加载本周的阴阳历
%% 	int_pet_calendar(PlayerStatus),
%% 	
%%     %%加载灵兽
%% 	PetList = get_player_all_pets(PlayerStatus#player.id),
%% 	data_pet:set_rename_times(PlayerStatus#player.rnct),
%% 	
%% 	%% 初始化宠物融合
%% 	init_fusion_pet(),
%% 	%% 初始宠物跟随
%% 	init_out_pet(PlayerStatus, PetList).	
%% 
%% %% 获取玩家所有宠物信息 
%% get_player_all_pets(PlayerId) ->
%% 	PetList = get(player_pet),
%% 	if 
%% 		PetList =:= undefined ->
%% 			 %%get_pet_cover(PlayerId),
%% 			 
%% 			 PetList1 = db_agent_pet:select_player_all_pet(PlayerId),
%% 			 
%% 			 NewPetList = 
%% 				 lists:map(fun(PetInfo)-> 
%% 								   Pet = list_to_tuple([pet | PetInfo]),
%% 								   Pet1 = add_exp(Pet, Pet#pet.exp),
%% 								   ValueP = data_pet:change_upgrade_need(Pet1#pet.pwn, Pet1#pet.qly),
%% 								   ValueT = data_pet:change_upgrade_need(Pet1#pet.tcn , Pet1#pet.qly),
%% 								   ValueM = data_pet:change_upgrade_need(Pet1#pet.mgn , Pet1#pet.qly),
%% 								   %%db_agent_pet:pet_update_spar(Pet1#pet.id, ValueP, ValueT, ValueM)
%% 								   if 
%% 									   Pet1#pet.tlid =/= 0 andalso Pet1#pet.tlv1 =:= 0 ->
%% 										   L1 = 1 + Pet#pet.lv  div 10;
%% 									   true ->
%% 										   L1 = Pet1#pet.tlv1
%% 								   end,
%% 								   
%% 								   if 
%% 									   Pet1#pet.tlid1 =/= 0 andalso Pet1#pet.tlv2 =:= 0 ->
%% 										   L2 = 1 + Pet#pet.lv  div 10;
%% 									   true ->
%% 										   L2 = Pet1#pet.tlv2
%% 								   end,
%% 								   
%% 								   if 
%% 									   Pet1#pet.speed < 1 orelse Pet1#pet.speed > 4 ->
%% 										   AptitudeSpeed = data_pet:get_aptitude_speed(),
%% 										   db_agent_pet:updata_pet_speed(Pet1#pet.id, AptitudeSpeed);
%% 									   true ->
%% 										   AptitudeSpeed = Pet1#pet.speed
%% 								   end,
%% 								   
%% 								   Pet2 = Pet1#pet{pwn = ValueP, tcn = ValueT, mgn = ValueM, tlv1 = L1, tlv2 = L2, speed = AptitudeSpeed},
%% 						   									   
%% 								   if 
%% 									   Pet2#pet.lv > Pet#pet.lv ->
%% 										   UpLevel = Pet2#pet.lv - Pet#pet.lv,
%% 										   NewPet = upgate_pet_attribute(Pet2, UpLevel, 1);
%% 									   true ->
%% 										   NewPet = upgate_pet_attribute(Pet2, 0, 1)
%% 								   end,
%% 								   NewPet										   
%% 								   end,PetList1),
%% 			 
%% 			 put(player_pet, NewPetList),
%% 			 NewPetList;		
%% 		true ->
%% 			
%% 			PetList
%% 	end.
%% 
%% %%获取下线玩家的出战宠物
%% get_act_pet_offline(PlayerId) ->
%% %% 	io:format("get_act_pet_offline~n"),
%% 	PetList = db_agent_pet:select_player_all_pet(PlayerId),				%% 从数据库中查询该玩家所有宠物
%% 	PetList1 = change_pet_data(PetList),			
%% 	
%% 	ActPetIdList = lib_formation:getActPetIdList_offline(PlayerId),		%% 离线获得玩家出战的宠物ID列表
%% 	case ActPetIdList of
%% 		[] -> 
%% 			[];
%% 		_ ->
%% 			ActPetList = [Pet || Pet <- PetList1, lists:member(Pet#pet.id, ActPetIdList)],
%% 			ActPetList
%% 	end.
%% %% 	[Pet || Pet <- PetList1, Pet#pet.psta =:=0].%%出战的宠物
%% 	
%% 
%% %%打包玩家宠物列表信息, 打包成41022数据包, 供玩家进程内玩家下线时保存下线宠物信息使用
%% get_my_pet_list_info(Status) ->
%% 	 PetList = lib_pet:get_stock_pet(Status#player.id),
%% 	 lists:map(fun(Pet)-> pt_41:parse_pet_info(Pet) end,PetList).
%%   
%% %%转换宠物数据
%% change_pet_data(PetList) ->
%% 	NewPetList = 
%% 		lists:map(fun(PetInfo)-> 
%% 						  Pet = list_to_tuple([pet | PetInfo]),
%% 						  Pet1 = add_exp(Pet, Pet#pet.exp),	
%% 						  
%% 						  ValueP = data_pet:change_upgrade_need(Pet1#pet.pwn, Pet1#pet.qly),
%% 						  ValueT = data_pet:change_upgrade_need(Pet1#pet.tcn , Pet1#pet.qly),
%% 						  ValueM = data_pet:change_upgrade_need(Pet1#pet.mgn , Pet1#pet.qly),								  
%% 						  if
%% 							  Pet1#pet.tlid =/= 0 andalso Pet1#pet.tlv1 =:= 0 ->
%% 								  L1 = 1 + Pet#pet.lv  div 10;
%% 							  true ->
%% 								  L1 = Pet1#pet.tlv1
%% 						  end,
%% 								   
%% 						  if
%% 							  Pet1#pet.tlid1 =/= 0 andalso Pet1#pet.tlv2 =:= 0 ->
%% 								  L2 = 1 + Pet#pet.lv  div 10;
%% 							  true ->
%% 								  L2 = Pet1#pet.tlv2
%% 						  end,
%% 						  
%% 						  Pet2 = Pet1#pet{pwn = ValueP, tcn = ValueT, mgn = ValueM, tlv1 = L1, tlv2 = L2},
%% 						  								   
%% 						  if 
%% 							  Pet2#pet.lv > Pet#pet.lv ->
%% 								  UpLevel = Pet2#pet.lv - Pet#pet.lv,
%% 								  NewPet = upgate_pet_attribute(Pet2, UpLevel, 1);
%% 							  true ->
%% 								  NewPet = upgate_pet_attribute(Pet2, 0, 1)
%% 						  end,
%% 						  NewPet										   
%% 				  end,PetList),
%% 	NewPetList.
%% 
%% %% 获取玩家宠物个数 
%% get_pet_count(PlayerId) ->
%%     length(get_player_all_pets(PlayerId)).
%% 
%% %% 获取玩家某只宠物
%% get_own_pet(PlayerId, PetId) -> 
%% 	PetList = get_player_all_pets(PlayerId),
%% 	NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PetId],
%% 	if NewPetList =:= [] -> [];
%% 	   true -> lists:nth(1, NewPetList)
%% 	end.
%% 
%% get_pet_by_type(PlayerId, PetTypeId) ->	
%% 	PetList = get_player_all_pets(PlayerId),
%% 	NewPetList = [Pet || Pet <- PetList, Pet#pet.ptid =:= PetTypeId],
%% 	NewPetList.	
%% 
%% delete_own_pet(PlayerId, PetId) -> 
%% 	PetList = get_player_all_pets(PlayerId),
%% 	NewPetList = [Pet || Pet <- PetList, Pet#pet.id =/= PetId],
%% 	put(player_pet, NewPetList),
%% 	ok.
%% 
%% init_pet(PlayerId, PetTypeInfo, TalentId, TalentId1, Cell, Id, AptitudeSpeed) ->
%% 	Maxhp = data_pet:get_upgrade_maxhp(PetTypeInfo#ets_base_pet.crr, 1, PetTypeInfo#ets_base_pet.qly),
%%     [BaseAttack, BaseDefense] =  data_pet:get_base_attack_defense(PetTypeInfo#ets_base_pet.crr, 1),
%% 	Speed = trunc((AptitudeSpeed / 100) * data_player:get_speed_by_lv_crr(PetTypeInfo#ets_base_pet.crr, 1)),
%% 	Other = #pet_other{
%% 	    mxhp = Maxhp,                               %% 最大生命	
%% 		pwrb = PetTypeInfo#ets_base_pet.pwr,                               %% 功内基础值
%% 		tecb = PetTypeInfo#ets_base_pet.tech,                               %% 技法基础值
%% 		mgcb = PetTypeInfo#ets_base_pet.mgc,                               %% 法力基础值
%% 		pwr = PetTypeInfo#ets_base_pet.pwr,                                %% 内功	
%% 		tech = PetTypeInfo#ets_base_pet.tech,                               %% 技法
%% 		mgc = PetTypeInfo#ets_base_pet.mgc,                                %% 法力
%% 		pwup = PetTypeInfo#ets_base_pet.pwup,                               %% 内功成长值	
%%       	tcup = PetTypeInfo#ets_base_pet.tcup,                               %% 技法成长值	
%%       	mgup = PetTypeInfo#ets_base_pet.mgup,                               %% 法力成长值	
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
%%       	dbas = BaseDefense,                               %% 基础防御	
%%       	dpwr = PetTypeInfo#ets_base_pet.dpwr,                               %% 内功防御	
%%       	dtech = PetTypeInfo#ets_base_pet.dtech,                              %% 技法防御	
%%       	dmgc = PetTypeInfo#ets_base_pet.dmgc,                               %% 法力防御	
%%       	abas = BaseAttack,                               %% 基础攻击	
%%       	apwr = PetTypeInfo#ets_base_pet.apwr,                               %% 内功攻击	
%%       	atech = PetTypeInfo#ets_base_pet.atech,                              %% 技法攻击	
%%       	amgc = PetTypeInfo#ets_base_pet.amgc,                                %% 法力攻击
%% 		speed = Speed     	
%% 	},
%% 	Pet = #pet{
%% 			   id = Id,
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
%% 			   pwn = 0,
%% 			   tcn = 0,
%% 			   mgn = 0,
%% 			   speed = AptitudeSpeed,
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
%% 	NewPet1 = NewPet#pet{hp = Pet#pet.other#pet_other.mxhp},
%% 	NewPet1.	
%% 
%% %% 更新宠物信息，只更新进程字典数据
%% %% 如要更新数据库请调用db_agent相关函数
%% update_own_pet(Pet) ->
%% 	PetList = get_player_all_pets(Pet#pet.uid),
%% 	NewPetList = [Pet1 || Pet1 <- PetList, Pet1#pet.id =/= Pet#pet.id],	
%% 	put(player_pet, [Pet | NewPetList]),
%% 	ok.	
%% 
%% %%　更新宠物当前血量
%% update_pet_hp(PetId, Hp) ->
%% 	PetList = get(player_pet),
%% 	%%io:format("~s update_pet_hp[~p] \n ",[misc:time_format(now()), [PetId, Hp, PetList]]),
%% 	if  
%% 		PetList =:= undefined -> {fail, 2}; %% 没有设置进程字典
%% 		true ->
%% 			NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PetId],
%% 			%%io:format("~s update_pet_hp1[~p] \n ",[misc:time_format(now()), [NewPetList]]),
%% 			if NewPetList =:= [] -> {fail, 3}; %% 宠物不存在
%% 			   true -> 
%% 				   PetInfo = lists:nth(1, NewPetList),
%% %% 				   io:format("~s update_pet_hp2[~p] \n ",[misc:time_format(now()), [PetInfo]]),
%% 				   if Hp > PetInfo#pet.other#pet_other.mxhp ->
%% 						  NewHp = PetInfo#pet.other#pet_other.mxhp;
%% 					  true ->
%% 						  NewHp = Hp
%% 				   end,
%% 				   
%% 				   NewPet = PetInfo#pet{hp = NewHp},
%% 				   OtherPetList = [Pet1 || Pet1 <- PetList, Pet1#pet.id =/= PetId],
%% 				   NewPetList1 = [NewPet | OtherPetList],
%% 				   put(player_pet, NewPetList1),
%% 				   
%% 				   ok
%% 			end			   
%% 	end.
%% 
%% %%　更新宠物亲密度
%% update_pet_rela(PetId, Rela) ->
%% 	PetList = get(player_pet),
%% 	if  
%% 		PetList =:= undefined -> {fail, 2}; %% 没有设置进程字典
%% 		true ->
%% 			NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PetId],
%% 			if NewPetList =:= [] -> {fail, 3}; %% 宠物不存在
%% 			   true -> 
%% 				   PetInfo = lists:nth(1, NewPetList),
%% 				   NewPet = PetInfo#pet{rela = Rela},
%% 				   OtherPetList = [Pet1 || Pet1 <- PetList, Pet1#pet.id =/= PetId],
%% 				   NewPetList1 = [NewPet | OtherPetList],
%% 				   put(player_pet, NewPetList1),
%% 				   %% 屏蔽，同一写，减少写数据库操作
%% %% 				   db_agent_pet:pet_update_rela(PetId, Rela),			   
%% 				   
%% 				   ok
%% 			end			   
%% 	end.
%% 
%% %% 宠物升级，更新属性
%% upgate_pet_attribute(Pet, Upgate, Becal) ->
%% 	%% 更新宠物属性
%% 	Maxhp_1 = data_pet:get_upgrade_maxhp(Pet#pet.crr, Pet#pet.lv, Pet#pet.qly),	
%% 	
%% 	[BaseAttack, BaseDefense] =  data_pet:get_base_attack_defense(Pet#pet.crr, Pet#pet.lv),
%% 
%% 	PetTypeInfo = get_base_pet(Pet#pet.ptid), 	
%% 	
%% 	Pwr2 = (PetTypeInfo#ets_base_pet.pwup * (Pet#pet.lv - 1)) div 10,
%% 	Tech2 = (PetTypeInfo#ets_base_pet.tcup * (Pet#pet.lv - 1)) div 10,
%% 	Mgc2 = (PetTypeInfo#ets_base_pet.mgup * (Pet#pet.lv - 1)) div 10,
%% 	
%% 	%% 晶石附加数值
%% 	ValueP = data_pet:get_total_aptitude(Pet#pet.pwn , Pet#pet.qly),
%% 	ValueT = data_pet:get_total_aptitude(Pet#pet.tcn , Pet#pet.qly),
%% 	ValueM = data_pet:get_total_aptitude(Pet#pet.mgn , Pet#pet.qly),
%% 	
%% 	%% 强化属性
%% 	[Addpwr, Addmgc, Addtech, AddMxhp] = data_pet:add_strengthen_attribute(Pet#pet.star, Pet#pet.qly),
%% 	
%% 	Maxhp = Maxhp_1 + AddMxhp,
%% 	Pwr = PetTypeInfo#ets_base_pet.pwr + Pwr2 + ValueP + Addpwr,
%% 	Tech = PetTypeInfo#ets_base_pet.tech + Tech2 + ValueT + Addtech,
%% 	Mgc = PetTypeInfo#ets_base_pet.mgc + Mgc2 + ValueM + Addmgc,
%% 	
%% 	Apwr = round(1.5*Pwr),
%% 	Atech = round(1.5 * Tech),
%% 	Amgc = round(1.5 * Mgc),
%% 	
%% 	Dpwr = round(1 * Pwr),
%% 	Dtech = round(1 * Tech),
%% 	Dmgc = round(1 * Mgc),
%% 	
%% 	%% 宠物自身成长速度
%% 	Speed = data_player:get_speed_by_lv_crr(Pet#pet.crr, Pet#pet.lv),
%% 	
%% 	Other = #pet_other{
%% 	    mxhp = Maxhp,                               %% 最大生命	
%% 		pwr = Pwr,                                %% 内功	
%% 		tech = Tech,                               %% 技法
%% 		mgc = Mgc,                                %% 法力
%% 
%%       	dbas = BaseDefense,                               %% 基础防御	
%%       	dpwr = Dpwr,                               %% 内功防御	
%%       	dtech = Dtech,                              %% 技法防御	
%%       	dmgc = Dmgc,                               %% 法力防御	
%%       	abas = BaseAttack,                               %% 基础攻击	
%%       	apwr = Apwr,                               %% 内功攻击	
%%       	atech = Atech,                              %% 技法攻击	
%%       	amgc = Amgc,                                %% 法力攻击
%% 		ddge = PetTypeInfo#ets_base_pet.ddge,
%% 		crit = PetTypeInfo#ets_base_pet.crit,
%% 		blck = PetTypeInfo#ets_base_pet.blck,
%% 		hit = PetTypeInfo#ets_base_pet.hit,
%% 		mana = PetTypeInfo#ets_base_pet.mana,
%% 		speed = Speed,
%% 				
%% 		mnup = PetTypeInfo#ets_base_pet.mnup,
%% 		pwrb = PetTypeInfo#ets_base_pet.pwr,
%% 	    tecb = PetTypeInfo#ets_base_pet.tech,
%% 		mgcb = PetTypeInfo#ets_base_pet.mgc,
%%  	    pwup = PetTypeInfo#ets_base_pet.pwup,
%% 		tcup = PetTypeInfo#ets_base_pet.tcup,
%% 		mgup = PetTypeInfo#ets_base_pet.mgup     	
%% 	},	
%% 	
%% 	NewPet1 = Pet#pet{other = Other},
%% 	
%% 	%% 更新天赋数值
%% %%  	io:format("~s upgate_pet_attribute1 ~p \n ",[misc:time_format(now()), NewPet1#pet.other#pet_other.mana]),
%% 	NewPet2 = data_pet:get_talent_value(NewPet1),
%% %%  	io:format("~s upgate_pet_attribute2 ~p \n ",[misc:time_format(now()), NewPet2#pet.other#pet_other.mana]),
%% 	NewPet3_1 = lib_theurgy:getPetThrAtr(NewPet2),
%%  	%io:format("~s upgate_pet_attribute3 ~p \n ",[misc:time_format(now()), NewPet3#pet.mana]),
%% 	
%% 	%% 附加元魂系统属性
%% 	NewPet3_2 = lib_soul:count_pet_soul(NewPet3_1),
%% 	
%% 	NewPet3_3 = lib_guild:update_pet_attr(NewPet3_2),
%% 	
%% 	%%附加龙鞍培养属性
%% 	NewPet3 = lib_saddle:update_pet_attr(NewPet3_3),	
%% 	
%% 	%% 附加阴阳历属性
%% 	if 
%% 		Becal =:= 0 ->
%% 			NewPet4 = NewPet3;
%% 		true ->
%% 			NewPet4 = get_calendar_value(NewPet3)
%% 	end,
%% 	
%%  	%%io:format("~s upgate_pet_attribute4 ~p \n ",[misc:time_format(now()), NewPet4#pet.mana]),
%% 	
%% 	%%lib_theurgy:getPetThrAtr(Player, Pet)
%% 	
%% 	%%法器
%% 	NewPet5 = lib_frmt_equip:frmt_att_pet(NewPet4) ,
%% 	
%% 	
%% 	%% 五行珠
%% 	NewPet6 = lib_bead:add_pet_attribute(NewPet5) ,
%% 	case Upgate of
%% 		0 -> 
%% 			if 
%% 				Pet#pet.hp > NewPet6#pet.other#pet_other.mxhp ->
%% 					Hp = NewPet6#pet.other#pet_other.mxhp;
%% 				true ->
%% 					Hp = Pet#pet.hp
%% 			end;
%% 		_ -> Hp = NewPet6#pet.other#pet_other.mxhp
%% 	end,
%% 	
%% 	%% 增加速度资质倍数
%% 	SpeedMultiple = data_pet:get_speed_multiple(Pet#pet.speed),
%% 	NewSpeed = trunc(SpeedMultiple * NewPet6#pet.other#pet_other.speed),	
%% 	NewOther1 = NewPet6#pet.other,
%% 	NewOther =  NewOther1#pet_other{speed = NewSpeed},	
%% 	NewPet7 = NewPet6#pet{hp = Hp,  other =  NewOther},
%% 
%% 	%% 	io:format("~s upgate_pet_attribute4 ~p \n ",[misc:time_format(now()), NewPet7#pet.other#pet_other.speed]),
%% 	
%% 	if 
%% 		Upgate > 0 ->
%% 			%% 这里更新数据库
%% 			db_agent_pet:upgate_pet_attribute(NewPet7);
%% 		true ->
%% 			ok
%% 	end,
%% 	
%% 	NewPet7.
%% 
%% %%获取出战宠物数量
%% get_act_pets_num(PlayerId) ->
%% 	ActPetIdList = lib_formation:getActPet(),
%% 	case ActPetIdList of
%% 		[] -> 0;
%% 		_ -> length(ActPetIdList)
%% 	end.
%% 
%% get_act_pets(PlayerId) ->
%% 	ActPetIdList = lib_formation:getActPet(),
%% 	case ActPetIdList of
%% 		[] -> [];
%% 		_ ->
%% 			PetList = get_player_all_pets(PlayerId),
%% 			ActPetList = [Pet || Pet <- PetList, lists:member(Pet#pet.id, ActPetIdList)],
%% 			ActPetList
%% 	end.
%% 
%% add_exp_to_fight(Status, Exp) ->
%% 	ActPetIdList = lib_formation:getActPet(),
%% 	case ActPetIdList of
%% 		[] -> skip;
%% 		_ ->
%% 			%%io:format("~s add_exp_to_fight[~p/~p] \n ",[misc:time_format(now()), Exp, ActPetIdList]),
%% 			Fun = fun(PetId) ->
%% 						  add_pet_exp(Status, PetId, Exp)
%% 				  end,
%% 			
%% 			lists:foreach(Fun, ActPetIdList)
%% 	end.
%% 	
%% 
%% %%刷新宠物数据
%% refresh_all_pet() ->
%% 	case get(player_pet) of
%% 		NullVal when (NullVal =:= [] orelse NullVal =:= undefined) ->
%% 			skip;
%% 		PetList ->
%% 			Fun = fun(Pet) ->
%% 						  lib_pet:upgate_pet_attribute(Pet, 0, 1)
%% 				  end,
%% 			NewPetList = lists:map(Fun, PetList),
%% 			put(player_pet, NewPetList)
%% 	end.
%% 
%% 
%% 
%% %% 增加宠物经验
%% add_pet_exp(Status, PetId, Exp) ->
%% 	%%io:format("~s add_pet_exp[~p/~p] \n ",[misc:time_format(now()), Exp, PetId]),
%% 	PetList = get(player_pet),
%% 	if  
%% 		PetList =:= undefined -> {fail, 2}; %% 没有设置进程字典
%% 		true ->
%% 			NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PetId],
%% 			if NewPetList =:= [] -> {fail, 3}; %% 宠物不存在
%% 			   true -> 
%% 				   PetInfo = lists:nth(1, NewPetList),
%% 				   NewExp = PetInfo#pet.exp +Exp,
%% 				   NewPet = add_exp(PetInfo, NewExp),				   
%% 				   
%% 				   %%io:format("~s add_pet_exp1[~p/~p] \n ",[misc:time_format(now()), E, NewExp]),				
%% 				   if
%% 					   NewPet#pet.lv > PetInfo#pet.lv -> 
%% 						   %% 宠物升级						   
%% 						   State = 1,
%% 						   UpLevel = NewPet#pet.lv - PetInfo#pet.lv,
%% 						   NewPet1 = upgate_pet_attribute(NewPet, UpLevel, 1),
%% 						   
%% 						   %%长生目标
%% 						   lib_target:target(pet_lv,NewPet#pet.lv),
%% 						   
%% 						   
%% 						   %%20级以后宠物升级日志
%% 						   if 
%% 							   NewPet#pet.lv >= 20 ->
%% 								   spawn(fun()->catch(db_log_agent:upgrate_pet_log(NewPet, 0))end);
%% 							   true -> 
%% 								   skip
%% 						   end;
%% 					   true ->
%% 						   State = 0,
%% 						   NewPet1 = NewPet
%% 				   end,
%% 				    
%% 				   OtherPetList = [Pet1 || Pet1 <- PetList, Pet1#pet.id =/= PetId],
%% 				   NewPetList1 = [NewPet1 | OtherPetList],
%% 				   put(player_pet, NewPetList1),
%% 				   
%% 				   if
%% 					   State =:=1 -> %% 升级了！！！
%% 						   %% 通知玩家宠物升级了
%% 						   {ok, BinData} = pt_41:write(41013, [NewPet1#pet.id, NewPet1#pet.tlid, NewPet1#pet.tlid1, NewPet1#pet.nick, PetInfo#pet.lv, NewPet1#pet.lv]),
%% 						   lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 						   
%% 						   %% 清空宠物缓存经验
%% 						   clear_cache_pet_exp(PetId),
%% 						   ok;
%% 					   true ->
%% 						   CacheExp = add_cache_pet_exp(PetId, Exp),
%% 						   if 
%% 							   CacheExp >= 10000 ->
%% 								   %% 这里更新数据库
%% 								   db_agent_pet:upgate_pet_attribute(NewPet1),
%% 								   clear_cache_pet_exp(PetId);
%% 							   true ->
%% 								   ok
%% 						   end
%% 				   end				   
%% 			       %%db_agent_pet:pet_update_exp(PetId, NewPet1#pet.exp, NewPet1#pet.lv)
%% 			end			   
%% 	end.
%% 
%% 
%% %% %% 增加宠物经验(递归)
%% add_exp(Pet, Exp) ->
%%     %%增加灵力
%%     NextLvExp = data_player:get_up_exp(Pet#pet.lv),	
%%     if
%% 		Pet#pet.lv >= 70 ->
%% 			if Exp >= NextLvExp ->
%% 				   Exp1 = NextLvExp;
%% 			   true ->
%% 				   Exp1 = Exp
%% 			end,
%% 			NewPet = Pet#pet{exp = Exp1},
%% 			NewPet;
%% 		NextLvExp > Exp ->
%% 			NewPet = Pet#pet{exp = Exp},
%% 			NewPet;
%% 		true ->           
%% 			%% 临时处理
%% 			NewPet1 = Pet#pet{lv = Pet#pet.lv + 1, exp = Exp - NextLvExp},
%% 			%%NewPet2 = upgate_pet_attribute(NewPet1, 1),
%% 			
%% 			add_exp(NewPet1, NewPet1#pet.exp)
%% 	end.
%% 
%% %% 宠物跟随
%% %% PetId 宠物动态id， Opt 0禁用，1启用
%% out_pet(PlayerStatus, PetId, Opt) ->
%% 	PetList = get(player_pet),
%% 	if
%% 		Opt =:= 0 andalso PlayerStatus#player.opid =:= 0 ->
%% 			{PlayerStatus, 2}; %%已经禁用
%% 		Opt =:= 1 andalso PlayerStatus#player.opid =:= PetId ->
%% 			{PlayerStatus, 3}; %%已经启用
%% 		PetList =:= undefined -> 
%% 			{PlayerStatus, 4}; %%宠物不存在
%% 		PlayerStatus#player.viplv < 3 ->
%% 			{PlayerStatus, 5}; %%Vip等级不足
%% 		true ->
%% 			NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PetId],
%% 			if 
%% 				NewPetList =:= [] -> 
%% 					{PlayerStatus, 4}; %% 宠物不存在
%% 				true ->	
%% 					PetInfo = lists:nth(1, NewPetList),
%% 					case Opt of
%% 						0 ->
%% 							NewPlayerStatus = PlayerStatus#player{opid = 0,
%% 																  other = PlayerStatus#player.other#player_other{out_pet_type_id = 0,
%% 																										   out_pet_name = undefined}
%% 																 },
%% 
%% 							{ok, BinData} = pt_41:write(41017, [NewPlayerStatus#player.id]);
%% 						_ ->
%% 							BinPetName = tool:to_binary(PetInfo#pet.nick),
%% 							PetIcon = PetInfo#pet.icon * 10 + PetInfo#pet.qly,
%% 							NewPlayerStatus = PlayerStatus#player{opid = PetId,
%% 																  other = PlayerStatus#player.other#player_other{out_pet_type_id = PetIcon,
%% 																										   out_pet_name = BinPetName}
%% 																 },
%% %% 							io:format("BinPetName:[~p]\n",[[BinPetName]]),
%% 							{ok, BinData} = pt_41:write(41016, [NewPlayerStatus#player.id, BinPetName, PetIcon])
%% 					end,
%% 					db_agent_pet:set_player_outPet(NewPlayerStatus#player.id, NewPlayerStatus#player.opid),
%% 					lib_player:send_player_attribute(NewPlayerStatus, 4),
%% %% 					lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData),
%% 					mod_scene_agent:send_to_scene(NewPlayerStatus#player.scn, BinData),
%% 					%%io:format("send_to_scene:[~p]\n",[[1]]),
%% 					{NewPlayerStatus, 1}
%% 			end
%% 	end.
%% 
%% init_out_pet(PlayerStatus, PetList) ->
%% 	if
%% 		PlayerStatus#player.opid =/= 0 ->
%% 			NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PlayerStatus#player.opid],
%% 			if
%% 				NewPetList =:= [] ->
%% 					PlayerStatus#player{opid = 0};
%% %% 				PlayerStatus#player.viplv < 3 andalso PlayerStatus#player.opid =/= 0 ->
%% %% 					db_agent_pet:set_player_outPet(PlayerStatus#player.id, 0),
%% %% 					PlayerStatus#player{opid = 0};									   
%% 				true ->
%% 					PetInfo = lists:nth(1, NewPetList),
%% 					BinPetName = tool:to_binary(PetInfo#pet.nick),
%% 					PetIcon = PetInfo#pet.icon * 10 + PetInfo#pet.qly,
%% 					PlayerStatus#player{other = PlayerStatus#player.other#player_other{out_pet_type_id = PetIcon,
%% 																					   out_pet_name = BinPetName}
%% 																 }
%% 			end;
%% 		true ->
%% 			PlayerStatus
%% 	end.
%% 
%% %% %%=========================================================================
%% %% %% 业务操作函数
%% %% %%=========================================================================
%% %% 
%% 
%% check_use_cell(Status) ->
%% 	 PetList1 = db_agent_pet:select_player_all_pet(Status#player.id),
%% 			 
%% 	 StockList = 
%% 				 lists:map(fun(PetInfo)-> 
%% 								   Pet = list_to_tuple([pet | PetInfo]),
%% 								   Pet1 = add_exp(Pet, Pet#pet.exp),							   									   
%% 									   
%% 								   if 
%% 									   Pet1#pet.lv > Pet#pet.lv ->
%% 										   UpLevel = Pet1#pet.lv - Pet#pet.lv,
%% 										   NewPet = upgate_pet_attribute(Pet1, UpLevel, 1);
%% 									   true ->
%% 										   NewPet = upgate_pet_attribute(Pet1, 0, 1)
%% 								   end,
%% 								   NewPet										   
%% 								   end,PetList1),
%% 
%% 	Cell = select_use_cell(StockList, Status#player.psn),
%% 
%% 	if 
%% 		Cell =< 0 orelse Cell > Status#player.psn ->
%% 			0; %% 宠物格子不正确
%% 		true ->
%% 			1
%% 	end.	
%% 	
%% %% 查询可放置的仓库格子
%% select_use_cell(StockList, MaxNum) ->
%% 	CellList = [Pet#pet.cell || Pet <- StockList],
%% 	lists:sort(CellList),
%% 	AllCell = lists:seq(1, MaxNum),
%% 
%% 	RestCell = [Cell || Cell <- AllCell, lists:member(Cell, CellList) =:= false],
%% 
%% 	Number = length(RestCell),
%% 	if 
%% 		Number =:= 0 -> 0;
%% 		true -> lists:min(RestCell)
%% 	end.	
%% 	
%% %% %%生成灵兽
%% create_pet(Status,[PetTypeId, TalentId, TalentId1, BeCell, BeLog]) ->	
%% 	PetTypeInfo = get_base_pet(PetTypeId),
%% 	StockList = get_stock_pet(Status#player.id),
%% 	PetCount = length(StockList),
%% 	case BeCell of
%% 		0 ->
%% 			Cell = 0;
%% 		_ ->
%% 			Cell = select_use_cell(StockList, Status#player.psn)
%% 	end,
%% 	
%% 	AptitudeSpeed = data_pet:get_aptitude_speed(),
%% 	
%% 	if	
%% 		is_record(PetTypeInfo,ets_base_pet) =:= false ->
%% 			[3,0,<<>>,Status]; %% 宠物信息不存在
%% %% 		Status#player.lv < PetTypeInfo#ets_base_pet.lv ->	 		
%% %% 			[4,0,<<>>,Status]; %% 等级不够
%% 		PetCount >= Status#player.psn ->	 
%% 			[5,0,<<>>,Status]; %% 宠物数已满
%% 		Cell =< 0 orelse Cell > Status#player.psn ->
%% 			[6,0,<<>>,Status]; %% 宠物格子不正确
%% 		true ->
%% 			case db_agent_pet:create_pet(Status#player.id,PetTypeInfo, TalentId, TalentId1, Cell, AptitudeSpeed) of
%% 				{mongo,Ret} ->					
%% 					Pet = init_pet(Status#player.id, PetTypeInfo, TalentId, TalentId1, Cell, Ret, AptitudeSpeed);				
%% 				_Ret ->
%% 					
%% 					PetData = db_agent_pet:get_new_pet(Status#player.id),
%% 					Pet = list_to_tuple([pet]++ PetData)
%% 			end,
%% 	
%% 			case is_record(Pet,pet) of
%% 				true ->
%% 					NewPet = upgate_pet_attribute(Pet, 1, 1),
%% 					
%% 					Pets = get_player_all_pets(Status#player.id),
%% 					
%% 					NewPets = [NewPet | Pets],
%% 					put(player_pet, NewPets),
%% 					
%% 					%%长生目标
%% 					if NewPet#pet.qly =:= 3 ->
%% 						   lib_target:target(blu_pet,1);
%% 					   NewPet#pet.qly =:= 4 ->
%% 						   lib_target:target(pur_pet,1);
%% 					   NewPet#pet.qly =:= 5 ->
%% 						   lib_target:target(ora_pet,1);
%% 					   NewPet#pet.qly =:= 6 ->
%% 						   lib_target:target(68,1);			%%拥有一只珍橙宠
%% 					 	true ->
%% 							ok
%% 					end,
%% 					
%% 					%%称号 橙色风暴 更新宠物个数
%% 					if NewPet#pet.qly =:= 5 ->
%% 						   lib_title:update_player_title(pet, 1);
%% 					   true ->
%% 						   ok
%% 					end,
%% 					
%% 					
%% 					%% 生成宠物日志
%% 					if 
%% 						BeLog =:= 0 ->
%% 							skip;
%% 						PetTypeInfo#ets_base_pet.qly > 3 orelse PetTypeInfo#ets_base_pet.ptid =:= 603001111-> %% 紫宠以上或龙魄的才记录
%% 					   		PetInfo = lib_pet:init_pet(Status#player.id, PetTypeInfo, 0, 0, 0, 0, AptitudeSpeed),
%% 							spawn(fun()->catch(db_log_agent:free_pet_log(PetInfo,2))end);
%% 						true ->
%% 							skip
%% 					end,
%% 					
%% 					%%io:format("~s create_pet 3[~p] \n ",[misc:time_format(now()), test]),
%% 					[1, NewPet#pet.id, NewPet#pet.nick, Status];
%% 				false ->
%% 					[0,0,<<>>,Status]
%% 			end			
%% 	end.	
%% 
%% %% 宠物放生
%% free_pet(Status, [PetId,Type]) ->
%% 	case Status#player.camp of 
%% 		101->{5,[]}; %% 新手不能放生宠物
%% 		_->
%% 			%% 从进程字典中 获取宠物数据
%%     		Pet = get_own_pet(Status#player.id, PetId),
%% 		    if  Pet =:= []  -> {2,[]}; % 宠物不存在 
%% 		        true ->
%% 					%%判断宠物是否出战
%% 					case lib_formation:getPetStaOnFrm(PetId) of
%% 						battleNo -> State = 0;
%% 						battleYes -> State = 1
%% 					end,
%% 					
%%         		    if  Pet#pet.uid =/= Status#player.id -> {3,[]}; % 该灵兽不归你所有
%% 						State =:= 1 -> {4,[]}; %% 出战的宠物不能直接放生
%%         		        true ->                		    
%% 							%% 删除进程字典信息
%% 							delete_own_pet(Status#player.id, PetId),
%% 							%%从闲置阵法中删除放生宠物
%% 							lib_formation:delGoawayPet(PetId),
%%                         	%%重新计算角色属性
%% 							%% 临时屏蔽
%% 							%%pet_attribute_effect(Status,Pet),
%% 							
%% 							%% 删除数据库信息
%% 							db_agent_pet:free_pet(PetId),
%% 							if
%% 								Pet#pet.qly > 2 -> %% 蓝宠以上的才记录
%% 									%% 记录放生宠物日记
%% 									spawn(fun()->catch(db_log_agent:free_pet_log(Pet,Type))end);
%% 								true -> skip
%% 							end,							
%% 
%% 						 	{1,Pet}
%% 					end
%% 			end
%%     end.
%% 
%% %% 灵兽改名
%% rename_pet(Status, [PetId, PetName]) ->
%% 	%%敏感词检测
%% 	case lib_words_ver:words_ver(PetName) of
%% 		true ->
%% 			case validata_name(PetName, 1, 12) of     %% 最长12字符
%% 				false -> {fail,7};
%% 				_ ->
%% 					Pet = get_own_pet(Status#player.id, PetId),
%% 					if  Pet =:= []  -> {fail,2}; %% 宠物不存在
%% 						true ->
%% 							NewName = tool:to_binary(PetName),
%% 							if 	Pet#pet.uid  =/= Status#player.id -> {fail,3}; % 该宠物不归你所有
%% 								Pet#pet.nick =:= NewName -> {fail,4}; %% 新旧名称相同
%% 								Status#player.viplv =:= 0 andalso Status#player.rnct > 0 andalso Status#player.gold < 2 -> {fail, 6}; %% 元宝不足
%% 								true ->
%% 									if 
%% 										Status#player.viplv =:= 0 andalso Status#player.rnct > 0 ->
%% 											Status1 = lib_goods:cost_money(Status, 2, gold, 4103),
%% 											NewStatus = Status1#player{rnct = Status1#player.rnct + 1},
%% 											lib_player:send_player_attribute2(NewStatus, 3);
%% 										true ->
%% 											NewStatus = Status#player{rnct = Status#player.rnct + 1}
%% 									end,
%% 									
%% 									data_pet:set_rename_times(NewStatus#player.rnct),
%% 																
%% 									% 更新进程字典信息
%% 									PetNew = Pet#pet{nick = NewName, rnct = Pet#pet.rnct + 1},
%% 									update_own_pet(PetNew),
%% 									NewStatus1 =
%% 										if
%% 											NewStatus#player.opid =:= PetId ->
%% 												BinPetName = tool:to_binary(NewName),
%% 												PetIcon = PetNew#pet.icon * 10 + PetNew#pet.qly,
%% 												{ok, BinData} = pt_41:write(41016, [NewStatus#player.id, BinPetName, PetIcon]),
%% 												mod_scene_agent:send_to_scene(NewStatus#player.scn, BinData),
%% 												NewStatus#player{other = NewStatus#player.other#player_other{out_pet_name = BinPetName}};
%% 											true ->
%% 												NewStatus
%% 										end,
%% 									
%% 									%% 更新数据库信息
%% 									spawn(fun()->db_agent_pet:rename_pet(Pet#pet.id, NewName) end),
%% 									
%% 									{ok, NewStatus1}    
%% 							end
%% 					end
%% 			end;
%% 		false->
%% 			{fail,5}
%%     end.
%% 
%% %% 宠物状态改变
%% change_status(Status,[PetId,PetStatus]) ->	
%% 	Pet = get_own_pet(Status#player.id, PetId),
%%     if  Pet =:= []  -> {fail,2}; %% 宠物不存在
%%         true ->         
%%             if  Pet#pet.uid =/= Status#player.id -> {fail,3}; %% 该宠物不归你所有
%%                 Pet#pet.psta =:= PetStatus -> {fail,4}; %% 宠物已经出战/休息
%% 				true ->
%% 					
%% 					%% 更新进程字典信息
%% 					PetNew = Pet#pet{psta = PetStatus}, 
%% 					update_own_pet(PetNew),	
%%                     
%% 					spawn(fun()->lib_task:event(pet, null, Status)end),
%% 					%% 临时屏蔽
%% 					%%属性加点对角色属性加成影响
%% 					%%pet_attribute_effect(Status,PetNew),
%% 					
%% 					%% 更新数据库信息
%% 					db_agent_pet:pet_update_status(Pet#pet.id,PetStatus),
%% 					
%% 					{ok,PetNew}
%%             end
%% 	end.	
%% 
%% %% 获取灵兽信息
%% get_pet_info(Status, [PetId]) ->
%%     get_own_pet(Status#player.id, PetId).
%% 
%% %% 获取玩家宠物列表
%% get_using_pet_list(_Status, [PlayerId]) ->
%%     PetList = get_player_all_pets(PlayerId),
%% 	NewList = [Pet || Pet <- PetList, Pet#pet.cell =:= 0],
%% 	if
%% 		length(NewList) > 0 ->
%% 			[1,NewList];
%% 		true ->
%% 			[1,[]]
%% 	end.
%% 
%% check_pet_aptitude(Pet, Type) ->
%% 	Limit = data_pet:get_limit(Pet#pet.qly),
%% 	case Type of
%% 		0 -> %% 内功
%% 			if 
%% 				Pet#pet.pwn >= Limit -> {fail, 5}; %% 资质已到上限
%% 				true -> 
%% 					case goods_util:get_type_goods_list(Pet#pet.uid, 133001, 0) of
%% 						[] ->
%% 							{fail, 4}; %% 晶石信息不存在
%% 						GoodsList ->
%% 							GoodsInfo = lists:nth(1, GoodsList),
%% 							[Pet#pet.pwn, GoodsInfo]
%% 					end
%% 			end;
%% 		1 -> %% 技法
%% 			if 
%% 				Pet#pet.tcn >= Limit -> {fail, 5}; %% 资质已到上限
%% 				true -> 
%% 					case goods_util:get_type_goods_list(Pet#pet.uid, 134001, 0) of
%% 						[] ->
%% 							{fail, 4}; %% 晶石信息不存在
%% 						GoodsList ->
%% 							GoodsInfo = lists:nth(1, GoodsList),
%% 							[Pet#pet.tcn, GoodsInfo]
%% 					end
%% 			end;
%% 		2 -> %% 法力
%% 			if 
%% 				Pet#pet.mgn >= Limit -> {fail, 5}; %% 资质已到上限
%% 				true -> 
%% 					case goods_util:get_type_goods_list(Pet#pet.uid, 135001, 0) of
%% 						[] ->
%% 							{fail, 4}; %% 晶石信息不存在
%% 						GoodsList ->
%% 							GoodsInfo = lists:nth(1, GoodsList),
%% 							[Pet#pet.mgn, GoodsInfo]
%% 					end
%% 			end
%% 	end.
%% 
%% %% 宠物资质提升
%% upgrade_aptitude(Status, [PetId, Number, Type]) -> 	
%% %% io:format("upgrade_aptitude:true[~p]\n",[Number]),
%% 	Pet = get_own_pet(Status#player.id, PetId),
%%     if  (Status#player.stsw band 8) =:= 0 -> {fail,8};%% 功能未开放
%% 		Pet =:= []  -> {fail,2}; %% 宠物不存在
%%         Pet#pet.uid =/= Status#player.id -> {fail,3}; %% 该宠物不归你所有
%% 		true ->
%% 			case check_pet_aptitude(Pet, Type) of
%% 				{fail, Ret} -> {fail,Ret};
%% 				[CurNum, GoodsInfo] ->
%% 					if GoodsInfo#goods.num < Number -> {fail, 6}; %% 晶石数量不足
%% 					   true ->
%% 						   [TotalNum, AddNum, Addap] = data_pet:get_add_aptitude(CurNum, Number, Pet#pet.qly),
%% 						   %%io:format("upgrade_aptitude:[~p/~p/~p/~p]\n",[CurNum, AddNum, TotalNum, GoodsInfo]),
%% 						   case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_one', GoodsInfo#goods.id, AddNum}) of
%% 								 [_Res, NewNum] ->
%% 									 %%io:format("upgrade_aptitude:ok[~p/~p]\n",[_Res, NewNum]),									 									 								 
%% 									 NewPet = 
%% 										 if  Type =:= 0 -> Pet#pet{other = Pet#pet.other#pet_other{pwr = Pet#pet.other#pet_other.pwr + Addap},
%% 																   pwn = Pet#pet.pwn + AddNum,
%% 																   rela = Pet#pet.rela + AddNum * 20 * 100};
%% 											 Type =:= 1 -> Pet#pet{other = Pet#pet.other#pet_other{tech = Pet#pet.other#pet_other.tech + Addap},
%% 																   tcn = Pet#pet.tcn + AddNum, 
%% 																   rela = Pet#pet.rela + AddNum * 20 * 100};
%% 											 true -> Pet#pet{other = Pet#pet.other#pet_other{mgc = Pet#pet.other#pet_other.mgc + Addap}, 
%% 															 mgn = Pet#pet.mgn + AddNum,
%% 															 rela = Pet#pet.rela + AddNum * 20 * 100}
%% 										 end,
%% 									 
%% 									 if
%% 										 Type =:= 0 -> Value = NewPet#pet.other#pet_other.pwr;
%% 										 Type =:= 1 -> Value = NewPet#pet.other#pet_other.tech;
%% 										 true -> Value = NewPet#pet.other#pet_other.mgc
%% 									 end,
%% 									 
%% 									 %%io:format("upgrade_aptitude:ok[~p/~p]\n",[Addap, NewPet]),
%% 									 %% 更新进程字典信息
%% 									 NewPet1 = upgate_pet_attribute(NewPet, 0, 1),
%% 									 update_own_pet(NewPet1),
%% 		
%% 									 %% 更新数据库信息
%% 									 db_agent_pet:pet_update_spar(NewPet1#pet.id, NewPet1#pet.pwn, NewPet1#pet.tcn, NewPet1#pet.mgn),
%% 
%% 									 {ok, Value, TotalNum, NewNum, NewPet1#pet.rela, NewPet1#pet.qly, CurNum};			
%% 								 _Err ->
%% 									 {fail, 0}						
%% 							end					
%% 					end
%% 			end				
%% 	end.
%% 
%% %% 获取玩家宠物晶石信息
%% get_spar_number(_Status, [PlayerId]) ->
%% 	Num1 = goods_util:get_goods_num(PlayerId, 133001, 0), %% 获取内功晶石数量
%% 	Num2 = goods_util:get_goods_num(PlayerId, 134001, 0), %% 获取技法晶石数量
%% 	Num3 = goods_util:get_goods_num(PlayerId, 135001, 0), %% 获取法力晶石数量
%% 	[Num1, Num2, Num3].
%% 
%% %% 宠物仓库列表信息
%% get_stock_pet(PlayerId) ->
%% 	PetList = get_player_all_pets(PlayerId),
%% 	NewList = [Pet || Pet <- PetList, Pet#pet.cell > 0],
%% 	%%io:format("handle_41008:[~p]\n",[NewList]),
%% 	if
%% 		length(NewList) > 0 ->
%% 			NewList;
%% 		true ->
%% 			[]
%% 	end.
%% 
%% %% 宠物洗炼成晶石的数量
%% change_to_spar(Pet, Type) ->
%% 	if 
%% 		Pet#pet.ptid =:= 603001111 ->
%% 			Num1 = 100,
%% 			Num2 = 100,
%% 			Num3 = 100,
%% 			Soul = 0;
%% 		true ->
%% 			LevelRatio = data_pet:get_level_ratio(Pet#pet.lv),
%% 			QualityRatio = data_pet:get_quality_ratio(Pet#pet.qly),
%% 			ChangeRatio = data_pet:get_change_ratio(Type),	
%% 			Num1 = Pet#pet.lv * LevelRatio + QualityRatio +	trunc(ChangeRatio * Pet#pet.pwn),
%% 			Num2 = Pet#pet.lv * LevelRatio + QualityRatio +	trunc(ChangeRatio * Pet#pet.tcn),
%% 			Num3 = Pet#pet.lv * LevelRatio + QualityRatio +	trunc(ChangeRatio * Pet#pet.mgn),
%% 			Soul = trunc(Pet#pet.snum * ChangeRatio)
%% 	end,
%% 	
%% 	[trunc(Num1), trunc(Num2), trunc(Num3), trunc(Soul)].
%% 
%% %% 增加宠物洗炼晶石
%% add_spar_num(PlayerId, GoodsTypeId, Number) ->
%% 	case goods_util:get_type_goods_info(PlayerId, GoodsTypeId, 0) of
%% 		[] ->
%% 			%%io:format("~s add_spar_num undefine[~p] \n ",[misc:time_format(now()), [test]]),
%% 			GoodsTypeInfo = goods_util:get_goods_type(GoodsTypeId),
%% 			GoodsInfo1 = goods_util:get_new_goods(GoodsTypeInfo),
%%             GoodsInfo2 = GoodsInfo1#goods{uid=PlayerId, loc=0, cell = 0, num=Number },
%% 			_NewGoodsInfo = lib_goods:add_goods(GoodsInfo2),
%% 			%%io:format("~s add_spar_num undefine[~p] \n ",[misc:time_format(now()), [NewGoodsInfo]]),
%% 			%%lib_goods:change_goods_num(NewGoodsInfo, Number),
%% 			ok;
%% 		GoodsInfo ->			
%% 			AllNumber = GoodsInfo#goods.num + Number,
%% 			%%io:format("~s add_spar_num [~p] \n ",[misc:time_format(now()), [GoodsInfo, AllNumber]]),
%% 			lib_goods:change_goods_num(GoodsInfo, AllNumber),
%% 			ok
%% 	end.
%% 
%% %% 仓库宠物洗炼
%% refinement_pet(Status, [PetId, Type]) ->	
%% 	Pet = get_own_pet(Status#player.id, PetId),	
%% 	%%io:format("~s refinement_pet[~p] \n ",[misc:time_format(now()), [Gold]]),
%% 
%%     if 
%% 		Status#player.stsw band 8 =:= 0 -> [0, 0, 0, 0, Status];
%% 		Status#player.opid =:= PetId -> [9, 0, 0, 0, Status]; %% 宠物跟随不能洗炼
%% 		Pet =:= []  -> [2, 0, 0, 0, Status]; %% 宠物不存在
%%         Pet#pet.uid =/= Status#player.id -> [3, 0, 0, 0, Status]; %% 该宠物不归你所有
%% 		Pet#pet.cell =:= 0 -> [4, 0, 0, 0, Status]; %% 宠物不在仓库					
%% 		true ->
%% 			HasBead = lib_bead:pet_has_bead(Status#player.id, PetId), %%是否装备五行珠
%% 			Gold = data_pet:get_refinement_gold(Pet),
%% 			[Num1, Num2, Num3] = get_spar_number(Status, [Status#player.id]),
%% 			[MakePwr, MakeTch, MakeMgc, Soul] = change_to_spar(Pet, Type),
%% 			NumLimit = data_pet:get_spar_limit(),
%% 			case lib_formation:getPetStaOnFrm(PetId) of
%% 				battleNo -> State = 0;
%% 				battleYes -> State = 1
%% 			end,
%% 			if 
%% 				HasBead =:= true -> [12, 0, 0, 0, Status]; %% 装备五行珠的宠物不能炼化
%% 				Type =:= 1 andalso Status#player.viplv < 3 -> [10, 0, 0, 0, Status]; %% 黄金炼化，vip等级不足		
%% 				Type =:= 1 andalso Status#player.gold < Gold -> [11, 0, 0, 0, Status]; %% 黄金炼化，元宝不足	
%% 				Num1 + MakePwr > NumLimit -> [5, 0, 0, 0, Status]; %% 内功晶石数量已满
%% 				Num2 + MakeTch > NumLimit -> [6, 0, 0, 0, Status]; %% 技法晶石数量已满
%% 				Num3 + MakeMgc > NumLimit -> [7, 0, 0, 0, Status]; %% 法力晶石数量已满
%% 				State =:= 1 -> [8, 0, 0, 0, Status]; %% 出战宠物不能洗炼
%% 				true -> %% 可以洗炼					
%%                 	
%% 					%% 删除进程字典信息
%% 					delete_own_pet(Status#player.id, PetId),
%% 					
%% 					add_spar_num(Status#player.id, 133001,MakePwr),
%% 					add_spar_num(Status#player.id, 134001,MakeTch),
%% 					add_spar_num(Status#player.id, 135001,MakeMgc),
%% 					
%% 					Status1 = lib_soul:add_soul_ext(Status, Soul, 4111),
%% 					
%% 					if 
%% 						Type =:= 1 andalso Gold =/= 0->
%% 							NewStatus = lib_goods:cost_money(Status1, Gold, gold, 4111);							
%% 						true  ->
%% 							NewStatus = Status1
%% 					end,
%% 							
%% 					%% 删除数据库信息
%% 					db_agent_pet:free_pet(PetId),
%% 					
%% 					if
%% 						Pet#pet.qly > 3 orelse Pet#pet.ptid =:= 603001111-> %% %% 紫宠以上或龙魄的才记录
%% 							%% 记录洗炼宠物日记
%% 							spawn(fun()->catch(db_log_agent:free_pet_log(Pet,1))end);
%% 						true -> skip
%% 					end,
%% 					lib_task:event(melt_pet, [1], NewStatus),
%% 					[1, MakePwr, MakeTch, MakeMgc, NewStatus]
%% 			end
%% 	end.
%% 
%% move_pet(Status, Type, PetId, StockPetId, Cell) ->	
%% 	
%% 	case Type of
%% 		0 -> %% 列表拖仓库
%% 			case get_own_pet(Status#player.id, PetId) of
%% 				[] -> [2, PetId, StockPetId, Cell]; %%宠物不存在
%% 				Pet ->
%% 					%%io:format("~s move_pet 0[~p] \n ",[misc:time_format(now()), [Pet]]),
%% 					%% 宠物状态
%% 					case lib_formation:getPetStaOnFrm(PetId) of
%% 						battleNo ->	State = 0;
%% 						battleYes ->State = 1
%% 					end,
%% 					
%% 					if 
%% 						(Cell < 0 orelse Cell > Status#player.psn) ->
%% 							[6, PetId, StockPetId, Cell]; %%宠物仓库格子未启用
%% 						State =:= 1 ->
%% 							[8, PetId, StockPetId, Cell]; %% 宠物已出战	
%% 						true ->
%% 							if 
%% 								StockPetId =:= 0 -> %% 拖到空的格子
%% 									%%io:format("~s move_pet 0[~p] \n ",[misc:time_format(now()), [PetId]]),
%% 									NewPet = Pet#pet{cell = Cell},									
%% 									update_own_pet(NewPet),
%% 									
%% 									spawn(fun()->db_agent_pet:update_pet_cell(PetId, Cell)  end),
%% 									[1, StockPetId, PetId, Cell];
%% 								true ->
%% 									case get_own_pet(Status#player.id, StockPetId) of
%% 										[] -> [2, PetId, StockPetId, Cell]; %%宠物不存在
%% 										StockPet ->
%% 											if 
%% 												StockPet#pet.cell =/= Cell -> 
%% 													[7, PetId, StockPetId, Cell]; %%宠物不在相应的格子
%% 												true ->
%% 													NewPet = Pet#pet{cell = Cell},													
%% 													update_own_pet(NewPet),
%% 													
%% 													NewPet1 = StockPet#pet{cell = 0},													
%% 													update_own_pet(NewPet1),
%% 													
%% 													spawn(fun()->db_agent_pet:update_pet_cell(PetId, Cell)  end),													
%% 													spawn(fun()->db_agent_pet:update_pet_cell(StockPetId, 0)  end),
%% 													[1, StockPetId, PetId, Cell]
%% 											end
%% 									end
%% 							end				
%% 					end
%% 			end;
%% 		1 -> %% 仓库拖列表
%% 			%%io:format("~s move_pet 1[~p] \n ",[misc:time_format(now()), [PetId]]),
%% 			case get_own_pet(Status#player.id, StockPetId) of
%% 				[] -> [2, PetId, StockPetId, Cell]; %%宠物不存在
%% 				StockPet ->
%% 					if 
%% 						StockPet#pet.cell =/= Cell ->
%% 							[7, PetId, StockPetId, Cell]; %%宠物不在相应的格子
%% 						true ->
%% 							if 
%% 								PetId =:= 0 -> %% 拖到空的格子
%% 									PetList = get_using_pet_list(Status, [Status#player.id]),
%% 									PetCount = length(PetList),
%% 									if 
%% 										PetCount >= 8 -> 
%% 											[4, PetId, StockPetId, Cell]; %% 宠物列表已满
%% 										true ->
%% 											NewPet = StockPet#pet{cell = 0},											
%% 											update_own_pet(NewPet),
%% 											
%% 											spawn(fun()->db_agent_pet:update_pet_cell(StockPetId, 0)  end),
%% 											[1, StockPetId, 0, Cell]
%% 									end;
%% 								true ->
%% 									%%io:format("~s move_pet [~p] \n ",[misc:time_format(now()), [PetId]]),
%% 									case get_own_pet(Status#player.id, PetId) of
%% 										[] -> [2, PetId, StockPetId, Cell]; %%宠物不存在
%% 										Pet ->
%% 											%% 宠物状态
%% 											case lib_formation:getPetStaOnFrm(PetId) of
%% 												battleYes -> 
%% 													[8, PetId, StockPetId, Cell]; %% 宠物已出战	
%% 												battleNo -> 
%% 													NewPet = StockPet#pet{cell = 0},													
%% 													update_own_pet(NewPet),
%% 													NewPet1 = Pet#pet{cell = Cell},													
%% 													update_own_pet(NewPet1),
%% 													
%% 													spawn(fun()->db_agent_pet:update_pet_cell(StockPetId, 0)  end),
%% 													spawn(fun()->db_agent_pet:update_pet_cell(PetId, Cell)  end),
%% 													[1, StockPetId, PetId, Cell]
%% 											end										
%% 									end
%% 							end
%% 					end
%% 			end
%% 	end.
%% 
%% open_grid(Status, Num) ->
%% 	GridLimit = data_pet:get_grid_limit(),
%% 	NeedGold = data_pet:open_grid_gold(Status#player.psn, Num),
%% 	if 
%% 		Status#player.psn >= GridLimit ->
%% 			{2, Status}; %% 已经开满格子 
%% 		Status#player.psn + Num > GridLimit ->
%% 			{4, Status}; %% 超过格子数
%% 		NeedGold > Status#player.gold ->
%% 			{3, Status}; %% 元宝不足		
%% 		true ->
%% 			db_agent_pet:open_grid(Status#player.id, Num),
%% 			NewStatus = lib_goods:cost_money(Status, NeedGold, gold, 4114),
%% 			NewStatus1 = NewStatus#player{psn = NewStatus#player.psn + Num},			
%% 			lib_player:send_player_attribute2(NewStatus1, 3),
%% 			{1, NewStatus1}
%% 	end.
%% 
%% %%通过ID获取宠物品质
%% get_pet_qly(PetId) ->
%% 	case get(player_pet) of
%% 		undefined ->
%% 			1;
%% 		PetList when is_list(PetList) ->
%% 			NewPetList = [Pet || Pet <- PetList, Pet#pet.id =:= PetId],
%% 			case NewPetList of
%% 				[] ->
%% 					1;
%% 				[Pet|_] ->
%% 					Pet#pet.qly;
%% 				_ ->
%% 					1
%% 			end;
%% 		_ ->
%% 			1
%% 	end.
%% 
%% get_aptitude_level_num(Level) ->
%% 	case get(player_pet) of
%% 		undefined ->
%% 			0;
%% 		PetList when is_list(PetList) ->
%% 			Fun = fun(Pet) ->
%% 						  ValueP = data_pet:get_upgrade_level(Pet#pet.pwn , Pet#pet.qly),
%% 						  ValueT = data_pet:get_upgrade_level(Pet#pet.tcn , Pet#pet.qly),
%% 						  ValueM = data_pet:get_upgrade_level(Pet#pet.mgn , Pet#pet.qly),
%% 						  ValueP + ValueT + ValueM						  
%% 				  end,
%% 			ValueList = lists:map(Fun, PetList),
%% 			
%% 			List = [Value || Value <- ValueList, Value >= Level],	
%% 		
%% 			case List of
%% 				[] -> 0;
%% 				_  -> length(List)			
%% 			end;
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %% 获取所有宠物中的最高阶数
%% get_aptitude_max_level() ->
%% 	case get(player_pet) of
%% 		undefined ->
%% 			0;
%% 		PetList when is_list(PetList) ->
%% 			Fun = fun(Pet) ->
%% 						  ValueP = data_pet:get_upgrade_level(Pet#pet.pwn , Pet#pet.qly),
%% 						  ValueT = data_pet:get_upgrade_level(Pet#pet.tcn , Pet#pet.qly),
%% 						  ValueM = data_pet:get_upgrade_level(Pet#pet.mgn , Pet#pet.qly),
%% 						  lists:max([ValueP, ValueT, ValueM])						  
%% 				  end,
%% 			ValueList = lists:map(Fun, PetList),
%% 			
%% 			lists:max(ValueList);				
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%获取一宠物的晶石阶数
%% get_pet_level(PlayerId, PetId) ->
%% 	Pet = get_own_pet(PlayerId, PetId),
%% 	if
%% 		Pet =:= [] ->
%% 			{0,0,0};
%% 		true ->
%% 			ValueP = data_pet:get_upgrade_level(Pet#pet.pwn , Pet#pet.qly),
%% 			ValueT = data_pet:get_upgrade_level(Pet#pet.tcn , Pet#pet.qly),
%% 			ValueM = data_pet:get_upgrade_level(Pet#pet.mgn , Pet#pet.qly),
%% 			{ValueP, ValueT, ValueM}
%% 	end.
%% 	
%% 
%% %% 清空宠物缓存经验
%% clear_cache_pet_exp(PetId) ->
%% 	case get(cache_pet_data) of
%% 		undefined ->
%% 			0;
%% 		CachePets ->
%% 			Fun = fun(Data) ->
%% 					[Pid, Exp] = Data,
%% 					if 
%% 						PetId =:= Pid -> [Pid, 0];
%% 						true -> [Pid, Exp]
%% 					end
%% 				  end,
%% 			ValueList = lists:map(Fun, CachePets),
%% 			
%% 			put(cache_pet_data, ValueList)
%% 	end.
%% 
%% %% 增加宠物缓存经验
%% add_cache_pet_exp(PetId, Exp) ->
%% 	case get(cache_pet_data) of
%% 		undefined ->
%% 			NewCachePets = [[PetId, Exp]],
%% 			NewExp = Exp;
%% 		CachePets ->
%% 			
%% 			Data = [[Pid1, Exp1] || [Pid1, Exp1] <- CachePets, Pid1 =:= PetId],
%% 			case Data of
%% 				[] ->
%% 					NewCachePets = CachePets ++ [[PetId, Exp]],
%% 					NewExp = Exp;
%% 				_ ->
%% 					Fun = fun(Data2) ->
%% 						[Pid2, Exp2] = Data2,
%% 						if
%% 							PetId =:= Pid2 -> [Pid2, Exp2];
%% 							true -> [Pid2, Exp2 + Exp]
%% 						end
%% 					end,
%% 					
%% 					NewCachePets = lists:map(Fun, CachePets),
%% 					[[_Pid3, Exp3] | _T] = Data,
%% 					NewExp = Exp3 + Exp
%% 			end
%% 	end,
%% 	
%% 	put(cache_pet_data, NewCachePets),
%% 	
%% 	NewExp.
%% 
%% %% -----------------------------------------------------------------
%% %% 宠物商店购买
%% %% -----------------------------------------------------------------
%% buy_pet(Status, TypeId, Num) ->
%% 	Info = data_pet:get_pet_shop_info(TypeId),
%% 	
%% 	%%io:format("~s buy_pet Ret[~p/~p] \n ",[misc:time_format(now()), TypeId, Info]),
%% 	
%% 	case Info of
%% 		[] -> [4, Status]; %% 不能购买此类型宠物
%% 		[PetTypeId, T1,T2, Gold, Prstg] ->
%% 			if 
%% 				Num < 1 orelse Num > 99 -> [8, Status];
%% 				Gold * Num > Status#player.gold -> [2, Status]; %% 2 元宝不足
%% 				Prstg > Status#player.prstg -> [5, Status]; %% 战勋不足
%% 				true ->
%% 					case lists:member(PetTypeId, [603085002, 603095003, 603095004, 603105002, 603105003, 603105004]) of %% 判断是否是宠物
%% 						true ->
%% 							StockList = get_stock_pet(Status#player.id),
%% 							PetCount = length(StockList),
%% 							Cell = select_use_cell(StockList, Status#player.psn),
%% 							if
%% 								PetCount >= Status#player.psn -> [3, Status]; %% 宠物数已满
%% 								Cell =< 0 orelse Cell > Status#player.psn -> [3, Status];%% 宠物数已满
%% 								Num =/= 1 -> [8, Status];
%% 								true ->
%% 									[Result, _PetId, _PetName, _NewStatus] = create_pet(Status,[PetTypeId, T1, T2, 1, 1]),
%% 									if
%% 										Result =:= 1 ->
%% 											NewStatus = lib_goods:cost_money(Status, Gold, gold, 4124),
%% 											[1, NewStatus];
%% 										true ->
%% 											[0, Status]
%% 									end
%% 							end;
%% 						_ -> %% 物品,非宠物
%% 							NullCellNum = gen_server:call(Status#player.other#player_other.pid_goods, {'cell_num'}),
%% 							if 
%% 								NullCellNum =:= 0 -> [6, Status];%% 背包已满
%% 								true ->
%% 									case gen_server:call(Status#player.other#player_other.pid_goods, {'give_goods', Status, PetTypeId, Num}) of
%% 										ok ->
%% 											Result = 1;
%% 										{_GoodsTypeId, not_found} ->
%% 											Result = 7;
%% 										cell_num ->
%% 											Result = 6;
%% 										_Error ->
%% 											Result = 0
%% 									end,
%% 
%% 									if
%% 										Result =:= 1 ->											
%% 											NewStatus = lib_goods:cost_money(Status, Gold * Num, gold, 4124),
%% 											
%% 											%% 神兵活动，商城购买3级生命水晶
%% 											if
%% 												PetTypeId =:= 460301 ->
%% 													lib_reward:reward_event(crystal, [NewStatus]);
%% 												true ->
%% 													ok
%% 											end,
%% 											[1, NewStatus];
%% 										true ->
%% 											[Result, Status]
%% 									end
%% 							end
%% 					end
%% 			end							
%% 	end.
%% 
%% buy_pet_goods(Status, GoodsTypeId, Num) ->
%% 	Info = data_pet:get_pet_goods_shop_info(GoodsTypeId),
%% 	
%% 	%%io:format("~s buy_pet Ret[~p/~p] \n ",[misc:time_format(now()), TypeId, Info]),
%% 	
%% 	case Info of
%% 		[] -> [4, Status]; %% 不能购买此类型
%% 		[PetTypeId, T1,T2, Gold, Prstg] ->
%% 			if 
%% 				Num < 1 orelse Num > 99 -> [8, Status];
%% 				Gold * Num > Status#player.gold -> [2, Status]; %% 2 元宝不足
%% 				Prstg > Status#player.prstg -> [5, Status]; %% 战勋不足
%% 				true ->
%% 					case lists:member(PetTypeId, [603085002, 603095003, 603095004, 603105002, 603105003, 603105004]) of %% 判断是否是宠物
%% 						true ->
%% 							StockList = get_stock_pet(Status#player.id),
%% 							PetCount = length(StockList),
%% 							Cell = select_use_cell(StockList, Status#player.psn),
%% 							if
%% 								PetCount >= Status#player.psn -> [3, Status]; %% 宠物数已满
%% 								Cell =< 0 orelse Cell > Status#player.psn -> [3, Status];%% 宠物数已满
%% 								true ->
%% 									[Result, _PetId, _PetName, _NewStatus] = create_pet(Status,[PetTypeId, T1, T2, 1, 1]),
%% 									if
%% 										Result =:= 1 ->
%% 											NewStatus = lib_goods:cost_money(Status, Gold, gold, 4126),
%% 											[1, NewStatus];
%% 										true ->
%% 											[0, Status]
%% 									end
%% 							end;
%% 						_ -> %% 物品,非宠物
%% 							NullCellNum = gen_server:call(Status#player.other#player_other.pid_goods, {'cell_num'}),
%% 							if 
%% 								NullCellNum =:= 0 -> [6, Status];%% 背包已满
%% 								true ->
%% 									case gen_server:call(Status#player.other#player_other.pid_goods, {'give_goods', Status, PetTypeId, Num}) of
%% 										ok ->
%% 											Result = 1;
%% 										{_GoodsTypeId, not_found} ->
%% 											Result = 7;
%% 										cell_num ->
%% 											Result = 6;
%% 										_Error ->
%% 											Result = 0
%% 									end,
%% 
%% 									if
%% 										Result =:= 1 ->
%% 											NewStatus = lib_goods:cost_money(Status, Gold * Num, gold, 4126),
%% 											[1, NewStatus];
%% 										true ->
%% 											[Result, Status]
%% 									end
%% 							end
%% 					end
%% 			end							
%% 	end.
%% 
%% %%宠物商店积分兑换
%% exchange_pet(Status, TypeId) ->
%% 	NeedLv = data_pet:exchange_pet_condition(player_lv),				%%兑换需要的人物等级
%% 	if
%% 		Status#player.lv < NeedLv ->									%%等级不够
%% 			{0, 0};
%% 		true ->
%% 			NeedOpen = data_pet:exchange_pet_condition(hunt_open),		%%兑换需要的战胜NPC
%% 			Hunt = lib_hunt:get_player_hunt(Status#player.id),
%% 			if
%% 				Hunt#hunt.open band NeedOpen =:= 0 ->					%%未战胜NPC独孤剑魔
%% 					{0, 0};
%% 				true ->
%% 					Info = data_pet:exchange_pet_data(TypeId),			%%兑换数据
%% 					case Info of
%% 						[PetTypeId, T1, T2, NeedPoint] ->
%% 							if 
%% 								Hunt#hunt.point < NeedPoint ->			%%积分不够
%% 									{2, 0};
%% 								true ->
%% 									case lists:member(PetTypeId, [603085002, 603095003, 603095004, 603105002, 603105003, 603105004]) of %% 判断是否是宠物
%% 										true ->
%% 											StockList = get_stock_pet(Status#player.id),
%% 											PetCount = length(StockList),
%% 											Cell = select_use_cell(StockList, Status#player.psn),
%% 											if
%% 												PetCount >= Status#player.psn -> 
%% 													{3, 0}; 			%% 宠物数已满
%% 												Cell =< 0 orelse Cell > Status#player.psn -> 
%% 													{3, 0};				%% 宠物数已满
%% 												true ->
%% 													[Result, _PetId, _PetName, _NewStatus] = create_pet(Status,[PetTypeId, T1, T2, 1, 1]),
%% 													if
%% 														Result =:= 1 ->
%% 															spawn(fun() -> db_log_agent:log_hunt_point(Status#player.id, Hunt#hunt.point, NeedPoint, PetTypeId) end),
%% 															{1, NeedPoint};
%% 														true ->
%% 															{0, 0}
%% 													end
%% 											end;
%% 										_ -> %% 物品,非宠物
%% 											NullCellNum = gen_server:call(Status#player.other#player_other.pid_goods, {'cell_num'}),
%% 											if 
%% 												NullCellNum =:= 0 -> 
%% 													{4, 0};%% 背包已满
%% 												true ->
%% 													case gen_server:call(Status#player.other#player_other.pid_goods, {'give_goods', Status, PetTypeId, 1}) of
%% 														ok ->
%% 															spawn(fun() -> db_log_agent:log_hunt_point(Status#player.id, Hunt#hunt.point, NeedPoint, PetTypeId) end),
%% 															{1, NeedPoint};
%% 														_ ->
%% 															{0, 0}
%% 													end
%% 											end
%% 									end
%% 							end;
%% 						_ ->				%%找不到对应的数据
%% 							{0, 0}
%% 					end
%% 			end
%% 	end.
%% 
%% 
%% %%直接生成一宠物
%% create_the_pet(Status, PetType) ->
%% 	PetTypeId = data_hunt:get_hunt_pet2(PetType),
%% 	%% 获取宠物天赋
%% 	case lib_pet:get_base_pet(PetTypeId) of
%% 		[] ->
%% 			0;
%% 		PetTypeInfo ->
%% 			RTalent = util:rand(0,10000),
%% 			TalentId = data_hunt:get_talent_by_ratio(PetTypeInfo#ets_base_pet.qly, RTalent),
%% 			
%% 			if 
%% 				PetTypeInfo#ets_base_pet.qly =:= 5 -> %% 橙宠双天赋
%% 					RTalent1 = util:rand(0,10000),
%% 					TalentId11 = data_hunt:get_talent_by_ratio(PetTypeInfo#ets_base_pet.qly, RTalent1),
%% 					if 
%% 						TalentId11 =:= TalentId ->
%% 							RTalent2 = util:rand(1500, 8426),
%% 							RTalent3 = (RTalent1 + RTalent2) rem 10000,
%% 							TalentId1 = data_hunt:get_talent_by_ratio(PetTypeInfo#ets_base_pet.qly, RTalent3);
%% 						true ->
%% 							TalentId1 = TalentId11
%% 					end;
%% 				true ->
%% 					TalentId1 = 0
%% 			end,
%% 			lib_pet:create_pet(Status, [PetTypeId, TalentId, TalentId1, 1, 1]),
%% 			PetTypeId
%% 	end.
%% 			
%% %% -----------------------------------------------------------------
%% %% 融合宠物
%% %% -----------------------------------------------------------------
%% 
%% %% 初始化宠物融合
%% init_fusion_pet() ->
%% 	FusionInfo = get(player_fusion),
%% 	if 
%% 		FusionInfo =:= undefined ->
%% 			NewInfo = #pet_fusion{
%% 									first_petid = 0,                    %% 主宠
%% 									main_qly = 0,						%% 主宠品质
%% 									sec_petid = 0,                      %% 副宠1
%% 									third_petid = 0,                    %% 副宠2
%% 									goods_id = 0						%%  仙器
%% 								   },
%% 			put(player_fusion, NewInfo),
%% 			NewInfo;
%% 		true ->
%% 			FusionInfo
%% 	end.
%% 
%% %% 撤销融合操作
%% clean_fusion_pet() ->
%% 	FusionInfo = init_fusion_pet(),
%% 	NewInfo = FusionInfo#pet_fusion{
%% 									first_petid = 0,                    %% 主宠
%% 									main_qly = 0,						%% 主宠品质
%% 									sec_petid = 0,                      %% 副宠1
%% 									third_petid = 0,                    %% 副宠2
%% 									goods_id = 0						%%  仙器
%% 								   },
%% 	put(player_fusion, NewInfo).
%% 	
%% %% 可融合宠物列表
%% get_fusion_pets(Status) ->
%% 	%% 获取所有宠物
%% 	PetList = get_stock_pet(Status#player.id),
%% 	%% 获取出战宠物ID列表
%% 	ActPetIdList = lib_formation:getActPet(),
%% 
%% 	Fun = fun(Pet) ->
%% 		if 
%% 			Pet#pet.qly =/= 5 andalso Pet#pet.qly =/= 7-> %% 非橙宠以上
%% 				[];
%% 			Pet#pet.id =:= Status#player.opid -> %% 跟随宠物
%% 				[];
%% 			true ->
%% 				IsAct = lists:member(Pet#pet.id, ActPetIdList),
%% 				if 
%% 					IsAct =:= true -> %% 出战宠物
%% 						[];
%% 					true ->
%% %% 						ValueP = data_pet:get_upgrade_level(Pet#pet.pwn , Pet#pet.qly),
%% %% 						ValueT = data_pet:get_upgrade_level(Pet#pet.tcn , Pet#pet.qly),
%% %% 						ValueM = data_pet:get_upgrade_level(Pet#pet.mgn , Pet#pet.qly),
%% %% 						Total =ValueP + ValueT + ValueM,
%% 						if 
%% %% 							Total < 30 -> %% 小于30阶
%% %% 								[];
%% 							Pet#pet.lv < 40 -> %% 小于40级
%% 								[];
%% 							true ->
%% 								Pet
%% 						end
%% 				end
%% 		end
%% 	end,
%% 				
%% 	List1 = lists:map(Fun, PetList),
%% 	
%% 	FusionList  = [Pet1 || Pet1 <- List1, Pet1 =/= []],
%% 		
%% 	FusionList.
%% 
%% %% Type 1副宠，0主宠
%% is_can_fusion(Status, Pet, Type) ->
%% 	if 
%% 		Pet =:= []  -> 2; %% 宠物不存在
%%         Pet#pet.uid =/= Status#player.id -> 3; %% 该宠物不归你所有
%% 		Pet#pet.qly =/= 5 andalso  Pet#pet.qly =/= 7 -> 4;%% 该宠物不能融合
%% 		Pet#pet.id =:= Status#player.opid -> 5;%% 跟随宠物
%% 		true ->
%% 			%% 获取出战宠物ID列表
%% 			ActPetIdList = lib_formation:getActPet(),
%% 			IsAct = lists:member(Pet#pet.id, ActPetIdList),
%% 			ValueP = data_pet:get_upgrade_level(Pet#pet.pwn , Pet#pet.qly),
%% 			ValueT = data_pet:get_upgrade_level(Pet#pet.tcn , Pet#pet.qly),
%% 			ValueM = data_pet:get_upgrade_level(Pet#pet.mgn , Pet#pet.qly),
%% 			Total =ValueP + ValueT + ValueM,
%% 			if 
%% 				IsAct =:= true -> 6;%% 出战宠物
%% 				Type =:= 0 andalso Total < 40 -> 7;%% 主宠小于40阶
%% 				Type =:= 0 andalso Pet#pet.lv < 50 -> 8; %% 主宠小于50级 
%% 				Type =:= 1 ->
%% 					HasBead = lib_bead:pet_has_bead(Status#player.id,Pet#pet.id),
%% 					if
%% 						Pet#pet.lv < 40 -> 11; %% 副宠小于40级 
%% 						HasBead =:= true -> 12; %% 装备五行珠的宠物不能当副宠
%% 						true -> 1
%% 					end;
%% 				true -> 1
%% 			end
%% 	end.	
%% 
%% %% 可融合主宠上/下阵
%% set_first_fusion(Status, [PetId, Type]) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	RetFusion = is_can_fusion(Status, Pet, 0),
%%     if  
%% 		RetFusion =/= 1  -> [RetFusion, 0, 0]; %% 不能融合       
%% 		true ->
%% 			Info = init_fusion_pet(),
%% 			case Type of
%% 				2 -> %% 下阵					
%% 					if 
%% 						PetId =:= Info#pet_fusion.first_petid -> %% 是上阵宠物
%% 							clean_fusion_pet(),
%% 							[1, 0, 0];
%% 						true -> %% 非上阵宠物
%% 							[0, 0, 0]
%% 					end;							
%% 				_ -> %% 上阵
%% 					if
%% 						Pet#pet.qly =/= Info#pet_fusion.main_qly ->
%% 							FirstId = Pet#pet.id,
%% 							SecId = 0,
%% 							ThirdId = 0,
%% 							Qly = Pet#pet.qly,
%% 							PetTypeId = Pet#pet.ptid;	
%% 						true ->
%% 							FirstId = Pet#pet.id,
%% 							Qly = Pet#pet.qly,
%% 							PetTypeId = Pet#pet.ptid,
%% 							if
%% 								Pet#pet.id =:= Info#pet_fusion.sec_petid ->
%% 									SecId = 0;
%% 								true ->
%% 									SecId = Info#pet_fusion.sec_petid
%% 							end,
%% 							
%% 							if
%% 								Pet#pet.id =:= Info#pet_fusion.third_petid ->
%% 									ThirdId = 0;
%% 								true ->
%% 									ThirdId = Info#pet_fusion.third_petid
%% 							end
%% 					end,
%% 					
%% 					[GoodTypeId, NeedNum] = data_pet:get_fusion_goodsid(Qly),		
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),	
%% 					FusionType = data_pet:get_fusion_pettype(PetTypeId),
%% 					
%% 					if 
%% 						FusionType =:= 0 ->
%% 							[4, 0, 0]; %% 该宠物不能融合
%% 						true ->
%% 							NewInfo = Info#pet_fusion{
%% 									first_petid = FirstId,               %% 主宠
%% 									main_qly = Qly,						%% 主宠品质
%% 									sec_petid = SecId,                   %% 副宠1
%% 									third_petid = ThirdId,                    %% 副宠2
%% 									goods_id = GoodTypeId					%%  仙器
%% 								   },
%% 							put(player_fusion, NewInfo),
%% 							
%% 							if
%% 								NeedNum > Num ->
%% 									Gid = 0;
%% 								true ->
%% 									Gid = GoodTypeId
%% 							end,
%% 							
%% 							[1, FusionType, Gid]
%% 					end
%% 			end
%% 	end.
%% 
%% %% 可融合副宠上/下阵
%% set_sub_fusion(Status, [PetId, Loc, Type]) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	RetFusion = is_can_fusion(Status, Pet, 1),
%%     if  
%% 		RetFusion =/= 1  -> [RetFusion, 0, 0]; %% 不能融合       
%% 		true ->
%% 			Info = init_fusion_pet(),
%% 			case Type of
%% 				2 -> %% 下阵					
%% 					if 
%% 						Loc =:= 1 andalso PetId =:= Info#pet_fusion.sec_petid -> %% 是上阵宠物
%% 							NewInfo = Info#pet_fusion{sec_petid = 0},                   %% 副宠1
%% 							put(player_fusion, NewInfo),
%% 							[1, PetId, Loc];
%% 						Loc =:= 2 andalso PetId =:= Info#pet_fusion.third_petid -> %% 是上阵宠物
%% 							NewInfo = Info#pet_fusion{third_petid = 0},                 %% 副宠2
%% 							put(player_fusion, NewInfo),
%% 							[1, PetId, Loc];
%% 						true -> %% 非上阵宠物
%% 							[0, 0, 0]
%% 					end;							
%% 				_ -> %% 上阵
%% 					if
%% 						Info#pet_fusion.first_petid =:= 0 ->
%% 							[8, 0, 0]; %% 主宠格没有宠物	
%% 						Info#pet_fusion.main_qly =/= Pet#pet.qly ->
%% 							[9, 0, 0]; %% 与主宠格品质不一致
%% 						PetId =:= Info#pet_fusion.first_petid orelse
%% 						PetId =:= Info#pet_fusion.sec_petid   orelse
%% 						PetId =:= Info#pet_fusion.third_petid ->
%% 							[10, 0, 0]; %% 已经放到主/副格
%% 						true ->
%% 							if 
%% 								Loc =:= 1 -> %% 上阵宠物
%% 									NewInfo = Info#pet_fusion{sec_petid = PetId},                   %% 副宠1
%% 									put(player_fusion, NewInfo),
%% 									[1, PetId, Loc];
%% 								Loc =:= 2 -> %% 上阵宠物
%% 									NewInfo = Info#pet_fusion{third_petid = PetId},                 %% 副宠2
%% 									put(player_fusion, NewInfo),
%% 									[1, PetId, Loc];
%% 								true -> %% 非上阵宠物
%% 									[0, 0, 0]
%% 							end							
%% 					end
%% 			end
%% 	end.
%% 
%% %% 宠物融合
%% fusion_pet(Status, Type) ->
%% 	Info = init_fusion_pet(),
%% 	if 
%% 		Info#pet_fusion.first_petid =:= 0 ->
%% 			[2, 0, 0, 0, Status]; %% 没有设置主宠
%% 		Info#pet_fusion.sec_petid =:= 0 orelse Info#pet_fusion.third_petid =:= 0 ->
%% 			[3, 0, 0, 0, Status]; %% 没有设置副宠
%% 		true ->
%% 			[GoodTypeId, NeedNum] = data_pet:get_fusion_goodsid(Info#pet_fusion.main_qly),
%% 			Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 			if 
%% 				NeedNum > Num -> 
%% 					[4, 0, 0 , 0, Status]; %% 没有仙器
%% 				true ->
%% 					Pet1 = get_own_pet(Status#player.id, Info#pet_fusion.first_petid),
%% 					Pet2 = get_own_pet(Status#player.id, Info#pet_fusion.sec_petid),
%% 					Pet3 = get_own_pet(Status#player.id, Info#pet_fusion.third_petid),
%% 					R1 = is_can_fusion(Status, Pet1, 0),
%% 					R2 = is_can_fusion(Status, Pet2, 1),
%% 					R3 = is_can_fusion(Status, Pet3, 1),
%% 					%%io:format("~s fusion_pet[~p] \n ",[misc:time_format(now()), [R1,R2,R3]]),
%% 					if 
%% 						R1 =/= 1 orelse R2 =/= 1 orelse R3 =/= 1 ->
%% 							[5, 0, 0, 0, Status]; %% 宠物不能融合						
%% 						true ->							
%% 							[Num1, Num2, Num3] = get_spar_number(Status, [Status#player.id]),
%% 							[MPwr1, MTch1, MMgc1, Soul1] = change_to_spar(Pet1, Type-1),
%% 							[MPwr2, MTch2, MMgc2, Soul2] = change_to_spar(Pet2, Type-1),
%% 							[MPwr3, MTch3, MMgc3, Soul3] = change_to_spar(Pet3, Type-1),
%% 							NumLimit = data_pet:get_spar_limit(),
%% 							
%% 							Gold = data_pet:get_refinement_gold(Pet1) +data_pet:get_refinement_gold(Pet2) + data_pet:get_refinement_gold(Pet3) ,
%% 							if 
%% 								Type =:= 2 andalso Status#player.viplv < 3 -> [6, 0, 0, 0, Status]; %% 黄金炼化，vip等级不足
%% 								Type =:= 2 andalso Status#player.gold < Gold -> [7, 0, 0, 0, Status]; %% 黄金炼化，元宝不足
%% 								Num1 + MPwr1 + MPwr2 + MPwr3 > NumLimit -> [8, 0, 0, 0, Status]; %% 融合后超出晶石数量
%% 								Num2 + MTch1 + MTch2 + MTch3 > NumLimit -> [8, 0, 0, 0, Status]; %% 融合后超出晶石数量
%% 								Num3 + MMgc1 + MMgc2 + MMgc3 > NumLimit -> [8, 0, 0, 0, Status]; %% 融合后超出晶石数量
%% 								true ->
%% 									StockList = get_stock_pet(Status#player.id),
%% 									PetCount = length(StockList),
%% 									if 
%% 										PetCount >= Status#player.psn ->
%% 											[9,0,0,0,Status]; %% 宠物数已满
%% 										true ->
%% 											FusionType = data_pet:get_fusion_pettype(Pet1#pet.ptid),
%% 											[Result, PetId, _PetName, _NewStatus] = create_pet(Status,[FusionType, Pet1#pet.tlid, Pet1#pet.tlid1, 1, 1]),
%% 											if 
%% 												Result =/= 1 ->
%% 													%%io:format("~s fusion_pet create[~p/~p/~p] \n ",[misc:time_format(now()), Result, Pet1#pet.ptid, FusionType]),
%% 													[10, 0, 0, 0, Status];%% 融合成新宠物失败
%% 												true -> %% 融合成功
%% 													%% 删除被融合宠物
%% 													
%% 													%% 删除进程字典信息
%% 													delete_own_pet(Status#player.id, Pet1#pet.id),
%% 													delete_own_pet(Status#player.id, Pet2#pet.id),
%% 													delete_own_pet(Status#player.id, Pet3#pet.id),
%% 													
%% 													%% 删除数据库信息
%% 													db_agent_pet:free_pet(Pet1#pet.id),
%% 													db_agent_pet:free_pet(Pet2#pet.id),
%% 													db_agent_pet:free_pet(Pet3#pet.id),
%% 													
%% 													%% 融合日志
%% 													if
%% 														Pet1#pet.qly > 3 orelse Pet1#pet.ptid =:= 603001111-> %% %% 紫宠以上或龙魄的才记录
%% 															%% 记录融合宠物日记
%% 															spawn(fun()->catch(db_log_agent:free_pet_log(Pet1,3))end);
%% 														true -> skip
%% 													end,
%% 													
%% 													if
%% 														Pet2#pet.qly > 3 orelse Pet2#pet.ptid =:= 603001111-> %% %% 紫宠以上或龙魄的才记录
%% 															%% 记录融合宠物日记
%% 															spawn(fun()->catch(db_log_agent:free_pet_log(Pet2,3))end);
%% 														true -> skip
%% 													end,
%% 													
%% 													if
%% 														Pet3#pet.qly > 3 orelse Pet3#pet.ptid =:= 603001111-> %% %% 紫宠以上或龙魄的才记录
%% 															%% 记录融合宠物日记
%% 															spawn(fun()->catch(db_log_agent:free_pet_log(Pet3,3))end);
%% 														true -> skip
%% 													end,
%% 													
%% 													%% 返还晶石和元魂
%% 													add_spar_num(Status#player.id, 133001,MPwr1 + MPwr2 + MPwr3),
%% 													add_spar_num(Status#player.id, 134001,MTch1 + MTch2 + MTch3),
%% 													add_spar_num(Status#player.id, 135001,MMgc1 + MMgc2 + MMgc3),
%% 													Status1 = lib_soul:add_soul_ext(Status, Soul1 + Soul2 + Soul3, 4133),
%% 													
%% 													%% 扣除元宝
%% 													if
%% 														Type =:= 2 andalso Gold =/= 0->
%% 															NewStatus = lib_goods:cost_money(Status1, Gold, gold, 4134);
%% 														true  ->
%% 															NewStatus = Status1
%% 													end,												
%% 													
%% 													%% 修改融合宠物名													
%% 													Pet = lib_pet:get_own_pet(NewStatus#player.id, PetId),
%% 													NewNick = Pet1#pet.nick,%%lists:concat([tool:to_list(Pet1#pet.nick), "•", 1, "☆"]),
%% 													PetNew = Pet#pet{lv = Pet1#pet.lv, 
%% 																	 exp = Pet1#pet.exp,
%% 																	 tlv1 = Pet1#pet.tlv1,
%% 																	 tlv2 = Pet1#pet.tlv2,
%% 																	 tlv3 = Pet1#pet.tlv3,
%% 																	 speed = Pet1#pet.speed,
%% 																	 nick = NewNick},
%% 													%% 五行珠转移
%% 													lib_bead:change_bead_role(Pet1#pet.id,PetId,NewStatus#player.id),
%% 													NewPet = upgate_pet_attribute(PetNew, 1, 1),
%% 													update_own_pet(NewPet),
%% 													%% 更新数据库信息
%% %%													db_agent_pet:upgate_pet_attribute(NewPet),
%% 													%%spawn(fun()->db_agent_pet:rename_pet(Pet#pet.id, NewNick) end),
%% 													
%% 													%% 清除融合信息
%% 													clean_fusion_pet(),
%% 													
%% 													if 
%% 														NeedNum =/= 0 ->
%% 															%% 删除相应仙器
%% 															gen_server:call(NewStatus#player.other#player_other.pid_goods,
%% 																			{'delete_more', Info#pet_fusion.goods_id,NeedNum});
%% 														true ->
%% 															skip
%% 													end,
%% 													
%% 													[GrowPwr, _NeedPwr, _L1] = data_pet:get_upgrade_need(NewPet#pet.pwn, NewPet#pet.qly),
%% 													[GrowTec, _NeedTec, _L2] = data_pet:get_upgrade_need(NewPet#pet.tcn, NewPet#pet.qly),
%% 													[GrowMgc, _NeedMgc, _L3] = data_pet:get_upgrade_need(NewPet#pet.mgn, NewPet#pet.qly),
%% 													Pwr = NewPet#pet.other#pet_other.pwr,
%% 													Tech = NewPet#pet.other#pet_other.tech,
%% 													Mgc = NewPet#pet.other#pet_other.mgc,
%% 													
%% 													ValueP = data_pet:get_upgrade_level(NewPet#pet.pwn , NewPet#pet.qly),
%% 													ValueT = data_pet:get_upgrade_level(NewPet#pet.tcn , NewPet#pet.qly),
%% 													ValueM = data_pet:get_upgrade_level(NewPet#pet.mgn , NewPet#pet.qly),
%% 													Total =ValueP + ValueT + ValueM,
%% 													
%% 													AptitudeSpeed = NewPet#pet.speed,
%% 													Speed = NewPet#pet.other#pet_other.speed,
%% 													
%% 													Data = data_pet:pack_pet_data(NewStatus, FusionType, NewPet#pet.nick, NewPet#pet.lv, 
%% 																				  NewPet#pet.tlid, NewPet#pet.tlid1, NewPet#pet.tlv1, NewPet#pet.tlv2, 
%% 																				  Pwr, Tech, Mgc, GrowPwr, GrowTec, GrowMgc, Total, Speed, AptitudeSpeed),
%% 													{ok, BinData} = pt_11:write(11080,  105, Data),
%% 													lib_send:send_to_all(BinData),
%% 													[1, FusionType, Pet1#pet.tlid, Pet1#pet.tlid1, NewStatus]
%% 											end
%% 									end
%% 							end
%% 					end
%% 			end
%% 	end.
%% 
%% %% 验证宠物融合信息
%% get_fusion_info(Status) ->
%% 	Info = init_fusion_pet(),
%% 	if 
%% 		Info#pet_fusion.first_petid =:= 0 ->
%% 			[[], 0, 0, 0, 0]; %% 没有设置主宠
%% 		true ->
%% 			%% 验证主宠
%% 			Pet1 = get_own_pet(Status#player.id, Info#pet_fusion.first_petid),
%% 			case is_can_fusion(Status, Pet1, 0) of
%% 				1 ->
%% 					%% 验证副宠
%% 					if
%% 						Info#pet_fusion.sec_petid =/= 0->
%% 							Pet2 = get_own_pet(Status#player.id, Info#pet_fusion.sec_petid),
%% 							case is_can_fusion(Status, Pet2, 1) of
%% 								1 ->
%% 									SecId = Info#pet_fusion.sec_petid;
%% 								_ ->
%% 									SecId = 0
%% 							end;
%% 						true ->
%% 							SecId = 0
%% 					end,
%% 					%% 验证副宠		
%% 					if
%% 						Info#pet_fusion.third_petid =/= 0->
%% 							Pet3 = get_own_pet(Status#player.id, Info#pet_fusion.third_petid),
%% 							case is_can_fusion(Status, Pet3, 1) of
%% 								1 ->
%% 									ThirdId = Info#pet_fusion.third_petid;
%% 								_ ->
%% 									ThirdId = 0
%% 							end;
%% 						true ->
%% 							ThirdId = 0
%% 					end,
%% 					
%% 					if
%% 						SecId =/= 0 ->
%% 							L1 = [[0, Info#pet_fusion.first_petid], [1, SecId]];
%% 						true ->
%% 							L1 = [[0, Info#pet_fusion.first_petid]]
%% 					end,
%% 					
%% 					if 
%% 						ThirdId =/= 0 ->
%% 							L2 = L1 ++ [[2, ThirdId]];
%% 						true ->
%% 							L2 = L1
%% 					end,
%% 					
%% 					%% 验证仙器
%% 					[GoodTypeId, NeedNum] = data_pet:get_fusion_goodsid(Info#pet_fusion.main_qly),
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 					if
%% 						Num >= NeedNum  ->
%% 							GooodId = GoodTypeId;
%% 						true ->
%% 							GooodId = 0
%% 					end,
%% 					
%% 					%% 更新进程字典数据
%% 					NewInfo = Info#pet_fusion{									
%% 									sec_petid = SecId,                   %% 副宠1
%% 									third_petid = ThirdId,                    %% 副宠2
%% 									goods_id = GoodTypeId					%%  仙器
%% 								   },
%% 					
%% 					put(player_fusion, NewInfo),
%% 					
%% 					FusionType = data_pet:get_fusion_pettype(Pet1#pet.ptid),
%% 					if 
%% 						FusionType =:= 0 -> %% 该主宠不能融合
%% 							%% 清除融合信息
%% 							clean_fusion_pet(),
%% 							[[], 0, 0, 0, 0]; %% 没有设置主宠
%% 						true ->
%% 							[L2, GooodId, FusionType, Pet1#pet.tlid, Pet1#pet.tlid1]
%% 					end;
%% 				_ -> %% 主宠不可融合
%% 					%% 清除融合信息
%% 					clean_fusion_pet(),
%% 					[[], 0, 0, 0, 0] %% 没有设置主宠
%% 			end
%% 	end.
%% 
%% %% 融合阵上的宠物交换
%% exchange_fusion_info(Status, [Start, End]) ->
%% 	%% 验证宠物融合信息
%% 	get_fusion_info(Status),
%% 	if 
%% 		Start < 0 orelse Start > 2 ->
%% 			[2, 0, 0, 0, 0, 0]; %% 位置数据错误
%% 		End < 0 orelse End > 2 ->
%% 			[2, 0, 0, 0, 0, 0]; %% 位置数据错误
%% 		Start =:= End ->
%% 			[2, 0, 0, 0, 0, 0]; %% 位置数据错误
%% 		true ->
%% 			if 
%% 				Start > End ->
%% 					Loc1 = End,
%% 					Loc2 = Start;
%% 				true ->
%% 					Loc1 = Start,
%% 					Loc2 = End
%% 			end,
%% 			Info = init_fusion_pet(),
%% %% 			io:format("~s exchange_fusion_info[~p] \n ",[misc:time_format(now()), Info]),
%% 			case [Loc1, Loc2] of
%% 				[0, 1] ->
%% 					Pet = get_own_pet(Status#player.id, Info#pet_fusion.sec_petid),					
%% 					R = is_can_fusion(Status, Pet, 0),
%% 					if 
%% 						Info#pet_fusion.first_petid =:= 0 orelse Info#pet_fusion.sec_petid =:= 0 ->
%% 							[3, 0, 0, 0, 0, 0]; %% 格子上没有设置宠物
%% 						R =/= 1 ->
%% 							[4, 0, 0, 0, 0, 0]; %% 不满足主宠要求
%% 						true ->
%% 							%% 更新进程字典数据
%% 							NewInfo = Info#pet_fusion{
%% 									first_petid = Info#pet_fusion.sec_petid,								
%% 									sec_petid = Info#pet_fusion.first_petid                   
%% 								   },
%% 							put(player_fusion, NewInfo),
%% 							
%% 							Pet = get_own_pet(Status#player.id, Info#pet_fusion.sec_petid),
%% 							FusionType = data_pet:get_fusion_pettype(Pet#pet.ptid),
%% 							[1, Start, End, FusionType, Pet#pet.tlid, Pet#pet.tlid1]
%% 					end;						
%% 				[0, 2] ->
%% 					Pet = get_own_pet(Status#player.id, Info#pet_fusion.third_petid),					
%% 					R = is_can_fusion(Status, Pet, 0),
%% 					if 
%% 						Info#pet_fusion.first_petid =:= 0 orelse Info#pet_fusion.third_petid =:= 0 ->
%% 							[3, 0, 0, 0, 0, 0]; %% 格子上没有设置宠物
%% 						R =/= 1 ->
%% 							[4, 0, 0, 0, 0, 0]; %% 不满足主宠要求
%% 						true ->
%% 							%% 更新进程字典数据
%% 							NewInfo = Info#pet_fusion{
%% 									first_petid = Info#pet_fusion.third_petid,								
%% 									third_petid = Info#pet_fusion.first_petid                  
%% 								   },
%% 							put(player_fusion, NewInfo),
%% 							
%% 							Pet = get_own_pet(Status#player.id, Info#pet_fusion.third_petid),
%% 							FusionType = data_pet:get_fusion_pettype(Pet#pet.ptid),
%% 							[1, Start, End, FusionType, Pet#pet.tlid, Pet#pet.tlid1]
%% 					end;	
%% 				[1, 2] ->
%% 					%%io:format("~s exchange_fusion_info[~p] \n ",[misc:time_format(now()), Info]),					
%% 					if 
%% 						Info#pet_fusion.sec_petid =:= 0 andalso Info#pet_fusion.third_petid =:= 0 ->
%% 							[3, 0, 0, 0, 0, 0]; %% 格子上没有设置宠物
%% 						true ->
%% 							%% 更新进程字典数据
%% 							NewInfo = Info#pet_fusion{
%% 									sec_petid = Info#pet_fusion.third_petid,								
%% 									third_petid = Info#pet_fusion.sec_petid                 
%% 								   },
%% 							put(player_fusion, NewInfo),
%% 							
%% 							Pet = get_own_pet(Status#player.id, Info#pet_fusion.first_petid),
%% 							FusionType = data_pet:get_fusion_pettype(Pet#pet.ptid),
%% 							[1, Start, End, FusionType, Pet#pet.tlid, Pet#pet.tlid1]
%% 					end	
%% 			end
%% 	end.
%% 
%% %% 可强化宠物列表
%% get_strengthen_pets(Status) ->
%% 	%% 获取所有宠物
%% 	PetList = get_stock_pet(Status#player.id),
%% 	%% 获取所有珍宠物
%% 	StPetList = [Pet || Pet <- PetList, Pet#pet.qly =:= 6 orelse Pet#pet.qly =:= 8],
%% 	[GoodTypeId, _NeedNum] = data_pet:get_strengthen_goodsid(6),
%% 	Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 	[StPetList, Num].
%% 
%% %% 宠物强化
%% strengthen_pet(Status, PetId) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	case Pet of
%% 		[] -> %% 宠物不存在
%% 			[3, 0];
%% 		_ ->
%% 			ValueP = data_pet:get_upgrade_level(Pet#pet.pwn , Pet#pet.qly),
%% 			ValueT = data_pet:get_upgrade_level(Pet#pet.tcn , Pet#pet.qly),
%% 			ValueM = data_pet:get_upgrade_level(Pet#pet.mgn , Pet#pet.qly),
%% 			Total =ValueP + ValueT + ValueM,
%% 			NeedLevel = data_pet:get_strengthen_need_level(Pet#pet.star, Pet#pet.qly),
%% 			if 
%% 				Pet#pet.qly =/= 6 andalso Pet#pet.qly =/= 8->
%% 					[4, 0]; %% 宠物不能强化
%% 				Pet#pet.star =:= 10 ->
%% 					[5, 0]; %% 宠物已经满星
%% 				NeedLevel > Total ->
%% 					[6, 0]; %% 晶石总阶数不足
%% 				true ->					
%% 					[GoodTypeId, NeedNum] = data_pet:get_strengthen_goodsid(Pet#pet.qly),
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 					if 
%% 						NeedNum > Num ->
%% 							[7, 0]; %% 没有足够的升星丹
%% 						true ->
%% 							case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_more', GoodTypeId,1}) of
%% 								1 -> %% 成功扣除升星丹
%% 									AddPoint = data_pet:get_strengthen_addpoint(),
%% 									[NewStar, NewPoint] = data_pet:get_new_star(Pet#pet.star, Pet#pet.sch + AddPoint, Pet#pet.qly),
%% 									Pet1 = Pet#pet{star = NewStar, sch = NewPoint},
%% 									%% 重新计算宠物属性
%% 									NewPet = upgate_pet_attribute(Pet1, 0, 1),
%% 									%% 更新进程字典
%% 									update_own_pet(NewPet),
%% 									%% 更新数据库
%% 									db_agent_pet:updata_pet_star(NewPet#pet.id, NewStar, NewPoint),
%% 									
%% 									if 
%% 										NewStar =/= Pet#pet.star -> %% 升星成功
%% 											%% 增加升星日志
%% 											Timestamp = util:unixtime(),
%% 											Data = [Status#player.id, Pet#pet.id, Pet#pet.nick, Pet#pet.star, NewStar, Timestamp, Status#player.rgt],
%% 											spawn(fun()->catch(db_log_agent:stren_pet_log(Data))end),
%% 											
%% 											[GrowPwr, _NeedPwr, _L1] = data_pet:get_upgrade_need(NewPet#pet.pwn, NewPet#pet.qly),
%% 											[GrowTec, _NeedTec, _L2] = data_pet:get_upgrade_need(NewPet#pet.tcn, NewPet#pet.qly),
%% 											[GrowMgc, _NeedMgc, _L3] = data_pet:get_upgrade_need(NewPet#pet.mgn, NewPet#pet.qly),
%% 											
%% 											Pwr = NewPet#pet.other#pet_other.pwr,
%% 											Tech = NewPet#pet.other#pet_other.tech,
%% 											Mgc = NewPet#pet.other#pet_other.mgc,
%% 											
%% 											ValueP = data_pet:get_upgrade_level(NewPet#pet.pwn , NewPet#pet.qly),
%% 											ValueT = data_pet:get_upgrade_level(NewPet#pet.tcn , Pet#pet.qly),
%% 											ValueM = data_pet:get_upgrade_level(NewPet#pet.mgn , NewPet#pet.qly),
%% 											Total = ValueP + ValueT + ValueM,	
%% 											AptitudeSpeed = NewPet#pet.speed,
%% 											Speed = NewPet#pet.other#pet_other.speed,
%% 											
%% 											Content = data_pet:pack_strengthen_pet_data(Status, NewPet#pet.ptid, NewPet#pet.nick, NewPet#pet.lv,
%% 																						NewPet#pet.tlid, NewPet#pet.tlid1, NewPet#pet.tlv1, NewPet#pet.tlv2,
%% 																						Pwr, Tech, Mgc, GrowPwr, GrowTec, GrowMgc, Total, Speed, AptitudeSpeed, NewStar),
%% 											{ok, BinData} = pt_11:write(11080,  108, Content),
%% 											lib_send:send_to_all(BinData),
%% 											
%% 											[2, AddPoint]; 
%% 										true -> %% 强化成功
%% 											[1, AddPoint]
%% 									end;
%% 								_ -> %% 使用升星丹失败 
%% 									[8, 0]
%% 							end
%% 					end
%% 			end
%% 	end.
%% 
%% %% 可进化宠物列表
%% get_evolution_pets(Status) ->
%% 	%% 获取所有宠物
%% 	PetList = get_stock_pet(Status#player.id),
%% 	%% 获取所有满星珍宠物
%% 	StPetList = [Pet || Pet <- PetList, (Pet#pet.qly =:= 6 orelse Pet#pet.qly =:= 8 ) andalso Pet#pet.star =:= 10],
%% 	StPetList.
%% 
%% %% 宠物进化后宠物类型
%% get_evolution_pet_type(Status, PetId) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	case Pet of
%% 		[] -> %% 宠物不存在
%% 			0;
%% 		_ ->
%% 			data_pet:get_evolution_pet_type(Pet#pet.ptid)			
%% 	end.
%% 
%% %% 宠物进化（珍宠和珍粉）
%% evolution_pet(Status, PetId, Type) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	if 
%% 		Pet =:= [] ->			 
%% 			[2, 0, Status];%% 宠物不存在
%% 		Pet#pet.qly =/= 6 andalso Pet#pet.qly =/= 8->
%% 			[3, 0, Status]; %% 宠物不能进化
%% 		Pet#pet.star =/= 10 ->
%% 			[4, 0, Status]; %% 宠物没有满星
%% 		true ->
%% 			[Num1, Num2, Num3] = get_spar_number(Status, [Status#player.id]),
%% 			[MPwr, MTch, MMgc, Soul] = change_to_spar(Pet, Type),
%% 
%% 			NumLimit = data_pet:get_spar_limit(),
%% 			Gold = data_pet:get_refinement_gold(Pet),
%% 			
%% 			PetTypeId = data_pet:get_evolution_pet_type(Pet#pet.ptid),
%% 			if 
%% 				PetTypeId =:= 0 -> [3, 0, Status];%% 宠物不能进化
%% 				Type =:= 1 andalso Status#player.viplv < 3 -> [5, 0, Status]; %% 黄金进化，vip等级不足
%% 				Type =:= 1 andalso Status#player.gold < Gold -> [6, 0, Status]; %% 黄金进化，元宝不足
%% 				Num1 + MPwr > NumLimit -> [7, 0, Status]; %% 进化后超出晶石数量
%% 				Num2 + MTch > NumLimit -> [7, 0, Status]; %% 进化后超出晶石数量
%% 				Num3 + MMgc > NumLimit -> [7, 0, Status]; %% 进化后超出晶石数量
%% 				true ->
%% 					ActPetIdList = lib_formation:getActPet(),
%% 					IsAct = lists:member(Pet#pet.id, ActPetIdList),
%% 					[GoodTypeId, NeedNum] = data_pet:get_evolution_goodsid(Pet#pet.qly),
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 					
%% 					if
%% 						IsAct =:= true ->
%% 							[8, 0, Status];%% 出战宠物不能进化
%% 						NeedNum > Num ->
%% 							[9, 0, Status];%% 没有足够进化丹
%% 						true ->
%% 							[Result, PetId, _PetName, _NewStatus] = create_pet(Status,[PetTypeId, Pet#pet.tlid, Pet#pet.tlid1, 1, 1]),
%% 							if 
%% 								Result =/= 1 ->
%% 									%%io:format("~s evolution_pet create[~p] \n ",[misc:time_format(now()), Result, PetTypeId]),
%% 									[10, 0, Status];%% 进化成新宠物失败
%% 								true -> %% 进化成功
%% 									%% 删除进程字典信息
%% 									delete_own_pet(Status#player.id, Pet#pet.id),
%% 									
%% 									%% 删除数据库信息
%% 									db_agent_pet:free_pet(Pet#pet.id),
%% 													
%% 									%% 进化日志
%% 									if
%% 										Pet#pet.qly > 3 orelse Pet#pet.ptid =:= 603001111-> %% %% 紫宠以上或龙魄的才记录
%% 											%% 记录融合宠物日记
%% 											spawn(fun()->catch(db_log_agent:free_pet_log(Pet,4))end);
%% 										true -> skip
%% 									end,
%% 									
%% 									%% 返还晶石和元魂
%% 									add_spar_num(Status#player.id, 133001,MPwr),
%% 									add_spar_num(Status#player.id, 134001,MTch),
%% 									add_spar_num(Status#player.id, 135001,MMgc),
%% 									Status1 = lib_soul:add_soul_ext(Status, Soul, 4140),
%% 													
%% 									%% 扣除元宝
%% 									if
%% 										Type =:= 1 andalso Gold =/= 0->
%% 											Status2 = lib_goods:cost_money(Status1, Gold, gold, 4141);
%% 										true  ->
%% 											Status2 = Status1
%% 									end,												
%% 													
%% 									%% 修改融合宠物名													
%% 									Pet_1 = lib_pet:get_own_pet(Status2#player.id, PetId),												
%% 									NewPet = Pet_1#pet{nick = Pet#pet.nick},
%% 									update_own_pet(NewPet),
%% 									%% 更新数据库信息
%% 									spawn(fun()->db_agent_pet:rename_pet(Pet#pet.id, Pet#pet.nick) end),
%% 									
%% 									if 
%% 										Status2#player.opid =:= PetId -> %% 改变宠物跟随
%% 											BinPetName = tool:to_binary(NewPet#pet.nick),
%% 											PetIcon = NewPet#pet.icon * 10 + NewPet#pet.qly,
%% 											NewStatus = Status2#player{opid = PetId,
%% 																  other = Status2#player.other#player_other{out_pet_type_id = PetIcon,
%% 																										   out_pet_name = BinPetName}
%% 																 },
%% 											
%% 											{ok, BinData} = pt_41:write(41016, [NewStatus#player.id, BinPetName, PetIcon]),
%% 											db_agent_pet:set_player_outPet(NewStatus#player.id, NewStatus#player.opid),
%% 											lib_player:send_player_attribute(NewStatus, 4),
%% 											mod_scene_agent:send_to_scene(NewStatus#player.scn, BinData);
%% 										true ->
%% 											NewStatus = Status2
%% 									end,													
%% 									
%% 									%% 删除相应进化丹
%% 									if 
%% 										NeedNum =/= 0 ->
%% 											gen_server:call(NewStatus#player.other#player_other.pid_goods,{'delete_more', GoodTypeId,NeedNum});
%% 										true ->
%% 											skip
%% 									end,
%% 							
%% 									[1, PetId, NewStatus]
%% 							end
%% 					end
%% 			end
%% 	end.	
%% 
%% %% 可升级/洗炼宠物天赋列表
%% get_trial_pets(Status) ->
%% 	clean_trial_pet_data(Status),
%% 	
%% 	%% 获取所有宠物
%% 	PetList = get_stock_pet(Status#player.id),
%% 	%% 获取所有满星珍宠物
%% 	TrPetList = [Pet || Pet <- PetList, Pet#pet.qly > 4], %% 橙宠及以上
%% 	TrPetList.
%% 
%% %% 升级宠物天赋
%% upgrade_pet_talent(Status, PetId, Type) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	if 
%% 		Pet =:= [] ->			 
%% 			[2, 0];%% 宠物不存在
%% 		Pet#pet.qly < 5->
%% 			[3, 0]; %% 宠物品质太低，不能升级天赋
%% 		true ->
%% 			case Type of
%% 				1 -> %% 升级天赋1
%% 					Level = data_pet:get_upgrade_talent_level(Pet#pet.tlv1),
%% 					[GoodTypeId, NeedNum] = data_pet:get_upgrade_talent_goodsid(Pet#pet.tlv1 + 1),
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 					if 
%% 						Level > Pet#pet.lv -> 
%% 							[4, 0]; %% 等级不足
%% 						NeedNum > Num ->
%% 							[5, 0]; %% 天赋丹不足
%% 						true ->
%% 							%% 使用天赋丹							
%% 							case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_more', GoodTypeId, NeedNum}) of
%% 								1 ->
%% 									Pet1 = Pet#pet{tlv1 = Pet#pet.tlv1 + 1},
%% 									%% 重新计算宠物属性
%% 									NewPet = upgate_pet_attribute(Pet1, 0, 1),
%% 									update_own_pet(NewPet),
%% 									%% 更新数据库信息
%% 									db_agent_pet:updata_pet_talent_level(NewPet),
%% 									
%% 									%% 写宠物天赋升级日志
%% 									spawn(fun()->catch(db_log_agent:talent_pet_log(NewPet, 0, Status#player.rgt))end),
%% 									
%% 									[GrowPwr, _NeedPwr, _L1] = data_pet:get_upgrade_need(NewPet#pet.pwn, NewPet#pet.qly),
%% 									[GrowTec, _NeedTec, _L2] = data_pet:get_upgrade_need(NewPet#pet.tcn, NewPet#pet.qly),
%% 									[GrowMgc, _NeedMgc, _L3] = data_pet:get_upgrade_need(NewPet#pet.mgn, NewPet#pet.qly),
%% 											
%% 									Pwr = NewPet#pet.other#pet_other.pwr,
%% 									Tech = NewPet#pet.other#pet_other.tech,
%% 									Mgc = NewPet#pet.other#pet_other.mgc,
%% 									
%% 									ValueP = data_pet:get_upgrade_level(NewPet#pet.pwn , NewPet#pet.qly),
%% 									ValueT = data_pet:get_upgrade_level(NewPet#pet.tcn , Pet#pet.qly),
%% 									ValueM = data_pet:get_upgrade_level(NewPet#pet.mgn , NewPet#pet.qly),
%% 									Total = ValueP + ValueT + ValueM,
%% 									
%% 									AptitudeSpeed = NewPet#pet.speed,
%% 									Speed = NewPet#pet.other#pet_other.speed,
%% 									
%% 									Data = data_pet:pack_talent_pet_data(Status, NewPet#pet.ptid, NewPet#pet.nick, NewPet#pet.lv, 
%% 																		 NewPet#pet.tlid, NewPet#pet.tlid1, NewPet#pet.tlv1, NewPet#pet.tlv2, 
%% 																		 Pwr, Tech, Mgc, GrowPwr, GrowTec, GrowMgc, Total,Speed, AptitudeSpeed, 
%% 																		 NewPet#pet.tlid,NewPet#pet.tlv1),
%% 									{ok, BinData} = pt_11:write(11080,  109, Data),
%% 									lib_send:send_to_all(BinData),
%% 							
%% 									[1, NewPet#pet.tlv1]; %% 天赋升级成功
%% 								_ ->
%% 									[6, 0] %% 使用天赋丹失败
%% 							end
%% 					end;						
%% 				2 -> %% 升级天赋2
%% 					Level = data_pet:get_upgrade_talent_level(Pet#pet.tlv2),
%% 					[GoodTypeId, NeedNum] = data_pet:get_upgrade_talent_goodsid(Pet#pet.tlv2 + 1),
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 					if 
%% 						Level > Pet#pet.lv -> 
%% 							[4, 0]; %% 等级不足
%% 						NeedNum > Num ->
%% 							[5, 0]; %% 天赋丹不足
%% 						true ->
%% 							%% 使用天赋丹
%% 							case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_more', GoodTypeId, NeedNum}) of
%% 								1 ->
%% 									Pet1 = Pet#pet{tlv2 = Pet#pet.tlv2 + 1},
%% 									%% 重新计算宠物属性
%% 									NewPet = upgate_pet_attribute(Pet1, 0, 1),
%% 									update_own_pet(NewPet),
%% 									%% 更新数据库信息
%% 									db_agent_pet:updata_pet_talent_level(NewPet),
%% 									
%% 									%% 写宠物天赋升级日志
%% 									spawn(fun()->catch(db_log_agent:talent_pet_log(NewPet, 0, Status#player.rgt))end),
%% 									
%% 									[GrowPwr, _NeedPwr, _L1] = data_pet:get_upgrade_need(NewPet#pet.pwn, NewPet#pet.qly),
%% 									[GrowTec, _NeedTec, _L2] = data_pet:get_upgrade_need(NewPet#pet.tcn, NewPet#pet.qly),
%% 									[GrowMgc, _NeedMgc, _L3] = data_pet:get_upgrade_need(NewPet#pet.mgn, NewPet#pet.qly),
%% 									
%% 									Pwr = NewPet#pet.other#pet_other.pwr,
%% 									Tech = NewPet#pet.other#pet_other.tech,
%% 									Mgc = NewPet#pet.other#pet_other.mgc,
%% 									
%% 									ValueP = data_pet:get_upgrade_level(NewPet#pet.pwn , NewPet#pet.qly),
%% 									ValueT = data_pet:get_upgrade_level(NewPet#pet.tcn , Pet#pet.qly),
%% 									ValueM = data_pet:get_upgrade_level(NewPet#pet.mgn , NewPet#pet.qly),
%% 									Total = ValueP + ValueT + ValueM,
%% 									
%% 									AptitudeSpeed = NewPet#pet.speed,
%% 									Speed = NewPet#pet.other#pet_other.speed,
%% 									
%% 									Data = data_pet:pack_talent_pet_data(Status, NewPet#pet.ptid, NewPet#pet.nick, NewPet#pet.lv, 
%% 																		 NewPet#pet.tlid, NewPet#pet.tlid1, NewPet#pet.tlv1, NewPet#pet.tlv2, 
%% 																		 Pwr, Tech, Mgc, GrowPwr, GrowTec, GrowMgc, Total, Speed, AptitudeSpeed, 
%% 																		 NewPet#pet.tlid1,NewPet#pet.tlv2),
%% 									{ok, BinData} = pt_11:write(11080,  109, Data),
%% 									lib_send:send_to_all(BinData),
%% 									
%% 									[1, NewPet#pet.tlv2]; %% 天赋升级成功
%% 								_ ->
%% 									[6, 0] %% 使用天赋丹失败
%% 							end
%% 					end;
%% 				_ -> %% 升级天赋类型错误
%% 					[8, 0]
%% 			end
%% 	end.
%% 
%% %% 获取洗炼天赋数据
%% get_trial_data() ->
%% 	Data = get(trial_data),
%% 	if 
%% 		Data =:= undefined ->
%% 			[0, 0, 0, 0];
%% 		true ->
%% 			Data
%% 	end.
%% 
%% %% 清除宠物洗炼天赋
%% clean_trial_pet_data(_Status) ->
%% 	Data = [0, 0, 0, 0],
%% 	put(trial_data, Data),
%% 	
%% 	1.	
%% 
%% %% 洗炼宠物天赋
%% trial_pet_talent(Status, PetId, Lock) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	if 
%% 		Pet =:= [] ->			 
%% 			[2, 0, 0,Status];%% 宠物不存在
%% 		Pet#pet.qly < 5->
%% 			[3, 0, 0,Status]; %% 宠物品质太低，不能洗炼天赋
%% 		Lock > 2 orelse Lock < 0 -> 
%% 			[4, 0, 0,Status]; %% 锁定天赋错误
%% 		true ->
%% 			Gold = data_pet:get_lock_talent(Lock),
%% 			if 
%% 				Gold > Status#player.gold ->
%% 					[5, 0, 0,Status]; %% 元宝不足
%% 				true ->
%% 					[GoodTypeId, NeedNum] = data_pet:get_trial_talent_goodsid(Pet#pet.tlv2),
%% 					Num = goods_util:get_goods_num(Status#player.id, GoodTypeId),
%% 					if 
%% 						NeedNum > Num ->
%% 							[6, 0, 0,Status]; %% 洗练丹不足
%% 						true ->
%% 							%% 使用洗练丹
%% 							case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_more', GoodTypeId, NeedNum}) of
%% 								1 ->
%% 									%%io:format("trial_pet_talent:[~p/~p/~p]\n",[Pet#pet.tlid, Pet#pet.tlid1, Lock]),
%% 									[T1, T2] = data_pet:trial_talent(Pet#pet.tlid, Pet#pet.tlid1, Lock),
%% 									%%io:format("trial_pet_talent:[~p/~p]\n",[T1, T2]),
%% 									Data = [Pet#pet.id, T1, T2, Lock],
%% 									put(trial_data, Data),
%% 									NewStatus = lib_goods:cost_money(Status, Gold, gold, 4144),
%% 									
%% 									[1, T1, T2, NewStatus]; %% 天赋升级成功
%% 								_ ->
%% 									[7, 0, 0, Status] %% 使用天赋丹失败
%% 							end
%% 					end
%% 			end
%% 	end.
%% 
%% %% 更换宠物天赋
%% updata_pet_talent(Status, PetId) ->
%% 	Pet = get_own_pet(Status#player.id, PetId),
%% 	if 
%% 		Pet =:= [] ->			 
%% 			[2, 0, 0];%% 宠物不存在
%% 		Pet#pet.qly < 5->
%% 			[3, 0, 0]; %% 宠物品质太低，不能洗炼天赋
%% 		true ->
%% 			[Pid, T1, T2, Lock] = get_trial_data(),
%% 			if 
%% 				Pid =/= PetId -> 
%% 					[4, 0, 0]; %% 此宠物没有洗炼天赋
%% 				true ->
%% 					clean_trial_pet_data(Status),
%% 					Pet1 = Pet#pet{tlid = T1, tlid1 = T2},
%% 					%% 重新计算宠物属性
%% 					NewPet = upgate_pet_attribute(Pet1, 0, 1),
%% 					update_own_pet(NewPet),
%% 					%% 更新数据库信息
%% 					db_agent_pet:updata_pet_talent(NewPet),
%% 					case Lock of
%% 						1 ->
%% 							Show1 = 0,
%% 							case lists:member(T2, [2001,2006,3002,3003,3004,3005,3007,3008,3009,3010,3011,1001,2002,2003]) of
%% 								true ->	Show2 = 1;
%% 								_ -> Show2 = 0
%% 							end;
%% 						2 ->
%% 							Show2 = 0,
%% 							case lists:member(T1, [2001,2006,3002,3003,3004,3005,3007,3008,3009,3010,3011,1001,2002,2003]) of
%% 								true ->	Show1 = 1;
%% 								_ -> Show1 = 0
%% 							end;
%% 						_ ->
%% 							case lists:member(T1, [2001,2006,3002,3003,3004,3005,3007,3008,3009,3010,3011,1001,2002,2003]) of
%% 								true ->	Show1 = 1;
%% 								_ -> Show1 = 0
%% 							end,
%% 							
%% 							case lists:member(T2, [2001,2006,3002,3003,3004,3005,3007,3008,3009,3010,3011,1001,2002,2003]) of
%% 								true ->	Show2 = 1;
%% 								_ -> Show2 = 0
%% 							end						
%% 					end,
%% 					
%% 					if
%% 						Show1 =:= 1 orelse Show2 =:= 1 ->
%% 							[GrowPwr, _NeedPwr, _L1] = data_pet:get_upgrade_need(NewPet#pet.pwn, NewPet#pet.qly),
%% 							[GrowTec, _NeedTec, _L2] = data_pet:get_upgrade_need(NewPet#pet.tcn, NewPet#pet.qly),
%% 							[GrowMgc, _NeedMgc, _L3] = data_pet:get_upgrade_need(NewPet#pet.mgn, NewPet#pet.qly),
%% 							
%% 							Pwr = NewPet#pet.other#pet_other.pwr,
%% 							Tech = NewPet#pet.other#pet_other.tech,
%% 							Mgc = NewPet#pet.other#pet_other.mgc,
%% 							ValueP = data_pet:get_upgrade_level(NewPet#pet.pwn , NewPet#pet.qly),
%% 						  	ValueT = data_pet:get_upgrade_level(NewPet#pet.tcn , Pet#pet.qly),
%% 						  	ValueM = data_pet:get_upgrade_level(NewPet#pet.mgn , NewPet#pet.qly),
%% 						  	Total = ValueP + ValueT + ValueM,	
%% 							
%% 							AptitudeSpeed = NewPet#pet.speed,
%% 							Speed = NewPet#pet.other#pet_other.speed,
%% 							Data = data_pet:pack_pet_talent_data(Status, NewPet#pet.ptid, NewPet#pet.nick, NewPet#pet.lv, 
%% 														  		 NewPet#pet.tlid, NewPet#pet.tlid1, NewPet#pet.tlv1, NewPet#pet.tlv2, 
%% 																 Pwr, Tech, Mgc, GrowPwr, GrowTec, GrowMgc, Total, Speed, AptitudeSpeed,  
%% 																 Show1, Show2),
%% 							{ok, BinData} = pt_11:write(11080, 107, Data),
%% 							lib_send:send_to_all(BinData);
%% 						true ->
%% 							ok
%% 					end,
%% 					
%% 					
%% 					%% 写宠物天赋更改日志
%% 					spawn(fun()->catch(db_log_agent:talent_pet_log(NewPet, 1, Status#player.rgt))end),
%% 					
%% 					[1, T1, T2]
%% 			end
%% 	end.
%% %% -----------------------------------------------------------------
%% %% 删除角色
%% %% -----------------------------------------------------------------
%% delete_role(PlayerId) ->
%%     % 删除宠物表记录
%%     db_agent_pet:lp_delete_role(PlayerId),
%%     ok.
%% 
%% %%通过mod_offline更新ETS表中的宠物属性, 玩家进程由使用
%% update_petattr_for_offine(PlayerId) ->
%% 	PetList = get_act_pets(PlayerId),	%%取玩家的出战宠物列表
%% 	PetAttrBin = pack_petList_attr(PetList),	%%打包宠物列表属性
%% 	gen_server:cast(mod_offline:get_mod_offline_pid(),{offline_u_update, PlayerId, PetAttrBin, pattr}).
%% 
%% %%通过mod_offline更新ETS表中的宠物属性, 可用于非玩家进程内
%% update_petattr_for_offine(PlayerId, PetList) ->
%% 	PetAttrBin = pack_petList_attr(PetList),	%%打包宠物列表属性
%% 	gen_server:cast(mod_offline:get_mod_offline_pid(),{offline_u_update, PlayerId, PetAttrBin, pattr}).
%% 
%% %%打包宠物列表属性, 辅助函数
%% pack_petList_attr(PetList) ->
%% 	pt_41:pack_petList_attr(PetList).
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
%%             [R] = Record,
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
%%             [R] = Record,
%%             R
%%     end.
%% 
%% match_all(Table, Pattern) ->
%%     ets:match_object(Table, Pattern).
%% 
%% change_pet_icon() ->
%% 	PetList = db_agent_pet:select_all_pet(),
%% 	NewPetList = lists:map(fun(PetInfo) ->
%% 					Pet = list_to_tuple([pet | PetInfo]),				
%% 			List = [pet | PetInfo],
%% 			Pet = list_to_tuple(List)
%% 		end,PetList),
%% 	
%% 	lists:map(fun(Pet1) ->
%% 		NewIcon = 
%% 			case Pet1#pet.icon of
%% 				90 -> 134;
%% 				71 -> 132;
%% 				20 -> 155;
%% 				74 -> 136;
%% 				59 -> 156;
%% 				40 -> 151;
%% 				15 -> 154;				
%% 				_ -> Pet1#pet.icon
%% 			end,
%% 			
%% 		if 
%% 			NewIcon =/= Pet1#pet.icon ->
%% 				Pet2 = Pet1#pet{icon = NewIcon},
%% 				db_agent_pet:change_pet_data(Pet2);
%% 			true ->
%% 				skip
%% 		end
%% 		end,
%% 	NewPetList),
%% 	
%% 	ok.
%% 	
%% change_pet_data() ->	
%% 	%%load_base_pet(),
%% 	
%% 	PetList = db_agent_pet:select_all_pet(),
%% 	NewPetList = lists:map(fun(PetInfo) ->
%% 					Pet = list_to_tuple([pet | PetInfo]),				
%% 			List = [pet | PetInfo],
%% 			Pet = list_to_tuple(List)
%% 		end,PetList),
%% 	
%% 	lists:map(fun(Pet1) ->
%% 			NewTypeId = data_pet:change_type_id(Pet1#pet.ptid),
%% 			PetTypeInfo = get_base_pet(NewTypeId),
%% 			if	
%% 				is_record(PetTypeInfo,ets_base_pet) =:= false ->
%% 					NewPet = Pet1;
%% 				true ->
%% 					NewPet1 = init_pet(Pet1#pet.uid, PetTypeInfo, Pet1#pet.tlid, Pet1#pet.tlid1, Pet1#pet.cell, Pet1#pet.id, Pet1#pet.speed),
%% 					NewPet = NewPet1#pet{lv = Pet1#pet.lv,
%% 										 exp = Pet1#pet.exp,
%% 										 hp =  Pet1#pet.hp,
%% 										 pwn = Pet1#pet.pwn,
%% 										 tcn = Pet1#pet.tcn,
%% 										 mgn = Pet1#pet.mgn,
%% 										 nick = Pet1#pet.nick,
%% 										 rnct = Pet1#pet.rnct,
%% 										 rela = Pet1#pet.rela,
%% 										 psta = Pet1#pet.psta}
%% 			end,
%% 					
%% 			NewQly = NewPet#pet.qly,
%% 			if 
%% 				NewQly =:= 5 -> %% 橙宠双天赋
%% 					if 
%% 						Pet1#pet.tlid < 11 ->
%% 							TalentId = Pet1#pet.tlid + 4;
%% 						true ->
%% 							TalentId = Pet1#pet.tlid
%% 					end,
%% 					
%% 					RTalent1 = random:uniform(10000),%%util:rand(0,10000),
%% 					TalentId11 = data_hunt:get_talent_by_ratio(NewQly, RTalent1),
%% 					if 
%% 						TalentId11 =:= TalentId ->
%% 							RTalent2 = 1100+ random:uniform(7800),%%util:rand(1100, 8900),
%% 							RTalent3 = (RTalent1 + RTalent2) rem 10000,
%% 							TalentId1 = data_hunt:get_talent_by_ratio(PetTypeInfo#ets_base_pet.qly, RTalent3);
%% 						true ->
%% 							TalentId1 = TalentId11
%% 					end;							
%% 				true ->
%% 					TalentId = Pet1#pet.tlid,
%% 					TalentId1 = 0
%% 			end,
%% 			Pet2 = NewPet#pet{ptid = NewTypeId, qly = NewQly, tlid = TalentId, tlid1 = TalentId1},
%% 			Pet3 = add_exp(Pet2, Pet2#pet.exp),
%% 			
%% 			if 
%% 				Pet3#pet.lv > NewPet#pet.lv ->
%% 					UpLevel = Pet3#pet.lv - NewPet#pet.lv,
%% 					Pet4 = upgate_pet_attribute(Pet3, UpLevel, 1);
%% 				true ->
%% 					Pet4 = upgate_pet_attribute(Pet3, 0, 1)
%% 			end,
%% 			db_agent_pet:change_pet_data(Pet4)									
%% 		end,
%% 	NewPetList),
%% 	
%% 	ok.
%% 
%% %% 获取宠物补偿
%% get_pet_cover(PlayerId) ->
%% 	PetList =  db_agent_pet:select_player_all_pet(PlayerId),
%% 	NewPetList = lists:map(fun(PetInfo) ->
%% 					Pet = list_to_tuple([pet | PetInfo]),				
%% 			List = [pet | PetInfo],
%% 			Pet = list_to_tuple(List)
%% 		end,PetList),
%% 	
%% 	lists:map(fun(Pet1) ->
%% 		case PetTypeInfo = get_base_pet(Pet1#pet.ptid) of
%% 			[] ->
%% 				ok;
%% 			PetTypeInfo ->
%% 				Crr = PetTypeInfo#ets_base_pet.crr,
%% 				NewIcon = PetTypeInfo#ets_base_pet.icon,
%% 				Teid = PetTypeInfo#ets_base_pet.sklid,
%% 				if 
%% 					Pet1#pet.speed =:= 0 orelse Pet1#pet.speed > 4 ->
%% 						Speed = data_pet:get_aptitude_speed();
%% 					true ->
%% 						Speed = Pet1#pet.speed
%% 				end,
%% 					
%% 				Pet2 = Pet1#pet{icon = NewIcon, speed = Speed, teid = Teid, crr = Crr},
%% 				db_agent_pet:change_pet_data2(Pet2)
%% 		end
%% 		end,
%% 	NewPetList),
%% 	
%% 	[].
%% 
%% %% ===========================================================
%% %% 宠物阴阳历 
%% %% ===========================================================
%% 
%% int_pet_calendar(Status) ->
%% 
%% 	if 
%% 		Status#player.stsw band 1024 =:= 0 ->
%% 			put(open_calendar, 0);
%% 		true ->
%% 			put(open_calendar, 1)
%% 	end,
%% 	
%% 	Calendar = get(player_calendar),
%% 	if 
%% 		Calendar =:= undefined ->
%% 			
%% 			{StartTime, _EndTime} = util:get_this_week_duringtime(),
%% 			{{Year1, Month1, Day1}, _} = util:seconds_to_localtime(StartTime),
%% 			Date = Year1*10000 + Month1*100 + Day1,
%% 			
%% 			case get_base_calendar(Date) of
%% 				[] ->				
%% 					ok;					
%% 				Cal ->
%% 				
%% 					put(player_calendar, Cal),			
%% 					
%% 					Cont = Cal#ets_base_calendar.cont,
%% 					Day2 = util:get_date(),
%% 					ContList = [{Race, Day, B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont, Day =:= Day2],
%% 					put(player_calendar_today, ContList),
%% 			
%% 					NowTime = util:unixtime(),
%% 					NextTime = util:get_next_day_seconds(NowTime),
%% 					LeftTime = NextTime - NowTime,
%% 					
%% 					erlang:send_after((LeftTime + 1)*1000, self(), 'check_player_calendar')
%% 			end;			
%% 		true ->
%% 			ok
%% 	end.
%% 	
%% %% 今日阴阳历
%% get_today_calendar(Status) ->
%% 	int_pet_calendar(Status),
%% 	
%% 	Open = get(open_calendar),
%% 	NowTime = util:unixtime(),
%% 	{{_Year1, _Month1, Date}, _} = util:seconds_to_localtime(NowTime),
%% 	Day = util:get_date(),
%% 	if 
%% 		Open =:= 0 ->
%% 			{2, Date, Day, []};
%% 		true ->
%% 			ContList = get(player_calendar_today),			
%% 			if
%% 				ContList =:= undefined ->
%% 					{0, Date, Day, []};
%% 				true ->					
%% 					{1, Date, Day, ContList}
%% 			end
%% 	end.
%% 
%% %% 本周阴阳历
%% get_week_calendar(Status) ->	
%% 	int_pet_calendar(Status),
%% 	Open = get(open_calendar),
%% 	Day = util:get_date(),
%% 	if 
%% 		Open =:= 0 ->
%% 			{2, Day, []};
%% 		true ->
%% 			Calendar = get(player_calendar),
%% 			
%% 			if
%% 				Calendar =:= undefined ->
%% 					{0, Day, []};
%% 				true ->
%% 					Cont = Calendar#ets_base_calendar.cont,
%% 					{1, Day, Cont}
%% 			end
%% 	end.
%% 
%% change_all_pet_calendar() ->
%% 	case get(player_pet) of
%% 		undefined ->
%% 			ok;
%% 		PetList when is_list(PetList) ->
%% 			Fun1 = fun(Pet) ->
%% 				upgate_pet_attribute(Pet, 0, 1)
%% 			end,
%% 			NewPetList = lists:map(Fun1, PetList),
%% 			put(player_pet, NewPetList)
%% 	end.
%% 
%% open_player_calendar(Status) ->
%% 	int_pet_calendar(Status),
%% 	change_all_pet_calendar(),
%% 	
%% 	pp_pet:handle(41020, Status, []),
%% 	
%% 	pp_pet:handle(41021, Status, []),
%% 	 
%% 	ok.
%% 
%% check_player_calendar(Status) ->
%% 	NowTime = util:unixtime(),
%% 	NextTime = util:get_next_day_seconds(NowTime),
%% 	LeftTime = NextTime - NowTime,
%% 	
%% 	{StartTime, _EndTime} = util:get_this_week_duringtime(),
%% 	{{Year1, Month1, Day1}, _} = util:seconds_to_localtime(StartTime),
%% 	Date = Year1*10000 + Month1*100 + Day1,	
%% 			
%% 	case get_base_calendar(Date) of
%% 		[] ->			
%% 			ok;
%% 		Cal ->
%% 			Calendar = get(player_calendar),
%% 			if 
%% 				Calendar =:= Cal ->
%% 					ContToday = get(player_calendar_today),
%% 					Cont = Calendar#ets_base_calendar.cont,
%% 					Day2 = util:get_date(),
%% 					ContList = [{Race, Day, B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont, Day =:= Day2],
%% 					if 
%% 						ContToday =:= ContList ->
%% 							ok;
%% 						true ->
%% 							put(player_calendar_today, ContList),
%% 				
%% 							change_all_pet_calendar(),
%% 							pp_pet:handle(41020, Status, [])													
%% 					end,							
%% 					ok;
%% 				true ->
%% 					put(player_calendar, Cal),					
%% 				
%% 					Cont = Cal#ets_base_calendar.cont,
%% 					Day2 = util:get_date(),
%% 					ContList = [{Race, Day, B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont, Day =:= Day2],
%% 					put(player_calendar_today, ContList),
%% 					
%% 					change_all_pet_calendar(),
%% 					
%% 					pp_pet:handle(41020, Status, []),					
%% 					pp_pet:handle(41021, Status, [])					
%% 			end
%% 	end,
%% 	
%% 	erlang:send_after((LeftTime + 1)*1000, self(), 'check_player_calendar').
%% 
%% get_calendar_value(Pet) ->
%% 	NowTime = util:unixtime(),
%% 	Calendar = get(player_calendar),
%% 	Open = get(open_calendar),
%% 	
%% 	if 
%% 		Open =:= 0 orelse Calendar =:= undefined ->
%% 			NewPet = Pet#pet{copen = 0, csta = 0, ctm = 0, cont = []};
%% 		true ->
%% 			Cont = Calendar#ets_base_calendar.cont,
%% 			Day1 = util:get_date(),
%% 			ContList = [{B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont, Day =:= Day1, Race =:= Pet#pet.race],
%% 			
%% 			case ContList of
%% 				[] ->
%% 					NewPet = Pet#pet{copen = 1, csta = 0, ctm = 0,cont = []};
%% 				_ ->
%% 					{B11, V11, B21, V21} = lists:nth(1, ContList),
%% 					NewPet1 = Pet#pet{copen = 1, csta = 1, ctm = NowTime, cont = [{B11, V11 div 100}, {B21, V21 div 100}]},
%% 					NewPet = data_pet:get_calendar_value(NewPet1, [B11, V11, B21, V21])					
%% 			end
%% 	end,
%% 	NewPet.
%% 
%% 
%% %% 给战斗的接口
%% get_battle_calendar_value(Member) ->
%% 	if 
%% 		Member#battleMember.copen =:= 0 ->
%% 			NewMember = Member;
%% 		true ->
%% 			NowTime = util:unixtime(),
%% 			IsSame = util:is_same_date(Member#battleMember.ctm, NowTime),
%% 			case IsSame of
%% 				true ->
%% 					NewMember = Member;
%% 				_ ->
%% 					%% 减去原来的阴阳历属性
%% 					Member1 = data_pet:sub_battle_calendar_value(Member, Member#battleMember.cont),	
%% 					Cont_1 = get(player_calendar_today),
%% 					Cont = check_calendar_today(Cont_1),
%% 					Day1 = util:get_date(),
%% 					ContList = [{B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont, Day =:= Day1, Race =:= Member#battleMember.race],
%% 					case ContList of
%% 						[] ->
%% 							NewMember = Member1#battleMember{csta = 0, ctm = 0,cont = []};
%% 						_ ->
%% 							{B11, V11, B21, V21} = lists:nth(1, ContList),
%% 							Member2 = Member1#battleMember{csta = 1, ctm = NowTime, cont = [{B11, V11 div 100}, {B21, V21 div 100}]},
%% 							NewMember = data_pet:add_battle_calendar_value(Member2, [B11, V11, B21, V21])	
%% 					end
%% 			end
%% 	end,
%% 	
%% 	NewMember.	
%% 
%% %% 主要处理非玩家进程宠物阴阳历
%% check_calendar_today(Cont) ->	
%% 	NowTime = util:unixtime(),
%% 	
%% 	if 
%% 		Cont =:= undefined ->
%% 			{StartTime, _EndTime} = util:get_this_week_duringtime(),
%% 			{{Year1, Month1, Day1}, _} = util:seconds_to_localtime(StartTime),
%% 			Date = Year1*10000 + Month1*100 + Day1,
%% 			
%% 			case get_base_calendar(Date) of
%% 				[] ->				
%% 					[];					
%% 				Cal ->				
%% 					put(player_calendar, Cal),					
%% 					Cont_1 = Cal#ets_base_calendar.cont,
%% 					Day2 = util:get_date(),
%% 					ContList = [{Race, Day, B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont_1, Day =:= Day2],
%% 					
%% 					put(player_calendar_today, ContList),				
%% 					put(last_time_calendar_today, NowTime),
%% 				
%% 					ContList
%% 			end;			
%% 		true ->
%% 			
%% 			LastTime = get(last_time_calendar_today),
%% 			case is_integer(LastTime) of
%% 				true ->
%% 					case util:is_same_date(LastTime, NowTime) of
%% 						true -> Cont;
%% 						_ ->
%% 							{StartTime, _EndTime} = util:get_this_week_duringtime(),
%% 							{{Year1, Month1, Day1}, _} = util:seconds_to_localtime(StartTime),
%% 							Date = Year1*10000 + Month1*100 + Day1,
%% 							case get_base_calendar(Date) of
%% 								[] ->
%% 									[];
%% 								Cal ->
%% 									put(player_calendar, Cal),
%% 									Cont_1 = Cal#ets_base_calendar.cont,
%% 									Day2 = util:get_date(),
%% 									ContList = [{Race, Day, B1, V1, B2, V2} || {Race, Day, B1, V1, B2, V2} <- Cont_1, Day =:= Day2],
%% 									
%% 									put(player_calendar_today, ContList),									
%% 									put(last_time_calendar_today, NowTime),
%% 									
%% 									ContList
%% 							end
%% 					end; 
%% 				_ ->
%% 					Cont
%% 			end					
%% 	end.
%% 
%% %% %%
%% %% %% Local Functions
%% %%
%% %% -----------------------------------------------------------------
%% %%判断名字长度是否合法（2个字符到10个字符之间， 一个中文当两个字符算）
%% %% -----------------------------------------------------------------
%% validata_name(Name, MinLen, MaxLen) ->
%% 	case asn1rt:utf8_binary_to_list(list_to_binary(Name)) of
%% 		{ok, CharList} ->
%% 			Len = string_width(CharList),
%% 			(Len =< MaxLen andalso Len >= MinLen);
%% 		{error, _Reason} ->
%% 			false
%% 	end.
%% string_width(String) ->
%% 	string_width(String, 0).
%% string_width([], Len) ->
%% 	Len;
%% string_width([H|T], Len) ->
%% 	case H > 255 of
%% 		true ->%%是非英文字符
%% 			string_width(T, Len + 2);
%% 		false ->%%是因为字符或者数字
%% 			string_width(T, Len + 1)
%% 	end.
%% 
%% 
%% %% subtract(A, []) -> A;
%% %% subtract([], _B) -> [];
%% %% subtract(A, [H | T]) ->
%% %% 	A1 = sub(A, [H]),
%% %% 	subtract(A1, T).
%% %% 
%% %% sub(A, []) -> A;
%% %% sub([], _B) -> [];
%% %% sub([H | T], [B1]) ->
%% %% 	if 
%% %% 		H =:= B1 -> T;
%% %% 		true ->  [H | sub(T, [B1])]
%% %% 	end.
%% 	
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
