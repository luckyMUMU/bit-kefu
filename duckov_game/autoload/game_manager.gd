extends Node

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	DEAD,
	EXTRACTING,
	BASE
}

enum MapDifficulty {
	EASY,
	NORMAL,
	HARD,
	NIGHTMARE
}

var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU
var current_scene: Node = null
var player_data: PlayerData = null
var crafting_manager: CraftingManager = null

var maps: Array[Dictionary] = [
	{
		"id": "zone_1",
		"name": "初学者营地",
		"difficulty": MapDifficulty.EASY,
		"unlocked": true,
		"scene_path": "res://scenes/zones/zone_1.tscn",
		"description": "适合新手的起始区域，敌人较弱，资源丰富",
		"required_level": 0,
		"boss_id": null
	},
	{
		"id": "zone_2",
		"name": "废弃工厂",
		"difficulty": MapDifficulty.NORMAL,
		"unlocked": false,
		"scene_path": "res://scenes/zones/zone_2.tscn",
		"description": "废弃的工厂区域，敌人强度中等，资源较为丰富",
		"required_level": 5,
		"boss_id": "boss_1"
	},
	{
		"id": "zone_3",
		"name": "辐射区",
		"difficulty": MapDifficulty.HARD,
		"unlocked": false,
		"scene_path": "res://scenes/zones/zone_3.tscn",
		"description": "被辐射污染的区域，敌人强大，资源稀有",
		"required_level": 10,
		"boss_id": "boss_2"
	},
	{
		"id": "zone_4",
		"name": "军事基地",
		"difficulty": MapDifficulty.NIGHTMARE,
		"unlocked": false,
		"scene_path": "res://scenes/zones/zone_4.tscn",
		"description": "高难度军事基地，敌人精英化，资源极其稀有",
		"required_level": 15,
		"boss_id": "boss_final"
	}
]

signal state_changed(new_state: GameState)
signal scene_changed(scene_name: String)
signal map_unlocked(map_id: String)

default var PLAYER_DATA_PATH := "user://player_data.json"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player_data = PlayerData.new()
	crafting_manager = CraftingManager.new()
	add_child(crafting_manager)
	
	# 加载地图解锁状态
	_load_map_unlock_status()

func _load_map_unlock_status() -> void:
	# 这里可以从存档中加载地图解锁状态
	# 暂时使用默认值
	pass

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
		change_state(GameState.PAUSED)
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
	# 检查地图是否解锁
	var map_info = get_map_info(zone_id)
	if not map_info or not map_info.unlocked:
		push_error("Map not unlocked: " + zone_id)
		return
	
	change_state(GameState.PLAYING)
	change_scene(map_info.scene_path)

func get_map_info(map_id: String) -> Dictionary:
	for map_info in maps:
		if map_info.id == map_id:
			return map_info
	return null

func get_unlocked_maps() -> Array[Dictionary]:
	var unlocked_maps := []
	for map_info in maps:
		if map_info.unlocked:
			unlocked_maps.append(map_info)
	return unlocked_maps

func unlock_map(map_id: String) -> bool:
	for map_info in maps:
		if map_info.id == map_id:
			if not map_info.unlocked:
				map_info.unlocked = true
				GameEvents.emit_map_unlocked(map_id)
				return true
			break
	return false

func check_map_unlock_conditions() -> void:
	# 检查地图解锁条件
	for map_info in maps:
		if not map_info.unlocked and player_data.level >= map_info.required_level:
			unlock_map(map_info.id)

func player_died() -> void:
	change_state(GameState.DEAD)
	GameEvents.on_player_died.emit()

func player_extracted() -> void:
	change_state(GameState.EXTRACTING)
	GameEvents.on_player_extracted.emit()
	await get_tree().create_timer(1.0).timeout
	go_to_base()
	
	# 检查地图解锁条件
	check_map_unlock_conditions()

func get_player() -> Node2D:
	if current_scene:
		return current_scene.find_child("Player", true, false)
	return null
