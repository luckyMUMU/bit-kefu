class_name Boss
extends Enemy

@export var boss_id: String = "boss_1"
@export var boss_name: String = "Boss"
@export var boss_description: String = "A powerful enemy"
@export var phase_count: int = 2
@export var phase_transition_health: Array[float] = [0.7, 0.3]

var current_phase: int = 1
var is_boss: bool = true
var boss_health: float

func _ready() -> void:
	super._ready()
	boss_health = max_health

func _process(delta: float) -> void:
	super._process(delta)
	_check_phase_transition()

func _check_phase_transition() -> void:
	if phase_count > 1:
		var health_percentage = current_health / boss_health
		for i in range(phase_count - 1):
			if health_percentage <= phase_transition_health[i] and current_phase == i + 1:
				current_phase = i + 2
				_on_phase_transition(current_phase)
				break

func _on_phase_transition(phase: int) -> void:
	# 子类重写此方法以实现阶段转换效果
	pass

func get_boss_id() -> String:
	return boss_id

func get_boss_name() -> String:
	return boss_name

func get_boss_description() -> String:
	return boss_description

func get_current_phase() -> int:
	return current_phase

func get_phase_count() -> int:
	return phase_count

func on_boss_defeated() -> void:
	# 当Boss被击败时调用
	GameEvents.emit_boss_defeated(boss_id)
	# 解锁下一阶段的地图或内容
	_unlock_next_content()

func _unlock_next_content() -> void:
	# 子类重写此方法以实现解锁逻辑
	pass

func apply_damage(amount: float, source: Node) -> void:
	super.apply_damage(amount, source)
	if current_health <= 0:
		on_boss_defeated()
