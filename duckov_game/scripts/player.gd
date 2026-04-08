class_name Player
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var carry_capacity: float = 50.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var weapon_holder: Node2D = $WeaponHolder
@onready var interaction_area: Area2D = $InteractionArea
@onready var vision_cone: Node2D = $VisionCone

var is_alive: bool = true
var is_attacking: bool = false
var can_move: bool = true
var facing_direction: Vector2 = Vector2.DOWN
var current_weapon: Weapon = null
var nearby_interactables: Array = []

signal health_changed(current: float, maximum: float)
signal died
signal weapon_changed(weapon: Weapon)

func _ready() -> void:
	add_to_group("player")
	
	if health_component:
		health_component.died.connect(_on_died)
		health_component.health_changed.connect(_on_health_changed)
		health_component.max_health = max_health
		health_component.current_health = current_health
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_area_body_entered)
		interaction_area.body_exited.connect(_on_interaction_area_body_exited)
		interaction_area.area_entered.connect(_on_interaction_area_area_entered)
		interaction_area.area_exited.connect(_on_interaction_area_area_exited)

func _physics_process(delta: float) -> void:
	if not is_alive or not can_move:
		return
	
	var input_direction := _get_input_direction()
	
	if input_direction != Vector2.ZERO:
		facing_direction = input_direction.normalized()
		velocity = input_direction * move_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * delta * 5.0)
	
	_update_facing()
	move_and_slide()
	_update_animation()

func _process(_delta: float) -> void:
	if not is_alive:
		return
	
	_update_aim_direction()
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if Input.is_action_just_pressed("reload"):
		reload_weapon()

func _get_input_direction() -> Vector2:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	return direction.normalized()

func _update_facing() -> void:
	if facing_direction.x < 0:
		sprite.flip_h = true
	elif facing_direction.x > 0:
		sprite.flip_h = false

func _update_aim_direction() -> void:
	var mouse_pos := get_global_mouse_position()
	var aim_direction := (mouse_pos - global_position).normalized()
	
	if vision_cone and vision_cone.has_method("set_direction"):
		vision_cone.set_direction(aim_direction)
	
	if weapon_holder:
		weapon_holder.rotation = aim_direction.angle()

func _update_animation() -> void:
	if velocity.length() > 0:
		pass
	else:
		pass

func attack() -> void:
	if is_attacking or current_weapon == null:
		return
	
	is_attacking = true
	current_weapon.attack()
	
	await get_tree().create_timer(current_weapon.get_attack_cooldown()).timeout
	is_attacking = false

func reload_weapon() -> void:
	if current_weapon and current_weapon.has_method("reload"):
		current_weapon.reload()

func interact() -> void:
	if nearby_interactables.is_empty():
		return
	
	var closest: Node = null
	var closest_distance: float = INF
	
	for interactable in nearby_interactables:
		if interactable.has_method("can_interact") and not interactable.can_interact():
			continue
		var distance := global_position.distance_to(interactable.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = interactable
	
	if closest and closest.has_method("interact"):
		closest.interact(self)

func equip_weapon(weapon: Weapon) -> void:
	if current_weapon:
		unequip_weapon()
	
	current_weapon = weapon
	if weapon_holder:
		weapon.reparent(weapon_holder)
		weapon.position = Vector2.ZERO
	
	weapon_changed.emit(weapon)

func unequip_weapon() -> Weapon:
	if current_weapon == null:
		return null
	
	var weapon := current_weapon
	current_weapon = null
	
	if weapon_holder and weapon.get_parent() == weapon_holder:
		weapon.reparent(get_tree().current_scene)
	
	weapon_changed.emit(null)
	return weapon

func take_damage(amount: float, source: Node = null) -> void:
	if health_component:
		health_component.take_damage(amount, source)

func heal(amount: float) -> void:
	if health_component:
		health_component.heal(amount)

func die() -> void:
	if not is_alive:
		return
	
	is_alive = false
	can_move = false
	
	if current_weapon:
		current_weapon.drop()
	
	died.emit()
	GameManager.player_died()

func _on_died() -> void:
	die()

func _on_health_changed(current: float, maximum: float) -> void:
	current_health = current
	max_health = maximum
	health_changed.emit(current, maximum)

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.has_method("interact"):
		nearby_interactables.append(body)

func _on_interaction_area_body_exited(body: Node2D) -> void:
	nearby_interactables.erase(body)

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.has_method("interact") or area.get_parent().has_method("interact"):
		var target := area if area.has_method("interact") else area.get_parent()
		nearby_interactables.append(target)

func _on_interaction_area_area_exited(area: Area2D) -> void:
	var target := area if area.has_method("interact") else area.get_parent()
	nearby_interactables.erase(target)

func get_facing_direction() -> Vector2:
	return facing_direction

func get_current_weight() -> float:
	return GameManager.player_data.inventory.get_total_weight()

func is_overburdened() -> bool:
	return get_current_weight() > carry_capacity

func get_nearby_interactables() -> Array:
	return nearby_interactables.duplicate()
