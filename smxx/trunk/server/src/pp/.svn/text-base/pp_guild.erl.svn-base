%%%--------------------------------------
%%% @Module  : pp_guild
%%% @Author  : water
%%% @Created : 2013.02.22
%%% @Description: 协议接口  
%%%--------------------------------------
-module(pp_guild).

-include("common.hrl").
-include("record.hrl").
-include("guild.hrl").
-include("debug.hrl").

-compile([export_all]).

%%帮派列表分页
-define(PAGE_SIZE, 5).

%% API Functions
handle(Cmd, Status, Data) ->
    ?TRACE("pp_guild: Cmd: ~p, Id: ~p, Data:~p~n", [Cmd, Status#player.id, Data]),
    handle_cmd(Cmd, Status, Data).

%%--------------------------------------
%%Protocol: 40001 查询帮派(分页待定)
%%--------------------------------------
handle_cmd(40001, Status, [PageNo]) ->
    GuildList = lib_guild:get_all_guild(),
    if GuildList =:= [] ->
           pack_and_send(Status, 40001, [0,0,[]]);
       true ->
           TotalPage = util:ceil(length(GuildList)/?PAGE_SIZE),
           Page = min(max(1,PageNo), TotalPage),
           Start = (Page -1) * ?PAGE_SIZE + 1,
           Length = min(Page * ?PAGE_SIZE, length(GuildList)) - Start + 1,
           F = fun(Guild) ->
               MaxNum = data_guild:get_max_num(),
               [Guild#guild.id, Guild#guild.name, Guild#guild.current_num, MaxNum, Guild#guild.level, Guild#guild.chief_id, Guild#guild.chief_name]
           end,
           %%按人数排序吧,人少放在前,这样可以减少看到满人的帮派,以便加帮派.平衡帮派人数
           GList = lists:keysort(#guild.current_num, GuildList), %%按人数排吧,　人少放前,　
           GuildInfoList = lists:map(F, lists:sublist(GList, Start, Length)),
           pack_and_send(Status, 40001, [Page, TotalPage, GuildInfoList])
    end;

%%--------------------------------------
%%Protocol: 40002 创建帮派
%%--------------------------------------
handle_cmd(40002, Status, [Name, Announce]) ->
    case guild_util:create_guild(Status, Name, Announce) of
        {true, Status1} ->
            pack_and_send(Status1, 40002, [?GUILD_OK]),
            lib_player:update_guild(Status1),
            {ok, Status1};
        {false, Reason} ->
            pack_and_send(Status, 40002, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40003 申请加入帮派
%%--------------------------------------
handle_cmd(40003, Status, [GuildId]) ->
    case guild_util:apply_join_guild(Status, GuildId) of
        true ->
            pack_and_send(Status, 40003, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40003, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40004 退出所在帮派
%%--------------------------------------
handle_cmd(40004, Status, _) ->
    case guild_util:quit_guild(Status) of
        {true, Status1} ->
            pack_and_send(Status1, 40004, [?GUILD_OK]),
            lib_player:update_guild(Status1),
            {ok, Status1};
        {false, Reason} ->
            pack_and_send(Status, 40004, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40005 查询帮派成员
%%--------------------------------------
handle_cmd(40005, Status, [_GuildId]) ->
    if Status#player.guild_id =:= 0 ->
           pack_and_send(Status, 40005, [?GUILD_NOT_IN_GUILD]);
       true ->
           MemberList = db_agent_guild:load_member_by_guild_id(Status#player.guild_id),
           F = fun(Member) ->
                case lib_player:is_online(Member#guild_member.uid) of
                    true -> Online = 1;
                    _    -> Online = 0
                end,
                [Member#guild_member.uid, Member#guild_member.nick, Member#guild_member.level, Member#guild_member.career, Member#guild_member.gender, 
                 Member#guild_member.position, Member#guild_member.devo, Member#guild_member.last_login_time, Online]
           end,
           MemberInfoList = lists:map(F, MemberList),
           pack_and_send(Status, 40005, [1, MemberInfoList])
    end;
  
%%--------------------------------------
%%Protocol: 40006 发起弹劾
%%--------------------------------------
handle_cmd(40006, Status, _) ->
    case guild_util:accuse_chief(Status) of
        true ->
            pack_and_send(Status, 40006, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40006, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40007 弹劾操作
%%--------------------------------------
handle_cmd(40007, Status, [Ops]) ->
    case guild_util:accuse_vote(Status, Ops) of
        true ->
            pack_and_send(Status, 40007, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40007, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40008 获取弹劾信息
%%--------------------------------------
handle_cmd(40008, Status, _) ->
    {ok, skip};

%%--------------------------------------
%%Protocol: 40009 帮派日志
%%--------------------------------------
handle_cmd(40009, Status, _) ->
    {ok, skip};

%%--------------------------------------
%%Protocol: 40030 邀请玩家加入帮派(帮主/副帮主/长老)
%%--------------------------------------
handle_cmd(40030, Status, [PlayerId]) ->
   {ok, skip};

%%--------------------------------------
%%Protocol: 40031 帮派申请列表(帮主/副帮主)
%%--------------------------------------
handle_cmd(40031, Status, _) ->
    if Status#player.guild_id =:= 0 ->
           pack_and_send(Status, 40031, []);
       Status#player.guild_post =/= ?GUILD_CHIEF andalso 
       Status#player.guild_post =/= ?GUILD_ASSIST_CHIEF ->
           pack_and_send(Status, 40031, []);
       true ->
           ApplyList = lib_guild:get_apply_by_guild_id(Status#player.guild_id),
           F = fun(Apply) ->
                [Apply#guild_apply.uid, Apply#guild_apply.nick, Apply#guild_apply.level, Apply#guild_apply.career,
                 Apply#guild_apply.gender, Apply#guild_apply.force, Apply#guild_apply.timestamp]
           end,
           ApplyInfoList = lists:map(F, ApplyList),
           pack_and_send(Status, 40031, [ApplyInfoList])
    end;

%%--------------------------------------
%%Protocol: 40032 通过或拒绝加入申请(帮主/副帮主)
%%--------------------------------------
handle_cmd(40032, Status, [Uid,Ops]) ->
    case guild_util:handle_apply(Status, Uid, Ops) of
        true ->
            pack_and_send(Status, 40032, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40032, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40033 提升职务(帮主)
%%--------------------------------------
handle_cmd(40033, Status, [Uid,NewPos]) ->
    case guild_util:promote_member(Status, Uid, NewPos) of
        true ->
            pack_and_send(Status, 40033, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40033, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40034 解散帮派(帮主)
%%--------------------------------------
handle_cmd(40034, Status, _) ->
   case guild_util:disband_guild(Status) of
        {true, Status1} ->
            pack_and_send(Status1, 40034, [?GUILD_OK]),
            lib_player:update_guild(Status1),
            {ok, Status1};
        {false, Reason} ->
            pack_and_send(Status, 40034, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40035 踢出成员(帮主/副帮主)
%%--------------------------------------
handle_cmd(40035, Status, [PlayerId]) ->
    case guild_util:kickout_member(Status, PlayerId) of
        true ->
            pack_and_send(Status, 40035, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40035, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40036 帮派升级(帮主/副帮主/长老)
%%--------------------------------------
handle_cmd(40036, Status, _) ->
    case guild_util:upgrade_guild(Status) of
        true ->
            pack_and_send(Status, 40036, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40036, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40037 帮主让位
%%--------------------------------------
handle_cmd(40037, Status, [Uid]) ->
    case guild_util:demise_chief(Status, Uid) of
        {true, Status1} ->
            pack_and_send(Status1, 40037, [?GUILD_OK]),
            lib_player:update_guild(Status1),
            {ok, Status1};
        {false, Reason} ->
            pack_and_send(Status, 40037, [Reason])
    end;

%%--------------------------------------
%%Protocol: 40039 帮派公告设置
%%--------------------------------------
handle_cmd(40039, Status, [Content]) ->
    case guild_util:modify_annouce(Status, Content) of
        true ->
            pack_and_send(Status, 40039, [?GUILD_OK]);
        {false, Reason} ->
            pack_and_send(Status, 40039, [Reason])
    end;

handle_cmd(Cmd, Status, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Status:~p, Data:~p~n", [Cmd, Status, Data]),
    {ok, pp_guild_error}.

pack_and_send(Status, Cmd, Data) ->
    ?TRACE("pp_guild send: Cmd: ~p, Id: ~p, Data:~p~n", [Cmd, Status#player.id, Data]),
    {ok, BinData} = pt_40:write(Cmd, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

