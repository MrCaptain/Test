%%%--------------------------------------
%%% @Module  : game_gateway
%%% @Author  : csj
%%% @Created : 2010.10.27 
%%% @Description: 将mysql数据表 转换成 erl record
%%%			生成文件： "../include/table_to_record.hrl"
%%%--------------------------------------
-module(table_to_record).
 
%%
%% Include files
%%
-include("common.hrl").

-define(CONFIG_FILE, "../config/gateway.config").

-define(TMP_TABLE_PATH, "./tmptable/").
-define(SRC_TABLE_PATH, "../src/table/").
-define(RECORD_FILENAME, "../include/table_to_record.hrl").
-define(BEAM_PATH, "./"). 

-define(TABLES,
		[
		 {server, server},
		 {player, player},
		 {goods,goods},
		 {skill, skill},
         {player_sys_setting, player_sys_setting},
		 {feedback, feedback},
		 {temp_combat_attr,temp_combat_attr} ,
		 {temp_goods,temp_goods} ,
		 {temp_item_equipment,temp_item_equipment} ,
		 {temp_item_gem,temp_item_gem} ,
		 {temp_item_holy_gem,temp_item_holy_gem} ,
		 {temp_item_set,temp_item_set} ,
		 {temp_mon_layout,temp_mon_layout} ,
		 {temp_notice,temp_notice} ,
		 {temp_npc,temp_npc} ,
		 {temp_npc_layout,temp_npc_layout} ,
		 {temp_scene,temp_scene},
         {temp_player, temp_player}
	]).

-record(erlydb_field,
	{name, name_str, name_bin, type, modifier, erl_type,
	 html_input_type,
	 null, key,
	 default, extra, attributes}).
%%
%% Exported Functions
%%
-compile(export_all). 

%%
%% API Functions
%%
start()->	
	case get_db_config(?CONFIG_FILE) of
		[Host, Port, User, Password, DB, Encode, _Conns] ->
			start_erlydb(Host, Port, User, Password, DB),
    		mysql:start_link(?DB_SERVER,?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode),
    		mysql:connect(?DB_SERVER,?DB_POOL, Host, Port, User, Password, DB, Encode, true),
  			tables_to_record(),
%% 			get_date_box(),
%% 			make_data_box:get_data_box(),
			ok;
		_ -> 
           mysql_config_fail
	end,
  	halt(),
	ok.

get_db_config(Config_file)->
		{ok,[L]} = file:consult(Config_file),
		{_, C} = lists:keyfind(gateway, 1, L),
		{_, Mysql_config} = lists:keyfind(mysql_config, 1, C),
		{_, Host} = lists:keyfind(host, 1, Mysql_config),
		{_, Port} = lists:keyfind(port, 1, Mysql_config),
		{_, User} = lists:keyfind(user, 1, Mysql_config),
		{_, Password} = lists:keyfind(password, 1, Mysql_config),
		{_, DB} = lists:keyfind(db, 1, Mysql_config),
		{_, Encode} = lists:keyfind(encode, 1, Mysql_config),
		{_, Conns} = lists:keyfind(conns, 1, Mysql_config),
		[Host, Port, User, Password, DB, Encode,Conns].

%%
%% Local Functions
%%
start_erlydb(IP, Port, User, Password, Db) ->
	erlydb:start(mysql, [{pool_id, erlydb_mysql},
						{hostname, IP},
						 {port, Port},
						 {username, User}, 
						 {password, Password}, 
						 {database, Db},
						 {encoding, utf8},
						 {pool_size, 10}]).

%% @doc 生成指定的表名的beam文件
%% @spec code_gen/0
%%      unilog_mysql_pool:code_gen()

code_gen() ->
	code_gen(?TABLES).

code_gen(TableName) ->
	TableList = writeTempFile(TableName),
%% io:format("TableList=~p~n~n",[TableList]),
	erlydb:code_gen(TableList,{mysql, 
							   [{allow_unsafe_statements, true},
								{skip_fk_checks, true}]},
								[debug_info,{skip_fk_checks, true},
								 {outdir,"../ebin/"}]),
	clearTempFile(),
	ok.

