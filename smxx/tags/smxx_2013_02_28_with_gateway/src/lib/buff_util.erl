%%%--------------------------------------
%%% @Module  : buff_util
%%% @Author  : water
%%% @Created : 2013.02.21
%%% @Description:角色相关处理
%%%--------------------------------------
-module(buff_util).
-include("common.hrl").
-include("record.hrl"). 
-include("debug.hrl").

-export([   add_goods_buff/2,
            readd_goods_buff/1,
            refresh_goods_buff/1, 
            remove_goods_buff/2,
            active_skill_buff/3,
            refresh_skill_buff/2,
            deactive_skill_buff/2,
            clear_skill_buff/1
        ]).

%%temp_buff类型: (last_time均为毫秒值)
%%    1增减属性(限战斗属性), 有效一次, 过期撤消, 有效期last_time字段配置, times字段忽略
%%    2扣血加血 周期性有效, N次共持续时间last_time字段配置 times配多少次
%%    3特殊状态(不能移动) last_time配有效时间
%%    4特殊状态(不能使用技能) last_time配有效时间
%%    5特殊状态(石化) last_time配有效时间
%%    6经验加成 单次有效, last_time配有效时间
%%    7气血包 单次作用, 只需要配data字段, [{hit_point, xxx}]
%%    8法力包 单次作用, 只需要配data字段, [{magic, xxx}]
%%    9情缘Buff
%%    10改变外观 单次有效, last_time配有效时间
%%
%%单次作用的Buff在buff表记录格式: {BuffId, 过期时间(秒)}, 过期时需要清除Buff的作用
%%周期性Buff在buff表记录方式: {BuffId, 剩余次数, 上次应用时间(秒)}, 过期保留Buff的作用, 不会清除

