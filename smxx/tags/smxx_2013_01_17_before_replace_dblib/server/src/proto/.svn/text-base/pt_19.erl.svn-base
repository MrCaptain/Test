%%------------------------------------
%%% @Module     : pt_19
%%% @Author     : csj
%%% @Created    : 2010.10.05
%%% @Description: 信件, 反馈，小师妹系统
%%%------------------------------------
-module(pt_19).

-include("common.hrl").
-include("record.hrl").

-export([read/2, write/2]).

%%
%%客户端 -> 服务端 ----------------------------
%%
%%---------------------------------------------
%% 旧版邮件协议
%%---------------------------------------------
%% 玩家发送信件(可带附件，Gold, Coin, Goods)
read(19001, Bin) ->
    {RName, Bin2} =    pt:read_string(Bin),
    {Title, ContentBin} = pt:read_string(Bin2),
    {Content, Rest2} =    pt:read_string(ContentBin),
    <<GLen:16, GoodListBin/binary>> = Rest2,
    F_GList = fun(_Idx, {RestBin, ResultList}) ->
        <<GoodsId:32, Num:8, NewRestBin/binary>> = RestBin,
        {NewRestBin, [{GoodsId, Num}|ResultList]}
    end,
    {Rest3, GoodsList} = lists:foldl(F_GList, {GoodListBin, []}, lists:seq(1,GLen)),
    case Rest3 of
        <<Gold:32, Coin:32>> ->
            {ok, [RName, Title, Content, lists:reverse(GoodsList), Gold, Coin]};
        _ ->
            {error, no_match}
   end;

%% 获取信件
read(19002, Bin) ->
    case Bin of
        <<Id:32>> ->
            {ok, Id};
        _ ->
            {error, no_match}
    end;

%% 删除信件 返回删除信件ID列表
read(19003, Bin) -> 
    <<N:16, Bin2/binary>> = Bin,
    case get_list([], Bin2, N) of
        {error, _}->
            {error, no_match};
        {ok, IdList, _RestBin} ->
            {ok, IdList}
    end;

%% 获取信件列表
read(19004, <<Mail_type:8, Mail_page:8>>) ->
    {ok, [Mail_type, Mail_page]};

%% 查询有无未读邮件
read(19005, _) ->
    {ok, []};

%% 提取附件
read(19006, <<MailId:32>>) ->
    {ok, MailId};

%%---------------------------------------------
%% 玩家反馈到GM
%%---------------------------------------------
%% 玩家反馈
read(19010, <<Type:8, Bin/binary>>) ->
    case pt:read_string(Bin) of
        {[], <<>>} ->
            {error, no_match};
        {Content,_} ->
            {ok, [Type, Content]}
    end;

%% 玩家获取问题列表
read(19011, _R) ->
    {ok, []} ;

%% 玩家获取问题列表int32 ID  string 内容
read(19013, <<ID:32, Bin/binary>>) ->
    case pt:read_string(Bin) of
        {[], <<>>} ->
            {error, no_match};
        {Content,_} ->
            {ok, [ID, Content]}
    end;

%%---------------------------------------------
%% 小师妹系统协议（助手系统）
%%---------------------------------------------
%协议号: 19050  是否有未读邮件
read(19050, _) ->
     {ok, []};

%协议号：19051  邮件列表数据
read(19051, <<PageNo:16, _Bin/binary>>) ->
    {ok, [PageNo]};

%协议号：19052  邮件具体内容
read(19052, <<MailId:32, _Bin/binary>>) ->
    {ok, [MailId]};

%协议号：19053 回信给小师妹
read(19053, Bin) ->
    <<MailId:32, ContentBin/binary>> = Bin,
    {Content,_} = pt:read_string(ContentBin),
    {ok, [MailId, Content]};

%协议号：19054 收取附件物品
read(19054,  <<MailId:32, _Bin/binary>>) ->
    {ok, [MailId]};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%
%%---------------------------------------------
%% 旧版邮件协议
%%---------------------------------------------
%% 回应客户端发信
write(19001, [Result]) ->
    {ok, pt:pack(19001, <<Result:8>>)};

