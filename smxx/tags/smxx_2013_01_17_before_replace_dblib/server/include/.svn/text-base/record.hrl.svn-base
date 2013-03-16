%%%------------------------------------------------
%%% File    : record.erl
%%% Author  : csj
%%% Created : 2010-09-15
%%% Description: record
%%%------------------------------------------------
-include("table_to_record.hrl").

%%用户的其他附加信息(对应player.other)
-record(player_other, {
                       skill = 0,                  % 技能
                       socket = undefined,         % 当前用户的socket
                       socket2 = undefined,        % 当前用户的子socket2
                       socket3 = undefined,        % 当前用户的子socket3
                       pid_socket = undefined,     % socket管理进程pid
                       pid = undefined,            % 用户进程Pid
                       pid_goods = undefined,      % 物品模块进程Pid
                       pid_send = [],              % 消息发送进程Pid(可多个)
                       pid_send2 = [],             % socket2的消息发送进程Pid
                       pid_send3 = [],             % socket3的消息发送进程Pid
                       pid_battle = undefined,     % 战斗进程Pid
                       pid_scene = undefined,      % 当前场景Pid
                       pid_dungeon = undefined,    % 当前副本进程
                       pid_task = undefined,       % 当前任务Pid
                       node = undefined,           % 进程所在节点    
                       blacklist = false           % 是否受黑名单监控
                      }).

%% 物品进程状态表
-record(goods_status, {
                       uid = 0,                    % 用户ID
                       null_cells = [],            % 背包空格子位置
                       pid_send = undefined        % 玩家pid_send进程组
                      }).


