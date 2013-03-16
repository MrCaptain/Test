%% Author: xiaomai
%% Created: 2010-12-27
%% Description: 玩家游戏系统配置的解包和组包
-module(pt_34).
-include("common.hrl").
-include("record.hrl").
%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([write/2, read/2]).

%%
%% API Functions
%%

%%%=========================================================================
%%% 解包函数
%%%=========================================================================
%% %% -----------------------------------------------------------------
%% %% 34000 读取设置信息
%% %% -----------------------------------------------------------------
%% read(34000, _R) ->
%% 	{ok, []};
%% 
%% %% -----------------------------------------------------------------
%% %% 34001 保存设置信息
%% %% -----------------------------------------------------------------
%% read(34001, <<ShieldRole:8, ShieldSkill:8, ShieldRela:8, ShieldTeam:8, 
%% 			 ShieldChat:8, Music:8, SoundEffect:8, Fasheffect:8>>) ->
%% 	Param = [ShieldRole, ShieldSkill, ShieldRela, 
%% 			 ShieldTeam, ShieldChat, Music, SoundEffect, Fasheffect],
%% 	{ok, [Param]};




read(34002, _R) ->
%% 	?DEBUG("~p", [[34002]]),
	{ok, []};



read(34003, <<D/binary>>) ->
%% 	?DEBUG("34003 ~p", [D]),
	{ok, [D]};





%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
read(_Cmd, _R) ->
    {error, no_match}.


%%%=========================================================================
%%% 组包函数
%%%=========================================================================


%% %% -----------------------------------------------------------------
%% %% 34000 读取设置信息
%% %% -----------------------------------------------------------------
%% write(34000, [ShieldRole, ShieldSkill, ShieldRela, ShieldTeam, ShieldChat, Music, SoundEffect, Fasheffect]) -> 
%% 	BinData = <<ShieldRole:8, ShieldSkill:8, ShieldRela:8, ShieldTeam:8, 
%% 			 ShieldChat:8, Music:8, SoundEffect:8, Fasheffect:8>>,
%% 	{ok, pt:pack(34000, BinData)};
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 34001 保存设置信息
%% %% -----------------------------------------------------------------
%% write(34001, [Result]) ->
%% 	BinData = <<Result:8>>,
%% 	{ok, pt:pack(34001, BinData)};


write(34002, Result) ->
%% 	?DEBUG("~p",[Result]),
	SBin = tool:to_binary(Result),
	Slen = length(Result),
	{ok, pt:pack(34002, <<Slen:16,SBin/binary>>)};




%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(_Cmd, _R) ->
    {ok, pt:pack(0, <<>>)}.

