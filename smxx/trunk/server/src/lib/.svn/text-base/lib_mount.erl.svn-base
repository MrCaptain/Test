%%%-----------------------------------
%%% @Module  : lib_mount
%%% @Author  : water
%%% @Created : 2013.01.18
%%% @Description: 技能库函数
%%%-----------------------------------
-module(lib_mount).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-include("mount.hrl").
-include("log.hrl").
-compile(export_all).

%%处理登录加载座骑
role_login(Status) ->
    case (Status#player.switch band ?SW_MOUNT_BIT) =:= ?SW_MOUNT_BIT of
        true  ->  
            case get_mount(Status#player.id) of
                [] ->
                    open_mount(Status);
                Mount ->
                    {TodayMidnight, _} = util:get_midnight_seconds(Status#player.last_login_time),
                    if Status#player.last_login_time >= TodayMidnight andalso
                       Status#player.logout_time < TodayMidnight ->
                            Mount1 = Mount#mount{skill_times = 0},
                            ets:insert(?ETS_MOUNT, Mount1),
                            spawn(fun() -> db_agent_mount:update_mount_skill_times(Mount1) end);
                    true ->
                            ets:insert(?ETS_MOUNT, Mount)
                    end,
                    Status#player{other = Status#player.other#player_other{mount_fashion = Mount#mount.fashion}}
            end;
        false ->  
            Status
    end.

%%处理登出时回写座骑记录
role_logout(Status) ->
    %write_back_mount(Status#player.id),
    ets:delete(?ETS_MOUNT, Status#player.id).
    
%%开启坐骑功能
open_mount(Status) ->
    NewMount = #mount{ uid = Status#player.id,
                       state = 0,
                       exp = 0,
                       level = 1,
                       star = 0,
                       fashion = 0,
                       skill_times = 0,
                       skill_list = [],
                       fashion_list = [],
                       old_fashion_list = []
                     },
    ets:insert(?ETS_MOUNT, NewMount),
    db_agent_mount:insert_mount(NewMount),
    Status#player{switch = Status#player.switch bor ?SW_MOUNT_BIT,
                  other = Status#player.other#player_other{mount_fashion = NewMount#mount.fashion}
                 }.

%%更新玩家战斗属性
%%根据座骑级别技能更新玩家战斗属性
add_mount_attr_to_player(Status) ->
    case (Status#player.switch band ?SW_MOUNT_BIT) =:= ?SW_MOUNT_BIT of
        true  ->  
            case get_mount(Status#player.id) of
                [] ->
                    Status;
                Mount ->
                    BattleAttr1 = lib_player:update_battle_attr(Status#player.battle_attr, get_attr_by_level(Mount)),
                    BattleAttr2 = lib_player:update_battle_attr(BattleAttr1, get_attr_by_skill(Mount)),
                    %%座骑阶级+被动技能加成
                    Status#player{battle_attr = BattleAttr2}
            end;
        false ->  
            Status
    end.

%%升级技能. 随机产生技能增加经验
%%技能经验不刷新到客户端, 等客户端来播完特效后来主动刷新
random_skill_exp(Status) ->
  case get_mount(Status#player.id) of
        [] ->
            {false, ?MOUNT_ERROR};   %%座骑功能末开通
        Mount ->
            FreeTimes = data_config:mount_config(skill_free_times),
            GoldCost = data_config:mount_config(skill_gcost),
            if Mount#mount.skill_times < FreeTimes ->
                AllSkill = [0|data_config:get_all_mount_skill()],
                Rand = lists:map(fun(_) -> lists:nth(util:rand(1,length(AllSkill)), AllSkill) end, lists:seq(1,4)),
                put(skill_exp, Rand),
                {true, Rand};
            true ->
                case goods_util:has_enough_money(Status, GoldCost, ?MONEY_T_BGOLD) of
                    true ->
                        AllSkill = [0|data_config:get_all_mount_skill()],
                        Rand = lists:map(fun(_) -> lists:nth(util:rand(1,length(AllSkill)), AllSkill) end, lists:seq(1,4)),
                        put(skill_exp, Rand),
                        NewStatus = goods_util:cost_money(Status, GoldCost, ?MONEY_T_BGOLD, ?LOG_MOUNT_SKILL),
                        {true, Rand, NewStatus};
                    false ->
                        {false, ?MOUNT_GOLD_NOT_ENOUGH}
                end 
            end
    end.

%%刷新座骑技能信息, 更新到玩家
update_skill_exp(Status) ->
    case get(skill_exp) of
        undefined ->
            {false, ?MOUNT_ERROR};
        Rand ->
           case get_mount(Status#player.id) of
                [] ->
                    {false, ?MOUNT_ERROR};   
                Mount ->
                    NewMount = add_skill_exp_random(Mount, Rand),
                    ets:insert(?ETS_MOUNT, NewMount),
                    spawn(fun() -> db_agent_mount:update_mount_skill(NewMount) end),
                    put(skill_exp, undefined),
                    F1 = fun({SkillId, Level, Exp}) ->
                         [SkillId, Level, Exp]
                    end,
                    SkillList = lists:map(F1, Mount#mount.skill_list),
                    {true, SkillList}
            end
    end.    

%%切换座骑幻化外观
change_fashion(Status, FashionId) ->
    case get_mount(Status#player.id) of
        Mount when is_record(Mount, mount) ->
            case lists:member(FashionId, Mount#mount.fashion_list) of
                false ->
                    {false, ?MOUNT_FASHION_NOT_EXIST};   %%幻化装没有
                true ->
                    NewMount = Mount#mount{fashion = FashionId},
                    ets:insert(?ETS_MOUNT, NewMount),
                    spawn(fun()->db_agent_mount:update_mount_fashion(NewMount) end),
                    Status1 = Status#player{other = Status#player.other#player_other{mount_fashion = FashionId}},
                    {true, Status1}        %返回成功
            end;
        _Other ->
            {false, ?MOUNT_ERROR}
    end.
    
%%上座骑
get_on_mount(Status) ->
    case get_mount(Status#player.id) of
        [] -> {false, ?MOUNT_ERROR};
        Mount ->
            if Mount#mount.state =:= 0 ->
                   %%更新玩家移动的计算速度
                   NewSpeed = Status#player.battle_attr#battle_attr.speed + data_config:mount_config(move_speed),
                   Status1 = Status#player{
                                battle_attr = Status#player.battle_attr#battle_attr{speed = NewSpeed},
                                other = Status#player.other#player_other{mount_fashion = Mount#mount.fashion}
                             },
                   {true, Status1};
            true ->
                   {false, ?MOUNT_ALREADY_ONMOUNT}
            end
    end.

%%下座骑
get_off_mount(Status) -> 
    case get_mount(Status#player.id) of
        [] -> {false, ?MOUNT_ERROR};
        Mount ->
            if Mount#mount.state >= 1 ->
                %%更新玩家移动速度
                NewSpeed = Status#player.battle_attr#battle_attr.speed - data_config:mount_config(move_speed),
                Status1 = Status#player{battle_attr = Status#player.battle_attr#battle_attr{speed = NewSpeed},
                              other = Status#player.other#player_other{mount_fashion = 0}},
                {true, Status1};
            true ->
                {false, ?MOUNT_NOT_ON_MOUNT}
            end
    end.

%%升星
upgrade_mount_star(Status) -> 
    case get_mount(Status#player.id) of
        [] -> {false, ?MOUNT_ERROR};
        Mount ->
            MaxStar = data_config:mount_config(max_star),
            MaxExp = data_config:mount_config(max_exp),
            MaxLevel = data_config:mount_config(max_level),
            {GoodTid, Num} = data_config:mount_config(star_goods),
            CostCoin = data_config:mount_config(star_cost_coin),
            GNum = goods_util:get_bag_goods_num(Status, GoodTid),
            CoinEnough = goods_util:has_enough_money(Status, CostCoin, ?MONEY_T_BCOIN), 
            if Mount#mount.level >= MaxLevel ->
                   {false, ?MOUNT_MAX_LEVEL};
               Mount#mount.star >= MaxStar ->
                   {false, ?MOUNT_MAX_STAR};
               GNum < Num ->
                   {false, ?MOUNT_NOGOOD_FOR_STAR};
               CoinEnough =:= false ->
                    {false, ?MOUNT_COIN_NOT_ENOUGH};
               true ->
                   goods_util:del_bag_goods(Status, GoodTid, Num, ?LOG_MOUNT_STAR),
                   Ratio = data_config:mount_config(star_exp_ratio),
                   Exp = data_config:mount_config(star_exp),
                   Lucky = case util:rand(1,100) of
                               Int when Int =< Ratio -> 1;
                               _Int -> 2
                           end,
                   NewExp = Mount#mount.exp + Lucky * Exp,
                   if NewExp >= MaxExp ->
                        NewMount = Mount#mount{exp = NewExp - MaxExp,  star = Mount#mount.star + 1}; 
                   true ->
                        NewMount = Mount#mount{exp = NewExp} 
                   end,
                   ets:insert(?ETS_MOUNT, NewMount),
                   spawn(fun()->db_agent_mount:update_mount_exp(NewMount) end),
                   {true, Lucky, NewMount#mount.exp, NewMount#mount.star}
            end
    end.

%%升阶
upgrade_mount_level(Status) -> 
    case get_mount(Status#player.id) of
        [] -> {false, 0};
        Mount ->
            MaxStar = data_config:mount_config(max_star),
            MaxLevel = data_config:mount_config(max_level),
            {GoodTid, Num} = data_config:mount_config(level_goods),
            CostCoin = data_config:mount_config(level_cost_coin),
            GNum = goods_util:get_bag_goods_num(Status, GoodTid),
            CoinEnough = goods_util:has_enough_money(Status, CostCoin, ?MONEY_T_BCOIN), 
            if Mount#mount.level >= MaxLevel ->
                   {false, ?MOUNT_MAX_LEVEL};
               Mount#mount.star < MaxStar ->
                   {false, ?MOUNT_NOSTAR_FOR_LEVEL};
               GNum < Num ->
                   {false, ?MOUNT_NOGOOD_FOR_LEVEL};
               CoinEnough =:= false ->
                   {false, ?MOUNT_COIN_NOT_ENOUGH};
               true ->
                   goods_util:del_bag_goods(Status, GoodTid, Num, ?LOG_MOUNT_LEVEL),
                   Mount1 = Mount#mount{level = Mount#mount.level + 1, exp = 0, star = 0},
                   case new_mount_skill(Mount1) of
                        {true, Mount2} -> 
                             ets:insert(?ETS_MOUNT, Mount2),
                             spawn(fun()-> db_agent_mount:update_mount_level(Mount2),
                                           db_agent_mount:update_mount_skill(Mount2)
                                   end),
                             true;
                        _  -> 
                             ets:insert(?ETS_MOUNT, Mount1),
                             spawn(fun()->db_agent_mount:update_mount_level(Mount1) end),
                             true
                  end
            end
    end.

%%检查幻化外观是否过期
refresh_fashion(Status) ->
    case get_mount(Status#player.id) of
        [] ->
            {false, ?MOUNT_ERROR};
        Mount ->
            Now = util:unixtime(),
            F = fun({_Fid, ExpireTime}) ->
                Now < ExpireTime
            end,
            {ValidFList, ExpireList} = lists:partition(F, Mount#mount.fashion_list),
            if ExpireList =:= [] -> 
                Status;
            true ->
                NewMount = Mount#mount{fashion_list = ValidFList, old_fashion_list = Mount#mount.fashion_list ++ ValidFList},
                ets:insert(?ETS_MOUNT, NewMount),
                spawn(fun() -> db_agent_mount:update_mount_fashion(NewMount),
                               db_agent_mount:update_mount_fashion_list(NewMount)
                      end),
                case lists:member(Mount#mount.fashion, NewMount#mount.fashion_list) of
                    true  -> Status#player{other = Status#player.other#player_other{mount_fashion = 0}};
                    false -> Status
                end
            end
    end.

%%查看座骑信息, 44000协议
get_mount_info(Status)->
    case get_mount(Status#player.id) of
        [] -> 
            [0];        %%座骑不存在
        Mount ->        %%座骑存在,转换为消息喜欢的格式
            F1 = fun({SkillId, Level, Exp}, SList) ->
                 [[SkillId, Level, Exp]|SList]
            end,
            SkillList = lists:foldr(F1, [], Mount#mount.skill_list),
            F2 = fun({FashId, Expire}) -> [FashId, Expire] end,
            FashionList = lists:map(F2, Mount#mount.fashion_list),
            OldFashionList = lists:map(F2, Mount#mount.old_fashion_list),
            [1, Mount#mount.level, Mount#mount.star, Mount#mount.exp, Mount#mount.fashion, Mount#mount.state, SkillList, FashionList, OldFashionList]
    end.

%%----------------------------------------------------------
%%座骑内部函数
%%----------------------------------------------------------
%%获取座骑
%%返回: 座骑记录或[]如果没有座骑
get_mount(PlayerId) ->
    case ets:lookup(?ETS_MOUNT, PlayerId) of
        [] -> case db_agent_mount:get_mount(PlayerId) of
                  [] ->
                     [];
                  Mount ->
                     Mount
              end;
        [Mount] -> 
            Mount
    end.

%%回写座骑数据到数据库
%%PlayerId 玩家ID/ Mount座骑记录
write_back_mount(PlayerId) when is_integer(PlayerId) ->
    case ets:lookup(?ETS_MOUNT, PlayerId) of
        [Mount] when is_record(Mount, mount) ->
            db_agent_mount:update_mount(Mount);
        _Other ->
            skip
    end;
write_back_mount(Mount) when is_record(Mount, mount) ->
    db_agent_mount:update_mount(Mount).

%%检查是否有新的技能可以学习
new_mount_skill(Mount) ->
    SkillId = data_config:get_new_mount_skill(Mount#mount.level),
    if is_integer(SkillId) andalso SkillId >= 1 ->
        case lists:keyfind(SkillId, Mount#mount.skill_list) of
             false  -> 
                   NewSkillList = [{SkillId, 0, 0}|Mount#mount.skill_list],
                   {true, Mount#mount{skill_list  = NewSkillList}};
             _Other -> 
                   false 
        end;
    true ->
        false
    end.

%%增加技能经验   
add_skill_exp_random(Mount, Rand) ->
    SkillList = Mount#mount.skill_list,
    %%循环处理加经验
    F1 = fun(SkList, R) ->
        F2 = fun({SkillId, Lv, Exp}) ->
            add_skill_exp({SkillId, Lv, Exp}, R, Mount#mount.level)
        end,
        lists:map(F2, SkList)
    end,
    NSkList = lists:foldl(F1, SkillList, Rand),
    Mount#mount{skill_list = NSkList}.

%%增加技能经验
add_skill_exp({SkillId, Lv, Exp}, R, Level) ->
    Exp1 = data_config:mount_config(skill_exp),
    ExpAll = data_config:mount_config(skill_exp_all),
    MaxExp = data_config:mount_config(max_skill_exp),
    MaxLevel = min(data_config:mount_config(max_skill_lv), data_config:get_max_skill_level(Level)),
    if Lv < MaxLevel ->
        if SkillId =:= R  ->  %Luck,
               case Exp + Exp1 >= MaxExp of
                   true ->
                       {SkillId, Lv, Exp + Exp1};
                   false ->
                       {SkillId, Lv+1, Exp + Exp1 - MaxExp}
               end;
            R =:= 0        ->  %Very Luck
               case Exp + ExpAll >= MaxExp of
                   true ->
                       {SkillId, Lv, Exp + ExpAll};
                   false ->
                       {SkillId, Lv+1, Exp + ExpAll - MaxExp}
               end;
            true ->
               {SkillId, Lv, Exp}
        end;
    true ->
        {SkillId, Lv, Exp}
    end.
        
%%根据阶和星获取加的战斗属性
get_attr_by_level(Mount) ->
    MAttr = tpl_mount_attr:get(Mount#mount.level, Mount#mount.star),
    MAttr#temp_mount_attr.data.

%%根据技能技能加的战斗属性
get_attr_by_skill(Mount) ->
    F = fun({SkillId, Lv, _}, Attr) ->
        MAttr = tpl_mount_skill:get(SkillId, Lv),
        MAttr#temp_mount_skill.data ++ Attr
    end,
    lists:foldl(F, [], Mount#mount.skill_list).

