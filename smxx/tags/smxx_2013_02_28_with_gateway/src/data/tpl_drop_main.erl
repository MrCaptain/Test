%%%------------------------------------------------	
%%% File    : tpl_drop_main.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_drop_main生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_drop_main). 	
-compile(export_all). 	
	
get(1)->
	{temp_drop_main, 1, [{1, 10000}, {2, 8000}]};	
get(_)->	
	[].	
