class_name CraftingManager
extends Node

@export var recipes: Array[CraftingRecipe] = []
@export var current_facility: String = "workbench"
@export var facility_level: int = 1

var is_crafting: bool = false
var current_crafting_recipe: CraftingRecipe = null
var crafting_progress: float = 0.0

signal recipe_list_updated
signal crafting_started(recipe: CraftingRecipe)
signal crafting_progress_updated(progress: float)
signal crafting_completed(recipe: CraftingRecipe)
signal crafting_failed(reason: String)
signal item_dismantled(item: InventoryItem, materials: Array)

func _ready() -> void:
	_load_default_recipes()

func _load_default_recipes() -> void:
	if recipes.is_empty():
		var basic_pistol := CraftingRecipe.create_basic()
		recipes.append(basic_pistol)
		
		var bandage_recipe := CraftingRecipe.new()
		bandage_recipe.recipe_id = "bandage"
		bandage_recipe.recipe_name = "Bandage"
		bandage_recipe.description = "Basic healing item"
		bandage_recipe.category = "medical"
		bandage_recipe.result_item_id = "bandage"
		bandage_recipe.result_quantity = 3
		bandage_recipe.ingredients = [{"item_id": "cloth", "quantity": 2}]
		bandage_recipe.required_facility = "medical"
		bandage_recipe.required_level = 1
		bandage_recipe.crafting_time = 1.0
		recipes.append(bandage_recipe)

func get_available_recipes() -> Array[CraftingRecipe]:
	var available: Array[CraftingRecipe] = []
	for recipe in recipes:
		if recipe.required_facility == current_facility and recipe.required_level <= facility_level:
			available.append(recipe)
	return available

func get_recipes_by_category(category: String) -> Array[CraftingRecipe]:
	var filtered: Array[CraftingRecipe] = []
	for recipe in recipes:
		if recipe.category == category:
			filtered.append(recipe)
	return filtered

func can_craft_recipe(recipe: CraftingRecipe, inventory: Inventory) -> Dictionary:
	if recipe.required_facility != current_facility:
		return {"can_craft": false, "reason": "Wrong facility"}
	
	return recipe.can_craft(inventory, facility_level)

func start_crafting(recipe: CraftingRecipe, inventory: Inventory) -> bool:
	if is_crafting:
		crafting_failed.emit("Already crafting")
		return false
	
	var check = can_craft_recipe(recipe, inventory)
	if not check.can_craft:
		crafting_failed.emit(check.reason)
		return false
	
	if not recipe.consume_ingredients(inventory):
		crafting_failed.emit("Failed to consume ingredients")
		return false
	
	is_crafting = true
	current_crafting_recipe = recipe
	crafting_progress = 0.0
	crafting_started.emit(recipe)
	
	_process_crafting()
	return true

func _process_crafting() -> void:
	if not is_crafting:
		return
	
	var recipe = current_crafting_recipe
	if recipe == null:
		cancel_crafting()
		return
	
	var total_time = recipe.crafting_time
	var time_step = 0.05
	
	while crafting_progress < 1.0:
		await get_tree().create_timer(time_step).timeout
		if not is_crafting:
			return
		crafting_progress = minf(1.0, crafting_progress + time_step / total_time)
		crafting_progress_updated.emit(crafting_progress)
	
	_complete_crafting()

func _complete_crafting() -> void:
	if current_crafting_recipe == null:
		return
	
	var result_item = InventoryItem.new()
	result_item.item_id = current_crafting_recipe.result_item_id
	result_item.quantity = current_crafting_recipe.result_quantity
	result_item.item_name = current_crafting_recipe.recipe_name
	
	GameManager.player_data.inventory.add_item(result_item)
	
	crafting_completed.emit(current_crafting_recipe)
	
	is_crafting = false
	current_crafting_recipe = null
	crafting_progress = 0.0

func cancel_crafting() -> void:
	if not is_crafting:
		return
	
	if current_crafting_recipe:
		for ingredient in current_crafting_recipe.ingredients:
			var item_id: String = ingredient.get("item_id", "")
			var quantity: int = ingredient.get("quantity", 1)
			var item = InventoryItem.new()
			item.item_id = item_id
			item.quantity = quantity
			GameManager.player_data.inventory.add_item(item)
	
	is_crafting = false
	current_crafting_recipe = null
	crafting_progress = 0.0
	crafting_failed.emit("Cancelled")

func dismantle_item(item: InventoryItem) -> Array:
	var materials: Array = []
	
	# 修复4.6.2类型推断严格化问题：显式指定int类型，避免Variant推断
	var result_quantity: int = max(1, int(item.weight * 2))
	var material_item = InventoryItem.new()
	material_item.item_id = "scrap_material"
	material_item.quantity = result_quantity
	material_item.item_name = "Scrap Material"
	
	materials.append(material_item)
	GameManager.player_data.inventory.remove_item(item)
	
	for mat in materials:
		GameManager.player_data.inventory.add_item(mat)
	
	item_dismantled.emit(item, materials)
	return materials

func unlock_recipe(recipe_id: String) -> bool:
	for recipe in recipes:
		if recipe.recipe_id == recipe_id and not recipe.is_unlocked:
			recipe.is_unlocked = true
			recipe_list_updated.emit()
			return true
	return false

func is_recipe_unlocked(recipe_id: String) -> bool:
	for recipe in recipes:
		if recipe.recipe_id == recipe_id:
			return recipe.is_unlocked
	return false

func set_facility(facility: String, level: int = 1) -> void:
	current_facility = facility
	facility_level = level
	recipe_list_updated.emit()

func get_current_facility() -> String:
	return current_facility

func get_facility_level() -> int:
	return facility_level
