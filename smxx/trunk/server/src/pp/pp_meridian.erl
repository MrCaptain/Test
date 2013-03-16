%%--------------------------------------
%% @Module: pp_meridian
%% Author: Auto Generated
%% Created: Fri Mar 08 11:21:05 2013
%% Description: 
%%--------------------------------------
-module(pp_meridian).

%%--------------------------------------
%% Include files
%%--------------------------------------
-include("common.hrl").
-include("record.hrl").

%%--------------------------------------
%% Exported Functions
%%--------------------------------------
-compile(export_all).

 
%%--------------------------------------
%%Protocol: 45001 获取玩家经脉信息
%%--------------------------------------
handle(45001, PS, _) ->
	lib_meridian:show_meridianidian(PS),
    ok;

%%--------------------------------------
%%Protocol: 45002 提升经脉
%%--------------------------------------
handle(45002, PS, [MerType]) ->
	case lib_meridian:improve_meridian(MerType,PS) of
		true->
			{ok,Data} = pt_45:write(45002,[100]),
			lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data);
		Err->
			?INFO_MSG("error ~p ~n",[Err]),
			 {ok,Data} = pt_45:write(45002,[Err]),
			 lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data)
	end,
	ok;

%%--------------------------------------
%%Protocol: 45003 提升筋骨
%%--------------------------------------
handle(45003, PS, [MerType,MerId]) ->
	case lib_meridian:improve_born(MerType, MerId, PS) of
		true->
			{ok,Data} = pt_45:write(45003,[100]),
			lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data);
		Err ->
			?INFO_MSG("45003 test ~p ~n",[Err]),
			{ok,Data} = pt_45:write(45003,[Err]),
			lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data)
	end,
	ok;

%------------------------------------------
%Protocol: 45004 2小时候候完成经脉提升(经脉1)
%------------------------------------------  
handle(45004, PS, _) ->
	case lib_meridian:improve_meridian_cd_info(PS) of
		true->
			{ok,Data} = pt_45:write(45004,[100]),
			lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data);
		Err ->
			{ok,Data} = pt_45:write(45004,[Err]),
			lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data)
	end,
    ok;

handle(Cmd, Status, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Status:~p, Data:~p~n", [Cmd, Status, Data]),
    {ok, error}.

pack_and_send(Status, Cmd, Data) ->
    {ok, BinData} = pt_45:write(Cmd, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).
