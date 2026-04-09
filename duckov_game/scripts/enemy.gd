class_name Enemy
extends CharacterBody2D

@export var enemy_data: EnemyData

var current_health: float = 50.0
var max_health: float = 50.0
var move_speed: float = 100.0
var damage: float = 10.0
var detection_range: float = 300.0
var attack_range: float = 50.0
var attack_cooldown: float = 1.0

var accuracy: float = 0.8
var fire_rate: float = 1.0
var bullet_speed: float = 300.0
var reload_time: float = 2.0
var magazine_size: int = 10
var current_ammo: int = 10
var is_shielded: bool = false
var shield_strength: float = 0.0
var critical_chance: float = 0.0
var critical_multiplier: float = 1.5
var detection_angle: float = 180.0
var patrol_speed: float = 50.0
var chase_speed: float = 100.0
var retreat_distance: float = 100.0
var cover_chance: float = 0.0
var flanking_chance: float = 0.0

var state: String = "idle"
var target: Node2D = null
var last_known_target_position: Vector2 = Vector2.ZERO
var attack_timer: float = 0.0
var patrol_points: Array = []
var current_patrol_index: int = 0
var is_alerted: bool = false
var is_attacking: bool = false
var is_showing_warning: bool = false
var is_reloading: bool = false
var reload_timer: float = 0.0
var fire_timer: float = 0.0
var current_behavior: String = ""

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea
@onready var vision_cone: VisionCone = $VisionCone

signal state_changed(new_state: String)
signal target_detected(target: Node2D)
signal target_lost
signal attack_started
signal attack_completed
signal died

func _ready() -> void:
	add_to_group("enemies")
	_initialize_from_data()
	_setup_signals()
	
	if detection_area:
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	if attack_area:
		attack_area.body_entered.connect(_on_attack_area_body_entered)
		attack_area.body_exited.connect(_on_attack_area_body_exited)
	
	if health_component:
		health_component.died.connect(_on_died)
		health_component.health_changed.connect(_on_health_changed)
	
	# 监听天气和时间变化
	GameEvents.on_weather_effects_updated.connect(_on_weather_effects_updated)
	# 初始应用天气效果
	_on_weather_effects_updated(WeatherManager.get_weather_effects())

func _initialize_from_data() -> void:
	if enemy_data == null:
		return
	
	max_health = enemy_data.max_health
	current_health = max_health
	move_speed = enemy_data.move_speed
	damage = enemy_data.damage
	detection_range = enemy_data.detection_range
	attack_range = enemy_data.attack_range
	attack_cooldown = enemy_data.attack_cooldown
	accuracy = enemy_data.accuracy
	fire_rate = enemy_data.fire_rate
	bullet_speed = enemy_data.bullet_speed
	reload_time = enemy_data.reload_time
	magazine_size = enemy_data.magazine_size
	current_ammo = enemy_data.current_ammo
	is_shielded = enemy_data.is_shielded
	shield_strength = enemy_data.shield_strength
	critical_chance = enemy_data.critical_chance
	critical_multiplier = enemy_data.critical_multiplier
	detection_angle = enemy_data.detection_angle
	patrol_speed = enemy_data.patrol_speed
	chase_speed = enemy_data.chase_speed
	retreat_distance = enemy_data.retreat_distance
	cover_chance = enemy_data.cover_chance
	flanking_chance = enemy_data.flanking_chance
	
	# 设置初始行为
	match enemy_data.behavior_type:
		EnemyData.BehaviorType.PATROL:
			current_behavior = "patrol"
		EnemyData.BehaviorType.CHASE:
			current_behavior = "chase"
		EnemyData.BehaviorType.RANGED:
			current_behavior = "ranged"
		EnemyData.BehaviorType.HYBRID:
			current_behavior = "hybrid"
		EnemyData.BehaviorType.SNIPER:
			current_behavior = "sniper"

func _setup_signals() -> void:
	pass

func _physics_process(delta: float) -> void:
	# 优化：只有在激活状态下才进行复杂计算
	if not is_visible_in_tree():
		return
	
	match state:
		"idle":
			_process_idle(delta)
		"patrol":
			_process_patrol(delta)
		"chase":
			_process_chase(delta)
		"attack":
			_process_attack(delta)
		"ranged":
			_process_ranged(delta)
		"sniper":
			_process_sniper(delta)
		"return":
			_process_return(delta)
		"reload":
			_process_reload(delta)
	
	# 优化：使用本地变量减少属性访问
	attack_timer = maxf(0.0, attack_timer - delta)
	fire_timer = maxf(0.0, fire_timer - delta)
	reload_timer = maxf(0.0, reload_timer - delta)
	move_and_slide()

# 优化：添加对象池支持
static var enemy_pool: Array[Enemy] = []
static var max_pool_size: int = 20

