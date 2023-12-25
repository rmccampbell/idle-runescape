class_name Data

const XP_TABLE = [
	0,        83,       174,      276,      388,      512,      650,
	801,      969,      1154,     1358,     1584,     1833,     2107,
	2411,     2746,     3115,     3523,     3973,     4470,     5018,
	5624,     6291,     7028,     7842,     8740,     9730,     10824,
	12031,    13363,    14833,    16456,    18247,    20224,    22406,
	24815,    27473,    30408,    33648,    37224,    41171,    45529,
	50339,    55649,    61512,    67983,    75127,    83014,    91721,
	101333,   111945,   123660,   136594,   150872,   166636,   184040,
	203254,   224466,   247886,   273742,   302288,   333804,   368599,
	407015,   449428,   496254,   547953,   605032,   668051,   737627,
	814445,   899257,   992895,   1096278,  1210421,  1336443,  1475581,
	1629200,  1798808,  1986068,  2192818,  2421087,  2673114,  2951373,
	3258594,  3597792,  3972294,  4385776,  4842295,  5346332,  5902831,
	6517253,  7195629,  7944614,  8771558,  9684577,  10692629, 11805606,
	13034431
]

static func find_at_most(table: Array, val):
	return table.bsearch(val, false) - 1

static func level_to_xp(level):
	return XP_TABLE[level - 1]

static func xp_to_level(xp):
	return find_at_most(XP_TABLE, xp) + 1

class Icon:
	var name: String
	var icon: Texture2D
	func _init(name_, icon_):
		name = name_
		icon = icon_

class SkillAction extends Icon:
	var level: int
	var xp: float
	func _init(name_, icon_, level_, xp_):
		super(name_, icon_)
		level = level_
		xp = xp_

class Monster extends Icon:
	var attack_req: int
	var hp: int
	var damage: int
	var coins: int
	func _init(name_, icon_, attack_req_, hp_, damage_, coins_):
		super(name_, icon_)
		attack_req = attack_req_
		hp = hp_
		damage = damage_
		coins = coins_

class SkillResource extends SkillAction:
	var value: int
	func _init(name_, icon_, level_, xp_, value_):
		super(name_, icon_, level_, xp_)
		value = value_

class Ore extends SkillResource:
	pass

class Bar extends SkillResource:
	pass

class Log extends SkillResource:
	pass

class Fish extends SkillResource:
	pass

class EquipmentType extends Icon:
	var smithing_req: int
	var defense: float
	func _init(name_, icon_, smithing_req_, defense_):
		super(name_, icon_)
		smithing_req = smithing_req_
		defense = defense_

static var MONSTER_TABLE: Array[Monster] = [
	Monster.new("Rat", preload("res://assets/Rat.png"), 1, 2, 1, 0),
	Monster.new("Goblin", preload("res://assets/Goblin chathead.png"), 2, 5, 1, 5),
	Monster.new("Cow", preload("res://assets/Cow chathead.png"), 5, 8, 1, 10),
	Monster.new("Dark Wizard", preload("res://assets/Dark wizard chathead.png"), 10, 12, 6, 50),
	Monster.new("Scorpion", preload("res://assets/Scorpion.png"), 15, 17, 11, 100),
	# Monster.new("King Scorpion", preload("res://assets/King_Scorpion.png"), 20, 30, 30, 50),
	Monster.new("Hill Giant", preload("res://assets/Hill giant chathead.png"), 20, 35, 20, 200),
	Monster.new("Moss Giant", preload("res://assets/Moss giant chathead.png"), 30, 60, 30, 400),
	Monster.new("BB Dragon", preload("res://assets/Baby_blue_dragon.png"), 40, 50, 40, 800),
	Monster.new("Lesser Demon", preload("res://assets/Lesser demon chathead.png"), 50, 79, 68, 1000),
	Monster.new("Greater Demon", preload("res://assets/Greater demon icon.png"), 60, 87, 76, 3000),
	Monster.new("KBD", preload("res://assets/King Black Dragon chathead.png"), 75, 240, 240, 15_000),
]
static var MONSTER_LVL_TABLE = MONSTER_TABLE.map(func(x): return x.attack_req)

static var MINING_TABLE: Array[Ore] = [
	Ore.new("Copper", preload("res://assets/Copper ore.png"), 1, 17.5, 1),
	Ore.new("Iron", preload("res://assets/Iron ore.png"), 15, 35, 5),
	Ore.new("Coal", preload("res://assets/Coal.png"), 30, 50, 10),
	Ore.new("Mithril", preload("res://assets/Mithril ore.png"), 55, 80, 20),
	Ore.new("Adamantite", preload("res://assets/Adamantite ore.png"), 70, 95, 50),
	Ore.new("Runite", preload("res://assets/Runite ore.png"), 85, 125, 100),
]
static var MINING_LVL_TABLE = MINING_TABLE.map(func(x): return x.level)

