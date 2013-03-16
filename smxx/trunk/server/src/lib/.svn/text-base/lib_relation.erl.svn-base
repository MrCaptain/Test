%%%--------------------------------------
%%% @Module  : lib_relation
%%% @Author  : water
%%% @Created : 2013.01.30
%%% @Description: 关系相关处理
%%%-----------------------------------
-module(lib_relation).
-include("record.hrl").
-include("common.hrl").
-include("debug.hrl").
-include("rela.hrl").

-compile(export_all).

%% friend_list格式 [{Uid, FriendShip, Name, Career, Gender}, ...], FirendShip 友好度
%% foe_list格式    [{Uid, Hostitily, Name, Career, Gender}, ...], Hostitily 仇恨度
%% recent_list格式 [{Uid, Time, Name, Career, Gender}, ...], Time 最近一次发生关系时间(秒)

%%处理登录加载关系, 不返回Status
role_login(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            put(friend_request_ids, []),
            case get_relation(Status#player.id) of
                [] ->
                    open_relation(Status);
                Relation ->
                    ets:insert(?ETS_RELATION, Relation)
            end;
        false ->  
            skip
    end.

%%处理登出时回写关系
role_logout(Status) ->
    write_back_relation(Status#player.id),
    ets:delete(?ETS_RELATION, Status#player.id).

%%开始好友/关系功能
%%返回Status, 更新player.switch相应标志位
open_relation(Status) ->
    NewRelation = #relation{ uid = Status#player.id,
                             bless_times = 0,
                             max_friend = data_player:get_max_friend_num(),
                             max_foe = data_player:get_max_foe_num(),
                             friend_list = [],
                             foe_list = [],
                             recent_list = []
                           },
    db_agent_relation:insert_relation(NewRelation),
    ets:insert(?ETS_RELATION, NewRelation),
    Status#player{switch = Status#player.switch bor ?SW_RELATION_BIT}.
    
%------------------------------------------
%Protocol: 14001 好友列表
%------------------------------------------
get_friend_info(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            case get_relation(Status#player.id) of
                [] -> 
                    [];
                Relation ->
                    F = fun({Uid, FriendShip, Name, Career, Gender}) ->
                        OnlineFlag = case lib_player:is_online(Uid) of
                                         true -> 1;
                                         _    -> 0
                                     end,
                        [Uid, Name, Gender, Career, OnlineFlag, FriendShip]
                    end,
                    lists:map(F, Relation#relation.friend_list)
            end;
        false ->  
            []
    end.

%------------------------------------------
%Protocol: 14002 获取最近联系人列表
%------------------------------------------
get_recent_info(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            case get_relation(Status#player.id) of
                [] -> 
                    [];
                Relation ->
                    F = fun({Uid, Time, Name, Career, Gender}) ->
                        OnlineFlag = case lib_player:is_online(Uid) of
                                         true -> 1;
                                         _    -> 0
                                     end,
                        [Uid, Name, Gender, Career, OnlineFlag, Time]
                    end,
                    lists:map(F, Relation#relation.recent_list)
            end;
        false ->  
            []
    end.

%------------------------------------------
%Protocol: 14003 获取仇人列表
%------------------------------------------
get_foe_info(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            case get_relation(Status#player.id) of
                [] -> 
                    [];
                Relation ->
                    F = fun({Uid, Hostitily, Name, Career, Gender}) ->
                        OnlineFlag = case lib_player:is_online(Uid) of
                                         true -> 1;
                                         _    -> 0
                                     end,
                        [Uid, Name, Gender, Career, OnlineFlag, Hostitily]
                    end,
                    lists:map(F, Relation#relation.foe_list)
            end;
        false ->  
            []
    end.

%%--------------------------------------
%%Protocol: 14012 好友请求列表
%%--------------------------------------
get_friend_req(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            case db_agent_relation:get_friend_request(Status#player.id) of
                [] -> 
                    [];
                ReqList -> 
                    ReqIds = [Uid||[Uid|_T]<-ReqList],  %%把请求的玩家ID存起来, 同意好友请求需要判断
                    put_request_uids(ReqIds),
                    ReqList
            end;
        false ->  
            []
    end.

%%发起添加好友操作, FriendId为要添加好友的Id
%%返回值: true成功发出请求, 
%%        {false, Reason}请求失败,Reason为错误码
add_friend_request(Status, FriendId) ->
    case ((Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT) andalso 
         (Status#player.id =/= FriendId) of
        true  ->  
            Relation = get_relation(Status#player.id),
            ?ASSERT(is_record(Relation, relation)),
            case lists:keyfind(FriendId, 1, Relation#relation.friend_list) of
                false ->
                    case length(Relation#relation.friend_list) < Relation#relation.max_friend of
                        true ->
                            send_add_friend_request(FriendId, Status#player.id, Status#player.nick, Status#player.career,
                                                              Status#player.gender, Status#player.camp, Status#player.level);
                        false ->  %%最大好友满了
                            {false, ?RELA_MAX_FRIEND_REACH}
                    end;
                _Other ->  %%已经在好友列表了
                    {false, ?RELA_ALREADY_FRIEND}
            end;
     false ->  
         {false, ?RELA_UNKNOWN_ERROR}
    end.

%%发送同意好友添加的回应给请求玩家 
%%如果玩家在线, 并删除好友请求记录
add_friend_response(Status, RequestUid) ->
    case lib_player:get_player_pid(RequestUid) of 
        Pid when is_pid(Pid) ->  %%在线,直接发请求
            gen_server:cast(Pid, {add_friend_response, Status#player.id, Status#player.nick, Status#player.career, Status#player.gender}),
            %%同时删除数据库对应记录(如果有)
            db_agent_relation:delete_request(Status#player.id, RequestUid);
        _Other ->  %%不在线, 更新数据库,等玩家下次登录查看
            db_agent_relation:update_friend_response(Status#player.id, RequestUid, 1)
    end.

%%发送祝福
send_bless_to_friend(Status, FriendId, Type) ->
    case ((Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT) andalso
         (Status#player.id =/= FriendId) of
        true  ->  
            Relation = get_relation(Status#player.id),
            ?ASSERT(is_record(Relation, relation)),
            case Relation#relation.bless_times < data_player:get_max_bless_times(Status#player.vip) of
                true ->
                    case lib_player:get_player_pid(FriendId) of 
                        Pid when is_pid(Pid) ->  %%在线,直接发请求
                            gen_server:cast(Pid, {bless, Type, Status#player.id, Status#player.nick}),
                            NewRelation = Relation#relation{bless_times = Relation#relation.bless_times + 1},
                            ets:insert(?ETS_RELATION, NewRelation),
                            true;
                        _Other ->  %%不在线
                            {false, ?RELA_FRIEND_OFFLINE}
                    end;
                false ->
                    {false, ?RELA_MAX_BLESS_TIMES_REACH}
           end;
     false ->  
         {false, ?RELA_UNKNOWN_ERROR}
    end.
    
%%给在线好友发送消息, MsgBin为二进制消息
send_message_to_friend(PlayerId, MsgBin) ->
    case get_relation(PlayerId) of
        [] -> skip;
        Relation ->
            F = fun(FInfo) ->
                Uid = element(1,FInfo),
                case lib_player:get_player_pid(Uid) of 
                    Pid when is_pid(Pid) ->  %%在线,直接发请求
                        gen_server:cast(Pid, {send_to_sid, MsgBin});
                    _Other ->  %%不在线
                        skip
                end
            end,
            lists:foreach(F, Relation#relation.friend_list)
   end.

%%给在线仇人发送消息, MsgBin为二进制消息
send_message_to_foe(PlayerId, MsgBin) ->
    case get_relation(PlayerId) of
        [] -> skip;
        Relation ->
            F = fun(FInfo) ->
                Uid = element(1,FInfo),
                case lib_player:get_player_pid(Uid) of 
                    Pid when is_pid(Pid) ->  %%在线
                        gen_server:cast(Pid, {send_to_sid, MsgBin});
                    _Other ->  %%不在线
                        skip
                end
            end,
            lists:foreach(F, Relation#relation.foe_list)
   end.

%%给在线好友发送消息, MsgBin为二进制消息
send_message_to_recent(PlayerId, MsgBin) ->
    case get_relation(PlayerId) of
        [] -> skip;
        Relation ->
            F = fun(FInfo) ->
                Uid = element(1,FInfo),
                case lib_player:get_player_pid(Uid) of 
                    Pid when is_pid(Pid) ->  %%在线
                        gen_server:cast(Pid, {send_to_sid, MsgBin});
                    _Other ->  %%不在线
                        skip
                end
            end,
            lists:foreach(F, Relation#relation.recent_list)
   end.
    
%%获取好友列表
%%返回列表, [] 没有好友或未开通.  
%%          [{Uid, 友好度, Name, Career, Gender},...]
get_friend_list(PlayerId) when is_integer(PlayerId) ->
    case get_relation(PlayerId) of
        [] ->
            [];
        Relation ->
            Relation#relation.friend_list
    end;
get_friend_list(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            get_friend_list(Status#player.id);
        false ->  
            []
    end.

%%获取仇人列表
%%返回列表, [] 没有仇人或未开通关系功能
%%          [{Uid, 仇恨度, Name, Career, Gender},...]
get_foe_list(PlayerId)  when is_integer(PlayerId) ->
    case get_relation(PlayerId) of
        [] ->
            [];
        Relation ->
            Relation#relation.foe_list
    end;
get_foe_list(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            get_foe_list(Status#player.id);
        false ->  
            []
    end.

%%获取最近联系人列表
%%返回列表, [] 没有最近联系人或未开通关系功能
%%          [{Uid, 最近联系时间, Name, Career, Gender},...]
get_recent_list(PlayerId)  when is_integer(PlayerId) ->
    case get_relation(PlayerId) of
        [] ->
            [];
        Relation ->
            Relation#relation.recent_list
    end;
get_recent_list(Status) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            get_recent_list(Status#player.id);
        false ->  
            []
    end.
    
%%增加一个好友到好友列表
%%PlayerId为玩家ID, Status为player结构
%%返回true成功, {false, Reason}不成功
add_to_friend_list(Status, {FriendId}) when is_record(Status, player)->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            add_to_friend_list(Status#player.id, {FriendId});
        false ->  
            {false, ?RELA_UNKNOWN_ERROR}   %%功能未开通
    end;
add_to_friend_list(Status, {FriendId, FriendName, FriendCareer, FriendGender}) when is_record(Status, player)->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            add_to_friend_list(Status#player.id, {FriendId, FriendName, FriendCareer, FriendGender});
        false ->  
            {false, ?RELA_UNKNOWN_ERROR}   %%功能未开通
    end;
add_to_friend_list(PlayerId, {FriendId})  when is_integer(PlayerId) ->
    case lib_player:get_chat_info_by_id(FriendId) of
        [Nick, Gender, Career, _Camp, _Level] ->
            add_to_friend_list(PlayerId, {FriendId, Nick, Career, Gender});
        _Other ->
            {false, ?RELA_INVALID_UID}  %%好友ID不存在
   end;
add_to_friend_list(PlayerId, {FriendId, FriendName, FriendCareer, FriendGender}) when is_integer(PlayerId) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            case lists:keyfind(FriendId, 1, Relation#relation.foe_list) of
                false ->
                    case lists:keyfind(FriendId, 1, Relation#relation.friend_list) of
                        false ->
                            case length(Relation#relation.friend_list) < Relation#relation.max_friend of
                                true ->
                                    NewRelation = Relation#relation{friend_list = [{FriendId, 0, FriendName, FriendCareer, FriendGender}|Relation#relation.friend_list]},
                                    ets:insert(?ETS_RELATION, NewRelation),
                                    db_agent_relation:update_friend_list(NewRelation),
                                    true;
                                false ->  %%最大好友满了
                                    {false, ?RELA_MAX_FRIEND_REACH}
                            end;
                        _Other ->  %%已经在好友列表了
                            {false, ?RELA_ALREADY_FRIEND}
                    end;
                _Other1 ->  %%已经在仇人列表,不能加为好友
                    {false, ?RELA_IN_FOE_LIST}
            end
    end.

%%删除一个好友
%%返回true成功, {false, Reason}不成功
delete_from_friend_list(PlayerId, FriendId) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            case lists:keyfind(FriendId, 1, Relation#relation.friend_list) of
                false ->
                    {false, ?RELA_NOT_FRIEND};
                _Other ->  %%已经在好友列表了
                    NewFriendList = lists:keydelete(FriendId, 1, Relation#relation.friend_list),
                    NewRelation = Relation#relation{friend_list = NewFriendList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    db_agent_relation:update_friend_list(NewRelation),
                    true
            end
    end.

%%增加一个好友到好友列表
%%PlayerId为玩家ID
%%返回 成功: {true, 新的好友度}, 不成功: {false, Reason}
add_friendship(PlayerId, FriendId, AddFriendShip) when is_integer(PlayerId) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            case lists:keyfind(FriendId, 1, Relation#relation.friend_list) of
                false ->
                    {false, ?RELA_ALREADY_FRIEND};
                {FriendId, OldFriendShip, FName, FCareer, FGender}->  
                    NewFList = lists:keyreplace(FriendId, 1, Relation#relation.friend_list, {FriendId, OldFriendShip + AddFriendShip, FName, FCareer, FGender}),
                    NewRelation = Relation#relation{friend_list = NewFList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    %db_agent_relation:update_friend_list(NewRelation),
                    {true, OldFriendShip + AddFriendShip}
            end
    end.
    
%%增加一个仇人到仇人列表
%%PlayerId为玩家ID, Status为player结构
%%返回true成功, {false, Reason}不成功
add_to_foe_list(Status, {FoeId}) when is_record(Status, player)->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            add_to_foe_list(Status#player.id, {FoeId});
        false ->  
            {false, ?RELA_UNKNOWN_ERROR}    %%功能未开通
    end;
add_to_foe_list(Status, {FoeId, FoeName, FoeCareer, FoeGender}) when is_record(Status, player) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            add_to_foe_list(Status#player.id, {FoeId, FoeName, FoeCareer, FoeGender});
        false ->  
            {false, ?RELA_UNKNOWN_ERROR}    %%功能未开通
    end;
add_to_foe_list(PlayerId, {FoeId}) when is_integer(PlayerId) ->
    case lib_player:get_chat_info_by_id(FoeId) of
        [Nick, Gender, Career, _Camp, _Level] ->
            add_to_foe_list(PlayerId, {FoeId, Nick, Career, Gender});
        _Other ->
            {false, ?RELA_INVALID_UID}    %%好友ID不存在
   end;
add_to_foe_list(PlayerId, {FoeId, FoeName, FoeCareer, FoeGender}) when is_integer(PlayerId) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};
        Relation ->
            case lists:keyfind(FoeId, 1, Relation#relation.friend_list) of
                 false ->
                     case length(Relation#relation.foe_list) < Relation#relation.max_foe of
                         true ->
                             case lists:keyfind(FoeId, 1, Relation#relation.foe_list) of
                                 false ->
                                     NewRelation = Relation#relation{foe_list = [{FoeId, 0, FoeName, FoeCareer, FoeGender}|Relation#relation.foe_list]},
                                     ets:insert(?ETS_RELATION, NewRelation),
                                     db_agent_relation:update_foe_list(NewRelation),
                                     true;
                                 _Other ->  %%已经在列表了
                                     {false, ?RELA_ALREADY_FOE}
                             end;
                         false ->
                             {false, ?RELA_MAX_FOE_REACH}
                     end;
                _Other ->  %%在好友列表中,不能加为仇人
                     {false, ?RELA_IN_FRIEND_LIST}
           end
    end.

%%删除一个仇人
delete_from_foe_list(PlayerId, FoeId) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            case lists:keyfind(FoeId, 1, Relation#relation.foe_list) of
                false ->
                    {false, ?RELA_NOT_FOE};
                _Other ->  %%已经在好友列表了
                    NewFriendList = lists:keydelete(FoeId, 1, Relation#relation.foe_list),
                    NewRelation = Relation#relation{foe_list = NewFriendList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    db_agent_relation:update_foe_list(NewRelation),
                    true
            end
    end.
    

%%增加一个好友到好友列表
%%PlayerId为玩家ID
%%返回 成功: {true, 新的仇恨度}, 不成功: {false, Reason}
add_hostitily(PlayerId, FoeId, AddHostitily) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            case lists:keyfind(FoeId, 1, Relation#relation.foe_list) of
                false ->
                    {false, ?RELA_ALREADY_FRIEND};
                {FoeId, OldHostitily, FName, FCareer, FGender}->  
                    NewFList = lists:keyreplace(FoeId, 1, Relation#relation.foe_list, {FoeId, OldHostitily + AddHostitily, FName, FCareer, FGender}),
                    NewRelation = Relation#relation{foe_list = NewFList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    %db_agent_relation:update_foe_list(NewRelation),
                    {true, OldHostitily + AddHostitily}
            end
    end.
    
%%增加一个人到最近联系人列表
%%PlayerId为玩家ID, Status为player结构
%%返回true成功, {false, Reason}不成功
add_to_recent_list(Status, {Uid}) when is_record(Status, player) ->
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            add_to_recent_list(Status#player.id, {Uid});
        _Other ->
            {false, ?RELA_INVALID_UID}
   end;
add_to_recent_list(Status, {Uid, Name, Career, Gender}) when is_record(Status, player) -> 
    case (Status#player.switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of
        true  ->  
            add_to_recent_list(Status#player.id, {Uid, Name, Career, Gender});
        false ->  
            {false, ?RELA_UNKNOWN_ERROR}
    end;
add_to_recent_list(PlayerId, {Uid}) when is_integer(PlayerId) ->
    case lib_player:get_chat_info_by_id(Uid) of
        [Nick, Gender, Career, _Camp, _Level] ->
            add_to_recent_list(PlayerId, {Uid, Nick, Career, Gender});
        _Other ->
            {false, ?RELA_INVALID_UID}
   end;
add_to_recent_list(PlayerId, {Uid, Name, Career, Gender}) when is_integer(PlayerId)->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};
        Relation ->
            Now = util:unixtime(),
            case lists:keyfind(Uid, 1, Relation#relation.foe_list) of
                false ->
                    %%最近联系人, 取最近的10个
                    NewRecentList = lists:sublist([{Uid, Now, Name, Career, Gender}|Relation#relation.recent_list], 1, 10),
                    NewRelation = Relation#relation{recent_list = NewRecentList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    %%db_agent_relation:update_recent_list(NewRelation),
                    true;
                _Other ->  %%已经在列表了, 更新联系时间
                    NewRecentList = lists:keyreplace(Uid, 1, Relation#relation.recent_list, {Uid, Now, Name, Career, Gender}),
                    NewRelation = Relation#relation{recent_list = NewRecentList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    %%db_agent_relation:update_recent_list(NewRelation),
                    true
            end
    end.
    
%%删除一个最近联系人
delete_from_recent_list(PlayerId, all) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            NewRelation = Relation#relation{recent_list = []},
            ets:insert(?ETS_RELATION, NewRelation),
            true
    end;
delete_from_recent_list(PlayerId, Uid) ->
    case get_relation(PlayerId) of
        [] ->
            {false, ?RELA_UNKNOWN_ERROR};     %%功能未开通
        Relation ->
            case lists:keyfind(Uid, 1, Relation#relation.recent_list) of
                false ->
                    {false, ?RELA_NOT_RECENT};
                _Other ->  %%已经在好友列表了
                    NewRecentList = lists:keydelete(Uid, 1, Relation#relation.recent_list),
                    NewRelation = Relation#relation{recent_list = NewRecentList},
                    ets:insert(?ETS_RELATION, NewRelation),
                    true
            end
    end.

%%----------------------------------------------------------
%%关系内部函数
%%----------------------------------------------------------
%% 返回: 关系记录或[]如果没有开通
get_relation(PlayerId) ->
    case ets:lookup(?ETS_RELATION, PlayerId) of
        [] -> case db_agent_relation:get_relation(PlayerId) of
                  [] ->
                     [];
                  Relation ->
                     Relation 
              end;
        [Relation] -> 
            Relation
    end.

%% 回写关系记录到数据库
%% PlayerId 玩家ID/ Relation关系记录
write_back_relation(PlayerId) when is_integer(PlayerId) ->
    case ets:lookup(?ETS_RELATION, PlayerId) of
        [Relation] when is_record(Relation, relation) ->
            db_agent_relation:update_relation(Relation);
        _Other ->
            skip
    end;
write_back_relation(Relation) when is_record(Relation, relation) ->
    db_agent_relation:update_relation(Relation).

%%获取请求加我为好友的玩家ID
%%玩家进程调用
get_request_uids() ->
   case get(friend_request_ids) of
      List when is_list(List) ->
          List;
      _ -> []
   end.
 
%%被请求玩家方保存:  请求加好友的玩家ID
%%玩家进程调用
put_request_uids(Uids) ->
    UidsOld = get_request_uids(),
    put(friend_request_ids, lists:usort(Uids ++ UidsOld)).
    
%%发起添加好友操作, PlayerId为要被添加玩家Id, RequestUid为发起添加请求Id
%%检查PlayerId是否存在, 以及关系功能是否开启
send_add_friend_request(PlayerId, RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel) ->
    case db_agent_player:get_switch_by_id(PlayerId) of
        [] ->  %%玩家不存在
            {false, ?RELA_INVALID_UID};
        Switch -> 
            case (Switch band ?SW_RELATION_BIT) =:= ?SW_RELATION_BIT of  %%判断是否开启了关系模块
                true ->
                    case lib_player:get_player_pid(PlayerId) of 
                        Pid when is_pid(Pid) ->  %%在线,直接发请求
                            gen_server:cast(Pid, {add_friend_request, RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel});
                        _Other ->  %%不在线, 存数据库等玩家下次登录查看
                            db_agent_relation:add_friend_request(PlayerId, RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel)
                    end,
                    true;
                false ->
                    {false, ?RELA_UNKNOWN_ERROR}
           end
    end.