%% 获取信件
%% write(19002, [Result | RestData]) ->
%%     case Result of
%%         2 ->
%%             MailId = RestData,
%%             {ok, pt:pack(19002, <<2:16, % 结果，成功-1 / 无该信件-2 / 读取信件失败-3
%%                     MailId:32,      % int:32 信件id
%%                     0:16,           % int:32 时间戳（不成功为空）
%%                     0:16, "",       % string 发件人（不成功为空）
%%                     0:16, "",       % string 信件标题（不成功为空）
%%                     0:16, "",       % string 信件内容（不成功为空）
%%                     0:32,           % int:32 物品类型ID（无则为0）
%%                     0:32,           % int:32 铜钱数
%%                     0:32>>)};       % int:32 元宝数
%%         3 ->
%%             MailId = RestData,
%%             {ok, pt:pack(19002, <<3:16, MailId:32, 0:16, 0:16, "", 0:16, "", 0:16, "", 0:32, 0:32, 0:32>>)};
%%         1 ->
%%             case RestData of
%%                 [MailId, _, _, Timestamp, SName, _, Title, Content, GoodsId, GoodsNum, Coin, Gold] ->
%%                     case lib_mail:get_goods_type_id(GoodsId) of
%%                         [] ->
%%                             GoodsTypeId = 0;
%%                         [GoodsTypeId] ->
%%                             ok;
%%                         _ ->
%%                             GoodsTypeId = 0
%%                     end,
%%                     Len1 = byte_size(SName),
%%                     Len2 = byte_size(Title),
%%                     Len3 = byte_size(Content),
%%                     {ok, pt:pack(19002, <<1:16, MailId:32, Timestamp:32, Len1:16, SName/binary, Len2:16, Title/binary, Len3:16, Content/binary, GoodsTypeId:32, GoodsNum:32, Coin:32, Gold:32>>)};
%%                 _ ->
%%                     {error, no_match}
%%             end;
%%         _ ->
%%             {error, no_match}
%%     end;

%% 删除信件
write(19003, Result) ->
    {ok, pt:pack(19003, <<Result:16>>)};

%% 信件列表
write(19004, [Result, Mail_num, Mail_page, Maillist]) ->
    case Result of
        1 ->
            F_Mail = fun(Mail) ->
                [Id, Type, State, Timestamp, SName, _RName, Title, Content, GoodsList, Coin, Gold] = Mail,
                Len1 = byte_size(SName),
                Len2 = byte_size(Title),
                Len3 = byte_size(Content),
                F_Goods = fun({_GoodsId, GoodsTypeId, GoodsNum}) ->
                    <<GoodsTypeId:32, GoodsNum:8>>
                end,
                GLen = length(GoodsList),
                GoodsBin = tool:to_binary([F_Goods(Goods) || Goods <- GoodsList]),
                <<Id:32, Type:8, State:8, Timestamp:32, Len1:16, SName/binary, Len2:16, Title/binary, Len3:16, Content/binary, GLen:16, GoodsBin/binary, Gold:32, Coin:32>>
            end,
            MailNum = length(Maillist),
            BinList = tool:to_binary([F_Mail(Mail) || Mail <- Maillist]),
            {ok, pt:pack(19004, <<1:8, Mail_num:8, Mail_page:8, MailNum:16, BinList/binary>>)};
        _ ->
            {ok, pt:pack(19004, <<0:8, 0:8, Mail_page:8, 0:16>>)}
    end;


%% 新信件通知
%% Result 0-无未读邮件, 1-有未读邮件, 2-查询失败
write(19005, Result) ->
    {ok, pt:pack(19005, <<Result:16>>)};

%% 提取附件
write(19006, [Result, MailId]) ->
    {ok, pt:pack(19006, <<Result:16, MailId:32>>)};

%%---------------------------------------------
%% 玩家反馈到GM
%%---------------------------------------------
%% 玩家反馈
write(19010, Result) ->
    {ok, pt:pack(19010, <<Result:8>>)};

