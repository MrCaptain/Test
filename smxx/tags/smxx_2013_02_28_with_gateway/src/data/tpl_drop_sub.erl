%%%------------------------------------------------	
%%% File    : tpl_drop_sub.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_drop_sub生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_drop_sub). 	
-compile(export_all). 	
	
get(1)->
	{temp_drop_sub, 1, [{100, 1, 100}, {101, 1, 100}]};	
get(2)->
	{temp_drop_sub, 2, [{200, 1, 100}, {201, 1, 100}]};	
get(_)->	
	[].	
