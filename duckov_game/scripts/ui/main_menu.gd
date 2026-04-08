class_name MainMenu
extends Control

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $TitleLabel

func _ready() -> void:
	_setup_buttons()
	_check_save_exists()
	
	if title_label:
		title_label.text = "逃离鸭科夫"

func _setup_buttons() -> void:
	if new_game_button:
		new_game_button.pressed.connect(_on_new_game_pressed)
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

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
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
