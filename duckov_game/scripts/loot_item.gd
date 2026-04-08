class_name LootItem
extends Area2D

# Godot 4.6.2 要求 @export 类型必须是内置类型、Resource、Node 或枚举
# InventoryItem 继承自 RefCounted，不符合 @export 条件，改为普通变量
var item: InventoryItem
@export var pickup_range: float = 50.0

var is_being_picked_up: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

signal picked_up(item: InventoryItem)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	if item and sprite:
		sprite.modulate = item.get_rarity_color()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_being_picked_up:
		pickup(body)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player") and not is_being_picked_up:
		pickup(area.get_parent())

func pickup(player: Node2D) -> void:
	if is_being_picked_up:
		return
	
	is_being_picked_up = true
	
	if player.has_method("get"):
		var inventory = player.get("inventory")
		if inventory and inventory is Inventory:
			if inventory.add_item(item):
				picked_up.emit(item)
				GameEvents.emit_item_picked_up(item)
				queue_free()
				return
	
	is_being_picked_up = false

func set_item(new_item: InventoryItem) -> void:
	item = new_item
	if sprite:
		sprite.modulate = item.get_rarity_color()

func get_item_value() -> int:
	if item:
		return item.get_total_value()
	return 0

func get_item_weight() -> float:
	if item:
		return item.get_total_weight()
	return 0.0
