class_name MeleeWeapon
extends Weapon

@export var attack_range: float = 50.0
@export var attack_arc: float = 90.0
@export var knockback_force: float = 100.0

var attack_hitbox: Area2D
var attack_collision: CollisionShape2D
var is_attacking: bool = false
var attack_timer: float = 0.0

signal hit_target(target: Node2D, damage: float)

func _ready() -> void:
	super._ready()
	_create_attack_hitbox()

func _create_attack_hitbox() -> void:
	attack_hitbox = Area2D.new()
	attack_hitbox.collision_layer = 0
	attack_hitbox.collision_mask = 2
	add_child(attack_hitbox)
	
	attack_collision = CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 20.0
	shape.height = attack_range
	attack_collision.shape = shape
	attack_collision.disabled = true
	attack_hitbox.add_child(attack_collision)
	
	attack_hitbox.body_entered.connect(_on_attack_hit_body)
	attack_hitbox.area_entered.connect(_on_attack_hit_area)

func attack() -> void:
	if not can_attack() or is_attacking:
		return
	
	is_attacking = true
	attack_collision.disabled = false
	
	var attack_direction := Vector2.RIGHT.rotated(global_rotation)
	attack_collision.position = attack_direction * attack_range / 2.0
	attack_collision.rotation = attack_direction.angle()
	
	var cooldown := get_attack_cooldown()
	attack_timer = cooldown
	
	await get_tree().create_timer(0.1).timeout
	attack_collision.disabled = true
	
	await get_tree().create_timer(cooldown - 0.1).timeout
	is_attacking = false

func _on_attack_hit_body(body: Node2D) -> void:
	if body == owner_entity:
		return
	
	_apply_damage_to_target(body)

func _on_attack_hit_area(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent == owner_entity:
		return
	
	if parent.has_method("take_damage") or parent.has_node("HealthComponent"):
		_apply_damage_to_target(parent)

func _apply_damage_to_target(target: Node2D) -> void:
	var damage := get_damage()
	
	if owner_entity and owner_entity.has_method("get"):
		var stats = owner_entity.get("stats")
		if stats and stats is PlayerStats:
			damage = stats.get_total_damage(damage)
			var crit := stats.roll_critical()
			if crit.critical:
				damage *= crit.multiplier
	
	if target.has_method("take_damage"):
		target.take_damage(damage, owner_entity)
	elif target.has_node("HealthComponent"):
		var health := target.get_node("HealthComponent")
		health.take_damage(damage, owner_entity)
	
	_apply_knockback(target)
	hit_target.emit(target, damage)
	use_durability(0.5)

func _apply_knockback(target: Node2D) -> void:
	if target is CharacterBody2D:
		var knockback_direction := (target.global_position - global_position).normalized()
		target.velocity += knockback_direction * knockback_force

func get_attack_cooldown() -> float:
	if weapon_data:
		return 1.0 / weapon_data.fire_rate
	return 0.5
