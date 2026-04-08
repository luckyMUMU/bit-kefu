class_name TutorialOverlay
extends Control

signal step_changed(step_index: int)
signal tutorial_completed
signal tutorial_skipped

@onready var dim_overlay: ColorRect = $DimOverlay
@onready var highlight_box: Panel = $HighlightBox
@onready var prompt_panel: PanelContainer = $PromptPanel
@onready var title_label: Label = $PromptPanel/PromptVBox/TitleLabel
@onready var description_label: RichTextLabel = $PromptPanel/PromptVBox/DescriptionLabel
@onready var key_hint_label: Label = $PromptPanel/PromptVBox/KeyHintLabel
@onready var progress_container: HBoxContainer = $ProgressContainer
@onready var skip_button: Button = $SkipButton

var tutorial_steps: Array = []
var current_step_index: int = -1
var is_active: bool = false
var is_waiting_for_input: bool = false

func _ready() -> void:
	visible = false
	_setup_skip_button()

func _setup_skip_button() -> void:
	if skip_button:
		skip_button.pressed.connect(_on_skip_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if not is_active or not is_waiting_for_input:
		return

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_on_skip_pressed()
			return
		_next_step()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed:
		_next_step()
		get_viewport().set_input_as_handled()

func start_tutorial(steps: Array) -> void:
	tutorial_steps = steps
	current_step_index = -1
	is_active = true
	visible = true

	_build_progress_dots()
	_next_step()

func _build_progress_dots() -> void:
	if progress_container == null:
		return

	for child in progress_container.get_children():
		child.queue_free()

	for i in range(tutorial_steps.size()):
		var dot := TextureRect.new()
		dot.custom_minimum_size = Vector2(12, 12)
		dot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		progress_container.add_child(dot)

	_update_progress_dots()

func _update_progress_dots() -> void:
	var children := progress_container.get_children() if progress_container else []
	for i in range(children.size()):
		var dot := children[i] as TextureRect
		if dot:
			if i < current_step_index:
				dot.modulate = Color.WHITE
			elif i == current_step_index:
				dot.modulate = Color.YELLOW
			else:
				dot.modulate = Color.GRAY

func next_step() -> void:
	_next_step()

func prev_step() -> void:
	if current_step_index > 0:
		current_step_index -= 1
		_show_current_step()
		step_changed.emit(current_step_index)

func _next_step() -> void:
	if tutorial_steps.is_empty():
		return

	current_step_index += 1

	if current_step_index >= tutorial_steps.size():
		_complete_tutorial()
		return

	_show_current_step()
	step_changed.emit(current_step_index)

func _show_current_step() -> void:
	if current_step_index < 0 or current_step_index >= tutorial_steps.size():
		return

	var step: Dictionary = tutorial_steps[current_step_index]

	var title := step.get("title", "")
	var description := step.get("description", "")
	var key_hint := step.get("key_hint", "按任意键继续...")
	var target_path := step.get("target", "")

	if title_label:
		title_label.text = title
	if description_label:
		description_label.text = description
	if key_hint_label:
		key_hint_label.text = key_hint

	if target_path != "":
		var target_node: Node = get_node_or_null(target_path)
		if target_node:
			highlight_area(target_node as Node2D)
		else:
			_hide_highlight()
	else:
		_hide_highlight()

	_update_progress_dots()
	is_waiting_for_input = true

func highlight_area(target: Node2D) -> void:
	if highlight_box == null:
		return

	var screen_pos: Vector2
	if target is Node2D:
		var camera := get_tree().get_first_node_of_group("camera") as Camera2D
		if camera:
			screen_pos = camera.unproject_position(target.global_position)
		else:
			screen_pos = target.global_position

	var size := Vector2(120, 120)
	if "size" in target:
		size = target.size

	highlight_box.visible = true
	highlight_box.position = screen_pos - size / 2.0
	highlight_box.custom_minimum_size = size

	var style := StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 0, 0.3)
	style.border_color = Color.YELLOW
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.set_corner_radius_all(8)
	highlight_box.add_theme_stylebox_override("panel", style)

func show_prompt(title: String, description: String, key_hint: String = "按任意键继续...") -> void:
	if title_label:
		title_label.text = title
	if description_label:
		description_label.text = description
	if key_hint_label:
		key_hint_label.text = key_hint

func _hide_highlight() -> void:
	if highlight_box:
		highlight_box.visible = false

func _complete_tutorial() -> void:
	is_active = false
	is_waiting_for_input = false
	visible = false
	_hide_highlight()
	tutorial_completed.emit()

func skip_tutorial() -> void:
	_on_skip_pressed()

func _on_skip_pressed() -> void:
	is_active = false
	is_waiting_for_input = false
	visible = false
	_hide_highlight()
	tutorial_skipped.emit()

func get_current_step() -> int:
	return current_step_index

func get_total_steps() -> int:
	return tutorial_steps.size()

func is_tutorial_active() -> bool:
	return is_active
