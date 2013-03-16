%%%-----------------------------------
%%% @Module  : pt_12
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 12场景信息
%%%-----------------------------------
-module(pt_12).
-export([read/2, write/2]).
-include("common.hrl").
-include("record.hrl").

%%%%
%%%%客户端 -> 服务端 ----------------------------
%%%%


%%
%%%%玩家进入某场景
read(12001, <<SceneId:32>>) ->
   {ok, [SceneId]};
%%
%%加载场景
read(12002, _) ->
%% io:format("12002_______________ ~n",[]),
   {ok, load_scene};


%%玩家移动
read(12010, <<DestX:16,DestY:16, WalkPathBin/binary>>) ->
	{ok,[DestX,DestY,WalkPathBin]};
	


%%玩家位置同步
read(12011,<<X:32, Y:32>>) ->
	{ok, [X, Y]};


%%
read(_Cmd, _R) ->
   {error, no_match}.
%%
%%%%
%%%%服务端 -> 客户端 ------------------------------------
%%%%
%%
%%%%玩家进入某场景
write(12001, [Player]) ->
   PlayerBin = pack_player(Player),
   {ok, pt:pack(12001, <<PlayerBin/binary>>)};


%%%%玩家进入某场景
write(12002, [PlayerList,_NpcList,_MonList]) ->
   PlayerLen = length(PlayerList) ,
   PlayerBin = tool:to_binary([pack_player(D) || D <- PlayerList]),
   {ok, pt:pack(12002, <<PlayerLen:16,PlayerBin/binary>>)};


%%进入新场景广播给本场景的人
write(12003, [Palyer]) ->
	Data = pack_player([Palyer]),
	{ok, pt:pack(12003, Data)};

%%玩家离开场景
write(12004, [UId]) ->
	{ok, pt:pack(12004, <<UId:64>>)};


%%玩家走路路径同步
write(12010, [UId,DestX,DestY,WarkPathBin]) ->
	{ok, pt:pack(12004, <<UId:64,DestX:16,DestY:16,WarkPathBin/binary>>)} ;




