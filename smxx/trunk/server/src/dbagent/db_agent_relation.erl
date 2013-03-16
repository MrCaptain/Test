%%--------------------------------------
%% @Module: db_agent_relation 
%% Author:  water
%% Created: Tue Jan 30 2013
%% Description: 关系(好友,仇人)
%%--------------------------------------
-module(db_agent_relation).
-include("common.hrl").
-include("record.hrl").
-compile(export_all).

%% friend_list格式 [{Uid, FriendShip, Name, Career, Gender}, ...], FirendShip 友好度
%% foe_list格式 [{Uid, Hostitily, Name, Career, Gender}, ...], Hostitily 仇恨度
%% recent_list格式 [{Uid, Time, Name, Career, Gender}, ...], Time 最近一次发生关系时间(秒)

%% 获取玩家关系记录
get_relation(PlayerId) ->
    case ?DB_MODULE:select_row(relation, "*", [{uid, PlayerId}], [], [1]) of
        [] -> [];
        R  -> Relation = list_to_tuple([relation|R]),
              Relation#relation{ friend_list = util:bitstring_to_term(Relation#relation.friend_list),
                                 foe_list = util:bitstring_to_term(Relation#relation.foe_list),
                                 recent_list = util:bitstring_to_term(Relation#relation.recent_list)}
    end.

%% 新建玩家关系记录
insert_relation(Relation) ->
    RelationForDB = Relation#relation{ friend_list =  util:term_to_string(Relation#relation.friend_list),
                                       foe_list = util:term_to_string(Relation#relation.foe_list),
                                       recent_list =  util:term_to_string(Relation#relation.recent_list)
                                     },
    ValueList = lists:nthtail(1, tuple_to_list(RelationForDB)),
    FieldList = record_info(fields, relation),
    ?DB_MODULE:insert(relation, FieldList, ValueList).

%% 更新关系记录
update_relation(Relation) ->
    RelationForDB = Relation#relation{ friend_list =  util:term_to_string(Relation#relation.friend_list),
                                       foe_list = util:term_to_string(Relation#relation.foe_list),
                                       recent_list =  util:term_to_string(Relation#relation.recent_list)
                                     },
    [_Uid|ValueList] = lists:nthtail(1, tuple_to_list(RelationForDB)),
    [uid|FieldList] = record_info(fields, relation),
    ?DB_MODULE:update(relation, FieldList, ValueList, uid, Relation#relation.uid).

%% 更新好友列表
update_friend_list(Relation) ->
    FriendListStr = util:term_to_string(Relation#relation.friend_list),
    ?DB_MODULE:update(relation,[{friend_list, FriendListStr}],[{uid, Relation#relation.uid}]).

%% 更新仇人列表
update_foe_list(Relation) ->
    FoeListStr = util:term_to_string(Relation#relation.foe_list),
    ?DB_MODULE:update(relation,[{foe_list, FoeListStr}],[{uid, Relation#relation.uid}]).

%% 更新最近联系人列表
update_recent_list(Relation) ->
    RecentStr = util:term_to_string(Relation#relation.recent_list),
    ?DB_MODULE:update(relation,[{recent_list, RecentStr}],[{uid, Relation#relation.uid}]).
    
%% 添加好友请求到数据表
add_friend_request(PlayerId, RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel) ->
    Now = util:unixtime(),
    ?DB_MODULE:insert(rela_friend_req, [uid, req_uid, req_nick, req_career, req_gender, req_camp, req_level, timestamp, response],
                                       [PlayerId, RequestUid, ReqNick, ReqCareer, ReqGender, ReqCamp, ReqLevel, Now, 0]).

%% 添加好友请求到数据表
get_friend_request(PlayerId) ->
    ?DB_MODULE:select_all(rela_friend_req, "req_uid, req_nick, req_career, req_gender, req_camp, req_level", [{uid, PlayerId}, {response, 0}], [], []).
    
% 更新好友请求回应状态
update_response(PlayerId, RequestUid, Response) ->
    ?DB_MODULE:update(rela_friend_req, [{response, Response}], [{uid,PlayerId}, {req_uid, RequestUid}]).

% 删除好友请求记录
delete_request(PlayerId, RequestUid) ->
    ?DB_MODULE:delete(rela_friend_req, [{uid,PlayerId}, {req_uid,RequestUid}]).
    

