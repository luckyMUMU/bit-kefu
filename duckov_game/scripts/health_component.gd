class_name HealthComponent
extends Node

@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var defense: float = 0.0
@export var invincibility_duration: float = 0.5

var is_invincible: bool = false
var is_dead: bool = false
var equipped_armor: Dictionary = {} # 装备的护甲，按部位存储

signal health_changed(current: float, maximum: float)
signal damaged(amount: float, source: Node)
signal healed(amount: float)
signal died
signal invincibility_started
signal invincibility_ended

func _ready() -> void:
	current_health = mini(current_health, max_health)

func take_damage(amount: float, source: Node = null, ammo_data: AmmoData = null) -> void:
	if is_dead or is_invincible:
		return
	
	# 应用护甲防护
	var armor_protection = get_armor_protection()
	var actual_damage := maxf(0.0, amount - defense)
	
	# 考虑护甲减免
	if armor_protection > 0:
		# 考虑弹药的穿透力
		if ammo_data:
			armor_protection *= (1.0 - ammo_data.get_penetration_power() * 0.1)
		actual_damage *= (1.0 - armor_protection)
	
	# 确保至少造成1点伤害
	actual_damage = maxf(1.0, actual_damage)
	
	current_health = maxf(0.0, current_health - actual_damage)
	
	# 损坏护甲
	damage_armor(amount)
	
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

func equip_armor(armor: ArmorData) -> bool:
	var armor_type = armor.armor_type
	equipped_armor[armor_type] = armor
	return true

func remove_armor(armor_type: int) -> ArmorData:
	if equipped_armor.has(armor_type):
		var removed_armor = equipped_armor[armor_type]
		equipped_armor.erase(armor_type)
		return removed_armor
	return null

func get_armor_protection() -> float:
	var total_protection = 0.0
	var total_coverage = 0.0
	
	for armor in equipped_armor.values():
		if not armor.is_destroyed():
			total_protection += armor.get_protection_factor()
			total_coverage += 1.0
	
	if total_coverage > 0:
		return total_protection / total_coverage
	return 0.0

func get_armor_movement_penalty() -> float:
	var total_penalty = 0.0
	var armor_count = 0
	
	for armor in equipped_armor.values():
		if not armor.is_destroyed():
			total_penalty += armor.movement_penalty
			armor_count += 1
	
	return total_penalty

func get_armor_stamina_penalty() -> float:
	var total_penalty = 0.0
	var armor_count = 0
	
	for armor in equipped_armor.values():
		if not armor.is_destroyed():
			total_penalty += armor.stamina_penalty
			armor_count += 1
	
	return total_penalty

func get_armor_turn_speed_penalty() -> float:
	var total_penalty = 0.0
	var armor_count = 0
	
	for armor in equipped_armor.values():
		if not armor.is_destroyed():
			total_penalty += armor.turn_speed_penalty
			armor_count += 1
	
	return total_penalty

func damage_armor(damage: float) -> void:
	for armor in equipped_armor.values():
		if not armor.is_destroyed():
			armor.damage_durability(damage)
