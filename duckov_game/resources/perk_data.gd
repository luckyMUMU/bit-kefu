class_name PerkData
extends Resource

enum PerkCategory {COMBAT, SURVIVAL, UTILITY, ECONOMY}
enum PerkTier {TIER_1, TIER_2, TIER_3, TIER_4, TIER_5}

@export var perk_id: String = ""
@export var perk_name: String = ""
@export_multiline var description: String = ""
@export var category: PerkCategory = PerkCategory.UTILITY
@export var tier: PerkTier = PerkTier.TIER_1
@export var icon: Texture2D
@export var max_level: int = 1
@export var current_level: int = 0
@export var cost_money: int = 100
@export var cost_fragments: int = 0
@export var required_perks: Array[String] = []
@export var stat_modifiers: Dictionary = {}
@export var special_effects: Array[String] = []
@export var branch_id: String = ""
@export var position_in_branch: int = 0

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

func get_tier_cost_multiplier() -> float:
	match tier:
		PerkTier.TIER_1:
			return 1.0
		PerkTier.TIER_2:
			return 1.5
		PerkTier.TIER_3:
			return 2.0
		PerkTier.TIER_4:
			return 3.0
		PerkTier.TIER_5:
			return 5.0
		_:
			return 1.0

func get_adjusted_cost_for_level(level: int) -> Dictionary:
	var multiplier := get_tier_cost_multiplier()
	return {
		"money": int(cost_money * level * multiplier),
		"fragments": int(cost_fragments * level * multiplier)
	}
