%%%------------------------------------
%%% @Module     : lib_mail
%%% @Author     : csj
%%% @Created    : 2010.10.05
%%% @Description: 信件处理/助手系统函数
%%%------------------------------------
-module(lib_mail).
-export(
    [
        clean_old_mail/0,       %% 检查信件有效期
        check_unread/1,         %% 查询是否存在未读信件
        feedback/6,             %% 玩家反馈（GM提交）
        get_feedback_list/1,    %% 玩家获取反馈列表
        get_attachment/2,       %% 获取附件
        get_mail/2,             %% 获取邮件
        get_maillist/1,         %% 获取邮件列表
        get_mail_page/4,        %% 分页获取用户信件
        check_mail_full/1,      %% 检查邮件是否已满
        rand_insert_mail/3,     %% 随机插入信件（测试用）
        send_priv_mail/6,       %% 发送私人邮件(unused)
        send_mail_to_one/9,     %% 发送私人邮件
        send_sys_mail/6,        %% 发送系统邮件
        check_assist_unread/1,  %% 检查是否有小师妹邮件
        notify_new_mail/1       %% 通知玩家有新的小师妹邮件
    ]).

-include("common.hrl").
-include("record.hrl").
-include("debug_trace.hrl").

-define(OTHER_ERROR,           0).  %% 其它错误
-define(WRONG_TITLE,           2).  %% 标题错误
-define(WRONG_CONTENT,         3).  %% 内容错误
-define(CANNOT_SEND_ATTACH,    4).  %% 不能发送附件
-define(WRONG_NAME,            5).  %% 无合法收件人
-define(NOT_ENOUGH_COIN,       7).  %% 金钱不足
-define(GOODS_NUM_NOT_ENOUGH,  8).  %% 物品数量不足
-define(GOODS_NOT_EXIST,       9).  %% 物品不存在
-define(GOODS_NOT_IN_PACKAGE, 10).  %% 物品不在背包
-define(ATTACH_CANNOT_SEND,   11).  %% 附件不能发送
-define(MAIL_FULL,            12).  %% 对方邮件已满
-define(NOT_ENOUGH_SPACE,      2).  %% 背包已满
-define(ATTACH_NOT_EXIST,      3).  %% 信件中不存在附件
-define(GOODS_NOT_EXIST_2,     4).  %% 信件中物品不存在

-define(POSTAGE, 50).               %% 邮资
-define(MAX_MAIL_NUM, 50).          %% 每个用户信件数量上限
-define(SYS_MAIL_KEEP, 20).         %% 系统邮件保留时间（天）

-define(MAIL_TYPE_ANY, 0).          %% 所有信件
-define(MAIL_TYPE_SYS, 1).          %% 系统信件
-define(MAIL_TYPE_PERSONAL, 2).     %% 私人信件
-define(MAIL_TYPE_ASSIST, 3).       %% 助手系统信件
-define(MAIL_TYPE_REQUEST, 10).     %% 玩家发给助手系统（小师妹）的信件

-define(MAIL_STATE_READ, 1).        %% 邮件已读状态
-define(MAIL_STATE_NEW, 2).         %% 邮件未读状态

%% 插入玩家反馈至数据库的feedback表
%% @spec feedback(Type, Title, Content, Address, PlayerId, PlayerName) -> Result
%%      Result : 0 | 1
%% feedback(Type, Title, Content, Address, PlayerId, PlayerName) ->
feedback(Type, Title, Content, Address, PlayerId, PlayerName) ->
    Server = atom_to_list( node() ),
    Timestamp = util:unixtime(),
    {A, B, C, D} = Address,
    IP = lists:concat([A, ".", B, ".", C, ".", D]),
    case db_agent_mail:mail_feedback(Type, PlayerId, PlayerName, Title, Content, Timestamp, IP, Server) of
        1  -> 1;
        _  -> 0
    end.

