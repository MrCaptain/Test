%%%--------------------------------------
%%% @Module  : db_agent_player
%%% @Author  : water
%%% @Created : 2013.01.15
%%% @Description: 玩家数据处理模块
%%%--------------------------------------
-module(db_agent_player).
-include("common.hrl").
-include("record.hrl").
-compile(export_all).

%% 创建角色增加插入默认字段
create_role(AccId, AccName, Career, Sex, Name, RegTime, LoginTime, SceneId, X, Y,
            HitPointMax, MagicMax, AngerMax, Attack,  Defense, FAttack, MAttack, DAttack, FDefense, MDefense, DDefense, Speed, SpdAtt) ->    
    Player = #player{    
      account_id = AccId,                     %% 平台账号ID    
      account_name = AccName,                 %% 平台账号    
      nick = Name,                            %% 玩家名    
      type = 1,                               %% 玩家身份 1普通玩家 2指导员3gm    
      reg_time = RegTime,                     %% 注册时间    
      last_login_time = LoginTime,            %% 最后登陆时间    
      last_login_ip = "",                     %% 最后登陆IP    
      status = 0,                             %% 玩家状态（0正常、1禁止、2战斗中、3死亡、4挂机、5打坐）    
      gender = Sex,                           %% 性别 1男 2女    
      career = Career,                        %% 职业    
      gold = 0,                               %% 元宝    
      bgold = 0,                              %% 绑定元宝    
      coin = 0,                               %% 铜钱    
      bcoin = 0,                              %% 绑定铜钱    
      scene = SceneId,                        %% 场景ID    
      x = X,                                  %% X坐标    
      y = Y,                                  %% Y坐标    
      level = 1,                              %% 等级    
      exp = 0,                                %% 经验    
      hit_point = HitPointMax,                %% 生命    
      hit_point_max = HitPointMax,            %% 生命上限    
      magic = MagicMax,                       %% 法力值    
      magic_max = MagicMax,                   %% 法力值上限    
      anger = AngerMax,                       %% 怒气值    
      anger_max = AngerMax,                   %% 怒气值上限    
      attack = Attack,                        %% 普通攻击力    
      defense = Defense,                      %% 普通防御力    
      abs_damage = 0,                         %% 绝对伤害值    
      fattack = FAttack,                      %% 仙攻值    
      mattack = MAttack,                      %% 魔攻值    
      dattack = DAttack,                      %% 妖攻值    
      fdefense = FDefense,                    %% 仙防值    
      mdefense = MDefense,                    %% 魔防值    
      ddefense = DDefense,                    %% 妖防值    
      speed = Speed,                          %% 移动速度    
      attack_speed = SpdAtt,                  %% 攻击速度    
      hit = 0,                                %% 命中等级    
      dodge = 0,                              %% 闪避等级    
      crit = 0,                               %% 暴击等级    
      tough = 0,                              %% 坚韧等级    
      hit_per = 0,                            %% 命中率    
      dodge_per = 0,                          %% 闪避率    
      crit_per = 0,                           %% 暴击率    
      tough_per = 0,                          %% 坚韧率    
      frozen_resis_per = 0,                   %% 冰冻抗性率    
      weak_resis_per = 0,                     %% 虚弱抗性率    
      flaw_resis_per = 0,                     %% 破绽抗性率    
      poison_resis_per = 0,                   %% 中毒抗性率    
      online_flag = 0,                        %% 在线标记，0不在线 1在线    
      other = 0                               %% 其他信息    
    },
    ValueList = lists:nthtail(2, tuple_to_list(Player)),
    [id | FieldList] = record_info(fields, player),
    Ret = ?DB_MODULE:insert(player, FieldList, ValueList),
    Ret.

%% 通过角色ID取得帐号ID
get_accountid_by_id(PlayerId) ->
    ?DB_MODULE:select_one(player, "account_id", [{id, PlayerId}], [], [1]).

%% 通过帐号ID取得角色ID
get_playerid_by_accountid(AccId) ->
    ?DB_MODULE:select_one(player, "id", [{account_id, AccId}], [], [1]).

%% 通过角色ID取得帐号信息
get_info_by_id(PlayerId) ->
    ?DB_MODULE:select_row(player, "*", [{id, PlayerId}], [], [1]).

%% 通过角色名取得角色信息
get_info_by_name(Name) ->
    ?DB_MODULE:select_row(player, "*", [{nick, Name}], [], [1]).

%% 通过角色ID取得帐号相关于私聊的信息
get_chat_info_by_id(PlayerId) ->
    ?DB_MODULE:select_row(player, "nick, gender, career, level", [{id, PlayerId}], [], [1]).

%% 获取角色money信息
get_player_money(PlayerId) ->
    ?DB_MODULE:select_row(player,"gold, bgold, coin, bcoin",[{id,PlayerId}],[],[1]).

%% 根据台用户ID，平台用户账号
%% 返回角色ID，状态，等级，职业，性别，名字
%% 取得指定帐号名称的角色列表 
get_role_list(Accid, Accname) ->
    Ret = ?DB_MODULE:select_row(player, "id, status, level, career, gender, nick", [{account_id, Accid}, {account_name, Accname}], [],[1]),
    case Ret of 
        [] -> [];
        _  -> [Ret]
    end.

%% 更新账号最近登录时间和IP
update_last_login(Time, LastLoginIP, PlayerId) ->
    ?DB_MODULE:update(player,[{last_login_time, Time}, {online_flag, 1}, {last_login_ip,LastLoginIP}],[{id, PlayerId}]).

%%更新角色在线状态
update_online_flag(PlayerId, Online_flag) ->
    ?DB_MODULE:update(player,[{online_flag, Online_flag}],[{id, PlayerId}]).

%% 设置角色状态(0-正常，1-禁止)
set_player_status(Id, Status) ->
    ?DB_MODULE:update(player, [{status, Status}], [{id, Id}]).

%%获取玩家最近登录的时间
get_player_last_login_time(PlayerId) ->
    ?DB_MODULE:select_one(player, "last_login_time", [{id, PlayerId}], [], [1]).

%% 根据角色名称查找ID
get_role_id_by_name(Name) ->
    ?DB_MODULE:select_one(player, "id", [{nick, Name}], [], [1]).

get_role_name_by_id(Id)->
    ?DB_MODULE:select_one(player, "nick", [{id, Id}], [], [1]).
    
%% 检测指定名称的角色是否已存在
is_accname_exists(AccName) ->
    ?DB_MODULE:select_one(player, "id", [{account_name, AccName}], [], [1]).

%% 更改玩家经验、血、魔等数值
update_player_exp_data(ValueList, WhereList) ->
    ?DB_MODULE:update(player, ValueList, WhereList).

%% 是否创建角色
is_create(Accname)->
    ?DB_MODULE:select_all(player, "id", [{account_name, Accname}], [], [1]).

%%保存玩家基本信息
save_player_table(PlayerId, FieldList, ValueList)->
    ?DB_MODULE:update(player, FieldList, ValueList, "id", PlayerId).

%% 删除角色
delete_role(PlayerId, Accid) ->
    ?DB_MODULE:delete(player, [{id, PlayerId}, {account_id, Accid}]).

