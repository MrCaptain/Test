%% Author: smxx
%% Created: 2013-01-15
%% Description: 玩家游戏系统配置
-module(pp_syssetting).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").

%%
%% Exported Functions
%%
-export([handle/3]).


%% -----------------------------------------------------------------
%% 34002 读取设置信息
%% -----------------------------------------------------------------
handle(34002, Status, []) ->
	Result = get(system_config_new),
	{ok, BinData} = pt_34:write(34002, Result),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
	ok;


handle(34003, _Status, [Data]) ->
	lib_syssetting:update_player_sys_setting([Data]),
	ok;

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
handle(_Cmd, _Status, _Data) ->
    ?DEBUG("pp_syssetting no match", []),
    {error, "pp_syssetting no match"}.


































%% %%
%% %% API Functions
%% %%
%% %% -----------------------------------------------------------------
%% %% 34000 读取设置信息
%% %% -----------------------------------------------------------------
%% handle(34000, Status, []) ->
%% 	Result = get_player_sys_settings(),
%% 	{ok, BinData} = pt_34:write(34000, Result),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 34001 保存设置信息
%% %% -----------------------------------------------------------------
%% handle(34001, Status, [Param]) ->
%% 	Fasheffect1 = lib_syssetting:get_player_sys_setting(fasheffect),
%% 	Result = set_player_sys_settings(Status#player.id, [Param]),
%% 	[_ShieldRole, _ShieldSkill, _ShieldRela, _ShieldTeam, _ShieldChat, _Music, _SoundEffect,Fasheffect] = Param,
%% 	
%% 	case  Fasheffect =/= Fasheffect1 of
%% 		false -> skip;
%% 		true ->
%% 			case Fasheffect1 == 1 of
%% 				false -> 
%% 					{ok, Bin12042} = pt_12:write(12042, [Status#player.id, [{2, 0}]]),
%% 					%%采用广播通知，附近玩家都能看到
%% 					mod_scene_agent:send_to_scene(Status#player.scn, Bin12042);
%% 				true ->
%% 					EquipIdList = goods_util:get_equip_id_list(Status#player.id,10,1),
%% 					F = fun(Goods_id) ->
%% 								case lists:member(Goods_id, [10901,10902,10903,10904,10905,10906,10907,10908]) of
%% 									false -> skip;
%% 									true ->
%% 										{ok, Bin12042} = pt_12:write(12042, [Status#player.id, [{2, Goods_id}]]),
%% 										%%采用广播通知，附近玩家都能看到
%% 										mod_scene_agent:send_to_scene(Status#player.scn, Bin12042)
%% 								end
%% 						end,
%% 					[F(Goods_id) || Goods_id <- EquipIdList]
%% 			end
%% 	end,
%% 	{ok, BinData} = pt_34:write(34001, Result),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% 	ok;
%% 
%% %% -----------------------------------------------------------------
%% %% 错误处理
%% %% -----------------------------------------------------------------
%% handle(_Cmd, _Status, _Data) ->
%%     ?DEBUG("pp_syssetting no match", []),
%%     {error, "pp_syssetting no match"}.
%% 
%% %%======================== 玩家游戏系统配置  begin =========================
%% %% -----------------------------------------------------------------
%% %% 34000 读取设置信息
%% %% -----------------------------------------------------------------
%% get_player_sys_settings() ->
%% 	try 
%% 		lib_syssetting:get_player_sys_setting_info()
%% 	catch
%% 		_:_ ->
%% 			[0,0,0,0,0,50,50,0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 34001 保存设置信息
%% %% -----------------------------------------------------------------
%% set_player_sys_settings(PlayerId, [Param]) ->
%% 	try 
%% 		lib_syssetting:set_player_sys_setting_info(PlayerId, Param)
%% 	catch
%% 		_:_ ->
%% 			[0]
%% 	end.
%% 
%% %%======================== 玩家游戏系统配置  end =========================
