class_name SettingsManager
extends Node

enum Difficulty {EASY, NORMAL, HARD}

var settings: Dictionary = {
	"graphics": {
		"quality": "high",
		"fullscreen": false,
		"vsync": true,
		"antialiasing": "msaa2x",
		"texture_filter": "linear"
	},
	"audio": {
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"master_volume": 1.0
	},
	"gameplay": {
		"difficulty": 1,
		"show_tutorial": true,
		"auto_save": true,
		"language": "zh"
	},
	"controls": {
		"invert_y": false,
		"sensitivity": 1.0,
		"deadzone": 0.2
	}
}

signal settings_changed(category: String, key: String, value: Variant)
signal difficulty_changed(difficulty: int)

const SETTINGS_PATH := "user://settings.json"

func _ready() -> void:
	_load_settings()
	_apply_settings()

func save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to save settings")
		return
	
	var json_string := JSON.stringify(settings, "\t")
	file.store_string(json_string)
	file.close()

func _load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_result := json.parse(json_string)
	
	if parse_result != OK:
		push_error("Failed to parse settings file")
		return
	
	var loaded_settings: Dictionary = json.data
	for category in loaded_settings:
		if settings.has(category):
			for key in loaded_settings[category]:
				settings[category][key] = loaded_settings[category][key]

func _apply_settings() -> void:
	_apply_graphics_settings()
	_apply_audio_settings()
	_apply_gameplay_settings()

func get_setting(category: String, key: String) -> Variant:
	if settings.has(category) and settings[category].has(key):
		return settings[category][key]
	return null

func set_setting(category: String, key: String, value: Variant) -> void:
	if settings.has(category):
		settings[category][key] = value
		settings_changed.emit(category, key, value)
		save_settings()
		_apply_category_setting(category, key, value)

func _apply_category_setting(category: String, key: String, value: Variant) -> void:
	match category:
		"graphics":
			_apply_graphics_setting(key, value)
		"audio":
			_apply_audio_setting(key, value)
		"gameplay":
			_apply_gameplay_setting(key, value)

func _apply_graphics_settings() -> void:
	_apply_graphics_setting("fullscreen", settings.graphics.fullscreen)
	_apply_graphics_setting("vsync", settings.graphics.vsync)
	_apply_graphics_setting("texture_filter", settings.graphics.texture_filter)

func _apply_graphics_setting(key: String, value: Variant) -> void:
	match key:
		"fullscreen":
			var window_mode := DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED
			get_window().mode = window_mode
		"vsync":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if value else DisplayServer.VSYNC_DISABLED)
		"texture_filter":
			pass

func _apply_audio_settings() -> void:
	if AudioManager:
		AudioManager.set_music_volume(settings.audio.music_volume)
		AudioManager.set_sfx_volume(settings.audio.sfx_volume)

func _apply_audio_setting(key: String, value: Variant) -> void:
	match key:
		"music_volume":
			if AudioManager:
				AudioManager.set_music_volume(value)
		"sfx_volume":
			if AudioManager:
				AudioManager.set_sfx_volume(value)

func _apply_gameplay_settings() -> void:
	difficulty_changed.emit(settings.gameplay.difficulty)

func _apply_gameplay_setting(key: String, value: Variant) -> void:
	match key:
		"difficulty":
			difficulty_changed.emit(value)

func get_difficulty() -> int:
	return settings.gameplay.difficulty

func set_difficulty(difficulty: int) -> void:
	set_setting("gameplay", "difficulty", difficulty)

func get_difficulty_name(difficulty: int) -> String:
	match difficulty:
		Difficulty.EASY:
			return "Easy"
		Difficulty.NORMAL:
			return "Normal"
		Difficulty.HARD:
			return "Hard"
		_:
			return "Unknown"

func get_music_volume() -> float:
	return settings.audio.music_volume

func set_music_volume(volume: float) -> void:
	set_setting("audio", "music_volume", clampf(volume, 0.0, 1.0))

func get_sfx_volume() -> float:
	return settings.audio.sfx_volume

func set_sfx_volume(volume: float) -> void:
	set_setting("audio", "sfx_volume", clampf(volume, 0.0, 1.0))

func is_fullscreen() -> bool:
	return settings.graphics.fullscreen

func set_fullscreen(enabled: bool) -> void:
	set_setting("graphics", "fullscreen", enabled)

func get_sensitivity() -> float:
	return settings.controls.sensitivity

func set_sensitivity(value: float) -> void:
	set_setting("controls", "sensitivity", clampf(value, 0.1, 3.0))

func reset_to_defaults() -> void:
	settings = {
		"graphics": {
			"quality": "high",
			"fullscreen": false,
			"vsync": true,
			"antialiasing": "msaa2x",
			"texture_filter": "linear"
		},
		"audio": {
			"music_volume": 0.8,
			"sfx_volume": 1.0,
			"master_volume": 1.0
		},
		"gameplay": {
			"difficulty": 1,
			"show_tutorial": true,
			"auto_save": true,
			"language": "zh"
		},
		"controls": {
			"invert_y": false,
			"sensitivity": 1.0,
			"deadzone": 0.2
		}
	}
	save_settings()
	_apply_settings()
