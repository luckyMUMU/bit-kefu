import { CoreLoop } from './core';
import { GrowthLayer } from './growth';
import { RiskLayer } from './risk';
import { BaseConstruction } from './base';
import { WarzoneExploration } from './warzone';
import { CombatModule } from './combat';
import { EconomyModule } from './economy';
import { LightweightDesign } from './lightweight';
import { EventSystem } from './shared/utils/event-system';
import { ServiceLocator } from './shared/utils/service-locator';

// 初始化事件系统
const eventSystem = new EventSystem();
ServiceLocator.getInstance().registerService('eventSystem', eventSystem);

// 初始化各模块
const coreLoop = new CoreLoop();
const growthLayer = coreLoop.getGrowthLayer();
const riskLayer = new RiskLayer();
const baseConstruction = coreLoop.getBaseConstruction();
const warzoneExploration = new WarzoneExploration();
const combatModule = new CombatModule();
const economyModule = new EconomyModule();
const lightweightDesign = new LightweightDesign();

// 注册服务
ServiceLocator.getInstance().registerService('coreLoop', coreLoop);
ServiceLocator.getInstance().registerService('growthLayer', growthLayer);
ServiceLocator.getInstance().registerService('riskLayer', riskLayer);
ServiceLocator.getInstance().registerService('baseConstruction', baseConstruction);
ServiceLocator.getInstance().registerService('warzoneExploration', warzoneExploration);
ServiceLocator.getInstance().registerService('combatModule', combatModule);
ServiceLocator.getInstance().registerService('economyModule', economyModule);
ServiceLocator.getInstance().registerService('lightweightDesign', lightweightDesign);

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
