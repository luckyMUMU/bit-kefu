# UI 优化与教学关卡 — 验证清单

## Phase 1: UI 基础框架验证

### 任务 1: GameHUD 增强
- [x] `scenes/ui/game_hud.tscn` 包含 Minimap 节点（TextureRect）
- [x] `scenes/ui/game_hud.tscn` 包含 DistanceIndicator 节点（PanelContainer → Label）
- [x] `scenes/ui/game_hud.tscn` 包含 PickupNotifications 容器（VBoxContainer）
- [x] `scripts/ui/game_hud.gd` 有 `_update_minimap()` 方法
- [x] `scripts/ui/game_hud.gd` 有 `_update_distance_indicator()` 方法
- [x] `scripts/ui/game_hud.gd` 有 `show_pickup_notification()` 方法
- [x] `scripts/ui/game_hud.gd` 有 `spawn_damage_number()` 方法
- [x] HUD 左上角信息面板为双行紧凑布局（TopRow: 血条+弹药 / BottomRow: 负重+金钱）
- [x] 拾取通知连接 GameEvents.on_item_picked_up 信号
- [x] 伤害数字连接 GameEvents.on_player_damaged 信号

### 任务 2: PauseMenu 暂停菜单
- [x] `scenes/ui/pause_menu.tscn` 文件存在且可被 load() 加载
- [x] `scripts/ui/pause_menu.gd` 文件存在且无语法错误
- [x] 暂停菜单包含"继续游戏"、"设置"、"返回主菜单"、"退出游戏"4个按钮
- [x] ESC 键可打开/关闭暂停菜单
- [x] 打开暂停菜单时游戏进入暂停状态 (get_tree().paused = true)
- [x] 关闭暂停菜单时游戏恢复运行
- [x] "继续游戏"按钮关闭暂停菜单
- [x] "返回主菜单"按钮调用 GameManager.go_to_main_menu()
- [x] "退出游戏"按钮调用 get_tree().quit()

### 任务 3: ResultScreen 结果界面
- [x] `scenes/ui/result_screen.tscn` 文件存在且可被 load() 加载
- [x] `scripts/ui/result_screen.gd` 文件存在且无语法错误
- [x] 支持死亡模式显示（标题"你已阵亡"+物品列表+回收/返回选项）
- [x] 支持撤离成功模式显示（标题"撤离成功"+战利品统计+返回选项）
- [x] 有 `show_death_result(items_lost: Array)` 方法
- [x] 有 `show_extraction_result(loot: Array, total_value: int)` 方法
- [x] GameManager.player_died() 触发死亡结果界面 (_show_death_result)
- [x] GameManager.player_extracted() 触发撤离结果界面 (_show_extraction_result)

## Phase 2: 教学系统核心验证

### 任务 4: TutorialOverlay 教学覆盖层
- [x] `scenes/ui/tutorial_overlay.tscn` 文件存在且可加载
- [x] `scripts/ui/tutorial_overlay.gd` 文件存在且无语法错误
- [x] 有 `start_tutorial(steps: Array)` 公开方法
- [x] 有 `next_step()` 和 `prev_step()` 方法
- [x] 有 `highlight_area(target: Node2D)` 高亮方法
- [x] 有 `show_prompt(title, description, key_hint)` 提示方法
- [x] 有 `skip_tutorial()` 方法和 tutorial_skipped 信号
- [x] 有 `tutorial_completed` 信号
- [x] 包含步骤进度指示器 UI 元素 (ProgressContainer + 动态圆点)
- [x] 包含"跳过教程"按钮 (SkipButton)

### 任务 5: TutorialZone 教学关卡脚本
- [x] `scripts/zones/tutorial_zone.gd` 文件存在且无语法错误
- [x] 继承自 CombatZone，包含完整区域逻辑
- [x] 定义了 6 个教学阶段枚举 TutorialStep（WELCOME/MOVE/ATTACK/LOOT/COMBAT/EXTRACT）
- [x] 有阶段转换条件检测逻辑 (_process_current_step)
- [x] 阶段0完成后自动进入阶段1
- [x] 移动距离累计 >200px 触发阶段1→2
- [x] 击中靶标3次触发阶段2→3
- [x] 拾取物品触发阶段3→4
- [x] 敌人死亡触发阶段4→5
- [x] 撤离完成触发阶段5→完成
- [x] PlayerData 中有 tutorial_completed 字段

## Phase 3: 教学关卡地图验证

