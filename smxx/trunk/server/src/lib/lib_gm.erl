%%%-------------------------------------- 
%%% @Module: lib_gm
%%% @Author: 
%%% @Created: 
%%% @Description: gm指令
%%%-------------------------------------- 
-module(lib_gm).

-include("common.hrl").
-include("record.hrl"). 
 -include("debug.hrl").

-export([handle_cmd/2, handle_gm_cmd/2]).

%%GM指令格式:
%%　　"-coin 10000"  参数之用半角的空格分开,不要使用全角的空格及字符串
%%    "-coin 10000\r -gold 10000"  是两条GM指令.　指令之间用换行符分隔

%%把聊天信息当成gm指令
handle_cmd(Status, []) ->
   {ok, Status};
handle_cmd(Status, [ChatMsg|T]) ->
   ChatMsg1 = string:tokens(ChatMsg, " "),
   F = fun(CM) -> %将字符串解码、解码失败的保持原样。特别备注——中文名和英语名可能会有不同的结果
            Reply = util:string_to_term(CM),
            if CM == "undefined" ->
                  undefined;
               Reply =/= undefined ->
                  Reply;
               true ->
                  CM
            end
       end,
   ChatMsg2 = [F(CM) || CM <- ChatMsg1],
   case handle_gm_cmd(Status, ChatMsg2) of
      {ok, Status2} when is_record(Status2, player) ->
         handle_cmd(Status2, T);
      _ ->
         handle_cmd(Status, T)
   end.

%%-----------------------------------------------
%% GM指令实现
%%-----------------------------------------------
handle_gm_cmd(Status, ["-get_time"]) ->
   CurTime = mod_mytime:time(),
   PromptMsg = io_lib:format(<<"当前时间：~p">>, [CurTime]),
   send_prompt(Status, PromptMsg);

%%直接改等级
handle_gm_cmd(Status, ["-level", Level])->
   Lv = if Level < 1 -> 1;
           Level > 100 -> 100;
           true -> Level
       end,
   Status2 = Status#player{level=Lv},
   lib_player:notice_client_upgrade(Status2, Status#player.level),
   {ok, Status2};

%%加铜钱
handle_gm_cmd(Status, ["-coin",Num]) ->
   Status2 = lib_player:add_coin(Status, Num),                 
   lib_player:send_player_attribute3(Status2),
   {ok, Status2};

%%加绑定铜钱
handle_gm_cmd(Status, ["-bcoin",Num]) ->
   Status2 = lib_player:add_bcoin(Status, Num),                 
   lib_player:send_player_attribute3(Status2),
   {ok, Status2};

%%加金币
handle_gm_cmd(Status, ["-gold",Num])->
   Status2 = lib_player:add_gold(Status, Num),                 
   lib_player:send_player_attribute3(Status2),
   {ok, Status2};

%%加绑定金币
handle_gm_cmd(Status, ["-bgold",Num]) ->
   Status2 = lib_player:add_bgold(Status, Num),                 
   lib_player:send_player_attribute3(Status2),
   {ok, Status2};

%%加经验
handle_gm_cmd(Status, ["-exp",Num]) ->
   Status2 = lib_player:add_exp(Status, Num, 0),                 
   lib_player:send_player_attribute1(Status2),
   {ok, Status2};

handle_gm_cmd(_Event, _Val) ->
   skip.

%%发送提示消息
send_prompt(Status, RespMsg) ->
   {ok, BinData} = pt_11:write(11000, [Status#player.id, Status#player.nick, 5, RespMsg]),
    lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData).

