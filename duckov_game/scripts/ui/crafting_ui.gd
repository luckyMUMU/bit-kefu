class_name CraftingUI
extends Control

@export var crafting_manager: CraftingManager
@onready var recipe_list: VBoxContainer = $MarginContainer/HBoxContainer/RecipeListContainer/ScrollContainer/RecipeList
@onready var recipe_details: PanelContainer = $MarginContainer/HBoxContainer/RecipeDetails
@onready var recipe_name: Label = $MarginContainer/HBoxContainer/RecipeDetails/VBoxContainer/RecipeName
@onready var recipe_desc: Label = $MarginContainer/HBoxContainer/RecipeDetails/VBoxContainer/RecipeDesc
@onready var ingredients_list: VBoxContainer = $MarginContainer/HBoxContainer/RecipeDetails/VBoxContainer/IngredientsList
@onready var craft_button: Button = $MarginContainer/HBoxContainer/RecipeDetails/VBoxContainer/CraftButton
@onready var cancel_button: Button = $MarginContainer/HBoxContainer/RecipeDetails/VBoxContainer/CancelButton
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/RecipeDetails/VBoxContainer/ProgressBar
@onready var close_button: Button = $MarginContainer/CloseButton

var selected_recipe: CraftingRecipe = null

signal closed

func _ready() -> void:
	if craft_button:
		craft_button.pressed.connect(_on_craft_button_pressed)
	if cancel_button:
		cancel_button.pressed.connect(_on_cancel_button_pressed)
		cancel_button.visible = false
	if progress_bar:
		progress_bar.visible = false
	if close_button:
		close_button.pressed.connect(close)
	
	_connect_crafting_signals()
	_refresh_recipe_list()

func _connect_crafting_signals() -> void:
	if crafting_manager:
		crafting_manager.recipe_list_updated.connect(_refresh_recipe_list)
		crafting_manager.crafting_started.connect(_on_crafting_started)
		crafting_manager.crafting_progress_updated.connect(_on_crafting_progress)
		crafting_manager.crafting_completed.connect(_on_crafting_completed)
		crafting_manager.crafting_failed.connect(_on_crafting_failed)

func open(manager: CraftingManager) -> void:
	crafting_manager = manager
	visible = true
	_connect_crafting_signals()
	_refresh_recipe_list()
	_clear_recipe_details()

func close() -> void:
	visible = false
	closed.emit()

func _refresh_recipe_list() -> void:
	if recipe_list == null or crafting_manager == null:
		return
	
	for child in recipe_list.get_children():
		child.queue_free()
	
	var available_recipes = crafting_manager.get_available_recipes()
	
	for recipe in available_recipes:
		var button = Button.new()
		button.text = recipe.recipe_name
		button.custom_minimum_size = Vector2(200, 40)
		button.pressed.connect(_on_recipe_selected.bind(recipe))
		recipe_list.add_child(button)

func _on_recipe_selected(recipe: CraftingRecipe) -> void:
	selected_recipe = recipe
	_display_recipe_details(recipe)

func _display_recipe_details(recipe: CraftingRecipe) -> void:
	if recipe_name:
		recipe_name.text = recipe.recipe_name
	if recipe_desc:
		recipe_desc.text = recipe.description
	
	if ingredients_list:
		for child in ingredients_list.get_children():
			child.queue_free()
		
		var header = Label.new()
		header.text = "Ingredients:"
		ingredients_list.add_child(header)
		
		var inventory = GameManager.player_data.inventory
		for ingredient in recipe.get_ingredients_display():
			var item_id = ingredient.get("item_id", "")
			var quantity = ingredient.get("quantity", 1)
			var has_item = inventory.has_item(item_id, quantity)
			
			var label = Label.new()
			label.text = "- %s: %d (%s)" % [item_id, quantity, "✅" if has_item else "❌"]
			label.add_theme_color_override("font_color", Color.GREEN if has_item else Color.RED)
			ingredients_list.add_child(label)
	
	_update_craft_button(recipe)

func _update_craft_button(recipe: CraftingRecipe) -> void:
	if craft_button and crafting_manager:
		var check = crafting_manager.can_craft_recipe(recipe, GameManager.player_data.inventory)
		craft_button.disabled = not check.can_craft or crafting_manager.is_crafting

func _on_craft_button_pressed() -> void:
	if selected_recipe and crafting_manager:
		crafting_manager.start_crafting(selected_recipe, GameManager.player_data.inventory)

func _on_cancel_button_pressed() -> void:
	if crafting_manager:
		crafting_manager.cancel_crafting()

func _clear_recipe_details() -> void:
	if recipe_name:
		recipe_name.text = ""
	if recipe_desc:
		recipe_desc.text = ""
	if ingredients_list:
		for child in ingredients_list.get_children():
			child.queue_free()
	selected_recipe = null

func _on_crafting_started(_recipe: CraftingRecipe) -> void:
	if craft_button:
		craft_button.visible = false
	if cancel_button:
		cancel_button.visible = true
	if progress_bar:
		progress_bar.visible = true
		progress_bar.value = 0.0

func _on_crafting_progress(progress: float) -> void:
	if progress_bar:
		progress_bar.value = progress * 100.0

func _on_crafting_completed(_recipe: CraftingRecipe) -> void:
	if craft_button:
		craft_button.visible = true
	if cancel_button:
		cancel_button.visible = false
	if progress_bar:
		progress_bar.visible = false
		progress_bar.value = 0.0
	_refresh_recipe_list()
	if selected_recipe:
		_display_recipe_details(selected_recipe)

func _on_crafting_failed(reason: String) -> void:
	if craft_button:
		craft_button.visible = true
	if cancel_button:
		cancel_button.visible = false
	if progress_bar:
		progress_bar.visible = false
		progress_bar.value = 0.0
	if selected_recipe:
		_update_craft_button(selected_recipe)
