class_name PlayerData
extends RefCounted

var current_health: float = 100.0
var max_health: float = 100.0
var money: int = 0
var experience: int = 0
var last_position: Vector2 = Vector2.ZERO
var current_zone: String = ""
var unlocked_perks: Array[String] = []
var unlocked_recipes: Array[String] = []
var base_facilities: Dictionary = {}
var corpses: Array = []
var inventory: Inventory
var stats: PlayerStats

# 新系统相关
var perk_manager: PerkManager
var training_manager: TrainingManager
var modification_manager: ModificationManager

func _init() -> void:
	inventory = Inventory.new()
	stats = PlayerStats.new()
	perk_manager = PerkManager.new()
	training_manager = TrainingManager.new()
	modification_manager = ModificationManager.new()

func add_money(amount: int) -> void:
	var old_amount := money
	money += amount
	GameEvents.emit_money_changed(money, old_amount)

func spend_money(amount: int) -> bool:
	if money >= amount:
		var old_amount := money
		money -= amount
		GameEvents.emit_money_changed(money, old_amount)
		return true
	return false

func add_experience(amount: int) -> void:
	experience += amount
	# 每获得1000经验值，获得1个训练点
	if experience % 1000 < amount:
		var training_points_gained = int((experience / 1000) - ( (experience - amount) / 1000))
		training_manager.gain_training_points(self, training_points_gained)

func heal(amount: float) -> void:
	current_health = minf(current_health + amount, max_health)
	GameEvents.emit_player_healed(amount)

func take_damage(amount: float) -> void:
	current_health = maxf(current_health - amount, 0.0)
	if current_health <= 0.0:
		GameEvents.emit_player_died()

func is_alive() -> bool:
	return current_health > 0.0

func unlock_perk(perk_id: String) -> void:
	if perk_id not in unlocked_perks:
		unlocked_perks.append(perk_id)
		GameEvents.emit_perk_unlocked(perk_id)

func unlock_recipe(recipe_id: String) -> void:
	if recipe_id not in unlocked_recipes:
		unlocked_recipes.append(recipe_id)
		GameEvents.emit_recipe_unlocked(recipe_id)

func build_facility(facility_id: String, level: int = 1) -> void:
	base_facilities[facility_id] = level
	GameEvents.emit_facility_built(facility_id)

func get_facility_level(facility_id: String) -> int:
	return base_facilities.get(facility_id, 0)

func has_facility(facility_id: String) -> bool:
	return base_facilities.has(facility_id)

func add_corpse(zone_id: String, position: Vector2, items: Array) -> void:
	corpses.append({
		"zone_id": zone_id,
		"position_x": position.x,
		"position_y": position.y,
		"items": items,
		"timestamp": Time.get_datetime_string_from_system()
	})

func remove_corpse(index: int) -> Array:
	if index >= 0 and index < corpses.size():
		var corpse := corpses[index]
		corpses.remove_at(index)
		return corpse.get("items", [])
	return []

# 新系统方法
func get_perk_manager() -> PerkManager:
	return perk_manager

func get_training_manager() -> TrainingManager:
	return training_manager

func get_modification_manager() -> ModificationManager:
	return modification_manager

func can_unlock_perk(perk_id: String) -> Dictionary:
	return perk_manager.can_unlock_perk(perk_id, self)

func unlock_perk_by_id(perk_id: String) -> bool:
	return perk_manager.unlock_perk(perk_id, self)

func can_train_stat(stat_name: String, points: int = 1) -> Dictionary:
	return training_manager.can_train_stat(self, stat_name, points)

func train_stat(stat_name: String, points: int = 1) -> bool:
	return training_manager.train_stat(self, stat_name, points)

func can_modify_item(item: Variant) -> bool:
	return modification_manager.can_modify_item(item, self)

func modify_weapon(weapon: WeaponData, mod_type: WeaponData.ModificationType) -> bool:
	return modification_manager.modify_weapon(weapon, mod_type, self)

func modify_armor(armor: ArmorData, mod_type: ArmorData.ArmorModification) -> bool:
	return modification_manager.modify_armor(armor, mod_type, self)

