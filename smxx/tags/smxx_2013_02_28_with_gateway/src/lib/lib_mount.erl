%%%-----------------------------------
%%% @Module  : lib_skill
%%% @Author  : water
%%% @Created : 2013.01.18
%%% @Description: 技能库函数
%%%-----------------------------------
-module(lib_mount).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

%%处理登录加载座骑
role_login(Status) ->
    case (Status#player.switch band ?SW_MOUNT_BIT) =:= ?SW_MOUNT_BIT of
        true  ->  
            case get_mount(Status#player.id) of
                []    ->
                    open_mount(Status);
                Mount ->
                    ets:insert(?ETS_MOUNT, Mount),
                    case Status#player.mount_flag =:= 1 orelse Status#player.mount_flag =:= 2 of
                         true  ->  Status;
                         false ->  Status#player{mount_flag = 2}
                    end
            end;
        false ->  
            Status
    end.

%%处理登出时回写座骑记录
role_logout(Status) ->
    write_back_mount(Status#player.id),
    ets:delete(?ETS_MOUNT, Status#player.id).
    
%%开启坐骑功能
open_mount(Status) ->
    NewMount = #mount{ uid = Status#player.id,
                       level = 1,
                       exp = 0,
                       fashion = 0,
                       skill_list = [],
                       fashion_list = []
                     },
    ets:insert(?ETS_MOUNT, NewMount),
    db_agent_mount:insert_mount(NewMount),
    Status#player{ mount_flag = 2,
                   switch = Status#player.switch bor ?SW_MOUNT_BIT
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
                    BattleAttr = Status#player.battle_attr,
                    %%座骑等级加成
                    NewBattleAttr = BattleAttr#battle_attr{},
                    %%座骑被动技能加成
                    Status#player{battle_attr = NewBattleAttr}
            end;
        false ->  
            Status
    end.

    
%%学习/升级座骑技能
%%学习时后立刻回写数据库
learn_skill(Status, SkillId) ->
    case get_mount(Status#player.id) of
        Mount when is_record(Mount, mount) ->
            case lists:keyfind(SkillId, 1, Mount#mount.skill_list) of
                false -> %%未学习,学习技能
                    NewSkillList = [{SkillId, 1}|Mount#mount.skill_list],
                    NewMount = Mount#mount{skill_list = lists:keysort(1, NewSkillList)},
                    ets:insert(?ETS_MOUNT, NewMount),
                    db_agent_mount:update_mount_skill(NewMount),
                    {true, Status};        %返回成功
                {SkillId, Lv} ->  %%已学技能, 升一级
                    NewSkillList = lists:keyreplace(SkillId, 1, Mount#mount.skill_list, {SkillId, Lv+1}),
                    NewMount = Mount#mount{skill_list = lists:keysort(1,NewSkillList)},
                    ets:insert(?ETS_MOUNT, NewMount),
                    db_agent_mount:update_mount_skill(NewMount),
                    {true, Status}        %返回成功
            end;
        _Other ->
            {false, 0}  %%座骑功能末开通
    end.

%%切换座骑幻化外观
change_fashion(Status, FashionId) ->
    case get_mount(Status#player.id) of
        Mount when is_record(Mount, mount) ->
            case lists:member(FashionId, Mount#mount.fashion_list) of
                false ->
                    {false, 3};   %%幻化装没有
                true ->
                    NewMount = Mount#mount{fashion = FashionId},
                    ets:insert(?ETS_MOUNT, NewMount),
                    {true, Status}        %返回成功
            end;
        _Other ->
            {false, 0}
    end.
    
%%上座骑
get_on_mount(Status) ->
    case get_mount(Status#player.id) of
        Mount when is_record(Mount, mount) ->
            if Mount#mount.fashion =/= 0 ->
                   {true, Status};
               length(Mount#mount.fashion_list) >= 1 ->
                   FashionId = lists:nth(util:rand(1, length(Mount#mount.fashion_list)), Mount#mount.fashion_list),
                   NewMount = Mount#mount{fashion = FashionId}, 
                   ets:insert(?ETS_MOUNT, NewMount),
                   %%更新玩家移动的计算速度
                   NewStatus = Status#player{mount_flag = 1},
                   {true, NewStatus};  %%有座骑并使用
               true ->
                   {false, 3}
            end;
        _Other ->
            {false, 0}
    end.

%%下座骑
get_off_mount(Status) -> 
    %%更新玩家移动速度
    NewStatus = Status#player{mount_flag = 1}, %%有座骑并不使用
    NewStatus.

%%查看座骑信息, 44000协议
get_mount_info(Status)->
    case get_mount(Status#player.id) of
        [] -> 
            [0];        %%座骑不存在
        Mount ->        %%座骑存在,转换为消息喜欢的格式
            F1 = fun({SkillId, Level}, SList) ->
                 [[SkillId, Level]|SList]
            end,
            SkillList = lists:foldr(F1, [], Mount#mount.skill_list),
            F2 = fun(FashId) -> [FashId] end,
            FashionList = lists:map(F2, Mount#mount.fashion_list),
            [1, Mount#mount.level, Mount#mount.exp, Mount#mount.fashion, SkillList, FashionList]
    end.

%%----------------------------------------------------------
%%座骑内部函数
%%----------------------------------------------------------
%% 获取座骑
%% 返回: 座骑记录或[]如果没有座骑
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

%% 回写座骑数据到数据库
%% PlayerId 玩家ID/ Mount座骑记录
write_back_mount(PlayerId) when is_integer(PlayerId) ->
    case ets:lookup(?ETS_MOUNT, PlayerId) of
        [Mount] when is_record(Mount, mount) ->
            db_agent_mount:update_mount(Mount);
        _Other ->
            skip
    end;
write_back_mount(Mount) when is_record(Mount, mount) ->
    db_agent_mount:update_mount(Mount).
    

