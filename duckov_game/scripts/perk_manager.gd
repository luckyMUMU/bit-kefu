class_name PerkManager
extends RefCounted

var available_perks: Array[PerkData] = []
var unlocked_perks: Array[String] = []

func _init() -> void:
	load_perks()

func load_perks() -> void:
	# 从资源文件夹加载所有PerkData资源
	var perk_files := Glob.glob_recursive("res://resources/*perk*.tres")
	for file in perk_files:
		var perk: PerkData = load(file)
		if perk:
			available_perks.append(perk)

func get_perk_by_id(perk_id: String) -> PerkData:
	for perk in available_perks:
		if perk.perk_id == perk_id:
			return perk
	return null

func get_perks_by_category(category: PerkData.PerkCategory) -> Array[PerkData]:
	var result: Array[PerkData] = []
	for perk in available_perks:
		if perk.category == category:
			result.append(perk)
	return result

func get_perks_by_branch(branch_id: String) -> Array[PerkData]:
	var result: Array[PerkData] = []
	for perk in available_perks:
		if perk.branch_id == branch_id:
			result.append(perk)
	# 按分支位置排序
	result.sort_custom(self, "_sort_perks_by_position")
	return result

func _sort_perks_by_position(a: PerkData, b: PerkData) -> int:
	return a.position_in_branch - b.position_in_branch

func can_unlock_perk(perk_id: String, player_data: PlayerData) -> Dictionary:
	var perk := get_perk_by_id(perk_id)
	if not perk:
		return {"can_unlock": false, "reason": "Perk not found"}
	
	var result := perk.can_unlock(player_data.unlocked_perks)
	if not result.can_unlock:
		return result
	
	# 检查资源是否足够
	var cost = perk.get_adjusted_cost_for_level(perk.current_level + 1)
	if player_data.money < cost.money:
		return {"can_unlock": false, "reason": "Not enough money"}
	
	if player_data.get_facility_level("perk_station") < perk.tier + 1:
		return {"can_unlock": false, "reason": "Perk station level too low"}
	
	return {"can_unlock": true, "reason": ""}

func unlock_perk(perk_id: String, player_data: PlayerData) -> bool:
	var can_unlock = can_unlock_perk(perk_id, player_data)
	if not can_unlock.can_unlock:
		return false
	
	var perk := get_perk_by_id(perk_id)
	var cost = perk.get_adjusted_cost_for_level(perk.current_level + 1)
	
	# 扣除资源
	if not player_data.spend_money(cost.money):
		return false
	
	# 升级技能
	perk.current_level += 1
	perk.apply_level(player_data.stats, 1)
	
	# 添加到已解锁技能列表
	if perk_id not in player_data.unlocked_perks:
		player_data.unlock_perk(perk_id)
	
	return true

func get_available_branches() -> Array[String]:
	var branches: Set[String] = {}
	for perk in available_perks:
		if perk.branch_id != "":
			branches.add(perk.branch_id)
	return branches.to_array()

func get_branch_progress(branch_id: String, player_data: PlayerData) -> float:
	var branch_perks = get_perks_by_branch(branch_id)
	if branch_perks.size() == 0:
		return 0.0
	
	var unlocked_count := 0
	for perk in branch_perks:
		if perk.perk_id in player_data.unlocked_perks:
			unlocked_count += 1
	
	return float(unlocked_count) / float(branch_perks.size())
