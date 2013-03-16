%%%--------------------------------------
%%% @Module  : pp_skill
%%% @Author  : csj
%%% @Created : 2010.10.06 
%%% @Description:  技能管理
%%%--------------------------------------
-module(pp_skill).
-include("common.hrl").
-include("record.hrl").
-compile([export_all]).
%% %%学习技能
%% %% handle(21001, Status, SkillId) ->
%% %% 	Skill = get(player_skill),
%% %% 	%%io:format("handle:21001 ~p \~n",[{SkillId, Skill#skill.sklls}]),
%% %% 	NewSkill = lib_skill:getSkill(SkillId),
%% %% 	[NewStatus, Res] = 
%% %% 		if
%% %% 			NewSkill =:= error ->
%% %% 				[Status, 0];
%% %% 			NewSkill#ets_skill.crr =/= Status#player.crr ->
%% %% 				[Status, 0];
%% %% 			true ->
%% %% 				lib_skill:learn_skill(Status, NewSkill, Skill)
%% %% 		end,
%% %% 	{ok, BinData} = pt_21:write(21001, [Res, SkillId]),
%% %% 	lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%% %% 	lib_player:send_player_attribute2(NewStatus, 5),
%% %% 	{ok, NewStatus};
%% 
%% %%获取技能列表
%% handle(21002, Status, _) ->
%%     AllSkill = lib_skill:check_skill_info(Status),
%%     {ok, BinData} = pt_21:write(21002, AllSkill),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
%% 
%% 
%% %%使用技能
%% handle(21003, Status, SkillId) ->
%% 	Skill = get(player_skill),
%% 	{ok, BinData} =
%% 		case lists:keyfind(SkillId, 1, Skill#skill.sklls) of
%% 			{_,1} 	->
%% 				NewSkill = Skill#skill{sklnw = SkillId},
%% 				put(player_skill, NewSkill),
%% 				db_agent_skill:use_skill(Status#player.id, SkillId),
%% 				NewStatus = Status#player{other = Status#player.other#player_other{skill = SkillId}},
%% 				pt_21:write(21003, [1, SkillId]);
%% 			{_,0}	->
%% 				NewStatus = Status,
%% 				pt_21:write(21003, [3, SkillId]);
%% 			_	 ->
%% 				NewStatus = Status,
%% 				pt_21:write(21003, [2, SkillId])
%% 		end,
%%     lib_send:send_to_sid(NewStatus#player.other#player_other.pid_send, BinData),
%% 	{ok, NewStatus};
%% 
%% handle(_Cmd, _Status, _Data) ->
%%     {error, "pp_skill no match"}.
