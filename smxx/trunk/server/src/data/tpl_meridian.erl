%%%------------------------------------------------	
%%% File    : tpl_meridian.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_meridian生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_meridian). 	
-compile(export_all). 	
	
get(0, 0)->
	{tpl_meridian, 0, 0, 0, <<"督脉">>, [{1,b,10},{2,c,10}],1, 0, []};	
get(1, 0)->
	{tpl_meridian, 1, 1, 0, <<"任脉">>, [{4,a,10}],2, 0, []};	
get(2, 0)->
	{tpl_meridian, 2, 2, 0, <<"冲脉">>, [],3, 0, []};	
get(3, 0)->
	{tpl_meridian, 3, 3, 0, <<"带脉">>, [],4, 0, []};	
get(4, 0)->
	{tpl_meridian, 4, 4, 0, <<"阴维">>, [],5, 0, []};	
get(5, 0)->
	{tpl_meridian, 5, 5, 0, <<"阳维">>, [],6, 0, []};	
get(6, 0)->
	{tpl_meridian, 6, 6, 0, <<"阴晓">>, [],7, 0, []};	
get(7, 0)->
	{tpl_meridian, 7, 7, 0, <<"阳晓">>, [],-1, 0, []};	
get(_, _)->	
	[].	
