%%%------------------------------------------------	
%%% File    : task_detail.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表task_detail生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(task_detail). 	
-compile(export_all). 	
	
get(0)->
	{task_detail, 0, 0, 1, 1, 1, [{130000,180000},{200000,220020}],{},2};	
get(1)->
	{task_detail, 1, 0, 1, 1, 1, [],{},2};	
get(2)->
	{task_detail, 2, 1, 3, 10, 1, [],{},1};	
get(3)->
	{task_detail, 3, 1, 2, 5, 1, [],{},2};	
get(4)->
	{task_detail, 4, 1, 1, 5, 3, [],{},2};	
get(5)->
	{task_detail, 5, 1, 3, 10, 1, [],{},4};	
get(6)->
	{task_detail, 6, 1, 3, 10, 1, [],{},2};	
get(7)->
	{task_detail, 7, 1, 3, 10, 1, [],{},2};	
get(8)->
	{task_detail, 8, 1, 3, 10, 1, [],{},2};	
get(9)->
	{task_detail, 9, 1, 1, 10, 1, [],{},2};	
get(_)->	
	[].	
