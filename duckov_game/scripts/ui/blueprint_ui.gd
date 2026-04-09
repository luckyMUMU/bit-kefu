class_name BlueprintUI
extends Control

var player_data: PlayerData
var selected_blueprint: Dictionary

func _ready() -> void:
	player_data = GameManager.get_player_data()
	
	# 连接按钮信号
	$Panel/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)
	$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/ResearchButton.pressed.connect(_on_research_button_pressed)
	
	# 加载蓝图列表
	load_blueprints()

func load_blueprints() -> void:
	var blueprint_buttons = $Panel/VBoxContainer/HBoxContainer/BlueprintList/BlueprintButtons
	
	# 清除现有按钮
	for child in blueprint_buttons.get_children():
		child.queue_free()
	
	# 定义可研究的蓝图
	var blueprints = [
		{"id": "advanced_weapons", "name": "高级武器", "description": "解锁高级武器配方", "cost": 5000, "required_level": 1},
		{"id": "advanced_armor", "name": "高级护甲", "description": "解锁高级护甲配方", "cost": 4000, "required_level": 1},
		{"id": "special_ammo", "name": "特殊弹药", "description": "解锁特殊弹药配方", "cost": 3000, "required_level": 1},
		{"id": "medical_supplies", "name": "医疗用品", "description": "解锁高级医疗用品配方", "cost": 2500, "required_level": 1},
		{"id": "engineering", "name": "工程学", "description": "解锁高级工程配方", "cost": 6000, "required_level": 2}
	]
	
	# 创建蓝图按钮
	for blueprint in blueprints:
		var button = Button.new()
		button.text = blueprint.name
		button.pressed.connect(func(): select_blueprint(blueprint))
		blueprint_buttons.add_child(button)

func select_blueprint(blueprint: Dictionary) -> void:
	selected_blueprint = blueprint
	
	# 更新蓝图详情
	$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/BlueprintName.text = blueprint.name
	$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/BlueprintDescription.text = blueprint.description
	$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/ResearchCost.text = "研究成本: $" + str(blueprint.cost)
	
	# 设置研究按钮状态
	var research_button = $Panel/VBoxContainer/HBoxContainer/BlueprintDetails/ResearchButton
	var can_research = can_research_blueprint(blueprint)
	research_button.enabled = can_research.can_research
	
	if not can_research.can_research:
		research_button.text = "无法研究: " + can_research.reason
	else:
		research_button.text = "研究"

func can_research_blueprint(blueprint: Dictionary) -> Dictionary:
	# 检查是否已经解锁
	if blueprint.id in player_data.unlocked_recipes:
		return {"can_research": false, "reason": "已经研究过"}
	
	# 检查金钱是否足够
	if player_data.money < blueprint.cost:
		return {"can_research": false, "reason": "金钱不足"}
	
	# 检查设施等级是否足够
	var facility_level = player_data.get_facility_level("blueprint_station")
	if facility_level < blueprint.required_level:
		return {"can_research": false, "reason": "研究站等级不足"}
	
	return {"can_research": true, "reason": ""}

func _on_research_button_pressed() -> void:
	if selected_blueprint:
		var success = research_blueprint(selected_blueprint)
		if success:
			# 重新加载蓝图列表
			load_blueprints()
			# 清除选择
			selected_blueprint = null
			# 清除详情
			$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/BlueprintName.text = ""
			$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/BlueprintDescription.text = ""
			$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/ResearchCost.text = ""
			$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/ResearchButton.text = "研究"
			$Panel/VBoxContainer/HBoxContainer/BlueprintDetails/ResearchButton.enabled = false

func research_blueprint(blueprint: Dictionary) -> bool:
	# 扣除金钱
	if not player_data.spend_money(blueprint.cost):
		return false
	
	# 解锁配方
	player_data.unlock_recipe(blueprint.id)
	
	return true

func _on_close_button_pressed() -> void:
	queue_free()