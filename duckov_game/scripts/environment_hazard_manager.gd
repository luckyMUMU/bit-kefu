class_name EnvironmentHazardManager
extends Node

var hazards: Array[EnvironmentHazard] = []
var hazard_templates: Dictionary = {
	"gas": {
		"hazard_type": "gas",
		"damage_per_second": 5.0,
		"effect_duration": 10.0,
		"damage_radius": 100.0,
		"color": Color(0.2, 0.8, 0.2, 0.5)
	},
	"radiation": {
		"hazard_type": "radiation",
		"damage_per_second": 3.0,
		"effect_duration": 15.0,
		"damage_radius": 150.0,
		"color": Color(0.2, 0.6, 0.8, 0.5)
	},
	"fire": {
		"hazard_type": "fire",
		"damage_per_second": 8.0,
		"effect_duration": 8.0,
		"damage_radius": 80.0,
		"color": Color(0.8, 0.2, 0.2, 0.5)
	},
	"electric": {
		"hazard_type": "electric",
		"damage_per_second": 10.0,
		"effect_duration": 5.0,
		"damage_radius": 60.0,
		"color": Color(0.8, 0.8, 0.2, 0.5)
	}
}

func _ready() -> void:
	pass

func spawn_hazard(hazard_type: String, position: Vector2, parent: Node) -> EnvironmentHazard:
	if hazard_type not in hazard_templates:
		push_error("Unknown hazard type: " + hazard_type)
		return null
	
	var hazard = EnvironmentHazard.new()
	var template = hazard_templates[hazard_type]
	
	hazard.hazard_type = template["hazard_type"]
	hazard.damage_per_second = template["damage_per_second"]
	hazard.effect_duration = template["effect_duration"]
	hazard.damage_radius = template["damage_radius"]
	hazard.color = template["color"]
	hazard.global_position = position
	
	parent.add_child(hazard)
	hazards.append(hazard)
	
	return hazard

func spawn_hazard_at_points(hazard_type: String, positions: Array[Vector2], parent: Node) -> Array[EnvironmentHazard]:
	var spawned_hazards = []
	for position in positions:
		var hazard = spawn_hazard(hazard_type, position, parent)
		if hazard:
			spawned_hazards.append(hazard)
	return spawned_hazards

func clear_all_hazards() -> void:
	for hazard in hazards:
		if is_instance_valid(hazard):
			hazard.queue_free()
	hazards.clear()

func get_hazards_in_area(area: Rect2) -> Array[EnvironmentHazard]:
	var result = []
	for hazard in hazards:
		if is_instance_valid(hazard):
			var hazard_rect = Rect2(
				hazard.global_position - Vector2(hazard.damage_radius, hazard.damage_radius),
				Vector2(hazard.damage_radius * 2, hazard.damage_radius * 2)
			)
			if area.intersects(hazard_rect):
				result.append(hazard)
	return result

func get_hazard_by_type(hazard_type: String) -> Array[EnvironmentHazard]:
	var result = []
	for hazard in hazards:
		if is_instance_valid(hazard) and hazard.get_hazard_type() == hazard_type:
			result.append(hazard)
	return result

func set_hazard_active(hazard_type: String, active: bool) -> void:
	for hazard in get_hazard_by_type(hazard_type):
		hazard.set_active(active)

func get_total_hazards() -> int:
	return hazards.size()
