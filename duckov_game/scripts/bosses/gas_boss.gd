class_name GasBoss
extends Boss

@export var gas_cloud_count: int = 3
@export var gas_cloud_radius: float = 80.0
@export var gas_damage_per_second: float = 5.0

var hazard_manager: EnvironmentHazardManager

func _ready() -> void:
	super._ready()
	boss_id = "boss_1"
	boss_name = "毒气领主"
	boss_description = "废弃工厂的统治者，能够释放致命的毒气"
	phase_count = 2
	phase_transition_health = [0.6, 0.3]
	
	# 查找或创建环境危害管理器
	hazard_manager = get_parent().get_node_or_null("HazardManager")
	if not hazard_manager:
		hazard_manager = EnvironmentHazardManager.new()
		get_parent().add_child(hazard_manager)

func _on_phase_transition(phase: int) -> void:
	match phase:
		2:
			# 第二阶段：增加移动速度和攻击频率
			move_speed *= 1.5
			attack_cooldown *= 0.7
			# 释放毒气云
			_release_gas_clouds()

func _release_gas_clouds() -> void:
	# 释放多个毒气云
	for i in range(gas_cloud_count):
		var offset = Vector2(
			random_range(-100, 100),
			random_range(-100, 100)
		)
		var position = global_position + offset
		hazard_manager.spawn_hazard("gas", position, get_parent())

func _unlock_next_content() -> void:
	# 解锁辐射区地图
	GameManager.unlock_map("zone_3")
