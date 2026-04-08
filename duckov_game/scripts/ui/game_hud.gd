class_name GameHUD
extends CanvasLayer

@onready var health_bar: ProgressBar = $InfoPanel/VBoxContainer/TopRow/HealthBar
@onready var health_label: Label = $InfoPanel/VBoxContainer/TopRow/HealthBar/HealthLabel
@onready var ammo_label: Label = $InfoPanel/VBoxContainer/TopRow/AmmoLabel
@onready var weight_label: Label = $InfoPanel/VBoxContainer/BottomRow/WeightLabel
@onready var money_label: Label = $InfoPanel/VBoxContainer/BottomRow/MoneyLabel
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var extraction_progress: ProgressBar = $ExtractionProgress
@onready var warning_label: Label = $WarningLabel
@onready var time_bonus_label: Label = $TimeBonusLabel

# 新增节点引用 - 小地图
@onready var minimap: TextureRect = $Minimap
# 新增节点引用 - 距离指示器
@onready var distance_label: Label = $DistanceIndicator/DistanceLabel
# 新增节点引用 - 物品拾取通知容器
@onready var pickup_container: VBoxContainer = $PickupNotifications

var player: Player

# 小地图配置常量
const MINIMAP_WIDTH: int = 150
const MINIMAP_HEIGHT: int = 150
const MAP_WORLD_WIDTH: float = 1600.0
const MAP_WORLD_HEIGHT: float = 1200.0

func _ready() -> void:
	visible = false
	_setup_signals()
	
	if extraction_progress:
		extraction_progress.visible = false
	if warning_label:
		warning_label.visible = false
	if interaction_prompt:
		interaction_prompt.visible = false
	
	# 初始化小地图背景
	_init_minimap()

func _setup_signals() -> void:
	GameEvents.on_inventory_changed.connect(_update_weight_display)
	GameEvents.on_money_changed.connect(_on_money_changed)
	GameEvents.on_extraction_started.connect(_show_extraction_progress)
	GameEvents.on_boss_wave_incoming.connect(_show_boss_warning)
	GameEvents.on_time_bonus_updated.connect(_update_time_bonus)
	
	# 连接物品拾取信号
	if GameEvents.has_signal("on_item_picked_up"):
		GameEvents.on_item_picked_up.connect(_on_item_picked_up)
	
	# 连接玩家受伤信号用于显示伤害数字
	if GameEvents.has_signal("on_player_damaged"):
		GameEvents.on_player_damaged.connect(_on_player_damaged_for_numbers)

func initialize(player_node: Player) -> void:
	player = player_node
	
	if player:
		player.health_changed.connect(_update_health_display)
		_update_health_display(player.current_health, player.max_health)
	
	_update_money_display()
	_update_weight_display()

func _process(_delta: float) -> void:
	if player:
		_update_interaction_prompt()
		_update_ammo_display()
		
		# 更新小地图显示
		_update_minimap()
		
		# 更新距离指示器
		_update_distance_indicator()

# ==================== 健康值显示 ====================

func _update_health_display(current: float, maximum: float) -> void:
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current
	
	if health_label:
		health_label.text = "%d / %d" % [int(current), int(maximum)]

# ==================== 弹药显示 ====================

func _update_ammo_display() -> void:
	if player == null or player.current_weapon == null:
		if ammo_label:
			ammo_label.text = "No Weapon"
		return
	
	var weapon: Weapon = player.current_weapon
	if weapon is RangedWeapon:
		var ranged := weapon as RangedWeapon
		if ammo_label:
			ammo_label.text = "Ammo: %d / %d" % [ranged.current_ammo, ranged.max_ammo]
	else:
		if ammo_label:
			ammo_label.text = "Melee Weapon"

# ==================== 重量显示 ====================

func _update_weight_display() -> void:
	if weight_label == null:
		return
	
	var inventory: Inventory = GameManager.player_data.inventory
	var current: float = inventory.get_total_weight()
	var max_capacity: float = GameManager.player_data.stats.carry_capacity
	
	weight_label.text = "Weight: %.1f / %.1f" % [current, max_capacity]
	
	if current > max_capacity:
		weight_label.add_theme_color_override("font_color", Color.RED)
	else:
		weight_label.add_theme_color_override("font_color", Color.WHITE)

# ==================== 金钱显示 ====================

func _update_money_display() -> void:
	if money_label:
		money_label.text = "$ %d" % GameManager.player_data.money

func _on_money_changed(new_amount: int, _old_amount: int) -> void:
	if money_label:
		money_label.text = "$ %d" % new_amount

# ==================== 交互提示 ====================

func _update_interaction_prompt() -> void:
	if interaction_prompt == null:
		return
	
	var interactables := player.get_nearby_interactables() if player else []
	
	if interactables.is_empty():
		interaction_prompt.visible = false
	else:
		interaction_prompt.visible = true
		interaction_prompt.text = "[E] Interact"

# ==================== 撤离进度 ====================

func _show_extraction_progress() -> void:
	if extraction_progress:
		extraction_progress.visible = true
		extraction_progress.value = 0.0

