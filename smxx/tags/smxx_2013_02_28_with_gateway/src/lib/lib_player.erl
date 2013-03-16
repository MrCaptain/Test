%%%--------------------------------------
%%% @Module  : lib_player
%%% @Author  : 
%%% @Created : 2010.10.05
%%% @Description:角色相关处理
%%%--------------------------------------
-module(lib_player).
-compile(export_all).

-include("common.hrl").
-include("record.hrl"). 
-include("battle.hrl").
-include("debug.hrl").

%%检测某个角色是否在线
is_online(PlayerId) ->
    case get_player_pid(PlayerId) of
        [] -> false;
        _Pid -> true
    end.

%%取得在线角色的进程PID
get_player_pid(PlayerId) ->
    PlayerProcessName = misc:player_process_name(PlayerId),
    case misc:whereis_name({global, PlayerProcessName}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true -> Pid;
                _ ->
                    []
            end;
        _ -> []
    end.

%% 根据角色名称查找ID, 返回Id或[]
get_role_id_by_name(Name) ->
    db_agent_player:get_role_id_by_name(Name).

%%根据角色id查找名称, 返回<<"名字">>或[]
get_role_name_by_id(Id)->
    db_agent_player:get_role_name_by_id(Id).

%%获取模块开启状态, 返回数字或[]
get_switch_by_id(Id)->
    db_agent_player:get_switch_by_id(Id).
    
%%检测指定名称的角色是否已存在
is_accname_exists(AccName) ->
    case db_agent_player:is_accname_exists(AccName) of
        []     -> false;
        _Other -> true
    end.

%% 通过角色ID取得帐号相关于私聊的信息
get_chat_info_by_id(PlayerId) ->
    case ets:lookup(?ETS_ONLINE, PlayerId) of
        [] ->
            db_agent_player:get_chat_info_by_id(PlayerId);
        [R] ->
            [R#player.nick, R#player.gender, R#player.career, R#player.camp, R#player.level]
    end.

%% 获取角色禁言信息
get_donttalk_status(PlayerId) ->
    case db_agent:get_donttalk(PlayerId) of
        [StopBeginTime, StopSeconds] ->
            [StopBeginTime, StopSeconds];
        _Other -> 
            db_agent:insert_donttalk(PlayerId),
            [0, 0]
    end.


%%检测指定名称的角色是否已存在
is_exists_name(Name) ->
    case get_role_id_by_name(Name) of
         []    -> false;
        _Other -> true
    end.

%%取得在线角色的角色状态
get_online_info(Id) ->
    case ets:lookup(?ETS_ONLINE, Id) of
           [] ->
                get_user_info_by_id(Id);
           [R] ->
               case misc:is_process_alive(R#player.other#player_other.pid) of
                   true -> 
                        R;
                   false ->
                       ets:delete(?ETS_ONLINE, Id),
                       []
               end
    end.

%%获取玩家信息
get_user_info_by_id(Id) ->
    case get_player_pid(Id) of
        []  -> [];
        Pid ->
             case catch gen:call(Pid, '$gen_call', 'PLAYER', 2000) of
                 {'EXIT',_Reason} ->
                      [];
                 {ok, Player} ->
                      Player
             end
    end.

%%获取用户信息(按字段需求)
get_online_info_fields(Id, L) when is_integer(Id) ->
    case get_player_pid(Id) of
        [] -> 
            [];
        Pid ->
            get_online_info_fields(Pid, L)
    end;

get_online_info_fields(Pid, L) when is_pid(Pid) ->
    case catch gen:call(Pid, '$gen_call', {'PLAYER', L}, 2000) of
           {'EXIT',_Reason} ->
                  [];
           {ok, PlayerFields} ->
                   PlayerFields
    end.

%% 增加铜钱
add_coin(Status, 0) ->  
    Status;
add_coin(Status, Num) ->
    Coin = max(Status#player.coin + Num, 0),
    db_agent_player:save_player_table(Status#player.id, [coin], [Coin]),
    Status#player{coin = Coin}.
%%消耗铜钱
cost_coin(Status, Num) ->
    Coin = max(Status#player.coin - Num, 0),
    db_agent_player:save_player_table(Status#player.id, [coin], [Coin]),
    Status#player{coin = Coin}.

%% 增加铜钱
add_bcoin(Status, 0) ->  
    Status;
add_bcoin(Status, Num) ->
    BCoin = max(Status#player.bcoin + Num, 0),
    db_agent_player:save_player_table(Status#player.id, [bcoin], [BCoin]),
    Status#player{bcoin = BCoin}.
%%消耗绑定铜钱
cost_bcoin(Status, Num) ->
    BCoin = max(Status#player.bcoin - Num, 0),
    db_agent_player:save_player_table(Status#player.id, [bcoin], [BCoin]),
    Status#player{bcoin = BCoin}.

%% 增加元宝
add_gold(Status, 0) ->  
    Status;
add_gold(Status, Num) ->
    Gold = max(Status#player.gold + Num, 0),
    db_agent_player:save_player_table(Status#player.id, [gold], [Gold]),
    Status#player{gold = Gold}.
%%消耗元宝
cost_gold(Status, Num) ->
    Gold = max(Status#player.gold - Num, 0),
    db_agent_player:save_player_table(Status#player.id, [gold], [Gold]),
    Status#player{gold = Gold}.

%% 增加元宝
add_bgold(Status, 0) ->  
    Status;
add_bgold(Status, Num) ->
    BGold = max(Status#player.bgold + Num, 0),
    db_agent_player:save_player_table(Status#player.id, [bgold], [BGold]),
    Status#player{bgold = BGold}.
%%消耗绑定元宝
cost_bgold(Status, Num) ->
    BGold = max(Status#player.bgold - Num, 0),
    db_agent_player:save_player_table(Status#player.id, [bgold], [BGold]),
    Status#player{bgold = BGold}.
    
%%增加元宝铜钱
add_money(Status, Coin, BCoin, Gold, BGold) ->
    Coin = max(Status#player.coin + Coin, 0),
    BCoin = max(Status#player.bcoin + BCoin, 0),
    Gold = max(Status#player.gold + Gold, 0),
    BGold = max(Status#player.bgold + BGold, 0),
    db_agent_player:save_player_table(Status#player.id, [coin, bcoin, gold, bgold], [Coin, BCoin, Gold, BGold]),
    Status#player{coin = Coin, bcoin = BCoin, gold = Gold, bgold = BGold}.
    
%%增加人物经验入口(FromWhere)
add_exp(Status, Exp, _FromWhere) ->
     NewExp = Status#player.exp + Exp,
     NewStatus = upgrade_to_next_level(Status#player{exp = NewExp}),
     db_agent_player:save_player_table(Status#player.id, [level, exp], [NewStatus#player.level, NewStatus#player.exp]),
     NewStatus.

%%升级到下一级
upgrade_to_next_level(Status) ->
    MaxLevel = data_player:max_level(),
    NewStatus = if Status#player.level < MaxLevel ->
           NextLvExp = data_player:next_level_exp(Status#player.career, Status#player.level),
           case Status#player.exp >= NextLvExp of
               true ->
                   Status1 = Status#player{level = Status#player.level + 1, exp = Status#player.exp - NextLvExp},
                   %%升级相应操作
                   %%省略1W行
                   upgrade_to_next_level(Status1);
               false ->
                   Status
           end;
       true -> %%已达最大级别
           Status
    end,
    %%重新计算一次战斗属性
    if NewStatus#player.level > Status#player.level ->
           calc_player_battle_attr(NewStatus);
       true ->
           NewStatus
    end.

% 发送玩家战斗力更新
send_player_attribute1(Status) ->
    ExpNextLevel = data_player:next_level_exp(Status#player.career, Status#player.level), 
    Data = [ Status#player.exp,
             ExpNextLevel,   
             Status#player.battle_attr#battle_attr.hit_point,
             Status#player.battle_attr#battle_attr.hit_point_max,
             Status#player.battle_attr#battle_attr.combopoint,
             Status#player.battle_attr#battle_attr.combopoint_max,
             Status#player.battle_attr#battle_attr.magic,
             Status#player.battle_attr#battle_attr.magic_max,
             Status#player.battle_attr#battle_attr.anger,
             Status#player.battle_attr#battle_attr.anger_max,
             Status#player.battle_attr#battle_attr.attack,
             Status#player.battle_attr#battle_attr.defense,
             Status#player.battle_attr#battle_attr.abs_damage,
             Status#player.battle_attr#battle_attr.fattack,
             Status#player.battle_attr#battle_attr.mattack,
             Status#player.battle_attr#battle_attr.dattack,
             Status#player.battle_attr#battle_attr.fdefense,
             Status#player.battle_attr#battle_attr.mdefense,
             Status#player.battle_attr#battle_attr.ddefense,
             Status#player.battle_attr#battle_attr.speed,
             Status#player.battle_attr#battle_attr.attack_speed,
             Status#player.battle_attr#battle_attr.hit_ratio,
             Status#player.battle_attr#battle_attr.dodge_ratio,
             Status#player.battle_attr#battle_attr.crit_ratio,
             Status#player.battle_attr#battle_attr.tough_ratio
           ],
    {ok, BinData} = pt_13:write(13003, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%% 发送玩家战斗力更新(基本)
%% 可用于战斗过程更新
send_player_attribute2(Status) ->
    Data = [ Status#player.battle_attr#battle_attr.hit_point,
             Status#player.battle_attr#battle_attr.hit_point_max,
             Status#player.battle_attr#battle_attr.combopoint,
             Status#player.battle_attr#battle_attr.combopoint_max,
             Status#player.battle_attr#battle_attr.magic,
             Status#player.battle_attr#battle_attr.magic_max,
             Status#player.battle_attr#battle_attr.anger,
             Status#player.battle_attr#battle_attr.anger_max
           ],
    {ok, BinData} = pt_13:write(13004, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%发送玩家金钱更新
send_player_attribute3(Status) ->
    Data = [ Status#player.gold,
             Status#player.bgold,
             Status#player.coin,
             Status#player.bcoin ],
    {ok, BinData} = pt_13:write(13005, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%发送玩家常用信息更新
send_player_attribute4(Status) ->
    Data = [ Status#player.exp,
             Status#player.lilian,
             Status#player.coin,
             Status#player.bcoin,
             Status#player.bgold
           ],
    {ok, BinData} = pt_13:write(13006, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%告诉客户端刷新属性
refresh_attr(Status, Key) ->
    Code = 
    case Key of
        bag    -> 1;
        money  -> 2;
        battle -> 3;
        _      -> 0 
    end,
    {ok, BinData} = pt_13:write(13010, [Code]),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

%%加载怪基本战斗属性
%%Career对人物是职业, 对怪是怪类型, 生命恢复最大
init_base_battle_attr(Level, Career) ->
    TempAttr = tpl_combat_attr:get(Level, Career),
    if is_record(TempAttr, temp_combat_attr) ->
           #battle_attr{
                        career = Career,          
                        skill_cd_all = 0,           
                        skill_cd_list = [],          
                        buff1 = [],              
                        combopoint_max = TempAttr#temp_combat_attr.hit_point_max, 
                        combopoint = 0,                
                        hit_point = TempAttr#temp_combat_attr.hit_point_max,    
                        hit_point_max = TempAttr#temp_combat_attr.hit_point_max,
                        magic = TempAttr#temp_combat_attr.magic_max,                     
                        magic_max = TempAttr#temp_combat_attr.magic_max,                 
                        anger = 0,                     
                        anger_max = TempAttr#temp_combat_attr.anger_max,                 
                        attack = TempAttr#temp_combat_attr.attack,                    
                        attack_ratio = 0,                             
                        defense = TempAttr#temp_combat_attr.defense,                   
                        defense_ratio = 0,             
                        abs_damage = TempAttr#temp_combat_attr.abs_damage,                
                        fattack = TempAttr#temp_combat_attr.fattack,                   
                        fattack_ratio = 0,              
                        mattack = TempAttr#temp_combat_attr.mattack,                   
                        mattack_ratio = 0,             
                        dattack = TempAttr#temp_combat_attr.dattack,                   
                        dattack_ratio = 0,             
                        fdefense = TempAttr#temp_combat_attr.fdefense,                  
                        fdefense_ratio = 0,            
                        mdefense = TempAttr#temp_combat_attr.mdefense,                   
                        mdefense_ratio = 0,            
                        ddefense = TempAttr#temp_combat_attr.ddefense,                   
                        ddefense_ratio = 0,            
                        speed = TempAttr#temp_combat_attr.speed,                      
                        attack_speed = TempAttr#temp_combat_attr.attack_speed,              
                        hit_ratio = TempAttr#temp_combat_attr.hit_ratio,                       
                        dodge_ratio = TempAttr#temp_combat_attr.dodge_ratio,  
                        crit_ratio = TempAttr#temp_combat_attr.crit_ratio,                      
                        tough_ratio = TempAttr#temp_combat_attr.tough_ratio,     
                        frozen_resis_ratio = TempAttr#temp_combat_attr.frozen_resis_ratio,
                        weak_resis_ratio = TempAttr#temp_combat_attr.weak_resis_ratio,
                        flaw_resis_ratio = TempAttr#temp_combat_attr.flaw_resis_ratio,
                        poison_resis_ratio = TempAttr#temp_combat_attr.poison_resis_ratio,
                        avoid_attack_ratio = 0,        
                        avoid_fattack_ratio = 0,       
                        avoid_mattack_ratio = 0,       
                        avoid_dattack_ratio = 0,       
                        avoid_crit_attack_ratio = 0,   
                        avoid_crit_fattack_ratio = 0,  
                        avoid_crit_mattack_ratio = 0,  
                        avoid_crit_dattack_ratio = 0,  
                        ignore_defense = 0,            
                        ignore_fdefense = 0,           
                        ignore_mdefense = 0,           
                        ignore_ddefense = 0 
                  };
   true ->
       ?ERROR_MSG("init_base_battle_attr: wrong paramter level: ~p, career: ~p~n", [Level, Career]),
       #battle_attr{}
   end.

%%加载玩家基本战斗属性
%%Career对人物是职业, 对怪是怪类型
init_base_battle_attr(Level, Career, BattleAttr) ->
    TempAttr = tpl_combat_attr:get(Level, Career),
    if is_record(TempAttr, temp_combat_attr) ->
           #battle_attr{
                        career = Career,          
                        skill_cd_all = 0,           
                        skill_cd_list = [],          
                        buff1 = [],              
                        combopoint_max = TempAttr#temp_combat_attr.hit_point_max, 
                        combopoint = BattleAttr#battle_attr.combopoint,                
                        hit_point = BattleAttr#battle_attr.hit_point,    
                        hit_point_max = TempAttr#temp_combat_attr.hit_point_max,
                        magic = BattleAttr#battle_attr.magic,                     
                        magic_max = TempAttr#temp_combat_attr.magic_max,                 
                        anger = BattleAttr#battle_attr.anger,                     
                        anger_max = TempAttr#temp_combat_attr.anger_max,                 
                        attack = TempAttr#temp_combat_attr.attack,                    
                        attack_ratio = 0,                             
                        defense = TempAttr#temp_combat_attr.defense,                   
                        defense_ratio = 0,             
                        abs_damage = TempAttr#temp_combat_attr.abs_damage,                
                        fattack = TempAttr#temp_combat_attr.fattack,                   
                        fattack_ratio = 0,              
                        mattack = TempAttr#temp_combat_attr.mattack,                   
                        mattack_ratio = 0,             
                        dattack = TempAttr#temp_combat_attr.dattack,                   
                        dattack_ratio = 0,             
                        fdefense = TempAttr#temp_combat_attr.fdefense,                  
                        fdefense_ratio = 0,            
                        mdefense = TempAttr#temp_combat_attr.mdefense,                   
                        mdefense_ratio = 0,            
                        ddefense = TempAttr#temp_combat_attr.ddefense,                   
                        ddefense_ratio = 0,            
                        speed = TempAttr#temp_combat_attr.speed,                      
                        attack_speed = TempAttr#temp_combat_attr.attack_speed,              
                        hit_ratio = TempAttr#temp_combat_attr.hit_ratio,                       
                        dodge_ratio = TempAttr#temp_combat_attr.dodge_ratio,  
                        crit_ratio = TempAttr#temp_combat_attr.crit_ratio,                      
                        tough_ratio = TempAttr#temp_combat_attr.tough_ratio,     
                        frozen_resis_ratio = TempAttr#temp_combat_attr.frozen_resis_ratio,
                        weak_resis_ratio = TempAttr#temp_combat_attr.weak_resis_ratio,
                        flaw_resis_ratio = TempAttr#temp_combat_attr.flaw_resis_ratio,
                        poison_resis_ratio = TempAttr#temp_combat_attr.poison_resis_ratio,
                        avoid_attack_ratio = 0,        
                        avoid_fattack_ratio = 0,       
                        avoid_mattack_ratio = 0,       
                        avoid_dattack_ratio = 0,       
                        avoid_crit_attack_ratio = 0,   
                        avoid_crit_fattack_ratio = 0,  
                        avoid_crit_mattack_ratio = 0,  
                        avoid_crit_dattack_ratio = 0,  
                        ignore_defense = 0,            
                        ignore_fdefense = 0,           
                        ignore_mdefense = 0,           
                        ignore_ddefense = 0 
                  };
   true ->
       ?ERROR_MSG("init_base_battle_attr: wrong paramter level: ~p, career: ~p~n", [Level, Career]),
       #battle_attr{}
   end.

% 计算装备属性,基本属性、强化、洗练等
recount_player_equip_attr(PlayerStatus) ->
	% 获取装备列表
	EquipList = lib_equip:get_own_equip_list(?LOCATION_PLAYER, PlayerStatus),
	% 获取装备基础属性列表
	EquipAttriList = lib_equip:get_equip_attri_list(EquipList),
	% 获取装备铸造属性
    CastingAttriList = lib_equip:get_equip_casting_attri(PlayerStatus, EquipList),
	% 获取全身强化奖励
    StrenRewardAttriList = lib_equip:get_equip_total_reward(EquipList),
    % 获取镶嵌全身加成
	% 套装装备加成
	% 镀金加成
	KeyValueList = StrenRewardAttriList ++ EquipAttriList ++ CastingAttriList,
	update_battle_attr(PlayerStatus, KeyValueList).

%%战斗属性计算
calc_player_battle_attr(Status) ->
	%% 初始化战斗属性
	%% TO_DO
	% 计算装备属性
	NewStatus1 = recount_player_equip_attr(Status),
    %%计算被动技能加成
    NewStatus2 = lib_skill:add_skill_attr_to_player(NewStatus1),
    NewStatus3 = lib_mount:add_mount_attr_to_player(NewStatus2),
    NewStatus3.

%%复活处理
%%清掉技能的BUFF
revive(Status, here) -> 
    OldBattleAttr = Status#player.battle_attr,
    NewBattleAttr = OldBattleAttr#battle_attr{hit_point = OldBattleAttr#battle_attr.hit_point_max,
											  magic = OldBattleAttr#battle_attr.magic_max},
    Status#player{battle_attr = NewBattleAttr};
revive(Status, city) -> 
    OldBattleAttr = Status#player.battle_attr,
    NewBattleAttr = OldBattleAttr#battle_attr{hit_point = round(OldBattleAttr#battle_attr.hit_point_max * 0.2),
											  magic = round(OldBattleAttr#battle_attr.magic_max * 0.2)},
    Status#player{battle_attr = NewBattleAttr}.

%%更新玩家的战斗属性
%%先不作范围检查,看看有没有值出现负或过大的情况
update_battle_attr(BattleAttr, []) ->
    BattleAttr;
update_battle_attr(Status, KeyValueList) when is_record(Status, player) ->
    NewBattleAttr = update_battle_attr(Status#player.battle_attr, KeyValueList),
    Status#player{battle_attr = NewBattleAttr};
update_battle_attr(BattleAttr, [{Key, Value}|T]) when is_record(BattleAttr, battle_attr) ->
    ?TRACE("update_battle_attr: Key ~p, Value ~p~n", [Key, Value]),
    NewBattleAttr = 
          case Key of
              combopoint_max ->             %% 最大连击点数()
                  BattleAttr#battle_attr{combopoint_max = BattleAttr#battle_attr.combopoint_max + Value};
              combopoint ->                 %% 连击点数(技能消耗/获得的属性,可额外增加伤害率或防御率)
                  NewCombopoint = min(BattleAttr#battle_attr.combopoint_max, max(0, BattleAttr#battle_attr.combopoint + Value)),
                  BattleAttr#battle_attr{combopoint = NewCombopoint};
              hit_point ->                  %% 生命	
                  NewHitPoint = min(BattleAttr#battle_attr.hit_point_max, max(0, BattleAttr#battle_attr.hit_point + Value)),
                  BattleAttr#battle_attr{hit_point = NewHitPoint};
              hit_point_max ->              %% 生命上限	
                  BattleAttr#battle_attr{hit_point_max = BattleAttr#battle_attr.hit_point_max + Value};
              magic ->                      %% 法力值	
                  NewMagic = min(BattleAttr#battle_attr.magic_max, max(0, BattleAttr#battle_attr.magic + Value)),
                  BattleAttr#battle_attr{magic = NewMagic};
              magic_max ->                  %% 法力值上限	
                  BattleAttr#battle_attr{magic_max = BattleAttr#battle_attr.magic_max + Value};
              anger ->                      %% 怒气值	
                  NewAnger = min(BattleAttr#battle_attr.anger_max, max(0, BattleAttr#battle_attr.anger + Value)),
                  BattleAttr#battle_attr{anger = NewAnger};
              anger_max ->                  %% 怒气值上限	
                  BattleAttr#battle_attr{anger_max = BattleAttr#battle_attr.anger_max + Value};
              attack ->                     %% 普通攻击力	
                  BattleAttr#battle_attr{attack = BattleAttr#battle_attr.attack + Value};
              attack_ratio ->               %% 普通攻击力伤害率(Buff附加值)                
                  BattleAttr#battle_attr{attack_ratio = BattleAttr#battle_attr.attack_ratio + Value};
              defense ->                    %% 普通防御力
                  BattleAttr#battle_attr{defense = BattleAttr#battle_attr.defense + Value};
              defense_ratio ->              %% 普通防御力防御率(Buff附加值)
                  BattleAttr#battle_attr{defense_ratio = BattleAttr#battle_attr.defense_ratio + Value};
              abs_damage ->                 %% 绝对伤害值	
                  BattleAttr#battle_attr{abs_damage = BattleAttr#battle_attr.abs_damage + Value};
              fattack ->                    %% 仙攻值
                  BattleAttr#battle_attr{fattack = BattleAttr#battle_attr.fattack + Value};
              fattack_ratio ->              %% 仙攻值伤害率(Buff附加值)      
                  BattleAttr#battle_attr{fattack_ratio = BattleAttr#battle_attr.fattack_ratio + Value};
              mattack ->                    %% 魔攻值	
                  BattleAttr#battle_attr{mattack = BattleAttr#battle_attr.mattack + Value};
              mattack_ratio ->              %% 魔攻值伤害率(Buff附加值)
                  BattleAttr#battle_attr{mattack_ratio = BattleAttr#battle_attr.mattack_ratio + Value};
              dattack ->                    %% 妖攻值
                  BattleAttr#battle_attr{dattack = BattleAttr#battle_attr.dattack + Value};
              dattack_ratio ->              %% 妖攻值伤害率(Buff附加值)
                  BattleAttr#battle_attr{dattack_ratio = BattleAttr#battle_attr.dattack_ratio + Value};
              fdefense ->                   %% 仙防值
                  BattleAttr#battle_attr{fdefense = BattleAttr#battle_attr.fdefense + Value};
              fdefense_ratio ->             %% 仙防值防御率(Buff附加值)
                  BattleAttr#battle_attr{fdefense_ratio = BattleAttr#battle_attr.fdefense_ratio + Value};
              mdefense ->                   %% 魔防值
                  BattleAttr#battle_attr{mdefense = BattleAttr#battle_attr.mdefense + Value};
              mdefense_ratio ->             %% 魔防值防御率(Buff附加值)
                  BattleAttr#battle_attr{mdefense_ratio = BattleAttr#battle_attr.mdefense_ratio + Value};
              ddefense ->                   %% 妖防值
                  BattleAttr#battle_attr{ddefense = BattleAttr#battle_attr.ddefense + Value};
              ddefense_ratio ->             %% 妖防值防御率(Buff附加值)
                  BattleAttr#battle_attr{ddefense_ratio = BattleAttr#battle_attr.ddefense_ratio + Value};
              speed ->                      %% 移动速度	
                  BattleAttr#battle_attr{speed = BattleAttr#battle_attr.speed + Value};
              attack_speed ->               %% 攻击速度	
                  BattleAttr#battle_attr{attack_speed = BattleAttr#battle_attr.attack_speed + Value};
              hit_ratio ->                  %% 命中率(Buff附加值)
                  BattleAttr#battle_attr{hit_ratio = BattleAttr#battle_attr.hit_ratio + Value};
              dodge_ratio ->                %% 闪避率(Buff附加值)	
                  BattleAttr#battle_attr{dodge_ratio = BattleAttr#battle_attr.dodge_ratio + Value};
              crit_ratio ->                 %% 暴击率(Buff附加值)
                  BattleAttr#battle_attr{crit_ratio = BattleAttr#battle_attr.crit_ratio + Value};
              tough_ratio ->                %% 坚韧率(Buff附加值)
                  BattleAttr#battle_attr{tough_ratio = BattleAttr#battle_attr.tough_ratio + Value};
              avoid_attack_ratio ->         %% 受到普攻免伤害率
                  BattleAttr#battle_attr{avoid_attack_ratio = BattleAttr#battle_attr.avoid_attack_ratio + Value};
              avoid_fattack_ratio ->        %% 受到仙攻免伤率
                  BattleAttr#battle_attr{avoid_fattack_ratio = BattleAttr#battle_attr.avoid_fattack_ratio + Value};
              avoid_mattack_ratio ->        %% 受到魔攻免伤率
                  BattleAttr#battle_attr{avoid_mattack_ratio = BattleAttr#battle_attr.avoid_mattack_ratio + Value};
              avoid_dattack_ratio ->        %% 受到妖攻免伤率
                  BattleAttr#battle_attr{avoid_dattack_ratio = BattleAttr#battle_attr.avoid_dattack_ratio + Value};
              avoid_crit_attack_ratio ->    %% 受到普攻暴击免伤害率
                  BattleAttr#battle_attr{avoid_crit_attack_ratio = BattleAttr#battle_attr.avoid_crit_attack_ratio + Value};
              avoid_crit_fattack_ratio ->   %% 受到仙攻暴击免伤率
                  BattleAttr#battle_attr{avoid_crit_fattack_ratio = BattleAttr#battle_attr.avoid_crit_fattack_ratio + Value};
              avoid_crit_mattack_ratio ->   %% 受到魔攻暴击免伤率
                  BattleAttr#battle_attr{avoid_crit_mattack_ratio = BattleAttr#battle_attr.avoid_crit_mattack_ratio + Value};
              avoid_crit_dattack_ratio ->   %% 受到妖攻暴击免伤率
                  BattleAttr#battle_attr{avoid_crit_dattack_ratio = BattleAttr#battle_attr.avoid_crit_dattack_ratio + Value};
              ignore_defense ->             %% 攻方忽略防方普防值(武魂引入)
                  BattleAttr#battle_attr{ignore_defense = BattleAttr#battle_attr.ignore_defense + Value};
              ignore_fdefense ->            %% 攻方忽略防方仙防值(武魂引入)
                  BattleAttr#battle_attr{ignore_fdefense = BattleAttr#battle_attr.ignore_fdefense + Value};
              ignore_mdefense ->            %% 攻方忽略防方魔防值(武魂引入)
                  BattleAttr#battle_attr{ignore_mdefense = BattleAttr#battle_attr.ignore_mdefense + Value};
              ignore_ddefense ->            %% 攻方忽略防方妖防值(武魂引入)
                  BattleAttr#battle_attr{ignore_ddefense = BattleAttr#battle_attr.ignore_ddefense + Value};
              _Other ->
                  ?ERROR_MSG("apply_effect: Unknown Key: ~p Value: ~p~n", [Key, Value]),
                  BattleAttr
          end,
    update_battle_attr(NewBattleAttr, T);
update_battle_attr(Other, _KeyVList)  ->
    ?ERROR_MSG("update_battle_attr: Unknown record: ~p,  Value: ~p~n", [Other, _KeyVList]),
    Other.

%%更新玩家的帮派信息
update_guild(Status) ->
    db_agent_player:save_player_table(
            Status#player.id, 
            [guild_id, guild_name, guild_post],
            [Status#player.guild_id, Status#player.guild_name, Status#player.guild_post]
    ).