static func get_enemy() -> Enemy:
	if enemy_pool.size() > 0:
		var enemy = enemy_pool.pop_back()
		enemy.reset()
		return enemy
	return null

static func return_enemy(enemy: Enemy) -> void:
	if enemy_pool.size() < max_pool_size:
		enemy_pool.append(enemy)

func reset() -> void:
	# 重置敌人状态
	state = "idle"
	target = null
	last_known_target_position = Vector2.ZERO
	attack_timer = 0.0
	fire_timer = 0.0
	reload_timer = 0.0
	is_alerted = false
	is_attacking = false
	is_showing_warning = false
	is_reloading = false
	current_ammo = enemy_data.current_ammo
	if is_shielded:
		shield_strength = enemy_data.shield_strength
	_initialize_from_data()

func _process_idle(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)
	
	if target and is_instance_valid(target):
		change_state("chase")

func _process_patrol(_delta: float) -> void:
	if patrol_points.is_empty():
		change_state("idle")
		return
	
	var target_point: Vector2 = patrol_points[current_patrol_index]
	var direction := (target_point - global_position).normalized()
	velocity = direction * move_speed * 0.5
	
	if global_position.distance_to(target_point) < 10.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
	
	if target and is_instance_valid(target):
		change_state("chase")

func _process_chase(_delta: float) -> void:
	if target == null or not is_instance_valid(target):
		change_state("return")
		return
	
	var distance := global_position.distance_to(target.global_position)
	
	if distance <= attack_range:
		change_state("attack")
		return
	
	if distance > detection_range * 1.5:
		last_known_target_position = target.global_position
		change_state("return")
		return
	
	var direction := (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	
	_update_facing(direction)

func _process_attack(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.2)
	
	if target == null or not is_instance_valid(target):
		change_state("return")
		return
	
	var distance := global_position.distance_to(target.global_position)
	
	if distance > attack_range * 1.2:
		change_state("chase")
		return
	
	if attack_timer <= 0.0 and not is_attacking:
		perform_attack()

func _process_return(_delta: float) -> void:
	if target and is_instance_valid(target):
		if global_position.distance_to(target.global_position) <= detection_range:
			change_state("chase")
			return
	
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)
	change_state("idle")

func _process_ranged(_delta: float) -> void:
	if target == null or not is_instance_valid(target):
		change_state("return")
		return
	
	var distance := global_position.distance_to(target.global_position)
	
	if distance > attack_range * 1.5:
		change_state("chase")
		return
	
	if distance < attack_range * 0.5:
		_retreat_from_target()
		return
	
	# 保持距离并攻击
	var direction := (target.global_position - global_position).normalized()
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.2)
	
	# 面向目标
	_update_facing(direction)
	
	# 检查是否需要换弹
	if current_ammo <= 0:
		change_state("reload")
		return
	
	# 攻击
	if fire_timer <= 0.0:
		_perform_ranged_attack()

func _process_sniper(_delta: float) -> void:
	if target == null or not is_instance_valid(target):
		change_state("return")
		return
	
	var distance := global_position.distance_to(target.global_position)
	
	if distance > detection_range * 0.8:
		change_state("chase")
		return
	
	if distance < attack_range * 0.8:
		_retreat_from_target()
		return
	
	# 保持距离并攻击
	var direction := (target.global_position - global_position).normalized()
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)
	
	# 面向目标
	_update_facing(direction)
	
	# 检查是否需要换弹
	if current_ammo <= 0:
		change_state("reload")
		return
	
	# 狙击攻击（更慢但更精准）
	if fire_timer <= 0.0:
		_perform_sniper_attack()

func _process_reload(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)
	
	if reload_timer <= 0.0:
		current_ammo = magazine_size
		is_reloading = false
		change_state(current_behavior)

func _retreat_from_target() -> void:
	if target == null:
		return
	
	var direction := (global_position - target.global_position).normalized()
	velocity = direction * move_speed * 1.2
	
	_update_facing(direction)

func perform_attack() -> void:
	if is_attacking or target == null:
		return
	
	is_attacking = true
	attack_started.emit()
	
	if enemy_data and enemy_data.has_attack_warning:
		is_showing_warning = true
		_show_attack_warning()
		await get_tree().create_timer(enemy_data.attack_warning_duration).timeout
		is_showing_warning = false
	
	if target and is_instance_valid(target):
		_apply_damage_to_target(target)
	
	attack_timer = attack_cooldown
	is_attacking = false
	attack_completed.emit()

func _perform_ranged_attack() -> void:
	if target == null or not is_instance_valid(target):
		return
	
	current_ammo -= 1
	fire_timer = 1.0 / fire_rate
	
	# 计算子弹方向，加入精度误差
	var direction := (target.global_position - global_position).normalized()
	var accuracy_offset := Vector2(randf_range(-1.0 + accuracy, 1.0 - accuracy), randf_range(-1.0 + accuracy, 1.0 - accuracy))
	direction += accuracy_offset * 0.1
	direction = direction.normalized()
	
	# 发射子弹
	_spawn_projectile(direction)

