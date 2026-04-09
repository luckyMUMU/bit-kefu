class_name EnemyData
extends Resource

enum EnemyType {NORMAL, HEAVY, SNIPER, ELITE, BOSS}
enum BehaviorType {PATROL, CHASE, RANGED, HYBRID, SNIPER}

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
@export var accuracy: float = 0.8
@export var fire_rate: float = 1.0
@export var bullet_speed: float = 300.0
@export var reload_time: float = 2.0
@export var magazine_size: int = 10
@export var current_ammo: int = 10
@export var is_shielded: bool = false
@export var shield_strength: float = 0.0
@export var critical_chance: float = 0.0
@export var critical_multiplier: float = 1.5
@export var detection_angle: float = 180.0
@export var patrol_speed: float = 50.0
@export var chase_speed: float = 100.0
@export var retreat_distance: float = 100.0
@export var cover_chance: float = 0.0
@export var flanking_chance: float = 0.0

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
