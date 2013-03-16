%%------------------------------------
%% @Module  : guild_util
%% @Author  : water
%% @Created : 2013.02.22
%% @Description: 帮派处理 
%%------------------------------------
-module(guild_util).
-include("common.hrl").
-include("record.hrl").
-include("guild.hrl").
-compile(export_all).

%%------------------NOTICE--------------------------
%%此文件对应玩家帮派相应的操作.在玩家进程执行
%%--------------------------------------------------
%%玩家登录时操作
role_login(Status) ->
    case db_agent_guild:load_member_by_role_id(Status#player.id) of
        [] ->  %%帮派解散了
            Status#player{guild_id = 0, guild_name = "", guild_post = 0};
        Mem ->
            NewMem = Mem#guild_member{level = Status#player.level},
            ets:insert(?ETS_GUILD_MEMBER, NewMem),
            Status#player{guild_id = Mem#guild_member.guild_id,
                          guild_name = Mem#guild_member.name,
                          guild_post = Mem#guild_member.position}
    end.

%%玩家退出登录操作
role_logout(Status) ->
    if Status#player.guild_id =/= 0 ->
        ets:delete(?ETS_GUILD_MEMBER, Status#player.id);
    true ->
        skip
    end.
    
%%创建
create_guild(Status, GuildName, GuildNotice) ->    
    CreateCoin = data_guild:get_guild_config(create_coin),            %%获取创建所需铜钱
    CreateLevel = data_guild:get_guild_config(require_level),         %%建帮派所需铜钱
    SenWordsCheck = lib_words_ver:validate_name(GuildName, special),  %%检查敏感词
    WordsLenCheck = lib_words_ver:validate_name(GuildName, [2, 12]),  %%长度
    if 
        Status#player.guild_id =/= 0 -> 
            {false, ?GUILD_ALREAD_IN_GUILD};   
        Status#player.level < CreateLevel ->
            {false, ?GUILD_LEVEL_NOT_ENOUGH};
        CreateCoin > Status#player.coin -> 
            {false, ?GUILD_COIN_NOT_ENOUGH};
        SenWordsCheck =:= false orelse WordsLenCheck =:= false ->
            {false, ?GUILD_NAME_INVALID};
        true ->
            case lib_guild:is_guild_exist(GuildName) of
                true ->
                    {false, ?GUILD_NAME_EXIST};
                false ->
                    ForceAtt = 0,  %lib_player:force_att(Status),
                    NewGuildNotice = lib_words_ver:words_filter(GuildNotice),
                    case catch gen_server:call(mod_guild:get_guild_pid(), 
                                    {apply_call, lib_guild, create_guild,  [Status#player.id,
                                                                            Status#player.level,
                                                                            Status#player.nick, 
                                                                            Status#player.last_login_time,
                                                                            Status#player.gender, 
                                                                            Status#player.career,
                                                                            ForceAtt,
                                                                            GuildName,
                                                                            NewGuildNotice
                                                                           ]}) of
                        {true, GuildId} ->
                            Status1 = Status#player{guild_id = GuildId, guild_post = ?GUILD_CHIEF, guild_name = GuildName},
                            Status2 = lib_player:cost_coin(Status1, CreateCoin),
                            {true, Status2};
                        {false, Reason} ->
                            {false, Reason};
                        _Other -> 
                            {false, ?GUILD_ERROR}
                   end
            end
    end.

%%申请加入帮派, 不需要帮派进程处理
apply_join_guild(Status, GuildId) ->
   ApplyList = lib_guild:get_apply_by_role_id(Status#player.id),
   MaxApply = data_guild:get_guild_config(apply_max),
   if 
        Status#player.guild_id =/= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_ALREAD_IN_GUILD};  
        length(ApplyList) >= MaxApply ->
            {false, ?GUILD_MAX_APPLY};
        true ->
            Guild = lib_guild:get_guild(GuildId),
            MaxNum = data_guild:get_max_num(),
            Apply2List = lib_guild:get_apply_by_guild_id(GuildId),
            MaxGuildApply = data_guild:get_guild_config(guild_apply_max),
            if Guild =:= [] ->
                   {false, ?GUILD_NOT_EXIST};
               Guild#guild.current_num >= MaxNum ->  %%最大人数已满
                   {false, ?GUILD_MEMBER_FULL};
               length(Apply2List) >= MaxGuildApply ->
                   {false, ?GUILD_APPLY_FULL};
               true ->
                   ForceAtt = 0,  %lib_player:force_att(Status),
                   lib_guild:apply_join_guild(GuildId, Status#player.id,
                                                       Status#player.level,
                                                       Status#player.nick,
                                                       Status#player.gender,
                                                       Status#player.career,
                                                       ForceAtt),
                   %%副帮主在线
                   GuildMember = lib_guild:get_assist_chief(GuildId),
                   NoticeUidList = if GuildMember =/= [] ->
                        [AssistUid|_T] = GuildMember,
                        [Guild#guild.chief_id, AssistUid];
                   true -> 
                        [Guild#guild.chief_id]
                   end,
                   lib_guild:notice_new_apply(NoticeUidList),
                   true
            end
    end.

%% 撤销加入帮派申请
apply_cancel_join(Status, GuildId) ->
    if Status#player.guild_id =/= 0 ->
            {false, ?GUILD_ALREAD_IN_GUILD};  
       true ->
            case catch gen_server:call(mod_guild:get_guild_pid(GuildId), 
                            {apply_call, lib_guild, apply_cancel_join, [GuildId, Status#player.id]}) of
                 true ->
                     true;
                 {false, Reason} ->
                     {false, Reason};
                 _Other ->
                     {false, ?GUILD_ERROR}
            end
    end.

%%退出所在帮派
quit_guild(Status) ->
    if Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
           {false, ?GUILD_NOT_IN_GUILD};  
       Status#player.guild_post =:= ?GUILD_CHIEF -> %%检查是否帮主, 帮主是不能退的
           {false, ?GUILD_PERMISSION_DENY};
       true ->
           case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                          {apply_call, lib_guild, quit_guild, [Status#player.guild_id, Status#player.id, Status#player.guild_post]}) of
               true ->
                   {true, Status#player{guild_id = 0, guild_post = 0, guild_name = ""}};
               {false, Reason} ->
                   {false, Reason};
               _Other ->
                   {false, ?GUILD_ERROR}
           end
    end.
    
%%发起弹劾
accuse_chief(Status) ->
    if Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
           {false, ?GUILD_NOT_IN_GUILD};  
       Status#player.guild_post =/= ?GUILD_CHIEF -> %%检查是否帮主
           {false, ?GUILD_PERMISSION_DENY};
       true ->
           case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                          {apply_call, lib_guild, accuse_chief, [Status#player.guild_id, Status#player.id]}) of
               true ->
                   true;
               {false, Reason} ->
                   {false, Reason};
               _Other ->
                   {false, ?GUILD_ERROR}
           end
    end.

%弹劾操作
accuse_vote(Status, Operation) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF -> %%被弹劾对象, 艰难的选择不用做
            {false, ?GUILD_PERMISSION_DENY};
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, accuse_chief, [Status#player.guild_id, Status#player.id, Operation]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.

%%通过或拒绝加入申请(帮主/副帮主)
handle_apply(Status, Uid, Ops) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF andalso 
        Status#player.guild_post =/= ?GUILD_ASSIST_CHIEF -> %%只有帮主或副帮主才能操作
            {false, ?GUILD_PERMISSION_DENY};
        Ops =:= 1 ->  %%同意
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, approve_join, [Status#player.guild_id, Uid]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end;
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, reject_join, [Status#player.guild_id, Uid]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.

%%提升职务(帮主)
promote_member(Status, Uid, NewPos) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF ->
            {false, ?GUILD_PERMISSION_DENY};
        NewPos =:= ?GUILD_ASSIST_CHIEF andalso NewPos =:= ?GUILD_ELITE ->
            {false, ?GUILD_WRONG_STATE};
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, promote_member, [Status#player.guild_id, Uid, NewPos]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.

%%解散帮派(帮主)
disband_guild(Status) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF ->
            {false, ?GUILD_PERMISSION_DENY};
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, disband_guild, [Status#player.guild_id]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.

%%踢出成员(帮主/副帮主)
kickout_member(Status, PlayerId) ->
  if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF andalso 
        Status#player.guild_post =/= ?GUILD_ASSIST_CHIEF -> %%只有帮主或副帮主才能操作
            {false, ?GUILD_PERMISSION_DENY};
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, kickout_member, [Status#player.guild_id, PlayerId]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.

%%帮派升级(帮主/副帮主/长老)
upgrade_guild(Status) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF andalso 
        Status#player.guild_post =/= ?GUILD_ASSIST_CHIEF andalso 
        Status#player.guild_post =/= ?GUILD_ELITE -> %%只有帮主或副帮主或长老
            {false, ?GUILD_PERMISSION_DENY};
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, upgrade_guild, [Status#player.guild_id]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.
  
%%帮主让位
demise_chief(Status, Uid) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF ->
            {false, ?GUILD_PERMISSION_DENY};
        true ->
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, demise, [Status#player.guild_id, Uid]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.

%%帮派公告设置
modify_annouce(Status, Announce) ->
    if 
        Status#player.guild_id =:= 0 ->  %%检查是否进了帮会
            {false, ?GUILD_NOT_IN_GUILD};  
        Status#player.guild_post =/= ?GUILD_CHIEF andalso 
        Status#player.guild_post =/= ?GUILD_ASSIST_CHIEF andalso 
        Status#player.guild_post =/= ?GUILD_ELITE -> %%只有帮主或副帮主或长老
            {false, ?GUILD_PERMISSION_DENY};
        true ->
            NewAnnounce = lib_words_ver:words_filter(Announce),
            case catch gen_server:call(mod_guild:get_guild_pid(Status#player.guild_id),
                           {apply_call, lib_guild, modify_annouce, [Status#player.guild_id, NewAnnounce]}) of
                true ->
                    true;
                {false, Reason} ->
                    {false, Reason};
                _Other ->
                    {false, ?GUILD_ERROR}
            end
    end.
