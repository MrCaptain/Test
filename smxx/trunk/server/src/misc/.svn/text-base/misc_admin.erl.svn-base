%%%----------------------------------------
%%% @Module  : misc_admin
%%% @Author  : csj
%%% @Created : 2010.10.09
%%% @Description: 系统状态管理和查询
%%%----------------------------------------
-module(misc_admin).
%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%
%% Exported Functions
%%
-compile(export_all).

%% 处理http请求【需加入身份验证或IP验证】
treat_http_request(Socket, Packet0) ->
%% 	io:format("treat_http_request~p~n",[[0]]),
	case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of 
		{ok, Packet} -> 
			case check_ip(Socket) of
				true ->
%% 					io:format("treat_http_request~p~n",[[1]]),
					P = lists:concat([Packet0, tool:to_list(Packet)]),
					check_http_command(Socket, tool:to_binary(P)),
					{http_request,  ok};
				_ ->
					gen_tcp:send(Socket,  <<"no_right">>),
					{http_request,  no_right}	
			end;
		{error, Reason} -> 
			{http_request,  Reason}
	end.

%% 加入http来源IP验证 
check_ip(Socket) ->
	MyIp = misc:get_ip(Socket),
	lists:any(fun(Ip) ->
					  tool:to_binary(MyIp)=:=tool:to_binary(Ip) end,config:get_http_ips(gateway)).

get_cmd_parm(Packet) ->
	Packet_list = string:to_lower(tool:to_list(Packet)),
	try
		case string:str(Packet_list, " ") of
			0 -> no_cmd;
			N -> CM = string:substr(Packet_list,2,N-2),
				 case string:str(CM, "?") of
					 0 -> [CM, ""];
				 	N1 -> [string:substr(CM,1,N1-1),  string:substr(CM, N1+1)]
				 end
		end
	catch
		_:_ -> no_cmd
	end.


%% 检查分析并处理http指令
check_http_command(Socket, Packet) ->
%% 		——节点信息查询:		/get_node_status?					(ok)
%%		--节点信息查询:		/get_node_info?t=1[cpu]2[memory]3[queue](ok)
%%  	--进程信息查询 		/get_process_info?p=pid					(ok)
%%		--获取进程信息		/get_proc_info?p=<0,1,2> (ok)
%% 		--关闭节点                           /close_nodes?t=1|2
%% 		——设置禁言: 			/donttalk?id=stoptime(分钟)			(ok)
%% 		——解除禁言: 			/donttalk?id=0						(ok)
%% 		——踢人下线：			/kickuser?id						(ok)
%%		——封/开角色：			/banrole?id=1/0						(ok)
%% 		——封/开账号：			/banaccount?accid=1/0				(ok)
%%		——通知客户端增减金钱	/notice_change_money?id=parm
%% 		——GM群发：   			/broadmsg?gmid_content[中文？]		(ok)
%% 		——安全退出游戏服务器：	/safe_quit?node						(ok)
%% 		——请求加载基础数据：	/load_base_data?					(ok)	
%% 		——禁言列表：			/donttalklist?	
%%		——获取在线人数		/online_count?						(ok)
%%		__获取场景人数		/scene_online_count?				(ok)
%%      __发送通知给玩家		notice								
%%  	io:format("get cmd ~p~n", [get_cmd_parm(Packet)]),
	try
		case get_cmd_parm(Packet) of
			["get_node_status", _] ->
				Data = get_nodes_info(), 
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"error!">>);
					true -> 
						gen_tcp:send(Socket, Data)
				end;
			["get_node_info",Parm] ->
				[_n, Type] = string:tokens(Parm, "="),
				Data = get_nodes_cmq(1,tool:to_integer(Type)),
				DataFormat = io_lib:format("~p", [Data]),
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"error!">>);
					true -> 
						gen_tcp:send(Socket,DataFormat)
				end;
			["get_process_info",Parm]->
				[_,PidList] = string:tokens(Parm,"="),
				Data = get_porcess_info(PidList),
				DataFormat = io_lib:format("~p",[Data]),
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"error!">>);
					true -> 
						gen_tcp:send(Socket,DataFormat)
				end;
			["close_nodes",Parm] ->
				[_n,Type] = string:tokens(Parm, "="),
				Data = close_nodes(tool:to_integer(Type)),
				DataFormat = io_lib:format("~p", [Data]),
				gen_tcp:send(Socket,DataFormat);
			["donttalk", Parm] ->		
				[Id, Stoptime] = string:tokens(Parm, "="),
				operate_to_player(misc_admin, donttalk, [list_to_integer(Id), list_to_integer(Stoptime)]),
				gen_tcp:send(Socket, <<"ok!">>),
				ok;
			["kickuser", Parm] ->		
				operate_to_player(misc_admin, kickuser, [list_to_integer(Parm)]),
				gen_tcp:send(Socket, <<"ok!">>),
				ok;	
			["banrole", Parm] ->	
				[Id0, Action0] = string:tokens(Parm, "="),
				Id = list_to_integer(Id0),
				Action = list_to_integer(Action0),
				Action1 =
					if Action < 0 orelse Action >1 ->
						0;
	   					true -> Action
					end,
				db_agent:set_player_status(Id, Action1),
				operate_to_player(misc_admin, banrole, [Id, Action1]),
				gen_tcp:send(Socket, <<"ok!">>),
				ok;		
%%             封平台帐号，如果打开则要修改db_agent:set_user_status(AccId, Action1),	其需要三个参数db_agent:set_user_status(Sn, AccId, Action1)
%% 			["banaccount", Parm] ->		
%% 				[AccId0, Action0] = string:tokens(Parm, "="),
%% 				AccId = list_to_integer(AccId0),
%% 				Action = list_to_integer(Action0),
%% 				Action1 =
%% 						case lists:member(Action, [0,1]) of
%% 							true -> Action;
%% 							_ -> 0
%% 						end,	
%% 				db_agent:set_user_status(AccId, Action1),	
%% 				operate_to_player(misc_admin, banaccount, [AccId, Action1]),
%% 				gen_tcp:send(Socket, <<"ok!">>),
%% 				ok;	
			["notice_change_money", Parm] ->		
				PlayerId = list_to_integer(Parm),
				change_money(PlayerId),
				ok;	
			["broadmsg", Parm] ->	
				Content = http_lib:url_decode(Parm),
