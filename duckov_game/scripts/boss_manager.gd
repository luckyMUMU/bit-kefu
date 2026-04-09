class_name BossManager
extends Node

var bosses: Array[Boss] = []
var boss_templates: Dictionary = {
	"boss_1": {
		"script": "res://scripts/bosses/gas_boss.gd",
		"health": 1000,
		"damage": 30,
		"armor": 50,
		"move_speed": 100,
		"attack_cooldown": 2.0
	},
	"boss_2": {
		"script": "res://scripts/bosses/radiation_boss.gd",
		"health": 1500,
		"damage": 40,
		"armor": 70,
		"move_speed": 80,
		"attack_cooldown": 1.5
	},
	"boss_final": {
		"script": "res://scripts/bosses/final_boss.gd",
		"health": 2500,
		"damage": 50,
		"armor": 100,
		"move_speed": 120,
		"attack_cooldown": 1.0
	}
}

func _ready() -> void:
	pass

func spawn_boss(boss_id: String, position: Vector2, parent: Node) -> Boss:
	if boss_id not in boss_templates:
		push_error("Unknown boss id: " + boss_id)
		return null
	
	var template = boss_templates[boss_id]
	var boss_script = load(template["script"])
	if not boss_script:
		push_error("Failed to load boss script: " + template["script"])
		return null
	
	var boss = boss_script.new()
	boss.global_position = position
	boss.max_health = template["health"]
	boss.current_health = template["health"]
	boss.damage = template["damage"]
	boss.armor = template["armor"]
	boss.move_speed = template["move_speed"]
	boss.attack_cooldown = template["attack_cooldown"]
	
	parent.add_child(boss)
	bosses.append(boss)
	
	# 触发Boss生成事件
	GameEvents.emit_boss_spawned(boss_id)
	
	return boss

func get_boss_by_id(boss_id: String) -> Boss:
	for boss in bosses:
		if is_instance_valid(boss) and boss.get_boss_id() == boss_id:
			return boss
	return null

func get_all_bosses() -> Array[Boss]:
	return bosses

func clear_all_bosses() -> void:
	for boss in bosses:
		if is_instance_valid(boss):
			boss.queue_free()
	bosses.clear()

func is_boss_alive(boss_id: String) -> bool:
	var boss = get_boss_by_id(boss_id)
	return boss != null and is_instance_valid(boss) and boss.current_health > 0

func get_boss_health_percentage(boss_id: String) -> float:
	var boss = get_boss_by_id(boss_id)
	if boss and is_instance_valid(boss):
		return boss.current_health / boss.max_health
	return 0.0
