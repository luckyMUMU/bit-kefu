class_name Weapon
extends Node2D

@export var weapon_data: WeaponData

var owner_entity: Node2D = null
var is_equipped: bool = false
var current_durability: float = 100.0

signal attacked(target_position: Vector2)
signal durability_changed(current: float, maximum: float)
signal weapon_broken

func _ready() -> void:
	if weapon_data:
		current_durability = weapon_data.weight * 10.0

func initialize(data: WeaponData) -> void:
	weapon_data = data
	current_durability = data.weight * 10.0

func attack() -> void:
	push_error("attack() must be overridden in derived classes")

func can_attack() -> bool:
	return is_equipped and current_durability > 0.0

func get_attack_cooldown() -> float:
	if weapon_data:
		return 1.0 / weapon_data.fire_rate
	return 1.0

func get_damage() -> float:
	if weapon_data:
		return weapon_data.damage
	return 10.0

func get_range() -> float:
	if weapon_data:
		return weapon_data.range
	return 100.0

func equip(entity: Node2D) -> void:
	owner_entity = entity
	is_equipped = true

func unequip() -> void:
	owner_entity = null
	is_equipped = false

func drop() -> void:
	unequip()
	var parent := get_parent()
	if parent:
		parent.remove_child(self)
		get_tree().current_scene.add_child(self)
		global_position = owner_entity.global_position if owner_entity else global_position

func use_durability(amount: float = 1.0) -> void:
	current_durability = maxf(0.0, current_durability - amount)
	durability_changed.emit(current_durability, weapon_data.weight * 10.0 if weapon_data else 100.0)
	
	if current_durability <= 0.0:
		weapon_broken.emit()

func repair(amount: float) -> void:
	var max_durability := weapon_data.weight * 10.0 if weapon_data else 100.0
	current_durability = minf(current_durability + amount, max_durability)
	durability_changed.emit(current_durability, max_durability)

func get_durability_percent() -> float:
	var max_durability := weapon_data.weight * 10.0 if weapon_data else 100.0
	if max_durability <= 0.0:
		return 0.0
	return (current_durability / max_durability) * 100.0

func get_weapon_name() -> String:
	if weapon_data:
		return weapon_data.weapon_name
	return "Unknown Weapon"

func get_weapon_type() -> int:
	if weapon_data:
		return weapon_data.weapon_type
	return WeaponData.WeaponType.RANGED
