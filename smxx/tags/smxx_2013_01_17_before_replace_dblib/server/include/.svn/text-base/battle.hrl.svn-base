
%%-------------战斗记录:-------------------------
-record(battle_record,{
					   bbtid = 0,             %%阵形基础ID（用于计算阵法相克）
					   behId = 0,     %%巨兽ID, 为0表示无
					   nick = "",       %%巨兽名称
					   behLv = 1,       %%巨兽等级
					   anger = 0,             %%怒气值
					   maxang = 100,          %%怒气上限
					   bact = 0,            %%是否攻击，0-未攻击，1-攻击了
					   behThId = 0,        %%巨兽技能ID
					   techv = 0,          %%巨兽技能攻击力
					   members = [],        %%由member记录组成的列表
					   frmtEquipDataR = [],  %%法器信息记录
					   mntDataR = [],     %%龙鞍信息记录
					   frsl = [],         %%巨兽对阵法的加成属性
					   frlv = 0,           %%巨兽对阵法加成的等级
					   img = 0,            %%巨兽形象
					   qly = 0,                %%巨兽品质
					   bgid = 0,                %%巨兽基础ID
					   teclv = 0,          %%巨兽技能等级
					   myatr = [],         %%巨兽对主角的加成属性列表
					   allatr = [],        %%巨兽对全队的加成属性列表
					   crr = 2             %%巨兽职业（等同攻击类型，1-武力，2-技能，3-法力）

					  }).
%%-----------成员记录:------------------------------
-record(member,{id,                    %%战斗角色id
				nick = "",                  %%名称
				crr = 0,                   %%职业
				mtype = 2,                 %%战斗角色类型（1:人物,2:宠物,3:怪物）默认为宠物怪物
				race = 0,                  %%种族ID
				pst = 0,                   %%九宫格位置
				psttp = {0,0},          		%%九宫格位置(二维：行，列)
				lv =1,                    %%等级
				%% add by chenzm for boss begin
				frhp=0,                   %%一轮战斗的初始气血
				defender=0,				  %%是否是守护者 0 - 否，1 - 是    
				%% add by chenzm for boss end
				hp =0,                   %%气血
				mxhp = 0,                %%最大气血
				mana = 50,                 %%气势   默认50
				mnup = 25,               %%气势增加值
				mxmn = 100,                 %%气势最大值
				sklid = 0,                  %%绝技id
				skllv = 1,      			%%绝技等级   默认1
				pwr = 0,                   %%内功
				tech = 0,                  %%技法
				mgc = 0,                  %%法力
				hit = 0,                   %%命中
				crit = 0,                   %%暴击
				ddge = 0,                  %%闪避
				blck = 0,                   %%格挡
				cter = 0,                   %%反击
				dbas = 0,					%%基础防御
				dpwr = 0,                  %%内功防御
				dtech = 0,                 %%技法防御
				dmgc = 0,                 %%法力防御
				abas = 0,				   %%基础攻击
				apwr = 0,                  %%内力攻击
				atech = 0,                 %%技法攻击
				amgc = 0,                 %%法力攻击
				roll = 0,                 %%碾压
				rela = 0,					%%亲密度
				dcrit = 0,               %%防暴击
				dblck = 0,               %%破格挡
				buffs=[],               %%buff列表 [{id, buffval, buffovernum},..]	{buff效果 ID,buff效果数值,buff持续次数}		
			    back_att=[],            %%反击位置
				icon = 0,               %%形象ID
				sex = 1,                 %%性别（1-男，2-女）
			    ffc = 0,                 %%战力（对人物有效）
				qly = 0,                 %%品质（对宠物有效）
%% 				%% 宠物阴阳历 begin
				copen = 0,              %% 是否开启阴阳历
				ctm=0,				  %%变身时间
				csta=0,                 %%是否变身				      
				cont = [],              %% 变身属性  [{Buff1, Value1}, {Buff2, Value2}...],如果Buff为0不显示  
%% 				%% 宠物阴阳历  end
				proty = 0,               %%先攻值（速度）
				tlidl = [],               %%天赋列表[天赋基础ID,..]
				atrlv = 0,                %%宠物总阶数（内功阶数+法力阶数+技法阶数）
				pasid = 0,                %%被动技能id
				paslv = 0,                %%被动技能等级
				pascan = 0,               %%被动技能是否有效（0-无效，1-有效）循环战斗单场战斗结束后要带出到新的battle_record中
				pasbuf = [],               %%被动技能BUFF
				fulltime = 0               %%累积修整时间（为先攻值倒数*10000000的累积和，注意先攻值为0的情况）
			   }).
