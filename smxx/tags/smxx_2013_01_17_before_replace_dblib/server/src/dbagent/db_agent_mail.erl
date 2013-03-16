%%%--------------------------------------
%%% @Module  : db_agent_mail
%%% @Author  : zxb
%%% @Created : 2012.11.26
%%% @Description: 邮件系统及助手系统
%%%            从db_agent.erl移过来。
%%%--------------------------------------
-module(db_agent_mail).

-include("common.hrl").
-include("record.hrl").

-compile(export_all).

%%邮件回馈到GM
mail_feedback(Type, PlayerId, PlayerName, Title, Content, Timestamp, IP, Server) ->
    Feedback = #feedback{
                type = Type, 
                player_id = PlayerId, 
                player_name = PlayerName, 
                title = Title, 
                content = Content,
                timestamp = Timestamp, 
                ip = IP, 
                server = Server},
    ValueList = lists:nthtail(2, tuple_to_list(Feedback)),
    [id | FieldList] = record_info(fields, feedback),
    ?DB_MODULE:insert(feedback, FieldList, ValueList),
    1.

%% 查询玩家的邮件反馈即回复
get_feedback(PlayerId) ->
    ?DB_MODULE:select_all(feedback,"id,type,state,player_name,content,gm,reply,timestamp,reply_time", [{player_id, PlayerId}]).

%% 插入邮件到表mail
insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold) ->
    GoodsListStr = util:term_to_string(GoodsList),
    ?DB_MODULE:insert(mail, [type, state, timestamp, sname, uid, title, content, goods_list, coin, gold], 
                            [Type, 2, Timestamp, SName, UId, Title, Content, GoodsListStr, Coin, Gold]).

%% 获取邮件信息
get_mail(MailId, PlayerId) ->
    case ?DB_MODULE:select_all(mail, "id, type, state, timestamp, sname, uid, title, content, goods_list, coin, gold", 
                                     [{id, MailId},{uid, PlayerId}], 
                                     [],
                                     [1]) of
        [[MailId, Type, State, TimeStamp, SName, Uid, Title, Content, GList, Coin, Gold]] ->
            [MailId, Type, State, TimeStamp, SName, Uid, Title, Content, util:bitstring_to_term(GList), Coin, Gold];
         _ -> []
     end.

%% 更新信件的附件
update_mail_attachment(MailId, GoodsList, Coin, Gold) ->
    GoodsListStr = util:term_to_string(GoodsList),
    ?DB_MODULE:update(mail, [{goods_list, GoodsListStr}, {coin, Coin}, {gold, Gold}],
                            [{id, MailId}]).                         

%% 更新信件状态为已读, 1为已读，2为未读
update_mail_status(MailId, State) ->
    ?DB_MODULE:update(mail, [{state, State}], [{id, MailId}]).

%% 获取用户信件列表
get_maillist(Uid) when is_integer(Uid) ->
    MailList = ?DB_MODULE:select_all(mail, "id, type, state, timestamp, sname, uid, title, content, goods_list, coin, gold", 
                                 [{uid, Uid}]),
    %%转换一下GoodsList
    F = fun(Mail, MList) ->
        case Mail of 
            [MailId, Type, State, TimeStamp, SName, Uid, Title, Content, GList, Coin, Gold] ->
                [[MailId, Type, State, TimeStamp, SName, Uid, Title, Content, util:bitstring_to_term(GList), Coin, Gold]|MList];
            _ -> 
                MList
        end
    end,
    lists:foldr(F, [], MailList);

%% 获取用户信件列表
get_maillist(Name) when is_list(Name) ->
    MailList = ?DB_MODULE:select_all(mail, "id, type, state, timestamp, sname, uid, title, content, goods_list, coin, gold", 
                                 [{sname, Name}]),
    %%转换一下GoodsList
    F = fun(Mail, MList) ->
        case Mail of 
            [MailId, Type, State, TimeStamp, SName, Uid, Title, Content, GList, Coin, Gold] ->
                [[MailId, Type, State, TimeStamp, SName, Uid, Title, Content, util:bitstring_to_term(GList), Coin, Gold]|MList];
            _ -> 
                MList
        end
    end,
    lists:foldr(F, [], MailList).


%%获取用户所有信件，按已读未读以及时间戳来排序
get_maillist_all(UId) ->
    MailList = ?DB_MODULE:select_all(mail,"id, type, state, timestamp, sname, uid, title, content, goods_list, coin, gold", 
                                          [{uid, UId}],[{state ,desc},{timestamp,desc}],[]),
    %%转换一下GoodsList
    F = fun(Mail, MList) ->
        case Mail of 
            [MailId, Type, State, TimeStamp, SName, Uid, Title, Content, GList, Coin, Gold] ->
                [[MailId, Type, State, TimeStamp, SName, Uid, Title, Content, util:bitstring_to_term(GList), Coin, Gold]|MList];
            _ -> 
                MList
        end
    end,
    lists:foldr(F, [], MailList).                     

%%获取用户信件数
get_mail_count(Uid) ->
    ?DB_MODULE:select_count(mail,[{uid, Uid}]).

%% 根据MailId获取信件内容
get_mail_by_id(Id) ->
    case ?DB_MODULE:select_all(mail, "id, type, state, timestamp, sname, uid, title, content, goods_list, coin, gold", 
                                      [{id, Id}],[],[1]) of
        [[MailId, Type, State, TimeStamp, SName, Uid, Title, Content, GList, Coin, Gold]|_T] ->
            [MailId, Type, State, TimeStamp, SName, Uid, Title, Content, util:bitstring_to_term(GList), Coin, Gold];
         _ -> []
     end.

%% 获取所有信件id
get_all_mail_ids() ->
    ?DB_MODULE:select_all(mail, "id", []).

%% 检查邮件中是否存在未读邮件
check_mail_unread(UId) ->
    ?DB_MODULE:select_all(mail, "id, type, state", [{uid, UId}, {state, 2}], [], [1]).

%% 删除信件
del_mail(MailId) ->
    ?DB_MODULE:delete(mail, [{id, MailId}]).

%%插入私人邮件日志
insert_mail_log(Time, SName, UId, GoodsList, Coin, Gold, Act) ->
    GoodsListStr = util:term_to_string(GoodsList),
    ?DB_MODULE:insert(log_mail,  [time, sname, uid, goods_list, coin, gold, act], 
                                 [Time, SName, UId, GoodsListStr, Coin, Gold, Act]).

%%加载所有基础小师妹信件
selelct_shimei_mails() ->
    MailList = ?DB_MODULE:select_all(base_shimei_mail, "mid, level, coin, gold, goods_list, title, content", []),
    F1 = fun([Mid, Level, Coin, Gold, GListStr, Title, Content]) ->
        GList = util:bitstring_to_term(GListStr),
        %%转换一下物品列表类型格式
        F2 = fun(Good, GoodsList) ->
                case Good of
                    {GoodsTypeId, GoodsNum} when GoodsTypeId =/= 0 andalso GoodsNum >= 1 ->
                        [{0, GoodsTypeId, GoodsNum}|GoodsList];
                    _ -> 
                        GoodsList
                end
        end,
        NewGList = lists:foldr(F2, [], GList),
        {Mid, Level, Coin, Gold, NewGList, Title, Content}
    end,
    lists:map(F1, MailList).

%% 获得物品类型ID
get_mail_goods_type_id(GoodsId) ->
	?DB_MODULE:select_row(goods, "player_id, goods_id", [{id, GoodsId}], [], [1]).

            
