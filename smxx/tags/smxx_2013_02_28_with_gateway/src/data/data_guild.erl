%%---------------------------------------
%% @Module  : data_guild
%% @Author  : water
%% @Created : 2013.02.22
%% @Description:  联盟配置
%%---------------------------------------

-module(data_guild).
-compile(export_all).

get_guild_config(Type) ->
    case Type of
        create_coin   -> 100;        %创建帮派所需铜钱
        require_level -> 1;          %创建帮派所需要等级
        accuse_time   -> 3*24*3600;  %投票持续弹劾时间 
        max_level     -> 100;        %%最大等级
        _             -> undefined
    end.

%%最大帮派人数
get_max_num() ->
    20.

get_upgrade_cost(_Level) ->
    10.

