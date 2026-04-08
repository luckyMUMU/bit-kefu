class_name TimeManager
extends Node

@export var base_loot_multiplier: float = 1.0
@export var max_loot_multiplier: float = 3.0
@export var time_to_max_bonus: float = 600.0
@export var boss_wave_time: float = 480.0

var zone_entry_time: float = 0.0
var elapsed_time: float = 0.0
var current_multiplier: float = 1.0
var boss_wave_triggered: bool = false

signal time_updated(elapsed: float)
signal loot_bonus_updated(multiplier: float)
signal boss_wave_triggered

func _ready() -> void:
	zone_entry_time = Time.get_ticks_msec() / 1000.0

func _process(_delta: float) -> void:
	var current_time := Time.get_ticks_msec() / 1000.0
	elapsed_time = current_time - zone_entry_time
	
	_update_loot_multiplier()
	_check_boss_wave()
	
	time_updated.emit(elapsed_time)

func _update_loot_multiplier() -> void:
	var progress := minf(elapsed_time / time_to_max_bonus, 1.0)
	current_multiplier = base_loot_multiplier + (max_loot_multiplier - base_loot_multiplier) * progress
	
	loot_bonus_updated.emit(current_multiplier)
	GameEvents.emit_time_bonus_updated(current_multiplier)

func _check_boss_wave() -> void:
	if boss_wave_triggered:
		return
	
	if elapsed_time >= boss_wave_time:
		boss_wave_triggered = true
		boss_wave_triggered.emit()
		GameEvents.emit_boss_wave_incoming()

func get_elapsed_time() -> float:
	return elapsed_time

func get_elapsed_time_formatted() -> String:
	var minutes := int(elapsed_time) / 60
	var seconds := int(elapsed_time) % 60
	return "%02d:%02d" % [minutes, seconds]

func get_current_multiplier() -> float:
	return current_multiplier

func reset() -> void:
	zone_entry_time = Time.get_ticks_msec() / 1000.0
	elapsed_time = 0.0
	current_multiplier = base_loot_multiplier
	boss_wave_triggered = false
