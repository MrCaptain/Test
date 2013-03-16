%%%--------------------------------------
%%% @Module  : game_gateway
%%% @Author  : 
%%% @Created : 2010.10.27 
%%% @Description: 将mysql数据表 转换成 erl record
%%%            生成文件： "../include/table_to_record.hrl"
%%%--------------------------------------
-module(table_to_erlang).
-compile(export_all). 

%%
%% Include files
%%
-include("common.hrl").
-include("table_to_record.hrl").

-define(CONFIG_FILE, "../config/gateway.config").
-define(TMP_TABLE_PATH, "./tmptable/").
-define(SRC_TABLE_PATH, "../src/table/").
-define(BEAM_PATH, "./"). 

-define(TABLES, [
         %数据库表名   Record名  %erlang文件名  %参数
         {temp_player,      temp_player,      data_player, [1,2]},
		 {temp_combat_attr, temp_combat_attr, data_battle, [1,2,3]} ,
		 %{temp_goods,temp_goods , []} ,
		 {temp_item_equipment, temp_item_equipment, data_equipment, [1]},
		 {temp_item_gem,  temp_item_gem, data_gem,  [1]} ,
		 {temp_item_holy_gem,  temp_item_holy_gem, data_holy_gem, [1]},
		 {temp_item_set, temp_item_set, data_set, [1]} ,
		 {temp_monster_refresh, temp_monster_refresh, data_scene_mon, [1]} ,
		 %{temp_notice,temp_notice, []} ,
		 %{temp_npc,temp_npc, []} ,
		 {temp_npc_refresh,temp_npc_refresh, data_scene_npc, [1]} 
		 %{temp_scene,temp_scene, []},
    ]).

%%
%% Exported Functions
%%

%%
%% API Functions
%%
start()->    
    case get_db_config(?CONFIG_FILE) of
    	[Host, Port, User, Password, DB, Encode, _Conns] ->
			start_erlydb(Host, Port, User, Password, DB),
    		mysql:start_link(?DB_SERVER,?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode),
    		mysql:connect(?DB_SERVER,?DB_POOL, Host, Port, User, Password, DB, Encode, true),
            tables_to_erlang(),
            ok;
        _ -> mysql_config_fail
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
    erlydb:code_gen(TableList,{mysql, 
                               [{allow_unsafe_statements, true},
                                {skip_fk_checks, true}]},
                                [debug_info,{skip_fk_checks, true},
                                {outdir,"../ebin/"}]),
    clearTempFile(),
    ok.

%% @doc 通过beam生成erl文件，方便开发查看模块方法
%%        调用该方法之前，必须先调用code_gen()方法，生成表对应的beam文件
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
%%    eg: TableFilePath -> "./tmptable/tuser_friend_log.erl"
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

tables_to_erlang() ->
    io:format("~nstart converting table to erlang data~n", []),
    F = fun({TableName, RecordName, FileName, ParamList}) ->
        table_to_erlang(atom_to_list(TableName), atom_to_list(RecordName), atom_to_list(FileName), ParamList) 
    end,
    lists:foreach(F, ?TABLES).

table_to_erlang(TableName, RecordName, FileName, ParamList) ->
    io:format("~s => ~s.erl,  \tTable fields ~p as parametes~n", [TableName, FileName, ParamList]),
    DataFileName = lists:concat(["../src/data/", FileName, ".erl"]),
    Bakfile = re:replace(lists:flatten(lists:concat([DataFileName , "_", time_format(now())])),"[ :]","_",[global,{return,list}]),
    file:rename(DataFileName, Bakfile),     
    file:write_file(DataFileName, ""),
    file:write_file(DataFileName, "%%%------------------------------------------------\t\n",[append]),
    FileBytes =  list_to_binary(io_lib:format("%%% File    : ~s.erl\t\n", [FileName])),
    file:write_file(DataFileName, FileBytes,[append]),
    file:write_file(DataFileName, "%%% Author  : table_to_erlang\t\n",[append]),
    Bytes = list_to_binary(io_lib:format("%%% Created : ~s\t\n", [time_format(now())])),
    file:write_file(DataFileName, Bytes,[append]),
    TableNameBytes =  list_to_binary(io_lib:format("%%% Description:从数据库表~s生成\n", [TableName])),
    file:write_file(DataFileName, TableNameBytes,[append]),
    file:write_file(DataFileName, "%%% WARNING:程序生成，请不要增加手工代码！\n",[append]),    
    file:write_file(DataFileName, "%%%------------------------------------------------    \t\n",[append]),
    file:write_file(DataFileName, " \t\n",[append]),
    ModuleName = lists:concat(["-module(", FileName, ")."]),
    file:write_file(DataFileName, ModuleName,[append]),
    file:write_file(DataFileName, " \t\n",[append]),
    file:write_file(DataFileName, "-compile(export_all).",[append]),
    file:write_file(DataFileName, " \t\n",[append]),
    
    %%从MYSQL查表所有内容
    Sql = io_lib:format("select * from ~s;", [TableName]),
    Lists = db_mysqlutil:get_all(Sql),
    TableRecordAtom = list_to_atom(RecordName),
    F = fun(ValueList) ->
        list_to_tuple([TableRecordAtom|ValueList])
    end,
    RecordList = lists:map(F, Lists),
    F2 = fun(Record) ->
        record_to_erlang(DataFileName, Record, ParamList)
    end,
    lists:foreach(F2, RecordList),
    record_to_erlang_end(DataFileName, ParamList).

