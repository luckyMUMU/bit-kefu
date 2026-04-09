class_name RangedWeapon
extends Weapon

@export var projectile_scene: PackedScene
@export var muzzle_offset: float = 20.0

var current_ammo: int = 0
var max_ammo: int = 10
var is_reloading: bool = false
var can_fire: bool = true
var equipped_ammo_id: String = ""
var attachments: Dictionary = {}

signal ammo_changed(current: int, maximum: int)
signal reload_started
signal reload_completed
signal projectile_fired(projectile: Node2D)
signal attachments_changed

func _ready() -> void:
	super._ready()
	if weapon_data:
		max_ammo = weapon_data.magazine_size
		current_ammo = max_ammo
		# 初始化附件
		if weapon_data.base_attachments:
			for attachment_id in weapon_data.base_attachments:
				# 这里应该从资源管理器加载附件数据
				# 暂时跳过具体实现
				pass

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

func get_modified_stats() -> Dictionary:
	var stats = {
		"damage": weapon_data.damage,
		"accuracy": weapon_data.accuracy,
		"fire_rate": weapon_data.fire_rate,
		"reload_time": weapon_data.reload_time,
		"magazine_size": weapon_data.magazine_size
	}
	
	# 应用附件修改器
	for attachment_id in attachments.keys():
		var attachment = attachments[attachment_id]
		if attachment:
			var modifiers = attachment.get_modifiers()
			for stat_name in modifiers.keys():
				if stats.has(stat_name):
					stats[stat_name] *= modifiers[stat_name]
	
	return stats

func get_damage() -> float:
	var base_damage = weapon_data.damage
	# 应用附件修改
	for attachment_id in attachments.keys():
		var attachment = attachments[attachment_id]
		if attachment:
			base_damage *= attachment.damage_modifier
	return base_damage

func get_accuracy() -> float:
	var base_accuracy = weapon_data.accuracy
	# 应用附件修改
	for attachment_id in attachments.keys():
		var attachment = attachments[attachment_id]
		if attachment:
			base_accuracy *= attachment.accuracy_modifier
	return base_accuracy

func get_attack_cooldown() -> float:
	var base_cooldown = 1.0 / weapon_data.fire_rate
	# 应用附件修改
	for attachment_id in attachments.keys():
		var attachment = attachments[attachment_id]
		if attachment:
			base_cooldown /= attachment.fire_rate_modifier
	return base_cooldown

func get_reload_time() -> float:
	var base_reload_time = weapon_data.reload_time
	# 应用附件修改
	for attachment_id in attachments.keys():
		var attachment = attachments[attachment_id]
		if attachment:
			base_reload_time /= attachment.reload_speed_modifier
	return base_reload_time

func equip_attachment(slot: String, attachment: AttachmentData) -> bool:
	if not weapon_data.attachment_slots.has(slot):
		return false
	
	if not attachment.get_compatibility(weapon_data.weapon_category):
		return false
	
	attachments[slot] = attachment
	# 更新弹匣容量
	if slot == "magazine":
		var old_max_ammo = max_ammo
		max_ammo = int(float(weapon_data.magazine_size) * attachment.magazine_capacity_modifier)
		# 保持当前弹药比例
		if current_ammo > 0:
			current_ammo = int(float(current_ammo) / float(old_max_ammo) * float(max_ammo))
		ammo_changed.emit(current_ammo, max_ammo)
	
	attachments_changed.emit()
	return true

func remove_attachment(slot: String) -> AttachmentData:
	if not attachments.has(slot):
		return null
	
	var removed_attachment = attachments[slot]
	attachments.erase(slot)
	
	# 恢复弹匣容量
	if slot == "magazine":
		var old_max_ammo = max_ammo
		max_ammo = weapon_data.magazine_size
		# 保持当前弹药比例
		if current_ammo > 0:
			current_ammo = int(float(current_ammo) / float(old_max_ammo) * float(max_ammo))
		ammo_changed.emit(current_ammo, max_ammo)
	
	attachments_changed.emit()
	return removed_attachment

func get_attachments() -> Dictionary:
	return attachments.duplicate()

func set_equipped_ammo(ammo_id: String) -> void:
	equipped_ammo_id = ammo_id

func get_equipped_ammo() -> String:
	return equipped_ammo_id

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