%%获取GM反馈
get_feedback_list(PlayerId) ->
    FBList = db_agent_mail:get_feedback(PlayerId) ,
    case FBList of 
        [] ->
            [] ;
        _ ->
            lists:map(
                fun(FeedBack) ->
                    [Id,Type,State,Nick,Cont,Gm,Reply,SendTime,ReplayTime] = FeedBack ,
                    case State of
                        1  ->    %% 已回复
                            ReplayList = [{Gm,Reply,ReplayTime},{Nick,Cont,SendTime}] ;
                        _ ->
                            ReplayList = [{Nick,Cont,SendTime}] 
                    end,
                    {Id,Type,State,ReplayList}
                end, FBList)
    end.



%% 邮件检查
%% 检查内容（限制500汉字） 
check_content(Content) ->
    check_length(Content, 1000).

%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
string_width(String) ->
    string_width(String, 0).
string_width([], Len) ->
    Len;
string_width([H | T], Len) ->
    case H > 255 of
        true ->
            string_width(T, Len + 2);
        false ->
            string_width(T, Len + 1)
    end.

%% 长度合法性检查
check_length(Item, LenLimit) ->
    case asn1rt:utf8_binary_to_list(list_to_binary(Item)) of
        {ok, UnicodeList} ->
            Len = string_width(UnicodeList),   
            Len =< LenLimit andalso Len >= 1;
        {error, _Reason} ->
            error
    end.

%% 检查角色名长度合法性，合法则查询是否存在角色
check_name(Name) ->
    case check_length(Name, 11) of
        true ->
            lib_player:is_exists_name(Name);     %% 存在true，不存在false
        %% false与error
        _Other ->    
            false
    end.

%% 检查邮件是否已满
check_mail_full(Uid) ->
    [Mail_count] = db_agent_mail:get_mail_count(Uid),
    if 
        Mail_count < ?MAX_MAIL_NUM ->
            false;
        true ->
            true
    end.

%% 检查主题长度（限制25汉字）
check_title(Title) ->
    check_length(Title, 50).

%% 检查信件是否合法，如合法，返回有效的角色名列表与无效的角色名列表
%% @spec check_mail(NameList, Title, Content, GoodsId, Coin, Gold) ->
%%          {ok, Name} | {error, Position} | {VList, IList}
%check_mail(NameList, Title, Content, GoodsList, Coin, Gold) ->
check_mail(NameList, Title, Content, _GoodsList, _Coin, _Gold) -> 
    case check_title(Title) of  %% 检查标题合法性
        true ->
            case check_content(Content) of  %% 检查长度合法性
                true ->
                    F = fun(Item) ->
                        case is_binary(Item) of
                            true ->     %% 二进制数据转换为字符串
                                binary_to_list(Item);
                            false ->    %% 无须转换
                                Item
                        end
                    end,
                    %%名字合法性检查
                    NewNameList = [F(Nick) || Nick <- NameList],
                    F2 = fun(Name) -> check_name(Name) end,
                    lists:partition(F2, NewNameList);
                false ->
                    {error, ?WRONG_CONTENT};       %% 内容长度非法
                error ->
                    {error, ?WRONG_CONTENT}
            end;
        false ->
            {error, ?WRONG_TITLE};     %% title长度非法
        error ->
            {error, ?WRONG_TITLE}
    end.


%% 检查邮件中是否存在未读邮件
%% @spec check_unread(UId) -> false | true
check_unread(UId) ->
    case db_agent_mail:check_mail_unread(UId) of
        [] ->
            false;
        _ ->
            true
    end.

%% 检查邮件中是否存在未读小师妹邮件
%% @spec check_unread(UId) -> false | true
check_assist_unread(UId) ->
    case db_agent_mail:check_mail_unread(UId) of
        [] ->
            false;
        List ->
            UnreadTypeList = [Type||[_Mid, Type, _State] <- List],
            lists:member(?MAIL_TYPE_ASSIST, UnreadTypeList)
    end.

