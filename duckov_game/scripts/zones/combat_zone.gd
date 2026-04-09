class_name CombatZone
extends Node2D

@export var zone_id: String = "zone_1"
@export var zone_name: String = "First Zone"
@export var hazards_enabled: bool = false
@export var hazard_spawn_points: Array[Vector2] = []

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemy_spawns: Node2D = $EnemySpawns
@onready var tile_map: TileMap = $TileMap

var player: Player
var enemies: Array[Enemy] = []
var loot_containers: Array[LootContainer] = []
var hazard_manager: EnvironmentHazardManager
var boss_manager: BossManager

func _ready() -> void:
	_setup_zone()
	_spawn_player()
	_spawn_enemies()
	_collect_loot_containers()
	_spawn_corpses()
	_init_time_manager()
	_init_hazard_manager()
	_init_boss_manager()
	
	GameManager.change_state(GameManager.GameState.PLAYING)
	GameManager.player_data.current_zone = zone_id
	GameEvents.emit_zone_entered(zone_id)

func _init_time_manager() -> void:
	var time_manager = TimeManager.new()
	add_child(time_manager)

func _init_hazard_manager() -> void:
	hazard_manager = EnvironmentHazardManager.new()
	add_child(hazard_manager)
	
	if hazards_enabled:
		_spawn_hazards()

func _init_boss_manager() -> void:
	boss_manager = BossManager.new()
	add_child(boss_manager)
	
	# 检查地图是否有Boss
	var map_info = GameManager.get_map_info(zone_id)
	if map_info and map_info.boss_id:
		_spawn_boss(map_info.boss_id)

func _spawn_boss(boss_id: String) -> void:
	# 生成Boss在地图中央附近
	var boss_position = Vector2(400, 300)  # 默认位置
	boss_manager.spawn_boss(boss_id, boss_position, self)

func _spawn_hazards() -> void:
	# 根据地图ID生成不同类型的环境危害
	match zone_id:
		"zone_2":
			# 废弃工厂 - 毒气
			hazard_manager.spawn_hazard_at_points("gas", hazard_spawn_points, self)
		"zone_3":
			# 辐射区 - 辐射
			hazard_manager.spawn_hazard_at_points("radiation", hazard_spawn_points, self)
		"zone_4":
			# 军事基地 - 多种危害
			hazard_manager.spawn_hazard_at_points("electric", hazard_spawn_points, self)
			hazard_manager.spawn_hazard_at_points("fire", hazard_spawn_points, self)

func _spawn_corpses() -> void:
	# 生成之前的尸体
	for i in range(GameManager.player_data.corpses.size()):
		var corpse_data = GameManager.player_data.corpses[i]
		if corpse_data.zone_id == zone_id:
			var position = Vector2(corpse_data.position_x, corpse_data.position_y)
			spawn_corpse(i, position, corpse_data.items, corpse_data.timestamp)

func _setup_zone() -> void:
	_create_basic_tilemap()

func _create_basic_tilemap() -> void:
	if tile_map == null:
		return

func _spawn_player() -> void:
	var player_scene := preload("res://scenes/player.tscn")
	var existing_player := find_child("Player", true, false)
	
	if existing_player:
		player = existing_player
	else:
		player = player_scene.instantiate()
		add_child(player)
	
	if player_spawn:
		player.global_position = player_spawn.global_position
	else:
		player.global_position = Vector2(100, 100)
	
	var hud := find_child("GameHUD", true, false)
	if hud and hud.has_method("initialize"):
		hud.initialize(player)

func _spawn_enemies() -> void:
	if enemy_spawns == null:
		return
	
	var enemy_scene := preload("res://scenes/enemy.tscn")
	var map_info = GameManager.get_map_info(zone_id)
	var difficulty_multiplier = _get_difficulty_multiplier(map_info.difficulty)
	
	for spawn_point in enemy_spawns.get_children():
		if spawn_point is Marker2D:
			var enemy := enemy_scene.instantiate()
			enemy.global_position = spawn_point.global_position
			
			# 根据spawn_point的名称决定敌人类型
			var spawn_name := spawn_point.name.lower()
			if spawn_name.contains("heavy"):
				enemy.enemy_data = load("res://resources/enemy_heavy_soldier.tres")
			elif spawn_name.contains("sniper"):
				enemy.enemy_data = load("res://resources/enemy_sniper.tres")
			else:
				enemy.enemy_data = load("res://resources/enemy_normal_soldier.tres")
			
			# 初始化敌人数据
			enemy._initialize_from_data()
			
			# 根据难度调整敌人属性
			enemy.max_health = int(enemy.max_health * difficulty_multiplier)
			enemy.current_health = enemy.max_health
			enemy.damage = int(enemy.damage * difficulty_multiplier)
			enemy.move_speed = enemy.move_speed * difficulty_multiplier
			
			add_child(enemy)
			enemies.append(enemy)
			GameEvents.emit_enemy_spawned(enemy)

func _get_difficulty_multiplier(difficulty: int) -> float:
	match difficulty:
		GameManager.MapDifficulty.EASY:
			return 1.0
		GameManager.MapDifficulty.NORMAL:
			return 1.5
		GameManager.MapDifficulty.HARD:
			return 2.0
		GameManager.MapDifficulty.NIGHTMARE:
			return 3.0
		default:
			return 1.0

func _spawn_hazards() -> void:
	# 根据地图ID生成不同类型的环境危害
	match zone_id:
		"zone_2":
			# 废弃工厂 - 毒气
			hazard_manager.spawn_hazard_at_points("gas", hazard_spawn_points, self)
		"zone_3":
			# 辐射区 - 辐射
			hazard_manager.spawn_hazard_at_points("radiation", hazard_spawn_points, self)
		"zone_4":
			# 军事基地 - 多种危害
			hazard_manager.spawn_hazard_at_points("electric", hazard_spawn_points, self)
			hazard_manager.spawn_hazard_at_points("fire", hazard_spawn_points, self)

func _collect_loot_containers() -> void:
	loot_containers.clear()
	for child in get_children():
		if child is LootContainer:
			loot_containers.append(child)

func get_player() -> Player:
	return player

func get_enemies() -> Array[Enemy]:
	return enemies

func get_alive_enemies() -> Array[Enemy]:
	var alive: Array[Enemy] = []
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.current_health > 0:
			alive.append(enemy)
	return alive

func spawn_corpse(corpse_id: int, position: Vector2, items: Array, timestamp: String) -> void:
	var corpse_scene := preload("res://scenes/corpse.tscn")
	var corpse := corpse_scene.instantiate()
	corpse.corpse_id = corpse_id
	corpse.items = items
	corpse.timestamp = timestamp
	corpse.global_position = position
	add_child(corpse)

func _exit_zone() -> void:
	GameEvents.emit_zone_exited(zone_id)
