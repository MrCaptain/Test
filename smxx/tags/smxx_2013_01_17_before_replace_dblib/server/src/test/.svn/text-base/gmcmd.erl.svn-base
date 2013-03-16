%% Author: hzj
%% Created: 2010-9-29
%% Description: TODO: Add description to gmcmd
-module(gmcmd).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-compile([export_all]).

%%
%% API Functions
%%
%%
%% Local Functions
%%
%% cmd(Status,Data) ->
%% %% ?DEBUG("cmd_~p ~n",[Data]),
%% 	case config:get_can_gmcmd(server) of
%% 		1 ->  
%% 			case string:tokens(Status#player.nick, "Y") of
%% 				["GUES", _] ->
%% 					do_cmd(Status,Data);
%% 				["GA", _] ->
%% 					do_cmd(Status,Data);
%% 				_ ->
%% 					case string:tokens(Status#player.nick, "T") of
%% 						["GUES", _] ->
%% 							do_cmd(Status,Data);
%% 						["S", _] ->
%% 							do_cmd(Status,Data);
%% 						_ ->  
%% 							do_cmd(Status,Data)
%% 					end
%% 			end;
%% %% 		_ -> do_cmd(Status,Data)
%% 		_ ->  no_cmd
%% 	end.

%% do_cmd(Status,Data) ->
%% 	 %% -------------------- 测试命令 ----------------
%%     case string:tokens(Data, " ") of
%% 		["-全功能"] ->
%% 			
%% 			%%io:format("~s do_cmd 1[~p] \n ",[misc:time_format(now()), Sign]),
%% 			Status1=Status#player{ftst= Status#player.ftst bor 16777215, stsw =  Status#player.stsw bor 1007},
%% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% 			lib_giant_s:creat_giant_by_type(Status, 1001),
%% %% 			lib_giant:creatPlayerFirstGiant(Status1#player.id),    %%创建第一个巨兽
%% %% 			lib_giant:openGiantLayEggs(Status1),   %%开启巨兽生蛋功能
%% 			
%% 			%% 开启竞技场
%% 			Force =  lib_player:force_att(Status1),
%% 		    lib_theater:role_log_in_player(Status1#player.id,Status1#player.nick,Status1#player.sex,Status1#player.crr,Status1#player.lv,Force),
%% 
%% 			Player = Status1,
%% 			lib_rela:get_rela_record(Status),
%% %% 			lib_rela:role_log_in(Player#player.id,Player#player.nick,Player#player.sex,
%% %% 												 Player#player.crr,Player#player.viplv,Player#player.lv,Player#player.un,Player#player.upst,1),
%% %% 			
%% 			
%% 			{ok, BinData} = pt_13:write(13031, [Status1#player.ftst, 16777215]),
%% 			lib_send:send_to_sid(Status1#player.other#player_other.pid_send, BinData),
%% 			spawn(fun()->db_agent:change_function_state(Status1#player.ftst, Status1#player.ftus, Status1#player.id) end),
%% 			is_cmd;
%% 		["-重置骰子"] ->
%% 			lib_guild_activity:rest_data(Status),
%% 			is_cmd;
%% 		["-仙友", PL, V] ->
%% 			pp_guild_activity:handle(list_to_integer(PL), Status, [list_to_integer(V)]),
%% 			is_cmd;
%% 		["-仙友", PL, V1, V2] ->
%% 			pp_guild_activity:handle(list_to_integer(PL), Status, [list_to_integer(V1), list_to_integer(V2)]),
%% 			is_cmd;
%% 		["-清联盟CD"] ->
%% 			mod_guild:clear_guild_cd(Status#player.unid),
%% 			is_cmd;
%% 		["-加联盟CD"] ->
%% 			Status1 = Status#player{uqlt = 0},
%% 			pp_guild:handle(40044, Status1, []),
%% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% 			is_cmd;
%% 		["-加兽魂", Type, Num] ->
%% 			lib_hunt2:add_hunt_soul(Status, list_to_integer(Type), list_to_integer(Num), gm),
%% 			is_cmd;		
%% 		["-体力buff"] ->
%% 			lib_goods_use:useEngBuff(Status, 30, 1),
%% 			is_cmd;
%% 		["-开启时空", Second] ->
%% 			lib_conflict:test_conflict(list_to_integer(Second)),
%% 			is_cmd;
%% 		["-进入时空"] ->
%% 			_Res = pp_conflict:handle(38001, Status, 0),
%% 			is_cmd;
%% 		["-退出时空"] ->
%% 			_Res = pp_conflict:handle(38002, Status, 0),
%% 			is_cmd;
%% 		["-重置猎兽概率"] ->
%% 			lib_hunt:clear_hunt_radio(Status),
%% 			is_cmd;
%% 		["-testvip"] ->
%% 			pp_vip:handle(57003,Status,1),
%% 			pp_vip:handle(57003,Status,1),
%% 			pp_vip:handle(57003,Status,1),
%% 			pp_vip:handle(57003,Status,1),
%% 			pp_vip:handle(57003,Status,1),
%% 			pp_vip:handle(57003,Status,1),
%% 			is_cmd;
%% 		["-加元力", Num] ->
%% 			Status1 = lib_soul:add_soul(Status, list_to_integer(Num),test),
%% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% 			lib_player:send_player_attribute2(Status1, 3),
%% 			is_cmd;
%% 		["-test_giant", PNum, M1, M2] ->
%% 			PPNum = list_to_integer(PNum),
%% 			MM1 = 
%% 				case list_to_integer(M1) of
%% 					0 ->
%% 						[];
%% 					Tmp1 ->
%% 						[Tmp1]
%% 				end,
%% 			
%% 			MM2 = 
%% 				case list_to_integer(M2) of
%% 					0 ->
%% 						[];
%% 					Tmp2 ->
%% 						[Tmp2]
%% 				end,
%% 			MMList = MM1 ++ MM2,
%% 			pp_giant_s:handle(PPNum, Status, MMList),
%% 			is_cmd;
%% 		["-shop_cls"] ->
%% 			case misc:whereis_name({global, mod_shop_process}) of
%% 				Pid when is_pid(Pid) ->
%% 					Content = 
%% 						lists:concat(["<font color='#ffffff'>[GM命令]玩家清除商城抢购记录：", Status#player.nick,
%% 							"</font></a></font>"
%% 							]),
%% 					{ok, BinData} = pt_11:write(11080,  Content),
%% 					lib_send:send_to_all(BinData),
%% 					gen_server:cast(Pid,{'cls_th_goods'});
%% 				_ ->
%% 					skip
%% 			end,
%% 			is_cmd;
%% 		["-重置日常任务"] ->
%% 			%% 重置日常任务
%% 			case catch(gen_server:call(Status#player.other#player_other.pid_task, {'test_daily_task', Status})) of
%% 				_ ->
%% 					skip
%% 			end,	
%% 			is_cmd;
%% 		["-联盟战",StartTime] ->
%% 			mod_guild_battle:restart_activity(list_to_integer(StartTime)),		
%% 			is_cmd;
%% 		["-长生阁", Flag] ->
%% 			case list_to_integer(Flag) of
%% 				1 ->
%% 					pp_formation:handle(17031, Status, 1);
%% 				2 ->
%% 					pp_formation:handle(17032, Status, [2]);
%% 				3 ->
%% 					pp_formation:handle(17033, Status, [1]);
%% 				4 ->
%% 					pp_formation:handle(17034, Status, 1);
%% 				5 ->
%% 					pp_formation:handle(17035, Status, 1);
%% 				6 ->
%% 					pp_formation:handle(17036, Status, [1]);
%% 				7 ->
%% 					pp_formation:handle(17037, Status, [1]);
%% 				8 ->
%% 					pp_formation:handle(17038, Status, 1);
%% 				_ ->
%% 					skip
%% 			end,
%% 			is_cmd;
%% 		
%% 		["-博物堂",StartTime] ->
%% 			mod_tribute:restart_activity(list_to_integer(StartTime)),		
%% 			is_cmd;
%% 		["-世界BOSS",StartTime] ->
%% 			mod_boss:restart_activity(list_to_integer(StartTime)),		
%% 			is_cmd;
%% 		["-BOSS血量",HpNumber] ->
%% 			mod_boss:set_boss_maxhp(list_to_integer(HpNumber)),		
%% 			is_cmd;
%% 		
%% 		["-守护联盟",StartTime] ->
%% 			mod_guild_guard:restart_activity(list_to_integer(StartTime)),		
%% 			is_cmd;
%% 		["-多人副本",StartTime] ->
%% 			mod_team:restart_activity(list_to_integer(StartTime)),		
%% 			is_cmd;
%% 		["-斗兽决赛",StartTime] ->
%% 			mod_arena:restart_activity(list_to_integer(StartTime)),		
%% 			is_cmd;
%% 		["-加卡片",CardId, Num] ->
%% 			lib_theater:add_card(Status, list_to_integer(CardId), list_to_integer(Num)),		
%% 			is_cmd;
%% 		["-开全副本"] ->
%% 			lib_dungeon:open_all_dungeon(Status),			
%% 			is_cmd;
%% 		["-开场景"] ->
%% 			Status1 = Status#player{scst = 7 bor Status#player.scst},
%% 			{ok, BinData} = pt_13:write(13030, [Status1#player.scst, Status1#player.scus]),
%% 			lib_send:send_to_sid(Status1#player.other#player_other.pid_send, BinData),
%% 			
%% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% 			
%% 			db_agent:change_scene_state(Status1#player.scst, Status1#player.scus, Status1#player.id),
%% 			is_cmd;
%% %% 		["-立即生蛋"] ->
%% %% 			GiantOther = get(my_giant_other),
%% %% 			Now = util:unixtime(),
%% %% 			if GiantOther#ets_giant_other.eggtm > Now ->
%% %% 				   CtTime =  GiantOther#ets_giant_other.eggtm - Now + 3600;
%% %% 			   true ->
%% %% 				   CtTime = 0
%% %% 			end,
%% %% 			mod_giant:dec_lay_eggs_time(Status#player.id, CtTime),
%% %% 			is_cmd;
%% 		["-vipgold", Num] ->
%% 			TypeNum = list_to_integer(Num),
%% 			lib_goods:add_money_vip(Status,TypeNum,7000),
%% 			is_cmd;
%% %% 		["-开采集"] ->
%% %% 			Status1=Status#player{ftst= Status#player.ftst bor 262144},
%% %% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% %% 			lib_collection:creatFirstCollectInfo(Status1),
%% %% 			{ok, BinData} = pt_13:write(13031, [Status1#player.ftst, 262144]),
%% %% 			lib_send:send_to_sid(Status1#player.other#player_other.pid_send, BinData),
%% %% 			spawn(fun()->db_agent:change_function_state(Status1#player.ftst, Status1#player.ftus, Status1#player.id) end),
%% %% 			is_cmd;
%% %% 		["-采集检测", Num] ->
%% %% 			TypeNum = list_to_integer(Num),
%% %% 			Res = lib_collection:checkCltSts(Status, TypeNum),
%% %% 			io:format("checkCltSts_____[~p] \n ",[Res]),
%% %% 			is_cmd;
%% %% 		["-采集", Num] ->
%% %% 			TypeNum = list_to_integer(Num),
%% %% 			Res = lib_collection:handleCollect(Status, TypeNum),
%% %% 			io:format("handleCollect_____[~p] \n ",[Res]),
%% %% 			is_cmd;
%% %% 		["-采集战斗"] ->
%% %% 			Res = pp_battle:handing(Status, 11, 15, 11001, 0, 0),
%% %% 			io:format("Collect_battle____[~p] \n ",[Res]),
%% %% 			is_cmd;
%% %% 		["-清除采集时间"] ->
%% %% 			lib_cooldown:clear_cd_pl(Status#player.id),
%% %% 			is_cmd;
%% 		["-存储战斗数据"] ->
%% 			MyBR = lib_battle:iniMyBRLoop(Status),
%% 			put(my_battle_record, MyBR),
%% 			is_cmd;
%% 		["-开通神通"] ->
%% 			Status1=Status#player{ftst= Status#player.ftst bor 1048576},
%% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% %% 			lib_collection:creatFirstCollectInfo(Status1),
%% 			{ok, BinData} = pt_13:write(13031, [Status1#player.ftst, 1048576]),
%% 			lib_send:send_to_sid(Status1#player.other#player_other.pid_send, BinData),
%% 			spawn(fun()->db_agent:change_function_state(Status1#player.ftst, Status1#player.ftus, Status1#player.id) end),
%% 			is_cmd;
%% 		["-添加神通", BinList] ->
%% 			ThrList = util:string_to_term(tool:to_list(BinList)),
%% 			lib_theurgy:openTheurgy(Status, ThrList),
%% 			is_cmd;
%% 		["-升级神通", BinList] ->
%% 			ThrList = util:string_to_term(tool:to_list(BinList)),
%% 			pp_theurgy:handle(62001, Status, ThrList),
%% 			is_cmd;
%% 		["-petexp",Exp] ->
%% 			%%io:format("~s do_cmd 1[~p] \n ",[misc:time_format(now()), Sign]),
%% 			lib_pet2:add_exp_to_fight(Status, list_to_integer(Exp)),	
%% 			is_cmd;
%% 		["-开功能",Sign] ->
%% 			%%io:format("~s do_cmd 1[~p] \n ",[misc:time_format(now()), Sign]),
%% 			Status1=Status#player{ftst= Status#player.ftst bor list_to_integer(Sign)},
%% 			gen_server:cast(Status1#player.other#player_other.pid, {'SET_PLAYER', Status1}),
%% 			
%% 			{ok, BinData} = pt_13:write(13031, [Status1#player.ftst, Status1#player.ftus]),
%% 			lib_send:send_to_sid(Status1#player.other#player_other.pid_send, BinData),
%% 			spawn(fun()->db_agent:change_function_state(Status1#player.ftst, Status1#player.ftus, Status1#player.id) end),
%% 					
%% 			is_cmd;
%% 		["-猎兽",Lock, NPC, Coin, Time] ->
%% 			put(test_hunt, undefined),
%% 			lib_hunt:test_hunt(Status,[list_to_integer(Lock), list_to_integer(NPC), list_to_integer(Coin), list_to_integer(Time)]),
%% 			is_cmd;
%% 		["-加宠物",PetTypeId] ->
%% 			io:format("~s gmcmd:加宠物[~p]\n",[misc:time_format(now()), PetTypeId]),
%% 			[Result, _PetId,_PetName, _NewStatus] = lib_pet2:create_pet(Status,[list_to_integer(PetTypeId), 1, 1]),
%% 			
%% 			io:format("~s gmcmd:add_pet[~p]\n",[misc:time_format(now()), Result]),
%% 			is_cmd;
%% 		["-宠物晶石",GoodsTypeId, Num] ->
%% 			case list_to_integer(GoodsTypeId) of
%% 				133001 ->
%% 					lib_pet:add_spar_num(Status#player.id, 133001, list_to_integer(Num)); %% 增加取内功晶石数量
%% 				134001 ->
%% 					lib_pet:add_spar_num(Status#player.id, 134001, list_to_integer(Num)); %% 增加技法晶石数量
%% 				135001 ->
%% 					lib_pet:add_spar_num(Status#player.id, 135001, list_to_integer(Num));  %% 增加法力晶石数量
%% 				_ ->
%% 					skip			
%% 			end,
%% 			
%% 			is_cmd;
%% 		["-加物品格子",Id,Num,Cell] ->
%% 			io:format("~s gmcmd:do_cmd_add[~p/~p]\n",[misc:time_format(now()), Id, Num]),
%%             GoodsTypeInfo = goods_util:get_ets_info(?ETS_BASE_GOODS, list_to_integer(Id)),
%% 			io:format("~s gmcmd:do_cmd_GoodsTypeInfo[~p]\n",[misc:time_format(now()), GoodsTypeInfo]),
%%             NewInfo = goods_util:get_new_goods(GoodsTypeInfo),
%% 			io:format("~s gmcmd:do_cmd_NewInfo[~p]\n",[misc:time_format(now()), NewInfo]),
%%             GoodsInfo = NewInfo#goods{uid=Status#player.id, loc=4, cell=list_to_integer(Cell), num=abs(list_to_integer(Num))},
%% 			io:format("~s gmcmd:do_cmd_GoodsInfo[~p]\n",[misc:time_format(now()), GoodsInfo]),
%% %%             %%?DEBUG("pp_chat/handle11001/GoodsInfo/~p",[GoodsInfo]),
%%             %%(catch lib_goods:add_goods(GoodsInfo)),
%% 			lib_goods:add_goods(GoodsInfo),
%% 			io:format("~s gmcmd:do_cmd_end[~p]\n",[misc:time_format(now()), test]),
%% 			is_cmd;
%%         ["-加物品",Id,Num] ->
%%             GoodsTypeInfo = goods_util:get_ets_info(?ETS_BASE_GOODS, list_to_integer(Id)),
%% 			io:format("~s gmcmd:do_get_ets_info [~p]\n",[misc:time_format(now()), GoodsTypeInfo]),
%%             NewInfo = goods_util:get_new_goods(GoodsTypeInfo),
%%             GoodsInfo = NewInfo#goods{uid=Status#player.id, loc=4, cell=3, num=abs(list_to_integer(Num))},
%% %%             ?DEBUG("pp_chat/handle11001/GoodsInfo/~p",[GoodsInfo]),
%%             (catch lib_goods:add_goods(GoodsInfo)),
%% 			is_cmd;
%% 		["-设等级",Level] ->
%% 			Lv0 = abs(list_to_integer(Level)),
%% 			Lv= if Lv0 < 1 -> 1;
%% 				   Lv0 > 100 -> 100;
%% 				   true -> Lv0
%% 				end,
%% 			
%% 			(catch db_agent:test_update_player_info([{lv,Lv}],[{id,Status#player.id}])),
%% 			Status2=Status#player{lv=Lv},
%% 			%%ets:insert(?ETS_ONLINE, Status2),
%% 			gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%% 			lib_player:send_player_attribute(Status2, 1),
%% 			is_cmd;
%% 		["-怪物战斗数据", MonGroupId, Times] ->
%% 			NewMonGroupId = list_to_integer(MonGroupId),
%% 			NewTimes = list_to_integer(Times),
%% 			test_battle:handing(Status, 1, NewMonGroupId, 0, 0, 0, NewTimes),
%% 			is_cmd;
%% 			
%% 		["-加铜币",Num] ->
%% 			N1=abs(list_to_integer(Num)),
%% 			io:format("~s gmcmd:add coin  [~p]\n",[misc:time_format(now()), N1]),
%% 			(catch db_agent:test_update_player_info([{coin,N1,add}],[{id,Status#player.id}])),
%% 			Coin=Status#player.coin + N1,
%% 			Status3=Status#player{coin=Coin},
%% 			gen_server:cast(Status3#player.other#player_other.pid, {'SET_PLAYER', Status3}),
%% 			lib_player:send_player_attribute2(Status3, 3),
%% 			is_cmd;
%% 		["-删除英灵"] ->
%% 			db_agent_ghost:delete_ghost(Status#player.id),
%% 			is_cmd;
%% 		["-加战勋",Num] ->
%% 			N1=abs(list_to_integer(Num)),
%% %% 			io:format("~s gmcmd:add coin  [~p]\n",[misc:time_format(now()), N1]),
%% 			(catch db_agent:test_update_player_info([{prstg,N1,add}],[{id,Status#player.id}])),
%% 			Coin=Status#player.prstg + N1,
%% 			Status3=Status#player{prstg=Coin},
%% 			gen_server:cast(Status3#player.other#player_other.pid, {'SET_PLAYER', Status3}),
%% 			lib_player:send_player_attribute2(Status3, 3),
%% 			is_cmd;
%% 		["-showmethemoney"] ->
%% 			N1=80000000,
%% 			N2=8000,
%% 			(catch db_agent:test_update_player_info([{coin,N1,add}],[{id,Status#player.id}])),
%% 			(catch db_agent:test_update_player_info([{gold,N2,add}],[{id,Status#player.id}])),
%% 			Coin=Status#player.coin + N1,
%% 			Gold=Status#player.gold + N2,
%% 			Status3=Status#player{coin=Coin, gold=Gold},
%% 			gen_server:cast(Status3#player.other#player_other.pid, {'SET_PLAYER', Status3}),
%% 			lib_player:send_player_attribute2(Status3, 3),
%% 			is_cmd;
%% 		["-whosyourdaddy",Num] ->
%% 			%% 限制使用
%% 			N1 =
%% 				case abs(list_to_integer(Num)) of
%% 					Num when Num rem 8 =:= 0 ->
%% 						30000;
%% 					true ->
%% 						0
%% 				end,
%% 			if
%% 				Status#player.tech < N1 ->
%% 					{Crit, Ddge, Cter} = {99, 99, 33},
%% 					(catch db_agent:test_update_player_info([{pwr,N1,add}, 
%% 															 {mgc,N1,add}, 
%% 															 {tech,N1,add},
%% 															 {crit, Crit},
%% 															 {ddge, Ddge},
%% 															 {cter, Cter}],
%% 															[{id,Status#player.id}])),
%% 					Status3=Status#player{pwr = Status#player.pwr + N1, 
%% 										  mgc = Status#player.mgc + N1,
%% 										  tech = Status#player.tech + N1,
%% 										  crit = Crit, ddge = Ddge, cter = Cter};
%% 				true ->
%% 					{Crit, Ddge, Cter} = get_crr_spec(Status),
%% 					(catch db_agent:test_update_player_info([{pwr,N1,sub}, 
%% 															 {mgc,N1,sub}, 
%% 															 {tech,N1,sub},
%% 															 {crit, Crit},
%% 															 {ddge, Ddge},
%% 															 {cter, Cter}],
%% 															[{id,Status#player.id}])),
%% 					Status3=Status#player{pwr = Status#player.pwr - N1, 
%% 										  mgc = Status#player.mgc - N1,
%% 										  tech = Status#player.tech - N1,
%% 										  crit = Crit, ddge = Ddge, cter = Cter}
%% 			end,
%% 			gen_server:cast(Status3#player.other#player_other.pid, {'SET_PLAYER', Status3}),
%% 			lib_player:send_player_attribute2(Status3, 3),
%% 			is_cmd;
%% 		["-qh"] -> %%强化重置概率
%% 			{Rate, _Time, _Trend} = mod_misc:gm_change_stren_info(),
%% 			Content = 
%% 				lists:concat(["<font color='#ffffff'>[公告]当前强化概率为：", Rate,
%% 							"</font></a></font>"
%% 							]),
%% 			{ok, BinData} = pt_11:write(11080,  Content),
%% 			lib_send:send_to_all(BinData),
%% 			is_cmd;
%% 		["-加金币",Num] ->
%% 			N2=abs(list_to_integer(Num)),
%% 			(catch db_agent:test_update_player_info([{gold,N2,add}],[{id,Status#player.id}])),
%% 			Gold=Status#player.gold + N2,
%% 			Status4=Status#player{gold=Gold},
%% 			gen_server:cast(Status4#player.other#player_other.pid, {'SET_PLAYER', Status4}),
%% 			lib_player:send_player_attribute2(Status4, 3),
%% 			is_cmd;
%% 		["-加经验",Num] ->
%% %% 			io:format("~s gmcmd:add exp  [~p]\n",[misc:time_format(now()), Num]),
%% 			N5=abs(list_to_integer(Num)),
%% 			Status2 = lib_player:add_exp(Status,N5,0,0), 				
%% 			gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%% 			lib_player:send_player_attribute(Status2, 3),
%% 			is_cmd;
%% 		["-加体力"] ->
%% 			Status2=Status#player{eng=40},
%% 			gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%% 			lib_player:send_player_attribute(Status2, 3),
%% 			is_cmd;
%% 		["-加体力", Num] ->
%% 			EngNum=list_to_integer(Num),
%% 			Status2=Status#player{eng=Status#player.eng + EngNum},
%% 			gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%% 			lib_player:send_player_attribute(Status2, 3),
%% 			is_cmd;
%% 		["-加灵力", Num] ->
%% 			GothNum=abs(list_to_integer(Num)),
%% 			Status2=Status#player{goth=Status#player.goth + GothNum},
%% 			gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%% 			lib_player:send_player_attribute(Status2, 3),
%% 			is_cmd;
%% 		["-设跑速",Num] ->
%% 			N8=abs(list_to_integer(Num)),
%% 			(catch db_agent:test_update_player_info([{spd,N8}],[{id,Status#player.id}])),
%% 			Status10=Status#player{spd=N8},
%% 			gen_server:cast(Status10#player.other#player_other.pid, {'SET_PLAYER', Status10}),
%% 			lib_player:send_player_attribute(Status10, 3),
%% 			is_cmd;
%% 		["-删任务", TaskId] ->
%% 			Id=abs(list_to_integer(TaskId)),
%% 			lib_task:delete_finish_task(Status, Id),    
%% %% 			ets:match_delete(?ETS_TASK_QUERY_CACHE, {Status#player.id,_='_'}),
%% 			lib_task:flush_role_task(Status),
%% 			io:format("~s gmcmd:删任务  [~p]\n",[misc:time_format(now()), Id]),
%%             gen_server:cast(Status#player.other#player_other.pid_task,{'task_list',Status}),
%% 			is_cmd;
%%         ["taskdel", "all"] ->
%%             db_agent:pc_del_task_bag(Status#player.id),
%%             db_agent:pc_del_task_log(Status#player.id),
%%             lib_task:offline(Status#player.id),
%%             lib_task:flush_role_task(Status),
%%             lib_task:trigger(10100, Status),
%%             {ok, BinData1} = pt_30:write(30006, [1,0]),
%%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData1),
%% 			is_cmd;
%% %% 		["完成任务"]->
%% %% 			lib_task:finish_all_task(Status),
%% %% 			is_cmd;
%% 		["-task",Lv] ->
%% 			N20 = abs(list_to_integer(Lv)),
%% 			lib_task:finish_all_task(Status, Lv),
%% 			NewStatus = lib_task:finish_task_under_lv(Status,N20),
%% 			
%% 			io:format("~s -task Lv  [~p]\n",[misc:time_format(now()), [NewStatus#player.scst, NewStatus#player.stsw, NewStatus#player.ftst]]),
%% 			
%% 			mod_player:save_player_table(NewStatus, 0),
%% 			
%% 			gen_server:cast(NewStatus#player.other#player_other.pid, {'SET_PLAYER', NewStatus}),
%% 			lib_player:send_player_attribute(NewStatus, 3),
%% 			
%% 			gen_server:cast(NewStatus#player.other#player_other.pid_task,{'task_list',NewStatus}),
%% 			is_cmd;
%% 		["-新建巨兽"] ->
%% 			gen_server:cast(Status#player.other#player_other.pid, {creat_first_giant}),
%% %% 			lib_giant:handle_creat_new_giant(Status, 1),
%% 			NewPlayerStatus = Status#player{ftst = Status#player.ftst bor 16},			
%% 			spawn(fun()->db_agent:change_function_state(NewPlayerStatus#player.ftst, NewPlayerStatus#player.ftus, NewPlayerStatus#player.id) end),
%% 							
%% 			{ok, BinData2} = pt_30:write(13031, [NewPlayerStatus#player.ftst, 16]),
%% 			lib_send:send_to_sid(NewPlayerStatus#player.other#player_other.pid_send, BinData2),
%% 			is_cmd;
%% 		["-cd"]->
%% 			lib_cooldown:clear_player_cooldown(Status#player.id,equip),
%% 			lib_cooldown:clear_player_cooldown(Status#player.id,camp),
%% 			lib_cooldown:clear_player_cooldown(Status#player.id,dung),
%% 			is_cmd;
%% 		["-viplv"] ->
%% 			ResStatus = Status#player{vipmt = 0},
%% 			db_agent_vip:clear_vipmt(Status#player.id),
%% 			gen_server:cast(ResStatus#player.other#player_other.pid, {'SET_PLAYER', ResStatus}),
%% 			lib_player:send_player_attribute(ResStatus, []),
%% 			is_cmd;
%% 		["-充值",N] ->
%% 			Num = abs(list_to_integer(N)),
%% 			NewPlayerStatus = Status#player{vipmt = Status#player.vipmt + Num},
%% 			db_agent_vip:add_vipmt(Status#player.id, Num),
%% 			timer:sleep(500),
%% 		   	lib_vip:set_viplv_offline(NewPlayerStatus#player.id),
%% 		   	ResStatus = lib_vip:set_viplv_online(NewPlayerStatus),
%% 			gen_server:cast(ResStatus#player.other#player_other.pid, {'SET_PLAYER', ResStatus}),
%% 			lib_player:send_player_attribute(ResStatus, []),
%% 			is_cmd;
%% %% 		["-加法器",N] ->
%% %% 			FrmtEid = abs(list_to_integer(N)),
%% %% %% 			io:format("~p~n",[FrmtEid]),
%% %% 			lib_frmt_equip:add_frmt_equip_pack(FrmtEid),
%% %% %% 			D = get(frmt_equip),
%% %% %% 			io:format("~p~n",[D]),
%% %% 			is_cmd;
%% 
%% %% 		["-upsaddlelv"] ->							%%增加龙鞍培养层
%% %% 			Saddle = lib_saddle:get_player_saddle(Status),
%% %% 			{_Res, Saddle1} = lib_saddle:add_level(Saddle),
%% %% 			put(saddle_data,Saddle1),
%% %% 			is_cmd;
%% %% 		["-upsaddleop"] ->							%%增加龙鞍培养开光
%% %% 			Saddle = lib_saddle:get_player_saddle(Status),
%% %% 			{_Res, Saddle1} = lib_saddle:add_open(Saddle),
%% %% 			put(saddle_data,Saddle1),
%% %% 			is_cmd;
%% %% 		["-saddletime"] ->							%%恢复龙鞍培养次数到20次
%% %% 			Saddle = Saddle = lib_saddle:get_player_saddle(Status),
%% %% 			put(saddle_data,Saddle#ets_saddle{left=20}),
%% %% 			is_cmd;
%% %% 		["-upsaddle1"] ->							%%用铜币培养
%% %% 			lib_saddle:enhance_saddle(Status, 1),
%% %% 			is_cmd;
%% %% 		["-upsaddle2"] ->							%%用元宝培养
%% %% 			lib_saddle:enhance_saddle(Status, 2),
%% %% 			is_cmd;
%% 		["-distime"] ->								%%重设天宫探宝次数
%% 			lib_discovery:set_discovery_times(Status),
%% 			is_cmd;
%% %% 		["-resetgtask"] ->								%%重置联盟任务
%% %% 			TaskGuild = lib_task:get_player_task_guild(Status#player.id),		%%从ets表中查询联盟任务
%% %% 			%% 	io:format("delete_task_guild, TaskGuild:~p~n",[TaskGuild]),
%% %% 			if TaskGuild =:= [] ->
%% %% 				   ok;
%% %% 			   true ->														%%若存在
%% %% 				   TaskGuild1 = TaskGuild#task_guild{tid=0,rt=0,ft=0,rft=0,st=2,qly=1,aw=[]},
%% %% 				   lib_task:put_player_task_guild(TaskGuild1),				
%% %% 				   gen_server:cast(Status#player.other#player_other.pid_task,{'task_list',Status})
%% %% 	end,
%% %% 			is_cmd;
%% 		["-resetjy"] ->								%%重设精英副本次数
%% 			lib_elite:gm_reset_elite_dungeon(Status, 1),
%% 			is_cmd;
%% 		["-resetjy2"] ->								%%重设精英副本次数
%% 			lib_elite:gm_reset_elite_dungeon(Status, 2),
%% 			is_cmd;
%% %% 		["-resetcross"] ->								%%重设百仙过海次数
%% %% 			lib_cross:reset_cross_data(Status),
%% %% 			is_cmd;
%% %% 		["-haiyun", Num] ->								%%重设海运开启时间, Num时间后
%% %% 			N2=abs(list_to_integer(Num)),
%% %% 			reset_sea_start_time(N2),
%% %% 			mod_cross:restart_sea(),
%% %% 			is_cmd;
%% 		["-addjade",Num] ->
%% 			N2=abs(list_to_integer(Num)),
%% 			mod_guild:add_devo_jade(Status#player.unid, [{Status#player.id, 0, N2}]),
%% 			is_cmd;
%% %% 		["-yangtuo", Num] ->								%%重设羊驼活动开启时间, Num时间后
%% %% 			N2=abs(list_to_integer(Num)),
%% %% 			reset_alpaca_start_time(N2),
%% %% 			mod_island:restart_island(),
%% %% 			is_cmd;
%% 		["-reward", Id] ->								%%活动奖励
%% 			RewardId=abs(list_to_integer(Id)),
%% 			lib_reward:test_reward(Status, RewardId),
%% 			is_cmd;
%% 		["-mysql2mongo", TableName] ->	%%重导表, 只是从mysql导到mongo
%% 			load_mysql_table(TableName),
%%             is_cmd;
%% 		["-reloadmongo", Name] ->	%%重导模块表(可能不只一个表), 只是从mongo导到内存
%% 			Name1 = util:string_to_term(Name),
%% 			load_base_data(Name1),
%%             is_cmd;     
%% 		["-retree"] ->									%%重置圣树次数
%% 			lib_tree:reset_tree_times_gm(Status#player.id),	%%重置圣树次数
%% 			is_cmd;
%% 		["-watertree", Num] ->								   %%置圣树注灵值
%% 			Num1=abs(list_to_integer(Num)),
%% 			lib_tree:set_tree_water_gm(Status#player.id, Num1),%%置圣树注灵值
%% 			is_cmd;
%% 		["-uptree"] ->									
%% 			lib_tree:upgrade_tree_gm(Status#player.id, Status#player.lv),	%%圣树升级
%% 			is_cmd;
%%         ["-clear_house", Count] ->  
%%             Counter = min(abs(list_to_integer(Count)),1000),
%%             lib_house:clear_times(Status, Counter),   %%设恢复体力次数
%%             is_cmd;     
%%         ["-init_house"] ->  
%%             Status2 = lib_house:init_house(Status),   %%恢复云中居规模为默认
%%             gen_server:cast(Status2#player.other#player_other.pid, {'SET_PLAYER', Status2}),
%%             lib_player:send_player_attribute2(Status2, 3),            
%%             is_cmd;
%% 		["-rerank"] ->									
%% 			mod_rank:rerank_all(),	%%重新进行排行榜排序
%% 			is_cmd;
%% 		["-releisure"] ->									
%% 			lib_leisure:reset(Status#player.id),	%%重新进行排行榜排序
%% 			is_cmd;
%% 		["-signdate", Num] ->								%%GM指令指定签到日期	
%% 			SignDate = abs(list_to_integer(Num)),
%% 			lib_help:gm_sign_date(Status, SignDate),
%% 			is_cmd;
%% 		["-signnum", Num] ->								%%GM指令设置连续签到天数	
%% 			DayNum = abs(list_to_integer(Num)),
%% 			lib_help:gm_set_sign_day_num(Status, DayNum),
%% 			is_cmd;
%% 		["-signresettoday"] ->							%%GM指令清除今日签到
%% 			lib_help:gm_reset_today(Status),
%% 			is_cmd;
%% 		["-signresetall"] ->							%%GM指令清除所有签到数据
%% 			lib_help:gm_reset_all(Status),
%% 			is_cmd;
%% 		["-handle"|T] ->
%% 			if
%% 				length(T) >= 1 ->
%% 					[Cmd0|_] = T,
%% 					[Cmd|Params] = [list_to_integer(D)||D<-T],
%% 					[H1, H2|_] = Cmd0,
%% 					case [H1, H2] of
%% 						"13" -> pp_player:handle(Cmd, Status, Params);
%% 						"15" -> pp_goods:handle(Cmd, Status, Params);
%% 						"17" -> pp_formation:handle(Cmd, Status, Params);
%% 						"20" -> pp_battle:handle(Cmd, Status, Params);
%% 						"23" -> pp_title:handle(Cmd, Status, Params);
%% 						"30" -> pp_task:handle(Cmd, Status, Params);
%% 						"35" -> pp_team:handle(Cmd, Status, Params);
%% 						"36" -> pp_boss:handle(Cmd, Status, Params);
%% 						"40" -> pp_guild:handle(Cmd, Status, Params);
%% 						"41" -> pp_pet:handle(Cmd, Status, Params);
%% 						"42" -> pp_tree:handle(Cmd, Status, Params);
%% 						"44" -> pp_giant_s:handle(Cmd, Status, Params);
%% 						"45" -> pp_hunt:handle(Cmd, Status, Params);
%% 						"46" -> pp_dungeon:handle(Cmd, Status, Params);
%% 						"47" -> pp_hook:handle(Cmd, Status, Params);
%% 						"49" -> pp_mine:handle(Cmd, Status, Params);
%% 						"52" -> pp_help:handle(Cmd, Status, Params);
%% 						"56" -> pp_theater:handle(Cmd, Status, Params); 
%% 						"57" -> pp_vip:handle(Cmd, Status, Params);
%% 						"58" -> pp_rela:handle(Cmd, Status, Params);
%% 						"59" -> pp_target:handle(Cmd, Status, Params);
%% 						"63" -> pp_elite:handle(Cmd, Status, Params);
%% 						"64" -> pp_house:handle(Cmd, Status, Params);
%% 						"38" -> pp_conflict:handle(Cmd, Status, Params);
%% 						_ -> %%错误处理
%% 							skip
%% 					end;
%% 				true ->
%% 					skip
%% 			end,
%% 			is_cmd;
%%         _ -> no_cmd
%%     end.
%% 
%% 
%% 
%% 
%% %%获取玩家实际闪避，暴击 ，反擊： 返回{Crit, Ddge, Cter}
%% get_crr_spec(Status) ->
%% 	CareerInfo = lib_player:get_career_info(Status#player.crr),
%% 	Crit = CareerInfo#ets_base_career.crit,
%% 	Ddge = CareerInfo#ets_base_career.ddge,
%% 	Cter = CareerInfo#ets_base_career.cter,
%% 	{Crit, Ddge, Cter}.
%% 	
%% 
%% %%func001把两个列表进行组合
%% %%把阵法格子位置与宠物ID组合成相应的数据结构，形如:[{宠物ID1, 2, 格子位置1},{宠物ID2, 2, 格子位置2}]
%% func001([], [], Res) ->
%% Res;
%% 
%% func001([], PosList, Res) ->
%% 	PosOther = [{0,0,P} || P <- PosList, P > 0],
%% 	Res1= Res ++ PosOther,
%% 	func001([], [], Res1);
%% 
%% func001(_PetIdList, [], Res) ->
%% 	func001([], [], Res);
%% 
%% func001(PetIdList, PosList, Res) ->
%% 	[PetId|Tpet] = PetIdList,
%% 	[Pos|Tpos] = PosList,
%% 
%% 	F = fun(PetId,Pos) ->
%% 			if Pos > 0 ->
%% 				if PetId =/= [] ->
%% 					[{PetId, 2, Pos}];
%% 				true ->
%% 					[{0,0,Pos}]
%% 				end;
%% 			true ->
%% 				[]
%% 			end
%% 		end,
%% 
%% 	Res1 = Res ++ F(PetId, Pos),
%% 	func001(Tpet, Tpos, Res1).
%% 
%% 
%% %%重启羊驼活动时间
%% reset_alpaca_start_time(LaterTime) ->
%% 	Now = util:unixtime(),
%% 	{Todaymidnight, _} = util:get_midnight_seconds(Now),
%% 	StartTime = Now + LaterTime - Todaymidnight,
%% 	lib_island:reset_alpaca_start_time(StartTime),
%% 	Servers = mod_disperse:server_list(),
%% 	F = fun(S) ->
%% 				case rpc:call(S#server.node,lib_island,reset_alpaca_start_time,[StartTime]) of
%% 					{badrpc,_} ->
%% 						[];
%% 					_ ->
%% 						[]
%% 				end
%% 		end,
%% 	lists:foreach(F, Servers).
%% 
%% %%重设海运时间
%% reset_sea_start_time(LaterTime) ->
%% 	Now = util:unixtime(),
%% 	{Todaymidnight, _} = util:get_midnight_seconds(Now),
%% 	StartTime = Now + LaterTime - Todaymidnight,
%% 	lib_cross:reset_sea_start_time(StartTime),
%% 	Servers = mod_disperse:server_list(),
%% 	F = fun(S) ->
%% 				case rpc:call(S#server.node,lib_cross,reset_sea_start_time,[StartTime]) of
%% 					{badrpc,_} ->
%% 						[];
%% 					_ ->
%% 						[]
%% 				end
%% 		end,
%% 	lists:foreach(F, Servers).
%% 	
%% %%调用gateway重导sql表
%% load_mysql_table(TableName) ->
%% 	NoteList = nodes(),		%%用nodes()会包含gateway节点
%% 	F = fun(N) ->
%% 				N1 = atom_to_list(N),				%%把单引号的原子转成双引号的列表
%% 				case string:tokens(N1, "@") of		%%折出字段, 在gateway执行
%% 					["game_gateway", _] ->
%% 						case rpc:call(N,mysql_to_emongo,start2,[TableName]) of
%% 							{badrpc,_} ->
%% 								[];
%% 							_ ->
%% 								[]
%% 						end;
%% 					_ ->
%% 						[]
%% 				end
%% 		end,
%% 	lists:map(F, NoteList).			
%% 
%% 
%% 
%% %%重导Type类型表
%% load_base_data(Type) ->
%% 	try
%% 		mod_kernel:load_base_data(Type),
%% 		Servers = mod_disperse:server_list(),
%% 		F = fun(S) ->
%% 					case rpc:call(S#server.node,mod_kernel,load_base_data,[Type]) of
%% 						{badrpc,_} ->
%% 							[];
%% 						_ ->
%% 							[]
%% 					end
%% 			end,
%% 		lists:foreach(F, Servers)
%% 	catch
%% 		_:_Reason ->
%% 			_Reason
%% 	end.
