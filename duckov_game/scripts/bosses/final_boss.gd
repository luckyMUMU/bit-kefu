class_name FinalBoss
extends Boss

@export var electric_attack_count: int = 3
@export var fire_attack_count: int = 2
@export var attack_pattern_duration: float = 5.0

var hazard_manager: EnvironmentHazardManager
var attack_pattern_timer: float = 0.0
var current_attack_pattern: int = 0

func _ready() -> void:
	super._ready()
	boss_id = "boss_final"
	boss_name = "机械帝王"
	boss_description = "军事基地的终极统治者，掌握多种元素攻击"
	phase_count = 4
	phase_transition_health = [0.8, 0.6, 0.4, 0.2]
	
	# 查找或创建环境危害管理器
	hazard_manager = get_parent().get_node_or_null("HazardManager")
	if not hazard_manager:
		hazard_manager = EnvironmentHazardManager.new()
		get_parent().add_child(hazard_manager)

func _process(delta: float) -> void:
	super._process(delta)
	_update_attack_pattern(delta)

func _update_attack_pattern(delta: float) -> void:
	attack_pattern_timer += delta
	if attack_pattern_timer >= attack_pattern_duration:
		attack_pattern_timer = 0.0
		_switch_attack_pattern()

func _switch_attack_pattern() -> void:
	current_attack_pattern = (current_attack_pattern + 1) % 3
	match current_attack_pattern:
		0:
			# 电击攻击
			_release_electric_attacks()
		1:
			# 火焰攻击
			_release_fire_attacks()
		2:
			# 混合攻击
			_release_electric_attacks()
			_release_fire_attacks()

func _on_phase_transition(phase: int) -> void:
	match phase:
		2:
			# 第二阶段：增加移动速度
			move_speed *= 1.2
		3:
			# 第三阶段：增加攻击频率和伤害
			attack_cooldown *= 0.8
			damage *= 1.5
		4:
			# 第四阶段：终极形态
			move_speed *= 1.3
			attack_cooldown *= 0.7
			armor += 30
			# 释放大规模攻击
			_release_electric_attacks()
			_release_fire_attacks()

func _release_electric_attacks() -> void:
	# 释放电击攻击
	for i in range(electric_attack_count):
		var angle = (i * 360.0 / electric_attack_count) * PI / 180.0
		var offset = Vector2(cos(angle), sin(angle)) * 100
		var position = global_position + offset
		hazard_manager.spawn_hazard("electric", position, get_parent())

func _release_fire_attacks() -> void:
	# 释放火焰攻击
	for i in range(fire_attack_count):
		var offset = Vector2(
			random_range(-150, 150),
			random_range(-150, 150)
		)
		var position = global_position + offset
		hazard_manager.spawn_hazard("fire", position, get_parent())

func _unlock_next_content() -> void:
	# 游戏胜利，解锁最终内容
	# 这里可以添加游戏胜利的逻辑
	pass