%%  io:format("broadmsg: ///~p///~p///~p/// ~n",[Parm, Content, tool:to_binary(Content)]),
				lib_chat:broadcast_sys_msg(2, Content),
				gen_tcp:send(Socket, tool:to_binary(Content)),
				ok;			
			["safe_quit", Parm] ->		
				safe_quit(),
				gen_tcp:send(Socket, <<"ok!">>),
				ok;
			["remove_nodes", Parm] ->		
				remove_nodes(Parm),
				gen_tcp:send(Socket, <<"ok!">>),
				ok;
			["load_base_data", Parm] ->		
				load_base_data(Parm),
				gen_tcp:send(Socket, <<"ok!">>),
				ok;		
			["online_count", _Parm] ->
				Data = get_online_count(),
%% 				io:format("~p~n",[Data]),
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"0">>);
					true -> 
						gen_tcp:send(Socket, Data)
				end;
			["scene_online_count",_Parm] ->
				Data = get_scene_online_num_php(),
%% 				io:format("get cmd ~p~n", [Data]),
				gen_tcp:send(Socket,Data);
%% 			["notice",Parm] ->
%% %% 				operate_to_player(misc_admin, notice_to_player, [list_to_integer(Parm)]),
%% %% 				gen_tcp:send(Socket, <<"ok!">>),
%% 				notice_to_player(list_to_integer(Parm)) ,
%% 				ok;
			["sys_acm",Parm] ->   %%新增或者修改公告				
%% 				io:format("=====check_http_command====~p~n",[Parm]) ,
				mod_rank:change_sys_acm(list_to_integer(Parm)) ,
				ok;
			["sys_acm_del",Parm] ->   %%删除公告
				mod_rank:delete_sys_acm(list_to_integer(Parm)) ,
				ok;
			["change_com_gift",Parm] ->   %%新增或者修改常规礼品				
%% 				io:format("=====check_http_command====~p~n",[Parm]) ,
				change_com_gift(list_to_integer(Parm)) ,
				ok;
			["delete_com_gift",Parm] ->   %%删除常规礼品
				delete_com_gift(list_to_integer(Parm)) ,
				ok;
			["chk_max_allow",_Parm] ->   %%查询服务器当前最大人数设置
				Num = game_gateway:chk_max_allow(),
				Data = lists:concat(["chk_max_allow:",Num]),
				gen_tcp:send(Socket, Data);
			["set_max_allow",Parm] ->   %%设置服务器当前最大人数设置
				game_gateway:set_max_allow(list_to_integer(Parm)),
%% 				gen_tcp:send(Socket, <<"ok!">>),
				ok;
			["query_challenger_upper",_Parm] ->   %%查询世界Boss当前最大人数设置
				Num = mod_boss_agent:query_challenger_upper(),
				Data = lists:concat(["query_challenger_upper:",Num]),
				gen_tcp:send(Socket, Data);
			["set_max_challenger",Parm] ->   %%设置世界Boss当前最大人数设置
				mod_boss:set_max_challenger(list_to_integer(Parm)),
%% 				gen_tcp:send(Socket, <<"ok!">>),
				ok;	
			["notice_mail", Param] ->   %%通过助手系统给玩家回信
                MailId = list_to_integer(Param),
                lib_mail:notify_new_mail(MailId),
				ok;			            
			_ -> 
				error_cmd
		end
	catch 
		_:_ -> error
	end.
	

%% 获取在线人数
get_online_count() ->
	Total_user_count = get_online_count(num),
	lists:concat(['online_count:',Total_user_count]).