static var SMITHING_TABLE: Array[Bar] = [
	Bar.new("Bronze", preload("res://assets/Bronze bar.png"), 1, 19, 1),
	Bar.new("Iron", preload("res://assets/Iron_bar.png"), 15, 40, 5),
	Bar.new("Steel", preload("res://assets/Steel_bar.png"), 30, 55, 10),
	Bar.new("Mithril", preload("res://assets/Mithril_bar.png"), 50, 80, 20),
	Bar.new("Adamantite", preload("res://assets/Adamantite_bar.png"), 70, 100, 50),
	Bar.new("Runite", preload("res://assets/Runite_bar.png"), 85, 125, 100),
]
static var SMITHING_LVL_TABLE = SMITHING_TABLE.map(func(x): return x.level)

static var WOODCUTTING_TABLE: Array[Log] = [
	Log.new("Logs", preload("res://assets/Logs.png"), 1, 25, 1),
	Log.new("Oak", preload("res://assets/Oak logs.png"), 15, 37.5, 5),
	Log.new("Willow", preload("res://assets/Willow logs.png"), 30, 67.5, 10),
	Log.new("Maple", preload("res://assets/Maple logs.png"), 45, 100, 20),
	Log.new("Yew", preload("res://assets/Yew logs.png"), 60, 175, 50),
	Log.new("Magic", preload("res://assets/Magic logs.png"), 75, 250, 100),
]
static var WOODCUTTING_LVL_TABLE = WOODCUTTING_TABLE.map(func(x): return x.level)

static var FIREMAKING_TABLE: Array[Log] = [
	Log.new("Logs", preload("res://assets/Logs.png"), 1, 40, 1),
	Log.new("Oak", preload("res://assets/Oak logs.png"), 15, 60, 5),
	Log.new("Willow", preload("res://assets/Willow logs.png"), 30, 90, 10),
	Log.new("Maple", preload("res://assets/Maple logs.png"), 45, 135, 20),
	Log.new("Yew", preload("res://assets/Yew logs.png"), 60, 202.5, 50),
	Log.new("Magic", preload("res://assets/Magic logs.png"), 75, 304, 100),
]
static var FIREMAKING_LVL_TABLE = FIREMAKING_TABLE.map(func(x): return x.level)

static var FISHING_TABLE: Array[Fish] = [
	Fish.new("Shrimp", preload("res://assets/Raw shrimps.png"), 1, 10, 3),
	Fish.new("Herring", preload("res://assets/Raw herring.png"), 10, 30, 5),
	Fish.new("Trout", preload("res://assets/Raw trout.png"), 20, 50, 7),
	Fish.new("Salmon", preload("res://assets/Raw salmon.png"), 30, 70, 9),
	Fish.new("Lobster", preload("res://assets/Raw lobster.png"), 40, 90, 12),
	Fish.new("Swordfish", preload("res://assets/Raw swordfish.png"), 50, 100, 14),
	Fish.new("Shark", preload("res://assets/Raw shark.png"), 76, 110, 20),
]
static var FISHING_LVL_TABLE = FISHING_TABLE.map(func(x): return x.level)

static var EQUIP_TABLE = [
	EquipmentType.new("Bronze", preload("res://assets/1280px-Bronze_platebody_detail.png"), 1, .0),
	EquipmentType.new("Iron", preload("res://assets/1280px-Iron_platebody_detail.png"), 15, .15),
	EquipmentType.new("Steel", preload("res://assets/1280px-Steel_platebody_detail.png"), 30, .30),
	EquipmentType.new("Mithril", preload("res://assets/1280px-Mithril_platebody_detail.png"), 50, .50),
	EquipmentType.new("Adamant", preload("res://assets/1280px-Adamant_platebody_detail.png"), 70, .70),
	EquipmentType.new("Rune", preload("res://assets/1280px-Rune_platebody_detail.png"), 85, .85),
]
static var EQUIP_LVL_TABLE = EQUIP_TABLE.map(func(x): return x.smithing_req)

enum EquipmentEnum {
	Bronze, Iron, Steel, Mithril, Adamant, Rune
}

static func find_monster(attack: int):
	return find_at_most(MONSTER_LVL_TABLE, attack)

static func find_skill_act(table: Array, level: int):
	return find_at_most(table, level)

static func find_equip(smithing: int):
	return find_at_most(EQUIP_LVL_TABLE, smithing)


@warning_ignore("integer_division")
static func format_num(x: int):
	if x < 10_000:
		return str(x)
	return "%.02fk" % int(x/1000)
