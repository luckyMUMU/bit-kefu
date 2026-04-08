class_name GameHUD
extends CanvasLayer

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthBar/HealthLabel
@onready var ammo_label: Label = $MarginContainer/VBoxContainer/AmmoLabel
@onready var weight_label: Label = $MarginContainer/VBoxContainer/WeightLabel
@onready var money_label: Label = $MarginContainer/VBoxContainer/MoneyLabel
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var extraction_progress: ProgressBar = $ExtractionProgress
@onready var warning_label: Label = $WarningLabel
@onready var time_bonus_label: Label = $TimeBonusLabel

var player: Player

func _ready() -> void:
	visible = false
	_setup_signals()
	
	if extraction_progress:
		extraction_progress.visible = false
	if warning_label:
		warning_label.visible = false
	if interaction_prompt:
		interaction_prompt.visible = false

func _setup_signals() -> void:
	GameEvents.on_inventory_changed.connect(_update_weight_display)
	GameEvents.on_money_changed.connect(_on_money_changed)
	GameEvents.on_extraction_started.connect(_show_extraction_progress)
	GameEvents.on_boss_wave_incoming.connect(_show_boss_warning)
	GameEvents.on_time_bonus_updated.connect(_update_time_bonus)

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

func _update_health_display(current: float, maximum: float) -> void:
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current
	
	if health_label:
		health_label.text = "%d / %d" % [int(current), int(maximum)]

func _update_ammo_display() -> void:
	if player == null or player.current_weapon == null:
		if ammo_label:
			ammo_label.text = "No Weapon"
		return
	
	var weapon := player.current_weapon
	if weapon is RangedWeapon:
		var ranged := weapon as RangedWeapon
		if ammo_label:
			ammo_label.text = "Ammo: %d / %d" % [ranged.current_ammo, ranged.max_ammo]
	else:
		if ammo_label:
			ammo_label.text = "Melee Weapon"

func _update_weight_display() -> void:
	if weight_label == null:
		return
	
	var inventory := GameManager.player_data.inventory
	var current := inventory.get_total_weight()
	var max_capacity := GameManager.player_data.stats.carry_capacity
	
	weight_label.text = "Weight: %.1f / %.1f" % [current, max_capacity]
	
	if current > max_capacity:
		weight_label.add_theme_color_override("font_color", Color.RED)
	else:
		weight_label.add_theme_color_override("font_color", Color.WHITE)

func _update_money_display() -> void:
	if money_label:
		money_label.text = "$ %d" % GameManager.player_data.money

func _on_money_changed(new_amount: int, _old_amount: int) -> void:
	if money_label:
		money_label.text = "$ %d" % new_amount

func _update_interaction_prompt() -> void:
	if interaction_prompt == null:
		return
	
	var interactables := player.get_nearby_interactables() if player else []
	
	if interactables.is_empty():
		interaction_prompt.visible = false
	else:
		interaction_prompt.visible = true
		interaction_prompt.text = "[E] Interact"

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

func _show_boss_warning() -> void:
	if warning_label:
		warning_label.visible = true
		warning_label.text = "WARNING: Boss Wave Incoming!"
		warning_label.modulate = Color.RED
		
		await get_tree().create_timer(3.0).timeout
		warning_label.visible = false

func _update_time_bonus(multiplier: float) -> void:
	if time_bonus_label:
		time_bonus_label.text = "Loot Bonus: x%.1f" % multiplier

func show_damage_indicator() -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(1, 0, 0, 0.3)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 0.0, 0.3)
	await tween.finished
	overlay.queue_free()
