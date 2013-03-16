%%--------------------------------------
%% @Module: dg_agent_guild
%% Author:  water
%% Created: Tue Feb 19 2013
%% Description: 帮派
%%--------------------------------------

-module(db_agent_guild).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").

-compile(export_all).

%%
%% API Functions
%%

%%加载所有帮派信息
load_all_guild() ->
	case ?DB_MODULE:select_all(guild, "*", []) of
        [] -> 
            [];
        GuildList ->
            lists:map(fun(Guild) -> list_to_tuple([guild|Guild]) end, GuildList)
    end.

%%加载帮派所有成员
load_member_by_guild_id(GuildId) ->
	case ?DB_MODULE:select_all(guild_member, "*", [{guild_id, GuildId}], [{position, asc}, {last_login_time, desc}], []) of
       [] -> 
            [];
        MemberList ->
            lists:map(fun(Member) -> 
                          Member1 = list_to_tuple([guild_member|Member]),
                          Member1#guild_member{sklist = util:bitstring_to_term(Member1#guild_member.sklist)}
                      end,
                      MemberList)
    end.

%%加载玩家帮派记录
load_member_by_role_id(PlayerId) ->
	case ?DB_MODULE:select_all(guild_member, "*", [{uid, PlayerId}], [], [1]) of
        [] -> 
            [];
        [Member|_T] ->
            Member1 = list_to_tuple([guild_member|Member]),
            Member1#guild_member{sklist = util:bitstring_to_term(Member1#guild_member.sklist)}
    end.

%%加载帮派所有申请
load_guild_apply(GuildId) ->
	case ?DB_MODULE:select_all(guild_apply, "*", [{guild_id, GuildId}]) of
        [] -> 
            [];
        ApplyList ->
            lists:map(fun(Apply) -> list_to_tuple([guild_apply|Apply]) end, ApplyList)
    end.

%%添加帮派
insert_guild(Guild) ->
    ValueList = lists:nthtail(2, tuple_to_list(Guild)),
    [id | FieldList] = record_info(fields, guild),
	Ret = ?DB_MODULE:insert_get_id(guild, FieldList, ValueList),
    Guild#guild{id = Ret}.

%%添加帮派成员
insert_member(GMember) ->
    Member = GMember#guild_member{sklist = util:term_to_string(GMember#guild_member.sklist)},
    ValueList = lists:nthtail(1, tuple_to_list(Member)),
    FieldList = record_info(fields, guild_member),
	?DB_MODULE:insert(guild_member, FieldList, ValueList).

%%插入帮派申请 
insert_apply(Apply) ->
    ValueList = lists:nthtail(2, tuple_to_list(Apply)),
    [id | FieldList] = record_info(fields, guild_apply),
	Ret = ?DB_MODULE:insert_get_id(guild_apply, FieldList, ValueList),
    Apply#guild_apply{id = Ret}.
   
%%删除帮派表
delete_guild(GuildId) ->
	?DB_MODULE:delete(guild, [{id, GuildId}]).

%%删除帮派成员表
delete_member_by_guild_id(GuildId) ->
	?DB_MODULE:delete(guild_member, [{guild_id, GuildId}]).

%%删除帮派成员表
delete_member_by_role_id(PlayerId) ->
	?DB_MODULE:delete(guild_member, [{uid, PlayerId}]).

%%删除申请记录表
delete_apply(GuildId, PlayerId) ->
	?DB_MODULE:delete(guild_apply, [{uid, PlayerId}, {guild_id, GuildId}]).

%%删除申请记录表
delete_apply_by_guild_id(GuildId) ->
	?DB_MODULE:delete(guild_apply, [{guild_id, GuildId}]).

%%删除申请记录表
delete_apply_by_role_id(PlayerId) ->
	?DB_MODULE:delete(guild_apply, [{uid, PlayerId}]).

%%删除解散的帮派所有日志
delete_guild_log(GuildId) ->
	?DB_MODULE:delete(guild_log, [{guild_id, GuildId}]).

%%更新帮派成员数
update_guild_num(GuildId, CurrentNum) ->
	?DB_MODULE:update(guild, [{current_num, CurrentNum}], [{id, GuildId}]).

%%修改帮派公告
update_guild_announce(GuildId, Announce) ->
	?DB_MODULE:update(guild,  [{annouce, Announce}],  [{id, GuildId}]).

%%更新弹劾信息
update_accuse(GuildId, PlayerId, ExpireTime) ->
	?DB_MODULE:update(guild,  [{accuse_id, PlayerId}, {accuse_time, ExpireTime}],  [{id, GuildId}]).
    
%%更新成员等级等信息
update_member(PlayerId, Level, ForceAtt, LastLoginTime) ->
	?DB_MODULE:update(guild_member, [{level, Level},{force_att, ForceAtt}, {last_login_time, LastLoginTime}], [{uid, PlayerId}]).

%%更新投票统计
update_vote(PlayerId, Vote, ExpireTime) ->
	?DB_MODULE:update(guild_member,  [{vote, Vote}, {accuse_time, ExpireTime}],  [{uid, PlayerId}]).

%%更新成员的职位
update_position(PlayerId, NewPos) ->
	?DB_MODULE:update(guild_member, [{position, NewPos}], [{uid, PlayerId}]).

%%检测指定帮派名是否已存在
is_guild_name_exist(GuildName) ->
    ?DB_MODULE:select_one(guild, "id", [{name, GuildName}], [], [1]).

