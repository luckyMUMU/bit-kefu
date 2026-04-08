# UI 优化与教学关卡 — 任务列表

## Phase 1: UI 基础框架优化

- [x] **任务 1: 增强 GameHUD（小地图+距离指示器+拾取通知+伤害数字）**
  - [x] 1.1 修改 `scenes/ui/game_hud.tscn` 布局：重构左上角信息面板为紧凑双行布局
  - [x] 1.2 新增 Minimap 节点（右上角，使用 TextureRect 绘制简化地图）
  - [x] 1.3 新增 DistanceIndicator 节点（右下角，Label 显示射程状态）
  - [x] 1.4 新增 PickupNotification 容器（中央偏上，VBoxContainer 管理通知队列）
  - [x] 1.5 新增 DamageNumber 生成逻辑（在 player 受击/治疗位置实例化飘字）
  - [x] 1.6 修改 `scripts/ui/game_hud.gd`：实现上述所有新组件的更新逻辑和信号连接

- [x] **任务 2: 实现 PauseMenu 暂停菜单**
  - [x] 2.1 创建 `scenes/ui/pause_menu.tscn`：全屏遮罩+居中面板+4个按钮
  - [x] 2.2 创建 `scripts/ui/pause_menu.gd`：ESC 开关逻辑、按钮回调、暂停状态管理
  - [x] 2.3 在 `game_manager.gd` 的 toggle_pause() 中集成暂停菜单显示

- [x] **任务 3: 实现 ResultScreen 结果界面**
  - [x] 3.1 创建 `scenes/ui/result_screen.tscn`：支持死亡/撤离两种模式的面板布局
  - [x] 3.2 创建 `scripts/ui/result_screen.gd`：
    - 死亡模式：显示丢失物品列表 + 回收/返回选项
    - 撤离模式：显示战利品统计 + 返回基地选项
  - [x] 3.3 在 `game_manager.gd` 的 player_died() / player_extracted() 中触发结果界面

## Phase 2: 教学系统核心

- [x] **任务 4: 实现 TutorialOverlay 教学覆盖层组件**
  - [x] 4.1 创建 `scenes/ui/tutorial_overlay.tscn`：高亮遮罩+提示框+进度条+跳过按钮
  - [x] 4.2 创建 `scripts/ui/tutorial_overlay.gd`：
    - `start_tutorial(steps: Array)` 开始教程
    - `next_step()` / `prev_step()` 步骤切换
    - `highlight_area(target: Node2D)` 高亮区域
    - `show_prompt(title, description, key_hint)` 显示提示
    - `skip_tutorial()` 跳过教程信号
    - `tutorial_completed()` 完成信号

- [x] **任务 5: 实现 TutorialZone 教学关卡脚本**
  - [x] 5.1 创建 `scripts/zones/tutorial_zone.gd`：继承 CombatZone 的教学状态机
    - 6 个阶段的状态定义和转换条件检测
    - 阶段完成回调 → 触发 TutorialOverlay.next_step()
    - 各阶段的触发器设置（移动距离计数、击中计数、拾取检测等）
    - 敌人生成控制（仅阶段4生成弱敌人）
    - 撤离点激活控制（仅阶段5激活）
  - [x] 5.2 在 PlayerData 中新增 `tutorial_completed: bool` 字段

## Phase 3: 教学关卡地图制作

- [x] **任务 6: 制作教学关卡基础场景 (`tutorial_zone.tscn`)**
  - [x] 6.1 创建 `scenes/zones/tutorial_zone.tscn` 基础结构
    - TileMap 地面、PlayerSpawn (150,200)、GameHUD、TutorialOverlay、TimeManager
    - 边界碰撞体防止走出训练场

- [x] **任务 7: 制作移动训练区（阶段1）**
  - [x] 7.1 移动目标 Area2D 触发器位于 (500, 200)
  - [x] 7.2 绿色半透明标记，到达后触发阶段完成

- [x] **任务 8: 制作瞄准攻击靶场（阶段2）**
  - [x] 8.1 TrainingTarget 靶标位于 (900, 200)，带 hit 信号和击中计数
  - [x] 8.2 靶标脚本 training_target.gd：被击中闪烁白色，3次后完成
  - [x] 8.3 战斗区围栏限制活动范围

- [x] **任务 9: 制作搜刮交互区（阶段3）**
  - [x] 9.1 LootContainer 战利品箱位于 (500, 500)
  - [x] 9.2 拾取完成后触发阶段完成信号

- [x] **任务 10: 制作战斗训练区（阶段4）**
  - [x] 10.1 EnemySpawn 点位于 (900, 500)，生成弱敌人（血量30/伤害5/速度80）
  - [x] 10.2 敌人死亡后触发阶段完成
  - [x] 10.3 撤离点区域解锁

- [x] **任务 11: 制作撤离终点区（阶段5）**
  - [x] 11.1 ExtractionPoint 撤离点位于 (1350, 600)
  - [x] 11.2 默认 deactivated，阶段5开始时 activate()
  - [x] 11.3 撤离完成后显示训练完成结果界面

## Phase 4: 集成与验证

- [x] **任务 12: GameManager 集成 + 主菜单入口**
  - [x] 12.1 在 `autoload/game_manager.gd` 新增 `go_to_tutorial()` 方法
  - [x] 12.2 复用 PLAYING 状态（不新增 TUTORIAL 枚举）
  - [x] 12.3 修改 `scenes/main_menu.tscn`：新增"🎯 教学模式"Button
  - [x] 12.4 修改 `scripts/ui/main_menu.gd`：绑定教学模式按钮回调
  - [x] 12.5 首次游玩检测：无存档时黄色高亮推荐教学模式

- [x] **任务 13: Player 翻滚动作增强（可选）**
  - [x] 13.1 在 `project.godot` 新增 `roll` 输入映射（空格键）
  - [x] 13.2 在 `scripts/player.gd` 新增 `roll()` 方法：
    - 无敌帧 0.3 秒（设置 collision_layer = 0）
    - 翻滚位移（面向方向 * 150 像素，0.2秒 tween，QUAD缓出）
    - 冷却时间 1.0 秒
    - 翻滚中禁止攻击和转向
  - [x] 13.3 在 `_process()` 中检测 roll 输入

## Task Dependencies

```
任务1 (HUD增强) ✅ ──────────────┐
任务2 (暂停菜单) ✅ ──────────────┤──→ 任务12 (集成) ✅ ─→ 任务13 (翻滚) ✅
任务3 (结果界面) ✅ ──────────────┤
                              │
任务4 (TutorialOverlay) ✅ ────┤
任务5 (TutorialZone脚本) ✅ ───┤
任务6 (场景基础) ✅ ────────────┤
任务7 (移动区) ✅ ──────────────┼──→ 任务12 (集成) ✅
任务8 (靶场) ✅ ────────────────┤
任务9 (搜刮区) ✅ ──────────────┤
任务10 (战斗区) ✅ ─────────────┤
任务11 (撤离区) ✅ ─────────────┘
```

**全部 13 个任务已完成 ✅**
