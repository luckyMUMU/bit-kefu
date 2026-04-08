class_name HealthComponent
extends Node

@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var defense: float = 0.0
@export var invincibility_duration: float = 0.5

var is_invincible: bool = false
var is_dead: bool = false

signal health_changed(current: float, maximum: float)
signal damaged(amount: float, source: Node)
signal healed(amount: float)
signal died
signal invincibility_started
signal invincibility_ended

func _ready() -> void:
	current_health = mini(current_health, max_health)

func take_damage(amount: float, source: Node = null) -> void:
	if is_dead or is_invincible:
		return
	
	var actual_damage := maxf(0.0, amount - defense)
	current_health = maxf(0.0, current_health - actual_damage)
	
	damaged.emit(actual_damage, source)
	health_changed.emit(current_health, max_health)
	
	if source and source.has_signal("on_hit"):
		source.emit_signal("on_hit", get_parent(), actual_damage)
	
	if current_health <= 0.0:
		die()
	else:
		start_invincibility()

func heal(amount: float) -> void:
	if is_dead:
		return
	
	var actual_heal := minf(amount, max_health - current_health)
	current_health = minf(current_health + amount, max_health)
	
	healed.emit(actual_heal)
	health_changed.emit(current_health, max_health)

func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	died.emit()

func revive(health_percent: float = 1.0) -> void:
	is_dead = false
	current_health = max_health * health_percent
	health_changed.emit(current_health, max_health)

func start_invincibility() -> void:
	if is_invincible:
		return
	
	is_invincible = true
	invincibility_started.emit()
	
	await get_tree().create_timer(invincibility_duration).timeout
	
	is_invincible = false
	invincibility_ended.emit()

func set_max_health(value: float) -> void:
	max_health = value
	current_health = minf(current_health, max_health)
	health_changed.emit(current_health, max_health)

func get_health_percent() -> float:
	if max_health <= 0.0:
		return 0.0
	return current_health / max_health

func is_alive() -> bool:
	return not is_dead and current_health > 0.0

func is_critical(threshold: float = 0.25) -> bool:
	return get_health_percent() <= threshold
