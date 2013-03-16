%%%------------------------------------------------
%%% File    : goods.hrl
%%% Author  : water
%%% Created : 2013-01-16
%%% Description: 物品头定义 
%%%------------------------------------------------

%% 避免头文件多重包含
-ifndef(__HEADER_GOOD_H__).
-define(__HEADER_GOOD_H__, 0).

%%物品大类型
-define(GTYPE_VIRTUAL,   1).    %虚拟物品
-define(GTYPE_EQUIPMENT, 2).    %装备
-define(GTYPE_WEAPON,    3).    %武器
-define(GTYPE_MEDICINE,  3).    %药品
-define(GTYPE_TOOLS,     4).    %道具
-define(GTYPE_PET,       5).    %宠物
-define(GTYPE_MATERIAL,  6).    %材料
-define(GTYPE_GEM,       7).    %宝石
-define(GTYPE_HORSE,     8).    %座骑



%%具体虚拟物品类
-define(GTYPE_VIRTUAL_START, ((?GTYPE_VIRTUAL-1) * 100 + 1)).
-define(GTYPE_GOLD,        1).
-define(GTYPE_BGOLD,       2).
-define(GTYPE_COIN,        3).
-define(GTYPE_BCOIN,       4).
-define(GTYPE_VIRTUAL_END,  ((?GTYPE_VIRTUAL)*100) ).

%%装备类
-define(GOOD_EQUIP_TYPE_START, 100).
-define(GTYPE_GOLD,        101).
-define(GTYPE_BGOLD,       102).
-define(GTYPE_COIN,        103).
-define(GTYPE_BCOIN,       104).
-define(GOOD_EQUIP_TYPE_END,   104).


-endif.  %% _HEADER_GOOD_H__   
