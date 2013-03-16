%%-----------------------------------
%% @Module  	: lib_chat
%% @Author  	: water
%% @Created 	: 2013.02.05
%% @Description: 聊天  
%%-----------------------------------
-module(lib_chat).

-compile(export_all).
-include("common.hrl").
-include("record.hrl").

%------------------------------------------
%Protocol: 11000 信息
%------------------------------------------
%s >> c:
% 	int:64   Uid      发送方用户id
% 	string   Name     发送方名称
% 	int:8    Type     消息类型: 1.世界、2.场景、3.联盟 4:私聊
% 	string   Content  内容 
%end
%------------------------------------------
%Protocol: 11010 系统信息/广播
%------------------------------------------
%s >> c:
% 	int:8    Type     消息类型: 1.系统、2.系统广播
% 	string   Content  内容 
%end

%% 处理世界聊天
chat_world(Status, Msg) -> 
    Data = [Status#player.id, Status#player.nick, 1, Msg],
    {ok, BinData} = pt_11:write(11000, Data),
    lib_send:send_to_all(BinData).

%% 处理场景聊天
chat_scene(Status, Msg) ->
    Data = [Status#player.id, Status#player.nick, 2, Msg],
    {ok, BinData} = pt_11:write(11000, Data),
    lib_send:send_to_local_scene(Status#player.scene, BinData).

%% 处理帮派聊天
chat_guild(Status, Msg) ->
    Data = [Status#player.id, Status#player.nick, 3, Msg],
    {ok, BinData} = pt_11:write(11000, Data),
    lib_send:send_to_assigned_guild(Status#player.guild_id, BinData).

%%处理私聊   
chat_private(Status, Uid, Msg) ->
    case lib_player:get_player_pid(Uid) of
        Pid when is_pid(Pid) ->
            Data = [Status#player.id, Status#player.nick, 4, Msg],
            {ok, BinData} = pt_11:write(11000, Data),
            gen_server:cast(Pid, {send_to_sid, BinData}),
            true;
        _Ohter ->
            false
    end.
        
%%发送系统信息给某个玩家
%%成功: true, 不在线 false
send_sys_msg_one(Uid, Msg) ->
     case lib_player:get_player_pid(Uid) of
          Pid when is_pid(Pid) ->
              Data = [1, Msg],
              {ok, BinData} = pt_11:write(11010, Data),
              gen_server:cast(Pid, {send_to_sid, BinData}),
              true;
          _Ohter ->
              false
      end.
     
%%发送系统信息
broadcast_sys_msg(_Type, Msg) ->
    Data = [2, Msg],
    {ok, BinData} = pt_11:write(11010, Data),
	mod_disperse:broadcast_to_world(ets:tab2list(?ETS_SERVER), BinData),
	lib_send:send_to_local_all(BinData).