%%----------Buff记录：---------------------------------------------
-record(buff,{id,                  %%buff效果 ID
			  buffval = 0,             %%buff效果数值
			  buffovernum = 0        %%buff持续次数
}).

%%阵型记录                                                                                刘菁  2011-8-11 添加
%% -record(formation,
%% 		{
%% %% 		 btaid=0,	%%阵法ID
%% 		 id = 0,    %%阵法ID
%% 		 uid=0,	    %%玩家ID
%% 		 bbtid=0,	%%基础阵法ID
%% 		 nick="",	%%名字
%% %% 		 lv=0,		%%等级
%% %% 		 bttlt=[],	%%默认技能列表，[{阵法技能ID,等级},..]
%% %% 		 techv=0,	%%剩余技能点
%% %% 		 bdesc="",	%%阵法描述
%% 		 rbidl=[],	%%相克阵型ID列表,[bbtid1, bbtid2,..] 
%% 		 posl=[],      %% 开启位置列表[{角色ID,角色类型,位格},..], 角色类型 1-人物、2-宠物,
%% 		 p1=[],		%%1号位,[{0/1/2,id},{dmgc,val},{apwr,val},..](第一个元组表示当前位置的开关{打开/关闭,站位角色类型（0-无人，1玩家，宠物）,对应角色id}，当加载到玩家第二个元组到最后的为阵法技能对当前位置的属性影响{属性标识,数值)
%% 		 p2=[],		%%2号位,同上
%% 		 p3=[],		%%3号位,同上
%% 		 p4=[],		%%4号位,同上
%% 		 p5=[],		%%5号位,同上
%% 		 p6=[],		%%6号位,同上
%% 		 p7=[],		%%7号位,同上
%% 		 p8=[],		%%8号位,同上
%% 		 p9=[]		%%9号位,同上
%% %% 		 btime=0,	%%时间戳,上次升级完成点的UNIX时间戳
%% %% 		 ltime=0,	%%冷却时间
%% %% 		 price=0	%%升级消耗铜钱数量
%% }).

%%外部实时更新--战斗开始时加载到战斗模块---------------------------------------------------------------------------------------
%%战斗数据记录
-record(battleData,
		{behId = 0,     %%巨兽ID, 为0表示无
		 nick = "",       %%巨兽名称
		 behLv = 0,       %%巨兽等级
		 anger = 0,        %%巨兽怒气
		 maxang = 100,          %%怒气上限
		 behThId = 0,        %%巨兽技能ID
		 techv = 0,          %%巨兽技能攻击力
		 members = [],        %%由battleMember记录组成的列表
		 frmtEquipDataR = [],  %%法器信息记录
		 mntDataR = [],     %%龙鞍信息记录
		 frsl = [],         %%巨兽对阵法的加成属性
		 frlv = 0,           %%巨兽对阵法加成的等级
		 img = 0,            %%巨兽形象
		 qly = 0,                 %%巨兽品质
		 bgid = 0,                %%巨兽基础ID
		 teclv = 0,          %%巨兽技能等级
		 myatr = [],         %%巨兽对主角的加成属性列表
		 allatr = [],        %%巨兽对全队的加成属性列表
		 crr = 2             %%巨兽职业（等同攻击类型，1-武力，2-技能，3-法力）
		}).
%%战斗成员记录
-record(battleMember,{id,              %%战斗角色id					  
					  nick = "",                  %%名称
					  crr = 0,                   %%职业
					  mtype = 0,                 %%战斗角色类型（1:人物,2:宠物,3:宠物）
					  race = 0,                  %%种族ID
					  lv = 0,                    %%等级
					  %% add by chenzm for boss begin
					  frhp=0,                   %%一轮战斗的初始气血
				      defender=0,				  %%是否是守护者 0 - 否，1 - 是    
				      %% add by chenzm for boss end
					  hp = 0,                   %%气血
					  mxhp = 0,                %%最大气血
					  mana = 50,                 %%气势
					  mnup = 25,               %%气势增加值
					  mxmn = 100,                  %%气势最大值
					  sklid = 0,                  %%绝技id
					  skllv = 0,      			%%绝技等级
					  pwr = 0,                   %%内功
					  tech = 0,                  %%技法
					  mgc = 0,                  %%法力
					  hit = 0,                   %%命中
					  crit = 0,                   %%暴击
					  ddge = 0,                  %%闪避
					  blck = 0,                   %%格挡
					  cter = 0,                   %%反击
					  dbas = 0,                   %%基础防御
					  dpwr = 0,                  %%内功防御
					  dtech = 0,                 %%技法防御
					  dmgc = 0,                 %%法力防御
					  abas = 0,					 %%基础攻击
					  apwr = 0,                  %%内力攻击
					  atech = 0,                 %%技法攻击
					  amgc = 0,                  %%法力攻击
					  roll = 0,					 %%碾压
					  rela = 0,           		 %%亲密度
					  dcrit = 0,                 %%防暴击
					  dblck = 0,                  %%破格挡
					  icon = 0,               %%形象ID
					  sex = 1,                 %%性别（1-男，2-女）
					  ffc = 0,                 %%战力（对人物有效）
					  qly = 0,                 %%品质（对宠物有效）
%% 					  %% 宠物阴阳历 begin
					  copen = 0,              %% 是否开启阴阳历
					  ctm=0,				  %%变身时间
					  csta=0,                 %%是否变身				      
					  cont = [],              %% 变身属性  [{Buff1, Value1}, {Buff2, Value2}...],如果Buff为0不显示  
%% 				      %% 宠物阴阳历  end
					  proty = 0,               %%先攻值 
					  tlidl = [],               %%天赋列表[天赋基础ID,..]
					  atrlv = 0,                %%宠物总阶数（内功阶数+法力阶数+技法阶数）
					  pasid = 0,                %%被动技能id
					  paslv = 0                 %%被动技能等级
			   }).
%%阵型克制记录
-record(formationRestraint,{
							drt=left,             %%受作用方
							eff=[]             %%作用效果
							}).
%%战斗状态记录
-record(battleSta,{					
					bBehemothAct = false,    	%%下次攻击是否启用巨兽攻击
					behemothActPst = 0,      	%%发动巨兽攻击的方位(left-表示左边巨兽，right-表示右边巨兽)
					bCter = false,           	%%下次攻击是否启用反击
					cterActPsttp = {},         	%%反击的攻击方坐标({left,Psttp}/{right,Psttp})
					cterDefPsttp = {},         	%%反击的防御方坐标({left,Psttp}/{right,Psttp})
					bRela = false,             	%%下次是否启用连携攻击
%% 					relaActPsttp = {},         	%%连携攻击的攻击方宠物坐标({left,Psttp}/{right,Psttp})
%% 					relaDefPsttp = {},        	%%连携攻击的防御方坐标({left,Psttp}/{right,Psttp})
					leftAllRela = 0,            %%左方连携判定概率（判定人物是否触发连携攻击）
					rightAllRela = 0,            %%右方连携判定概率（判定人物是否触发连携攻击）
					relaPlayerPsttp = {},       %%连携攻击的攻击方人物坐标({left,Psttp}/{right,Psttp})
					relaActPetPstL = [],      %%连携攻击的攻击方宠物坐标列表[Pst, ..]
					relaActNum = 0,             %%当次连携攻击已发生宠物连携次数（计算攻击力用）
					relaMustPetId = 0,          %%连携攻击不需rand点判定的宠物ID（连携率最高的宠物）
					bRelaActing = false,        %%连携必出标志位 
					killMonNum = 0 ,		   	%%杀死怪物的数量，兼容多人副本战斗
				  	costTime = 0 ,            	%%战斗耗时,兼容多人副本战斗
					bTeamBattle = false,			%%是否是多人副本，多人副本需要禁用连携攻击
					pDirect = normal,              %%战斗第一次攻击强制先攻方(如果是normal,则不判定先手，只按速度判定决定第一次攻击)：left、right、normal
					actLastDirect = right,            %%上回合出手方（每回战斗都需要记录），第一回合左方为优先判定出手（速度相同时）
					b_rela = 0        %%是否恒出连携(0-正常，1-恒出连携)
					
%% 					specialType = 1,           	%%（1-正常攻击，2-反击攻击，3-连携攻击，4-巨兽攻击）
%% 					actType = 1				  	%%本次攻击类型 （1-内力攻击，2-绝技攻击,3-法术攻击）
				  }).            
%%战斗攻击子类型记录
-record(battleSubType,{
					   bManaChange = false,     %%判定本次攻击攻击方是否增加气势
					   bRela = false,           %%判定本次攻击防守方是否可以发生连携运算  （暂时无用）
					   bCter = true,            %%判定本次攻击防守方是否可以发生反击运算
					   bAct = true,             %%攻击还是不攻击（true-攻击，false-不攻击）
					   missVal = 0,             %%攻击方的未命中率
					   hitVal = 0,              %%攻击方的命中率
					   critVal = 0,             %%攻击方的暴击率
					   dblck = 0,                  %%破格挡
					   lvVal = 0,               %%攻击方的等级					   
					   actType = 1,              %%主攻击类型ID(1-内力攻击，2-技能攻击，3-法力攻击)
					   typeId = 1,               %%子类型ID（1-普通内力攻击，2-技能伤害攻击，3-普通法术攻击，4-技能连击攻击，5-技能降气势攻击(包含伤害攻击效果)， 6-技能加气势，7-技能加血，8-技能换血，9-反击，10-巨兽攻击，11-连携攻击）不用，12-连击类型要传给客户端
					   skilFId = 0,               %%主动技能即时效果ID
					   actVal = 0,           %%攻击力（当为连击攻击时是普通攻击力，其余攻击都是技能攻击力），在攻击循环计算攻击力是为了减少在防守循环中计算带来的冗余（提升效率，当然在被攻击者为多个时，才能提升效率）
					   otherVal = 0,         %%其他属性值（如：加减的气势值、加血值）
					   manaVal = 0,        %%气势值，发动绝技攻击时高于100的气势能提高攻击力
					   upManaVal = 0,         %%攻击者在战斗中要加的额外气势（如：人物咒师职业发生暴击）
					   buffCancelList = [],       %%buff发生改变(取消)的角色位置列表:[Pst,..]
					   buffAddList = []           %%buffbuff发生改变(添加)的角色位置列表:[{Pst, buff Id},..]
					  }).       

%%多人副本中，各类攻击的时间权值
-record(attactTimeWight,{
						 attact_relat = 10,				%%连携攻击
						 attact_back = 8,				%%反击攻击
						 attact_behemoth = 5 ,          %%巨兽攻击	
					  	 attact_common = 10,            %%普通攻击
						 attact_skill = 10,             %%技能攻击
						 attact_notattack = 0           %%昏睡封足等BUFF导致的未发生攻击
					  }).

%%PVE战斗评分记录
-record(battleScore, {
					  score_round = 0,           %%战斗持续回合数
					  score_player_hurt = 0,     %%玩家伤害总和（攻击评分用）
					  score_player_luck = 0,     %%玩家队伍整场战斗中出现碾压、暴击，闪避，格挡总次数
					  score_mon_luck = 0,        %%怪物队伍整场战斗中出现碾压、暴击，闪避，格挡总次数
					  left_all_hp = 1,           %%左边阵营气血总和，初始为1防止除0的错误操作
					  right_all_hp = 1           %%右边阵营气血总和，初始为1防止除0的错误操作
					  }).

%%法器信息记录
-record(frmtEquipData, {
%% 						bOpen = 0,               %%是否激活法器（即天宫探宝是否开启）
						atrList = []             %%法器属性列表[{法器的BaseId, 法器等级},...]
						}).
%%龙鞍信息记录,属性类型:（1-技法攻击，2-技法防御，3-普通攻击，4-普通防御，5-生命值，6-命中率，7-格挡率，8-闪避率，9-暴击率，10-气势）
-record(mntData, {
%% 					  bOpen = 0,                %%是否装备龙鞍
					  qly = 0,                  %%龙鞍的品质(即开光度)
					  lv = 0,                   %%龙鞍等级
					  artList = []              %%龙鞍添加属性列表[{属性类型, 属性数值},...]
					   }).

%%被动技显示信息记录（包含主动技的气势加减）
-record(rolePasinfo, {
					  pst = 0,     %%被动技触发角色位置
					  imef = 0,    %%被动技即时效果类型ID
					  flag = 0,    %%被动技触发标志（0-取消，1-触发）
					  other_data = 0   %%技能附带效果数值
					  }).

%%运行时角色信息记录（由原来的L、R List列表[{Id, Type, Dr, Pst, Psttp},..]中的元组进化而来）(取消不用)
-record(role_battle_info, {
						   id = 0,      %%角色ID
						   type = 0,    %%角色类型
						   dr = left,   %%
						   pst = 0,
						   psttp = {0, 0},
						   fulltime = 0}).

%%外部带入战斗参数记录
-record(battle_other, {
					   binsta = 0,       %%战斗打包方式
					   b_rela = 0        %%是否恒出连携(0-正常，1-恒出连携)
					  }).