get_online_count(num) ->
	L = mod_disperse:server_list(),
	Count_list =
    if 
        L == [] ->
            [0];
        true ->
			Info_list =
				lists:map(
			  		fun(S) ->
						{_Node_name, User_count} = 
					  		case rpc:call(S#server.node, mod_disperse, online_state, []) of
								{badrpc, _} ->
                                    {error, 0};
                                [_State, Num, _] ->
                                    {S#server.node, Num}
							end,
						User_count
					end,
			  		L),
			Info_list
    end,
	lists:sum(Count_list).


%% 获取玩家等级附近的玩家列表，全服的。
%% @spec get_close_level_players(PlayerLv,FloatLv)
get_close_level_players(PlayerId,PlayerLv,FloatLv,MinLv) ->
	ServerList = mod_disperse:server_list() ,
	CurPlayerList = mod_disperse:close_level_players(PlayerId,PlayerLv,FloatLv,MinLv) ,
	Fun = fun(Server,PlayerList) ->
				  case rpc:call(Server#server.node,mod_disperse,close_level_players,[PlayerId,PlayerLv,FloatLv,MinLv]) of
					  CurPlayeList when is_list(CurPlayeList) andalso length(CurPlayeList) > 0 ->
						  NewPlayerList = PlayerList ++ CurPlayeList ;
					  _ ->
						  NewPlayerList = PlayerList 
				  end ,
				  NewPlayerList
		  end ,
	lists:foldl(Fun, CurPlayerList, ServerList).



%% 获取场景在线数（外部php调用）
get_scene_online_num_php() ->
	_Total_scene_user_count=get_scene_online_num_php(num).

%%获取场景在线数（外部php调用）
get_scene_online_num_php(num) ->
	L = mod_disperse:server_list(),
	Count_list =
		if
			L == [] ->
				[{0,<<>>,0}];
			true ->
					lists:map(
					  fun(S) ->
%% 							  io:format("get cmd ~p~n", [S]),
								  case rpc:call(S#server.node,mod_disperse,scene_online_num_php,[]) of
									  {badrpc,_}->
										  [];
									  GetList ->
%% 										  io:format("getlist~p~n", [GetList]),
										  GetList
								  end
					  end
					  ,L)
		end,
	FlattenList = lists:flatten(Count_list),
%% 	io:format("FlattenList..~p~n",[FlattenList]),
	CountData = lists:foldl(fun count_scene_online_num_php/2, [], FlattenList),
%% 	io:format("CountData..~p~n",[CountData]),
	F_print = fun({SceneId,SceneName,Num},Str) ->
			lists:concat([Str,'[',tool:to_list(SceneName),']  [',SceneId,']  [',Num,']\t\n'])	
	end,
	lists:foldl(F_print,[],CountData).
					  
%%统计场景人数（外部php调用）
count_scene_online_num_php({SceneId,SceneName,Num},CountInfo) ->
	case lists:keysearch(SceneId, 1, CountInfo) of
		false ->
			[{SceneId,SceneName,Num}]++CountInfo;
		{value,{_sceneid,SceneName,Total}} ->
			lists:keyreplace(SceneId, 1, CountInfo,{SceneId,SceneName,Num+Total})
	end.
	

%%获取场景在线数
get_scene_online_num() ->
	L = mod_disperse:server_list(),
	Count_list =
		if
			L == [] ->
				[{0,0}];
			true ->
					lists:map(
					  fun(S) ->
								  case rpc:call(S#server.node,mod_disperse,scene_online_num,[]) of
									  {badrpc,_}->
										  [];
									  GetList ->
										  GetList
								  end
					  end
					  ,L)
		end,
	FlattenList = lists:flatten(Count_list),
	lists:foldl(fun count_scene_online_num/2, [], FlattenList).
					  
%%统计场景人数
count_scene_online_num({SceneId, Num},CountInfo) ->
	case lists:keysearch(SceneId, 1, CountInfo) of
		false ->
			[{SceneId, Num}|CountInfo];
		{value,{_sceneid, Total}} ->
			lists:keyreplace(SceneId, 1, CountInfo,{SceneId, Num+Total})
	end.


%% 获取节点列表
get_node_info_list() ->
	L = lists:usort(mod_disperse:server_list()),
	Info_list =
		lists:map(
	  		fun(S) ->
				{Node_status, Node_name, User_count} = 
			  		case rpc:call(S#server.node, mod_disperse, online_state, []) of
						{badrpc, _} ->
                              {fail, S#server.node, 0};
                       [_State, Num, _] ->
                              {ok,   S#server.node, Num}
					end,	
				Node_info = 
					try 
					case rpc:call(S#server.node, misc_admin, node_info, []) of
				  		{ok, Node_info_0} ->
							Node_info_0;
						_ ->
							error
					end
					catch
						_:_ -> error
					end,							
				{Node_status, Node_name, User_count, Node_info}
			end,
	  		L),
	{ok, Gateway_node_info} = misc_admin:node_info(),
	Info_list_1 = Info_list ++ [{0, node(), 0, Gateway_node_info}],
	{ok, Info_list_1}.

% 获取各节点状态
get_nodes_info() ->
	case get_node_info_list() of
		{ok, Node_info_list} ->
			Count_list =
				lists:map(
				  fun({_Node_status, _Node_name, User_count, _Node_info})->
						  User_count
				  end,
				  Node_info_list),	
			Total_user_count = lists:sum(Count_list),	
			
			Node_ok_list =
				lists:map(
				  fun({Node_status, _Node_name, _User_count, _Node_info})->
						  case Node_status of
							  fail -> 0;
							  _ ->  1
						  end
				  end,
				  Node_info_list),	
			Total_node_ok = lists:sum(Node_ok_list),	
			Temp1 = 
				case Total_node_ok =:= length(Node_info_list) of
					true -> [];
					_ -> lists:concat(['/',Total_node_ok])
				end,
			
			All_Connect_count_str = lists:concat(['Nodes_count: [', length(Node_info_list),
								'] ,total_connections: [', Total_user_count, Temp1,
								']    [',misc:time_format(game_timer:now()),
								']']),
			Info_list =
				lists:map(
				  fun({Node_status, Node_name, _User_count, Node_info})->
						  case Node_status of
							  fail ->
								lists:concat(['Node: ',Node_name,'[Warning: this node may be crashed or busy.]\t\n']);
							  _ ->
								lists:concat(['Node: ',Node_name,'\t\n',Node_info])
						  end
				  end,
				  Node_info_list),	

			lists:concat([All_Connect_count_str, 
						'\t\n', 
						'------------------------------------------------------------------------\t\n',
						Info_list]);		
		_ ->
			''
	end.

%% %% 获取本节点的基本信息
%% node_info() ->
%%   	Info = get_node_info(),
%%  	{ok, Info}.

%% get_node_info() ->
%% 	Info_log_level = lists:concat(['    Log_level:[', config:get_log_level(server),'], Process_id:[',os:getpid(),']\t\n']),
%% 	 
%% 	Info_tcp_listener =	
%% 		lists:concat(
%% 			case ets:match(?ETS_SYSTEM_INFO,{'_',tcp_listener,'$3'}) of
%% 				[[{Host_tcp, Port_tcp, Start_time}]] ->
%% 					['    Tcp listener? [Yes]. IP:[',Host_tcp,
%% 					 		'], Port:[',Port_tcp,
%% 					 		'], Connections:[',ets:info(?ETS_ONLINE, size),
%% 					 		'], Start_time:[',misc:time_format(Start_time),					 		
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]
%% 			end),
%% 
%% 	Info_mysql =	
%% 		lists:concat(
%% 			case ets:match(?ETS_SYSTEM_INFO,{'_',mysql,'$3'}) of
%% 				[[{Host_mysql, Port_mysql, User_mysql, DB_mysql, Encode_mysql}]] ->
%% 					['    Mysql connected? [Yes]. IP:[',Host_mysql,
%% 					 		'], Port:[',Port_mysql,
%% 					 		'], User:[',User_mysql,
%% 					 		'], DB:[',DB_mysql,
%% 					 		'], Encode:[',Encode_mysql,
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]
%% 			end),
%% 	
%% 	Info_mongo =	
%% 		lists:concat(
%% 			case ets:match(?ETS_SYSTEM_INFO,{'_',mongo,'$3'}) of
%% 				[[{PoolId_mongo, Host_mongo, Port_mongo, DB_mongo, EmongoSize_mongo}]] ->
%% 					['    Mongodb master? [Yes]. PoolId:[',PoolId_mongo,
%% 					 		'], Host:[',Host_mongo,
%% 					 		'], Port:[',Port_mongo,
%% 					 		'], DB:[',DB_mongo,
%% 					 		'], Size:[',EmongoSize_mongo,
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]
%% 			end),
%% 	
%% 	Info_mongom_slave =	
%% 		lists:concat(
%% 			case ets:match(?ETS_SYSTEM_INFO,{'_',mongo_slave,'$3'}) of
%% 				[[{PoolId_mongo_slave, Host_mongo_slave, Port_mongo_slave, DB_mongo_slave, EmongoSize_mongo_slave}]] ->
%% 					['    Mongodb slave? [Yes]. PoolId:[',PoolId_mongo_slave,
%% 					 		'], Host:[',Host_mongo_slave,
%% 					 		'], Port:[',Port_mongo_slave,
%% 					 		'], DB:[',DB_mongo_slave,
%% 					 		'], Size:[',EmongoSize_mongo_slave,
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]
%% 			end),
%% 	
%% 	Info_stat_socket = 
%% 		try
%% 			case ets:info(?ETS_STAT_SOCKET) of
%% 				undefined ->
%% 					[];
%% 				_ ->
%% 					Stat_list_socket_out = ets:match(?ETS_STAT_SOCKET,{'$1', socket_out , '$3','$4'}),
%% 					Stat_list_socket_out_1 = lists:sort(fun([_,_,Count1],[_,_,Count2]) -> Count1 > Count2 end, Stat_list_socket_out),
%% 					Stat_list_socket_out_2 = lists:sublist(Stat_list_socket_out_1, 5),
%% 					Stat_info_socket_out = 
%% 					lists:map( 
%% 	  					fun(Stat_data) ->
%% 							case Stat_data of				
%% 								[Cmd, BeginTime, Count] ->
%% 									TimeDiff = timer:now_diff(game_timer:now(), BeginTime)/(1000*1000)+1,
%% 									lists:concat(['        ','Cmd:[', Cmd, 
%% 												'], packet_avg/sec:[', Count, '/',round(TimeDiff),' = ',round(Count / TimeDiff),']\t\n']);
%% 								_->
%% 									''
%% 							end 
%% 	  					end, 
%% 						Stat_list_socket_out_2),
%% 					if length(Stat_info_socket_out) > 0 ->
%% 						lists:concat(['    Socket packet_out statistic_top5:\t\n', Stat_info_socket_out]);
%% 			   		   true ->
%% 				   		[]
%% 					end			
%% 			end
%% 		catch
%% 			_:_ -> []
%% 		end,	
%% 	
%% 	Info_stat_db = 
%% 		try
%% 			case ets:info(?ETS_STAT_DB) of
%% 				undefined ->
%% 					[];
%% 				_ ->
%% 					Stat_list_db = ets:match(?ETS_STAT_DB,{'$1', '$2', '$3', '$4', '$5'}),
%% 					Stat_list_db_1 = lists:sort(fun([_,_,_,_,Count1],[_,_,_,_,Count2]) -> Count1 > Count2 end, Stat_list_db),
%% 					Stat_list_db_2 = lists:sublist(Stat_list_db_1, 5), 
%% 					Stat_info_db = 
%% 					lists:map( 
%% 	  					fun(Stat_data) ->
%% 							case Stat_data of				
%% 								[_Key, Table, Operation, BeginTime, Count] ->
%% 									TimeDiff = timer:now_diff(game_timer:now(), BeginTime)/(1000*1000)+1,
%% 									lists:concat(['        ','Table:[', lists:duplicate(30-length(tool:to_list(Table))," "), Table, 
%% 												'], op:[', Operation,
%% 												'], avg/sec:[', Count, '/',round(TimeDiff),' = ',round(Count / TimeDiff),']\t\n']);
%% 								_->
%% 									''
%% 							end 
%% 	  					end, 
%% 						Stat_list_db_2),
%% 					if length(Stat_info_db) > 0 ->
%% 						lists:concat(['    Table operation statistic_top5:\t\n', Stat_info_db]);
%% 			   		   true ->
%% 				   		[]
%% 					end			
%% 			end
%% 		catch
%% 			_:_ -> []
%% 		end,	
%% 
%% 	Process_info_detail = 
%% 		try
%% 			get_monitor_process_info_list()
%% 		catch
%% 			_:_ -> {ok, []} 
%% 		end,
%% 
%% 	Info_process_queue_top = 
%% 		try
%% 			case get_process_info(Process_info_detail, 5, 2, 0, msglen) of 
%% 				{ok, Process_queue_List, Process_queue_List_len} ->
%% 					Info_process_queue_list = 
%% 					lists:map( 
%% 	  					fun({Pid, RegName, Mlen, Qlen, Module, Other, Messgaes}) ->
%% 							if 	is_atom(RegName) -> 
%% 									lists:concat(['        ','regname:[', RegName, erlang:pid_to_list(Pid), 
%% 												  '],q:[', Qlen ,
%% 												  '],m:[', Mlen ,
%% 												  '],i:[', Other ,
%% 												  Messgaes ,
%% 												  ']\t\n']);
%% 								is_atom(Module) ->
%% 									lists:concat(['        ','module:[', Module, erlang:pid_to_list(Pid), 
%% 												  '],q:[', Qlen ,
%% 												  '],m:[', Mlen ,
%% 												  '],i:[', Other ,
%% 												  Messgaes ,
%% 												  ']\t\n']);
%% 								true ->
%% 									lists:concat(['        ','pid:[', erlang:pid_to_list(Pid) ,
%% 												  '],q:[', Qlen ,
%% 												  '],m:[', Mlen ,
%% 												  '],i:[', Other ,
%% 												  Messgaes ,
%% 												  ']\t\n'])
%% 							end	
%% 						end,
%% 					Process_queue_List),
%% 					lists:concat(['    Message_queue_top5: [', Process_queue_List_len, ' only processes being monitored', ']\t\n',Info_process_queue_list]);
%% 				_ ->
%% 					lists:concat(['    Message_queue_top5: [error_1]\t\n'])
%% 			end
%% 		catch
%% 			_:_ -> lists:concat(['    Message_queue_top5: [error_2]\t\n'])
%% 		end,
%% 	
%% 	Info_process_memory_top = 
%% 		try
%% 			case get_process_info(Process_info_detail, 5, 0, 0, memory) of 
%% 				{ok, Process_memory_List, Process_memory_List_len} ->
%% 					Info_process_memory_list = 
%% 					lists:map( 
%% 	  					fun({Pid, RegName, Mlen, Qlen, Module, Other, _Messgaes}) ->
%% 							if 	is_atom(RegName) -> 
%% 									lists:concat(['        ','regname:[', RegName, erlang:pid_to_list(Pid), 
%% 												  '],q:[', Qlen ,
%% 												  '],m:[', Mlen ,
%% 												  '],i:[', Other ,
%% 												  ']\t\n']);
%% 								is_atom(Module) ->
%% 									lists:concat(['        ','module:[', Module, erlang:pid_to_list(Pid), 
%% 												  '],q:[', Qlen ,
%% 												  '],m:[', Mlen ,
%% 												  '],i:[', Other ,
%% 												  ']\t\n']);
%% 								true ->
%% 									lists:concat(['        ','pid:[', erlang:pid_to_list(Pid) ,
%% 												  '],q:[', Qlen ,
%% 												  '],m:[', Mlen ,
%% 												  '],i:[', Other ,
%% 												  ']\t\n'])
%% 							end	
%% 						end,
%% 					Process_memory_List),
%% 					lists:concat(['    Process_memory_top5: [', Process_memory_List_len,' only processes being monitored', ']\t\n',Info_process_memory_list]);
%% 				_ ->
%% 					lists:concat(['    Message_memory_top5: [error_1]\t\n'])
%% 			end
%% 		catch
%% 			_:_ -> lists:concat(['    Message_memory_top5: [error_2]\t\n'])
%% 		end,
%% 
%% 	System_process_info = 
%% 		try
%% 			lists:concat(["    System process: \t\n",
%% 						 "        ",
%% 						 "process_count:[", erlang:system_info(process_count) ,'],',
%% 						 "processes_limit:[", erlang:system_info(process_limit) ,'],',
%% 						 "ports_count:[", length(erlang:ports()),']',
%% 						 "\t\n"
%% 						])
%% 		catch
%% 			_:_ -> []
%% 		end,
%% 
%% %% 		   total = processes + system
%% %%         processes = processes_used + ProcessesNotUsed
%% %%         system = atom + binary + code + ets + OtherSystem
%% %%         atom = atom_used + AtomNotUsed
%% %% 
%% %%         RealTotal = processes + RealSystem
%% %%         RealSystem = system + MissedSystem
%% 	
%% 	System_memory_info = 
%% 		try
%% 			lists:concat(["    System memory: \t\n",
%% 						 "        ",
%% 						 "total:[", erlang:memory(total) ,'],',
%% 						 "processes:[", erlang:memory(processes) ,'],',
%% 						 "processes_used:[", erlang:memory(processes_used) ,'],\t\n',
%% 						 "        ",
%% 						 "system:[", erlang:memory(system) ,'],',
%% 						 "atom:[", erlang:memory(atom) ,'],',
%% 						 "atom_used:[", erlang:memory(atom_used) ,'],\t\n',
%% 						 "        ",
%% 						 "binary:[", erlang:memory(binary) ,'],',
%% 						 "code:[", erlang:memory(code) ,'],',
%% 						 "ets:[", erlang:memory(ets) ,']',
%% 						 "\t\n"
%% 						])
%% 		catch
%% 			_:_ -> []
%% 		end,
%% 
%% 	System_other_info = 
%% 		try
%% 			System_load = mod_disperse:get_system_load(),
%% 			{{input,Input},{output,Output}} = statistics(io),
%% 			
%% 			lists:concat(["    System other: \t\n",
%% 						 "        ",
%% 						 "run_queue:[", statistics(run_queue) ,'],',
%% 						 "input:[", Input ,'],',
%% 						 "output:[", Output ,'],',
%% 						 "wallclock_time:[", io_lib:format("~.f", [System_load]) ,'],',						  
%% 						 "\t\n"
%% 						])
%% 		catch
%% 			_:_ -> []
%% 		end,	
%% 
%% 	Info_mod_guild =	
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_guild ,'$3'}) of
%% 				[[GuildPid, _]] ->
%% 					['    Mod_guild here? [yes]. Pid:[',erlang:pid_to_list(GuildPid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]   %%['    Mod_guild here? [no].', '\t\n']				
%% 			end),	
%% 
%% 	Info_mod_sale =	
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_sale ,'$3'}) of
%% 				[[SalePid, _]] ->
%% 					['    Mod_sale here? [yes]. Pid:[',erlang:pid_to_list(SalePid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]    %%['    Mod_sale here? [no].', '\t\n']				
%% 			end),
%% 
%% 	Info_mod_rank =	
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_rank ,'$3'}) of
%% 				[[RankPid, _]] ->
%% 					['    Mod_rank here? [yes]. Pid:[',erlang:pid_to_list(RankPid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]   %%['    Mod_rank here? [no].', '\t\n']				
%% 			end),
%% 	
%% 	Info_mod_delayer =	
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_delayer ,'$3'}) of
%% 				[[DelayerPid, _]] ->
%% 					['    Mod_delayer here? [yes]. Pid:[',erlang:pid_to_list(DelayerPid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]   %%['    Mod_rank here? [no].', '\t\n']				
%% 			end),
%% 
%% 	Info_mod_shop =	
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_shop ,'$3'}) of
%% 				[[ShopPid, _]] ->
%% 					['    Mod_shop here? [yes]. Pid:[',erlang:pid_to_list(ShopPid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]   %%['    Mod_shop here? [no].', '\t\n']				
%% 			end),
%% 	
%% 	Info_mod_master_apprentice = 
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_master_apprentice ,'$3'}) of
%% 				[[MasterPid, _]] ->
%% 					['    Mod_master_apprentice here? [yes]. Pid:[',erlang:pid_to_list(MasterPid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]   %%['    Mod_master_apprentice here? [no].', '\t\n']				
%% 			end),		
%% 
%% 	Info_mod_dungeon_analytics = 
%% 		lists:concat(
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_dungeon_analytics ,'$3'}) of
%% 				[[DungeonAlyPid, _]] ->
%% 					['    Mod_dungeon_analytics here? [yes]. Pid:[',erlang:pid_to_list(DungeonAlyPid),
%% 					 		']\t\n'];
%% 				_ ->
%% 					[]   %%['    Mod_dungeon_analytics here? [no].', '\t\n']				
%% 			end),	
%% 	
%% 	Info_scene = 
%% 		try 
%% 			case ets:info(?ETS_MONITOR_PID) of
%% 				undefined ->
%% 					[];
%% 				_ ->
%% 					Stat_list_scene = ets:match(?ETS_MONITOR_PID,{'$1', mod_scene ,'$3'}),
%% 					Stat_info_scene = 
%% 					lists:map( 
%% 	  					fun(Stat_data) ->
%% 							case Stat_data of				
%% 								[_SceneAgentPid, {SceneId, Worker_Number}] ->
%% 									MS = ets:fun2ms(fun(T) when T#player.scn == SceneId  -> 
%% 												[T#player.id] 
%% 												end),
%% 									Players = ets:select(?ETS_ONLINE_SCENE, MS),
%% 									lists:concat([SceneId,'(', Worker_Number ,')_', length(Players), ', ']);
%% 								_->
%% 									''
%% 							end 
%% 	  					end, 
%% 						Stat_list_scene),
%% 					case Stat_list_scene of
%% 						[] -> [];
%% 						_ -> lists:concat(['    Scene here: [',Stat_info_scene,']\t\n'])
%% 					end
%% 			end
%% 		catch
%% 			_:_ -> []
%% 		end,
%% 	
%% 	Info_dungeon = 
%% 		try
%% 			case ets:info(?ETS_MONITOR_PID) of
%% 				undefined ->
%% 					[];
%% 				_ ->
%% 					Stat_list_dungeon = ets:match(?ETS_MONITOR_PID,{'$1', mod_dungeon ,'$3'}),
%% 					Stat_info_dungeon = 
%% 					lists:map( 
%% 	  					fun(Stat_data) ->
%% 							case Stat_data of				
%% 								[_,{{_,Dungeon_scene_id, Scene_id, _, Dungeon_role_list,_ ,_, _ }}] ->
%% 									lists:concat([Scene_id,'(',Dungeon_scene_id,')','_', length(Dungeon_role_list), ', ']);
%% 								_->
%% 									''
%% 							end 
%% 	  					end, 
%% 						Stat_list_dungeon),
%% 					case Stat_list_dungeon of
%% 						[] -> [];
%% 						_ -> lists:concat(['    Dungeon here: [',Stat_info_dungeon,']\t\n'])
%% 					end			
%% 			end
%% 		catch
%% 			_:_ -> []
%% 		end,	
%% 
%% 	lists:concat([Info_log_level, 
%% 				Info_mod_guild, Info_mod_sale, Info_mod_rank, Info_mod_delayer, Info_mod_shop, Info_mod_master_apprentice,
%% 				Info_mod_dungeon_analytics, 
%% 				Info_scene, Info_dungeon, 
%% 				Info_tcp_listener, Info_stat_socket,
%% 				Info_mysql, Info_mongo, Info_mongom_slave, Info_stat_db, 
%% 				Info_process_queue_top, Info_process_memory_top, 
%% 				System_process_info, System_memory_info, System_other_info,
%% 				'------------------------------------------------------------------------\t\n']).
%% 
%% get_process_info(Process_info_detail, Top, MinMsgLen, MinMemSize, OrderKey) ->
%% 	case Process_info_detail of
%% 		{ok, RsList} ->
%% 			Len = erlang:length(RsList),
%% 			FilterRsList = 
%% 			case OrderKey of 
%% 				msglen ->
%% 					lists:filter(fun({_,_,_,Qlen,_,_,_}) -> Qlen >= MinMsgLen end, RsList);
%% 				memory ->
%% 					lists:filter(fun({_,_,Qmem,_,_,_,_}) -> Qmem >= MinMemSize end, RsList);
%% 				_ ->
%% 					lists:filter(fun({_,_,_,Qlen,_,_,_}) -> Qlen >= MinMsgLen end, RsList)
%% 			end,
%% 			RsList2 = 
%% 				case OrderKey of
%% 					msglen ->
%% 						lists:sort(fun({_,_,_,MsgLen1,_,_,_},{_,_,_,MsgLen2,_,_,_}) -> MsgLen1 > MsgLen2 end, FilterRsList);
%% 					memory ->
%% 						lists:sort(fun({_,_,MemSize1,_,_,_,_},{_,_,MemSize2,_,_,_,_}) -> MemSize1 > MemSize2 end, FilterRsList);
%% 					_ ->
%% 						lists:sort(fun({_,_,_,MsgLen1,_,_,_},{_,_,_,MsgLen2,_,_,_}) -> MsgLen1 > MsgLen2 end, FilterRsList)
%% 				end,
%% 			NewRsList = 
%% 				if Top =:= 0 ->
%% 					   RsList2;
%% 				   true ->
%% 					   if erlang:length(RsList2) > Top ->
%% 							  lists:sublist(RsList2, Top);
%% 						  true ->
%% 							  RsList2
%% 					   end
%% 				end,
%% 			{ok,NewRsList, Len};
%% 		_->
%% 			{error,'error'}
%% 	end.

get_process_info_detail_list(Process, NeedModule, Layer) ->
	RootPid =
		if erlang:is_pid(Process) ->
			   Process;
		   true ->
			   case misc:whereis_name({local, Process}) of
				   undefined ->
					   error;
				   ProcessPid ->
					   ProcessPid
			   end
		end,
	case RootPid of
		error ->
			{error,lists:concat([Process," is not process reg name in the ", node()])};
		_ ->
			AllPidList = misc:get_process_all_pid(RootPid,Layer),
			RsList = misc:get_process_info_detail(NeedModule, AllPidList,[]),
			{ok, RsList}
	end.

get_monitor_process_info_list() ->
	Monitor_process_info_list =	
		try
			case ets:match(?ETS_MONITOR_PID,{'$1','$2','$3'}) of
				List when is_list(List) ->
					lists:map(
					  	fun([Pid, Module, Pars]) ->
							get_process_status({Pid, Module, Pars})
						end,
						List);	 
				_ ->
					[]
			end
		catch
			_:_ -> []
		end,			
	{ok, Monitor_process_info_list}.

%% get_process_status({Pid, Module, Pars}) when Module =/= mcs_role_send ->
%% 	{'', '', -1, -1, '', '', ''};
get_message_queue_len(Pid) ->
	try 
	    case erlang:process_info(Pid, [message_queue_len]) of
			[{message_queue_len, Qlen}] ->	Qlen;
			 _ -> -1
		end
	catch 
		_:_ -> -2
	end.

get_process_status({Pid, Module, _Pars}) ->
%% 	Other = 
%% 		case Module of
%% 			mod_player -> 
%% 				{PlayerId} = Pars,
%% 				lists:concat([PlayerId]);
%% %% 			
%% %% 				{#role_send_state{roleid = Roleid,  client_ip = {P1,P2,P3,P4}, 
%% %% 							rolepid = RolePid, accountpid = AccountPid, 
%% %% 							role_status = Role_status, account_status = Account_status,	  
%% %% 							start_time = StartTime, now_time = CheckTime,priority =Priority,
%% %% 							canStopCount = CanStopCount, lastMsgLen = LastMsgLen,  getMsgError = GetMsgError
%% %% 							}} = Pars,
%% %% 				lists:concat([Roleid,'/',P1,'.',P2,'.',P3,'.',P4,'/',mcs_misc:time_format( StartTime)
%% %% 							,'/',mcs_misc:time_format( CheckTime)
%% %% 							,'/',CanStopCount
%% %% 							,',', LastMsgLen
%% %% 							,',', GetMsgError
%% %% 							,',', Priority
%% %%  							,'/',erlang:is_process_alive(Pid)
%% %% 							,'/R', erlang:pid_to_list(RolePid), '[',Role_status,']_', erlang:is_process_alive(RolePid), '_', get_message_queue_len(RolePid)
%% %% 							,'/A', erlang:pid_to_list(AccountPid), '[',Account_status,']_', erlang:is_process_alive(AccountPid), '_', get_message_queue_len(AccountPid)
%% %% 							]);
%% 			_->
%% 				''
%% 		end,
%% 	Other = %%根据刘哥的方案修改,只处理mod_player----xiaomai
%% 		case Module of
%% 			mod_player -> 
%% 				{PlayerId} = Pars,
%% 				Dic = erlang:process_info(Pid,[dictionary]),
%% 				[{_, Dic1}] = Dic,
%% 				case lists:keyfind(last_msg, 1, Dic1) of 
%% 					{last_msg, Last_msg} -> 
%% 						lists:concat([PlayerId, "__", io_lib:format("~p", Last_msg)]);
%% 					_-> lists:concat([PlayerId])
%% 				end;
%% 			_ ->
%% 				''
%% 		end,
	Other = '',%%去掉last_msg的进程字典，此处修改
	
	try 
	 case erlang:process_info(Pid, [message_queue_len,memory,registered_name, messages]) of
		[{message_queue_len,Qlen},{memory,Mlen},{registered_name, RegName},{messages, _MessageQueue}] ->
			Messages = '',
