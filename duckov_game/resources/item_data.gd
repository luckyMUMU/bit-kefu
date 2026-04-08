class_name ItemData
extends Resource

@export var item_id: String = ""
@export var item_name: String = ""
@export_multiline var description: String = ""
@export var category: String = "misc"
@export var rarity: String = "common"
@export var weight: float = 1.0
@export var value: int = 0
@export var max_stack: int = 1
@export var is_equipment: bool = false
@export var equipment_slot: String = ""
@export var sprite: Texture2D
@export var stats: Dictionary = {}
