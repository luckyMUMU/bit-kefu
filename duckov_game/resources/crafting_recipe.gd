class_name CraftingRecipe
extends Resource

@export var recipe_id: String = ""
@export var recipe_name: String = ""
@export var description: String = ""
@export var category: String = "weapons"
@export var result_item_id: String = ""
@export var result_quantity: int = 1
@export var ingredients: Array[Dictionary] = []
@export var required_facility: String = "workbench"
@export var required_level: int = 1
@export var crafting_time: float = 1.0
@export var is_unlocked: bool = false
@export var unlock_blueprint_id: String = ""

func can_craft(inventory: Inventory, facility_level: int) -> Dictionary:
	var result := {"can_craft": true, "reason": ""}
	
	if facility_level < required_level:
		result.can_craft = false
		result.reason = "Requires facility level " + str(required_level)
		return result
	
	for ingredient in ingredients:
		var item_id: String = ingredient.get("item_id", "")
		var quantity: int = ingredient.get("quantity", 1)
		
		if not inventory.has_item(item_id, quantity):
			result.can_craft = false
			result.reason = "Missing " + str(quantity) + " x " + item_id
			return result
	
	return result

func get_missing_ingredients(inventory: Inventory) -> Array:
	var missing: Array = []
	
	for ingredient in ingredients:
		var item_id: String = ingredient.get("item_id", "")
		var quantity: int = ingredient.get("quantity", 1)
		
		var has_quantity: int = 0
		var item = inventory.find_item_by_id(item_id)
		if item:
			has_quantity = item.quantity
		
		if has_quantity < quantity:
			missing.append({
				"item_id": item_id,
				"required": quantity,
				"available": has_quantity,
				"missing": quantity - has_quantity
			})
	
	return missing

func get_ingredients_display() -> Array:
	var display: Array = []
	for ingredient in ingredients:
		display.append({
			"item_id": ingredient.get("item_id", ""),
			"quantity": ingredient.get("quantity", 1)
		})
	return display

func consume_ingredients(inventory: Inventory) -> bool:
	for ingredient in ingredients:
		var item_id: String = ingredient.get("item_id", "")
		var quantity: int = ingredient.get("quantity", 1)
		
		if not inventory.remove_item_by_id(item_id, quantity):
			return false
	
	return true

static func create_basic() -> CraftingRecipe:
	var recipe := CraftingRecipe.new()
	recipe.recipe_id = "basic_pistol"
	recipe.recipe_name = "Basic Pistol"
	recipe.description = "A simple but reliable sidearm"
	recipe.category = "weapons"
	recipe.result_item_id = "pistol_basic"
	recipe.result_quantity = 1
	recipe.ingredients = [
		{"item_id": "metal_scrap", "quantity": 5},
		{"item_id": "mechanical_parts", "quantity": 2}
	]
	recipe.required_facility = "workbench"
	recipe.required_level = 1
	recipe.crafting_time = 2.0
	return recipe
