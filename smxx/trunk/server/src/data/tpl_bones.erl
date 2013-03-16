%%%------------------------------------------------	
%%% File    : tpl_bones.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_bones生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_bones). 	
-compile(export_all). 	
	
get(1)->
	{tpl_bones, 1, 1200, 7000, 1500};	
get(2)->
	{tpl_bones, 2, 2000, 6000, 1200};	
get(3)->
	{tpl_bones, 3, 2800, 5000, 1000};	
get(4)->
	{tpl_bones, 4, 3900, 4000, 900};	
get(5)->
	{tpl_bones, 5, 4800, 3000, 900};	
get(6)->
	{tpl_bones, 6, 5900, 2000, 900};	
get(7)->
	{tpl_bones, 7, 7000, 1000, 800};	
get(8)->
	{tpl_bones, 8, 8000, 900, 700};	
get(9)->
	{tpl_bones, 9, 9000, 800, 600};	
get(10)->
	{tpl_bones, 10, 12000, 500, 500};	
get(_)->	
	[].	
