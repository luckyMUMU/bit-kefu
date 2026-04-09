class_name AttachmentData
extends Resource

enum AttachmentType {SIGHT, GRIP, MAGAZINE, MUZZLE, BARREL, STOCK, FOREGRIP, LASER, TACTICAL}

@export var attachment_id: String = ""
@export var attachment_name: String = ""
@export_multiline var description: String = ""
@export var attachment_type: AttachmentType = AttachmentType.SIGHT
@export var compatible_weapon_categories: Array[String] = []
@export var damage_modifier: float = 1.0
@export var accuracy_modifier: float = 1.0
@export var recoil_modifier: float = 1.0
@export var fire_rate_modifier: float = 1.0
@export var reload_speed_modifier: float = 1.0
@export var magazine_capacity_modifier: float = 1.0
@export var weight: float = 0.5
@export var value: int = 500
@export var sprite: Texture2D

func get_compatibility(weapon_category: String) -> bool:
	return compatible_weapon_categories.size() == 0 or compatible_weapon_categories.has(weapon_category)

func get_modifiers() -> Dictionary:
	return {
		"damage": damage_modifier,
		"accuracy": accuracy_modifier,
		"recoil": recoil_modifier,
		"fire_rate": fire_rate_modifier,
		"reload_speed": reload_speed_modifier,
		"magazine_capacity": magazine_capacity_modifier
	}

func get_total_weight() -> float:
	return weight