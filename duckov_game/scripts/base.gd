class_name Base
extends Node2D

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var storage_container: Node2D = $Facilities/StorageContainer
@onready var workbench: Node2D = $Facilities/Workbench

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

func go_to_zone(zone_id: String) -> void:
	GameManager.player_data.current_zone = zone_id
	SaveManager.save_game()
	GameManager.go_to_combat_zone(zone_id)

func open_storage() -> void:
	pass

func open_workbench() -> void:
	pass

func get_player() -> Player:
		return player
