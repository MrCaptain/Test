-module(tool).

-compile(export_all).


%% 分割列表的函数
split(N,SrcList) ->
	case length(SrcList) > N of
		true ->
			lists:split(N,SrcList) ;
		false ->
			{SrcList,[]}
	end.



%% @doc get IP address string from Socket
ip(Socket) ->
  	{ok, {IP, _Port}} = inet:peername(Socket),
  	{Ip0,Ip1,Ip2,Ip3} = IP,
	list_to_binary(integer_to_list(Ip0)++"."++integer_to_list(Ip1)++"."++integer_to_list(Ip2)++"."++integer_to_list(Ip3)).


%% @doc quick sort
sort([]) ->
	[];
sort([H|T]) -> 
	sort([X||X<-T,X<H]) ++ [H] ++ sort([X||X<-T,X>=H]).

%% for
for(Max,Max,F)->[F(Max)];
for(I,Max,F)->[F(I)|for(I+1,Max,F)].

%%---------------------------------------------------
%%给列表中元素加下标  by chenzm 
%%@spec for(n,m,fun()) -> [] 
%%---------------------------------------------------
add_index([]) ->
	[] ;
add_index(List) ->
	for(1,length(List),fun(I) ->
							   Elem = lists:nth(I,List),
							   if
								   is_tuple(Elem) ->
									   list_to_tuple([I] ++ tuple_to_list(Elem)) ;
								   true ->
									   {I,Elem} 
							   end 
		  				end).
add_index_to_record(List) ->
	case List of
		[] ->
			[] ;
		_ ->
			for(1,length(List),fun(I) ->
							   Elem = lists:nth(I,List),
							   {I,Elem}
		  				end)
	end.


%% @doc convert float to string,  f2s(1.5678) -> 1.57
f2s(N) when is_integer(N) ->
    integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
    [A] = io_lib:format("~.2f", [F]),
	A.


%% @doc convert other type to atom
to_atom(Msg) when is_atom(Msg) -> 
	Msg;
to_atom(Msg) when is_binary(Msg) -> 
	tool:list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) -> 
    tool:list_to_atom2(Msg);
to_atom(_) -> 
    throw(other_value).  %%list_to_atom("").

%% @doc convert other type to list
to_list(Msg) when is_list(Msg) -> 
    Msg;
to_list(Msg) when is_atom(Msg) -> 
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) -> 
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) -> 
    integer_to_list(Msg);
to_list(Msg) when is_float(Msg) -> 
    f2s(Msg);
to_list(_) ->
    throw(other_value).

%% @doc convert other type to binary
to_binary(Msg) when is_binary(Msg) -> 
    Msg;
to_binary(Msg) when is_atom(Msg) ->
	list_to_binary(atom_to_list(Msg));
	%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) -> 
	list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) -> 
	list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) -> 
	list_to_binary(f2s(Msg));
to_binary(_Msg) ->
    throw(other_value).

%% @doc convert other type to float
to_float(Msg)->
	Msg2 = to_list(Msg),
	list_to_float(Msg2).

%% @doc convert other type to integer
%% -spec to_integer(Msg :: any()) -> integer().       %%liujing 2012-8-9 cancel
to_integer(Msg) when is_integer(Msg) -> 
    Msg;
to_integer(Msg) when is_binary(Msg) ->
	Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) -> 
    list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) -> 
    round(Msg);
to_integer(_Msg) ->
    throw(other_value).

to_bool(D) when is_integer(D) ->
	D =/= 0;
to_bool(D) when is_list(D) ->
	length(D) =/= 0;
to_bool(D) when is_binary(D) ->
	to_bool(binary_to_list(D));
to_bool(D) when is_boolean(D) ->
	D;
to_bool(_D) ->
	throw(other_value).

%% @doc convert other type to tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) -> {T}.

%% @doc get data type {0=integer,1=list,2=atom,3=binary}
get_type(DataValue,DataType)->
	case DataType of
		0 ->
			DataValue2 = binary_to_list(DataValue),
			list_to_integer(DataValue2);
		1 ->
			binary_to_list(DataValue);
		2 ->
			DataValue2 = binary_to_list(DataValue),
			list_to_atom(DataValue2);
		3 -> 
			DataValue
	end.

%% @spec is_string(List)-> yes|no|unicode  
is_string([]) -> yes;
is_string(List) -> is_string(List, non_unicode).

is_string([C|Rest], non_unicode) when C >= 0, C =< 255 -> is_string(Rest, non_unicode);
is_string([C|Rest], _) when C =< 65000 -> is_string(Rest, unicode);
is_string([], non_unicode) -> yes;
is_string([], unicode) -> unicode;
is_string(_, _) -> no.



%% @doc get random list
list_random(List)->
	case List of
		[] ->
			{};
		_ ->
			RS			=	lists:nth(random:uniform(length(List)), List),
			ListTail	= 	lists:delete(RS,List),
			{RS,ListTail}
	end.

