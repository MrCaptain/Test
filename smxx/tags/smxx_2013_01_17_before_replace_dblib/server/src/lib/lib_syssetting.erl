%% Author: 
%% Created: 
%% Description: 玩家游戏系统配置
-module(lib_syssetting).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).

%%放入进程字典
init_system_config(PlayerId) ->
	D = get_player_system_config(PlayerId),
	update_player_sys_setting(D).

%%更新进程字典
update_player_sys_setting(Result) ->
	put(system_config_new,Result).

%%玩家新手进度处理
get_player_system_config(PlayerId) ->
	case db_agent_system_config:get_system_config(PlayerId) of
		[] ->
			db_agent_system_config:insetrt_system_config(PlayerId),
			Res = [];
		D ->
			[_Id,_Uid, Res] = D
	end,
	Res.
	

%%更新玩家新手进度
update_player_system_config(PlayerId,Data) ->
	db_agent_system_config:update_system_config(PlayerId,Data).


%%下线保存进度
save_system_config(PlayerId) ->
	D = get(system_config_new),
	db_agent_system_config:update_system_config(PlayerId,D).






