class_name TrainingManager
extends RefCounted

func _init() -> void:
	pass

func gain_training_points(player_data: PlayerData, points: int) -> void:
	player_data.stats.add_training_points(points)
	GameEvents.emit_training_points_gained(points)

func train_stat(player_data: PlayerData, stat_name: String, points: int = 1) -> bool:
	var can_train = can_train_stat(player_data, stat_name, points)
	if not can_train.can_train:
		return false
	
	var cost = get_training_cost(player_data, stat_name, points)
	if not player_data.spend_money(cost):
		return false
	
	return player_data.stats.train_stat(stat_name, points)

func can_train_stat(player_data: PlayerData, stat_name: String, points: int = 1) -> Dictionary:
	if stat_name not in player_data.stats.training_levels:
		return {"can_train": false, "reason": "Invalid stat name"}
	
	if player_data.stats.training_points < points:
		return {"can_train": false, "reason": "Not enough training points"}
	
	var current_level = player_data.stats.training_levels[stat_name]
	var cost = get_training_cost(player_data, stat_name, points)
	if player_data.money < cost:
		return {"can_train": false, "reason": "Not enough money"}
	
	if player_data.get_facility_level("training_room") < get_required_facility_level(current_level + points):
		return {"can_train": false, "reason": "Training room level too low"}
	
	return {"can_train": true, "reason": ""}

func get_training_cost(player_data: PlayerData, stat_name: String, points: int = 1) -> int:
	var current_level = player_data.stats.training_levels[stat_name]
	var total_cost = 0
	
	for i in range(points):
		total_cost += player_data.stats.get_training_cost(stat_name, current_level + i)
	
	return total_cost

func get_required_facility_level(training_level: int) -> int:
	# 每5级需要提升一次训练室等级
	return int(training_level / 5) + 1

func get_stat_description(stat_name: String) -> String:
	match stat_name:
		"strength":
			return "提升力量可以增加负重能力和近战伤害"
		"endurance":
			return "提升耐力可以增加生命值和健康恢复速度"
		"dexterity":
			return "提升敏捷可以增加移动速度和武器操控性"
		"perception":
			return "提升感知可以增加视野范围和暴击伤害"
		"intelligence":
			return "提升智力可以增加技能学习速度和资源利用效率"
		_:
			return "未知属性"

func get_stat_effects(stat_name: String, value: float) -> Array[String]:
	var effects: Array[String] = []
	
	match stat_name:
		"strength":
			effects.append("负重能力: +" + str(int(value * 5)) + "kg")
			effects.append("近战伤害: +" + str(int(value * 0.5)) + "点")
		"endurance":
			effects.append("生命值: +" + str(int(value * 10)) + "点")
			effects.append("健康恢复: +" + str(value * 0.05) + "/秒")
		"dexterity":
			effects.append("移动速度: +" + str(int(value * 5)) + "单位")
			effects.append("潜行能力: +" + str(value * 0.02) + "%")
		"perception":
			effects.append("视野范围: +" + str(value * 10) + "单位")
			effects.append("暴击伤害: +" + str(value * 0.05) + "倍")
		"intelligence":
			effects.append("技能学习速度: +" + str(value * 0.05) + "%")
			effects.append("资源利用效率: +" + str(value * 0.01) + "%")
	
	return effects