%% @doc get a random integer between Min and Max
random(Min,Max)->
	Min2 = Min-1,
	random:uniform(Max-Min2)+Min2.

%% @doc 掷骰子
random_dice(Face,Times)->
	if
		Times == 1 ->
			random(1,Face);
		true ->
			lists:sum(for(1,Times, fun(_)-> random(1,Face) end))
	end.

%% @doc 机率
odds(Numerator, Denominator)->
	Odds = random:uniform(Denominator),
	if
		Odds =< Numerator -> 
			true;
		true ->
			false
	end.

odds_list(List)->
	Sum = odds_list_sum(List),
	odds_list(List,Sum).
odds_list([{Id,Odds}|List],Sum)->
	case odds(Odds,Sum) of
		true ->
			Id;
		false ->
			odds_list(List,Sum-Odds)
	end.
odds_list_sum(List)->
	{_List1,List2} = lists:unzip(List),
	lists:sum(List2).


%% @doc 取整 大于X的最小整数
ceil(X) ->
    T = trunc(X),
	if 
		X - T == 0 ->
			T;
		true ->
			if
				X > 0 ->
					T + 1;
				true ->
					T
			end			
	end.


%% @doc 取整 小于X的最大整数
floor(X) ->
    T = trunc(X),
	if 
		X - T == 0 ->
			T;
		true ->
			if
				X > 0 ->
					T;
				true ->
					T-1
			end
	end.
%% 4舍5入
%% round(X)

%% subatom
subatom(Atom,Len)->	
	list_to_atom(lists:sublist(atom_to_list(Atom),Len)).

%% @doc 暂停多少毫秒
sleep(Msec) ->
	receive
		after Msec ->
			true
	end.

md5(S) ->        
	Md5_bin =  erlang:md5(S), 
    Md5_list = binary_to_list(Md5_bin), 
    lists:flatten(list_to_hex(Md5_list)). 
 
list_to_hex(L) -> 
	lists:map(fun(X) -> int_to_hex(X) end, L). 
 
int_to_hex(N) when N < 256 -> 
    [hex(N div 16), hex(N rem 16)]. 
hex(N) when N < 10 -> 
       $0+N; 
hex(N) when N >= 10, N < 16 ->      
	$a + (N-10).

list_to_atom2(List) when is_list(List) ->
	case catch(list_to_existing_atom(List)) of
		{'EXIT', _} -> erlang:list_to_atom(List);
		Atom when is_atom(Atom) -> Atom
	end.
	
combine_lists(L1, L2) ->
	Rtn = 
	lists:foldl(
		fun(T, Acc) ->
			case lists:member(T, Acc) of
				true ->
					Acc;
				false ->
					[T|Acc]
			end
		end, lists:reverse(L1), L2),
	lists:reverse(Rtn).


get_process_info_and_zero_value(InfoName) ->
	PList = erlang:processes(),
	ZList = lists:filter( 
		fun(T) -> 
			case erlang:process_info(T, InfoName) of 
				{InfoName, 0} -> false; 
				_ -> true 	
			end
		end, PList ),
	ZZList = lists:map( 
		fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
		end, ZList ),
	[ length(PList), InfoName, length(ZZList), ZZList ].

get_process_info_and_large_than_value(InfoName, Value) ->
	PList = erlang:processes(),
	ZList = lists:filter( 
		fun(T) -> 
			case erlang:process_info(T, InfoName) of 
				{InfoName, VV} -> 
					if VV >  Value -> true;
						true -> false
					end;
				_ -> true 	
			end
		end, PList ),
	ZZList = lists:map( 
		fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
		end, ZList ),
	[ length(PList), InfoName, Value, length(ZZList), ZZList ].

get_msg_queue() ->
	io:fwrite("process count:~p~n~p value is not 0 count:~p~nLists:~p~n", 
				get_process_info_and_zero_value(message_queue_len) ).

get_memory() ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
				get_process_info_and_large_than_value(memory, 1048576) ).

get_memory(Value) ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
				get_process_info_and_large_than_value(memory, Value) ).

get_heap() ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
				get_process_info_and_large_than_value(heap_size, 1048576) ).

get_heap(Value) ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
				get_process_info_and_large_than_value(heap_size, Value) ).

get_processes() ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
	get_process_info_and_large_than_value(memory, 0) ).


list_to_term(String) ->
	{ok, T, _} = erl_scan:string(String++"."),
	case erl_parse:parse_term(T) of
		{ok, Term} ->
			Term;
		{error, Error} ->
			Error
	end.


substr_utf8(Utf8EncodedString, Length) ->
	substr_utf8(Utf8EncodedString, 1, Length).
