class_name LootContainer
extends Area2D

@export var loot_table: Array[Dictionary] = []
@export var is_opened: bool = false
@export var respawn_time: float = 60.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var interaction_label: Label = $InteractionLabel

var contained_items: Array[InventoryItem] = []

signal opened
signal closed

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if interaction_label:
		interaction_label.visible = false
	
	if not is_opened:
		_generate_loot()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_opened:
		if interaction_label:
			interaction_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if interaction_label:
			interaction_label.visible = false

func can_interact() -> bool:
	return not is_opened

func interact(player: Node2D) -> void:
	if is_opened:
		return
	
	open(player)

func open(_player: Node2D) -> void:
	is_opened = true
	opened.emit()
	
	if sprite:
		sprite.modulate = Color(0.5, 0.5, 0.5, 1.0)
	
	if interaction_label:
		interaction_label.visible = false
	
	_spawn_loot_items()

func _generate_loot() -> void:
	contained_items.clear()
	
	var time_bonus := _get_current_time_bonus()
	
	for loot_entry in loot_table:
		var base_chance: float = loot_entry.get("chance", 0.5)
		var adjusted_chance := base_chance * time_bonus
		
		if randf() <= adjusted_chance:
			var item := _create_item_from_entry(loot_entry)
			if item:
				contained_items.append(item)

func _create_item_from_entry(entry: Dictionary) -> InventoryItem:
	var item := InventoryItem.new()
	item.item_id = entry.get("item_id", "unknown")
	item.item_name = entry.get("item_name", "Unknown Item")
	item.description = entry.get("description", "")
	item.category = entry.get("category", "misc")
	item.rarity = entry.get("rarity", "common")
	item.quantity = randi_range(
		entry.get("min_quantity", 1),
		entry.get("max_quantity", 1)
	)
	item.weight = entry.get("weight", 1.0)
	item.value = entry.get("value", 10)
	item.max_stack = entry.get("max_stack", 1)
	return item

func _spawn_loot_items() -> void:
	for item in contained_items:
		var loot_scene := preload("res://scenes/loot_item.tscn")
		var loot_node := loot_scene.instantiate()
		loot_node.item = item
		loot_node.global_position = global_position + Vector2(randf_range(-30, 30), randf_range(-30, 30))
		get_tree().current_scene.add_child(loot_node)
	
	contained_items.clear()

func _get_current_time_bonus() -> float:
	var time_manager = get_tree().current_scene.get_node_or_null("TimeManager")
	if time_manager and time_manager.has_method("get_current_multiplier"):
		return time_manager.get_current_multiplier()
	return 1.0

func reset() -> void:
	is_opened = false
	contained_items.clear()
	
	if sprite:
		sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	_generate_loot()
