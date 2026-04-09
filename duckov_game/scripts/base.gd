class_name Base
extends Node2D

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var storage_container: Node2D = $Facilities/StorageContainer
@onready var workbench: Node2D = $Facilities/Workbench
@onready var blueprint_station: Node2D = $Facilities/BlueprintStation
@onready var medical_station: Node2D = $Facilities/MedicalStation
@onready var gym: Node2D = $Facilities/Gym

var player: Player

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.BASE)
	_spawn_player()
	_setup_facilities()

func _spawn_player() -> void:
	var player_scene := preload("res://scenes/player.tscn")
	player = player_scene.instantiate()
	
	if player_spawn:
		player.global_position = player_spawn.global_position
	else:
		player.global_position = Vector2(400, 300)
	
	add_child(player)

func _setup_facilities() -> void:
	var facilities := GameManager.player_data.base_facilities
	
	if not facilities.has("storage"):
		GameManager.player_data.build_facility("storage", 1)
	
	if not facilities.has("workbench"):
		GameManager.player_data.build_facility("workbench", 1)
	
	if not facilities.has("blueprint_station"):
		GameManager.player_data.build_facility("blueprint_station", 1)
	
	if not facilities.has("medical_station"):
		GameManager.player_data.build_facility("medical_station", 1)
	
	if not facilities.has("gym"):
		GameManager.player_data.build_facility("gym", 1)

func go_to_zone(zone_id: String) -> void:
	GameManager.player_data.current_zone = zone_id
	SaveManager.save_game()
	GameManager.go_to_combat_zone(zone_id)

func open_storage() -> void:
	var inventory_ui = preload("res://scenes/ui/inventory_ui.tscn").instantiate()
	inventory_ui.inventory = GameManager.player_data.storage_inventory
	inventory_ui.title = "Storage"
	add_child(inventory_ui)

func open_workbench() -> void:
	var crafting_ui = preload("res://scenes/ui/crafting_ui.tscn").instantiate()
	add_child(crafting_ui)

func open_blueprint_station() -> void:
	var blueprint_ui = preload("res://scenes/ui/blueprint_ui.tscn").instantiate()
	add_child(blueprint_ui)

func open_medical_station() -> void:
	var medical_ui = preload("res://scenes/ui/medical_ui.tscn").instantiate()
	add_child(medical_ui)

func open_gym() -> void:
	var training_ui = preload("res://scenes/ui/training_ui.tscn").instantiate()
	add_child(training_ui)

func get_player() -> Player:
		return player