substr_utf8(Utf8EncodedString, Start, Length) ->
	ByteLength = 2*Length,
	Ucs = xmerl_ucs:from_utf8(Utf8EncodedString),
	Utf16Bytes = xmerl_ucs:to_utf16be(Ucs),
	SubStringUtf16 = lists:sublist(Utf16Bytes, Start, ByteLength),
	Ucs1 = xmerl_ucs:from_utf16be(SubStringUtf16),
	xmerl_ucs:to_utf8(Ucs1).

ip_str(IP) ->
	case IP of
		{A, B, C, D} ->
			lists:concat([A, ".", B, ".", C, ".", D]);
		{A, B, C, D, E, F, G, H} ->
			lists:concat([A, ":", B, ":", C, ":", D, ":", E, ":", F, ":", G, ":", H]);
		Str when is_list(Str) ->
			Str;
		_ ->
			[]
	end.

%%对正负进行调整：负数变为0，正数保持不变
int_format(Num) ->
	if Num >= 0 ->
		   Num;
	   true ->
		   0
	end.

%%去掉字符串空格
remove_string_black(L) ->
	F = fun(S) ->
				if S == 32 -> [];
				   true -> S
				end
		end,
	Result = [F(lists:nth(I,L)) || I <- lists:seq(1,length(L))],
	lists:filter(fun(T) -> T =/= [] end,Result).
	

%%获取协议操作的时间戳，true->允许；false -> 直接丢弃该条数据
%%spec is_operate_ok/1 param: Type -> 添加的协议类型(atom); return: true->允许；false -> 直接丢弃该条数据
is_operate_ok(Type, TimeStamp) ->
	NowTime = util:unixtime(),
	case get(Type) of
		undefined ->
			put(Type, NowTime),
    		true;
		Value ->
			case (NowTime - Value) >= TimeStamp of
				true ->
					put(Type, NowTime),
					true;
				false ->
					false
			end
	end.

%%打包字符串数据
pack_string(Str) ->
	StrBin = tool:to_binary(Str),
	Len = byte_size(StrBin),
	{Len, StrBin}.

%%对[{GetName, Rate},..]结构类型的单项随机获取的通用处理,空列表返回undefined
get_rand_single(RateList) ->
	Fun = fun({_Tmp, R}, RNum) ->
				  RNum + R
		  end,
	AllR = lists:foldl(Fun, 0, RateList),
	GetRNum = util:rand(1, AllR),
	Fun1 = fun({Atom, Rat}, [BGet, Ra, FirstNum, GetAtom1]) ->
				   EndNum = FirstNum + Rat,
				   if BGet =:= 0 andalso Ra =< EndNum ->
						  [1, Ra, EndNum, Atom];
					  true ->
						  [BGet, Ra, EndNum, GetAtom1]
				   end
		   end,
	[_NewBGet, _NewRa, _FirstNum, GetAtom] = lists:foldl(Fun1, [0, GetRNum, 0, undefined], RateList),
	GetAtom.

%%对[{GetName, Rate, MinNum, MaxNum},..]结构类型的单项随机获取的通用处理,空列表返回undefined
get_rand_single2(RateList) ->
	Fun = fun({_Tmp, R, _Mn, _Mx}, RNum) ->
				  RNum + R
		  end,
	AllR = lists:foldl(Fun, 0, RateList),
	GetRNum = util:rand(1, AllR),
	Fun1 = fun({Atom, Rat, MinNum, MaxNum}, [BGet, Ra, FirstNum, GetAtom1]) ->
				   EndNum = FirstNum + Rat,
				   if BGet =:= 0 andalso Ra =< EndNum ->
						  [1, Ra, EndNum, {Atom, MinNum, MaxNum}];
					  true ->
						  [BGet, Ra, EndNum, GetAtom1]
				   end
		   end,
	[_NewBGet, _NewRa, _FirstNum, GetAtom] = lists:foldl(Fun1, [0, GetRNum, 0, undefined], RateList),
	GetAtom.


%%对单个玩家数据回档的操作函数======2012-9-17 from liujing======

%%获取需要处理的表名(返回字符串结构的表名)
get_handle_table_name() ->
	TableList = lib_player_rw:get_all_tables(),
	F = fun(TableName, GetList) ->
				TableName1 = util:term_to_string(TableName),
				case TableName1 =/= "cards"  andalso TableName1 =/= "sys_acm"  andalso string:str(TableName1,"admin") =/= 1 
					andalso TableName1 =/= "auto_ids" andalso TableName1 =/= "shop" andalso string:str(TableName1,"base") =/= 1 
					andalso TableName1 =/= "slaves" andalso TableName1 =/= "battle_cache_data" andalso string:str(TableName1,"arena") =/= 1 
					andalso string:str(TableName1,"log_") =/= 1 andalso string:str(TableName1,"th") =/= 1 
					andalso TableName1 =/= "rela"  of
					false -> GetList;
					true ->
						GetList ++ [util:string_to_term(tool:to_list(TableName1))]
				end
		end,
	lists:foldl(F, [], TableList).

