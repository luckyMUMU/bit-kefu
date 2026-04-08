class_name ResultScreen
extends Control

enum ResultMode { DEATH, EXTRACTION }

@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var subtitle_label: Label = $Panel/VBox/SubTitleLabel
@onready var item_list: ItemList = $Panel/VBox/ItemList
@onready var total_value_label: Label = $Panel/VBox/TotalValueLabel
@onready var action_button_1: Button = $Panel/VBox/ButtonBar/ActionButton1
@onready var action_button_2: Button = $Panel/VBox/ButtonBar/ActionButton2

signal action_chosen(action: String)

var current_mode: ResultMode = ResultMode.DEATH

func _ready() -> void:
	visible = false
	_setup_buttons()

func _setup_buttons() -> void:
	if action_button_1:
		action_button_1.pressed.connect(_on_action_1)
	if action_button_2:
		action_button_2.pressed.connect(_on_action_2)

func show_death_result(items_lost: Array) -> void:
	current_mode = ResultMode.DEATH
	visible = true
	
	if title_label:
		title_label.text = "你已阵亡"
		title_label.add_theme_color_override("font_color", Color.RED)
	
	if subtitle_label:
		subtitle_label.text = "你在战区倒下了...携带的物品散落在原地"
	
	_clear_item_list()
	for item in items_lost:
		var item_text := str(item) if item else "未知物品"
		if item_list:
			item_list.add_item(item_text)
	
	if total_value_label:
		total_value_label.visible = false
	
	if action_button_1:
		action_button_1.text = "回收尸体"
	if action_button_2:
		action_button_2.text = "返回基地"
		action_button_2.visible = true

func show_extraction_result(loot: Array, total_value: int = 0) -> void:
	current_mode = ResultMode.EXTRACTION
	visible = true
	
	if title_label:
		title_label.text = "撤离成功"
		title_label.add_theme_color_override("font_color", Color.GREEN)
	
	if subtitle_label:
		subtitle_label.text = "你成功带回了所有战利品！"
	
	_clear_item_list()
	for item in loot:
		var item_text := str(item) if item else "未知物品"
		if item_list:
			item_list.add_item(item_text)
	
	if total_value_label:
		total_value_label.text = "总价值: $%d" % total_value
		total_value_label.visible = true
	
	if action_button_1:
		action_button_1.text = "返回基地"
	if action_button_2:
		action_button_2.visible = false

func close_result() -> void:
	visible = false

func _clear_item_list() -> void:
	if item_list:
		item_list.clear()

func _on_action_1() -> void:
	var action := ""
	match current_mode:
		ResultMode.DEATH:
			action = "recover_corpse"
		ResultMode.EXTRACTION:
			action = "return_base"
	close_result()
	action_chosen.emit(action)

func _on_action_2() -> void:
	close_result()
	action_chosen.emit("return_base")
