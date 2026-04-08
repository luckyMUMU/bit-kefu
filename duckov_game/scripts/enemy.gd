class_name Enemy
extends CharacterBody2D

@export var enemy_data: EnemyData

var current_health: float = 50.0
var max_health: float = 50.0
var move_speed: float = 100.0
var damage: float = 10.0
var detection_range: float = 300.0
var attack_range: float = 50.0
var attack_cooldown: float = 1.0

var state: String = "idle"
var target: Node2D = null
var last_known_target_position: Vector2 = Vector2.ZERO
var attack_timer: float = 0.0
var patrol_points: Array = []
var current_patrol_index: int = 0
var is_alerted: bool = false
var is_attacking: bool = false
var is_showing_warning: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea

signal state_changed(new_state: String)
signal target_detected(target: Node2D)
signal target_lost
signal attack_started
signal attack_completed
signal died

func _ready() -> void:
	add_to_group("enemies")
	_initialize_from_data()
	_setup_signals()
	
	if detection_area:
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	if attack_area:
		attack_area.body_entered.connect(_on_attack_area_body_entered)
		attack_area.body_exited.connect(_on_attack_area_body_exited)
	
	if health_component:
		health_component.died.connect(_on_died)
		health_component.health_changed.connect(_on_health_changed)

func _initialize_from_data() -> void:
	if enemy_data == null:
		return
	
	max_health = enemy_data.max_health
	current_health = max_health
	move_speed = enemy_data.move_speed
	damage = enemy_data.damage
	detection_range = enemy_data.detection_range
	attack_range = enemy_data.attack_range
	attack_cooldown = enemy_data.attack_cooldown

func _setup_signals() -> void:
	pass

func _physics_process(delta: float) -> void:
	match state:
		"idle":
			_process_idle(delta)
		"patrol":
			_process_patrol(delta)
		"chase":
			_process_chase(delta)
		"attack":
			_process_attack(delta)
		"return":
			_process_return(delta)
	
	attack_timer = maxf(0.0, attack_timer - delta)
	move_and_slide()

func _process_idle(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)
	
	if target and is_instance_valid(target):
		change_state("chase")

func _process_patrol(_delta: float) -> void:
	if patrol_points.is_empty():
		change_state("idle")
		return
	
	var target_point: Vector2 = patrol_points[current_patrol_index]
	var direction := (target_point - global_position).normalized()
	velocity = direction * move_speed * 0.5
	
	if global_position.distance_to(target_point) < 10.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
	
	if target and is_instance_valid(target):
		change_state("chase")

func _process_chase(_delta: float) -> void:
	if target == null or not is_instance_valid(target):
		change_state("return")
		return
	
	var distance := global_position.distance_to(target.global_position)
	
	if distance <= attack_range:
		change_state("attack")
		return
	
	if distance > detection_range * 1.5:
		last_known_target_position = target.global_position
		change_state("return")
		return
	
	var direction := (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	
	_update_facing(direction)

func _process_attack(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.2)
	
	if target == null or not is_instance_valid(target):
		change_state("return")
		return
	
	var distance := global_position.distance_to(target.global_position)
	
	if distance > attack_range * 1.2:
		change_state("chase")
		return
	
	if attack_timer <= 0.0 and not is_attacking:
		perform_attack()

func _process_return(_delta: float) -> void:
	if target and is_instance_valid(target):
		if global_position.distance_to(target.global_position) <= detection_range:
			change_state("chase")
			return
	
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)
	change_state("idle")

func perform_attack() -> void:
	if is_attacking or target == null:
		return
	
	is_attacking = true
	attack_started.emit()
	
	if enemy_data and enemy_data.has_attack_warning:
		is_showing_warning = true
		_show_attack_warning()
		await get_tree().create_timer(enemy_data.attack_warning_duration).timeout
		is_showing_warning = false
	
	if target and is_instance_valid(target):
		_apply_damage_to_target(target)
	
	attack_timer = attack_cooldown
	is_attacking = false
	attack_completed.emit()

func _show_attack_warning() -> void:
	if sprite:
		var original_color := sprite.modulate
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = original_color
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = original_color

func _apply_damage_to_target(target_node: Node2D) -> void:
	if target_node.has_method("take_damage"):
		target_node.take_damage(damage, self)
	elif target_node.has_node("HealthComponent"):
		var health := target_node.get_node("HealthComponent")
		health.take_damage(damage, self)

func change_state(new_state: String) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(new_state)

func _update_facing(direction: Vector2) -> void:
	if sprite:
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false

func take_damage(amount: float, source: Node = null) -> void:
	if health_component:
		health_component.take_damage(amount, source)
	
	if source and source.is_in_group("player"):
		target = source
		is_alerted = true
		if state != "chase" and state != "attack":
			change_state("chase")

func die() -> void:
	died.emit()
	_drop_loot()
	GameEvents.emit_enemy_died(self)
	queue_free()

func _drop_loot() -> void:
	if enemy_data == null:
		return
	
	var money_drop := enemy_data.get_random_money_drop()
	GameManager.player_data.add_money(money_drop)
	
	var loot := enemy_data.get_random_loot()
	for loot_entry in loot:
		var item := InventoryItem.new()
		item.item_id = loot_entry.get("item_id", "")
		item.quantity = loot_entry.get("quantity", 1)
		_spawn_loot_item(item)

func _spawn_loot_item(item: InventoryItem) -> void:
	var loot_scene := preload("res://scenes/loot_item.tscn")
	var loot_node := loot_scene.instantiate()
	loot_node.item = item
	loot_node.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
	get_tree().current_scene.add_child(loot_node)

func set_patrol_points(points: Array) -> void:
	patrol_points = points
	if not patrol_points.is_empty():
		change_state("patrol")

func get_state() -> String:
	return state

func has_target() -> bool:
	return target != null and is_instance_valid(target)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		is_alerted = true
		target_detected.emit(body)
		change_state("chase")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		last_known_target_position = target.global_position
		target = null
		target_lost.emit()

func _on_attack_area_body_entered(body: Node2D) -> void:
	pass

func _on_attack_area_body_exited(body: Node2D) -> void:
	pass

func _on_died() -> void:
	die()

func _on_health_changed(current: float, maximum: float) -> void:
	current_health = current
	max_health = maximum