ini_faraway_mongo_db(PoolId, Num) ->
	Host = 
		case Num of
			1 ->
				"113.105.250.125" ;
			2 ->
				"113.105.251.123" ;
			4 ->
				"183.61.130.69" ;
			_ ->
				%%连接内部192.168.51.174服务器
				"192.168.51.174"
		end,
%% 	Host = io:get_line("remote database ip:") ,
	Port = 27017,
	case Num of
		0 ->
			DB = "csj_dev_S1";
		_ ->
			DB = lists:concat(["csj_dev_S",Num])
	end,
	io:format("====dest db:~p~n",[[Host,DB]]) ,
	
	EmongoSize = 1,
	emongo_sup:start_link(),
	emongo_app:initialize_pools([PoolId, Host, Port, DB, EmongoSize]).

ini_local_mongo_db(PoolId, Num) ->
 	Host = "192.168.51.174",
%%  	Host = io:get_line("sorce database ip:") ,
	Port = 27017,
	case Num of
		0 ->
			DB = "csj_dev_src_S1";
		_ ->
			DB = lists:concat(["csj_dev_src_S",Num])
	end,
	io:format("====src db:~p~n",[DB]) ,
	EmongoSize = 1,
	emongo_sup:start_link(),
	emongo_app:initialize_pools([PoolId, Host, Port, DB, EmongoSize]).

get_mongo_to_mysql(UidList, ServerNum) ->
%% 	CONFIG_FILE = "../config/gateway.config",
	FarPoolId = lists:concat(["master_mongo_tmp", ServerNum]),
	LocalPoolId = "master_mongo_l",
	TableList = get_handle_table_name(),
	ini_faraway_mongo_db(FarPoolId, ServerNum),
	ini_local_mongo_db(LocalPoolId, ServerNum),
	Fun1 = fun(TableName, GetUid) ->
				   case TableName of
					   player ->
						   io:format("========_1_~n"),
						   [WhereOpertion,FieldOpertion] = db_mongoutil:make_select_opertion(db_mongo:transfer_fields(TableName, "*"), [{id, GetUid}], [], []),
						   L = emongo:find_all(LocalPoolId,tool:to_list(TableName),WhereOpertion,FieldOpertion),
						   io:format("========_1_~p~n",[L]),
						   RList = db_mongo:handle_all_result(TableName,db_mongo:transfer_fields(TableName,"*"), L),
						   [DelOpertion] = db_mongoutil:make_delete_opertion([{id, GetUid}]),
						   emongo:delete(FarPoolId, tool:to_list(TableName), DelOpertion),
						   case RList of
							   [] ->
								   GetUid;
							   _ ->
								   FieldList = db_mongo:get_all_fields(TableName),
								   Fun2 = fun(RL) ->
												  FullKeyValuelist = db_mongo:fullKeyValue(TableName,lists:zip(FieldList,RL)),
												  FullKeyValuelist1 = checkF(FullKeyValuelist),
												  Opertion = db_mongoutil:make_insert_opertion(FullKeyValuelist1),
  												  emongo:insert(FarPoolId,tool:to_list(TableName),Opertion)
										  end,
								   lists:foreach(Fun2, RList),
								   GetUid
						   end;
					   _ ->
						   io:format("========_3_[~p]~n", [TableName]),
						   FieldList = db_mongo:get_all_fields(TableName),
						   case FieldList of
							   undefined ->
								   GetUid;
							   [] ->
								   GetUid;
							   _ ->
								   [WhereOpertion,FieldOpertion] = db_mongoutil:make_select_opertion(db_mongo:transfer_fields(TableName, "*"), [{uid, GetUid}], [], []),
								   L = emongo:find_all(LocalPoolId,tool:to_list(TableName),WhereOpertion,FieldOpertion),
								  
								   RList = db_mongo:handle_all_result(TableName,db_mongo:transfer_fields(TableName,"*"), L),
								   [DelOpertion] = db_mongoutil:make_delete_opertion([{uid, GetUid}]),
								   emongo:delete(FarPoolId, tool:to_list(TableName), DelOpertion),
								   case RList of
									   [] ->
										   GetUid;
									   _ ->
										   Fun2 = fun(RL) ->
														  FullKeyValuelist = db_mongo:fullKeyValue(TableName,lists:zip(FieldList,RL)),
														  FullKeyValuelist1 = checkF(FullKeyValuelist),
														  Opertion = db_mongoutil:make_insert_opertion(FullKeyValuelist1),
														  emongo:insert(FarPoolId,tool:to_list(TableName),Opertion)
												  end,
										   lists:foreach(Fun2, RList),
										   GetUid
								   end
						   end
				   end
		   end,
	Fun = fun(Uid) ->
				  lists:foldl(Fun1, Uid, TableList)
		  end,
	lists:foreach(Fun, UidList).

