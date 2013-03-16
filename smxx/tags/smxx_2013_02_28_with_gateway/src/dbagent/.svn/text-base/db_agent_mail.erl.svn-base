%%--------------------------------------
%% @Module  : db_agent_mail
%% @Author  : water
%% @Created : 2013.02.06
%% @Description: 邮件系统
%%--------------------------------------
-module(db_agent_mail).

-include("common.hrl").
-include("record.hrl").

-compile(export_all).

%%邮件物品格式: 
%%[{GoodTypeId, Num, State},...]
%%GoodTypeId为物品类型ID, Num为物品的数量, State为附件物品状态, 1:有效(未提取), 0:已提取
%%玩家私人邮件不允许发送物品

%%邮件回馈到GM
insert_feedback(Type, PlayerId, Name, Content, Timestamp, IP, Server) ->
    FieldList = [type, state, uid, name, content, timestamp, ip, server],
    ValueList = [Type, 0, PlayerId, Name, Content, Timestamp, IP, Server],
    ?DB_MODULE:insert(feedback, FieldList, ValueList).

%%查询反馈回复
get_feedback(PlayerId) ->
   ?DB_MODULE:select_all(feedback,"id, type, state, name, content, timestamp, gm, reply, reply_time", [{uid, PlayerId}]).

%%删除反馈
delete_feedback(FbId) ->
   ?DB_MODULE:delete(feedback, [{id, FbId}]).

%% 插入邮件到表mail
insert_mail(Type, State, Timestamp, SName, Uid, Title, Content, GoodsList) ->
    GoodsListStr = util:term_to_string(GoodsList),
    ?DB_MODULE:insert(mail, [type, state, timestamp, sname, uid, title, content, goods_list], 
                            [Type, State, Timestamp, SName, Uid, Title, Content, GoodsListStr]).

%%删除信件
delete_mail(MailId) ->
    ?DB_MODULE:delete(mail, [{id, MailId}]).
%%删除信件
delete_mail(MailId, PlayerId) ->
    ?DB_MODULE:delete(mail, [{id, MailId},{uid, PlayerId}]).

%%获取所有信件id, type, timestamp
get_all_mail_info() ->
    ?DB_MODULE:select_all(mail, "id, type, timestamp", []).

%% 获取邮件接收方ID, 发送方名字
get_uid_by_mail_id(MailId) ->
    ?DB_MODULE:select_one(mail, "uid", [{id, MailId}], [], []).

%% 获取邮件发送方名字, 标题
get_mail_title_id(MailId) ->
    ?DB_MODULE:select_row(mail, "sname, title", [{id, MailId}], [], [1]).

%%获取玩家所有信件,按时间戳来排序
get_mail_all(Uid) ->
    MailList = ?DB_MODULE:select_all(mail,"id, type, state, timestamp, sname, title, goods_list", 
                                          [{uid, Uid}],[{timestamp,desc}],[]),
    %%转换一下GoodsList
    F = fun(Mail, MList) ->
        case Mail of 
            [MailId, Type, State, TimeStamp, SName, Title,  GList] ->
                [[MailId, Type, State, TimeStamp, SName, Title, util:bitstring_to_term(GList)]|MList];
            _ -> 
                MList
        end
    end,
    lists:foldr(F, [], MailList).

%% 获取邮件
get_mail_content(MailId, PlayerId) ->
    case ?DB_MODULE:select_row(mail, "id, state, content, goods_list", [{id, MailId}, {uid, PlayerId}], [], [1]) of
        [MailId, State, Content, GList] ->
            [MailId, State, Content, util:bitstring_to_term(GList)];
         _ -> 
            []
     end.

%% 获取邮件附件内容
get_mail_attachment(MailId, PlayerId) ->
    case ?DB_MODULE:select_one(mail, "goods_list", [{id, MailId}, {uid, PlayerId}], [], [1]) of
        [] -> [];
        GList -> util:bitstring_to_term(GList)
     end.

%% 更新信件的物品附件
update_attachment(MailId, GoodsList) ->
    GoodsListStr = util:term_to_string(GoodsList),
    ?DB_MODULE:update(mail, [{goods_list, GoodsListStr}], [{id, MailId}]).                         

%% 更新信件状态
update_state(MailId, State) ->
    ?DB_MODULE:update(mail, [{state, State}], [{id, MailId}]).

%%获取用户信件数
get_mail_count(Uid) ->
    ?DB_MODULE:select_count(mail,[{uid, Uid}]).

%%获取存在未读/已读邮件数
get_mail_count(Uid, State) ->
    ?DB_MODULE:select_count(mail, [{uid, Uid}, {state, State}]).

%%插入私人邮件日志
insert_mail_log(Time, SName, Uid, GoodsList, Act) ->
    GoodsListStr = util:term_to_string(GoodsList),
    ?DB_LOG_MODULE:insert(log_mail,  [time, sname, uid, goods_list, act], 
                                     [Time, SName, Uid, GoodsListStr, Act]).

