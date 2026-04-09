class_name WeaponData
extends Resource

enum WeaponType {MELEE, RANGED}
enum WeaponCategory {PISTOL, SMG, RIFLE, SHOTGUN, SNIPER, MELEE, THROWABLE}
enum ModificationType {BARREL, STOCK, GRIP, SIGHT, MAGAZINE, MUZZLE, FOREGRIP, HANDGUARD}

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

# 改装相关
var modifications: Dictionary = {}
var modification_level: int = 0
var max_modification_level: int = 5

func get_dps() -> float:
	return damage * fire_rate

func get_effective_range() -> float:
	return range * accuracy

func is_silent() -> bool:
	return noise_level < 0.3

func apply_modification(mod_type: ModificationType, modifier: Dictionary) -> void:
	# 应用改装效果
	for stat_name in modifier:
		if stat_name in self:
			self[stat_name] += modifier[stat_name]
	
	modifications[mod_type] = modifier
	modification_level += 1

func remove_modification(mod_type: ModificationType) -> void:
	if mod_type in modifications:
		var modifier = modifications[mod_type]
		# 移除改装效果
		for stat_name in modifier:
			if stat_name in self:
				self[stat_name] -= modifier[stat_name]
		
		modifications.erase(mod_type)
		modification_level -= 1

func get_modification_slot_count() -> int:
	return attachment_slots.size()

func get_available_modification_slots() -> Array[String]:
	var available: Array[String] = []
	for slot in attachment_slots:
		if slot not in modifications.keys():
			available.append(slot)
	return available

func get_modification_cost(level: int) -> int:
	# 改装成本随等级增加
	return int(pow(level + 1, 2) * 500)

func can_modify() -> bool:
	return modification_level < max_modification_level