checkF(KeyVList) ->
	Fun= fun({Key, Val}) ->
				 case Val of
					 [] ->
						 {Key, <<"[]">>};
					 undefined ->
						 {Key, <<"[]">>};
					 _ ->
						 {Key, Val}
				 end
		 end,
	lists:map(Fun, KeyVList).
				 
%%-------------------------- 合服所用函数 begin -------------------------------------------
%%检查player、user表的acid是否有序号范围外的
check_player_user_id(ServerNo) ->
	if
		ServerNo > 0 ->
			Start = ServerNo * 100000000,
			End   = (ServerNo+1) * 100000000,
			SmallPlayers = db_agent_tool:get_small_players(Start),			%%player.id小于合法值的
			BigPlayers   = db_agent_tool:get_big_players(End),				%%player.id大于合法值的
			SmallPlayers2 = db_agent_tool:get_small_players_acid(Start),	%%player.acid小于合法值的
			BigPlayers2   = db_agent_tool:get_big_players_acid(End),		%%player.acid大于合法值的
			SmallUsers = db_agent_tool:get_small_users(Start),				%%user.id小于合法值的
			BigUsers   = db_agent_tool:get_big_users(End),					%%user.id大于合法值的
			if
				SmallPlayers =/= [] ->
					Info = lists:concat(["Id SmallPlayers num:", length(SmallPlayers)]);
				true ->
					Info = ""
			end,
			if
				BigPlayers =/= [] ->
					Info1 = lists:concat([Info, ", Id BigPlayers num:", length(BigPlayers)]);
				true ->
					Info1 = lists:concat([Info, ""])
			end,
			if
				SmallPlayers2 =/= [] ->
					Info2 = lists:concat([Info1, ", Acid SmallPlayers num:", length(SmallPlayers2)]);
				true ->
					Info2 = lists:concat([Info1, ""])
			end,
			if
				BigPlayers2 =/= [] ->
					Info3 = lists:concat([Info2, ", acid BigPlayers num:", length(BigPlayers2)]);
				true ->
					Info3 = lists:concat([Info2, ""])
			end,
			if
				SmallUsers =/= [] ->
					Info4 = lists:concat([Info3, ", id SmallUsers num:", length(SmallUsers)]);
				true ->
					Info4 = lists:concat([Info3, ""])
			end,
			if
				BigUsers =/= [] ->
					Info5 = lists:concat([Info4, ", id BigUsers num:", length(BigUsers)]);
				true ->
					Info5 = lists:concat([Info4, ""])
			end,
			io:format("check_player_user_id, result:~p~n", [Info5]);
		true ->
			skip
	end.

%%修复acid, ServerNo服务器编号
correct_acid(ServerNo) ->
	if
		ServerNo > 0 ->
			BeginTime = util:unixtime(),
			End = (ServerNo+1) * 100000000,				%%比要求大
			Users = db_agent_tool:get_big_user_acid(End),
			F = fun(User) ->
						case User of
							[_Id, Acid, Acnm, State, Idcrs] ->
								if
									Acid >= End ->
										NewAcid = db_agent_tool:update_user(Acnm, [Acid, Acnm, State, Idcrs]),
										db_agent_tool:update_player_acid(Acnm, NewAcid);		%%更新player表中的acid
									true ->
										skip
								end;
							[_Id, Acid, Acnm, State, Idcrs, _, _] ->
								if
									Acid >= End ->
										NewAcid = db_agent_tool:update_user2(Acnm, [Acid, Acnm, State, Idcrs, ServerNo]),
										db_agent_tool:update_player_acid(Acnm, NewAcid);		%%更新player表中的acid
									true ->
										skip
								end;
							_ ->
								skip
						end
				end,
			lists:foreach(F, Users),
			Start = ServerNo * 100000000,				%%比要求小
			Users2 = db_agent_tool:get_small_user_acid(Start),
			F2 = fun(User) ->
						 case User of
							 [_Id, Acid, Acnm, State, Idcrs] ->
								 if
									 Acid < Start ->
										 NewAcid = db_agent_tool:update_user(Acnm, [Acid, Acnm, State, Idcrs]),
										 db_agent_tool:update_player_acid(Acnm, NewAcid);
									 true ->
										 skip
								 end;
							 [_Id, Acid, Acnm, State, Idcrs, _, _] ->
								 if
									 Acid < Start ->
										 NewAcid = db_agent_tool:update_user2(Acnm, [Acid, Acnm, State, Idcrs, ServerNo]),
										 db_agent_tool:update_player_acid(Acnm, NewAcid);
									 true ->
										 skip
								 end;
							 _ ->
								 skip
						 end
							 
				end,
			lists:foreach(F2, Users2),
			CostTime = util:unixtime() - BeginTime,
			io:format("correct is complete, cost time:~p, correct user num:~p~n", [CostTime, length(Users)+length(Users2)]);
		true ->
			skip
	end.



