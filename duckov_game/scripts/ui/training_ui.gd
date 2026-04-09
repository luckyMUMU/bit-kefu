class_name TrainingUI
extends Control

var player_data: PlayerData
var selected_stat: String

func _ready() -> void:
	player_data = GameManager.get_player_data()
	
	# 连接按钮信号
	$Panel/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)
	$Panel/VBoxContainer/HBoxContainer/StatDetails/TrainButton.pressed.connect(_on_train_button_pressed)
	
	# 加载属性列表
	load_stats()
	# 更新训练点显示
	update_training_points()

func load_stats() -> void:
	var stat_buttons = $Panel/VBoxContainer/HBoxContainer/StatList/StatButtons
	
	# 清除现有按钮
	for child in stat_buttons.get_children():
		child.queue_free()
	
	# 定义可训练的属性
	var stats = ["strength", "endurance", "dexterity", "perception", "intelligence"]
	var stat_names = {"strength": "力量", "endurance": "耐力", "dexterity": "敏捷", "perception": "感知", "intelligence": "智力"}
	
	# 创建属性按钮
	for stat in stats:
		var button = Button.new()
		button.text = stat_names[stat]
		button.pressed.connect(func(): select_stat(stat))
		stat_buttons.add_child(button)

func update_training_points() -> void:
	$Panel/VBoxContainer/TrainingPoints.text = "训练点: " + str(player_data.stats.training_points)

func select_stat(stat_name: String) -> void:
	selected_stat = stat_name
	var stat_names = {"strength": "力量", "endurance": "耐力", "dexterity": "敏捷", "perception": "感知", "intelligence": "智力"}
	
	# 更新属性详情
	$Panel/VBoxContainer/HBoxContainer/StatDetails/StatName.text = stat_names[stat_name]
	
	# 获取当前属性值
	var stat_value = player_data.stats[stat_name]
	$Panel/VBoxContainer/HBoxContainer/StatDetails/StatValue.text = "当前值: " + str(stat_value)
	
	# 更新效果列表
	load_stat_effects(stat_name, stat_value)
	
	# 计算训练成本
	var current_level = player_data.stats.training_levels[stat_name]
	var cost = player_data.get_training_manager().get_training_cost(player_data, stat_name, 1)
	$Panel/VBoxContainer/HBoxContainer/StatDetails/TrainingCost.text = "训练成本: $" + str(cost)
	
	# 设置训练按钮状态
	var train_button = $Panel/VBoxContainer/HBoxContainer/StatDetails/TrainButton
	var can_train = player_data.can_train_stat(stat_name, 1)
	train_button.enabled = can_train.can_train
	
	if not can_train.can_train:
		train_button.text = "无法训练: " + can_train.reason
	else:
		train_button.text = "训练"

func load_stat_effects(stat_name: String, value: float) -> void:
	var effect_list = $Panel/VBoxContainer/HBoxContainer/StatDetails/StatEffects/EffectList
	
	# 清除现有效果
	for child in effect_list.get_children():
		child.queue_free()
	
	# 获取属性效果
	var effects = player_data.get_training_manager().get_stat_effects(stat_name, value)
	
	# 创建效果标签
	for effect in effects:
		var label = Label.new()
		label.text = effect
		effect_list.add_child(label)

func _on_train_button_pressed() -> void:
	if selected_stat:
		var success = player_data.train_stat(selected_stat, 1)
		if success:
			# 更新训练点显示
			update_training_points()
			# 重新选择当前属性
			select_stat(selected_stat)

func _on_close_button_pressed() -> void:
	queue_free()
