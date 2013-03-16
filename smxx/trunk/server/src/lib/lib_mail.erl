%%------------------------------------
%% @Module     : lib_mail
%% @Author     : water
%% @Created    : 2013.02.06
%% @Description: 信件系统
%%------------------------------------
-module(lib_mail).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("mail.hrl").
-include("debug.hrl").
-include("log.hrl").

%%邮件物品格式: 
%%[{GoodTypeId, Num, State},...]
%%GoodTypeId为物品类型ID, Num为物品的数量, State为附件物品状态, 1:有效(未提取), 0:已提取
%%玩家私人邮件不允许发送物品
%%------------------------------------
%% GM邮件处理
%%------------------------------------
%%玩家反馈插入到数据库的feedback表
feedback(Type, Content, Address, PlayerId, Name) ->
    Server = atom_to_list(node()),
    Timestamp = util:unixtime(),
    {A, B, C, D} = Address,
    IP = lists:concat([A, ".", B, ".", C, ".", D]),
    db_agent_mail:insert_feedback(Type, PlayerId, Name, Content, Timestamp, IP, Server).

%---------------------------------------------
%Protocol: 19002  获取GM反馈
%---------------------------------------------
%%读取反馈及回复
get_feedback_list(PlayerId) ->
    FBList = db_agent_mail:get_feedback(PlayerId) ,
    case FBList of 
        [] ->
            [];
        _ ->
            F = fun(FeedBack) ->
                [Id, Type, State, Nick, Cont, SendTime, Gm, Reply, ReplayTime] = FeedBack,
                case State of
                     1  ->  %% 已回复, 包含GM的回复
                         ReplayList = [[Nick,Cont,SendTime], [Gm,Reply,ReplayTime]];
                     _  ->
                         ReplayList = [[Nick,Cont,SendTime]]
                end,
                [Id,Type,State,ReplayList]
            end,
            lists:map(F, FBList)
    end.

%%------------------------------------
%% 邮件处理
%%------------------------------------
%%获得信件id进行信件时间检查
%%并删除老邮件
clean_old_mail() ->
    %% 获得所有信件的[id, type, timestamp]
    ?TRACE("~s cleaning old mail~n", [misc:time_format(now())]),
    case db_agent_mail:get_all_mail_info() of
        [] ->
            ok;
        MailList ->
            lists:foreach(fun(Item) -> clean_old_mail(Item) end, MailList)
    end.
%% 根据信件Id对该信件进行期限检查
clean_old_mail([MailId, Type, TimeStamp]) ->
    Now = util:unixtime(),     %% 当前时间戳
    case ((Now >= TimeStamp + ?SYS_MAIL_KEEP) andalso (Type =:= ?MAIL_TYPE_SYS)) orelse
         ((Now >= TimeStamp + ?PRIV_MAIL_KEEP) andalso (Type =:= ?MAIL_TYPE_PRIV)) of    
         true ->
             db_agent_mail:delete_mail(MailId);
         false ->
             skip
    end.

