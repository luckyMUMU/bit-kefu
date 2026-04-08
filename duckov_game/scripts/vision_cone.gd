class_name VisionCone
extends Node2D

@export var cone_angle: float = 90.0
@export var cone_radius: float = 300.0
@export var cone_color: Color = Color(1.0, 1.0, 0.8, 0.3)
@export var shadow_color: Color = Color(0.0, 0.0, 0.0, 0.7)
@export var update_interval: float = 0.05

var direction: Vector2 = Vector2.DOWN
var obstacles: Array = []

var _polygon: Polygon2D
var _shadow_polygon: Polygon2D
var _ray_cast_2d: RayCast2D
var _timer: Timer

signal vision_updated(visible_points: Array)

func _ready() -> void:
	_create_visual_components()
	_setup_timer()

func _create_visual_components() -> void:
	_shadow_polygon = Polygon2D.new()
	_shadow_polygon.color = shadow_color
	_shadow_polygon.z_index = -1
	add_child(_shadow_polygon)
	
	_polygon = Polygon2D.new()
	_polygon.color = cone_color
	add_child(_polygon)
	
	_ray_cast_2d = RayCast2D.new()
	_ray_cast_2d.enabled = false
	_ray_cast_2d.collision_mask = 64
	add_child(_ray_cast_2d)

func _setup_timer() -> void:
	_timer = Timer.new()
	_timer.wait_time = update_interval
	_timer.autostart = true
	_timer.timeout.connect(_update_vision)
	add_child(_timer)

func _update_vision() -> void:
	var points := _calculate_vision_polygon()
	
	if points.size() >= 3:
		_polygon.polygon = PackedVector2Array(points)
		_shadow_polygon.polygon = _create_shadow_polygon(points)
	
	vision_updated.emit(points)

func _calculate_vision_polygon() -> Array:
	var points: Array = []
	points.append(Vector2.ZERO)
	
	var half_angle := deg_to_rad(cone_angle / 2.0)
	var start_angle := direction.angle() - half_angle
	var end_angle := direction.angle() + half_angle
	
	var ray_count := int(cone_angle / 2.0)
	var angle_step := (end_angle - start_angle) / ray_count
	
	for i in range(ray_count + 1):
		var angle := start_angle + angle_step * i
		var ray_direction := Vector2(cos(angle), sin(angle))
		var point := _cast_ray(ray_direction)
		points.append(point)
	
	points.append(Vector2.ZERO)
	return points

func _cast_ray(direction: Vector2) -> Vector2:
	_ray_cast_2d.target_position = direction * cone_radius
	_ray_cast_2d.force_raycast_update()
	
	if _ray_cast_2d.is_colliding():
		return to_local(_ray_cast_2d.get_collision_point())
	
	return direction * cone_radius

func _create_shadow_polygon(vision_points: Array) -> PackedVector2Array:
	var shadow_points: PackedVector2Array = []
	var screen_size := Vector2(2000.0, 2000.0)
	
	shadow_points.append(Vector2(-screen_size.x, -screen_size.y))
	shadow_points.append(Vector2(screen_size.x, -screen_size.y))
	shadow_points.append(Vector2(screen_size.x, screen_size.y))
	shadow_points.append(Vector2(-screen_size.x, screen_size.y))
	
	for point in vision_points:
		shadow_points.append(point)
	
	return shadow_points

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()
	_update_vision()

func set_direction_to_point(point: Vector2) -> void:
	direction = (point - global_position).normalized()
	_update_vision()

func is_point_in_vision(point: Vector2) -> bool:
	var local_point := to_local(point)
	var distance := local_point.length()
	
	if distance > cone_radius:
		return false
	
	var point_angle := atan2(local_point.y, local_point.x)
	var half_angle := deg_to_rad(cone_angle / 2.0)
	var center_angle := direction.angle()
	
	var angle_diff := absf(wrapf(point_angle - center_angle, -PI, PI))
	return angle_diff <= half_angle

func get_visible_bodies() -> Array:
	var visible: Array = []
	var space_state := get_world_2d().direct_space_state
	
	var half_angle := deg_to_rad(cone_angle / 2.0)
	var start_angle := direction.angle() - half_angle
	var end_angle := direction.angle() + half_angle
	
	var ray_count := int(cone_angle / 5.0)
	var angle_step := (end_angle - start_angle) / ray_count
	
	for i in range(ray_count + 1):
		var angle := start_angle + angle_step * i
		var ray_direction := Vector2(cos(angle), sin(angle))
		
		var query := PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + ray_direction * cone_radius
		)
		query.collision_mask = 0xFFFFFF & ~1
		
		var result := space_state.intersect_ray(query)
		if result and result.collider:
			if result.collider not in visible:
				visible.append(result.collider)
	
	return visible

func set_cone_angle(angle: float) -> void:
	cone_angle = clampf(angle, 10.0, 360.0)
	_update_vision()

func set_cone_radius(radius: float) -> void:
	cone_radius = maxf(radius, 10.0)
	_update_vision()
