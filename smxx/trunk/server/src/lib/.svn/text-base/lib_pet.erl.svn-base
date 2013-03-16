%%%--------------------------------------
%%% @Module  : lib_pet
%%% @Author  :
%%% @Created :
%%% @Description : 宠物信息
%%%--------------------------------------
-module(lib_pet).
-include("common.hrl").
-include("record.hrl").
-include("battle.hrl"). 
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).

init_pet_info(PlayerId) ->
	case db_agent_pet:select_pet_by_uid(PlayerId)  of		
		PetInfo when is_record(PetInfo, pet)->
			lib_common:insert_ets_info(?ETS_PET_INFO, PetInfo),
			{PetInfo#pet.template_id, PetInfo#pet.name};
		_ -> {0, 0, ""}
	end.

%% 宠物改名
rename_pet(PS, PetId, PetName) ->
	case lib_words_ver:validate_name(PetName, [1, 12]) of
		false -> {fail, 2}; % 名字长度错误
		true ->
			case lib_words_ver:validate_name(PetName, special) of
				false -> {fail, 3}; % 含特殊字符/敏感词
				true ->
					case lib_common:get_ets_info(?ETS_PET_INFO, PetId) of
						PetInfo when is_record(PetInfo, pet) ->
							NewPetInfo = PetInfo#pet{name = PetName},
							lib_common:insert_ets_info(?ETS_PET_INFO, NewPetInfo),
							spawn(fun()-> db_agent_pet:rename_pet(PetId, PetName) end),
							PlayerOther = PS#player.other#player_other{pet_nick = PetName},
							NewPS = PS#player{other = PlayerOther},
							{ok, NewPS};
						_ -> {fail, 4} % 没有宠物
					end
			end
	end.

%% 
%% %% 宠物状态改变
%% change_status(Status,[PetId,PetStatus]) ->	
%% 	Pet = get_own_pet(Status#player.id, PetId),
%%     if  Pet =:= []  -> {fail,2}; %% 宠物不存在
%%         true ->         
%%             if  Pet#pet.uid =/= Status#player.id -> {fail,3}; %% 该宠物不归你所有
%%                 Pet#pet.psta =:= PetStatus -> {fail,4}; %% 宠物已经出战/休息
%% 				true ->
%% 					
%% 					%% 更新进程字典信息
%% 					PetNew = Pet#pet{psta = PetStatus}, 
%% 					update_own_pet(PetNew),	
%%                     
%% 					spawn(fun()->lib_task:event(pet, null, Status)end),
%% 					%% 临时屏蔽
%% 					%%属性加点对角色属性加成影响
%% 					%%pet_attribute_effect(Status,PetNew),
%% 					
%% 					%% 更新数据库信息
%% 					db_agent_pet:pet_update_status(Pet#pet.id,PetStatus),
%% 					
%% 					{ok,PetNew}
%%             end
%% 	end.	

%% %% 宠物资质提升
%% upgrade_aptitude(Status, [PetId, Number, Type]) -> 	
%% %% io:format("upgrade_aptitude:true[~p]\n",[Number]),
%% 	Pet = get_own_pet(Status#player.id, PetId),
%%     if  (Status#player.stsw band 8) =:= 0 -> {fail,8};%% 功能未开放
%% 		Pet =:= []  -> {fail,2}; %% 宠物不存在
%%         Pet#pet.uid =/= Status#player.id -> {fail,3}; %% 该宠物不归你所有
%% 		true ->
%% 			case check_pet_aptitude(Pet, Type) of
%% 				{fail, Ret} -> {fail,Ret};
%% 				[CurNum, GoodsInfo] ->
%% 					if GoodsInfo#goods.num < Number -> {fail, 6}; %% 晶石数量不足
%% 					   true ->
%% 						   [TotalNum, AddNum, Addap] = data_pet:get_add_aptitude(CurNum, Number, Pet#pet.qly),
%% 						   %%io:format("upgrade_aptitude:[~p/~p/~p/~p]\n",[CurNum, AddNum, TotalNum, GoodsInfo]),
%% 						   case gen_server:call(Status#player.other#player_other.pid_goods, {'delete_one', GoodsInfo#goods.id, AddNum}) of
%% 								 [_Res, NewNum] ->
%% 									 %%io:format("upgrade_aptitude:ok[~p/~p]\n",[_Res, NewNum]),									 									 								 
%% 									 NewPet = 
%% 										 if  Type =:= 0 -> Pet#pet{other = Pet#pet.other#pet_other{pwr = Pet#pet.other#pet_other.pwr + Addap},
%% 																   pwn = Pet#pet.pwn + AddNum,
%% 																   rela = Pet#pet.rela + AddNum * 20 * 100};
%% 											 Type =:= 1 -> Pet#pet{other = Pet#pet.other#pet_other{tech = Pet#pet.other#pet_other.tech + Addap},
%% 																   tcn = Pet#pet.tcn + AddNum, 
%% 																   rela = Pet#pet.rela + AddNum * 20 * 100};
%% 											 true -> Pet#pet{other = Pet#pet.other#pet_other{mgc = Pet#pet.other#pet_other.mgc + Addap}, 
%% 															 mgn = Pet#pet.mgn + AddNum,
%% 															 rela = Pet#pet.rela + AddNum * 20 * 100}
%% 										 end,
%% 									 
%% 									 if
%% 										 Type =:= 0 -> Value = NewPet#pet.other#pet_other.pwr;
%% 										 Type =:= 1 -> Value = NewPet#pet.other#pet_other.tech;
%% 										 true -> Value = NewPet#pet.other#pet_other.mgc
%% 									 end,
%% 									 
%% 									 %%io:format("upgrade_aptitude:ok[~p/~p]\n",[Addap, NewPet]),
%% 									 %% 更新进程字典信息
%% 									 NewPet1 = upgate_pet_attribute(NewPet, 0, 1),
%% 									 update_own_pet(NewPet1),
%% 		
%% 									 %% 更新数据库信息
%% 									 db_agent_pet:pet_update_spar(NewPet1#pet.id, NewPet1#pet.pwn, NewPet1#pet.tcn, NewPet1#pet.mgn),
%% 
%% 									 {ok, Value, TotalNum, NewNum, NewPet1#pet.rela, NewPet1#pet.qly, CurNum};			
%% 								 _Err ->
%% 									 {fail, 0}						
%% 							end					
%% 					end
%% 			end				
%% 	end.

is_pet_exists(PlayerId) ->
	case lib_common:get_ets_info(?ETS_PET_INFO, PlayerId) of
		{} -> false;	% 没有宠物
		_ -> true 
	end.