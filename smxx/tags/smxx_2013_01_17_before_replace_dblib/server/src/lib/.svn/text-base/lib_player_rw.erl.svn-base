%%%------------------------------------------------	
%%% File    : lib_player_rw.erl	
%%% Author  : csj	
%%% Created : 2013-01-16 20:41:57	
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
				career -> Player#player.career;	
				gold -> Player#player.gold;	
				bgold -> Player#player.bgold;	
				coin -> Player#player.coin;	
				bcoin -> Player#player.bcoin;	
				scene -> Player#player.scene;	
				x -> Player#player.x;	
				y -> Player#player.y;	
				level -> Player#player.level;	
				exp -> Player#player.exp;	
				hit_point -> Player#player.hit_point;	
				hit_point_max -> Player#player.hit_point_max;	
				magic -> Player#player.magic;	
				magic_max -> Player#player.magic_max;	
				anger -> Player#player.anger;	
				anger_max -> Player#player.anger_max;	
				attack -> Player#player.attack;	
				defense -> Player#player.defense;	
				abs_damage -> Player#player.abs_damage;	
				fattack -> Player#player.fattack;	
				mattack -> Player#player.mattack;	
				dattack -> Player#player.dattack;	
				fdefense -> Player#player.fdefense;	
				mdefense -> Player#player.mdefense;	
				ddefense -> Player#player.ddefense;	
				speed -> Player#player.speed;	
				attack_speed -> Player#player.attack_speed;	
				hit -> Player#player.hit;	
				dodge -> Player#player.dodge;	
				crit -> Player#player.crit;	
				tough -> Player#player.tough;	
				hit_per -> Player#player.hit_per;	
				dodge_per -> Player#player.dodge_per;	
				crit_per -> Player#player.crit_per;	
				tough_per -> Player#player.tough_per;	
				frozen_resis_per -> Player#player.frozen_resis_per;	
				weak_resis_per -> Player#player.weak_resis_per;	
				flaw_resis_per -> Player#player.flaw_resis_per;	
				poison_resis_per -> Player#player.poison_resis_per;	
				online_flag -> Player#player.online_flag;	
				resolut_x -> Player#player.resolut_x;	
				resolut_y -> Player#player.resolut_y;	
				liveness -> Player#player.liveness;	
				camp -> Player#player.camp;	
				other -> Player#player.other;	
				skill -> Player#player.other#player_other.skill;	
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
				{career, Val, add} -> Player#player{career=Player#player.career + Val};	
				{career, Val, sub} -> Player#player{career=Player#player.career - Val};	
				{career, Val, _} -> Player#player{career= Val};	
				{career, Val} -> Player#player{career= Val};	
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
				{scene, Val, add} -> Player#player{scene=Player#player.scene + Val};	
				{scene, Val, sub} -> Player#player{scene=Player#player.scene - Val};	
				{scene, Val, _} -> Player#player{scene= Val};	
				{scene, Val} -> Player#player{scene= Val};	
				{x, Val, add} -> Player#player{x=Player#player.x + Val};	
				{x, Val, sub} -> Player#player{x=Player#player.x - Val};	
				{x, Val, _} -> Player#player{x= Val};	
				{x, Val} -> Player#player{x= Val};	
				{y, Val, add} -> Player#player{y=Player#player.y + Val};	
				{y, Val, sub} -> Player#player{y=Player#player.y - Val};	
				{y, Val, _} -> Player#player{y= Val};	
				{y, Val} -> Player#player{y= Val};	
				{level, Val, add} -> Player#player{level=Player#player.level + Val};	
				{level, Val, sub} -> Player#player{level=Player#player.level - Val};	
				{level, Val, _} -> Player#player{level= Val};	
				{level, Val} -> Player#player{level= Val};	
				{exp, Val, add} -> Player#player{exp=Player#player.exp + Val};	
				{exp, Val, sub} -> Player#player{exp=Player#player.exp - Val};	
				{exp, Val, _} -> Player#player{exp= Val};	
				{exp, Val} -> Player#player{exp= Val};	
				{hit_point, Val, add} -> Player#player{hit_point=Player#player.hit_point + Val};	
				{hit_point, Val, sub} -> Player#player{hit_point=Player#player.hit_point - Val};	
				{hit_point, Val, _} -> Player#player{hit_point= Val};	
				{hit_point, Val} -> Player#player{hit_point= Val};	
				{hit_point_max, Val, add} -> Player#player{hit_point_max=Player#player.hit_point_max + Val};	
				{hit_point_max, Val, sub} -> Player#player{hit_point_max=Player#player.hit_point_max - Val};	
				{hit_point_max, Val, _} -> Player#player{hit_point_max= Val};	
				{hit_point_max, Val} -> Player#player{hit_point_max= Val};	
				{magic, Val, add} -> Player#player{magic=Player#player.magic + Val};	
				{magic, Val, sub} -> Player#player{magic=Player#player.magic - Val};	
				{magic, Val, _} -> Player#player{magic= Val};	
				{magic, Val} -> Player#player{magic= Val};	
				{magic_max, Val, add} -> Player#player{magic_max=Player#player.magic_max + Val};	
				{magic_max, Val, sub} -> Player#player{magic_max=Player#player.magic_max - Val};	
				{magic_max, Val, _} -> Player#player{magic_max= Val};	
				{magic_max, Val} -> Player#player{magic_max= Val};	
				{anger, Val, add} -> Player#player{anger=Player#player.anger + Val};	
				{anger, Val, sub} -> Player#player{anger=Player#player.anger - Val};	
				{anger, Val, _} -> Player#player{anger= Val};	
				{anger, Val} -> Player#player{anger= Val};	
				{anger_max, Val, add} -> Player#player{anger_max=Player#player.anger_max + Val};	
				{anger_max, Val, sub} -> Player#player{anger_max=Player#player.anger_max - Val};	
				{anger_max, Val, _} -> Player#player{anger_max= Val};	
				{anger_max, Val} -> Player#player{anger_max= Val};	
				{attack, Val, add} -> Player#player{attack=Player#player.attack + Val};	
				{attack, Val, sub} -> Player#player{attack=Player#player.attack - Val};	
				{attack, Val, _} -> Player#player{attack= Val};	
				{attack, Val} -> Player#player{attack= Val};	
				{defense, Val, add} -> Player#player{defense=Player#player.defense + Val};	
				{defense, Val, sub} -> Player#player{defense=Player#player.defense - Val};	
				{defense, Val, _} -> Player#player{defense= Val};	
				{defense, Val} -> Player#player{defense= Val};	
				{abs_damage, Val, add} -> Player#player{abs_damage=Player#player.abs_damage + Val};	
				{abs_damage, Val, sub} -> Player#player{abs_damage=Player#player.abs_damage - Val};	
				{abs_damage, Val, _} -> Player#player{abs_damage= Val};	
				{abs_damage, Val} -> Player#player{abs_damage= Val};	
				{fattack, Val, add} -> Player#player{fattack=Player#player.fattack + Val};	
				{fattack, Val, sub} -> Player#player{fattack=Player#player.fattack - Val};	
				{fattack, Val, _} -> Player#player{fattack= Val};	
				{fattack, Val} -> Player#player{fattack= Val};	
				{mattack, Val, add} -> Player#player{mattack=Player#player.mattack + Val};	
				{mattack, Val, sub} -> Player#player{mattack=Player#player.mattack - Val};	
				{mattack, Val, _} -> Player#player{mattack= Val};	
				{mattack, Val} -> Player#player{mattack= Val};	
				{dattack, Val, add} -> Player#player{dattack=Player#player.dattack + Val};	
				{dattack, Val, sub} -> Player#player{dattack=Player#player.dattack - Val};	
				{dattack, Val, _} -> Player#player{dattack= Val};	
				{dattack, Val} -> Player#player{dattack= Val};	
				{fdefense, Val, add} -> Player#player{fdefense=Player#player.fdefense + Val};	
				{fdefense, Val, sub} -> Player#player{fdefense=Player#player.fdefense - Val};	
				{fdefense, Val, _} -> Player#player{fdefense= Val};	
				{fdefense, Val} -> Player#player{fdefense= Val};	
				{mdefense, Val, add} -> Player#player{mdefense=Player#player.mdefense + Val};	
				{mdefense, Val, sub} -> Player#player{mdefense=Player#player.mdefense - Val};	
				{mdefense, Val, _} -> Player#player{mdefense= Val};	
				{mdefense, Val} -> Player#player{mdefense= Val};	
				{ddefense, Val, add} -> Player#player{ddefense=Player#player.ddefense + Val};	
				{ddefense, Val, sub} -> Player#player{ddefense=Player#player.ddefense - Val};	
				{ddefense, Val, _} -> Player#player{ddefense= Val};	
				{ddefense, Val} -> Player#player{ddefense= Val};	
				{speed, Val, add} -> Player#player{speed=Player#player.speed + Val};	
				{speed, Val, sub} -> Player#player{speed=Player#player.speed - Val};	
				{speed, Val, _} -> Player#player{speed= Val};	
				{speed, Val} -> Player#player{speed= Val};	
				{attack_speed, Val, add} -> Player#player{attack_speed=Player#player.attack_speed + Val};	
				{attack_speed, Val, sub} -> Player#player{attack_speed=Player#player.attack_speed - Val};	
				{attack_speed, Val, _} -> Player#player{attack_speed= Val};	
				{attack_speed, Val} -> Player#player{attack_speed= Val};	
				{hit, Val, add} -> Player#player{hit=Player#player.hit + Val};	
				{hit, Val, sub} -> Player#player{hit=Player#player.hit - Val};	
				{hit, Val, _} -> Player#player{hit= Val};	
				{hit, Val} -> Player#player{hit= Val};	
				{dodge, Val, add} -> Player#player{dodge=Player#player.dodge + Val};	
				{dodge, Val, sub} -> Player#player{dodge=Player#player.dodge - Val};	
				{dodge, Val, _} -> Player#player{dodge= Val};	
				{dodge, Val} -> Player#player{dodge= Val};	
				{crit, Val, add} -> Player#player{crit=Player#player.crit + Val};	
				{crit, Val, sub} -> Player#player{crit=Player#player.crit - Val};	
				{crit, Val, _} -> Player#player{crit= Val};	
				{crit, Val} -> Player#player{crit= Val};	
				{tough, Val, add} -> Player#player{tough=Player#player.tough + Val};	
				{tough, Val, sub} -> Player#player{tough=Player#player.tough - Val};	
				{tough, Val, _} -> Player#player{tough= Val};	
				{tough, Val} -> Player#player{tough= Val};	
				{hit_per, Val, add} -> Player#player{hit_per=Player#player.hit_per + Val};	
				{hit_per, Val, sub} -> Player#player{hit_per=Player#player.hit_per - Val};	
				{hit_per, Val, _} -> Player#player{hit_per= Val};	
				{hit_per, Val} -> Player#player{hit_per= Val};	
				{dodge_per, Val, add} -> Player#player{dodge_per=Player#player.dodge_per + Val};	
				{dodge_per, Val, sub} -> Player#player{dodge_per=Player#player.dodge_per - Val};	
				{dodge_per, Val, _} -> Player#player{dodge_per= Val};	
				{dodge_per, Val} -> Player#player{dodge_per= Val};	
				{crit_per, Val, add} -> Player#player{crit_per=Player#player.crit_per + Val};	
				{crit_per, Val, sub} -> Player#player{crit_per=Player#player.crit_per - Val};	
				{crit_per, Val, _} -> Player#player{crit_per= Val};	
				{crit_per, Val} -> Player#player{crit_per= Val};	
				{tough_per, Val, add} -> Player#player{tough_per=Player#player.tough_per + Val};	
				{tough_per, Val, sub} -> Player#player{tough_per=Player#player.tough_per - Val};	
				{tough_per, Val, _} -> Player#player{tough_per= Val};	
				{tough_per, Val} -> Player#player{tough_per= Val};	
				{frozen_resis_per, Val, add} -> Player#player{frozen_resis_per=Player#player.frozen_resis_per + Val};	
				{frozen_resis_per, Val, sub} -> Player#player{frozen_resis_per=Player#player.frozen_resis_per - Val};	
				{frozen_resis_per, Val, _} -> Player#player{frozen_resis_per= Val};	
				{frozen_resis_per, Val} -> Player#player{frozen_resis_per= Val};	
				{weak_resis_per, Val, add} -> Player#player{weak_resis_per=Player#player.weak_resis_per + Val};	
				{weak_resis_per, Val, sub} -> Player#player{weak_resis_per=Player#player.weak_resis_per - Val};	
				{weak_resis_per, Val, _} -> Player#player{weak_resis_per= Val};	
				{weak_resis_per, Val} -> Player#player{weak_resis_per= Val};	
				{flaw_resis_per, Val, add} -> Player#player{flaw_resis_per=Player#player.flaw_resis_per + Val};	
				{flaw_resis_per, Val, sub} -> Player#player{flaw_resis_per=Player#player.flaw_resis_per - Val};	
				{flaw_resis_per, Val, _} -> Player#player{flaw_resis_per= Val};	
				{flaw_resis_per, Val} -> Player#player{flaw_resis_per= Val};	
				{poison_resis_per, Val, add} -> Player#player{poison_resis_per=Player#player.poison_resis_per + Val};	
				{poison_resis_per, Val, sub} -> Player#player{poison_resis_per=Player#player.poison_resis_per - Val};	
				{poison_resis_per, Val, _} -> Player#player{poison_resis_per= Val};	
				{poison_resis_per, Val} -> Player#player{poison_resis_per= Val};	
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
				{skill, Val, add} -> Player#player{other=Player#player.other#player_other{skill = Player#player.other#player_other.skill + Val}};	
				{skill, Val, sub} -> Player#player{other=Player#player.other#player_other{skill = Player#player.other#player_other.skill - Val}};	
				{skill, Val, _} -> Player#player{other=Player#player.other#player_other{skill =  Val}};	
				{skill, Val} -> Player#player{other=Player#player.other#player_other{skill =  Val}};	
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
			_ -> Player	
		end,	
	set_player_info_fields(NewPlayer, T).	
 	
