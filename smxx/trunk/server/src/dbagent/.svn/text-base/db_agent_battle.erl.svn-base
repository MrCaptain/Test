%% Author: liujing
%% Created: 2011-9-21
%% Description: TODO: 战斗部分数据处理
-module(db_agent_battle).
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl").
-define(MAX_BATTLE_CACHE_NUM, 500). 
-export([updateBattleDataToDb/1,
		 getDbIdFromUid/1,
		 getBattleDataFromUid/1,
		 insertBattleShareData/1,
		 getBattleShareData/1]).

%%将当前玩家的战斗数据记录#battleData更新存储到数据库中（离线时使用）
updateBattleDataToDb(Player) ->	
	{BattleData, _List, _Formation} = lib_battle:loadLBattleData(Player), 
	BattleDataStr = util:term_to_string(BattleData),
%% 	BattleDataStr = "jflksjflkaj",
%% 	io:format("~s BattleDataStr____[~p][~p]\n",[misc:time_format(now()), logout_begin, BattleDataStr]),
	case getDbIdFromUid(Player#player.id) of
		Val when Val =:= null orelse Val =:= undefined ->
			%%io:format("~s BattleDataStr____[~p][~p]\n",[misc:time_format(now()), logout_begin, Val]),
			_NewId = ?DB_MODULE:insert(battle_data, [uid,btdt], [Player#player.id,BattleDataStr]);  %%当数据库不存在当前玩家的战斗数据记录，插入一个新的
		BattleDataID ->
			_X = ?DB_MODULE:update(battle_data, [{uid, Player#player.id}, {btdt, BattleDataStr}], [{id, BattleDataID}])
	end.

%%通过玩家ID从数据库获取战斗数据记录ID
getDbIdFromUid(Uid) ->
	?DB_MODULE:select_one(battle_data, "id", [{uid, Uid}], [], [1]).

%%通过玩家ID从数据库查询战斗数据记录#battleData,并转换为可用格式
%%返回可用的战斗数据记录#battleData
getBattleDataFromUid(Uid) ->
	case ?DB_MODULE:select_one(battle_data, "btdt", [{uid, Uid}], [], [1]) of
		Val0 when Val0 =:= null orelse Val0 =:= undefined ->
			[];
		BattleData when is_binary(BattleData) ->
			util:string_to_term(tool:to_list(BattleData));
		_ ->
			[]
	end.

%%插入战斗分享数据
insertBattleShareData(BattleBinData) ->
	{LeftId, LName, RightId, RName, WarMode, BattleBin} = BattleBinData,
	Svty = 1,     %%保存类型为限时保存
	Stim = util:unixtime(),          %%存储时间点
	Lftm = Stim + (3600 * 24 * 365),   %%到期时间，暂定1年
	[ReNum] = ?DB_MODULE:select_count(battle_cache_data,[]),
	if ReNum >= ?MAX_BATTLE_CACHE_NUM ->
		   Id = ?DB_MODULE:select_one(battle_cache_data, "id", [], [{stim, asc}], []),
		   ?DB_MODULE:update(battle_cache_data, [{actid, LeftId}, {acnm, LName}, {defid, RightId}, {dfnm, RName}, {wrmd, WarMode}, {svty, Svty}, {stim, Stim}, {lftm, Lftm}, {bbin, BattleBin}], [{id, Id}]),
		   Id;
	   true ->
		   ?DB_MODULE:insert(battle_cache_data, [actid, acnm, defid, dfnm, wrmd, svty, stim, lftm, bbin], [LeftId, LName, RightId, RName, WarMode, Svty, Stim, Lftm, BattleBin])
	end.
	

%%获取战斗分享数据(通过分享记录ID)
getBattleShareData(Id) ->
	?DB_MODULE:select_row(battle_cache_data, "bbin, wrmd, defid", [{id, Id}]).