%%检查删除条件范围内的玩家数量
check_delete_player_num(Lv) ->
	ToDeletePlayers = db_agent_tool:get_to_delete_players(Lv),		%%获取小于Lv级、30天未登录、且非VIP的玩家
	io:format("to delete player num:~p~n", [length(ToDeletePlayers)]).

%%合服前删除条件范围内的玩家数据, 分表地一个一个玩家删除，为防止mongo busy采用了延时，用时大
delete_player_data(Lv) ->
	BeginTime = util:unixtime(),
	ToDeletePlayers = db_agent_tool:get_to_delete_players(Lv),		%%获取小于Lv级、30天未登录、且非VIP的玩家  id, acid, acnm
	F = fun(Player) ->
				case Player of
					[Uid, Acid, Acnm] ->
						delete_player_data(Uid, Acid, Acnm),		%%按角色ID、帐号删除一玩家数据
						timer:sleep(50);							%%要有延迟，不然太快了数据库连接会出错
					_ ->
						skip
				end
		end,
	lists:foreach(F, ToDeletePlayers),
	CostTime = util:unixtime() - BeginTime,
	io:format("delete player_data is complete, cost time:~p, delete player num:~p~n", [CostTime, length(ToDeletePlayers)]),
	timer:sleep(1000),
	delete_user_data().												%%删除user表中存在但player表不存在的数据

%%按角色ID、帐号删除一玩家数据
delete_player_data(Uid, Acid, Acnm) ->
	Tables = [battle_data, collection, collection_award, colors_tree, com_gift, cooldown, cross_data, daily_bless, dungeon, frmt, frmt_equip, ghost,giant, giant_other, goods, goods_buff, guild_beast_feed, guild_member,guild_shop, hook_data,  hunt, notice, online_gift, pet, rank_reward, rela, reward_bag, saddle, sign_in, skill,slaves, subs_doll, system_config, target, task_bag, task_cycle, task_daily, task_finish, task_guild, team_player_mtask, theurgy, thplayer, thrank, thsave, title, treasure, treasure_msg, vip],
	F = fun(Table) ->
				db_agent_tool:delete_table_data_by_uid(Table, Uid)	%%按表名删除上面这些表中的玩家数据
%% 				timer:sleep(100)									%%不延时会造成mongo busy退出
		end,
	lists:foreach(F, Tables),
%% 	timer:sleep(100),
	db_agent_tool:delete_player_user(Uid, Acid, Acnm).	%%%%删除player、user、infant_ctrl_byuser、stc_create_page表中的玩家数据

	
%%删除user表中存在但player表不存在的数据
delete_user_data() ->
	BeginTime = util:unixtime(),
	Users = db_agent_tool:get_big_user_acid(1),
	F = fun(User, Acc) ->
				case User of
					[_Id, Acid, Acnm, _State, _Idcrs] ->
						Player = db_agent_tool:get_playerid_by_acnm(Acnm);
					[_Id, Acid, Acnm, _State, _Idcrs, _Sn, _] ->
						Player = db_agent_tool:get_playerid_by_acnm(Acnm);
					_ ->
						Player = skip,
						Acid = 0,
						Acnm = skip
				end,
				case Player of
					null ->
						db_agent_tool:delete_user_by_acnm(Acnm),
						db_agent_tool:delete_infant_ctrl_byuser_by_acid(Acid),
						db_agent_tool:delete_stc_create_page_by_acid(Acid),
						timer:sleep(40),
						Acc + 1;
					_ ->
						Acc
				end
		end,
	Num = lists:foldl(F, 0, Users),
	CostTime = util:unixtime() - BeginTime,
	io:format("delete user_data is complete, cost time:~p, delete user num:~p~n", [CostTime, Num]).

%%合服前删除条件范围内的玩家数据, 一个表一个表地集中删除, 要删除的数量大会引起mongo busy
delete_player_data2(Lv) ->
	BeginTime = util:unixtime(),
	ToDeletePlayers = db_agent_tool:get_to_delete_players(Lv),			%%获取小于Lv级、30天未登录、且非VIP的玩家
	Tables = [battle_data, collection, collection_award, colors_tree, com_gift, cooldown, cross_data, daily_bless, discovery, discovery_data, dungeon, frmt, frmt_equip, ghost,giant, giant_other, giant_box, giant_valup_log, goods, goods_buff, guild_beast_feed, guild_member,guild_shop, hook_data,  hunt, notice, online_gift, pet, rank_reward, rela, reward_bag, saddle, sign_in, skill,slaves, subs_doll, system_config, target, task_bag, task_cycle, task_daily, task_finish, task_guild, team_player_mtask, theurgy, thplayer, thrank, thsave, title, treasure, treasure_msg, vip],
	F = fun(Table) ->
				db_agent_tool:delete_table_data_by_uid2(Table, ToDeletePlayers),		%%按表名删除上面这些表中的玩家数据
				timer:sleep(1000)
		end,
	lists:foreach(F, Tables),
	timer:sleep(1000),
	db_agent_tool:delete_player_user2(ToDeletePlayers),	%%%%删除player、user、infant_ctrl_byuser、stc_create_page表中的玩家数据
	CostTime = util:unixtime() - BeginTime,
	io:format("delete player_data is complete, cost time:~p, delete player num:~p~n", [CostTime, length(ToDeletePlayers)]).
			
