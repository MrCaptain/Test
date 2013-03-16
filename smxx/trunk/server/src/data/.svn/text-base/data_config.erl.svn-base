%%------------------------------------------------    
%% File    : data_config.erl    
%% Author  : 
%% Desc    : 配置参数
%%------------------------------------------------        

-module(data_config).     
-compile(export_all).


%%模块开放等级配置值
get_config(Key) ->
    case Key of
		drop_x -> 3 ;					%%掉落X范围
		drop_y -> 3 ;					%%掉落Y范围
		drop_last_time -> 30 ;			%%掉落存活时间
        max_level  -> 100;             %%人物最大等级
        here_revive_hp -> 0.5;         %%原地复活生命值
        here_revive_mp -> 0.5;         %%原地复活法力值
        city_revive_hp -> 0.25;        %%回城复活生命值
        city_revive_mp -> 0.25;        %%回城复活法力值
        %%聊天
        chat_len -> 0;                 %聊天消息长度(字符)
        chat_cd  -> 10;                %世界聊天消息CD(秒)
 
        %%关系
        max_friend -> 30;              %%最大好友人数
        max_foe    -> 10;              %%最大仇人数
        max_bless  -> 20;              %%每天祝福次数

        %%帮派
        guild_create_coin     -> 100;        %创建帮派所需铜钱
        guild_require_level   -> 1;          %创建帮派所需要等级
        guild_accuse_time     -> 3*24*3600;  %弹劾投票时间长(秒)
        guild_max_level       -> 100;        %%帮派最大等级
        guild_role_max_apply  -> 3;          %%玩家同时申请最多帮派数
        guild_apply_max       -> 10;         %%同一帮派同时最多申请人数

        %%其他
        _Other -> undefined
    end.

%%背包大小(等级->背包大小增加量)
get_cell_num(Level) ->
    case Level of 
         1  -> 17;
         40 -> 5;
         _ -> 0
    end.
   
%%帮派升级费用(到达等级 -> 费用)
get_guild_upgrade_cost(Level) ->
    case Level of
        2 -> 100;
        3 -> 200;
        _ -> 0
    end.


%%复活要物品类型ID
get_revive_googs() ->
	465004204 .