%%%%走路
%%write(12001, [X, Y, SX, SY, Id]) ->
%%%%io:format("12001_put_~p ~n",[[X, Y, Id]]),
%%    Data = <<X:8, Y:8, SX:8, SY:8, Id:32>>,
%%    {ok, pt:pack(12001, Data)};
%%
%%%% 加场景信息
%%write(12002, {User, Npc}) ->
%%%% io:format("12002_______________22_____________: [~p]~n", [length(User)]),
%%	DataUser = pack_role_list(User),
%%%% io:format("12002_test_ ~p~n",[Npc]),
%%    DataNpc = pack_npc_list(Npc),
%%%%io:format("12002_test_ ~n",[]),
%%    Data = <<DataUser/binary, DataNpc/binary>>,
%%    {ok, pt:pack(12002, Data)};
%%
%%
%%%%退出场景
%%write(12004, Id) ->
%%    Data = <<Id:32>>,
%%    {ok, pt:pack(12004, Data)};
%%
%%%%切换场景
%%write(12005, [Id, X, Y, Name, Sid, DungeonTimes, DungeonMaxtimes, ArenaMark]) ->
%%%% ?DEBUG("______________________________________________1200555_______________5555_____________: [~p]~n", [Sid]),
%%    Len = byte_size(Name),
%%    Data = <<Id:32, X:8, Y:8, Len:16, Name/binary, Sid:32, DungeonTimes:8, DungeonMaxtimes:8, ArenaMark:8>>,
%%    {ok, pt:pack(12005, Data)};
%%
%%%%使用物品或者装备物品
%%write(12009, [PlayerId, HP, HP_lim]) ->
%%    {ok, pt:pack(12009, <<PlayerId:32, HP:32, HP_lim:32>>)};
%%
%%%%乘上坐骑或者离开坐骑
%%write(12010, [PlayerId, PlayerSpeed, MountTypeId,MountId,MountStren]) ->
%%    {ok, pt:pack(12010, <<PlayerId:32, PlayerSpeed:16, MountTypeId:32,MountId:32,MountStren:8>>)};
%%
%%%%加场景信息
%%write(12011, [EnterUser, LeaveUser]) ->
%%    EnterUserData = pack_role_list(EnterUser),
%%    LeaveUserData = pack_leave_list(LeaveUser),
%%    Data = <<EnterUserData/binary, LeaveUserData/binary>>,
%%    {ok, pt:pack(12011, Data)};
%%
%%%%装备物品
%%write(12012, [PlayerId, GoodsTypeId, Subtype, HP, HP_lim]) ->
%%    {ok, pt:pack(12012, <<PlayerId:32, GoodsTypeId:32, Subtype:16, HP:32, HP_lim:32>>)};
%%
%%%%卸下装备
%%write(12013, [PlayerId, GoodsTypeId, Subtype, HP, HP_lim]) ->
%%    {ok, pt:pack(12013, <<PlayerId:32, GoodsTypeId:32, Subtype:16, HP:32, HP_lim:32>>)};
%%
%%%%使用物品
%%write(12014, [PlayerId, GoodsTypeId, HP, HP_lim]) ->
%%    {ok, pt:pack(12014, <<PlayerId:32, GoodsTypeId:32, HP:32, HP_lim:32>>)};
%%
%%%%装备磨损
%%write(12015, [PlayerId, HP, HP_lim, GoodsList]) ->
%%    ListNum = length(GoodsList),
%%    F = fun(GoodsInfo) ->
%%            GoodsId = GoodsInfo#goods.gtid,
%%            Subtype = GoodsInfo#goods.stype,
%%            <<GoodsId:32, Subtype:16>>
%%        end,
%%    ListBin = tool:to_binary(lists:map(F, GoodsList)),
%%    {ok, pt:pack(12015, <<PlayerId:32, HP:32, HP_lim:32, ListNum:16, ListBin/binary>>)};
%%
%%%%切换装备
%%write(12016, [PlayerId, HP, HP_lim, GoodsList]) ->
%%    ListNum = length(GoodsList),
%%    F = fun(GoodsInfo) ->
%%            GoodsId = GoodsInfo#goods.gtid,
%%            Subtype = GoodsInfo#goods.stype,
%%            <<GoodsId:32, Subtype:16>>
%%        end,
%%    ListBin = tool:to_binary(lists:map(F, GoodsList)),
%%    {ok, pt:pack(12016, <<PlayerId:32, HP:32, HP_lim:32, ListNum:16, ListBin/binary>>)};
%%
%%%%掉落包生成
%%write(12017, [RealMonId, Time, X, Y]) ->
%%     {ok, pt:pack(12017, <<RealMonId:32, Time:16, X:8, Y:8>>)};
%%
%%%%某玩家成为队长(卸任队长)时通知场景
%%write(12018, [Id, Type]) ->
%%%% ?DEBUG("12018_~p/",[{Id, Type}]),
%%    {ok, pt:pack(12018, <<Id:32, Type:8>>)};
%%
%%%%掉落包消失
%%write(12019, DropId) ->
%%     {ok, pt:pack(12019, <<DropId:32>>)};
%%
%%%% 改变NPC状态图标
%%write(12020, []) ->
%%    {ok, pt:pack(12020, <<>>)};
%%write(12020, [NpcList]) ->
%%    NL = length(NpcList),
%%    Bin = tool:to_binary([<<Id:32, Ico:8>> || [Id, Ico] <- NpcList]),
%%    Data = <<NL:16, Bin/binary>>,
%%    {ok, pt:pack(12020, Data)};
%%
%%%% 当前罪恶值
%%write(12021, [Id, Evil]) ->
%%    {ok, pt:pack(12021, <<Id:32, Evil:32>>)};
%%
%%%% 返回当前场景的分线数
%%write(12022,[SceneId,CopySceneIdList]) ->
%%	NL = length(CopySceneIdList),
%%	Bin = tool:to_binary([<<SId:32>> || SId <- CopySceneIdList]),
%%	Data = <<SceneId:32,NL:16,Bin/binary>>,
%%	{ok,pt:pack(12022,Data)};
%%
%%%%巨兽跟随
%%write(12031,[PetStatus,Id,PetId,PetName,PetColor,PetType,PetGrow]) ->
%%	Name = tool:to_binary(PetName),
%%	Len = byte_size(Name),
%%	{ok,pt:pack(12031,<<PetStatus:16,Id:32,PetId:32,Len:16,Name/binary,PetColor:16,PetType:32,PetGrow:16>>)};
%%
%%%%装备效果改变场景广播
%%write(12032,[PlayerId,Type,Value]) ->
%%	{ok,pt:pack(12032,<<PlayerId:32,Type:8,Value:16>>)};
%%
%%%%接镖或者交镖
%%write(12041,[PsId,Carry_Mark]) ->
%%	{ok,pt:pack(12041,<<PsId:32,Carry_Mark:8>>)};
%%
%%%%护送NPC
%%write(12051,[PsId,ConVoy_Npc,Name]) ->
%%	Name1 = tool:to_binary(Name),
%%	NameLen = byte_size(Name1),
%%	{ok,pt:pack(12051,<<PsId:32,ConVoy_Npc:32,NameLen:16,Name1/binary>>)};
%%
%%%% 场景烟花广播
%%write(12061,[PlayerId,Goods_id]) ->
%%	{ok,pt:pack(12061,<<PlayerId:32,Goods_id:32>>)};
%%
%%
%%%% 打包场景相邻关系数据
%%write(12080, [L]) ->
%%    Len = length(L),
%%    Bin = pack_scene_border(L, []),
%%    {ok, pt:pack(12080, <<Len:16, Bin/binary>>)};
%%
%%%% 更新怪物血量
%%write(12081, [Id, Hp]) ->
%% 	{ok, pt:pack(12081, <<Id:32, Hp:32>>)};
%%
%%%% 更新怪物血量
%%write(12082, [Id, Hp]) ->
%%	{ok, pt:pack(12082, <<Id:32, Hp:32>>)};
%%
%%%% 更新怪物属性
%%write(12083, [Id, Hp, HpLim, Name]) ->
%%%% ?DEBUG("12083___________________~p/",[[Hp, HpLim]]),
%%	NewName = tool:to_binary(Name),
%%	NameLen = byte_size(Name),
%%  	{ok, pt:pack(12083, <<Id:32, Hp:32, HpLim:32, NameLen:16, NewName/binary>>)};
%%     
%%%%修炼信息广播
%%write(12090, [Pid, Sta]) ->
%%    {ok, pt:pack(12090, <<Pid:32, Sta:8>>)};
%%
%%%% 场景瞬移
%%write(12110, [PlayerId, X, Y]) ->
%%	{ok, pt:pack(12110, <<PlayerId:32, X:8, Y:8>>)};
%%
%%%%获取副本次数
%%write(12100,TimesList)->
%%	TBin = pack_times_list(TimesList),
%%    Data = << TBin/binary>>,
%%    {ok, pt:pack(12100, Data)};
%%
%%%% 场景广播 某人的 某个属性
%%write(12042, [PlayerId, AttrList]) ->
%%	Len = length(AttrList),
%%	F = fun({AttrType, AttrVal}) ->
%%				<<AttrType:32, AttrVal:32>>
%%		end,
%%	LB = tool:to_binary(lists:map(F, AttrList)),
%%    {ok, pt:pack(12042, <<PlayerId:32, Len:16 ,LB/binary>>)};
%%
%%%%魅力称号变换
%%write(12043,[PlayerId,TitleId]) ->
%%	{ok,pt:pack(12043,<<PlayerId:32,TitleId:32>>)};
%%
write(Cmd, _R) ->
	?DEBUG("-------------------------ERR:~p~n",[_R]),
	?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
	{ok, pt:pack(0, <<>>)}.


