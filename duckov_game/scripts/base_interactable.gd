class_name BaseInteractable
extends Area2D

@export var interactable_type: String = "storage"
@export var display_name: String = "Storage"

var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		GameEvents.emit_interactable_available(self, display_name)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		GameEvents.emit_interactable_unavailable(self)

func interact() -> void:
	match interactable_type:
		"storage":
			var base = get_parent().get_parent()
			if base and base.has_method("open_storage"):
				base.open_storage()
		"workbench":
			var base = get_parent().get_parent()
			if base and base.has_method("open_workbench"):
				base.open_workbench()
		"blueprint_station":
			var base = get_parent().get_parent()
			if base and base.has_method("open_blueprint_station"):
				base.open_blueprint_station()
		"medical_station":
			var base = get_parent().get_parent()
			if base and base.has_method("open_medical_station"):
				base.open_medical_station()
		"gym":
			var base = get_parent().get_parent()
			if base and base.has_method("open_gym"):
				base.open_gym()
		"zone_exit":
			var base = get_parent()
			if base and base.has_method("go_to_zone"):
				base.go_to_zone("zone_1")