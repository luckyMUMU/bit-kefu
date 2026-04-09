class_name RadiationBoss
extends Boss

@export var radiation_pulse_count: int = 2
@export var radiation_pulse_radius: float = 150.0
@export var radiation_pulse_damage: float = 20.0

var hazard_manager: EnvironmentHazardManager

func _ready() -> void:
	super._ready()
	boss_id = "boss_2"
	boss_name = "辐射巨人"
	boss_description = "辐射区的霸主，能够释放强烈的辐射脉冲"
	phase_count = 3
	phase_transition_health = [0.7, 0.4, 0.1]
	
	# 查找或创建环境危害管理器
	hazard_manager = get_parent().get_node_or_null("HazardManager")
	if not hazard_manager:
		hazard_manager = EnvironmentHazardManager.new()
		get_parent().add_child(hazard_manager)

func _on_phase_transition(phase: int) -> void:
	match phase:
		2:
			# 第二阶段：增加防御和辐射伤害
			armor += 20
			# 释放辐射脉冲
			_release_radiation_pulse()
		3:
			# 第三阶段：增加移动速度和攻击频率
			move_speed *= 1.3
			attack_cooldown *= 0.6
			# 释放多个辐射脉冲
			for i in range(radiation_pulse_count):
				_release_radiation_pulse()

func _release_radiation_pulse() -> void:
	# 释放辐射脉冲
	var position = global_position
	hazard_manager.spawn_hazard("radiation", position, get_parent())

func _unlock_next_content() -> void:
	# 解锁军事基地地图
	GameManager.unlock_map("zone_4")
