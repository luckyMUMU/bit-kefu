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

func _init() -> void:
	inventory = Inventory.new()
	stats = PlayerStats.new()

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
