%% Author: Administrator
%% Created:
%% Description: TODO: Add description to db_agent_pet
-module(db_agent_pet).

-include("common.hrl").
-include("record.hrl").

-compile(export_all).

%% 加载玩家宠物
select_pet_by_uid(PlayerId) ->
	case ?DB_MODULE:select_row(pet, "*", [{uid, PlayerId}], [], [1]) of
		DataList when is_list(DataList) andalso length(DataList) >  0 ->
			list_to_tuple([pet|DataList]);
		_ ->
			[]
	end .

%% 宠物改名
rename_pet(PlayerId, PetName) ->
	?DB_MODULE:update(pet, ["name"], [PetName], "pet_id", PlayerId).

%% 更新宠物状态
update_pet_status(PlayerId, Status) ->
	?DB_MODULE:update(pet, ["status"], [Status], "pet_id", PlayerId).

%% 更新宠物属攻类型
update_pet_attr_type(PlayerId, AttrType) ->
	?DB_MODULE:update(pet, ["attack_type"], [AttrType], "pet_id", PlayerId).

%% 更新宠物品阶
update_pet_quality(PlayerId, QualityLv) ->
	?DB_MODULE:update(pet, ["quality_lv"], [QualityLv], "pet_id", PlayerId).

%% 更新宠物成长属性
update_pet_growth(PlayerId, GrowthVal, GrowthProgress) ->
	?DB_MODULE:update(pet, ["growth_val", "growth_progress"], [GrowthVal, GrowthProgress], "pet_id", PlayerId).

%% 更新宠物资质属性
update_pet_aptitude(PlayerId, AptitudeLv, AptitudeProgress) ->
	?DB_MODULE:update(pet, ["aptitude_lv", "aptitude_progress"], [AptitudeLv, AptitudeProgress], "pet_id", PlayerId).

%% 更新宠物属性
update_pet_attr_type(PlayerId, Attack, AttrAttack, Hit, Crit) ->
	?DB_MODULE:update(pet, ["attack", "attr_attack", "hit", "crit"], [Attack, AttrAttack, Hit, Crit], "pet_id", PlayerId).

%% 更新宠物开启技能槽总数
update_pet_skill_holes(PlayerId, SkillHoles) ->
	?DB_MODULE:update(pet, ["skill_hole"], [SkillHoles], "pet_id", PlayerId).

%% 更新宠物技能
update_pet_skill(PlayerId, SkillList) ->
	?DB_MODULE:update(pet, ["skill_list"], [SkillList], "pet_id", PlayerId).

%%生成宠物添加默认值
create_pet(PetInfo) ->
	ValueList = lists:nthtail(2, tuple_to_list(PetInfo)),
    FieldList = record_info(fields, pet),
	?DB_MODULE:insert(pet, FieldList, ValueList).  