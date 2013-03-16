%% Author: Administrator
%% Created: 2011-11-19
%% Description: TODO: Add description to db_agent_system_config
-module(db_agent_system_config).

%%
%% Include files
%%

%%
%% Exported Functions
%%

-include("common.hrl").
-include("record.hrl").
-compile(export_all).

%%
%% API Functions
%%

insetrt_system_config(PlayerId) ->
	Data = [],
	ND = util:term_to_string(Data),
	?DB_MODULE:insert(system_config,[uid,pro], [PlayerId,ND]).

get_system_config(PlayerId) ->
	case ?DB_MODULE:select_row(system_config,"*",[{uid,PlayerId}]) of
		[] ->
			[];
		D ->
			[Id,Uid, Pro] = D,
			FD = tool:to_list(Pro),
			NData = util:string_to_term(FD),
			[Id,Uid, NData]
	end.

update_system_config(PlayerId,Data) ->
	ND = util:term_to_string(Data),
	?DB_MODULE:update(system_config,[{pro,ND}], [{uid,PlayerId}]).	


