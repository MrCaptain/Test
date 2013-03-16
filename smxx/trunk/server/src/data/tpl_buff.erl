%%%------------------------------------------------	
%%% File    : tpl_buff.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表temp_buff生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_buff). 	
-compile(export_all). 	
	
get(1)->
	{temp_buff, 1, <<"勇毅">>, 1, 1, 1, 60000, 1, 10000, [],0, 0, [{defense,40},{fdefense,20},{mdefense,20},{ddefense,20}, {avoid_attack,100},{aviod_fattack,75},{avoid_mattack,75},{avoid_dattack,75}]};	
get(2)->
	{temp_buff, 2, <<"勇毅">>, 1, 1, 2, 60000, 1, 10000, [],0, 0, [{defense,80},{fdefense,40},{mdefense,40},{ddefense,40}, {avoid_attack,200},{aviod_fattack,150},{avoid_mattack,150},{avoid_dattack,150}]};	
get(3)->
	{temp_buff, 3, <<"勇毅">>, 1, 1, 3, 60000, 1, 10000, [],0, 0, [{defense,120},{fdefense,60},{mdefense,60},{ddefense,60}, {avoid_attack,300},{aviod_fattack,150},{avoid_mattack,150},{avoid_dattack,150}]};	
get(4)->
	{temp_buff, 4, <<"勇毅">>, 1, 1, 4, 60000, 1, 10000, [],0, 0, [{defense,160},{fdefense,80},{mdefense,80},{ddefense,80}, {avoid_attack,400},{aviod_fattack,200},{avoid_mattack,200},{avoid_dattack,200}]};	
get(5)->
	{temp_buff, 5, <<"勇毅">>, 1, 1, 5, 60000, 1, 10000, [],0, 0, [{defense,200},{fdefense,100},{mdefense,100},{ddefense,100}, {avoid_attack,500},{aviod_fattack,250},{avoid_mattack,250},{avoid_dattack,250}]};	
get(6)->
	{temp_buff, 6, <<"勇毅">>, 1, 1, 6, 60000, 1, 10000, [],0, 0, [{defense,250},{fdefense,125},{mdefense,125},{ddefense,125}, {avoid_attack,600},{aviod_fattack,300},{avoid_mattack,300},{avoid_dattack,300}]};	
get(7)->
	{temp_buff, 7, <<"勇毅">>, 1, 1, 7, 60000, 1, 10000, [],0, 0, [{defense,300},{fdefense,150},{mdefense,150},{ddefense,150}, {avoid_attack,700},{aviod_fattack,350},{avoid_mattack,350},{avoid_dattack,350}]};	
get(8)->
	{temp_buff, 8, <<"勇毅">>, 1, 1, 8, 60000, 1, 10000, [],0, 0, [{defense,350},{fdefense,175},{mdefense,175},{ddefense,175}, {avoid_attack,800},{aviod_fattack,400},{avoid_mattack,400},{avoid_dattack,400}]};	
get(9)->
	{temp_buff, 9, <<"勇毅">>, 1, 1, 9, 60000, 1, 10000, [],0, 0, [{defense,400},{fdefense,200},{mdefense,200},{ddefense,200}, {avoid_attack,900},{aviod_fattack,500},{avoid_mattack,500},{avoid_dattack,500}]};	
get(10)->
	{temp_buff, 10, <<"勇毅">>, 1, 1, 10, 60000, 1, 10000, [],0, 0, [{defense,500},{fdefense,250},{mdefense,250},{ddefense,250}, {avoid_attack,1000},{aviod_fattack,750},{avoid_mattack,750},{avoid_dattack,750}]};	
get(11)->
	{temp_buff, 11, <<"洗礼">>, 1, 2, 1, 60000, 1, 10000, [],0, 0, [{attack,70},{fattack,35},{mattack,35},{dattack,35}]};	
get(12)->
	{temp_buff, 12, <<"洗礼">>, 1, 2, 2, 60000, 1, 10000, [],0, 0, [{attack,140},{fattack,70},{mattack,70},{dattack,70}]};	
get(13)->
	{temp_buff, 13, <<"洗礼">>, 1, 2, 3, 60000, 1, 10000, [],0, 0, [{attack,210},{fattack,105},{mattack,105},{dattack,105}]};	
get(14)->
	{temp_buff, 14, <<"洗礼">>, 1, 2, 4, 60000, 1, 10000, [],0, 0, [{attack,280},{fattack,140},{mattack,140},{dattack,140}]};	
get(15)->
	{temp_buff, 15, <<"洗礼">>, 1, 2, 5, 60000, 1, 10000, [],0, 0, [{attack,350},{fattack,175},{mattack,175},{dattack,175}]};	
get(16)->
	{temp_buff, 16, <<"洗礼">>, 1, 2, 6, 60000, 1, 10000, [],0, 0, [{attack,420},{fattack,210},{mattack,210},{dattack,210}]};	
get(17)->
	{temp_buff, 17, <<"洗礼">>, 1, 2, 7, 60000, 1, 10000, [],0, 0, [{attack,490},{fattack,245},{mattack,245},{dattack,245}]};	
get(18)->
	{temp_buff, 18, <<"洗礼">>, 1, 2, 8, 60000, 1, 10000, [],0, 0, [{attack,560},{fattack,280},{mattack,280},{dattack,280}]};	
get(19)->
	{temp_buff, 19, <<"洗礼">>, 1, 2, 9, 60000, 1, 10000, [],0, 0, [{attack,630},{fattack,315},{mattack,315},{dattack,315}]};	
