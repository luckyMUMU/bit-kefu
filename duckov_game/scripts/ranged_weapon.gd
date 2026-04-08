class_name RangedWeapon
extends Weapon

@export var projectile_scene: PackedScene
@export var muzzle_offset: float = 20.0

var current_ammo: int = 0
var max_ammo: int = 10
var is_reloading: bool = false
var can_fire: bool = true

signal ammo_changed(current: int, maximum: int)
signal reload_started
signal reload_completed
signal projectile_fired(projectile: Node2D)

func _ready() -> void:
	super._ready()
	if weapon_data:
		max_ammo = weapon_data.magazine_size
		current_ammo = max_ammo

func attack() -> void:
	if not can_attack() or is_reloading or current_ammo <= 0:
		return
	
	fire_projectile()

func fire_projectile() -> void:
	if not can_fire:
		return
	
	can_fire = false
	current_ammo -= 1
	ammo_changed.emit(current_ammo, max_ammo)
	
	var projectile := _create_projectile()
	if projectile:
		var spawn_position := global_position + Vector2.RIGHT.rotated(global_rotation) * muzzle_offset
		projectile.global_position = spawn_position
		projectile.rotation = global_rotation
		get_tree().current_scene.add_child(projectile)
		projectile_fired.emit(projectile)
	
	use_durability(0.1)
	
	var cooldown := get_attack_cooldown()
	await get_tree().create_timer(cooldown).timeout
	can_fire = true

func _create_projectile() -> Node2D:
	if projectile_scene:
		return projectile_scene.instantiate()
	
	var projectile := Projectile.new()
	projectile.damage = get_damage()
	projectile.speed = 500.0
	projectile.max_distance = get_range()
	projectile.owner_entity = owner_entity
	projectile.collision_mask = 2
	return projectile

func reload() -> void:
	if is_reloading or current_ammo >= max_ammo:
		return
	
	is_reloading = true
	reload_started.emit()
	
	var reload_time := weapon_data.reload_time if weapon_data else 2.0
	await get_tree().create_timer(reload_time).timeout
	
	current_ammo = max_ammo
	is_reloading = false
	reload_completed.emit()
	ammo_changed.emit(current_ammo, max_ammo)

func can_reload() -> bool:
	return not is_reloading and current_ammo < max_ammo

func get_ammo_percent() -> float:
	if max_ammo <= 0:
		return 0.0
	return float(current_ammo) / float(max_ammo)

func get_current_ammo() -> int:
	return current_ammo

func get_max_ammo() -> int:
	return max_ammo