%%检查player表存在而user表不存在的玩家
check_no_user() ->
	Players = db_agent_tool:get_player_info(),
	F = fun(Player, Acc) ->
				[_Uid, _Nick, Acid] = Player,						%%id, nick, acid
				case db_agent_tool:get_user_by_acid(Acid) of
					null ->
						[Acid|Acc];
					_ ->
						Acc
				end
		end,
	Result = lists:foldl(F, [], Players),
	io:format("check_no_user, acid result:~p~n", [Result]).

%%在user表中增加一个服务器编号
update_sn_to_user(Sn) ->
	BeginTime = util:unixtime(),
	Users = db_agent_tool:get_big_user_acid(1),					%%查询acid大于等于1的帐号
	F = fun(User) ->
				[_Id, Acid|_] = User,
				timer:sleep(20),
				db_agent_tool:update_user_sn(Acid, Sn)			%%更新服务器编号
		end,
	lists:foreach(F, Users),
	CostTime = util:unixtime() - BeginTime,
	io:format("update_sn_to_user complete, cost time:~p, user num:~p~n", [CostTime, length(Users)]).

%%检查玩家重复角色名
check_player_same_name() ->
	BeginTime = util:unixtime(),
	Players = db_agent_tool:get_player_info(),		%%得到player表中的id, nick, acid列表
	loop_check_player_name(Players),
	CostTime = util:unixtime() - BeginTime,
	io:format("check_player_same_name complete, cost time:~p, players num:~p~n", [CostTime, length(Players)]).

%%检查玩家列表中的角色名，若有相同的，根据其所在服务器编号修改
loop_check_player_name(Players) ->
	if
		length(Players) =< 1 ->						%%玩家列表小于等于1时返回
			ok;
		true ->
			[OnePlayer|TPlayers] = Players,
			[_, CheckNick, _] = OnePlayer,
			SameNamePlayers = [[Uid2, Nick2, Acid2]||[Uid2, Nick2, Acid2]<-Players, Nick2 =:= CheckNick],	%%找出相同角色名的
			if
				length(SameNamePlayers) =< 1 ->		%%只有一个时，不要修改
					loop_check_player_name(TPlayers);
				true ->
					F = fun(Player, Acc) ->
								[Uid2, Nick2, _Acid2] = Player,
								ServerNo = Uid2 div 100000000,
								case ServerNo of			%%根据uid找出帐号所在的服务器编号
									Sn when is_number(Sn) ->					%%找到则用服务器编号
										TempNick = binary_to_list(Nick2),
										NewNick = lists:concat([TempNick, "_S", Sn]),
										db_agent_tool:update_player_nick(NewNick,Uid2),			%%更新player表的中角色名
										db_agent_tool:update_guild_owner_name(NewNick,Uid2),	%%修改联盟盟主名称
										db_agent_tool:update_guild_member_name(NewNick,Uid2),	%%修改联盟成员表中的角色名
										spawn(fun() ->db_log_agent:update_log_player(Uid2, NewNick) end),	%%写log_player中的角色名
										Acc;
									_ ->										%%没有则用序号
										TempNick = binary_to_list(Nick2),
										NewNick = lists:concat([TempNick, "_", Acc]),
										db_agent_tool:update_player_nick(NewNick,Uid2),
										db_agent_tool:update_guild_owner_name(NewNick,Uid2),
										db_agent_tool:update_guild_member_name(NewNick,Uid2),	%%修改联盟成员表中的角色名
										spawn(fun() ->db_log_agent:update_log_player(Uid2, NewNick) end),	%%写log_player中的角色名
										Acc + 1
								end
						end,
					lists:foldl(F, 1, SameNamePlayers),
					LeftPlayers = [[Uid2, Nick2, Acid2]||[Uid2, Nick2, Acid2]<-Players, Nick2 =/= CheckNick],
					loop_check_player_name(LeftPlayers)
			end
	end.
	

%%检查联盟重复角色名
check_guild_same_name() ->
	BeginTime = util:unixtime(),
	Guilds = db_agent_tool:get_guild_info(),			%%查询联盟信息
	loop_check_guild_name(Guilds),						%%检查联盟列表中的角色名
	CostTime = util:unixtime() - BeginTime,
	io:format("check_guild_same_name complete, cost time:~p, Guilds num:~p~n", [CostTime, length(Guilds)]).

