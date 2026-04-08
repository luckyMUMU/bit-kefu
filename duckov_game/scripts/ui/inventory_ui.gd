class_name InventoryUI
extends Control

@onready var item_grid: GridContainer = $VBoxContainer/ScrollContainer/ItemGrid
@onready var weight_label: Label = $VBoxContainer/WeightLabel
@onready var safe_slot: PanelContainer = $VBoxContainer/SafeSlot

var inventory: Inventory
var selected_item: InventoryItem
var item_slots: Array[Button] = []

signal item_selected(item: InventoryItem)
signal item_used(item: InventoryItem)
signal item_dropped(item: InventoryItem)

const ITEM_SLOT_SCENE = preload("res://scenes/ui/item_slot.tscn")

func _ready() -> void:
	visible = false
	GameEvents.on_inventory_changed.connect(_refresh_inventory)

func open(inv: Inventory) -> void:
	inventory = inv
	visible = true
	_refresh_inventory()

func close() -> void:
	visible = false
	selected_item = null

func toggle(inv: Inventory) -> void:
	if visible:
		close()
	else:
		open(inv)

func _refresh_inventory() -> void:
	if inventory == null:
		return
	
	_clear_item_slots()
	
	for item in inventory.items:
		var slot := _create_item_slot(item)
		item_grid.add_child(slot)
		item_slots.append(slot)
	
	_update_weight_display()
	_update_safe_slot()

func _clear_item_slots() -> void:
	for slot in item_slots:
		slot.queue_free()
	item_slots.clear()

func _create_item_slot(item: InventoryItem) -> Button:
	var slot := Button.new()
	slot.custom_minimum_size = Vector2(64, 64)
	
	var tooltip_text := "%s\n%s\nWeight: %.1f\nValue: %d" % [
		item.item_name,
		item.description,
		item.get_total_weight(),
		item.get_total_value()
	]
	slot.tooltip_text = tooltip_text
	
	slot.pressed.connect(_on_item_slot_pressed.bind(item))
	
	return slot

func _update_weight_display() -> void:
	if inventory == null or weight_label == null:
		return
	
	var current := inventory.get_total_weight()
	var max_capacity := GameManager.player_data.stats.carry_capacity
	var is_over := inventory.is_overburdened(max_capacity)
	
	weight_label.text = "Weight: %.1f / %.1f" % [current, max_capacity]
	
	if is_over:
		weight_label.add_theme_color_override("font_color", Color.RED)
	else:
		weight_label.add_theme_color_override("font_color", Color.WHITE)

func _update_safe_slot() -> void:
	if safe_slot == null:
		return
	
	if inventory and inventory.safe_slot_item:
		var item := inventory.safe_slot_item
		safe_slot.tooltip_text = "%s (Safe)" % item.item_name
	else:
		safe_slot.tooltip_text = "Empty Safe Slot"

func _on_item_slot_pressed(item: InventoryItem) -> void:
	selected_item = item
	item_selected.emit(item)
	_show_item_context_menu(item)

func _show_item_context_menu(item: InventoryItem) -> void:
	var popup := PopupMenu.new()
	popup.add_item("Use", 0)
	popup.add_item("Drop", 1)
	popup.add_item("Move to Safe Slot", 2)
	popup.add_item("Cancel", 3)
	
	popup.id_pressed.connect(func(id: int):
		match id:
			0: _use_item(item)
			1: _drop_item(item)
			2: _move_to_safe_slot(item)
			3: pass
		popup.queue_free()
	)
	
	add_child(popup)
	popup.popup_centered()

func _use_item(item: InventoryItem) -> void:
	item_used.emit(item)

func _drop_item(item: InventoryItem) -> void:
	if inventory:
		inventory.remove_item(item)
		item_dropped.emit(item)

func _move_to_safe_slot(item: InventoryItem) -> void:
	if inventory and inventory.safe_slot_item == null:
		inventory.remove_item(item)
		inventory.set_safe_slot_item(item)
		_refresh_inventory()