%%设置宠物信息(按[{字段1,值1},{字段2,值2, add},{字段3,值3, sub}...])	
%% handle_cast({'SET_PET',[{x, 10} ,{y, 20, add},  ,{hp, 20, sub}]}, Status)	
	
	
%% 根据表名获取其完全字段	
get_table_fields(Table_name) ->	
	Table_fileds = [ 	
		{feedback,[{id, 0},{type, 1},{state, 0},{player_id, 0},{player_name, []},{title, []},{content, 0},{timestamp, 0},{ip, []},{server, []},{gm, []},{reply, []},{reply_time, 0}]},	
		{goods,[{id, 0},{uid, 0},{gtid, 0},{type, 0},{stype, 0},{quality, 0},{num, 0},{cell, 0},{streng_lv, 0},{use_times, 0},{expire_time, 0},{spec, []}]},	
		{infant_ctrl_byuser,[{account_id, 0},{total_time, 0},{last_login_time, 0}]},	
		{mail,[{id, 0},{type, 0},{state, 0},{timestamp, 0},{sname, []},{uid, 0},{title, []},{content, []},{goods_list, []},{coin, 0},{gold, 0}]},	
		{notice,[{id, 0},{uid, 0},{claz, 0},{type, 0},{cntt, "\"\""},{tmsp, 0},{exp, 0},{eng, 0},{coin, 0},{prstg, 0},{sprt, 0},{soul, 0},{gold, 0},{goods, []},{sts, 1},{rtmsp, 0},{otid, 0}]},	
		{player,[{id, 0},{account_id, 0},{account_name, []},{nick, []},{type, 1},{icon, 0},{reg_time, 0},{last_login_time, 0},{last_login_ip, []},{status, 0},{gender, 1},{career, 0},{gold, 0},{bgold, 0},{coin, 0},{bcoin, 0},{scene, 0},{x, 0},{y, 0},{level, 1},{exp, 0},{hit_point, 0},{hit_point_max, 0},{magic, 0},{magic_max, 0},{anger, 0},{anger_max, 0},{attack, 0},{defense, 0},{abs_damage, 0},{fattack, 0},{mattack, 0},{dattack, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0},{speed, 0},{attack_speed, 0},{hit, 0},{dodge, 0},{crit, 0},{tough, 0},{hit_per, 0},{dodge_per, 0},{crit_per, 0},{tough_per, 0},{frozen_resis_per, 0},{weak_resis_per, 0},{flaw_resis_per, 0},{poison_resis_per, 0},{online_flag, 0},{resolut_x, 0},{resolut_y, 0},{liveness, 0},{camp, 0},{other, 0}]},	
		{player_sys_setting,[{uid, 0},{shield_role, 0},{shield_skill, 0},{shield_rela, 0},{shield_team, 0},{shield_chat, 0},{music, 50},{soundeffect, 50},{fasheffect, 0}]},	
		{server,[{id, 0},{ip, []},{port, 0},{node, []},{num, 0},{stop_access, 0}]},	
		{skill,[{uid, 0},{skill_list, []},{cur_skill, 0}]},	
		{system_config,[{id, 0},{uid, 0},{pro, []}]},	
		{temp_combat_attr,[{level, 0},{career, 0},{exp, 0},{hit_point_max, 0},{magic_max, 0},{combopoint_max, 0},{anger_max, 0},{attack, 0},{abs_damage, 0},{ndefense, 0},{fattack, 0},{mattack, 0},{dattack, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0},{speed, 0},{attack_speed, 0},{hit, 0},{dodge, 0},{crit, 0},{tough, 0},{frozen_resis_per, 0},{weak_resis_per, 0},{flaw_resis_per, 0},{poison_resis_per, 0}]},	
		{temp_goods,[{gtid, 0},{name, []},{icon, 0},{fall, 0},{type, 0},{quality, 0},{price_type, 0},{sell_price, 0},{career, 0},{gender, 0},{level, 0},{max_num, 0},{limit, 0},{expire_time, 0},{set_id, 0},{descr, []},{special, []}]},	
		{temp_item_equipment,[{gtid, 0},{icon, 0},{set_id, 0},{hit_point, 0},{defense, 0},{attack, 0},{fattack, 0},{mattack, 0},{dattack, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0},{hit, 0},{dodge, 0},{crit, 0},{tough, 0},{abs_damage, 0}]},	
		{temp_item_gem,[{gtid, 0},{hit_point, 0},{attack, 0},{fattack, 0},{mattack, 0},{dattack, 0},{defense, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0}]},	
		{temp_item_holy_gem,[{gtid, 0},{hit_point, 0},{attack, 0},{fattack, 0},{mattack, 0},{dattack, 0},{defense, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0}]},	
		{temp_item_set,[{setid, 0},{name, []},{goods_list, []},{effect_list, []}]},	
		{temp_mon_layout,[{scene_id, 0},{monid, 0},{x, 0},{y, 0},{towards, 0},{state, 0},{revive_time, 0},{monrcd, "{}"},{combatattrrcd, "{}"},{id, 0}]},	
		{temp_notice,[{noticeid, 0},{noticetext, []},{noticelv, 0},{type, 0}]},	
		{temp_npc,[{nid, 0},{name, []},{title, []},{icon, 0},{head, 0},{model, 0},{npc_type, 0},{level, 0},{fire_range, 0},{warn_range, 0},{shop_id, 0},{hit_point, 0},{magic, 0},{fall_goods, []},{act_skilllist, []},{pas_skilllist, []}]},	
		{temp_npc_layout,[{scene_id, 0},{npcid, 0},{x, 0},{y, 0},{towards, 0},{npcrcd, "{}"},{id, 0}]},	
		{temp_player,[{career, 0},{level, 1},{exp, 0},{hit_point_max, 0},{magic_max, 0},{anger_max, 0},{attack, 0},{defense, 0},{abs_damage, 0},{fattack, 0},{mattack, 0},{dattack, 0},{fdefense, 0},{mdefense, 0},{ddefense, 0},{speed, 0},{attack_speed, 0}]},	
		{temp_scene,[{sid, 0},{name, []},{icon, 0},{mode, 0},{type, 1},{pk_mode, 1},{level_limit, 0},{x, 0},{y, 0},{poem, "0"},{loading, 0},{revive_sid, 0},{revive_x, 0},{revive_y, 0},{npc, []},{id, 0}]},	
		{temp_skill,[{sid, 0},{name, []},{icon, 0},{type, 0},{distance, 0},{aoe_dist, 0},{aoe_tnum, 0},{cd, 0},{cd_group, 0},{cost_magic_list, 0},{damage_list, 0},{get_cont, 0},{cost_cont, 0},{cost_anger, 0},{link_skill_list, []},{unlink_skill_list, []},{descr, []}]},	
		{temp_task,[{tid, 0},{type, 0},{start_npc, 0},{start_scene, 0},{end_npc, 0},{end_scene, 0},{target_type, 0},{target_num, 0},{name, []},{desc, []},{ongoing_dialog, "\"\""},{finish_dialog, []},{pre_tid, 0},{level, 0},{difficulty, 0},{finish_at_once, 0},{career, 0},{gender, 0},{guild, 0},{team, 0},{exp, 0},{coin, 0},{bcoin, 0},{gold, 0},{bgold, 0},{lilian, 0},{goods_list, []},{guild_goods_list, []},{contrib, 0}]},	
		{user,[{account_id, 0},{account_name, []},{state, 0},{id_card_state, 0}]},	
		{null,""}], 	
	case lists:keysearch(Table_name,1, Table_fileds) of 	
		{value,{_, Val}} -> Val; 	
		_ -> undefined 	
	end. 	
	
	
%% 获取所有表名	
get_all_tables() ->	
	[ 	
		feedback,	
		goods,	
		infant_ctrl_byuser,	
		mail,	
		notice,	
		player,	
		player_sys_setting,	
		server,	
		skill,	
		system_config,	
		temp_combat_attr,	
		temp_goods,	
		temp_item_equipment,	
		temp_item_gem,	
		temp_item_holy_gem,	
		temp_item_set,	
		temp_mon_layout,	
		temp_notice,	
		temp_npc,	
		temp_npc_layout,	
		temp_player,	
		temp_scene,	
		temp_skill,	
		temp_task,	
		user,	
		null 	
	]. 	
