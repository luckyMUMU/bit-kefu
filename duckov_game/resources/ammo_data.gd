class_name AmmoData
extends Resource

@export var ammo_id: String = ""
@export var ammo_name: String = ""
@export_multiline var description: String = ""
@export var ammo_type: String = "9mm"
@export var damage_multiplier: float = 1.0
@export var penetration: float = 1.0
@export var armor_damage: float = 1.0
@export var ricochet_chance: float = 0.1
@export var bullet_drop: float = 0.1
@export var velocity: float = 1000.0
@export var max_stack: int = 50
@export var weight: float = 0.1
@export var value: int = 10
@export var sprite: Texture2D

func get_effective_damage(base_damage: float) -> float:
	return base_damage * damage_multiplier

func get_penetration_power() -> float:
	return penetration

func get_armor_damage_factor() -> float:
	return armor_damage