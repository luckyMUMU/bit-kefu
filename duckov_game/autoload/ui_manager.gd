extends Node

var ui_layers: Dictionary = {}
var current_popup: Control = null

const LAYER_BACKGROUND := "background"
const LAYER_GAME := "game"
const LAYER_HUD := "hud"
const LAYER_POPUP := "popup"

signal popup_opened(popup: Control)
signal popup_closed(popup: Control)

func _ready() -> void:
	_create_ui_layers()

func _create_ui_layers() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 0
	add_child(canvas)
	ui_layers[LAYER_BACKGROUND] = canvas
	
	canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	ui_layers[LAYER_GAME] = canvas
	
	canvas = CanvasLayer.new()
	canvas.layer = 20
	add_child(canvas)
	ui_layers[LAYER_HUD] = canvas
	
	canvas = CanvasLayer.new()
	canvas.layer = 30
	add_child(canvas)
	ui_layers[LAYER_POPUP] = canvas

func add_to_layer(node: Control, layer_name: String) -> void:
	if ui_layers.has(layer_name):
		ui_layers[layer_name].add_child(node)
	else:
		push_error("UI layer not found: " + layer_name)

func remove_from_layer(node: Control) -> void:
	if node.get_parent():
		node.get_parent().remove_child(node)

func show_popup(popup_scene: PackedScene, data: Dictionary = {}) -> Control:
	if current_popup:
		close_popup()
	
	current_popup = popup_scene.instantiate()
	
	for key in data:
		if current_popup.has_method("set_" + key):
			current_popup.call("set_" + key, data[key])
		elif key in current_popup:
			current_popup.set(key, data[key])
	
	add_to_layer(current_popup, LAYER_POPUP)
	get_tree().paused = true
	popup_opened.emit(current_popup)
	return current_popup

func close_popup() -> void:
	if current_popup:
		var popup := current_popup
		current_popup = null
		remove_from_layer(popup)
		popup.queue_free()
		get_tree().paused = false
		popup_closed.emit(popup)

func show_message(title: String, message: String, callback: Callable = Callable()) -> void:
	var popup := _create_message_popup(title, message, callback)
	add_to_layer(popup, LAYER_POPUP)
	current_popup = popup
	get_tree().paused = true
	popup_opened.emit(popup)

func show_confirm(title: String, message: String, on_confirm: Callable, on_cancel: Callable = Callable()) -> void:
	var popup := _create_confirm_popup(title, message, on_confirm, on_cancel)
	add_to_layer(popup, LAYER_POPUP)
	current_popup = popup
	get_tree().paused = true
	popup_opened.emit(popup)

func _create_message_popup(title: String, message: String, callback: Callable) -> Control:
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(400, 200)
	
	var vbox := VBoxContainer.new()
	panel.add_child(vbox)
	
	var title_label := Label.new()
	title_label.text = title
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title_label)
	
	var message_label := Label.new()
	message_label.text = message
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(message_label)
	
	var ok_button := Button.new()
	ok_button.text = "OK"
	ok_button.pressed.connect(func():
		close_popup()
		if callback.is_valid():
			callback.call()
	)
	vbox.add_child(ok_button)
	
	return panel

func _create_confirm_popup(title: String, message: String, on_confirm: Callable, on_cancel: Callable) -> Control:
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(400, 200)
	
	var vbox := VBoxContainer.new()
	panel.add_child(vbox)
	
	var title_label := Label.new()
	title_label.text = title
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title_label)
	
	var message_label := Label.new()
	message_label.text = message
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(message_label)
	
	var hbox := HBoxContainer.new()
	vbox.add_child(hbox)
	
	var cancel_button := Button.new()
	cancel_button.text = "Cancel"
	cancel_button.pressed.connect(func():
		close_popup()
		if on_cancel.is_valid():
			on_cancel.call()
	)
	hbox.add_child(cancel_button)
	
	var confirm_button := Button.new()
	confirm_button.text = "Confirm"
	confirm_button.pressed.connect(func():
		close_popup()
		if on_confirm.is_valid():
			on_confirm.call()
	)
	hbox.add_child(confirm_button)
	
	return panel