%% 删除一封信件，退回附件
del_one_mail(Mail) ->
    [MailId, Type, _, _Timestamp, _BinSName, _UId, _, _, GoodsList, Coin, _Gold] = Mail,
    case Type of
        %%系统邮件，直接删除
        ?MAIL_TYPE_SYS      ->  
             db_agent_mail:del_mail(MailId);
        ?MAIL_TYPE_PERSONAL -> 
             case GoodsList =/= [] orelse Coin =/= 0 of
                 true  ->   %%私人信件有附件，需要退回附件
                     give_back_attachment(Mail);
                 false ->   %%无附件，直接删除
                     db_agent_mail:del_mail(MailId)
             end;
        %%小师妹的邮件，直接删除。
        ?MAIL_TYPE_ASSIST ->
            db_agent_mail:del_mail(MailId);
        ?MAIL_TYPE_REQUEST ->
            db_agent_mail:del_mail(MailId)
    end.

%退回附件, 用于私人邮件。
give_back_attachment(Mail) ->
    [MailId, _Type, _, Timestamp, SName, UId, _, _, GoodsList, Coin, Gold] = Mail,
    case lib_player:get_role_id_by_name(SName) of
        [] ->           %% 发件人角色不存在
            db_agent_mail:del_mail(MailId);   %% 删除信件，如果存在附件则丢弃
        [UId2] ->
            case lib_player:get_role_name_by_id(UId) of
               [] ->
                   Name = "对方";
               [Any] ->
                   Name = binary_to_list(Any);
               error ->
                   Name = "对方"
            end,
            Type2 = ?MAIL_TYPE_SYS,
            Timestamp2 = util:unixtime(),
            SName2 = "系统",
            Title2 = "退回附件",
            OldTime = calendar:now_to_local_time({Timestamp div 1000000, Timestamp rem 1000000, 0}),
            {{Year, Month, Day}, {Hour, Minute, Second}} = OldTime,
            Content2 = lists:concat([SName, "：\n    ", "您于", 
                                     Year, "-", Month, "-", Day, " ",
                                     Hour, ":", Minute, ":", Second,
                                     "发送的信件包含附件，", Name, "未提取您发送的附件，请于7天内取回附件!"]),
            db_agent_mail:insert_mail(Type2, Timestamp2, SName2, UId2, Title2, Content2, GoodsList, Coin, Gold),
            db_agent_mail:del_mail(MailId)  %%删除信件
    end.

%% 获得信件id进行信件时间检查
clean_old_mail() ->
    %% 获得所有信件的id
    case db_agent_mail:get_all_mail_ids() of
        [] ->
            ok;
        MailIdList ->
            lists:foreach(fun(Item) -> [MailId] = Item, clean_old_mail(MailId) end, MailIdList)
    end.

%% 根据信件Id对该信件进行期限检查
clean_old_mail(MailId) ->
    case db_agent_mail:get_mail_by_id(MailId) of
        [] ->
            ok;
        Mail when is_list(Mail)->
            [_MId, Type, _State, Timestamp, _SN, _Uid, _Title, _Content, _GList, _Coin, _Gold] = Mail,
            CurrTimestamp = util:unixtime(),            %% 当前时间戳
            TimeSpan = CurrTimestamp - Timestamp,       %% 时间差
            %% 系统信件20天(604800秒)到期
            case TimeSpan >= ?SYS_MAIL_KEEP * 86400 andalso
                 (Type =:= ?MAIL_TYPE_SYS orelse Type =:= ?MAIL_TYPE_ASSIST) of    
                true ->
                    del_one_mail(Mail);
                false ->
                    ok
            end
    end.

