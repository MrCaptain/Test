%%%------------------------------------
%%% @Module     : pp_mail
%%% @Author     : csj
%%% @Created    : 2010.10.05
%%% @Description: 信件操作/助手系统
%%%------------------------------------
-module(pp_mail).
-export([handle/3, handle_cmd/3, pack_and_send/3]).
-include("common.hrl").
-include("record.hrl"). 
-include("debug_trace.hrl").

%% API Functions
handle(Cmd, Player, Data) ->
    ?TRACE("pp_mail: Cmd:~p, Player:~p, Data:~p~n", [Cmd, Player#player.id, Data]),
    %%屏蔽旧的邮件协议
    AllowCmdList = [19010, 19011, 19050, 19051, 19052, 19053, 19054],
    case lists:member(Cmd, AllowCmdList) of
        true  -> handle_cmd(Cmd, Player, Data);
        false -> skip
    end.

%%---------------------------------------------
%% 旧版邮件协议 1900x
%%---------------------------------------------
%% 客户端发信
handle_cmd(19001, PlayerStatus, Data) ->
    Timestamp = util:unixtime(),
    Last_send = get(send_mail_time),
    Could_send =
        case Last_send  of
            undefined ->
                ok;
            Val when Timestamp - Val > 4 ->
                ok;
            _ ->
                error
        end,
    case Could_send of
        ok ->
            put(send_mail_time, Timestamp),
            [RName, Title, Content, GoodsList, Coin] = Data,
            %%检查物品有效性及
            F = fun({GoodsId, GoodsNum}, GList) ->
                if GoodsNum >= 1 ->
                    case db_agent_mail:get_mail_goods_type_id(GoodsId) of
                         [PlayerId, GoodsTypeId] ->
                            if PlayerId =:= PlayerStatus#player.id ->
                                [{GoodsId, GoodsTypeId, GoodsNum}|GList];
                            true ->
                                GList
                            end;
                         _ ->
                             GList
                    end;
                true ->
                    GList
                end
            end,
            ValidGoodsList = lists:foldr(F, [], GoodsList),
            CheckGList = [{GId, GNum}||{GId, _GTypeId, GNum} <-ValidGoodsList],
            CheckResult = GoodsList -- CheckGList,
            Title_ver = lib_words_ver:words_ver(Title),
            Content_ver = lib_words_ver:words_ver(Content),
            if
                Title_ver =:= false ->
                    {ok, BinData} = pt_19:write(19001, [2]),
                    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                    ok;
                Content_ver =:= false ->
                    {ok, BinData} = pt_19:write(19001, [3]),
                    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                    ok;
                CheckResult =:= [] ->
                    {ok, BinData} = pt_19:write(19001, [9]),
                    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                    ok;
                true ->
                    case lib_mail:send_mail_to_one(RName, 2, Timestamp, PlayerStatus#player.nick, Title, Content, ValidGoodsList, Coin, 0) of
                        {ok, NewStatus} ->
                            {ok, Bin} = pt_19:write(19005, 1),                %% 通知收件人有未读邮件
                            lib_send:send_to_nick(RName, Bin),
                            {ok, BinData} = pt_19:write(19001, [1]),          %% 发送成功
                            lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                            {ok, NewStatus};
                        {error, Reason} ->
                            put(send_mail_time, Last_send),
                            {ok, BinData} = pt_19:write(19001, [Reason]),
                            lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                            ok;
                        _ ->
                            ok
                    end
            end;
        _ ->
            {ok, BinData} = pt_19:write(19001, [13]),
            lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
            ok
    end;

%% 获取信件
handle_cmd(19002, _PlayerStatus, _MailId) ->
    ok;

%% 删除信件
handle_cmd(19003, PlayerStatus, Data) ->
    IdList = Data,
    case lib_mail:del_mail(IdList, PlayerStatus#player.id) of
        ok ->
            {ok, BinData} = pt_19:write(19003, 1);
        _ ->
            {ok, BinData} = pt_19:write(19003, 0)
    end,
    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);

%% 获取信件列表及内容
handle_cmd(19004, PlayerStatus, [Mail_type, Mail_page_p]) ->
    Mail_page =
        if 
            Mail_page_p > 10 ->
                10;
            Mail_page_p < 1 ->
                1;
            true ->
                Mail_page_p
        end,
    Mail_list = db_agent:get_maillist_all(PlayerStatus#player.id),
    Mail_count = length(Mail_list),
    case Mail_count of
        0 ->
            {ok, BinData} = pt_19:write(19004, [0, 0, Mail_page, []]);
        _ ->
            {Mail_current, Mails} = lib_mail:get_mail_page(Mail_list, [Mail_type], Mail_page, 4),
            {ok, BinData} = pt_19:write(19004, [1, Mail_current, Mail_page, Mails])
    end,
    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);

%% 查询有无未读邮件
handle_cmd(19005, PlayerStatus, check_unread) ->
    case lib_mail:check_unread(PlayerStatus#player.id) of
        true ->
            {ok, BinData} = pt_19:write(19005, 1),
            lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);  %% 有未读邮件
        false ->
            ok   %% 无未读邮件
    end;

%% 提取附件
handle_cmd(19006, PlayerStatus, Data) ->
    MailId = Data,
    Timestamp = util:unixtime(),
    Last_get = get(get_mail_time),
    Could_get =
        case Last_get of
            undefined ->
                ok;
            {Last_MailId, Last_time} when Last_MailId =:= MailId andalso Timestamp - Last_time < 6 ->
                error;
            _ ->
                ok
        end,
    case Could_get of
        ok ->
            case lib_mail:get_attachment(PlayerStatus, MailId) of
                {ok, Status} ->
                    %timer:sleep(5),    %% Erlang模拟客户端测试需要
                    put(get_mail_time, {MailId, Timestamp}),
                    {ok, BinData} = pt_19:write(19006, [1, MailId]),
                    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
                    lib_player:send_player_attribute2(Status, 19006),
                    {ok, Status};        %% 提取附件成功，附件中有铜钱或者元宝
                ok ->
                    put(get_mail_time, {MailId, Timestamp}),
                    {ok, BinData} = pt_19:write(19006, [1, MailId]),
                    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                    ok;            %% 提取附件成功  
                {error, RCode, Status} -> 
                    put(get_mail_time, {MailId, Timestamp}),
                    {ok, BinData} = pt_19:write(19006, [RCode, MailId]),
                    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
                    lib_player:send_player_attribute2(Status, 19006),
                    {ok, Status};        %% 提取附件成功，附件中有铜钱或者元宝                    
                {error, ErrorCode} ->
                    put(get_mail_time, Last_get),
                    {ok, BinData} = pt_19:write(19006, [ErrorCode, MailId]),
                    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
                    ok
            end;
        _ ->
            ok
    end;

%%---------------------------------------------
%% 玩家反馈到GM 1901x
%%---------------------------------------------
%% 处理玩家反馈信息
handle_cmd(19010, PlayerStatus, Data) ->
    [Type, Content] = Data,
%%     [Type, Title, Content] = Data,
    PlayerId = PlayerStatus#player.id,
    PlayerName = PlayerStatus#player.nick,
    {ok, {Address, _Port}} = inet:peername(PlayerStatus#player.other#player_other.socket),   %% 获得对方IP地址
    Title = "" ,
    Result = lib_mail:feedback(Type, Title, Content, Address, PlayerId, PlayerName),
    {ok, BinData} = pt_19:write(19010, Result),
    lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData);

%% 查询反馈信息
handle_cmd(19011, Status, []) ->
    PlayerId = Status#player.id,
    Result = lib_mail:get_feedback_list(PlayerId),
    {ok, BinData} = pt_19:write(19011, Result),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData) ;


%%---------------------------------------------
%% 小师妹系统协议（助手系统）1905x
%%---------------------------------------------
%% 小师妹系统:是否有未读邮件
handle_cmd(19050, Status, _) ->
    State = case lib_mail:check_assist_unread(Status#player.id) of
        true  -> 1;
        false -> 0
    end,
    pack_and_send(Status, 19050, [1, State]);

%协议号：19051  获取小师妹 邮件列表数据
handle_cmd(19051, Status, [PageNo]) ->
    %%接收到的邮件
    AllMyRecvMail = lib_mail:get_maillist(Status#player.id),
    %%发送的邮件
    %AllMySendMail = lib_mail:get_maillist(Status#player.nick),
    %AllMyMail = AllMyRecvMail ++ AllMySendMail,
    %%[3，10]取小师妹信及玩家发给小师妹的信件。
    %%每页邮件为4封
    {MailNum, Mail} = lib_mail:get_mail_page(AllMyRecvMail, [3, 10], PageNo, 4),
    pack_and_send(Status, 19051, [1, PageNo, util:ceil(MailNum/4), Mail]);

%协议号：19052  获取小师妹邮件具体内容
handle_cmd(19052, Status, [MailId]) ->
    case lib_mail:get_mail(MailId, Status) of
        {ok, Mail} ->
            [MailId, _Type, _State, _Timestamp, SName, _Uid, Title, Content, GoodsList, _Coin, _Gold] = Mail,
            pack_and_send(Status, 19052, [1, MailId, SName, Title, Content, GoodsList]);
        {error, _} ->
            pack_and_send(Status, 19052, [0, MailId, [], [], [], []])
    end;

%协议号：19053 回信, 发信给小师妹
handle_cmd(19053, Status, [MailId, Content]) ->
    Timestamp = util:unixtime(),
    Last_send = get(send_mail_time),
    Could_send = case Last_send  of
                    undefined ->
                        ok;
                    Val when Timestamp - Val > 4 ->
                        ok;
                    _ ->
                        error
                 end,
    Result = case Could_send of
                ok ->
                    put(send_mail_time, Timestamp),
                    case lib_words_ver:words_ver(Content) of
                        false ->
                            3;   %%内容错误
                        _ ->
                            lib_mail:send_mail_to_shimei(Status, MailId, Content)
                    end;
                error ->
                    0
            end,
    pack_and_send(Status, 19053, [Result]);

%协议号：19054 收取附件
handle_cmd(19054, Status, [MailId]) ->
    case lib_mail:get_attachment(Status, MailId) of
        ok ->  %成功, 有物品
            pack_and_send(Status, 19054, [1]);
        {ok, NewStatus} -> %成功，只有钱币
            pack_and_send(Status, 19054, [1]),
            lib_player:send_player_attribute2(NewStatus, 19054),
            {ok, NewStatus};
        {error, RCode, NewStatus} -> %物品部分成功, 钱币已收
            pack_and_send(Status, 19054, [RCode]),
            lib_player:send_player_attribute2(NewStatus, 19054),
            {ok, NewStatus};
        {error, RCode} -> %物品领取失败或其他错误（钱币是不会失败的）
            pack_and_send(Status, 19054, [RCode])
    end;

handle_cmd(_, _, _) ->
    {error, "pp_mail no match"}.

pack_and_send(Player, Cmd, Data) ->
    %?TRACE("pp_mail:pack_and_send Cmd:~p, Player:~p, Data:~p~n", [Cmd, Player#player.id, Data]),
    {ok, BinData} = pt_19:write(Cmd, Data),
    lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData).
