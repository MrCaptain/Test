%%--------------------------------------
%% @Module  : lib_guild
%% @Author  : 
%% @Created : 
%% @Description : 帮派业务处理实现
%%--------------------------------------
-module(lib_guild).

-include("common.hrl").
-include("record.hrl").
-include("guild.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-compile(export_all).

%% API Functions
%------------------------------------------
%-帮派操作
%------------------------------------------
%%加载所有帮派到ETS
load_all_guild() ->
    GuildList = db_agent_guild:load_all_guild(),
    lists:foreach(fun(Guild) -> 
                        ets:insert(?ETS_GUILD, Guild),
                        load_all_apply(Guild#guild.id)  %%加载帮派申请
                  end, GuildList).

%%加载所有帮派申请到ETS
load_all_apply(GuildId) ->
    ApplyList = db_agent_guild:load_guild_apply(GuildId),
    db_agent_guild:delete_apply_by_guild_id(GuildId),   %%申请只放在ETS中,　停服才写数据库
    lists:foreach(fun(Apply) -> ets:insert(?ETS_GUILD_APPLY, Apply) end, ApplyList).

%%创建帮派
create_guild(PlayerId, Level, PlayerName, LastLoginTime, Gender, Career, ForceAtt, GuildName, GuildNotice) ->
    NewGuildName = tool:to_binary(GuildName),
    NewGuildNotice = tool:to_binary(GuildNotice),
    Now = util:unixtime(),
    Guild = #guild{
                    id = 0,                                 %% 帮派编号    
                    name = NewGuildName,                    %% 帮派名称    
                    chief_id = PlayerId,                    %% 帮主角色    
                    chief_name = PlayerName,                %% 帮主名字    
                    announce = NewGuildNotice,              %% 帮派公告    
                    level = 1,                              %% 帮派等级    
                    current_num = 1,                        %% 当前人数    
                    create_time = Now                       %% 创建时间    
                 },
    case catch db_agent_guild:insert_guild(Guild) of
        NewGuild when is_record(NewGuild, guild) ->
            ets:insert(?ETS_GUILD, NewGuild),              %%加到ETS表
            GuildMember = #guild_member{    
                                uid = PlayerId,                         %% 角色ID    
                                guild_id = NewGuild#guild.id,           %% 帮派ID    
                                name = GuildName,                       %% 帮派名称    
                                nick = PlayerName,                      %% 角色昵称    
                                gender = Gender,                        %% 性别    
                                career = Career,                        %% 职业    
                                level = Level,                          %% 玩家等级    
                                force = ForceAtt,                       %% 玩家战斗力    
                                position = 1,                           %% 1帮主 2副帮主 3元老 中间预留 10-帮众(最低)    
                                last_login_time = LastLoginTime,        %% 上次登录时间    
                                sklist = []                             %% 技能列表[{IdLevel}],    
                          },
            db_agent_guild:insert_member(GuildMember),
            ets:insert(?ETS_GUILD_MEMBER, GuildMember),
            {true, NewGuild#guild.id};
        _Other ->
            {false, ?GUILD_ERROR}
    end.

%%加入帮派
%%这里只做有限必要的检查, 调用函数需要检查玩家是否重复加入等条件
join_guild(GuildId, PlayerId, Level, PlayerName, LastLoginTime, Gender, Career, ForceAtt) ->
    Guild = get_guild(GuildId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       true ->
           NewGuild = Guild#guild{current_num = Guild#guild.current_num + 1},
           ets:insert(?ETS_GUILD, NewGuild),              %%加到ETS表
           GuildMember = #guild_member{    
                               uid = PlayerId,                         %% 角色ID    
                               guild_id = NewGuild#guild.id,           %% 帮派ID    
                               name = NewGuild#guild.name,             %% 帮派名称    
                               nick = PlayerName,                      %% 角色昵称    
                               gender = Gender,                        %% 性别    
                               career = Career,                        %% 职业    
                               level = Level,                          %% 玩家等级    
                               force = ForceAtt,                       %% 玩家战斗力    
                               position = 10,                          %% 1帮主 2副帮主 3元老 中间预留 10-帮众(最低)    
                               last_login_time = LastLoginTime,        %% 上次登录时间    
                               sklist = []                             %% 技能列表[{IdLevel}],    
                         },
           ets:insert(?ETS_GUILD_MEMBER, GuildMember),   %%如果玩家不在线,是否不加ETS好一点?
           db_agent_guild:insert_member(GuildMember),
           db_agent_guild:update_guild_cur_num(NewGuild#guild.id, NewGuild#guild.current_num),
           {true, NewGuild#guild.id}
    end.

%%申请加入帮派, 直接加, 不需要帮派进程处理
apply_join_guild(GuildId, PlayerId, Level, Name, Gender, Career, ForceAtt) ->
    Now = util:unixtime(),
    Apply = #guild_apply{uid = PlayerId, 
                         guild_id = GuildId,
                         level = Level,
                         nick = Name,
                         gender = Gender,
                         career = Career,
                         force = ForceAtt,
                         timestamp = Now
                        },
    ets:insert(?ETS_GUILD_APPLY, Apply),
    true.

%%撤销加入帮派申请
cancel_join_apply(GuildId, PlayerId) ->
    delete_apply(GuildId, PlayerId),
    true.

%%退出所在帮派
quit_guild(GuildId, PlayerId, Position) ->
    Guild = get_guild(GuildId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       true ->
           if Position =:= ?GUILD_ELITE ->
                  NewGuild = Guild#guild{current_num = Guild#guild.current_num - 1,
                                         elite_num = Guild#guild.current_num - 1};
              true ->
                  NewGuild = Guild#guild{current_num = Guild#guild.current_num - 1}
           end,
           ets:insert(?ETS_GUILD, NewGuild), 
           db_agent_guild:delete_member_by_role_id(PlayerId),
           db_agent_guild:update_guild_num(NewGuild#guild.id, NewGuild#guild.current_num, NewGuild#guild.elite_num),
           ets:delete(?ETS_GUILD_MEMBER, PlayerId), 
           true
    end.

%%发起弹劾
accuse_chief(GuildId, PlayerId) ->
    Guild = get_guild(GuildId),
    GuildMember = get_guild_member(PlayerId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       GuildMember =:= [] ->
           {false, ?GUILD_NOT_IN_GUILD};
       Guild#guild.state =/= 0 ->
           {false, ?GUILD_IN_WAR_ACCUSE};
       true ->
           ExpireTime = util:unixtime() + data_guild:get_guild_config(accuse_time),
           NewGuild = Guild#guild{state = 1,
                                  accuse_id = PlayerId,
                                  accuse_time = ExpireTime,
                                  against = 0, 
                                  agree = 1     %%发起弹劾者总是同意的吧
                                 },
           ets:insert(?ETS_GUILD, NewGuild),
           NewGuildMember = GuildMember#guild_member{vote = 1, accuse_time = ExpireTime},
           ets:insert(?ETS_GUILD_MEMBER, NewGuildMember),
           db_agent_guild:update_guild_accuse(GuildId, PlayerId, ExpireTime, 0, 1),
           db_agent_guild:update_member_vote(PlayerId, 1, ExpireTime),
           true
    end.

%%弹劾投票操作
accuse_vote(GuildId, PlayerId, Operation) ->
    Guild = get_guild(GuildId),
    GuildMember = get_guild_member(PlayerId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       GuildMember =:= [] ->
           {false, ?GUILD_NOT_IN_GUILD};
       Guild#guild.state =:= 0 ->   %%不是弹劾状态
           {false, ?GUILD_WRONG_STATE};
       GuildMember#guild_member.accuse_time =:= Guild#guild.accuse_time -> %%已经投过票了
           {false, ?GUILD_ALREADY_VOTE};
       true ->
           if Operation =:= 1 -> %%同意
                  NewGuild = Guild#guild{agree = Guild#guild.agree + 1};
              true ->
                  NewGuild = Guild#guild{against = Guild#guild.against + 1}
           end,
           ets:insert(?ETS_GUILD, NewGuild),
           NewGuildMember = GuildMember#guild_member{vote = Operation, accuse_time = NewGuild#guild.accuse_time},
           ets:insert(?ETS_GUILD_MEMBER, NewGuildMember),
           db_agent_guild:update_guild_vote(GuildId, NewGuild#guild.agree, NewGuild#guild.against),
           db_agent_guild:update_member_vote(PlayerId, Operation, NewGuild#guild.accuse_time),
           true
    end.

%%获取弹劾信息

%%帮派日志

%%邀请玩家加入帮派(帮主/副帮主/长老)

%%帮派申请列表(帮主/副帮主)

%%通过或拒绝加入申请(帮主/副帮主)(服务主进程)
approve_join(GuildId, PlayerId) ->
    Guild = get_guild(GuildId),
    GuildApply = get_guild_apply(GuildId, PlayerId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       GuildApply =:= [] ->
           {false, ?GUILD_APPLY_NOT_EXIST};
       true ->
           delete_apply_by_role_id(PlayerId),  %%删除玩家的所有申请
           [Apply|_] = GuildApply,
           NewGuild = Guild#guild{current_num = Guild#guild.current_num + 1},
           ets:insert(?ETS_GUILD, NewGuild),
           GuildMember = #guild_member{    
                                 uid = PlayerId,                          
                                 guild_id = NewGuild#guild.id,      
                                 name = NewGuild#guild.name,                        
                                 nick = Apply#guild_apply.nick,      
                                 gender = Apply#guild_apply.gender,  
                                 career = Apply#guild_apply.career,  
                                 level = Apply#guild_apply.level, 
                                 force = Apply#guild_apply.force,
                                 position = 10,          %%从帮众做起
                                 last_login_time = 0,    %%等登录再说          
                                 sklist = []                          
                           },
           ets:insert(?ETS_GUILD_MEMBER, GuildMember),
           db_agent_guild:insert_member(GuildMember),
           db_agent_guild:update_guild_cur_num(NewGuild#guild.id, NewGuild#guild.current_num),
           spawn(fun() -> notice_approve(PlayerId, GuildId, NewGuild#guild.name, 10) end),
           spawn(fun() -> broadcast_new_member(GuildId, 
                                               PlayerId,
                                               Apply#guild_apply.nick, 
                                               Apply#guild_apply.level,
                                               Apply#guild_apply.career,
                                               Apply#guild_apply.gender)
                 end),
           true
     end.

%%通过或拒绝加入申请(帮主/副帮主)
reject_join(GuildId, PlayerId) ->
    Guild = get_guild(GuildId),
    delete_apply(GuildId, PlayerId),
    spawn(fun() -> notice_reject(PlayerId, GuildId, Guild#guild.name) end),
    true.

%%提升职务(帮主)
%%提升为副帮主
promote_member(GuildId, PlayerId, ?GUILD_ASSIST_CHIEF) ->
    Guild = get_guild(GuildId),
    GuildAssistChief = get_assist_chief(GuildId),
    GuildMember = get_guild_member(PlayerId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       GuildAssistChief =/= [] ->
           {false, ?GUILD_POS_EMPTY};
       GuildMember =:= [] ->
           {false, ?GUILD_INVALID_PLAYER};
       GuildMember#guild_member.guild_id =/= GuildId ->
           {false, ?GUILD_NOT_SAME_GUILD};
       GuildMember#guild_member.position =/= ?GUILD_NORMAL andalso
       GuildMember#guild_member.position =/= ?GUILD_ELITE ->
           {false, ?GUILD_WRONG_POSITION};
       true ->
           if GuildMember#guild_member.position =:= ?GUILD_ELITE ->
                  NewGuild = Guild#guild{elite_num = Guild#guild.elite_num - 1},
                  ets:insert(?ETS_GUILD, NewGuild),
                  db_agent_guild:update_elite_num(NewGuild#guild.id, NewGuild#guild.elite_num);
              true ->
                  skip
           end,
           NewGuildMember = GuildMember#guild_member{position = ?GUILD_ASSIST_CHIEF},
           ets:insert(?ETS_GUILD_MEMBER, NewGuildMember),
           db_agent_guild:update_member_position(PlayerId, ?GUILD_ASSIST_CHIEF),
           spawn(fun() -> notice_promote(PlayerId, ?GUILD_ASSIST_CHIEF) end),
           spawn(fun() -> broadcast_promotion(GuildId, 
                                              PlayerId,
                                              GuildMember#guild_member.nick,
                                              GuildMember#guild_member.position,
                                              ?GUILD_ASSIST_CHIEF) end),
           true
    end;

%%提升为长老
promote_member(GuildId, PlayerId, ?GUILD_ELITE) ->
    Guild = get_guild(GuildId),
    GuildMember = get_guild_member(PlayerId),
    MaxElite = data_guild:get_guild_config(elite),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       GuildMember =:= [] ->
           {false, ?GUILD_INVALID_PLAYER};
       Guild#guild.elite_num >= MaxElite ->
           {false, ?GUILD_POS_EMPTY};
       GuildMember#guild_member.position =/= ?GUILD_NORMAL ->
           {false, ?GUILD_POS_EMPTY};
       true ->
           NewGuild = Guild#guild{elite_num = Guild#guild.elite_num + 1},
           ets:insert(?ETS_GUILD, NewGuild),
           NewGuildMember = GuildMember#guild_member{position = ?GUILD_ELITE},
           ets:insert(?ETS_GUILD_MEMBER, NewGuildMember),
           db_agent_guild:update_guild_elite_num(NewGuild#guild.id, NewGuild#guild.elite_num),
           db_agent_guild:update_member_position(PlayerId, ?GUILD_ELITE),
           spawn(fun() -> notice_promote(PlayerId, ?GUILD_ELITE) end),
           spawn(fun() -> broadcast_promotion(GuildId, 
                                              PlayerId,
                                              GuildMember#guild_member.nick,
                                              GuildMember#guild_member.position,
                                              ?GUILD_ELITE) end),

           true
    end;
promote_member(_GuildId, _PlayerId, _) ->
    {false, ?GUILD_POS_EMPTY}.

%%解散帮派(帮主)
disband_guild(GuildId) ->
    Guild = get_guild(GuildId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       Guild#guild.state =/= 0 ->
           {false, ?GUILD_WRONG_STATE};
       true ->
           ets:delete(?ETS_GUILD, GuildId), 
           MemberList = get_member_by_guild_id(GuildId), 
           spawn(fun() ->
                    lists:foreach(fun(Member) -> 
                                      ets:delete(?ETS_GUILD_MEMBER, Member#guild_member.uid),
                                      notice_disband(Member#guild_member.uid, Member#guild_member.guild_id, Member#guild_member.name)
                                   end,
                                   MemberList)
                  end),
           db_agent_guild:delete_apply_by_guild_id(GuildId),
           db_agent_guild:delete_guild(GuildId),
           db_agent_guild:delete_member_by_guild_id(GuildId),
           {true, GuildId}
    end.

%%踢出成员(帮主/副帮主)
kickout_member(GuildId, PlayerId) ->
    Guild = get_guild(GuildId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       true ->
           NewGuild = Guild#guild{current_num = Guild#guild.current_num - 1},
           ets:insert(?ETS_GUILD, NewGuild), 
           ets:delete(?ETS_GUILD_MEMBER, PlayerId),
           db_agent_guild:update_guild_cur_num(NewGuild#guild.id, NewGuild#guild.current_num),
           db_agent_guild:delete_member_by_role_id(PlayerId),
           spawn(fun() -> notice_kickout(PlayerId, Guild#guild.id, Guild#guild.name) end),
           true
    end.

%%帮派升级(帮主/副帮主/长老)
upgrade_guild(GuildId) ->
    Guild = get_guild(GuildId),
    Cost = data_guild:get_upgrade_cost(Guild#guild.level),
    MaxLevel = data_guild:get_guild_config(max_level),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       Guild#guild.level >= MaxLevel  ->
           {false, ?GUILD_MAX_LEVEL};
       Guild#guild.fund >= Cost ->
           {false, ?GUILD_MONEY_NOT_ENOUGH};
       true ->
           NewGuild = Guild#guild{level = Guild#guild.level + 1, fund = Guild#guild.fund - Cost},
           ets:insert(?ETS_GUILD, NewGuild),
           db_agent_guild:update_guild_level(GuildId, NewGuild#guild.level, NewGuild#guild.fund), 
           spawn(fun() -> broadcast_upgrade(GuildId, Guild#guild.level, NewGuild#guild.level) end),
           true
    end.

%%帮主让位
demise_chief(GuildId, PlayerId) ->
    Guild = get_guild(GuildId),
    GuildMember = get_guild_member(PlayerId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       GuildMember =:= [] ->
           {false, ?GUILD_INVALID_PLAYER};
       GuildMember#guild_member.guild_id =:= GuildId ->
           {false, ?GUILD_NOT_SAME_GUILD};
       true ->
           NewGuild = Guild#guild{chief_id = PlayerId, chief_name = GuildMember#guild_member.nick},
           ets:insert(?ETS_GUILD, NewGuild),
           NewGuildMember = GuildMember#guild_member{position = ?GUILD_CHIEF},
           ets:insert(?ETS_GUILD_MEMBER, NewGuildMember),
           db_agent_guild:update_guild_chief(GuildId, PlayerId, GuildMember#guild_member.nick),
           db_agent_guild:update_position(PlayerId, ?GUILD_CHIEF),
           spawn(fun() -> broadcast_demise(GuildId, Guild#guild.chief_id, Guild#guild.chief_name, PlayerId, GuildMember#guild_member.nick) end),
           true
    end.

%%帮派公告设置
modify_annouce(GuildId, Announce) ->
    Guild = get_guild(GuildId),
    if Guild =:= [] ->
           {false, ?GUILD_NOT_EXIST};
       true ->
           NewGuild = Guild#guild{announce = Announce},   
           ets:insert(?ETS_GUILD, NewGuild),
           db_agent_guild:update_guild_announce(GuildId, Announce),
           spawn(fun() -> broadcast_new_announce(GuildId, Announce) end),
           true
    end.

%------------------------------------------
%-通知/帮派内广播操作
%------------------------------------------
%%帮派新增成员信息(广播)
broadcast_new_member(GuildId, PlayerId, PlayerName, Level, Career, Gender) ->
    {ok, BinData} = pt_40:write(40070, [PlayerId, PlayerName, Level, Career, Gender]),
    lib_send:send_to_assigned_guild(GuildId, BinData).
   
%职位变化通告(广播)
broadcast_promotion(GuildId, PlayerId, PlayerName, OldPos, NewPos) ->
     {ok, BinData} = pt_40:write(40073, [PlayerId, PlayerName, OldPos, NewPos]),
     lib_send:send_to_assigned_guild(GuildId, BinData).

%帮主让位通知(广播)
broadcast_demise(GuildId, GChiefId, GChiefName, NewGChiefId, NewGChiefName) ->
     {ok, BinData} = pt_40:write(40074, [GChiefId, GChiefName, NewGChiefId, NewGChiefName]),
     lib_send:send_to_assigned_guild(GuildId, BinData).

%帮派升级通知(广播) 
broadcast_upgrade(GuildId, OldLevel, NewLevel) ->
     {ok, BinData} = pt_40:write(40075, [OldLevel, NewLevel]),
     lib_send:send_to_assigned_guild(GuildId, BinData).

%新帮派公告 
broadcast_new_announce(GuildId, Announce) ->
     {ok, BinData} = pt_40:write(40077, [Announce]),
     lib_send:send_to_assigned_guild(GuildId, BinData).

%%提升职位
notice_promote(PlayerId, Position) ->
    case lib_player:get_player_pid(PlayerId) of
        []  ->  %%不在线
            skip;
        Pid ->  %%在线
            gen_server:cast(Pid, {guild_post, Position})
    end.

%申请通过
notice_approve(PlayerId, GuildId, GuildName, Postion) ->
    case lib_player:get_player_pid(PlayerId) of
        []  ->  %%不在线
            skip;
        Pid ->  %%在线
            gen_server:cast(Pid, {join_guild, GuildId, GuildName, Postion})
    end.

%被踢通知(接收玩家)
notice_kickout(PlayerId, GuildId, GuildName) ->
    case lib_player:get_player_pid(PlayerId) of
        []  ->  %%不在线
            skip;
        Pid ->  %%在线
            {ok, BinData} = pt_40:write(40071, [GuildId, GuildName]),
            gen_server:cast(Pid, {send_to_sid, BinData}),
            gen_server:cast(Pid, {quit_guild})
    end.

%帮派邀请
notice_invite(PlayerId, InviterId, InviterName, GuildId, CurrentNum, GuildLevel, GuildName, GChiefId, GChiefName) ->
    {ok, BinData} = pt_40:write(40072, [InviterId, InviterName, GuildId, CurrentNum, GuildLevel, GuildName, GChiefId, GChiefName]),
    lib_send:send_to_assigned_guild(GuildId, BinData).

%拒绝申请通知(仅玩家)
notice_reject(PlayerId, GuildId, GuildName) ->
    {ok, BinData} = pt_40:write(40076, [GuildId, GuildName]),
    lib_send:send_to_uid(PlayerId, BinData).

%%解散帮派通知
notice_disband(PlayerId, GuildId, GuildName) ->
    case lib_player:get_player_pid(PlayerId) of
        []  ->  %%不在线
            skip;
        Pid ->  %%在线
            gen_server:cast(Pid, {quit_guild})
    end.

%%新帮派申请通知
notice_new_apply(UidList) ->
    F = fun(Uid) ->
        case lib_player:get_player_pid(Uid) of
            []  ->  %%不在线
                skip;
            Pid ->  %%在线
                gen_server:cast(Pid, {new_guild_apply})
        end
    end,
    lists:foreach(F, UidList).

%------------------------------------------
%-内部操作
%------------------------------------------
%%获取帮派记录
get_guild(GuildId) ->
   case ets:lookup(?ETS_GUILD, GuildId) of
       [] -> [];
       [R] -> R
   end.

%%所有帮派列表
get_all_guild() ->
   ets:tab2list(?ETS_GUILD).

%%获取帮派成员记录
get_guild_member(PlayerId) ->
   case ets:lookup(?ETS_GUILD_MEMBER, PlayerId) of
       [] -> [];
       [R] -> R
   end.

%%获取帮派成员列表(在线)
get_member_by_guild_id(GuildId) ->
 	MS = ets:fun2ms(fun(T) when T#guild_member.guild_id =:= GuildId ->   
                        T
					end),
    ets:select(?ETS_GUILD_MEMBER, MS).

%%获取帮派副帮主成员记录
get_assist_chief(GuildId) ->
 	MS = ets:fun2ms(fun(T) when T#guild_member.guild_id =:= GuildId andalso T#guild_member.position =:= ?GUILD_ASSIST_CHIEF ->   
                        T
					end),
    ets:select(?ETS_GUILD_APPLY, MS).

%%根据帮派ID获取申请
get_apply_by_guild_id(GuildId) ->
 	MS = ets:fun2ms(fun(T) when T#guild_apply.guild_id =:= GuildId ->   
                        T
					end),
    ets:select(?ETS_GUILD_APPLY, MS).

%%根据玩家ID获取申请
get_apply_by_role_id(PlayerId) ->
 	MS = ets:fun2ms(fun(T) when T#guild_apply.uid =:= PlayerId ->   
                        T
					end),
    ets:select(?ETS_GUILD_APPLY, MS).

%%获取申请
get_guild_apply(GuildId, PlayerId) ->
 	MS = ets:fun2ms(fun(T) when T#guild_apply.uid =:= PlayerId andalso
                                T#guild_apply.guild_id =:= GuildId ->   
                        T
					end),
    ets:select(?ETS_GUILD_APPLY, MS).

delete_apply_by_role_id(PlayerId) ->
    Pattern = #guild_apply{uid = PlayerId, _ = '_'},
    ets:match_delete(?ETS_GUILD_APPLY, Pattern).

delete_apply_by_guild_id(GuildId) ->
    Pattern = #guild_apply{guild_id = GuildId, _ = '_'},
    ets:match_delete(?ETS_GUILD_APPLY, Pattern).

delete_apply(GuildId, PlayerId) ->
    Pattern = #guild_apply{uid = PlayerId, guild_id = GuildId, _ = '_'},
    ets:match_delete(?ETS_GUILD_APPLY, Pattern).

%%检测指定帮派名是否已存在
is_guild_exist(GuildName) ->
   case db_agent_guild:is_guild_name_exist(GuildName) of
        []     -> false;
        _Other -> true
    end.