func update_extraction_progress(progress: float) -> void:
	if extraction_progress and extraction_progress.visible:
		extraction_progress.value = progress * 100.0

func hide_extraction_progress() -> void:
	if extraction_progress:
		extraction_progress.visible = false

# ==================== Boss警告 ====================

func _show_boss_warning() -> void:
	if warning_label:
		warning_label.visible = true
		warning_label.text = "WARNING: Boss Wave Incoming!"
		warning_label.modulate = Color.RED
		
		await get_tree().create_timer(3.0).timeout
		warning_label.visible = false

# ==================== 时间奖励倍率 ====================

func _update_time_bonus(multiplier: float) -> void:
	if time_bonus_label:
		time_bonus_label.text = "Loot Bonus: x%.1f" % multiplier

# ==================== 伤害指示器（红色闪烁） ====================

func show_damage_indicator() -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(1, 0, 0, 0.3)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 0.0, 0.3)
	await tween.finished
	overlay.queue_free()

# ==================== 小地图系统 ====================

func _init_minimap() -> void:
	# 初始化小地图背景图像
	if minimap == false:
		return
	
	var bg_image := Image.create(MINIMAP_WIDTH, MINIMAP_HEIGHT, false, Image.FORMAT_RGBA8)
	bg_image.fill(Color(0.1, 0.1, 0.15, 0.7))
	var bg_texture := ImageTexture.create_from_image(bg_image)
	minimap.texture = bg_texture

func _update_minimap() -> void:
	if minimap == null or player == null:
		return
	
	# 创建小地图图像
	var map_image := Image.create(MINIMAP_WIDTH, MINIMAP_HEIGHT, false, Image.FORMAT_RGBA8)
	map_image.fill(Color(0.1, 0.1, 0.15, 0.7))
	
	# 计算缩放比例
	var scale_x := float(MINIMAP_WIDTH) / MAP_WORLD_WIDTH
	var scale_y := float(MINIMAP_HEIGHT) / MAP_WORLD_HEIGHT
	
	# 绘制玩家位置（青色圆点）
	if player.global_position:
		var player_pos_on_map := Vector2(
			player.global_position.x * scale_x,
			player.global_position.y * scale_y
		)
		_draw_circle_on_image(map_image, player_pos_on_map, 5, Color.CYAN)
	
	# 绘制敌人位置（红色圆点）- 遍历 enemies 分组
	var enemies_group := get_tree().get_nodes_in_group("enemies")
	for enemy in enemies_group:
		if enemy is Node2D and enemy.global_position:
			var enemy_node2d := enemy as Node2D
			var enemy_pos_on_map := Vector2(
				enemy_node2d.global_position.x * scale_x,
				enemy_node2d.global_position.y * scale_y
			)
			_draw_circle_on_image(map_image, enemy_pos_on_map, 3, Color.RED)
	
	# 绘制撤离点（绿色方块）- 查找 ExtractionPoint
	var extraction_points := get_tree().get_nodes_in_group("extraction_points")
	for point in extraction_points:
		if point is Node2D and point.global_position:
			var point_node2d := point as Node2D
			var point_pos_on_map := Vector2(
				point_node2d.global_position.x * scale_x,
				point_node2d.global_position.y * scale_y
			)
			_draw_rect_on_image(map_image, point_pos_on_map, Vector2(6, 6), Color.GREEN)
	
	# 应用纹理到小地图
	var map_texture := ImageTexture.create_from_image(map_image)
	minimap.texture = map_texture

func _draw_circle_on_image(image: Image, center: Vector2, radius: int, color: Color) -> void:
	# 在图像上绘制实心圆
	for y in range(-radius, radius + 1):
		for x in range(-radius, radius + 1):
			if x * x + y * y <= radius * radius:
				var px := int(center.x) + x
				var py := int(center.y) + y
				if px >= 0 and px < image.get_width() and py >= 0 and py < image.get_height():
					image.set_pixel(px, py, color)

func _draw_rect_on_image(image: Image, center: Vector2, size: Vector2, color: Color) -> void:
	# 在图像上绘制矩形
	var half_size := size / 2
	var start_x := int(center.x - half_size.x)
	var start_y := int(center.y - half_size.y)
	var end_x := int(center.x + half_size.x)
	var end_y := int(center.y + half_size.y)
	
	for y in range(start_y, end_y + 1):
		for x in range(start_x, end_x + 1):
			if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
				image.set_pixel(x, y, color)

# ==================== 距离指示器系统 ====================

