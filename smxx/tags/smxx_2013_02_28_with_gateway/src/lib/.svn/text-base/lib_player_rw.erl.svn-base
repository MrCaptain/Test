%%%------------------------------------------------	
%%% File    : lib_player_rw.erl	
%%% Author  : csj	
%%% Created : 2013-02-28 16:54:11	
%%% Description: 从record生成的代码	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------		
 	
-module(lib_player_rw).	
 	
%%  	
%% Include files  	
-include("common.hrl"). 	
-include("record.hrl"). 	
  	
%% 	
%% Exported Functions 	
%% 	
-compile(export_all). 	
  	
%%获取用户信息(按[字段1,字段2,...])	
%% handle_call({'PLAYER',  [x ,y]}, _from, Status)	
get_player_info_fields(Player, List) ->	
	lists:map(fun(T) ->	
			case T of	
				id -> Player#player.id;	
				account_id -> Player#player.account_id;	
				account_name -> Player#player.account_name;	
				nick -> Player#player.nick;	
				type -> Player#player.type;	
				icon -> Player#player.icon;	
				reg_time -> Player#player.reg_time;	
				last_login_time -> Player#player.last_login_time;	
				last_login_ip -> Player#player.last_login_ip;	
				status -> Player#player.status;	
				gender -> Player#player.gender;	
				gold -> Player#player.gold;	
				bgold -> Player#player.bgold;	
				coin -> Player#player.coin;	
				bcoin -> Player#player.bcoin;	
				vip -> Player#player.vip;	
				vip_expire_time -> Player#player.vip_expire_time;	
				scene -> Player#player.scene;	
				cell_num -> Player#player.cell_num;	
				level -> Player#player.level;	
				exp -> Player#player.exp;	
				online_flag -> Player#player.online_flag;	
				resolut_x -> Player#player.resolut_x;	
				resolut_y -> Player#player.resolut_y;	
				liveness -> Player#player.liveness;	
				camp -> Player#player.camp;	
				lilian -> Player#player.lilian;	
				mount_flag -> Player#player.mount_flag;	
				switch -> Player#player.switch;	
				guild_id -> Player#player.guild_id;	
				guild_name -> Player#player.guild_name;	
				guild_post -> Player#player.guild_post;	
				battle_attr -> Player#player.battle_attr;	
				other -> Player#player.other;	
				x -> Player#player.battle_attr#battle_attr.x;	
				y -> Player#player.battle_attr#battle_attr.y;	
				career -> Player#player.battle_attr#battle_attr.career;	
				skill_cd_all -> Player#player.battle_attr#battle_attr.skill_cd_all;	
				skill_cd_list -> Player#player.battle_attr#battle_attr.skill_cd_list;	
				skill_buff -> Player#player.battle_attr#battle_attr.skill_buff;	
				buff1 -> Player#player.battle_attr#battle_attr.buff1;	
				buff2 -> Player#player.battle_attr#battle_attr.buff2;	
				sing_expire -> Player#player.battle_attr#battle_attr.sing_expire;	
				use_combopoint -> Player#player.battle_attr#battle_attr.use_combopoint;	
				combopoint_max -> Player#player.battle_attr#battle_attr.combopoint_max;	
				combopoint -> Player#player.battle_attr#battle_attr.combopoint;	
				hit_point -> Player#player.battle_attr#battle_attr.hit_point;	
				hit_point_max -> Player#player.battle_attr#battle_attr.hit_point_max;	
				magic -> Player#player.battle_attr#battle_attr.magic;	
				magic_max -> Player#player.battle_attr#battle_attr.magic_max;	
				anger -> Player#player.battle_attr#battle_attr.anger;	
				anger_max -> Player#player.battle_attr#battle_attr.anger_max;	
				attack -> Player#player.battle_attr#battle_attr.attack;	
				attack_ratio -> Player#player.battle_attr#battle_attr.attack_ratio;	
				defense -> Player#player.battle_attr#battle_attr.defense;	
				defense_ratio -> Player#player.battle_attr#battle_attr.defense_ratio;	
				abs_damage -> Player#player.battle_attr#battle_attr.abs_damage;	
				fattack -> Player#player.battle_attr#battle_attr.fattack;	
				fattack_ratio -> Player#player.battle_attr#battle_attr.fattack_ratio;	
				mattack -> Player#player.battle_attr#battle_attr.mattack;	
				mattack_ratio -> Player#player.battle_attr#battle_attr.mattack_ratio;	
				dattack -> Player#player.battle_attr#battle_attr.dattack;	
				dattack_ratio -> Player#player.battle_attr#battle_attr.dattack_ratio;	
				fdefense -> Player#player.battle_attr#battle_attr.fdefense;	
				fdefense_ratio -> Player#player.battle_attr#battle_attr.fdefense_ratio;	
				mdefense -> Player#player.battle_attr#battle_attr.mdefense;	
				mdefense_ratio -> Player#player.battle_attr#battle_attr.mdefense_ratio;	
				ddefense -> Player#player.battle_attr#battle_attr.ddefense;	
				ddefense_ratio -> Player#player.battle_attr#battle_attr.ddefense_ratio;	
				speed -> Player#player.battle_attr#battle_attr.speed;	
				attack_speed -> Player#player.battle_attr#battle_attr.attack_speed;	
				hit_ratio -> Player#player.battle_attr#battle_attr.hit_ratio;	
				dodge_ratio -> Player#player.battle_attr#battle_attr.dodge_ratio;	
				crit_ratio -> Player#player.battle_attr#battle_attr.crit_ratio;	
				tough_ratio -> Player#player.battle_attr#battle_attr.tough_ratio;	
				frozen_resis_ratio -> Player#player.battle_attr#battle_attr.frozen_resis_ratio;	
				weak_resis_ratio -> Player#player.battle_attr#battle_attr.weak_resis_ratio;	
				flaw_resis_ratio -> Player#player.battle_attr#battle_attr.flaw_resis_ratio;	
				poison_resis_ratio -> Player#player.battle_attr#battle_attr.poison_resis_ratio;	
				avoid_attack_ratio -> Player#player.battle_attr#battle_attr.avoid_attack_ratio;	
				avoid_fattack_ratio -> Player#player.battle_attr#battle_attr.avoid_fattack_ratio;	
				avoid_mattack_ratio -> Player#player.battle_attr#battle_attr.avoid_mattack_ratio;	
				avoid_dattack_ratio -> Player#player.battle_attr#battle_attr.avoid_dattack_ratio;	
				avoid_crit_attack_ratio -> Player#player.battle_attr#battle_attr.avoid_crit_attack_ratio;	
				avoid_crit_fattack_ratio -> Player#player.battle_attr#battle_attr.avoid_crit_fattack_ratio;	
				avoid_crit_mattack_ratio -> Player#player.battle_attr#battle_attr.avoid_crit_mattack_ratio;	
				avoid_crit_dattack_ratio -> Player#player.battle_attr#battle_attr.avoid_crit_dattack_ratio;	
				ignore_defense -> Player#player.battle_attr#battle_attr.ignore_defense;	
				ignore_fdefense -> Player#player.battle_attr#battle_attr.ignore_fdefense;	
				ignore_mdefense -> Player#player.battle_attr#battle_attr.ignore_mdefense;	
				ignore_ddefense -> Player#player.battle_attr#battle_attr.ignore_ddefense;	
				skill_list -> Player#player.other#player_other.skill_list;	
				socket -> Player#player.other#player_other.socket;	
				socket2 -> Player#player.other#player_other.socket2;	
				socket3 -> Player#player.other#player_other.socket3;	
				pid_socket -> Player#player.other#player_other.pid_socket;	
				pid -> Player#player.other#player_other.pid;	
				pid_goods -> Player#player.other#player_other.pid_goods;	
				pid_send -> Player#player.other#player_other.pid_send;	
				pid_send2 -> Player#player.other#player_other.pid_send2;	
				pid_send3 -> Player#player.other#player_other.pid_send3;	
				pid_battle -> Player#player.other#player_other.pid_battle;	
				pid_scene -> Player#player.other#player_other.pid_scene;	
				pid_dungeon -> Player#player.other#player_other.pid_dungeon;	
				pid_task -> Player#player.other#player_other.pid_task;	
				node -> Player#player.other#player_other.node;	
				blacklist -> Player#player.other#player_other.blacklist;	
				pk_mode -> Player#player.other#player_other.pk_mode;	
				goods_ets_id -> Player#player.other#player_other.goods_ets_id;	
				equip_current -> Player#player.other#player_other.equip_current;	
				weapon_strenLv -> Player#player.other#player_other.weapon_strenLv;	
				armor_strenLv -> Player#player.other#player_other.armor_strenLv;	
				fashion_strenLv -> Player#player.other#player_other.fashion_strenLv;	
				wapon_accstrenLv -> Player#player.other#player_other.wapon_accstrenLv;	
				wing_strenLv -> Player#player.other#player_other.wing_strenLv;	
				_ -> undefined	
			end	
		end, List).	
 	
