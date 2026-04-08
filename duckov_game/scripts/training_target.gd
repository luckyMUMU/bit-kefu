class_name TrainingTarget
extends Node2D

signal hit()
signal hit_count_changed(count: int)

@export var max_hits: int = 3
var current_hit_count: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_area: Area2D = $HitArea

func _ready() -> void:
	if hit_area:
		hit_area.body_entered.connect(_on_projectile_entered)
	_update_visual()

func _on_projectile_entered(body: Node2D) -> void:
	if not body.is_in_group("player_projectile"):
		return
	
	current_hit_count += 1
	hit.emit()
	hit_count_changed.emit(current_hit_count)
	
	_flash_white()
	_update_visual()

func _flash_white() -> void:
	if sprite == null:
		return
	var original := sprite.modulate
	sprite.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = original

func _update_visual() -> void:
	if sprite == null:
		return
	var ratio := float(current_hit_count) / float(max_hits)
	sprite.modulate = Color(1.0, 1.0 - ratio * 0.7, 1.0 - ratio * 0.7, 1.0)

func reset_hits() -> void:
	current_hit_count = 0
	_update_visual()

func get_hit_count() -> int:
	return current_hit_count

func is_complete() -> bool:
	return current_hit_count >= max_hits
