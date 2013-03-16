%%%-----------------------------------
%%% @Module  : pt_12
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 12场景信息
%%%-----------------------------------
-module(pt_12).
-export([read/2, write/2,pack_player/1,pack_mon/1]).
-include("common.hrl").
-include("record.hrl").

%%%%
%%%%客户端 -> 服务端 ----------------------------
%%%%


%%
%%%%玩家进入某场景
read(12001, <<SceneId:16,PostX:8,PostY:8>>) ->
   {ok, [SceneId,PostX,PostY]};
%%
%%加载场景
read(12002, _) ->
%% io:format("12002_______________ ~n",[]),
   {ok, load_scene};


%%玩家移动
read(12010, <<DestX:8,DestY:8,WalkPathBin/binary>>) ->
	{ok,[DestX,DestY,WalkPathBin]};
	


%%玩家位置同步
read(12011,<<X:8, Y:8>>) ->
	{ok, [X, Y]};


%%掉落拾取
read(12016,<<MonId:32, GoodsId:32,PosX:8,PosY:8>>) ->
	{ok, [MonId, GoodsId,PosX,PosY]};

%%开始采集
read(12017,<<TaskId:32,NPCId:16>>) ->
	{ok, [TaskId,NPCId]};

%%中断采集
read(12018,_R) ->
	{ok, []};

%%结束采集
read(12019,<<TaskId:32,NPCId:16>>) ->
	{ok, [TaskId,NPCId]};

%%玩家原地复活
read(12020,_R) ->
	{ok, []};


%%玩家回主城复活
read(12021,<<SceneId:16>>) ->
	{ok, [SceneId]};

%%
read(_Cmd, _R) ->
   {error, no_match}.
%%
%%%%
%%%%服务端 -> 客户端 ------------------------------------
%%%%
%%
%%%%玩家进入某场景
write(12001, [SceneId,X,Y]) ->
   {ok, pt:pack(12001, <<SceneId:16,X:8,Y:8>> )};


%%%%玩家进入某场景
write(12002, [PlayerList,MonList]) ->
   PlayerLen = length(PlayerList) ,
   PlayerBin = tool:to_binary([pack_player(P) || P <- PlayerList]),
   
   MonLen = length(MonList) ,
   MonBin = tool:to_binary([pack_mon(M) || M <- MonList]),
   
   {ok, pt:pack(12002, <<PlayerLen:16,PlayerBin/binary,MonLen:16,MonBin/binary>>)};


%%进入新场景广播给本场景的人
write(12003, [Palyer]) ->
	Data = pack_player(Palyer),
	{ok, pt:pack(12003, Data)};

%%玩家离开场景
write(12004, [UId]) ->
	{ok, pt:pack(12004, <<UId:64>>)};

%%怪物复活
write(12007, [MonRcd]) ->
	MonBin = pack_mon(MonRcd) ,
	{ok, pt:pack(12007, <<MonBin/binary>>)};

%%玩家走路路径同步
write(12010, [UId,DestX,DestY,WarkPathBin]) ->
	{ok, pt:pack(12010, <<UId:64,DestX:8,DestY:8,WarkPathBin/binary>>)} ;


%%怪物走路协议
write(12012, [MId,Path]) ->
	PLen = length(Path) ,
	Fun = fun({X,Y}) ->
				  <<X:8,Y:8>>
		  end ,
	MoveBin  = tool:to_binary([Fun(M) || M <- Path]),
	{ok, pt:pack(12012, <<MId:32,PLen:16,MoveBin/binary>>)} ;


%%怪物状态变化协议
write(12013, [DataList]) ->
	Len = length(DataList) ,
	Fun = fun({MId,BuffList}) ->
				  BLen = length(BuffList) ,
				  BFun = fun({BuffId,ExpirTime}) ->
								 <<BuffId:16,ExpirTime:32>>
						 end ,
				  BuffBin = tool:to_binary([BFun(B) || B <- BuffList]),
				  <<MId:32,BLen:16,BuffBin/binary>> 
		  end ,
	DataBin  = tool:to_binary([Fun(M) || M <- DataList]),
	{ok, pt:pack(12013, <<Len:16,DataBin/binary>>)} ;



%%怪物走路协议
write(12014, [MId,SId,CanBreak,ChantTime]) ->
	{ok, pt:pack(12014, <<MId:32,SId:8,CanBreak:8,ChantTime:32>>)} ;


%%怪物掉落协议
write(12015, [DropList]) ->
	Len = length(DropList) ,
	NowTime = util:unixtime() ,
	DataBin  = tool:to_binary([pack_drop(D,NowTime) || D <- DropList]),
	{ok, pt:pack(12015, <<Len:16,DataBin/binary>>)} ;



%%掉落拾取协议
write(12016, [Code]) ->
	{ok, pt:pack(12016, <<Code:8>>)} ;



%%开始采集
write(12017, [Code]) ->
	{ok, pt:pack(12017, <<Code:8>>)} ;