%% 			if length(MessageQueue) > 0, Module == mod_player ->
%% 				   Message_Lists = 
%% 				   lists:map(
%% 					 fun({Mclass, Mbody}) ->
%% 							 if is_tuple(Mbody) ->
%% %% 									[Mtype] = lists:sublist(tuple_to_list(Mbody),1),
%% 									[Mtype, Module1, Method1] = lists:sublist(tuple_to_list(Mbody),3),
%% 							 		lists:concat(['            <'
%% 												 ,Mclass,
%% 												 ', ' ,Mtype,
%% 												 ', ',binary_to_list(Module1), 
%% 												 ', ',binary_to_list(Method1),
%% 												 '>\t\n']);
%% 							   true ->
%% 									lists:concat(['            <',Mclass,'>\t\n'])
%% 							 end
%% 					 end,
%% 				   lists:sublist(MessageQueue,5)),				   
%% 				   lists:concat(['/\t\n',Message_Lists,'            ']);
%% 			   true -> ''
%% 			end,
			{Pid, RegName, Mlen, Qlen, Module, Other, Messages};
		_ -> 
			{'', '', -1, -1, '', '', ''}
	 end
	catch 
		_:_ -> {'', '', -1, -1, '', '', ''}
	end.


%% ===================针对玩家的各类操作=====================================
operate_to_player(Module, Method, Args) ->
    F = fun(S)->  
