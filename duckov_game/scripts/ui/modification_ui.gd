class_name ModificationUI
extends Control

var player_data: PlayerData
var selected_item: Variant
var selected_modification: int

func _ready() -> void:
	player_data = GameManager.get_player_data()
	
	# 连接按钮信号
	$Panel/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)
	$Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModifyButton.pressed.connect(_on_modify_button_pressed)
	
	# 加载可改装物品
	load_modifiable_items()

func load_modifiable_items() -> void:
	var item_buttons = $Panel/VBoxContainer/HBoxContainer/ItemList/ItemButtons
	
	# 清除现有按钮
	for child in item_buttons.get_children():
		child.queue_free()
	
	# 从背包中获取可改装物品
	var modifiable_items = []
	for item in player_data.inventory.items:
		if item.item_data is WeaponData or item.item_data is ArmorData:
			modifiable_items.append(item)
	
	# 创建物品按钮
	for item in modifiable_items:
		var button = Button.new()
		button.text = item.item_data.weapon_name if item.item_data is WeaponData else item.item_data.armor_name
		button.pressed.connect(func(): select_item(item.item_data))
		item_buttons.add_child(button)

func select_item(item: Variant) -> void:
	selected_item = item
	
	# 更新物品详情
	if item is WeaponData:
		$Panel/VBoxContainer/HBoxContainer/ModificationDetails/ItemName.text = item.weapon_name
		load_weapon_stats(item)
		load_weapon_modifications(item)
	elif item is ArmorData:
		$Panel/VBoxContainer/HBoxContainer/ModificationDetails/ItemName.text = item.armor_name
		load_armor_stats(item)
		load_armor_modifications(item)

func load_weapon_stats(weapon: WeaponData) -> void:
	var stat_list = $Panel/VBoxContainer/HBoxContainer/ModificationDetails/ItemStats/StatList
	
	# 清除现有属性
	for child in stat_list.get_children():
		child.queue_free()
	
	# 添加武器属性
	var stats = [
		{"name": "伤害", "value": weapon.damage},
		{"name": "射速", "value": weapon.fire_rate},
		{"name": "精度", "value": weapon.accuracy},
		{"name": "射程", "value": weapon.range},
		{"name": "弹匣容量", "value": weapon.magazine_size},
		{"name": " reload 时间", "value": weapon.reload_time},
		{"name": "重量", "value": weapon.weight},
		{"name": "噪音等级", "value": weapon.noise_level}
	]
	
	for stat in stats:
		var label = Label.new()
		label.text = stat.name + ": " + str(stat.value)
		stat_list.add_child(label)

func load_armor_stats(armor: ArmorData) -> void:
	var stat_list = $Panel/VBoxContainer/HBoxContainer/ModificationDetails/ItemStats/StatList
	
	# 清除现有属性
	for child in stat_list.get_children():
		child.queue_free()
	
	# 添加装甲属性
	var stats = [
		{"name": "防护等级", "value": armor.protection_level},
		{"name": "耐久度", "value": armor.durability},
		{"name": "最大耐久度", "value": armor.max_durability},
		{"name": "重量", "value": armor.weight},
		{"name": "移动惩罚", "value": armor.movement_penalty},
		{"name": "耐力惩罚", "value": armor.stamina_penalty},
		{"name": "转向惩罚", "value": armor.turn_speed_penalty}
	]
	
	for stat in stats:
		var label = Label.new()
		label.text = stat.name + ": " + str(stat.value)
		stat_list.add_child(label)

func load_weapon_modifications(weapon: WeaponData) -> void:
	var mod_buttons = $Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModificationOptions/ModButtons
	
	# 清除现有改装选项
	for child in mod_buttons.get_children():
		child.queue_free()
	
	# 定义可应用的改装类型
	var mod_types = [
		WeaponData.ModificationType.BARREL,
		WeaponData.ModificationType.STOCK,
		WeaponData.ModificationType.GRIP,
		WeaponData.ModificationType.SIGHT,
		WeaponData.ModificationType.MAGAZINE,
		WeaponData.ModificationType.MUZZLE,
		WeaponData.ModificationType.FOREGRIP,
		WeaponData.ModificationType.HANDGUARD
	]
	
	# 创建改装选项按钮
	for mod_type in mod_types:
		if mod_type not in weapon.modifications:
			var button = Button.new()
			button.text = player_data.get_modification_manager().get_weapon_modification_description(mod_type)
			button.pressed.connect(func(): select_weapon_modification(mod_type))
			mod_buttons.add_child(button)

func load_armor_modifications(armor: ArmorData) -> void:
	var mod_buttons = $Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModificationOptions/ModButtons
	
	# 清除现有改装选项
	for child in mod_buttons.get_children():
		child.queue_free()
	
	# 定义可应用的改装类型
	var mod_types = [
		ArmorData.ArmorModification.PLATING,
		ArmorData.ArmorModification.LINING,
		ArmorData.ArmorModification.PADDING,
		ArmorData.ArmorModification.REINFORCEMENT,
		ArmorData.ArmorModification.WEIGHT_REDUCTION
	]
	
	# 创建改装选项按钮
	for mod_type in mod_types:
		if mod_type not in armor.modifications:
			var button = Button.new()
			button.text = player_data.get_modification_manager().get_armor_modification_description(mod_type)
			button.pressed.connect(func(): select_armor_modification(mod_type))
			mod_buttons.add_child(button)

func select_weapon_modification(mod_type: int) -> void:
	selected_modification = mod_type
	var weapon = selected_item as WeaponData
	
	# 计算改装成本
	var cost = weapon.get_modification_cost(weapon.modification_level)
	$Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModCost.text = "改装成本: $" + str(cost)
	
	# 设置改装按钮状态
	var modify_button = $Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModifyButton
	var can_modify = player_data.can_modify_item(weapon)
	modify_button.enabled = can_modify
	
	if not can_modify:
		modify_button.text = "无法改装"
	else:
		modify_button.text = "改装"

func select_armor_modification(mod_type: int) -> void:
	selected_modification = mod_type
	var armor = selected_item as ArmorData
	
	# 计算改装成本
	var cost = armor.get_modification_cost(armor.modification_level)
	$Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModCost.text = "改装成本: $" + str(cost)
	
	# 设置改装按钮状态
	var modify_button = $Panel/VBoxContainer/HBoxContainer/ModificationDetails/ModifyButton
	var can_modify = player_data.can_modify_item(armor)
	modify_button.enabled = can_modify
	
	if not can_modify:
		modify_button.text = "无法改装"
	else:
		modify_button.text = "改装"

func _on_modify_button_pressed() -> void:
	if selected_item:
		var success = false
		if selected_item is WeaponData:
			success = player_data.modify_weapon(selected_item, selected_modification)
		elif selected_item is ArmorData:
			success = player_data.modify_armor(selected_item, selected_modification)
		
		if success:
			# 重新加载物品详情
			select_item(selected_item)

func _on_close_button_pressed() -> void:
	queue_free()