%% 提取附件
%% @spec get_attachment(PlayerStatus, MailId) -> 
%%  成功：    {ok, Status}
%%  部分成功  {error, Reason, Status}
get_attachment(PlayerStatus, MailId) ->
    case get_mail(MailId, PlayerStatus#player.id) of
        {ok, Mail} ->
            [_, Type, _, _, SName, Uid, _, _, GoodsList, Coin, Gold] = Mail,
            case GoodsList == [] andalso Coin == 0 andalso Gold == 0 of
                false ->            %% 有附件
                     Nowtime = util:unixtime(),
                     %%有钱币
                     NewStatus1 = if Coin =/= 0  ->
                         lib_goods:add_money(PlayerStatus, abs(Coin), coin, 1901);     %%修改money更新方式
                     true ->
                         PlayerStatus
                     end,
                     NewStatus = if Gold =/= 0 ->
                         lib_goods:add_money(NewStatus1, abs(Gold), gold, 1902);        %%修改money更新方式
                     true ->
                         NewStatus1
                     end,
                     %有物品
                     {RCode, RemainList} =
                     if GoodsList =/= [] ->
                         case handle_goods_recv(NewStatus, GoodsList, Type) of
                            {ok, []} -> 
                                db_agent_mail:update_mail_attachment(MailId, [], 0,0),
                                {ok, []};
                            {error, ErrorCode, GoodsListT} ->
                                db_agent_mail:update_mail_attachment(MailId, GoodsListT, 0,0),
                                {ErrorCode, GoodsListT}
                         end;
                     true ->
                         db_agent_mail:update_mail_attachment(MailId, [], 0,0),
                         {ok,[]}
                     end,
                     %%写log_mail
                     erlang:spawn(db_agent_mail, insert_mail_log, [Nowtime, SName, Uid, GoodsList--RemainList, Coin, Gold, 0]),
                     %%有钱币，无论物品是否成功都返回成功
                     case RCode of
                         ok ->
                             if Coin =/= 0 orelse Gold =/= 0 ->
                                 {ok, NewStatus};
                             true ->
                                 ok
                             end;
                         _ ->
                             if Coin =/= 0 orelse Gold =/= 0 ->
                                 {error, RCode, NewStatus};
                             true ->
                                 {error, RCode}
                             end 
                     end;
                true ->  %% 无附件
                    {error, ?ATTACH_NOT_EXIST}
            end;
        {error, _} ->
            {error, ?OTHER_ERROR}
    end.

%% 获取信件，限玩家接收的信件
%% @spec get_mail(MailId, PlayerId) -> {ok, Mail} | {error, ErrorCode}
get_mail(MailId, PlayerId) when is_integer(PlayerId)->
    case db_agent_mail:get_mail(MailId, PlayerId) of
        [] ->
            {error,2};        
        Mail ->
            [MailId, Type, State|_T] = Mail,
            %%检查是否是玩家的邮件
            case State == ?MAIL_STATE_NEW andalso Type =/= ?MAIL_TYPE_REQUEST of
                true ->
                    %% 更新信件状态为已读
                    db_agent_mail:update_mail_status(MailId, ?MAIL_STATE_READ),    
                    {ok, Mail};
                false ->
                    {ok, Mail}
            end
    end;

%% 获取信件, 玩家发送或接收到的都可以获取
%% @spec get_mail(MailId, PlayerId) -> {ok, Mail} | {error, ErrorCode}
get_mail(MailId, Status) when is_record(Status, player) ->
    case get_mail(MailId, Status#player.id) of
        {ok, Mail} -> {ok, Mail};
        %%查找是否是玩家发出的邮件
        {error, Reason} ->
           case db_agent_mail:get_mail_by_id(MailId) of
               [] ->
                   {error,2};        
               Mail ->
                   [MailId, Type, _State, _TimeS, SName, _Uid|_T] = Mail,
                   SendName = tool:to_list(SName),
                   %%检查是否是玩家发的邮件
                   case Type == ?MAIL_TYPE_REQUEST andalso SendName =:= Status#player.nick of
                       true ->
                           {ok, Mail};
                       false ->
                           {error, Reason}
                   end               
           end
    end.


%% 获取用户信件列表
%% @spec get_maillist(PlayerId) -> Maillist | db_error
get_maillist(UId) ->
    db_agent_mail:get_maillist(UId).

%% 分页获取用户所有信件，邮件类型和已读未读
%% 返回总长度及邮件列表{Len, MailList}
get_mail_page(MailList, MailTypeList, PageNo, PageSize) ->
    %根据类型过滤出信件（目前仅用助手系统）
    MailsF = lists:filter(
                fun(Mail) -> 
                   [_,Type|_Tail] = Mail,
                   lists:member(Type, MailTypeList)
                end,
                MailList),
    %%按未读在前状态排序，然后时间进行排序
    MailsSorted = lists:sort(
                fun(Mail1, Mail2) ->
                   [_Mid1, _Type1, State1, Timestamp1|_Tail1] = Mail1,
                   [_Mid2, _Type2, State2, Timestamp2|_Tail2] = Mail2,
                   case State1 =:= State2 of
                       true ->
                           Timestamp1 > Timestamp2;
                       false ->
                           State1 > State2
                   end
                end,
                MailsF),
    NumOfMail = length(MailsSorted),
    %%获取对应页码的信件页
    case PageNo >=1 andalso NumOfMail >= (PageNo-1)*PageSize of
        false ->
            {NumOfMail, []};
        true ->
            {NumOfMail, lists:sublist(MailsSorted, (PageNo-1)*PageSize+1, PageSize)}
    end.

%% 处理物品附件（提取附件时）,其中物品的刷新搬到人物的物品进程中操作
%% 系统邮件，只需要提供物品类型ID及数量，私人邮件，需要提供物品Id
%% @spec handle_goods_recv(PlayerStatus, GoodsList, Type) -> ok
%% 如果出错，返回未提取的物品列表： {error, ErrorCode, RemainGoodsList}
handle_goods_recv(_PlayerStatus, [], _Type) ->
    {ok, []};
handle_goods_recv(PlayerStatus, [{GoodsId, GoodsType, GoodsNum}|GoodsListT], Type) ->
    GoodsPid = PlayerStatus#player.other#player_other.pid_goods, 
    PlayerId = PlayerStatus#player.id,
    %%系统邮件或小师妹邮件可以发物品
    RCode = 
    case Type =:= ?MAIL_TYPE_SYS orelse Type =:= ?MAIL_TYPE_ASSIST of 
         true ->
             if GoodsType =/= 0 andalso GoodsNum > 0 ->
                 case gen_server:call(GoodsPid, {'give_goods', PlayerStatus, GoodsType, GoodsNum, 2}) of
                     ok ->
                         ok;
                     {_GoodsTypeId, not_found} ->
                         {error, ?GOODS_NOT_EXIST_2};
                     cell_num ->
                         {error, ?NOT_ENOUGH_SPACE};
                     _Error ->
                         {error, ?OTHER_ERROR}
                 end;
             true ->
                 {error, ?GOODS_NOT_EXIST_2}
             end;
         %%私人邮件或其他邮件，不用GoodsType(空头支票)
         false ->
             if GoodsId =/= 0 andalso GoodsNum > 0 ->
                %%这个有问题，暂时不会到这里来
                %%私人物品交换，使用
                case catch(gen_server:call(GoodsPid, {'give_goods_exsit', GoodsId, PlayerId})) of
                    {ok, _Res} ->
                        ok;
                    {error, Res} ->
                        {error, Res};
                    _Other ->
                        {error, ?OTHER_ERROR}
                end;
             true ->
                 {error, ?GOODS_NOT_EXIST_2}
             end
    end,
    case RCode of
        %%处理下一类物品
        ok -> 
            handle_goods_recv(PlayerStatus, GoodsListT, Type);
        %%出错了，返回未处理的物品及错误码
        %%如果背包满，那么GoodsNum不会分部分放进去背包
        {error, _Reason} -> 
            {error, _Reason, [{GoodsId, GoodsType, GoodsNum}|GoodsListT]}
    end.

%%玩家发送信件给小师妹。
%%标题默认填为 “回复：原标题”
send_mail_to_shimei(PlayerStatus, MailId, Content) ->
    PlayerId = PlayerStatus#player.id,
    %%检查长度，140微博?
    case check_length(Content, 140) of
        true ->
            case db_agent_mail:get_mail(MailId, PlayerId) of
                [MailId, _Type, _State, _TimeS, _SName, _Uid, Title, _Content, _GList, _Coin, _Gold] ->
                    Timestamp = util:unixtime(),
                    SName = tool:to_binary(PlayerStatus#player.nick),
                    Uid = 0,
                    NewTitle = "回复：" ++ tool:to_list(Title),
                    NewTitleBin = tool:to_binary(NewTitle),
                    ContentBin = tool:to_binary(Content),
                    db_agent_mail:insert_mail(?MAIL_TYPE_REQUEST, Timestamp, SName, Uid, NewTitleBin, ContentBin, [], 0, 0),
                    1;
                _ -> 
                    ?OTHER_ERROR
            end;
        _Other ->
            ?WRONG_CONTENT
    end.

   
%% 随机插入信件到数据库（测试用）
%% Start: 起始编号，N 结束编号
rand_insert_mail(UId, Start, N) ->
    {{Year, Month, Day}, {Hour, Minute, Second}} = erlang:localtime(),
    Content = "内容" ++ integer_to_list(Start) ++ ", " ++ integer_to_list(Year) ++ "-" ++ integer_to_list(Month) ++
        "-" ++ integer_to_list(Day) ++ ", " ++ integer_to_list(Hour) ++ ":" ++ integer_to_list(Minute)
        ++ ":" ++ integer_to_list(Second),
    Title = "标题" ++ integer_to_list(Start),
    Type = ?MAIL_TYPE_ASSIST,  %random:uniform(2),
    Timestamp = util:unixtime(),
    SName = integer_to_list(random:uniform(10000)),
    Coin = 0,
    Gold = 0,
    GoodsList = [],
    db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold),
    case N =< 1 of
        true ->
            ok;
        false ->
            timer:sleep(500),
            rand_insert_mail(UId, Start + 1, N - 1)
    end.



%%群发送系统信件
%% @spec send_sys_mail/8 -> {ok, InvalidList} | {error, Reason}
%%          InvalidList : 未发送的名单
%%          Reason      : 错误码（数字），对应含义见宏定义
send_sys_mail(NameList, Title, Content, GoodsList, Coin, Gold) ->
    Timestamp = util:unixtime(),
    case check_mail(NameList, Title, Content, GoodsList, Coin, Gold) of
        {error, Reason} ->
            {error, Reason};
        {ok, Name} ->
            case send_mail_to_one(Name, ?MAIL_TYPE_SYS, Timestamp, "系统", Title, Content, GoodsList, Coin, Gold) of
                {ok, _NewStatus} -> %% 发送成功
                    {ok, Bin} = pt_19:write(19005, 1),
                    lib_send:send_to_nick(Name, Bin),
                    {ok, []};
                ok -> %% 发送成功
                    {ok, Bin} = pt_19:write(19005, 1),
                    lib_send:send_to_nick(Name, Bin),
                    {ok, []};
                {error, Reason} ->
                    {erorr, Reason}
            end;
        {ValidNameList, InvalidNameList} ->
            case send_mail_to_some(ValidNameList, ?MAIL_TYPE_SYS, Timestamp, "系统", Title, Content, GoodsList, Coin, Gold) of
                {error, Reason} ->
                    {error, Reason};
                {_ValidList, OldInvalidList} ->
                    NewInvalidList = InvalidNameList ++ OldInvalidList,
                    {ok, NewInvalidList}
            end
    end.

%% 发送私人信件(无接收方通知)
%% @spec send_priv_mail/7 -> {ok, RName} | {error, ErrorCode} | {VList, IList}
%% @var     RName : 收件人名，VList : 发送成功名单， IList : 发送失败名单
send_priv_mail(NameList, Title, Content, _GoodsList, Coin, _PlayerStatus) ->
    Gold = 0,
    Timestamp = util:unixtime(),  
    GoodsList = [],
    case check_mail(NameList, Title, Content, GoodsList, Coin, Gold) of
        {error, Reason} ->
            {error, Reason};
        {ValidNameList, InvalidNameList} ->
            case send_mail_to_some(ValidNameList, ?MAIL_TYPE_SYS, Timestamp, "系统", Title, Content, GoodsList, Coin, Gold) of
                {error, Reason} ->
                    {error, Reason};
                {_ValidList, OldInvalidList} ->
                    NewInvalidList = InvalidNameList ++ OldInvalidList,
                    {ok, NewInvalidList}
            end
    end.


%% 发送信件给一个收件人
%% @spec send_mail_to_one/11 -> ok | {error, ErrorCode}
send_mail_to_one(RName, Type, Timestamp, SName, Title, Content, GoodsList, Coin, Gold) ->
    case lib_player:get_role_id_by_name(RName) of
        []->
            {error, ?WRONG_NAME};
        UId when is_integer(UId) ->
            case Type of
                ?MAIL_TYPE_SYS ->
                    db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold),
                    ok;
                ?MAIL_TYPE_ASSIST ->
                    db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold),
                    ok;                    
                ?MAIL_TYPE_PERSONAL ->
                    case check_mail_full(UId) of
                        true ->
                            {error, ?MAIL_FULL};
                        _ ->            
                            db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold),
                            ok
                    end
            end;
        _ ->
            {error, ?OTHER_ERROR}
    end.

