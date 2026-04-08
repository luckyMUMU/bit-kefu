# 鸭科夫游戏模块说明文档# 鸭科夫游戏模块说明文档

## 一、核心循环模块
# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` |# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` |# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCom# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` |# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
|# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 |# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

#### 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2.# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
|# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId:# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perk# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string,# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 |# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` |# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
|# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
-# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1.# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1. 模块功能
基地建设模块负责基地的设施# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1. 模块功能
基地建设模块负责基地的设施建造、升级和使用，包括工作台、蓝图# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1. 模块功能
基地建设模块负责基地的设施建造、升级和使用，包括工作台、蓝图研究站、医疗站、军备室、健身房# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1. 模块功能
基地建设模块负责基地的设施建造、升级和使用，包括工作台、蓝图研究站、医疗站、军备室、健身房和储物柜等设施。

#### 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1. 模块功能
基地建设模块负责基地的设施建造、升级和使用，包括工作台、蓝图研究站、医疗站、军备室、健身房和储物柜等设施。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `buildFacility(facilityId# 鸭科夫游戏模块说明文档

## 一、核心循环模块

### 1. 模块功能
核心循环模块是游戏的核心引擎，负责管理游戏的主要流程，包括基地整备、进入战区、搜索/搜刮物资、战斗、撤离、返回基地和存入仓库等环节。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `prepareBase()` | 基地整备，恢复玩家状态 | 无 | void |
| `enterWarzone(mapId: string)` | 进入指定战区 | mapId: 地图ID | void |
| `loot()` | 搜索/搜刮物资 | 无 | LootItem[] |
| `engageCombat(enemyId: string)` | 与敌人战斗 | enemyId: 敌人ID | CombatResult |
| `evacuate(evacPointId: string)` | 从指定撤离点撤离 | evacPointId: 撤离点ID | boolean |
| `returnToBase()` | 返回基地 | 无 | void |
| `storeItems(items: LootItem[])` | 存入物品到仓库 | items: 物品数组 | void |

### 3. 实现细节
- 游戏状态管理：通过 `GameState` 枚举管理游戏的不同状态
- 物资生成：随机生成不同类型和稀有度的物资
- 战斗系统：模拟战斗结果，包括胜利和失败的处理
- 死亡机制：处理玩家死亡后的物品丢失和回收
- 基地管理：管理基地的仓库和设施

## 二、成长层模块

### 1. 模块功能
成长层模块负责玩家的角色成长，包括Perk技能树、身体训练、蓝图研究和装备改装等功能。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `unlockPerk(perkId: string)` | 解锁Perk技能 | perkId: Perk ID | boolean |
| `trainStats(statType: string, amount: number)` | 训练指定属性 | statType: 属性类型, amount: 增加量 | boolean |
| `researchBlueprint(blueprintId: string)` | 研究蓝图 | blueprintId: 蓝图ID | boolean |
| `modifyEquipment(equipmentId: string, modificationId: string)` | 改装装备 | equipmentId: 装备ID, modificationId: 改装ID | boolean |
| `getPlayerProgress()` | 获取玩家进度 | 无 | any |
| `levelUp()` | 玩家升级 | 无 | boolean |

### 3. 实现细节
- Perk系统：包含多种Perk，如背包扩容、生命值提升、耐力提升等
- 技能树：支持Perk的前置条件和等级提升
- 蓝图研究：通过研究蓝图解锁新的制造配方
- 装备改装：为武器添加配件，提升武器性能
- 等级系统：玩家通过获得经验值升级，提升基础属性

## 三、基地建设模块

### 1. 模块功能
基地建设模块负责基地的设施建造、升级和使用，包括工作台、蓝图研究站、医疗站、军备室、健身房和储物柜等设施。

### 2. 主要接口

| 方法 | 描述 | 参数 | 返回值 |
|------|------|------|--------|
| `buildFacility(facilityId: string)` | 建造设施 | facilityId: 设施ID | boolean |
|