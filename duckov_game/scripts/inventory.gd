class_name Inventory
extends RefCounted

var items: Array[InventoryItem] = []
var safe_slot_item: InventoryItem = null
var current_weight: float = 0.0
var max_slots: int = 20

signal weight_changed(new_weight: float)

func add_item(item: InventoryItem) -> bool:
	if items.size() >= max_slots:
		return false
	
	var existing := find_item_by_id(item.item_id)
	if existing and existing.is_stackable():
		existing.quantity += item.quantity
	else:
		items.append(item)
	
	recalculate_weight()
	GameEvents.emit_inventory_changed()
	return true

func remove_item(item: InventoryItem) -> bool:
	var index := items.find(item)
	if index >= 0:
		items.remove_at(index)
		recalculate_weight()
		GameEvents.emit_inventory_changed()
		return true
	return false

func remove_item_by_id(item_id: String, quantity: int = 1) -> bool:
	var item := find_item_by_id(item_id)
	if item == null:
		return false
	
	if item.quantity <= quantity:
		items.remove_at(items.find(item))
	else:
		item.quantity -= quantity
	
	recalculate_weight()
	GameEvents.emit_inventory_changed()
	return true

func find_item_by_id(item_id: String) -> InventoryItem:
	for item in items:
		if item.item_id == item_id:
			return item
	return null

func has_item(item_id: String, quantity: int = 1) -> bool:
	var item := find_item_by_id(item_id)
	return item != null and item.quantity >= quantity

func get_total_weight() -> float:
	return current_weight

func recalculate_weight() -> void:
	current_weight = 0.0
	for item in items:
		current_weight += item.get_total_weight()
	if safe_slot_item:
		current_weight += safe_slot_item.get_total_weight()
	weight_changed.emit(current_weight)

func is_overburdened(max_capacity: float) -> bool:
	return current_weight > max_capacity

func get_overburden_amount(max_capacity: float) -> float:
	return maxf(0.0, current_weight - max_capacity)

func set_safe_slot_item(item: InventoryItem) -> bool:
	if safe_slot_item != null:
		return false
	safe_slot_item = item
	recalculate_weight()
	return true

func clear_safe_slot() -> InventoryItem:
	var item := safe_slot_item
	safe_slot_item = null
	recalculate_weight()
	return item

func clear() -> void:
	items.clear()
	safe_slot_item = null
	current_weight = 0.0
	GameEvents.emit_inventory_changed()

func get_items_by_category(category: String) -> Array[InventoryItem]:
	var result: Array[InventoryItem] = []
	for item in items:
		if item.category == category:
			result.append(item)
	return result

func get_all_items() -> Array[InventoryItem]:
	return items.duplicate()

func serialize() -> Array:
	var data := []
	for item in items:
		data.append(item.serialize())
	return data

func deserialize(data: Array) -> void:
	items.clear()
	for item_data in data:
		var item := InventoryItem.new()
		item.deserialize(item_data)
		items.append(item)
	recalculate_weight()
