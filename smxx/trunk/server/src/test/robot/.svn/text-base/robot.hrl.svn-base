%%% -------------------------------------------------------------------
%%% Author:
%%% Description : 
%%% Created :
%%% -------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

-include_lib("stdlib/include/ms_transform.hrl").
-define(CONFIG_FILE, "../config/gateway.config").

%%连接服务器端口
%% -define(GATEWAY_ADD,"192.168.51.175"). 
%% -define(GATEWAY_PORT,7788).
%% -define(SERVER_ADD,"192.168.51.175"). 
%% -define(SERVER_PORT,7777).
-define(SERVER_ADD,"127.0.0.1"). 
-define(SERVER_PORT,7788).

-define(ACTION_SPEED_CONTROL, 10).
-define(ACTION_INTERVAL, ?ACTION_SPEED_CONTROL*1000).  % 自动行为最大时间间隔
-define(ACTION_MIN, 3000).    % 自动行为最小时间间隔

%%需要随机调用模块列表如robot_chat, 
-define(RANDOM_MODULE, []).
-define(RANDOM_INTERVAL, 1000).  %%随机操作触发的间隔(毫秒)

%%设为1, 登录后发GM指令加钱等
-define(INITIAL_GM, 1).

%%TCP Socket的参数
-define(TCP_OPTS, [
        binary,
        {packet, 0}, % no packaging
        {reuseaddr, true}, % allow rebind without waiting
        {nodelay, false},
        {delay_send, true},
        {active, false},
        {exit_on_close, false}
    ]).

%%断言以及打印调试信息宏
%%不需要时启用 -undefine行
%-define(debug,1).
-undefine(debug).
-ifdef(debug).
    -define(TRACE(Str), io:format(Str)).
    -define(TRACE(Str, Args), io:format(Str, Args)).
    % unicode版
    -define(TRACE_W(Str), io:format("~ts", [list_to_binary(io_lib:format(Str, []))])).
    -define(TRACE_W(Str, Args), io:format("~ts", [list_to_binary(io_lib:format(Str, Args))])).
-else.
    -define(TRACE(Str), void).
    -define(TRACE(Str, Args), void).

    -define(TRACE_W(Str), void).
    -define(TRACE_W(Str, Args), void).
-endif.


%%机器进程状态
-record(robot, {
        orig_n,    
        login,
        acid,      %%account id
        socket,    %%socket
        pid,       %%process id
        x ,        %%x坐标
        y ,        %%y坐标
        scene,
        tox,
        toy,
        hp,
        id,          %% ID
        act,         %% 动作
        status,      %% 当前状态
        dstScene,
        step,
        guild,       %%0不在帮派中
        guild_post,  %%1帮主
        frda, %% 好友信息
        bkda, %% 黑名单信息,
        sgda %% 陌生人信息         
    }).
