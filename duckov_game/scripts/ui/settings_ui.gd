class_name SettingsUI
extends Control

@onready var tab_container: TabContainer = $MarginContainer/TabContainer
@onready var graphics_tab: Control = $MarginContainer/TabContainer/GraphicsTab
@onready var audio_tab: Control = $MarginContainer/TabContainer/AudioTab
@onready var gameplay_tab: Control = $MarginContainer/TabContainer/GameplayTab
@onready var controls_tab: Control = $MarginContainer/TabContainer/ControlsTab

@onready var fullscreen_checkbox: CheckBox = $MarginContainer/TabContainer/GraphicsTab/VBoxContainer/FullscreenCheckbox
@onready var vsync_checkbox: CheckBox = $MarginContainer/TabContainer/GraphicsTab/VBoxContainer/VsyncCheckbox

@onready var music_slider: HSlider = $MarginContainer/TabContainer/AudioTab/VBoxContainer/MusicSlider
@onready var music_value: Label = $MarginContainer/TabContainer/AudioTab/VBoxContainer/MusicSlider/MusicValue
@onready var sfx_slider: HSlider = $MarginContainer/TabContainer/AudioTab/VBoxContainer/SfxSlider
@onready var sfx_value: Label = $MarginContainer/TabContainer/AudioTab/VBoxContainer/SfxSlider/SfxValue

@onready var difficulty_option: OptionButton = $MarginContainer/TabContainer/GameplayTab/VBoxContainer/DifficultyOption
@onready var autosave_checkbox: CheckBox = $MarginContainer/TabContainer/GameplayTab/VBoxContainer/AutosaveCheckbox

@onready var sensitivity_slider: HSlider = $MarginContainer/TabContainer/ControlsTab/VBoxContainer/SensitivitySlider
@onready var sensitivity_value: Label = $MarginContainer/TabContainer/ControlsTab/VBoxContainer/SensitivitySlider/SensitivityValue
@onready var invert_y_checkbox: CheckBox = $MarginContainer/TabContainer/ControlsTab/VBoxContainer/InvertYCheckbox

@onready var close_button: Button = $MarginContainer/CloseButton
@onready var reset_button: Button = $MarginContainer/ResetButton

signal closed

func _ready() -> void:
	_setup_signals()
	_load_current_settings()
	visible = false

func _get_settings() -> Node:
	return get_node_or_null("/root/SettingsManager")

func _setup_signals() -> void:
	if close_button:
		close_button.pressed.connect(close)
	if reset_button:
		reset_button.pressed.connect(_reset_settings)
	
	if fullscreen_checkbox:
		fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	if vsync_checkbox:
		vsync_checkbox.toggled.connect(_on_vsync_toggled)
	
	if music_slider:
		music_slider.value_changed.connect(_on_music_slider_changed)
	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	
	if difficulty_option:
		difficulty_option.item_selected.connect(_on_difficulty_selected)
	if autosave_checkbox:
		autosave_checkbox.toggled.connect(_on_autosave_toggled)
	
	if sensitivity_slider:
		sensitivity_slider.value_changed.connect(_on_sensitivity_slider_changed)
	if invert_y_checkbox:
		invert_y_checkbox.toggled.connect(_on_invert_y_toggled)

func _load_current_settings() -> void:
	var settings := _get_settings()
	if settings == null:
		return

	if fullscreen_checkbox:
		fullscreen_checkbox.button_pressed = settings.is_fullscreen()
	if vsync_checkbox:
		vsync_checkbox.button_pressed = settings.get_setting("graphics", "vsync")

	if music_slider:
		music_slider.value = settings.get_music_volume()
	if music_value:
		music_value.text = "%d%%" % int(settings.get_music_volume() * 100)
	if sfx_slider:
		sfx_slider.value = settings.get_sfx_volume()
	if sfx_value:
		sfx_value.text = "%d%%" % int(settings.get_sfx_volume() * 100)

	if difficulty_option:
		difficulty_option.selected = settings.get_difficulty()
	if autosave_checkbox:
		autosave_checkbox.button_pressed = settings.get_setting("gameplay", "auto_save")

	if sensitivity_slider:
		sensitivity_slider.value = settings.get_sensitivity()
	if sensitivity_value:
		sensitivity_value.text = "%.1f" % settings.get_sensitivity()
	if invert_y_checkbox:
		invert_y_checkbox.button_pressed = settings.get_setting("controls", "invert_y")

func open() -> void:
	_load_current_settings()
	visible = true
	get_tree().paused = true

func close() -> void:
	visible = false
	get_tree().paused = false
	closed.emit()

func _reset_settings() -> void:
	var settings := _get_settings()
	if settings:
		settings.reset_to_defaults()
		_load_current_settings()

func _on_fullscreen_toggled(checked: bool) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_fullscreen(checked)

func _on_vsync_toggled(checked: bool) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_setting("graphics", "vsync", checked)

func _on_music_slider_changed(value: float) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_music_volume(value)
	if music_value:
		music_value.text = "%d%%" % int(value * 100)

func _on_sfx_slider_changed(value: float) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_sfx_volume(value)
	if sfx_value:
		sfx_value.text = "%d%%" % int(value * 100)

func _on_difficulty_selected(index: int) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_difficulty(index)

func _on_autosave_toggled(checked: bool) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_setting("gameplay", "auto_save", checked)

func _on_sensitivity_slider_changed(value: float) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_sensitivity(value)
	if sensitivity_value:
		sensitivity_value.text = "%.1f" % value

func _on_invert_y_toggled(checked: bool) -> void:
	var settings := _get_settings()
	if settings:
		settings.set_setting("controls", "invert_y", checked)