func _update_distance_indicator() -> void:
	if distance_label == false or player == false:
		return
	
	# 检查玩家是否有当前武器
	if player.current_weapon == null:
		distance_label.text = "射程: 无武器"
		distance_label.add_theme_color_override("font_color", Color.GRAY)
		return
	
	var weapon: Weapon = player.current_weapon
	
	# 判断是否是远程武器
	if weapon is RangedWeapon:
		var ranged_weapon := weapon as RangedWeapon
		
		# 获取鼠标位置并计算距离
		var viewport := get_viewport()
		if viewport == null:
			return
			
		var mouse_pos := viewport.get_mouse_position()
		var camera := get_viewport().get_camera_2d()
		
		var world_mouse_pos: Vector2
		if camera:
			world_mouse_pos = camera.get_global_mouse_position()
		else:
			# 如果没有相机，使用玩家位置作为参考
			world_mouse_pos = player.global_position
		
		# 计算鼠标到玩家的距离
		var distance_to_target := player.global_position.distance_to(world_mouse_pos)
		
		# 获取武器有效射程（默认200，或从武器获取）
		var effective_range := 200.0
		if ranged_weapon.has_method("get_effective_range"):
			effective_range = ranged_weapon.get_effective_range()
		elif ranged_weapon.get("effective_range") != null:
			effective_range = ranged_weapon.effective_range
		
		# 根据距离判断是否在射程内
		if distance_to_target <= effective_range:
			distance_label.text = "✓ 射程内 (%.0f/%.0f)" % [distance_to_target, effective_range]
			distance_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			distance_label.text = "✗ 超出射程 (%.0f/%.0f)" % [distance_to_target, effective_range]
			distance_label.add_theme_color_override("font_color", Color.RED)
	else:
		# 近战武器提示
		distance_label.text = "近战武器"
		distance_label.add_theme_color_override("font_color", Color.YELLOW)

# ==================== 物品拾取通知系统 ====================

func show_pickup_notification(item_name: String, quantity: int = 1) -> void:
	if pickup_container == null:
		return
	
	# 创建通知面板容器
	var notification_panel := PanelContainer.new()
	
	# 创建水平布局容器
	var hbox := HBoxContainer.new()
	hbox.layout_mode = 2
	
	# 创建图标占位标签
	var icon_label := Label.new()
	icon_label.layout_mode = 2
	icon_label.text = "📦"
	icon_label.horizontal_alignment = 1
	
	# 创建文本标签
	var text_label := Label.new()
	text_label.layout_mode = 2
	if quantity > 1:
		text_label.text = "获得 %s x%d" % [item_name, quantity]
	else:
		text_label.text = "获得 %s" % item_name
	
	# 组装UI结构
	hbox.add_child(icon_label)
	hbox.add_child(text_label)
	notification_panel.add_child(hbox)
	pickup_container.add_child(notification_panel)
	
	# 创建淡出动画
	var tween := create_tween()
	tween.tween_property(notification_panel, "modulate:a", 0.0, 3.0)
	
	# 动画完成后自动销毁
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(notification_panel):
		notification_panel.queue_free()

func _on_item_picked_up(item: Variant) -> void:
	# 处理物品拾取事件
	var item_name: String = "物品"
	var quantity: int = 1
	
	# 尝试从 InventoryItem 获取信息
	if item != null and item.has_method("get") and item.get("item_id") != null:
		item_name = str(item.item_id)
	if item != null and item.has_method("get") and item.get("quantity") != null:
		quantity = int(item.quantity)
	
	show_pickup_notification(item_name, quantity)

# ==================== 伤害数字显示系统 ====================

func spawn_damage_number(value: float, position: Vector2, type: String = "normal") -> void:
	# 创建伤害数字标签
	var damage_label := Label.new()
	damage_label.text = str(int(value))
	damage_label.horizontal_alignment = 1
	
	# 根据类型设置颜色
	match type:
		"crit":
			damage_label.add_theme_color_override("font_color", Color.RED)
			damage_label.add_theme_font_size_override("font_size", 20)
		"heal":
			damage_label.add_theme_color_override("font_color", Color.GREEN)
			damage_label.add_theme_font_size_override("font_size", 16)
		_:  # normal
			damage_label.add_theme_color_override("font_color", Color.WHITE)
			damage_label.add_theme_font_size_override("font_size", 18)
	
	# 将世界坐标转换为屏幕坐标
	var screen_pos: Vector2
	var camera := get_viewport().get_camera_2d() if get_viewport() else null
	if camera and position:
		screen_pos = camera.unproject_position(Vector3(position.x, position.y, 0))
	else:
		# 如果没有相机，使用 CanvasLayer 的 make_canvas_position 方法
		screen_pos = position if position else Vector2(get_viewport().get_visible_rect().size.x / 2, get_viewport().get_visible_rect().size.y / 2)
	
	damage_label.position = screen_pos
	add_child(damage_label)
	
	# 创建向上飘动和淡出的动画
	var tween := create_tween()
	tween.parallel().tween_property(damage_label, "position:y", screen_pos.y - 100, 1.0)
	tween.parallel().tween_property(damage_label, "modulate:a", 0.0, 1.0)
	
	# 动画结束后销毁节点
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(damage_label):
		damage_label.queue_free()

func _on_player_damaged_for_numbers(amount: float) -> void:
	# 显示玩家受到的伤害数字
	var target_pos: Vector2 = player.global_position if player else Vector2.ZERO
	spawn_damage_number(amount, target_pos, "normal")