%%中断采集
write(12018, [Code]) ->
	{ok, pt:pack(12018, <<Code:8>>)} ;


%%结束采集
write(12019, [Code]) ->
	{ok, pt:pack(12019, <<Code:8>>)} ;



%%人物原地复活
write(12020, [Code]) ->
	{ok, pt:pack(12020, <<Code:8>>)} ;

%%人物回城复活
write(12021, [Code]) ->
	{ok, pt:pack(12021, <<Code:8>>)} ;



write(Cmd, _R) ->
	?DEBUG("-------------------------ERR:~p~n",[_R]),
	?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
	{ok, pt:pack(0, <<>>)}.


pack_drop(DropRcd,NowTime) ->
	if
		is_record(DropRcd,mon_drop_goods) ->
			NewDropRcd = DropRcd ;
		true ->
			NewDropRcd = #mon_drop_goods{} 
	end ,
	MonId 	= NewDropRcd#mon_drop_goods.mon_id ,
	GoodsId = NewDropRcd#mon_drop_goods.goods_id ,
	GoodsNum = NewDropRcd#mon_drop_goods.goods_num ,
	DropX = NewDropRcd#mon_drop_goods.x ,
	DropY = NewDropRcd#mon_drop_goods.y ,
	LeftTime = NowTime - NewDropRcd#mon_drop_goods.drop_time ,
	<<MonId:32,GoodsId:32,GoodsNum:32,DropX:8,DropY:8,LeftTime:16>> .

%% 打包玩家信息
pack_player(Player) ->
	if
		is_record(Player,player) ->
			NewPlayer = Player ;
		true ->
			NewPlayer = #player{} 
	end ,
	PosX = NewPlayer#player.battle_attr#battle_attr.x ,
	PosY = NewPlayer#player.battle_attr#battle_attr.y ,
	UId =  NewPlayer#player.id ,
	UId =  NewPlayer#player.id ,
	{NmLen,NmBin} = tool:pack_string(NewPlayer#player.nick) ,
	Stts = NewPlayer#player.status ,
	Sex = NewPlayer#player.gender ,
	Crr = NewPlayer#player.career ,
	CurHp = NewPlayer#player.battle_attr#battle_attr.hit_point ,
	MaxHp = NewPlayer#player.battle_attr#battle_attr.hit_point_max ,
	Magic = NewPlayer#player.battle_attr#battle_attr.magic ,
	MagicMax = NewPlayer#player.battle_attr#battle_attr.magic_max ,
    [Weapon, Armor, Fashion, WwaponAcc, Wing, Mount] = NewPlayer#player.other#player_other.equip_current,
	WeaponStrenLv = NewPlayer#player.other#player_other.weapon_strenLv, 
	ArmorStrenLv = NewPlayer#player.other#player_other.armor_strenLv, 
	FashionStrenLv = NewPlayer#player.other#player_other.fashion_strenLv, 
	WaponAccStrenLv = NewPlayer#player.other#player_other.wapon_accstrenLv, 
	WingStrenLv = NewPlayer#player.other#player_other.wing_strenLv,
	<<PosX:8,PosY:8,UId:64,NmLen:16,NmBin/binary,Stts:8,Sex:8,Crr:8,CurHp:32,MaxHp:32,Magic:32,MagicMax:32,
		Weapon:32, Armor:32, Fashion:32, WwaponAcc:32, Wing:32, Mount:32, WeaponStrenLv:8, ArmorStrenLv:8, FashionStrenLv:8,
	   WaponAccStrenLv:8, WingStrenLv:8>> .

%% 打包怪物信息
pack_mon(Mon) ->
	if
		is_record(Mon,temp_mon_layout) ->
			NewMon = Mon ;
		true ->
			NewMon = #temp_mon_layout{monrcd=#temp_npc{},battle_attr=#battle_attr{}} 
	end ,
	MonId = NewMon#temp_mon_layout.id ,
	PosX = NewMon#temp_mon_layout.pos_x ,
	PosY = NewMon#temp_mon_layout.pos_y ,
	Stts =  NewMon#temp_mon_layout.state ,
	CurHp = NewMon#temp_mon_layout.battle_attr#battle_attr.hit_point ,
	MaxHp  = NewMon#temp_mon_layout.battle_attr#battle_attr.hit_point_max ,
	Magic = NewMon#temp_mon_layout.battle_attr#battle_attr.magic ,
	MagicMax = NewMon#temp_mon_layout.battle_attr#battle_attr.magic_max ,
	BuffList = NewMon#temp_mon_layout.battle_attr#battle_attr.buff1,
	BuffLen = length(BuffList) ,
	Fun = fun({BuffId,ExpirTime}) ->
				  <<BuffId:16,ExpirTime:32>>
		  end ,
	BuffBin = tool:to_binary([Fun(M) || M <- BuffList]),
	<<MonId:32,PosX:8,PosY:8,Stts:8,CurHp:32,MaxHp:32,Magic:32,MagicMax:32,BuffLen:16,BuffBin/binary>> .

	
