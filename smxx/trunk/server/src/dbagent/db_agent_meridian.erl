%% @author Johnathe_Yip
%% @doc @todo Add description to de_agent_physique.


-module(db_agent_meridian).

-include("common.hrl").
-include("record.hrl").
-include("meridian.hrl").
-compile(export_all).
 
%% ====================================================================
%% Internal functions
%% ====================================================================
get_all_tpl_mer()->
	?DB_MODULE:select_all(temp_meridian, "*", []).

get_mer_by_uid(PlayerId)->
 	?DB_MODULE:select_all(meridian, "*",[{player_id,PlayerId}]).

insert_mer_data(Data)->
		FieldList = record_info(fields, meridian),
		?DB_MODULE:insert(meridian, FieldList, Data).

upd_mer1_data_in_db([MerDetail,CoolDown,PlayerId])->
	 ?DB_MODULE:update(meridian, 
								 [ {mer_detail_1,MerDetail},
								  {cool_down,CoolDown}], 
								 [{player_id, PlayerId}]).

upd_mer2_data_in_db([MerDetail,State,PlayerId])->
	 ?DB_MODULE:update(meridian,  
							     [{mer_state,State},{mer_detail_2,MerDetail}], 
								 [{player_id, PlayerId}]).


upd_trigger_mer_in_db([State,CoolDown,PlayerId])->
	?DB_MODULE:update(meridian, 
					  [{mer_state, State},
					   {cool_down,CoolDown}], 
					  [{player_id, PlayerId}]).

%%更新筋骨数据到数据库
upd_bones_info_2_db(Type,MerDetail,PlayerId)->
	 ?DB_MODULE:update(meridian,  
							     [{data_meridian:get_mer_handle(Type),MerDetail}], 
								 [{player_id, PlayerId}]) .

