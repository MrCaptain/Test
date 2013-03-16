%%%------------------------------------------------
%%% File    : task.hrl
%%% Author  : Johnathe_Yip
%%% Created : 2013-01-16
%%% Description: 任务定义 
%%%------------------------------------------------

%% 避免头文件多重包含
-ifndef(__HEADER_TASK_H__).
-define(__HEADER_TASK_H__, 0).

%%任务类别
-define(MAIN_TASK,0). %%主线任务
-define(BRANCHE_TASK,1). %%支线任务
-define(FACTION_TASK,2).%%帮派任务
-define(DREAMLAND_TASK,3).%%桃园任务
-define(GOD_COMMAND_TASK,4).%%天道令任务
-define(CAMP_TASK,5).%%阵营任务
-define(MINE_TASK,6).%%聚宝阁任务
-define(EXERCISE_TASK,7).%%千锤百炼任务
-define(SELF_IMPROVE_TASK,8).%%自强不息
-define(MASTER_TASK,9).%%师门任务 
-define(ALL_TASK_TYPE,%%所有任务类型
		[?FACTION_TASK,?DREAMLAND_TASK ,?GOD_COMMAND_TASK,?CAMP_TASK,?MINE_TASK,?EXERCISE_TASK,?SELF_IMPROVE_TASK,?MASTER_TASK]).

%%----------任务事件------------
-define(KILL_EVENT,1). %%杀怪事件类型
-define(COLLECT_EVENT,2). %%采集事件类型
-define(NPC_TALK_EVENT,0). %%npc对话事件类型
-define(LEVEL_EVENT,4). %%升级事件类型
-define(SHOPPING_EVENT,3).%%商城购物事件
-define(NPC_GOODS_EVENT,6).%%npc购物
-define(GOD_COMMAND_EVENT,7).%%发布天道令任务
-define(SCENE_EVENT,8).%%到达指定副本指定层数

%%----------npc状态--------------
-define(NPC_NO_TASK,0).%%npc对于角色没有任何任务关联
-define(NPC_UNFIN_TASK,1).%%npc对于角色已触发任务，但没有完成
-define(NPC_CAN_TRIGGER,2).%%npc对于角色有可接任务
-define(NPC_FINISH_TASK,3).%%npc对于玩家有完成任务

%%----------任务模板-------
-define(TASK_AUTO_FIN_FLAG,0).%%任务自动完成标识
-define(TASK_AUTO_TRIG_FLAG,0).%%任务自动触发标识

%%----------任务奖励标识类型---------------
-define(NULL_TASK_FLAG,0).%%无标识类型
-define(CAREER_TASK_FLAG,1).%%职业标识类型

%%----------玩家职业---------
-define(NULL_CAREER,4).%无职业限制
-define(SOLDIER_CAREER,1).%%战士 
-define(MASTER_CAREER,2).%%法师
-define(SHOOTER_CAREER,3).%%射手

%%----------玩家性别限制-------
-define(NULL_SEX,2).%无性别限制
-define(BOY_SEX,1).%男
-define(GIRL_SEX,0).%女

%%----------日常任务状态-------
-define(CAN_TRIGGER,0).%%可触发
-define(CAN_NOT_TRIGGER,1).%%不可触发
-define(OUT_OF_MAX,2).%%已超过每次最大触发任务个数

-define(RESET_TIME,24*60*60).%%重置等待时间
%%成功编码
-define(OPT_SUCCESS,100).%%操作成功 
%%错误编码 
-define(TASK_ALREADY_TRIGGER,102).%%该任务已经触发过了，不能接
-define(TASK_LEVEL_NOTENOUGHT, 103).%%任务等级不足
-define(TASK_ALREADY_FINISH,104).%%任务已完成
-define(TASK_NOT_EXIT,101).%%任务不存在
-define(TASK_WRONG_CAREER,105).%%不满足职业限定
-define(TASK_WRONG_SEX,106).%%不满足性别限定
-define(PRE_TASK_UNFIN,107).%%前置任务未完成
-define(DAILY_TASK_REJECT,108).%%不满足日常任务触发条件 
-define(TASK_TIME_LIMIT,109).%%任务不在可接时间段
-define(TASK_NOT_IN_PROCESS,201).%%任务不在进度列表
-define(TASK_UNFINISH,202).%%任务未完成
-define(TASK_NOT_TRIGGER,203).%%任务没有触发
-define(NO_TASK_IN_DETAIL,204).%%任务不在任务模板子表
-define(TASK_NOT_ENOUGH_COIN,205).%%完成任务所需元宝不足
-define(NOT_COIN_TASK,206).%%该任务不能用元宝完成
-define(UNKNOW_ERROR,207).%%未知错误
-define(GET_GOOD_FAIL,208).%%获取任务奖品失败

%%------------任务状态用于30501/30008协议----------------
-define(TASK_NOT_FINISH,0).%任务已触发未完成
-define(TASK_FINISH,1).%%任务已满足完成条件
-define(TASK_CAN_TRIGGER,2).%%任务可触发
-define(TASK_AUTO_TRIGGER,3).%%任务自动触发
-endif.   
 