%%设置用户信息(按[{字段1,值1},{字段2,值2, add},{字段3,值3, sub}...])	
%% handle_cast({'SET_PLAYER',[{x, 10} ,{y, 20, add},  ,{hp, 20, sub}]}, Status)	
set_player_info_fields(Player, []) ->	
	Player;	
set_player_info_fields(Player, [H|T]) ->	
	NewPlayer =	
		case H of	
				{id, Val, add} -> Player#player{id=Player#player.id + Val};	
				{id, Val, sub} -> Player#player{id=Player#player.id - Val};	
				{id, Val, _} -> Player#player{id= Val};	
				{id, Val} -> Player#player{id= Val};	
				{account_id, Val, add} -> Player#player{account_id=Player#player.account_id + Val};	
				{account_id, Val, sub} -> Player#player{account_id=Player#player.account_id - Val};	
				{account_id, Val, _} -> Player#player{account_id= Val};	
				{account_id, Val} -> Player#player{account_id= Val};	
				{account_name, Val, add} -> Player#player{account_name=Player#player.account_name + Val};	
				{account_name, Val, sub} -> Player#player{account_name=Player#player.account_name - Val};	
				{account_name, Val, _} -> Player#player{account_name= Val};	
				{account_name, Val} -> Player#player{account_name= Val};	
				{nick, Val, add} -> Player#player{nick=Player#player.nick + Val};	
				{nick, Val, sub} -> Player#player{nick=Player#player.nick - Val};	
				{nick, Val, _} -> Player#player{nick= Val};	
				{nick, Val} -> Player#player{nick= Val};	
				{type, Val, add} -> Player#player{type=Player#player.type + Val};	
				{type, Val, sub} -> Player#player{type=Player#player.type - Val};	
				{type, Val, _} -> Player#player{type= Val};	
				{type, Val} -> Player#player{type= Val};	
				{icon, Val, add} -> Player#player{icon=Player#player.icon + Val};	
				{icon, Val, sub} -> Player#player{icon=Player#player.icon - Val};	
				{icon, Val, _} -> Player#player{icon= Val};	
				{icon, Val} -> Player#player{icon= Val};	
				{reg_time, Val, add} -> Player#player{reg_time=Player#player.reg_time + Val};	
				{reg_time, Val, sub} -> Player#player{reg_time=Player#player.reg_time - Val};	
				{reg_time, Val, _} -> Player#player{reg_time= Val};	
				{reg_time, Val} -> Player#player{reg_time= Val};	
				{last_login_time, Val, add} -> Player#player{last_login_time=Player#player.last_login_time + Val};	
				{last_login_time, Val, sub} -> Player#player{last_login_time=Player#player.last_login_time - Val};	
				{last_login_time, Val, _} -> Player#player{last_login_time= Val};	
				{last_login_time, Val} -> Player#player{last_login_time= Val};	
				{last_login_ip, Val, add} -> Player#player{last_login_ip=Player#player.last_login_ip + Val};	
				{last_login_ip, Val, sub} -> Player#player{last_login_ip=Player#player.last_login_ip - Val};	
				{last_login_ip, Val, _} -> Player#player{last_login_ip= Val};	
				{last_login_ip, Val} -> Player#player{last_login_ip= Val};	
				{status, Val, add} -> Player#player{status=Player#player.status + Val};	
				{status, Val, sub} -> Player#player{status=Player#player.status - Val};	
				{status, Val, _} -> Player#player{status= Val};	
				{status, Val} -> Player#player{status= Val};	
				{gender, Val, add} -> Player#player{gender=Player#player.gender + Val};	
				{gender, Val, sub} -> Player#player{gender=Player#player.gender - Val};	
				{gender, Val, _} -> Player#player{gender= Val};	
				{gender, Val} -> Player#player{gender= Val};	
				{gold, Val, add} -> Player#player{gold=Player#player.gold + Val};	
				{gold, Val, sub} -> Player#player{gold=Player#player.gold - Val};	
				{gold, Val, _} -> Player#player{gold= Val};	
				{gold, Val} -> Player#player{gold= Val};	
				{bgold, Val, add} -> Player#player{bgold=Player#player.bgold + Val};	
				{bgold, Val, sub} -> Player#player{bgold=Player#player.bgold - Val};	
				{bgold, Val, _} -> Player#player{bgold= Val};	
				{bgold, Val} -> Player#player{bgold= Val};	
				{coin, Val, add} -> Player#player{coin=Player#player.coin + Val};	
				{coin, Val, sub} -> Player#player{coin=Player#player.coin - Val};	
				{coin, Val, _} -> Player#player{coin= Val};	
				{coin, Val} -> Player#player{coin= Val};	
				{bcoin, Val, add} -> Player#player{bcoin=Player#player.bcoin + Val};	
				{bcoin, Val, sub} -> Player#player{bcoin=Player#player.bcoin - Val};	
				{bcoin, Val, _} -> Player#player{bcoin= Val};	
				{bcoin, Val} -> Player#player{bcoin= Val};	
				{vip, Val, add} -> Player#player{vip=Player#player.vip + Val};	
				{vip, Val, sub} -> Player#player{vip=Player#player.vip - Val};	
				{vip, Val, _} -> Player#player{vip= Val};	
				{vip, Val} -> Player#player{vip= Val};	
				{vip_expire_time, Val, add} -> Player#player{vip_expire_time=Player#player.vip_expire_time + Val};	
				{vip_expire_time, Val, sub} -> Player#player{vip_expire_time=Player#player.vip_expire_time - Val};	
				{vip_expire_time, Val, _} -> Player#player{vip_expire_time= Val};	
				{vip_expire_time, Val} -> Player#player{vip_expire_time= Val};	
				{scene, Val, add} -> Player#player{scene=Player#player.scene + Val};	
				{scene, Val, sub} -> Player#player{scene=Player#player.scene - Val};	
				{scene, Val, _} -> Player#player{scene= Val};	
				{scene, Val} -> Player#player{scene= Val};	
				{cell_num, Val, add} -> Player#player{cell_num=Player#player.cell_num + Val};	
				{cell_num, Val, sub} -> Player#player{cell_num=Player#player.cell_num - Val};	
				{cell_num, Val, _} -> Player#player{cell_num= Val};	
				{cell_num, Val} -> Player#player{cell_num= Val};	
				{level, Val, add} -> Player#player{level=Player#player.level + Val};	
				{level, Val, sub} -> Player#player{level=Player#player.level - Val};	
				{level, Val, _} -> Player#player{level= Val};	
				{level, Val} -> Player#player{level= Val};	
				{exp, Val, add} -> Player#player{exp=Player#player.exp + Val};	
				{exp, Val, sub} -> Player#player{exp=Player#player.exp - Val};	
				{exp, Val, _} -> Player#player{exp= Val};	
				{exp, Val} -> Player#player{exp= Val};	
				{online_flag, Val, add} -> Player#player{online_flag=Player#player.online_flag + Val};	
				{online_flag, Val, sub} -> Player#player{online_flag=Player#player.online_flag - Val};	
				{online_flag, Val, _} -> Player#player{online_flag= Val};	
				{online_flag, Val} -> Player#player{online_flag= Val};	
				{resolut_x, Val, add} -> Player#player{resolut_x=Player#player.resolut_x + Val};	
				{resolut_x, Val, sub} -> Player#player{resolut_x=Player#player.resolut_x - Val};	
				{resolut_x, Val, _} -> Player#player{resolut_x= Val};	
				{resolut_x, Val} -> Player#player{resolut_x= Val};	
				{resolut_y, Val, add} -> Player#player{resolut_y=Player#player.resolut_y + Val};	
				{resolut_y, Val, sub} -> Player#player{resolut_y=Player#player.resolut_y - Val};	
				{resolut_y, Val, _} -> Player#player{resolut_y= Val};	
				{resolut_y, Val} -> Player#player{resolut_y= Val};	
				{liveness, Val, add} -> Player#player{liveness=Player#player.liveness + Val};	
				{liveness, Val, sub} -> Player#player{liveness=Player#player.liveness - Val};	
				{liveness, Val, _} -> Player#player{liveness= Val};	
				{liveness, Val} -> Player#player{liveness= Val};	
				{camp, Val, add} -> Player#player{camp=Player#player.camp + Val};	
				{camp, Val, sub} -> Player#player{camp=Player#player.camp - Val};	
				{camp, Val, _} -> Player#player{camp= Val};	
				{camp, Val} -> Player#player{camp= Val};	
				{lilian, Val, add} -> Player#player{lilian=Player#player.lilian + Val};	
				{lilian, Val, sub} -> Player#player{lilian=Player#player.lilian - Val};	
				{lilian, Val, _} -> Player#player{lilian= Val};	
				{lilian, Val} -> Player#player{lilian= Val};	
				{mount_flag, Val, add} -> Player#player{mount_flag=Player#player.mount_flag + Val};	
				{mount_flag, Val, sub} -> Player#player{mount_flag=Player#player.mount_flag - Val};	
				{mount_flag, Val, _} -> Player#player{mount_flag= Val};	
				{mount_flag, Val} -> Player#player{mount_flag= Val};	
				{switch, Val, add} -> Player#player{switch=Player#player.switch + Val};	
				{switch, Val, sub} -> Player#player{switch=Player#player.switch - Val};	
				{switch, Val, _} -> Player#player{switch= Val};	
				{switch, Val} -> Player#player{switch= Val};	
				{guild_id, Val, add} -> Player#player{guild_id=Player#player.guild_id + Val};	
				{guild_id, Val, sub} -> Player#player{guild_id=Player#player.guild_id - Val};	
				{guild_id, Val, _} -> Player#player{guild_id= Val};	
				{guild_id, Val} -> Player#player{guild_id= Val};	
				{guild_name, Val, add} -> Player#player{guild_name=Player#player.guild_name + Val};	
				{guild_name, Val, sub} -> Player#player{guild_name=Player#player.guild_name - Val};	
				{guild_name, Val, _} -> Player#player{guild_name= Val};	
				{guild_name, Val} -> Player#player{guild_name= Val};	
				{guild_post, Val, add} -> Player#player{guild_post=Player#player.guild_post + Val};	
				{guild_post, Val, sub} -> Player#player{guild_post=Player#player.guild_post - Val};	
				{guild_post, Val, _} -> Player#player{guild_post= Val};	
				{guild_post, Val} -> Player#player{guild_post= Val};	
				{skill_list, Val, add} -> Player#player{other=Player#player.other#player_other{skill_list = Player#player.other#player_other.skill_list + Val}};	
				{skill_list, Val, sub} -> Player#player{other=Player#player.other#player_other{skill_list = Player#player.other#player_other.skill_list - Val}};	
				{skill_list, Val, _} -> Player#player{other=Player#player.other#player_other{skill_list =  Val}};	
				{skill_list, Val} -> Player#player{other=Player#player.other#player_other{skill_list =  Val}};	
				{socket, Val, add} -> Player#player{other=Player#player.other#player_other{socket = Player#player.other#player_other.socket + Val}};	
				{socket, Val, sub} -> Player#player{other=Player#player.other#player_other{socket = Player#player.other#player_other.socket - Val}};	
				{socket, Val, _} -> Player#player{other=Player#player.other#player_other{socket =  Val}};	
				{socket, Val} -> Player#player{other=Player#player.other#player_other{socket =  Val}};	
				{socket2, Val, add} -> Player#player{other=Player#player.other#player_other{socket2 = Player#player.other#player_other.socket2 + Val}};	
				{socket2, Val, sub} -> Player#player{other=Player#player.other#player_other{socket2 = Player#player.other#player_other.socket2 - Val}};	
				{socket2, Val, _} -> Player#player{other=Player#player.other#player_other{socket2 =  Val}};	
				{socket2, Val} -> Player#player{other=Player#player.other#player_other{socket2 =  Val}};	
				{socket3, Val, add} -> Player#player{other=Player#player.other#player_other{socket3 = Player#player.other#player_other.socket3 + Val}};	
				{socket3, Val, sub} -> Player#player{other=Player#player.other#player_other{socket3 = Player#player.other#player_other.socket3 - Val}};	
				{socket3, Val, _} -> Player#player{other=Player#player.other#player_other{socket3 =  Val}};	
				{socket3, Val} -> Player#player{other=Player#player.other#player_other{socket3 =  Val}};	
				{pid_socket, Val, add} -> Player#player{other=Player#player.other#player_other{pid_socket = Player#player.other#player_other.pid_socket + Val}};	
				{pid_socket, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_socket = Player#player.other#player_other.pid_socket - Val}};	
				{pid_socket, Val, _} -> Player#player{other=Player#player.other#player_other{pid_socket =  Val}};	
				{pid_socket, Val} -> Player#player{other=Player#player.other#player_other{pid_socket =  Val}};	
				{pid, Val, add} -> Player#player{other=Player#player.other#player_other{pid = Player#player.other#player_other.pid + Val}};	
				{pid, Val, sub} -> Player#player{other=Player#player.other#player_other{pid = Player#player.other#player_other.pid - Val}};	
				{pid, Val, _} -> Player#player{other=Player#player.other#player_other{pid =  Val}};	
				{pid, Val} -> Player#player{other=Player#player.other#player_other{pid =  Val}};	
				{pid_goods, Val, add} -> Player#player{other=Player#player.other#player_other{pid_goods = Player#player.other#player_other.pid_goods + Val}};	
				{pid_goods, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_goods = Player#player.other#player_other.pid_goods - Val}};	
				{pid_goods, Val, _} -> Player#player{other=Player#player.other#player_other{pid_goods =  Val}};	
				{pid_goods, Val} -> Player#player{other=Player#player.other#player_other{pid_goods =  Val}};	
				{pid_send, Val, add} -> Player#player{other=Player#player.other#player_other{pid_send = Player#player.other#player_other.pid_send + Val}};	
				{pid_send, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_send = Player#player.other#player_other.pid_send - Val}};	
				{pid_send, Val, _} -> Player#player{other=Player#player.other#player_other{pid_send =  Val}};	
				{pid_send, Val} -> Player#player{other=Player#player.other#player_other{pid_send =  Val}};	
				{pid_send2, Val, add} -> Player#player{other=Player#player.other#player_other{pid_send2 = Player#player.other#player_other.pid_send2 + Val}};	
				{pid_send2, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_send2 = Player#player.other#player_other.pid_send2 - Val}};	
				{pid_send2, Val, _} -> Player#player{other=Player#player.other#player_other{pid_send2 =  Val}};	
				{pid_send2, Val} -> Player#player{other=Player#player.other#player_other{pid_send2 =  Val}};	
				{pid_send3, Val, add} -> Player#player{other=Player#player.other#player_other{pid_send3 = Player#player.other#player_other.pid_send3 + Val}};	
				{pid_send3, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_send3 = Player#player.other#player_other.pid_send3 - Val}};	
				{pid_send3, Val, _} -> Player#player{other=Player#player.other#player_other{pid_send3 =  Val}};	
				{pid_send3, Val} -> Player#player{other=Player#player.other#player_other{pid_send3 =  Val}};	
				{pid_battle, Val, add} -> Player#player{other=Player#player.other#player_other{pid_battle = Player#player.other#player_other.pid_battle + Val}};	
				{pid_battle, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_battle = Player#player.other#player_other.pid_battle - Val}};	
				{pid_battle, Val, _} -> Player#player{other=Player#player.other#player_other{pid_battle =  Val}};	
				{pid_battle, Val} -> Player#player{other=Player#player.other#player_other{pid_battle =  Val}};	
				{pid_scene, Val, add} -> Player#player{other=Player#player.other#player_other{pid_scene = Player#player.other#player_other.pid_scene + Val}};	
				{pid_scene, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_scene = Player#player.other#player_other.pid_scene - Val}};	
				{pid_scene, Val, _} -> Player#player{other=Player#player.other#player_other{pid_scene =  Val}};	
				{pid_scene, Val} -> Player#player{other=Player#player.other#player_other{pid_scene =  Val}};	
				{pid_dungeon, Val, add} -> Player#player{other=Player#player.other#player_other{pid_dungeon = Player#player.other#player_other.pid_dungeon + Val}};	
				{pid_dungeon, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_dungeon = Player#player.other#player_other.pid_dungeon - Val}};	
				{pid_dungeon, Val, _} -> Player#player{other=Player#player.other#player_other{pid_dungeon =  Val}};	
				{pid_dungeon, Val} -> Player#player{other=Player#player.other#player_other{pid_dungeon =  Val}};	
				{pid_task, Val, add} -> Player#player{other=Player#player.other#player_other{pid_task = Player#player.other#player_other.pid_task + Val}};	
				{pid_task, Val, sub} -> Player#player{other=Player#player.other#player_other{pid_task = Player#player.other#player_other.pid_task - Val}};	
				{pid_task, Val, _} -> Player#player{other=Player#player.other#player_other{pid_task =  Val}};	
				{pid_task, Val} -> Player#player{other=Player#player.other#player_other{pid_task =  Val}};	
				{node, Val, add} -> Player#player{other=Player#player.other#player_other{node = Player#player.other#player_other.node + Val}};	
				{node, Val, sub} -> Player#player{other=Player#player.other#player_other{node = Player#player.other#player_other.node - Val}};	
				{node, Val, _} -> Player#player{other=Player#player.other#player_other{node =  Val}};	
				{node, Val} -> Player#player{other=Player#player.other#player_other{node =  Val}};	
				{blacklist, Val, add} -> Player#player{other=Player#player.other#player_other{blacklist = Player#player.other#player_other.blacklist + Val}};	
				{blacklist, Val, sub} -> Player#player{other=Player#player.other#player_other{blacklist = Player#player.other#player_other.blacklist - Val}};	
				{blacklist, Val, _} -> Player#player{other=Player#player.other#player_other{blacklist =  Val}};	
				{blacklist, Val} -> Player#player{other=Player#player.other#player_other{blacklist =  Val}};	
				{pk_mode, Val, add} -> Player#player{other=Player#player.other#player_other{pk_mode = Player#player.other#player_other.pk_mode + Val}};	
				{pk_mode, Val, sub} -> Player#player{other=Player#player.other#player_other{pk_mode = Player#player.other#player_other.pk_mode - Val}};	
				{pk_mode, Val, _} -> Player#player{other=Player#player.other#player_other{pk_mode =  Val}};	
				{pk_mode, Val} -> Player#player{other=Player#player.other#player_other{pk_mode =  Val}};	
				{goods_ets_id, Val, add} -> Player#player{other=Player#player.other#player_other{goods_ets_id = Player#player.other#player_other.goods_ets_id + Val}};	
				{goods_ets_id, Val, sub} -> Player#player{other=Player#player.other#player_other{goods_ets_id = Player#player.other#player_other.goods_ets_id - Val}};	
				{goods_ets_id, Val, _} -> Player#player{other=Player#player.other#player_other{goods_ets_id =  Val}};	
				{goods_ets_id, Val} -> Player#player{other=Player#player.other#player_other{goods_ets_id =  Val}};	
				{equip_current, Val, add} -> Player#player{other=Player#player.other#player_other{equip_current = Player#player.other#player_other.equip_current + Val}};	
				{equip_current, Val, sub} -> Player#player{other=Player#player.other#player_other{equip_current = Player#player.other#player_other.equip_current - Val}};	
				{equip_current, Val, _} -> Player#player{other=Player#player.other#player_other{equip_current =  Val}};	
				{equip_current, Val} -> Player#player{other=Player#player.other#player_other{equip_current =  Val}};	
				{weapon_strenLv, Val, add} -> Player#player{other=Player#player.other#player_other{weapon_strenLv = Player#player.other#player_other.weapon_strenLv + Val}};	
				{weapon_strenLv, Val, sub} -> Player#player{other=Player#player.other#player_other{weapon_strenLv = Player#player.other#player_other.weapon_strenLv - Val}};	
				{weapon_strenLv, Val, _} -> Player#player{other=Player#player.other#player_other{weapon_strenLv =  Val}};	
				{weapon_strenLv, Val} -> Player#player{other=Player#player.other#player_other{weapon_strenLv =  Val}};	
				{armor_strenLv, Val, add} -> Player#player{other=Player#player.other#player_other{armor_strenLv = Player#player.other#player_other.armor_strenLv + Val}};	
				{armor_strenLv, Val, sub} -> Player#player{other=Player#player.other#player_other{armor_strenLv = Player#player.other#player_other.armor_strenLv - Val}};	
				{armor_strenLv, Val, _} -> Player#player{other=Player#player.other#player_other{armor_strenLv =  Val}};	
				{armor_strenLv, Val} -> Player#player{other=Player#player.other#player_other{armor_strenLv =  Val}};	
				{fashion_strenLv, Val, add} -> Player#player{other=Player#player.other#player_other{fashion_strenLv = Player#player.other#player_other.fashion_strenLv + Val}};	
				{fashion_strenLv, Val, sub} -> Player#player{other=Player#player.other#player_other{fashion_strenLv = Player#player.other#player_other.fashion_strenLv - Val}};	
				{fashion_strenLv, Val, _} -> Player#player{other=Player#player.other#player_other{fashion_strenLv =  Val}};	
				{fashion_strenLv, Val} -> Player#player{other=Player#player.other#player_other{fashion_strenLv =  Val}};	
				{wapon_accstrenLv, Val, add} -> Player#player{other=Player#player.other#player_other{wapon_accstrenLv = Player#player.other#player_other.wapon_accstrenLv + Val}};	
				{wapon_accstrenLv, Val, sub} -> Player#player{other=Player#player.other#player_other{wapon_accstrenLv = Player#player.other#player_other.wapon_accstrenLv - Val}};	
				{wapon_accstrenLv, Val, _} -> Player#player{other=Player#player.other#player_other{wapon_accstrenLv =  Val}};	
				{wapon_accstrenLv, Val} -> Player#player{other=Player#player.other#player_other{wapon_accstrenLv =  Val}};	
				{wing_strenLv, Val, add} -> Player#player{other=Player#player.other#player_other{wing_strenLv = Player#player.other#player_other.wing_strenLv + Val}};	
				{wing_strenLv, Val, sub} -> Player#player{other=Player#player.other#player_other{wing_strenLv = Player#player.other#player_other.wing_strenLv - Val}};	
				{wing_strenLv, Val, _} -> Player#player{other=Player#player.other#player_other{wing_strenLv =  Val}};	
				{wing_strenLv, Val} -> Player#player{other=Player#player.other#player_other{wing_strenLv =  Val}};	
				{x, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{x = Player#player.battle_attr#battle_attr.x + Val}};	
				{x, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{x = Player#player.battle_attr#battle_attr.x - Val}};	
				{x, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{x =  Val}};	
				{x, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{x =  Val}};	
				{y, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{y = Player#player.battle_attr#battle_attr.y + Val}};	
				{y, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{y = Player#player.battle_attr#battle_attr.y - Val}};	
				{y, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{y =  Val}};	
				{y, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{y =  Val}};	
				{career, Val, add} -> Player1 = Player#player{battle_attr=Player#player.battle_attr#battle_attr{career = Player#player.battle_attr#battle_attr.career + Val}},	
								Player1#player{career=Player1#player.career + Val};	
				{career, Val, sub} -> Player1 = Player#player{battle_attr=Player#player.battle_attr#battle_attr{career = Player#player.battle_attr#battle_attr.career - Val}},	
				                Player1#player{career=Player1#player.career - Val};	
				{career, Val, _} -> Player1 = Player#player{battle_attr=Player#player.battle_attr#battle_attr{career =  Val}},	
								Player1#player{career= Val};	
				{career, Val} -> Player1 = Player#player{battle_attr=Player#player.battle_attr#battle_attr{career =  Val}},	
								Player1#player{career= Val};	
				{skill_cd_all, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_all = Player#player.battle_attr#battle_attr.skill_cd_all + Val}};	
				{skill_cd_all, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_all = Player#player.battle_attr#battle_attr.skill_cd_all - Val}};	
				{skill_cd_all, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_all =  Val}};	
				{skill_cd_all, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_all =  Val}};	
				{skill_cd_list, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_list = Player#player.battle_attr#battle_attr.skill_cd_list + Val}};	
				{skill_cd_list, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_list = Player#player.battle_attr#battle_attr.skill_cd_list - Val}};	
				{skill_cd_list, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_list =  Val}};	
				{skill_cd_list, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_cd_list =  Val}};	
				{skill_buff, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_buff = Player#player.battle_attr#battle_attr.skill_buff + Val}};	
				{skill_buff, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_buff = Player#player.battle_attr#battle_attr.skill_buff - Val}};	
				{skill_buff, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_buff =  Val}};	
				{skill_buff, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{skill_buff =  Val}};	
				{buff1, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff1 = Player#player.battle_attr#battle_attr.buff1 + Val}};	
				{buff1, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff1 = Player#player.battle_attr#battle_attr.buff1 - Val}};	
				{buff1, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff1 =  Val}};	
				{buff1, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff1 =  Val}};	
				{buff2, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff2 = Player#player.battle_attr#battle_attr.buff2 + Val}};	
				{buff2, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff2 = Player#player.battle_attr#battle_attr.buff2 - Val}};	
				{buff2, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff2 =  Val}};	
				{buff2, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{buff2 =  Val}};	
				{sing_expire, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{sing_expire = Player#player.battle_attr#battle_attr.sing_expire + Val}};	
				{sing_expire, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{sing_expire = Player#player.battle_attr#battle_attr.sing_expire - Val}};	
				{sing_expire, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{sing_expire =  Val}};	
				{sing_expire, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{sing_expire =  Val}};	
				{use_combopoint, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{use_combopoint = Player#player.battle_attr#battle_attr.use_combopoint + Val}};	
				{use_combopoint, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{use_combopoint = Player#player.battle_attr#battle_attr.use_combopoint - Val}};	
				{use_combopoint, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{use_combopoint =  Val}};	
				{use_combopoint, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{use_combopoint =  Val}};	
				{combopoint_max, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint_max = Player#player.battle_attr#battle_attr.combopoint_max + Val}};	
				{combopoint_max, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint_max = Player#player.battle_attr#battle_attr.combopoint_max - Val}};	
				{combopoint_max, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint_max =  Val}};	
				{combopoint_max, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint_max =  Val}};	
				{combopoint, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint = Player#player.battle_attr#battle_attr.combopoint + Val}};	
				{combopoint, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint = Player#player.battle_attr#battle_attr.combopoint - Val}};	
				{combopoint, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint =  Val}};	
				{combopoint, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{combopoint =  Val}};	
				{hit_point, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point = Player#player.battle_attr#battle_attr.hit_point + Val}};	
				{hit_point, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point = Player#player.battle_attr#battle_attr.hit_point - Val}};	
				{hit_point, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point =  Val}};	
				{hit_point, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point =  Val}};	
				{hit_point_max, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point_max = Player#player.battle_attr#battle_attr.hit_point_max + Val}};	
				{hit_point_max, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point_max = Player#player.battle_attr#battle_attr.hit_point_max - Val}};	
				{hit_point_max, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point_max =  Val}};	
				{hit_point_max, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_point_max =  Val}};	
				{magic, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic = Player#player.battle_attr#battle_attr.magic + Val}};	
				{magic, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic = Player#player.battle_attr#battle_attr.magic - Val}};	
				{magic, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic =  Val}};	
				{magic, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic =  Val}};	
				{magic_max, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic_max = Player#player.battle_attr#battle_attr.magic_max + Val}};	
				{magic_max, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic_max = Player#player.battle_attr#battle_attr.magic_max - Val}};	
				{magic_max, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic_max =  Val}};	
				{magic_max, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{magic_max =  Val}};	
				{anger, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger = Player#player.battle_attr#battle_attr.anger + Val}};	
				{anger, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger = Player#player.battle_attr#battle_attr.anger - Val}};	
				{anger, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger =  Val}};	
				{anger, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger =  Val}};	
				{anger_max, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger_max = Player#player.battle_attr#battle_attr.anger_max + Val}};	
				{anger_max, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger_max = Player#player.battle_attr#battle_attr.anger_max - Val}};	
				{anger_max, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger_max =  Val}};	
				{anger_max, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{anger_max =  Val}};	
				{attack, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack = Player#player.battle_attr#battle_attr.attack + Val}};	
				{attack, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack = Player#player.battle_attr#battle_attr.attack - Val}};	
				{attack, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack =  Val}};	
				{attack, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack =  Val}};	
				{attack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_ratio = Player#player.battle_attr#battle_attr.attack_ratio + Val}};	
				{attack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_ratio = Player#player.battle_attr#battle_attr.attack_ratio - Val}};	
				{attack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_ratio =  Val}};	
				{attack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_ratio =  Val}};	
				{defense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense = Player#player.battle_attr#battle_attr.defense + Val}};	
				{defense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense = Player#player.battle_attr#battle_attr.defense - Val}};	
				{defense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense =  Val}};	
				{defense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense =  Val}};	
				{defense_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense_ratio = Player#player.battle_attr#battle_attr.defense_ratio + Val}};	
				{defense_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense_ratio = Player#player.battle_attr#battle_attr.defense_ratio - Val}};	
				{defense_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense_ratio =  Val}};	
				{defense_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{defense_ratio =  Val}};	
				{abs_damage, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{abs_damage = Player#player.battle_attr#battle_attr.abs_damage + Val}};	
				{abs_damage, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{abs_damage = Player#player.battle_attr#battle_attr.abs_damage - Val}};	
				{abs_damage, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{abs_damage =  Val}};	
				{abs_damage, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{abs_damage =  Val}};	
				{fattack, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack = Player#player.battle_attr#battle_attr.fattack + Val}};	
				{fattack, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack = Player#player.battle_attr#battle_attr.fattack - Val}};	
				{fattack, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack =  Val}};	
				{fattack, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack =  Val}};	
				{fattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack_ratio = Player#player.battle_attr#battle_attr.fattack_ratio + Val}};	
				{fattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack_ratio = Player#player.battle_attr#battle_attr.fattack_ratio - Val}};	
				{fattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack_ratio =  Val}};	
				{fattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fattack_ratio =  Val}};	
				{mattack, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack = Player#player.battle_attr#battle_attr.mattack + Val}};	
				{mattack, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack = Player#player.battle_attr#battle_attr.mattack - Val}};	
				{mattack, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack =  Val}};	
				{mattack, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack =  Val}};	
				{mattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack_ratio = Player#player.battle_attr#battle_attr.mattack_ratio + Val}};	
				{mattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack_ratio = Player#player.battle_attr#battle_attr.mattack_ratio - Val}};	
				{mattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack_ratio =  Val}};	
				{mattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mattack_ratio =  Val}};	
				{dattack, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack = Player#player.battle_attr#battle_attr.dattack + Val}};	
				{dattack, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack = Player#player.battle_attr#battle_attr.dattack - Val}};	
				{dattack, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack =  Val}};	
				{dattack, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack =  Val}};	
				{dattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack_ratio = Player#player.battle_attr#battle_attr.dattack_ratio + Val}};	
				{dattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack_ratio = Player#player.battle_attr#battle_attr.dattack_ratio - Val}};	
				{dattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack_ratio =  Val}};	
				{dattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dattack_ratio =  Val}};	
				{fdefense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense = Player#player.battle_attr#battle_attr.fdefense + Val}};	
				{fdefense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense = Player#player.battle_attr#battle_attr.fdefense - Val}};	
				{fdefense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense =  Val}};	
				{fdefense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense =  Val}};	
				{fdefense_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense_ratio = Player#player.battle_attr#battle_attr.fdefense_ratio + Val}};	
				{fdefense_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense_ratio = Player#player.battle_attr#battle_attr.fdefense_ratio - Val}};	
				{fdefense_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense_ratio =  Val}};	
				{fdefense_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{fdefense_ratio =  Val}};	
				{mdefense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense = Player#player.battle_attr#battle_attr.mdefense + Val}};	
				{mdefense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense = Player#player.battle_attr#battle_attr.mdefense - Val}};	
				{mdefense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense =  Val}};	
				{mdefense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense =  Val}};	
				{mdefense_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense_ratio = Player#player.battle_attr#battle_attr.mdefense_ratio + Val}};	
				{mdefense_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense_ratio = Player#player.battle_attr#battle_attr.mdefense_ratio - Val}};	
				{mdefense_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense_ratio =  Val}};	
				{mdefense_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{mdefense_ratio =  Val}};	
				{ddefense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense = Player#player.battle_attr#battle_attr.ddefense + Val}};	
				{ddefense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense = Player#player.battle_attr#battle_attr.ddefense - Val}};	
				{ddefense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense =  Val}};	
				{ddefense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense =  Val}};	
				{ddefense_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense_ratio = Player#player.battle_attr#battle_attr.ddefense_ratio + Val}};	
				{ddefense_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense_ratio = Player#player.battle_attr#battle_attr.ddefense_ratio - Val}};	
				{ddefense_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense_ratio =  Val}};	
				{ddefense_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ddefense_ratio =  Val}};	
				{speed, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{speed = Player#player.battle_attr#battle_attr.speed + Val}};	
				{speed, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{speed = Player#player.battle_attr#battle_attr.speed - Val}};	
				{speed, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{speed =  Val}};	
				{speed, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{speed =  Val}};	
				{attack_speed, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_speed = Player#player.battle_attr#battle_attr.attack_speed + Val}};	
				{attack_speed, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_speed = Player#player.battle_attr#battle_attr.attack_speed - Val}};	
				{attack_speed, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_speed =  Val}};	
				{attack_speed, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{attack_speed =  Val}};	
				{hit_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_ratio = Player#player.battle_attr#battle_attr.hit_ratio + Val}};	
				{hit_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_ratio = Player#player.battle_attr#battle_attr.hit_ratio - Val}};	
				{hit_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_ratio =  Val}};	
				{hit_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{hit_ratio =  Val}};	
				{dodge_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dodge_ratio = Player#player.battle_attr#battle_attr.dodge_ratio + Val}};	
				{dodge_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dodge_ratio = Player#player.battle_attr#battle_attr.dodge_ratio - Val}};	
				{dodge_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dodge_ratio =  Val}};	
				{dodge_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{dodge_ratio =  Val}};	
				{crit_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{crit_ratio = Player#player.battle_attr#battle_attr.crit_ratio + Val}};	
				{crit_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{crit_ratio = Player#player.battle_attr#battle_attr.crit_ratio - Val}};	
				{crit_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{crit_ratio =  Val}};	
				{crit_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{crit_ratio =  Val}};	
				{tough_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{tough_ratio = Player#player.battle_attr#battle_attr.tough_ratio + Val}};	
				{tough_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{tough_ratio = Player#player.battle_attr#battle_attr.tough_ratio - Val}};	
				{tough_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{tough_ratio =  Val}};	
				{tough_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{tough_ratio =  Val}};	
				{frozen_resis_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{frozen_resis_ratio = Player#player.battle_attr#battle_attr.frozen_resis_ratio + Val}};	
				{frozen_resis_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{frozen_resis_ratio = Player#player.battle_attr#battle_attr.frozen_resis_ratio - Val}};	
				{frozen_resis_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{frozen_resis_ratio =  Val}};	
				{frozen_resis_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{frozen_resis_ratio =  Val}};	
				{weak_resis_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{weak_resis_ratio = Player#player.battle_attr#battle_attr.weak_resis_ratio + Val}};	
				{weak_resis_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{weak_resis_ratio = Player#player.battle_attr#battle_attr.weak_resis_ratio - Val}};	
				{weak_resis_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{weak_resis_ratio =  Val}};	
				{weak_resis_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{weak_resis_ratio =  Val}};	
				{flaw_resis_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{flaw_resis_ratio = Player#player.battle_attr#battle_attr.flaw_resis_ratio + Val}};	
				{flaw_resis_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{flaw_resis_ratio = Player#player.battle_attr#battle_attr.flaw_resis_ratio - Val}};	
				{flaw_resis_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{flaw_resis_ratio =  Val}};	
				{flaw_resis_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{flaw_resis_ratio =  Val}};	
				{poison_resis_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{poison_resis_ratio = Player#player.battle_attr#battle_attr.poison_resis_ratio + Val}};	
				{poison_resis_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{poison_resis_ratio = Player#player.battle_attr#battle_attr.poison_resis_ratio - Val}};	
				{poison_resis_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{poison_resis_ratio =  Val}};	
				{poison_resis_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{poison_resis_ratio =  Val}};	
				{avoid_attack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_attack_ratio = Player#player.battle_attr#battle_attr.avoid_attack_ratio + Val}};	
				{avoid_attack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_attack_ratio = Player#player.battle_attr#battle_attr.avoid_attack_ratio - Val}};	
				{avoid_attack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_attack_ratio =  Val}};	
				{avoid_attack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_attack_ratio =  Val}};	
				{avoid_fattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_fattack_ratio = Player#player.battle_attr#battle_attr.avoid_fattack_ratio + Val}};	
				{avoid_fattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_fattack_ratio = Player#player.battle_attr#battle_attr.avoid_fattack_ratio - Val}};	
				{avoid_fattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_fattack_ratio =  Val}};	
				{avoid_fattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_fattack_ratio =  Val}};	
				{avoid_mattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_mattack_ratio = Player#player.battle_attr#battle_attr.avoid_mattack_ratio + Val}};	
				{avoid_mattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_mattack_ratio = Player#player.battle_attr#battle_attr.avoid_mattack_ratio - Val}};	
				{avoid_mattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_mattack_ratio =  Val}};	
				{avoid_mattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_mattack_ratio =  Val}};	
				{avoid_dattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_dattack_ratio = Player#player.battle_attr#battle_attr.avoid_dattack_ratio + Val}};	
				{avoid_dattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_dattack_ratio = Player#player.battle_attr#battle_attr.avoid_dattack_ratio - Val}};	
				{avoid_dattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_dattack_ratio =  Val}};	
				{avoid_dattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_dattack_ratio =  Val}};	
				{avoid_crit_attack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_attack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_attack_ratio + Val}};	
				{avoid_crit_attack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_attack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_attack_ratio - Val}};	
				{avoid_crit_attack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_attack_ratio =  Val}};	
				{avoid_crit_attack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_attack_ratio =  Val}};	
				{avoid_crit_fattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_fattack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_fattack_ratio + Val}};	
				{avoid_crit_fattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_fattack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_fattack_ratio - Val}};	
				{avoid_crit_fattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_fattack_ratio =  Val}};	
				{avoid_crit_fattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_fattack_ratio =  Val}};	
				{avoid_crit_mattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_mattack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_mattack_ratio + Val}};	
				{avoid_crit_mattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_mattack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_mattack_ratio - Val}};	
				{avoid_crit_mattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_mattack_ratio =  Val}};	
				{avoid_crit_mattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_mattack_ratio =  Val}};	
				{avoid_crit_dattack_ratio, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_dattack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_dattack_ratio + Val}};	
				{avoid_crit_dattack_ratio, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_dattack_ratio = Player#player.battle_attr#battle_attr.avoid_crit_dattack_ratio - Val}};	
				{avoid_crit_dattack_ratio, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_dattack_ratio =  Val}};	
				{avoid_crit_dattack_ratio, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{avoid_crit_dattack_ratio =  Val}};	
				{ignore_defense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_defense = Player#player.battle_attr#battle_attr.ignore_defense + Val}};	
				{ignore_defense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_defense = Player#player.battle_attr#battle_attr.ignore_defense - Val}};	
				{ignore_defense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_defense =  Val}};	
				{ignore_defense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_defense =  Val}};	
				{ignore_fdefense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_fdefense = Player#player.battle_attr#battle_attr.ignore_fdefense + Val}};	
				{ignore_fdefense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_fdefense = Player#player.battle_attr#battle_attr.ignore_fdefense - Val}};	
				{ignore_fdefense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_fdefense =  Val}};	
				{ignore_fdefense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_fdefense =  Val}};	
				{ignore_mdefense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_mdefense = Player#player.battle_attr#battle_attr.ignore_mdefense + Val}};	
				{ignore_mdefense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_mdefense = Player#player.battle_attr#battle_attr.ignore_mdefense - Val}};	
				{ignore_mdefense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_mdefense =  Val}};	
				{ignore_mdefense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_mdefense =  Val}};	
				{ignore_ddefense, Val, add} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_ddefense = Player#player.battle_attr#battle_attr.ignore_ddefense + Val}};	
				{ignore_ddefense, Val, sub} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_ddefense = Player#player.battle_attr#battle_attr.ignore_ddefense - Val}};	
				{ignore_ddefense, Val, _} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_ddefense =  Val}};	
				{ignore_ddefense, Val} -> Player#player{battle_attr=Player#player.battle_attr#battle_attr{ignore_ddefense =  Val}};	
			_ -> Player	
		end,	
	set_player_info_fields(NewPlayer, T).	
 	
%%设置宠物信息(按[{字段1,值1},{字段2,值2, add},{字段3,值3, sub}...])	
%% handle_cast({'SET_PET',[{x, 10} ,{y, 20, add},  ,{hp, 20, sub}]}, Status)	
	
	
%% 根据表名获取其完全字段	
get_table_fields(Table_name) ->	
	Table_fileds = [ 	
		{buff,[{uid, 0},{buff, []}]},	
		{casting_polish,[{gid, 0},{uid, 0},{cur_attri, []},{new_attri, []}]},	
		{daily_task_finish,[{uid, 0},{type, 0},{state, 0},{count_detail, []},{cycle_datil, []},{trigger_detail, []},{reset_time, 0},{total, 0},{trigger_time, []}]},	
		{donttalk,[{uid, 0},{start_time, 0},{duration, 0},{reason, [230,151,160,231,144,134]}]},	
		{feedback,[{id, 0},{type, 1},{state, 0},{uid, 0},{name, []},{content, 0},{timestamp, 0},{ip, []},{server, []},{gm, []},{reply, []},{reply_time, 0}]},	
		{goods,[{id, 0},{uid, 0},{pet_id, 0},{gtid, 0},{location, 0},{cell, 0},{num, 0},{score, 0},{hole, 0},{hole_goods, []},{polish_num, 0},{stren_lv, 0},{stren_percent, 0},{type, 0},{subtype, 0},{quality, 0},{sell_price, 0},{career, 0},{gender, 0},{level, 0},{max_num, 0},{bind, 0},{expire_time, 0},{suit_id, 0},{gilding_lv, 0}]},	
		{goods_attribute,[{id, 0},{uid, 0},{gid, 0},{attribute_type, 0},{stone_type_id, 0},{attribute_id, 0},{value, 0},{value_type, 0},{hole_seq, 0},{status, 0}]},	
		{goods_polish,[{id, 0},{uid, 0},{gtid, 0},{type, 0},{stype, 0},{quality, 0},{num, 0},{cell, 0},{polish_lv, 0},{polish_attr, 0},{use_times, 0},{expire_times, 0},{spec, []}]},	
		{goods_strength,[{id, 0},{uid, 0},{gtid, 0},{type, 0},{stype, 0},{quality, 0},{num, 0},{cell, 0},{streng_lv, 0},{use_times, 0},{expire_times, 0},{spec, []}]},	
		{guild,[{id, 0},{name, []},{chief_id, 0},{chief_name, []},{announce, []},{level, 0},{current_num, 0},{elite_num, 0},{devo, 0},{fund, 0},{upgrade_time, 0},{create_time, 0},{maintain_time, 0},{state, 0},{accuse_id, 0},{accuse_time, 0},{against, 0},{agree, 0},{accuse_num, 0},{dirty, 0}]},	
		{guild_apply,[{id, 0},{uid, 0},{guild_id, 0},{nick, []},{gender, 0},{career, 0},{level, 0},{force, 0},{timestamp, 0}]},	
		{guild_member,[{uid, 0},{guild_id, 0},{name, []},{nick, []},{gender, 0},{career, 0},{level, 0},{force, 0},{position, 4},{devo, 0},{coin, 0},{gold, 0},{today_devo, 0},{devo_time, 0},{remain_devo, 0},{vote, 0},{accuse_time, 0},{title, 0},{last_login_time, 0},{sklist, []}]},	
		{infant_ctrl_byuser,[{account_id, 0},{total_time, 0},{last_login_time, 0}]},	
		{mail,[{id, 0},{type, 0},{state, 0},{timestamp, 0},{sname, []},{uid, 0},{title, []},{content, []},{goods_list, []}]},	
		{mount,[{uid, 0},{exp, 0},{level, 0},{fashion, 0},{skill_list, []},{fashion_list, []}]},	
		{notice,[{id, 0},{uid, 0},{claz, 0},{type, 0},{cntt, "\"\""},{tmsp, 0},{exp, 0},{eng, 0},{coin, 0},{prstg, 0},{sprt, 0},{soul, 0},{gold, 0},{goods, []},{sts, 1},{rtmsp, 0},{otid, 0}]},	
		{player,[{id, 0},{account_id, 0},{account_name, []},{nick, []},{type, 1},{icon, 0},{reg_time, 0},{last_login_time, 0},{last_login_ip, []},{status, 0},{gender, 1},{career, 0},{gold, 0},{bgold, 0},{coin, 0},{bcoin, 0},{vip, 0},{vip_expire_time, 0},{scene, 0},{cell_num, 0},{level, 1},{exp, 0},{online_flag, 0},{resolut_x, 0},{resolut_y, 0},{liveness, 0},{camp, 0},{lilian, 0},{mount_flag, 0},{switch, 0},{guild_id, 0},{guild_name, []},{guild_post, 0},{battle_attr, []},{other, 0}]},	
		{rela_friend_req,[{id, 0},{uid, 0},{req_uid, 0},{req_nick, []},{req_career, 0},{req_gender, 0},{req_camp, 0},{req_level, 0},{timestamp, 0},{response, 0}]},	
		{relation,[{uid, 0},{bless_times, 0},{max_friend, 0},{max_foe, 0},{friend_list, []},{foe_list, []},{recent_list, []}]},	
		{server,[{id, 0},{ip, []},{port, 0},{node, []},{num, 0},{stop_access, 0},{start_time, 0},{state, 0}]},	
		{skill,[{uid, 0},{skill_list, []},{cur_skill_list, []}]},	
		{system_config,[{uid, 0},{shield_role, 0},{shield_skill, 0},{shield_rela, 0},{shield_team, 0},{shield_chat, 0},{fasheffect, 0},{music, 50},{soundeffect, 50}]},	
		{task_detail,[{task_type, 0},{can_cyc, 0},{trigger_time, 0},{cycle_time, 0},{meanw_trigger, 0},{time_limit, []},{reset_time, []},{coin, 0}]},	
		{task_finish,[{id, 0},{uid, 0},{td1, []},{td2, []},{td3, []},{td4, []},{td5, []},{td6, []},{td7, []},{td, []}]},	
		{task_process,[{id, 0},{uid, 0},{tid, 0},{state, 0},{trigger_time, 0},{type, 0},{mark, []}]},	
		{temp_all_gem_reward,[{gem_num, 0},{add_value, []}]},	
		{temp_all_stren_reward,[{stren_lv, 0},{stren_reward, []}]},	
		{temp_buff,[{buff_id, 0},{name, [230,157,130,230,138,128]},{type, 0},{group, 0},{priority, 0},{last_time, 0},{times, 0},{ratio, 10000},{link_skill, []},{data, []}]},	
		{temp_combat_attr,[{level, 0},{career, 0},{exp, 0},{hit_point_max, 0},{magic_max, 0},{combopoint_max, 0},{anger_max, 0},{attack, 0},{abs_damage, 0},{defense, 0},{fattack, 0},{mattack, 0},{dattack, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0},{speed, 0},{attack_speed, 0},{hit_ratio, 0},{dodge_ratio, 0},{crit_ratio, 0},{tough_ratio, 0},{frozen_resis_ratio, 0},{weak_resis_ratio, 0},{flaw_resis_ratio, 0},{poison_resis_ratio, 0}]},	
		{temp_compose,[{target_gtid, 0},{gtid, 0},{goods_num, 0},{cost_coin, 0}]},	
		{temp_drop_main,[{did, 0},{dropitem, []}]},	
		{temp_drop_sub,[{sid, 0},{dropitem, []}]},	
		{temp_gilding,[{gilding_lv, 0},{equip_subtype, 0},{add_value, []},{goods, []},{cost_coin, 0}]},	
		{temp_god_tried,[{target_tid, 0},{stone_tid, 0},{god_stone_tid, 0},{cost_coin, 0}]},	
		{temp_gold_bag,[{cell_num, 0},{gold_num, 0}]},	
		{temp_goods,[{gtid, 0},{name, []},{icon, 0},{fall, 0},{type, 0},{subtype, 0},{quality, 0},{sell_price, 0},{career, 0},{gender, 0},{level, 0},{max_num, 0},{limit, 0},{expire_time, 0},{suit_id, 0},{desc, []}]},	
		{temp_goods_buff,[{gtid, 0},{buff_tid, 0}]},	
		{temp_item_equipment,[{gtid, 0},{icon, 0},{set_id, 0},{max_stren, 0},{equip_attr, []},{stren_change, []},{max_holes, 0},{max_gilding, 0}]},	
		{temp_item_gem,[{gtid, 0},{coin_num, 0},{attri_add, "{}"}]},	
		{temp_item_suit,[{suit_id, 0},{suit_num, 0},{name, []},{goods_list, []},{effect_list, []}]},	
		{temp_level_bag,[{level, 0},{cell_num, 0}]},	
		{temp_mon_layout,[{scene_id, 0},{monid, 0},{x, 0},{y, 0},{towards, 0},{revive_time, 0},{state, 0},{pos_x, 0},{pos_y, 0},{attack_skill, 0},{skill_lv, 0},{refresh_time, 0},{last_move_time, 0},{move_time, 0},{move_path, 0},{hate_list, []},{buff_list, []},{begin_sing, 0},{monrcd, "{}"},{battle_attr, "{}"},{target_uid, 0},{id, 0}]},	
		{temp_notice,[{noticeid, 0},{noticetext, []},{noticelv, 0},{type, 0}]},	
		{temp_npc,[{nid, 0},{name, []},{title, []},{icon, 0},{head, 0},{model, 0},{half_length, 0},{npc_type, 0},{level, 0},{fire_range, 0},{warn_range, 0},{hit_point, 0},{magic, 0},{greeting, []},{func, []},{drop_id, 0},{act_skilllist, []},{pas_skilllist, []}]},	
		{temp_npc_layout,[{scene_id, 0},{npcid, 0},{x, 0},{y, 0},{towards, 0},{npcrcd, "{}"},{id, 0}]},	
		{temp_polish,[{gtid, 0},{polish_value, []}]},	
		{temp_polish_goods,[{quality, 0},{max_polish, 0},{goods, []},{cost_coin, 0}]},	
		{temp_scene,[{sid, 0},{name, []},{icon, 0},{mode, 0},{type, 1},{pk_mode, 1},{level_limit, 0},{x, 0},{y, 0},{poem, "0"},{loading, 0},{revive_sid, 0},{revive_x, 0},{revive_y, 0},{npc, []},{scene_num, 0},{id, 0}]},	
		{temp_shop,[{shop_id, 0},{shop_goods, 0},{shop_type, 0},{cost_goods, 0},{cost_num, 0}]},	
		{temp_skill,[{sid, 0},{name, []},{icon, 0},{type, 0},{stype, 0},{career, 0},{distance, 0},{aoe_dist, 0},{aoe_tnum, 0},{cd_all, 0},{cd_group, []},{sing_time, 0},{sing_break, 0},{description, []},{require_list, []},{learn_level, 0},{use_combopoint, 0}]},	
		{temp_skill_attr,[{sid, 0},{level, 0},{cost_lilian, 0},{cost_coin, 0},{cost_magic, 0},{cost_anger, 0},{abs_damage, 0},{buff, []}]},	
		{temp_stren,[{stren_lv, 0},{add_percent, 0},{goods, []},{cost_coin, 0},{stren_rate, 0},{stren_succ, []},{stren_fail, []},{add_succ_rate, 0},{add_holes, 0},{desc, []}]},	
		{temp_suit_reward,[{suit_id, 0},{num, 0},{add_value, []}]},	
		{temp_task,[{tid, 0},{type, 0},{start_npc, 0},{start_scene, 0},{end_npc, 0},{end_scene, 0},{target_type, 0},{target_property, "0"},{name, []},{desc, []},{ongoing_dialog, "\"\""},{finish_dialog, []},{pre_tid, 0},{level, 0},{finish_at_once, 0},{career, 0},{gender, 0},{guild, 0},{team, 0},{goods_list, []},{guild_goods_list, []},{func_num, 0},{next_tid, 0}]},	
		{temp_task_daily,[{id, 0},{uid, 0},{tid, 0},{trigger_time, "0"},{state, 0},{mark, []},{type, 7},{reset_time, "0"},{last_fin_time, 0},{avali_time, 1},{fin_time, 0},{cyc_datil, []},{actual_state, 0}]},	
		{temp_upgrade,[{gtid, 0},{career, 0},{goods, []},{cost_coin, 0},{target_gtid, []}]},	
		{temp_vip_bag,[{vip_gtid, 0},{cell_num, 0}]},	
		{user,[{account_id, 0},{account_name, []},{state, 0},{id_card_state, 0}]},	
		{null,""}], 	
	case lists:keysearch(Table_name,1, Table_fileds) of 	
		{value,{_, Val}} -> Val; 	
		_ -> undefined 	
	end. 	
	
	
%% 获取所有表名	
get_all_tables() ->	
	[ 	
		buff,	
		casting_polish,	
		daily_task_finish,	
		donttalk,	
		feedback,	
		goods,	
		goods_attribute,	
		goods_polish,	
		goods_strength,	
		guild,	
		guild_apply,	
		guild_member,	
		infant_ctrl_byuser,	
		mail,	
		mount,	
		notice,	
		player,	
		rela_friend_req,	
		relation,	
		server,	
		skill,	
		system_config,	
		task_detail,	
		task_finish,	
		task_process,	
		temp_all_gem_reward,	
		temp_all_stren_reward,	
		temp_buff,	
		temp_combat_attr,	
		temp_compose,	
		temp_drop_main,	
		temp_drop_sub,	
		temp_gilding,	
		temp_god_tried,	
		temp_gold_bag,	
		temp_goods,	
		temp_goods_buff,	
		temp_item_equipment,	
		temp_item_gem,	
		temp_item_suit,	
		temp_level_bag,	
		temp_mon_layout,	
		temp_notice,	
		temp_npc,	
		temp_npc_layout,	
		temp_polish,	
		temp_polish_goods,	
		temp_scene,	
		temp_shop,	
		temp_skill,	
		temp_skill_attr,	
		temp_stren,	
		temp_suit_reward,	
		temp_task,	
		temp_task_daily,	
		temp_upgrade,	
		temp_vip_bag,	
		user,	
		null 	
	]. 	
