class_name ModificationManager
extends RefCounted

func _init() -> void:
	pass

func modify_weapon(weapon: WeaponData, mod_type: WeaponData.ModificationType, player_data: PlayerData) -> bool:
	if not weapon.can_modify():
		return false
	
	var cost = weapon.get_modification_cost(weapon.modification_level)
	if not player_data.spend_money(cost):
		return false
	
	var modifier = get_weapon_modifier(mod_type, weapon.modification_level + 1)
	weapon.apply_modification(mod_type, modifier)
	
	GameEvents.emit_weapon_modified(weapon.weapon_id, mod_type)
	return true

func modify_armor(armor: ArmorData, mod_type: ArmorData.ArmorModification, player_data: PlayerData) -> bool:
	if not armor.can_modify():
		return false
	
	var cost = armor.get_modification_cost(armor.modification_level)
	if not player_data.spend_money(cost):
		return false
	
	var modifier = get_armor_modifier(mod_type, armor.modification_level + 1)
	armor.apply_modification(mod_type, modifier)
	
	GameEvents.emit_armor_modified(armor.armor_id, mod_type)
	return true

func get_weapon_modifier(mod_type: WeaponData.ModificationType, level: int) -> Dictionary:
	var base_value = level * 0.1
	
	match mod_type:
		WeaponData.ModificationType.BARREL:
			return {"damage": base_value * 2, "accuracy": base_value, "range": base_value * 100}
		WeaponData.ModificationType.STOCK:
			return {"accuracy": base_value * 1.5, "recoil": -base_value}
		WeaponData.ModificationType.GRIP:
			return {"accuracy": base_value, "recoil": -base_value * 0.5}
		WeaponData.ModificationType.SIGHT:
			return {"accuracy": base_value * 2, "range": base_value * 50}
		WeaponData.ModificationType.MAGAZINE:
			return {"magazine_size": int(base_value * 5), "reload_time": -base_value * 0.2}
		WeaponData.ModificationType.MUZZLE:
			return {"noise_level": -base_value * 0.3, "recoil": -base_value * 0.3}
		WeaponData.ModificationType.FOREGRIP:
			return {"recoil": -base_value * 0.7, "accuracy": base_value * 0.5}
		WeaponData.ModificationType.HANDGUARD:
			return {"weight": -base_value * 0.2, "recoil": -base_value * 0.3}
		_:
			return {}

func get_armor_modifier(mod_type: ArmorData.ArmorModification, level: int) -> Dictionary:
	var base_value = level * 0.1
	
	match mod_type:
		ArmorData.ArmorModification.PLATING:
			return {"protection_level": int(base_value), "durability": base_value * 20}
		ArmorData.ArmorModification.LINING:
			return {"durability": base_value * 30, "weight": -base_value * 0.3}
		ArmorData.ArmorModification.PADDING:
			return {"movement_penalty": -base_value * 0.02, "stamina_penalty": -base_value * 0.02}
		ArmorData.ArmorModification.REINFORCEMENT:
			return {"protection_level": int(base_value * 0.5), "durability": base_value * 15}
		ArmorData.ArmorModification.WEIGHT_REDUCTION:
			return {"weight": -base_value * 0.5, "movement_penalty": -base_value * 0.03}
		_:
			return {}

func get_weapon_modification_description(mod_type: WeaponData.ModificationType) -> String:
	match mod_type:
		WeaponData.ModificationType.BARREL:
			return "枪管改装：提升伤害、精度和射程"
		WeaponData.ModificationType.STOCK:
			return "枪托改装：提升精度和减少后坐力"
		WeaponData.ModificationType.GRIP:
			return "握把改装：提升精度和减少后坐力"
		WeaponData.ModificationType.SIGHT:
			return "瞄准镜改装：显著提升精度和射程"
		WeaponData.ModificationType.MAGAZINE:
			return "弹匣改装：增加弹匣容量和减少 reload 时间"
		WeaponData.ModificationType.MUZZLE:
			return "枪口改装：减少噪音和后坐力"
		WeaponData.ModificationType.FOREGRIP:
			return "前握把改装：减少后坐力和提升精度"
		WeaponData.ModificationType.HANDGUARD:
			return "护木改装：减轻重量和减少后坐力"
		_:
			return "未知改装"

func get_armor_modification_description(mod_type: ArmorData.ArmorModification) -> String:
	match mod_type:
		ArmorData.ArmorModification.PLATING:
			return "装甲板：提升防护等级和耐久度"
		ArmorData.ArmorModification.LINING:
			return "内衬：提升耐久度并减轻重量"
		ArmorData.ArmorModification.PADDING:
			return "填充物：减少移动和耐力惩罚"
		ArmorData.ArmorModification.REINFORCEMENT:
			return "加固：提升防护等级和耐久度"
		ArmorData.ArmorModification.WEIGHT_REDUCTION:
			return "轻量化：显著减轻重量和移动惩罚"
		_:
			return "未知改装"

func can_modify_item(item: Variant, player_data: PlayerData) -> bool:
	if item is WeaponData:
		return item.can_modify() and player_data.get_facility_level("modification_bench") >= 1
	elif item is ArmorData:
		return item.can_modify() and player_data.get_facility_level("modification_bench") >= 1
	return false
