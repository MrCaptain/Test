%%%------------------------------------------------
%%% File    : meridian.hrl
%%% Author  : Johnathe_Yip
%%% Created : 2013-01-16
%%% Description: 经脉定义 
%%%------------------------------------------------

%% 避免头文件多重包含
-ifndef(__HEADER_MERIDIAN_H__).
-define(__HEADER_MERIDIAN_H__, 0).
 %%-------------------------------------
%%           经脉模块宏定义
%%-------------------------------------
%%所有经脉类型
-define(ALL_MER_TYPE,[0,1,2,3,4,5,6,7]).
%%最高筋骨
-define(MAX_BONES,10).
%%==============经脉系统类型=================
%%消耗时间升级的经脉系统
-define(COST_CD,1).
%%消耗元宝升级的经脉系统
-define(COST_MONEY,2).
%%消耗时间长度 *60*60
-define(COOL_DOWN_TIME,2).

%%==============经脉cd状态================
-define(COOL_DOWN,0).%%经脉修炼中
-define(NULL_COOL_DOWN,1).%%经脉完成修炼

%%==============提升经脉操作结果===========
-define(MER_SUCCESS,100).%%提升成功
-define(UNKNOW_ERR,101).%%位置错误
-define(IN_COOL_DOWN,102).%%还处于冷却时间
-define(NULL_MER_DATA,103).%%经脉模板表没有数据
-define(OUT_OF_LV,104).%%经脉已满级
-define(IN_MER_PROCESS,105).%%角色已经在修炼了，不能同时修炼两个
-define(NOT_IN_MER_PROCESS,106).%%角色没有在修炼了或正在修炼，不能完成修炼（改！！）
-define(OUT_OF_BONES_LV,107).%%筋骨已满级
-define(OUT_OF_MERTYPE,108).%%不存在该经脉类型

%%==============经脉等级状态===============
-define(MER_STATE_OUT_OF_LV,-1).%%经脉满级
-define(MER_STATE_IN_LV,0).%%经脉没满级

%%==============经脉系统类型种类=================
-define(MER_TYPE_1,1).%经脉1
-define(MER_TYPE_2,2).%%经脉2

-endif.   
 