class_name PlayerStats
extends RefCounted

# 基础属性
var strength: float = 10.0  # 影响负重和近战伤害
var endurance: float = 10.0  # 影响耐力和生命值
var dexterity: float = 10.0  # 影响武器操控和移动速度
var perception: float = 10.0  # 影响视野和瞄准
var intelligence: float = 10.0  # 影响技能学习速度和资源利用

# 衍生属性
var move_speed: float = 200.0
var carry_capacity: float = 50.0
var damage_bonus: float = 0.0
var defense_bonus: float = 0.0
var critical_chance: float = 0.05
var critical_multiplier: float = 1.5
var health_regen: float = 0.0
var stealth: float = 0.0
var loot_find_bonus: float = 0.0

# 训练相关
var training_points: int = 0
var training_levels: Dictionary = {
	"strength": 0,
	"endurance": 0,
	"dexterity": 0,
	"perception": 0,
	"intelligence": 0
}

func _init() -> void:
	update_derived_stats()

func apply_perk_modifier(stat_name: String, value: float) -> void:
	if stat_name in self:
		self[stat_name] += value
		update_derived_stats()

func get_total_damage(base_damage: float) -> float:
	return base_damage + damage_bonus + (strength * 0.5)

func get_total_defense(base_defense: float) -> float:
	return base_defense + defense_bonus + (endurance * 0.3)

func roll_critical() -> Dictionary:
	if randf() <= critical_chance + (dexterity * 0.005):
		return {"critical": true, "multiplier": critical_multiplier + (perception * 0.05)}
	return {"critical": false, "multiplier": 1.0}

func train_stat(stat_name: String, points: int = 1) -> bool:
	if stat_name not in training_levels:
		return false
	
	if training_points < points:
		return false
	
	training_points -= points
	training_levels[stat_name] += points
	
	# 提升基础属性
	match stat_name:
		"strength":
			strength += points * 0.5
		"endurance":
			endurance += points * 0.5
		"dexterity":
			dexterity += points * 0.5
		"perception":
			perception += points * 0.5
		"intelligence":
			intelligence += points * 0.5
	
	update_derived_stats()
	return true

func add_training_points(points: int) -> void:
	training_points += points

func get_training_cost(stat_name: String, current_level: int) -> int:
	# 训练成本随等级增加
	return int(pow(current_level + 1, 1.5) * 100)

func update_derived_stats() -> void:
	# 根据基础属性更新衍生属性
	move_speed = 200.0 + (dexterity * 5.0)
	carry_capacity = 50.0 + (strength * 5.0)
	health_regen = endurance * 0.05
	stealth = dexterity * 0.02
	loot_find_bonus = perception * 0.01

