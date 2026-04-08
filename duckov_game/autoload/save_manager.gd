extends Node

const SAVE_DIR := "user://saves/"
const SAVE_EXTENSION := ".json"

signal save_completed(success: bool)
signal load_completed(success: bool)

func _ready() -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)

func save_game(slot_name: String = "autosave") -> bool:
	var save_path := SAVE_DIR + slot_name + SAVE_EXTENSION
	var save_data := _collect_save_data()
	
	var json_string := JSON.stringify(save_data, "\t")
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	
	if file == null:
		push_error("Failed to open save file: " + save_path)
		save_completed.emit(false)
		return false
	
	file.store_string(json_string)
	file.close()
	save_completed.emit(true)
	return true

func load_game(slot_name: String = "autosave") -> bool:
	var save_path := SAVE_DIR + slot_name + SAVE_EXTENSION
	
	if not FileAccess.file_exists(save_path):
		push_error("Save file not found: " + save_path)
		load_completed.emit(false)
		return false
	
	var file := FileAccess.open(save_path, FileAccess.READ)
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_result := json.parse(json_string)
	
	if parse_result != OK:
		push_error("Failed to parse save file: " + save_path)
		load_completed.emit(false)
		return false
	
	var save_data: Dictionary = json.data
	_apply_save_data(save_data)
	load_completed.emit(true)
	return true

func has_save(slot_name: String = "autosave") -> bool:
	return FileAccess.file_exists(SAVE_DIR + slot_name + SAVE_EXTENSION)

func delete_save(slot_name: String) -> bool:
	var save_path := SAVE_DIR + slot_name + SAVE_EXTENSION
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		return true
	return false

func get_all_saves() -> Array[String]:
	var saves: Array[String] = []
	var dir := DirAccess.open(SAVE_DIR)
	
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(SAVE_EXTENSION):
				saves.append(file_name.get_basename())
			file_name = dir.get_next()
	
	return saves

func _collect_save_data() -> Dictionary:
	var data := {
		"version": "1.0.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"player": _collect_player_data(),
		"inventory": _collect_inventory_data(),
		"base": _collect_base_data(),
		"corpses": _collect_corpse_data()
	}
	return data

func _collect_player_data() -> Dictionary:
	var player := GameManager.player_data
	return {
		"health": player.current_health,
		"max_health": player.max_health,
		"money": player.money,
		"experience": player.experience,
		"position_x": player.last_position.x,
		"position_y": player.last_position.y,
		"current_zone": player.current_zone,
		"unlocked_perks": player.unlocked_perks,
		"stats": {
			"move_speed": player.stats.move_speed,
			"carry_capacity": player.stats.carry_capacity,
			"damage_bonus": player.stats.damage_bonus,
			"defense_bonus": player.stats.defense_bonus
		}
	}

func _collect_inventory_data() -> Dictionary:
	var inventory_data := {
		"items": [],
		"safe_slot": null,
		"current_weight": 0.0
	}
	
	var player := GameManager.player_data
	for item in player.inventory.items:
		inventory_data["items"].append({
			"item_id": item.item_id,
			"quantity": item.quantity,
			"durability": item.durability
		})
	
	if player.inventory.safe_slot_item:
		inventory_data["safe_slot"] = {
			"item_id": player.inventory.safe_slot_item.item_id,
			"quantity": player.inventory.safe_slot_item.quantity
		}
	
	inventory_data["current_weight"] = player.inventory.current_weight
	return inventory_data

func _collect_base_data() -> Dictionary:
	return {
		"facilities": GameManager.player_data.base_facilities,
		"storage": [],
		"unlocked_recipes": GameManager.player_data.unlocked_recipes
	}

func _collect_corpse_data() -> Array:
	return GameManager.player_data.corpses

func _apply_save_data(data: Dictionary) -> void:
	if data.has("player"):
		_apply_player_data(data.player)
	if data.has("inventory"):
		_apply_inventory_data(data.inventory)
	if data.has("base"):
		_apply_base_data(data.base)
	if data.has("corpses"):
		GameManager.player_data.corpses = data.corpses

func _apply_player_data(data: Dictionary) -> void:
	var player := GameManager.player_data
	player.current_health = data.get("health", player.max_health)
	player.max_health = data.get("max_health", 100)
	player.money = data.get("money", 0)
	player.experience = data.get("experience", 0)
	player.last_position = Vector2(data.get("position_x", 0), data.get("position_y", 0))
	player.current_zone = data.get("current_zone", "")
	player.unlocked_perks = data.get("unlocked_perks", [])
	
	if data.has("stats"):
		var stats = data.stats
		player.stats.move_speed = stats.get("move_speed", 200.0)
		player.stats.carry_capacity = stats.get("carry_capacity", 50.0)
		player.stats.damage_bonus = stats.get("damage_bonus", 0.0)
		player.stats.defense_bonus = stats.get("defense_bonus", 0.0)

func _apply_inventory_data(data: Dictionary) -> void:
	var player := GameManager.player_data
	player.inventory.items.clear()
	
	for item_data in data.get("items", []):
		var item := InventoryItem.new()
		item.item_id = item_data.get("item_id", "")
		item.quantity = item_data.get("quantity", 1)
		item.durability = item_data.get("durability", 100.0)
		player.inventory.items.append(item)
	
	if data.has("safe_slot") and data.safe_slot != null:
		player.inventory.safe_slot_item = InventoryItem.new()
		player.inventory.safe_slot_item.item_id = data.safe_slot.get("item_id", "")
		player.inventory.safe_slot_item.quantity = data.safe_slot.get("quantity", 1)
	
	player.inventory.current_weight = data.get("current_weight", 0.0)

func _apply_base_data(data: Dictionary) -> void:
	var player := GameManager.player_data
	player.base_facilities = data.get("facilities", {})
	player.unlocked_recipes = data.get("unlocked_recipes", [])