get(20)->
	{temp_buff, 20, <<"洗礼">>, 1, 2, 10, 60000, 1, 10000, [],0, 0, [{attack,700},{fattack,350},{mattack,350},{dattack,350}]};	
get(21)->
	{temp_buff, 21, <<"完杀">>, 1, 3, 1, 60000, 1, 10000, [],0, 0, [{fattack,60},{mattack,60},{dattack,60},{crit,250}]};	
get(22)->
	{temp_buff, 22, <<"完杀">>, 1, 3, 2, 60000, 1, 10000, [],0, 0, [{fattack,120},{mattack,120},{dattack,120},{crit,500}]};	
get(23)->
	{temp_buff, 23, <<"完杀">>, 1, 3, 3, 60000, 1, 10000, [],0, 0, [{fattack,180},{mattack,180},{dattack,180},{crit,750}]};	
get(24)->
	{temp_buff, 24, <<"完杀">>, 1, 3, 4, 60000, 1, 10000, [],0, 0, [{fattack,240},{mattack,240},{dattack,240},{crit,1000}]};	
get(25)->
	{temp_buff, 25, <<"完杀">>, 1, 3, 5, 60000, 1, 10000, [],0, 0, [{fattack,300},{mattack,300},{dattack,300},{crit,1250}]};	
get(26)->
	{temp_buff, 26, <<"完杀">>, 1, 3, 6, 60000, 1, 10000, [],0, 0, [{fattack,360},{mattack,360},{dattack,360},{crit,1500}]};	
get(27)->
	{temp_buff, 27, <<"完杀">>, 1, 3, 7, 60000, 1, 10000, [],0, 0, [{fattack,420},{mattack,420},{dattack,420},{crit,1750}]};	
get(28)->
	{temp_buff, 28, <<"完杀">>, 1, 3, 8, 60000, 1, 10000, [],0, 0, [{fattack,490},{mattack,490},{dattack,490},{crit,2000}]};	
get(29)->
	{temp_buff, 29, <<"完杀">>, 1, 3, 9, 60000, 1, 10000, [],0, 0, [{fattack,540},{mattack,540},{dattack,540},{crit,2250}]};	
get(30)->
	{temp_buff, 30, <<"完杀">>, 1, 3, 10, 60000, 1, 10000, [],0, 0, [{fattack,600},{mattack,600},{dattack,600},{crit,2500},{hit,4000}]};	
get(101)->
	{temp_buff, 101, <<"初级金创药">>, 2, 4, 1, 0, 1, 10000, [],0, 0, [hit_point,1000]};	
get(102)->
	{temp_buff, 102, <<"中级金疮药">>, 2, 4, 1, 0, 1, 10000, [],0, 0, [hit_point,1001]};	
get(103)->
	{temp_buff, 103, <<"高级金疮药">>, 2, 4, 1, 0, 1, 10000, [],0, 0, [hit_point,1002]};	
get(104)->
	{temp_buff, 104, <<"特级金创药">>, 2, 4, 1, 0, 1, 10000, [],0, 0, [hit_point,1003]};	
get(105)->
	{temp_buff, 105, <<"顶级金创药">>, 2, 4, 1, 0, 1, 10000, [],0, 0, [hit_point,1004]};	
get(106)->
	{temp_buff, 106, <<"初级琼华液">>, 2, 5, 1, 0, 1, 10000, [],0, 0, [magic,1000]};	
get(107)->
	{temp_buff, 107, <<"中级琼华液">>, 2, 5, 1, 0, 1, 10000, [],0, 0, [magic,1001]};	
get(108)->
	{temp_buff, 108, <<"高级琼华液">>, 2, 5, 1, 0, 1, 10000, [],0, 0, [magic,1002]};	
get(109)->
	{temp_buff, 109, <<"特级琼华液">>, 2, 5, 1, 0, 1, 10000, [],0, 0, [magic,1003]};	
get(110)->
	{temp_buff, 110, <<"顶级琼华液">>, 2, 5, 1, 0, 1, 10000, [],0, 0, [magic,1004]};	
get(151)->
	{temp_buff, 151, <<"初级生命包">>, 7, 6, 1, 0, 100, 10000, [],1, 100, [hit_point,1000]};	
get(152)->
	{temp_buff, 152, <<"中级生命包">>, 7, 6, 2, 0, 100, 10000, [],1, 50, [hit_point,2000]};	
get(153)->
	{temp_buff, 153, <<"高级生命包">>, 7, 6, 3, 0, 100, 10000, [],1, 25, [hit_point,4000]};	
get(154)->
	{temp_buff, 154, <<"特级生命包">>, 7, 6, 4, 0, 100, 10000, [],1, 10, [hit_point,10000]};	
get(155)->
	{temp_buff, 155, <<"顶级生命包">>, 7, 6, 5, 0, 100, 10000, [],1, 5, [hit_point,20000]};	
get(156)->
	{temp_buff, 156, <<"初级法力包">>, 8, 7, 1, 0, 100, 10000, [],1, 100, [magic,1000]};	
get(157)->
	{temp_buff, 157, <<"中级法力包">>, 8, 7, 2, 0, 100, 10000, [],1, 50, [magic,2000]};	
get(158)->
	{temp_buff, 158, <<"高级法力包">>, 8, 7, 3, 0, 100, 10000, [],1, 25, [magic,4000]};	
get(159)->
	{temp_buff, 159, <<"特级法力包">>, 8, 7, 4, 0, 100, 10000, [],1, 10, [magic,10000]};	
get(160)->
	{temp_buff, 160, <<"顶级法力包">>, 8, 7, 5, 0, 100, 10000, [],1, 5, [magic,20000]};	
get(_)->	
	[].	