%% @doc 通过beam生成erl文件，方便开发查看模块方法
%%		调用该方法之前，必须先调用code_gen()方法，生成表对应的beam文件
%% @spec code_gen_src/0
code_gen_src() ->
	lists:foreach(fun(TableName) ->
						  Beam = lists:concat([?BEAM_PATH, TableName,".beam"]),
						  case beam_lib:chunks(Beam, [abstract_code]) of
							  {ok,{_,[{abstract_code,{_,AC}}]}} ->
								  Code = erl_prettypr:format(erl_syntax:form_list(AC)),
								  file:write_file(lists:concat([?SRC_TABLE_PATH,TableName,".erl"]), list_to_binary(Code)),
								  io:format("build beam:~p to erl:~p success.~n", [TableName, TableName]);
							  {error, beam_lib, Reason} ->
								  io:format("code_gen_erl_file error, reason:~p~n", [Reason])
						  end
				  end, ?TABLES).	

%% @doc 为指定的表名生成module文件，给code_gen/0 使用
%% @spec writeTempFile/0 ->[TableFilePath]
%%	eg: TableFilePath -> "./tmptable/tuser_friend_log.erl"
writeTempFile(TableName)->
	clearTempFile(),
	ok = file:make_dir(?TMP_TABLE_PATH),
	lists:map(fun(F)-> 
					  Filename =  
						  ?TMP_TABLE_PATH ++ atom_to_list(F) ++ ".erl",
					  Bytes = list_to_binary( io_lib:format("-module(~w).", [F]) ),
					  file:write_file(Filename, Bytes),
					  Filename
			  end, TableName).

clearTempFile()->
	case file:list_dir(?TMP_TABLE_PATH) of
		{ok, Filenames} ->
			lists:foreach(fun(F)->
								  file:delete(?TMP_TABLE_PATH ++ F) end , Filenames);
		{error, _} -> ignore
	end,
	file:del_dir(?TMP_TABLE_PATH).

tables_to_record() ->
    io:format("starting table to record ...~n"),
	Bakfile = re:replace(
		lists:flatten(lists:concat([?RECORD_FILENAME , "_", time_format(now())])),
		"[ :]","_",[global,{return,list}]),
	lists:flatten(lists:concat([?RECORD_FILENAME , "_", time_format(now())])),
	file:rename(?RECORD_FILENAME, Bakfile), 

	file:write_file(?RECORD_FILENAME, ""),
	file:write_file(?RECORD_FILENAME, "%%%------------------------------------------------\t\n",[append]),
	file:write_file(?RECORD_FILENAME, "%%% File    : table_to_record.erl\t\n",[append]),
	file:write_file(?RECORD_FILENAME, "%%% Author  : smxx\t\n",[append]),
	Bytes = list_to_binary(io_lib:format("%%% Created : ~s\t\n", [time_format(now())])),
	file:write_file(?RECORD_FILENAME, Bytes,[append]),
	file:write_file(?RECORD_FILENAME, "%%% Description: 从mysql表生成的record\t\n",[append]),
	file:write_file(?RECORD_FILENAME, "%%% Warning:  由程序自动生成，请不要随意修改！\t\n",[append]),	
	file:write_file(?RECORD_FILENAME, "%%%------------------------------------------------	\t\n",[append]),
	file:write_file(?RECORD_FILENAME, " \t\n",[append]),

	io:format("~n~n"),
	
	lists:foreach(fun(Table)-> 
					case Table of 
						{Table_name, Record_name} -> table_to_record(Table_name, Record_name, "");
						{Table_name, Record_name, TableComment} -> table_to_record(Table_name, Record_name, TableComment);
						_-> no_action
					end	
			  	  end, 
				  ?TABLES),
	io:format("finished!~n~n"),	
	ok.
	
%% table_to_record:table_to_record(user, 1).
%% [A,B]=db_mysqlutil:get_row("show create table user;")
%% db_mysqlutil:get_row("select * from base_goods_type;")
table_to_record(Table_name, Record_name, TableComment) ->
	file:write_file(?RECORD_FILENAME, "\t\n",[append]),	
	Sql = lists:concat(["show create table ", Table_name]),
	try 
		case  db_mysqlutil:get_row(Sql) of 
			{db_error, _} ->
				error;
			[_, A | _]->
%%  io:format("====A = ~s~n~n~n",[A]),
 				Create_table_list = re:split(A,"[\n]",[{return, binary}]),
%% io:format("Create_table_list = ~s~n~n~n",[Create_table_list]),
				Table_comment =
					case TableComment of
						"" -> get_table_comment(Create_table_list, Table_name);
						_ -> TableComment
					end,
