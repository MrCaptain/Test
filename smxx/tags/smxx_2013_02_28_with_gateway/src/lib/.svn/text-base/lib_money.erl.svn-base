%%%-------------------------------------- 
%%% @Module: lib_money
%%% @Author: lxl
%%% @Created: 2012-7-12
%%% @Description: 
%%%-------------------------------------- 
-module(lib_money).

%% 
%% Including Files
%%
-include("record.hrl").
-include("goods.hrl").
%% -include("num_limits.hrl").
-include("common.hrl").
%% -include("player.hrl").
-include("common_log.hrl").

-compile(export_all).
%% 
%% %% 元宝对战天币的兑换率（RMB：表示人民币，即元宝， ZTM：表示zt money，即战天币）
%% -define(RMB_TO_ZTM_CONVERT_RATE, 10).
%% 
%% -define(DEFAULT_INTERVAL_SECONDS, 300).   % 5分钟
%% -define(DEFAULT_GOLD_PER_INTERVAL, 1).     % 每段间隔1元宝
%% 
%% %%充值增加元宝
%% recharge(PS, 0) -> PS;
%% recharge(PS, Num) ->
%% 	%%充值日志
%% 	NewStatus = lib_player:add_gold(PS, Num),
%% 	log:log_currency_consume(NewStatus#player.id, recharge, Num),
%% 	lib_common:actin_new_proc(mod_p2_activity, handle_charge_tips, [NewStatus, Num]),
%% 	NewStatus.

%% 扣除角色金钱 , 统计货币流向 + 货币消费统计
%% @Source: 货币流向地方  详细参照common_log.hrl
%% @return: NewPlayerStatus
%% @GoodsTid:物品类型ID	
cost_money(statistic, PlayerStatus, 0, _Type, _Source) ->
	PlayerStatus;
cost_money(statistic, PlayerStatus, Cost, Type, Source) ->
	cost_money(statistic, PlayerStatus, Cost, Type, Source, 0);

%% 扣除角色金钱 , 只统计货币流向,不统计货币消费
%% @Source: 货币流向地方  详细参照common_log.hrl
%% @return: NewPlayerStatus
cost_money(unstatistic, PlayerStatus, 0, _Type, _Source) ->
	PlayerStatus;
cost_money(unstatistic, PlayerStatus, Cost, Type, Source) ->
	cost_money(unstatistic, PlayerStatus, Cost, Type, Source, 0).

cost_money(statistic, PlayerStatus, Cost, Type, Source, GoodsTid) ->
%% 	log:log_currency_circulation(PlayerStatus#player.id, Currency, ?LOG_CONSUME_CURRENCY, Source, Cost, Leavings)
	NewPlayerStatus = get_cost(statistic, PlayerStatus, Cost, Type, Source, GoodsTid),
%%     if 
%%         Type == gold orelse Type == ?MONEY_T_GOLD ->
%%         	mod_gs_stati:log_player_use_RMB(PlayerStatus#player.id, Cost); % 记录玩家消费元宝（用于做全服统计）
%%         true ->
%%             skip
%%     end,
    % 通知客户端更新金钱
    lib_player:send_player_attribute3(NewPlayerStatus),
    NewPlayerStatus;

%% @GoodsTid:物品类型ID	
cost_money(unstatistic, PlayerStatus, Cost, Type, Source, GoodsTid) ->
%% 	log:log_currency_circulation(PlayerStatus#player.id, Currency, ?LOG_CONSUME_CURRENCY, Source, Cost, Leavings)
	NewPlayerStatus = get_cost(unstatistic, PlayerStatus, Cost, Type, Source, GoodsTid),
    if 
        Type == gold orelse Type == ?MONEY_T_GOLD ->
        	mod_gs_stati:log_player_use_RMB(PlayerStatus#player.id, Cost); % 记录玩家消费元宝（用于做全服统计）
        true ->
            skip
    end,
    % 通知客户端更新金钱
    lib_player:send_player_attribute3(NewPlayerStatus),
    NewPlayerStatus.

%% desc: 计算消费
%% returns: NewPS
get_cost(statistic, PlayerStatus, Cost, Type, Source, GoodsTid) ->
	case Type of
		% 铜钱
		?MONEY_T_COIN -> 
			DiffCoin = (PlayerStatus#player.coin - Cost),
			case PlayerStatus#player.coin >= Cost of
				true -> 
					log:log_currency_consume(PlayerStatus#player.id, coin, Cost),
					log:log_currency_circulation(PlayerStatus#player.id, 
												 ?LOG_COIN, ?LOG_CONSUME_CURRENCY, Source, Cost, DiffCoin, GoodsTid),						
					PlayerStatus#player{coin = DiffCoin};
				false -> 
					log:log_currency_consume(PlayerStatus#player.id, coin, PlayerStatus#player.coin),
					log:log_currency_consume(PlayerStatus#player.id, bcoin, abs(DiffCoin)),
					log:log_currency_circulation(PlayerStatus#player.id, 
												 ?LOG_COIN, ?LOG_CONSUME_CURRENCY, Source, PlayerStatus#player.coin, 0, GoodsTid),
					log:log_currency_circulation(PlayerStatus#player.id, 
												 ?LOG_BCOIN, ?LOG_CONSUME_CURRENCY, Source, abs(DiffCoin), 
												 util:minmax(PlayerStatus#player.coin + DiffCoin, 0, ?MAX_S32), GoodsTid),
					
					PlayerStatus#player{
										coin = 0, 
										bcoin = util:minmax(PlayerStatus#player.coin + DiffCoin, 0, ?MAX_S32)
									   }
			end;
		% 绑定铜钱
		?MONEY_T_BCOIN -> 
			log:log_currency_consume(PlayerStatus#player.id, coin, Cost),
			log:log_currency_circulation(PlayerStatus#player.id, 
										 ?LOG_BCOIN, ?LOG_CONSUME_CURRENCY, Source, Cost, 
										 util:minmax(PlayerStatus#player.bcoin - Cost, 0, ?MAX_S32), GoodsTid),
			PlayerStatus#player{bcoin = util:minmax(PlayerStatus#player.bcoin - Cost, 0, ?MAX_S32)}; 
		% 元宝
		?MONEY_T_GOLD -> 
			log:log_currency_consume(PlayerStatus#player.id, gold, Cost),
			log:log_currency_circulation(PlayerStatus#player.id, 
										 ?LOG_GOLD, ?LOG_CONSUME_CURRENCY, Source, Cost, 
										 util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32), GoodsTid),
			PlayerStatus#player{gold = util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32)};
		% 绑定元宝
		?MONEY_T_BGOLD -> 
			log:log_currency_consume(PlayerStatus#player.id, gold, Cost),
			log:log_currency_circulation(PlayerStatus#player.id, 
										 ?LOG_BGOLD, ?LOG_CONSUME_CURRENCY, Source, Cost, 
										 util:minmax(PlayerStatus#player.bgold - Cost, 0, ?MAX_S32), GoodsTid),
			PlayerStatus#player{bgold = util:minmax(PlayerStatus#player.bgold - Cost, 0, ?MAX_S32)}
	end;
get_cost(unstatistic, PlayerStatus, Cost, Type, Source, GoodsTid) ->
	case Type of
		% 铜钱
		?MONEY_T_COIN -> 
			DiffCoin = (PlayerStatus#player.coin - Cost),
			case PlayerStatus#player.coin >= Cost of
				true -> 
					log:log_currency_circulation(PlayerStatus#player.id, 
												 ?LOG_COIN, ?LOG_CONSUME_CURRENCY, Source, Cost, DiffCoin, GoodsTid),
					PlayerStatus#player{coin = DiffCoin}; 
				false -> 
					log:log_currency_circulation(PlayerStatus#player.id, 
												 ?LOG_COIN, ?LOG_CONSUME_CURRENCY, Source, PlayerStatus#player.coin, 0, GoodsTid),
					log:log_currency_circulation(PlayerStatus#player.id, 
												 ?LOG_BCOIN, ?LOG_CONSUME_CURRENCY, Source, abs(DiffCoin), 
												 util:minmax(PlayerStatus#player.bcoin + DiffCoin, 0, ?MAX_S32), GoodsTid),
					PlayerStatus#player{
										coin = 0, 
										bcoin = util:minmax(PlayerStatus#player.coin + DiffCoin, 0, ?MAX_S32)
									   }
			end;
		% 绑定铜钱
		?MONEY_T_BCOIN -> 
			log:log_currency_circulation(PlayerStatus#player.id, 
										 ?LOG_BCOIN, ?LOG_CONSUME_CURRENCY, Source, Cost, 
										 util:minmax(PlayerStatus#player.bcoin - Cost, 0, ?MAX_S32), GoodsTid),
			PlayerStatus#player{bcoin = util:minmax(PlayerStatus#player.bcoin - Cost, 0, ?MAX_S32)}; 
		% 元宝
		?MONEY_T_GOLD -> 
			log:log_currency_circulation(PlayerStatus#player.id, 
										 ?LOG_GOLD, ?LOG_CONSUME_CURRENCY, Source, Cost, 
										 util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32), GoodsTid),
			PlayerStatus#player{gold = util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32)};
		% 绑定元宝
		?MONEY_T_BGOLD -> 
			log:log_currency_circulation(PlayerStatus#player.id, 
										 ?LOG_BGOLD, ?LOG_CONSUME_CURRENCY, Source, Cost, 
										 util:minmax(PlayerStatus#player.bgold - Cost, 0, ?MAX_S32), GoodsTid),
			PlayerStatus#player{bgold = util:minmax(PlayerStatus#player.bgold - Cost, 0, ?MAX_S32)}
	end.

%% 扣除角色金钱
%% @return: NewPlayerStatus
cost_money(PlayerStatus, 0, _Type) ->
    PlayerStatus;
cost_money(PlayerStatus, Cost, Type) ->
    NewPlayerStatus = get_cost(PlayerStatus, Cost, Type),
    if 
        Type == gold orelse Type == ?MONEY_T_GOLD ->
        	mod_gs_stati:log_player_use_RMB(PlayerStatus#player.id, Cost); % 记录玩家消费元宝（用于做全服统计）
        true ->
            skip
    end,
    % 通知客户端更新金钱
    lib_player:send_player_attribute3(NewPlayerStatus),
    NewPlayerStatus.

%% 扣除角色金钱  不计入货币消费统计范围
%% @return: NewPlayerStatus
cost_money(unstatistic, PlayerStatus, 0, _Type) ->
	PlayerStatus;
cost_money(unstatistic, PlayerStatus, Cost, Type) ->
	NewPlayerStatus = get_cost(unstatistic, PlayerStatus, Cost, Type),
    if
        Type == gold orelse Type == ?MONEY_T_GOLD ->
        	mod_gs_stati:log_player_use_RMB(PlayerStatus#player.id, Cost); % 记录玩家消费元宝（用于做全服统计）
        true ->
            skip
    end,
    % 通知客户端更新金钱
    lib_player:send_player_attribute3(NewPlayerStatus),
    NewPlayerStatus.

%% exports
%% desc: 改变db中玩家的货币
db_change_player_money(PS) -> ok.
%%     db:update(player, 
%%     			["coin", "gold", "coin", "zt_money", "guild_prestige"], 
%%     			[PS#player.coin, PS#player.gold, PS#player.coin, PS#player.bcoin, PS#player.guild_prestige], 
%%     			"id", 
%%     			PS#player.id
%%     		 ).

%% desc: 计算消费
%% returns: NewPS
cost_ps_money(PlayerStatus, Cost, Type) ->
    case Type of
        % 铜钱
        ?MONEY_T_COIN -> 
         	 PlayerStatus#player{coin = util:minmax(PlayerStatus#player.coin - Cost, 0, ?MAX_S32)}; 
        % 绑定铜钱
        ?MONEY_T_BCOIN ->
			DiffCoin = (PlayerStatus#player.bcoin - Cost),
            case PlayerStatus#player.bcoin >= Cost of
                true ->
					PlayerStatus#player{bcoin = DiffCoin}; 
                false ->
					PlayerStatus#player{
                				bcoin = 0, 
                				coin = util:minmax(PlayerStatus#player.coin + DiffCoin, 0, ?MAX_S32)
                				}
            end;			
        % 元宝
        ?MONEY_T_GOLD ->
			PlayerStatus#player{gold = util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32)};
        % 绑定元宝
        ?MONEY_T_BGOLD ->
			DiffGold = (PlayerStatus#player.bgold - Cost),
            case PlayerStatus#player.bgold >= Cost of
                true ->
					PlayerStatus#player{bgold = DiffGold}; 
                false ->
					PlayerStatus#player{
                				bgold = 0, 
                				gold = util:minmax(PlayerStatus#player.gold + DiffGold, 0, ?MAX_S32)
                				}
            end
    end.

%% desc: 计算消费
%% returns: NewPS
get_cost(PlayerStatus, Cost, Type) ->
    case Type of
        % 铜钱
        ?MONEY_T_COIN -> 
            DiffCoin = (PlayerStatus#player.coin - Cost),
            case PlayerStatus#player.coin >= Cost of
                true -> log:log_currency_consume(PlayerStatus#player.id, coin, Cost),
						PlayerStatus#player{coin = DiffCoin}; 
                false -> log:log_currency_consume(PlayerStatus#player.id, coin, PlayerStatus#player.coin),
						 log:log_currency_consume(PlayerStatus#player.id, bcoin, abs(DiffCoin)),
						 PlayerStatus#player{
                				coin = 0, 
                				bcoin = util:minmax(PlayerStatus#player.bcoin + DiffCoin, 0, ?MAX_S32)
                				}
            end;
        % 绑定铜钱
        ?MONEY_T_BCOIN -> log:log_currency_consume(PlayerStatus#player.id, bcoin, Cost),
				  PlayerStatus#player{bcoin = util:minmax(PlayerStatus#player.bcoin - Cost, 0, ?MAX_S32)}; 
        % 元宝
        ?MONEY_T_GOLD -> log:log_currency_consume(PlayerStatus#player.id, gold, Cost),
				PlayerStatus#player{gold = util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32)};
        % 绑定元宝
        ?MONEY_T_BGOLD -> log:log_currency_consume(PlayerStatus#player.id, gold, Cost),
				PlayerStatus#player{bgold = util:minmax(PlayerStatus#player.bgold - Cost, 0, ?MAX_S32)}
    end.

get_cost(unstatistic, PlayerStatus, Cost, Type) ->
	case Type of
        % 铜钱
        ?MONEY_T_COIN -> 
            DiffCoin = (PlayerStatus#player.coin - Cost),
            case PlayerStatus#player.coin >= Cost of
                true -> PlayerStatus#player{coin = DiffCoin}; 
                false -> PlayerStatus#player{
                				coin = 0, 
                				bcoin = util:minmax(PlayerStatus#player.bcoin + DiffCoin, 0, ?MAX_S32)
                				}
            end;
        % 绑定铜钱
        ?MONEY_T_BCOIN -> PlayerStatus#player{coin = util:minmax(PlayerStatus#player.bcoin - Cost, 0, ?MAX_S32)}; 
        % 元宝
        ?MONEY_T_GOLD -> PlayerStatus#player{gold = util:minmax(PlayerStatus#player.gold - Cost, 0, ?MAX_S32)};
        % 绑定元宝
        ?MONEY_T_BGOLD -> PlayerStatus#player{bgold = util:minmax(PlayerStatus#player.bgold - Cost, 0, ?MAX_S32)};
		_ ->	PlayerStatus
    end.

%% exports
%% 判断金钱是否充足
%% returns: 充足则返回true，否则返回false
can_pay(PS, List) ->
    F = fun({Cost, Type}, [Result, PStatus]) ->
                case Result of
                    true ->
                        case has_enough_money(PStatus, Cost, Type) of
                            true ->    [true, cost_ps_money(PStatus, Cost, Type)];
                            false ->   [false, PStatus]
                        end;
                    false ->
                        [Result, PStatus]
                end
        end,
    [IsEnough, _] = lists:foldl(F, [true, PS], List),
    IsEnough.

%% desc: 判断金钱是否充足
%% returns: true | false
has_enough_money(PS, Cost, Type) when is_atom(Type) ->
    case Type of
        ?MONEY_T_BCOIN ->   PS#player.coin + PS#player.bcoin >= Cost; % 绑定游戏币
        ?MONEY_T_COIN ->  	PS#player.coin >= Cost;   % 非绑定游戏币
        ?MONEY_T_GOLD ->    PS#player.gold >= Cost;   % 元宝
        ?MONEY_T_BGOLD ->   PS#player.bgold + PS#player.gold >= Cost;  % 绑定元宝
		_ -> false 
    end.
%% 
%% exports
%% desc: 从列表中选出钱给予玩家
%% returns: [NewPS, List]
%% Goods : {GoodsTid, Num} | GoodsTid | #ets_drop_content{} 只允许三种类型
give_role_money([], PS, Res) ->
    [PS, Res];
give_role_money([Goods | T], PS, Res) ->
    {GoodsTid, Num} = if
                          is_integer(Goods) ->
                              {Goods, 1};
                          erlang:tuple_size(Goods) =:= 2 ->
                              Goods;
                          true ->
                              {0, 0}
                      end,
    [NewPS, Left] = case GoodsTid of
                        ?MONEY_COIN_T_ID -> 
                            PS1 = lib_player:add_coin(PS, Num),
                            [PS1, Res];
						?MONEY_BCOIN_T_ID ->
                            PS1 = lib_player:add_bcoin(PS, Num),
                            [PS1, Res];
                        ?MONEY_GOLD_T_ID ->
                            PS1 = lib_player:add_gold(PS, Num),
                            [PS1, Res];
                        ?MONEY_BGOLD_T_ID ->
                            PS1 = lib_player:add_bgold(PS, Num),
                            [PS1, Res];
                        _ ->
                            [PS, [{GoodsTid, Num} | Res]]
                    end,
    give_role_money(T, NewPS, Left).