%--------------------------------
%Protocol: 19011  邮件列表
%--------------------------------
get_mail(Status) ->
    case db_agent_mail:get_mail_all(Status#player.id) of
        [] ->   
            [];
        MailList ->
            F = fun(Mail) ->
                [MailId, Type, State, TimeStamp, SName, Title, GoodList|_T] = Mail,
                %信件状态（1已读/2未读/3已读有附件/4未读有附件）
                if GoodList =/= [] andalso State =:= ?MAIL_STATE_READ ->
                       NewState = 3;
                   GoodList =/= [] andalso State =:= ?MAIL_STATE_READ ->
                       NewState = 4;
                   State =:= ?MAIL_STATE_READ ->
                       NewState = 1;
                   true ->
                       NewState = 2
                end,
                [MailId, Type, NewState, TimeStamp, SName, Title]
            end,
            lists:map(F, MailList)
    end.

%--------------------------------
%Protocol: 19012  邮件具体内容
%--------------------------------
get_mail(Status, MailId) ->
    case db_agent_mail:get_mail_content(MailId, Status#player.id) of
        [] ->
            {false, ?MAIL_WRONG_ID};        
        Mail ->
            [MailId, State, Content, GoodList|_T] = Mail,
            %%检查是否是玩家的邮件
            if State =:= ?MAIL_STATE_NEW ->
                   %% 更新信件状态为已读
                   db_agent_mail:update_state(MailId, ?MAIL_STATE_READ),
                   {true, [MailId, Content, GoodList]};
               true ->
                   {true, [MailId, Content, GoodList]}
            end
    end.

%--------------------------------
%Protocol: 19014 收取附件
%--------------------------------
get_attachment(Status, MailId) ->
    GoodsList = db_agent_mail:get_mail_attachment(MailId, Status#player.id),
    AttachGList = [{GoodsId, Num}||{GoodsId, Num, State} <- GoodsList, State =:= 1],
    if AttachGList =:= [] ->
           {false, ?MAIL_ATTACH_NOT_EXIST};  %%没有附件
       true ->  %%提取附件(略)
            case check_bag_enough(Status, AttachGList) of
                true ->
                    NewStatus = goods_util:send_goods_and_money(Status, AttachGList, ?LOG_GOODS_MAIL),
                    GotList = [{GoodsId, Num, 0}||{GoodsId, Num, _} <- GoodsList],
                    db_agent_mail:update_attachment(MailId, GotList),
                    {true, NewStatus};
                false ->
                    {false, ?MAIL_NOT_ENOUGH_SPACE}
           end
    end.

%--------------------------------
%Protocol: 19015 删除邮件
%--------------------------------
delete_mail(_Status, []) ->
    skip;
delete_mail(Status, [MailId|T]) ->
    db_agent_mail:delete_mail(MailId, Status#player.id),
    delete_mail(Status, T).
    
%%群发送系统信件
%%参数: RecvList为玩家角色名列表/或玩家Id列表
%%      GoodsList格式为 [{GoodsTypeId, Num},...]
%%返回: 成功: true, 全部成功
%%      {false, Reason/错误名字列表}
send_sys_mail(RecvList, Title, Content, GoodsList) ->
    Timestamp = util:unixtime(),
    case check_mail(RecvList, Title, Content, GoodsList) of
        {true, ValidIdList, NewGoodsList} ->
            %%这里发出的系统邮件不会失败了
            send_mail_to_some(ValidIdList, ?MAIL_TYPE_SYS, Timestamp, "系统", Title, Content, NewGoodsList),
            %%如果在线, 通知有新邮件
            [notify_new_mail(PlayerId)||PlayerId<-ValidIdList],
            true;
        {false, Reason} -> 
            {false, Reason}
    end.

%% 发送私人信件
%%参数: RecvList为玩家角色名列表
send_priv_mail(Status, RecvList, Title, Content) ->
    Timestamp = util:unixtime(),  
    case check_mail(RecvList, Title, Content, []) of
         {true, ValidIdList, _} ->
              {SucceedIdList, FailIdList} = send_mail_to_some(ValidIdList, ?MAIL_TYPE_PRIV, Timestamp, Status#player.nick, Title, Content, []),
              %%如果在线, 通知有新邮件
              [notify_new_mail(PlayerId)||PlayerId<-SucceedIdList],
              if FailIdList =:= [] ->
                     true;
                 true ->
                     {false, ?MAIL_BOX_FULL}  %%有些人邮箱满了
              end;
        {false, Reason} ->
              {false, Reason}
    end.

%%回复私人信件
reply_priv_mail(Status, MailId, Content) ->
    case check_content(Content) of
        true ->
            case db_agent_mail:get_mail_title_id(MailId) of
                [SName, Title] ->
                      NewTitle = lists:sublist(lists:concat(["回复:", tool:to_list(Title)]), 1, 30),
                      send_priv_mail(Status, [SName], NewTitle, Content);
                [] ->
                      {false, ?MAIL_WRONG_ID}
            end;
        false ->
            {false, ?MAIL_WRONG_CONTENT}
    end.

%%通知玩家有新邮件
notify_new_mail(PlayerId) ->
    %%玩家是否在线, 在线时才通知
    case lib_player:get_player_pid(PlayerId) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, refresh_mail);
        _ ->
            skip
    end.

%%通知玩家有新邮件
notify_new_mail2(MailId) ->
    case db_agent_mail:get_uid_by_mail_id(MailId) of
        Uid when is_integer(Uid) ->
            notify_new_mail(Uid);
        _Other ->
            skip
    end.

%% 检查邮件中是否存在未读邮件
get_newmail_count(Uid) ->
    db_agent_mail:get_mail_count(Uid, ?MAIL_STATE_NEW).

%--------------------------------------------------
% 邮件内部函数
%--------------------------------------------------
%% 邮件检查
%% 检查内容（限制500汉字) 暂不检查敏感词
check_content(Content) ->
    length(Content) =< 1000.

%% 检查主题长度（限制25汉字）暂不检查敏感词
check_title(Title) ->
    length(Title) =< 50.

%% 检查邮件是否已满
check_mail_full(Uid) ->
    case db_agent_mail:get_mail_count(Uid) of
        []    -> true;
        [Num] ->  Num >= ?MAX_MAIL_NUM
    end.

%%检查并转换玩家名为玩家ID, 检查玩家ID有效性
%%返回: 成功, {true, Id列表}
%%      失败  {false, 错误名字列表}
convert_name_list(NameList) ->
    F = fun(NameOrId, {IdList, NmList}) ->
        case NameOrId of
            Name when is_list(Name) ->  %%检查是否有效玩家名
                case lib_player:get_role_id_by_name(Name) of
                    [] -> {IdList, [Name|NmList]};
                    Id -> {[Id|IdList], NmList}
                end;
            Id when is_integer(Id) ->  %%数字,检查是否有效玩家ID
                case lib_player:get_role_name_by_id(Id) of
                    [] -> {IdList, [Id|NmList]};
                    _ -> {[Id|IdList], NmList}
                end;
           _ -> 
                {IdList, [NameOrId|NmList]}
        end
    end,
    {ValidIdList, ErrNameList} = lists:foldr(F, {[], []}, NameList),
    case length(ValidIdList) =:= length(NameList) of
        true  -> {true,  ValidIdList};
        false -> {false, ErrNameList}
    end.
    
%%检查物品格式[{GoodTypeId, Num},...]
%%是否有误, 并转换为格式: 
%%[{GoodTypeId, Num, State},...]
%%GoodTypeId为物品类型ID, Num为物品的数量, State为附件物品状态, 1:有效(未提取), 0:已提取
convert_goods_list(GoodsList) ->
    F = fun({GoodTypeId, Num}, {GList, ErrGList}) ->
        case goods_util:is_goodstid(GoodTypeId) of %%检查物品类型ID是否有效
            false -> {GList, [{GoodTypeId, Num}|ErrGList]};
            true  -> {[{GoodTypeId, Num, 1}|GList], ErrGList}
        end
    end,
    {NewGoodsList, ErrGoodsList} = lists:foldr(F, {[], []}, GoodsList),
    case length(NewGoodsList) =:= length(GoodsList) of
        true  -> {true,  NewGoodsList};
        false -> {false, ErrGoodsList}
    end.

%% 检查信件
%% 标题长度,内容长度, 物品有效性, 名字换成ID
%% 返回值: {true, IdList}
%%         {false, Reason}  标题或内容,物品有误
%%         {false, InvalidNameList} 玩家名有误
%% IdList为有效用户Id, NameList为无效玩家名
check_mail(NameList, Title, Content, GoodsList) -> 
    %%检查标题及内容
    case check_title(Title) of
        true ->
            case check_content(Content) of
                true ->
                     case convert_goods_list(GoodsList) of
                         {true, NewGoodsList} ->
                              case convert_name_list(NameList) of
                                  {true, ValidIdList} -> 
                                       {true, ValidIdList, NewGoodsList};
                                  {false, _ErrNList} ->
                                       {false, ?MAIL_WRONG_NAME}
                              end;
                         {false, _ErrGList} ->
                             {false, ?MAIL_GOODS_NOT_EXIST}
                    end;
                false ->
                    {false, ?MAIL_WRONG_CONTENT}
            end;
        false ->
            {false, ?MAIL_WRONG_TITLE}   
    end.

%% 发送信件给多个收件人
%% 返回{VList, IList}
%% VList:信件已正确发送的收件人ID列表
%% IList:未正确发送的收件人ID列表
send_mail_to_some(UidList, Type, Timestamp, SName, Title, Content, GoodsList) ->
    F = fun(Uid) ->
         case Type of
             ?MAIL_TYPE_SYS -> %%系统信件可群发附件
                 db_agent_mail:insert_mail(Type, ?MAIL_STATE_NEW, Timestamp, SName, Uid, Title, Content, GoodsList),
                 true;
             ?MAIL_TYPE_PRIV -> %%私人信件不可发送附件
                 case check_mail_full(Uid) of
                     true ->
                         false;
                     _ ->
                         db_agent_mail:insert_mail(Type, ?MAIL_STATE_NEW, Timestamp, SName, Uid, Title, Content, []),
                         true
                 end;
             _ -> false
         end
    end,
    lists:partition(F, UidList).

%%检查背包是否足够
check_bag_enough(Status, GoodsList) ->
    if GoodsList =:= [] ->
        true;
    true ->
        NumCells = goods_util:handle_get_bag_null_cells_nums(Status),
        [_, _, InBagList] = goods_util:split_goods(GoodsList),
        NumCells >= length(InBagList)
    end.

%% 随机插入信件到数据库（测试用）
%% Start: 起始编号，N 结束编号
rand_insert_mail(Uid, Start, N) ->
    {{Year, Month, Day}, {Hour, Minute, Second}} = erlang:localtime(),
    Content = "内容" ++ integer_to_list(Start) ++ ", " ++ integer_to_list(Year) ++ "-" ++ integer_to_list(Month) ++
        "-" ++ integer_to_list(Day) ++ ", " ++ integer_to_list(Hour) ++ ":" ++ integer_to_list(Minute)
        ++ ":" ++ integer_to_list(Second),
    Title = "标题" ++ integer_to_list(Start),
    Type = random:uniform(2),
    Timestamp = util:unixtime(),
    SName = integer_to_list(random:uniform(10000)),
    GoodsList = [],
    db_agent_mail:insert_mail(Type, ?MAIL_STATE_NEW, Timestamp, SName, Uid, Title, Content, GoodsList),
    case N =< 1 of
        true ->
            ok;
        false ->
            timer:sleep(500),
            rand_insert_mail(Uid, Start + 1, N - 1)
    end.
