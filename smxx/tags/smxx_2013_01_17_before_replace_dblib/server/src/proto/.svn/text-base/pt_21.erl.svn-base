%%%-----------------------------------
%%% @Module  : pt_21
%%% @Author  : csj
%%% @Created : 2011.8.15
%%% @Description: 21技能信息
%%%-----------------------------------
-module(pt_21).
-export([read/2, write/2]).
-include("common.hrl").
%%
%%客户端 -> 服务端 ----------------------------
%%

%%学习技能
read(21001, <<Id:32>>) ->
    {ok, Id};

%%技能列表
read(21002, _) ->
    {ok, list};

%%使用技能
read(21003, <<Id:32>>) ->
    {ok, Id};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%学习技能
write(21001, [Res, SkillId]) ->
	%%io:format("handle:2100111111111111111111 ~p \~n",[Res]),
    {ok, pt:pack(21001, <<Res:8, SkillId:32>>)};

%%获取技能列表
write(21002, [SkillNow, Skill]) ->
	%%io:format("handle:2100222222222222 ~p \~n",[Skill]),
	Data = skill_list([Skill]),
    {ok, pt:pack(21002, <<SkillNow:32, Data/binary>>)};

%%使用技能
write(21003, [Res, SkillId]) ->
	%%io:format("handle:21003333333333333333 ~p \~n",[Res]),
    {ok, pt:pack(21003, <<Res:8, SkillId:32>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

skill_list([]) ->
    <<0:16, <<>>/binary>>;
skill_list([Skill]) ->
    Rlen = length(Skill),
	try
    		F = 
				fun({SkillId, SkillState}) ->
            			<<SkillId:32, SkillState:8>>
    				end,
    	LB = tool:to_binary([F(X) || X <- Skill, X /= []]),
		<<Rlen:16, LB/binary>>
	catch
		_:_ -> 
			?WARNING_MSG("skill_list List[~p],Num[~p]", [Skill, Rlen]),
			<<0:16, <<>>/binary>>
	end.