%% 			io:format("node__/~p/ ~n",[[S, Module, Method, Args]]),	
			rpc:cast(S#server.node, Module, Method, Args)
    	end,
    [F(S) || S <- ets:tab2list(?ETS_SERVER)],
	ok.

%% 取得本节点的角色状态
get_player_info_local(Id) ->
	case ets:lookup(?ETS_ONLINE, Id) of
   		[] -> [];
   		[R] ->
       		case misc:is_process_alive(R#player.other#player_other.pid) of
           		false -> [];		
           		true -> R
       		end
	end.

%% 设置禁言 或 解除禁言
donttalk(Id, Stop_minutes) ->
	case get_player_info_local(Id) of
		[] -> no_action;
		Player ->
			if Stop_minutes > 0 ->
				Stop_begin_time = util:unixtime(),
				Stop_chat_seconds = Stop_minutes*60,
				gen_server:cast(Player#player.other#player_other.pid, 
								{set_donttalk, Stop_begin_time, Stop_chat_seconds}),
				db_agent:update_donttalk_status(Id, Stop_begin_time, Stop_chat_seconds),
				ok;
			Stop_minutes == 0 ->
				gen_server:cast(Player#player.other#player_other.pid, {set_donttalk, 0, 0}),		
                db_agent:update_donttalk_status(Id, 0, 0);
		    true ->
                skip
			end
	end.

%% 踢人下线
kickuser(Id) ->
	case get_player_info_local(Id) of
		[] -> no_action;
		Player ->	
    		mod_login:logout(Player#player.other#player_other.pid, 2)		
	end.

%% 封/开角色
banrole(Id, Action) ->
	case get_player_info_local(Id) of
		[] -> no_action;	
		Player ->
			if Action == 1 ->
				gen_server:cast(Player#player.other#player_other.pid,{'SET_PLAYER', [{stts,1}]}),
    			mod_login:logout(Player#player.other#player_other.pid, 3);
			   true ->
				   skip
			end
	end.	

%% 封/开账号
banaccount(Accid, Action) ->
    case db_agent_player:get_playerid_by_accountid(Accid) of
        [] ->
            false;
        Id ->
			case get_player_info_local(Id) of
				[] -> no_action;	
				Player ->
					if Action == 1 ->
						   mod_login:logout(Player#player.other#player_other.pid, 4);
	   					true -> no_action
					end
			end
	end.

%% %% 通知客户端增减金钱
%% notice_change_money(Id, Action) ->
%% 	try
%% 		case get_player_info_local(Id) of
%% 			[] -> no_action;
%% 			Player ->			
%% 				[Val1, Val2, Val3, Val4] = string:tokens(Action, "_"),
%% 				Field = case Val1 of
%% 						"gold"  -> 1;
%% 						"coin"  -> 2;
%% 						"cash"  -> 3;
%% 						"bcoin" -> 4;
%% 						_ ->0
%% 					end,
%% 				Optype = case Val2 of
%% 						"add"  -> 1;
%% 						"sub"  -> 2;
%% 						_ ->0
%% 					end,
%% 				Value = list_to_integer(Val3),
%% 				Source = list_to_integer(Val4),
%% 				if Field =/=0, Optype =/=0, Value =/=0 ->
%% 						gen_server:cast(Player#player.other#player_other.pid, {'CHANGE_MONEY', [Field, Optype, Value, Source]});
%% 		 	 		true -> no_action
%% 				end
%% 		end
%% 	catch
%% 		_:_ -> error
%% 	end.
change_money(PlayerId) ->
	lib_vip:set_viplv_offline(PlayerId),
	case lib_player:is_online(PlayerId) of
		false ->
			ok;
%% 			lib_vip:set_viplv_offline(PlayerId);
		_ ->
			PGid  = lib_player:get_player_pid(PlayerId),
			gen_server:cast(PGid, {handle_vip})
	end.












%% 
%% %% 发送通知给玩家
%% notice_to_player(NoticeId) ->
%% 	try
%% 		case db_agent_notice:select_unread_notice_by_key(NoticeId) of
%% 			[] ->
%% 				skip ;
%% 			Notice ->
%% 				case Notice#ets_notice.type > 0 of
%% 					true ->           %% 处理邮件
%% 						lib_notice:mail_to_one(exists, Notice#ets_notice.uid,NoticeId, 1,Notice#ets_notice.type,Notice#ets_notice.cntt) ;
%% 					false ->          %% 处理通知
%% 						NList = [{Notice#ets_notice.id,
%% 						  Notice#ets_notice.claz,
%% 						  Notice#ets_notice.exp,
%% 						  Notice#ets_notice.eng,
%% 						  Notice#ets_notice.gold,
%% 						  Notice#ets_notice.coin,
%% 						  Notice#ets_notice.prstg,
%% 						  util:bitstring_to_term(Notice#ets_notice.goods),
%% 						  Notice#ets_notice.cntt}] ,
%% 						lib_notice:notice_to_one(Notice#ets_notice.uid,NList)
%% 				end
%% 		end
%% 	catch
%% 		_:_ ->
%% 			error
%% 	end.
%% 	
%% 安全退出游戏服务器
%% safe_quit(Node) ->
%% %% 	mod_theater:theater_save(),
%% 
%% 	timer:sleep(10 * 1000),
%% 	
%% 	game_gateway:server_stop(),
%% 	case Node of
%% 		[] -> 
%% %% 			mod_theater:out_ter(),
%% %% 			mod_relationship:out_ter(),
%% 			mod_disperse:stop_game_server(ets:tab2list(?ETS_SERVER));
%% 		_ ->
%% 			rpc:cast(tool:to_atom(Node), main, server_stop, [])
%% 	end,
%% 	ok.

%% 安全退出当前游戏服务器(在游戏服务器节点执行)
safe_quit() ->
	timer:sleep(10 * 1000),
%% 	game_gateway:server_stop(),
    mod_guild:safe_quit(),
	main:server_stop(),
	ok.

%% 网关发起维护服务器操作
stop_server(ServId) ->
	mod_disperse:stop_server(ServId) .

%% 动态撤节点
remove_nodes(NodeOrIp) ->
	case NodeOrIp of
		[] -> 
%% 			io:format("You Must Input Ip or NodeName!!!",[])
			skip ;
		_ ->
			NI_atom = tool:to_atom(NodeOrIp),
			NI_str = tool:to_list(NodeOrIp),
			case string:tokens(NI_str, "@") of
				[_, _] ->
					rpc:cast(NI_atom, main, server_remove, []);
				_ ->
					Server = nodes(),
					F = fun(S) ->
							case string:tokens(tool:to_list(S), "@") of
								[_Left, Right] when Right =:= NI_str ->
									rpc:cast(S, main, server_remove, []);
								_ ->
									ok
							end
						end,
					[F(S) || S <- Server]
			end
	end,
	ok.


%% 请求加载基础数据
load_base_data(Parm) ->
	Parm_1 = 
		case Parm of 
			[] -> [];
			_ -> [tool:to_atom(Parm)]
		end,
	mod_disperse:load_base_data(ets:tab2list(?ETS_SERVER), Parm_1),
	ok.

%% update_box_goods() ->
%% 	BoxPid = mod_box:get_mod_box_pid(),
%% 	gen_server:cast(BoxPid, {event, update_action}).






%% test_m() ->
%% 	Process_info_detail = 
%% 		try
%% 			get_monitor_process_info_list()
%% 		catch
%% 			_:_ -> {ok, []} 
%% 		end,
%% 	{ok, L} = Process_info_detail,
%% 	Info_process_memory = 
%% 		try
%% 			case get_process_info(Process_info_detail, length(L), 0, 0, memory) of 
%% 				{ok, Process_memory_List, _Process_memory_List_len} ->
%% 					Info_process_memory_list = 
%% 					lists:map( 
%% 	  					fun({_Pid, _RegName, Mlen, _Qlen, _Module, _Other, _Messgaes}) -> 
%% 								Mlen
%% 						end,
%% 						Process_memory_List),
%% 					lists:sum(Info_process_memory_list);
%% 				_ ->
%% 					-1
%% 			end
%% 		catch
%% 			_:_ -> -2
%% 		end,
%% 	
%% 	Info_process_memory.

%%获取所有进程的cpu 内存 队列
get_nodes_cmq(_Node,Type)->
	L = mod_disperse:server_list(),
	Info_list0 =
		if
			L == [] ->
				[];
			true ->
					lists:map(
					  fun(S)  ->
								  case rpc:call(S#server.node,mod_disperse,get_nodes_cmq,[Type]) of
									  {badrpc,_}->
										  [];
									  GetList ->
										  GetList
								  end
					  end
					  ,L)
		end,
	
	try
		Info_list = lists:flatten(Info_list0),
		F_sort = fun(A,B)->					
						 {_,_,{_K1,V1}}=A,
						 {_,_,{_K2,V2}}=B,
						 V1 > V2
				 end,
		Sort_list = lists:sort(F_sort,Info_list),
		F_print = fun(Ls,Str) ->
			lists:concat([Str,tuple_to_list(Ls)])
		end,
		lists:foldl(F_print,[],Sort_list)
	catch _e:_e2 ->
			 %%file:write_file("get_nodes_cmq_err.txt",_e2)
			 ?DEBUG("_GET_NODES_CMQ_ERR:~p",[[_e,_e2]])
	end.

%%查进程信息	
get_porcess_info(Pid_list) ->
	L = mod_disperse:server_list(),
	Info_list0 =
		if
			L == [] ->
				[];
			true ->
				lists:map(
				  fun(S) ->
						  case rpc:call(S#server.node,mod_disperse,get_process_info,[Pid_list]) of
							  {badrpc,_} ->
								  [];
							  GetList ->
								  GetList
						  end
				  end
						 ,
				  L						 
				  )
		end,
	file:write_file("info_1.txt",Info_list0),
	Info_list = lists:flatten(Info_list0),
	F_print = fun(Ls,Str) ->
					  lists:concat([Str,Ls])
			  end,
	lists:foldl(F_print, [],Info_list).

close_nodes(Type) ->
	case Type of
		2 ->
			safe_quit();
		_ ->
			nodes()
	end.

%%新增或者修改常规礼品
change_com_gift(GiftId) ->
	L = mod_disperse:server_list(),
	if
		L == [] ->
			[];
		true ->
			lists:map(
			  fun(S) ->
					  case rpc:call(S#server.node,mod_notice,change_com_gift,[GiftId]) of
						  {badrpc,_} ->
							  [];
						  _ ->
							  []
					  end
			  end,
			  L)
	end.

%%删除常规礼品
delete_com_gift(GiftId) ->
	L = mod_disperse:server_list(),
	if
		L == [] ->
			[];
		true ->
			lists:map(
			  fun(S) ->
					  case rpc:call(S#server.node,mod_notice,delete_com_gift,[GiftId]) of
						  {badrpc,_} ->
							  [];
						  _ ->
							  []
					  end
			  end,
			  L)
	end.

%%检查gateway是否能连上
chk_gw_cnt() ->
	NoteList = nodes(),
	lists:any(fun(Node) ->
					  case re:run(atom_to_list(Node), "gate", [caseless]) of
						  nomatch -> false;
						  _-> true
					  end
			  end, NoteList).

%%检查配置数据, 仅用于辅助检查配置数据
check_base_tables() ->
	goods_util:check_table_base_goods_suit(),
	goods_util:check_table_base_holiday_goods(),
	goods_util:check_table_base_goods(),
	lib_mon:check_table_base_mon(),
	lib_mon:check_table_base_mongroup(),
	lib_task:check_table_base_task(),
	lib_pet2:check_table_base_pet(),
	lib_giant_s:check_table_base_giant(),
	lib_dungeon:check_table_base_dungeon(),
	lib_elite:check_table_base_elite(),
	lib_target:check_table_base_target(),
	lib_team:check_table_base_team_dungeon(),
	ok.
	
