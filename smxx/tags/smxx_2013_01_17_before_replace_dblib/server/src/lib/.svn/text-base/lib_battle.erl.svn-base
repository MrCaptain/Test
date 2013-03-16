%%------------------
%% Author: liujing
%% Created: 2012-8-6
%% Description: TODO: Add description to lib_battle_new
-module(lib_battle).
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl"). 
-compile(export_all).

%% %%-----------------------------------------------------------------------------------------
%% %%------role_merge/3创建单回合的战斗队列（Player_List-进攻方即左边成员队列（并已按位置顺序排好序），
%% %%--------------------------Mon_List-防守方即右边成员队列（并已按位置顺序排好序），
%% %%--------------------------Result_List-返回的战斗队列）----
%% %%-----------------------------------------------------------------------------------------
%% role_merge(Left_List, Right_List, _R, PDirect) ->
%% 	case PDirect of
%% 		right ->
%% 			role_merge(Right_List, Left_List, []);
%% 		_ ->
%% 			role_merge(Left_List, Right_List, [])
%% 	end.
%% 
%% role_merge([],[],Result_List)->
%% 	Result_List;
%% role_merge(Player_List,Mon_List,Result_List)->
%% 	case Player_List of
%% 		[]->			
%% 			C=Result_List,
%% 			C1=Player_List;
%% 		[A|B]->
%% 			C=Result_List ++ [A],
%% 		  	C1=B;
%% 		_->
%% 			C=Result_List,
%% 			C1=Player_List
%% 	end,
%% 	case Mon_List of
%% 		[]->
%% 			D=C,
%% 			D1=Mon_List;
%% 		[E|F]->
%% 			D=C ++ [E],
%% 			D1=F;
%% 		_->
%% 			D=C,
%% 			D1=Mon_List
%% 	end,
%% 	role_merge(C1,D1,D).
%% 
%% %%----------------------------------------------------------------------------------------------------
%% %%----init_player_role/7加载玩家战斗数据记录（PlayerBattleData-玩家战斗记录数据信息，PlayerFormation-玩家阵法信息，RstFL-玩家阵法相克属性列表，
%% %%------------------------Player_List-战斗成员列表(即阵型表)，Bin_Pos需要写入数据包的玩家信息，Bin_Pet需要写入数据包的宠物信息，
%% %%------------------------Bin_Mon需要写入数据包的怪物信息-------
%% %%----------------------------------------------------------------------------------------------------
%% init_player_role(PlayerBattleData, PlayerFormation, RstFL, Player_List, Bin_Pos, Bin_Pet, Bin_Mon) ->
%% %% 	io:format("~s load_members_data____Left_____[~p]\n",[misc:time_format(now()), PlayerBattleData]),
%% 	{L_Member_List, NewPlayer_List, Bin_Pos1, Bin_Pet1, Bin_Mon1}=load_members_data(PlayerBattleData, PlayerFormation, RstFL, [], [], Player_List, Bin_Pos, Bin_Pet, Bin_Mon),
%% 	
%% 	L_record =#battle_record{%%创建玩家（当为PVP战斗时可以是对方玩家）数据记录
%% 							 bbtid = PlayerFormation#frmt.bbtid,             %%基础阵形ID
%% 							 %%fmlv=1,              %%阵形等级
%% 							 behId = PlayerBattleData#battleData.behId,     %%巨兽ID, 为0表示无
%% 							 nick = PlayerBattleData#battleData.nick,       %%巨兽名称
%% 							 behLv = PlayerBattleData#battleData.behLv,       %%巨兽等级
%% 							 anger = PlayerBattleData#battleData.anger,             %%怒气值,临时修改为60，原来为0
%% 							 maxang = PlayerBattleData#battleData.maxang,          %%怒气上限
%% 							 bact=0,            %%是否攻击，0-未攻击，1-攻击了
%% 							 behThId = PlayerBattleData#battleData.behThId,        %%巨兽技能ID对应巨兽类型
%% 							 techv = PlayerBattleData#battleData.techv,
%% 							 members = L_Member_List,
%% 							 frmtEquipDataR = PlayerBattleData#battleData.frmtEquipDataR,  %%法器信息记录
%% 							 mntDataR = PlayerBattleData#battleData.mntDataR,     %%龙鞍信息记录
%% 							 img = PlayerBattleData#battleData.img,            %%巨兽形象
%% 							 frsl = PlayerBattleData#battleData.frsl,         %%巨兽对阵法的加成属性
%% 							 frlv = PlayerBattleData#battleData.frlv,           %%巨兽对阵法加成的等级
%% 							 qly = PlayerBattleData#battleData.qly,                %%巨兽品质
%% 							 bgid = PlayerBattleData#battleData.bgid,                %%巨兽基础ID
%% 							 teclv = PlayerBattleData#battleData.teclv,          %%巨兽技能等级
%% 							 myatr = PlayerBattleData#battleData.myatr,         %%巨兽对主角的加成属性列表
%% 							 allatr = PlayerBattleData#battleData.allatr,        %%巨兽对全队的加成属性列表
%% 							 crr = PlayerBattleData#battleData.crr
%% 							},
%% 	{L_record, NewPlayer_List, Bin_Pos1, Bin_Pet1, Bin_Mon1}.
%% 
%% %%----------------------------------------------------------------------------------------------------
%% %%----init_mon_role/7加载怪物战斗数据记录（PtgId-怪物群组ID，MonFormation-怪物阵法信息，Mon_List-怪物战斗成员列表(即阵型表)，
%% %%------------------------Bin_Pos需要写入数据包的玩家信息，Bin_Pet需要写入数据包的宠物信息，
%% %%------------------------Bin_Mon需要写入数据包的怪物信息-------
%% %%----------------------------------------------------------------------------------------------------
%% init_mon_role(MonsData, MonFormation, RstFL, Mon_List, Bin_Pos, Bin_Pet, Bin_Mon) -> 
%% 	{R_Member_List, NewMon_List, Bin_Pos1, Bin_Pet1, Bin_Mon1}=load_members_data(MonsData, MonFormation, RstFL, [], [], Mon_List, Bin_Pos, Bin_Pet, Bin_Mon),
%% 	R_record = #battle_record{%%创建怪物数据记录（与怪物对战时用）
%% 							  bbtid = MonFormation#frmt.bbtid,             %%阵形ID
%% 							  %%fmlv=1,              %%阵形等级
%% 							  behId=0,     %%巨兽ID, 为0表示无
%% 							  behLv=1,       %%巨兽等级
%% 							  anger=0,             %%怒气值
%% 							  maxang=100,          %%怒气上限
%% 							  bact=0,            %%是否攻击，0-未攻击，1-攻击了
%% 							  behThId=0,        %%巨兽技能ID
%% 							  members=R_Member_List},       %%由member记录组成的列表
%% 	{R_record, NewMon_List, Bin_Pos1, Bin_Pet1, Bin_Mon1}.
%% 
%% %%----------------------------------------------------------------------------------------------------
%% %%----load_members_data/6加载战斗左右方各组成成员的属性数据记录，组成记录列表Members_List和打包数据返回，
%% %%--------参数信息：（BattleData-战斗数据记录#battleData，Mon_List-怪物战斗成员列表(即阵型表)，Members_List-由#member记录
%% %%----------组成的列表，UnLoad_List-表示未加载的成员列表，Bin_Pos-需要写入数据包的玩家信息，Bin_Pet-需要写
%% %%----------入数据包的宠物信息，Bin_Mon-需要写入数据包的怪物信息-------
%% %%----------------------------------------------------------------------------------------------------
%% load_members_data(_BattleData, _Formation, _RstFL, Members_List, DirectList, [], Bin_Pos, Bin_Pet, Bin_Mon)->
%% 	case DirectList of
%% 		[] ->
%% 			DirectList1 = [];
%% 		_ ->
%% 			DirectList1 = lists:keysort(4,DirectList)
%% 	end,
%% 	{Members_List, DirectList1, Bin_Pos, Bin_Pet, Bin_Mon};
%% 
%% load_members_data(BattleData, Formation, RstFL, Members_List, DirectList, UnLoad_List, Bin_Pos, Bin_Pet, Bin_Mon)->
%% 	[Member|T] = UnLoad_List,
%% 	{ID, Type, _, Pst, PstTpl} = Member,
%% 	BattleMembers = BattleData#battleData.members,
%% 	TmpGiant = #ets_giant_s{
%% 							frsl = BattleData#battleData.frsl,
%% 							qly = BattleData#battleData.qly

%% 						   },
%% 	AddGiantAtrList = lib_giant_s:cpt_frmt_atr(TmpGiant, BattleData#battleData.frlv),  
%% %% 	FunBattle = fun(BM) ->
%% %% 						if is_record(BM, battleMember) ->
%% %% 							   BM;
%% %% 						   true ->
%% %% 							   BL = tuple_to_list(BM),
%% %% 							   list_to_tuple(BL ++ [0])
%% %% 						end
%% %% 				end,
%% %% 	BattleMembers1 = lists:map(FunBattle, BattleMembers),
%% 	AllBattleMemberRecords = [M||M <- BattleMembers, M#battleMember.id =:= ID andalso M#battleMember.mtype =:= Type],
%% 	case AllBattleMemberRecords of
%% 		[] ->
%% 			load_members_data(BattleData, Formation, RstFL, Members_List, DirectList, T, Bin_Pos, Bin_Pet, Bin_Mon);
%% 		_ ->
%% 			[BattleMemberRecord|_] = AllBattleMemberRecords,
%% 			case Type of
%% 				1->			
%% 					M1 = get_member_data(BattleMemberRecord, Formation, Pst, PstTpl),				    %%加载战斗成员中玩家的属性
%% 					M1_1 = get_member_giant_atr(M1, AddGiantAtrList),                %%加入巨兽阵法属性
%% 					M2 = get_member_Probability(M1_1),                     %%将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 					M = get_member_restraint_data(M2, RstFL),									%%加载相克加成后玩家的属性
%% 					BinM = binMember(M),
%% 					Bin_Pos1 = <<Bin_Pos/binary, BinM/binary>>,
%% 					%%Tmp_UnLoad_List=UnLoad_List--[Member],
%% 					Tmp_Member_List=Members_List++[M],
%% 					case M#member.hp > 0 of
%% 						true ->
%% 							NewDirectList = DirectList ++ [Member] ;
%% 						false ->
%% 							NewDirectList = DirectList
%% 					end ,
%% 					load_members_data(BattleData, Formation, RstFL, Tmp_Member_List, NewDirectList, T, Bin_Pos1, Bin_Pet, Bin_Mon);
%% 				2->
%% 					M1 = get_member_data(BattleMemberRecord, Formation, Pst, PstTpl),   			%%加载战斗成员中宠物的属性
%% 					M1_1 = get_member_giant_atr(M1, AddGiantAtrList),                %%加入巨兽阵法属性
%% 					M2 = get_member_Probability(M1_1),                                             %%将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 					M = get_member_restraint_data(M2, RstFL),									%%加载相克加成后宠物的属性
%% 					BinM = binMember(M),
%% 					Bin_Pet1 = <<Bin_Pet/binary, BinM/binary>>,
%% 					%%Tmp_UnLoad_List=UnLoad_List--[Member],
%% 					Tmp_Member_List=Members_List++[M],
%% 					case M#member.hp > 0 of
%% 						true ->
%% 							NewDirectList = DirectList ++ [Member] ;
%% 						false ->
%% 							NewDirectList = DirectList
%% 					end ,
%% 					load_members_data(BattleData, Formation, RstFL, Tmp_Member_List, NewDirectList, T, Bin_Pos, Bin_Pet1, Bin_Mon);
%% 				3->
%% 		%% 			BattleMembers = BattleData#battle_record.members,	
%% 		%% 			[BattleMemberRecord] = [M||M <- BattleMembers, M#member.id =:= ID andalso M#member.mtype =:= Type],
%% 					M1 = get_member_data(BattleMemberRecord, Formation, Pst, PstTpl),				           							%%加载战斗成员中怪物的属性
%% 					M2 = get_member_Probability(M1),                                             %%将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 					M = get_member_restraint_data(M2, RstFL),									%%加载相克加成后怪物的属性,
%% 					BinM = binMember(M),
%% 					Bin_Mon1 = <<Bin_Mon/binary, BinM/binary>>,
%% 					%%Tmp_UnLoad_List=UnLoad_List--[Member],
%% 					Tmp_Member_List=Members_List++[M],
%% 					case M#member.hp > 0 of
%% 						true ->
%% 							NewDirectList = DirectList ++ [Member] ;
%% 						false ->
%% 							NewDirectList = DirectList
%% 					end ,
%% 					load_members_data(BattleData, Formation, RstFL, Tmp_Member_List, NewDirectList, T, Bin_Pos, Bin_Pet, Bin_Mon1);
%% 				_->
%% 					%%Tmp_UnLoad_List = UnLoad_List--[Member],
%% 					load_members_data(BattleData, Formation, RstFL, Members_List, DirectList, T, Bin_Pos, Bin_Pet, Bin_Mon)
%% 			end
%% 	end.
%% 
%% %%----------------------------------------------------------------------------------------------------
%% %%-------------get_pos_data/3 加载战斗成员中玩家的属性（ID-玩家ID，Pst为11-29的位置坐标，
%% %%-------------------------------------PstTpl为二维坐标信息）--------------------
%% %%------------改为通用接口，可以加载玩家和宠物的成员记录（#member）属性----------------------------------------------------------------------------------------
%% get_member_data(PlayerBattleMember, PlayerFormation, Pst, PstTpl) ->	
%% 	MemberData =#member{
%% 						id = PlayerBattleMember#battleMember.id,                    %%战斗角色id                
%% 						nick = PlayerBattleMember#battleMember.nick,                %%名称                    
%% 						crr = PlayerBattleMember#battleMember.crr,                   %%职业                    
%% 						mtype = PlayerBattleMember#battleMember.mtype,                 %%战斗角色类型（1:人物,2:宠物,3:怪物）
%% 						race = PlayerBattleMember#battleMember.race,                  %%种族ID                  
%% 						pst = Pst,                    							 %%九宫格位置                 
%% 						psttp = PstTpl,          								 %%九宫格位置(二维：行，列)            
%% 						lv = PlayerBattleMember#battleMember.lv,                    %%等级    
%% 						%% add by chenzm for boss begin 
%% 						frhp = PlayerBattleMember#battleMember.frhp,                   %% 初始气血         
%% 						defender = PlayerBattleMember#battleMember.defender,           %% 守护者
%% 						%% add by chenzm for boss end                  
%% 						hp = PlayerBattleMember#battleMember.mxhp,                   %%气血 (新版修改不需要使用气血包，自动补满血)                    
%% 						mxhp = PlayerBattleMember#battleMember.mxhp,                %%最大气血                    
%% 						mana = PlayerBattleMember#battleMember.mana,                 %%气势   默认50         
%% 						mnup = PlayerBattleMember#battleMember.mnup,               %%气势增加值   
%% 						mxmn = PlayerBattleMember#battleMember.mxmn,               %%气势最大值 
%% 						sklid = PlayerBattleMember#battleMember.sklid,                  %%绝技id                 
%% 						skllv = PlayerBattleMember#battleMember.skllv,      			%%绝技等级   默认1             
%% 						pwr = PlayerBattleMember#battleMember.pwr,                   %%内功                
%% 						tech = PlayerBattleMember#battleMember.tech,                  %%技法                
%% 						mgc = PlayerBattleMember#battleMember.mgc,                  %%法力                 
%% 						hit = PlayerBattleMember#battleMember.hit,                   %%命中                
%% 						crit = PlayerBattleMember#battleMember.crit,                   %%暴击               
%% 						ddge = PlayerBattleMember#battleMember.ddge,                  %%闪避                
%% 						blck = PlayerBattleMember#battleMember.blck,                   %%格挡               
%% 						cter = PlayerBattleMember#battleMember.cter,                   %%反击               
%% 						dbas = PlayerBattleMember#battleMember.dbas,					%%基础防御                       
%% 						dpwr = PlayerBattleMember#battleMember.dpwr,                  %%内功防御              
%% 						dtech = PlayerBattleMember#battleMember.dtech,                 %%技法防御              
%% 						dmgc = PlayerBattleMember#battleMember.dmgc,                 %%法力防御               
%% 						abas = PlayerBattleMember#battleMember.abas,				   %%基础攻击                      
%% 						apwr = PlayerBattleMember#battleMember.apwr,                  %%内力攻击              
%% 						atech = PlayerBattleMember#battleMember.atech,                 %%技法攻击              
%% 						amgc = PlayerBattleMember#battleMember.amgc,                 %%法力攻击               
%% 						roll = PlayerBattleMember#battleMember.roll,                 %%碾压                 
%% 						rela = PlayerBattleMember#battleMember.rela,					%%亲密度                        
%% 						dcrit = PlayerBattleMember#battleMember.dcrit,               %%防暴击                 
%% 						dblck = PlayerBattleMember#battleMember.dblck,               %%破格挡                 
%% 						buffs=[],               									 %%buff记录列表				     
%% 						back_att=[],            										 %%反击位置    
%% 						icon = PlayerBattleMember#battleMember.icon,                  %%形象ID
%% 						sex = PlayerBattleMember#battleMember.sex,                     %%性别        
%% 					    ffc = PlayerBattleMember#battleMember.ffc,                 %%战力（对人物有效）
%% 						qly = PlayerBattleMember#battleMember.qly,                 %%品质（对宠物有效）
%% 						copen = PlayerBattleMember#battleMember.copen,              %% 是否开启阴阳历
%% 						ctm = PlayerBattleMember#battleMember.ctm,				  %%变身时间
%% 						csta = PlayerBattleMember#battleMember.csta,                 %%是否变身				      
%% 						cont = PlayerBattleMember#battleMember.cont,              %% 变身属性  [{Buff1, Value1}, {Buff2, Value2}...],如果Buff为0不显示     
%% 					    proty = data_battle:chk_speed(PlayerBattleMember),               %%先攻值（速度）
%% 						tlidl = PlayerBattleMember#battleMember.tlidl,                          %%宠物天赋基础ID列表
%% 						atrlv = PlayerBattleMember#battleMember.atrlv,                           %%宠物总阶数 
%% 						pasid = PlayerBattleMember#battleMember.pasid,                %%被动技能id
%% 						paslv = PlayerBattleMember#battleMember.paslv,                %%被动技能等级
%% 						pascan = 1,               %%被动技能是否有效（0-无效，1-有效）循环战斗单场战斗结束后要带出到新的battle_record中
%% 						pasbuf = [],               %%被动技能BUFF
%% 						fulltime = data_battle:get_proty_time(data_battle:chk_speed(PlayerBattleMember))     %%累积发招时间（为先攻值倒数*100000的累积和，注意先攻值不允许为0）  
%% 					   },
%% 	MemberAttributeList = 
%% 		case Pst rem 10 of
%% 			1 -> PlayerFormation#frmt.p1;
%% 			2 -> PlayerFormation#frmt.p2;
%% 			3 -> PlayerFormation#frmt.p3;
%% 			4 -> PlayerFormation#frmt.p4;
%% 			5 -> PlayerFormation#frmt.p5;
%% 			6 -> PlayerFormation#frmt.p6;
%% 			7 -> PlayerFormation#frmt.p7;
%% 			8 -> PlayerFormation#frmt.p8;
%% 			_ -> PlayerFormation#frmt.p9
%% 		end,
%% 	if 
%% 		MemberAttributeList =:= [] -> 
%% 			MemberData;
%% 		true ->
%% 			addRoleAttribute(MemberData, MemberAttributeList)
%% 	end.
%% 
%% %%加载战斗成员的阵法技能属性
%% addRoleAttribute(MemberData,[]) ->
%% 	MemberData;
%% addRoleAttribute(MemberData, MemberAttributeList) ->
%% 	[MA|MAL] = MemberAttributeList,
%% 	{MField, MAVal} = MA,	
%% 	case MField of
%% 		act -> %%普通攻击
%% 			Apwr = MemberData#member.apwr + MAVal,
%% 			Amgc = MemberData#member.amgc + MAVal,
%% 			MemberData1 = MemberData#member{apwr=Apwr, amgc=Amgc};
%% 		def ->  %%普通防御
%% 			Dpwr = MemberData#member.dpwr + MAVal,
%% 			Dmgc = MemberData#member.dmgc + MAVal,
%% 			MemberData1 = MemberData#member{dpwr=Dpwr, dmgc=Dmgc};
%% 		pwr -> %%内功
%% 			Pwr = MemberData#member.pwr + MAVal,
%% 			MemberData1 = MemberData#member{pwr=Pwr};
%% 		tech ->  %%技法
%% 			Tech = MemberData#member.tech + MAVal,
%% 			MemberData1 = MemberData#member{tech=Tech};
%% 		mgc ->  %%法力
%% 			Mgc = MemberData#member.mgc + MAVal,
%% 			MemberData1 = MemberData#member{mgc=Mgc};
%% 		hit ->  %%命中
%% 			Hit = MemberData#member.hit + (MAVal*100),
%% 			MemberData1 = MemberData#member{hit=Hit};
%% 		hitr ->  %%命中率
%% 			Hit = MemberData#member.hit + MAVal,
%% 			MemberData1 = MemberData#member{hit=Hit};
%% 		crit ->  %%暴击
%% 			Crit = MemberData#member.crit + (MAVal*100),
%% 			MemberData1 = MemberData#member{crit=Crit};
%% 		critr ->  %%暴击率
%% 			Crit = MemberData#member.crit + MAVal,
%% 			MemberData1 = MemberData#member{crit=Crit};
%% 		ddge ->   %%闪避
%% 			Ddge = MemberData#member.ddge + (MAVal*100),
%% 			MemberData1 = MemberData#member{ddge=Ddge};
%% 		ddger ->   %%闪避率
%% 			Ddge = MemberData#member.ddge + MAVal,
%% 			MemberData1 = MemberData#member{ddge=Ddge};
%% 		blck ->   %%格挡
%% 			Blck = MemberData#member.blck + (MAVal*100),
%% 			MemberData1 = MemberData#member{blck=Blck};
%% 		blckr ->   %%格挡率
%% 			Blck = MemberData#member.blck + MAVal,
%% 			MemberData1 = MemberData#member{blck=Blck};
%% 		cter ->    %%反击
%% 			Cter = MemberData#member.cter + (MAVal*100),
%% 			MemberData1 = MemberData#member{cter=Cter};
%% 		cterr ->    %%反击率
%% 			Cter = MemberData#member.cter + MAVal,
%% 			MemberData1 = MemberData#member{cter=Cter};
%% 		dbas ->     %%基础防御
%% 			Dbas = MemberData#member.dbas + MAVal,
%% 			MemberData1 = MemberData#member{dbas=Dbas};
%% 		dpwr ->    %%内功防御
%% 			Dpwr = MemberData#member.dpwr + MAVal,
%% 			MemberData1 = MemberData#member{dpwr=Dpwr};
%% 		dtech ->   %%技法防御
%% 			Dtech = MemberData#member.dtech + MAVal,
%% 			MemberData1 = MemberData#member{dtech=Dtech};
%% 		dmgc ->    %%法力防御
%% 			Dmgc = MemberData#member.dmgc + MAVal,
%% 			MemberData1 = MemberData#member{dmgc=Dmgc};
%% 		abas ->    %%基础攻击
%% 			Abas = MemberData#member.abas + MAVal,
%% 			MemberData1 = MemberData#member{abas=Abas};
%% 		apwr ->    %%内力攻击
%% 			Apwr = MemberData#member.apwr + MAVal,
%% 			MemberData1 = MemberData#member{apwr=Apwr};
%% 		atech ->   %%技法攻击
%% 			Atech = MemberData#member.atech + MAVal,
%% 			MemberData1 = MemberData#member{atech=Atech};
%% 		amgc ->    %%法力攻击
%% 			Amgc = MemberData#member.amgc + MAVal,
%% 			MemberData1 = MemberData#member{amgc=Amgc};
%% 		roll ->    %%碾压
%% 			Amgc = MemberData#member.amgc + (MAVal*100),
%% 			MemberData1 = MemberData#member{amgc=Amgc};
%% 		rollr ->    %%碾压率
%% 			Amgc = MemberData#member.amgc + MAVal,
%% 			MemberData1 = MemberData#member{amgc=Amgc};
%% 		rela ->     %%亲密度
%% 			if MemberData#member.mtype =:= 1 ->
%% 				   MemberData1 = MemberData;
%% 			   true ->
%% 				   Rela = MemberData#member.rela + (MAVal*100),
%% 				   MemberData1 = MemberData#member{rela=Rela}
%% 			end;
%% 		relar ->     %%连携率
%% 			if MemberData#member.mtype =:= 1 ->
%% 				   MemberData1 = MemberData;
%% 			   true ->
%% 				   Rela = MemberData#member.rela + MAVal,
%% 				   MemberData1 = MemberData#member{rela=Rela}
%% 			end;		
%% 		_ ->
%% 			MemberData1 = MemberData
%% 	end,
%% 	addRoleAttribute(MemberData1, MAL).	   
%% 
%% %%将成员记录中的暴击、闪避、格挡、反击、命中、连携值转换为概率值
%% get_member_Probability(MemberData) ->
%% 	Hit = cptHitRatio(MemberData#member.crr, MemberData#member.hit),
%% 	Crit = cptCritRatio(MemberData#member.crr, MemberData#member.crit),
%% 	Ddge = cptDdgeRatio(MemberData#member.crr, MemberData#member.ddge),
%% 	Blck = cptBlckRatio(MemberData#member.crr, MemberData#member.blck),
%% 	Cter = cptCterRatio(MemberData#member.cter),
%% 	Dcrit = cptDcritRatio(MemberData#member.crr, MemberData#member.dcrit),
%% 	Dblck = cptDblckRatio(MemberData#member.crr, MemberData#member.dblck),
%% %% 	Rela = cptRelaRatio(MemberData#member.rela),
%% %% 	io:format("get_member_Probability[~p]\n[~p]\n[~p]\n[~p]\n[~p]\n[~p]\n[~p]\n[~p]\n",[{crr, MemberData#member.crr}, {hit, Hit, MemberData#member.hit}, {crit, Crit, MemberData#member.crit}, {ddge, Ddge, MemberData#member.ddge}, {blck, Blck, MemberData#member.blck}, {cter, Cter, MemberData#member.cter}, {dcrit, Dcrit, MemberData#member.dcrit}, {dblck, Dblck, MemberData#member.dblck}]),
%% 	MemberData#member{hit = Hit,
%% 					  crit = Crit,
%% 					  ddge = Ddge,
%% 					  blck = Blck,
%% 					  cter = Cter,
%% 					  dcrit = Dcrit,
%% 					  dblck = Dblck}.
%% %% 					  rela = Rela}.
%% 
%% %%封装战斗成员member记录的初始数据（二进制数据包）
%% binMember(M) ->
%% 	if M#member.hp =< 0 andalso M#member.mtype =/= 1->
%% 		   <<>>;
%% 	   true ->
%% 			case M#member.mtype of
%% 				1 ->
%% 					Nick1 = tool:to_binary(M#member.nick),
%% 				    NickLen = byte_size(Nick1),
%% 					Crr = M#member.crr,
%% 					Race = M#member.race,
%% 					Lv = M#member.lv,
%% 					Mxhp = M#member.mxhp,
%% 					Hp = M#member.hp,
%% 					Mxmn = M#member.mxmn,
%% 					Mana = M#member.mana,
%% 					Sklid = M#member.sklid,
%% 					SklLv = M#member.skllv,
%% 					PasId = M#member.pasid,
%% 					PasLv = M#member.paslv,
%% 					PasCan = M#member.pascan,
%% 					Sex = M#member.sex,
%% 					Icon = M#member.icon,
%% 					Ffc = M#member.ffc,
%% 					Pst = M#member.pst,
%% 					<<NickLen:16, Nick1/binary, Crr:16,	Race:8, Lv:16, Pst:8, Mxhp:32, Hp:32, Mxmn:16, Mana:16, Sklid:32, SklLv:16, PasId:32, PasLv:16, PasCan:8, Sex:8, Icon:32, Ffc:32>>;
%% 				2 ->
%% 					Nick1 = tool:to_binary(M#member.nick),
%% 				    NickLen = byte_size(Nick1),			
%% 					Crr = M#member.crr,
%% 					Race = M#member.race,
%% 					Quality = M#member.qly,    %%lib_pet:get_pet_qly(ID), %%宠物品质
%% 					Lv = M#member.lv,
%% 					Mxhp = M#member.mxhp,
%% 					Hp = M#member.hp,
%% 					Mxmn = M#member.mxmn,
%% 					Mana = M#member.mana,
%% 					Sklid = M#member.sklid,
%% 					SklLv = M#member.skllv,
%% 					PasId = M#member.pasid,
%% 					PasLv = M#member.paslv,
%% 					PasCan = M#member.pascan,
%% 					Icon = M#member.icon,
%% 					case M#member.csta of        %%提取宠物阴阳历数据
%% 						1 ->
%% 							Copen = 1,
%% 							Cont = M#member.cont,
%% 							Clen = length(Cont),
%% 							Fun = fun({BuffId, BuffNum}) ->
%% 										  <<BuffId:8, BuffNum:16>>
%% 								  end,
%% 							BinContF = list_to_binary(lists:map(Fun, Cont)),
%% 							BinCont = <<Clen:16, BinContF/binary>>;
%% 						_ ->
%% 							Copen = 0,
%% 							BinCont = <<0:16>>
%% 					end,
%% 					Id = M#member.id,
%% 					Pst = M#member.pst,
%% 					TlidL = M#member.tlidl,
%% 					Fun1 = fun(Tlid) ->
%% 								   <<Tlid:32>>
%% 						   end,
%% 					BinTlidL = list_to_binary(lists:map(Fun1, TlidL)),
%% 					TlidLLen = length(TlidL),
%% 					AtrLv = M#member.atrlv,
%% 					 <<Id:32, NickLen:16, Nick1/binary, Crr:16, Race:8, Quality:8, Lv:16, Pst:8, Mxhp:32, Hp:32, Mxmn:16, Mana:16, Sklid:32, SklLv:16, PasId:32, PasLv:16, PasCan:8, Icon:32, TlidLLen:16, BinTlidL/binary, AtrLv:16, Copen:8, BinCont/binary>>;
%% 				3 ->
%% 					Nick1 = tool:to_binary(M#member.nick),
%% 				    NickLen = byte_size(Nick1),
%% 					Crr = M#member.crr,
%% 					Race = M#member.race,
%% 					Lv = M#member.lv,
%% 					Mxhp = M#member.mxhp,
%% 					Hp = M#member.hp,
%% 					Mxmn = M#member.mxmn,
%% 					Mana = M#member.mana,
%% 					Sklid = M#member.sklid,
%% 					SklLv = M#member.skllv,
%% 					PasId = M#member.pasid,
%% 					PasLv = M#member.paslv,
%% 					PasCan = M#member.pascan,
%% 					Icon = M#member.icon,
%% 					Id = M#member.id,
%% 					Pst = M#member.pst,
%% 					<<Id:32, NickLen:16, Nick1/binary, Crr:16, Race:8, Lv:16, Pst:8, Mxhp:32, Hp:32, Mxmn:16, Mana:16, Sklid:32, SklLv:16, PasId:32, PasLv:16, PasCan:8, Icon:32>>;
%% 				_ ->
%% 					<<>>
%% 			end
%% 	end.
%% 
%% 
%% %%------------------------------------------------------------------------------------------------------
%% %%--------line_up/2 计算打完X1行，下一次要打哪一行----(new,刘菁2012-8-6)----------------------
%% %%------------------------------------------------------------------------------------------------------
%% line_up(X,X1)->
%% 	case X of 
%% 		1 -> X1+1;
%% 		2 -> 
%% 			case X1 of
%% 				1 -> 3;
%% 				2 -> 1
%% 			end;
%% 		3-> X1-1
%% 	end.
%% 
%% %%获取单体攻击受攻击的坐标位
%% get_single_act_pos(Act_position, Arrmy_list, RowSortList) ->
%% 	Fun = fun(RowFlag, {ReFlag, ReList}) ->
%% 				  case ReFlag of
%% 					  0 ->
%% 						  case [{X, Y}||{X, Y}<-Arrmy_list, Y =:= RowFlag] of
%% 							  [] ->
%% 								  {ReFlag, ReList};
%% 							  List ->
%% 								  {1, List}
%% 						  end;
%% 					  _ ->
%% 						  {ReFlag, ReList}
%% 				  end
%% 		  end,
%% 	{_F, NewReList} = lists:foldl(Fun, {0, []}, RowSortList),
%% 	{X1,_B} = Act_position,
%% 	case [{Z1,_M1}||{Z1,_M1}<-NewReList, Z1 =:= X1] of
%% 		[] ->
%% 			X2=line_up(X1,X1),
%% 			case [{Z2,_M2}||{Z2,_M2}<-NewReList, Z2 =:= X2] of
%% 				[] ->
%% 					X3 = line_up(X1,X2),
%% 					case [{Z3,_M3}||{Z3,_M3}<-NewReList, Z3 =:= X3] of
%% 						[] ->
%% 							[];
%% 						[Z|_] ->
%% 							[Z]
%% 					end;
%% 				[Z|_] ->
%% 					[Z]
%% 			end;
%% 		[Z|_] ->
%% 			[Z]
%% 	end.
%% 
%% 
%% %%------------------------------------------------------------------------------------------------------
%% %%--------act_to/3计算被攻击角色的坐标列表（Act_position-攻击角色站位坐标(二维)，
%% %%------------------------------------Act_range攻击范围，Arrmy_list被攻击角色坐标列表-----------------
%% %%------------------------------------------------------------------------------------------------------
%% act_to(Act_position,Act_range,Arrmy_list)->
%% 	RowList = [1,2,3], 
%% 	case Act_range of
%% 		1 ->                                            %%单体攻击
%% 			get_single_act_pos(Act_position, Arrmy_list, RowList);
%% 		2 ->                                                %%横排直线攻击
%% 			case get_single_act_pos(Act_position, Arrmy_list, RowList) of
%% 				[] ->
%% 					[];
%% 				[{X, _Y}] ->
%% 					[{X1, Y1}||{X1, Y1}<-Arrmy_list, X1 =:= X]
%% 			end;
%% 		3 ->                                                 %%纵向直线攻击（前列）
%% 			case get_single_act_pos(Act_position, Arrmy_list, RowList) of
%% 				[] ->
%% 					[];
%% 				[{_X, Y}] ->
%% 					[{X1, Y1}||{X1, Y1}<-Arrmy_list, Y1 =:= Y]
%% 			end;
%% 		4 ->                                                 %%影杀攻击
%% 			RowList1 = lists:reverse(RowList),
%% 			get_single_act_pos(Act_position, Arrmy_list, RowList1);
%% 		5 ->                                                 %%纵向直线攻击（后列）
%% 			RowList1 = [3,1,2],
%% 			case get_single_act_pos(Act_position, Arrmy_list, RowList1) of
%% 				[] ->
%% 					[];
%% 				[{_X, Y}] ->
%% 					[{X1, Y1}||{X1, Y1}<-Arrmy_list, Y1 =:= Y]
%% 			end;
%% 		6 ->                                                 %%纵向直线攻击（中列）
%% 			RowList1 = [2,3,1],
%% 			case get_single_act_pos(Act_position, Arrmy_list, RowList1) of
%% 				[] ->
%% 					[];
%% 				[{_X, Y}] ->
%% 					[{X1, Y1}||{X1, Y1}<-Arrmy_list, Y1 =:= Y]
%% 			end;
%% 		_ ->
%% %% 			?DEBUG("这招不会",[]),
%% 			[]
%% 	end.
%% 
%% %%------------------------------------------------------------------------------------------------------
%% %%--------act_begin/8开始战斗，战斗数据计算（Player_List-左边角色列表(按位置排过序), Mon_List-右边角色
%% %%-----------------------列表(按位置排过序),Battle_Sequence_List-战斗序列列表, Left_battle_record-左边
%% %%-----------------------战斗数据记录, Right_battle_record-右边战斗数据记录, Special_Act_Type-是指区
%% %%-----------------------分常规排队的战斗和不用排队的特殊攻击，如巨兽、反击，连携等（1表示常规战斗）, 
%% %%-----------------------War_Num-战斗发生次数, Result_bin_list-二进制打包数据）
%% %%------------------------------------------------------------------------------------------------------
%% %% act_begin() ->
%% %% 	Temp_LList = [{10001, 1 , 2}, {10002, 2, 3}, {10003, 2,6}],
%% %% 	Temp_RList = [{10011, 1 , 1}, {10012, 2, 4}, {10013, 2,8}],
%% %% 	L_List = [{Id, RoleType, left, Pst + 10, positionConversion(Pst)}||{Id, RoleType, Pst} <- Temp_LList, is_integer(Id) andalso Id =/= 0],
%% %% 	R_List = [{Id1, RoleType1, right, Pst1 + 20, positionConversion(Pst1)}||{Id1, RoleType1, Pst1} <- Temp_RList, is_integer(Id1) andalso Id1 =/= 0],
%% %% 	Round_List = lib_battle:role_merge(L_List,R_List,[]),
%% %% 	LMemberL = [#member{id = Lid,
%% %% 						nick = tool:to_list(Lid)++"号木偶",
%% %% 						mtype = LType,
%% %% 						pst = LPst,
%% %% 						psttp = LPsttp}||{Lid, LType, _D, LPst, LPsttp} <- L_List],
%% %% 	RMemberL = [#member{id = Rid,
%% %% 						nick = tool:to_list(Rid)++"号木偶",
%% %% 						mtype = RType,
%% %% 						pst = RPst,
%% %% 						psttp = RPsttp}||{Rid, RType, _D1, RPst, RPsttp} <- R_List],
%% %% 	Lbattle_record = #battle_record{members = LMemberL},
%% %% 	Rbattle_record = #battle_record{members = RMemberL},
%% %% 	TempBin = <<>>,
%% %% 	io:format("~s Left_list_________  [~p]\n",[misc:time_format(now()), L_List]),
%% %% 	io:format("~s R_List_________  [~p]\n",[misc:time_format(now()), R_List]),
%% %% 	act_begin(L_List, R_List, Round_List, Lbattle_record, Rbattle_record, 1, 0, TempBin).
%% 	
%% 
%% 
%% act_begin([], _Mon_List, _Battle_Sequence_List, Left_battle_record, Right_battle_record, _BattleSta, War_Num, Result_bin_list, MyBattleScore)->
%% %% io:format("~s 2-Right Win---[~p]\n",[misc:time_format(now()), new_act_end]),
%% 	{2, War_Num, Result_bin_list, Left_battle_record,Right_battle_record, MyBattleScore#battleScore{score_round = War_Num}};   %%右方胜利返回2
%% 
%% act_begin(_Player_List, [], _Battle_Sequence_List, Left_battle_record, Right_battle_record, _BattleSta, War_Num, Result_bin_list, MyBattleScore)->
%% %% io:format("~s 2-Left Win----[~p]\n",[misc:time_format(now()), new_act_end]),
%% 	{1, War_Num, Result_bin_list, Left_battle_record,Right_battle_record, MyBattleScore#battleScore{score_round = War_Num}};    %%左方胜利返回1
%% 		
%% act_begin(Left_List, Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleSta, War_Num, Result_bin_list, MyBattleScore)->     %% Special_Act_Type 是指区分常规排队的战斗和不用排队的特殊攻击，1为正常攻击，其他如巨兽、反击，连携
%%  	%%io:format("~s act_begin--bRela--[~p]\n",[misc:time_format(now()), BattleSta#battleSta.bRela]),
%% 	if  BattleSta#battleSta.bRela ->     %%连携攻击
%% %% 		   BattleStaNew = BattleSta#battleSta{bRela = false},
%% %% 		   {Direct, Xy} = BattleSta#battleSta.relaActPsttp,   %%连携攻击方坐标
%% 		   case BattleSta#battleSta.relaActPetPstL of
%% 			   [] ->
%% 				   BattleStaNew = BattleSta#battleSta{bRela = false,
%% 													  relaActPetPstL = [],
%% 													  relaActNum = 0},
%% 				   act_begin(Left_List, Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleStaNew, War_Num, Result_bin_list, MyBattleScore);
%% 			   _ ->
%% 				   {Direct, PlayerXy} = BattleSta#battleSta.relaPlayerPsttp, %%连携攻击方人物坐标
%% 				   [ActPst|LastRelaList] = lists:sort(BattleSta#battleSta.relaActPetPstL),  %%%%连携攻击方坐标
%% 				   Xy = positionConversion(ActPst rem 10),
%% 				   case Direct of
%% 					   left ->
%% 						   Member_List=Left_battle_record#battle_record.members;				   
%% 					   right ->
%% 						   Member_List=Right_battle_record#battle_record.members
%% 				   end,
%% 				   [Old_Member|_]=[M||M<-Member_List,M#member.psttp =:= Xy],
%% 				   ActType = data_battle:getCrrActType(Old_Member#member.crr),  %%通过职业ID获得攻击类型是内功还是法功
%% 				   ActPwr = getActAll(Old_Member, ActType),                     %%获取普通攻击力
%% 				   [Old_Member1|_]=[M1||M1<-Member_List,M1#member.psttp =:= PlayerXy],  %%以人物所处位格作为攻击参照位判定受击方
%% 				   [{SwDirect, SwPsttp}] = cptActTo(Old_Member1, Direct, Left_List, Right_List),
%% %% 				   {SwDirect, SwPsttp} = BattleSta#battleSta.relaDefPsttp,
%% %% 				   case SwDirect of
%% %% 					   left ->
%% %% 						   SwList = Left_List;
%% %% 					   right ->
%% %% 						   SwList = Right_List
%% %% 				   end,
%% 
%% 				   if BattleSta#battleSta.b_rela =:= 1 ->
%% 						  BRelaAct = true;
%% 					  true ->
%% 						  if BattleSta#battleSta.relaMustPetId =/= Old_Member#member.id ->  %%根据宠物连携率判定连携宠物是否发生攻击（连携率最高的宠物必定发生攻击）
%% 								 RelaRand = util:rand(1, 10000),
%% 								 MaxRelaRand = data_battle:cptRelaRatio(Old_Member#member.rela, Old_Member#member.qly),
%% 								 if RelaRand =< MaxRelaRand ->
%% 										BRelaAct = true;
%% 									true ->
%% 										BRelaAct = false
%% 								 end;
%% 							 true ->
%% 								 BRelaAct = true
%% 						  end
%% 				   end,
%% 				   case LastRelaList of
%% 					   [] ->
%% 						   BattleStaNew = BattleSta#battleSta{bRela = false,
%% 															  relaActPetPstL = LastRelaList,
%% 															  relaActNum = 0};
%% 					   _ ->
%% 						   BattleStaNew = BattleSta#battleSta{relaActPetPstL = LastRelaList}
%% 				   end,
%% 				   case SwPsttp of %%[SwId||{SwId, _SwType, _SwDir, _SwPst, SwPsttpT}<-SwList, SwPsttpT =:= SwPsttp] of
%% 					   [] ->
%% 						   act_begin(Left_List, Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleStaNew, War_Num, Result_bin_list, MyBattleScore);
%% 					   _ ->
%% 						   case BRelaAct of
%% 							   false ->
%% 								   act_begin(Left_List, Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleStaNew, War_Num, Result_bin_list, MyBattleScore);
%% 							   _ ->
%% 								   BattleStaNew1 = BattleStaNew#battleSta{relaActNum = BattleStaNew#battleSta.relaActNum + 1},
%% 								   Arrmy_Members1 = [{SwDirect, SwPsttp}],         %%受攻击角色队列
%% %% 								   MissVal = data_battle:getCrrMiss(Old_Member#member.crr) *100,%%获取未命中率
%% %% 								   HitVal = Old_Member#member.hit,                              %%连携攻击命中不受BUFF影响
%% %% 								   CritVal = Old_Member#member.crit,                            %%连携攻击暴击不受BUFF影响
%% 								   LvVal = Old_Member#member.lv,                                %%攻击者等级
%% 								   BattleSubType = #battleSubType{   %%连携攻击不rand点
%% 																  bAct = true,                  %%发生攻击
%% 																  bRela = false,                %%不触发连携
%% 																  bCter = false,                %%不触发反击
%% %% 																  missVal = MissVal,            %%未命中率
%% %% 																  hitVal = HitVal,              %%命中率
%% %% 																  critVal = CritVal,            %%暴击率
%% 																  lvVal = LvVal,                %%攻击者等级
%% 																  actType = ActType,            %%主攻击类型
%% 																  typeId = 11,                  %%攻击子类型ID（连携）
%% 																  actVal = ActPwr},
%% 								   BinActedArray = <<>>,                                     %%获取受攻击角色封包数据
%% 								   {ok, New_Left_List, New_Right_List, New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, ReBinActedArray, BattleSta1, BattleSubTypeNew, Arrmy_Members_Len, _NewBuffOffList, NewMyBattleScore, PasList} = 
%% 											arrmy_trauma(Arrmy_Members1, Old_Member, Left_List, Right_List, Battle_Sequence_List, Left_battle_record, Right_battle_record, BinActedArray, BattleStaNew1, BattleSubType, 0, [], MyBattleScore, []),
%% 								   ReBinActedArray1 = <<Arrmy_Members_Len:16, ReBinActedArray/binary>>,  %%加入数组长度
%% 								   case Direct of
%% 									   left ->
%% 										   New_Member_List=New_Left_battle_record#battle_record.members,
%% 										   BinAnger = New_Left_battle_record#battle_record.anger;       %%怒气值
%% 									   right ->
%% 										   New_Member_List=New_Right_battle_record#battle_record.members,
%% 										   BinAnger = New_Right_battle_record#battle_record.anger       %%怒气值
%% 								   end,
%% 								   ReBinRoleBuffArray = ptBuffs(New_Left_battle_record, New_Right_battle_record, BattleSubTypeNew),        %%BUFF改变数据（连携没有BUFF攻击）
%% 								   [New_Member|_]=[NewM||NewM<-New_Member_List,NewM#member.psttp =:= Xy],
%% 								   BinPst = New_Member#member.pst,                    %%位置
%% %% 								   BinBuffs = ptBuffs(New_Member#member.buffs),       %%BUFF队列
%% 								   BinHpBuff = <<0:16>>,                              %%没有BUFF加减血量
%% 								   BinNowHp = New_Member#member.hp,                   %%当前血量
%% 								   BinActSta = 1,                                     %%生存
%% 								   BinActEffctId = 5,                                 %%攻击特效ID(连携攻击)
%% 								   BinMana = New_Member#member.mana,                  %%气势值
%% 								   BinPas = binPasList(New_Left_List, New_Right_List, PasList),  %%封包被动技能触发
%% 								   BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray1, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据
%% 								   New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% 								   War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 								   act_begin(New_Left_List, New_Right_List, New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, BattleSta1, War_Num1, New_Result_bin_list_All1, NewMyBattleScore)
%% 						   end
%% 				   end
%% 		   end;
%% 		   
%% 		BattleSta#battleSta.bCter ->   %%反击攻击
%% 		   BattleStaNew = BattleSta#battleSta{bCter = false},
%% 		   {Direct, Xy} = BattleSta#battleSta.cterActPsttp,            %%反击攻击方坐标
%% 		   case Direct of
%% 			   left ->
%% 				   Member_List=Left_battle_record#battle_record.members,
%% 				   Tmp_Role_List = [{_Id, _Type, _Dir, _Pst, PsttpT}||{_Id, _Type, _Dir, _Pst, PsttpT}<-Left_List, PsttpT =:= Xy];
%% 			   right ->
%% 				   Member_List=Right_battle_record#battle_record.members,
%% 				   Tmp_Role_List = [{_Id, _Type, _Dir, _Pst, PsttpT}||{_Id, _Type, _Dir, _Pst, PsttpT}<-Right_List, PsttpT =:= Xy]		   
%% 		   end,
%% 		   if Tmp_Role_List =:= [] ->   %%判定反击角色是否死亡，被连携攻击后可能死亡
%% 				  BattleSta1 = BattleSta#battleSta{bCter = false},
%% 				  act_begin(Left_List, Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleSta1, War_Num, Result_bin_list, MyBattleScore);
%% 			  true ->                   %%未死亡
%% 		   		  [Old_Member|_]=[M||M<-Member_List,M#member.psttp =:= Xy],		   
%% 		   		  ActType = data_battle:getCrrActType(Old_Member#member.crr),  %%通过职业ID获得攻击类型是内功还是法功
%% 		   		  ActPwr = getActAll(Old_Member, ActType),                     %%获取普通攻击力
%% 		   		  Arrmy_Members1 = [BattleSta#battleSta.cterDefPsttp],         %%受攻击角色队列
%% %% 		   		  MissVal = data_battle:getCrrMiss(Old_Member#member.crr) *100,%%获取未命中率
%% %% 		   		  HitVal = Old_Member#member.hit,                              %%反击攻击命中不受BUFF影响
%% %% 		   		  CritVal = Old_Member#member.crit,                            %%反击攻击暴击不受BUFF影响
%% 		   		  LvVal = Old_Member#member.lv,                                %%攻击者等级
%% 		   		  BattleSubType = #battleSubType{      %%反击不rand点
%% 							  					  bAct = true,                  %%发生攻击
%% 										  		  bRela = false,                %%不触发连携
%% 										  		  bCter = false,                %%不触发反击
%% %% 			  									  missVal = MissVal,            %%未命中率
%% %% 						  						  hitVal = HitVal,              %%命中率
%% %% 									  			  critVal = CritVal,            %%暴击率
%% 											      lvVal = LvVal,                %%攻击者等级
%% 			  									  actType = ActType,            %%主攻击类型
%% 						  						  typeId = 9,                  %%攻击子类型ID（反击）
%% 									  			  actVal = ActPwr},		   
%% 				  BinActedArray = <<>>,                                     %%获取受攻击角色封包数据
%% 				  {ok, New_Left_List, New_Right_List, New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, ReBinActedArray, BattleSta1, BattleSubTypeNew, Arrmy_Members_Len, _NewBuffOffList, NewMyBattleScore, PasList} = 
%% 					     arrmy_trauma(Arrmy_Members1, Old_Member, Left_List, Right_List, Battle_Sequence_List, Left_battle_record, Right_battle_record, BinActedArray, BattleStaNew, BattleSubType, 0, [], MyBattleScore, []),
%% 		   		  ReBinActedArray1 = <<Arrmy_Members_Len:16, ReBinActedArray/binary>>,  %%加入数组长度
%% 		   		  case Direct of
%% 			   		  left ->
%% 				   		  New_Member_List=New_Left_battle_record#battle_record.members,
%% 				   		  BinAnger = New_Left_battle_record#battle_record.anger;       %%怒气值
%% 			   		  right ->
%% 				   		  New_Member_List=New_Right_battle_record#battle_record.members,
%% 				   		  BinAnger = New_Right_battle_record#battle_record.anger       %%怒气值
%% 		   		  end,
%% 				  ReBinRoleBuffArray = ptBuffs(New_Left_battle_record, New_Right_battle_record, BattleSubTypeNew), %%BUFF改变数据（反击没有BUFF攻击）
%% 		   		  [New_Member|_]=[NewM||NewM<-New_Member_List,NewM#member.psttp =:= Xy],
%% 		   		  BinPst = New_Member#member.pst,                    %%位置
%% %% 		   		  BinBuffs = ptBuffs(New_Member#member.buffs),       %%BUFF队列
%% 		   		  BinHpBuff = <<0:16>>,                              %%没有BUFF加减血量
%% 		   		  BinNowHp = New_Member#member.hp,                   %%当前血量
%% 		   		  BinActSta = 1,                                     %%生存
%% 		   		  BinActEffctId = 3,                                 %%攻击特效ID（反击攻击）
%% 		   		  BinMana = New_Member#member.mana,                  %%气势值
%% 				  BinPas = binPasList(New_Left_List, New_Right_List, PasList),  %%封包被动技能触发
%% 		   		  BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray1, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据
%% 		   		  New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% 		   		  War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 		   		  act_begin(New_Left_List, New_Right_List, New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, BattleSta1, War_Num1, New_Result_bin_list_All1, NewMyBattleScore)
%% 		   end;
%% 		
%% 		BattleSta#battleSta.bBehemothAct ->       %%巨兽攻击
%% 			BattleStaNew = BattleSta#battleSta{bBehemothAct = false},
%% 			Direct = BattleSta#battleSta.behemothActPst,         %%巨兽攻击方的方位		   
%% 			case Direct of
%% 				left ->
%% 					ActPwr = Left_battle_record#battle_record.techv,
%% 					ActType = Left_battle_record#battle_record.crr,
%% 					GiantTechId = Left_battle_record#battle_record.behThId,
%% 					NowAnger = tool:int_format(Left_battle_record#battle_record.anger - Left_battle_record#battle_record.maxang),
%% 					NewTemp_Left_battle_record = Left_battle_record#battle_record{bact = 0,   %%现在改为巨兽可以多次攻击
%% 																				  anger = NowAnger},
%% 					NewTemp_Right_battle_record = Right_battle_record,
%% 					MyAllMember = [{Dr1, Psttp1}||{_Id1, _Type1, Dr1, _Pst1, Psttp1} <- Left_List],
%% 					Arrmy_Members1 = [{Dr, Psttp}||{_Id, _Type, Dr, _Pst, Psttp} <- Right_List];
%% 				right ->
%% 					ActPwr = Right_battle_record#battle_record.techv,
%% 					ActType = Right_battle_record#battle_record.crr,
%% 					GiantTechId = Right_battle_record#battle_record.behThId,
%% 					NowAnger = tool:int_format(Right_battle_record#battle_record.anger - Right_battle_record#battle_record.maxang),
%% 					NewTemp_Left_battle_record = Left_battle_record,
%% 					NewTemp_Right_battle_record = Right_battle_record#battle_record{bact = 0,  %%现在改为巨兽可以多次攻击
%% 																					anger = NowAnger},
%% 					MyAllMember = [{Dr1, Psttp1}||{_Id1, _Type1, Dr1, _Pst1, Psttp1} <- Right_List],
%% 					Arrmy_Members1 = [{Dr, Psttp}||{_Id, _Type, Dr, _Pst, Psttp} <- Left_List]
%% 			end,
%% 			%%巨兽攻击没有暴击、未命中、闪避、碾压等
%% 			ActSkill = getSkill(GiantTechId),
%% 			case ActSkill#ets_skill.other_data of
%% 				[DownMana] ->
%% 					skip;
%% 				_ ->
%% 					DownMana = 0
%% 			end,
%% %% 			BattleSubType = #battleSubType{
%% %% 										   bAct = true,                  %%发生攻击
%% %% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% %% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% %% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% %% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% %% 										   lvVal = LvVal,                %%攻击者等级
%% %% 										   actType = 2,                  %%技能攻击
%% %% 										   typeId = 2,                   %%   old: 5,%%攻击子类型ID（技能伤害+降气势）
%% %% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% %% 										   actVal = ActPwr,
%% %% 										   otherVal = DownMana, %%降气势值
%% %% 										   manaVal = OldMana
%% %% 										  };
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   bRela = false,                %%不触发连携
%% 										   bCter = false,                %%不触发反击
%% 										   actType = ActType,                  %%巨兽是技能攻击
%% 										   typeId = 10,                  %%攻击子类型ID（巨兽）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   otherVal = DownMana, %%降气势值
%% 										   actVal = ActPwr},
%% 			Old_Member = #member{},                      %%临时做参数，后续不要Old_Member这个参数
%% 			BinActedArray = <<>>,                                     %%获取受攻击角色封包数据
%% 			{ok, New_Left_List, New_Right_List, New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, ReBinActedArray, BattleSta1, BattleSubTypeNew, Arrmy_Members_Len, NewBuffOffList, NewMyBattleScore, PasList} = 
%% 				arrmy_trauma(Arrmy_Members1, Old_Member, Left_List, Right_List, Battle_Sequence_List, NewTemp_Left_battle_record, NewTemp_Right_battle_record, BinActedArray, BattleStaNew, BattleSubType, 0, [], MyBattleScore, []),
%% 			ReBinActedArray1 = <<Arrmy_Members_Len:16, ReBinActedArray/binary>>,  %%加入数组长度
%% 			BinRoleBuffArray = <<>>,  				
%% 			if ActSkill#ets_skill.bftp =:= 0 ->   %%没有BUFF攻击
%% 				   New_Left_battle_record1 = New_Left_battle_record,
%% 				   New_Right_battle_record1 = New_Right_battle_record,
%% 				   BattleSubTypeNew2 = BattleSubTypeNew;
%% 			   true ->
%% 				   %%计算BUFF受攻击者队列	
%% 				   case ActSkill#ets_skill.bfmod of
%% 					   2 ->
%% 						   BuffArrmy_Members = MyAllMember;
%% 					   4 ->
%% 						   BuffArrmy_Members = Arrmy_Members1;
%% 					   _ ->
%% 						   BuffArrmy_Members = []
%% 				   end,
%% 				   BuffArrmy_Members1 = BuffArrmy_Members -- NewBuffOffList,
%% %% 				   io:format("[BuffArrmy_MembersAll]--[NewBuffOffList]-[BuffArrmy_Members]---[~p][~p][~p]\n",[Arrmy_Members1, NewBuffOffList, BuffArrmy_Members1]),
%% 				   {New_Left_battle_record1, New_Right_battle_record1, _ReBinRoleBuffArray, _BuffArrmy_Members_Len, BattleSubTypeNew2} = 
%% 					   arrmyBuffActed(BuffArrmy_Members1, New_Left_battle_record, New_Right_battle_record, ActSkill, BinRoleBuffArray, 0, BattleSubTypeNew)
%% 			end,
%% 			ReBinRoleBuffArray = ptBuffs(New_Left_battle_record1, New_Right_battle_record1, BattleSubTypeNew2),
%% 			%% 										 ReBinRoleBuffArray1 = <<BuffArrmy_Members_Len:16, ReBinRoleBuffArray/binary>>,  %%加入数组长度
%% 			
%% %% 			ReBinRoleBuffArray = ptBuffs(New_Left_battle_record, New_Right_battle_record, BattleSubTypeNew),                     %%BUFF变化数据（巨兽攻击不带buff)		   
%% 			BinPst = data_battle:directToNum(Direct),          %%位置
%% 			%% 		   BinBuffs = <<0:16>>,                               %%BUFF队列（巨兽没有BUFF）
%% 			BinHpBuff = <<0:16>>,                              %%没有BUFF加减血量
%% 			BinNowHp = 0,                                      %%当前血量
%% 			BinActSta = 1,                                     %%生存
%% 			BinActEffctId = 4,                                 %%攻击特效ID(巨兽攻击)
%% 			BinMana = 0,                                       %%气势值
%% 			BinAnger = NowAnger,                                      %%怒气值
%% 			BinPas = binPasList(New_Left_List, New_Right_List, PasList),  %%封包被动技能触发
%% %% 			io:format("~s BinPst----[~p]\n",[misc:time_format(now()), BinPas]),
%% 			BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray1, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据
%% 			New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% 			War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 			BattleSta2 = bBehemothAct(New_Left_battle_record, left, BattleSta1),   %%判定左方是否还有巨兽攻击
%% 			BattleSta3 = bBehemothAct(New_Right_battle_record, right, BattleSta2), %%判定右方是否还有巨兽攻击
%% 			act_begin(New_Left_List, New_Right_List, New_Battle_Sequence_List, New_Left_battle_record1, New_Right_battle_record1, BattleSta3, War_Num1, New_Result_bin_list_All1, NewMyBattleScore);
%% 		
%% 		true ->            %%正常攻击
%% 			if War_Num >= 300 ->                                                        	%%判定回合是否结束，结束，重建战斗队列
%% %% 				[] ->
%% %% 				   Round_List = role_merge(Left_List, Right_List, [], BattleSta#battleSta.pDirect),
%% %% 				   MyBattleScore1 = MyBattleScore#battleScore{score_round = MyBattleScore#battleScore.score_round + 1},
%% %% 				   %%io:format("~s MyBattleScore1______[~p]\n",[misc:time_format(now()), MyBattleScore1#battleScore.score_round]),
%% %% 				   if MyBattleScore1#battleScore.score_round >= 30 ->
%% %% 						  %%io:format("~s MyBattleScore2______[~p]\n",[misc:time_format(now()), MyBattleScore1#battleScore.score_round]),
%% 						  LeftLostHp = cptBattleLostAllHp(Left_battle_record),
%% 						  RightLostHp = cptBattleLostAllHp(Right_battle_record),
%% 						  if LeftLostHp > RightLostHp ->
%% 								 act_begin(Left_List, [] ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleSta, War_Num, Result_bin_list, MyBattleScore);
%% 							 LeftLostHp < RightLostHp ->
%% 								 act_begin([], Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleSta, War_Num, Result_bin_list, MyBattleScore);
%% 							 true ->
%% 								 case BattleSta#battleSta.pDirect of
%% 									 left ->
%% 										 act_begin(Left_List, [] ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleSta, War_Num, Result_bin_list, MyBattleScore);
%% 									 _ ->
%% 										 act_begin([], Right_List ,Battle_Sequence_List, Left_battle_record, Right_battle_record, BattleSta, War_Num, Result_bin_list, MyBattleScore)
%% 								 end
%% 						  end;
%% %% 					  true ->
%% %% 						  %%io:format("~s MyBattleScore3______[~p]\n",[misc:time_format(now()), MyBattleScore1#battleScore.score_round]),
%% %% 						  act_begin(Left_List, Right_List ,Round_List, Left_battle_record, Right_battle_record, BattleSta, War_Num, Result_bin_list, MyBattleScore1)
%% %% 				   end;
%% 			   true ->
%% 				   {Act_Role, NowLeft_Battle_Record, NowRight_Battle_Record, NowBattleSta} = 
%% 					   get_act_role(Left_List, Right_List, Left_battle_record, Right_battle_record, BattleSta, War_Num),
%% %% 				   Round_List = Battle_Sequence_List,
%% 				   MyBattleScore1 = MyBattleScore,
%% %% 					Act_Role = lists:nth(1, Round_List),                                             		%%提取当前攻击角色的队列信息		
%% 					{_Id,_,Direct,Pst,_Xy} = Act_Role,							   
%% 					case Direct of
%% 						left ->     %%左边正常攻击
%% 							Act_battle_record = NowLeft_Battle_Record;
%% 						right ->    %%右边正常攻击					
%% 							Act_battle_record = NowRight_Battle_Record
%% 					end,
%% 					Member_List=Act_battle_record#battle_record.members,
%% 					[Old_Member|_]=[M||M<-Member_List,M#member.pst=:=Pst],
%% 					{_RoleBuffSta, RoleHurtSta, NewHp, BinHpBuff, BuffPasList} = cptRoleActBeginBuff(Old_Member, []),                               %%计算buff对攻击角色血量的影响			
%% 					if NewHp =:= 0 ->  %%BUFF效果令攻击角色死亡				   
%% 						   Old_Member1 = Old_Member#member{hp = 0},
%% 						   %%巨兽怒气值增加公式修改（begin）
%% %% 						   HurtHp = Old_Member#member.hp,
%% 						   {Act_battle_record1, BuffPasList1} = chkPasSkillRev(Old_Member1#member.pst, Act_battle_record, BuffPasList),  %%角色死亡检测复仇被动技
%% %% 						   case Direct of
%% %% 							   left ->
%% %% 								   AddAnger = cptAngerVal(HurtHp, MyBattleScore1#battleScore.left_all_hp);
%% %% 							   right ->
%% %% 								   AddAnger = cptAngerVal(HurtHp, MyBattleScore1#battleScore.right_all_hp)
%% %% 						   end,
%% 						   AddAnger = 0,
%% 						   Anger = Act_battle_record#battle_record.anger + AddAnger,
%% 						   %%巨兽怒气值增加公式修改（end）
%% %%						   Anger = Act_battle_record#battle_record.anger + 10,
%% 						   NewAct_battle_record = updateBattle_record(Act_battle_record1, memberandanger, {Anger,Old_Member1}),  %%更改战斗成员信息和怒气值
%% 						   BattleSta1 = NowBattleSta, %%bBehemothAct(NewAct_battle_record, Direct, NowBattleSta),                            %%巨兽攻击判定    
%% 						   case Direct of 
%% 							   left ->
%% 								   New_Left_battle_record = NewAct_battle_record,
%% 								   New_Right_battle_record = NowRight_Battle_Record,
%% 								   New_Left_List = Left_List -- [Act_Role],          %%删除队列中死亡角色
%% 								   New_Right_List = Right_List;
%% 							   right ->
%% 								   New_Left_battle_record = NowLeft_Battle_Record,
%% 								   New_Right_battle_record = NewAct_battle_record,
%% 								   New_Left_List = Left_List,
%% 								   New_Right_List = Right_List -- [Act_Role]         %%删除队列中死亡角色
%% 						   end,				          
%% 						   ReBinActedArray = <<0:16>>,                        %%受攻击角色数据（这里没有发生攻击）
%% 						   ReBinRoleBuffArray = <<0:16>>,                     %%BUFF变化数据（这里没有发生BUFF攻击)		   
%% 				  		   BinPst = Pst,                                      %%位置
%% %% 						   BinBuffs = <<0:16>>,                               %%BUFF队列（死亡了没有BUFF）				   
%% 						   BinNowHp = 0,                                      %%当前血量
%% 						   BinActSta = 0,                                     %%死亡
%% 						   BinActEffctId = 0,                                 %%攻击特效ID(没有意义了)
%% 						   BinMana = 0,                                       %%气势值
%% 						   BinAnger = NewAct_battle_record#battle_record.anger,   %%怒气值
%% 						   BinPas = binPasList(New_Left_List, New_Right_List, BuffPasList1),  %%封包被动技能触发
%% 						   BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据
%% 						   New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% %% 						   New_Battle_Sequence_List = Round_List -- [Act_Role],                         %%在回合队列中减去当前攻击角色
%% 						   War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 						   act_begin(New_Left_List, New_Right_List, Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, BattleSta1, War_Num1, New_Result_bin_list_All1, MyBattleScore1);			   
%% 					   
%% 					   true ->	%%BUFF效果没令攻击角色死亡			   
%% 						   BNotAct = bNoAct(Old_Member) orelse bNoPwr(Old_Member) orelse bNoTech(Old_Member) orelse bNoMgc(Old_Member), %%判定是否发生攻击，如果有致盲、昏睡、 晕眩BUFF其中的一个或封足、封技、封法BUFF触发判定成功，不能攻击
%% 						   Old_Member1 = Old_Member#member{hp = NewHp},
%% 						   if RoleHurtSta =:= 1 ->                              %%发生了BUFF伤害
%% 								  %%巨兽怒气值增加公式修改（begin）
%% %% 						   		  HurtHp = Old_Member#member.hp - Old_Member1#member.hp,
%% %% 						   		  case Direct of
%% %% 							   		  left ->
%% %% 								   		  AddAnger = cptAngerVal(HurtHp, MyBattleScore1#battleScore.left_all_hp);
%% %% 							   		  right ->
%% %% 								   		  AddAnger = cptAngerVal(HurtHp, MyBattleScore1#battleScore.right_all_hp)
%% %% 						   		  end,
%% 								  AddAnger = 0,
%% 								  Anger = Act_battle_record#battle_record.anger + AddAnger,
%% 						   		  %%巨兽怒气值增加公式修改（end）
%% %%								  Anger = Act_battle_record#battle_record.anger + 5,
%% 								  NewAct_battle_record = updateBattle_record(Act_battle_record, memberandanger, {Anger,Old_Member1}),  %%更改战斗成员信息和怒气值
%% 								  BattleStaNew = NowBattleSta; %%bBehemothAct(NewAct_battle_record, Direct, NowBattleSta);                            %%巨兽攻击判定   
%% 							  true ->
%% 								  NewAct_battle_record = updateBattle_record(Act_battle_record, member, Old_Member1),  %%更改战斗成员信息
%% 								  BattleStaNew = NowBattleSta
%% 						   end,				   
%% 						   case Direct of 
%% 							   left ->
%% 								   NewTemp_Left_battle_record = NewAct_battle_record,
%% 								   NewTemp_Right_battle_record = NowRight_Battle_Record;						   
%% 							   right ->
%% 								   NewTemp_Left_battle_record = NowLeft_Battle_Record,
%% 								   NewTemp_Right_battle_record = NewAct_battle_record						   
%% 						   end,	 			   
%% 						   if BNotAct =:= true -> %%有致盲、昏睡、 晕眩BUFF其中的一个或封足、封技、封法BUFF触发判定成功，不能攻击
%% 								  BattleSubType = #battleSubType{},
%% 								  {NewBuffs, BattleSubType1} = updateBuff(Old_Member1, BattleSubType),                %%更新攻击角色的buff列表
%% 								  Old_Member2 = Old_Member1#member{buffs = NewBuffs},
%% 								  NewAct_battle_record1 = updateBattle_record(NewAct_battle_record, member, Old_Member2),  %%更改战斗成员信息					   
%% 								  case Direct of 
%% 									  left ->	
%% 										  NewTemp_Left_battle_record1 = NewAct_battle_record1,
%% 										  NewTemp_Right_battle_record1 = NewTemp_Right_battle_record;					   							   
%% 							   		  right ->
%% 								   		  NewTemp_Left_battle_record1 = NewTemp_Left_battle_record,
%% 								   		  NewTemp_Right_battle_record1 = NewAct_battle_record1						   
%% 						   		  end,	
%% 								  ReBinActedArray = <<0:16>>,                        %%受攻击角色数据（这里没有发生攻击）
%% 								  ReBinRoleBuffArray = ptBuffs(NewTemp_Left_battle_record1, NewTemp_Right_battle_record1, BattleSubType1),  %%变化BUFF数据（这里没有发生BUFF攻击)
%% %% 								  io:format("~s MyBattleScore3______[~p][~p][~p]\n",[misc:time_format(now()), War_Num, BattleSubType1#battleSubType.buffCancelList, ReBinRoleBuffArray]),
%% 								  BinPst = Pst,                                      %%位置
%% %% 						  		  BinBuffs = ptBuffs(NewBuffs),                      %%BUFF队列	
%% 								  BinNowHp = NewHp,                                      %%当前血量
%% 						     	  BinActSta = 1,                                     %%生存
%% 						   		  BinActEffctId = 0,                                 %%攻击特效ID(无特效攻击)
%% 						   		  BinMana = Old_Member2#member.mana,                 %%气势值 (BUFF伤害不会增加气势)
%% 						   		  BinAnger = NewAct_battle_record1#battle_record.anger,   %%怒气值
%% 								  BinPas = binPasList(Left_List, Right_List, BuffPasList),  %%封包被动技能触发
%% 								  BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据
%% 						   		  New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% %% 						   		  New_Battle_Sequence_List = Round_List -- [Act_Role],                         %%在回合队列中减去当前攻击角色
%% 						   		  War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 						   		  act_begin(Left_List, Right_List, Battle_Sequence_List, NewTemp_Left_battle_record1, NewTemp_Right_battle_record1, BattleStaNew, War_Num1, New_Result_bin_list_All1, MyBattleScore1);			   
%% 							  true ->
%% 								  OldMana = Old_Member1#member.mana,
%% %% 								  MissVal = cptMissBuff(Old_Member1, data_battle:getCrrMiss(Old_Member1#member.crr) *100),%%获取未命中率
%% %% 				   		  		  HitVal =  cptHitBuff(Old_Member1),               %%Old_Member1#member.hit,                              %%计算攻击者命中率（含BUFF影响）
%% %% 				   		  		  CritVal = cptCritBuff(Old_Member1),                %%Old_Member1#member.crit,                            %%计算攻击者暴击率（含BUFF影响）
%% %% %% 				   		  		  DCritVal = Old_Member1#member.dcrit,                 %%防暴击
%% %% 					  			  DBlckVal = cptDBlckBuff(Old_Member1),                  %%破格挡
%% %% 								  LvVal = Old_Member1#member.lv,                                %%攻击者等级
%% 								  if OldMana >= Old_Member1#member.mxmn ->                   %%技能攻击   
%% 										 {ActSkill, BattleSubType} = get_skill_act_data(Old_Member1),
%% 										 %%计算受攻击者队列
%% 										 BChaosAct = bCanChaosAct(Old_Member1),  %%判定是否混乱
%% %%										 io:format("~s act_begin--BChaosAct--[~p]\n",[misc:time_format(now()), BChaosAct]),
%% 										 if BChaosAct ->
%% 												Arrmy_Members1 = cptTechChaosActTo(Old_Member1, Direct, ActSkill, Left_List, Right_List);
%% 											true ->
%% 												Arrmy_Members1 = cptTechActTo(Old_Member1, Direct, ActSkill, Left_List, Right_List)
%% 										 end,
%% %% 										 io:format("~s act_begin--Arrmy_Members1--[~p][~p]\n",[misc:time_format(now()), Old_Member1#member.psttp, Arrmy_Members1]),
%% 										 if BattleSubType#battleSubType.typeId =:= 4 ->    %%连击处理
%% 												case BattleSubType#battleSubType.otherVal of											
%% 													2 ->
%% 														Arrmy_Members2 = lists:flatten([[AM,AM]||AM <- Arrmy_Members1]);
%% 													3 ->
%% 														Arrmy_Members2 = lists:flatten([[AM,AM,AM]||AM <- Arrmy_Members1]);
%% 													_ ->
%% 														Arrmy_Members2 = Arrmy_Members1
%% 												end;
%% 											true ->
%% 												Arrmy_Members2 = Arrmy_Members1
%% 										 end,
%% 										 
%% 										 %%连携攻击修改为普通攻击触发（liujing 2012-5-8）
%% %%										 case bNoRelaTech(Old_Member1, ActSkill) of  %%是否触发连携概率运算
%% %%											 false ->
%% %%												 BattleStaNew1 = BattleStaNew;
%% %%											 true ->										 
%% %%												 case ranRelaRatio(Old_Member1, Direct, Act_battle_record) of %%判断连携是否发生
%% %%													 noway ->
%% %%														 BattleStaNew1 = BattleStaNew;
%% %%													 PetPsttp ->
%% %%														 [RelaP] = cptActTo(Old_Member1, Direct, Left_List, Right_List),
%% %%														 %% 多人副本禁用连携
%% %%														 case BattleStaNew#battleSta.bTeamBattle of
%% %%															 true ->
%% %%																 BRela = false ;
%% %%															 false ->
%% %%																 BRela = true 
%% %%														 end ,
%% %%														 BattleStaNew1 = BattleStaNew#battleSta{
%% %%																								bRela = BRela,
%% %%																								relaActPsttp = PetPsttp,
%% %%																								relaDefPsttp = RelaP}
%% %%												 end
%% %%										 end,								 
%% %%										 
%% 										 BattleSubType1 = bNoCterTech(Old_Member1, ActSkill, BattleSubType),   %%是否触发反击概率运算（技能攻击下）									 	 
%% 										 BinActedArray = <<>>,		
%% 										 case BattleSubType#battleSubType.skilFId of
%% 											 26 ->          %%气势保留绝对值主动技能
%% 												 Old_Member2 = Old_Member1#member{mana = BattleSubType#battleSubType.otherVal},
%% 												 IniPasList = [#rolePasinfo{
%% 					  														pst = Old_Member2#member.pst,     
%% 					  														imef = 26,    
%% 					  														flag = 1,    
%% 					  														other_data = BattleSubType#battleSubType.otherVal   
%% 					  														}|BuffPasList];
%% 											 _ ->
%% 												 Old_Member2 = Old_Member1#member{mana = 0},                           %%气势清0
%% 												 IniPasList = BuffPasList
%% 										 end,
%% 								  		 NewAct_battle_record1 = updateBattle_record(Act_battle_record, member, Old_Member2),  %%更改战斗成员信息					   
%% 								  		 case Direct of 
%% 											 left ->
%% 												 NewTemp_Left_battle_record1 = NewAct_battle_record1,							  
%% 										  		 NewTemp_Right_battle_record1 = NewTemp_Right_battle_record;					   							   
%% 							   		  		 right ->
%% 								   		  		 NewTemp_Left_battle_record1 = NewTemp_Left_battle_record,
%% 								   		  		 NewTemp_Right_battle_record1 = NewAct_battle_record1						   
%% 						   		  		 end,	
%% 										 
%% 										 {ok, New_Left_List, New_Right_List, _New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, ReBinActedArray, BattleSta1, BattleSubTypeNew, Arrmy_Members_Len, NewBuffOffList, NewMyBattleScore, PasList} = 
%% 												arrmy_trauma(Arrmy_Members2, Old_Member2, Left_List, Right_List, Battle_Sequence_List, NewTemp_Left_battle_record1, NewTemp_Right_battle_record1, BinActedArray, BattleStaNew, BattleSubType1, 0, [], MyBattleScore1, IniPasList),
%% 										 ReBinActedArray1 = <<Arrmy_Members_Len:16, ReBinActedArray/binary>>,  %%加入数组长度		   
%% 										 
%% 										 case Direct of
%% 												left ->     %%左边buff攻击
%% 													BuffAct_battle_record = New_Left_battle_record;
%% 												right ->    %%右边buff攻击					
%% 													BuffAct_battle_record = New_Right_battle_record
%% 										 end,
%% 										 BuffAct_Member_List=BuffAct_battle_record#battle_record.members,   
%% 										 [BuffAct_Member|_]=[BM||BM<-BuffAct_Member_List,BM#member.pst=:=Pst],								 
%% 										 
%% 										 {NewBuffs, BattleSubTypeNew1} = updateBuff(BuffAct_Member, BattleSubTypeNew),                %%更新攻击角色的buff列表,每个BUFF次数减1
%% 								 		 NewBuffAct_Member = BuffAct_Member#member{buffs = NewBuffs, mana = BuffAct_Member#member.mana + BattleSubTypeNew1#battleSubType.upManaVal},
%% 								 		 NewBuffAct_battle_record = updateBattle_record(BuffAct_battle_record, member, NewBuffAct_Member),  %%更改战斗成员信息							 	
%% 										 								 
%% 										 BinRoleBuffArray = <<>>,  							 
%% 								  		 case Direct of 									 
%% 									 		 left ->	
%% 										  		NewTemp_Left_battle_record2 = NewBuffAct_battle_record,
%% 										  		NewTemp_Right_battle_record2 = New_Right_battle_record;					   							   
%% 							   		  		 right ->
%% 								   		  		NewTemp_Left_battle_record2 = New_Left_battle_record,
%% 								   		  		NewTemp_Right_battle_record2 = NewBuffAct_battle_record						   
%% 						   		  		 end,	
%% 										 if ActSkill#ets_skill.bftp =:= 0 ->   %%没有BUFF攻击
%% 												New_Left_battle_record1 = NewTemp_Left_battle_record2,
%% 												New_Right_battle_record1 = NewTemp_Right_battle_record2,
%% 												BattleSubTypeNew2 = BattleSubTypeNew1;
%% %% 												ReBinRoleBuffArray = <<>>,
%% %% 												BuffArrmy_Members_Len = 0;
%% 											true ->
%% 												%%计算BUFF受攻击者队列								
%% 										 		if BChaosAct ->       %%混乱											   
%% 													   BuffArrmy_Members = cptBuffActToOnChaos(NewBuffAct_Member, Direct, ActSkill, Left_List, Right_List);	%%通过原队列计算，不会产生队列误差，有死亡角色，在arrmyBuffActed函数中进行判定									   
%% 												   true ->            %%不混乱
%% 												       BuffArrmy_Members = cptBuffActTo(NewBuffAct_Member, Direct, ActSkill, Left_List, Right_List)
%% 										        end,
%% 												BuffArrmy_Members1 = BuffArrmy_Members -- NewBuffOffList,
%% %%												io:format("~s [BuffArrmy_MembersAll]--[NewBuffOffList]-[BuffArrmy_Members]---[~p][~p][~p]\n",[misc:time_format(now()), BuffArrmy_Members, NewBuffOffList, BuffArrmy_Members1]),
%% 												{New_Left_battle_record1, New_Right_battle_record1, _ReBinRoleBuffArray, _BuffArrmy_Members_Len, BattleSubTypeNew2} = 
%% 											 		arrmyBuffActed(BuffArrmy_Members1, NewTemp_Left_battle_record2, NewTemp_Right_battle_record2, ActSkill, BinRoleBuffArray, 0, BattleSubTypeNew1)
%% 										 end,
%% 										 ReBinRoleBuffArray = ptBuffs(New_Left_battle_record1, New_Right_battle_record1, BattleSubTypeNew2),
%% %% 										 ReBinRoleBuffArray1 = <<BuffArrmy_Members_Len:16, ReBinRoleBuffArray/binary>>,  %%加入数组长度
%% 										 case Direct of                     %%获取攻击角色的BUFF列表
%% 												left ->     %%左边buff攻击
%% 													New_Left_battle_record2 = 
%% 														New_Left_battle_record1#battle_record{anger = New_Left_battle_record1#battle_record.anger + data_battle:get_add_anger(NewBuffAct_Member#member.mtype)},
%% 													New_Right_battle_record2 = New_Right_battle_record1,
%% 													NewBuffAct_battle_record1 = New_Left_battle_record2;
%% 												right ->    %%右边buff攻击	
%% 													New_Left_battle_record2 = New_Left_battle_record1,
%% 													New_Right_battle_record2 = 
%% 														New_Right_battle_record1#battle_record{anger = New_Right_battle_record1#battle_record.anger + data_battle:get_add_anger(NewBuffAct_Member#member.mtype)},
%% 													NewBuffAct_battle_record1 = New_Right_battle_record2
%% 										 end,
%% 										 BattleSta2 = bBehemothAct(NewBuffAct_battle_record1, Direct, BattleSta1),
%% 										 AMemList = NewBuffAct_battle_record1#battle_record.members,
%% 										 [BuffAct_MemberT|_]=[BMT||BMT<-AMemList,BMT#member.pst=:=Pst],
%% %% 										 NowBuffs = BuffAct_MemberT#member.buffs,
%% 										 BinPst = Pst,                                      %%位置
%% %% 						  		  		 BinBuffs = ptBuffs(NowBuffs),                      %%BUFF队列				  		  		 
%% 								  		 BinNowHp = BuffAct_MemberT#member.hp,              %%当前血量
%% 						     	  		 BinActSta = 1,                                     %%生存
%% 						   		  		 BinActEffctId = 2,                                 %%攻击特效ID(绝技攻击)
%% 						   		  		 BinMana = BuffAct_MemberT#member.mana,                 %%气势值 
%% 						   		  		 BinAnger = NewBuffAct_battle_record1#battle_record.anger,   %%怒气值
%% 										 BinPas = binPasList(New_Left_List, New_Right_List, PasList),  %%封包被动技能触发
%% 										 BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray1, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据
%% 						   		  		 New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% %% 						   		  		 New_Battle_Sequence_List1 = New_Battle_Sequence_List -- [Act_Role],                         %%在回合队列中减去当前攻击角色
%% 						   		 		 War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 						   		 		 act_begin(New_Left_List, New_Right_List, Battle_Sequence_List, New_Left_battle_record2, New_Right_battle_record2, BattleSta2, War_Num1, New_Result_bin_list_All1, NewMyBattleScore);					  
%% 										             	
%% 									 true ->                                                               %%普通攻击
%% 										 BattleSubType = get_normal_act_data(Old_Member1),
%% 										 BChaosAct = bCanChaosAct(Old_Member1),  %%判定是否混乱
%% 										 if BChaosAct ->
%% 												Arrmy_Members1 = cptChaosBuffActTo(Old_Member1, Direct, Left_List, Right_List);
%% 											true ->
%% 												Arrmy_Members1 = cptActTo(Old_Member1, Direct, Left_List, Right_List)
%% 										 end,
%% 										 
%% 										 case bNoRelaTech(Old_Member1, BChaosAct) of  %%是否触发连携概率运算
%% 											 false ->
%% 												 BattleStaNew1 = BattleStaNew;
%% 											 true ->										 
%% %% 												 case ranRelaRatio(Direct, BattleStaNew) of %%判断连携是否发生 （新版不用判定，liujing 2012-10-26）
%% %% 													 false ->
%% %% 														 BattleStaNew1 = BattleStaNew;
%% %% 													 _ ->
%% 														 %% 多人副本禁用连携
%% 														 case BattleStaNew#battleSta.bTeamBattle of
%% 															 true ->
%% 																 BattleStaNew1 = BattleStaNew;
%% 															 false ->
%% 																 case getRelaPetList(Direct, Left_List, Right_List) of
%% 																	 [] ->
%% 																		 BattleStaNew1 = BattleStaNew;
%% 																	 PetList ->
%% %% 																		 RelaMustPetId = getRelaMustPetId(NewAct_battle_record),   
%% 																		 BattleStaNew1 = BattleStaNew#battleSta{
%% 																												bRela = true,
%% 																												relaActNum = 0,
%% 																												relaActPetPstL = PetList,
%% 																												relaPlayerPsttp = {Direct, Old_Member1#member.psttp},
%% 																												relaMustPetId = 0    %%新版取消最大亲密度宠物必出连携的功能
%% 																											   }  
%% 																 end
%% 														 end
%% %% 												 end
%% 										 end,								 
%% 										 
%% 										 BattleSubType1 = bNoCter(Old_Member1, BattleSubType),   %%是否触发反击概率运算（普通攻击下）
%% 										 BinActedArray = <<>>,
%% 										 {ok, New_Left_List, New_Right_List, _New_Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, ReBinActedArray, BattleSta1, BattleSubTypeNew, Arrmy_Members_Len, _NewBuffOffList, NewMyBattleScore, PasList} = 
%% 										      arrmy_trauma(Arrmy_Members1, Old_Member1, Left_List, Right_List, Battle_Sequence_List, NewTemp_Left_battle_record, NewTemp_Right_battle_record, BinActedArray, BattleStaNew1, BattleSubType1, 0, [], MyBattleScore1, BuffPasList),								 
%% 										 						 
%% 										 ReBinActedArray1 = <<Arrmy_Members_Len:16, ReBinActedArray/binary>>,  %%加入数组长度								 
%% 										 case Direct of
%% 												left ->     %%左边buff攻击
%% 													BuffAct_battle_record = New_Left_battle_record;
%% 												right ->    %%右边buff攻击					
%% 													BuffAct_battle_record = New_Right_battle_record
%% 										 end,										
%% 										 BuffAct_Member_List=BuffAct_battle_record#battle_record.members,   
%% 										 [BuffAct_Member|_]=[BM||BM<-BuffAct_Member_List,BM#member.pst=:=Pst],
%% 										 {NewBuffs, BattleSubTypeNew1} = updateBuff(BuffAct_Member, BattleSubTypeNew),                %%更新攻击角色的buff列表								 
%% 										 if BattleSubTypeNew1#battleSubType.bManaChange =:= true ->
%% 												NewMana = BuffAct_Member#member.mana + BuffAct_Member#member.mnup + BattleSubTypeNew1#battleSubType.upManaVal;
%% 											true ->
%% 												NewMana = BuffAct_Member#member.mana + BattleSubTypeNew1#battleSubType.upManaVal
%% 										 end,										
%% 								  		 BuffAct_Member1 = BuffAct_Member#member{
%% 																				 mana = NewMana,
%% 																				 buffs = NewBuffs},
%% 										 NewBuffAct_battle_record = updateBattle_record(BuffAct_battle_record, member, BuffAct_Member1),  %%更改战斗成员信息
%% 										 NewBuffAct_battle_record1 = 
%% 											 NewBuffAct_battle_record#battle_record{anger = NewBuffAct_battle_record#battle_record.anger + data_battle:get_add_anger(BuffAct_Member1#member.mtype)},
%% 										 case Direct of 
%% 											 left ->
%% 												 New_Left_battle_record1 = NewBuffAct_battle_record1,
%% 												 New_Right_battle_record1 = New_Right_battle_record;
%% 											 right ->
%% 												 New_Left_battle_record1 = New_Left_battle_record,
%% 												 New_Right_battle_record1 = NewBuffAct_battle_record1
%% 										 end,
%% 										 BattleSta2 = bBehemothAct(NewBuffAct_battle_record1, Direct, BattleSta1),
%% 										 ReBinRoleBuffArray = ptBuffs(New_Left_battle_record1, New_Right_battle_record1, BattleSubTypeNew1),    %%BUFF更改数据（这里没有发生BUFF攻击)
%% 								  		 BinPst = Pst,                                      %%位置
%% %% 						  		  		 BinBuffs = ptBuffs(NewBuffs),                      %%BUFF队列	(修改)			  		  		 
%% 								  		 BinNowHp = BuffAct_Member1#member.hp,               %%当前血量
%% 						     	  		 BinActSta = 1,                                     %%生存
%% 						   		  		 BinActEffctId = 1,                                 %%攻击特效ID(普通攻击)
%% %% 						   		  		 case data_battle:check_world_boss(BuffAct_Member1) of   %%判定是否世界BOSS
%% %% 											 true ->
%% %% 												 BinMana = 0;
%% %% 											 _ ->
%% 												 BinMana = BuffAct_Member1#member.mana,                 %%气势值 (BUFF伤害不会增加气势)ReBinActedArray
%% %% 										 end,
%% 						   		  		 BinAnger = NewBuffAct_battle_record1#battle_record.anger,   %%怒气值	 
%% 										 BinPas = binPasList(New_Left_List, New_Right_List, PasList),  %%封包被动技能触发
%% %% 										 io:format("anger_[~p]\n", [BinAnger]),
%% 										 BinWarRound = ptSimpleAct(BinPst, BinHpBuff, BinNowHp, BinActSta, BinActEffctId, BinMana, BinAnger, ReBinActedArray1, ReBinRoleBuffArray, BinPas),   %%打包单次攻击数据				   		  		 
%% 										 New_Result_bin_list_All1 = <<Result_bin_list/binary, BinWarRound/binary>>,    %%合并数据包
%% %% 						   		  		 New_Battle_Sequence_List1 = New_Battle_Sequence_List -- [Act_Role],                         %%在回合队列中减去当前攻击角色
%% 						   		 		 War_Num1 = War_Num + 1,                            %%战斗次数加1
%% 						   		 		 act_begin(New_Left_List, New_Right_List, Battle_Sequence_List, New_Left_battle_record1, New_Right_battle_record1, BattleSta2, War_Num1, New_Result_bin_list_All1, NewMyBattleScore)						  
%% 							   	  end					
%% 						   end			
%% 					end				   				   
%% 			end
%% 	end.				   
%% 			
%% %%------------------------------------------------------------------------------------------------------
%% %%--------arrmy_trauma/9计算受攻击角色的伤害及数值修改（Arrmy_Members-受攻击角色队列（格式：[{left/right,
%% %%--------------------------二维坐标}）,..], Act_type-攻击类型（1-内力攻击，2-绝技攻击，3-法术攻击）, 
%% %%--------------------------Act_Member-攻击角色相应攻击类型的攻击力, Player_List-左边角色列表(按位置排过序),
%% %%--------------------------Mon_List-右边角色列表(按位置排过序), Battle_Sequence_List-战斗序列列表, 
%% %%--------------------------Left_battle_record-左边战斗数据记录, Right_battle_record-右边战斗数据记录, 
%% %%--------------------------Result_bin_list-二进制打包数据, BChangeMana判断攻击者是否增加气势）
%% %%------------------------------------------------------------------------------------------------------			
%% arrmy_trauma([], _Act_Member, Left_List, Right_List, Battle_Sequence_List, Left_battle_record, Right_battle_record, Result_bin_list, BattleSta, BattleSubType, ArrmyLength, BuffOffList, MyBattleScore, PasList) ->
%% 	{ok, Left_List, Right_List, Battle_Sequence_List, Left_battle_record, Right_battle_record, Result_bin_list, BattleSta, BattleSubType, ArrmyLength, BuffOffList, MyBattleScore, PasList};
%% 
%% arrmy_trauma(Arrmy_Members, Act_Member, Left_List, Right_List, Battle_Sequence_List, Left_battle_record, Right_battle_record, Result_bin_list, BattleSta, BattleSubType, ArrmyLength, BuffOffList, MyBattleScore, PasList) ->
%% 	{Direct, Psttp}=lists:nth(1,Arrmy_Members),
%% %% 	io:format("~s arrmy_trauma----[~p][~p]\n",[misc:time_format(now()), Act_Member#member.pst, Arrmy_Members]),
%% 	case Direct of
%% 		left ->
%% 			Def_battle_record = Left_battle_record;
%% 		right ->
%% 			Def_battle_record = Right_battle_record
%% 	end,
%% 	Def_Member_List = Def_battle_record#battle_record.members,
%% 	[Def_Member|_]=[M||M <- Def_Member_List, M#member.psttp =:= Psttp],
%% %% 	DefAllVal = cptDefAll(Def_Member, BattleSubType#battleSubType.actType),   %%计算防守成员的总防御力
%% 	case BattleSubType#battleSubType.bAct of
%% 		true ->   %%发生攻击	
%% %% 			io:format("~s gongji--1--\n",[misc:time_format(now())]),
%% 			case BattleSubType#battleSubType.typeId of     %%闪、暴、挡RAND点
%% 				10 ->     %%巨兽攻击不用rand点
%% 					RandKey = nomalR;
%% 				9 ->      %%反击攻击不用rand点
%% 					RandKey = nomalR;
%% 				11 ->     %%连携攻击不用rand点
%% 					RandKey = nomalR;
%% 				2 ->      %%技能攻击要计算对技能对概率的影响（攻击方的已加成，这里是加入对防守者的影响）
%% 					case BattleSubType#battleSubType.skilFId of
%% 						24 ->  %%降低对手格挡率
%% 							DefDdgeRatio = tool:int_format(cptDdgeBuff(Def_Member)),              %%防守者的闪避率
%% 							DefBlckRatioT1 = cptBlckBuff(Def_Member),              
%% 							DefBlckRatioDown = BattleSubType#battleSubType.otherVal,
%% 							DefBlckRatio = tool:int_format(DefBlckRatioT1 - DefBlckRatioDown);         %%防守者的格挡率
%% 						25 ->  %%降低对手闪避
%% 							DefBlckRatio = tool:int_format(cptBlckBuff(Def_Member)),              %%防守者的格挡率
%% 							DefDdgeRatioT1 = cptDdgeBuff(Def_Member),              %%防守者的闪避率
%% 							DefDdgeRatioDown = BattleSubType#battleSubType.otherVal,
%% 							DefDdgeRatio = tool:int_format(DefDdgeRatioT1 - DefDdgeRatioDown);
%% 						_ ->
%% 							DefDdgeRatio = tool:int_format(cptDdgeBuff(Def_Member)),              %%防守者的闪避率
%% 							DefBlckRatio = tool:int_format(cptBlckBuff(Def_Member))              %%防守者的格挡率
%% 					end,
%% 					MissRatio = BattleSubType#battleSubType.missVal, %%攻击者的未命中率
%% 					ActHitRatio = BattleSubType#battleSubType.hitVal,    %%攻击者的命中率
%% 					ActCritRatio = BattleSubType#battleSubType.critVal,   %%攻击者的暴击率
%% 					ActDBlckRatio = BattleSubType#battleSubType.dblck,    %%攻击者破格挡（穿刺）
%% 					DefDCritRatio = tool:int_format(cptDCritBuff(Def_Member)),    %%防守者的防暴击率（韧性）
%% 					CritRatio = tool:int_format(ActCritRatio - DefDCritRatio),    %%暴击率
%% %% 					DdgeRatio = tool:int_format(DefDdgeRatio - ActHitRatio),      %%闪避率
%% 					BlckRatio = tool:int_format(DefBlckRatio - ActDBlckRatio),    %%格挡率
%% %% 					RollRatio = cptRollRatio(BattleSubType#battleSubType.lvVal, Def_Member#member.lv),      %%计算碾压率
%% 					RandKey = ranWarRatio(MissRatio, ActHitRatio, DefDdgeRatio, BlckRatio, CritRatio); %%计算各种概率的发生（闪避、暴击、格挡）
%% 				_ ->
%% 					MissRatio = BattleSubType#battleSubType.missVal, %%攻击者的未命中率
%% 					DefDdgeRatio = tool:int_format(cptDdgeBuff(Def_Member)),              %%防守者的闪避率
%% 					DefBlckRatio = tool:int_format(cptBlckBuff(Def_Member)),              %%防守者的格挡率
%% 					ActHitRatio = BattleSubType#battleSubType.hitVal,    %%攻击者的命中率
%% 					ActCritRatio = BattleSubType#battleSubType.critVal,   %%攻击者的暴击率
%% 					ActDBlckRatio = BattleSubType#battleSubType.dblck,    %%攻击者破格挡（穿刺）
%% 					DefDCritRatio = tool:int_format(cptDCritBuff(Def_Member)),    %%防守者的防暴击率（韧性）
%% 					CritRatio = tool:int_format(ActCritRatio - DefDCritRatio),    %%暴击率
%% %% 					DdgeRatio = tool:int_format(DefDdgeRatio - ActHitRatio),      %%闪避率
%% 					BlckRatio = tool:int_format(DefBlckRatio - ActDBlckRatio),    %%格挡率
%% %% 					RollRatio = cptRollRatio(BattleSubType#battleSubType.lvVal, Def_Member#member.lv),      %%计算碾压率
%% 					RandKey = ranWarRatio(MissRatio, ActHitRatio, DefDdgeRatio, BlckRatio, CritRatio)   %%计算各种概率的发生（闪避、暴击、格挡）
%% 			end,
%% 			case RandKey of
%% 				ddgeR ->    %%闪避不做被动技能判定
%% 					Def_Member_chg1 = Def_Member,
%% 					PasList1 = PasList;
%% 				missR ->    %%未命中不做被动技判定
%% 					Def_Member_chg1 = Def_Member,
%% 					PasList1 = PasList;
%% 				_ ->        %%对防守成员被动技能的攻击和防御进行触发和计算
%% 					{Def_Member_chg1, PasList1} = chkPasActDef(Def_Member, PasList)
%% 			end,
%% %% 			io:format("~s 20001_______[Direct][ActType][ActAllVal][DefAllVal][HurtVal][RandKey]________[~p][~p][~p][~p][~p][~p]\n",[misc:time_format(now()),Direct,BattleSubType#battleSubType.actType,ActAllVal, DefAllVal, HurtVal, RandKey]),			
%% 			ActAllVal = BattleSubType#battleSubType.actVal,			
%% 			case BattleSubType#battleSubType.typeId of        %%计算初始伤害
%% 				9 ->        %%反击，伤害减半
%% 					DefAllVal = getDefAll(Def_Member_chg1, BattleSubType#battleSubType.actType),   %%计算防守成员的防御力（不带BUFF效果及被动技效果）
%% 					TmpHurtVal = cptBaseHurt(ActAllVal, DefAllVal, BattleSubType#battleSubType.actType),
%% 					HurtVal = round(TmpHurtVal / 2);
%% 				11 ->       %%连携攻击
%% 					DefAllVal = getDefAll(Def_Member_chg1, BattleSubType#battleSubType.actType),   %%计算防守成员的防御力（不带BUFF效果及被动技效果）
%% 					TmpHurtVal = cptBaseHurt(ActAllVal, DefAllVal, BattleSubType#battleSubType.actType),
%% 					HurtVal = data_battle:cptRelaHurt(Act_Member#member.rela, BattleSta#battleSta.relaActNum, TmpHurtVal);
%% 				10 ->      %%巨兽攻击  (新版修改为计算防御)
%% 					DefAllVal = cptDefAll(Def_Member_chg1, BattleSubType#battleSubType.actType),   %%计算防守成员的防御力（带BUFF效果及被动技效果）
%% 					HurtVal = cptBaseHurt(ActAllVal, DefAllVal, BattleSubType#battleSubType.actType);
%% %% 					%%巨兽攻击时绝技攻击，免疫普通攻击BUFF无效，绝对伤害，攻击力就是伤害
%% %% 					HurtVal = ActAllVal;
%% 				4 ->       %%连击攻击
%% 					ActType = data_battle:getCrrActType(Act_Member#member.crr),              
%% 					DefAllVal = cptDefAll(Def_Member_chg1, ActType),                               %%计算防守成员的防御力（计算的是普通防御力，带BUFF效果及被动技效果）
%% 					HurtVal = cptBaseHurt(ActAllVal, DefAllVal, BattleSubType#battleSubType.actType);
%% 				_ ->       %%其他攻击
%% 					DefAllVal = cptDefAll(Def_Member_chg1, BattleSubType#battleSubType.actType),   %%计算防守成员的防御力（带BUFF效果及被动技效果）
%% 					HurtVal = cptBaseHurt(ActAllVal, DefAllVal, BattleSubType#battleSubType.actType)
%% 			end,
%% %% 			io:format("_get_hurt___1___[~p] \n", [[ActAllVal, DefAllVal]]),
%% 
%% 			HurtVal1 = HurtVal,
%% 
%% 			case RandKey of
%% 				nomalR ->
%% 					MyBattleScore1 = MyBattleScore,
%% 					HurtAll = HurtVal1,
%% 					NewBuffOffList = BuffOffList,
%% 					BinDefEffctId = 0;                               %%受击者普通特效						
%% 				missR ->     %%伤害数值在这里没有价值（cptHurt会重新赋值伤害为0）
%% 					case Direct of
%% 						left ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_player_luck = MyBattleScore#battleScore.score_player_luck + 1};
%% 						right ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_mon_luck = MyBattleScore#battleScore.score_mon_luck + 1}
%% 					end,
%% 					HurtAll = 0,
%% 					NewBuffOffList = BuffOffList ++ [{Direct, Psttp}],
%% 					BinDefEffctId = 1;                               %%受击者MISS特效					
%% 				ddgeR ->    %%伤害数值在这里没有价值（cptHurt会重新赋值伤害为0）
%% 					case Direct of
%% 						left ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_player_luck = MyBattleScore#battleScore.score_player_luck + 1};
%% 						right ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_mon_luck = MyBattleScore#battleScore.score_mon_luck + 1}
%% 					end,
%% 					HurtAll = 0,
%% 					NewBuffOffList = BuffOffList ++ [{Direct, Psttp}],
%% 					BinDefEffctId = 2;                               %%受击者闪避特效					
%% 				blckR ->
%% 					case Direct of
%% 						left ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_player_luck = MyBattleScore#battleScore.score_player_luck + 1};
%% 						right ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_mon_luck = MyBattleScore#battleScore.score_mon_luck + 1}
%% 					end,
%% 					HurtAll = round(HurtVal1 / 2),
%% 					NewBuffOffList = BuffOffList,
%% 					BinDefEffctId = 3;                               %%受击者格挡特效						
%% 				critR ->
%% 					{ActDirectTmp, _ActPsttpTmp} = pstToDirectAndPsttp(Act_Member#member.pst),
%% 					case ActDirectTmp of
%% 						left ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_player_luck = MyBattleScore#battleScore.score_player_luck + 1};
%% 						right ->
%% 							MyBattleScore1 = MyBattleScore#battleScore{score_mon_luck = MyBattleScore#battleScore.score_mon_luck + 1}
%% 					end,
%% 					HurtAll = round(HurtVal1 * 1.5),
%% 					NewBuffOffList = BuffOffList,
%% 					BinDefEffctId = 4                               %%受击者被暴击特效					
%% %% 				rollR ->
%% %% 					{ActDirectTmp, _ActPsttpTmp} = pstToDirectAndPsttp(Act_Member#member.pst),
%% %% 					case ActDirectTmp of
%% %% 						left ->
%% %% 							MyBattleScore1 = MyBattleScore#battleScore{score_player_luck = MyBattleScore#battleScore.score_player_luck + 1};
%% %% 						right ->
%% %% 							MyBattleScore1 = MyBattleScore#battleScore{score_mon_luck = MyBattleScore#battleScore.score_mon_luck + 1}
%% %% 					end,
%% %% 					HurtAll = HurtVal * 2,
%% %% 					NewBuffOffList = BuffOffList,
%% %% 					BinDefEffctId = 5                               %%受击者碾压特效					
%% 			end,
%% 			
%% 			case BattleSubType#battleSubType.actType of
%% 				2 ->         %%绝技伤害，mana值有加成
%% 					if BattleSubType#battleSubType.typeId =/= 10 -> %%巨兽攻击与气势无关
%% 						   ManaVal = BattleSubType#battleSubType.manaVal,
%% 						   MxMana = Act_Member#member.mxmn,
%% 						   HurtAll1 = round(HurtAll * (1 + 0.5*(ManaVal - MxMana)/(ManaVal - MxMana + 80))); %%round(HurtAll * (1 + 0.003*(ManaVal - MxMana)));
%% 					   true ->
%% 						   HurtAll1 = HurtAll 
%% 					end;					
%% 				_ ->
%% 					if BattleSubType#battleSubType.typeId =/= 4 ->  
%% 						   HurtAll1 = HurtAll;
%% 					   true ->                       %%连击也是绝技攻击，也要做气势加成
%% 						   ManaVal = BattleSubType#battleSubType.manaVal,
%% 						   MxMana = Act_Member#member.mxmn,
%% 					       HurtAll1 = round(HurtAll * (1 + 0.5*(ManaVal - MxMana)/(ManaVal - MxMana + 80)))  %%(1 + 0.003*(ManaVal - MxMana)))
%% 					end
%% 			end,
%% 			case data_battle:check_world_boss(Def_Member_chg1) of   %%判定是否世界BOSS
%% 				true ->
%% 					HurtAll_Boss = round(HurtAll1 * data_battle:get_world_boss_hurt_ra());
%% 				_ ->
%% 					HurtAll_Boss = HurtAll1
%% 			end,
%% 			{NewHurtAll, Def_Member_chg2, PasList2} = cptHurt(Def_Member_chg1, ActAllVal, HurtAll_Boss, PasList1, BattleSubType, RandKey),
%% 
%% 						%%计算双方总伤害逻辑处理（begin）
%% 			case BattleSubType#battleSubType.typeId of
%% 				10 ->     %%巨兽攻击的攻击方肯定是受击方的对方
%% 					ActDirect = case Direct of
%% 									left ->
%% 										right;
%% 									right ->
%% 										left
%% 								end;
%% 				_ ->
%% 					{ActDirect, _ActPsttp} = pstToDirectAndPsttp(Act_Member#member.pst)
%% 			end,
%% 			case ActDirect of
%% 				left ->
%% 					MyBattleScore2 = MyBattleScore1#battleScore{score_player_hurt = MyBattleScore1#battleScore.score_player_hurt + NewHurtAll};
%% 				right ->
%% 					MyBattleScore2 = MyBattleScore1
%% 			end,
%% 			%%计算双方总伤害逻辑处理（end）
%% %% 			io:format("~s gongji--2--\n",[misc:time_format(now())]),
%% 
%% 			{BinNowHp, BinDefSta, Def_Member_chg3, PasList3} = arrmy_data_change(NewHurtAll, Def_Member_chg2, PasList2),     %%PasList3之前还有两个被动技能逻辑点需要判断
%% 			
%% 			BattleSta1 = ranCterRatioToAll(Act_Member, Def_Member_chg3, BattleSubType, BattleSta, RandKey),  %%反击计算，下次是否有反击攻击
%% %% 			io:format("~s 20001_______[BattleSta1]________[~p]\n",[misc:time_format(now()), BattleSta1]),
%% %% 			if NewHurtAll > 0 ->               %%怒气计算，需要有伤害产生才作怒气增加
%% %% 				   case BattleSubType#battleSubType.typeId of
%% %% 					   10 ->                   %%怒气攻击不改变怒气值
%% %% 						   NowAnger = Def_battle_record#battle_record.anger;
%% %% 					   _ ->
%% %% 						   case BinDefSta of
%% %% 							   1 ->
%% %% 								   HurtHp = Def_Member_chg3#member.hp - BinNowHp,
%% %% 								   case Direct of
%% %% 									   left ->
%% %% 										   AddAnger = cptAngerVal(HurtHp, MyBattleScore2#battleScore.left_all_hp);
%% %% 									   right ->
%% %% 										   AddAnger = cptAngerVal(HurtHp, MyBattleScore2#battleScore.right_all_hp)
%% %% 								   end,
%% %% 								   NowAnger = Def_battle_record#battle_record.anger + AddAnger;
%% %% %% 								   NowAnger = Def_battle_record#battle_record.anger + 5;					   
%% %% 							   0 ->
%% %% 				   				   HurtHp = Def_Member_chg3#member.hp - BinNowHp,
%% %% 								   case Direct of
%% %% 									   left ->
%% %% 										   AddAnger = cptAngerVal(HurtHp, MyBattleScore2#battleScore.left_all_hp);
%% %% 									   right ->
%% %% 										   AddAnger = cptAngerVal(HurtHp, MyBattleScore2#battleScore.right_all_hp)
%% %% 								   end,
%% %% 								   NowAnger = Def_battle_record#battle_record.anger + AddAnger;
%% %% %% 								   NowAnger = Def_battle_record#battle_record.anger + 10;
%% %% 							   _ ->
%% %% 								   NowAnger = Def_battle_record#battle_record.anger   
%% %% 						   end
%% %% 				   end;
%% %% 			   true ->
%% %% 				   NowAnger = Def_battle_record#battle_record.anger
%% %% 			end,			
%% 			NowAnger = Def_battle_record#battle_record.anger,
%% 			BManaChange = BattleSubType#battleSubType.bManaChange,
%% 			if NewHurtAll > 0 ->             %%气势计算，需要有伤害产生才作气势增加
%% 				   case BattleSubType#battleSubType.actType of
%% 					   ATId when ATId =:= 2 orelse ATId =:= 10 ->                                                    %%绝技攻击气势不作变化
%% 						   %% 						  if BattleSubType#battleSubType.typeId =:= 5 ->      %%减气势的绝技攻击
%% 						   if BattleSubType#battleSubType.skilFId =:= 12 ->    %%减气势的绝技攻击
%% 								  PasList4 = [#rolePasinfo{
%% 														   pst = Def_Member_chg3#member.pst,     
%% 														   imef = 12,    
%% 														   flag = 1,    
%% 														   other_data = BattleSubType#battleSubType.otherVal   
%% 														  }|PasList3],
%% 								  %%PasList4 = PasList3 ++ [{Def_Member_chg3#member.pst, 12, 1, BattleSubType#battleSubType.otherVal}],
%% %% 								  if Def_Member_chg3#member.mana > BattleSubType#battleSubType.otherVal ->
%% 								  NowMana = tool:int_format(Def_Member_chg3#member.mana - BattleSubType#battleSubType.otherVal),
%% %% 								  io:format("~s giant_down_mana--[~p, ~p]--\n",[misc:time_format(now()), Def_Member_chg3#member.mana, NowMana]),
%% 								  BattleSubTypeNew = BattleSubType#battleSubType{bManaChange = BManaChange or false};									
%% %% 									 true ->
%% %% 										 NowMana = 0,
%% %% 										 BattleSubTypeNew = BattleSubType#battleSubType{bManaChange = BManaChange or false}
%% %% 								  end;
%% 							  true ->
%% 								  PasList4 = PasList3,
%% 								  NowMana = Def_Member_chg3#member.mana,
%% 								  BattleSubTypeNew = BattleSubType#battleSubType{bManaChange = BManaChange or false}						  
%% 						   end;
%% 					   _ ->
%% 						   PasList4 = PasList3,
%% 						   if BattleSubType#battleSubType.typeId =/= 4 andalso BattleSubType#battleSubType.typeId =/= 11 andalso BattleSubType#battleSubType.typeId =/= 10 andalso BattleSubType#battleSubType.typeId =/= 9 ->  								 
%% 								  NowMana = Def_Member_chg3#member.mana + Def_Member_chg3#member.mnup,								 
%% 								  BattleSubTypeNew = BattleSubType#battleSubType{bManaChange = BManaChange or true}; %%攻击者的气势也要做变化
%% 							  true ->                                        %%连击,也是绝技攻击，气势不作变化, 连携攻击双方都不加气势
%% 								  NowMana = Def_Member_chg3#member.mana,								 
%% 								  BattleSubTypeNew = BattleSubType#battleSubType{bManaChange = BManaChange or false}
%% 						   end
%% 				   end;
%% 			   true ->
%% 				   PasList4 = PasList3,
%% 				   NowMana = Def_Member_chg3#member.mana,
%% 				   BattleSubTypeNew = BattleSubType#battleSubType{bManaChange = BManaChange or false}
%% 			end,
%% %% 			io:format("~s gongji--3--\n",[misc:time_format(now())]),
%% 			{NewBuffs, BattleSubTypeNew1} = updateSleepBuff(Def_Member_chg3, BattleSubTypeNew),          %%更新昏睡BUFF			  
%% 			Def_Member_chg4 = Def_Member_chg3#member{
%% 											 mana = NowMana,
%% 											 hp = BinNowHp,
%% 											 buffs = NewBuffs
%% 											},
%% %% 			io:format("~s gongji--3-1-\n",[misc:time_format(now())]),
%% 			{Def_Member1, BattleSubTypeNew2} = updateOtherMana(RandKey, Act_Member, Def_Member_chg4, BattleSubTypeNew1),      %%根据双方人物职业计算额外气势增加
%% 			if BinDefSta =:= 0 ->
%% 				   {Def_battle_record1, PasList5} = chkPasSkillRev(Def_Member1#member.pst, Def_battle_record, PasList4);  %%角色死亡检测复仇被动技
%% 			   true ->
%% 				   Def_battle_record1 = Def_battle_record,
%% 				   PasList5 = PasList4
%% 			end,
%% 			NewDef_battle_record = updateBattle_record(Def_battle_record1, memberandanger, {NowAnger, Def_Member1}), %%更新战斗记录
%% 			BattleStaNew = BattleSta1, %%bBehemothAct(NewDef_battle_record, Direct, BattleSta1),	%%判定巨兽攻击
%% 			case Direct of
%% 				left ->
%% 					New_Left_battle_record = NewDef_battle_record,
%% 					New_Right_battle_record = Right_battle_record;
%% 				right ->
%% 					New_Left_battle_record = Left_battle_record,
%% 					New_Right_battle_record = NewDef_battle_record
%% 			end,
%% %% 			io:format("~s gongji--4--\n",[misc:time_format(now())]),
%% 			if BinDefSta =/= 0 ->         %%角色生存，改变战斗队列
%% 				   New_Arrmy_Members = Arrmy_Members -- [{Direct, Psttp}],   %%在防守队列中减去当前的角色
%% 				   New_Left_List = Left_List,
%% 				   New_Right_List = Right_List;
%% %% 				   New_Battle_Sequence_List = Battle_Sequence_List;
%% 			   true ->                    %%角色死亡，改变战斗队列
%% 				   New_Arrmy_Members = [AM||AM<-Arrmy_Members, AM =/= {Direct, Psttp}],    %%在防守队列中减去和当前角色相同的所有角色
%% %% 				   New_Battle_Sequence_List = [{_Id, _Type, _Direct, Pst1, _Psttp1}||{_Id, _Type, _Direct, Pst1, _Psttp1}<- Battle_Sequence_List, Pst1 =/= Def_Member1#member.pst],
%% %% 				   New_Battle_Sequence_List = New_Arrmy_Members,
%% 				   case Direct of
%% 					   left ->						   
%% 						   New_Left_List = [{_Id2, _Type2, _Direct2, Pst2, _Psttp2}||{_Id2, _Type2, _Direct2, Pst2, _Psttp2}<- Left_List, Pst2 =/= Def_Member1#member.pst],
%% 						   New_Right_List = Right_List;					   
%% 					   right ->
%% 						   New_Left_List = Left_List,
%% 						   New_Right_List = [{_Id2, _Type2, _Direct2, Pst2, _Psttp2}||{_Id2, _Type2, _Direct2, Pst2, _Psttp2}<- Right_List, Pst2 =/= Def_Member1#member.pst]
%% 				   end
%% 			end,
%% 			%%数据封包
%% %% 			io:format("~s gongji--5--\n",[misc:time_format(now())]),
%% 			DefPst = Def_Member1#member.pst,			
%% %% 			DefBuffBin = ptBuffs(Def_Member1#member.buffs),	
%% 			BinAnger = NewDef_battle_record#battle_record.anger,  %%NowAnger的值不是最终值，战斗记录中的才是
%% %% 			case data_battle:check_world_boss(Def_Member1) of   %%判定是否世界BOSS
%% %% 				 true ->
%% %% 					 BinMana = 0;
%% %% 				 _ ->
%% 					 BinMana = NowMana,
%% %% 			end,
%% %% 			io:format("anger_[~p]\n", [BinAnger]),
%% 			DefBin = ptSimpleDef(DefPst, BinDefEffctId, 2, NewHurtAll, BinNowHp, BinDefSta, BinMana, BinAnger),
%% 			New_Result_bin_list = <<Result_bin_list/binary, DefBin/binary>>,
%% 			NewArrmyLength = ArrmyLength + 1,
%% 			arrmy_trauma(New_Arrmy_Members, Act_Member, New_Left_List, New_Right_List, Battle_Sequence_List, New_Left_battle_record, New_Right_battle_record, New_Result_bin_list, BattleStaNew, BattleSubTypeNew2, NewArrmyLength, NewBuffOffList, MyBattleScore2, PasList5);   
%% 			
%% 		false ->   %%未发生攻击
%% %% 			io:format("~s bu_gongji--1--\n",[misc:time_format(now())]),
%% 			case BattleSubType#battleSubType.typeId of
%% 				6 ->                %%加气势
%% %% 					PasList1 = PasList ++ [{Def_Member#member.pst, 11, 1, BattleSubType#battleSubType.otherVal}],
%% 					PasList1 = [#rolePasinfo{
%% 					  						 pst = Def_Member#member.pst,     
%% 					  						 imef = 11,    
%% 					  						 flag = 1,    
%% 					  						 other_data = BattleSubType#battleSubType.otherVal   
%% 					  						 }|PasList],
%% 					OldMana = Def_Member#member.mana,
%% 					Def_Member1 = Def_Member#member{mana = OldMana + BattleSubType#battleSubType.otherVal},
%% 					Act_Member1 = Act_Member,
%% 					HpUpDown = 0,
%% 					HpChg = 0,
%% 					NowHp = Def_Member#member.hp;
%% 				7 ->                %%加气血
%% 					PasList1 = PasList,
%% 					OldHp = Def_Member#member.hp,
%% 					HpChg = BattleSubType#battleSubType.otherVal,
%% 					NewHp = OldHp + HpChg,
%% %% 					io:format("~s 20001_______TechaddHp________[~p][~p]\n",[misc:time_format(now()), HpChg, NewHp]),
%% 					if NewHp > Def_Member#member.mxhp ->
%% 						   NowHp = Def_Member#member.mxhp;
%% 					   true ->
%% 						   NowHp = NewHp
%% 					end,
%% 					Def_Member1 = Def_Member#member{hp = NowHp},
%% 					Act_Member1 = Act_Member,
%% 					HpUpDown = 1;					
%% 				8 ->                %%换血
%% 					PasList1 = PasList,
%% 					ActHp = Act_Member#member.hp,
%% 					DefHp = Def_Member#member.hp,
%% 					if ActHp =< Def_Member#member.mxhp ->
%% 						   Def_Member1 = Def_Member#member{hp = ActHp},
%% 						   NowHp = ActHp;					   
%% 					   true ->
%% 						   Def_Member1 = Def_Member#member{hp = Def_Member#member.mxhp},
%% 						   NowHp = Def_Member1#member.hp
%% 					end,
%% 					if DefHp =< Act_Member#member.mxhp ->
%% 						   Act_Member1 = Act_Member#member{hp = DefHp};
%% 					   true ->
%% 						   Act_Member1 = Act_Member#member{hp = Act_Member#member.mxhp}
%% 					end,
%% 					if ActHp < DefHp ->
%% 						  HpUpDown = 2,
%% 						  HpChg = DefHp - ActHp;
%% 					   ActHp > DefHp ->
%% 						  HpUpDown = 1,
%% 						  HpChg = ActHp - DefHp;
%% 					   true ->
%% 						  HpUpDown = 0,
%% 						  HpChg = 0
%% 					end;				
%% 				_ ->
%% 					PasList1 = PasList,
%% 					Def_Member1 = Def_Member,
%% 					Act_Member1 = Act_Member,
%% 					HpUpDown = 0,
%% 					HpChg = 0,
%% 					NowHp = Def_Member1#member.hp
%% 			end,			
%% 			{ActDirect, _ActPsttp} = pstToDirectAndPsttp(Act_Member1#member.pst),
%% 			case ActDirect of
%% 				left ->
%% 					New_Left_battle_record = updateBattle_record(Left_battle_record, member, Act_Member1),  %%更新攻击方的战斗记录
%% 					New_Right_battle_record = Right_battle_record;
%% 				right ->
%% 					New_Left_battle_record = Left_battle_record,
%% 					New_Right_battle_record = updateBattle_record(Right_battle_record, member, Act_Member1)
%% 			end,
%% 			NewDef_battle_record = updateBattle_record(Def_battle_record, member, Def_Member1), %%更新战斗记录
%% 			case Direct of
%% 				left ->
%% 					New_Left_battle_record1 = NewDef_battle_record,
%% 					New_Right_battle_record1 = New_Right_battle_record;
%% 				right ->
%% 					New_Left_battle_record1 = New_Left_battle_record,
%% 					New_Right_battle_record1 = NewDef_battle_record
%% 			end,
%% 			%%无攻击的战斗没有怒气改变，绝技攻击气势无变化,并且不更新昏睡BUFF
%% 			DefPst = Def_Member1#member.pst,			
%% %% 			DefBuffBin = ptBuffs(Def_Member1#member.buffs),
%% 			DefEffctId = 6,                           %%受击特效ID,未受击
%% 			DefSta = 1,
%% %% 			case data_battle:check_world_boss(Def_Member1) of   %%判定是否世界BOSS
%% %% 				 true ->
%% %% 					 BinMana = 0;
%% %% 				 _ ->
%% 					 BinMana = Def_Member1#member.mana,
%% %% 			end,
%% %% 			NowMana = Def_Member1#member.mana,
%% 			NowAnger = NewDef_battle_record#battle_record.anger,
%% 			DefBin = ptSimpleDef(DefPst, DefEffctId, HpUpDown, HpChg, NowHp, DefSta, BinMana, NowAnger),
%% 			New_Result_bin_list = <<Result_bin_list/binary, DefBin/binary>>,
%% 			NewArrmyLength = ArrmyLength + 1,
%% 			New_Arrmy_Members = Arrmy_Members -- [{Direct, Psttp}],
%% 			arrmy_trauma(New_Arrmy_Members, Act_Member1, Left_List, Right_List, Battle_Sequence_List, New_Left_battle_record1, New_Right_battle_record1, New_Result_bin_list, BattleSta, BattleSubType, NewArrmyLength, BuffOffList, MyBattleScore, PasList1)
%% 				
%% 	end.
%% 
%% %%计算BUFF攻击受攻击方数值和属性的改变
%% 
%% arrmyBuffActed([], Left_battle_record, Right_battle_record, _ActSkill, BinRoleBuffArray, BuffArrmysLen, BattleSubType) ->
%% 	{Left_battle_record, Right_battle_record, BinRoleBuffArray, BuffArrmysLen, BattleSubType};
%% 
%% arrmyBuffActed(Buff_Arrmy_Members, Left_battle_record, Right_battle_record, ActSkill, BinRoleBuffArray, BuffArrmysLen, BattleSubType) ->
%% 	{Direct, Psttp}=lists:nth(1,Buff_Arrmy_Members),
%% 	case Direct of
%% 		left ->
%% 			Def_battle_record = Left_battle_record;
%% 		right ->
%% 			Def_battle_record = Right_battle_record
%% 	end,
%% 	Def_Member_List = Def_battle_record#battle_record.members,
%% 	Def_Member_L = [M||M <- Def_Member_List, M#member.psttp =:= Psttp andalso M#member.hp > 0 andalso M#member.crr =/= 100],  %%职业为100是世界BOSS
%% 	case Def_Member_L of
%% 		[] ->
%% 			Buff_Arrmy_Members1 = Buff_Arrmy_Members -- [{Direct, Psttp}],
%% 			arrmyBuffActed(Buff_Arrmy_Members1, Left_battle_record, Right_battle_record, ActSkill, BinRoleBuffArray, BuffArrmysLen, BattleSubType);
%% 		_ ->			
%% 			[Def_Member|_] = Def_Member_L,
%% 			OldBuffs = Def_Member#member.buffs,
%% 			BuffRatio = ActSkill#ets_skill.bfrg *100,
%% 			if ActSkill#ets_skill.bftp > 0 ->
%% 					if ActSkill#ets_skill.bftm > 0 ->
%% 							if BuffRatio >= 10000 ->
%% 								    BBuffChg = 1,   %%改变BUFF
%% 									BattleSubType1 = BattleSubType#battleSubType{buffAddList = BattleSubType#battleSubType.buffAddList ++ [{Def_Member#member.pst, ActSkill#ets_skill.bftp}]},
%% 						   			NewBuffs = [{ActSkill#ets_skill.bftp, ActSkill#ets_skill.bfval, ActSkill#ets_skill.bftm}|OldBuffs];
%% 	  				 			true ->		   
%% 						   			Ratio = util:rand(1, 10000),
%% %% 								io:format("~s 20001_______TechBuffRand________[~p]\n",[misc:time_format(now()), Ratio]),
%% 						   			if Ratio > 0 andalso Ratio =< BuffRatio ->	
%% 										    BBuffChg = 1,   %%改变BUFF
%% 											BattleSubType1 = BattleSubType#battleSubType{buffAddList = BattleSubType#battleSubType.buffAddList ++ [{Def_Member#member.pst, ActSkill#ets_skill.bftp}]},
%% 						   		 			NewBuffs = [{ActSkill#ets_skill.bftp, ActSkill#ets_skill.bfval, ActSkill#ets_skill.bftm}|OldBuffs ];			  
%% 	  				 		  			true ->
%% 											BBuffChg = 0,   %%未改变BUFF
%% 											BattleSubType1 = BattleSubType,
%% 						   		 			NewBuffs = OldBuffs
%% 						   			end
%% 							end;
%% 					   true ->
%% 						    BBuffChg = 0,
%% 							BattleSubType1 = BattleSubType,
%% 							NewBuffs = OldBuffs
%% 					end;
%% 			   true ->
%% 				    BBuffChg = 0,
%% 					BattleSubType1 = BattleSubType,
%% 					NewBuffs = OldBuffs
%% 			end,
%% 			if BBuffChg =:= 1 ->
%% 				   NewDefMember = Def_Member#member{buffs = NewBuffs},
%% 				   NewDef_battle_record = updateBattle_record(Def_battle_record, member, NewDefMember);
%% 			   true ->
%% %% 				   NewDefMember = Def_Member,
%% 				   NewDef_battle_record = Def_battle_record
%% 			end,
%% 			case Direct of
%% 				left ->
%% 					Left_battle_record1 = NewDef_battle_record,
%% 					Right_battle_record1 = Right_battle_record;
%% 				right ->
%% 					Left_battle_record1 = Left_battle_record,
%% 					Right_battle_record1 = NewDef_battle_record
%% 			end,
%% 			Buff_Arrmy_Members1 = Buff_Arrmy_Members -- [{Direct, Psttp}],
%% %% 			if BBuffChg =:= 1 ->
%% %% 				   BuffArrmysLen1 = BuffArrmysLen + 1,
%% %% 				   BinPst = NewDefMember#member.pst,
%% %% 				   BinNewBuffs = ptBuffs(NewBuffs),
%% %% 				   BinRoleBuffArray1 = <<BinRoleBuffArray/binary, BinPst:8, BinNewBuffs/binary>>;
%% %% 			   true ->
%% %% 				   BuffArrmysLen1 = BuffArrmysLen,
%% %% 				   BinRoleBuffArray1 = BinRoleBuffArray
%% %% 			end,
%% 			arrmyBuffActed(Buff_Arrmy_Members1, Left_battle_record1, Right_battle_record1, ActSkill, BinRoleBuffArray, BuffArrmysLen, BattleSubType1)
%% 	end.
%% 
%% %%计算受伤害成员的血量改变及状态（0-死亡，1-生存）
%% arrmy_data_change(Hurt, DefMember, PasList) ->
%% 	if Hurt > 0 ->
%% 		   Hp = DefMember#member.hp,
%% 		   if Hp > Hurt ->
%% 				  {ReHurt, NewPasList} = chkPasSkillReHp(DefMember, PasList, Hurt),   %%伤害转血量被动技
%% 				  {Hp - Hurt + ReHurt, 1, DefMember, NewPasList};
%% 			  true ->
%% 				  chkPasSkillRelive(DefMember, PasList)        %%复生和垂死被动技
%% 		   end;
%% 	   true ->
%% 		   {DefMember#member.hp, 1, DefMember, PasList}
%% 	end.
%% 
%% 
%% %%位置坐标转换二维坐标{行，列}
%% positionConversion(Pst) ->
%% 	case Pst of
%% 		1 -> {1,1};  
%% 		2 -> {2,1};
%% 		3 -> {3,1};
%% 		4 -> {1,2};
%% 		5 -> {2,2};
%% 		6 -> {3,2};
%% 		7 -> {1,3};
%% 		8 -> {2,3};
%% 		9 -> {3,3};
%% 		_ -> errorPosition
%% 	end.
%% 
%% re_pos(Psttp) ->
%% 	case Psttp of
%% 		{1,1} -> 1;  
%% 		{2,1} -> 2;
%% 		{3,1} -> 3;
%% 		{1,2} -> 4;
%% 		{2,2} -> 5;
%% 		{3,2} -> 6;
%% 		{1,3} -> 7;
%% 		{2,3} -> 8;
%% 		{3,3} -> 9;
%% 		_ -> 0
%% 	end.
%% 
%% %%loadSimpleWarList/2通过双方战斗成员记录列表BattleMembers表示[record#battleMember,..],
%% %%转化为战斗成员简表[{00001, 2, left, 11, {1,1}},..]
%% loadSimpleWarList(Direct, FormationRecord) ->
%% 	case Direct of
%% 		left ->
%% 			%%[{M#battleMember.id, M#battleMember.mtype, Direct, M#battleMember.pst + 10, positionConversion(M#battleMember.pst)}||M <- BattleMembers];
%% 			lists:keysort(4,[{Id, RoleType, Direct, Pst + 10, positionConversion(Pst)}||{Id, RoleType, Pst} <- FormationRecord#frmt.posl, is_integer(Id) andalso Id =/= 0]);
%% 		right ->
%% 			%%[{M#battleMember.id, M#battleMember.mtype, Direct, M#battleMember.pst + 20, positionConversion(M#battleMember.pst)}||M <- BattleMembers]
%% 			lists:keysort(4,[{Id, RoleType, Direct, Pst + 20, positionConversion(Pst)}||{Id, RoleType, Pst} <- FormationRecord#frmt.posl, is_integer(Id) andalso Id =/= 0])
%% 	end.
%% 
%% %%通过战斗记录battle_record建立战斗成员简表并修改角色坐标方向
%% loadSimpleWarListLoop(Direct, BattleRecord) ->
%% 	case Direct of
%% 		left ->
%% 			Fun = fun(M1) ->
%% 						  NewPst = (M1#member.pst rem 10) + 10,
%% 						  M1#member{pst = NewPst}
%% 				  end,
%% 			Members = lists:map(Fun, BattleRecord#battle_record.members),
%% 			BattleRecord1 = BattleRecord#battle_record{
%% 													   members = Members
%% 													  };
%% 		right ->
%% 			Fun = fun(M1) ->
%% 						  NewPst = (M1#member.pst rem 10) + 20,
%% 						  M1#member{pst = NewPst}
%% 				  end,
%% 			Members = lists:map(Fun, BattleRecord#battle_record.members),
%% 			BattleRecord1 = BattleRecord#battle_record{
%% 													   members = Members
%% 													  }
%% 	end,
%% 	{BattleRecord1, lists:keysort(4,[{M#member.id, M#member.mtype, Direct, M#member.pst, M#member.psttp} || M <- BattleRecord1#battle_record.members, M#member.hp =/= 0])}.
%% 	
%% 		
%% %% %%把#frmt类型记录转换为#formation型记录,供战斗使用
%% %% changeFrmtRecord(FrmtRecord) ->
%% %% 	  #formation{
%% %% 				id = FrmtRecord#frmt.id, 
%% %% 				uid = FrmtRecord#frmt.uid,	
%% %% 				bbtid = FrmtRecord#frmt.bbtid,
%% %% 				nick = FrmtRecord#frmt.nick,
%% %% 				rbidl = FrmtRecord#frmt.rbidl,
%% %% 				posl = FrmtRecord#frmt.posl, 
%% %% 				p1 = FrmtRecord#frmt.p1,		
%% %% 				p2 = FrmtRecord#frmt.p2,		
%% %% 				p3 = FrmtRecord#frmt.p3,		
%% %% 				p4 = FrmtRecord#frmt.p4,		
%% %% 				p5 = FrmtRecord#frmt.p5,		
%% %% 				p6 = FrmtRecord#frmt.p6,		
%% %% 				p7 = FrmtRecord#frmt.p7,		
%% %% 				p8 = FrmtRecord#frmt.p8,		
%% %% 				p9 = FrmtRecord#frmt.p9	
%% %% 				}.
%% 
%% %% %%把#formation类型记录转换为#frmt型记录,供战斗数据初始化
%% %% changeFormationRecord(FrmtRecord) ->
%% %% 	  #frmt{
%% %% 				id = FrmtRecord#formation.id, 
%% %% 				uid = FrmtRecord#formation.uid,	
%% %% 				bbtid = FrmtRecord#formation.bbtid,
%% %% 				nick = FrmtRecord#formation.nick,
%% %% 				rbidl = FrmtRecord#formation.rbidl,
%% %% 				posl = FrmtRecord#formation.posl, 
%% %% 				p1 = FrmtRecord#formation.p1,		
%% %% 				p2 = FrmtRecord#formation.p2,		
%% %% 				p3 = FrmtRecord#formation.p3,		
%% %% 				p4 = FrmtRecord#formation.p4,		
%% %% 				p5 = FrmtRecord#formation.p5,		
%% %% 				p6 = FrmtRecord#formation.p6,		
%% %% 				p7 = FrmtRecord#formation.p7,		
%% %% 				p8 = FrmtRecord#formation.p8,		
%% %% 				p9 = FrmtRecord#formation.p9	
%% %% 				}.		
%% 
%% %%加载怪物战斗数据及阵型数据 
%% %%返回 [Exp, Coin, GoodsList, RBattleData, Right_List, RFormation] 经验 铜钱 物品列表 战斗数据 战斗序列List 战斗阵型
%% loadMonData(RightId) ->
%% 	case ets:lookup(?ETS_MONGROUP, RightId) of
%% 		[] ->
%% 			[0, 0, 0, [], [], [], []];
%% 		[MonGroup|_] ->
%% 			%%查询怪物群组ETS表，获取怪物数据列表(RMonMemberList),阵型列表(Right_List)及克制阵型的Id列表(RestraintList),后续处理
%% 			RMonMemberList = MonGroup#ets_mongroup.posl,
%% %% 			Right_List = [{MonMember#member.id, 3, right, MonMember#member.pst, MonMember#member.psttp}||MonMember <-RMonMemberList],
%% 			[RBattleData, Right_List] = loadMonDataRecord(RMonMemberList), 
%% 			case Right_List of
%% 				[] ->
%% 					RBattleDataNew = [];
%% 				_ ->
%% 					RBattleDataNew = RBattleData
%% 			end,
%% 			RFormation = lib_formation:getFrmtFromId(MonGroup#ets_mongroup.frmid),			%%通过怪物阵型ID获取阵型记录，用于计算相克阵型列表
%% 			Fun = fun({MonId, Type, _Direct, Pst, _Ppst}) ->
%% 						  {MonId, Type, Pst rem 10}
%% 				  end,
%% 			MonPosl = lists:map(Fun, Right_List),
%% 			RFormation1 = RFormation#frmt{posl = MonPosl},
%% 			[MonGroup#ets_mongroup.exp, MonGroup#ets_mongroup.coin, MonGroup#ets_mongroup.goth, MonGroup#ets_mongroup.goods, RBattleDataNew, Right_List, RFormation1]
%% 	end.
%% 	
%% 
%% loadBossData(RightId,BossName) ->
%% 	case ets:lookup(?ETS_MONGROUP, RightId) of
%% 		[] ->
%% 			[0, 0, [], [], [], []];
%% 		[MonGroup|_] ->
%% 			%%查询怪物群组ETS表，获取怪物数据列表(RMonMemberList),阵型列表(Right_List)及克制阵型的Id列表(RestraintList),后续处理
%% 			RMonMemberList = MonGroup#ets_mongroup.posl,
%% %% 			Right_List = [{MonMember#member.id, 3, right, MonMember#member.pst, MonMember#member.psttp}||MonMember <-RMonMemberList],
%% 			[RBattleData, Right_List] = loadMonDataRecord(RMonMemberList), 
%% 			case Right_List of
%% 				[] ->
%% 					RBattleDataNew = [];
%% 				_ ->
%% 					[BossMember | _ ] = RBattleData#battleData.members ,
%% 					NewBossMember = BossMember#battleMember{nick=BossName} ,
%% 					RBattleDataNew = RBattleData#battleData{members=[NewBossMember]}
%% 			end,
%% 			RFormation = lib_formation:getFrmtFromId(MonGroup#ets_mongroup.frmid),			%%通过怪物阵型ID获取阵型记录，用于计算相克阵型列表
%% 			[MonGroup#ets_mongroup.exp, MonGroup#ets_mongroup.coin, MonGroup#ets_mongroup.goth, MonGroup#ets_mongroup.goods, RBattleDataNew, Right_List, RFormation]
%% 	end.
%% 
%% 
%% %%计算阵型相克
%% formationRestraintData(LFormation, RFormation) ->
%% 	Lrbl = LFormation#frmt.rbidl,
%% 	LFId = LFormation#frmt.bbtid,
%% %% 	LFName = LFormation#formation.nick,
%% 	Rrbl = RFormation#frmt.rbidl,
%% 	RFId = RFormation#frmt.bbtid,
%% %% 	RFName = RFormation#formation.nick,
%% 	case lists:member(LFId, Rrbl) of
%% 		false ->
%% 			case lists:member(RFId, Lrbl) of
%% 				false ->
%% 					[];
%% 				_ ->
%% 					getRtrtA(LFId, left, RFId)
%% 			end;
%% 		_ ->
%% 			getRtrtA(RFId, right, LFId)
%% 	end.
%% 
%% %%获取克制的静态关系表：	MasterFName-主克方阵法Id，Direct-主克方所处方向（左/右），PassiveFName-被克方阵法Id			
%% getRtrtA(MasterFId, Direct, PassiveFId) ->
%% 	case MasterFId of
%% 		403000001 ->
%% 			case PassiveFId of
%% 				403000002 ->
%% 					[{Direct, crit, up, rat, 10}];
%% 				403000004 ->
%% 					[{Direct, crit, up, rat, 5}];
%% 				_ ->
%% 					[]
%% 			end;
%% 		403000002 ->
%% 			case PassiveFId of
%% 				403000003 ->
%% 					[{Direct, blck, up, rat, 10}];
%% 				403000005 ->
%% 					[{Direct, blck, up, rat, 5}];
%% 				_ ->
%% 					[]
%% 			end;
%% 		403000003 ->
%% 			case PassiveFId of
%% 				403000004 ->
%% 					[{Direct, ddge, up, rat, 10}];
%% 				403000001 ->
%% 					[{Direct, ddge, up, rat, 5}];
%% 				_ ->
%% 					[]
%% 			end;
%% 		403000004 ->
%% 			case PassiveFId of
%% 				403000005 ->
%% 					[{Direct, dpwr, up, rat, 10}, {Direct, dmgc, up, rat, 10}];
%% 				403000002 ->
%% 					[{Direct, dpwr, up, rat, 5}, {Direct, dmgc, up, rat, 5}];
%% 				_ ->
%% 					[]
%% 			end;
%% 		403000005 ->
%% 			case PassiveFId of
%% 				403000001 ->
%% 					[{Direct, apwr, up, rat, 10}, {Direct, amgc, up, rat, 10}];
%% 				403000003 ->
%% 					[{Direct, apwr, up, rat, 5}, {Direct, amgc, up, rat, 5}];
%% 				_ ->
%% 					[]
%% 			end;
%% 		_ ->
%% 			[]
%% 	end.
%% 
%% %%加载阵法相克的加成属性到战斗成员中，     Member-战斗成员记录(#member),RstFL-阵法相克属性列表，如：[{Direct, ddge, up, val, 10}]
%% get_member_restraint_data(Member, [])->
%% 	Member;
%% get_member_restraint_data(Member, RstFL)->
%%   [RstF|RstFL1] = RstFL,
%%   {_Direct, Attr, Chg, CTyp, Val} = RstF,
%%   case Attr of
%% 	  crit ->       %%修改暴击值
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val -> %%修改值要乘以100，暴击数值的前两位为暴击率,后面为暴击强度
%% 						  TempVal = Member#member.crit + cptCritRatio(Member#member.crr, Val * 100),
%% 						  Member1 = Member#member{crit = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = Member#member.crit + cptCritRatio(Member#member.crr, Val),
%% 						  Member1 = Member#member{crit = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.crit - cptCritRatio(Member#member.crr, Val * 100) of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{crit = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = case Member#member.crit - cptCritRatio(Member#member.crr, Val) of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{crit = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  blck ->   %%修改格挡值，格挡数值的前两位为格挡率,后面为格挡强度
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val -> %%修改值要乘以100，暴击数值的前两位为暴击率,后面为暴击强度
%% 						  TempVal = Member#member.blck + cptBlckRatio(Member#member.crr, Val * 100),
%% 						  Member1 = Member#member{blck = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = Member#member.blck + cptBlckRatio(Member#member.crr, Val),
%% 						  Member1 = Member#member{blck = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.blck - cptBlckRatio(Member#member.crr, Val * 100) of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{blck = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = case Member#member.blck - cptBlckRatio(Member#member.crr, Val) of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{blck = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  dpwr ->     %%修改内功防御值
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = Member#member.dpwr + Val,
%% 						  Member1 = Member#member{dpwr = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = 100 + Val,
%% 						  TempVal1 = round(Member#member.dpwr * TempVal/100),
%% 						  Member1 = Member#member{dpwr = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.dpwr - Val of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{dpwr = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = 100 - Val,
%% 						  TempVal1 = round(Member#member.dpwr * TempVal / 100),
%% 						  Member1 = Member#member{dpwr = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  dmgc ->   %%修改法力防御值
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = Member#member.dmgc + Val,
%% 						  Member1 = Member#member{dmgc = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = 100 + Val,
%% 						  TempVal1 = round(Member#member.dmgc * TempVal / 100 ),
%% 						  Member1 = Member#member{dmgc = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.dmgc - Val of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{dmgc = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = 100 - Val,
%% 						  TempVal1 = round(Member#member.dmgc * TempVal / 100 ),
%% 						  Member1 = Member#member{dmgc = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  ddge ->     %%修改闪避值， 闪避数值的前两位为闪避率,后面为闪避强度
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val -> %%修改值要乘以100，暴击数值的前两位为暴击率,后面为暴击强度
%% 						  TempVal = Member#member.ddge + cptDdgeRatio(Member#member.crr, Val * 100),
%% 						  Member1 = Member#member{ddge = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = Member#member.ddge + cptDdgeRatio(Member#member.crr, Val),
%% 						  Member1 = Member#member{ddge = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.ddge - cptDdgeRatio(Member#member.crr, Val * 100) of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{ddge = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = case Member#member.ddge - cptDdgeRatio(Member#member.crr, Val) of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{ddge = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  apwr ->    %%修改内力攻击值
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = Member#member.apwr + Val,
%% 						  Member1 = Member#member{apwr = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = 100 + Val,
%% 						  TempVal1 = round(Member#member.apwr * TempVal / 100 ),
%% 						  Member1 = Member#member{apwr = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.apwr - Val of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{apwr = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = 100 - Val,
%% 						  TempVal1 = round(Member#member.apwr * TempVal / 100 ),
%% 						  Member1 = Member#member{apwr = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  amgc ->     %%修改法力攻击值
%% 		  case Chg of
%% 			  up ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = Member#member.amgc + Val,
%% 						  Member1 = Member#member{amgc = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);				
%% 					  rat ->
%% 						  TempVal = 100 + Val,
%% 						  TempVal1 = round(Member#member.amgc * TempVal / 100 ),
%% 						  Member1 = Member#member{amgc = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);					  		
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)					  
%% 				  end;
%% 			  down ->
%% 				  case CTyp of
%% 					  val ->
%% 						  TempVal = case Member#member.amgc - Val of
%% 										TVal when TVal > 0 ->
%% 											TVal;
%% 										_ ->
%% 											0
%% 									end,
%% 						  Member1 = Member#member{amgc = TempVal},
%% 						  get_member_restraint_data(Member1, RstFL1);					  
%% 					  rat ->
%% 						  TempVal = 100 - Val,
%% 						  TempVal1 = round(Member#member.amgc * TempVal / 100 ),
%% 						  Member1 = Member#member{amgc = TempVal1},
%% 						  get_member_restraint_data(Member1, RstFL1);
%% 					  _ ->
%% 						  get_member_restraint_data(Member, RstFL1)
%% 				  end;
%% 			  _ ->
%% 				  get_member_restraint_data(Member, RstFL1)				
%% 		  end;
%% 	  _ ->
%% 		  get_member_restraint_data(Member, RstFL1)		  
%%   end. 
%% 
%% %%通过怪物列表获取战斗信息
%% loadMonDataRecord(RMonMemberList) ->
%% 	[BattleMembers, Right_List] = loadMonDataRecord1([], RMonMemberList),
%% 	[#battleData{
%% 				behId = 0,     %%巨兽ID, 为0表示无
%% 		 		behLv = 0,       %%巨兽等级
%% 		 		maxang = 0,          %%怒气上限
%% 		 		behThId = 0,        %%巨兽技能ID
%% 		 		members = BattleMembers        %%由battleMember记录组成的列表
%% 			   }, 
%% 	 Right_List].
%% 
%% loadMonDataRecord1([Members, Right_List], []) ->
%% 	[Members, Right_List];
%% loadMonDataRecord1([], RMonMemberList) ->
%% %% 	io:format("~s loadMonDataRecord1[~p]~n",[misc:time_format(now()),RMonMemberList]),
%% 	[{BMember, Pst, Ppst}|LastL] = RMonMemberList,
%% 	case BMember of
%% 		[] ->
%% 			Members1 = [],
%% 			Right_List1 = [];
%% 		_ ->
%% 			Members1 = [BMember],
%% 			Right_List1 = [{BMember#battleMember.id, 3, right, Pst, Ppst}]
%% 	end,
%% 	loadMonDataRecord1([Members1, Right_List1], LastL);
%% loadMonDataRecord1([Members, Right_List], RMonMemberList) ->
%% 	[{BMember, Pst, Ppst}|LastL] = RMonMemberList,
%% 	case BMember of
%% 		[] ->
%% 			Members1 = Members,
%% 			Right_List1 = Right_List;
%% 		_ ->
%% 			Members1 = Members ++ [BMember],
%% 			Right_List1 = Right_List ++ [{BMember#battleMember.id, 3, right, Pst, Ppst}]
%% 	end,
%% 	loadMonDataRecord1([Members1, Right_List1], LastL).
%% 
%% 
%% 
%% %%内部函数-----------------------------------------------------------------------------------------------------------------------------
%% 
%% %%判定防守者BUFF列表中是否有免疫普通攻击BUFF
%% bTrueDef(Def_Member) ->
%% 	Buffs = Def_Member#member.buffs,
%% 	case Buffs of
%% 		[] ->
%% 			false;
%% 		_ ->
%% 			TrueDefList = [{Id, _Val, _Time}||{Id, _Val, _Time}<-Buffs, Id =:= 75],
%% 			case TrueDefList of
%% 				[] ->
%% 					false;
%% 				_ ->
%% 					true
%% 			end
%% 	end.
%% 
%% %%计算受到普通攻击时是否触发反击运算（通过攻击者的职业）
%% 
%% %%返回#battleSubType记录
%% bNoCter(ActMember, BattleSubType) ->
%% 	DistType = data_battle:getCrrActDist(ActMember#member.crr),
%% 	if DistType =:= 3 ->  %%远程攻击不发生反击
%% 		   BattleSubType#battleSubType{bCter = false};
%% 	   true ->
%% 		   BattleSubType#battleSubType{bCter = true}
%% 	end.
%% 
%% 
%% %%计算受到技能攻击时是否触发反击运算（通过攻击者的职业、技能，特殊处理二连击是不触发反击的）
%% 
%% %%返回#battleSubType记录
%% bNoCterTech(ActMember, ActSkill, BattleSubType) ->
%% 	DistType = data_battle:getCrrActDist(ActMember#member.crr),
%% 	if DistType =:= 3 ->  %%远程攻击不发生反击
%% 		   BattleSubType#battleSubType{bCter = false};	   
%% 	   true ->
%% 		   case ActSkill#ets_skill.imef of
%% 			   5 ->    %%连击不发生反击
%% 				   BattleSubType#battleSubType{bCter = false};
%% 			   11 ->
%% 				   BattleSubType#battleSubType{bCter = false};
%% 			   13 ->
%% 				   BattleSubType#battleSubType{bCter = false};
%% 			   14 ->
%% 				   BattleSubType#battleSubType{bCter = false};
%% 			   15 ->
%% 				   BattleSubType#battleSubType{bCter = false};
%% 			   _ ->
%% 				   case ActSkill#ets_skill.immod of
%% 					   2 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 					   3 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 					   4 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 				   	   6 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 					   7 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 					   8 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 					   9 ->
%% 						   BattleSubType#battleSubType{bCter = false};
%% 					   _ ->
%% 						   BattleSubType#battleSubType{bCter = true}
%% 				   end
%% 		   end
%% 	end.
%% 			   
%% %%是否触发连携概率运算(人物混乱后不发生连携)
%% 
%% %%返回#battleSubType记录
%% bNoRelaTech(ActMember, BChaosAct) ->
%% 	if ActMember#member.mtype =/= 1 ->  %%攻击方不是人物角色
%% 		   false;
%% 	   true ->
%% 		   case BChaosAct of
%% 			   true ->
%% 				   false;
%% 			   _ ->
%% 				   true
%% 		   end
%% 		   
%% %% 		   case ActSkill#ets_skill.imef of
%% %% 			   2 ->
%% %% 				   true;
%% %% 			   4 ->
%% %% 				   true;
%% %% 			   5 ->
%% %% 				   true;
%% %% 			   12 ->
%% %% 				   true;
%% %% 			   _ ->
%% %% 				   false
%% %% 		   end
%% 	end.
%% 		   
%% 
%% %% %%计算正常攻击时是否触发反击运算（通过攻击者的职业）
%% %% bNoCterNomal(ActMember, BattleSubType) ->
%% %% 	DistType = data_battle:getCrrActDist(ActMember#member.crr),
%% %% 	if DistType =:= 3 ->
%% %% 		   BattleSubType#battleSubType{bCter = false};	   
%% %% 	   true ->
%% %% 		   BattleSubType#battleSubType{bCter = true}
%% %% 	end.
%% 
%% %%计算反击发生与不发生的BattleSta记录的属性改变
%% %%返回新的BattleSta记录
%% ranCterRatioToAll(ActMember, DefMember, BattleSubType, BattleSta, RandKey) ->
%% 	case BattleSubType#battleSubType.bCter of
%% 		true ->  %%反击规则发生改变
%% %% 			case RandKey of
%% %% 				blckR ->            %%格挡
%% %% 					case data_battle:chk_crr(DefMember#member.crr, 3) of
%% %% 						true ->
%% %% 							BCter = ok;
%% %% 						_ ->
%% %% 							BCter = ranCterRatio(DefMember#member.cter)
%% %% 					end;
%% %% 				_ ->
%% %% 					BCter = ranCterRatio(DefMember#member.cter)
%% %% 			end,
%% 			case RandKey of
%% 				blckR ->            %%格挡
%% 					BCter = ok;
%% 				_ ->
%% 					BCter = false
%% 			end,
%% 			case BCter of
%% 				ok ->
%% 					CterActPsttp = pstToDirectAndPsttp(DefMember#member.pst),               %%防守者坐标格式转换
%% 					CterDefPsttp = pstToDirectAndPsttp(ActMember#member.pst),               %%攻击者坐标格式转换					
%% 					BattleSta#battleSta{
%% 										bCter = true,                           %%下次攻击是否启用反击
%% 										cterActPsttp = CterActPsttp,         %%反击的攻击方坐标({left,Psttp}/{right,Psttp})
%% 										cterDefPsttp = CterDefPsttp             %%反击的防御方坐标({left,Psttp}/{right,Psttp})
%% 										};
%% 				_ ->
%% 					BattleSta
%% 			end;
%% 		false ->
%% 			BattleSta
%% 	end.					
%% 
%% 
%% %%计算是否发生反击-------------------------------------------------------------------------------------------------------------------------
%% %%CterRatio - 受攻击方反击概率
%% %%返回ok表示反击成功，返回noway表示反击失败
%% ranCterRatio(CterRatio) ->	
%% 	Ratio = util:rand(1, 10000),
%% 	if Ratio > 0 andalso Ratio =< CterRatio ->
%% 		   ok;
%% 	   true ->
%% 		   noway
%% 	end.	
%% 	
%% %%通过概率计算闪避、格挡、暴击、正常攻击的发生情况----------------------------------------------------------------------
%% ranWarRatio(MissRatio, HitRatio, DdgeRatio, BlckRatio, CritRatio) ->
%% 	{UpDown, MVal} = cptMissRatio(MissRatio, HitRatio), %%计算未命中率
%% 	case UpDown of		
%% 		up ->
%% 			RatioList = [{missR, MVal}, {ddgeR, DdgeRatio}];
%% 		down ->
%% 			if MVal >= DdgeRatio ->
%% 				   RatioList = [];
%% 			   true ->
%% 				   RatioList = [{ddgeR, DdgeRatio - MVal}]
%% 			end
%% 	end,
%% 	AllRatioList = RatioList ++ [{blckR, BlckRatio}, {critR, CritRatio}, {nomalR, 10000}],
%% 	Fun = fun({RKey, RNum}, [First, BStop, ListLen, ReListLen, ReKey, ReVal, ReaAllVal]) ->  %%筛选出前面概率和大于等于100的属性列表
%% 				  End = First + RNum,
%% 				  ListLenNew = ListLen + 1,
%% 				  if End >= 10000 andalso BStop =:= 0 ->
%% 						 [End, 1, ListLenNew, ListLenNew, RKey, RNum, End];
%% 					 true ->
%% 						 [End, BStop, ListLenNew, ReListLen, ReKey, ReVal, ReaAllVal]
%% 				  end
%% 		  end,
%% 	[_F, _B, _L, ReListLen1, ReKey1, ReVal1, ReaAllVal1] = lists:foldl(Fun, [0, 0, 0, 0, {}, 0, 0], AllRatioList),
%% 	NewAllRatioList = lists:sublist(AllRatioList, ReListLen1),
%% 	CVal = ReaAllVal1 - 10000,
%% 	NewRVal = ReVal1 - CVal,
%% 	NewAllRatioList1 = NewAllRatioList --[{ReKey1, ReVal1}],
%% 	NewAllRatioList2 = NewAllRatioList1 ++ [{ReKey1, NewRVal}],	
%% 	Ratio = util:rand(1, 10000),
%% 	Fun1 = fun({RKey, RVal}, [First1, Rt, RandKey]) ->
%% 				   End1 = First1 + RVal,
%% 				   if Rt > First1 andalso  Rt =< End1 ->
%% 						  [End1, Rt, RKey];
%% 					  true ->
%% 						  [End1, Rt, RandKey]
%% 				   end
%% 		   end,
%% 	[_T1, _T2, ReRandKey] = lists:foldl(Fun1, [0, Ratio, {}], NewAllRatioList2),
%% %% 	io:format("~s ranWarRatio___[~p][~p][~p]\n",[misc:time_format(now()),Ratio, NewAllRatioList2, ReRandKey]),
%% 	ReRandKey.  %%critR等标识原子，{}为没有
%% 
%% %%通过概率计算未命中、闪避、格挡、暴击、碾压、正常攻击的发生情况----------(旧代码)--------------------------------------------------------------
%% %%MissRatio-攻击方未命中率
%% %%HitRatio - 攻击方命中率
%% %%DdgeRatio - 受攻击方闪避率
%% %%BlckRatio - 受攻击方格挡率
%% %%CritRatio - 攻击方暴击率
%% %%RollRatio - 攻击方碾压率
%% %%返回状态的标识原子（如：blckR/critR/rollR等）
%% ranWarRatio_old(MissRatio, HitRatio, DdgeRatio, BlckRatio, CritRatio, RollRatio) ->
%% 	{UpDown, MVal} = cptMissRatio(MissRatio, HitRatio), %%计算未命中率
%% 	case UpDown of		
%% 		up ->
%% 			RatioList = [{missR, MVal}, {ddgeR, DdgeRatio}];
%% 		down ->
%% 			if MVal >= DdgeRatio ->
%% 				   RatioList = [];
%% 			   true ->
%% 				   RatioList = [{ddgeR, DdgeRatio - MVal}]
%% 			end
%% 	end,
%% 	AllRatioList = RatioList ++ [{blckR, BlckRatio}, {critR, CritRatio}, {rollR, RollRatio}, {nomalR, 10000}],
%% 	Fun = fun({RKey, RNum}, [First, BStop, ListLen, ReListLen, ReKey, ReVal, ReaAllVal]) ->  %%筛选出前面概率和大于等于100的属性列表
%% 				  End = First + RNum,
%% 				  ListLenNew = ListLen + 1,
%% 				  if End >= 10000 andalso BStop =:= 0 ->
%% 						 [End, 1, ListLenNew, ListLenNew, RKey, RNum, End];
%% 					 true ->
%% 						 [End, BStop, ListLenNew, ReListLen, ReKey, ReVal, ReaAllVal]
%% 				  end
%% 		  end,
%% 	[_F, _B, _L, ReListLen1, ReKey1, ReVal1, ReaAllVal1] = lists:foldl(Fun, [0, 0, 0, 0, {}, 0, 0], AllRatioList),
%% 	NewAllRatioList = lists:sublist(AllRatioList, ReListLen1),
%% 	CVal = ReaAllVal1 - 10000,
%% 	NewRVal = ReVal1 - CVal,
%% 	NewAllRatioList1 = NewAllRatioList --[{ReKey1, ReVal1}],
%% 	NewAllRatioList2 = NewAllRatioList1 ++ [{ReKey1, NewRVal}],	
%% 	Ratio = util:rand(1, 10000),
%% 	Fun1 = fun({RKey, RVal}, [First1, Rt, RandKey]) ->
%% 				   End1 = First1 + RVal,
%% 				   if Rt > First1 andalso  Rt =< End1 ->
%% 						  [End1, Rt, RKey];
%% 					  true ->
%% 						  [End1, Rt, RandKey]
%% 				   end
%% 		   end,
%% 	[_T1, _T2, ReRandKey] = lists:foldl(Fun1, [0, Ratio, {}], NewAllRatioList2),
%% %% 	io:format("~s ranWarRatio___[~p][~p][~p]\n",[misc:time_format(now()),Ratio, NewAllRatioList2, ReRandKey]),
%% 	ReRandKey.  %%critR等标识原子，{}为没有
%% 
%% %%获取人物触发连携后的宠物坐标列表[Pst,...]
%% getRelaPetList(Direct, Left_List, Right_List) ->
%% 	case Direct of
%% 		left ->
%% 			[Pst||{_Id, Type, _Dr, Pst, _Psttp} <- Left_List, Type =:= 2];
%% 		_ ->
%% 			[Pst||{_Id, Type, _Dr, Pst, _Psttp} <- Right_List, Type =:= 2]
%% 	end.
%% 
%% %%计算是否发生连携
%% %%ActMember是攻击主角#member记录
%% %%ActBattle_record 攻击主角方的战斗记录
%% %%返回连携成功{ok,宠物所在位置pst}，失败noway
%% ranRelaRatio(Direct, BattleSta) ->
%% 	case BattleSta#battleSta.bRelaActing of
%% 		true ->
%% 			true;
%% 		_ ->
%% 			case Direct of
%% 				left ->
%% 					MaxRela = BattleSta#battleSta.leftAllRela;
%% 				_ ->
%% 					MaxRela = BattleSta#battleSta.rightAllRela
%% 			end,
%% 			Ratio = util:rand(1, 10000),
%% 			if Ratio =< MaxRela ->
%% 				   true;
%% 			   true ->
%% 				   false
%% 			end
%% 	end.
%% 
%% %%获取连携攻击必出连携的宠物ID（连携率最高的宠物ID）
%% getRelaMustPetId(Battle_Record) ->
%% 	Members = Battle_Record#battle_record.members,
%% 	Fun = fun({_Id1, Rela1}, {_Id2, Rela2}) ->
%% 				  Rela1 > Rela2
%% 		  end,
%% 	PetRelaList = lists:sort(Fun, [{M#member.id, data_battle:cptRelaRatio(M#member.rela)} || M <- Members, M#member.hp > 0 andalso M#member.mtype =:= 2]),
%% 	case PetRelaList of
%% 		[] ->
%% 			0;
%% 		_ ->
%% 			[{MaxPetId, _RelaR}|_] = PetRelaList,
%% 			MaxPetId
%% 	end.
%% 
%% %%检测副本战斗是否必出连携
%% chkRelaActing(DungId) ->
%% 	case DungId of
%% 		10103 ->
%% 			true;
%% 		_ ->
%% 			false
%% 	end.
%% 
%% %% 	PetMemberListOld = ActBattle_record#battle_record.members,
%% %% 	PetMemberListT = PetMemberListOld -- [ActMember],
%% %% 	PetMemberList = [M1||M1 <- PetMemberListT, M1#member.hp > 0],  %%过滤死亡宠物
%% %% 	case PetMemberList of
%% %% 		[] ->
%% %% 			noway;
%% %% 		_ ->
%% %% 			RelaList = [{M#member.psttp, M#member.rela}||M <- PetMemberList],
%% %% 			NewRelaList = lists:keysort(2, RelaList),	
%% %% 			{Psttp, MaxRela} = lists:last(NewRelaList),
%% %% 			Ratio = util:rand(1, 10000),
%% %% 			if Ratio > 0 andalso Ratio =< MaxRela ->
%% %% 				   {Direct, Psttp};
%% %% 			   true ->
%% %% 				   noway
%% %% 			end
%% %% 	end.
%% 
%% 	
%% %%计算反击概率，
%% %%CterNum - 角色的反击属性
%% %%百分比*10000后的整数（反击概率）
%% cptCterRatio(CterNum) ->
%% 	(CterNum rem 100)*100.
%% 
%% 
%% %%计算未命中率-----------------------------------------------------------------------------------------------------------------
%% %%ActRoleCrr - 攻击方职业
%% %%HitRatio - 攻击方命中率，由cptHitRatio计算所得的命中率，值为百分比*10000后的整数
%% %%返回剩余的未命中率或命中率,值为百分比*10000后的整数
%% cptMissRatio(MissRatio, HitRatio) ->
%% %% 	BaseMiss1 = data_battle:getCrrMiss(ActRoleCrr),
%% 	BaseMiss = MissRatio,
%% 	if BaseMiss > HitRatio ->   %%未命中率大于等于命中率，返回未命中率
%% 		   MissRatio1 = BaseMiss - HitRatio,
%% 		   {up, MissRatio1};
%% 	   true ->
%% 		   MissRatio1 = HitRatio - BaseMiss,  %%%%命中率大于未命中率，返回剩余的命中率
%% 		   {down, MissRatio1}
%% 	end.
%% 
%% %%计算韧性率 ： 公式暂定
%% cptDcritRatio(Crr, DCritNum) ->
%% 	TrueNum = DCritNum div 100,
%% 	TrueRatio = (DCritNum rem 100) *100,
%% 	TrueRatioAdd = data_battle:get_rate(Crr, dcrit, TrueNum),
%% 	round(TrueRatio + TrueRatioAdd).
%% 
%% %%计算穿刺率： 公式暂定
%% cptDblckRatio(Crr, DBlckNum) ->
%% 	TrueNum = DBlckNum div 100,
%% 	TrueRatio = (DBlckNum rem 100) *100,
%% 	TrueRatioAdd = data_battle:get_rate(Crr, dblck, TrueNum),
%% 	round(TrueRatio + TrueRatioAdd).
%% 
%% %%计算命中率
%% %%HitNum - 攻击者的命中属性
%% %%返回是百分比*10000后的整数（命中率）
%% cptHitRatio(Crr, HitNum) ->
%% 	TrueHitNum = HitNum div 100,
%% 	TrueHitRatio = (HitNum rem 100)*100,
%% 	TrueHitRatioAdd = data_battle:get_rate(Crr, hit, TrueHitNum),
%% 	round(TrueHitRatio + TrueHitRatioAdd).
%% 
%% %%计算闪避率
%% %%DdgeNum - 受攻击者的闪避属性
%% %%返回是百分比*10000后的整数（闪避率）
%% cptDdgeRatio(Crr, DdgeNum) ->
%% 	TrueDdgeNum = DdgeNum div 100,
%% 	TrueDdgeRatio = (DdgeNum rem 100) *100,
%% 	TrueDdgeRatioAdd = data_battle:get_rate(Crr, ddge, TrueDdgeNum),
%% 	round(TrueDdgeRatio + TrueDdgeRatioAdd).
%% 
%% 	
%% %%计算暴击率
%% %%CritNum - 攻击者的暴击属性
%% %%返回是百分比*10000后的整数（暴击率）
%% cptCritRatio(Crr, CritNum) ->
%% 	TrueCritNum = CritNum div 100,
%% 	TrueCritRatio = (CritNum rem 100) * 100,
%% 	TrueCritRatioAdd = data_battle:get_rate(Crr, crit, TrueCritNum),
%% 	round(TrueCritRatio + TrueCritRatioAdd).
%% 
%% %%计算格挡率
%% %%BlckNum - 受攻击者的格挡属性
%% %%返回是百分比*10000后的整数（格挡率）
%% cptBlckRatio(Crr, BlckNum) ->
%% 	TrueBlckNum = BlckNum div 100,
%% 	TrueBlckRatio = (BlckNum rem 100) * 100,
%% 	TrueBlckRatioAdd = data_battle:get_rate(Crr, blck, TrueBlckNum),
%% 	round(TrueBlckRatio + TrueBlckRatioAdd).
%% 
%% 
%% %%计算碾压率
%% %%ActMemberLv - 攻击者成员等级
%% %%DefMemberLv - 受攻击者成员等级
%% %%返回是百分比*10000后的整数（碾压率）
%% cptRollRatio(ActMemberLv, DefMemberLv) ->	
%% 	if ActMemberLv > DefMemberLv ->
%% 		   RNum = ActMemberLv - DefMemberLv,
%% 		   if RNum >= 5 ->
%% 				  round(RNum*0.08 * 10000 / (RNum +5));
%% 			  true ->
%% 				  0
%% 		   end;
%% 	   true ->
%% 		   0
%% 	end.
%% 
%% %%计算buff对防御力的影响，返回增加或减少的防御力{up,Val}/{down,Val}/{0,0}
%% %%DefMember-受攻击成员记录#member 的buffs字段是buff列表： [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}
%% %%ActRoleType-攻击角色的攻击类型（1-内力攻击，2-绝技攻击，3-法术攻击）
%% 
%% cptDefBuffChg(DefMember, BaseDef, ActRoleType) ->
%% 	BuffList = DefMember#member.buffs,	
%% 	case BuffList of
%% 		[] ->
%% 			{0,0};
%% 		_ ->
%% 			Fun = fun({BuffId, BuffVal, _Num}, {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, AccDownL}) ->
%% 						  BRUp = lists:member(BuffId, BuffRKeyUpL),
%% 						  BVUp = lists:member(BuffId, BuffVKeyUpL),
%% 						  BRDown = lists:member(BuffId, BuffRKeyDownL),
%% 						  BVDown = lists:member(BuffId, BuffVKeyDownL),
%% 						  if 
%% 							  BRUp =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, [round(BaseDef * BuffVal /100)|AccUpL], AccDownL};
%% 							  BVUp =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, [BuffVal|AccUpL], AccDownL};
%% 							  BRDown =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, [round(BaseDef * BuffVal /100)|AccDownL]};
%% 							  BVDown =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, [BuffVal|AccDownL]};
%% 							  true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, AccDownL}
%% 						  end
%% 				  end,
%% 			case ActRoleType of
%% 				1 ->  %%内力攻击
%% 					{_RUpKeyL, _VUpKeyL, _RDownKeyL, _VDownKeyL, UseBuffListUp, UseBuffListDown} = lists:foldl(Fun, {[12, 86], [10, 85], [16, 88], [14, 87], [], []}, BuffList),
%% 					{_RUpKeyL1, _VUpKeyL1, _RDownKeyL1, _VDownKeyL1, _UseBuffListUp1, UseBuffListWeakDown} = lists:foldl(Fun, {[], [], [71], [70], [], []}, BuffList),
%% 					case UseBuffListUp of
%% 						[] ->
%% 							DefUpV = 0;
%% 						_ ->
%% 							DefUpV = lists:max(UseBuffListUp)
%% 					end,
%% 					case UseBuffListDown of
%% 						[] ->
%% 							DefDownV = 0;
%% 						_ ->
%% 							DefDownV = lists:max(UseBuffListDown)
%% 					end,
%% 					case UseBuffListWeakDown of
%% 						[] ->
%% 							DefDownWeakV = 0;
%% 						_ ->
%% 							DefDownWeakV = lists:max(UseBuffListWeakDown)
%% 					end,
%% 					AllDefDownV = DefDownV + DefDownWeakV,
%% 					if DefUpV > AllDefDownV ->
%% 						   {up, DefUpV - AllDefDownV};
%% 					   true ->
%% 						   {down, AllDefDownV - DefUpV}
%% 					end;
%% 				2 ->  %%绝技攻击
%% 					{_RUpKeyL, _VUpKeyL, _RDownKeyL, _VDownKeyL, UseBuffListUp, UseBuffListDown} = lists:foldl(Fun, {[13], [11], [17], [15], [], []}, BuffList),
%% 					{_RUpKeyL1, _VUpKeyL1, _RDownKeyL1, _VDownKeyL1, _UseBuffListUp1, UseBuffListWeakDown} = lists:foldl(Fun, {[], [], [71], [70], [], []}, BuffList),
%% 					case UseBuffListUp of
%% 						[] ->
%% 							DefUpV = 0;
%% 						_ ->
%% 							DefUpV = lists:max(UseBuffListUp)
%% 					end,
%% 					case UseBuffListDown of
%% 						[] ->
%% 							DefDownV = 0;
%% 						_ ->
%% 							DefDownV = lists:max(UseBuffListDown)
%% 					end,
%% 			
%% 					case UseBuffListWeakDown of
%% 						[] ->
%% 							DefDownWeakV = 0;
%% 						_ ->
%% 							DefDownWeakV = lists:max(UseBuffListWeakDown)
%% 					end,
%% 					AllDefDownV = DefDownV + DefDownWeakV,
%% 					if DefUpV > AllDefDownV ->
%% 						   {up, DefUpV - AllDefDownV};
%% 					   true ->
%% 						   {down, AllDefDownV - DefUpV}
%% 					end;
%% 				3 ->
%% 					{_RUpKeyL, _VUpKeyL, _RDownKeyL, _VDownKeyL, UseBuffListUp, UseBuffListDown} = lists:foldl(Fun, {[12, 90], [10, 89], [16, 92], [14, 91], [], []}, BuffList),
%% 					{_RUpKeyL1, _VUpKeyL1, _RDownKeyL1, _VDownKeyL1, _UseBuffListUp1, UseBuffListWeakDown} = lists:foldl(Fun, {[], [], [71], [70], [], []}, BuffList),
%% 					case UseBuffListUp of
%% 						[] ->
%% 							DefUpV = 0;
%% 						_ ->
%% 							DefUpV = lists:max(UseBuffListUp)
%% 					end,
%% 					case UseBuffListDown of
%% 						[] ->
%% 							DefDownV = 0;
%% 						_ ->
%% 							DefDownV = lists:max(UseBuffListDown)
%% 					end,
%% 					case UseBuffListWeakDown of
%% 						[] ->
%% 							DefDownWeakV = 0;
%% 						_ ->
%% 							DefDownWeakV = lists:max(UseBuffListWeakDown)
%% 					end,
%% 					AllDefDownV = DefDownV + DefDownWeakV,
%% 					if DefUpV > AllDefDownV ->
%% 						   {up, DefUpV - AllDefDownV};
%% 					   true ->
%% 						   {down, AllDefDownV - DefUpV}
%% 					end;
%% 				_ ->
%% 					{0,0}
%% 			end
%% 	end.
%% 
%% 
%% %%检测被动技”复仇“，并修改数值, Pst为死亡角色，PasList为被动技状态列表（提供前端显示）
%% chkPasSkillRev(Pst, BattleRecord, PasList) ->
%% 	Members = BattleRecord#battle_record.members,
%% 	EffMembers = [M||M<-Members, M#member.hp > 0 andalso M#member.pst =/= Pst],
%% 	Fun = fun(M1, OldPasList) ->
%% 				  PasSkill = getSkill(M1#member.pasid),
%% 				  case PasSkill#ets_skill.imef of
%% 					  52 ->  %%复仇
%% 						  [{Num, MaxNum}] = PasSkill#ets_skill.other_data,
%% %% 						  io:format("~s chkPasSkillRev__1__[~p]~n",[misc:time_format(now()), M1#member.pst]),
%% 						  OldPasbuf = M1#member.pasbuf,
%% 						  case [{Id, RNum}||{Id, RNum}<-OldPasbuf, Id =:= 52] of
%% 							  [] ->
%% 								  NewPasbuf = OldPasbuf ++ [{52, Num}],
%% %% 								  NewPasList = OldPasList ++ [{M1#member.pst, 52, 1, 0}];
%% 								  PasLv = 1,
%% 								  NewPasList = [#rolePasinfo{
%% 					  						 				pst = M1#member.pst,     
%% 					  						 				imef = 52,    
%% 					  						 				flag = 1,    
%% 					  						 				other_data = PasLv   
%% 					  						 				}|OldPasList];
%% 							  [{_Id1, RNum1}|_] ->
%% 								  if RNum1 >= MaxNum ->
%% 										 NewPasbuf = OldPasbuf,
%% 										 NewPasList = OldPasList;
%% 									 true ->
%% 										 NewRNum1 = RNum1 + Num,
%% 										 if NewRNum1 >= MaxNum ->
%% 												GetNum = MaxNum;
%% %% 												NewPasbuf = lists:keyreplace(52, 1, OldPasbuf, {52, MaxNum});
%% %% 												NewPasList = OldPasList ++ [{M1#member.pst, 52, 1, 0}];
%% 											true ->
%% 												GetNum = NewRNum1
%% %% 												NewPasbuf = lists:keyreplace(52, 1, OldPasbuf, {52, NewRNum1})
%% %% 												NewPasList = OldPasList ++ [{M1#member.pst, 52, 1, 0}]
%% 										 end,
%% 										 NewPasbuf = lists:keyreplace(52, 1, OldPasbuf, {52, GetNum}),
%% 										 PasLv = util:ceil(GetNum/Num),
%% 										 NewPasList = [#rolePasinfo{
%% 					  						 						pst = M1#member.pst,     
%% 					  						 						imef = 52,    
%% 					  						 						flag = 1,    
%% 					  						 						other_data = PasLv   
%% 					  						 						}|OldPasList]
%% 								  end
%% 						  end,
%% %% 						  io:format("~s chkPasSkillRev__2__[~p]~n",[misc:time_format(now()), NewPasbuf]),
%% 						  {M1#member{pasbuf = NewPasbuf}, NewPasList};
%% 					  _ ->
%% 						  {M1, OldPasList}
%% 				  end
%% 		  end,
%% 	{NewEffMembers, ResPasList} = lists:mapfoldl(Fun, PasList, EffMembers),
%% 	Fun1 = fun(M2, OldMembers) ->
%% 				   lists:keyreplace(M2#member.pst, #member.pst, OldMembers, M2)
%% 		   end,
%% 	NewMembers = lists:foldl(Fun1, Members, NewEffMembers),
%% 	{BattleRecord#battle_record{members = NewMembers}, ResPasList}.
%% 				  
%% %%角色死亡后检测”复生“和”垂死“被动技，并修改数值, PasList为被动技状态列表（提供前端显示）
%% chkPasSkillRelive(DefMember, PasList) ->
%% 	case DefMember#member.pascan of
%% 		1 ->
%% 			PasSkill = getSkill(DefMember#member.pasid),
%% 			case PasSkill#ets_skill.imef of
%% 				51 ->      %%复生(需要清空buff和被动技BUFF)
%% 					NewDefMember = DefMember#member{pascan = 0,
%% 													buffs = [],
%% 													pasbuf = []},
%% %% 					NewPasList = PasList ++ [{NewDefMember#member.pst, 51, 1, 0}],
%% 					NewPasList = [#rolePasinfo{
%% 					  						    pst = NewDefMember#member.pst,     
%% 					  						 	imef = 51,    
%% 					  						 	flag = 1,    
%% 					  						 	other_data = 0   
%% 					  						 	}|PasList],
%% 					[RNum] = PasSkill#ets_skill.other_data,
%% 					{round(NewDefMember#member.mxhp * RNum /100), 1, NewDefMember, NewPasList};
%% 				54 ->      %%垂死
%% 					NewDefMember = DefMember#member{pascan = 0},
%% %% 					NewPasList = PasList ++ [{NewDefMember#member.pst, 54, 1, 0}],
%% 					NewPasList = [#rolePasinfo{
%% 					  						    pst = NewDefMember#member.pst,     
%% 					  						 	imef = 54,    
%% 					  						 	flag = 1,    
%% 					  						 	other_data = 0   
%% 					  						 	}|PasList],
%% 					{2, 1, NewDefMember, NewPasList};
%% 				_ ->
%% 					{0, 0, DefMember, PasList}
%% 			end;
%% 		_ ->
%% 			{0, 0, DefMember, PasList}
%% 	end.
%% 					  
%% %%角色死亡后检测”神灵保佑“被动技，并修改数值, PasList为被动技状态列表（提供前端显示）
%% chkPasSkillReHp(DefMember, PasList, Hurt) ->
%% 	case DefMember#member.pascan of
%% 		1 ->
%% 			PasSkill = getSkill(DefMember#member.pasid),
%% 			case PasSkill#ets_skill.imef of
%% 				56 ->      %%神灵保佑
%% 					[{RandRat, RNum}] = PasSkill#ets_skill.other_data,
%% 					RandNum = util:rand(1, 10000),
%% 					if RandNum =< RandRat * 100 ->
%% 						   ReHurt = round(Hurt * RNum /100),
%% %% 						   NewPasList = PasList ++ [{DefMember#member.pst, 56, 1, ReHurt}],
%% 						   NewPasList = [#rolePasinfo{
%% 					  						    		pst = DefMember#member.pst,     
%% 					  						 			imef = 56,    
%% 					  						 			flag = 1,    
%% 					  						 			other_data = ReHurt   
%% 					  						 			}|PasList],
%% 						   {ReHurt, NewPasList};
%% 					   true ->
%% 						   {0, PasList}
%% 					end;
%% 				_ ->
%% 					{0, PasList}
%% 			end;
%% 		_ ->
%% 			{0, PasList}
%% 	end.
%% 
%% %%角色检测”铜墙铁壁“被动技，并修改数值, PasList为被动技状态列表（提供前端显示）
%% chkPasActDef(DefMember, PasList) ->
%% 	case DefMember#member.pascan of
%% 		1 ->
%% 			PasSkill = getSkill(DefMember#member.pasid),
%% 			case PasSkill#ets_skill.imef of
%% 				53 ->      %%铜墙铁壁
%% 					[{RandRat, Num, MaxNum}] = PasSkill#ets_skill.other_data,
%% 					RandNum = util:rand(1, 10000),
%% 					if RandNum =< RandRat * 100 ->
%% 						   OldPasbuf = DefMember#member.pasbuf,
%% 						   case [{Id, RNum}||{Id, RNum}<-OldPasbuf, Id =:= 53] of
%% 							   [] ->
%% 								   NewPasbuf = OldPasbuf ++ [{53, Num}],
%% %% 								   NewPasList = PasList ++ [{DefMember#member.pst, 53, 1, 0}];
%% 								   PasLv = 1,
%% 								   NewPasList = [#rolePasinfo{
%% 					  						    				pst = DefMember#member.pst,     
%% 					  						 					imef = 53,    
%% 					  						 					flag = 1,    
%% 					  						 					other_data = PasLv   
%% 					  						 					}|PasList];
%% 							   [{_Id1, RNum1}|_] ->
%% 								   if RNum1 >= MaxNum ->
%% 										  NewPasbuf = OldPasbuf,
%% 										  NewPasList = PasList;
%% 									  true ->
%% 										  NewRNum1 = RNum1 + Num,
%% 										  if NewRNum1 >= MaxNum ->
%% 												 GetNum = MaxNum;
%% %% 												 NewPasbuf = lists:keyreplace(53, 1, OldPasbuf, {53, MaxNum}),
%% %% %% 												 NewPasList = PasList ++ [{DefMember#member.pst, 53, 1, 0}];
%% %% 												 NewPasList = [#rolePasinfo{
%% %% 					  						    							pst = DefMember#member.pst,     
%% %% 					  						 								imef = 53,    
%% %% 					  						 								flag = 1,    
%% %% 					  						 								other_data = 0   
%% %% 					  						 								}|PasList];
%% 											 true ->
%% 												 GetNum = NewRNum1
%% %% 												 NewPasbuf = lists:keyreplace(53, 1, OldPasbuf, {53, NewRNum1}),
%% %% %% 												 NewPasList = PasList ++ [{DefMember#member.pst, 53, 1, 0}]
%% %% 												 NewPasList = [#rolePasinfo{
%% %% 					  						    							pst = DefMember#member.pst,     
%% %% 					  						 								imef = 53,    
%% %% 					  						 								flag = 1,    
%% %% 					  						 								other_data = 0   
%% %% 					  						 								}|PasList]
%% 										  end,
%% 										  NewPasbuf = lists:keyreplace(53, 1, OldPasbuf, {53, GetNum}),
%% 										  PasLv = util:ceil(GetNum/Num),
%% 										  NewPasList = [#rolePasinfo{
%% 					  						    					 pst = DefMember#member.pst,     
%% 					  						 						 imef = 53,    
%% 					  						 						 flag = 1,    
%% 					  						 						 other_data = PasLv   
%% 					  						 						 }|PasList]
%% 								   end
%% 						   end,
%% 						   {DefMember#member{pasbuf = NewPasbuf}, NewPasList};
%% 					   true ->
%% 						   {DefMember, PasList}
%% 					end;
%% 				_ ->
%% 					{DefMember, PasList}
%% 			end;
%% 		_ ->
%% 			{DefMember, PasList}
%% 	end.
%% 
%% %%角色检测”霸体“被动技，并修改数值, PasList为被动技状态列表（提供前端显示）
%% chkPasNoHurt(DefMember, PasList) ->
%% 	case DefMember#member.pascan of
%% 		1 ->
%% 			PasSkill = getSkill(DefMember#member.pasid),
%% 			case PasSkill#ets_skill.imef of
%% 				55 ->      %%霸体
%% 					[{RandRat, Num, MaxNum}] = PasSkill#ets_skill.other_data,
%% 					RandNum = util:rand(1, 10000),
%% 					if RandNum =< RandRat * 100 ->
%% 						   OldPasbuf = DefMember#member.pasbuf,
%% 						   case [{Id, RNum}||{Id, RNum}<-OldPasbuf, Id =:= 55] of
%% 							   [] ->
%% 								   NewPasbuf = OldPasbuf ++ [{55, Num}],
%% %% 								   NewPasList = PasList ++ [{DefMember#member.pst, 55, 1, 0}];
%% 								   PasLv = 1,
%% 								   NewPasList = [#rolePasinfo{
%% 					  						    				pst = DefMember#member.pst,     
%% 					  						 					imef = 55,    
%% 					  						 					flag = 1,    
%% 					  						 					other_data = PasLv   
%% 					  						 					}|PasList];
%% 							   [{_Id1, RNum1}|_] ->
%% 								   if RNum1 >= MaxNum ->
%% 										  NewPasbuf = OldPasbuf,
%% 										  NewPasList = PasList;
%% 									  true ->
%% 										  NewRNum1 = RNum1 + Num,
%% 										  if NewRNum1 >= MaxNum ->
%% 												 GetNum = MaxNum;
%% %% 												 NewPasbuf = lists:keyreplace(55, 1, OldPasbuf, {55, MaxNum});
%% %% 												 NewPasList = PasList ++ [{DefMember#member.pst, 55, 1, 0}];
%% 											 true ->
%% 												 GetNum = NewRNum1
%% %% 												 NewPasbuf = lists:keyreplace(55, 1, OldPasbuf, {55, NewRNum1})
%% %% 												 NewPasList = PasList ++ [{DefMember#member.pst, 55, 1, 0}]
%% 										  end,
%% 										  NewPasbuf = lists:keyreplace(55, 1, OldPasbuf, {55, GetNum}),
%% 										  PasLv = util:ceil(GetNum/Num),
%% %% 										  io:format(" =======chkPasNoHurt=====[~p]~n",[PasLv]),
%% 										  NewPasList = [#rolePasinfo{
%% 					  						    				pst = DefMember#member.pst,     
%% 					  						 					imef = 55,    
%% 					  						 					flag = 1,    
%% 					  						 					other_data = PasLv   
%% 					  						 					}|PasList]
%% 								   end
%% 						   end,
%% 						   {DefMember#member{pasbuf = NewPasbuf}, NewPasList};
%% 					   true ->
%% 						   {DefMember, PasList}
%% 					end;
%% 				_ ->
%% 					{DefMember, PasList}
%% 			end;
%% 		_ ->
%% 			{DefMember, PasList}
%% 	end.
%% 
%% %%计算被动技BUFF对防御力的增加， 被动技BUFF数据格式：[{被动技能即时效果ID, 增加百分比总和}]
%% cptDefPasBufChg(DefMember, BaseDef) ->
%% 	PasBuff = DefMember#member.pasbuf,
%% 	case [{Id, RNum} || {Id, RNum} <- PasBuff, Id =:= 53] of
%% 		[{_Id1, RNum1}|_] ->
%% 			round(BaseDef * RNum1 /100);
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%计算被动技BUFF对伤害的减少， 被动技BUFF数据格式：[{被动技能即时效果ID, 增加百分比总和}]
%% cptNoHurtPasBufChg(DefMember, HurtVal) ->
%% 	PasBuff = DefMember#member.pasbuf,
%% 	case [{Id, RNum} || {Id, RNum} <- PasBuff, Id =:= 55] of
%% 		[{_Id1, RNum1}|_] ->
%% 			round(HurtVal * RNum1 /100);
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%计算被动技BUFF对攻击力的增加， 被动技BUFF数据格式：[{被动技能即时效果ID, 增加百分比总和}]
%% cptActPasBufChg(ActMember, BaseAct) ->
%% 	PasBuff = ActMember#member.pasbuf,
%% 	case [{Id, RNum} || {Id, RNum} <- PasBuff, Id =:= 52] of
%% 		[{_Id1, RNum1}|_] ->
%% 			round(BaseAct * RNum1 /100);
%% 		_ ->
%% 			0
%% 	end.
%% 	
%% 
%% %%计算buff对攻击力的影响，返回增加或减少的攻击力(注：技法攻击力是不是技法伤害的攻击力){up,Val}/{down, Val}
%% %%ActMember-攻击成员记录#member 的buffs字段是buff列表： [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}
%% %%ActRoleType-攻击角色的攻击类型（1-内力攻击，2-绝技攻击，3-法术攻击）
%% cptActBuffChg(ActMember, BaseAct, ActRoleType) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			{0,0};
%% 		_ ->			
%% 			Fun = fun({BuffId, BuffVal, _Num}, {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, AccDownL}) ->
%% 						  BRUp = lists:member(BuffId, BuffRKeyUpL),
%% 						  BVUp = lists:member(BuffId, BuffVKeyUpL),
%% 						  BRDown = lists:member(BuffId, BuffRKeyDownL),
%% 						  BVDown = lists:member(BuffId, BuffVKeyDownL),
%% 						  if 
%% 							  BRUp =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, [round(BaseAct * BuffVal /100)|AccUpL], AccDownL};
%% 							  BVUp =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, [BuffVal|AccUpL], AccDownL};
%% 							  BRDown =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, [round(BaseAct * BuffVal /100)|AccDownL]};
%% 							  BVDown =:= true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, [BuffVal|AccDownL]};
%% 							  true ->
%% 								  {BuffRKeyUpL, BuffVKeyUpL, BuffRKeyDownL, BuffVKeyDownL, AccUpL, AccDownL}
%% 						  end
%% 				  end,
%% 			case ActRoleType of
%% 				1 ->  %%内力攻击
%% 					{_RUpKeyL, _VUpKeyL, _RDownKeyL, _VDownKeyL, UseBuffListUp, UseBuffListDown} = lists:foldl(Fun, {[3, 78], [1, 77], [7, 80], [5, 79], [], []}, BuffList),
%% 					{_RUpKeyL1, _VUpKeyL1, _RDownKeyL1, _VDownKeyL1, _UseBuffListUp1, UseBuffListWeakDown} = lists:foldl(Fun, {[], [], [71], [70], [], []}, BuffList),
%% %% 					UseBuffListUpR = [round(BaseAct * BuffUpVal /100)||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 3],   %%攻击力增益BUFF
%% %% 					UseBuffListUpV = [BuffUpVal1||{BuffUpId1, BuffUpVal1, _UpNum1} <- BuffList, BuffUpId1 =:= 1],
%% %% 					UseBuffListUp = UseBuffListUpR ++ UseBuffListUpV,
%% 					case UseBuffListUp of
%% 						[] ->
%% 							ActUpV = 0;
%% 						_ ->
%% 							ActUpV = lists:max(UseBuffListUp)
%% 					end,
%% %% 					UseBuffListDownR = [round(BaseAct * BuffDownVal /100)||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 7], %%减攻击力百分比BUFF
%% %% 					UseBuffListDownV = [BuffDownVal1||{BuffDownId1, BuffDownVal1, _DownNum1} <- BuffList, BuffDownId1 =:= 5],                                %%减攻击力绝对值BUFF
%% %% 					UseBuffListDownWeakR = [round(BaseAct * BuffDownWeakVal /100)||{BuffDownWeakId, BuffDownWeakVal, _DownWeakNum} <- BuffList, BuffDownWeakId =:= 71], %%衰弱减攻击力百分比BUFF
%% %% 					UseBuffListDownWeakV = [BuffDownWeakVal1||{BuffDownWeakId1, BuffDownWeakVal1, _DownWeakNum1} <- BuffList, BuffDownWeakId1 =:= 70],                                %%衰弱减攻击力绝对值BUFF
%% %% 					UseBuffListDown = UseBuffListDownR ++ UseBuffListDownV,	
%% %% 					UseBuffListWeakDown = UseBuffListDownWeakR ++ UseBuffListDownWeakV,
%% 					case UseBuffListDown of
%% 						[] ->
%% 							ActDownV = 0;
%% 						_ ->
%% 							ActDownV = lists:max(UseBuffListDown)
%% 					end,
%% 			
%% 					case UseBuffListWeakDown of
%% 						[] ->
%% 							ActDownWeakV = 0;
%% 						_ ->
%% 							ActDownWeakV = lists:max(UseBuffListWeakDown)
%% 					end,
%% 					AllActDownV = ActDownV + ActDownWeakV,
%% 					if ActUpV > AllActDownV ->
%% 						   {up, ActUpV - AllActDownV};
%% 					   true ->
%% 						   {down, AllActDownV - ActUpV}
%% 					end;
%% 				2 ->  %%绝技攻击
%% 
%% 					{_RUpKeyL, _VUpKeyL, _RDownKeyL, _VDownKeyL, UseBuffListUp, UseBuffListDown} = lists:foldl(Fun, {[4], [2], [8], [6], [], []}, BuffList),
%% 					{_RUpKeyL1, _VUpKeyL1, _RDownKeyL1, _VDownKeyL1, _UseBuffListUp1, UseBuffListWeakDown} = lists:foldl(Fun, {[], [], [71], [70], [], []}, BuffList),
%% %% 					UseBuffListUpR = [round(BaseAct * BuffUpVal /100)||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 4],   %%攻击力增益BUFF
%% %% 					UseBuffListUpV = [BuffUpVal1||{BuffUpId1, BuffUpVal1, _UpNum1} <- BuffList, BuffUpId1 =:= 2],
%% %% 					UseBuffListUp = UseBuffListUpR ++ UseBuffListUpV,
%% 					case UseBuffListUp of
%% 						[] ->
%% 							ActUpV = 0;
%% 						_ ->
%% 							ActUpV = lists:max(UseBuffListUp)
%% 					end,
%% %% 					UseBuffListDownR = [round(BaseAct * BuffDownVal /100)||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 8], %%攻击力减益BUFF
%% %% 					UseBuffListDownV = [BuffDownVal1||{BuffDownId1, BuffDownVal1, _DownNum1} <- BuffList, BuffDownId1 =:= 6],
%% %% 					UseBuffListDownWeakR = [round(BaseAct * BuffDownWeakVal /100)||{BuffDownWeakId, BuffDownWeakVal, _DownWeakNum} <- BuffList, BuffDownWeakId =:= 71], %%衰弱减攻击力百分比BUFF
%% %% 					UseBuffListDownWeakV = [BuffDownWeakVal1||{BuffDownWeakId1, BuffDownWeakVal1, _DownWeakNum1} <- BuffList, BuffDownWeakId1 =:= 70],                                %%衰弱减攻击力绝对值BUFF
%% %% 					UseBuffListDown = UseBuffListDownR ++ UseBuffListDownV,	
%% %% 					UseBuffListWeakDown = UseBuffListDownWeakR ++ UseBuffListDownWeakV,			
%% 					case UseBuffListDown of
%% 						[] ->
%% 							ActDownV = 0;
%% 						_ ->
%% 							ActDownV = lists:max(UseBuffListDown)
%% 					end,
%% 					case UseBuffListWeakDown of
%% 						[] ->
%% 							ActDownWeakV = 0;
%% 						_ ->
%% 							ActDownWeakV = lists:max(UseBuffListWeakDown)
%% 					end,
%% 					AllActDownV = ActDownV + ActDownWeakV,
%% 					if ActUpV > AllActDownV ->
%% 						   {up, ActUpV - AllActDownV};
%% 					   true ->
%% 						   {down, AllActDownV - ActUpV}
%% 					end;
%% 				3 ->
%% 					{_RUpKeyL, _VUpKeyL, _RDownKeyL, _VDownKeyL, UseBuffListUp, UseBuffListDown} = lists:foldl(Fun, {[3, 82], [1, 81], [7, 84], [5, 83], [], []}, BuffList),
%% 					{_RUpKeyL1, _VUpKeyL1, _RDownKeyL1, _VDownKeyL1, _UseBuffListUp1, UseBuffListWeakDown} = lists:foldl(Fun, {[], [], [71], [70], [], []}, BuffList),
%% %% 					UseBuffListUpR = [round(BaseAct * BuffUpVal /100)||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 3],   %%攻击力增益BUFF
%% %% 					UseBuffListUpV = [BuffUpVal1||{BuffUpId1, BuffUpVal1, _UpNum1} <- BuffList, BuffUpId1 =:= 1],			
%% %% 					UseBuffListUp = UseBuffListUpR ++ UseBuffListUpV,
%% 					case UseBuffListUp of
%% 						[] ->
%% 							ActUpV = 0;
%% 						_ ->
%% 							ActUpV = lists:max(UseBuffListUp)
%% 					end,
%% %% 					UseBuffListDownR = [round(BaseAct * BuffDownVal /100)||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 7], %%攻击力减益BUFF
%% %% 					UseBuffListDownV = [BuffDownVal1||{BuffDownId1, BuffDownVal1, _DownNum1} <- BuffList, BuffDownId1 =:= 5],
%% %% 					UseBuffListDownWeakR = [round(BaseAct * BuffDownWeakVal /100)||{BuffDownWeakId, BuffDownWeakVal, _DownWeakNum} <- BuffList, BuffDownWeakId =:= 71], %%衰弱减攻击力百分比BUFF
%% %% 					UseBuffListDownWeakV = [BuffDownWeakVal1||{BuffDownWeakId1, BuffDownWeakVal1, _DownWeakNum1} <- BuffList, BuffDownWeakId1 =:= 70],                                %%衰弱减攻击力绝对值BUFF
%% %% 					UseBuffListDown = UseBuffListDownR ++ UseBuffListDownV,	
%% %% 					UseBuffListWeakDown = UseBuffListDownWeakR ++ UseBuffListDownWeakV,	
%% 					case UseBuffListDown of
%% 						[] ->
%% 							ActDownV = 0;
%% 						_ ->
%% 							ActDownV = lists:max(UseBuffListDown)
%% 					end,
%% 			
%% 					case UseBuffListWeakDown of
%% 						[] ->
%% 							ActDownWeakV = 0;
%% 						_ ->
%% 							ActDownWeakV = lists:max(UseBuffListWeakDown)
%% 					end,
%% 					AllActDownV = ActDownV + ActDownWeakV,
%% 					if ActUpV > AllActDownV ->
%% 						   {up, ActUpV - AllActDownV};
%% 					   true ->
%% 						   {down, AllActDownV - ActUpV}
%% 					end;
%% 				_ ->
%% 					{0,0}
%% 			end
%% 	end.
%% 
%% %%计算BUFF对未命中率的影响
%% cptMissBuff(ActMember, MissRat) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			MissRat;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 64],   %%致盲BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = data_battle:get_blind()
%% 			end,
%% 			MissRat + DefUpV * 100
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.		
%% 
%% %%计算BUFF对命中率的影响
%% %%ActMember-攻击成员记录#member 的buffs字段是buff列表： [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}
%% %%返回改变后的命中率 (百分比*10000)
%% cptHitBuff(ActMember) ->	
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			ActMember#member.hit;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 30],   %%命中增益BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			UseBuffListDown = [BuffDownVal||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 31], %%命中减益BUFF	
%% 			case UseBuffListDown of
%% 				[] ->
%% 					DefDownV = 0;
%% 				_ ->
%% 					DefDownV = lists:max(UseBuffListDown)
%% 			end,
%% %% 			UseBuffListBlind = [BuffBlindVal||{BuffBlindId, BuffBlindVal, _BlindNum} <- BuffList, BuffBlindId =:= 64], %%致盲BUFF	
%% %% 			case UseBuffListBlind of      %%致盲BUFF固定减少5%的命中率
%% %% 				[] ->
%% %% 					BlindV = 0;
%% %% 				_ ->
%% %% 					BlindV = 5
%% %% 			end,
%% 			TempVal = ActMember#member.hit + DefUpV * 100,
%% 			TempDownVal = DefDownV * 100,	
%% 			TempVal - TempDownVal
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.
%% 
%% %%计算BUFF对闪避率的影响
%% %%DefMember-受攻击成员记录#member 的buffs字段是buff列表： [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}
%% %%返回改变后的闪避率 (百分比*10000)
%% cptDdgeBuff(DefMember) ->
%% 	BuffList = DefMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			DefMember#member.ddge;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 20],   %%闪避增益BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			UseBuffListDown = [BuffDownVal||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 21], %%闪避减益BUFF	
%% 			case UseBuffListDown of
%% 				[] ->
%% 					DefDownV = 0;
%% 				_ ->
%% 					DefDownV = lists:max(UseBuffListDown)
%% 			end,
%% 			TempVal = DefMember#member.ddge + DefUpV * 100,
%% 			TempDownVal = DefDownV * 100,	
%% 			TempVal - TempDownVal
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.		
%% 
%% 
%% %%计算BUFF对穿透率的影响
%% cptDBlckBuff(ActMember) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			ActMember#member.dblck;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 42],   %%穿透增益BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			UseBuffListDown = [BuffDownVal||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 43], %%穿透减益BUFF	
%% 			case UseBuffListDown of
%% 				[] ->
%% 					DefDownV = 0;
%% 				_ ->
%% 					DefDownV = lists:max(UseBuffListDown)
%% 			end,
%% 			TempVal = ActMember#member.dblck + DefUpV * 100,
%% 			TempDownVal = DefDownV * 100,
%%             TempVal - TempDownVal
%% 
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.
%% 
%% %%计算BUFF对格挡率的影响
%% %%DefMember-受攻击成员记录#member 的buffs字段是buff列表： [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}
%% %%返回改变后的格挡率(百分比*10000)
%% cptBlckBuff(DefMember) ->
%% 	BuffList = DefMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			DefMember#member.blck;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 40],   %%格挡增益BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			UseBuffListDown = [BuffDownVal||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 41], %%格挡减益BUFF	
%% 			case UseBuffListDown of
%% 				[] ->
%% 					DefDownV = 0;
%% 				_ ->
%% 					DefDownV = lists:max(UseBuffListDown)
%% 			end,
%% 			TempVal = DefMember#member.blck + DefUpV * 100,
%% 			TempDownVal = DefDownV * 100,	
%% 			TempVal - TempDownVal
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.	
%% 
%% %%计算BUFF对暴击率的影响(由于有主动技能第二属性的影响，所以结果有负数就必须保留)
%% %%ActMember-攻击成员记录#member 的buffs字段是buff列表： [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}
%% %%返回改变后的暴击率(百分比*10000)
%% cptCritBuff(ActMember) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			ActMember#member.crit;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 50],   %%暴击增益BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			UseBuffListDown = [BuffDownVal||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 51], %%暴击减益BUFF	
%% 			case UseBuffListDown of
%% 				[] ->
%% 					DefDownV = 0;
%% 				_ ->
%% 					DefDownV = lists:max(UseBuffListDown)
%% 			end,
%% 			TempVal = ActMember#member.crit + DefUpV * 100,
%% 			TempDownVal = DefDownV * 100,
%%             TempVal - TempDownVal
%% 
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.
%% 
%% %%计算BUFF对韧性率的影响
%% cptDCritBuff(DefMember) ->
%% 	BuffList = DefMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			DefMember#member.dcrit;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 52],   %%韧性增益BUFF	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			UseBuffListDown = [BuffDownVal||{BuffDownId, BuffDownVal, _DownNum} <- BuffList, BuffDownId =:= 53], %%韧性减益BUFF	
%% 			case UseBuffListDown of
%% 				[] ->
%% 					DefDownV = 0;
%% 				_ ->
%% 					DefDownV = lists:max(UseBuffListDown)
%% 			end,
%% 			TempVal = DefMember#member.dcrit + DefUpV * 100,
%% 			TempDownVal = DefDownV * 100,	
%% 			TempVal - TempDownVal
%% %% 			if TempVal > TempDownVal ->
%% %% 				   TempVal - TempDownVal;
%% %% 			   true ->
%% %% 				   0
%% %% 			end
%% 	end.
%% 
%% %%计算免伤BUFF，返回剩余伤害
%% cptNoHurtBuff(DefMember, Hurt) ->	
%% 	BuffList = DefMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			Hurt;
%% 		_ ->			
%% 			UseBuffListUp = [BuffUpVal||{BuffUpId, BuffUpVal, _UpNum} <- BuffList, BuffUpId =:= 76],   %%免伤BUFF(免伤百分比)	
%% 			case UseBuffListUp of
%% 				[] ->
%% 					DefUpV = 0;
%% 				_ ->
%% 					DefUpV = lists:max(UseBuffListUp)
%% 			end,
%% 			tool:int_format(round(Hurt * (100 - DefUpV) / 100))
%% 	end.
%% 
%% 
%% %%暴击、命中、闪避、格挡、反击的数值转换（将强度和概率进行合并）
%% %%ValType - 数值类型标识原子 (rat:概率，val:强度)
%% %%Val - 具体数值
%% %%返回转换值，以用于属性字段赋值
%% changeArtVal(ValType, Val) ->
%% 	case ValType of
%% 		rat ->
%% 			round(Val);
%% 		val ->
%% 			round(Val * 100);
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%通过技能ID获取技能记录#ets_skill
%% getSkill(Id) ->
%% 	case ets:lookup(?ETS_BASE_SKILL, Id) of
%% 		[] -> #ets_skill{
%% 						 imef = 0,                               %% 技能即时效果类型（0-表示没有及时附加效果）	
%%       					 imvl = 0,                               %% 即时效果数值	
%%       					 immod = 1,                              %% 即时模式: 1敌方单体
%%       					 bftp = 0                                %% 无BUFF攻击
%% 						};
%% 		[D] -> D
%% 	end.
%% 
%% %%计算技能附加的即时攻击力,返回增加值
%% %%ActMember-攻击成员记录#member
%% %%SkillRcd-攻击方技能记录#ets_skill
%% %%返回{内力攻击增加值，技能攻击增加值，法力攻击增加值}
%% cptActTech(_ActMember, SkillRcd, BaseAct) ->
%% 	case SkillRcd of
%% 		RealSkillRcd when is_record(RealSkillRcd, ets_skill) ->
%% 			RealActId = RealSkillRcd#ets_skill.imef,
%% 			AddActData = RealSkillRcd#ets_skill.imvl,
%% 			case RealActId of
%% 				2 ->
%% 					AddActData;
%% 				4 ->
%% 					round(BaseAct * AddActData / 100);
%% 				12 ->
%% 					round(BaseAct * AddActData / 100);
%% 				OtherActId when OtherActId >= 21 , OtherActId =< 26-> 
%% 					round(BaseAct * AddActData / 100);
%% 				_ ->
%% 					0
%% 			end;
%% 		_ ->
%% 			0
%% 	end.
%% 
%% 
%% %%计算总攻击力(包含技能和BUFF的附加攻击力及被动技效果)
%% %%ActMember-攻击成员记录#member
%% %%ActRoleType-攻击方攻击类型
%% %%SkillRcd-攻击方技能记录#ets_skill
%% %%返回攻击力总和
%% cptActAll(ActMember, ActRoleType, SkillRcd) ->	
%% 	case ActRoleType of
%% 		1 ->
%% 			BaseAct = ActMember#member.apwr * data_battle:get_act_con(ActMember#member.crr, ActRoleType),
%% 			{BuffChg, BuffVal} = cptActBuffChg(ActMember, BaseAct, 1),    %%计算BUFF的内力攻击力
%% 			PasBuffVal = cptActPasBufChg(ActMember, BaseAct),            %%计算被动技buff增加的攻击力(与攻击类型无关)
%% 			case BuffChg of
%% 				up ->
%% 					util:ceil(tool:int_format(BaseAct + BuffVal + PasBuffVal));
%% 				down ->
%% 					util:ceil(tool:int_format(BaseAct - BuffVal + PasBuffVal));
%% 				_ ->
%% 					util:ceil(tool:int_format(BaseAct + PasBuffVal))
%% 			end;
%% 		2 ->
%% 			BaseAct = ActMember#member.atech * data_battle:get_act_con(ActMember#member.crr, ActRoleType),
%% 			RealActTech = cptActTech(ActMember, SkillRcd, BaseAct),       %%计算技能附加的即时攻击力
%% 			{BuffChg, BuffVal} = cptActBuffChg(ActMember, BaseAct, 2),    %%计算BUFF的技能攻击力
%% 			PasBuffVal = cptActPasBufChg(ActMember, BaseAct),            %%计算被动技buff增加的攻击力(与攻击类型无关)
%% 			case BuffChg of
%% 				up ->
%% 					util:ceil(tool:int_format(BaseAct + BuffVal + PasBuffVal + RealActTech));
%% 				down ->
%% 					util:ceil(tool:int_format(BaseAct - BuffVal + PasBuffVal + RealActTech));
%% 				_ ->
%% 					util:ceil(tool:int_format(BaseAct + PasBuffVal + RealActTech))
%% 			end;
%% %% 			RealActId = SkillRcd#ets_skill.imef,
%% %% 			case RealActId of
%% %% 				6 ->  %%下降总攻击力的百分比
%% %% 					round(AllTechVal - round(AllTechVal * (SkillRcd#ets_skill.imvl /100)));
%% %% 				_ ->
%% %% 					AllTechVal
%% %% 			end;
%% 		3 ->
%% 			BaseAct = ActMember#member.amgc * data_battle:get_act_con(ActMember#member.crr, ActRoleType),
%% 			{BuffChg, BuffVal} = cptActBuffChg(ActMember, BaseAct, 3),    %%计算BUFF的法力攻击力
%% 			PasBuffVal = cptActPasBufChg(ActMember, BaseAct),            %%计算被动技buff增加的攻击力(与攻击类型无关)
%% 			case BuffChg of
%% 				up ->
%% 					util:ceil(tool:int_format(BaseAct + BuffVal + PasBuffVal));
%% 				down ->
%% 					util:ceil(tool:int_format(BaseAct - BuffVal + PasBuffVal));
%% 				_ ->
%% 					util:ceil(tool:int_format(BaseAct + PasBuffVal))
%% 			end;
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%
%% 
%% %%计算总防御力（包含了BUFF效果及被动技）
%% %%DefMember-防御成员记录#member
%% %%ActRoleType-攻击方攻击类型
%% %%返回防御力总和
%% cptDefAll(DefMember, ActRoleType) ->	
%% 	case ActRoleType of
%% 		1 ->
%% 			BaseDef = DefMember#member.dpwr * data_battle:get_def_con(DefMember#member.crr, ActRoleType),
%% 			{BuffChg, BuffVal} = cptDefBuffChg(DefMember, BaseDef, 1),    %%计算BUFF的内力防御力
%% 			PasBuffVal = cptDefPasBufChg(DefMember, BaseDef),            %%计算被动技buff增加的防御力(与攻击类型无关)
%% 			case BuffChg of
%% 				up ->
%% 					util:ceil(tool:int_format(BaseDef + BuffVal + PasBuffVal));
%% 				down ->
%% 					util:ceil(tool:int_format(BaseDef - BuffVal + PasBuffVal));
%% 				_ ->
%% 					util:ceil(tool:int_format(BaseDef + PasBuffVal))
%% 			end;
%% 		2 ->
%% 			BaseDef = DefMember#member.dtech * data_battle:get_def_con(DefMember#member.crr, ActRoleType),
%% 			{BuffChg, BuffVal} = cptDefBuffChg(DefMember, BaseDef, 2),    %%计算BUFF的技能防御力
%% 			PasBuffVal = cptDefPasBufChg(DefMember, BaseDef),            %%计算被动技buff增加的防御力(与攻击类型无关)
%% 			case BuffChg of
%% 				up ->
%% 					util:ceil(tool:int_format(BaseDef + BuffVal + PasBuffVal));
%% 				down ->
%% 					util:ceil(tool:int_format(BaseDef - BuffVal + PasBuffVal));
%% 				_ ->
%% 					util:ceil(tool:int_format(BaseDef + PasBuffVal))
%% 			end;
%% 		3 ->
%% 			BaseDef = DefMember#member.dmgc * data_battle:get_def_con(DefMember#member.crr, ActRoleType),
%% 			{BuffChg, BuffVal} = cptDefBuffChg(DefMember, BaseDef, 3),    %%计算BUFF的法力防御力
%% 			PasBuffVal = cptDefPasBufChg(DefMember, BaseDef),            %%计算被动技buff增加的防御力(与攻击类型无关)
%% 			case BuffChg of
%% 				up ->
%% 					util:ceil(tool:int_format(BaseDef + BuffVal + PasBuffVal));
%% 				down ->
%% 					util:ceil(tool:int_format(BaseDef - BuffVal + PasBuffVal));
%% 				_ ->
%% 					util:ceil(tool:int_format(BaseDef + PasBuffVal))
%% 			end;
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%计算基础伤害
%% %%DefMember-防守者成员记录
%% %%ActVal-攻击力
%% %%DefVal-防御力
%% %%返回伤害值                       (根据公式计算)
%% cptBaseHurt(ActVal, DefVal, ActType) ->	
%% 	case ActType of
%% 		2 ->
%% 			Hurt = tool:int_format(ActVal - DefVal);    %%round(0.9 * (ActVal - DefVal) - 25);   %%2011-22-28刘菁修改伤害公式
%% 		_ ->
%% 			Hurt = tool:int_format(ActVal - DefVal)                %%round(1.2 * (ActVal - DefVal)) %%2011-22-28刘菁修改伤害公式
%% 	end,
%% 	Hurt.
%% 
%% %%伤害计算
%% cptHurt(DefMember, ActVal, BaseHurt, PasList, BattleSubType, RandKey) ->
%% 	%%buff免伤
%% 	%%被动技能免伤
%% 	case RandKey of
%% 		ddgeR ->    %%闪避最终伤害为0
%% 			{0, DefMember, PasList};
%% 		missR ->    %%未命中最终伤害为0
%% 			{0, DefMember, PasList};
%% 		_ ->
%% 			case BattleSubType#battleSubType.typeId of    %%判断是否有免疫普通攻击
%% 				TrueTypeId when TrueTypeId =:= 1 orelse TrueTypeId =:= 3 ->    %%普通攻击
%% 					case bTrueDef(DefMember) of
%% 						true ->
%% 							Hurt = 1,
%% 							{DefMember1, PasList1} = chkPasNoHurt(DefMember, PasList),
%% 							{Hurt, DefMember1, PasList1};
%% 						_ ->
%% 							cptHurt1(DefMember, ActVal, BaseHurt, PasList)
%% 					end;
%% 				_ ->
%% 					cptHurt1(DefMember, ActVal, BaseHurt, PasList)
%% 			end
%% 	end.
%% 
%% %%cptHurt的辅助函数
%% cptHurt1(DefMember, ActVal, BaseHurt, PasList) ->
%% 	Hurt1 = cptNoHurtBuff(DefMember, BaseHurt),
%% 	{DefMember1, PasList1} = chkPasNoHurt(DefMember, PasList),
%% 	PasNoHurt = cptNoHurtPasBufChg(DefMember1, Hurt1),
%% 	Hurt2 = tool:int_format(Hurt1 - PasNoHurt),
%% 	HurtSw = util:ceil(ActVal * 0.05),  %%最低伤害
%% 	if Hurt2 < HurtSw ->
%% 		   Hurt = HurtSw;
%% 	   	true ->
%% 		   Hurt = Hurt2
%% 	end,
%% 	{Hurt, DefMember1, PasList1}.
%% 
%% %%计算战斗成员开始战斗时的BUFF对血量的影响（中毒、出血、加血）
%% %%返回气血的影响值{角色状态（0-生存，1-死亡），是否受到伤害（0-没有，1-有受到伤害），角色最后的血量，Hp_Array数据打包}
%% cptRoleActBeginBuff(ActMember, PasList) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			BinHpBuffs = <<0:16>>,
%% 			{1, 0, ActMember#member.hp, BinHpBuffs, PasList};
%% 		_ ->		
%% 			UseBuffListDownR = [round(ActMember#member.mxhp * BuffDownVal /100)||{BuffDownId, BuffDownVal, DownNum} <- BuffList, BuffDownId =:= 63 andalso DownNum > 0], %%气血中毒百分比减益BUFF
%% 			UseBuffListDownV = [BuffDownVal1||{BuffDownId1, BuffDownVal1, DownNum1} <- BuffList, BuffDownId1 =:= 62 andalso DownNum1 > 0],                              %%气血中毒绝对值减益BUFF
%% 			UseBuffListDownR1 = [round(ActMember#member.mxhp * BuffDownVal2 /100)||{BuffDownId2, BuffDownVal2, DownNum2} <- BuffList, BuffDownId2 =:= 69 andalso DownNum2 > 0], %%气血出血百分比减益BUFF
%% 			UseBuffListDownV1 = [BuffDownVal3||{BuffDownId3, BuffDownVal3, DownNum3} <- BuffList, BuffDownId3 =:= 68 andalso DownNum3 > 0],                              %%气血出血绝对值减益BUFF
%% 			UseBuffListDown = UseBuffListDownR ++ UseBuffListDownV,
%% 			UseBuffListDown1 = UseBuffListDownR1 ++ UseBuffListDownV1,	
%% 			UseBuffListDownAll = UseBuffListDown ++ UseBuffListDown1,			
%% 			case  UseBuffListDownAll of                %%判定是否有伤害产生
%% 				[] ->
%% 					BHurt = 0;              
%% 				_ ->
%% 					BHurt = 1
%% 			end,
%% 			case UseBuffListDown of
%% 				[] ->					
%% 					HpBuffs = [];
%% 				_ ->					 
%% 					ActDownVT = lists:max(UseBuffListDown),
%% 					if ActDownVT >= 2000 ->
%% 						  ActDownV = 2000;
%% 					   true ->
%% 						  ActDownV = ActDownVT
%% 					end,
%% 					HpBuffs = [{1, ActDownV}]
%% 			end,							  
%% 			case UseBuffListDown1 of
%% 				[] ->					
%% 					HpBuffs1 = HpBuffs;
%% 				_ ->
%% 					ActDownVT1 = lists:max(UseBuffListDown1),
%% 					if ActDownVT1 >= 2000 ->
%% 						   ActDownV1 = 2000;
%% 					   true ->
%% 						   ActDownV1 = ActDownVT1
%% 					end,
%% 					HpBuffs1 = HpBuffs ++ [{2, ActDownV1}]			
%% 			end,
%% 			BinHpBuffs = <<>>,
%% 			{ActSta, NewBeginHpT, NewBinHpBuffs, ListNum} = cptRoleActBeginBuffList(HpBuffs1, ActMember#member.hp, BinHpBuffs, 0),
%% 			case ActSta of
%% 				0 ->   %%触发被动技(复生和垂死)
%% 					{NewBeginHp, ActSta1, ActMember1, PasList1} = chkPasSkillRelive(ActMember, PasList);
%% 				1 ->
%% 					ActSta1 = ActSta,
%% 					NewBeginHp = NewBeginHpT,
%% 					ActMember1 = ActMember,
%% 					PasList1 = PasList
%% 			end,
%% 			BuffList1 = ActMember1#member.buffs,
%% 			case ActSta1 of
%% 				0 ->
%% 					BinHpBuffsAll = <<ListNum:16, NewBinHpBuffs/binary>>,
%% 					{0, BHurt, NewBeginHp, BinHpBuffsAll, PasList1};
%% 				1 ->
%% 					UseBuffListUpR = [round(ActMember#member.mxhp * BuffUpVal /100)||{BuffUpId, BuffUpVal, UpNum} <- BuffList1, BuffUpId =:= 61 andalso UpNum > 0],                                     %%气血百分比增益BUFF
%% 					UseBuffListUpV = [BuffUpVal1||{BuffUpId1, BuffUpVal1, UpNum1} <- BuffList1, BuffUpId1 =:= 60 andalso UpNum1 > 0],                                %%气血绝对值增益BUFF
%% 					UseBuffListUp = UseBuffListUpR ++ UseBuffListUpV,
%% 					case UseBuffListUp of
%% 						[] ->							
%% 							BinHpBuffsAll = <<ListNum:16, NewBinHpBuffs/binary>>,
%% 							{1, BHurt, NewBeginHp, BinHpBuffsAll, PasList1};
%% 						_ ->
%% 							ActUpV1 = lists:max(UseBuffListUp),
%% 							if ActUpV1 > 2000 ->
%% 								   ActUpV = 2000;
%% 							   true ->
%% 								   ActUpV = ActUpV1
%% 							end,
%% 							NewHp = ActUpV + NewBeginHp,
%% 							if NewHp > ActMember#member.mxhp ->
%% 								   NowHp = ActMember#member.mxhp;
%% 							   true ->
%% 								   NowHp = NewHp
%% 							end,
%% 							NewListNum = ListNum + 1,
%% 							BinHpBuffsAll = <<NewListNum:16, NewBinHpBuffs/binary, 3:8, ActUpV:32, NowHp:32>>,
%% 							{1, BHurt, NowHp, BinHpBuffsAll, PasList1}							   
%% 					end
%% 			end			
%% 	end.
%% 
%% %%Buff血量变化队列
%% cptRoleActBeginBuffList([], BeginHp, BinHpBuffs, ListNum) ->
%% 	if BeginHp > 0 ->
%% 		   {1, BeginHp, BinHpBuffs, ListNum};
%% 	   true ->
%% 		   {0, BeginHp, BinHpBuffs, ListNum}
%% 	end;
%% 	
%% cptRoleActBeginBuffList(_HpBuffList, 0, BinHpBuffs, ListNum) ->
%% 	{0, 0, BinHpBuffs, ListNum};
%% 
%% cptRoleActBeginBuffList(HpBuffList, BeginHp, BinHpBuffs, ListNum) ->
%% 	{Id, Val} = lists:nth(1, HpBuffList),
%% 	if BeginHp > Val ->
%% 		   NewBeginHp = BeginHp - Val;		   
%% 	   true ->
%% 		   NewBeginHp = 0		   		   
%% 	end,	
%% 	NewListNum = ListNum + 1,
%% 	NewBinHpBuffs = <<BinHpBuffs/binary, Id:8, Val:32, NewBeginHp:32>>,
%% 	NewHpBuffList = HpBuffList -- [{Id, Val}],
%% 	cptRoleActBeginBuffList(NewHpBuffList, NewBeginHp, NewBinHpBuffs, NewListNum).
%% 
%% %%更改攻击角色的所有BUFF次数（不含昏睡）(0-没有buff被取消，1-有buff被取消)
%% %%ActMember-攻击成员记录#member
%% %%返回攻击角色的BUFF列表
%% updateBuff(ActMember, BattleSubType) ->
%% 	%% change by chenzm for boss begin, 世界BOSS不含BUFF
%% 	case ActMember#member.crr of
%% 		100 ->
%% 			BuffList = [] ;
%% 		_ ->
%% 			BuffList = ActMember#member.buffs
%% 	end ,
%% 	%% change by chenzm for boss begin
%% 	case BuffList of
%% 		[] ->
%% 			{[], BattleSubType};
%% 		_ ->
%% 			%%昏睡效果BUFF修改(liujing 2012-8-11)
%% 			TmpBuffList1 = [{Id, Val, Num - 1}||{Id, Val, Num} <- BuffList, Num > 0],
%% 			ReBuffList = [{Id1, Val1, Num1}||{Id1, Val1, Num1} <- TmpBuffList1, Num1 > 0],
%% 			ChkListOld = lists:usort([Id2||{Id2, _Val2, Num2}<- BuffList, Num2 > 0]),
%% 			ChkListNew = lists:usort([Id3||{Id3, _Val3, _Num3}<- ReBuffList]),
%% %% 			io:format("~s updateBuff____[~w][~w]~n",[misc:time_format(now()), ChkListOld,ChkListNew]),
%% 			if ChkListOld =:= ChkListNew ->
%% 				   {ReBuffList, BattleSubType};
%% 			   true ->
%% 				   {ReBuffList, BattleSubType#battleSubType{buffCancelList = [ActMember#member.pst|BattleSubType#battleSubType.buffCancelList]}}
%% 			end
%% 			
%% %% 			TmpBuffList1 = [{Id1, _Val1, _Num1}||{Id1, _Val1, _Num1} <- BuffList, Id1 =/= 66],
%% %% 			TmpBuffList2 = [{Id2, _Val2, _Num2}||{Id2, _Val2, _Num2} <- BuffList, Id2 =:= 66],
%% %% 			case TmpBuffList1 of
%% %% 				[] ->
%% %% 					TmpBuffList = [];
%% %% 				_ ->
%% %% 					TmpBuffList = [{Id, Val, Num - 1}||{Id, Val, Num} <- TmpBuffList1, Num > 1]          %%筛选出剩余次数不为0的非睡昏睡BUFF
%% %% 			end,			
%% %% 			TmpBuffList ++ TmpBuffList2
%% 	end.
%% 
%% %%更改受攻击角色的昏睡BUFF次数
%% %%DefMember-受攻击成员记录#member
%% %%返回受攻击角色的BUFF列表
%% updateSleepBuff(DefMember, BattleSubType) ->
%% 	BuffList = DefMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			{[], BattleSubType};
%% 		_ ->
%% 			TmpBuffList1 = [{Id1, _Val1, _Num1}||{Id1, _Val1, _Num1} <- BuffList, Id1 =/= 66],
%% 			TmpBuffList2 = [{Id2, _Val2, _Num2}||{Id2, _Val2, _Num2} <- BuffList, Id2 =:= 66],
%% 			%%昏睡效果BUFF修改(liujing 2012-8-11)
%% 			case TmpBuffList2 of
%% 				[] ->
%% 					{BuffList, BattleSubType};
%% %% 				    TmpBuffList = [];
%% 				_ ->
%% 					SleepRat = data_battle:get_sleep() * 100,
%% 					RandNum = util:rand(1,10000),
%% 					if RandNum =< SleepRat ->
%% 						   {TmpBuffList1, BattleSubType#battleSubType{buffCancelList = BattleSubType#battleSubType.buffCancelList ++ [DefMember#member.pst]}};
%% 					   true ->
%% 						   {BuffList, BattleSubType}
%% 					end
%% %% 			case TmpBuffList2 of
%% %% 				[] ->
%% %% 					TmpBuffList = [];
%% %% 				_ ->
%% %% 					TmpBuffList = [{Id, Val, Num - 1}||{Id, Val, Num} <- TmpBuffList2, Num > 1]          %%筛选出剩余次数不为0的BUFF
%% %% 			end,			
%% %% 			TmpBuffList ++ TmpBuffList1
%% 			end		
%% 	end.
%% 
%% %%修改战斗记录#battle_record的字段值
%% %%OldBattle_record-需要修改的战斗记录
%% %%Key-修改类型判定原子（member-修改成员记录，anger-修改怒气值, memberandanger- 成员记录和怒气都修改）
%% %%Val-修改值（member记录或怒气值或{怒气值，成员记录}）
%% %%返回新的战斗记录#battle_record
%% updateBattle_record(OldBattle_record, Key, Val) ->
%% 	case Key of
%% 		member ->
%% 			MemberList = OldBattle_record#battle_record.members,
%% %% 			io:format("~s updateBattle_record__1----[~p]\n",[misc:time_format(now()), MemberList]),
%% 			Pst = Val#member.pst,
%% 			NMemberList = [OldM||OldM <- MemberList, OldM#member.pst =/= Pst],                   
%% 			NewMemberList = [Val|NMemberList],
%% %% 			io:format("~s updateBattle_record__2----[~p]\n",[misc:time_format(now()), NewMemberList]),
%% 			OldBattle_record#battle_record{members = NewMemberList};
%% 		anger ->
%% 			if OldBattle_record#battle_record.bact =:= 1 orelse OldBattle_record#battle_record.behId =:= 0 ->
%% 				   OldBattle_record#battle_record{anger = 0};
%% 			   true ->   
%% 				   if Val > 100 ->
%% 						  OldBattle_record#battle_record{anger = 100};
%% 					  true ->
%% 						  OldBattle_record#battle_record{anger = Val}
%% 				   end				   
%% 			end;			
%% 		memberandanger ->
%% 			{Anger, Member} = Val,
%% 			MemberList = OldBattle_record#battle_record.members,
%% 			Pst = Member#member.pst,
%% 			NMemberList = [OldM||OldM <- MemberList, OldM#member.pst =/= Pst],  
%% 			NewMemberList = [Member|NMemberList],
%% 			if OldBattle_record#battle_record.bact =:= 1 orelse OldBattle_record#battle_record.behId =:= 0 ->
%% 				   NewAnger = 0;
%% 			   true ->
%% 				   if Anger > 100 ->
%% 						  NewAnger = 100;
%% 					  true ->
%% 						  NewAnger = Anger
%% 				   end				   
%% 			end,
%% 			OldBattle_record#battle_record{anger = NewAnger,
%% 										   members = NewMemberList};
%% 		_ ->
%% 			OldBattle_record			
%% 	end.
%% 
%% %%巨兽攻击判定
%% bBehemothAct(Battle_record, Direct, BattleSta) ->
%% 	if Battle_record#battle_record.anger >= Battle_record#battle_record.maxang andalso Battle_record#battle_record.bact =/= 1 andalso Battle_record#battle_record.behId =/= 0 ->
%% 		   if BattleSta#battleSta.bBehemothAct ->
%% 				  BattleSta;
%% 			  true ->
%% 				  BattleSta#battleSta{bBehemothAct = true,
%% 									  behemothActPst = Direct}
%% 		   end;
%% 	   true ->
%% 		   BattleSta
%% 	end.
%% 		   
%% %%通过BUFF判定是否进行攻击（即判断是否有致盲、昏睡、晕眩BUFF）
%% %%ActMember-攻击成员记录#member
%% %%返回能攻击true或不能攻击false
%% bNoAct(ActMember) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			false;
%% 		_ ->			
%% 			RList = [{Id, _Val, _Num}||{Id, _Val, _Num} <- BuffList, Id =:= 66 orelse Id =:= 67],  %%Id =:= 64 致盲改为可以行动
%% 			case RList of
%% 				[] ->
%% 					false;
%% 				_ ->
%% 					true
%% 			end
%% 	end.
%% 
%% %%通过BUFF判定是否进行混乱攻击（即判断是否混乱BUFF）
%% %%ActMember-攻击成员记录#member
%% %%返回能攻击true或不能攻击false
%% bCanChaosAct(ActMember) ->
%% 	BuffList = ActMember#member.buffs,
%% 	case BuffList of
%% 		[] ->
%% 			false;
%% 		_ ->			
%% 			RList = [{Id, _Val, _Num}||{Id, _Val, _Num} <- BuffList, Id =:= 65],
%% 			case RList of
%% 				[] ->
%% 					false;
%% 				_ ->
%% 					true
%% 			end
%% 	end.
%% 
%% %%通过BUFF判定是否封足成功
%% %%ActMember-攻击成员记录#member
%% %%返回能true或false
%% bNoPwr(ActMember) ->
%% 	RoleActType = data_battle:getCrrActType(ActMember#member.crr),
%% 	if RoleActType =:= 1 ->
%% 		   if ActMember#member.mana < ActMember#member.mxmn ->
%% 				  BuffList = ActMember#member.buffs,
%% 				  case BuffList of
%% 					  [] ->
%% 						  false;
%% 					  _ ->
%% 						  RList = [{Id, _Val, _Num}||{Id, _Val, _Num} <- BuffList, Id =:= 72],
%% 						  case RList of
%% 							  [] ->
%% 								  false;
%% 							  _ ->
%% 								  true
%% 						  end
%% 				  end;
%% 			  true ->
%% 				  false
%% 		   end;
%% 	   true ->
%% 		   false
%% 	end.
%% 
%% %%通过BUFF判定是否封法成功
%% %%ActMember-攻击成员记录#member
%% %%返回能true或false
%% bNoMgc(ActMember) ->
%% 	RoleActType = data_battle:getCrrActType(ActMember#member.crr),
%% 	if RoleActType =:= 3 ->
%% 		   if ActMember#member.mana < ActMember#member.mxmn ->
%% 				  BuffList = ActMember#member.buffs,
%% 				  case BuffList of
%% 					  [] ->
%% 						  false;
%% 					  _ ->
%% 						  RList = [{Id, _Val, _Num}||{Id, _Val, _Num} <- BuffList, Id =:= 74],
%% 						  case RList of
%% 							  [] ->
%% 								  false;
%% 							  _ ->
%% 								  true
%% 						  end
%% 				  end;
%% 			  true ->
%% 				  false
%% 		   end;
%% 	   true ->
%% 		   false
%% 	end.
%% 
%% %%通过BUFF判定是否封技成功
%% %%ActMember-攻击成员记录#member
%% %%返回能true或false
%% bNoTech(ActMember) ->	
%% 	if ActMember#member.mana >= ActMember#member.mxmn ->
%% 		  BuffList = ActMember#member.buffs,
%% 		  case BuffList of
%% 			  [] ->
%% 				  false;
%% 			  _ ->
%% 				  RList = [{Id, _Val, _Num}||{Id, _Val, _Num} <- BuffList, Id =:= 73],
%% 				  case RList of
%% 					  [] ->
%% 						  false;
%% 					  _ ->
%% 						  true
%% 				  end
%% 		  end;
%% 	  true ->
%% 		  false	
%% 	end.
%% 	
%% %%在角色队列中删除死亡角色（用于受攻击列表计算中）
%% %%Role_List-角色列表
%% %%Role-角色元组{left/right, psttp}
%% %%返回新的角色列表
%% delDeathRole(Role_List, Role) ->
%% 	{_Dr, Psttp} = Role,
%% 	Death_List = [{Xid,Z1,Z2,Z3,Z4}||{Xid,Z1,Z2,Z3,Z4}<-Role_List,Z4 =:= Psttp],
%% 	Role_List -- Death_List.
%% 
%% %%计算技能Buff的受攻击角色列表
%% %%ActMember-攻击成员记录#member
%% %%Direct-攻击角色所站方向（left/right）
%% %%SkillRcd-攻击角色技能记录#ets_skill
%% %%返回受BUFF攻击对象列表
%% cptBuffActTo(ActMember, Direct, SkillRcd, Left_List, Right_List) ->
%% 	BuffRangeId = SkillRcd#ets_skill.bfmod,
%% 	case BuffRangeId of
%% 		1 ->    %%施放对象是自己
%% 			[{Direct, ActMember#member.psttp}];
%% 		2 ->    %%施放对象是己方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List]
%% 			end;
%% 		3 ->    %%施放对象是敌方单体
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{right, Arrmy_Member}];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            	
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{left, Arrmy_Member}]
%% 			end;
%% 		4 ->    %%施放对象是敌方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List]
%% 			end;
%% 		5 ->    %%敌方单排
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		6 ->   %%敌方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		7 ->   %%敌方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		8 ->  %%敌方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		9 ->   %%己方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		10 ->   %%己方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		11 ->   %%己方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		_ ->
%% 			[]
%% 	end.
%% 
%% 
%% %%计算技能Buff的受攻击角色列表(攻击者中了混乱BUFF后)
%% %%ActMember-攻击成员记录#member
%% %%Direct-攻击角色所站方向（left/right）
%% %%SkillRcd-攻击角色技能记录#ets_skill
%% %%返回受BUFF攻击对象列表
%% cptBuffActToOnChaos(ActMember, Direct, SkillRcd, Left_List, Right_List) ->
%% 	BuffRangeId = SkillRcd#ets_skill.bfmod,
%% 	TechRangeId = SkillRcd#ets_skill.immod,
%% %% 	io:format("~s cptBuffActToOnChaos[~p/~p]\n",[misc:time_format(now()), BuffRangeId, Direct]),
%% 	case BuffRangeId of
%% 		1 ->    %%施放对象是自己
%% 			case Direct of
%% 				left ->
%% 					if TechRangeId =:= 1 ->                   %%即时模式是敌方单体，BUFF攻击对象还是自己
%% 						   [{Direct, ActMember#member.psttp}];
%% 					   true ->
%% 						   Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],					
%% 						   case Arrmy_Position_List of							   
%% 							   [] ->
%% 								   [];
%% 							   _ ->
%% 								   [Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),     %% 计算受攻击的成员,单体攻击，混乱情况下单体和影杀攻击目标相同
%% 								   [{right, Arrmy_Member}]
%% 						  end
%% 					end;
%% 				right ->
%% 					if TechRangeId =:= 1 ->                   %%即时模式是敌方单体，BUFF攻击对象还是自己
%% 						   [{Direct, ActMember#member.psttp}];
%% 					   true ->						   
%% 						   Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 						   case Arrmy_Position_List of
%% 							   [] ->
%% 								   [];
%% 							   _ ->
%% 								   [Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),      %% 计算受攻击的成员,单体攻击，混乱情况下单体和影杀攻击目标相同
%% 								   [{left, Arrmy_Member}]
%% 						   end
%% 					end
%% 			end;
%% 		2 ->    %%施放对象是己方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List]
%% 			end;
%% 		3 ->    %%施放对象是敌方单体
%% 			ActPsttp = ActMember#member.psttp,
%% 			case Direct of				
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActPsttp], 
%% %% 					io:format("~s cptBuffActToOnChaos1[~p]\n",[misc:time_format(now()), Arrmy_Position_List]),
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							[Arrmy_Member]=act_to(ActMember#member.psttp, 4, Arrmy_Position_List),     %% 计算受攻击的成员,单体攻击，混乱情况下单体和影杀攻击目标相同
%% 							[{left, Arrmy_Member}]
%% 					end;					
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActPsttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							[Arrmy_Member]=act_to(ActMember#member.psttp, 4, Arrmy_Position_List),      %% 计算受攻击的成员,单体攻击，混乱情况下单体和影杀攻击目标相同
%% 							[{right, Arrmy_Member}]
%% 					end				
%% 			end;
%% 		4 ->    %%施放对象是敌方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List, Psttp =/= ActMember#member.psttp];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List, Psttp =/= ActMember#member.psttp]
%% 			end;
%% 		5 ->   %%敌方单排
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp],
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->					
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		6 ->   %%敌方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		7 ->  %%敌方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		8 ->  %%敌方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		9 ->   %%己方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		10 ->   %%己方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		11 ->   %%己方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		_ ->
%% 			[]
%% 	end.
%% 
%% 
%% %%计算普通攻击的受攻击角色列表
%% cptActTo(ActMember, Direct, Left_List, Right_List) ->
%% 	case Direct of
%% 		left ->
%% 			Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],   
%% 			case act_to(ActMember#member.psttp, 1, Arrmy_Position_List) of  %% 计算受普通攻击的成员,单体攻击
%% 				[Arrmy_Member] ->
%% 					[{right, Arrmy_Member}];
%% 				_ ->
%% 					[{right, []}]
%% 			end;
%% 		right ->
%% 			Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],          
%% 			case act_to(ActMember#member.psttp, 1, Arrmy_Position_List) of  %% 计算受普通攻击的成员,单体攻击
%% 				[Arrmy_Member] ->
%% 					[{left, Arrmy_Member}];
%% 				_ ->
%% 					[{left, []}]
%% 			end
%% 	end.
%% 
%% %%计算中混乱BUFF后普通攻击的受攻击角色列表
%% cptChaosBuffActTo(ActMember, Direct, Left_List, Right_List) ->
%% 	case Direct of
%% 		left ->			
%% 			Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp],
%% 			case Arrmy_Position_List of
%% 				[] ->
%% 					[];
%% 				_ ->
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受攻击的成员,单体攻击，混乱情况下单体和影杀攻击目标相同
%% 					[{left, Arrmy_Member}]
%% 			end;
%% 		right ->
%% 			Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp],
%% 			case Arrmy_Position_List of
%% 				[] ->
%% 					[];
%% 				_ ->
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受攻击的成员,单体攻击，混乱情况下单体和影杀攻击目标相同
%% 					[{right, Arrmy_Member}]
%% 			end
%% 	end.
%% 
%% %%计算技能的受攻击角色列表
%% %%ActMember-攻击成员记录#member
%% %%Direct-攻击角色所站方向（left/right）
%% %%SkillRcd-攻击角色技能记录#ets_skill
%% %%返回受技能攻击对象列表
%% cptTechActTo(ActMember, Direct, SkillRcd, Left_List, Right_List) ->
%% 	BuffRangeId = SkillRcd#ets_skill.immod,
%% %% 	io:format("~s cptTechActTo___1_____[~p][~p] \n ",[misc:time_format(now()),SkillRcd#ets_skill.id, BuffRangeId]),
%% 	case BuffRangeId of
%% 		0 ->
%% 			[];
%% 		1 ->    %%施放对象是敌方单体
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{right, Arrmy_Member}];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            	
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{left, Arrmy_Member}]
%% 			end;
%% 		2 ->    %%施放对象是敌方单排
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		3 ->    %%施放对象是敌方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		4 ->    %%施放对象是敌方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List]
%% 			end;
%% 		5 ->	%%影杀
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 4, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{right, Arrmy_Member}];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            	
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 4, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{left, Arrmy_Member}]
%% 			end;
%% 		6 ->    %%施放对象是自己
%% 			[{Direct, ActMember#member.psttp}];
%% 		7 ->	%%施放对象是己方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List]
%% 			end;
%% 		9 ->   %%施放对象是敌方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		10 ->  %%施放对象是敌方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		11 ->  %%己方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		12 ->  %%己方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		13 ->  %%己方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{left, Psttp}||Psttp <- Arrmy_Members];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 					[{right, Psttp}||Psttp <- Arrmy_Members]
%% 			end;
%% 		_ ->
%% 			[]
%% 	end.			
%% 
%% %%计算技能的受攻击角色列表(攻击方中混乱后)
%% %%ActMember-攻击成员记录#member
%% %%Direct-攻击角色所站方向（left/right）
%% %%SkillRcd-攻击角色技能记录#ets_skill
%% %%返回受技能攻击对象列表
%% cptTechChaosActTo(ActMember, Direct, SkillRcd, Left_List, Right_List) ->
%% 	BuffRangeId = SkillRcd#ets_skill.immod,
%% 	case BuffRangeId of
%% 		0 ->     %%没有及时攻击
%% 			[];
%% 		1 ->    %%施放对象是敌方单体
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp],                            
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 							[{left, Arrmy_Member}]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp],
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 							[{right, Arrmy_Member}]
%% 					end
%% 			end;
%% 		2 ->    %%施放对象是敌方单排
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp],
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->					
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 2, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		3 ->    %%施放对象是敌方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		4 ->    %%施放对象是敌方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List, Psttp =/= ActMember#member.psttp];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List, Psttp =/= ActMember#member.psttp]
%% 			end;
%% 		5 ->	%%影杀
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp],
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							[Arrmy_Member]=act_to(ActMember#member.psttp, 4, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 							[{left, Arrmy_Member}]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							[Arrmy_Member]=act_to(ActMember#member.psttp, 4, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 							[{right, Arrmy_Member}]
%% 					end
%% 			end;
%% 		6 ->    %%施放对象是自己
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List],                            
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{right, Arrmy_Member}];
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List],                            	
%% 					[Arrmy_Member]=act_to(ActMember#member.psttp, 1, Arrmy_Position_List),                                 %% 计算受BUFF攻击的成员,单体攻击
%% 					[{left, Arrmy_Member}]
%% 			end;
%% 		7 ->	%%施放对象是己方全体
%% 			case Direct of
%% 				left ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Right_List];
%% 				right ->
%% 					[{D1,Psttp}||{_Id, _Type, D1, _Pst, Psttp} <- Left_List]
%% 			end;
%% 		9 ->   %%施放对象是敌方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		10 ->   %%施放对象是敌方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List, P =/= ActMember#member.psttp], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		11 ->    %%施放对象是己方前列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 3, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		12 ->    %%施放对象是己方中列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 6, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		13 ->    %%施放对象是己方后列
%% 			case Direct of
%% 				left ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Right_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{right, Psttp}||Psttp <- Arrmy_Members]
%% 					end;
%% 				right ->
%% 					Arrmy_Position_List = [P||{_,_,_,_,P}<-Left_List], 
%% 					case Arrmy_Position_List of
%% 						[] ->
%% 							[];
%% 						_ ->
%% 							Arrmy_Members=act_to(ActMember#member.psttp, 5, Arrmy_Position_List),
%% 							[{left, Psttp}||Psttp <- Arrmy_Members]
%% 					end
%% 			end;
%% 		_ ->
%% 			[]
%% 	end.			
%% 
%% %%计算普通攻击力（不含BUFF和技能）
%% getActAll(ActMember, ActRoleType) ->
%% 	case ActRoleType of
%% 		1 ->
%% 			util:ceil(ActMember#member.apwr * data_battle:get_act_con(ActMember#member.crr, ActRoleType));
%% 		2 ->
%% 			util:ceil(ActMember#member.atech * data_battle:get_act_con(ActMember#member.crr, ActRoleType));
%% 		3 ->
%% 			util:ceil(ActMember#member.amgc * data_battle:get_act_con(ActMember#member.crr, ActRoleType));
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%计算普通防御力（不含BUFF）
%% getDefAll(DefMember, ActRoleType) ->
%% 	case ActRoleType of
%% 		1 ->
%% 			util:ceil(DefMember#member.dpwr * data_battle:get_def_con(DefMember#member.crr, ActRoleType));
%% 		2 ->
%% 			util:ceil(DefMember#member.dtech * data_battle:get_def_con(DefMember#member.crr, ActRoleType));
%% 		3 ->
%% 			util:ceil(DefMember#member.dmgc * data_battle:get_def_con(DefMember#member.crr, ActRoleType));
%% 		_ ->
%% 			0
%% 	end.
%% 
%% pstToDirectAndPsttp(Pst) ->
%% 	Direct = Pst div 10, 
%% 	P = Pst rem 10,
%% 	Psttp = positionConversion(P),
%% 	case Direct of
%% 		1 ->
%% 			{left, Psttp};
%% 		2 ->
%% 			{right, Psttp};
%% 		_ ->
%% 			{}
%% 	end.
%% 
%% %% %%BUFF列表数据封包
%% %% ptBuffs(BuffList) ->
%% %% 	case BuffList of
%% %% 		[] ->
%% %% 			<<0:16>>;
%% %% 		_ ->
%% %% 			NewList = lists:usort([<<Id:8>>||{Id, _V, _T} <- BuffList]),
%% %% 			ListLen = length(NewList),
%% %% 			BuffsBin = tool:to_binary(NewList),
%% %% 			<<ListLen:16, BuffsBin/binary>>
%% %% 	end.
%% 
%% %%buff发生变化角色的BUFF列表数据封包
%% ptBuffs(LBattleRecord, RBattleRecord, BattleSubType) ->
%% 	AllMember = LBattleRecord#battle_record.members ++ RBattleRecord#battle_record.members,
%% 	DownRoleList = BattleSubType#battleSubType.buffCancelList,
%% 	UpRoleDataList = BattleSubType#battleSubType.buffAddList,
%% 	UpRoleList = [Pst||{Pst, _Id}<-UpRoleDataList],
%% 	AllRoleList = lists:usort(DownRoleList ++ UpRoleList),
%% 	Fun1 = fun(BuffId, BuffPst) ->
%% 				   case [{Pst1, Id1} || {Pst1, Id1} <- UpRoleDataList, Pst1 =:= BuffPst andalso Id1 =:= BuffId] of
%% 					   [] ->
%% 						   {<<0:8, BuffId:8>>, BuffPst};
%% 					   _ ->
%% 						   {<<1:8, BuffId:8>>, BuffPst}
%% 				   end
%% 		   end,
%% 	Fun = fun(RolePst, BinList) ->
%% 				  case lists:keyfind(RolePst, #member.pst, AllMember) of
%% 					  false ->
%% 						  BinList;
%% 					  RoleMember ->
%% 						  if RoleMember#member.hp > 0 ->
%% 								 BuffList = RoleMember#member.buffs,
%% 								 NewList = lists:usort([Id||{Id, _V, T} <- BuffList, T > 0]),
%% 								 {ThisBinList, _RePst} = lists:mapfoldl(Fun1, RolePst, NewList),
%% 								 ThisLen = length(ThisBinList),
%% 								 ThisBin = tool:to_binary(ThisBinList),
%% 								 BinList ++ [<<RolePst:8, ThisLen:16, ThisBin/binary>>];
%% 							 true ->
%% 								 BinList
%% 						  end
%% 				  end
%% 		  end,
%% 	ReBinList = lists:foldl(Fun, [], AllRoleList),
%% 	AllBinLen = length(ReBinList),
%% 	AllBin = tool:to_binary(ReBinList),
%% 	<<AllBinLen:16, AllBin/binary>>.
%% 						  
%% 
%% %%单次受到BUFF攻击的数据封包
%% ptSimpleDefBuff(DefPst, DefBuffBin) ->
%% 	<<DefPst:8, DefBuffBin/binary>>.
%% 
%% %%单次受到攻击的数据封包
%% ptSimpleDef(DefPst, DefEffctId, HpUpDown, HpChg, NowHp, DefSta, Mana, Anger) ->
%% %% 	io:format("========ptSimpleDef ~p~n",[[DefPst, DefEffctId, HpUpDown, HpChg, NowHp, DefSta, Mana, Anger]]),
%% 	if DefSta =/= 0 ->  %%生存
%% 		   NewMana = Mana;
%% 	   true ->
%% 		   NewMana = 0
%% 	end,
%% 	<<DefPst:8, DefEffctId:8, HpUpDown:8, HpChg:32, NowHp:32, DefSta:8, NewMana:16, Anger:16>>.
%% 
%% %%单次攻击的数据封包
%% ptSimpleAct(ActPst, BinHpArray, NowHp, ActSta, ActEffctId, Mana, Anger, ActedBin, ActedBuffBin, BinPas) ->
%% 	<<ActPst:8, BinHpArray/binary, NowHp:32, ActSta:8, ActEffctId:8, Mana:16, Anger:16, ActedBin/binary, ActedBuffBin/binary, BinPas/binary>>.
%% 
%% %% add by chenzm for boss begin
%% 
%% packHead(LBattleRecord,RBattleRecord) ->
%% 	LMemList = [ M || M <- LBattleRecord#battle_record.members,M#member.mtype =:= 1 ] ,
%% 	RMemList = [ M || M <- RBattleRecord#battle_record.members,M#member.mtype =:= 1 ] ,
%% 	case LMemList of
%% 		[ LeftMember | _ ] when is_record(LeftMember,member) ->
%% 			LHeadTuple = {1,
%% 						 LeftMember#member.id,
%% 						 LeftMember#member.nick,
%% 						 LeftMember#member.sex,
%% 						 LeftMember#member.crr,
%% 						 LeftMember#member.lv,
%% 						 LeftMember#member.ffc} ,
%% 			HeadList = [LHeadTuple] ;
%% 		_ ->
%% 			HeadList = []
%% 	end ,
%% 	case RMemList of
%% 		[ RightMember | _ ] when is_record(RightMember,member) ->
%% 			RHeadTuple = {2,
%% 						 RightMember#member.id,
%% 						 RightMember#member.nick,
%% 						 RightMember#member.sex,
%% 						 RightMember#member.crr,
%% 						 RightMember#member.lv,
%% 						 RightMember#member.ffc} ,
%% 			NewHeadList = HeadList ++ [RHeadTuple] ;
%% 		_ ->
%% 			NewHeadList = HeadList
%% 	end ,
%% 	packHead(NewHeadList) .
%%   
%% packHead([]) -> 
%% 	<<0:16, <<>>/binary>> ;
%% packHead(HeadList) ->
%% 	Len = length(HeadList) ,
%% 	F = fun({Direct,UId,Nick,Sex,Crr,Lv,Ffc}) ->
%% 				NickBin = tool:to_binary(Nick) ,
%% 				NickLen = byte_size(NickBin) ,
%% 				<<Direct:8,UId:32,NickLen:16,NickBin/binary,Sex:8,Crr:16,Lv:16,Ffc:32>> 
%% 		end,
%% 	RB = tool:to_binary([F(D) || D <- HeadList]) ,
%% 	<<Len:16,RB/binary>> .
%% 
%% %% add by chenzm for boss end
%% 
%% %%校验战斗记录中成员数据（用于对旧数据的兼容，member中新添加字段必须在后面添加）,主要用于循环战斗
%% checkBattleRecord(Battle_record) ->
%% 	if is_record(Battle_record, battle_record) ->
%% 		    Members = Battle_record#battle_record.members,
%% 			Fun = fun(BM) ->
%% 						  if is_record(BM, member) ->
%% 								 BM;
%% 							 true ->
%% 								 checkMember(BM)
%% 						  end
%% 				  end,
%% 			Members1 = lists:map(Fun, Members),
%% 			Battle_record#battle_record{members = Members1};
%% 	   true ->
%% 		    List = [Battle_record],
%% 			case lists:keyfind(battle_record, 1, List) of
%% 				false ->
%% 					[];
%% 				_ ->
%% 					Battle_recordTmp = #battle_record{},
%% 					TrueList = tuple_to_list(Battle_recordTmp),
%% 					TrueLen = length(TrueList),
%% 					NowList = tuple_to_list(Battle_record),
%% 					NowLen = length(NowList),
%% 					if TrueLen =< NowLen ->
%% 						    Battle_recordTmp1 = Battle_record;
%% 			   			true ->
%% 				   			Battle_recordTmp1 = list_to_tuple(NowList ++ lists:nthtail(NowLen, TrueList))
%% 					end,
%% 					Members = Battle_recordTmp1#battle_record.members,
%% 					Fun = fun(BM) ->
%% 								  if is_record(BM, member) ->
%% 										 BM;
%% 									 true ->
%% 										 checkMember(BM)
%% 								  end
%% 						  end,
%% 					Members1 = lists:map(Fun, Members),
%% 					Battle_recordTmp1#battle_record{members = Members1}
%% 			end
%% 	end.
%% 
%% 
%% %%校验成员记录（用于对旧数据的兼容，member中新添加字段必须在后面添加）
%% checkMember(Member) ->
%% 	DefMember = #member{},
%% 	TrueList = tuple_to_list(DefMember),
%% 	TrueLen = length(TrueList),
%% 	NowList = tuple_to_list(Member),
%% 	NowLen = length(NowList),
%% 	if TrueLen =< NowLen ->
%% 		   Member;
%% 	   true ->
%% 		   list_to_tuple(NowList ++ lists:nthtail(NowLen, TrueList))
%% 	end.
%% 
%% %%校验战斗数据记录
%% chkRBData(RBData) ->
%% 	RBDataTmp = #battleData{},
%% 	TrueList = tuple_to_list(RBDataTmp),
%% 	TrueLen = length(TrueList),
%% 	NowList = tuple_to_list(RBData),
%% 	NowLen = length(NowList),
%% 	if TrueLen =< NowLen ->
%% 		   RBData;
%% 	   true ->
%% 		   list_to_tuple(NowList ++ lists:nthtail(NowLen, TrueList))
%% 	end.
%% 
%% %%校验战斗成员记录（用于对旧数据的兼容，battleMember中新添加字段必须在后面添加）
%% checkBattleMember(BattleMember) ->
%% 	DefBattleMember = #battleMember{},
%% 	TrueList = tuple_to_list(DefBattleMember),
%% 	TrueLen = length(TrueList),
%% 	NowList = tuple_to_list(BattleMember),
%% 	NowLen = length(NowList),
%% 	if TrueLen =< NowLen ->
%% 		   BattleMember;
%% 	   true ->
%% 		   list_to_tuple(NowList ++ lists:nthtail(NowLen, TrueList))
%% 	end.
%% 
%% 
%% 
%% %%根据战斗模式在战斗数据记录#battleData设置人物和宠物的气血及添加宠物阴阳历属性
%% changeHp(RBattleData, WarMode) ->
%% 	BattleMembers = RBattleData#battleData.members,
%% %% 	TrueListLen = length(record_info(fields, battleMember)) + 1,
%% 	FunBattle = fun(BM) ->    %%liujing 2012-3-2添加battleMember记录的ffc战力字段及宠物阴阳历字段容错离线战斗数据
%% %% 						if is_record(BM, battleMember) ->
%% %% 							   BM1 = BM;
%% %% 						   true ->
%% %% 							   BL = tuple_to_list(BM),
%% %% 							   ListLen = length(BL),
%% %% 							   NewBL = BL ++ lists:duplicate(TrueListLen - ListLen - 1, 0) ++ [[]],
%% %% 							   BM1 = list_to_tuple(NewBL)
%% %% 						end,
%% 						BM1 = checkBattleMember(BM),
%% 						case BM1#battleMember.mtype of
%% 							2 ->
%% 								lib_pet2:get_battle_calendar_value(BM1);   %%添加和消除宠物阴阳历属性
%% 							_ ->
%% 								BM1
%% 						end
%% 				end,
%% 	BattleMembers1 = lists:map(FunBattle, BattleMembers),
%% 	RBattleData1 = RBattleData#battleData{members = BattleMembers1},
%% 	case WarMode of
%% 		0 ->
%% 			MList = [M#battleMember{hp = M#battleMember.mxhp}||M <- RBattleData1#battleData.members], 
%% 			RBattleData1#battleData{members = MList};
%% 		1 ->
%% 			RBattleData;
%% 		11 ->  %%失乐园随机事件PVE
%% 			MList = [M#battleMember{hp = M#battleMember.mxhp}||M <- RBattleData1#battleData.members], 
%% 			RBattleData1#battleData{members = MList};
%% 		_ ->
%% 			RBattleData1
%% 	end.	
%% 
%% 
%% %%初始化竞技场玩家战斗数据(优宠卡)  %%新版取消
%% loadLBattleDataTheater(Player, PetList, Frmt) ->
%% 	case Frmt of
%% 		[] ->
%% %% 			Formation = #formation{},
%% 			Formation = #frmt{posl = [{Player#player.id, 1, 5}]},
%% 			List = [{Player#player.id, 1, left, 15, {2,2}}];
%% 		_ ->
%% 			Formation = Frmt, %%changeFrmtRecord(Frmt), 
%% 			List = loadSimpleWarList(left, Formation)
%% 	end,
%% 	PlayerGiant = lib_giant_s:get_act_giant(),      %%新模块调用
%% 	if PlayerGiant =:= [] ->
%% 		   NewPlayerGiant = #ets_giant_s{id = 0};
%% 	   true ->
%% 		   NewPlayerGiant = PlayerGiant
%% 	end,	
%% 	BattleMembers = loadLBattleData1([], Player, List, PetList),
%% 	AddAnger = lib_player:get_add_anger(Player),
%% 	{#battleData{
%% 				 nick = NewPlayerGiant#ets_giant_s.nick,            %%巨兽名称
%% 				 behId = NewPlayerGiant#ets_giant_s.id,     %%巨兽基础ID, 为0表示无
%% 				 behLv = NewPlayerGiant#ets_giant_s.lv,       %%巨兽等级
%% 				 anger = data_battle:get_ini_anger() + AddAnger,         %%巨兽初始怒气
%% 				 maxang = data_giant_s:getGiantMaxAngle(NewPlayerGiant#ets_giant_s.tecid),          %%怒气上限
%% 				 behThId= NewPlayerGiant#ets_giant_s.tecid,        %%巨兽技能ID对应巨兽类型
%% 				 techv = data_giant_s:cpt_tech_power(NewPlayerGiant#ets_giant_s.tecid, NewPlayerGiant#ets_giant_s.teclv),
%% 				 members = BattleMembers,        %%由battleMember记录组成的列表
%% 				 frmtEquipDataR = [],   %%法器数据
%% 				 mntDataR = [],             %%龙鞍数据
%% 				 frsl = NewPlayerGiant#ets_giant_s.frsl,         %%巨兽对阵法的加成属性
%% 				 frlv = NewPlayerGiant#ets_giant_s.frlv,           %%巨兽对阵法加成的等级
%% 				 img = NewPlayerGiant#ets_giant_s.img,            %%巨兽形象
%% 				 qly = NewPlayerGiant#ets_giant_s.qly,                 %%巨兽品质
%% 				 bgid = NewPlayerGiant#ets_giant_s.bgid,               %%巨兽基础ID
%% 				 teclv = NewPlayerGiant#ets_giant_s.teclv,          %%巨兽技能等级
%% 				 myatr = NewPlayerGiant#ets_giant_s.myatr,         %%巨兽对主角的加成属性列表
%% 				 allatr = NewPlayerGiant#ets_giant_s.allatr,        %%巨兽对全队的加成属性列表
%% 				 crr = NewPlayerGiant#ets_giant_s.crr
%% 				}, List, Formation}.
%% 
%% 
%% %%初始化玩家战斗数据（PVP和PVE）
%% loadLBattleData(Player) ->
%% %% 	OpenFormation1 = lib_formation:get_OpenFormation(),
%% %% 	OpenFormation = lib_battle:changeFrmtRecord(OpenFormation1),
%% %% 	List = lib_battle:loadSimpleWarList(left, OpenFormation),
%% 	FormationList = get(frmtInfo),
%% 	case FormationList of
%% 		[] ->
%% %% 			Formation = #formation{},
%% 			Formation = #frmt{posl = [{Player#player.id, 1, 5}]},
%% 			List = [{Player#player.id, 1, left, 15, {2,2}}];
%% 		undefined ->
%% %% 			Formation = #formation{},
%% 			Formation = #frmt{posl = [{Player#player.id, 1, 5}]},
%% 			List = [{Player#player.id, 1, left, 15, {2,2}}];
%% 	    _ ->
%% 			[Formation|_] = [M||M<-FormationList, M#frmt.bopen =:=1],							 %%提取启用的阵法记录#frmt		 
%% %% 		 	Formation = changeFrmtRecord(TempLFormation),              				  %%转化为战斗使用的阵法记录#formation
%% 			List = loadSimpleWarList(left, Formation) 							  %%玩家阵型列表,{id,类型，对战方向，位置序号，位置二维表示}
%% 	end,
%% 	PlayerGiant = lib_giant_s:get_act_giant(),      %%新模块调用
%% 	if PlayerGiant =:= [] ->
%% 		   NewPlayerGiant = #ets_giant_s{id = 0};
%% 	   true ->
%% 		   NewPlayerGiant = PlayerGiant
%% 	end,	
%% 	PetList = get(player_pet),
%% 	BattleMembers = loadLBattleData1([], Player, List, PetList),
%% %% 	Frmt = changeFormationRecord(Formation),
%% %% 	FrmtEquip = get(frmt_equip),
%% %% 	Saddle = get(saddle_data),
%% %% 	case is_record(FrmtEquip, ?ETS_FRMT_EQUIP) of
%% %% 		true ->
%% %% 			case lib_discovery:getDisSw(Player) of
%% %% 				false ->
%% %% 					NowFrmtEquip = [];
%% %% 				_ ->
%% %% 				    NowFrmtEquip = iniBattleFmtEqp(FrmtEquip, Frmt)
%% %% 			end;
%% %% 		_ ->
%% %% 			NowFrmtEquip = []
%% %% 	end,
%% %% 	case is_record(Saddle, ets_saddle) of
%% %% 		true ->
%% %% 			NowSaddle = iniBattleSaddle(Saddle);
%% %% 		_ ->
%% %% 			NowSaddle = []
%% %% 	end,
%% 	AddAnger = lib_player:get_add_anger(Player),
%% 	{#battleData{
%% 				 nick = NewPlayerGiant#ets_giant_s.nick,            %%巨兽名称
%% 				 behId = NewPlayerGiant#ets_giant_s.id,     %%巨兽基础ID, 为0表示无
%% 				 behLv = NewPlayerGiant#ets_giant_s.lv,       %%巨兽等级
%% 				 anger = data_battle:get_ini_anger() + AddAnger,         %%巨兽初始怒气
%% 				 maxang = data_giant_s:getGiantMaxAngle(NewPlayerGiant#ets_giant_s.tecid),          %%怒气上限
%% 				 behThId= NewPlayerGiant#ets_giant_s.tecid,        %%巨兽技能ID对应巨兽类型
%% 				 techv = data_giant_s:cpt_tech_power(NewPlayerGiant#ets_giant_s.tecid, NewPlayerGiant#ets_giant_s.teclv),
%% 				 members = BattleMembers,        %%由battleMember记录组成的列表
%% 				 frmtEquipDataR = [],   %%法器数据
%% 				 mntDataR = [],             %%龙鞍数据
%% 				 frsl = NewPlayerGiant#ets_giant_s.frsl,         %%巨兽对阵法的加成属性
%% 				 frlv = NewPlayerGiant#ets_giant_s.frlv,           %%巨兽对阵法加成的等级
%% 				 img = NewPlayerGiant#ets_giant_s.img,            %%巨兽形象
%% 				 qly = NewPlayerGiant#ets_giant_s.qly,                 %%巨兽品质
%% 				 bgid = NewPlayerGiant#ets_giant_s.bgid,               %%巨兽基础ID
%% 				 teclv = NewPlayerGiant#ets_giant_s.teclv,          %%巨兽技能等级
%% 				 myatr = NewPlayerGiant#ets_giant_s.myatr,         %%巨兽对主角的加成属性列表
%% 				 allatr = NewPlayerGiant#ets_giant_s.allatr,        %%巨兽对全队的加成属性列表
%% 				 crr = NewPlayerGiant#ets_giant_s.crr
%% 				}, List, Formation}.
%% 	
%% 
%% 
%% %%竞技场初始化数据 begin(被打方：right)心魔数据
%% %%初始化玩家战斗数据（PVP和PVE）
%% loadRBattleData(Player,Pet) ->
%% %% 	OpenFormation1 = lib_formation:get_OpenFormation(),
%% %% 	OpenFormation = lib_battle:changeFrmtRecord(OpenFormation1),
%% %% 	List = lib_battle:loadSimpleWarList(left, OpenFormation),
%% 	FormationList = get(frmtInfo),
%% 	case FormationList of
%% 		[] ->
%% %% 			Formation = #formation{},
%% 			Formation = #frmt{posl = [{Player#player.id, 1, 5}]},
%% 			List = [{Player#player.id, 1, left, 15, {2,2}}];
%% 		undefined ->
%% %% 			Formation = #formation{},
%% 			Formation = #frmt{posl = [{Player#player.id, 1, 5}]},
%% 			List = [{Player#player.id, 1, left, 15, {2,2}}];
%% 	    _ ->
%% 			[Formation|_] = [M||M<-FormationList, M#frmt.bopen =:=1],							 %%提取启用的阵法记录#frmt		 
%% %% 		 	Formation = changeFrmtRecord(TempLFormation),              				  %%转化为战斗使用的阵法记录#formation
%% 			List = loadSimpleWarList(right, Formation) 							  %%玩家阵型列表,{id,类型，对战方向，位置序号，位置二维表示}
%% 	end,
%% 	
%% 	PetList = Pet,
%% 	BattleMembers = loadLBattleData1([], Player, List, PetList),
%% 	PlayerGiant = lib_giant_s:get_act_giant(),      %%新模块调用
%% 	if PlayerGiant =:= [] ->
%% 		   NewPlayerGiant = #ets_giant_s{id = 0};
%% 	   true ->
%% 		   NewPlayerGiant = PlayerGiant
%% 	end,	
%% %% 	Frmt = changeFormationRecord(Formation),
%% %% 	FrmtEquip = get(frmt_equip),
%% %% 	Saddle = get(saddle_data),
%% %% 	case is_record(FrmtEquip, ?ETS_FRMT_EQUIP) of
%% %% 		true ->
%% %% 			case lib_discovery:getDisSw(Player) of
%% %% 				false ->
%% %% 					NowFrmtEquip = [];
%% %% 				_ ->
%% %% 				    NowFrmtEquip = iniBattleFmtEqp(FrmtEquip, Frmt)
%% %% 			end;
%% %% 		_ ->
%% %% 			NowFrmtEquip = []
%% %% 	end,
%% %% 	case is_record(Saddle, ets_saddle) of
%% %% 		true ->
%% %% 			NowSaddle = iniBattleSaddle(Saddle);
%% %% 		_ ->
%% %% 			NowSaddle = []
%% %% 	end,
%% 	AddAnger = lib_player:get_add_anger(Player),
%% 	{#battleData{
%% 				 nick = NewPlayerGiant#ets_giant_s.nick,            %%巨兽名称
%% 				 behId = NewPlayerGiant#ets_giant_s.id,     %%巨兽基础ID, 为0表示无
%% 				 behLv = NewPlayerGiant#ets_giant_s.lv,       %%巨兽等级
%% 				 anger = data_battle:get_ini_anger() + AddAnger,         %%巨兽初始怒气
%% 				 maxang = data_giant_s:getGiantMaxAngle(NewPlayerGiant#ets_giant_s.tecid),          %%怒气上限
%% 				 behThId= NewPlayerGiant#ets_giant_s.tecid,        %%巨兽技能ID对应巨兽类型
%% 				 techv = data_giant_s:cpt_tech_power(NewPlayerGiant#ets_giant_s.tecid, NewPlayerGiant#ets_giant_s.teclv),
%% 				 members = BattleMembers,        %%由battleMember记录组成的列表
%% 				 frmtEquipDataR = [],   %%法器数据
%% 				 mntDataR = [],             %%龙鞍数据
%% 				 frsl = NewPlayerGiant#ets_giant_s.frsl,         %%巨兽对阵法的加成属性
%% 				 frlv = NewPlayerGiant#ets_giant_s.frlv,           %%巨兽对阵法加成的等级
%% 				 img = NewPlayerGiant#ets_giant_s.img,            %%巨兽形象
%% 				 qly = NewPlayerGiant#ets_giant_s.qly,                 %%巨兽品质
%% 				 bgid = NewPlayerGiant#ets_giant_s.bgid,               %%巨兽基础ID
%% 				 teclv = NewPlayerGiant#ets_giant_s.teclv,          %%巨兽技能等级
%% 				 myatr = NewPlayerGiant#ets_giant_s.myatr,         %%巨兽对主角的加成属性列表
%% 				 allatr = NewPlayerGiant#ets_giant_s.allatr,        %%巨兽对全队的加成属性列表
%% 				 crr = NewPlayerGiant#ets_giant_s.crr
%% 				}, List, Formation}.
%% 	
%% 
%% %%竞技场初始化 end
%% 
%% 
%% 
%% 
%% 
%% 
%% %% add by chenzm for team begin=====================
%% loadLBattleMember(Player,PetId) ->
%% 	PetList = [ Pet || Pet <- get(player_pet), Pet#pet2.id =:= PetId] ,
%% 	LList = [{Player#player.id, 1, left, 15, {2,2}}] ,   			%% 15, {2,2}为调后面函数拼的，无实际用途
%% 	case PetList of 
%% 		[Pet | _] when is_record(Pet,pet2) ->
%% 			LeftList = LList ++ [{PetId, 2, left, 15, {3,2}}] ;    	%% 15, {2,2}为调后面函数拼的，无实际用途
%% 		_ ->
%% 			LeftList = LList 
%% 	end ,
%% 	loadLBattleData1([], Player, LeftList, PetList).
%% %% add by chenzm for team end=====================
%% 
%% 
%% loadLBattleData1(MemberList, _Player, [], _PetList) ->
%% 	MemberList;
%% 
%% loadLBattleData1(MemberList, Player, Left_List, PetList) ->
%% 	[{Id, Type, _Direct, _Pst, _Pstlt}|LastL] = Left_List,	
%% 	case Type of
%% 		1 ->
%% 			case get(player_skill) of
%% %% 				PlayerSkill when is_record(PlayerSkill, skill) ->
%% %% 					SkillId = PlayerSkill#skill.sklnw;
%% 				[] ->
%% 					SkillId = data_battle:getPSkillFromCrr(Player#player.crr);
%% 				undefined ->
%% 					SkillId = data_battle:getPSkillFromCrr(Player#player.crr);
%% 				PlayerSkill ->
%% 					case PlayerSkill#skill.sklnw of
%% 						0 ->
%% 							SkillId = data_battle:getPSkillFromCrr(Player#player.crr);
%% 						_ ->
%% 							SkillId = PlayerSkill#skill.sklnw
%% 					end
%% 			end,
%% 
%% 			BMember = #battleMember{
%% 								id = Id,                    %%战斗角色id	
%% 					            nick = Player#player.nick,                  %%名称              
%% 					            crr = Player#player.crr,                   %%职业              
%% 					            mtype = Type,                 %%战斗角色类型（1:人物,2:宠物
%% 					            race = 0,                  %%种族ID            
%% 					            lv = Player#player.lv,                    %%等级          
%% 								%% add by chenzm for boss begin
%% 					  			frhp=Player#player.hp,                  %%一轮战斗的初始气血
%% 				      			defender=0,				  				%%是否是守护者 0 - 否，1 - 是    
%% 				      			%% add by chenzm for boss end    
%% 					            hp = Player#player.hp,                   %%气血               
%% 					            mxhp = Player#player.mxhp,                %%最大气血              
%% 					            mana = Player#player.mana,                 %%气势               
%% 								mnup = Player#player.mnup,                 %%气势增加值
%% 					            mxmn = 100,               %%触发绝技的气势值           
%% 					            sklid = SkillId,    %%data_battle:get_skill(Player#player.crr),  %%测试，临时取消：SkillId,    %%绝技id           
%% 					            %%skllv = Player#player.skllv,      			%%绝技等级                 
%% 					            pwr = Player#player.pwr,                   %%内功              
%% 					            tech = Player#player.tech,                  %%技法              
%% 					            mgc = Player#player.mgc,                  %%法力               
%% 					            hit = Player#player.hit,                   %%命中              
%% 					            crit = Player#player.crit,                   %%暴击             
%% 					            ddge = Player#player.ddge,                  %%闪避              
%% 					            blck = Player#player.blck,                   %%格挡             
%% 					            cter = Player#player.cter,                   %%反击             
%% 					            dbas = Player#player.other#player_other.baseDef,                   %%基础防御           
%% 					            dpwr = Player#player.dpwr,                  %%内功防御            
%% 					            dtech = Player#player.dtech,                 %%技法防御            
%% 					            dmgc = Player#player.dmgc,                 %%法力防御             
%% 					            abas = Player#player.other#player_other.baseAtt,					 %%基础攻击                    
%% 					            apwr = Player#player.apwr,                  %%内力攻击            
%% 					            atech = Player#player.atech,                 %%技法攻击            
%% 					            amgc = Player#player.amgc,                  %%法力攻击            
%% 					            roll = 0,					 %%碾压                      
%% 					            rela = 0,           		 %%亲密度               
%% 					            dcrit = Player#player.dcrit,                 %%防暴击             
%% 					            dblck = Player#player.dblck,                  %%破格挡 
%% 								icon = Player#player.img,  %%形象ID       
%% 								sex = Player#player.sex,     %%性别
%% 								ffc = lib_player:force_att(Player), %%战力
%% 								qly = 0,                             %%品质（宠物专用）
%% 								proty = Player#player.speed,         %%data_battle:get_speed(Player#player.crr),  %%测试临时使用
%% 								pasid = data_battle:get_pos_pas_skill(Player#player.crr),  %%测试临时使用              %%被动技能id
%% 					  			paslv = 0                 %%被动技能等级
%% 								   },
%% 			BMemberL = [BMember];
%% 		2 ->
%% 			case PetList of 
%% 				undefined -> 
%% 					BMemberL = [];
%% 				PetList1 when is_list(PetList1) ->
%% 					case [M||M<-PetList1, M#pet2.id =:= Id] of
%% 						[] ->
%% 							BMemberL = [];
%% 						[PetMember] ->
%% %% 							Quality = PetMember#pet2.qly,
%% %% 							PwrLv = 0,%data_pet:get_upgrade_level(PetMember#pet.pwn, Quality),
%% %% 							MgcLv = 0,%data_pet:get_upgrade_level(PetMember#pet.mgn, Quality),
%% %% 							TechLv = 0,%data_pet:get_upgrade_level(PetMember#pet.tcn, Quality),
%% %% 							AtrLv = PwrLv + MgcLv + TechLv,
%% 							TlidL = [],%[Tlid||Tlid<-[PetMember#pet.tlid, PetMember#pet.tlid1, PetMember#pet.tlid2], Tlid =/= 0],
%% 							BMember = #battleMember{
%% 													id = Id,                    %%战斗角色id	
%% 							            			nick = PetMember#pet2.nick,                  %%名称              
%% 							            			crr = PetMember#pet2.crr,                   %%职业              
%% 							            			mtype = Type,                 %%战斗角色类型（1:人物,2:宠物）
%% 							            			race = PetMember#pet2.race,                  %%种族ID            
%% 							            			lv = PetMember#pet2.lv,                    %%等级    
%% 													%% add by chenzm for boss begin
%% 					  								frhp=PetMember#pet2.hp,
%% 				      								defender=0,				  				%%是否是守护者 0 - 否，1 - 是    
%% 				      								%% add by chenzm for boss end              
%% 							            			hp = PetMember#pet2.hp,                   %%气血               
%% 							            			mxhp = PetMember#pet2.other#pet_other.mxhp,                %%最大气血              
%% 							            			mana = PetMember#pet2.other#pet_other.mana,                 %%气势       
%% 													mnup = PetMember#pet2.other#pet_other.mnup,                 %%气势增加值        
%% 							            			mxmn = 100,               %%触发绝技的气势值           
%% 							            			sklid = PetMember#pet2.teid,        %%data_battle:get_skill(PetMember#pet.crr), %%测试，临时取消： PetMember#pet.teid,        %%绝技id           
%% 							            			skllv = 1,      			                %%绝技等级                 
%% 							            			pwr = 0,%PetMember#pet.other#pet_other.pwr,                   %%内功              
%% 							            			tech = 0,%PetMember#pet.other#pet_other.tech,                  %%技法              
%% 							            			mgc = 0,%PetMember#pet.other#pet_other.mgc,                  %%法力               
%% 							            			hit = PetMember#pet2.other#pet_other.hit,                   %%命中              
%% 							            			crit = PetMember#pet2.other#pet_other.crit,                   %%暴击             
%% 							            			ddge = PetMember#pet2.other#pet_other.ddge,                  %%闪避              
%% 							            			blck = PetMember#pet2.other#pet_other.blck,                   %%格挡             
%% 							            			cter = PetMember#pet2.other#pet_other.cter,                   %%反击             
%% 							            			dbas = 0,%PetMember#pet.other#pet_other.dbas,                   %%基础防御           
%% 							            			dpwr = PetMember#pet2.other#pet_other.dpwr,                  %%内功防御            
%% 							            			dtech = PetMember#pet2.other#pet_other.dtech,                 %%技法防御            
%% 							            			dmgc = PetMember#pet2.other#pet_other.dmgc,                 %%法力防御             
%% 							            			abas = 0,%PetMember#pet.other#pet_other.abas,					 %%基础攻击                    
%% 							            			apwr = PetMember#pet2.other#pet_other.apwr,                  %%内力攻击            
%% 							            			atech = PetMember#pet2.other#pet_other.atech,                 %%技法攻击            
%% 							            			amgc = PetMember#pet2.other#pet_other.amgc,                  %%法力攻击            
%% 							            			roll = 0,					 %%碾压                      
%% 							            			rela = PetMember#pet2.rela,           		 %%亲密度               
%% 							            			dcrit = PetMember#pet2.other#pet_other.dcrit,                 %%防暴击             
%% 							            			dblck = PetMember#pet2.other#pet_other.dblck,                  %%破格挡 
%% 													icon = PetMember#pet2.icon,                     %%形象ID
%% 												    ffc = 0,                                      %%战力
%% 													qly = PetMember#pet2.qly,                       %%品质
%% %% 													%% 宠物阴阳历 begin
%% 													copen = PetMember#pet2.copen,              %% 是否开启阴阳历
%% 													ctm = PetMember#pet2.ctm,				  %%变身时间
%% 													csta = PetMember#pet2.csta,                 %%是否变身
%% 													cont = PetMember#pet2.cont,             %% 变身属性  [{Buff1, Value1}, {Buff2, Value2}...]
%% %% 												    %% 宠物阴阳历  end
%% 													tlidl = TlidL,                          %%宠物天赋基础ID列表
%% 													atrlv = PetMember#pet2.star,                           %%宠物总阶数
%% 													proty = PetMember#pet2.other#pet_other.speed,            %%data_battle:get_speed(PetMember#pet.crr),  %%测试临时使用
%% 													pasid = PetMember#pet2.teid1,            %%data_battle:get_pas_skill(PetMember#pet.crr), %%测试临时使用               %%被动技能id
%% 					  								paslv = 0                 %%被动技能等级
%% 												   },
%% 							BMemberL = [BMember]
%% 					end;	
%% 				_ ->
%% 					BMemberL = []
%% 			end;
%% 		_ ->
%% 			BMemberL = []
%% 	end,
%% 	MemberList1 = MemberList ++ BMemberL,
%% 	loadLBattleData1(MemberList1, Player, LastL, PetList).
%% 
%% %%判定是否有巨兽，
%% %%返回巨兽的打包数据
%% checkGiand(Battle_record, Direct) ->
%% 	case Battle_record#battle_record.behId of
%% 		0 ->
%% 			{0, <<>>};
%% 		_ ->
%% 			Id = Battle_record#battle_record.behId,
%% 			NickBin = tool:to_binary(Battle_record#battle_record.nick),
%%     		NickLen = byte_size(NickBin),
%% 			Pst = Direct,
%% 			MaxAng = Battle_record#battle_record.maxang,
%% 			Anger = Battle_record#battle_record.anger,
%% %% 			io:format("======checkGiand Anger:~p~n",[[Id,Battle_record#battle_record.nick,Anger,Direct]]) ,
%% 			TechId = Battle_record#battle_record.behThId,  %%data_giant:get_giant_tech_id(Battle_record#battle_record.behThId),
%% 			IconId = Battle_record#battle_record.img,      %%data_giant:get_giant_icon_id(Battle_record#battle_record.behThId),
%% %% 			io:format("======checkGiand Anger:~p~n",[[Id,Battle_record#battle_record.nick,Anger,Direct, TechId, IconId]]) ,
%% 			GiandBin = <<Id:32, NickLen:16, NickBin/binary, Pst:8, MaxAng:16, Anger:16, TechId:32, IconId:32>>,
%% 			{1, GiandBin}
%% 	end.
%% %%战斗结束后更新人物及宠物的气血
%% updateRoleHp(Player, Battle_record) ->
%% 	Members = Battle_record#battle_record.members,
%% 	[PMember|_] = lists:filter(fun(M) -> M#member.mtype =:= 1 end, Members),
%% 	NewHp = checkHp(PMember#member.hp),
%% 	Status1 = Player#player{hp = NewHp},
%% 	PetMembers = lists:filter(fun(M1) -> M1#member.mtype =:= 2 end, Members),
%% %% 	io:format("~s updateRoleHp[~p] \n ",[misc:time_format(now()), PetMembers]),
%% 	case PetMembers of
%% 		[] ->
%% 			skip;
%% 		_ ->			
%% 			Fun = fun(PM) ->
%% 						  NewHp1 = checkHp(PM#member.hp),
%% %% 						  io:format("~s updatePetHp[~p][~p] \n ",[misc:time_format(now()),PM#member.id, NewHp1]),
%% 						  _X1 = lib_pet2:update_pet_hp(PM#member.id, NewHp1)
%% %% 						  io:format("~s updatePetHp1[~p][~p] \n ",[misc:time_format(now()),PM#member.id, _X])
%% 				  end,
%% 			_X = lists:foreach(Fun, PetMembers)
%% 	end,
%% 	
%% 	Status1.
%% 
%% 
%% %%判定气血是否为0，如果是设置为最低血量
%% checkHp(Hp) ->
%% %% 	io:format("~s checkHp[~p] \n ",[misc:time_format(now()), Hp]),
%% 	if Hp =< 0 ->
%% 		   1;
%% %% 		   ?LIMIT_HP;
%% 	   true ->
%% 		   Hp
%% 	end.
%% 
%% %%战斗胜利后更新战斗角色的属性（EXP,铜钱,元宝,亲密度,体力）-包括人物和 宠物
%% updateRoleAtr(Player, Battle_record, Exp, Coin, Gold, Goth, DungMonType, _DungName) ->
%% 	Members = Battle_record#battle_record.members,
%% %% 	NewCoinT = Player#player.coin + Coin,
%% 	if Coin > 0 ->
%% 		   TmpPlayer = lib_goods:add_money(Player, Coin, coin, 2002);
%% %% 		   NewCoin = NewCoinT;
%% 	   true ->
%% 		   TmpPlayer = Player
%% %% 		   NewCoin = 0
%% 	end,
%% %% 	NewGoldT = Player#player.gold + Gold,
%% 	if Gold > 0 ->
%% %% 		   Msg = io_lib:format("<font color='#fee400'><b>通告</b></font>    <a href='event:name_~p,~s'><font color='#FFD800'><u>~s</u></font></a>在~s副本获得<font color='#FF6C00'>~p</font>元宝。", 
%% %% 							   [Player#player.id, Player#player.nick, Player#player.nick, DungName, Gold]),
%% %% 		   if
%% %% 			   DungMonType =:= 2 ->			%%当玩家精英副本获得元宝，聊天框发送广播时，需要添加“前往探险”链接, 11080协议中的type改为104
%% %% 				   lib_chat:broadcast_sys_msg(104, Msg);
%% %% 			   true ->
%% %% 				   lib_chat:broadcast_sys_msg(1, Msg)
%% %% 		   end,
%% 		   Status1 = lib_goods:add_money(TmpPlayer, Gold, gold, 2002);
%% %% 		   NewGold = NewGoldT;
%% 	   true ->
%% 		   Status1 = TmpPlayer
%% %% 		   NewGold = 0
%% 	end,
%% %% 	Status1 = Player#player{
%% %% 							coin = NewCoin,
%% %% 							gold = NewGold
%% %% 							},	
%% 	Status2 = lib_player:add_exp(Status1, Exp, 0, 0),
%% %% 	gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%% %% 	io:format("~s updateRoleAtr   [~p] \n ",[misc:time_format(now()), Status2#player.eng]),
%% 	DungEng = data_player:get_dung_eng(DungMonType),
%% %% 	if Status2#player.eng > DungEng ->
%% %% 		   NewEngine = Status2#player.eng - DungEng;
%% %% 	   true ->
%% %% 		   NewEngine = 0
%% %% 	end,
%% %% 	Status3 = Status2#player{eng = NewEngine},
%% 	Status3 = lib_player:cost_energy(Status2#player{goth = Status2#player.goth + Goth}, DungEng, 2001),
%% 	lib_player:send_player_attribute(Status3, 3),
%% 	PetMembers = lists:filter(fun(M1) -> M1#member.mtype =:= 2 end, Members),
%% 	case PetMembers of
%% 		[] ->
%% 			skip;
%% 		_ ->			
%% 			Fun = fun(PM) ->						  
%% 						  %OldPet = lib_pet2:get_own_pet(Player#player.id, PM#member.id),
%% 						  %NewRela = OldPet#pet2.rela + 100,
%% 						  %_X1 = lib_pet2:update_pet_rela(PM#member.id, NewRela),
%% 						  _X2 = lib_pet2:add_pet_exp(Status3, PM#member.id, Exp)
%% 				  end,
%% 			_Y = lists:foreach(Fun, PetMembers)
%% 	end,
%% 	Status3.
%% 
%% 
%% %%获取受攻击玩家名
%% getRPlayerName(RightId, ReRight_battle_record) ->
%% 	case [M#member.nick||M<-ReRight_battle_record#battle_record.members, M#member.id =:= RightId andalso M#member.mtype =:= 1] of
%% 		[] ->
%% 			"";
%% 		[RName] ->
%% 			RName;
%% 		_ ->
%% 			""
%% 	end.
%% 
%% %%保存战斗分享数据到进程字典({LeftId, LName, RightId, RName, WarMode, BattleBin})
%% putShareBattle(LeftId, LName, RightId, RName, WarMode, BattleBin) ->
%% 	put(sharebattlebin, {LeftId, LName, RightId, RName, WarMode, BattleBin}).
%% 
%% %%执行战斗分享，获取进程字典中的战斗分享数据，存入数据库，返回ID
%% doShareBattle() ->
%% 	case get(sharebattlebin) of
%% 		BattleBinData when is_tuple(BattleBinData) ->
%% 			{_LeftId, LName, _RightId, RName, _WarMode, _BattleBin} = BattleBinData,
%% 			Id = db_agent_battle:insertBattleShareData(BattleBinData),
%% 			put(sharebattlebin, []),
%% 			{Id, LName, RName};
%% 		_ ->
%% 			error
%% 	end.
%% 			
%% 
%% %%计算怪物数量(MonList-[monid,..])
%% cptMonNum(MonList) ->
%% 	MinList = lists:usort(MonList),
%% 	F = fun(M) ->
%% 				TmpList = [AM || AM <- MonList, AM =:= M],
%% 				Num = length(TmpList),
%% 				{M, Num}
%% 		end,
%% 	lists:map(F, MinList).
%% 
%% 
%% %% add by chenzhm for boss begin
%% %% spec get_boss_hurt -> int
%% %% 计算BOSS 伤害血量
%% get_boss_hurt(Battle_record) ->
%% 	Members = Battle_record#battle_record.members,
%% 	[BossMember | _] = lists:filter(fun(M) -> M#member.mtype =:= 3 end, Members),
%% 	BossMember#member.frhp - BossMember#member.hp .
%% 	
%% %% 计算守护者伤害血量
%% %% spec get_defender_hurt -> [{id,type,hurtvalue}]
%% get_defender_hurt(Battle_record) ->
%% 	Members = Battle_record#battle_record.members ,
%% 	HurtList = 
%% 		lists:map(fun(M) ->
%% 						  HurtValue = M#member.frhp - M#member.hp ,
%% 						  {M#member.id,M#member.mtype,HurtValue,M#member.mxhp}
%% 				  end,Members) ,
%% 	NowAnger = Battle_record#battle_record.anger ,
%% 	[NowAnger,HurtList] .
%% 
%% %% add by chenzhm for boss end
%% 
%% %%计算双方各自的剩余气血总和
%% cptBattleLostAllHp(Battle_Record) ->
%% 	Fun = fun(RoleMember, AllMaxHp) ->
%% 				  AllMaxHp + RoleMember#member.hp
%% 		  end,
%% 	lists:foldl(Fun, 0, Battle_Record#battle_record.members).
%% 
%% 
%% 
%% %%计算双方各自的气血总和
%% cptBattleAllHp(Battle_Record) ->
%% %% 	io:format("cptBattleAllHp_____~p \n",[Battle_Record]),
%% 	Fun = fun(RoleMember, AllMaxHp) ->
%% 				  AllMaxHp + RoleMember#member.mxhp
%% 		  end,
%% 	lists:foldl(Fun, 0, Battle_Record#battle_record.members).
%% 
%% %%计算增加怒气值
%% cptAngerVal(HurtHp, AllHp) ->
%% %% 	io:format("cptAngerVal-~p ~p~n",[HurtHp, AllHp]),
%% 	round((HurtHp * 100 / AllHp) * 1.5).
%% 
%% %%PVE战斗评级（1-完胜，2-大胜，3-胜利，4-小胜，5-险胜，6-惜败，7-小败，8-战败，9-溃败，10-完败）
%% battleScore(BattleRe, Battle_Record) ->
%% 	Fun = fun(RoleMember, [AllHp, AllMaxHp]) ->
%% 				  [AllHp + RoleMember#member.hp, AllMaxHp + RoleMember#member.mxhp]
%% 		  end,
%% 	[NewAllHp, NewAllMaxHp] = lists:foldl(Fun, [0, 0], Battle_Record#battle_record.members),
%% 	HpRatio = abs(round(NewAllHp * 100 / NewAllMaxHp)),
%% 	case BattleRe of
%% 		1 ->    %%战斗胜利
%% 			if  
%% 				HpRatio =< 20 -> 1;
%% 				HpRatio =< 40 -> 2;
%% 				HpRatio =< 60 -> 3;
%% 				HpRatio =< 80 -> 4;
%% 				true          -> 5
%% 			end;
%% 		2 ->   %%战斗失败
%% 			0;
%% %% 			if 
%% %% 				HpRatio =< 199 -> 6;
%% %% 				HpRatio =< 399 -> 7;
%% %% 				HpRatio =< 599 -> 8;
%% %% 				HpRatio =< 799 -> 9;
%% %% 				true           -> 10
%% %% 			end;
%% 		_ ->
%% 			0
%% 	end.
%% 
%% %%PVE战斗评级（1-完胜，2-大胜，3-胜利，4-小胜，5-险胜，6-惜败，7-小败，8-战败，9-溃败，10-完败）
%% get_score_level(LeftHp,TotalHp) ->
%% 	HpRatio = abs(round(LeftHp * 100 / TotalHp)),
%% 	if  
%% 		HpRatio =< 20 -> 1;
%% 		HpRatio =< 40 -> 2;
%% 		HpRatio =< 60 -> 3;
%% 		HpRatio =< 80 -> 4;
%% 		true          -> 5
%% 	end.
%% 			
%% %%计算精英BOSS抽奖新规则（刘菁 2012-1-19修改）
%% cptBossAwardNew(OldGoodsList) ->
%% 	GoodsNum = length(OldGoodsList),
%% 	if GoodsNum > 0 ->
%% 		   GetRationNum = util:rand(1, GoodsNum),
%% 		   Award = lists:nth(GetRationNum, OldGoodsList),
%% 		   [Award];
%% 	   true ->
%% 		   []
%% 	end.
%% 
%% %%计算精英BOSS抽奖
%% cptBossAward(OldGoodsList) ->
%% 	Fun = fun(GoodsM3, GoodsM4) ->
%% 				  {_GoodsId3, GoodsR3, _MinNum3, _MaxNum3} = GoodsM3,
%% 				  {_GoodsId4, GoodsR4, _MinNum4, _MaxNum4} = GoodsM4,
%% 				  GoodsR3 < GoodsR4
%% 		  end,
%% 	GoodsList = lists:sort(Fun, OldGoodsList),
%% 	Fun1 = fun({_GoodsId1, GoodsR1, _MinNum1, _MaxNum1}, RatioNum1) ->
%% 				   RatioNum1 + GoodsR1
%% 		   end,
%% 	AllRationNum = lists:foldl(Fun1, 0, GoodsList),
%% 	BigAllRationNum = AllRationNum,  %%* 100, 已修改，数据库已修改概率，放大了100倍     2012-1-18
%% 	GetRationNum = util:rand(1, BigAllRationNum),
%% 	Fun2 = fun({GoodsId2, GoodsR2, MinNum2, MaxNum2}, [BGet, Ra, FirstNum, GetGoodsList]) ->
%% 				   BigRatioNum = GoodsR2,            %%* 100,  已修改，数据库已修改概率，放大了100倍     2012-1-18
%% 				   EndNum = FirstNum + BigRatioNum,
%% 				   if BGet =:= 0 andalso Ra =< EndNum ->
%% 						  [1, Ra, EndNum, [{GoodsId2, GoodsR2, MinNum2, MaxNum2}]];
%% 					  true ->
%% 						  [BGet, Ra, EndNum, GetGoodsList]
%% 				   end
%% 		   end,
%% %% 	lists:foldl(Fun2, [0, GetRationNum, 0, []], GoodsList).
%% 	[_NewBGet, _NewRa, _FirstNum, NewGetAwardList] = lists:foldl(Fun2, [0, GetRationNum, 0, []], GoodsList),
%% 	NewGetAwardList.
%% 				
%% %%计算精英BOSS战斗胜利后的物品奖励列表（5个）
%% cptBossAwardList(GoodsList) ->
%% 	{RGoodsList, LoseGoodsList} = cptBossAwardList1(GoodsList, [], GoodsList, 0),
%% 	RGoodsNum = length(RGoodsList),
%% 	if RGoodsNum >= 5 ->
%% 		   RGoodsList;
%% 	   true ->
%% 		   Fun = fun(GoodsM1, GoodsM2) ->
%% 						 {_GoodsId1, GoodsR1, _MinNum1, _MaxNum1} = GoodsM1,
%% 						 {_GoodsId2, GoodsR2, _MinNum2, _MaxNum2} = GoodsM2,
%% 						 GoodsR1 > GoodsR2
%% 				 end,
%% 		   SortLoseGoodsList = lists:sort(Fun, LoseGoodsList),
%% 		   AddRGoodsList = lists:sublist(SortLoseGoodsList, 5 - RGoodsNum),
%% 		   RGoodsList ++ AddRGoodsList
%% 	end.
%% 						 
%% %%cptBossAwardList辅助尾递归函数
%% cptBossAwardList1([], RGoodsList, LoseGoodsList, _RGoodsNum) ->
%% 	{RGoodsList, LoseGoodsList};
%% 
%% cptBossAwardList1(_GoodsList, RGoodsList, LoseGoodsList, 5) ->
%% 	{RGoodsList, LoseGoodsList};
%% 	
%% cptBossAwardList1(GoodsList, RGoodsList, LoseGoodsList, RGoodsNum) ->
%% 	[GoodsM | SubGoodsList] = GoodsList,
%% 	{_GoodsId, GoodsR, _MinNum, _MaxNum} = GoodsM,
%% 	GoodsRNow = GoodsR,     %% * 100,  已修改，数据库已修改概率，放大了100倍     2012-1-18
%% 	RatioGet = util:rand(1, 10000),
%% 	if RatioGet =< GoodsRNow ->
%% 		   NewRGoodsList = RGoodsList ++ [GoodsM],
%% 		   NewLoseGoodsList = LoseGoodsList -- [GoodsM],
%% 		   NewRGoodsNum = RGoodsNum + 1,
%% 		   cptBossAwardList1(SubGoodsList, NewRGoodsList, NewLoseGoodsList, NewRGoodsNum);
%% 	   true ->
%% 		   cptBossAwardList1(SubGoodsList, RGoodsList, LoseGoodsList, RGoodsNum)
%% 	end.
%% 
%% %%计算玩家的攻击评价
%% cptPlayerActGrade(PlayerBattleScore, Mon_battle_record) ->
%% 	MonMembers = Mon_battle_record#battle_record.members,
%% 	Fun = fun(Member, AllMaxHp) ->
%% 				  AllMaxHp + Member#member.mxhp
%% 		  end,
%% 	AllMonMaxHp = lists:foldl(Fun, 0, MonMembers),
%% 	if AllMonMaxHp > 0 andalso PlayerBattleScore#battleScore.score_round > 0 ->
%% 		   ActScore = round((PlayerBattleScore#battleScore.score_player_hurt * 100) / AllMonMaxHp); %%(PlayerBattleScore#battleScore.score_round * AllMonMaxHp));
%% 	   true ->
%% 		   ActScore = 0
%% 	end,
%% 	if ActScore < 110 ->
%% 		   1;
%% 	   ActScore < 120 ->
%% 		   2;
%% 	   ActScore < 130 ->
%% 		   3;
%% 	   ActScore < 140 ->
%% 		   4;
%% 	   true ->
%% 		   5
%% 	end.
%% %% 	if ActScore < 20 ->
%% %% 		   1;
%% %% 	   ActScore < 30 ->
%% %% 		   2;
%% %% 	   ActScore < 46 ->
%% %% 		   3;
%% %% 	   ActScore < 70 ->
%% %% 		   4;
%% %% 	   true ->
%% %% 		   5
%% %% 	end.
%% 
%% %%计算玩家的防守评价
%% cptPlayerDefGrade(Player_battle_record) ->
%% 	RoleMembers = Player_battle_record#battle_record.members,
%% 	Fun = fun(Member, {AllHp, AllMaxHp}) ->
%% 				  {AllHp + Member#member.hp, AllMaxHp + Member#member.mxhp}
%% 		  end,
%% 	{AllRoleHp, AllRoleMaxHp} = lists:foldl(Fun, {0, 0}, RoleMembers),
%% 	if AllRoleMaxHp > 0 ->
%% 		   DefScore = round(AllRoleHp * 100 / AllRoleMaxHp);
%% 	   true ->
%% 		   DefScore = 0
%% 	end,
%% 	if DefScore < 20 ->
%% 		   1;
%% 	   DefScore < 40 ->
%% 		   2;
%% 	   DefScore < 60 ->
%% 		   3;
%% 	   DefScore < 80 ->
%% 		   4;
%% 	   true ->
%% 		   5
%% 	end.	
%% 	
%% %%计算玩家的人品评价
%% cptPlayerLuckGrade(PlayerBattleScore) ->
%% 	LuckScore = round(PlayerBattleScore#battleScore.score_player_luck - PlayerBattleScore#battleScore.score_mon_luck),
%% 	if LuckScore =< 1 ->
%% 		   1;
%% 	   LuckScore =:= 2 ->
%% 		   2;
%% 	   LuckScore =< 4 ->
%% 		   3;
%% 	   LuckScore =< 6 ->
%% 		   4;
%% 	   true ->
%% 		   5
%% 	end.
%% 
%% %%判定是否开启精英副本奖励抽奖（针对PVE战斗）
%% checkOpenBossAward(DungMonType) ->
%% 	case DungMonType of
%% 		2 ->
%% 			2;
%% 		_ ->
%% 			1
%% 	end.
%% 
%% %%获取每种角色类型的总个数(All_List为战斗序列)
%% getRoleNum(LBattleR, RBattleR) ->
%% 	AllMembers = LBattleR#battle_record.members ++ RBattleR#battle_record.members,
%% 	Pos_List = [M#member.id||M<-AllMembers, M#member.mtype =:= 1],
%% 	Pet_List = [M1#member.id||M1<-AllMembers, M1#member.mtype =:= 2 andalso M1#member.hp > 0],
%% 	Mon_List = [M2#member.id||M2<-AllMembers, M2#member.mtype =:= 3 andalso M2#member.hp > 0],
%% %% 	Pos_List = [{_G1,G2,_G3,_G4,_G5}||{_G1,G2,_G3,_G4,_G5}<-All_List, G2 =:= 1],
%% %% 	Pet_List = [{_H1,H2,_H3,_H4,_H5}||{_H1,H2,_H3,_H4,_H5}<-All_List, H2 =:= 2],
%% %% 	Mon_List = [{_I1,I2,_I3,_I4,_I5}||{_I1,I2,_I3,_I4,_I5}<-All_List, I2 =:= 3],
%% 	{length(Pos_List), length(Pet_List), length(Mon_List)}.
%% 
%% %%对战斗记录添加阵法相克属性
%% addRstArt(BattleRecord, RstFL) ->
%% 	case RstFL of
%% 		[] ->
%% 			BattleRecord;
%% 		_ ->
%% 			Fun = fun(M) ->
%% 						  get_member_restraint_data(M, RstFL)									%%加载相克加成后玩家的属性
%% %% 						  get_member_Probability(M1)                                             %%将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 				  end,
%% 			NewMembers = lists:map(Fun, BattleRecord#battle_record.members),
%% 			BattleRecord#battle_record{members = NewMembers}
%% 	end.
%% 	
%% %%打包战斗角色初始化数据
%% binRole(BattleRecord, {Bin_Pos, Bin_Pet, Bin_Mon}) ->
%% 	Fun = fun(M, {Bin1, Bin2, Bin3}) ->
%% 				  Bin = binMember(M),
%% 				  case M#member.mtype of
%% 					  1 ->
%% 						  {<<Bin1/binary, Bin/binary>>, Bin2, Bin3};
%% 					  2 ->
%% 						  {Bin1, <<Bin2/binary, Bin/binary>>, Bin3};
%% 					  3 ->
%% 						  {Bin1, Bin2, <<Bin3/binary, Bin/binary>>};
%% 					  _ ->
%% 						  {Bin1, Bin2, Bin3}
%% 				  end
%% 		  end,
%% 	lists:foldl(Fun, {Bin_Pos, Bin_Pet, Bin_Mon}, BattleRecord#battle_record.members).
%% 				  
%% %%用新的战斗记录替换原有战斗记录的部分属性（这里只需要替换怒气值和成员血量）
%% putArt(OldBattleRecord, NewBattleRecord, BattleFlag) ->
%% 	case BattleFlag of
%% 		0 ->    %%替换怒气值和成员血量
%% 			Fun = fun(M) ->
%% 						  case [M1 || M1 <- NewBattleRecord#battle_record.members, (M1#member.pst rem 10)  =:= (M#member.pst rem 10)] of
%% 							  [] ->
%% 								  M;
%% 							  [M2|_] ->
%% 								  M#member{hp = M2#member.hp,
%% 										   pascan = M2#member.pascan}
%% 						  end
%% 				  end,
%% 			NewMembers = lists:map(Fun, OldBattleRecord#battle_record.members),
%% 			OldBattleRecord#battle_record{
%% 										  members = NewMembers,
%% 										  anger = NewBattleRecord#battle_record.anger
%% 										  };
%% 		1 ->    %%完全使用新的battle_record(如多人副本)，初始速度还原
%% 			Fun = fun(M) ->
%% 						  M#member{fulltime = data_battle:get_proty_time(M#member.proty)}
%% 				  end,
%% 			NewMembers = lists:map(Fun, NewBattleRecord#battle_record.members),
%% 			NewBattleRecord#battle_record{members = NewMembers};
%% 		_ ->
%% 			NewBattleRecord
%% 	end.
%% 
%% %%初始化玩家自己的battle_record（循环战斗初始数据使用）
%% iniMyBRLoop(Player) ->
%% 	{BattleData, _List, Formation} = loadLBattleData(Player),
%% 	iniPosBRLoop(Player#player.id, BattleData, Formation, 0).
%% 	
%% 
%% %%初始化人物的battle_record(除阵法相克属性加成以外，并不用封包数据，循环战斗初始数据使用)，这里的方向不会影响，因为在循环战斗handingLoop函数里会做转换
%% iniPosBRLoop(PlayerId, BattleData, Formation, WarMode) ->
%% 	case Formation of
%% 		Val when is_record(Val, frmt) andalso Val =/= #frmt{} ->
%% 			Formation1 = Formation,
%% 			List = lib_battle:loadSimpleWarList(left, Formation1);  %%这里的left或right只是个临时数据当不得真（为了函数需要，后续战斗运算时会根据实际方位修改的）
%% 		_ ->
%% %% 			Formation1 = #formation{},
%% 			Formation1 = #frmt{posl = [{PlayerId, 1, 5}]},
%% 			List = [{PlayerId, 1, left, 25, {2,2}}]      %%这里的left或right只是个临时数据当不得真（为了函数需要，后续战斗运算时会根据实际方位修改的）
%% 	end,
%% 	BattleData1 = changeHp(BattleData, WarMode),    %%WarMode可以取常量0，因为一般都是会加满血
%% 	{BattleRecord, _List1, _Bin_Pos2, _Bin_Pet2, _Bin_Mon2} = 
%% 		init_player_role(BattleData1, Formation1, [], List, <<>>, <<>>, <<>>), %%加载玩家数据
%% 	BattleRecord.
%% 											 
%% %%初始化怪物的battle_record(除阵法相克属性加成以外，并不用封包数据, 循环战斗初始数据使用)
%% iniMonBRLoop(MonGroupId) ->
%% 	[_Exp, _Coin, _Goth, Goods, BattleData, List, Formation]= loadMonData(MonGroupId),
%% %% 	io:format("~s iniMonBRLoop[~p][~p] \n ",[misc:time_format(now()),List, MonGroupId]),
%% 	BattleData1 = changeHp(BattleData, 0),
%% 	{BattleRecord, _List, _Bin_Pos2, _Bin_Pet2, _Bin_Mon2} = 
%% 							 lib_battle:init_mon_role(BattleData1, Formation, [], List, <<>>, <<>>, <<>>),
%% 	{BattleRecord, Goods}.
%% 
%% %%获取PVP战斗对手战斗数据
%% getArmyPlayerBattleData(RightId) ->
%% 	case lib_player:is_online(RightId) of
%% 	 true ->
%% 		 PlayerProcessName = misc:player_process_name(RightId),
%% 		 {RBData, RFormation01T}= gen_server:call({global,PlayerProcessName},{'getBattleData'}, 2000), %%传回对方玩家战斗数据记录#battleData及启用的阵型记录#formation,这里有个问题，就是两个玩家相互CALL，会不会产生死锁
%% 		 
%% %% 		 io:format("~s 20001_______RFormation01T________[~p]\n",[misc:time_format(now()), RFormation01T]),
%% 		 case RFormation01T of
%% 			 Val when is_record(Val, frmt) andalso Val =/= #frmt{} ->
%% 				 RFormation01 = RFormation01T,
%% 				 RList = lib_battle:loadSimpleWarList(right, RFormation01);
%% 			 _ ->
%% %% 				 RFormation01 = #formation{},
%% 				 RFormation01 = #frmt{posl = [{RightId, 1, 5}]},
%% 				 RList = [{RightId, 1, right, 25, {2,2}}]
%% 		 end,
%% 			 [0, 0, 0, [], RBData, RList, RFormation01];
%% 	 false ->
%% 		 RBDataTmp = db_agent_battle:getBattleDataFromUid(RightId),
%% 		 if is_record(RBDataTmp, battleData) ->
%% 				RBData = RBDataTmp;
%% 			true ->
%% 				case RBDataTmp of
%% 					[] ->
%% 						RBData = [];
%% 					_ ->
%% 						RBData = chkRBData(RBDataTmp)
%% 				end
%% 				
%% 		 end,
%% %%		 io:format("~s 20001_______RBData________[~p]\n",[misc:time_format(now()), RBData]),
%% 		 case db_agent:get_open_frmt_player(RightId) of
%% 			 Val when Val =:= [] orelse Val =:= undefined ->
%% 				 %%io:format("~s 20001_______RFrmt1________[~p]\n",[misc:time_format(now()), Val]),
%% %% 				 RFormation01 = #formation{},
%% 				 RFormation01 = #frmt{posl = [{RightId, 1, 5}]},
%% 				 RList = [{RightId, 1, right, 25, {2,2}}];
%% 			 R when is_list(R) ->
%% %%				 io:format("~s 20001_______RFrmt________[~p]\n",[misc:time_format(now()), R]),
%% 				 FrmtTechInfo = list_to_tuple([frmt | R]),
%% 				 RFormation01 = lib_formation:changeFrmtFromDb(FrmtTechInfo),
%% %% 				 RFormation01 = changeFrmtRecord(FrmtTechInfo1),
%% 				 RList = lib_battle:loadSimpleWarList(right, RFormation01);
%% 			 _ ->
%% %% 				 RFormation01 = #formation{},
%% 				 RFormation01 = #frmt{posl = [{RightId, 1, 5}]},
%% 				 RList = [{RightId, 1, right, 25, {2,2}}]
%% 		 end,
%% 		 [0, 0, 0, [], RBData, RList, RFormation01]
%% 	end.	
%% 
%% 
%% %%检测玩家是否可以战斗
%% checkBWar(Player, WarMode) ->
%% 	if Player#player.stts =:= 0 orelse Player#player.stts =:= 2 orelse Player#player.stts =:= 10 orelse WarMode =:= 0 orelse WarMode =:= 11 ->
%% 		   true;
%% 	   true ->
%% 		   false
%% 	end.
%% 
%% %%=============================新增战斗数据初始化接口(from liujing)==================================
%% %%通过怪物群组ID获取战斗数据(BattleData, 掉落物品表, 阵法)
%% getMonBattleData(MonGId) ->
%% 	[_Exp, _Coin, _Goth, Goods, BattleData, _List, Frmt]= loadMonData(MonGId),
%% %% 	Frmt = changeFormationRecord(Formation),
%% 	{BattleData, Goods, Frmt}.
%% 
%% %%获取人物现在的战斗数据（BattleData，阵法)
%% getPlayerBattleData(Player) ->
%% 	{BattleData, _List, Frmt} = loadLBattleData(Player),
%% %% 	Frmt = changeFormationRecord(Formation),
%% 	{BattleData, Frmt}.
%% 
%% %%只保留使用阵法的专用法器
%% %% checkFrmtPrfe(FrmtEquip, Frmt) ->
%% %% 	Fun = fun(M, BList) ->
%% %% 				  {_Pos,Tid,_Id,_Type,_Exp} = M,
%% %% 				  Base = data_frmt_equip:get_base_frmt_equip_by_tid(Tid),
%% %% 				  if Base#ets_base_frmt_equip.frmt =:= Frmt#frmt.bbtid ->
%% %% 						 BList ++ [M];
%% %% 					 true ->
%% %% 						 BList
%% %% 				  end
%% %% 		  end,
%% %% 	lists:foldl(Fun, [], FrmtEquip#ets_frmt_equip.prfe).
%% 
%% %%根据法器类型排序
%% %% sortFmtEqp(FEList) ->
%% %% 	Fun = fun({Tid, Lv}) ->
%% %% 				  Type = Tid rem 10,
%% %% 				  case Type of
%% %% 					  3 -> %%惊觉铃
%% %% 						  {1, Tid, Lv};
%% %% 					  2 -> %%三色铜
%% %% 						  {2, Tid, Lv};
%% %% 					  4 -> %%玛尼石
%% %% 						  {3, Tid, Lv};
%% %% 					  5 -> %%降魔撅
%% %% 						  {4, Tid, Lv};
%% %% 					  1 -> %%曼陀罗
%% %% 						  {5, Tid, Lv};
%% %% 					  _ ->
%% %% 						  {6, Tid, Lv}
%% %% 				  end
%% %% 		  end,
%% %% 	[{Tid1, Lv1}||{_SortId, Tid1, Lv1} <- lists:keysort(1, lists:map(Fun, FEList))].
%% 
%% %%战斗显示法器数据初始化
%% %% iniBattleFmtEqp(FrmtEquip, Frmt) ->
%% %% 	Fun = fun(M) ->
%% %% 				  {_Pos,Tid,_Id,_Type,Exp} = M,
%% %% 				  Base = data_frmt_equip:get_base_frmt_equip_by_tid(Tid),
%% %% 				  Qly = Base#ets_base_frmt_equip.qly,
%% %% 			  	  Lv = data_frmt_equip:exp_to_lv(Qly,Exp),
%% %% 				  {Tid, Lv}
%% %% 		  end,
%% %% 	NewPrfe = checkFrmtPrfe(FrmtEquip, Frmt),   %%只保留使用阵法的专用法器
%% %% 	AllList = NewPrfe ++ FrmtEquip#ets_frmt_equip.gnfe,
%% %% 	FrmtEquipArtL = lists:map(Fun, AllList),
%% %% 	#frmtEquipData{atrList = sortFmtEqp(FrmtEquipArtL)}.
%% 
%% %%战斗显示龙鞍数据初始化
%% %% iniBattleSaddle(Saddle) ->
%% %% 	Op = Saddle#ets_saddle.op,
%% %% 	Lv = Saddle#ets_saddle.lv,
%% %% 	Attr = Saddle#ets_saddle.attr,
%% %% 	if is_record(Attr, saddle_attr) ->
%% %% 		   ArrList = [{1, Attr#saddle_attr.ata}, {2, Attr#saddle_attr.atd}, {3, Attr#saddle_attr.apa},
%% %% 					  {4, Attr#saddle_attr.apd}, {5, Attr#saddle_attr.ahp}, {6, Attr#saddle_attr.hit},
%% %% 					  {7, Attr#saddle_attr.blck}, {8, Attr#saddle_attr.ddge}, {9, Attr#saddle_attr.crit},
%% %% 					  {10, Attr#saddle_attr.mana}],
%% %% 		   NowArrList = [{Type, AtrNum} || {Type, AtrNum} <- ArrList, AtrNum =/= 0];
%% %% 	   true ->
%% %% 		   NowArrList = []
%% %% 	end,
%% %% 	case NowArrList of
%% %% 		[] ->
%% %% 			[];
%% %% 		_ ->
%% %% 			#mntData{
%% %% 					 qly = Op,
%% %% 					 lv = Lv,
%% %% 					 artList = NowArrList
%% %% 					 }
%% %% 	end.
%% 
%% %%封包战斗显示的法器和龙鞍数据
%% binBattleDisData(LBattleRecord, RBattleRecord) ->
%% 	LFrmtEquipData = LBattleRecord#battle_record.frmtEquipDataR,
%% 	RFrmtEquipData = RBattleRecord#battle_record.frmtEquipDataR,
%% 	LMntData = LBattleRecord#battle_record.mntDataR,
%% 	RMntData = RBattleRecord#battle_record.mntDataR,
%% 	case is_record(LFrmtEquipData, frmtEquipData) of
%% 		true ->
%% 			BinLEquip = binEquip(LFrmtEquipData#frmtEquipData.atrList),
%% 			BinLFrmtEquip = <<1:8, BinLEquip/binary>>;
%% 		_ ->
%% 			BinLFrmtEquip = <<>>
%% 	end,
%% 	case is_record(RFrmtEquipData, frmtEquipData) of
%% 		true ->
%% 			BinREquip = binEquip(RFrmtEquipData#frmtEquipData.atrList),
%% 			BinRFrmtEquip = <<2:8, BinREquip/binary>>;
%% 		_ ->
%% 			BinRFrmtEquip = <<>>
%% 	end,
%% 	BinFrmtEquipList = lists:filter(fun(M) -> M =/= <<>> end, [BinLFrmtEquip, BinRFrmtEquip]),
%% 	BinFrmtEquipLen = length(BinFrmtEquipList),
%% 	BinFrmtEquip = tool:to_binary(BinFrmtEquipList),
%% 	BinFrmtEquipAll = <<BinFrmtEquipLen:16, BinFrmtEquip/binary>>,
%% 	case is_record(LMntData, mntData) of
%% 		true ->
%% 			LQly = LMntData#mntData.qly,
%% 			LLv = LMntData#mntData.lv,
%% 			BinLMntArt = binSaddle(LMntData#mntData.artList),
%% 			BinLMnt = <<1:8, LQly:8, LLv:8, BinLMntArt/binary>>;
%% 		_ ->
%% 			BinLMnt = <<>>
%% 	end,	
%% 	case is_record(RMntData, mntData) of
%% 		true ->
%% 			RQly = RMntData#mntData.qly,
%% 			RLv = RMntData#mntData.lv,
%% 			BinRMntArt = binSaddle(RMntData#mntData.artList),
%% 			BinRMnt = <<2:8, RQly:8, RLv:8, BinRMntArt/binary>>;
%% 		_ ->
%% 			BinRMnt = <<>>
%% 	end,	
%% 	BinMntList = lists:filter(fun(M1) -> M1 =/= <<>> end, [BinLMnt, BinRMnt]),
%% 	BinMntLen = length(BinMntList),
%% 	BinMnt = tool:to_binary(BinMntList),
%% 	BinMntAll = <<BinMntLen:16, BinMnt/binary>>,
%% 	<<BinFrmtEquipAll/binary, BinMntAll/binary>>.
%% 
%% %%封包法器列表（binBattleDisData辅助函数）
%% binEquip(ArtList) ->
%% 	Fun = fun({BaseId, Lv}) ->
%% 				  <<BaseId:32, Lv:8>>
%% 		  end,
%% 	BinList = lists:map(Fun, ArtList),
%% 	BinListLen = length(BinList),
%% 	BinArt = tool:to_binary(BinList),
%% 	<<BinListLen:16, BinArt/binary>>.
%% 
%% %%封包龙鞍属性列表（binBattleDisData辅助函数）
%% binSaddle(ArtList) ->
%% 	Fun = fun({Type, Num}) ->
%% 				  <<Type:8, Num:32>>
%% 		  end,
%% 	BinList = lists:map(Fun, ArtList),
%% 	BinListLen = length(BinList),
%% 	BinArt = tool:to_binary(BinList),
%% 	<<BinListLen:16, BinArt/binary>>.
%% 
%% 
%% %%初始化BattleData(Giant巨兽, Frmt阵法, Frmt_equip法器([]-未开启法器功能), Saddle龙鞍([]-没有龙鞍))
%% iniBattleData({custom, RoleList, Giant, _Frmt, _FrmtEquip, _Saddle}) ->
%% 	case is_record(Giant, ets_giant_s) of
%% 		true ->
%% 			NowGiant = Giant;
%% 		_ ->
%% 			NowGiant = #ets_giant_s{id = 0}
%% 	end,
%% %% 	case is_record(FrmtEquip, ?ETS_FRMT_EQUIP) of
%% %% 		true ->
%% %% 			NowFrmtEquip = iniBattleFmtEqp(FrmtEquip, Frmt);
%% %% 		_ ->
%% %% 			NowFrmtEquip = []
%% %% 	end,
%% %% 	case is_record(Saddle, ets_saddle) of
%% %% 		true ->
%% %% 			NowSaddle = iniBattleSaddle(Saddle);
%% %% 		_ ->
%% %% 			NowSaddle = []
%% %% 	end,
%% 	BattleMembers = loadCustomBD(RoleList),
%% 	AddAnger = 0,    %%自定义初始化数据时，人物的怒气加成属性不起作用（后续有需要再做修改）
%% 	#battleData{
%% 				nick = NowGiant#ets_giant_s.nick,            %%巨兽名称
%% 				behId = NowGiant#ets_giant_s.id,     %%巨兽ID, 为0表示无
%% 				behLv = NowGiant#ets_giant_s.lv,       %%巨兽等级
%% 				anger = data_battle:get_ini_anger() + AddAnger,         %%巨兽初始怒气
%% 				maxang = data_giant_s:getGiantMaxAngle(NowGiant#ets_giant_s.tecid),          %%怒气上限
%% 				behThId= NowGiant#ets_giant_s.tecid,        %%巨兽技能ID对应巨兽类型
%% 				techv = data_giant_s:cpt_tech_power(NowGiant#ets_giant_s.tecid, NowGiant#ets_giant_s.teclv),
%% 				members = BattleMembers,        %%由battleMember记录组成的列表
%% 				frmtEquipDataR = [],   %%法器数据
%% 				mntDataR = [],             %%龙鞍数据
%% 				frsl = NowGiant#ets_giant_s.frsl,         %%巨兽对阵法的加成属性
%% 				frlv = NowGiant#ets_giant_s.frlv,           %%巨兽对阵法加成的等级
%% 				img = NowGiant#ets_giant_s.img,            %%巨兽形象
%% 				qly = NowGiant#ets_giant_s.qly,                 %%巨兽品质
%% 				bgid = NowGiant#ets_giant_s.bgid,                %%巨兽基础ID
%% 				teclv = NowGiant#ets_giant_s.teclv,          %%巨兽技能等级
%% 				myatr = NowGiant#ets_giant_s.myatr,         %%巨兽对主角的加成属性列表
%% 				allatr = NowGiant#ets_giant_s.allatr,        %%巨兽对全队的加成属性列表
%% 				crr = NowGiant#ets_giant_s.crr
%% 			   };
%% 
%% iniBattleData(_Other) ->
%% 	false.
%% 
%% %%初始化BattleRecord(BHpChg:0-补满血，1-保留原有气血)
%% iniBattleRecord(BattleData, Frmt, BHpChg) ->
%% 	case is_record(Frmt, frmt) of
%% 		true ->
%% %% 			Formation = changeFrmtRecord(Frmt),
%% 			List = loadSimpleWarList(left, Frmt),  %%这里的left或right只是个临时数据当不得真（为了函数需要，后续战斗运算时会根据实际方位修改的）
%% 			case BattleData of
%% 				[] ->
%% 					[];
%% 				_ ->
%% 					BattleDataTmp = chkRBData(BattleData),
%% 					BattleData1 = changeHp(BattleDataTmp, BHpChg),    %%WarMode可以取常量0，因为一般都是会加满血，并加上或清除变身卡效果
%% 					{BattleRecord, _List1, _Bin_Pos2, _Bin_Pet2, _Bin_Mon2} = 
%% 						init_player_role(BattleData1, Frmt, [], List, <<>>, <<>>, <<>>), %%数据转换
%% 					BattleRecord
%% 			end;
%% 		_ ->
%% 			[]
%% 	end.
%% 	
%% %%battleData初始化辅助函数
%% loadCustomBD(RoleList) ->
%% 	Fun = fun({Type, RoleRecord, SkillId}) ->
%% 				case Type of
%% 					1 ->   %%人物
%% 						case is_record(RoleRecord, player) of
%% 							true ->
%% 								case SkillId of
%% 									TmpId when is_integer(TmpId) ->
%% 										if TmpId > 0 ->
%% 											   NowSkillId = TmpId;
%% 										   true ->
%% 											   NowSkillId = data_battle:getPSkillFromCrr(RoleRecord#player.crr)
%% 										end;
%% 									_ ->
%% 										NowSkillId = data_battle:getPSkillFromCrr(RoleRecord#player.crr)
%% 								end,
%% 								#battleMember{
%% 		  									id = RoleRecord#player.id,                    %%战斗角色id	
%% 		  						            nick = RoleRecord#player.nick,                  %%名称              
%% 		  						            crr = RoleRecord#player.crr,                   %%职业              
%% 		  						            mtype = Type,                 %%战斗角色类型（1:人物,2:宠物
%% 		  						            race = 0,                  %%种族ID            
%% 		  						            lv = RoleRecord#player.lv,                    %%等级          
%% 		  						  			frhp = RoleRecord#player.hp,                  %%一轮战斗的初始气血
%% 		  					      			defender = 0,				  				%%是否是守护者 0 - 否，1 - 是    
%% 		  						            hp = RoleRecord#player.hp,                   %%气血               
%% 		  						            mxhp = RoleRecord#player.mxhp,                %%最大气血              
%% 		  						            mana = RoleRecord#player.mana,                 %%气势               
%% 		  									mnup = RoleRecord#player.mnup,                 %%气势增加值
%% 		  						            mxmn = 100,               %%触发绝技的气势值           
%% 		  						            sklid = NowSkillId,     %%data_battle:get_skill(RoleRecord#player.crr), %%测试，临时取消：NowSkillId,   %% Player#player.sklid,                  %%绝技id           
%% 		  						            pwr = RoleRecord#player.pwr,                   %%内功              
%% 		  						            tech = RoleRecord#player.tech,                  %%技法              
%% 		  						            mgc = RoleRecord#player.mgc,                  %%法力               
%% 		  						            hit = RoleRecord#player.hit,                   %%命中              
%% 		  						            crit = RoleRecord#player.crit,                   %%暴击             
%% 		  						            ddge = RoleRecord#player.ddge,                  %%闪避              
%% 		  						            blck = RoleRecord#player.blck,                   %%格挡             
%% 		  						            cter = RoleRecord#player.cter,                   %%反击             
%% 		  						            dbas = RoleRecord#player.other#player_other.baseDef,                   %%基础防御           
%% 		  						            dpwr = RoleRecord#player.dpwr,                  %%内功防御            
%% 		  						            dtech = RoleRecord#player.dtech,                 %%技法防御            
%% 		  						            dmgc = RoleRecord#player.dmgc,                 %%法力防御             
%% 		  						            abas = RoleRecord#player.other#player_other.baseAtt,					 %%基础攻击                    
%% 		  						            apwr = RoleRecord#player.apwr,                  %%内力攻击            
%% 		  						            atech = RoleRecord#player.atech,                 %%技法攻击            
%% 		  						            amgc = RoleRecord#player.amgc,                  %%法力攻击            
%% 		  						            roll = 0,					 %%碾压                      
%% 		  						            rela = 0,           		 %%亲密度               
%% 		  						            dcrit = RoleRecord#player.dcrit,                 %%防暴击             
%% 		  						            dblck = RoleRecord#player.dblck,                  %%破格挡 
%% 		  									icon = RoleRecord#player.img,  %%形象ID       
%% 		  									sex = RoleRecord#player.sex,     %%性别
%% 		  									ffc = 0, %%战力 (由于可能是多个人物角色或没有人物，避免数据错误，这里不做计算，需要战力显示的战斗，算好后直接加到协议里)
%% 		  									qly = 0,                             %%品质（宠物专用）
%% 											proty = RoleRecord#player.speed,   %%data_battle:get_speed(RoleRecord#player.crr),  %%测试临时使用
%% 											pasid = data_battle:get_pos_pas_skill(RoleRecord#player.crr), %%测试临时使用                  %%被动技能id
%% 					  						paslv = 0                 %%被动技能等级
%% 		  									 };
%% 							_ ->
%% 								[]
%% 						end;
%% 					2 ->  %%宠物
%% 						case is_record(RoleRecord, pet2) of
%% 							true ->
%% %% 								Quality = RoleRecord#pet2.qly,
%% %% 								PwrLv = 0,%data_pet:get_upgrade_level(RoleRecord#pet.pwn, Quality),
%% %% 								MgcLv = 0,%data_pet:get_upgrade_level(RoleRecord#pet.mgn, Quality),
%% %% 								TechLv = 0,%data_pet:get_upgrade_level(RoleRecord#pet.tcn, Quality),
%% %% 								AtrLv = PwrLv + MgcLv + TechLv,
%% 								TlidL = [],%[Tlid||Tlid<-[RoleRecord#pet.tlid, RoleRecord#pet.tlid1, RoleRecord#pet.tlid2], Tlid =/= 0],
%% 								#battleMember{
%% 											id = RoleRecord#pet2.id,                    %%战斗角色id	
%% 					            			nick = RoleRecord#pet2.nick,                  %%名称              
%% 					            			crr = RoleRecord#pet2.crr,                   %%职业              
%% 					            			mtype = Type,                 %%战斗角色类型（1:人物,2:宠物）
%% 					            			race = RoleRecord#pet2.race,                  %%种族ID            
%% 					            			lv = RoleRecord#pet2.lv,                    %%等级    
%% 				 							frhp = RoleRecord#pet2.hp,
%% 				    						defender = 0,				  				%%是否是守护者 0 - 否，1 - 是    
%% 					            			hp = RoleRecord#pet2.hp,                   %%气血               
%% 					            			mxhp = RoleRecord#pet2.other#pet_other.mxhp,                %%最大气血              
%% 					            			mana = RoleRecord#pet2.other#pet_other.mana,                 %%气势       
%% 											mnup = RoleRecord#pet2.other#pet_other.mnup,                 %%气势增加值        
%% 					            			mxmn = 100,               %%触发绝技的气势值           
%% 					            			sklid = RoleRecord#pet2.teid,  %%data_battle:get_skill(RoleRecord#pet.crr), %%测试，临时取消：RoleRecord#pet.teid,                  %%绝技id           
%% 					            			skllv = 1,      			                %%绝技等级                 
%% 					            			pwr = 0,%RoleRecord#pet.other#pet_other.pwr,                   %%内功              
%% 					            			tech = 0,%RoleRecord#pet.other#pet_other.tech,                  %%技法              
%% 					            			mgc = 0,%RoleRecord#pet.other#pet_other.mgc,                  %%法力               
%% 					            			hit = RoleRecord#pet2.other#pet_other.hit,                   %%命中              
%% 					            			crit = RoleRecord#pet2.other#pet_other.crit,                   %%暴击             
%% 					            			ddge = RoleRecord#pet2.other#pet_other.ddge,                  %%闪避              
%% 					            			blck = RoleRecord#pet2.other#pet_other.blck,                   %%格挡             
%% 					            			cter = RoleRecord#pet2.other#pet_other.cter,                   %%反击             
%% 					            			dbas = 0,%RoleRecord#pet.other#pet_other.dbas,                   %%基础防御           
%% 					            			dpwr = RoleRecord#pet2.other#pet_other.dpwr,                  %%内功防御            
%% 					            			dtech = RoleRecord#pet2.other#pet_other.dtech,                 %%技法防御            
%% 					            			dmgc = RoleRecord#pet2.other#pet_other.dmgc,                 %%法力防御             
%% 					            			abas = 0,%RoleRecord#pet.other#pet_other.abas,					 %%基础攻击                    
%% 					            			apwr = RoleRecord#pet2.other#pet_other.apwr,                  %%内力攻击            
%% 					            			atech = RoleRecord#pet2.other#pet_other.atech,                 %%技法攻击            
%% 					            			amgc = RoleRecord#pet2.other#pet_other.amgc,                  %%法力攻击            
%% 					            			roll = 0,					 %%碾压                      
%% 					            			rela = RoleRecord#pet2.rela,           		 %%亲密度               
%% 					            			dcrit = RoleRecord#pet2.other#pet_other.dcrit,                 %%防暴击             
%% 					            			dblck = RoleRecord#pet2.other#pet_other.dblck,                  %%破格挡 
%% 											icon = RoleRecord#pet2.icon,                     %%形象ID
%% 										    ffc = 0,                                      %%战力
%% 											qly = RoleRecord#pet2.qly,                       %%品质
%% 											copen = RoleRecord#pet2.copen,              %% 是否开启阴阳历
%% 											ctm = RoleRecord#pet2.ctm,				  %%变身时间
%% 											csta = RoleRecord#pet2.csta,                 %%是否变身
%% 											cont = RoleRecord#pet2.cont,             %% 变身属性  [{Buff1, Value1}, {Buff2, Value2}...]
%% 											tlidl = TlidL,                          %%宠物天赋基础ID列表
%% 											atrlv = RoleRecord#pet2.star,                           %%宠物总阶数
%% 											proty = RoleRecord#pet2.other#pet_other.speed,   %%data_battle:get_speed(RoleRecord#pet.crr),  %%测试临时使用
%% 											pasid = RoleRecord#pet2.teid1,   %%data_battle:get_pas_skill(RoleRecord#pet.crr), %%测试临时使用                %%被动技能id
%% 					  						paslv = 0                 %%被动技能等级
%% 										   };
%% 							_ ->
%% 								[]
%% 						end;
%% 					3 ->  %%怪物
%% 						case is_record(RoleRecord, ets_mon) of
%% 							true ->
%% 								#battleMember{
%% 											id = RoleRecord#ets_mon.mtid,                    %%战斗角色id	
%% 					            			nick = tool:to_list(RoleRecord#ets_mon.name),                  %%名称              
%% 					            			crr = RoleRecord#ets_mon.crr,                   %%职业              
%% 					            			mtype = Type,                 %%战斗角色类型（1:人物,2:宠物,3:怪物）
%% 					            			race = RoleRecord#ets_mon.race,                  %%种族ID            
%% 					            			lv = RoleRecord#ets_mon.lv,                    %%等级              
%% 					            			hp = RoleRecord#ets_mon.mxhp,                   %%气血               
%% 					            			mxhp = RoleRecord#ets_mon.mxhp,                %%最大气血              
%% 					            			mana = RoleRecord#ets_mon.mana,                 %%气势               
%% 											mnup = RoleRecord#ets_mon.mnup,                 %%气势增加值
%% 					            			mxmn = 100,               %%触发绝技的气势值           
%% 					            			sklid = RoleRecord#ets_mon.sklid,   %%data_battle:get_skill(RoleRecord#ets_mon.crr), %%测试，临时取消RoleRecord#ets_mon.sklid,                  %%绝技id           
%% 					            			skllv = 1,      			                   %%绝技等级                 
%% 					            			pwr = RoleRecord#ets_mon.pwr,                   %%内功              
%% 					            			tech = RoleRecord#ets_mon.tech,                  %%技法              
%% 					            			mgc = RoleRecord#ets_mon.mgc,                  %%法力               
%% 					            			hit = RoleRecord#ets_mon.hit,                   %%命中              
%% 					            			crit = RoleRecord#ets_mon.crit,                   %%暴击             
%% 					            			ddge = RoleRecord#ets_mon.ddge,                  %%闪避              
%% 					            			blck = RoleRecord#ets_mon.blck,                   %%格挡             
%% 					            			cter = RoleRecord#ets_mon.cter,                   %%反击             
%% 					            			dbas = 0,  %%MonMember#ets_mon.dbas,                   %%基础防御           
%% 					            			dpwr = RoleRecord#ets_mon.dpwr,                  %%内功防御            
%% 					            			dtech = RoleRecord#ets_mon.dtech,                 %%技法防御            
%% 					            			dmgc = RoleRecord#ets_mon.dmgc,                 %%法力防御             
%% 					            			abas = 0, %%MonMember#ets_mon.abas,					 %%基础攻击                    
%% 					            			apwr = RoleRecord#ets_mon.apwr,                  %%内力攻击            
%% 					            			atech = RoleRecord#ets_mon.atech,                 %%技法攻击            
%% 					            			amgc = RoleRecord#ets_mon.amgc,                  %%法力攻击            
%% 					            			roll = 0,					 %%碾压                      
%% 					            			rela = 0,           		 %%亲密度               
%% 					            			dcrit = RoleRecord#ets_mon.dcrit,                 %%防暴击             
%% 					            			dblck = RoleRecord#ets_mon.dblck,                  %%破格挡 
%% 											icon = RoleRecord#ets_mon.icon,                         %%形象ID
%% 											proty = RoleRecord#ets_mon.speed,  %%data_battle:get_speed(RoleRecord#ets_mon.crr),  %%测试临时使用
%% 											pasid = RoleRecord#ets_mon.pasid,  %%data_battle:get_pas_skill(RoleRecord#ets_mon.crr), %%测试临时使用                %%被动技能id
%% 					  						paslv = 0                 %%被动技能等级
%% 										   };
%% 							_ ->
%% 								[]
%% 						end;
%% 					_ ->
%% 						[]
%% 				end
%% 		  end,
%% 	RoleDataL = lists:map(Fun, RoleList),
%% 	lists:filter(fun(M) -> M =/= [] end, RoleDataL).
%% 
%% %%根据双方人物职业计算额外气势增加
%% updateOtherMana(RandKey, Act_Member, Def_Member, BattleSubType) ->
%% 	case RandKey of
%% 		ddgeR ->     %%闪避
%% 			if Def_Member#member.crr =:= 1 ->
%% 					Def_Member1 = Def_Member#member{mana = Def_Member#member.mana + 10},
%% 					BattleSubType1 = BattleSubType;
%% 			   true ->
%% 					Def_Member1 = Def_Member,
%% 					BattleSubType1 = BattleSubType
%% 			end;
%% 		blckR ->     %%格挡
%% 			if Def_Member#member.crr =:= 3 ->
%% 					Def_Member1 = Def_Member#member{mana = Def_Member#member.mana + 13},
%% 					BattleSubType1 = BattleSubType;
%% 			   true ->
%% 					Def_Member1 = Def_Member,
%% 					BattleSubType1 = BattleSubType
%% 			end;
%% 		critR ->     %%暴击
%% 			if Act_Member#member.crr =:= 2 ->
%% 					Def_Member1 = Def_Member,
%% 					BattleSubType1 = BattleSubType#battleSubType{upManaVal = BattleSubType#battleSubType.upManaVal + 25};
%% 			   true ->
%% 					Def_Member1 = Def_Member,
%% 					BattleSubType1 = BattleSubType
%% 			end;
%% 		_ ->
%% 			Def_Member1 = Def_Member,
%% 			BattleSubType1 = BattleSubType
%% 	end,
%% 	{Def_Member1, BattleSubType1}.
%% 
%% %%获取当前攻击角色,并对其累加修整时间，改变下次攻击的优先攻击方向判断（注：left方为默认进攻方，但不一定是先攻方）
%% %%第一回合战斗要做特殊处理（即WarNum为0的情况）：需要根据先攻方向判定出手角色。
%% get_act_role(LeftList, RightList, Left_Battle_Record, Right_Battle_Record, BattleSta, WarNum) ->
%% 	AllMember = Left_Battle_Record#battle_record.members ++ Right_Battle_Record#battle_record.members,
%% 	AllList = LeftList ++ RightList,
%% 	Fun = fun({_Id, _Type, Dir, Pst, _Psttp}, ReList) ->
%% 				  case lists:keyfind(Pst, #member.pst, AllMember) of
%% 					  M when is_record(M, member) ->
%% 						  WaitTime = M#member.fulltime,
%% 						  ReList ++ [{Dir, Pst, WaitTime}];
%% 					  _ ->
%% 						  ReList
%% 				  end
%% 		  end,
%% 	if WarNum =:= 0 ->
%% 		   case BattleSta#battleSta.pDirect of
%% 			   left ->
%% 				   WaitTimeList = lists:foldl(Fun, [], LeftList);
%% 			   right ->
%% 				   WaitTimeList = lists:foldl(Fun, [], RightList);
%% 			   _ ->
%% 				   WaitTimeList = lists:foldl(Fun, [], AllList)
%% 		   end;
%% 	   true ->
%% 		   WaitTimeList = lists:foldl(Fun, [], AllList)
%% 	end,
%% 	ActPst = get_normal_role(WaitTimeList, BattleSta),
%% 	NowRoleInfo = lists:keyfind(ActPst, 4, AllList),
%% 	{_NowId, _NowType, NowDir, NowPst, _NowPsttp} = NowRoleInfo,
%% 	{NowLeft_Battle_Record, NowRight_Battle_Record, NowBattleSta} =
%% 		update_role_act_info(NowPst, NowDir, Left_Battle_Record, Right_Battle_Record, BattleSta),
%% 	{NowRoleInfo, NowLeft_Battle_Record, NowRight_Battle_Record, NowBattleSta}.
%% 	
%% get_normal_role(WaitTimeList, BattleSta) ->
%% 	WaitTimeList1 = lists:keysort(3, WaitTimeList),
%% 	{_FDir, FPst, FWaitTime} = lists:nth(1, WaitTimeList1),
%% 	FirList = [{Dir, Pst, WaitTime}||{Dir, Pst, WaitTime}<-WaitTimeList1, WaitTime =:= FWaitTime],
%% 	case length(FirList) of
%% 		0 ->
%% 			0;
%% 		1 ->
%% 			FPst;
%% 		_ ->
%% 			NowDir = data_battle:directToRvs(BattleSta#battleSta.actLastDirect),
%% 			FirList1 = [{Dir1, Pst1, WaitTime1}||{Dir1, Pst1, WaitTime1}<-FirList, Dir1 =:= NowDir],
%% 			case FirList1 of
%% 				[] ->
%% 					NowFirList = FirList;
%% 				_ ->
%% 					NowFirList = FirList1
%% 			end,
%% 			case lists:keysort(2, NowFirList) of
%% 				[] ->
%% 					0;
%% 				NowFirList1 ->
%% 					{_NowDir, NowPst, _NowWTime} = lists:nth(1, NowFirList1),
%% 					NowPst
%% 			end
%% 	end.
%% 
%% %%更新战斗运行时数据
%% update_role_act_info(ActPst, ActDir, Left_Battle_Record, Right_Battle_Record, BattleSta) ->
%% 	Fun = fun(M) ->
%% 				  if M#member.pst =:= ActPst ->      %%此处计算后期要加入速度BUFF的影响
%% 						 AddWaitTime = data_battle:get_proty_time(M#member.proty),
%% 						 M#member{fulltime = M#member.fulltime + AddWaitTime};
%% 					 true ->
%% 						 M
%% 				  end
%% 		  end,
%% 	case ActDir of
%% 		left ->
%% 			NewLeftMembers = lists:map(Fun, Left_Battle_Record#battle_record.members),
%% 			NewLeft_Battle_Record = Left_Battle_Record#battle_record{members = NewLeftMembers},
%% 			NewRight_Battle_Record = Right_Battle_Record;
%% 		right ->
%% 			NewRightMembers = lists:map(Fun, Right_Battle_Record#battle_record.members),
%% 			NewRight_Battle_Record = Right_Battle_Record#battle_record{members = NewRightMembers},
%% 			NewLeft_Battle_Record = Left_Battle_Record
%% 	end,
%% 	NewBattleSta = BattleSta#battleSta{actLastDirect = ActDir},
%% 	{NewLeft_Battle_Record, NewRight_Battle_Record, NewBattleSta}.
%% 			
%% %%封包被动技触发数据
%% binPasList(Left_List, Right_List, PasList) ->
%% 	AllList = Left_List ++ Right_List,
%% 	Fun = fun(M, GetList) ->
%% 				  Pst = M#rolePasinfo.pst,
%% 				  case lists:keyfind(Pst, 4, AllList) of
%% 					  false ->
%% 						  GetList;
%% 					  _ ->
%% 						  [M|GetList]
%% 				  end
%% 		  end,
%% 	NewPasList = lists:foldl(Fun, [], PasList),
%% 	Fun1 = fun(M1) ->
%% 				   Pst1 = M1#rolePasinfo.pst,
%% 				   Imef1 = M1#rolePasinfo.imef,
%% 				   Flag1 = M1#rolePasinfo.flag,
%% 				   Data1 = M1#rolePasinfo.other_data,
%% %% 				   io:format("binPasList_[~w][~w][~w][~w]~n", [Pst1, Imef1, Flag1, Data1]),
%% 				   <<Pst1:8, Imef1:16, Flag1:8, Data1:32>>
%% 		   end,
%% 	Len = length(NewPasList),
%% %% 	if Len > 0 ->
%% %% 		   io:format("~s__binPasList__clip~n",[misc:time_format(now())]);
%% %% 	   true ->
%% %% 		   skip
%% %% 	end,
%% 	BinPas = tool:to_binary(lists:map(Fun1, NewPasList)),
%% 	<<Len:16, BinPas/binary>>.
%% 	
%% %%检测角色位置是否在巨兽阵法位置中(前、中、后阵)
%% chk_giant_frm_pst(RolePst, FrmPst) ->
%% 	TruePst = RolePst rem 10,
%% 	case FrmPst of
%% 		1 ->
%% 			lists:member(TruePst, [1,2,3]);
%% 		2 ->
%% 			lists:member(TruePst, [4,5,6]);
%% 		3 ->
%% 			lists:member(TruePst, [7,8,9]);
%% 		_ ->
%% 			false
%% 	end.
%% 
%% %%在初始化BattleRecord时加入巨兽阵法属性
%% get_member_giant_atr(Member, GiantFrmAtrList) ->
%% 	Fun = fun({FrmPst, {_DisList, AtrList}}, BegMember) ->
%% 				  case chk_giant_frm_pst(BegMember#member.pst, FrmPst) of
%% 					  true ->
%% 						  set_member_info_fields(BegMember, AtrList);
%% 					  _ ->
%% 						  BegMember
%% 				  end
%% 		  end,
%% 	lists:foldl(Fun, Member, GiantFrmAtrList).
%% 
%% set_member_info_fields(Member, []) ->
%% 	Member#member{hp = Member#member.mxhp};
%% set_member_info_fields(Member, [H|T]) ->	
%% 	NewMember =	
%% 		case H of	
%% 			{mxhp, Val} -> Member#member{mxhp=Member#member.mxhp + Val};	
%% 			{hit, Val} -> Member#member{hit=Member#member.hit + Val};	
%% 			{crit, Val} ->  Member#member{crit=Member#member.crit + Val};	
%% 			{dcrit, Val} ->  Member#member{dcrit=Member#member.dcrit + Val};	
%% 			{ddge, Val} ->  Member#member{ddge=Member#member.ddge + Val};	
%% 			{blck, Val} ->  Member#member{blck=Member#member.blck + Val};	
%% 			{dblck, Val} ->  Member#member{dblck=Member#member.dblck + Val};	
%% 			{cter, Val} ->  Member#member{cter=Member#member.cter + Val};	
%% 			{mana, Val} ->  Member#member{mana=Member#member.mana + Val};	
%% 			{speed, Val} ->  Member#member{proty=Member#member.proty + Val};	
%% 			{dpwr, Val} ->  Member#member{dpwr=Member#member.dpwr + Val};	
%% 			{dtech, Val} ->  Member#member{dtech=Member#member.dtech + Val};	
%% 			{dmgc, Val} ->  Member#member{dmgc=Member#member.dmgc + Val};	
%% 			{apwr, Val} ->  Member#member{apwr=Member#member.apwr + Val};	
%% 			{atech, Val} ->  Member#member{atech=Member#member.atech + Val};	
%% 			{amgc, Val} ->  Member#member{amgc=Member#member.amgc + Val};
%% %% 			{mana, Val} -> Member#member{mana=Member#member.mana + Val};
%% 			_ ->
%% 				Member
%% 		end,
%% 	set_member_info_fields(NewMember, T).	
%% 				  
%% %%获取技能攻击的战斗数据
%% get_skill_act_data(ActMember) ->
%% 	MissVal = cptMissBuff(ActMember, data_battle:getCrrMiss(ActMember#member.crr) *100),%%获取未命中率
%% 	HitVal =  cptHitBuff(ActMember),               %%Old_Member1#member.hit,                              %%计算攻击者命中率（含BUFF影响）
%% 	CritVal = cptCritBuff(ActMember),                %%Old_Member1#member.crit,                            %%计算攻击者暴击率（含BUFF影响）
%% 	%% 				   		  		  DCritVal = Old_Member1#member.dcrit,                 %%防暴击
%% 	DBlckVal = cptDBlckBuff(ActMember),                  %%破格挡
%% 	LvVal = ActMember#member.lv, 
%% 	ActSkill = getSkill(ActMember#member.sklid),   %%获得#ets_skill记录
%% 	OldMana = ActMember#member.mana,
%% 	case ActSkill#ets_skill.imef of                     %%计算技能攻击力
%% 		0 ->                   %%没有技能时的技能攻击
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                   %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,              %%攻击力
%% 										   otherVal = 0,
%% 										   manaVal = OldMana
%% 										  };
%% 		2 ->					%%增加自己技法攻击绝对值					 
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                   %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,              %%攻击力
%% 										   otherVal = 0,
%% 										   manaVal = OldMana
%% 										  };
%% 		4 ->					%%增加自己技法攻击百分比
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = 0,
%% 										   manaVal = OldMana
%% 										  };
%% 		5 ->					%%连击
%% 			ActType = data_battle:getCrrActType(ActMember#member.crr),  %%通过职业ID获得攻击类型是内功还是法功
%% 			ActPwr = cptActAll(ActMember, ActType, 0), 
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                 %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,           %%技能攻击
%% 										   typeId = 4,                  %%攻击子类型ID（连击）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = ActSkill#ets_skill.imvl,    %%连击次数
%% 										   manaVal = OldMana
%% 										  };
%% 		6 ->                  %%降低总攻击力的群攻
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = 0,
%% 										   manaVal = OldMana
%% 										  };
%% 		12 ->					%%降气势，绝对值
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[DownMana] ->
%% 					skip;
%% 				_ ->
%% 					DownMana = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                   %%   old: 5,%%攻击子类型ID（技能伤害+降气势）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = DownMana, %%降气势值
%% 										   manaVal = OldMana
%% 										  };
%% 		11 ->                  %%加气势，绝对值		
%% 			case ActSkill#ets_skill.other_data of
%% 				[UpMana] ->
%% 					skip;
%% 				_ ->
%% 					UpMana = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = false,                 %%不发生攻击
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 6,                  %%攻击子类型ID（加气势）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = 0,
%% 										   otherVal = UpMana, %%加气势值
%% 										   manaVal = OldMana
%% 										  }; 
%% 		13 ->                 %%加血，绝对值
%% 			case ActSkill#ets_skill.other_data of
%% 				[UpHp] ->
%% 					skip;
%% 				_ ->
%% 					UpHp = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = false,                 %%不发生攻击
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 7,                  %%攻击子类型ID（加血绝对值）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = 0,
%% 										   otherVal = UpHp, %%加血绝对值
%% 										   manaVal = OldMana
%% 										  };
%% 		14 ->					%%加血，百分比
%% 			case ActSkill#ets_skill.other_data of
%% 				[UpHpR] ->
%% 					skip;
%% 				_ ->
%% 					UpHpR = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = false,                 %%不发生攻击
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 7,                  %%攻击子类型ID（加血百分比）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = 0,
%% 										   otherVal = round(ActMember#member.atech * UpHpR / 100), %%加血百分比(固定公式)
%% 										   manaVal = OldMana
%% 										  };
%% 		15 ->                 %%换血
%% 			BattleSubType = #battleSubType{
%% 										   bAct = false,                 %%不发生攻击
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 8,                  %%攻击子类型ID（换血）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = 0,
%% 										   otherVal = 0,                
%% 										   manaVal = OldMana
%% 										  };
%% 		21 ->                %%攻击并加暴击
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[UpCrit] ->
%% 					skip;
%% 				_ ->
%% 					UpCrit = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal + (UpCrit * 100)),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   manaVal = OldMana
%% 										  };
%% 		22 ->                %%攻击并加技法攻击绝对值
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[UpAct] ->
%% 					skip;
%% 				_ ->
%% 					UpAct = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr + UpAct,
%% 										   manaVal = OldMana
%% 										  };
%% 		23 ->                %%攻击并加降低对手防御百分比
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[DownDef] ->
%% 					skip;
%% 				_ ->
%% 					DownDef = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = DownDef, %%降对手防御百分比
%% 										   manaVal = OldMana
%% 										  };
%% 		24 ->                %%攻击并加降低对手格挡率
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[DownBlck] ->
%% 					skip;
%% 				_ ->
%% 					DownBlck = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = DownBlck * 100, %%降低对手格挡率
%% 										   manaVal = OldMana
%% 										  };
%% 		25 ->                %%攻击并加降低对手闪避率
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[DownDdge] ->
%% 					skip;
%% 				_ ->
%% 					DownDdge = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = DownDdge * 100, %%降低对手闪避率
%% 										   manaVal = OldMana
%% 										  };
%% 		26 ->                %%攻击并保留自己一定气势值
%% 			ActPwr = cptActAll(ActMember, 2, ActSkill),
%% 			case ActSkill#ets_skill.other_data of
%% 				[StayMana] ->
%% 					skip;
%% 				_ ->
%% 					StayMana = 0
%% 			end,
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                  %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),             %%破格挡(穿透)
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = 2,                  %%技能攻击
%% 										   typeId = 2,                  %%攻击子类型ID（技能伤害）
%% 										   skilFId = ActSkill#ets_skill.imef,  %%主动技能即时效果ID
%% 										   actVal = ActPwr,
%% 										   otherVal = StayMana, %%保留气势值
%% 										   manaVal = OldMana
%% 										  };
%% 		_ ->
%% 			BattleSubType = #battleSubType{}
%% 	end,
%% 	{ActSkill, BattleSubType}.
%% 	
%% %%获取普通攻击的战斗数据
%% get_normal_act_data(ActMember) ->
%% 	MissVal = cptMissBuff(ActMember, data_battle:getCrrMiss(ActMember#member.crr) *100),%%获取未命中率
%% 	HitVal =  cptHitBuff(ActMember),               %%Old_Member1#member.hit,                              %%计算攻击者命中率（含BUFF影响）
%% 	CritVal = cptCritBuff(ActMember),                %%Old_Member1#member.crit,                            %%计算攻击者暴击率（含BUFF影响）
%% 	DBlckVal = cptDBlckBuff(ActMember),                  %%破格挡
%% 	LvVal = ActMember#member.lv, 
%% 	ActType = data_battle:getCrrActType(ActMember#member.crr),  %%通过职业ID获得攻击类型是内功还是法功
%% 	ActPwr = cptActAll(ActMember, ActType, 0),                  %%计算普通攻击力（含BUFF影响）
%% 	case ActMember#member.defender =:= 1 of
%% 		true ->
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                 %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = ActType,           %%普通攻击
%% 										   typeId = 100,                %%作为守护者发起普通攻击
%% 										   actVal = ActPwr} ;
%% 		false ->
%% 			BattleSubType = #battleSubType{
%% 										   bAct = true,                 %%发生攻击
%% 										   missVal = tool:int_format(MissVal),            %%未命中率
%% 										   hitVal = tool:int_format(HitVal),              %%命中率
%% 										   critVal = tool:int_format(CritVal),            %%暴击率
%% 										   dblck = tool:int_format(DBlckVal),
%% 										   lvVal = LvVal,                %%攻击者等级
%% 										   actType = ActType,           %%普通攻击
%% 										   typeId = ActType,            %%攻击子类型ID（普通攻击）
%% 										   actVal = ActPwr}
%% 	end ,
%% 	BattleSubType.
%% 
%% %%失败评分计算
%% cpt_grade(Ffc, PLv, Flag) ->
%% 	StdGrade = data_battle:get_std_grade(Flag, PLv),
%% 	Grade = round(Ffc * 100 / StdGrade),
%% 	G = 
%% 		case Flag of
%% 			1 ->
%% 				if Grade >= 75 -> 5;
%% 				   Grade >= 50 -> 4;
%% 				   Grade >= 21 -> 3;
%% 				   Grade >= 11 -> 2;
%% 				   true -> 1
%% 				end;
%% 			2 ->
%% 				if Grade >= 75 -> 5;
%% 				   Grade >= 50 -> 4;
%% 				   Grade >= 21 -> 3;
%% 				   Grade >= 11 -> 2;
%% 				   true -> 1
%% 				end;
%% 			3 ->
%% 				if Grade >= 75 -> 5;
%% 				   Grade >= 60 -> 4;
%% 				   Grade >= 35 -> 3;
%% 				   Grade >= 11 -> 2;
%% 				   true -> 1
%% 				end;
%% 			4 ->
%% 				if Grade >= 75 -> 5;
%% 				   Grade >= 60 -> 4;
%% 				   Grade >= 30 -> 3;
%% 				   Grade >= 11 -> 2;
%% 				   true -> 1
%% 				end;
%% 			_ ->
%% 				0
%% 		end,
%% 	{G, StdGrade}.
%% 
%% %%计算失败后各项评分（需要在玩家进程调用）->[{评分类型标识位, 是否开启功能标识位, 评分},..]
%% cpt_every_grade(Player) ->
%% 	List = [1,2,3,4],     %%1-装备，2-英灵，3-巨兽，4-宠物
%% 	Fun = fun(Flag) ->
%% 				  case Flag of
%% 					  1 ->
%% 						  EquitAttList = Player#player.other#player_other.equip_attribute,
%% 						  Ffc = data_player:cpt_ffc(EquitAttList),
%% 						  {Grade, StdFfc} = cpt_grade(Ffc, Player#player.lv, Flag),
%% 						  {Flag, 1, Grade, Ffc, StdFfc};
%% 					  2 ->
%% 						  ResOpen = data_player:is_opening_function(Player#player.ftst, ?FUNC_SIGN_GHOST),
%% 						  case ResOpen of
%% 							  true ->
%% 								  Ghost = Player#player.other#player_other.ghost,
%% 								  Ffc = lib_ghost:cpt_ghost_ffc(Ghost),
%% 								  {Grade, StdFfc} = cpt_grade(Ffc, Player#player.lv, Flag),
%% 								  {Flag, 1, Grade, Ffc, StdFfc};
%% 							  _ ->
%% 								  {Flag, 0, 0, 0, 1}
%% 						  end;
%% 					  3 ->
%% 						  ResOpen = data_player:is_opening_function(Player#player.ftst, ?FUNC_SIGN_GIANT),
%% 						  case ResOpen of
%% 							  true ->
%% 								  Giant = lib_giant_s:get_act_giant(),
%% 								  Ffc = lib_giant_s:cpt_giant_ffc(Giant),
%% 								  {Grade, StdFfc} = cpt_grade(Ffc, Player#player.lv, Flag),
%% 								  {Flag, 1, Grade, Ffc, StdFfc};
%% 							  _ ->
%% 								  {Flag, 0, 0, 0, 1}
%% 						  end;
%% 					  4 ->
%% 						  ResOpen = data_player:is_opening_function(Player#player.ftst, ?FUNC_SIGN_FRMT_PET),
%% 						  case ResOpen of
%% 							  true ->
%% 								  ActPetlist = lib_pet2:get_act_pets(Player#player.id),
%% 								  Ffc = lists:foldl(fun(X, Sum) -> lib_player:force_att_pet(X) + Sum end, 0, ActPetlist),
%% 								  {Grade, StdFfc} = cpt_grade(Ffc, Player#player.lv, Flag),
%% 								  {Flag, 1, Grade, Ffc, StdFfc};
%% 							  _ ->
%% 								  {Flag, 0, 0, 0, 0}
%% 						  end;
%% 					  _ ->
%% 						  {0, 0, 0, 0, 1}
%% 				  end
%% 		  end,
%% 	lists:map(Fun, List).
%% 						  
%% %%计算各项属性系统战力（需要在玩家进程调用）->[{评分类型标识位, 是否开启功能标识位, 当前战力, 最大战力},..]
%% cpt_every_grade_info(Player) ->
%% 	List = [1,2,3,4],     %%1-装备，2-英灵，3-巨兽，4-宠物
%% 	Fun = fun(Flag) ->
%% 				  case Flag of
%% 					  1 ->
%% 						  EquitAttList = Player#player.other#player_other.equip_attribute,
%% 						  Ffc = data_player:cpt_ffc(EquitAttList),
%% 						  MaxFfc = data_battle:get_std_grade(Flag, Player#player.lv),
%% 						  if Ffc > MaxFfc ->
%% 								 ReMaxFfc = Ffc;
%% 							 true ->
%% 								 ReMaxFfc = MaxFfc
%% 						  end,
%% 						  {Flag, 1, Ffc, ReMaxFfc};
%% 					  2 ->
%% 						  ResOpen = data_player:is_opening_function(Player#player.ftst, ?FUNC_SIGN_GHOST),
%% 						  case ResOpen of
%% 							  true ->
%% 								  Ghost = Player#player.other#player_other.ghost,
%% 								  Ffc = lib_ghost:cpt_ghost_ffc(Ghost),
%% 								  MaxFfc = data_battle:get_std_grade(Flag, Player#player.lv),
%% 								  if Ffc > MaxFfc ->
%% 										 ReMaxFfc = Ffc;
%% 									 true ->
%% 										 ReMaxFfc = MaxFfc
%% 								  end,
%% 								  {Flag, 1, Ffc, ReMaxFfc};
%% 							  _ ->
%% 								  {Flag, 0, 0, 0}
%% 						  end;
%% 					  3 ->
%% 						  ResOpen = data_player:is_opening_function(Player#player.ftst, ?FUNC_SIGN_GIANT),
%% 						  case ResOpen of
%% 							  true ->
%% 								  Giant = lib_giant_s:get_act_giant(),
%% 								  Ffc = lib_giant_s:cpt_giant_ffc(Giant),
%% 								  MaxFfc = data_battle:get_std_grade(Flag, Player#player.lv),
%% 								  if Ffc > MaxFfc ->
%% 										 ReMaxFfc = Ffc;
%% 									 true ->
%% 										 ReMaxFfc = MaxFfc
%% 								  end,
%% 								  {Flag, 1, Ffc, ReMaxFfc};
%% 							  _ ->
%% 								  {Flag, 0, 0, 0}
%% 						  end;
%% 					  4 ->
%% 						  ResOpen = data_player:is_opening_function(Player#player.ftst, ?FUNC_SIGN_FRMT_PET),
%% 						  case ResOpen of
%% 							  true ->
%% 								  ActPetlist = lib_pet2:get_act_pets(Player#player.id),
%% 								  Ffc = lists:foldl(fun(X, Sum) -> lib_player:force_att_pet(X) + Sum end, 0, ActPetlist),
%% 								  MaxFfc = data_battle:get_std_grade(Flag, Player#player.lv),
%% 								  if Ffc > MaxFfc ->
%% 										 ReMaxFfc = Ffc;
%% 									 true ->
%% 										 ReMaxFfc = MaxFfc
%% 								  end,
%% 								  {Flag, 1, Ffc, ReMaxFfc};
%% 							  _ ->
%% 								  {Flag, 0, 0, 0}
%% 						  end;
%% 					  _ ->
%% 						  {0, 0, 0, 0}
%% 				  end
%% 		  end,
%% 	lists:map(Fun, List).
%% 
%% test_bd_record() ->
%% 	M = #battleMember{},
%% 	MLen = length(tuple_to_list(M)),
%% 	TLen = record_info(fields, battleMember),
%% 	{MLen, TLen}.
%% 	   
%% 	
%% 	
	
	
	
	
	
	
	
