class_name InventoryItem
extends RefCounted

var item_id: String = ""
var item_name: String = ""
var description: String = ""
var category: String = "misc"
var rarity: String = "common"
var quantity: int = 1
var weight: float = 1.0
var value: int = 0
var max_stack: int = 1
var durability: float = 100.0
var max_durability: float = 100.0
var is_equipment: bool = false
var equipment_slot: String = ""
var stats: Dictionary = {}

enum Rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}

func _init(data: Dictionary = {}) -> void:
	if not data.is_empty():
		deserialize(data)

func get_total_weight() -> float:
	return weight * quantity

func get_total_value() -> int:
	return value * quantity

func is_stackable() -> bool:
	return max_stack > 1

func can_stack_with(other: InventoryItem) -> bool:
	return item_id == other.item_id and is_stackable() and quantity < max_stack

func merge_with(other: InventoryItem) -> bool:
	if not can_stack_with(other):
		return false
	
	var space := max_stack - quantity
	var to_add := mini(space, other.quantity)
	quantity += to_add
	other.quantity -= to_add
	return true

func use() -> bool:
	if quantity <= 0:
		return false
	
	if is_stackable():
		quantity -= 1
	else:
		durability -= 1.0
	
	return true

func repair(amount: float) -> void:
	durability = minf(durability + amount, max_durability)

func is_broken() -> bool:
	return durability <= 0.0

func get_durability_percent() -> float:
	return (durability / max_durability) * 100.0

func get_rarity_color() -> Color:
	match rarity.to_lower():
		"common": return Color.WHITE
		"uncommon": return Color.GREEN
		"rare": return Color.BLUE
		"epic": return Color.PURPLE
		"legendary": return Color.GOLD
		_: return Color.WHITE

func serialize() -> Dictionary:
	return {
		"item_id": item_id,
		"item_name": item_name,
		"description": description,
		"category": category,
		"rarity": rarity,
		"quantity": quantity,
		"weight": weight,
		"value": value,
		"max_stack": max_stack,
		"durability": durability,
		"max_durability": max_durability,
		"is_equipment": is_equipment,
		"equipment_slot": equipment_slot,
		"stats": stats
	}

func deserialize(data: Dictionary) -> void:
	item_id = data.get("item_id", "")
	item_name = data.get("item_name", "")
	description = data.get("description", "")
	category = data.get("category", "misc")
	rarity = data.get("rarity", "common")
	quantity = data.get("quantity", 1)
	weight = data.get("weight", 1.0)
	value = data.get("value", 0)
	max_stack = data.get("max_stack", 1)
	durability = data.get("durability", 100.0)
	max_durability = data.get("max_durability", 100.0)
	is_equipment = data.get("is_equipment", false)
	equipment_slot = data.get("equipment_slot", "")
	stats = data.get("stats", {})

static func create_from_data(data: ItemData) -> InventoryItem:
	var item := InventoryItem.new()
	item.item_id = data.item_id
	item.item_name = data.item_name
	item.description = data.description
	item.category = data.category
	item.rarity = data.rarity
	item.weight = data.weight
	item.value = data.value
	item.max_stack = data.max_stack
	item.is_equipment = data.is_equipment
	item.equipment_slot = data.equipment_slot
	item.stats = data.stats.duplicate()
	return item
