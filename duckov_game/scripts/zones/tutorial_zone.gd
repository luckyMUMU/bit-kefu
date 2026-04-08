class_name TutorialZone
extends CombatZone

# 教程步骤枚举：定义教学流程的各个阶段
enum TutorialStep {
	WELCOME,      # 0: 欢迎
	MOVE,        # 1: 移动教学
	ATTACK,      # 2: 攻击教学
	LOOT,        # 3: 搜刮教学
	COMBAT,      # 4: 战斗教学
	EXTRACT      # 5: 撤离教学
}

@export var zone_id: String = "tutorial"
@export var zone_name: String = "训练场"

var current_step: TutorialStep = TutorialStep.WELCOME
var step_completed: bool = false

var start_position: Vector2 = Vector2.ZERO
var total_moved_distance: float = 0.0
var target_hit_count: int = 0
var items_picked_up: int = 0
var enemies_defeated: int = 0

const MOVE_DISTANCE_REQUIRED: float = 200.0
const HITS_REQUIRED: int = 3

@onready var tutorial_overlay: TutorialOverlay = $TutorialOverlay
@onready var move_target: Area2D = $MoveTarget
@onready var training_target: Node2D = $TrainingTarget
@onready var tutorial_loot: LootContainer = $TutorialLoot
@onready var extraction_point: ExtractionPoint = $ExtractionZone

signal tutorial_step_changed(step: TutorialStep)
signal tutorial_finished

func _ready() -> void:
	# 不调用父类 _ready 的 _spawn_enemies（由教程自己控制敌人生成时机）
	_setup_zone()
	_spawn_player()
	_collect_loot_containers()
	
	start_position = player.global_position if player else Vector2.ZERO
	
	GameManager.change_state(GameManager.GameState.PLAYING)
	GameEvents.emit_zone_entered(zone_id)
	
	_start_tutorial()

func _start_tutorial() -> void:
	# 定义教程各阶段的教学内容配置
	var steps := [
		{
			"title": "欢迎来到鸭科夫！",
			"description": "这里是训练场，将教你生存的基本技能。\n\n在危险的世界中，你需要学会移动、战斗、搜刮物资并安全撤离。",
			"key_hint": "按任意键开始训练...",
			"target": ""
		},
		{
			"title": "第一阶段：移动",
			"description": "使用 [color=yellow]W A S D[/color] 键移动你的角色\n\n到达 [color=green]标记区域[/color] 以继续",
			"key_hint": "到达绿色标记区域自动继续",
			"target": "../MoveTarget"
		},
		{
			"title": "第二阶段：攻击",
			"description": "[color=yellow]移动鼠标[/color] 瞄准目标\n[color=yellow]左键点击[/color] 进行攻击\n\n击中靶标 [color=green]3 次[/color] 以继续",
			"key_hint": "击中靶标 3/3 后自动继续",
			"target": "../TrainingTarget"
		},
		{
			"title": "第三阶段：搜刮",
			"description": "走近 [color=yellow]战利品箱[/color]\n按 [color=yellow]E 键[/color] 搜刮物资\n\n这是获取装备的主要方式",
			"key_hint": "拾取物品后自动继续",
			"target": "../TutorialLoot"
		},
		{
			"title": "第四阶段：战斗",
			"[color=red]敌人会发起攻击！[/color]\n\n注意红色警告动画并使用 [color=yellow]空格键翻滚[/color] 闪避\n击败敌人以继续",
			"key_hint": "击败敌人后自动继续",
			"target": "../EnemySpawns/TutorialEnemySpawn"
		},
		{
			"title": "第五阶段：撤离",
			"description": "到达 [color=green]绿色烟雾标记[/color] 的撤离点\n按住 [color=yellow]E 键[/color] 开始撤离\n\n成功撤离保住所有战利品！",
			"key_hint": "完成撤离后显示结果",
			"target": "../ExtractionZone"
		}
	]
	
	if tutorial_overlay:
		tutorial_overlay.tutorial_completed.connect(_on_tutorial_complete)
		tutorial_overlay.tutorial_skipped.connect(_on_tutorial_skipped)
		tutorial_overlay.step_changed.connect(_on_overlay_step_changed)
		tutorial_overlay.start_tutorial(steps)
	
	_set_step(TutorialStep.WELCOME)

func _process(delta: float) -> void:
	_process_current_step(delta)

