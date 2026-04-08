class_name EnemyData
extends Resource

enum EnemyType {NORMAL, ELITE, BOSS}
enum BehaviorType {PATROL, CHASE, RANGED, HYBRID}

@export var enemy_id: String = ""
@export var enemy_name: String = ""
@export_multiline var description: String = ""
@export var enemy_type: EnemyType = EnemyType.NORMAL
@export var behavior_type: BehaviorType = BehaviorType.CHASE
@export var max_health: float = 50.0
@export var damage: float = 10.0
@export var move_speed: float = 100.0
@export var attack_range: float = 50.0
@export var detection_range: float = 300.0
@export var attack_cooldown: float = 1.0
@export var experience_reward: int = 10
@export var money_drop_min: int = 5
@export var money_drop_max: int = 20
@export var loot_table: Array[Dictionary] = []
@export var sprite: Texture2D
@export var death_effect: PackedScene
@export var attack_warning_duration: float = 0.5
@export var has_attack_warning: bool = false

func get_random_money_drop() -> int:
	return randi_range(money_drop_min, money_drop_max)

func get_random_loot() -> Array[Dictionary]:
	var drops: Array[Dictionary] = []
	for loot_entry in loot_table:
		var chance: float = loot_entry.get("chance", 0.0)
		if randf() <= chance:
			drops.append({
				"item_id": loot_entry.get("item_id", ""),
				"quantity": randi_range(
					loot_entry.get("min_quantity", 1),
					loot_entry.get("max_quantity", 1)
				)
			})
	return drops
