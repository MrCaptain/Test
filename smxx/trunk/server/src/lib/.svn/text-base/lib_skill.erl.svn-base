%%%-----------------------------------
%%% @Module  : lib_skill
%%% @Author  : water
%%% @Created : 2013.01.18
%%% @Description: 技能库函数
%%%-----------------------------------
-module(lib_skill).

-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

-export([role_login/1, 
         learn_skill/2,
         upgrade_skill/2,
         get_skill_info/1,
         check_skill_usable/2,
         update_player_battle_attr/2,
         update_mon_battle_attr/3,
         clear_player_battle_attr/1
        ]).
-compile(export_all).

%%处理登录加载技能, 取出当前玩家技能列表
role_login(Status) ->
    Skill = get_all_skill(Status#player.id, Status#player.career),
    NewPlayerOther = Status#player.other#player_other{skill_list = Skill#skill.cur_skill_list},
    Status#player{other = NewPlayerOther}.
    
%%更新玩家战斗属性(限玩家进程调用)
%%根据被动技能更新玩家战斗属性
add_skill_attr_to_player(Status) ->
    _SkillList = Status#player.other#player_other.skill_list,
    BattleAttr = Status#player.battle_attr,
    %%被动技能加成
    NewBattleAttr = BattleAttr#battle_attr{},
    Status#player{battle_attr = NewBattleAttr}.

%%开启技能模块
open_skill(Status) ->
    Status#player{switch = Status#player.switch bor ?SW_SKILL_BIT}.
    
%%学习技能 玩家进程调用
%%学习时后立刻回写数据库
learn_skill(Status, SkillId) ->
    case check_skill_learnable(Status, SkillId, 1) of
        true ->
            Skill = get_all_skill(Status#player.id, Status#player.career),
            RequireSkillList = data_skill:get_require_skill_list(SkillId, 1),
            case check_skill_requirement(Skill#skill.cur_skill_list, RequireSkillList) of
                true ->
                    case lists:keyfind(SkillId, 1, Skill#skill.cur_skill_list) of
                        {SkillId, _Lv} ->
                            {false, 6};  %技能已学习
                        false ->
                            NewSkillList = [{SkillId, 1}|Skill#skill.cur_skill_list],
                            NewSkill = Skill#skill{skill_list = NewSkillList, cur_skill_list = NewSkillList},
                            put(player_skill, NewSkill),
                            write_back_skill(),
                            NewPlayerOther = Status#player.other#player_other{skill_list = Skill#skill.cur_skill_list},
                            {true, Status#player{other = NewPlayerOther}}   %返回成功
                    end;
                false ->
                    {false, 5}  %%所学技能等级不够学习新技能
                end;
        false ->
            {false, 3} %%Level 
    end.

%%升级技能 玩家进程调用
%%升级立刻回写数据库
upgrade_skill(Status, SkillId) ->
    Skill = get_all_skill(Status#player.id, Status#player.career),
    case lists:keyfind(SkillId, 1, Skill#skill.cur_skill_list) of
        false ->
            {false, 5};   %技能未学习
        {SkillId, Lv} ->
            case check_skill_lv(SkillId, Lv+1) of %%技能新等级是否有效
                true ->
                    case check_skill_upgrade(Status, Skill#skill.cur_skill_list, {SkillId, Lv+1}) of
                        true ->
                            %{CoinCost, EmpCost} = get_upgrade_cost(SkillId, Lv + 1),
                            NewSkillList = lists:keyreplace(SkillId, 1, Skill#skill.cur_skill_list, {SkillId, Lv+1}),
                            NewSkill = Skill#skill{skill_list = NewSkillList, cur_skill_list = NewSkillList},
                            put(player_skill, NewSkill),
                            write_back_skill(),
                            NewPlayerOther = Status#player.other#player_other{skill_list = Skill#skill.cur_skill_list},
                            {true, Status#player{other = NewPlayerOther}};        %返回成功
                        false ->
                            {false, 3}  %%人物等级不足或技能等级不足
                    end;
                false ->
                    {false, 0} %%无效参数
            end
    end.
    
%%查看技能信息, 21000协议
get_skill_info(Status)->
    Skill = get_all_skill(Status#player.id, Status#player.career),
    F = fun({SkillId, Level}, SkillList) ->
            case data_skill:get_type(SkillId) of   
                0 -> SkillList;                      %%0为普通技能,不发到客户端
                _ -> [[SkillId, Level] | SkillList]
            end
    end,
    lists:foldr(F, [], Skill#skill.cur_skill_list).

%%----------------------------------------------------------
%%战斗相关技能函数
%%----------------------------------------------------------
%%功能: 检查战斗过程技能是否可用.
%%返回: true 技能可用, false 技能不可用
%%      检查技能CD, 消耗法力,怒气值 这里不修改任何战斗属性
check_skill_usable(Status, SkillId) ->
    CurSkillList = Status#player.other#player_other.skill_list,
    case lists:keyfind(SkillId, 1, CurSkillList) of
        {SkillId, SkillLv} ->  %%已学习技能
            TempSkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
            ?ASSERT(is_record(TempSkillAttr, temp_skill_attr)),
            BattleAttr = Status#player.battle_attr,
            NowLong = util:longunixtime(),  %%毫秒值

            %%检查是否需要消耗怒气值及法力值
            if (BattleAttr#battle_attr.anger < TempSkillAttr#temp_skill_attr.cost_anger) orelse
               (BattleAttr#battle_attr.magic < TempSkillAttr#temp_skill_attr.cost_magic) ->
                   false;  %%怒气值或法力值不够
               BattleAttr#battle_attr.skill_cd_all > NowLong ->
                   false;  %%技能CD还没有到
               true ->
                    %%检查是否有技能CD组
                    case lists:keyfind(SkillId, 1, BattleAttr#battle_attr.skill_cd_list) of
                        {SkillId, ExpireTime} ->
                            NowLong =< ExpireTime;
                        false ->
                            true
                    end
            end;
        false ->  %%未学习的技能,不能使用
            false
    end.

%%功能: 检查战斗过程怪的技能是否可用.
%%返回: true 技能可用, false 技能不可用
%%      对怪只检查技能CD  这里不修改任何战斗属性
check_skill_usable(BattleAttr, SkillId, SkillLv) ->
    TempSkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    ?ASSERT(is_record(TempSkillAttr, temp_skill_attr)),
    NowLong = util:longunixtime(),  %%毫秒值
    %%检查是否需要消耗怒气值及法力值
    if BattleAttr#battle_attr.skill_cd_all > NowLong ->
           false;  %%技能CD还没有到
       BattleAttr#battle_attr.sing_expire > NowLong ->
           false;  %%吟唱时间中
       true ->
           %%检查是否有技能CD组
           case lists:keyfind(SkillId, 1, BattleAttr#battle_attr.skill_cd_list) of
               {SkillId, ExpireTime} ->
                   NowLong =< ExpireTime;
               false ->
                   true
           end
    end.
    
%%功能: 战斗过程玩家技能Buff处理,需要计算伤害前调用
%%返回: 新的玩家Status, 更新后战斗记录BattleAttr
%%      1: 扣除技能消耗的怒气值
%%      2: 已过期的Buff解除, 应用周期性技能BUFF
%%      3: CD处理
update_player_battle_attr(Status, SkillId) ->
    CurSkillList = Status#player.other#player_other.skill_list,
    case lists:keyfind(SkillId, 1, CurSkillList) of
        {SkillId, SkillLv} ->  %%已学习技能
            BattleAttr = update_battle_attr(Status#player.battle_attr, SkillId, SkillLv),
            %%更新玩家结构
            Status#player{battle_attr = BattleAttr};
        false ->  %%未学习的技能,不能使用
            ?ERROR_MSG("lib_skill: Uid: ~p  Error skillid:~p~n", [Status#player.id, SkillId]),
            Status
    end.

%%功能: 战斗过程怪的技能处理,需要计算伤害前调用
%%返回: 新的战斗属性Status
%%      1: 扣除技能消耗的怒气值
%%      2: 已过期的Buff解除, 应用周期性的技能BUFF
%%      3: CD处理
update_mon_battle_attr(BattleAttr, SkillId, SkillLv) ->
    BattleAttr1 = update_battle_attr(BattleAttr, SkillId, SkillLv),
    NowLong = util:longunixtime(),  %%毫秒值
    {_SingBreak,SingTime} = data_skill:get_sing(SkillId),
    if 
       SingTime > 0 -> %%检查是否有吟唱时间, 有就加上
            BattleAttr1#battle_attr{sing_expire = NowLong + SingTime};
       NowLong >= BattleAttr1#battle_attr.sing_expire ->  %%吟唱时间已到,清为0
            BattleAttr1#battle_attr{sing_expire = 0};
       true ->
            BattleAttr1
    end.

%%群体攻击技能Buff处理(技能Buff对被攻击方所有人)
%%参数:　SkillId, SkillLv为攻方技能
%%　     DerList为守方战斗结构列表
%%返回: NewDerList
update_der_battle_attr(SkillId, SkillLv, DerList) when is_list(DerList) ->
    ?ASSERT(data_skill:get_type(SkillId) =:= 2),
    NowLong = util:longunixtime(),
    SkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    ?ASSERT(is_record(SkillAttr, temp_skill_attr)),
    %%应用新BUFF
    F = fun(Der) ->
        buff_util:active_skill_buff(Der, SkillAttr#temp_skill_attr.buff, NowLong)
    end,
    lists:map(F, DerList);

%%单体攻击技能Buff处理(技能Buff对被攻击方)
%%参数:　SkillId, SkillLv为攻方技能
%%　　　 Der为守方战斗结构信息
%%返回:  NewDer
update_der_battle_attr(SkillId, SkillLv, Der) ->
    ?ASSERT(data_skill:get_type(SkillId) =:= 1),
    NowLong = util:longunixtime(),
    SkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    ?ASSERT(is_record(SkillAttr, temp_skill_attr)),
    %%应用新BUFF
    buff_util:active_skill_buff(Der, SkillAttr#temp_skill_attr.buff, NowLong).


%%群体辅助技能Buff处理(技能Buff对已方所有人)
%%参数:　SkillId, SkillLv为攻方技能
%%　　　 AerList为攻方战斗结构列表
%%返回:  NewAerList
update_aer_battle_attr(SkillId, SkillLv, AerList) when is_list(AerList) ->
    ?ASSERT(data_skill:get_type(SkillId) =:= 4),
    NowLong = util:longunixtime(),
    SkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    ?ASSERT(is_record(SkillAttr, temp_skill_attr)),
    %%应用新BUFF
    F = fun(Aer) ->
        buff_util:active_skill_buff(Aer, SkillAttr#temp_skill_attr.buff, NowLong)
    end,
    lists:map(F, AerList);

%%单体辅助技能Buff处理(技能Buff对自己)
%%参数:　SkillId, SkillLv为攻方技能
%%　　　 Aer为战斗结构
%%返回:  NewAer
update_aer_battle_attr(SkillId, SkillLv, Aer) ->
    ?ASSERT(data_skill:get_type(SkillId) =:= 3),
    NowLong = util:longunixtime(),
    SkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    ?ASSERT(is_record(SkillAttr, temp_skill_attr)),
    %%应用新BUFF
    buff_util:active_skill_buff(Aer, SkillAttr#temp_skill_attr.buff, NowLong).

%%功能: 通知战斗开始, 设置玩家战斗技能状态 
%%返回: 新的玩家Status, 更新后战斗记录BattleAttr
%%      1: 清理战斗记录的skill_cd_list, skill_cd_all
%%      2: 清空skill_buff列表
clear_player_battle_attr(Status) -> 
    NewBattleAttr = clear_battle_attr(Status#player.battle_attr),
    Other = Status#player{battle_attr = NewBattleAttr},
    Status#player{other = Other}.

%%----------------------------------------------------------
%%技能内部函数
%%----------------------------------------------------------
%%功能: 战斗过程技能处理,需要计算伤害前调用
%%返回: 更新后战斗记录BattleAttr
%%      1: 扣除技能消耗的怒气值
%%      2: 已过期的Buff解除, 周期性BUFF应用
%%      3: CD处理
update_battle_attr(BattleAttr, SkillId, SkillLv) ->
    SkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    ?ASSERT(is_record(SkillAttr, temp_skill_attr)),
    NowLong = util:longunixtime(),
    %%扣除技能消耗的法力值与怒气值
    {CostAnger, CostMagic} = {SkillAttr#temp_skill_attr.cost_anger,
                              SkillAttr#temp_skill_attr.cost_magic},

    BattleAttr1 = BattleAttr#battle_attr{anger = max(0, BattleAttr#battle_attr.anger - CostAnger),
                                         magic = max(0, BattleAttr#battle_attr.magic - CostMagic)},
    %%解除旧的BUFF
    BattleAttr2 = buff_util:deactive_skill_buff(BattleAttr1, NowLong),
    %%应用周期性Buff
    BattleAttr3 = buff_util:refresh_skill_buff(BattleAttr2, NowLong),
    %%检查是否可以使用连击点
    BattleAttr4 = apply_combopoint_usage(BattleAttr3, SkillId),
    %%CD处理: 
    NewBattleAttr = update_skill_cd(BattleAttr4, SkillId, NowLong),
    NewBattleAttr.

%%功能: 战斗结束, 解除玩家战斗技能增加的属性 
%%返回: 更新后战斗记录BattleAttr
%%      1: 清理战斗记录的skill_cd_list, skill_cd_all
%%      2: 清空skill_buff列表
%%      3: 使用连击点增加的属性攻击值
clear_battle_attr(BattleAttr) -> 
    %%去除使用的连击点增加的属性攻击值
    BattleAttr1 = 
    if BattleAttr#battle_attr.use_combopoint >= 1 ->
           case BattleAttr#battle_attr.career of
               ?CAREER_F ->  
                    BattleAttr#battle_attr{
                                 use_combopoint = 0,
                                 fattack = max(BattleAttr#battle_attr.fattack - BattleAttr#battle_attr.use_combopoint*100, 0)
                             };
               ?CAREER_M -> 
                     BattleAttr#battle_attr{
                                 use_combopoint = 0,
                                 mattack = max(BattleAttr#battle_attr.mattack - BattleAttr#battle_attr.use_combopoint*100, 0)
                              };
               ?CAREER_D -> 
                     BattleAttr#battle_attr{
                                 use_combopoint = 0,
                                 dattack = max(BattleAttr#battle_attr.dattack - BattleAttr#battle_attr.use_combopoint*100, 0)
                              };
               _Other    -> 
                     BattleAttr
           end;
      true ->
          BattleAttr
    end,
    %%清理Buff
    BattleAttr2 = buff_util:clear_skill_buff(BattleAttr1),
    %%清除技能的CD及Buff列表, 吟唱时间    
    BattleAttr2#battle_attr{sing_expire = 0, skill_cd_all = 0, skill_cd_list = []}.


%%检查是否可以使用连击点
%%可以使用连击点,应用连击点到属性攻击
apply_combopoint_usage(BattleAttr, SkillId) ->
    case data_skill:get_combopoint_usage(SkillId) of
        true  ->
            %%去除上次使用的连击点增加的属性攻击值
            BattleAttr1 = 
            if BattleAttr#battle_attr.use_combopoint >= 1 ->
                   case BattleAttr#battle_attr.career of
                       ?CAREER_F ->  
                            BattleAttr#battle_attr{
                                         use_combopoint = 0,
                                         fattack = max(BattleAttr#battle_attr.fattack - BattleAttr#battle_attr.use_combopoint*100, 0)
                                     };
                       ?CAREER_M -> 
                             BattleAttr#battle_attr{
                                         use_combopoint = 0,
                                         mattack = max(BattleAttr#battle_attr.mattack - BattleAttr#battle_attr.use_combopoint*100, 0)
                                      };
                       ?CAREER_D -> 
                             BattleAttr#battle_attr{
                                         use_combopoint = 0,
                                         dattack = max(BattleAttr#battle_attr.dattack - BattleAttr#battle_attr.use_combopoint*100, 0)
                                      };
                       _Other1 -> 
                             BattleAttr
                   end;
              true ->
                  BattleAttr
            end,
            %%应用本次使用连击点增加属性攻击值
            if BattleAttr1#battle_attr.combopoint >= 1 ->
                   UseCombopoint = min(BattleAttr1#battle_attr.combopoint, BattleAttr1#battle_attr.combopoint_max),
                   case BattleAttr1#battle_attr.career of
                       ?CAREER_F ->  
                            BattleAttr1#battle_attr{
                                         use_combopoint = UseCombopoint,
                                         combopoint = BattleAttr1#battle_attr.combopoint - UseCombopoint,
                                         fattack = BattleAttr1#battle_attr.fattack +  UseCombopoint * 100
                                     };
                       ?CAREER_M -> 
                             BattleAttr1#battle_attr{
                                         use_combopoint = UseCombopoint,
                                         combopoint = BattleAttr1#battle_attr.combopoint - UseCombopoint,
                                         mattack = BattleAttr1#battle_attr.mattack + UseCombopoint * 100
                                      };
                       ?CAREER_D -> 
                             BattleAttr1#battle_attr{
                                         use_combopoint = UseCombopoint,
                                         combopoint = BattleAttr1#battle_attr.combopoint - UseCombopoint,
                                         dattack = BattleAttr1#battle_attr.dattack + UseCombopoint * 100
                                      };
                       _Other2 -> 
                             BattleAttr1
                   end;
               true ->
                  BattleAttr1
           end;
       false -> 
           BattleAttr
    end.

%%更新战斗技能的CD值
%%SkillCdList: [{SkillId, CdTime},...], CdTime为unixtime毫秒
update_skill_cd(BattleAttr, SkillId, Now) ->
    TempSkill = tpl_skill:get(SkillId),
    ?ASSERT(is_record(TempSkill, temp_skill)),

    %%CD处理: 移除旧的CD. 能跑到这里, SkillId是可以使用,旧的CD已无效, 不用重复检查
    SkillCdList = lists:keydelete(SkillId, 1, BattleAttr#battle_attr.skill_cd_list),
    
    %%是否有对技能单独的CD 
    if TempSkill#temp_skill.cd_group =/= [] ->
           F = fun({Sid, CdTime}, CdList) ->
                case lists:keyfind(Sid,1, CdList) of
                    {Sid, Time} ->  %%技能已有CD, 取CD较长者
                        CdList1 = lists:keydelete(Sid, 1, CdList),
                        [{Sid, max(Now + CdTime, Time)}|CdList1];
                    false ->        %%技能未有CD,加到CD列表
                        [{Sid, Now + CdTime}|CdList]
                end
           end,
           NewCdList = lists:foldr(F, SkillCdList, TempSkill#temp_skill.cd_group);
       true ->
           NewCdList = SkillCdList
    end,

    %%对所有技能CD,
    if TempSkill#temp_skill.cd_all > 0 ->
           BattleAttr#battle_attr{skill_cd_all = Now + TempSkill#temp_skill.cd_all,
                                  skill_cd_list = NewCdList};
       true ->
           BattleAttr#battle_attr{skill_cd_list = NewCdList}
    end.

%% 获取所有技能, 玩家进程调用. 其他进程不要调用
%% 参数: PlayerId 玩家ID
%% 返回: 技能记录 skill
get_all_skill(PlayerId, Career) ->
    Skill = 
        case get(player_skill) of
            undefined ->
                case db_agent_skill:get_skill(PlayerId) of
                    [] -> %%默认技能是普通攻击
                        {DefaultSid, DefaultLv} = data_skill:get_default_skill(Career),
                        InitSkill = #skill{ 
                                        uid = PlayerId,
                                        skill_list = [{DefaultSid, DefaultLv}],
                                        cur_skill_list = [{DefaultSid, DefaultLv}]
                                      },
                        db_agent_skill:insert_skill(InitSkill),
                        InitSkill;
                    Other ->
                        Other
                end;
            Data -> 
                Data
        end,
    ?ASSERT(is_record(Skill, skill)),
    put(player_skill, Skill),
    Skill.

%% 回写技能数据到数据库. 仅玩家进程调用. 
%% PlayerId 玩家ID
write_back_skill() ->
    case get(player_skill) of
        undefined ->
            skip;
        Skill -> 
            db_agent_skill:update_skill(Skill)
    end.

%%检查技能ID是否有效, 有效返回true,否则false
check_skill_id(SkillId) ->
    SkillTemp = tpl_skill:get(SkillId),
    is_record(SkillTemp, temp_skill).

%%检查技能ID,等级是否有效,有效返回true,否则false
check_skill_lv(SkillId, SkillLv) ->
    SkillTemp = tpl_skill:get(SkillId),
    SkillAttr = tpl_skill_attr:get(SkillId, SkillLv),
    is_record(SkillTemp, temp_skill) andalso is_record(SkillAttr, temp_skill_attr).

%%检查技能是否可学, 检查技能类型, 职业限制, 等级要求
%%可以学习返回 true, 否则返回 false
check_skill_learnable(Status, SkillId, Lv) ->
    TempSkill = tpl_skill:get(SkillId),
    TempSkillAttr = tpl_skill:get(SkillId, Lv),
    is_record(TempSkill, temp_skill) andalso 
    is_record(TempSkillAttr, temp_skill_attr) andalso
    (TempSkill#temp_skill.type =/= 0) andalso  %%可以学习的技能技能(普通默认技能不用学习)
    (TempSkill#temp_skill.stype =:= 1) andalso %%玩家技能
    ((TempSkill#temp_skill.career =:= 0) orelse (Status#player.career =:= TempSkill#temp_skill.career)) andalso
    (Status#player.level >= TempSkillAttr#temp_skill_attr.learn_level).

%%检查技能是否可以升级
check_skill_upgrade(Status, CurSkillList, {SkillId, Lv}) ->
   TempSkillAttr = tpl_skill:get(SkillId, Lv),
   is_record(TempSkillAttr, temp_skill_attr) andalso
   (Status#player.level >= TempSkillAttr#temp_skill_attr.learn_level) andalso
   check_skill_requirement(CurSkillList, TempSkillAttr#temp_skill_attr.require_list).

%%学习技能时检查: 检查当前技能列表是否满足要求的技能列表
%%满足时返回true, 否则false
check_skill_requirement(_CurSkillList, []) ->
    true;
check_skill_requirement(CurSkillList, [{SkillId, SkillLv}|T]) ->
    case lists:keyfind(SkillId, 1,  CurSkillList) of
        {SkillId, Lv} ->
            if Lv >= SkillLv ->
                check_skill_requirement(CurSkillList, T); %%满足,比较下一个技能要求
            true ->
                false   %%等级不满足
            end;
        false ->
            false       %%技能未学习,不满足
    end.
    
