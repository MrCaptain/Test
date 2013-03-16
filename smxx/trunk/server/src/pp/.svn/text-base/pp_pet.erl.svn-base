%% Author: Administrator
%% Created: 2013-3-12
%% Description: TODO: Add description to pp_pet
-module(pp_pet).

-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%%宠物名称更改
handle(25003, PS, Name) ->
	{BinData, NewPS1} = 
	case lib_pet:is_pet_exists(PS#player.id) of
		true ->
			case lib_pet:rename_pet(PS, Name) of
				{faile, Res} ->
					{ok, BinData1} = pt_25:write(15003, [Res, ""]),
					{BinData1, PS};
				{ok, NewPS} ->
					{ok, BinData1} = pt_25:write(15003, [?RESULT_OK, Name]),
					{ok, BinData2} = pt_12:write(12024, [NewPS#player.id, NewPS#player.other#player_other.pet_template_id, Name]),
					mod_scene_agent:send_to_scene(NewPS#player.scene, BinData2, NewPS#player.id),
					{BinData1, NewPS}
			end;
		false ->
			{ok, BinData1} = pt_15:write(15003, [4, ""]),
			{BinData1, PS}
	end,
	lib_send:send_one(NewPS1#player.other#player_other.socket, BinData),
	{ok, NewPS1};

%% %% 宠物出战
%% handle(?PP_PET_FIGHT, Status, [PetId]) ->
%% 	%% 如果已经有宠物出战，即要先召回，客服端如果需要即先调召回
%% 	case lib_pet:is_pet_fight(Status#ets_users.id) of
%% 		0 ->
%% 			skip;
%% 		PetInfo ->
%% 			handle(?PP_PET_CALL_BACK, Status, [PetInfo#ets_users_items.id])
%% 	end,
%% 	case gen_server:call(Status#ets_users.other_data#user_other.pid_item, {'pet_fight', PetId}) of
%% 				{ok, PetTemplateId, PetNick} ->
%% 					{ok, BinData} = pt_12:write(?PP_MAP_PET_INFO_UPDATE, [PetId, PetTemplateId, Status#ets_users.id, PetNick]),
%% 					mod_map_agent: send_to_area_scene(
%% 							Status#ets_users.current_map_id,
%% 							Status#ets_users.pos_x,
%% 							Status#ets_users.pos_y,
%% 							BinData,
%% 							undefined),
%% 			         Other = Status#ets_users.other_data#user_other{pet_id=PetId,pet_template_id=PetTemplateId,pet_nick=PetNick},
%% 			         NewStatus = Status#ets_users{other_data=Other},
%% 			         lib_pet:change_pet_enchase1(Status#ets_users.id,PetId,?PET_FIGHT_STATE),    %%出战状态设为1
%% 			         lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,
%% 											   ?CHAT,?None,?ORANGE,?_LANG_PET_ALREADY_FIGHTTING]),
%% %% 			         {ok, NewStatus};
%% 					{update_map, NewStatus};
%% 				_ ->
%% 					?WARNING_MSG("PP_PET_FIGHT is error.",[]),
%% 					ok
%% %% 			end
%% 	end;
%% 
%% %% 宠物召回
%% handle(?PP_PET_CALL_BACK, Status, [PetId]) ->
%% 	if 
%% 		Status#ets_users.other_data#user_other.pet_id =/= PetId ->
%% 			%% 宠物不存在
%% 			skip;
%% 		true ->
%% 			 case gen_server:call(Status#ets_users.other_data#user_other.pid_item, {'pet_call_back', Status#ets_users.other_data#user_other.pet_id}) of
%% 				 ok ->
%% 					{ok, BinData} = pt_12:write(?PP_MAP_PET_REMOVE, [PetId]),
%% 					mod_map_agent: send_to_area_scene(
%% 									Status#ets_users.current_map_id,
%% 									Status#ets_users.pos_x,
%% 									Status#ets_users.pos_y,
%% 									BinData,
%% 									undefined),
%% 					Other = Status#ets_users.other_data#user_other{pet_id=0,pet_template_id=0,pet_nick=undefined},
%% 				    lib_pet:change_pet_enchase1(Status#ets_users.id,PetId,0),
%% 					NewStatus = Status#ets_users{other_data=Other},
%% %% 					{ok, NewStatus};
%% 					{update_map, NewStatus};
%% 		 		_ ->
%% 			 		ok
%% 	 		end
%% 	end;
	  

handle(Cmd, _Status, _) ->
	?WARNING_MSG("pp_pet cmd is not: ~w", [Cmd]).


%%
%% Local Functions
%%

