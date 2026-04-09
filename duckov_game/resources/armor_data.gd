class_name ArmorData
extends Resource

enum ArmorType {HELMET, VEST, ARMOR_PLATE, GLOVES, BOOTS}
enum ArmorMaterial {Kevlar, Ceramic, Steel, Composite, Lightweight}
enum ArmorModification {PLATING, LINING, PADDING, REINFORCEMENT, WEIGHT_REDUCTION}

@export var armor_id: String = ""
@export var armor_name: String = ""
@export_multiline var description: String = ""
@export var armor_type: ArmorType = ArmorType.VEST
@export var armor_material: ArmorMaterial = ArmorMaterial.Kevlar
@export var protection_level: int = 1 # 1-6, 对应逃离塔科夫的防护等级
@export var durability: float = 100.0
@export var max_durability: float = 100.0
@export var weight: float = 5.0
@export var value: int = 1000
@export var movement_penalty: float = 0.05
@export var stamina_penalty: float = 0.05
@export var turn_speed_penalty: float = 0.05
@export var coverage: Dictionary = {"head": 0, "thorax": 0, "stomach": 0, "arms": 0, "legs": 0}
@export var sprite: Texture2D

# 改装相关
var modifications: Dictionary = {}
var modification_level: int = 0
var max_modification_level: int = 3

func get_protection_factor() -> float:
	return protection_level * 0.15

func get_effective_durability() -> float:
	return durability

func damage_durability(damage: float) -> float:
	var damage_amount = damage * 0.3
	durability = max(0.0, durability - damage_amount)
	return durability

func is_destroyed() -> bool:
	return durability <= 0.0

func repair(amount: float) -> float:
	durability = min(max_durability, durability + amount)
	return durability

func get_movement_speed_factor() -> float:
	return 1.0 - movement_penalty

func get_stamina_factor() -> float:
	return 1.0 - stamina_penalty

func get_turn_speed_factor() -> float:
	return 1.0 - turn_speed_penalty

func apply_modification(mod_type: ArmorModification, modifier: Dictionary) -> void:
	# 应用改装效果
	for stat_name in modifier:
		if stat_name in self:
			self[stat_name] += modifier[stat_name]
	
	modifications[mod_type] = modifier
	modification_level += 1

func remove_modification(mod_type: ArmorModification) -> void:
	if mod_type in modifications:
		var modifier = modifications[mod_type]
		# 移除改装效果
		for stat_name in modifier:
			if stat_name in self:
				self[stat_name] -= modifier[stat_name]
		
		modifications.erase(mod_type)
		modification_level -= 1

func get_modification_cost(level: int) -> int:
	# 改装成本随等级增加
	return int(pow(level + 1, 2) * 800)

func can_modify() -> bool:
	return modification_level < max_modification_level
