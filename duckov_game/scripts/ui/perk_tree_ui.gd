class_name PerkTreeUI
extends Control

var player_data: PlayerData
var selected_perk: PerkData

func _ready() -> void:
	player_data = GameManager.get_player_data()
	
	# 连接按钮信号
	$Panel/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)
	$Panel/VBoxContainer/HBoxContainer/PerkDetails/UnlockButton.pressed.connect(_on_unlock_button_pressed)
	
	# 加载技能分支
	load_branches()

func load_branches() -> void:
	var branches = player_data.get_perk_manager().get_available_branches()
	var branch_buttons = $Panel/VBoxContainer/HBoxContainer/BranchList/BranchButtons
	
	# 清除现有按钮
	for child in branch_buttons.get_children():
		child.queue_free()
	
	# 创建分支按钮
	for branch in branches:
		var button = Button.new()
		button.text = branch
		button.pressed.connect(func(): load_perks_in_branch(branch))
		branch_buttons.add_child(button)

func load_perks_in_branch(branch_id: String) -> void:
	var perks = player_data.get_perk_manager().get_perks_by_branch(branch_id)
	var perk_grid = $Panel/VBoxContainer/HBoxContainer/PerkTree/PerkGrid
	
	# 清除现有技能按钮
	for child in perk_grid.get_children():
		child.queue_free()
	
	# 创建技能按钮
	for perk in perks:
		var button = Button.new()
		button.text = perk.perk_name
		button.pressed.connect(func(): select_perk(perk))
		
		# 设置按钮状态
		if perk.perk_id in player_data.unlocked_perks:
			button.add_theme_color_override("font_color", Color(0, 1, 0))
		else:
			var can_unlock = player_data.can_unlock_perk(perk.perk_id)
			if can_unlock.can_unlock:
				button.add_theme_color_override("font_color", Color(1, 1, 0))
			else:
				button.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
				button.disabled = true
		
		perk_grid.add_child(button)

func select_perk(perk: PerkData) -> void:
	selected_perk = perk
	
	# 更新技能详情
	$Panel/VBoxContainer/HBoxContainer/PerkDetails/PerkName.text = perk.perk_name
	$Panel/VBoxContainer/HBoxContainer/PerkDetails/PerkDescription.text = perk.description
	
	var cost = perk.get_adjusted_cost_for_level(perk.current_level + 1)
	$Panel/VBoxContainer/HBoxContainer/PerkDetails/PerkCost.text = "成本: $" + str(cost.money)
	
	# 设置解锁按钮状态
	var unlock_button = $Panel/VBoxContainer/HBoxContainer/PerkDetails/UnlockButton
	var can_unlock = player_data.can_unlock_perk(perk.perk_id)
	unlock_button.enabled = can_unlock.can_unlock
	
	if not can_unlock.can_unlock:
		unlock_button.text = "无法解锁: " + can_unlock.reason
	else:
		unlock_button.text = "解锁"

func _on_unlock_button_pressed() -> void:
	if selected_perk:
		var success = player_data.unlock_perk_by_id(selected_perk.perk_id)
		if success:
			# 重新加载技能树
			var branch_id = selected_perk.branch_id
			load_perks_in_branch(branch_id)
			# 重新选择当前技能
			select_perk(selected_perk)

func _on_close_button_pressed() -> void:
	queue_free()
