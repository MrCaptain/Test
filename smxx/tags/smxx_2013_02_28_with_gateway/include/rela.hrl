%%%------------------------------------------------
%%% File    : rela.hrl
%%% Author  : water
%%% Created : 2013-02-01
%%% Description: 返回码定义
%%%------------------------------------------------

%%-------------------------------------------------
%% 关系模块 错误返回码
%%-------------------------------------------------
-define(RELA_UNKNOWN_ERROR, 0).          %%未知错误功能(如客户端错误行为或参数)
-define(RELA_ALREADY_FRIEND, 2).         %%已经是好友
-define(RELA_ALREADY_FOE, 3).            %%已经是仇人
-define(RELA_MAX_FRIEND_REACH, 4).       %%最大好友数达到
-define(RELA_MAX_FOE_REACH, 5).          %%最大仇人数达到
-define(RELA_IN_FOE_LIST, 6).            %%加仇人为好友
-define(RELA_IN_FRIEND_LIST, 7).         %%加好友为仇人
-define(RELA_INVALID_UID, 8).            %%非法的玩家ID
-define(RELA_NOT_FRIEND, 9).             %%不是好友
-define(RELA_NOT_FOE, 10).               %%不是仇人
-define(RELA_NOT_RECENT, 11).            %%不是最近联系人
-define(RELA_FRIEND_OFFLINE, 12).        %%好友不在线
-define(RELA_MAX_BLESS_TIMES_REACH, 13). %%祝福次数用完
-define(RELA_INVALID_NAME, 14).          %%无效的玩家名
%%-------------------------------------------------