func _process_current_step(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	match current_step:
		TutorialStep.MOVE:
			_process_move_step(delta)
		TutorialStep.ATTACK:
			_process_attack_step()
		TutorialStep.LOOT:
			_process_loot_step()
		TutorialStep.COMBAT:
			_process_combat_step()
		TutorialStep.EXTRACT:
			_process_extract_step()

func _process_move_step(_delta: float) -> void:
	var current_pos := player.global_position if player else Vector2.ZERO
	var distance := current_pos.distance_to(start_position)
	total_moved_distance = distance
	
	if total_moved_distance >= MOVE_DISTANCE_REQUIRED:
		_advance_step()

func _process_attack_step() -> void:
	if target_hit_count >= HITS_REQUIRED:
		_advance_step()

func _process_loot_step() -> void:
	if items_picked_up >= 1:
		_advance_step()

func _process_combat_step() -> void:
	if enemies_defeated >= 1:
		_advance_step()

func _process_extract_step() -> void:
	if extraction_point and extraction_point.extraction_progress >= 1.0:
		_on_extraction_complete()

func _set_step(new_step: TutorialStep) -> void:
	current_step = new_step
	step_completed = false
	tutorial_step_changed.emit(new_step)
	
	match new_step:
		TutorialStep.MOVE:
			start_position = player.global_position if player else Vector2.ZERO
			total_moved_distance = 0.0
		TutorialStep.ATTACK:
			target_hit_count = 0
		TutorialStep.LOOT:
			items_picked_up = 0
		TutorialStep.COMBAT:
			enemies_defeated = 0
			_spawn_tutorial_enemy()
		TutorialStep.EXTRACT:
			if extraction_point:
				extraction_point.activate()

func _advance_step() -> void:
	if step_completed:
		return
	step_completed = true
	
	# 使用安全的枚举值转换方式
	var next_step_val: int = int(current_step) + 1
	var next: TutorialStep = TutorialStep.EXTRACT
	
	match next_step_val:
		0: next = TutorialStep.WELCOME
		1: next = TutorialStep.MOVE
		2: next = TutorialStep.ATTACK
		3: next = TutorialStep.LOOT
		4: next = TutorialStep.COMBAT
		5: next = TutorialStep.EXTRACT
		_:
			return  # 超出范围则不推进
	
	_set_step(next)
	
	if tutorial_overlay:
		tutorial_overlay.next_step()

func _spawn_tutorial_enemy() -> void:
	var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
	var spawn_marker := $EnemySpawns/TutorialEnemySpawn if has_node("EnemySpawns/TutorialEnemySpawn") else null
	
	if enemy_scene == null:
		return
	
	var enemy := enemy_scene.instantiate()
	
	if spawn_marker:
		enemy.global_position = spawn_marker.global_position
	else:
		enemy.global_position = Vector2(900, 500)
	
	add_child(enemy)
	enemies.append(enemy)
	
	# 配置弱化的教程敌人数据
	enemy.max_health = 30.0
	enemy.current_health = 30.0
	enemy.damage = 5.0
	enemy.move_speed = 80.0
	
	# 安全连接敌人死亡信号
	if enemy.has_node("HealthComponent"):
		var hc := enemy.get_node("HealthComponent")
		if hc.has_method("take_damage") and hc.has_signal("died"):
			hc.died.connect(_on_tutorial_enemy_died)
	
	GameEvents.emit_enemy_spawned(enemy)

func _on_tutorial_target_hit() -> void:
	target_hit_count += 1

func _on_item_pickup() -> void:
	items_picked_up += 1

func _on_tutorial_enemy_died() -> void:
	enemies_defeated += 1

func _on_extraction_complete() -> void:
	tutorial_finished.emit()
	if tutorial_overlay:
		tutorial_overlay.skip_tutorial()
	
	await get_tree().create_timer(0.5).timeout
	GameManager.player_extracted()

func _on_overlay_step_changed(step_idx: int) -> void:
	match step_idx:
		0: _set_step(TutorialStep.WELCOME)
		1: _set_step(TutorialStep.MOVE)
		2: _set_step(TutorialStep.ATTACK)
		3: _set_step(TutorialStep.LOOT)
		4: _set_step(TutorialStep.COMBAT)
		5: _set_step(TutorialStep.EXTRACT)

func _on_tutorial_complete() -> void:
	# 标记教程完成状态到玩家数据
	var pd := GameManager.player_data
	if pd:
		pd.tutorial_completed = true

func _on_tutorial_skipped() -> void:
	pass
