class_name Projectile
extends Area2D

@export var damage: float = 10.0
@export var speed: float = 500.0
@export var max_distance: float = 500.0
@export var penetration: int = 1
@export var hit_effect: PackedScene

var owner_entity: Node2D = null
var direction: Vector2 = Vector2.RIGHT
var distance_traveled: float = 0.0
var hit_count: int = 0

signal hit_target(target: Node2D, damage: float)
signal projectile_expired

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	if owner_entity and owner_entity.is_in_group("player"):
		collision_layer = 4
		collision_mask = 2 | 64
	else:
		collision_layer = 8
		collision_mask = 1 | 64
	
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 5.0
	collision.shape = shape
	add_child(collision)
	
	var sprite := Sprite2D.new()
	sprite.modulate = Color.YELLOW
	add_child(sprite)

func _physics_process(delta: float) -> void:
	var movement := direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	
	if distance_traveled >= max_distance:
		expire()

func initialize(dir: Vector2, spawn_position: Vector2, owner: Node2D) -> void:
	direction = dir.normalized()
	global_position = spawn_position
	owner_entity = owner
	rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if body == owner_entity:
		return
	
	_apply_damage(body)
	hit_count += 1
	
	if hit_count >= penetration:
		expire()

func _on_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent == owner_entity:
		return
	
	if area.collision_layer & 64:
		expire()
		return
	
	_apply_damage(parent)
	hit_count += 1
	
	if hit_count >= penetration:
		expire()

func _apply_damage(target: Node2D) -> void:
	var final_damage := damage
	
	if owner_entity and owner_entity.has_method("get"):
		var stats = owner_entity.get("stats")
		if stats and stats is PlayerStats:
			final_damage = stats.get_total_damage(damage)
			# 修复4.6.2类型推断严格化问题：显式指定Dictionary类型
			var crit: Dictionary = stats.roll_critical()
			if crit.critical:
				final_damage *= crit.multiplier
	
	if target.has_method("take_damage"):
		target.take_damage(final_damage, owner_entity)
	elif target.has_node("HealthComponent"):
		var health := target.get_node("HealthComponent")
		health.take_damage(final_damage, owner_entity)
	
	hit_target.emit(target, final_damage)
	_spawn_hit_effect(target.global_position)

func _spawn_hit_effect(position: Vector2) -> void:
	if hit_effect:
		var effect := hit_effect.instantiate()
		effect.global_position = position
		get_tree().current_scene.add_child(effect)

func expire() -> void:
	projectile_expired.emit()
	queue_free()

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()