%%转换表到Erlang文件, Record为数据库一条记录对应的Record
%%DataFileName为文件名， ParamList为入口参数列表[]
%%如get(Level, Career), ParamList应该指定 Level,Career在数据表位置
record_to_erlang(DataFileName, Record, ParamList) ->
    [RecordName|ValueList] = tuple_to_list(Record),
    F1 = fun(Index) ->
         Idx = lists:nth(Index, ParamList),
         Value = lists:nth(Idx, ValueList),
         if Index =:= length(ParamList) ->
                Bytes = lists:concat([integer_to_list(Value), ")->\n\t"]);
            true ->
                Bytes =  lists:concat([integer_to_list(Value), ", "]) 
            end,
         file:write_file(DataFileName, list_to_binary(Bytes),[append]) 
    end,

    %%写get(xxx,xxx) ->
    file:write_file(DataFileName, "\t\n",[append]),
    file:write_file(DataFileName, "get(", [append]),
    lists:foreach(F1, lists:seq(1, length(ParamList))),

    %%写 {record_name, 
    file:write_file(DataFileName, list_to_binary(io_lib:format("{~s, ",[RecordName])), [append]),                
    F2 = fun(Index2) ->
            Value2 = lists:nth(Index2,ValueList),
            if is_integer(Value2) ->
                    if Index2  =:= length(ValueList) ->
                        file:write_file(DataFileName, list_to_binary(io_lib:format("~p};",[Value2])), [append]);
                    true ->
                        file:write_file(DataFileName, list_to_binary(io_lib:format("~p, ",[Value2])), [append])
                    end;
               %%列表类型(字符串)
               is_list(Value2) orelse is_binary(Value2) ->
                    Value3 = case is_binary(Value2) of
                                true ->  binary_to_list(Value2);
                                false -> Value2
                             end,
                    if Index2  =:= length(ValueList) ->
                        file:write_file(DataFileName, list_to_binary(io_lib:format("~p};",[Value3])), [append]);
                    true ->
                        file:write_file(DataFileName, list_to_binary(io_lib:format("~p, ",[Value3])), [append])
                    end;
               true ->
                    if Index2  =:= length(ValueList) ->
                        file:write_file(DataFileName, list_to_binary(io_lib:format("~p};",[Value2])), [append]);
                    true ->
                        file:write_file(DataFileName, list_to_binary(io_lib:format("~p, ",[Value2])), [append])
                    end
            end

   end,
   lists:foreach(F2, lists:seq(1, length(ValueList))).

%% %%写get(_,_, ...) -> [].
record_to_erlang_end(DataFileName, ParamList) ->
    F = fun(Index) ->
            if Index =:= length(ParamList) ->
                Bytes = "_)->\t\n";
            true ->
                Bytes = "_, "
            end,
            file:write_file(DataFileName, list_to_binary(Bytes), [append]) 
    end,
    file:write_file(DataFileName, "\t\n",[append]),
    file:write_file(DataFileName, "get(", [append]),
    lists:foreach(F, lists:seq(1, length(ParamList))),
    file:write_file(DataFileName, "\t[].\t\n",[append]).