%% 获取反馈列表
write(19011, Result) ->
    case Result of
        [] ->
            BinData = <<0:16,<<>>/binary>> ;
        _ ->
            FBLen = length(Result) ,
            F1 = fun(FBData) ->
                {FBId,FBType,Repalied,ReplyList} = FBData,
                RLen = length(ReplyList),
                case ReplyList of
                    [] ->
                        ReplyBin = [<<>>];
                    _  ->
                        F2 = fun(X) ->
                            {RName,RCont,DateTime} = X,
                            RNameBin = tool:to_binary(RName),
                            RNBinLen = byte_size(RNameBin),
                            RContBin = tool:to_binary(RCont),
                            RCBinLen = byte_size(RContBin),
                            <<RNBinLen:16,RNameBin/binary,RCBinLen:16,RContBin/binary,DateTime:32>> 
                        end,
                        ReplyBin = tool:to_binary([F2(X) || X <- ReplyList])
                end,
                RelayRecord = tool:to_binary(ReplyBin) ,
                <<FBId:32,FBType:8,Repalied:8,RLen:16,RelayRecord/binary>> 
        end,            
        BinDataTmp = lists:map(F1,Result) ,
        BinDataRcd = tool:to_binary(BinDataTmp) ,
        BinData = <<FBLen:16,BinDataRcd/binary>> 
    end,
    {ok,pt:pack(19011, <<BinData/binary>>)} ;

%% 玩家反馈
write(19013, Result) ->
    {ok, pt:pack(19013, <<Result:16>>)};

%%---------------------------------------------
%% 小师妹系统协议（助手系统）
%%---------------------------------------------
%协议号：19050  是否有未读邮件
write(19050, [Result, State]) ->
    {ok, pt:pack(19050, <<Result:8, State:8>>)};

%协议号：19051  邮件列表数据
write(19051, [Result, PageNo, MaxNo, MailList]) ->
    F = fun(Mail) ->
           [MailId, Type, State, TimeStamp, SName, _Uid, Title, _Content, _GList, _Coin, _Gold] = Mail,
           SNameBin = tool:to_binary(SName),
           SNameLen = byte_size(SNameBin),
           TitleBin = tool:to_binary(Title),
           TitleLen = byte_size(TitleBin),
           %%状态过滤：小师妹邮件，并且为未读，状态才为未读
           SState = case State =:= 2 andalso Type =:= 3 of
               false -> 0;
               true  -> 1
           end,
           <<MailId:32, SState:8, SNameLen:16, SNameBin/binary, TitleLen:16, TitleBin/binary, TimeStamp:32>>
    end,
    MailBin = tool:to_binary(lists:map(F, MailList)),
    MailLen = length(MailList),
    {ok, pt:pack(19051, <<Result:8, PageNo:16, MaxNo:16, MailLen:16, MailBin/binary>>)};

%协议号：19052  邮件具体内容
write(19052, [Result, MailId, SName, Title, Content, Attachment]) ->
    SNameBin = tool:to_binary(SName),
    SNameLen = byte_size(SNameBin),
    TitleBin = tool:to_binary(Title),
    TitleLen = byte_size(TitleBin),
    ContentBin = tool:to_binary(Content),
    ContentLen = byte_size(ContentBin),
    MailBin = <<MailId:32, SNameLen:16, SNameBin/binary, TitleLen:16, TitleBin/binary, ContentLen:16, ContentBin/binary>>,
    F = fun({_GoodsId, GoodsType, GoodsNum}) ->
        <<GoodsType:32, GoodsNum:32>>
    end,
    AttachBin = tool:to_binary(lists:map(F, Attachment)),
    AttachLen = length(Attachment),
    {ok, pt:pack(19052, <<Result:8, MailBin/binary, AttachLen:16, AttachBin/binary>>)};

%协议号：19053 回信
write(19053, [Result]) ->
    {ok, pt:pack(19053, <<Result:8>>)};

%协议号：19054 收取附件 Int:8 结果码（0失败 1成功 2背包满)
write(19054, [Result]) ->
    {ok, pt:pack(19054, <<Result:8>>)};

write(Cmd, _R) ->
    ?ERROR_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%% 获取列表（读取信件id列表）
%% 列表每项为int32
get_list(AccList, _Bin, 0) ->
    {ok, AccList, _Bin};
get_list(AccList, Bin, N) when N > 0 ->
    case Bin of
        <<Item:32, Bin2/binary>> ->
            NewList = [Item | AccList],
            get_list(NewList, Bin2, N-1);
        _ ->
            {error, []}
    end.
