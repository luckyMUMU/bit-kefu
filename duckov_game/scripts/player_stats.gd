class_name PlayerStats
extends RefCounted

var move_speed: float = 200.0
var carry_capacity: float = 50.0
var damage_bonus: float = 0.0
var defense_bonus: float = 0.0
var critical_chance: float = 0.05
var critical_multiplier: float = 1.5
var health_regen: float = 0.0
var stealth: float = 0.0
var loot_find_bonus: float = 0.0

func apply_perk_modifier(stat_name: String, value: float) -> void:
	if stat_name in self:
		self[stat_name] += value

func get_total_damage(base_damage: float) -> float:
	return base_damage + damage_bonus

func get_total_defense(base_defense: float) -> float:
	return base_defense + defense_bonus

func roll_critical() -> Dictionary:
	if randf() <= critical_chance:
		return {"critical": true, "multiplier": critical_multiplier}
	return {"critical": false, "multiplier": 1.0}
