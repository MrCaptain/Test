%%%------------------------------------------------	
%%% File    : data_scene_mon.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_mon_layout生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(data_scene_mon). 	
-compile(export_all). 	
	
get(101)->
	{temp_mon_layout, 101, 20001, 20, 15, 8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, <<"">>, <<"">>, 0, {},{},0, 0};	
get(101)->
	{temp_mon_layout, 101, 20002, 10, 10, 7, 1, 0, 0, 0, 0, 0, 0, 3, 0, 0, <<"00000000000">>, <<"">>, 0, {},{},0, 0};	
get(_)->	
	[].	
