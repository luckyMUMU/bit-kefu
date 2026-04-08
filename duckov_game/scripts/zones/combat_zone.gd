class_name CombatZone
extends Node2D

@export var zone_id: String = "zone_1"
@export var zone_name: String = "First Zone"

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemy_spawns: Node2D = $EnemySpawns
@onready var tile_map: TileMap = $TileMap

var player: Player
var enemies: Array[Enemy] = []
var loot_containers: Array[LootContainer] = []

func _ready() -> void:
	_setup_zone()
	_spawn_player()
	_spawn_enemies()
	_collect_loot_containers()
	
	GameManager.change_state(GameManager.GameState.PLAYING)
	GameEvents.emit_zone_entered(zone_id)

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
	
	for spawn_point in enemy_spawns.get_children():
		if spawn_point is Marker2D:
			var enemy := enemy_scene.instantiate()
			enemy.global_position = spawn_point.global_position
			add_child(enemy)
			enemies.append(enemy)
			GameEvents.emit_enemy_spawned(enemy)

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

func spawn_corpse(position: Vector2, items: Array) -> void:
	var corpse := LootContainer.new()
	corpse.global_position = position
	corpse.contained_items = items
	corpse.is_opened = false
	add_child(corpse)
	
	var sprite := Sprite2D.new()
	sprite.modulate = Color(0.5, 0.5, 0.5, 0.8)
	corpse.add_child(sprite)

func _exit_zone() -> void:
	GameEvents.emit_zone_exited(zone_id)
