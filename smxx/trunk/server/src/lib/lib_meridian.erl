%%%-----------------------------------
%%% @Module  : lib_physique
%%% @Author  : Johanathe_Yip
%%% @Created : 2013.03.01
%%% @Description: 经脉

-module(lib_meridian).
-include("common.hrl").
-include("record.hrl").
-include("meridian.hrl").
-compile(export_all).


%--------------------------------------
%      玩家登陆游戏时初始化玩家经脉数据
%--------------------------------------

%%玩家登陆时初始化玩家数据
init_meridian(PS)-> 
	case db_agent_meridian:get_mer_by_uid(PS#player.id) of
		[Data] -> 
			MerInfo= list_to_tuple([meridian|Data]),  
			NewMerInfo = MerInfo#meridian{
											mer_state = util:bitstring_to_term(MerInfo#meridian.mer_state),
											mer_detail_1 = util:bitstring_to_term(MerInfo#meridian.mer_detail_1),
											mer_detail_2 = util:bitstring_to_term(MerInfo#meridian.mer_detail_2),
											cool_down = util:bitstring_to_term(MerInfo#meridian.cool_down)
										   },
			put(meridian_info,NewMerInfo);
		[]->
			new_meridian(PS#player.id);
		_->
			?ERROR_MSG("data error in table meridianidian  ~n",[])
	end,
 	improve_meridian_cd_info(PS),
	ok. 

%%在数据库新建经脉数据
new_meridian(PlayerId)-> 
	Result_1  = make_meridian_detail(mer_detail_1,?ALL_MER_TYPE),
	Result_2  = make_meridian_detail(mer_detail_2,?ALL_MER_TYPE),
	NewMerInfo = #meridian{			player_id = PlayerId,
										mer_state = {0,0},
										mer_detail_1 = Result_1,
										mer_detail_2 = Result_2,
										cool_down = {0,0,?NULL_COOL_DOWN}
							},
	put(meridian_info,NewMerInfo),
	db_agent_meridian:insert_mer_data 
	  ([PlayerId,util:term_to_bitstring(Result_1),
		util:term_to_bitstring(Result_2),
		util:term_to_bitstring({0,0}),
		util:term_to_bitstring({0,0,?NULL_COOL_DOWN})]),
	ok.

%%构造玩家经脉数据
make_meridian_detail(Flag,List)->
	lists:foldl(fun(Item,Sum)->
						put({Flag,Item},{0,0}),
						util:make_list(Sum, {Item,0,0})
				end, 0, List).

%-----------------------------
%			提升经脉
%-----------------------------

%%开始提升经脉(经脉1要等2小时)			
improve_meridian(?COST_CD,PS)->
	case get(meridian_info) of
		undefined->
			?ERROR_MSG("no meridian_info data in mem ~n ",[]),
			?UNKNOW_ERR; 
		MerInfo-> 
			case check_mer_trigger_condition(MerInfo) of
				true ->upd_mer_trigger_info(MerInfo),
					   true;
				Reason->Reason
			end
	end;		

%%提升经脉(经脉2)
improve_meridian(?COST_MONEY,PS)->
	case get(meridian_info) of
		undefined->
			?ERROR_MSG("no meridian_info data in mem ~n ",[]),
			?UNKNOW_ERR; 
		MerInfo-> 
			{_,MerState} = MerInfo#meridian.mer_state,
			case check_mer_lv(MerState) of
				true->
				upd_money_mer_fin_info(MerInfo),
					true;
				false->
					?OUT_OF_LV
			end
	end. 

%%2小时候候完成经脉提升(经脉1)
improve_meridian_cd_info(PS)->
	case get(meridian_info) of
		undefined->
			?ERROR_MSG("no meridian_info data in mem ~n ",[]),
			?UNKNOW_ERR; 
		MerInfo-> 
			case check_mer_fin_condition(MerInfo) of
				true->
					upd_cd_mer_fin_info(MerInfo),
					true;
				Reason->
					Reason
			end
	end.
%%判断经脉完成修炼条件(经脉1)
check_mer_fin_condition(MerInfo)->
	case check_cool_down_time(MerInfo#meridian.cool_down) of %%判断已过冷却时间
		true->
			case check_cool_down_state(MerInfo,?COOL_DOWN) of
				true -> true;
				false-> ?NOT_IN_MER_PROCESS
			end;
		false->
			?IN_COOL_DOWN
	end .
%%判断经脉cd(经脉1)
check_cool_down_state(MerInfo,State)->
	case MerInfo#meridian.cool_down of
		{_,_,State}->true;
		{_,_,_}->false;
		Err->
			?ERROR_MSG("wrong farmatter in meridian.cool_down ~p ~n",[Err]),
			false
	end.
%%检测玩家经脉冷却时间
check_cool_down_time({UpdTime,TimeCost,_})-> 
	Now = util:unixtime(),
	if Now-UpdTime>=TimeCost ->  true;
	   true->  false
	end;
check_cool_down_time(_)-> 
	false.

%%判断触发提升经脉条件(经脉1)
check_mer_trigger_condition(MerInfo)->
	case check_cool_down_state(MerInfo,?NULL_COOL_DOWN) of %%判断经脉cd
		true->  
			{MerState,_} = MerInfo#meridian.mer_state,
			%%判断经脉是否满级
			case check_mer_lv(MerState) of
				true->true;
				false->?OUT_OF_LV
			end;
		false->?NOT_IN_MER_PROCESS
	end.

%%检测玩家经脉是否满级
check_mer_lv(State)->
	 State =/= -1.

%%获取下一级状态 如果经脉满级,返回-1
get_next_state(State,Detail)->
	 {MerType,MerLv,_} = lists:nth(State+1, Detail),
		case tpl_meridian:get(MerType,MerLv) of
		[]->
			?ERROR_MSG("no tpl_meridian data lv:~p type: ~p ~n",[MerLv,MerType]),
			?MER_STATE_OUT_OF_LV;
		MerTpl->
			case MerTpl#tpl_meridian.next_mer_id of
				-1 ->
					?MER_STATE_OUT_OF_LV;
				_->State+1
			end
	end.
%%包装经脉状态，当经脉满级的时候做另外的处理(经脉2)
parse_mer_2_state(MerState,Detail)->
	case MerState of
		?MER_STATE_OUT_OF_LV -> length(Detail);
		_->MerState+1
	end.
%%包装经脉状态，当经脉满级的时候做另外的处理(经脉1)
parse_mer_1_state(MerState,Detail)->
	case MerState of
		?MER_STATE_OUT_OF_LV -> length(Detail);
		_->MerState
	end.

%%更新经脉状态(經脈2)
upd_money_mer_fin_info(MerInfo)->
	{S1,S2} = MerInfo#meridian.mer_state,
	{MerType,MerLv,BonLv} = lists:nth(parse_mer_2_state(S2,MerInfo#meridian.mer_detail_2)
									  , MerInfo#meridian.mer_detail_2),
 	NewMerDetail2 = lists:keyreplace(MerType, 1, MerInfo#meridian.mer_detail_2, {MerType,MerLv+1,BonLv}),
 	NS2 = get_next_state(S2,MerInfo#meridian.mer_detail_2),
	upd_meney_mer_fin_in_mem({S1,NS2},NewMerDetail2,MerInfo ),
	db_agent_meridian:upd_mer2_data_in_db([util:term_to_bitstring(NewMerDetail2),
										   util:term_to_bitstring({S1,NS2}),
										    MerInfo#meridian.player_id]).



%%将最新经脉状态同步到内存(经脉2)				
upd_meney_mer_fin_in_mem(State,MerDetail,MerInfo)->
	put(meridian_info,MerInfo#meridian{ 
										 mer_state = State,
										 mer_detail_2 =MerDetail
										}).

%%更新玩家经脉状态与冷却信息(经脉1)
upd_mer_trigger_info(MerInfo)->
	{S1,S2} = MerInfo#meridian.mer_state, 
 	Now = util:unixtime(),
	NS1 = get_next_state(S1,MerInfo#meridian.mer_detail_1),
	 upd_mer_trigger_2_mem(MerInfo,Now,{NS1,S2}), 
	db_agent_meridian:upd_trigger_mer_in_db([
											 util:term_to_bitstring({NS1,S2}),
											 util:term_to_bitstring({Now,?COOL_DOWN_TIME,?COOL_DOWN}),
											 MerInfo#meridian.player_id]).
%%更新经脉冷却与状态信息到内存(经脉1)
upd_mer_trigger_2_mem(MerInfo,Now,State)->
	put(meridian_info,MerInfo#meridian{
										 mer_state = State,
										 cool_down = {Now,?COOL_DOWN_TIME,?COOL_DOWN}
										 }).
	
%%更新经脉状态(經脈1)
upd_cd_mer_fin_info(MerInfo)->
	{MerState1,_} = MerInfo#meridian.mer_state,
	{MerType,MerLv,BonLv} = lists:nth(parse_mer_1_state(MerState1,MerInfo#meridian.mer_detail_1)
									  , MerInfo#meridian.mer_detail_1),
  	NewMerDetail1 = lists:keyreplace(MerType, 1, MerInfo#meridian.mer_detail_1, {MerType,MerLv+1,BonLv}),
    {TriTime,CoolDown,_} = MerInfo#meridian.cool_down,
	upd_cd_mer_fin_in_mem(NewMerDetail1,MerInfo,{TriTime,CoolDown,?NULL_COOL_DOWN}),
	db_agent_meridian:upd_mer1_data_in_db([util:term_to_bitstring(NewMerDetail1),
										   util:term_to_bitstring({TriTime,CoolDown,?NULL_COOL_DOWN}),
										   MerInfo#meridian.player_id]).

%%将最新经脉进度与冷却同步到内存(经脉1)				
upd_cd_mer_fin_in_mem(MerDetail,MerInfo,CoolDown)->
	put(meridian_info,MerInfo#meridian{ 
										 mer_detail_1 =MerDetail,
										 cool_down = CoolDown
										}).

%-----------------------------------
%             提升筋骨
%-----------------------------------
%%提升筋骨
improve_born(Type,MerId,PS)->
	case get(meridian_info) of
		undefined->
			?ERROR_MSG("no meridian_info datain pid ~n",[]),
			?UNKNOW_ERR;
		MerInfo ->
			MerDetail = get_mer_detail_info(Type,MerInfo),
			case check_mer_available(MerId,MerDetail) of %%判断要提升筋骨的筋骨是否有效
				true->
					{MerType,MerLv,BonLv} = lists:nth(MerId+1,MerDetail ),
					case check_bones_lv(BonLv) of %%判断筋骨是否满级
						true-> 
							NewMerDetail = lists:keyreplace(MerType, 1, MerDetail, {MerType,MerLv,BonLv+1}),
							upd_bones_info(Type,MerInfo,NewMerDetail),
							true;
						false ->
							?OUT_OF_BONES_LV
					end;
				false ->
					?OUT_OF_MERTYPE
			end
	end.  
 
%%判断要提升筋骨的筋骨是否有效
check_mer_available(MerId,MerDetail)->
	length(MerDetail)-1 >= MerId  .
%%判断筋骨是否满级
check_bones_lv(BonLv)->
	BonLv < ?MAX_BONES.

%%获取经脉进度
get_mer_detail_info(?MER_TYPE_1,MerInfo)->
	MerInfo#meridian.mer_detail_1;
get_mer_detail_info(?MER_TYPE_2,MerInfo)->
		MerInfo#meridian.mer_detail_2;
get_mer_detail_info(_,_)->
		?INFO_MSG("meridian type err in get_mer_detail_info ~n",[]),
		[].

%%更新筋骨数据
upd_bones_info(Type,MerInfo,NewMerDetail)->
 	upd_bones_info_2_mem(Type,MerInfo,NewMerDetail),
	db_agent_meridian:upd_bones_info_2_db(Type,util:term_to_bitstring(NewMerDetail),MerInfo#meridian.player_id).

%%更新筋骨数据到内存(经脉1)
upd_bones_info_2_mem(?MER_TYPE_1,MerInfo,NewMerDetail)->
	put(meridian_info,MerInfo#meridian{
										 mer_detail_1 = NewMerDetail
										});
%%更新筋骨数据到内存(经脉2)
upd_bones_info_2_mem(?MER_TYPE_2,MerInfo,NewMerDetail)->
	put(meridian_info,MerInfo#meridian{
										 mer_detail_2 = NewMerDetail
										});
upd_bones_info_2_mem(_,_,_)->
	?ERROR_MSG("param not match upd_bones_info_2_mem ~n",[]),
	error.

%-----------------------------------
%         获取玩家经脉筋骨数据
%-----------------------------------

%%获取玩家经脉1/2信息
get_player_all_meridian()->
	case get(meridian_info) of
		undefined->
			?ERROR_MSG("no meridian_info in pid ~n",[]),
			[[],[]];
		MerInfo when is_record(MerInfo, meridian)->
			[MerInfo#meridian.mer_detail_1,MerInfo#meridian.mer_detail_2];
		_->
			?ERROR_MSG("wrong meridian_info in pid ~n",[]),
			[[],[]]
	end.
			
%%现实玩家经脉信息
show_meridianidian(PS)->
 [MerDetail1,MerDetail2] = get_player_all_meridian(),
 ?INFO_MSG("all meridian ~p ~n",[{MerDetail1,MerDetail2}]),
 {ok,Data} = pt_45:write(45001, [MerDetail1,MerDetail2]),
 lib_send:send_to_sid((PS#player.other#player_other.pid_send), Data).
 
	
	