func _perform_sniper_attack() -> void:
	if target == null or not is_instance_valid(target):
		return
	
	current_ammo -= 1
	fire_timer = 2.0 / fire_rate  # 狙击枪射速更慢
	
	# 计算子弹方向，高精度
	var direction := (target.global_position - global_position).normalized()
	var accuracy_offset := Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
	direction += accuracy_offset * 0.05
	direction = direction.normalized()
	
	# 发射子弹
	_spawn_projectile(direction, true)

func _spawn_projectile(direction: Vector2, is_sniper: bool = false) -> void:
	# 这里需要根据游戏的子弹系统实现
	# 暂时使用简化的实现
	var damage_amount := damage
	
	# 狙击枪造成更高伤害
	if is_sniper:
		damage_amount *= 2.0
	
	# 检查是否暴击
	if randf() < critical_chance:
		damage_amount *= critical_multiplier
	
	# 应用伤害
	if target and is_instance_valid(target):
		_apply_damage_to_target(target, damage_amount)

func _show_attack_warning() -> void:
	if sprite:
		var original_color := sprite.modulate
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = original_color
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = original_color

func _apply_damage_to_target(target_node: Node2D, damage_amount: float = -1.0) -> void:
	var dmg := damage if damage_amount < 0 else damage_amount
	
	if target_node.has_method("take_damage"):
		target_node.take_damage(dmg, self)
	elif target_node.has_node("HealthComponent"):
		var health := target_node.get_node("HealthComponent")
		health.take_damage(dmg, self)

func change_state(new_state: String) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(new_state)

func _update_facing(direction: Vector2) -> void:
	if sprite:
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false

func take_damage(amount: float, source: Node = null) -> void:
	# 处理护盾
	if is_shielded and shield_strength > 0:
		shield_strength -= amount
		if shield_strength <= 0:
			shield_strength = 0
			is_shielded = false
		return
	
	if health_component:
		health_component.take_damage(amount, source)
	
	if source and source.is_in_group("player"):
		target = source
		is_alerted = true
		if state != "chase" and state != "attack" and state != "ranged" and state != "sniper":
			change_state("chase")

func die() -> void:
	died.emit()
	_drop_loot()
	GameEvents.emit_enemy_died(self)
	
	# 优化：返回对象池而不是直接销毁
	remove_from_parent()
	Enemy.return_enemy(self)

func _drop_loot() -> void:
	if enemy_data == null:
		return
	
	var money_drop := enemy_data.get_random_money_drop()
	GameManager.player_data.add_money(money_drop)
	
	var loot := enemy_data.get_random_loot()
	for loot_entry in loot:
		var item := InventoryItem.new()
		item.item_id = loot_entry.get("item_id", "")
		item.quantity = loot_entry.get("quantity", 1)
		_spawn_loot_item(item)

func _spawn_loot_item(item: InventoryItem) -> void:
	var loot_scene := preload("res://scenes/loot_item.tscn")
	var loot_node := loot_scene.instantiate()
	loot_node.item = item
	loot_node.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
	get_tree().current_scene.add_child(loot_node)

func set_patrol_points(points: Array) -> void:
	patrol_points = points
	if not patrol_points.is_empty():
		change_state("patrol")

func get_state() -> String:
	return state

func has_target() -> bool:
	return target != null and is_instance_valid(target)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		is_alerted = true
		target_detected.emit(body)
		
		# 根据行为类型决定进入什么状态
		match current_behavior:
			"ranged":
				change_state("ranged")
			"sniper":
				change_state("sniper")
			else:
				change_state("chase")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		last_known_target_position = target.global_position
		target = null
		target_lost.emit()

func _on_attack_area_body_entered(body: Node2D) -> void:
	pass

func _on_attack_area_body_exited(body: Node2D) -> void:
	pass

func _on_died() -> void:
	die()

func _on_health_changed(current: float, maximum: float) -> void:
	current_health = current
	max_health = maximum

func _on_weather_effects_updated(effects: Dictionary) -> void:
	# 更新敌人属性以响应天气和时间变化
	var base_detection_range := enemy_data.detection_range if enemy_data else 300.0
	var base_accuracy := enemy_data.accuracy if enemy_data else 0.8
	var base_move_speed := enemy_data.move_speed if enemy_data else 100.0
	
	# 应用天气和时间效果
	detection_range = base_detection_range * effects.enemy_aggro_range_modifier
	accuracy = base_accuracy * effects.enemy_accuracy_modifier
	move_speed = base_move_speed * effects.movement_modifier
	chase_speed = base_move_speed * effects.movement_modifier
	patrol_speed = base_move_speed * effects.movement_modifier * 0.5
