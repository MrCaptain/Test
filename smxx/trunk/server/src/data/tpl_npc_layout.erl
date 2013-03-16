%%%------------------------------------------------	
%%% File    : tpl_npc_layout.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_npc_layout生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_npc_layout). 	
-compile(export_all). 	
	
get(101, 10001)->
	{temp_npc_layout, 101, 10001, 10, 7, 5, {},0};	
get(101, 10002)->
	{temp_npc_layout, 101, 10002, 17, 13, 5, {},0};	
get(101, 10003)->
	{temp_npc_layout, 101, 10003, 32, 6, 5, {},0};	
get(101, 10005)->
	{temp_npc_layout, 101, 10005, 12, 21, 5, {},0};	
get(101, 10006)->
	{temp_npc_layout, 101, 10006, 32, 19, 5, {},0};	
get(101, 11001)->
	{temp_npc_layout, 101, 11001, 41, 10, 1, {},0};	
get(101, 11002)->
	{temp_npc_layout, 101, 11002, 19, 42, 2, {},0};	
get(101, 11003)->
	{temp_npc_layout, 101, 11003, 7, 23, 3, {},0};	
get(101, 11004)->
	{temp_npc_layout, 101, 11004, 19, 12, 4, {},0};	
get(_, _)->	
	[].	
