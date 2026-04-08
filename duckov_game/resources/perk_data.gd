class_name PerkData
extends Resource

enum PerkCategory {COMBAT, SURVIVAL, UTILITY, ECONOMY}

@export var perk_id: String = ""
@export var perk_name: String = ""
@export_multiline var description: String = ""
@export var category: PerkCategory = PerkCategory.UTILITY
@export var icon: Texture2D
@export var max_level: int = 1
@export var current_level: int = 0
@export var cost_money: int = 100
@export var cost_fragments: int = 0
@export var required_perks: Array[String] = []
@export var stat_modifiers: Dictionary = {}
@export var special_effects: Array[String] = []

func can_unlock(unlocked_perks: Array[String]) -> Dictionary:
	var result := {"can_unlock": true, "reason": ""}
	
	if current_level >= max_level:
		result.can_unlock = false
		result.reason = "Already at max level"
		return result
	
	for required in required_perks:
		if required not in unlocked_perks:
			result.can_unlock = false
			result.reason = "Missing required perk: " + required
			return result
	
	return result

func apply_level(player_stats: PlayerStats, level: int = 1) -> void:
	for stat_name in stat_modifiers:
		var value: float = stat_modifiers[stat_name] * level
		player_stats.apply_perk_modifier(stat_name, value)

func get_cost_for_level(level: int) -> Dictionary:
	return {
		"money": cost_money * level,
		"fragments": cost_fragments * level
	}
