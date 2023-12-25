extends Control

@export var hp_xp: float = 1154.0
@export var attack_xp: float = 0.0
@export var mining_xp: float = 0.0
@export var smithing_xp: float = 0.0
@export var woodcutting_xp: float = 0.0
@export var firemaking_xp: float = 0.0
@export var fishing_xp: float = 0.0

@export var hp_lvl: int = 10
@export var attack_lvl: int = 1
@export var mining_lvl: int = 1
@export var smithing_lvl: int = 1
@export var woodcutting_lvl: int = 1
@export var firemaking_lvl: int = 1
@export var fishing_lvl: int = 1

@export var hp_val: int = 10

@export var inv_coins: int = 0
@export var inv_ores: int = 0
@export var inv_bars: int = 0
@export var inv_logs: int = 0
@export var inv_food: int = 0
@export var inv_glasses: int = 0

@export var equip_ind: Data.EquipmentEnum = Data.EquipmentEnum.Bronze
@export var monster_ind: int = 0
@export var mining_act_ind: int = 0
@export var smithing_act_ind: int = 0
@export var woodcutting_act_ind: int = 0
@export var firemaking_act_ind: int = 0
@export var fishing_act_ind: int = 0

@export var item_mult: int = 1

func _ready():
	load_game()
	%AttackButton.pressed.connect(_on_attack_button_pressed)
	%MiningButton.pressed.connect(_on_mining_button_pressed)
	%SmithingButton.pressed.connect(_on_smithing_button_pressed)
	%WoodcuttingButton.pressed.connect(_on_woodcutting_button_pressed)
	%FiremakingButton.pressed.connect(_on_firemaking_button_pressed)
	%FishingButton.pressed.connect(_on_fishing_button_pressed)
	%BeerButton.pressed.connect(_on_beer_button_pressed)
	%SellOresButton.pressed.connect(_on_sell_ores_button_pressed)
	%SellBarsButton.pressed.connect(_on_sell_bars_button_pressed)
	%SellLogsButton.pressed.connect(_on_sell_logs_button_pressed)
	%EatButton.pressed.connect(_on_eat_button_pressed)
	%SaveButton.pressed.connect(_on_save_button_pressed)
	#%HealTimer.timeout.connect(_on_heal_timer_timeout)
	#%X10Button.toggled.connect(_on_x10_button_toggled)


func _process(_delta):
	%HpXpLabel.text = "%dxp" % hp_xp
	%AttackXpLabel.text = "%dxp" % attack_xp
	%MiningXpLabel.text = "%dxp" % mining_xp
	%SmithingXpLabel.text = "%dxp" % smithing_xp
	%WoodcuttingXpLabel.text = "%dxp" % woodcutting_xp
	%FiremakingXpLabel.text = "%dxp" % firemaking_xp
	%FishingXpLabel.text = "%dxp" % fishing_xp

	%HpValLabel.text = "%02d/%02d" % [hp_val, hp_lvl]
	%AttackValLabel.text = "%02d" % attack_lvl
	%MiningValLabel.text = "%02d" % mining_lvl
	%SmithingValLabel.text = "%02d" % smithing_lvl
	%WoodcuttingValLabel.text = "%02d" % woodcutting_lvl
	%FiremakingValLabel.text = "%02d" % firemaking_lvl
	%FishingValLabel.text = "%02d" % fishing_lvl

	%CoinsValLabel.text = Data.format_num(inv_coins)
	%OresValLabel.text = Data.format_num(inv_ores)
	%BarsValLabel.text = Data.format_num(inv_bars)
	%LogsValLabel.text = Data.format_num(inv_logs)
	%FoodValLabel.text = Data.format_num(inv_food)
	%BeerGlassesValLabel.text = Data.format_num(inv_glasses)

	%MonsterIcon.texture = Data.MONSTER_TABLE[monster_ind].icon
	%OreIcon.texture = Data.MINING_TABLE[mining_act_ind].icon
	%BarIcon.texture = Data.SMITHING_TABLE[smithing_act_ind].icon
	%WoodIcon.texture = Data.WOODCUTTING_TABLE[woodcutting_act_ind].icon
	%BurnIcon.texture = Data.FIREMAKING_TABLE[firemaking_act_ind].icon
	%FishIcon.texture = Data.FISHING_TABLE[fishing_act_ind].icon
	%EquipIcon.texture = Data.EQUIP_TABLE[equip_ind].icon


func _on_attack_button_pressed():
	var monster = Data.MONSTER_TABLE[monster_ind]
	var equip = Data.EQUIP_TABLE[equip_ind]
	var damage = int(monster.damage * (1. - equip.defense))
	if hp_val > damage:
		var xp = roundi(monster.hp*4/3.)
		attack_xp += xp
		attack_lvl = Data.xp_to_level(attack_xp)
		hp_xp += xp
		hp_lvl = Data.xp_to_level(hp_xp)
		monster_ind = Data.find_monster(attack_lvl)
		inv_coins += monster.coins
		hp_val -= damage

