extends Node

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	DEAD,
	EXTRACTING,
	BASE
}

var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU
var current_scene: Node = null
var player_data: PlayerData = null
var pause_menu: PauseMenu = null

signal state_changed(new_state: GameState)
signal scene_changed(scene_name: String)

const PLAYER_DATA_PATH := "user://player_data.json"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player_data = PlayerData.new()

func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return
	previous_state = current_state
	current_state = new_state
	state_changed.emit(new_state)
	
	match new_state:
		GameState.PAUSED:
			get_tree().paused = true
		GameState.PLAYING, GameState.BASE:
			get_tree().paused = false

func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		if pause_menu == null:
			var pause_scene := load("res://scenes/ui/pause_menu.tscn")
			if pause_scene:
				pause_menu = pause_scene.instantiate()
				get_tree().root.add_child(pause_menu)
		if pause_menu:
			pause_menu.toggle()
	elif current_state == GameState.PAUSED:
		change_state(GameState.PLAYING)

func change_scene(scene_path: String) -> void:
	var scene_resource := load(scene_path)
	if scene_resource == null:
		push_error("Failed to load scene: " + scene_path)
		return
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene_resource.instantiate()
	get_tree().root.add_child(current_scene)
	
	var scene_name := scene_path.get_file().get_basename()
	scene_changed.emit(scene_name)

func go_to_main_menu() -> void:
	change_state(GameState.MAIN_MENU)
	change_scene("res://scenes/main_menu.tscn")

func go_to_base() -> void:
	change_state(GameState.BASE)
	change_scene("res://scenes/base.tscn")

func go_to_combat_zone(zone_id: String = "zone_1") -> void:
	change_state(GameState.PLAYING)
	change_scene("res://scenes/zones/" + zone_id + ".tscn")

func go_to_tutorial() -> void:
	change_state(GameState.PLAYING)
	change_scene("res://scenes/zones/tutorial_zone.tscn")

func player_died() -> void:
	change_state(GameState.DEAD)
	GameEvents.on_player_died.emit()
	_show_death_result()

func _show_death_result() -> void:
	var result_scene := load("res://scenes/ui/result_screen.tscn")
	if result_scene == null:
		return
	var result_screen: Control = result_scene.instantiate()
	get_tree().root.add_child(result_screen)
	result_screen.action_chosen.connect(_on_result_action)

func _on_result_action(action: String) -> void:
	match action:
		"return_base":
			go_to_base()
		"recover_corpse":
			go_to_combat_zone()

func player_extracted() -> void:
	change_state(GameState.EXTRACTING)
	GameEvents.on_player_extracted.emit()
	_show_extraction_result()

func _show_extraction_result() -> void:
	var result_scene := load("res://scenes/ui/result_screen.tscn")
	if result_scene == null:
		return
	var result_screen: Control = result_scene.instantiate()
	var loot := []
	var total_value := player_data.money if player_data else 0
	result_screen.show_extraction_result(loot, total_value)
	get_tree().root.add_child(result_screen)
	result_screen.action_chosen.connect(func(action: String):
		if action == "return_base":
			go_to_base()
	)

func get_player() -> Node2D:
	if current_scene:
		return current_scene.find_child("Player", true, false)
	return null