%% io:format("Table_name1 = ~p~n~n~n",[Table_name]),							  
				file:write_file(?RECORD_FILENAME, 
								list_to_binary(io_lib:format("%% ~s\t\n",[Table_comment])), 
								[append]),
%% io:format("Table_name2 = ~p~n~n~n",[Table_name]),
				file:write_file(?RECORD_FILENAME, 
								list_to_binary(io_lib:format("%% ~s ==> ~s \t\n",[Table_name, Record_name])), 
								[append]),
%% io:format("Table_name3 = ~p~n~n~n",[Table_name]),
				file:write_file(?RECORD_FILENAME, 
								list_to_binary(io_lib:format("-record(~s, {\t\n",[Record_name])), 
								[append]),				
				code_gen([Table_name]),
%% io:format("Table_name = ~p~n~n~n",[Table_name]),	
				Table_fields = erlang:apply(Table_name, db_fields, []),
%% io:format("Table_fields = ~p~n~n~n",[Table_fields]),				
				lists:mapfoldl(fun(Field, Sum) ->
%% io:format("Sum_~p = ~p~n",[Sum, Field]),										   
								Field_comment = get_field_comment(Create_table_list, Sum),
%% io:format("Field_comment = ~p~n",[Field_comment]),								
								Default = 
									case Field#erlydb_field.default of
										undefined -> '';
										<<>> -> 
											case erlydb_field:get_erl_type(Field#erlydb_field.type) of
												binary -> 
													lists:concat([" = \"\""]);
												integer -> 
													lists:concat([" = 0"]);
												_ -> '' 
											end;
										<<"[]">> ->
												lists:concat([" = ", binary_to_list(Field#erlydb_field.default)]);
										Val -> 
											case erlydb_field:get_erl_type(Field#erlydb_field.type) of
												binary -> 
													lists:concat([" = <<\"", binary_to_list(Val) ,"\">>"]);
%% 												integer -> 
%% 													lists:concat([" = 0"]);
												_ -> 
													lists:concat([" = ", binary_to_list(Val)])
											end																				
									end,
								T1 = 
									if Sum == length(Table_fields) -> 
										   '';
										true -> ','
							   		end,  
%% 								io:format("Field[~p] = ~p / ~p ~n",[Sum, Field, Field_comment]),
								T2 = io_lib:format("~s~s~s",
																 [Field#erlydb_field.name, 
																  Default,
																  T1]), 
%% io:format("T2_len= ~p/~p ~n",[length(T2), T2]),								
								T3 = lists:duplicate(40-length(lists:flatten(T2)), " "),
								Bytes = list_to_binary(io_lib:format("      ~s~s%% ~s\t\n",
																 [T2, 
																  T3,
																  Field_comment])), 								
								file:write_file(?RECORD_FILENAME, 
										Bytes,
										[append]),								
								{
								[], 
								Sum+1
								}
								end,
							 	1, Table_fields),
				
				file:write_file(?RECORD_FILENAME, 
								list_to_binary(io_lib:format("    }).\t\n",[])), 
								[append]),	
				io:format("                 ~s ==> ~s ~n",[Table_name, Record_name]),
				ok
		end
	catch
		_:_ -> 
        io:format("error when getting  ~s ==> ~s ~n",[Table_name, Record_name]),
        error
	end.

get_field_comment(Create_table_list, Loc) ->
	try
%% 	L1 = re:split(lists:nth(Loc+1, Create_table_list),"[ ]",[{return, list}]),
		L1 = binary_to_list(lists:nth(Loc+1, Create_table_list)),	
%%   io:format("L1 = ~p ~n", [L1]),		
		Loc1 = string:rstr(L1, "COMMENT "),
%%   io:format("Loc = ~p ~n", [Loc1]),	
		case Loc1 > 0 of
			true -> 
				L2 = string:substr(L1, Loc1 + 8),
				L3 = lists:subtract(L2, [39,44]),
				lists:subtract(L3, [39]);
			_ -> ""
		end
	catch
		_:_ -> ""
	end.

get_table_comment(Create_table_list, Table_name) ->
	try
%% 	L1 = re:split(lists:nth(Loc+1, Create_table_list),"[ ]",[{return, list}]),
		Len  = length(Create_table_list),	
		L1 = binary_to_list(lists:nth(Len, Create_table_list)),	
%%   io:format("L1 = ~p ~n", [L1]),		
		Loc1 = string:rstr(L1, "COMMENT="),
%%   io:format("Loc = ~p ~n", [Loc1]),	
		case Loc1 > 0 of
			true -> 
				L2 = string:substr(L1, Loc1 + 8),
				L3 = lists:subtract(L2, [39,44]),
				lists:subtract(L3, [39]);
			_ -> Table_name
		end
	catch
		_:_ -> Table_name
	end.	
  
%% time format
one_to_two(One) -> io_lib:format("~2..0B", [One]).

%% @doc get the time's seconds for integer type
%% @spec get_seconds(Time) -> integer() 
get_seconds(Time)->
	{_MegaSecs, Secs, _MicroSecs} = Time, 
	Secs.
	
time_format(Now) -> 
	{{Y,M,D},{H,MM,S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", 
						one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).
date_format(Now) ->
	{{Y,M,D},{_H,_MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D)]).
date_hour_format(Now) ->
	{{Y,M,D},{H,_MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", one_to_two(H)]).
date_hour_minute_format(Now) ->
	{{Y,M,D},{H,MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", one_to_two(H) , "-", one_to_two(MM)]).
%% split by -
minute_second_format(Now) ->
	{{_Y,_M,_D},{H,MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([one_to_two(H) , "-", one_to_two(MM)]).

hour_minute_second_format(Now) ->
	{{_Y,_M,_D},{H,MM,S}} = calendar:now_to_local_time(Now),
	lists:concat([one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).




%% ------------------------------------------------------------------------------------------------------
%% *********************************从mysql表生成的诛邪系统物品概率碰撞表 start ****************************
%% ------------------------------------------------------------------------------------------------------
get_date_box() ->
	Careers = lists:seq(1,5),
	lists:map(fun get_data_box_career/1, Careers).
get_data_box_career(Career) ->
%% 	DataFileName = lists:concat(["../src/data/data_box_", Career, ".erl"]),
%% 	Bakfile = re:replace(
%% 		lists:flatten(lists:concat([DataFileName , "_", time_format(now())])),
%% 		"[ :]","_",[global,{return,list}]),
%% 	
%% 	file:rename(DataFileName, Bakfile), 
%% 	
%% 	file:write_file(DataFileName, ""),
%% 	file:write_file(DataFileName, "%%%------------------------------------------------\t\n",[append]),
%% 	file:write_file(DataFileName, "%%% File    : data_box_X.erl\t\n",[append]),
%% 	file:write_file(DataFileName, "%%% Author  : xiaomai\t\n",[append]),
%% 	Bytes = list_to_binary(io_lib:format("%%% Created : ~s\t\n", [time_format(now())])),
%% 	file:write_file(DataFileName, Bytes,[append]),
%% 	file:write_file(DataFileName, "%%% Description: 从mysql表生成的诛邪系统物品概率碰撞表\t\n",[append]),
%% 	file:write_file(DataFileName, "%%% Warning:  由程序自动生成，请不要随意修改！\t\n",[append]),	
%% 	file:write_file(DataFileName, "%%%------------------------------------------------	\t\n",[append]),
%% 	file:write_file(DataFileName, " \t\n",[append]),
%% 	ModuleName = lists:concat(["-module(data_box_",Career,")."]),
%% 	file:write_file(DataFileName, ModuleName,[append]),
%% 	file:write_file(DataFileName, " \t\n\n",[append]),
%% 	file:write_file(DataFileName, "-export([get_goods_one/3]).",[append]),
%% 	file:write_file(DataFileName, " \t\n",[append]),
%% 	file:write_file(DataFileName, " \t\n",[append]),
%% 	file:write_file(DataFileName, "get_goods_one(HoleType, Career, RandomCount) ->\n\t",[append]),
	Counts = lists:seq(1,3),
	lists:map(fun(Elem)-> handle_data_box_each(Career, Elem) end, Counts),
%% 	ErCodeend = "GoodsInfo = lists:concat([\"Goods_info_\", HoleType, Elem, \"00\"]),
%% 	%%注意这里的返回值	
%% 	{BaseGoodsId} = lists:nth(RandomCount, GoodsInfo),
%% 	BaseGoodsId.",
%% 	file:write_file(DataFileName, ErCodeend,[append]),
	io:format("~n~n").
%% handle_data_box_each(Elem, Career) ->
%% 	Sum = lists:seq(1,5),
%% 	lists:foldl(fun handle_data_box_each_one/2,{Elem}, Sum).
handle_data_box_each(Career, Elem) ->
	DataFileName = lists:concat(["../src/data/data_box_", Career, Elem, ".erl"]),
	Bakfile = re:replace(
		lists:flatten(lists:concat([DataFileName , "_", time_format(now())])),
		"[ :]","_",[global,{return,list}]),
	
	file:rename(DataFileName, Bakfile), 	
	file:write_file(DataFileName, ""),
	file:write_file(DataFileName, "%%%------------------------------------------------\t\n",[append]),
	file:write_file(DataFileName, "%%% File    : data_box_XX.erl\t\n",[append]),
	file:write_file(DataFileName, "%%% Author  : xiaomai\t\n",[append]),
	Bytes = list_to_binary(io_lib:format("%%% Created : ~s\t\n", [time_format(now())])),
	file:write_file(DataFileName, Bytes,[append]),
	file:write_file(DataFileName, "%%% Description: 从mysql表生成的诛邪系统物品概率碰撞表\t\n",[append]),
	file:write_file(DataFileName, "%%% Warning:  由程序自动生成，请不要随意修改！\t\n",[append]),	
	file:write_file(DataFileName, "%%%------------------------------------------------	\t\n",[append]),
	file:write_file(DataFileName, " \t\n",[append]),
	ModuleName = lists:concat(["-module(data_box_", Career, Elem, ")."]),
	file:write_file(DataFileName, ModuleName,[append]),
	file:write_file(DataFileName, " \t\n\n",[append]),
	file:write_file(DataFileName, "-export([get_goods_one/3]).",[append]),
	file:write_file(DataFileName, " \t\n",[append]),
	file:write_file(DataFileName, " \t\n",[append]),
	file:write_file(DataFileName, "get_goods_one(HoleType, Career, RandomCount) ->\n\t",[append]),

	Sql = 
		io_lib:format("select a.pro, a.goods_id from `base_box_goods` a, `base_goods` b where hole_type = ~p and b.goods_id = a.goods_id and b.career in (0,~p) order  by a.goods_id desc",
					  [Elem,Career]),
	Lists = db_mysqlutil:get_all(Sql),
	ElemName = lists:concat(["Goods_info_", Career, Elem, "00 = ["]),
	file:write_file(DataFileName,ElemName,[append]),
 	{_NewCount, _FileName} = lists:foldl(fun make_content_goods/2,{1, DataFileName},Lists),
%% 	io:format("the [~p]count is[~p]\n\n\n", [Career, NewCount]),
%%  	String = lists:concat(Result),
%%  	file:write_file(?FILENAME, string:substr(String,1, string:len(String)),[append]),
	
	file:write_file(DataFileName,"],\n\t",[append]),
	ErCodeEndOne = "
	%%注意这里的返回值	
	{BaseGoodsId} = lists:nth(RandomCount, ",
	ErCodeEndTwo = "),
	BaseGoodsId.",
	EndString = lists:concat([ErCodeEndOne,"Goods_info_",Career,Elem,"00",ErCodeEndTwo]),
	file:write_file(DataFileName, EndString,[append]).
	
make_content_goods(List, AccIn) ->
	[Pro, GoodsId] = List,
	{Count, DataFileName} = AccIn,
	NewPro = Pro*100000,
	NewProInt = tool:to_integer(NewPro),
	Sum = lists:seq(1, NewProInt),
	{NewCount, _GodosId, Result} = lists:foldl(fun get_content_array/2,{Count,GoodsId,[]},Sum),
	String = lists:concat(lists:reverse(Result)),
 	file:write_file(DataFileName, String,[append]),
%% 	file:write_file(DataFileName, "\n\t\t\t\t\t\t",[append]),
%% 	io:format("the elem is {~p,~p,~p,~p}\t\t", [Pro,NewProInt,NewCount,length(Result)]),
	{NewCount, DataFileName}.
get_content_array(_Elem,AccIn) ->
	{Count, GoodsId, ResultList} = AccIn,
	case tool:to_integer(Count) =:= 100000 of
		true ->
 			ResultElem = lists:concat(["{", GoodsId, "}"]);
		false ->
 			ResultElem = lists:concat(["{", GoodsId, "},"])
	end,
	{Count+1, GoodsId, [ResultElem|ResultList]}.
%% ------------------------------------------------------------------------------------------------------
%% *********************************从mysql表生成的诛邪系统物品概率碰撞表 end ****************************
%% ------------------------------------------------------------------------------------------------------
