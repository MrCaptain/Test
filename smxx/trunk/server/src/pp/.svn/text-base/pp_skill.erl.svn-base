%%%--------------------------------------
%%% @Module  : pp_skill
%%% @Author  : water
%%% @Created : 2013.01.18 
%%% @Description:  技能学习升级
%%%--------------------------------------
-module(pp_skill).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).


%% API Functions
handle(Cmd, Status, Data) ->
    ?TRACE("pp_skill: Cmd: ~p, Id: ~p, Data:~p~n", [Cmd, Status#player.id, Data]),
    handle_cmd(Cmd, Status, Data).

%%--------------------------------------
%%Protocol: 21000 获取技能列表
%%--------------------------------------
handle_cmd(21000, Status, _) ->
    AllSkill = lib_skill:get_skill_info(Status),
    pack_and_send(Status, 21000, [AllSkill]);

%%--------------------------------------
%%Protocol: 21001 学习技能
%%--------------------------------------
handle_cmd(21001, Status, [SkillId])->
    case Status#player.switch band ?SW_SKILL_BIT =:= ?SW_SKILL_BIT of
         true ->
             case lib_skill:check_skill_id(SkillId) of 
                 true ->
                     case lib_skill:learn_skill(Status, SkillId) of
                         {false, Reason} ->
                             pack_and_send(Status, 21001, [Reason]);
                         {true, NewStatus} ->
                             pack_and_send(Status, 21001, [1]),
                             %扣钱, 刷新属性
                             %NewStatus = lib_player:send_player_attribute2(Status, 5);
                             {ok, NewStatus}
                     end;
                 false ->
                     pack_and_send(Status, 21001, [0])  %%无效的技能ID
             end;
        false ->
             pack_and_send(Status, 21001, [0])  %%无效的技能ID
    end;

%%--------------------------------------
%%Protocol: 21002 升级技能
%%--------------------------------------
handle_cmd(21002, Status, [SkillId])->
    case Status#player.switch band ?SW_SKILL_BIT =:= ?SW_SKILL_BIT of
        true ->
            case lib_skill:check_skill_id(SkillId) of
                true ->
                    case lib_skill:upgrade_skill(Status, SkillId) of
                       {false, Reason} ->
                            pack_and_send(Status, 21002, [Reason]);
                       {true, NewStatus} ->
                            pack_and_send(Status, 21002, [1]),
                            %扣钱, 刷新属性
                            %NewStatus = lib_player:send_player_attribute2(Status, 5);
                            {ok, NewStatus}
                    end;
                false ->
                    pack_and_send(Status, 21002, [0])  %%无效的技能ID
            end;
        false ->
            pack_and_send(Status, 21002, [0])  %%无效的技能ID
    end;

handle_cmd(Cmd, Status, Data) ->
    ?ERROR_MSG("Undefine handler: Cmd ~p, Status:~p, Data:~p~n", [Cmd, Status, Data]),
    {ok, error}.

pack_and_send(Status, Cmd, Data) ->
    ?TRACE("pp_skill send: Cmd: ~p, Id: ~p, Data:~p~n", [Cmd, Status#player.id, Data]),
    {ok, BinData} = pt_21:write(Cmd, Data),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).
     
