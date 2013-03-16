%% Author: YLZ
%% Created: 2012-3-15
%% Description: TODO: Add description to db_log_agent
-module(db_log_agent).

-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).


%%mysql玩家日志记录
insert_log_player(Uid,Acid,Acnm,Nick,Sex,Crr) ->
	?DB_LOG_MODULE:insert(log_player,[uid,accid,acnm,nick,sex,crr], [Uid,Acid,Acnm,Nick,Sex,Crr]).

%% 创建角色后, 真正进入游戏, 写记录
log_real_play(Uid) ->
	Now = util:unixtime(),
	?DB_LOG_MODULE:insert(log_real_play, [pt,uid],[Now,Uid]).

%% 获取玩家的最后充值时间
get_last_pay_time(PlayerId) ->
	?DB_MODULE:select_one(log_pay,"insert_time",[{player_id,PlayerId},{pay_status,1}],[{insert_time,desc}],[1]).

%% 玩家踢出日志
insert_kick_off_log(Uid, NickName, K_type, Now_time, Scene, X, Y, Other) ->
	?DB_MODULE:insert(log_kick_off, [uid, nick, k_type, time, scene, x, y, other], [Uid, NickName, K_type, Now_time, Scene, X, Y, Other]).


