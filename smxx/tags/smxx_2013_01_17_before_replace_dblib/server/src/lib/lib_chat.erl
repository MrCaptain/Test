%%%-----------------------------------
%%% @Module  	: lib_chat
%%% @Author  	: csj
%%% @Created 	: 2010.10.14
%%% @Description: 聊天  
%%%-----------------------------------
-module(lib_chat).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-define(SOCKET_CHAT,3).
%% 处理世界聊天
%% chat_world(Status, [Data]) ->
%%    	case gmcmd:cmd(Status,Data) of
%% 		is_cmd -> ok;
%% 		_ ->
%% 		if Status#player.lv < 3 ->  %%检查等级
%% 		   	{ok, BinData} = pt_11:write(11011, [4, 14]),
%% 		   	lib_send:send_one(get_socket(Status), BinData),
%% 		   	ok;
%% 	   	true ->
%% 		    %%检查禁言情况
%% 			[Can_chat,  Ret] = check_donttalk(Status#player.id),
%% 			case Can_chat of
%% 				true ->	%%可以聊天
%% 		   				%%检查聊天间隔
%% 		    			case check_chat_interval(previous_chat_time_world, 10) of
%% 				 			true -> 
%%     							Data1 = [Status#player.id, Status#player.nick, Status#player.crr, Status#player.sex, Status#player.state, Data],
%%     							{ok, BinData} = pt_11:write(11010, Data1),
%%     							lib_send:send_to_all(BinData,?SOCKET_CHAT);
%% 				 			false ->
%% 		   						{ok, BinData} = pt_11:write(11011, [1, 10]),
%% 		   						lib_send:send_one(get_socket(Status), BinData)	
%% 						end;
%% 				_ ->	%%不能聊天
%% 		   			{ok, BinData} = pt_11:write(11011, [Ret, 0]),
%% 		   			lib_send:send_one(get_socket(Status), BinData),						
%% 					ok
%% 			end
%% 		end
%% 	end.
%% 
%% %% %% 处理阵营聊天
%% %% chat_realm(Status, [Data]) ->
%% %%    	case gmcmd:cmd(Status,Data) of
%% %% 		is_cmd -> ok;
%% %% 		_ ->
%% %% 		%%检查禁言情况
%% %% 		[Can_chat,  Ret] = check_donttalk(Status#player.id),
%% %% 		case Can_chat of
%% %% 			true ->	%%可以聊天
%% %% 				%%检查聊天间隔
%% %%     			case check_chat_interval(previous_chat_time_realm, 2) of
%% %% 					true -> 
%% %% 						Data1 = [Status#player.id, Status#player.nick, Status#player.crr, Status#player.camp, Status#player.sex,Status#player.vip, Status#player.state,Data],
%% %% 						{ok, BinData} = pt_11:write(11020, Data1),
%% %% 		 				lib_send:send_to_realm(Status#player.camp, BinData,?SOCKET_CHAT);
%% %% 					false ->
%% %% 						{ok, BinData} = pt_11:write(11021, [1, 2]),
%% %% 						lib_send:send_one(get_socket(Status), BinData)	
%% %% 				end;
%% %% 			_ ->	%%不能聊天
%% %% 				{ok, BinData} = pt_11:write(11021, [Ret, 0]),
%% %% 				lib_send:send_one(get_socket(Status), BinData),						
%% %% 				ok
%% %% 		end
%% %% 	end.
%% 
%% %% 处理联盟聊天
%% chat_guild(Status, [Data]) ->
%%    	case gmcmd:cmd(Status,Data) of
%% 		is_cmd -> ok;
%% 		_ ->
%% 		%%检查禁言情况
%% 		[Can_chat,  Ret] = check_donttalk(Status#player.id),
%% 		case Can_chat of
%% 			true ->	%%可以聊天
%% 				%%检查聊天间隔
%%     			case check_chat_interval(previous_chat_time_guild, 2) of
%% 					true -> 
%% 						if
%% 							Status#player.unid > 0 ->
%% 								Data1 = [Status#player.id, Status#player.nick, Status#player.crr, Status#player.sex, Status#player.state, Status#player.upst, Data],
%% 								{ok, BinData} = pt_11:write(11030, Data1),
%% 		 						lib_send:send_to_guild(Status#player.unid, BinData);
%% 							true ->
%% 								{ok, BinData} = pt_11:write(11031, [4, 0]),
%% 								lib_send:send_one(get_socket(Status), BinData)
%% 						end;
%% 					false ->
%% 						{ok, BinData} = pt_11:write(11031, [1, 2]),
%% 						lib_send:send_one(get_socket(Status), BinData)	
%% 				end;
%% 			_ ->	%%不能聊天
%% 				{ok, BinData} = pt_11:write(11031, [Ret, 0]),
%% 				lib_send:send_one(get_socket(Status), BinData),						
%% 				ok
%% 		end
%% 	end.
%% 
%% %% %% 处理队伍聊天
%% %% chat_team(Status, [Data]) ->
%% %%    	case gmcmd:cmd(Status,Data) of
%% %% 		is_cmd -> ok;
%% %% 		_ ->
%% %% 		%%检查禁言情况
%% %% 		[Can_chat,  Ret] = check_donttalk(Status#player.id),
%% %% 		case Can_chat of
%% %% 			true ->	%%可以聊天
%% %% 				%%检查聊天间隔
%% %% 			    case check_chat_interval(previous_chat_time_team, 2) of
%% %% 					true -> 
%% %%    				 		case misc:is_process_alive(Status#player.other#player_other.pid_team) of
%% %%         					true ->
%% %% 								Data1 = [Status#player.id, Status#player.nick, Status#player.crr, Status#player.camp, Status#player.sex,Status#player.vip, Status#player.state,Data],
%% %% 								{ok, BinData} = pt_11:write(11040, Data1),
%% %%             					gen_server:cast(Status#player.other#player_other.pid_team, {'TEAM_CHAT', BinData});
%% %%         					false -> ok
%% %%     					end;
%% %% 					false ->
%% %% 						{ok, BinData} = pt_11:write(11041, [1, 2]),
%% %% 						lib_send:send_one(get_socket(Status), BinData)	
%% %% 				end;
%% %% 			_ ->	%%不能聊天
%% %% 				{ok, BinData} = pt_11:write(11041, [Ret, 0]),
%% %% 				lib_send:send_one(get_socket(Status), BinData),						
%% %% 				ok
%% %% 		end
%% %% 	end.
%% 
%% %% 处理场景聊天
%% chat_scene(Status, [Data]) ->
%%    	case gmcmd:cmd(Status,Data) of
%% 		is_cmd -> ok;
%% 		_ ->
%% 		if Status#player.lv < 3 ->  %%检查等级
%% 		   	ok;
%% 		   true ->
%% 			%%检查禁言情况
%% 			[Can_chat,  Ret] = check_donttalk(Status#player.id),
%% 			case Can_chat of
%% 				true ->	%%可以聊天
%% 					%%检查聊天间隔
%%  			   		case check_chat_interval(previous_chat_time_scene, 2) of
%% 						true -> 
%% 							Data1 = [Status#player.id, Status#player.nick, Status#player.crr, Status#player.sex, Status#player.state,Data],
%% 							{ok, BinData} = pt_11:write(11050, Data1),
%% 					 		mod_scene_agent:send_to_scene(Status#player.scn, BinData);		
%% 						false ->
%% 							{ok, BinData} = pt_11:write(11051, [1, 2]),
%% 							lib_send:send_one(get_socket(Status), BinData)	
%% 					end;
%% 				_ ->	%%不能聊天
%% 					{ok, BinData} = pt_11:write(11051, [Ret, 0]),
%% 					lib_send:send_one(get_socket(Status), BinData),						
%% 					ok
%% 			end
%% 		end
%% 	end.
%% 
%% %% 处理集结号
%% chat_sound(Status, [Type, Data]) ->
%% %% 	%%检查禁言情况
%% 	[Can_chat,  _Ret] = check_donttalk(Status#player.id),
%% 	case Can_chat of
%% 		true ->	%% 可以聊天
%% 			%% 检查聊天间隔
%% 			case check_chat_interval(sound_chat_time_world, 1) of
%% 				true -> 
%% 					%%检查是否有集结号
%% 					{GoodsType, Cmd} =
%% 						case Type of
%% 							1 ->
%% 								{360101, 11022};
%% 							_ ->
%% 								{360201, 11023}
%% 						end,
%%     				case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_more', GoodsType, 1}) of
%% 						1 ->  %%  使用集结号
%% 							{ok, BinData} = pt_11:write(11021, [1]),
%% 							Data1 = [Status#player.id, Status#player.nick, Status#player.crr, 
%% 									 Status#player.sex, Status#player.state, Data],
%% 							{ok, BCBinData} = pt_11:write(Cmd, Data1),
%% 							lib_send:send_to_all(BCBinData,?SOCKET_CHAT);
%% 						_ ->  %%  集结号不够
%% 							Err = Type + 10,
%% 							{ok, BinData} = pt_11:write(11021, [Err])	
%% 					end;
%% 				false -> %% 不到聊天间隔期
%% 		   			{ok, BinData} = pt_11:write(11021, [0])
%% 			end;
%% 		_ ->	%%不能聊天
%% 			{ok, BinData} = pt_11:write(11021, [2])
%% 	end,
%% 	lib_send:send_one(get_socket(Status), BinData).
%%   
%% %%检查禁言情况
%% check_donttalk(PlayerId) ->
%% 	try 
%% 	[Stop_begin_time, Stop_chat_minutes] = get(donttalk),
%% 	case Stop_chat_minutes of
%% 		undefined -> 	%% 没有被禁言
%% 			[true,  undefined];
%% 		999999 -> 		%% 永远禁言
%% 			[false, 3];		
%% 		Val ->			%% 有禁言
%% 			TimeDiff = util:unixtime() - Stop_begin_time,
%% 			if 
%% 				TimeDiff >= Val*60 ->
%% 					db_agent:delete_donttalk(PlayerId),
%% 					put(donttalk, [undefined, undefined]),
%% 					[true,  undefined];
%% 				true ->
%% 					[false, 2]
%%   			end
%% 	end
%% 	catch
%% 		_:_ -> [true,  undefined]
%% 	end.
%% 
%% %%私聊返回被加黑名单通知
%% chat_in_blacklist(Id, Sid) ->
%%     {ok, BinData} = pt_11:write(11071, Id),
%%     lib_send:send_to_sid(Sid, BinData).
%% 
%% %%发送系统信息给某个玩家
%% %% send_sys_msg_one(Socket, Msg) ->
%% %%     {ok, BinData} = pt_11:write(11080, Msg),
%% %%     lib_send:send_one(Socket, BinData).
%% 
%% %%发送系统信息(Type=1:系统；2:传闻; 3:开封印)
%% broadcast_sys_msg(Type, Msg) ->
%% 	Msg1 = tool:to_binary(Msg),
%%     Len1 = byte_size(Msg1),
%% 	Data = <<0:16, Len1:16, Msg1/binary>>,
%% 	{ok, BinData} = pt_11:write(11080, Type, Data),
%% 	mod_disperse:broadcast_to_world(ets:tab2list(?ETS_SERVER), BinData),
%% 	lib_send:send_to_local_all(BinData).
%% 
%% %%专门用于诛邪系统 的广播
%% %% boradcast_box_goods_msg(_Type, Msg, BroadCastGoodsList) ->
%% %% 	{ok, BinData} = pt_11:write(11080, 3, Msg),
%% %% 	mod_disperse:boradcast_box_goods_msg(ets:tab2list(?ETS_SERVER), BinData, BroadCastGoodsList),
%% %% 	lib_send:send_to_local_all(BinData).
%% 
%% 
%% %%发送聊天给指定玩家ID.
%% %%From_id 发送方Id
%% %%To_id: 接收方ID
%% %%Bin:二进制数据.
%% private_to_uid(To_id, Sid, Bin) ->
%% 	case lib_player:is_online(To_id) of
%% 		true ->
%% 			case lib_player:get_player_pid(To_id) of
%% 				[] ->
%% 					[];
%% 				Pid ->
%% 					gen_server:cast(Pid, {send_to_sid, Bin})
%% 			end;
%% 		_ ->
%% 			gen_server:cast(mod_offline:get_mod_offline_pid(),{add_offline_rela,To_id,Bin,rela})
%% 	end.
%% 		
%% %% 获取聊天间隔
%% getChatTimeDiff(Previous_chat_time)->
%% 	case get(Previous_chat_time) of
%% 		undefined -> 
%% 			PreviousChatTime = {0,0,0};
%% 		Val ->
%% 			PreviousChatTime = Val
%% 	end,
%% 	Now = game_timer:now(),
%% 	TimeDiff = timer:now_diff(Now, PreviousChatTime),
%% 	{Now, TimeDiff}.
%% 
%% %% 检查聊天间隔
%% check_chat_interval(Previous_chat_time, Interval) ->
%% 	{Now,TimeDiff} = getChatTimeDiff(Previous_chat_time),
%% 	if TimeDiff >= Interval*1000000 ->
%% 			put(Previous_chat_time, Now),
%% 			true;
%% 	   true ->
%% 		   false
%% 	end.
%% 
%% %% 选择玩家socket 默认socket3
%% get_socket(Player) ->
%% 	case Player#player.other#player_other.socket3 of
%% 		undefined ->
%% 			Player#player.other#player_other.socket;
%% 		Socket ->
%% 			Socket
%% 	end.