pack_player(Player) ->
	if
		is_record(Player,player) ->
			NewPlayer = player ;
		true ->
			NewPlayer = #player{} 
	end ,
	PosX = NewPlayer#player.x ,
	PosY = NewPlayer#player.y ,
	UId =  NewPlayer#player.id ,
	UId =  NewPlayer#player.id ,
	{NmLen,NmBin} = tool:pack_string(NewPlayer#player.nick) ,
	Stts = NewPlayer#player.status ,
	Sex = NewPlayer#player.gender ,
	Crr = NewPlayer#player.career ,
	<<PosX:16,PosY:16,UId:64,NmLen:16,NmBin/binary,Stts:8,Sex:8,Crr:8>> .

%%     int:8 	X坐标
%%     int:8 	Y坐标
%%     int:32 	玩家ID
%%     string 	名字
%%     int:8  	状态: 	0正常、1禁止、2战斗中、3死亡、4挂机、5打坐
%%     int:16 	形象
%% 	int:8 	性别（增加）
%% 	int:8 	职业（增加）
	%%
%%%%打包副本次数列表
%%pack_times_list([]) -> <<0:16>>;
%%pack_times_list(TimesList) ->
%%    Len = length(TimesList),
%%    Bin = tool:to_binary([pack_times(X) || X <- TimesList]),
%%    <<Len:16, Bin/binary>>.
%%pack_times({SceneId,NowTimes,LimitTimes})->
%%	<<SceneId:32,NowTimes:16,LimitTimes:16>>.
%%
%%%% 打包元素列表
%%%% pack_elem_list([]) ->
%%%%     <<0:16, <<>>/binary>>;
%%%% pack_elem_list(Elem) ->
%%%%     Rlen = length(Elem),
%%%%     F = fun([Sid, Name, X, Y]) ->
%%%%         Len = byte_size(Name),
%%%%         <<Sid:32, Len:16, Name/binary, X:8, Y:8>>
%%%%     end,
%%%%     RB = tool:to_binary([F(D) || D <- Elem]),
%%%%     <<Rlen:16, RB/binary>>.
%%
%%%% 打包单个角色
%%pack_role_info([X, Y, ID, Camp, Stts, Img, Nick, Spd, Mnt,  _MountStren, OutPetId, OutPetName, Sex, Career, TitleId, Un, MaskId, GhostLv]) ->
%%    Nick1 = tool:to_binary(Nick),
%%    Len = byte_size(Nick1),
%%	Un1 = tool:to_binary(Un),
%%	UnLen = byte_size(Un1),
%%%% 	io:format("~s pack_role_info1_____[~p]\n",[misc:time_format(now()), ID]),
%%%% 	MaskId = lib_goods_use:getMaskImgId(ID),
%%%% 	io:format("~s pack_role_info2___[~p]\n",[misc:time_format(now()), MaskId]),
%%%% 	{MountLen, Mount} =
%%%% 		case Mnt of
%%%% 			0 ->
%%%% 				case MaskId of
%%%% 					0 ->
%%%% 						{0, <<>>};
%%%% 					_ ->
%%%% 						{1, <<MaskId:16, 10000:16>>}
%%%% 				end;
%%%% 			_ ->
%%%% 				case MaskId of
%%%% 					0 ->
%%%% 						{1, <<Mnt:16, MountStren:16>>};
%%%% 					_ ->
%%%% 						{2, <<Mnt:16, MountStren:16, MaskId:16, 10000:16>>}
%%%% 				end
%%%% 		end,
%%	{OutPetLen, OutPet} =
%%		case OutPetId of
%%			0 ->
%%				{0, <<>>};
%%			_ ->
%%				LenPetName = byte_size(OutPetName),
%%				{1, <<OutPetId:16, LenPetName:16,OutPetName/binary>>}
%%		end,
%%	<<X:8, Y:8, ID:32, Camp:8, Stts:8, Img:16, 
%%	  Len:16, Nick1/binary, Spd:16, Sex:8, Career:8,
%%	  TitleId:32, UnLen:16, Un1/binary, 
%%	  Mnt:16, MaskId:16, GhostLv:16,
%%	  OutPetLen:16, OutPet/binary>>.
%%%%     <<X:8, Y:8, ID:32, Camp:8, Stts:8, Img:16, 
%%%% 	  Len:16, Nick1/binary, Spd:16, Sex:8, Career:8,
%%%% 	  TitleId:32, UnLen:16, Un1/binary, 
%%%% 	  MountLen:16, Mount/binary,
%%%% 	  OutPetLen:16, OutPet/binary>>.
%%
%%
%%%% 打包角色列表
%%pack_role_list([]) ->  <<0:16, <<>>/binary>>;
%%pack_role_list(User) -> 
%%    Rlen = length(User),
%%%% io:format("-------------------------Player:~p~n",[Rlen]),
%%    F = fun([ID, Nick, X, Y, 
%%			 _Hp, _MxHp, _Eng, _Lv, 
%%			 Career, Spd, Sex, OutPetId, 
%%			 OutPetName, _Pid, Camp, Un, 
%%			 Stts, _Stren, _SuitID, _Vip, 
%%			 Img, Mnt, MountStren, TitleId, MaskId, GhostLv]) ->
%%%% 				io:format("-------------------------Player:~p~n",[{OutPetId, OutPetName}]),
%%		pack_role_info([X, Y, ID, Camp, Stts, Img, Nick, Spd, Mnt, MountStren, OutPetId, OutPetName, Sex, Career,TitleId, Un, MaskId,GhostLv])
%%    end,
%%    RB = tool:to_binary([F(D) || D <- User]),
%%    <<Rlen:16, RB/binary>>.
%%
%%%% 打包NPC列表
%%pack_npc_list([]) ->
%%    <<0:16, <<>>/binary>>;
%%pack_npc_list(Npc) ->
%%    Rlen = length(Npc),
%%%% 	io:format("-------------------------Player:~p~n",[Rlen]),
%%    F = fun([Id, _Nid, Name, X, _Y, _Icon, _NpcType]) ->
%%				Name1 = tool:to_binary(Name),
%%				NameLen = byte_size(Name1),
%%%% 				TypeName = get_npc_typename(NpcType),
%%%% 				TypeNameBin = tool:to_binary(TypeName),
%%%% 				TypeNameLen = byte_size(TypeNameBin),
%%				<<Id:32, X:8, NameLen:16, Name1/binary>>
%%		end,
%%    RB = tool:to_binary([F(D) || D <- Npc]),
%%    <<Rlen:16, RB/binary>>.
%%
%%%% 打包场景相邻关系数据
%%pack_scene_border([], Result) ->
%%    tool:to_binary(Result);
%%pack_scene_border([{Id, Border} | T], Result) ->
%%    L = length(Border),
%%    B = tool:to_binary([<<X:32>> || X <- Border]),
%%    Bin = <<Id:32, L:16, B/binary>>,
%%    pack_scene_border(T, [Bin | Result]).
%%
%%%% 打包元素列表
%%pack_leave_list([]) ->
%%    <<0:16, <<>>/binary>>;
%%pack_leave_list(List) ->
%%    Rlen = length(List),
%%    RB = tool:to_binary([<<Id:32>> || Id <- List]),
%%    <<Rlen:16, RB/binary>>.
%%
%%trans_to_12003(Status) ->
%%%% 	case get(player_mnt_sts) of
%%%% 		{1, MntIconId} ->   %%有坐骑，将坐骑ID转换为坐骑形象ID
%%%% 			io:format("~s trans_to_12003 -1----[~p]\n",[misc:time_format(now()), MntIconId]),
%%%% 			Mnt = MntIconId;
%%%% 		undefined ->
%%%% 			io:format("~s trans_to_12003 -2----[~p]\n",[misc:time_format(now()), Status#player.mnt]),
%%%% 			Mnt = Status#player.mnt;
%%%% 		_R ->
%%%% 			io:format("~s trans_to_12003 -3-----[~p]\n",[misc:time_format(now()), _R]),
%%%% 			Mnt = 0
%%%% 	end,
%%%% 	io:format("~s trans_to_12003 ----[~p]\n",[misc:time_format(now()), Status#player.other#player_other.mnt_sts]),
%%	[
%%	 	Status#player.x,
%%	 	Status#player.y,
%%    	Status#player.id,
%%%% 	 	Status#player.camp,
%%%%         Status#player.stts,
%%%% 		Status#player.img,
%%%%     	Status#player.nick,
%%%% 		Status#player.spd,
%%%% 		Status#player.mnt_sts,
%%%% %% 		Status#player.mnt,
%%%% 		Status#player.other#player_other.mount_stren,
%%%% 		Status#player.other#player_other.out_pet_type_id,
%%%% 		Status#player.other#player_other.out_pet_name,
%%%% 		Status#player.sex,
%%%% 		Status#player.crr,
%%%% 		Status#player.tid,
%%%% 		Status#player.un,
%%		Status#player.other#player_other.maskId,
%%		Status#player.other#player_other.ghost_fllw
%%	].
%%
%%
%%%% %%  复制生生成 若干个 角色(用于大数据包测试)
%%%% make_many_user([]) -> [];
%%%% make_many_user(User) ->
%%%% 	[Auser|_] = User,
%%%% 	[Id, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Speed, EquipCurrent,
%%%% 			 Sex, Out_pet, _Pid, Leader, _Pid_team, Realm, GuildName, Evil, Status,Carry_Mark,ConVoy_Npc] = Auser,
%%%% 	lists:map(fun(Id0) ->
%%%% 			[Id0, Nick, X, Y, Hp, Hp_lim, Mp, Mp_lim, Lv, Career, Speed, EquipCurrent,
%%%% 			 Sex, Out_pet, _Pid, Leader, _Pid_team, Realm, GuildName, Evil, Status,Carry_Mark,ConVoy_Npc]					
%%%% 			  end,
%%%% 		lists:seq(1, 300)). %% 566 错误
	
