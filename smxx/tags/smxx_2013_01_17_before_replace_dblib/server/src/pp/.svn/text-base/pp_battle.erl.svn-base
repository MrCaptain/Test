%% Author: liujing
%% Created: 2011-8-3
%% Description: 战斗及封装战斗数据包
-module(pp_battle).
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl").
-compile([export_all]).


%% %% 战斗函数
%% %% LPlayer - 攻击方玩家记录#player
%% %% LPlayerBattle - 攻击方战斗记录#battle
%% %% WarMode - 战斗模式(0/1)，即(pvp/pve)
%% %% RightId 防守方数据(当战斗模式为pvp时,为防守玩家id;当战斗模式为pve时,为怪物群组id)
%% %% LBattleArray 攻击方玩家的阵型记录
%% handle(20001, LPlayer, [MongrpId, _DungId]) ->
%% 	Is_operate_ok = tool:is_operate_ok(lists:concat([pp_20001]), 1),		%%包以1秒时间计
%% 	if Is_operate_ok =:= true ->
%% 		   case lib_dungeon:can_fight_dungeon(LPlayer, MongrpId) of
%% 			   [1, DungId, MType] ->
%% 				   case handing(LPlayer, MongrpId, DungId, MType) of
%% 					   {ok, PlayerStatus, BinData} ->
%% 						   lib_send:send_to_sid(PlayerStatus#player.other#player_other.pid_send, BinData),
%% 						   {ok, PlayerStatus};
%% 					   R when is_integer(R) ->
%% 						   BinData = pt:pack(20001, <<0:8, R:8>>),
%% 						   lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 						   ok;
%% 					   _ ->
%% 						   BinData = pt:pack(20001, <<0:8, 0:8>>),
%% 						   lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 						   ok
%% 				   end;
%% 			   [Res, _, _] ->
%% 				   BinData = pt:pack(20001, <<0:8, Res:8>>),
%% 				   lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 				   ok;
%% 			   _ ->            %%该怪物点不能打
%% 				   BinData = pt:pack(20001, <<0:8, 3:8>>),
%% 				   lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 				   ok
%% 		   end;
%% 	   true ->
%% 		   ok
%% 	end;
%% 
%% handle(20002, LPlayer, [RPlayerId]) ->   %%与他切磋
%% 	%%io:format("~s 20002_______RPlayerId________[~p]\n",[misc:time_format(now()), RPlayerId]),
%% 	%% 	handing(LPlayer, 0, RPlayerId, 100001, 0, 0),      %%副本ID =0和100000 被竞技场用了，这里设100001是避免和真实的副本ID冲突
%% 	{PBattleData, PFrmt} =  lib_battle:getPlayerBattleData(LPlayer),
%% 	PlayerLBR = lib_battle:iniBattleRecord(PBattleData, PFrmt, 0),
%% 	[_, _, _, _, RBData, _RList, BPFrmt] = lib_battle:getArmyPlayerBattleData(RPlayerId),
%% 	PlayerRBR = lib_battle:iniBattleRecord(RBData, BPFrmt, 0),
%% 	case pp_battle:battle_handing(PlayerLBR, PlayerRBR, normal) of
%% 		{_BR, Bin, _BinOther, _LR, _RR, _Ret} ->
%% 			[];
%% 		_ ->
%% 			{_BR,Bin} = {2,<<>>}
%% 	end,
%% 	RPlayerName = lib_battle:getRPlayerName(RPlayerId, PlayerRBR),
%% 	lib_battle:putShareBattle(LPlayer#player.id, LPlayer#player.nick, RPlayerId, RPlayerName, 0, Bin), %%缓存战斗数据
%% 	Bin_20002 = pt:pack(20002, <<Bin/binary>>),
%% 	lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, Bin_20002),
%% 	lib_task:event(pk, [1], LPlayer),
%% 	ok;
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 多人副本战斗协议处理函数
%% %% 用多人副本代理进程运算
%% %% -----------------------------------------------------------------
%% handle(20003, Status, [Flag]) ->
%% 	%% 先获取战斗数据，包括副本，成员，队伍
%% 	case mod_team:get_battle_env(Status#player.id,Flag) of
%% 		[1,Team,Dungeon,TeamMembers] ->
%% 			%%1.0 获取怪物群组的初始战斗数据，列表和阵型
%% 			{RCode,NewStatus} = lib_team_battle:launch_fight(Status,Team,Dungeon,TeamMembers) 	;
%% 		 [RCode,_,_,_] ->
%% 			NewStatus = Status 
%% 	end ,
%% 	{ok, BinData} = pt_20:write(20003, [RCode]),
%% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	{ok, NewStatus} ;
%% 	
%% 
%% 
%% %%打怪掉落物品拾取
%% handle(20006, Status, _Data) ->
%% 	Is_operate_ok = tool:is_operate_ok("pp_20006", 1),		%%包以1秒时间计
%% 	if 
%% 		Is_operate_ok =:= true ->
%% 			MonGoodsInfo = get(mongoodslists),
%% 			case MonGoodsInfo of
%% 				[] ->
%% 					Res = 1,
%% 					NewStatus = Status;
%% 				undefined ->
%% 					Res = 1,
%% 					NewStatus = Status;
%% 				_ ->
%% 					[GoodsList, CostPoint] = 
%% 						case MonGoodsInfo of
%% 							[Goods, Point] ->			%%带了消费点
%% 								[Goods, Point];
%% 							_ ->						%%未带消费点
%% 								[MonGoodsInfo, 2002]
%% 						end,
%% 					case lib_goods:player_add_goods_2(Status, GoodsList, CostPoint) of
%% 						{AddRes, _PChg, NewStatus} ->
%% 							if
%% 								AddRes =:= 1 ->					%%给予成功
%% 									put(mongoodslists, []),		%%清空奖励
%% 									lib_task:event(item, GoodsList, Status),
%% 									lib_elite:boradcast_elite_award_goods(Status#player.id, Status#player.nick, GoodsList);	%%精英副本广播
%% 								true ->							%%不成功
%% 									skip
%% 							end,
%% 							Res = AddRes;
%% 						_ ->									%%未知返回
%% 							Res = 1,
%% 							NewStatus = Status
%% 					end
%% 			end,
%% 			{ok, GoodsBin} = pt_20:write(20006, [Res]),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin),
%% 			{ok, NewStatus#player{stts = 0}};
%% 		true ->
%% 			{ok, Status}
%% 	end;
%% 			
%% %% 	GoodsList = get(mongoodslists),
%% %% 	%%io:format("~s handle_20006[~p] \n ",[misc:time_format(now()), [self(), GoodsList]]),
%% %% 	case GoodsList of
%% %% 		[] ->
%% %% 			{ok, GoodsBin} = pt_20:write(20006, [1]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% %% 		undefined ->
%% %% 			{ok, GoodsBin} = pt_20:write(20006, [1]),
%% %% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% %% 		_ ->
%% %% 			%% 区分卡片
%% %% 			GoodsListNoCard = [{GdId, GdNum}||{GdId, GdNum} <- GoodsList, lists:member(GdId, [260101, 260201, 260202, 260203, 260204, 260205]) =/= true],
%% %% 			case gen_server:call(Status#player.other#player_other.pid_goods, {'get_multi', Status, GoodsListNoCard}) of
%% %% 				1 ->
%% %% 					put(mongoodslists, []),
%% %% 					lib_task:event(item, GoodsList, Status),
%% %% 					
%% %% 					EliteInfo = get(elite_dungeon_info),
%% %% 					case EliteInfo of
%% %% 						[EliteId, EliteName] ->
%% %% 							%%获得掉落物品广播
%% %% 							spawn(fun()->lib_broadcast:broadcast_info(elite_drop, [Status#player.id, Status#player.nick, EliteId, EliteName, GoodsListNoCard])end);
%% %% 						_ ->
%% %% 							ok
%% %% 					end,
%% %% 					put(elite_dungeon_info, []),
%% %% 					
%% %% %% 					lib_elite:check_award_broadcast(Status, GoodsListNoCard),					
%% %% 					
%% %% 					GoodsListCard = [{GdId1, GdNum1}||{GdId1, GdNum1} <- GoodsList, lists:member(GdId1, [260101, 260201, 260202, 260203, 260204, 260205]) =:= true],
%% %% 					
%% %% 					%%io:format("~s handle_20006_2 card[~p] \n ",[misc:time_format(now()), [GoodsListCard]]),
%% %% 					lib_theater:add_cards(Status, GoodsListCard),
%% %% 					{ok, GoodsBin} = pt_20:write(20006, [1]),
%% %% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% %% 				ErrorNum ->      %%错误码（0-执行失败, 2- 物品不存在, 4-背包格子不够）
%% %% 					{ok, GoodsBin} = pt_20:write(20006, [ErrorNum]),
%% %% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin)
%% %% 			end
%% %% 	end,
%% %% 	put(bossmongoodslists, []),
%% %% 	%% 	io:format("~s handle_20006[~p] \n ",[misc:time_format(now()), [self(), GoodsList]]),
%% %% 	{ok, Status#player{stts = 0}};
%% 
%% handle(20007, Status, [GoodsId]) ->
%% 	GoodsListAll = get(mongoodslists),
%% 	%%io:format("~s handle_20007[~p] \n ",[misc:time_format(now()), [self(), GoodsListAll]]),
%% 	GoodsList = [{GdId, GdNum}||{GdId, GdNum} <- GoodsListAll, GdId =:= GoodsId],
%% 	
%% 	%%io:format("~s handle_20007_1[~p] \n ",[misc:time_format(now()), [self(), GoodsList]]),
%% 	case GoodsList of
%% 		[] ->
%% 			{ok, GoodsBin} = pt_20:write(20007, [1]),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% 		undefined ->
%% 			{ok, GoodsBin} = pt_20:write(20007, [1]),
%% 			lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% 		_ ->
%% 			%% 判断是否是卡片
%% 			case lists:member(GoodsId, [260101, 260201, 260202, 260203, 260204, 260205]) of
%% 				true ->
%% 					lib_theater:add_cards(Status, GoodsList),
%% 					NewGoodsList = [{GdId, GdNum}||{GdId, GdNum} <- GoodsListAll, GdId =/= GoodsId],
%% 					%%io:format("~s handle_20007_2 card[~p] \n ",[misc:time_format(now()), [GoodsId]]),
%% 					put(mongoodslists, NewGoodsList),
%% 					{ok, GoodsBin} = pt_20:write(20007, [1]),
%% 					lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% 				_ ->
%% 					case gen_server:call(Status#player.other#player_other.pid_goods, {'get_multi', Status, GoodsList}) of
%% 						1 ->
%% 							NewGoodsList = [{GdId, GdNum}||{GdId, GdNum} <- GoodsListAll, GdId =/= GoodsId],
%% 							%%io:format("~s handle_20007_2[~p] \n ",[misc:time_format(now()), [1]]),
%% 							put(mongoodslists, NewGoodsList),
%% 							lib_task:event(item, GoodsList, Status),
%% 							spawn(fun() -> lib_goods:public_add_get_goods_log(Status#player.id,   %%物品产出日志
%% 																	GoodsList,
%% 																	0,
%% 																	2002) end),
%% 							{ok, GoodsBin} = pt_20:write(20007, [1]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin);
%% 						ErrorNum ->      %%错误码（0-执行失败, 2- 物品不存在, 4-背包格子不够）
%% 							%%io:format("~s handle_20007_3[~p] \n ",[misc:time_format(now()), [ErrorNum]]),
%% 							{ok, GoodsBin} = pt_20:write(20007, [ErrorNum]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, GoodsBin)
%% 					end
%% 			end
%% 	end,
%% 	
%% 	{ok, Status};
%% 
%% handle(20008, Status, _Data) ->
%% 	%%io:format("~s handle_200080[~p] \n ",[misc:time_format(now()), null]),
%% %% 	Res = lib_cooldown:get_cd(4),
%% %% 	%%io:format("~s handle_20008[~p] \n ",[misc:time_format(now()), [self(), Res]]),
%% %% 	Now = util:unixtime(),
%% %% 	case Res < Now of
%% %% 		true ->
%% %% 			Time = 0;
%% %% 		_ ->
%% %% 			Time = Res - Now
%% %% 	end,
%% 	case lib_cooldown:get_cd(4) of
%% 		{Time,CDFlg} ->
%% 			case CDFlg of
%% 				true ->    %%允许打
%% 					Bin_20009 = pt:pack(20008, <<Time:16, 1:8>>);
%% 				_ ->    %%不允许打
%% 					Bin_20009 = pt:pack(20008, <<Time:16, 0:8>>)
%% 			end;
%% 		_ ->
%% 			Bin_20009 = pt:pack(20008, <<0:16, 0:8>>)
%% 	end,
%% 	%%io:format("~s handle_200082[~p] \n ",[misc:time_format(now()), [Time]]),
%% 	_RR = lib_send:send_to_sid(Status#player.other#player_other.pid_send, Bin_20009),
%% 	{ok, Status};
%% 
%% handle(20010, Player, _) ->
%% 	{Res,NPlayer}= lib_cooldown:clear_cd(4,Player,2010),
%% 	{ok, BinData} = pt_20:write(20010,[Res]),
%% 	lib_send:send_to_sid(Player#player.other#player_other.pid_send, BinData),
%% 	lib_player:send_player_attribute2(NPlayer,[]),
%% 	{ok,NPlayer};
%% 
%% 
%% %% ===================================
%% %% 联盟战，放到指定的代理进程里面进行运算
%% %% WarMode = 3 
%% %% ===================================
%% handle(20013, LPlayer, [FortId,RPlayerId,BClazz]) ->
%% 	[Code,BinWarAll,LAward,RAward] = mod_guild_battle_agent:exec_fight(LPlayer#player.id,LPlayer#player.unid,RPlayerId,LPlayer#player.scn,FortId,BClazz) ,
%%  	%%io:format("======handle(20013=~s VS ~p ,=~p,~p,~p~n",[LPlayer#player.nick,RPlayerId,Code,LAward,RAward]) ,
%% 	case Code  of
%% 		0 ->
%% 			[LCoin,LDevo] = LAward ,
%% 			LBin_20013 = pt:pack(20013, <<BinWarAll/binary,LCoin:32,LDevo:32>>),
%% 			lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, LBin_20013) ,
%% 			
%% 			[RCoin,RDevo] = RAward ,
%% 			RBin_20013 = pt:pack(20013, <<BinWarAll/binary,RCoin:32,RDevo:32>>),
%% 			lib_send:send_to_uid(RPlayerId, RBin_20013) ,
%% 			{ok, LPlayer} ;
%% 		RCode ->
%% 			Bin_20013 = pt:pack(20013, <<0:8, RCode:8>>) ,
%% 			lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, Bin_20013) ,
%% 			{error,[]}
%% 	end ; 
%% 
%% 
%% %% ===================================
%% %% 联盟战，联盟守护战，全部到代理进程里面进行运算
%% %% 
%% %% ===================================
%% handle(20015, LPlayer,[]) ->
%% %% 	CanFight =  lib_guild_guard:can_fight() ,
%% 	case LPlayer#player.unid > 0 of
%% 		true ->
%% 			[Code,BinWarAll,RNick,BAward] = mod_guild_guard_agent:launch_fight(LPlayer#player.id,LPlayer#player.unid) ,
%%  			
%% 			case Code  of
%% 				0 ->
%% 					RNickBin = tool:to_binary(RNick) ,
%% 					RNickLen = byte_size(RNickBin) ,
%% 					[Coin,Devo,Jade] = BAward , 
%% 					case Devo > 0 of
%% 						true ->
%% 							mod_guild:add_devo_jade(LPlayer#player.unid,[{LPlayer#player.id,Devo,Jade}]) ;
%% 						false ->
%% 							skip
%% 					end ,
%% 					case Coin > 0 of
%% 						true ->
%% 							NewStatus = lib_goods:add_money(LPlayer,Coin,coin,2015) ,
%% 							lib_player:send_player_attribute2(NewStatus,2) ;
%% 						false ->
%% 							NewStatus =  LPlayer
%% 					end ,
%% 					
%% 					Bin_20015 = pt:pack(20015, <<BinWarAll/binary,RNickLen:16,RNickBin/binary,Coin:32,Devo:32,Jade:32>>) ,
%% 					lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, Bin_20015) ,
%% 					{ok, NewStatus} ;
%% 				RCode ->
%% 					Bin_20015 = pt:pack(20015, <<0:8, RCode:8>>) ,
%% 					lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, Bin_20015) ,
%% 					{error,[]}
%% 			end ; 
%% 		false ->
%% 			{error,[]}
%% 	end ;
%% 	
%% 	
%% 	
%% 	
%% 	
%% %%分享战斗协议（分享请求），现改为由后端直接发送发送
%% handle(20021, LPlayer, _Data) ->
%% 	case lib_battle:doShareBattle() of
%% 		Re when is_tuple(Re) ->
%% 			{Id, LName, RName} = Re,
%% %% 			string:    tool:to_list(io_lib:format("~p,", [Id]))
%% 			ShareDataString = io_lib:format("~p,", [Id]) ++ tool:to_list(LName) ++ "," ++ tool:to_list(RName) ++  ",battle",
%% %% 			ShareDataBin = tool:to_binary(ShareDataString),
%% %% 			StrLen = byte_size(ShareDataBin),
%% %% 			ShareData = <<StrLen:16, ShareDataBin/binary>>,
%% 			lib_chat:chat_world(LPlayer, [ShareDataString]),
%% %% 			{ok, BinData} = pt_20:write(20021, [Re]),
%% 			BinData = pt:pack(20021, <<2:8>>);
%% 		_ ->
%% 			BinData = pt:pack(20021, <<2:8>>)
%% 	end,
%% 	lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 	{ok, LPlayer};
%% 
%% %%回放战斗分享数据
%% handle(20022, LPlayer, [Id]) ->
%% 	case db_agent_battle:getBattleShareData(Id) of
%% 		[] ->
%% 			BinData = pt:pack(20022, <<2:8>>);
%% 		ShareBin when is_list(ShareBin) ->
%% 			{ok, BinData} = pt_20:write(20022, [ShareBin]);
%% 		_ ->
%% 			BinData = pt:pack(20022, <<2:8>>)
%% 	end,
%% 	lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 	{ok, LPlayer};
%% 
%% %%请求精英BOSS奖励物品列表
%% handle(20031, LPlayer, _Data) ->
%% 	case get(bossmongoodslists) of
%% 		[0, BossGoodsList] ->
%% 			{ok, BinData} = pt_20:write(20031, BossGoodsList);
%% 		_ ->
%% 			BinData = pt:pack(20031, <<0:16>>)
%% 	end,
%% 	lib_send:send_to_sid(LPlayer#player.other#player_other.pid_send, BinData),
%% 	{ok, LPlayer};
%% 	
%% %%请求精英BOSS奖励物品列表
%% handle(20032, LPlayer, _Data) ->
%% 	case get(bossmongoodslists) of
%% 		[AwardNum, BossGoodsList] ->
%% 			if AwardNum > 2 ->
%% 				   NewLPlayer1 = LPlayer,
%% 				   BinData = pt:pack(20032, <<5:8>>);   %%抽奖次数已到上限不能抽奖
%% 			   true ->
%% 				   NullCellNum = gen_server:call(LPlayer#player.other#player_other.pid_goods, {'cell_num'}),
%% 				   if NullCellNum =< 0 ->
%% 						  NewLPlayer1 = LPlayer,
%% 						  BinData = pt:pack(20032, <<3:8>>);   %%背包没有一个以上的空格
%% 					  true ->
%% 						  GetGoldNum = data_player:get_lottery_time_gold(AwardNum),
%% 						  if GetGoldNum > 0 ->
%% 								 IsEnoughMoney = goods_util:is_enough_money(LPlayer, GetGoldNum, gold),
%% 								 case IsEnoughMoney of
%% 									 true ->
%% 										 NewLPlayer = lib_goods:cost_money(LPlayer, GetGoldNum, gold, 2001);
%% 									 _ ->
%% 										 NewLPlayer = LPlayer
%% 								 end;
%% 							 true ->
%% 								 IsEnoughMoney = true,
%% 								 NewLPlayer = LPlayer
%% 						  end,
%% 						  if IsEnoughMoney =:= true ->
%% %% 								 NewLPlayer = lib_goods:cost_money(LPlayer, GetGoldNum, gold, 2000),
%% %% 								 if NewLPlayer#player.gold =/= LPlayer#player.gold orelse GetGoldNum =:= 0 ->
%% 										AwardGoodsList = lib_battle:cptBossAward(BossGoodsList),   %%修改规则，使用了新函数(老天，2012-3-21又修改了)
%% 										NextAwardNum = AwardNum + 1,
%% 										NextGetGoldNum = data_player:get_lottery_time_gold(NextAwardNum),
%% 										case AwardGoodsList of
%% 											[] ->  %%没有奖励，加回元宝
%% 												NewLPlayer1 = lib_goods:add_money(NewLPlayer, GetGoldNum, gold, 2003),
%% 												BinData = pt:pack(20032, <<2:8>>);   %%没有精英BOSS奖励数据
%% 											[AwardGoods | _] ->
%% 												{GoodsId, _Ra, MinNum, _MaxNum} = AwardGoods,
%% 												case GoodsId of
%% 													210101 ->    %%铜币奖励
%% 														if NextAwardNum >= 3 ->
%% 															   put(bossmongoodslists, []);
%% 														   true ->
%% 															   NewBossGoodsList = BossGoodsList -- AwardGoodsList,
%% 															   put(bossmongoodslists, [NextAwardNum, NewBossGoodsList])
%% 														end,
%% 														NewLPlayer1 = lib_goods:add_money(NewLPlayer, MinNum, coin, 2004),
%% 														BinData = pt:pack(20032, <<1:8, NextAwardNum:8, NextGetGoldNum:16, GoodsId:32, 0:32, MinNum:32, 0:8>>);
%% 													210201 ->    %%元宝奖励
%% 														if NextAwardNum >= 3 ->
%% 															   put(bossmongoodslists, []);
%% 														   true ->
%% 															   NewBossGoodsList = BossGoodsList -- AwardGoodsList,
%% 															   put(bossmongoodslists, [NextAwardNum, NewBossGoodsList])
%% 														end,
%% 														NewLPlayer1 = lib_goods:add_money(NewLPlayer, MinNum, gold, 2004),
%% 														BinData = pt:pack(20032, <<1:8, NextAwardNum:8, NextGetGoldNum:16, GoodsId:32, 0:32, MinNum:32, 0:8>>);
%% 													_ ->
%% 														case gen_server:call(NewLPlayer#player.other#player_other.pid_goods, {'get_multi', NewLPlayer, [{GoodsId, MinNum}]}) of
%% 															1 ->  %%成功
%% 																if NextAwardNum >= 3 ->
%% 															   			put(bossmongoodslists, []);
%% 														   			true ->
%% 															   			NewBossGoodsList = BossGoodsList -- AwardGoodsList,
%% 															   			put(bossmongoodslists, [NextAwardNum, NewBossGoodsList])
%% 																end,
%% 																NewLPlayer1 = NewLPlayer,
%% 																BinData = pt:pack(20032, <<1:8, NextAwardNum:8, NextGetGoldNum:16, GoodsId:32, 0:32, MinNum:32, 0:8>>);
%% 															4 ->  %%添加背包格子不够，将消费的元宝加回去
%% 																NewLPlayer1 = lib_goods:add_money(NewLPlayer, GetGoldNum, gold, 2003),
%% 																BinData = pt:pack(20032, <<3:8>>);
%% 															2 ->  %%物品不存在，将消费的元宝加回去
%% 																NewLPlayer1 = lib_goods:add_money(NewLPlayer, GetGoldNum, gold, 2003),
%% 																BinData = pt:pack(20032, <<6:8>>);
%% 															_ ->  %%添加背包失败， 由于不知道原因，暂不加回元宝
%% 																NewLPlayer1 = NewLPlayer,
%% 																BinData = pt:pack(20032, <<7:8>>)
%% 														end
%% 												end,
%% 												lib_player:send_player_attribute(NewLPlayer1, 3);
%% 											_ ->  %%没有奖励，加回元宝
%% 												NewLPlayer1 = lib_goods:add_money(NewLPlayer, GetGoldNum, gold, 2003),
%% 												BinData = pt:pack(20032, <<2:8>>)   %%没有精英BOSS奖励数据
%% 										end;
%% %% 									true ->  %%扣除元宝没有成功
%% %% 										NewLPlayer1 = LPlayer,
%% %% 										BinData = pt:pack(20032, <<4:8>>)   %%元宝数量不够
%% %% 								 end;
%% 							 true ->
%% 								 NewLPlayer1 = NewLPlayer,
%% 								 BinData = pt:pack(20032, <<4:8>>)   %%元宝数量不够
%% 						  end
%% 				   end
%% 			end;
%% 		_ ->
%% 			NewLPlayer1 = LPlayer,
%% 			BinData = pt:pack(20032, <<5:8>>)
%% 	end,
%% 	lib_send:send_to_sid(NewLPlayer1#player.other#player_other.pid_send, BinData),
%% 	{ok, NewLPlayer1};
%% 
%% %%关闭抽奖
%% handle(20033, LPlayer, _Data) ->
%% 	put(bossmongoodslists, []),
%% 	{ok, LPlayer};
%% 
%% handle(_Cmd, _Status, _Data) ->
%% %%    ?DEBUG("pp_player no match", []),
%%     {error, "pp_player no match"}.
%% 
%% 
%% %%业务处理函数===============================================================================================
%% %%循环战斗处理函数(切记：传入battle_record参数一定是初始化后不带阵法相克属性或由本函数传出的battle_record数值)
%% handingLoop(Left_battle_record, Right_battle_record, _WarMode) ->
%% 	Left_battle_record_check = lib_battle:checkBattleRecord(Left_battle_record),   %%数据容错校验
%% 	Right_battle_record_check = lib_battle:checkBattleRecord(Right_battle_record), %%数据容错校验
%% 	if is_record(Left_battle_record_check, battle_record) andalso is_record(Right_battle_record_check, battle_record) ->
%% 		   {Left_battle_recordTmp, LList} = lib_battle:loadSimpleWarListLoop(left, Left_battle_record_check),
%% 		   {Right_battle_recordTmp, RList} = lib_battle:loadSimpleWarListLoop(right, Right_battle_record_check),
%% 		   
%% 		   LeftFId = Left_battle_recordTmp#battle_record.bbtid,
%% 		   RightFId = Right_battle_recordTmp#battle_record.bbtid,
%% 		   LFormation = lib_formation:getFrmtFromId(LeftFId),
%% 		   RFormation = lib_formation:getFrmtFromId(RightFId),
%% 		   
%% 		   RstFL = lib_battle:formationRestraintData(LFormation, RFormation),  %%生成阵法相克属性列表
%% 		   
%% 		   LRstFL = [{Drct1, _Attr1, _Chg1, _CTyp1, _Val1}||{Drct1, _Attr1, _Chg1, _CTyp1, _Val1}<-RstFL, Drct1 =:= left],  %%提取左方阵法相克加成列表
%% 		   %%添加进攻方相克属性并将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 		   Left_battle_record1 = lib_battle:addRstArt(Left_battle_recordTmp, LRstFL), 
%% 		   %%打包进攻方初始化属性
%% 		   {Bin_Pos1, Bin_Pet1, Bin_Mon1} = lib_battle:binRole(Left_battle_record1, {<<>>, <<>>, <<>>}),
%% 		   
%% 		   RRstFL = [{Drct2, _Attr2, _Chg2, _CTyp2, _Val2}||{Drct2, _Attr2, _Chg2, _CTyp2, _Val2}<-RstFL, Drct2 =:= right],
%% 		   %%添加防守方相克属性并将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 		   Right_battle_record1 = lib_battle:addRstArt(Right_battle_recordTmp, RRstFL),
%% 		   %%打包防守方初始化属性
%% 		   {Bin_Pos2, Bin_Pet2, Bin_Mon2} = lib_battle:binRole(Right_battle_record1, {Bin_Pos1, Bin_Pet1, Bin_Mon1}),
%% 		   Battle_Sequence_List = lib_battle:role_merge(LList, RList, []),     %%生成战斗队列
%% 		   %% 			{Bin_Pos_Len, Bin_Pet_Len, Bin_Mon_Len} = lib_battle:getRoleNum(Battle_Sequence_List),
%% 		   {Bin_Pos_Len, Bin_Pet_Len, Bin_Mon_Len} = lib_battle:getRoleNum(Left_battle_record1, Right_battle_record1),
%% 		   Bin_Pos = <<Bin_Pos_Len:16, Bin_Pos2/binary>>,
%% 		   Bin_Pet = <<Bin_Pet_Len:16, Bin_Pet2/binary>>,
%% 		   Bin_Mon = <<Bin_Mon_Len:16, Bin_Mon2/binary>>,
%% 		   
%% 		   {LGiantNum, LGiantBin} = lib_battle:checkGiand(Left_battle_record1, 1),    %%打包巨兽数据
%% 		   {RGiantNum, RGiantBin} = lib_battle:checkGiand(Right_battle_record1, 2),
%% 		   GiantNum = LGiantNum + RGiantNum,
%% 		   GiantBin = <<GiantNum:16, LGiantBin/binary, RGiantBin/binary>>,
%% 		   Bin_Role = <<Bin_Pos/binary, Bin_Pet/binary, GiantBin/binary, Bin_Mon/binary>>,
%% 		   
%% 		   BattleSta = #battleSta{leftAllRela = data_battle:cptChkRelaRand(Left_battle_record1),
%% 								  rightAllRela = data_battle:cptChkRelaRand(Right_battle_record1)}, 
%% 		   LeftAllMaxHp = lib_battle:cptBattleAllHp(Left_battle_record1),
%% 		   RightAllMaxHp = lib_battle:cptBattleAllHp(Right_battle_record1),
%% 		   MyBattleScore = #battleScore{
%% 										score_round = 1,
%% 										left_all_hp = LeftAllMaxHp,
%% 										right_all_hp = RightAllMaxHp
%% 									   },
%% 		   Bin_War = <<>>,
%% 		   {MM, War_Num ,Bin_War1, ReLeft_battle_record,ReRight_battle_record, _NewMyBattleScore} = 
%% 			   lib_battle:act_begin(LList, RList ,Battle_Sequence_List, Left_battle_record1, Right_battle_record1, BattleSta, 0, Bin_War, MyBattleScore),
%% %% 		   BinBattleDisData = lib_battle:binBattleDisData(ReLeft_battle_record, ReRight_battle_record),
%% %% 		   Bin_War_All = <<MM:8, LeftFId:32, RightFId:32, 0:8, 0:8, 0:8, 0:8, 0:8, 0:32, 0:32, 0:32, 0:8, 0:16, BinBattleDisData/binary, Bin_Role/binary, War_Num:16, Bin_War1/binary>>,
%% 		   Bin_War_All = <<MM:8, Bin_Role/binary, War_Num:16, Bin_War1/binary>>,
%% 		   NewLeft_battle_record = lib_battle:putArt(Left_battle_record_check, ReLeft_battle_record, 0),   %%将新血量及怒气带入到最初的战斗记录
%% 		   NewRight_battle_record = lib_battle:putArt(Right_battle_record_check, ReRight_battle_record, 0), %%将新血量及怒气带入到最初的战斗记录
%%            
%%            %%获取失败一方Id列表
%%            UidList = if 
%%              MM =:= 2 ->
%%                 lists:usort([X#member.id||X<-Left_battle_record_check#battle_record.members, X#member.mtype =:= 1]);
%%              MM =:= 1 ->
%%                 lists:usort([X#member.id||X<-Right_battle_record_check#battle_record.members, X#member.mtype =:= 1]);
%%              true -> 
%%                 []
%%            end,
%%            %%通知成就系统：死亡一次
%% 		   {MM, Bin_War_All, NewLeft_battle_record, NewRight_battle_record};
%% 	   true ->
%% 		   {error, 1}   %%数据错误
%% 	end.
%% 
%% %%战斗处理逻辑（单人副本PVE战斗）
%% handing(Player, MonGid, DungId, MType) ->
%% 	if Player#player.stts =:= 0 orelse Player#player.stts =:= 2 ->	                    %%%玩家状态判定
%% 		   {MonBattleData, GoodsList, MonFrmt} = lib_battle:getMonBattleData(MonGid),
%% 		   MonBR = lib_battle:iniBattleRecord(MonBattleData, MonFrmt, 0),
%% 		   {PBattleData, PFrmt} =  lib_battle:getPlayerBattleData(Player),
%% 		   PlayerBR = lib_battle:iniBattleRecord(PBattleData, PFrmt, 0),
%% %% 		   io:format("DungId____[~p]\n", [DungId]),
%% 		   case lists:member(DungId, [101105,101106,101111,101112]) of
%% 			   true ->
%% 				   BattleOther = #battle_other{b_rela = 1};
%% 			   _  ->
%% 				   BattleOther = #battle_other{}
%% 		   end,
%% 		   case battle_handing(PlayerBR, MonBR, normal, BattleOther) of
%% 			   {MM, WarBin, _BinOther, LR, _RR, _Ret} ->
%% 				   DungName = lib_dungeon:getDungName(DungId),  %%获取副本名字
%% 				   case MM of
%% 					   2 ->		     %%战斗失败
%% 						   PveBattleGrade = 0,   %%lib_battle:battleScore(MM, RR),
%% 						   GradeList = lib_battle:cpt_every_grade(Player),
%% 						   GradeLen = length(GradeList),
%% 						   Fun1 = fun({GradeType, GradeSw, GradeNum, Ffc, StdFfc}) ->
%% 										  <<GradeType:8, GradeSw:8, GradeNum:8, Ffc:32, StdFfc:32>>
%% 								  end,
%% 						   GradeBinList = lists:map(Fun1, GradeList),
%% 						   GradeBin = list_to_binary(GradeBinList),
%% 						   GradeBinAll = <<GradeLen:16, GradeBin/binary>>,
%% 						   GoodsBinAll = <<0:16>>,
%% 						   Bin_War_All = <<1:8, PveBattleGrade:8, GradeBinAll/binary, GoodsBinAll/binary, WarBin/binary>>,
%% 						   lib_battle:putShareBattle(Player#player.id, Player#player.nick, DungId, DungName, 1, Bin_War_All), %%缓存战斗数据
%% 						   Bin_20001 = pt:pack(20001, <<Bin_War_All/binary>>),
%% 						   NewPlayer = lib_dungeon:update_fight_dungeon(Player, MonGid, MM, PveBattleGrade),
%% %% 						   lib_send:send_to_sid(Player#player.other#player_other.pid_send, Bin_20001),
%% %% 						   {ok, Player#player{stts = 2}};
%%                            %%通知成就系统：杀怪一次
%% 						   {ok, NewPlayer, Bin_20001};
%% 					   1 ->           %%战斗胜利
%% 						   GetGoodsList1 = lib_goods_use:get_other_data_goods_list(GoodsList),
%% 						   case MType of
%% 							   1 ->
%% 								   TaskGoods = lib_task:get_item_goods(Player, DungId);
%% 							   _ ->
%% 								   TaskGoods = []
%% 						   end,
%% 						   GetGoodsList2 = GetGoodsList1 ++ TaskGoods,
%% 						   GetGoodsList = cpt_eng_awards(GetGoodsList2, Player),
%% 						   {BagGoodsList, VtlGoodsList} = lib_goods:split_goods(GetGoodsList),
%% 						   {_BPChg, NewPlayer} = lib_goods:add_virtual_goods(Player, VtlGoodsList, 2001),
%% 						   put(mongoodslists, [BagGoodsList, 2002]),
%% 						   GoodsLen = length(GetGoodsList),
%% 						   Fun1 = fun(GoodsM2) ->
%% 										  {GoodsId1, GoodsNum1} = GoodsM2,
%% 										  <<GoodsId1:32, GoodsNum1:32>>
%% 								  end,
%% 						   GoodsBinList = lists:map(Fun1, GetGoodsList),
%% 						   GoodsBin = list_to_binary(GoodsBinList),
%% 						   GoodsBinAll = <<GoodsLen:16, GoodsBin/binary>>,
%% 						   PveBattleGrade = lib_battle:battleScore(MM, LR),
%% 						   GradeBinAll = <<0:16>>,
%% 						   Bin_War_All = <<1:8, PveBattleGrade:8, GradeBinAll/binary, GoodsBinAll/binary, WarBin/binary>>,
%% 						   lib_battle:putShareBattle(NewPlayer#player.id, NewPlayer#player.nick, DungId, DungName, 1, Bin_War_All), %%缓存战斗数据
%% 						   
%% 						   MonId_List = [MonMember#member.id||MonMember<-MonBR#battle_record.members, MonMember#member.mtype =:= 3],
%% 						   KillMonList = lib_battle:cptMonNum(MonId_List),
%% 
%% 						   gen_server:cast(NewPlayer#player.other#player_other.pid_task,{'task_event',NewPlayer,kill,KillMonList}),
%%                            %%通知成就系统：杀怪一次
%% %% 						   case EngFlag of
%% %% 							   1 ->
%% %% 								   DungEng = data_battle:get_dung_energy(DungType),
%% %% 								   NewPlayer3 = lib_player:cost_energy(NewPlayer2, DungEng, 2001),
%% %% 								   lib_player:send_player_attribute2(NewPlayer3, 3);
%% %% 							   _ ->
%% %% 								   NewPlayer3 = NewPlayer2
%% %% 						   end,
%% 
%% 						   NewPlayer1 = lib_dungeon:update_fight_dungeon(NewPlayer, MonGid, MM, PveBattleGrade),
%% 						   Bin_20001 = pt:pack(20001, <<Bin_War_All/binary>>),
%% %% 						   {ok, NewPlayer3#player{stts = 2}, Bin_20001};
%% 						   {ok, NewPlayer1, Bin_20001};
%% 					   _ ->
%% 						   {error,[]}
%% 				   end;
%% 			   _ ->
%% 				   3 
%% 		   end;
%% 	   true ->
%% 		   2
%% 	end.
%% 
%% %%常用接口
%% battle_handing(Left_battle_record, Right_battle_record, Proty) ->
%% 	battle_handing(Left_battle_record, Right_battle_record, Proty, #battle_other{}).
%% 
%% 
%% %%新战斗实现函数（兼容循环战斗和先攻方式Proty：left/right, BattleFlag:0-为通用，1-为多人副本，循环战斗传回battle_record数据不同）
%% battle_handing(Left_battle_record, Right_battle_record, Proty, BattleOther) ->
%% 	Left_battle_record_check = lib_battle:checkBattleRecord(Left_battle_record),   %%数据容错校验
%% 	Right_battle_record_check = lib_battle:checkBattleRecord(Right_battle_record), %%数据容错校验
%% 	if is_record(Left_battle_record_check, battle_record) andalso is_record(Right_battle_record_check, battle_record) ->
%% 		   {Left_battle_recordTmp, LList} = lib_battle:loadSimpleWarListLoop(left, Left_battle_record_check),
%% 		   {Right_battle_recordTmp, RList} = lib_battle:loadSimpleWarListLoop(right, Right_battle_record_check),
%% 		   
%% 		   LeftFId = Left_battle_recordTmp#battle_record.bbtid,
%% 		   RightFId = Right_battle_recordTmp#battle_record.bbtid,
%% 		   LFormation = lib_formation:getFrmtFromId(LeftFId),
%% 		   RFormation = lib_formation:getFrmtFromId(RightFId),
%% 		   
%% 		   RstFL = lib_battle:formationRestraintData(LFormation, RFormation),  %%生成阵法相克属性列表
%% 		   
%% 		   LRstFL = [{Drct1, _Attr1, _Chg1, _CTyp1, _Val1}||{Drct1, _Attr1, _Chg1, _CTyp1, _Val1}<-RstFL, Drct1 =:= left],  %%提取左方阵法相克加成列表
%% 		   %%添加进攻方相克属性并将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 		   Left_battle_record1 = lib_battle:addRstArt(Left_battle_recordTmp, LRstFL), 
%% 		   %%打包进攻方初始化属性
%% 		   {Bin_Pos1, Bin_Pet1, Bin_Mon1} = lib_battle:binRole(Left_battle_record1, {<<>>, <<>>, <<>>}),
%% 		   
%% 		   RRstFL = [{Drct2, _Attr2, _Chg2, _CTyp2, _Val2}||{Drct2, _Attr2, _Chg2, _CTyp2, _Val2}<-RstFL, Drct2 =:= right],
%% 		   %%添加防守方相克属性并将命中、暴击、闪避、格挡、反击、连携值转换为概率值(百分比*10000)
%% 		   Right_battle_record1 = lib_battle:addRstArt(Right_battle_recordTmp, RRstFL),
%% 		   %%打包防守方初始化属性
%% 		   {Bin_Pos2, Bin_Pet2, Bin_Mon2} = lib_battle:binRole(Right_battle_record1, {Bin_Pos1, Bin_Pet1, Bin_Mon1}),
%% 		   Battle_Sequence_List = lib_battle:role_merge(LList, RList, [], Proty),     %%生成战斗队列
%% 		   %% 			{Bin_Pos_Len, Bin_Pet_Len, Bin_Mon_Len} = lib_battle:getRoleNum(Battle_Sequence_List),
%% 		   {Bin_Pos_Len, Bin_Pet_Len, Bin_Mon_Len} = lib_battle:getRoleNum(Left_battle_record1,Right_battle_record1),
%% 		   Bin_Pos = <<Bin_Pos_Len:16, Bin_Pos2/binary>>,
%% 		   Bin_Pet = <<Bin_Pet_Len:16, Bin_Pet2/binary>>,
%% 		   Bin_Mon = <<Bin_Mon_Len:16, Bin_Mon2/binary>>,
%% 		   
%% 		   {LGiantNum, LGiantBin} = lib_battle:checkGiand(Left_battle_record1, 1),    %%打包巨兽数据
%% 		   {RGiantNum, RGiantBin} = lib_battle:checkGiand(Right_battle_record1, 2),
%% 		   GiantNum = LGiantNum + RGiantNum,
%% 		   GiantBin = <<GiantNum:16, LGiantBin/binary, RGiantBin/binary>>,
%% 		   Bin_Role = <<Bin_Pos/binary, Bin_Pet/binary, GiantBin/binary, Bin_Mon/binary>>, 
%% 		   BRela = BattleOther#battle_other.b_rela,
%% 		   if BRela =:= 1 ->
%% 				  BattleSta = #battleSta{pDirect = Proty,
%% 										 leftAllRela = 10000,
%% 										 rightAllRela = 10000,
%% 										 b_rela = BRela
%% 										};
%% 			  true ->
%% 				  BattleSta = #battleSta{pDirect = Proty,
%% 										 leftAllRela = data_battle:cptChkRelaRand(Left_battle_record1),
%% 										 rightAllRela = data_battle:cptChkRelaRand(Right_battle_record1),
%% 										 b_rela = BRela
%% 										}
%% 		   end,
%% 		   LeftAllMaxHp = lib_battle:cptBattleAllHp(Left_battle_record1),
%% 		   RightAllMaxHp = lib_battle:cptBattleAllHp(Right_battle_record1),
%% 		   MyBattleScore = #battleScore{
%% 										score_round = 1,
%% 										left_all_hp = LeftAllMaxHp,
%% 										right_all_hp = RightAllMaxHp
%% 									   },
%% 		   Bin_War = <<>>,
%% 		   {MM, War_Num ,Bin_War1, ReLeft_battle_record,ReRight_battle_record, NewMyBattleScore} = 
%% 			   lib_battle:act_begin(LList, RList ,Battle_Sequence_List, Left_battle_record1, Right_battle_record1, BattleSta, 0, Bin_War, MyBattleScore),
%% %% 		   BinBattleDisData = lib_battle:binBattleDisData(ReLeft_battle_record, ReRight_battle_record),
%% 		   %% 			Bin_War_All = <<MM:8, LeftFId:32, RightFId:32, 0:8, 0:8, 0:8, 0:8, 0:8, 0:32, 0:32, 0:32, 0:8, 0:16, BinBattleDisData/binary, Bin_Role/binary, War_Num:16, Bin_War1/binary>>,
%% 		   BinGiantDis = pack_giant_dis(ReLeft_battle_record, ReRight_battle_record),
%% 		   Bin_War_All = <<MM:8, BinGiantDis/binary, Bin_Role/binary, War_Num:16, Bin_War1/binary>>,
%% %% 		   io:format("battle_handing---1---[~p]\n", [BinGiantDis]),
%% 		   BattleFlag = BattleOther#battle_other.binsta,
%% 		   if BattleFlag =:= 1 ->      %%旧版的多人副本是自己初始化角色信息的
%% 				  Bin_War_OnlyBattle = <<War_Num:16, Bin_War1/binary>>;
%% 			  true ->
%% %% 				  Bin_War_OnlyBattle = <<MM:8, LeftFId:32, RightFId:32, BinBattleDisData/binary, Bin_Role/binary, War_Num:16, Bin_War1/binary>>
%% 				  Bin_War_OnlyBattle = <<MM:8, BinGiantDis/binary, Bin_Role/binary, War_Num:16, Bin_War1/binary>>
%% 		   end,
%% 		   NewLeft_battle_record = lib_battle:putArt(Left_battle_record_check, ReLeft_battle_record, BattleFlag),   %%将新血量及怒气带入到最初的战斗记录
%% 		   NewRight_battle_record = lib_battle:putArt(Right_battle_record_check, ReRight_battle_record, BattleFlag), %%将新血量及怒气带入到最初的战斗记录
%%            %%获取失败一方Id列表
%%            UidList = if 
%%              MM =:= 2 ->
%%                 lists:usort([X#member.id||X<-Left_battle_record_check#battle_record.members, X#member.mtype =:= 1]);
%%              MM =:= 1 ->
%%                 lists:usort([X#member.id||X<-Right_battle_record_check#battle_record.members, X#member.mtype =:= 1]);
%%              true -> 
%%                 []
%%            end,
%%            %%通知成就系统：死亡一次
%% 		   {MM, Bin_War_All, Bin_War_OnlyBattle, NewLeft_battle_record, NewRight_battle_record, NewMyBattleScore};
%% 	   true ->
%% 		   false   %%数据错误
%% 	end.
%% 
%% %%单人副本的收益计算
%% cpt_eng_awards(GoodsList, Player) ->
%% 	EngRadio = lib_player:get_reward_ratio_by_eng(Player),
%% 	Fun = fun({GoodsType, Num}) ->
%% 				  case GoodsType of
%% 					  210102 ->
%% 						  {GoodsType, round(Num * EngRadio)};
%% 					  _ ->
%% 						  {GoodsType, Num}
%% 				  end
%% 		  end,
%% 	lists:map(Fun, GoodsList).
%% 
%% %%打包巨兽悬浮信息
%% pack_giant_dis(LBattleRecord, RBattleRecord) ->
%% 	BRList = [{1, LBattleRecord}, {2, RBattleRecord}],
%% 	Fun = fun({Direct, BR}, AccBinL) ->
%% 				  if 
%% 					  BR#battle_record.behId =:= 0 ->
%% 						 AccBinL;
%% 					  true ->
%% 						  BinNick = tool:to_binary(BR#battle_record.nick),
%% 						  BinNickLen = byte_size(BinNick),
%% 						  GiantQly = BR#battle_record.qly,
%% 						  GiantLv = BR#battle_record.behLv,
%% 						  {DisPAtrL, _AddPL} = lib_giant_s:cpt_player_atr(d, GiantLv),
%% 						  {DisAAtrL, _AddAL} = lib_giant_s:cpt_all_atr(g, GiantLv),
%% 						  BinPAL = [<<AtrId1:8, Num1:32>>||{AtrId1, Num1}<-DisPAtrL],
%% 						  BinPLen = length(BinPAL),
%% 						  BinPA = list_to_binary(BinPAL),
%% 						  BinAAL = [<<AtrId2:8, Num2:32>>||{AtrId2, Num2}<-DisAAtrL],
%% 						  BinALen = length(BinAAL),
%% 						  BinAA = list_to_binary(BinAAL),
%% 						  TechId = BR#battle_record.behThId,
%% 						  TechLv = BR#battle_record.teclv,
%% 						  ActType = BR#battle_record.crr,
%% 						  TechPwr = BR#battle_record.techv,
%% 						  FrmtLv = BR#battle_record.frlv,
%% 						  FrmAtrL = lib_giant_s:cpt_frmt_atr(g, FrmtLv),
%% 						  BinFrmtL = lists:map(fun({Pst, {DisAtrL, _AddAtrL}}) ->
%% 													  BinDataL = [<<AtrId3:8, Num3:32>>||{AtrId3, Num3}<-DisAtrL],
%% 													  BinLen = length(BinDataL),
%% 													  BinData = list_to_binary(BinDataL),
%% 													  <<Pst:8, BinLen:16, BinData/binary>>
%% 											  end, FrmAtrL),
%% 						  BinFrmtLen = length(BinFrmtL),
%% 						  BinGiantFrmt = list_to_binary(BinFrmtL),
%% 						  BinAll = <<Direct:8, GiantQly:8, BinNickLen:16, BinNick/binary, GiantLv:16, BinPLen:16, BinPA/binary,
%% 									 BinALen:16, BinAA/binary, TechId:32, TechLv:16, ActType:8, TechPwr:32, FrmtLv:16, BinFrmtLen:16, BinGiantFrmt/binary>>,
%% 						  [BinAll|AccBinL]
%% 				  end
%% 		  end,
%% 	AllGiantBinL = lists:foldl(Fun, [], BRList),
%% 	LenAllGiantBin = length(AllGiantBinL),
%% 	AllGiantBin = list_to_binary(AllGiantBinL),
%% 	<<LenAllGiantBin:16, AllGiantBin/binary>>.
%% 