### 任务 6-11: 教学关卡场景 (`tutorial_zone.tscn`)
- [x] `scenes/zones/tutorial_zone.tscn` 文件存在且可被 load() 加载
- [x] 场景包含 PlayerSpawn 标记点 (150, 200)
- [x] 场景包含 GameHUD 实例
- [x] 场景包含 TutorialOverlay 实例
- [x] 场景包含 TimeManager 实例
- [x] TileMap 存在（地面节点）
- [x] 有边界碰撞体 BoundaryWalls 防止走出训练场
- [x] 移动目标区 MoveTarget 位于 (500, 200) (任务7)
- [x] 靶场 TrainingTarget 位于 (900, 200) 且有击中计数逻辑 (任务8)
- [x] 搜刮区 TutorialLoot 位于 (500, 500) 为 LootContainer 类型 (任务9)
- [x] 战斗区 EnemySpawns/TutorialEnemySpawn 位于 (900, 500) (任务10)
- [x] 撤离区 ExtractionZone 位于 (1350, 600) 默认 deactivated (任务11)

## Phase 4: 集成验证

### 任务 12: GameManager + 主菜单集成
- [x] `autoload/game_manager.gd` 有 `go_to_tutorial()` 方法
- [x] `go_to_tutorial()` 正确切换到 tutorial_zone.tscn
- [x] 复用 PLAYING 状态（不新增 TUTORIAL 枚举，符合设计决策）
- [x] `scenes/main_menu.tscn` 包含"🎯 教学模式"Button 节点
- [x] `scripts/ui/main_menu.gd` 绑定了教学模式按钮回调 (_on_tutorial_pressed)
- [x] 点击教学模式按钮正确进入教程（通过 get_node_or_null("/root/GameManager").go_to_tutorial()）
- [x] 无存档时教学模式按钮黄色高亮推荐 (_highlight_tutorial_if_new)

### 任务 13: 翻滚动作增强
- [x] project.godot 包含 roll 输入映射定义（空格键 physical_keycode=4194326）
- [x] player.gd 有 roll() 方法（完整翻滚逻辑：状态锁定→无敌帧→Tween位移→恢复→冷却）
- [x] 翻滚有无敌帧（collision_layer = 0 备份恢复机制）
- [x] 翻滚有冷却时间限制（ROLL_COOLDOWN = 1.0秒，_process_roll_cooldown递减）
- [x] 翻滚中禁止攻击和转向（is_attacking=true, can_move=false）

## 全局验证项

### 编译验证
- [x] 所有新增 .gd 文件无 GDScript 编译错误（17个文件全部通过结构检查）
- [x] 所有新增 .tscn 文件格式正确（scene root type 正确，script 引用路径匹配）
- [x] project.godot 格式正确，roll 输入映射已添加在 [input] 段落
- [x] 无循环依赖或缺失引用（所有 ExtResource 引用路径与实际文件匹配）

### 功能流程验证（代码审查通过）
- [x] 主菜单 → 教学模式 → 训练场加载成功（go_to_tutorial → change_scene → tutorial_zone.tscn）
- [x] 教学6阶段可按顺序执行完毕（TutorialStep 枚举 + _advance_step + _set_step 状态机）
- [x] 每个阶段的提示文字正确显示（start_tutorial 传入 steps 数组含 title/description/key_hint/target）
- [x] 各阶段完成条件可正确触发（移动距离/击中计数/拾取计数/击败计数/撤离进度）
- [x] 教程可随时跳过（ESC / SkipButton → tutorial_skipped 信号）
- [x] 教程完成后可正常进入基地（_on_extraction_complete → player_extracted → result_screen → return_base）
- [x] HUD 新组件（小地图/距离指示/拾取通知/伤害数字）在 game_hud.gd 中已实现
- [x] 暂停菜单可在游戏中正常打开/关闭（toggle_pause → pause_menu.toggle）
- [x] 死亡/撤离结果界面可正确显示（ResultScreen 双模式 show_death_result / show_extraction_result）

### 代码质量验证
- [x] 新增代码遵循项目现有命名规范（class_name PascalCase, 变量 snake_case）
- [x] 新增代码注释为中文说明
- [x] 无强制解包（unwrap/expect）使用（所有可选访问均有 if 守卫或 is_instance_valid）
- [x] 信号连接使用 connect() 方式
- [x] autoload 单例通过 get_node_or_null("/root/xxx") 安全访问
- [x] class_name 与 autoload 无冲突（SettingsManager 已移除 class_name，PauseMenu/TutorialOverlay 等新类名不与 autoload 冲突）
