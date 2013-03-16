%%%-----------------------------------
%%% @Module  : pt_30
%%% @Author  : Johanathe_Yip
%%% @Created : 2013.01.13
%%% @Description: 30 任务信息
%%%-----------------------------------
-module(pt_30).
-export([read/2, write/2]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
%%
%%客户端 -> 服务端 ----------------------------
%%
 
%% 接受任务
read(30003, <<TaskId:16>>) ->
    {ok, [TaskId]};  

%% 完成任务
read(30004, <<TaskId:16>>)->
		{ok,[TaskId]};

%% 检测npc状态
read(30005, <<ILen:16, Bin/binary>>) ->
    F = fun(_, {TB, Result}) ->
            <<NpcId:16, NewTB/binary>> = TB,
            {ok, {NewTB, Result++[NpcId]}}
    end,
    {ok,{ _, NpcList}} = util:for(1, ILen, F, {Bin, []}),
    {ok, [NpcList]};
%%获取指定大小的任务列表
read(30006, <<Size:8>>) ->
    {ok, [Size]};
%%消耗元宝完成任务
read(30007,<<TaskId:16>>)->
	{ok, [TaskId]};
%% 获取npc任务信息 
read(30008,<<NpcId:16>>) ->
    {ok, [NpcId]};
%%通知服务器玩家与某任务npc对话
read(30100,<<NpcId:16>>)->
    {ok, [NpcId]};
read(_Cmd, R) -> 
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%% --- NPC对话开始 ----------------------------------
 
%% 接受任务
write(30003,[Result])->  
	{ok, pt:pack(30003, <<Result:16>>)};

%% 完成任务
write(30004,[Result])->
	{ok, pt:pack(30004, <<Result:16>>)};
 
%%通知客户端npc状态
write(30005,[List,Len])->
	F = fun({NpcId,State}) -><<NpcId:16,State:8>> end,
	Data = tool:to_binary([F(Item)|| Item <- List]),
	{ok, pt:pack(30005, tool:to_binary([<<Len:16>>|Data]))};

%%获取任务列表
write(30006,[List,Len]) ->  
	F = fun({TaskId,State,Mark}) ->  
				<<TaskId:16,State:8,Mark:8>> 
		end,  
    Data = tool:to_binary([F(Task)|| Task <- List]),
	{ok, pt:pack(30006, tool:to_binary([<<Len:16>>|Data]))};
%%消耗元宝自动完成任务 
write(30007,Result) ->  
	{ok, pt:pack(30007, <<Result:16>>)};

%%通知客户端指定任务进度更新
write(30501,[List,Len]) ->
	F = fun({Tid,State,NowNum}) -><<Tid:16,State:8,NowNum:8>> end,
	Data = tool:to_binary([F(Task)|| Task <- List]),
	{ok, pt:pack(30501, tool:to_binary([<<Len:16>>|Data]))};
 
%%通知客户端服务器为玩家触发了自动触发任务
write(30503,[List,Len])->
	F = fun(Temp_task) -><<Temp_task:16>> end,
	Data = tool:to_binary([F(Task)|| Task <- List]),
	{ok, pt:pack(30503, tool:to_binary([<<Len:16>>|Data]))};

%%通知客户端有自动完成任务(单个)
write(30505,[TaskId])->  
		{ok, pt:pack(30505, <<TaskId:16>>)};
%%通知客户端有自动触发任务(单个)
write(30506,[TaskId])->  
		{ok, pt:pack(30506, <<TaskId:16>>)};
%%通知客户端日常任务重置
write(30507,[List,Len])->  
	F = fun(Task_Type) -> 
				<<Task_Type:8>> end,
	Data = tool:to_binary([F(Task)|| Task <- List]),
	{ok, pt:pack(30507, tool:to_binary([<<Len:16>>|Data]))}; 
%%获取npc任务信息 
write(30008,[TaskList]) ->
    Fun_TaskList = fun({TaskId,TaskState}) ->
        <<TaskId:16,TaskState:8>>
    end,
    TaskList_Len = length(TaskList),
    TaskList_ABin = any_to_binary(lists:map(Fun_TaskList,TaskList)),
    TaskList_ABinData = <<TaskList_Len:16, TaskList_ABin/binary>>,
    {ok, pt:pack(30008, <<TaskList_ABinData/binary>>)};

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(csj_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.
 
any_to_binary(Any) ->
    tool:to_binary(Any).