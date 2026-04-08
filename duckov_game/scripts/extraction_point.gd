class_name ExtractionPoint
extends Area2D

@export var extraction_time: float = 5.0
@export var is_active: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D

var player_in_zone: bool = false
var extraction_progress: float = 0.0
var extracting_player: Player = null

signal extraction_started
signal extraction_progress_updated(progress: float)
signal extraction_completed
signal extraction_cancelled

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if particles:
		particles.emitting = is_active
	
	if sprite:
		sprite.modulate = Color(0.2, 0.8, 0.2, 0.5) if is_active else Color(0.5, 0.5, 0.5, 0.5)

func _process(delta: float) -> void:
	if player_in_zone and is_active:
		if Input.is_action_pressed("interact"):
			_process_extraction(delta)
		else:
			_cancel_extraction()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_active:
		player_in_zone = true
		extracting_player = body
		GameEvents.emit_extraction_available(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_zone = false
		_cancel_extraction()

func _process_extraction(delta: float) -> void:
	if extraction_progress == 0.0:
		extraction_started.emit()
		GameEvents.emit_extraction_started()
	
	extraction_progress += delta / extraction_time
	extraction_progress_updated.emit(extraction_progress)
	
	_update_hud_progress()
	
	if extraction_progress >= 1.0:
		_complete_extraction()

func _cancel_extraction() -> void:
	if extraction_progress > 0.0:
		extraction_progress = 0.0
		extraction_cancelled.emit()
		_update_hud_progress()

func _complete_extraction() -> void:
	extraction_completed.emit()
	
	if extracting_player:
		GameManager.player_extracted()

func _update_hud_progress() -> void:
	var hud := _get_hud()
	if hud and hud.has_method("update_extraction_progress"):
		hud.update_extraction_progress(extraction_progress)
		hud.hide_extraction_progress() if extraction_progress <= 0.0 else null

func _get_hud() -> Node:
	var scene := get_tree().current_scene
	if scene:
		return scene.find_child("GameHUD", true, false)
	return null

func activate() -> void:
	is_active = true
	if sprite:
		sprite.modulate = Color(0.2, 0.8, 0.2, 0.5)
	if particles:
		particles.emitting = true

func deactivate() -> void:
	is_active = false
	if sprite:
		sprite.modulate = Color(0.5, 0.5, 0.5, 0.5)
	if particles:
		particles.emitting = false
	_cancel_extraction()
