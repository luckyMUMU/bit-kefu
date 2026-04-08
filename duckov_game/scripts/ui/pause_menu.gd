class_name PauseMenu
extends Control

@onready var resume_button: Button = $Panel/VBox/ResumeButton
@onready var settings_button: Button = $Panel/VBox/SettingsButton
@onready var main_menu_button: Button = $Panel/VBox/MainMenuButton
@onready var quit_button: Button = $Panel/VBox/QuitButton

signal resume_requested

func _ready() -> void:
	visible = false
	_setup_buttons()

func _setup_signals() -> void:
	if resume_button:
		resume_button.pressed.connect(_on_resume)
	if settings_button:
		settings_button.pressed.connect(_on_settings)
	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu)
	if quit_button:
		quit_button.pressed.connect(_on_quit)

func _setup_buttons() -> void:
	_setup_signals()

func open() -> void:
	visible = true
	get_tree().paused = true

func close() -> void:
	visible = false
	get_tree().paused = false

func toggle() -> void:
	if visible:
		close()
	else:
		open()

func _on_resume() -> void:
	close()
	resume_requested.emit()

func _on_settings() -> void:
	var settings_scene: PackedScene = load("res://scenes/ui/settings_ui.tscn")
	if settings_scene == null:
		return
	var settings_ui := settings_scene.instantiate()
	add_child(settings_ui)
	if settings_ui.has_method("open"):
		settings_ui.open()

func _on_main_menu() -> void:
	close()
	var game_manager: Node = get_node_or_null("/root/GameManager")
	if game_manager and game_manager.has_method("go_to_main_menu"):
		game_manager.go_to_main_menu()

func _on_quit() -> void:
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if visible:
			toggle()
