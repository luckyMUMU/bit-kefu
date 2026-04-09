class_name MedicalUI
extends Control

var player_data: PlayerData

func _ready() -> void:
	player_data = GameManager.get_player_data()
	
	# 连接按钮信号
	$Panel/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)
	$Panel/VBoxContainer/TreatmentOptions/HealButton.pressed.connect(_on_heal_button_pressed)
	$Panel/VBoxContainer/TreatmentOptions/CureStatusButton.pressed.connect(_on_cure_status_button_pressed)
	
	# 更新状态显示
	update_status()

func update_status() -> void:
	# 更新生命值显示
	$Panel/VBoxContainer/StatusDisplay/HealthValue.text = str(int(player_data.current_health)) + "/" + str(int(player_data.max_health))
	
	# 更新设施等级显示
	var facility_level = player_data.get_facility_level("medical_station")
	$Panel/VBoxContainer/StatusDisplay/FacilityLevel.text = "医疗站等级: " + str(facility_level)
	
	# 更新治疗按钮状态
	update_heal_button()
	
	# 更新状态恢复按钮状态
	update_cure_status_button()

func update_heal_button() -> void:
	var heal_button = $Panel/VBoxContainer/TreatmentOptions/HealButton
	var missing_health = player_data.max_health - player_data.current_health
	
	if missing_health <= 0:
		heal_button.enabled = false
		heal_button.text = "生命值已满"
	else:
		var heal_cost = calculate_heal_cost(missing_health)
		heal_button.text = "治疗: $" + str(heal_cost)
		heal_button.enabled = player_data.money >= heal_cost

func update_cure_status_button() -> void:
	var cure_button = $Panel/VBoxContainer/TreatmentOptions/CureStatusButton
	# 这里简化处理，假设玩家有状态异常
	var has_status_effects = false
	
	if has_status_effects:
		var cure_cost = 1000
		cure_button.text = "恢复状态: $" + str(cure_cost)
		cure_button.enabled = player_data.money >= cure_cost
	else:
		cure_button.enabled = false
		cure_button.text = "无状态异常"

func calculate_heal_cost(health_amount: float) -> int:
	# 基础治疗成本
	var base_cost = 10
	# 每点生命值的成本
	var cost_per_health = 5
	# 设施等级折扣
	var facility_level = player_data.get_facility_level("medical_station")
	var discount = 0.1 * facility_level
	
	var total_cost = int((base_cost + health_amount * cost_per_health) * (1 - discount))
	return max(100, total_cost)  # 最低成本100

func _on_heal_button_pressed() -> void:
	var missing_health = player_data.max_health - player_data.current_health
	if missing_health > 0:
		var heal_cost = calculate_heal_cost(missing_health)
		if player_data.spend_money(heal_cost):
			# 完全治疗
			player_data.heal(missing_health)
			# 更新状态显示
			update_status()

func _on_cure_status_button_pressed() -> void:
	# 这里简化处理，假设玩家有状态异常
	var has_status_effects = false
	
	if has_status_effects:
		var cure_cost = 1000
		if player_data.spend_money(cure_cost):
			# 清除所有状态异常
			# 这里需要实现状态异常的清除逻辑
			# 更新状态显示
			update_status()

func _on_close_button_pressed() -> void:
	queue_free()