"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("./core");
const risk_1 = require("./risk");
const warzone_1 = require("./warzone");
const combat_1 = require("./combat");
const economy_1 = require("./economy");
const lightweight_1 = require("./lightweight");
const event_system_1 = require("./shared/utils/event-system");
const service_locator_1 = require("./shared/utils/service-locator");
// 初始化事件系统
const eventSystem = new event_system_1.EventSystem();
service_locator_1.ServiceLocator.getInstance().registerService('eventSystem', eventSystem);
// 初始化各模块
const coreLoop = new core_1.CoreLoop();
const growthLayer = coreLoop.getGrowthLayer();
const riskLayer = new risk_1.RiskLayer();
const baseConstruction = coreLoop.getBaseConstruction();
const warzoneExploration = new warzone_1.WarzoneExploration();
const combatModule = new combat_1.CombatModule();
const economyModule = new economy_1.EconomyModule();
const lightweightDesign = new lightweight_1.LightweightDesign();
// 注册服务
service_locator_1.ServiceLocator.getInstance().registerService('coreLoop', coreLoop);
service_locator_1.ServiceLocator.getInstance().registerService('growthLayer', growthLayer);
service_locator_1.ServiceLocator.getInstance().registerService('riskLayer', riskLayer);
service_locator_1.ServiceLocator.getInstance().registerService('baseConstruction', baseConstruction);
service_locator_1.ServiceLocator.getInstance().registerService('warzoneExploration', warzoneExploration);
service_locator_1.ServiceLocator.getInstance().registerService('combatModule', combatModule);
service_locator_1.ServiceLocator.getInstance().registerService('economyModule', economyModule);
service_locator_1.ServiceLocator.getInstance().registerService('lightweightDesign', lightweightDesign);
// 启动游戏
console.log('鸭科夫游戏启动中...');
coreLoop.prepareBase();
coreLoop.gameLoop();
// 模拟游戏流程
console.log('\n=== 模拟游戏流程 ===');
// 进入战区
coreLoop.enterWarzone('forest');
coreLoop.gameLoop();
// 搜刮物资
coreLoop.loot();
coreLoop.gameLoop();
// 再次搜刮
coreLoop.loot();
coreLoop.gameLoop();
// 撤离
coreLoop.evacuate('evac-1');
coreLoop.gameLoop();
// 再次进入战区
coreLoop.enterWarzone('factory');
coreLoop.gameLoop();
// 模拟战斗失败
for (let i = 0; i < 5; i++) {
    coreLoop.engageCombat(`enemy-${i}`);
    coreLoop.gameLoop();
}
console.log('\n=== 游戏流程模拟完成 ===');
