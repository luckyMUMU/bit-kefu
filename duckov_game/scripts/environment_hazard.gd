class_name EnvironmentHazard
extends Node2D

@export var hazard_type: String = "gas"
@export var damage_per_second: float = 5.0
@export var effect_duration: float = 10.0
@export var damage_radius: float = 100.0
@export var color: Color = Color(0.2, 0.8, 0.2, 0.5)

var active: bool = true
var affected_entities: Array[Node] = []

func _ready() -> void:
	_setup_hazard()

func _setup_hazard() -> void:
	# 创建碰撞区域
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = damage_radius
	collision_shape.shape = circle_shape
	
	var area = Area2D.new()
	area.name = "HazardArea"
	area.collision_layer = 0
	area.collision_mask = 1 | 2  # 玩家和敌人
	area.add_child(collision_shape)
	add_child(area)
	
	# 连接信号
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
	# 创建视觉效果
	var sprite = ColorRect.new()
	sprite.name = "HazardVisual"
	sprite.size = Vector2(damage_radius * 2, damage_radius * 2)
	sprite.position = Vector2(-damage_radius, -damage_radius)
	sprite.color = color
	sprite.modulate = Color(1, 1, 1, 0.3)
	add_child(sprite)
	
	# 添加粒子效果
	var particles = CPUParticles2D.new()
	particles.name = "HazardParticles"
	particles.emitting = true
	particles.lifetime = 2.0
	particles.amount = 100
	particles.speed_min = 50
	particles.speed_max = 100
	particles.spread = 360
	particles.gravity = Vector2(0, 0)
	particles.color_initial = color
	particles.color_final = Color(color.r, color.g, color.b, 0)
	add_child(particles)

func _process(delta: float) -> void:
	if active:
		_apply_damage(delta)

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_damage"):
		affected_entities.append(body)

func _on_body_exited(body: Node) -> void:
	if body in affected_entities:
		affected_entities.erase(body)

func _apply_damage(delta: float) -> void:
	for entity in affected_entities:
		if is_instance_valid(entity):
			entity.apply_damage(damage_per_second * delta, self)

func set_active(value: bool) -> void:
	active = value
	var particles = get_node_or_null("HazardParticles")
	if particles:
		particles.emitting = value

func get_hazard_type() -> String:
	return hazard_type

func get_damage_per_second() -> float:
	return damage_per_second

func get_effect_duration() -> float:
	return effect_duration
