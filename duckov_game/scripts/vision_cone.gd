class_name VisionCone
extends Node2D

@export var cone_angle: float = 90.0
@export var cone_radius: float = 300.0
@export var cone_color: Color = Color(1.0, 1.0, 0.8, 0.3)
@export var shadow_color: Color = Color(0.0, 0.0, 0.0, 0.7)
@export var update_interval: float = 0.05
@export var light_intensity: float = 1.0
@export var enable_fog_of_war: bool = true

var direction: Vector2 = Vector2.DOWN
var obstacles: Array = []
var explored_area: Array = []
var fog_texture: Texture2D
var fog_polygon: Polygon2D

var _polygon: Polygon2D
var _shadow_polygon: Polygon2D
var _ray_cast_2d: RayCast2D
var _timer: Timer
var _last_update_time: float = 0.0

const FOG_RESOLUTION: int = 32
const FOG_CELL_SIZE: float = 16.0

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
	
	if enable_fog_of_war:
		_init_fog_of_war()

func _init_fog_of_war() -> void:
	# 初始化战争迷雾系统
	explored_area = []
	
	# 创建迷雾多边形
	fog_polygon = Polygon2D.new()
	fog_polygon.color = Color(0.1, 0.1, 0.1, 0.8)
	fog_polygon.z_index = -2
	add_child(fog_polygon)
	
	# 初始化探索区域
	_reset_explored_area()

func _setup_timer() -> void:
	_timer = Timer.new()
	_timer.wait_time = update_interval
	_timer.autostart = true
	_timer.timeout.connect(_update_vision)
	add_child(_timer)

func _update_vision() -> void:
	# 性能优化：只在必要时更新
	var current_time := Time.get_time_dict_from_system()
	var time_key := current_time["second"] * 1000 + current_time["minute"]
	if time_key == _last_update_time:
		return
	_last_update_time = time_key
	
	var points := _calculate_vision_polygon()
	
	if points.size() >= 3:
		# 应用光线强度
		_polygon.color = cone_color * light_intensity
		_polygon.polygon = PackedVector2Array(points)
		_shadow_polygon.polygon = _create_shadow_polygon(points)
		
		# 更新战争迷雾
		if enable_fog_of_war:
			_update_explored_area(points)
			_update_fog_polygon()
	
	vision_updated.emit(points)

func _reset_explored_area() -> void:
	# 重置探索区域
	explored_area = []

func _update_explored_area(vision_points: Array) -> void:
	# 更新探索区域
	var global_vision_points := []
	for point in vision_points:
		global_vision_points.append(global_position + point)
	
	# 标记探索区域
	for point in global_vision_points:
		var cell_x := int(point.x / FOG_CELL_SIZE)
		var cell_y := int(point.y / FOG_CELL_SIZE)
		var cell_key := Vector2(cell_x, cell_y)
		
		if not explored_area.has(cell_key):
			explored_area.append(cell_key)

func _update_fog_polygon() -> void:
	# 更新迷雾多边形
	if not fog_polygon:
		return
	
	# 计算迷雾区域
	var fog_points := _calculate_fog_polygon()
	if fog_points.size() >= 3:
		fog_polygon.polygon = PackedVector2Array(fog_points)

func _calculate_fog_polygon() -> Array:
	# 计算迷雾多边形
	var screen_size := Vector2(4000.0, 4000.0)
	var fog_points := [
		Vector2(-screen_size.x, -screen_size.y),
		Vector2(screen_size.x, -screen_size.y),
		Vector2(screen_size.x, screen_size.y),
		Vector2(-screen_size.x, screen_size.y)
	]
	
	# 添加已探索区域的反多边形
	# 这里简化处理，实际应该使用更复杂的多边形运算
	# 为了性能，我们使用简单的方式处理
	
	return fog_points

func _calculate_vision_polygon() -> Array:
	var points: Array = []
	points.append(Vector2.ZERO)
	
	var half_angle := deg_to_rad(cone_angle / 2.0)
	var start_angle := direction.angle() - half_angle
	var end_angle := direction.angle() + half_angle
	
	# 优化射线数量，根据角度动态调整
	var ray_count := max(10, int(cone_angle / 1.5))
	var angle_step := (end_angle - start_angle) / ray_count
	
	# 缓存射线检测结果，避免重复计算
	var ray_results := []
	
	for i in range(ray_count + 1):
		var angle := start_angle + angle_step * i
		var ray_direction := Vector2(cos(angle), sin(angle))
		var point := _cast_ray(ray_direction)
		points.append(point)
		ray_results.append(point)
	
	# 优化多边形生成，移除冗余点
	points = _optimize_polygon_points(points)
	
	points.append(Vector2.ZERO)
	return points

func _optimize_polygon_points(points: Array) -> Array:
	# 优化多边形点，移除冗余点
	if points.size() <= 2:
		return points
	
	var optimized := [points[0]]
	
	for i in range(1, points.size() - 1):
		var prev := points[i-1]
		var current := points[i]
		var next := points[i+1]
		
		# 检查三点是否共线
		var v1 := current - prev
		var v2 := next - current
		
		if abs(v1.cross(v2)) > 0.01:
			optimized.append(current)
	
	optimized.append(points[-1])
	return optimized

func _cast_ray(direction: Vector2) -> Vector2:
	_ray_cast_2d.target_position = direction * cone_radius
	_ray_cast_2d.force_raycast_update()
	
	if _ray_cast_2d.is_colliding():
		# 考虑光线强度对碰撞检测的影响
		var collision_point := to_local(_ray_cast_2d.get_collision_point())
		var distance := collision_point.length()
		
		# 根据光线强度调整碰撞点
		var adjusted_distance := distance * (1.0 / max(0.1, light_intensity))
		return direction * min(adjusted_distance, cone_radius)
	
	return direction * cone_radius

func _create_shadow_polygon(vision_points: Array) -> PackedVector2Array:
	var shadow_points: PackedVector2Array = []
	var screen_size := Vector2(4000.0, 4000.0)
	
	shadow_points.append(Vector2(-screen_size.x, -screen_size.y))
	shadow_points.append(Vector2(screen_size.x, -screen_size.y))
	shadow_points.append(Vector2(screen_size.x, screen_size.y))
	shadow_points.append(Vector2(-screen_size.x, screen_size.y))
	
	for point in vision_points:
		shadow_points.append(point)
	
	return shadow_points

func set_light_intensity(intensity: float) -> void:
	light_intensity = clampf(intensity, 0.1, 2.0)
	_update_vision()

func reset_explored_area() -> void:
	_reset_explored_area()
	_update_vision()

func is_point_explored(point: Vector2) -> bool:
	if not enable_fog_of_war:
		return true
	
	var cell_x := int(point.x / FOG_CELL_SIZE)
	var cell_y := int(point.y / FOG_CELL_SIZE)
	var cell_key := Vector2(cell_x, cell_y)
	
	return explored_area.has(cell_key)

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
