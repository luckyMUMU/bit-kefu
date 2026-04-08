class_name MainMenu
extends Control

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $TitleLabel
@onready var difficulty_option: OptionButton = $VBoxContainer/DifficultyOption
@onready var tutorial_button: Button = $VBoxContainer/TutorialButton

var settings_ui: SettingsUI

func _ready() -> void:
	_setup_buttons()
	_check_save_exists()
	_setup_difficulty_option()

	if title_label:
		title_label.text = "逃离鸭科夫"
	_highlight_tutorial_if_new()

func _get_settings() -> Node:
	return get_node_or_null("/root/SettingsManager")

func _setup_buttons() -> void:
	if new_game_button:
		new_game_button.pressed.connect(_on_new_game_pressed)
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if tutorial_button:
		tutorial_button.pressed.connect(_on_tutorial_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func _setup_difficulty_option() -> void:
	if difficulty_option:
		difficulty_option.add_item("Easy")
		difficulty_option.add_item("Normal")
		difficulty_option.add_item("Hard")
		if _get_settings():
			difficulty_option.selected = _get_settings().get_difficulty()
		difficulty_option.item_selected.connect(_on_difficulty_changed)

func _check_save_exists() -> void:
	if continue_button:
		continue_button.visible = SaveManager.has_save()

func _on_new_game_pressed() -> void:
	GameManager.player_data = PlayerData.new()
	GameManager.go_to_base()

func _on_continue_pressed() -> void:
	if SaveManager.load_game():
		GameManager.go_to_base()

func _on_settings_pressed() -> void:
	_show_settings_ui()

func _show_settings_ui() -> void:
	if settings_ui == null:
		var settings_scene = preload("res://scenes/ui/settings_ui.tscn")
		settings_ui = settings_scene.instantiate()
		add_child(settings_ui)
	
	if settings_ui:
		settings_ui.open()

func _on_difficulty_changed(index: int) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_difficulty(index)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tutorial_pressed() -> void:
	var game_manager: Node = get_node_or_null("/root/GameManager")
	if game_manager and game_manager.has_method("go_to_tutorial"):
		game_manager.go_to_tutorial()

func _highlight_tutorial_if_new() -> void:
	if tutorial_button == null:
		return
	var save_mgr: Node = get_node_or_null("/root/SaveManager")
	if save_mgr and save_mgr.has_method("has_save") and not save_mgr.has_save():
		tutorial_button.modulate = Color.YELLOW