%%给玩家增加Buff, 只能玩家进程调用
%%应用Buff效果, 在Buff表列表增加相应信息记录
add_goods_buff(Status, BuffId) ->
    Buff = tpl_buff:get(BuffId),
    ?ASSERT(is_record(Buff, temp_buff)),
    %%检查BUFF是否有同组的应用
    BuffList = load_goods_buff(Status#player.id),
    F = fun(X) ->
           case X of
                {BuffId, _}    ->
                     BuffId;
                {BuffId, _, _} ->
                     BuffId
           end
    end,
    BuffIdList = lists:map(F, BuffList),
    %%检查Buff同组别覆盖优先级
    case check_buff_overlay(Buff, BuffIdList) of
          add ->
              BuffList1 = add_goods_buff_list(BuffList, Buff),
              save_goods_buff(Status#player.id, BuffList1),
              apply_goods_buff_effect(Status, BuffId);
          {replace, OldBuffId} -> %%替换旧的Buff
              %%删除旧的Buff并取消作用
              BuffList1 = lists:keydelete(OldBuffId, 1, BuffList),
              BuffList2 = add_goods_buff_list(BuffList1, Buff),
              save_goods_buff(Status#player.id, BuffList2),
              Status1 = remove_goods_buff_effect(Status, OldBuffId),
              %%应用新的Buff并加到Buff列表
              apply_goods_buff_effect(Status1, BuffId);
          reject ->
              Status
    end.

%%重新应用Buff, 用于登录时或刷新玩家战斗属性使用
%%其余场合不能使用
readd_goods_buff(Status) ->
    BuffList = load_goods_buff(Status#player.id),
    %%过滤出来适合再应用的Buff
    F1 = fun(BufRec, ApplyList) -> 
         case BufRec of
              %%单次作用的Buff: {BuffId, 过期时间(秒)}, 无论是否过期时都重新作用
              {BuffId, _ExpireTime} ->
                  [BuffId|ApplyList];
              %%周期性Buff记录方式: 这一类已保存,不需要重新应用
              _Other ->
                  ApplyList
         end
    end,
    ApplyBufList = lists:foldr(F1, [], BuffList),
    
    %%应用BUFF
    F2 = fun(BuffId, OldStatus) ->
        apply_goods_buff_effect(OldStatus, BuffId)
    end,
    lists:foldl(F2, Status, ApplyBufList).

%%刷新周期性的Buff
%%只能玩家进程调用
refresh_goods_buff(Status) ->
    BuffList = load_goods_buff(Status#player.id),
    Now = util:unixtime(),
    %%过滤出来适合再应用的Buff
    F1 = fun(BufRec, {KeepList, ApplyList, RemoveList}) -> 
         case BufRec of
              %%单次作用的Buff: {BuffId, 过期时间(秒)}, 过期时需要清除Buff的作用
              {BuffId, ExpireTime} ->
                   if Now >= ExpireTime ->
                          {KeepList, ApplyList, [BuffId|RemoveList]};
                      true ->
                          {[BufRec|KeepList], ApplyList, RemoveList} 
                   end;
              %%周期性Buff记录方式: {BuffId, 剩余次数, 上次应用时间(秒)}, 过期保留Buff的作用
              {BuffId, ResTimes, LastTime} ->
                   Buff = tpl_buff:get(BuffId),
                   ?ASSERT(is_record(Buff, temp_buff)),
                   ?ASSERT(Buff#temp_buff.last_time > 0),
                   ?ASSERT(Buff#temp_buff.times > 0),
                   %%Buff应用间隔(秒), 注意配置表中毫秒值
                   Interval = util:floor(Buff#temp_buff.last_time/Buff#temp_buff.times/1000),
                   Times = max(0, util:floor((Now - LastTime)/Interval)),
                   if Times >= 1 andalso ResTimes >= 2 ->   %%还有2次以上
                          {[{BuffId, ResTimes - 1, Now}|KeepList], [BuffId|ApplyList], RemoveList};
                      Times >= 1 andalso ResTimes =:= 1 -> %%最后一次了
                          {KeepList, [BuffId|ApplyList], RemoveList};
                      ResTimes =:= 0  ->                   %%没有了
                          {KeepList, ApplyList, RemoveList};
                      true ->                              %%时间未到, 保留
                          {[{BuffId, ResTimes, LastTime}|KeepList],  ApplyList, RemoveList}
                   end
         end
    end,
    {KeepBufList, ApplyBufList, RemoveBufList} = lists:foldr(F1, {[],[],[]}, BuffList),
    
    %%保存新Buff记录表
    save_goods_buff(Status#player.id, KeepBufList),

    %%应用BUFF
    F2 = fun(BuffId, OldStatus) ->
        apply_goods_buff_effect(OldStatus, BuffId)
    end,
    %%移除Buff
    F3 = fun(BuffId, OldStatus) ->
        remove_goods_buff_effect(OldStatus, BuffId)
    end,
    Status1 = lists:foldl(F2, Status, ApplyBufList),
    lists:foldl(F3, Status1, RemoveBufList).
    
%%移除物品BUFF
%%移除物品BUFF记录, 并还原BUFF状态
remove_goods_buff(Status, BuffId) ->
    BuffList = load_goods_buff(Status#player.id),
    case lists:keyfind(BuffId, 1, BuffList) of
        false ->  %%没有的Buff,移除个毛
            Status;
        {BuffId, _ExpireTime} ->   %%一次性的Buff 移除Buff作用和记录
            NewBuffList = lists:keydelete(BuffId, 1, BuffList),
            save_goods_buff(Status#player.id, NewBuffList),
            remove_goods_buff_effect(Status, BuffId);
        {BuffId, _ResTimes, _LastTime} -> %%周期的Buff,只移除记录,不删作用
            NewBuffList = lists:keydelete(BuffId, 1, BuffList),
            save_goods_buff(Status#player.id, NewBuffList),
            Status
    end.

%激活(应用)新的技能BUFF到战斗记录上BattleAttr
%%BuffId: 技能需要应用的BuffId
%%应用BUFF,并加Buff过期时间到BattleAttr
active_skill_buff(BattleAttr, [BuffId|IdList], NowLong) ->
    %%取BUFF记录
    Buff = tpl_buff:get(BuffId),
    ?ASSERT(is_record(Buff, temp_buff)),

    %%检查BUFF是否有同组的应用
    BuffList = [BufId||{BufId, _} <- BattleAttr#battle_attr.buff1] ++       %%属性Buff列表
               [BufId||{BufId, _} <- BattleAttr#battle_attr.skill_buff] ++  %%状态Buff列表
               [BufId||{BufId, _, _} <- BattleAttr#battle_attr.buff2],      %%周期属性Buff列表
    case check_buff_overlay(Buff, BuffList) of
          add ->
              BattleAttr1 = add_skill_buff(BattleAttr, Buff, NowLong),
              active_skill_buff(BattleAttr1, IdList, NowLong);
          {replace, OldBuffId} -> %%替换旧的Buff
              %%删除旧的Buff并取消作用
              BattleAttr1 = remove_skill_buff(BattleAttr, OldBuffId),
              %%应用新的Buff并加到Buff列表
              BattleAttr2 = add_skill_buff(BattleAttr1, Buff, NowLong),
              active_skill_buff(BattleAttr2, IdList, NowLong);
          reject ->
              active_skill_buff(BattleAttr, IdList, NowLong) 
    end;
active_skill_buff(BattleAttr, _, _) ->
    BattleAttr.

%%应用周期性的BUFF
refresh_skill_buff(BattleAttr, NowLong) ->
    %%过滤出来适合再应用的Buff
    F1 = fun({BuffId, ResTimes, LastTime}, {Buff1,BufList}) -> 
         Buff = tpl_buff:get(BuffId),
         ?ASSERT(is_record(Buff, temp_buff)),
         ?ASSERT(Buff#temp_buff.last_time > 0),
         ?ASSERT(Buff#temp_buff.times > 0),
         %%合适次数 = (当前时间-上次应用时间)/(持续时间/总应用次数)
         Times = min(ResTimes, util:floor((NowLong - LastTime)/(Buff#temp_buff.last_time/Buff#temp_buff.times))),
         if Times >= 1 ->
                {[{BuffId, ResTimes - Times, NowLong}|Buff1], [{Buff, Times}|BufList]};
            true ->
                {[{BuffId, ResTimes, LastTime}|Buff1],  BufList}
         end
    end,
    {NewBuff2, ReBuffList} = lists:foldr(F1, {[],[]}, BattleAttr#battle_attr.buff2),
    BattleAttr1 = BattleAttr#battle_attr{buff2 = NewBuff2},

    %%再次应用BUFF
    F2 = fun({Buff, Times}, OldBatAttr) ->
         F3 = fun(_Idx, BatAttr) ->
             apply_buff_effect(BatAttr, Buff#temp_buff.data, apply)
         end,
         lists:foldl(F3, OldBatAttr, lists:seq(1, Times))
    end,
    lists:foldl(F2, BattleAttr1, ReBuffList).

%%解除BUFF
%%检查BattleAttr#battle_attr.buff列表
%%如果有buff过期, 移除buff的作用并从skill_buff删除
deactive_skill_buff(BattleAttr, NowLong) ->
    %%过滤出需要deactive的Buff
    F1 = fun(BufRec, DeBufList) -> 
        case BufRec of
            {BufId, ExpireTime} ->  %%Buff1
                 if NowLong >= ExpireTime -> %%已过期的Buff
                       [BufId|DeBufList]; 
                    true ->
                       DeBufList
                 end;
            {BufId, ResTimes, _} ->
                 if ResTimes =< 0 ->   %%剩余次数为0,过期
                       [BufId|DeBufList]; 
                    true ->
                       DeBufList
                 end;
            _Other ->
                  DeBufList
        end
    end,
    DeBuffList = lists:foldr(F1, [], BattleAttr#battle_attr.buff1 ++ BattleAttr#battle_attr.buff2),
    
    %%解除BUFF的作用
    F2 = fun(BuffId, OldBattleAttr) ->
        remove_skill_buff(OldBattleAttr, BuffId)
    end,
    lists:foldl(F2, BattleAttr, DeBuffList).

%%功能: 战斗结束, 解除玩家战斗技能Buff
%%返回: 更新后战斗记录BattleAttr, 
%%      1: 清空skill_buff列表
clear_skill_buff(BattleAttr) ->
    %%单次Buff,如果未解除,　先解除 
    %%过滤出需要deactive的Buff, 技能的Buff不保留,停止战斗时全部解除
    DeBuffList = [BufId||{BufId, _}<-BattleAttr#battle_attr.buff1],
    %%解除BUFF的作用
    F = fun(BuffId, OldBattleAttr) ->
        %%取BUFF记录
        SkillBuf = tpl_buff:get(BuffId),
        apply_buff_effect(OldBattleAttr, SkillBuf#temp_buff.data, remove)
    end,
    BattleAttr1 = lists:foldl(F, BattleAttr, DeBuffList),

    %%TODO:周期性Buff

    %%清除技能的Buff列表
    BattleAttr1#battle_attr{buff1 = [], buff2 = []}.

%------------------------------------------------------------------------
% 以下为内部函数,　非请勿用
%------------------------------------------------------------------------
%%加Buff到Buff记录列表
add_goods_buff_list(BuffList, Buff) ->
    Now = util:unixtime(),
    case Buff#temp_buff.type of
        1 -> %加参数Buff, 有效时间, 这一类需要回复到原状态, 记录过期时间
             LastTime = util:floor(Buff#temp_buff.last_time/1000),
             [{Buff#temp_buff.buff_id, Now+LastTime}|BuffList];
        2 -> %加血/扣血, 周期性作用的Buff, 不用回复状态的Buf记录: [{BufId, RemTims, 上次作用时间}]
             [{Buff#temp_buff.buff_id, Buff#temp_buff.times, Now}|BuffList];
        6 ->  %经验加成, 单次作用
             LastTime = util:floor(Buff#temp_buff.last_time/1000),
             [{Buff#temp_buff.buff_id, Now+LastTime}|BuffList];
        7 ->  %气血包, 单次作用, 不需要记录
            BuffList;
        8 ->  %法力包, 单次作用, 不需要记录
            BuffList;
        9 ->  %情缘Buff
            BuffList;
       10 ->  %改变外观, 有效时间
            LastTime = util:floor(Buff#temp_buff.last_time/1000),
            [{Buff#temp_buff.buff_id, Now+LastTime}|BuffList];
        _ ->  %%其他类型不是技能的,不在这里处理.
            BuffList
    end.

%%增加物品BUFF应用Buff参数或属性
apply_goods_buff_effect(Status, BuffId) ->
    Buff = tpl_buff:get(BuffId),
    case Buff#temp_buff.type of
        1 ->  %加参数Buff, 这一类需要回复到原状态, 记录过期时间
              BattleAttr = apply_buff_effect(Status#player.battle_attr, Buff#temp_buff.data, apply),
              Status#player{battle_attr = BattleAttr};
        2 ->  
              BattleAttr = apply_buff_effect(Status#player.battle_attr, Buff#temp_buff.data, apply),
              Status#player{battle_attr = BattleAttr};
        6 ->  %经验加成
              Status;
        7 ->  %气血包
              BattleAttr = apply_buff_effect(Status#player.battle_attr, Buff#temp_buff.data, apply),
              Status#player{battle_attr = BattleAttr};
        8 ->  %法力包
              BattleAttr = apply_buff_effect(Status#player.battle_attr, Buff#temp_buff.data, apply),
              Status#player{battle_attr = BattleAttr};
        9 ->  %情缘Buff
              Status;
       10 ->  %改变外观
              Status;
        _ ->  %%其他类型不认识,不处理.
              Status
    end.
    
%%移除BUFF
%%移除BUFF记录, 并还原BUFF状态
remove_goods_buff_effect(Status, BuffId) ->
    Buff = tpl_buff:get(BuffId),
    case Buff#temp_buff.type of
        1 ->  %加参数Buff, 这一类需要回复到原状态, 记录过期时间
              BattleAttr = apply_buff_effect(Status#player.battle_attr, Buff#temp_buff.data, remove),
              Status#player{battle_attr = BattleAttr};
        6 ->  %经验加成
              Status;
        9 ->  %情缘Buff
              Status;
       10 ->  %改变外观
              Status;
        _ ->  %%其他类型不认识,不处理.
              Status
    end.

%%增加技能BUFF
%%增加技能BUFF记录, 应用Buff参数或属性
add_skill_buff(BattleAttr, Buff, NowLong) ->
       BattleAttr1 = case Buff#temp_buff.type of
        1 ->  %加参数Buff, 这一类需要回复到原状态, 记录过期时间
              %保存结构[{BufId, 过期时间}]
              NewBuffList = [{Buff#temp_buff.buff_id, NowLong + Buff#temp_buff.last_time}|BattleAttr#battle_attr.buff1],
              BattleAttr#battle_attr{buff1 = NewBuffList};
        2 ->  %加血/扣血,不用回复状态的Buff
              %保存结构[{BufId, RemTims, 上次作用时间}]
              ?ASSERT(Buff#temp_buff.last_time > 0),
              ?ASSERT(Buff#temp_buff.times > 0),
              NewBuffList = [{Buff#temp_buff.buff_id, Buff#temp_buff.times - 1, NowLong}|BattleAttr#battle_attr.buff2],
              BattleAttr#battle_attr{buff2 = NewBuffList};
        3 ->  %%来源技能: 特殊状态(不能移动) 
              NewSkillBuf = [{Buff#temp_buff.buff_id, NowLong + Buff#temp_buff.last_time}|BattleAttr#battle_attr.skill_buff],
              BattleAttr#battle_attr{skill_buff = NewSkillBuf};
        4 ->  %%技能来源: 特殊状态(不能使用技能) 
              NewSkillBuf = [{Buff#temp_buff.buff_id, NowLong + Buff#temp_buff.last_time}|BattleAttr#battle_attr.skill_buff],
              BattleAttr#battle_attr{skill_buff = NewSkillBuf};
        5 ->  %%特殊状态(石化) 
              NewSkillBuf = [{Buff#temp_buff.buff_id, NowLong + Buff#temp_buff.last_time}|BattleAttr#battle_attr.skill_buff],
              BattleAttr#battle_attr{skill_buff = NewSkillBuf};
        _ ->  %%其他类型不是技能的,不在这里处理.
              BattleAttr
    end,
    %%应用本次BUFF到战斗记录
    apply_buff_effect(BattleAttr1, Buff#temp_buff.data, apply).

%%移除BUFF
%%移除BUFF记录, 并还原BUFF状态
remove_skill_buff(BattleAttr, BuffId) ->
    Buff = tpl_buff:get(BuffId),
    ?ASSERT(is_record(Buff, temp_buff)),
    case Buff#temp_buff.type of
        1 ->  %删除Buff列表记录, 回复到原状态,
              %保存结构[{BufId, 过期时间}]
              BuffList = lists:keydelete(BuffId, 1, BattleAttr#battle_attr.buff1),
              BattleAttr1 = BattleAttr#battle_attr{buff1 = BuffList},
              apply_buff_effect(BattleAttr1, Buff#temp_buff.data, remove);
        2 ->  %删除Buff列表记录
              BuffList = lists:keydelete(BuffId, 1, BattleAttr#battle_attr.buff2),
              BattleAttr#battle_attr{buff2 = BuffList};
        3 ->  %%来源技能: 特殊状态(不能移动) 
              BuffList = lists:keydelete(BuffId, 1, BattleAttr#battle_attr.skill_buff),
              BattleAttr#battle_attr{skill_buff = BuffList};
        4 ->  %%技能来源: 特殊状态(不能使用技能) 
              BuffList = lists:keydelete(BuffId, 1, BattleAttr#battle_attr.skill_buff),
              BattleAttr#battle_attr{skill_buff = BuffList};
        5 ->  %%特殊状态(石化) 
              BuffList = lists:keydelete(BuffId, 1, BattleAttr#battle_attr.skill_buff),
              BattleAttr#battle_attr{skill_buff = BuffList};
        _ ->  %%其他类型不用技能
              BattleAttr
    end.

%%检查BUFF同组互斥情况
%%NewBuff为新增Buff的结构
check_buff_overlay(NewBuff, [BuffId|BuffList]) ->
    Buff = tpl_buff:get(BuffId),
    ?ASSERT(is_record(Buff, temp_buff)),
    if %新Buff优先级相同或高, 替换旧
       (NewBuff#temp_buff.group =:= Buff#temp_buff.group) andalso 
       (NewBuff#temp_buff.priority >= Buff#temp_buff.priority) ->
            {relace, BuffId};
       %旧的比新Buff优先级高, 不用
       (NewBuff#temp_buff.group =:= Buff#temp_buff.group) andalso 
       (NewBuff#temp_buff.priority < Buff#temp_buff.priority) ->
            reject;
       true -> 
            check_buff_overlay(NewBuff, BuffList)
    end;
check_buff_overlay(_NewBuff, _) ->
    add.

%%应用Buff的作用, active buff里调用
apply_buff_effect(BattleAttr, [{Key, Value}|T], apply) ->
    BattleAttr = lib_player:update_battle_attr(BattleAttr, [{Key, Value}]),
    apply_buff_effect(BattleAttr, T, apply);
%%解除Buff的作用, deactive buff里调用
apply_buff_effect(BattleAttr, [{Key, Value}|T], remove) ->
    BattleAttr = lib_player:update_battle_attr(BattleAttr, [{Key, -Value}]),
    apply_buff_effect(BattleAttr, T, remove);
%%应用Buff效果 
apply_buff_effect(BattleAttr, _, _) ->
    BattleAttr.

%%加载玩家的Buff
%%只能玩家进程调用,
load_goods_buff(PlayerId) ->
    case get(goods_buff) of
         undefine ->
             case db_agent:get_buff(PlayerId) of
                 [] ->
                     db_agent:insert_buff(PlayerId, []),
                     put(goods_buff, []),
                     [];
                 Buff -> 
                     put(goods_buff, Buff),
                     Buff
             end;
         Buff -> 
             Buff
    end.

%%保存玩家Buff记录
save_goods_buff(PlayerId, BuffList) ->
    put(goods_buff, BuffList),
    db_agent:update_buff(PlayerId, BuffList).


