extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS := 8

var music_volume: float = 0.8
var sfx_volume: float = 1.0
var music_muted: bool = false
var sfx_muted: bool = false

signal volume_changed(type: String, value: float)

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	for i in MAX_SFX_PLAYERS:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)
	
	_load_settings()

func play_music(stream: AudioStream, fade_duration: float = 1.0) -> void:
	if music_player.stream == stream:
		return
	
	if music_player.playing:
		var tween := create_tween()
		tween.tween_property(music_player, "volume_db", -40.0, fade_duration)
		await tween.finished
	
	music_player.stream = stream
	music_player.volume_db = -40.0 if music_player.playing else linear_to_db(music_volume if not music_muted else 0.0)
	music_player.play()
	
	var fade_in := create_tween()
	fade_in.tween_property(music_player, "volume_db", linear_to_db(music_volume if not music_muted else 0.0), fade_duration)

func stop_music(fade_duration: float = 1.0) -> void:
	if not music_player.playing:
		return
	
	var tween := create_tween()
	tween.tween_property(music_player, "volume_db", -40.0, fade_duration)
	await tween.finished
	music_player.stop()

func play_sfx(stream: AudioStream, volume_scale: float = 1.0) -> void:
	if sfx_muted:
		return
	
	var player := _get_available_sfx_player()
	if player == null:
		return
	
	player.stream = stream
	player.volume_db = linear_to_db(sfx_volume * volume_scale)
	player.play()

func play_sfx_at_position(stream: AudioStream, position: Vector2, volume_scale: float = 1.0) -> void:
	if sfx_muted:
		return
	
	var player := _get_available_sfx_player()
	if player == null:
		return
	
	var listener := get_viewport().get_camera_2d()
	if listener:
		var distance := position.distance_to(listener.global_position)
		var max_distance := 800.0
		var attenuation: float = 1.0 - clamp(distance / max_distance, 0.0, 1.0)
		volume_scale *= attenuation
	
	player.stream = stream
	player.volume_db = linear_to_db(sfx_volume * volume_scale)
	player.play()

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	if music_player.playing and not music_muted:
		music_player.volume_db = linear_to_db(music_volume)
	volume_changed.emit("music", music_volume)
	_save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	volume_changed.emit("sfx", sfx_volume)
	_save_settings()

func toggle_music_mute() -> void:
	music_muted = not music_muted
	music_player.volume_db = linear_to_db(0.0 if music_muted else music_volume)

func toggle_sfx_mute() -> void:
	sfx_muted = not sfx_muted

func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return null

func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "music_muted", music_muted)
	config.set_value("audio", "sfx_muted", sfx_muted)
	config.save("user://audio_settings.cfg")

func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load("user://audio_settings.cfg") != OK:
		return
	
	music_volume = config.get_value("audio", "music_volume", 0.8)
	sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
	music_muted = config.get_value("audio", "music_muted", false)
	sfx_muted = config.get_value("audio", "sfx_muted", false)