func _on_mining_button_pressed():
	var ore = Data.MINING_TABLE[mining_act_ind]
	mining_xp += ore.xp
	mining_lvl = Data.xp_to_level(mining_xp)
	mining_act_ind = Data.find_skill_act(Data.MINING_LVL_TABLE, mining_lvl)
	inv_ores += ore.value

func _on_smithing_button_pressed():
	var bar = Data.SMITHING_TABLE[smithing_act_ind]
	if inv_ores >= bar.value:
		smithing_xp += bar.xp
		smithing_lvl = Data.xp_to_level(smithing_xp)
		smithing_act_ind = Data.find_skill_act(Data.SMITHING_LVL_TABLE, smithing_lvl)
		equip_ind = Data.find_equip(smithing_lvl)
		inv_ores -= bar.value
		inv_bars += bar.value

func _on_woodcutting_button_pressed():
	var wood = Data.WOODCUTTING_TABLE[woodcutting_act_ind]
	woodcutting_xp += wood.xp
	woodcutting_lvl = Data.xp_to_level(woodcutting_xp)
	woodcutting_act_ind = Data.find_skill_act(Data.WOODCUTTING_LVL_TABLE, woodcutting_lvl)
	inv_logs += wood.value

func _on_firemaking_button_pressed():
	var wood = Data.FIREMAKING_TABLE[firemaking_act_ind]
	if inv_logs >= wood.value:
		firemaking_xp += wood.xp
		firemaking_lvl = Data.xp_to_level(firemaking_xp)
		firemaking_act_ind = Data.find_skill_act(Data.FIREMAKING_LVL_TABLE, firemaking_lvl)
		inv_logs -= wood.value

func _on_fishing_button_pressed():
	var fish = Data.FISHING_TABLE[fishing_act_ind]
	fishing_xp += fish.xp
	fishing_lvl = Data.xp_to_level(fishing_xp)
	fishing_act_ind = Data.find_skill_act(Data.FISHING_LVL_TABLE, fishing_lvl)
	inv_food += fish.value

func _on_beer_button_pressed():
	@warning_ignore("integer_division")
	var num = min(item_mult, int(inv_coins/2))
	if num:
		inv_glasses += num
		inv_coins -= 2*num

func _on_sell_ores_button_pressed():
	var num = min(item_mult, inv_ores)
	if num:
		inv_ores -= num
		inv_coins += num

func _on_sell_bars_button_pressed():
	var num = min(item_mult, inv_bars)
	if num:
		inv_bars -= num
		inv_coins += num

func _on_sell_logs_button_pressed():
	var num = min(item_mult, inv_logs)
	if num:
		inv_logs -= num
		inv_coins += num

func _on_eat_button_pressed():
	var num = min(item_mult, inv_food, hp_lvl - hp_val)
	if num:
		inv_food -= num
		hp_val += num

func _on_heal_timer_timeout():
	if hp_val < hp_lvl:
		hp_val += 1

func _on_x10_button_toggled(toggled_on: bool):
	item_mult = 10 if toggled_on else 1

func _on_save_button_pressed():
	save_game()

func save_game():
	var data = {
		'hp_xp': hp_xp,
		'attack_xp': attack_xp,
		'mining_xp': mining_xp,
		'smithing_xp': smithing_xp,
		'woodcutting_xp': woodcutting_xp,
		'firemaking_xp': firemaking_xp,
		'fishing_xp': fishing_xp,
		'hp_lvl': hp_lvl,
		'attack_lvl': attack_lvl,
		'mining_lvl': mining_lvl,
		'smithing_lvl': smithing_lvl,
		'woodcutting_lvl': woodcutting_lvl,
		'firemaking_lvl': firemaking_lvl,
		'fishing_lvl': fishing_lvl,
		'hp_val': hp_val,
		'inv_coins': inv_coins,
		'inv_ores': inv_ores,
		'inv_bars': inv_bars,
		'inv_logs': inv_logs,
		'inv_food': inv_food,
		'inv_glasses': inv_glasses,
		'equip_ind': equip_ind,
		'monster_ind': monster_ind,
		'mining_act_ind': mining_act_ind,
		'smithing_act_ind': smithing_act_ind,
		'woodcutting_act_ind': woodcutting_act_ind,
		'firemaking_act_ind': firemaking_act_ind,
		'fishing_act_ind': fishing_act_ind,
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(data))
	print('Game saved')

func load_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	if not save_file:
		print('Failed to open save file')
		return
	var data = JSON.parse_string(save_file.get_as_text())
	for key in data:
		set(key, data[key])
	print('Game loaded')