%%检查联盟列表中的联盟名，若有相同的，根据盟主所在服务器编号修改
loop_check_guild_name(Guilds) ->
	if
		length(Guilds) =< 1 ->							%%联盟个数小于等于1时返回
			ok;
		true ->
			[OneGuild|TGuilds] = Guilds,
			[_, CheckName, _] = OneGuild,
			SameNameGuilds = [[Id2, Name2, Uid2]||[Id2, Name2, Uid2]<-Guilds, Name2 =:= CheckName],		%%找出有相同名称的
			if
				length(SameNameGuilds) =< 1 ->			%%只有一个时，不用修改
					loop_check_guild_name(TGuilds);
				true ->
					F = fun(Guild, Acc) ->
								[Id2, Name2, _Uid2] = Guild,
								ServerNo = Id2 div 100000000,
								case ServerNo of										%%根据ID找出所在服务器编号
									Sn when is_number(Sn) ->							%%找到则用服务器编号
										TempName = binary_to_list(Name2),
										NewName = lists:concat([TempName, "_S", Sn]),
										db_agent_tool:update_guild_name(NewName,Id2),
										update_guild_name_to_player(NewName, Id2),
										update_guild_name_to_guild_member(NewName, Id2),
										Acc;
									_ ->												%%没有则用序号
										TempName = binary_to_list(Name2),
										NewName = lists:concat([TempName, "_", Acc]),
										db_agent_tool:update_guild_name(NewName,Id2),
										update_guild_name_to_player(NewName, Id2),
										update_guild_name_to_guild_member(NewName, Id2),
										Acc + 1
								end
						end,
					lists:foldl(F, 1, SameNameGuilds),
					LeftGuilds = [[Id2, Name2, Uid2]||[Id2, Name2, Uid2]<-Guilds, Name2 =/= CheckName],	%%剩下的联盟继续检查
					loop_check_guild_name(LeftGuilds)
			end
	end.

%%更新联盟名到玩家表
update_guild_name_to_player(GuildName, GuildId) ->
	Members = db_agent_tool:get_member_by_guild_id(GuildId),
	F = fun([Uid]) ->
				db_agent_tool:update_guild_name_to_player(GuildName, Uid)
		end,
	lists:foreach(F, Members).
		

%%更新联盟名到联盟成员表
update_guild_name_to_guild_member(GuildName, GuildId) ->
	Members = db_agent_tool:get_member_by_guild_id(GuildId),
	F = fun([Uid]) ->
				db_agent_tool:update_guild_name_to_guild_member(GuildName, Uid)
		end,
	lists:foreach(F, Members).
	

%%对同帐号多角色时选择一个等级最高的player, 把其非最高的user.use改为0
check_use_user() ->
	BeginTime = util:unixtime(),
	Users = db_agent_tool:get_big_user_acid(1),
	F = fun(User) ->
				case User of
					[_Id, _Acid, Acnm, _State, _Idcrs] ->
						Players = db_agent_tool:get_player_by_acnm(Acnm);		%%得到id, acid, lv
					[_Id, _Acid, Acnm, _State, _Idcrs, _Sn, _] ->
						Players = db_agent_tool:get_player_by_acnm(Acnm);
					_ ->
						Players = skip
				end,
				if 
					is_list(Players) andalso Players =/= [] andalso length(Players) > 1 ->
						update_use_user(Players);
					true ->
						skip
				end
		end,
	lists:foreach(F,Users),
	CostTime = util:unixtime() - BeginTime,
	io:format("check_use_user is complete, cost time:~p~n", [CostTime]).
	
%%选择一个等级最高的player, 把其非最高的user.use改为0
update_use_user(Players) ->
	if
		is_list(Players) andalso Players =/= [] andalso length(Players) > 1 ->
			F = fun(Player, Acc) ->
						if
							Acc =:= [] ->
								Player;
							true ->
								[_Uid, _Acid, Lv, Gold, Coin] = Player,
								[_Uid0, _Acid0, Lv0, Glod0, Coin0] = Acc,
								if
									Lv < Lv0 ->
										Acc;
									Lv > Lv0 ->
										Player;
									true ->
										if
											Gold < Glod0 ->
												Acc;
											Gold > Glod0 ->
												Player;
											true ->
												if
													Coin < Coin0 ->
														Acc;
													true ->
														Player
												end
										end
								end
						end
				end,
			[Uid0, _Acid0, _Lv0, _Gold0, _Coin0] = lists:foldl(F, [], Players),		%%等到等级最高的player
			LeftPlayers = [[Uid, Acid, Lv, Gold, Coin]||[Uid, Acid, Lv, Gold, Coin]<-Players, Uid =/= Uid0],
			F2 = fun(Player) ->
						 [_Uid, Acid, _Lv, _Gold, _Coin] = Player,
						 db_agent_tool:update_user_use(Acid, 0)						%%把其余player的user.use使用状态改为0
				 end,
			lists:foreach(F2, LeftPlayers);
		true ->
			skip
	end.
						
								

						
	
%%-------------------------- 合服所用函数 end -------------------------------------------