class_name Corpse
 extends StaticBody2D

@export var corpse_id: int = -1
@export var items: Array = []
@export var timestamp: String = ""

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var interaction_area: Area2D = $InteractionArea

func _ready() -> void:
	add_to_group("corpses")

func interact(player: Player) -> void:
	# 回收尸体物品
	for item_data in items:
		var item := InventoryItem.new()
		item.deserialize(item_data)
		player.get_inventory().add_item(item)
	
	# 从玩家数据中移除尸体
	GameManager.player_data.remove_corpse(corpse_id)
	
	# 播放回收动画或效果
	# ...
	
	# 销毁尸体节点
	queue_free()