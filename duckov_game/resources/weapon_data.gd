class_name WeaponData
extends Resource

enum WeaponType {MELEE, RANGED}
enum WeaponCategory {PISTOL, SMG, RIFLE, SHOTGUN, SNIPER, MELEE, THROWABLE}

@export var weapon_id: String = ""
@export var weapon_name: String = ""
@export_multiline var description: String = ""
@export var weapon_type: WeaponType = WeaponType.RANGED
@export var weapon_category: WeaponCategory = WeaponCategory.PISTOL
@export var rarity: String = "common"
@export var damage: float = 10.0
@export var fire_rate: float = 1.0
@export var accuracy: float = 0.9
@export var range: float = 500.0
@export var magazine_size: int = 10
@export var reload_time: float = 2.0
@export var ammo_type: String = "9mm"
@export var weight: float = 1.0
@export var value: int = 100
@export var noise_level: float = 1.0
@export var sprite: Texture2D
@export var projectile_scene: PackedScene
@export var attack_animation: String = "attack"
@export var attachment_slots: Array[String] = []
@export var base_attachments: Array[String] = []

func get_dps() -> float:
	return damage * fire_rate

func get_effective_range() -> float:
	return range * accuracy

func is_silent() -> bool:
	return noise_level < 0.3