%% 发送信件给多个收件人
%% @spec send_mail_to_some/11 -> {error, ErrorCode} | {VList, IList}
%%      VList : 信件已正确发送的收件人列表
%%      IList : 未正确发送的收件人列表
send_mail_to_some(NameList, Type, Timestamp, SName, Title, Content, GoodsList, Coin, Gold) ->
    F = fun(RName) ->
        case lib_player:get_role_id_by_name(RName) of
            [] ->
                false;
             UId when is_integer(UId) ->
                case Type of
                    ?MAIL_TYPE_SYS ->     %% 系统信件可群发金钱附件
                        db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold),
                        true;
                    ?MAIL_TYPE_ASSIST ->
                        db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, GoodsList, Coin, Gold),
                        true;
                    ?MAIL_TYPE_PERSONAL ->
                        case check_mail_full(UId) of
                            true ->
                                false;
                            _ ->
                                if GoodsList == [] andalso Gold == 0 andalso Coin == 0 ->
                                    db_agent_mail:insert_mail(Type, Timestamp, SName, UId, Title, Content, [], 0, 0);
                                    true;
                                true ->   %% 有物品，群发不支持发送物品
                                    false
                                end
                        end;
                    _ ->
                        false
                end;
            _  ->
                false
        end
    end,
    lists:partition(F, NameList).

%% 通知玩家有新邮件
notify_new_mail(MailId) ->
    case db_agent_mail:get_mail_by_id(MailId) of
        [] ->
            ok;
        Mail when is_list(Mail) ->
            [MailId, Type, State, _Timestamp, _SName, Uid, _Title, _Content, _GList, _Coin, _Gold] = Mail,
            %%只有为小师妹邮件并且为未读状态时才操作
            if Type == ?MAIL_TYPE_ASSIST andalso State =:= ?MAIL_STATE_NEW ->
                 %%玩家是否在线, 在线时才通知
                 case lib_player:get_player_pid(Uid) of
                     Pid when is_pid(Pid) ->
                         gen_server:cast(Pid, refresh_mail);
                     _ ->
                         skip
                 end;
            true ->
               skip
            end
    end.
