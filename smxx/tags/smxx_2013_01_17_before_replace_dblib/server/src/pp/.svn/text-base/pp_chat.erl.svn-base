%%%--------------------------------------
%%% @Module  : pp_chat
%%% @Author  : csj
%%% @Created : 2010.09.28
%%% @Description:  聊天功能
%%%--------------------------------------
-module(pp_chat).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile([export_all]).

%%世界聊天
%% handle(11010, Status, [Data]) when is_list(Data) andalso erlang:length(Data) < 150 ->
%% 	lib_task:event(chat_world, [1], Status),
%% 	Data_filtered = lib_words_ver:words_filter([Data]),
%% 	lib_chat:chat_world(Status, [Data_filtered]);
%% 
%% %%检查集结号
%% handle(11020, Status, _) ->
%% 	Data = gen_server:call(Status#player.other#player_other.pid_goods, 
%% 						   {'goods_count_chat', Status#player.id}),
%% 	{ok, BinData} = pt_11:write(11020, Data),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
%% 
%% %%集结号
%% handle(11021, Status, [Type, Data]) when is_list(Data) andalso erlang:length(Data) < 150 ->
%% 	Data_filtered = lib_words_ver:words_filter([Data]),
%% 	lib_chat:chat_sound(Status, [Type, Data_filtered]);	
%% 	
%% 
%% %%联盟聊天
%% handle(11030, Status, [Data]) when is_list(Data) andalso erlang:length(Data) < 600 ->
%% %% 	Data_filtered = lib_words_ver:words_filter([Data]),  %%前端已做过滤
%% 	lib_chat:chat_guild(Status, [Data]);
%% 
%% %% %%队伍聊天
%% %% handle(11040, Status, [Data]) when is_list(Data) andalso erlang:length(Data) < 150 ->
%% %% 	Data_filtered = lib_words_ver:words_filter([Data]),
%% %% 	lib_chat:chat_team(Status, [Data_filtered]);
%% 
%% %%场景聊天
%% handle(11050, Status, [Data]) when is_list(Data) andalso erlang:length(Data) < 150 ->
%% 	SceneId = Status#player.scn,
%% 	if
%% 		SceneId =:= 310 orelse SceneId div 100 =:= 310 ->	%%宠物岛
%% 			ok;
%% 		true ->
%% 			Data_filtered = lib_words_ver:words_filter([Data]),
%% 			lib_chat:chat_scene(Status, [Data_filtered])
%% 	end;
%% 
%% %%私聊
%% %%_Uid:用户ID
%% %%_Nick:用户名  	(_Uid 和_Nick 任意一个即可 )
%% %%Data:内容
%% handle(11070, Status, [Uid, Data]) when is_list(Data) andalso erlang:length(Data) < 600 ->
%% 	Data_filtered = lib_words_ver:words_filter([Data]),
%%     Data1 = [Status#player.id, Status#player.crr, Status#player.sex, Status#player.nick, Data_filtered],
%%     {ok, BinData} = pt_11:write(11070, Data1),
%% %% 	%%判断是否存在黑名单关系(存在则屏蔽,并返回信息)
%% %% 	case lib_relationship:is_exists_remote(Uid, Status#player.id, 2) of
%% %% 		{_, false} ->
%% 	lib_chat:private_to_uid(Uid, Status#player.other#player_other.pid_send, BinData);
%% %% 		{_, true} ->
%% %% 			lib_chat:chat_in_blacklist(Uid, Status#player.other#player_other.pid_send)
%% %% 	end;		   
%%  
%% 
%% 
%% 
%% %%展示
%% handle(11100, Status, [CTypeString,Name])  ->
%% 	ShareDataString = "<a href='event:comm_"++ tool:to_list(CTypeString)++"'><u><font color='#ffffff'>"++tool:to_list(Name)++"</font></u></a>,comm",
%% 	lib_chat:chat_world(Status, [ShareDataString]);
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% handle(_Cmd, _Status, _Data) ->
%% %%     ?DEBUG("pp_chat no match", []),
%%     {error, "pp_chat no match"}.
