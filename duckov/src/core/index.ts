import { CoreLoopInterface, LootItem, CombatResult, Player, MapData, Base, DeathResult } from '../shared/types';
import { ServiceLocator } from '../shared/utils/service-locator';
import { GrowthLayer } from '../growth';
import { BaseConstruction } from '../base';

export enum GameState {
  BASE = 'base',
  WARZONE = 'warzone',
  LOOTING = 'looting',
  COMBAT = 'combat',
  EVACUATING = 'evacuating',
  DEAD = 'dead',
  RETURNING = 'returning'
}

export class CoreLoop implements CoreLoopInterface {
  private currentState: GameState = GameState.BASE;
  private player: Player;
  private currentMap: MapData | null = null;
  private inventory: Map<string, LootItem> = new Map();
  private base: Base;
  private timeInWarzone: number = 0;
  private riskLevel: number = 0;
  private growthLayer: GrowthLayer;
  private baseConstruction: BaseConstruction;

  constructor() {
    // 初始化玩家数据
    this.player = {
      id: 'player-1',
      name: 'Duck Commander',
      level: 1,
      position: { x: 0, y: 0 },
      stats: {
        health: 100,
        stamina: 100,
        strength: 10,
        agility: 10,
        intellect: 10
      },
      perks: [],
      inventory: [],
      equipment: {
        weapon: null,
        armor: null,
        accessories: []
      },
      cash: 1000,
      experience: 0
    };

    // 初始化基地数据
    this.base = {
      id: 'base-1',
      name: 'Duck Nest',
      facilities: [
        {
          id: 'workbench-1',
          name: '工作台',
          type: 'workbench',
          level: 1,
          status: 'active',
          effects: []
        },
        {
          id: 'storage-1',
          name: '储物柜',
          type: 'storage-locker',
          level: 1,
          status: 'active',
          effects: []
        }
      ],
      storage: [],
      resources: []
    };

    // 初始化成长系统
    this.growthLayer = new GrowthLayer(this.player, this.base);
    // 初始化基地建设系统
    this.baseConstruction = new BaseConstruction(this.base, this.player);
  }

  getCurrentState(): GameState {
    return this.currentState;
  }

  getPlayer(): Player {
    return this.player;
  }

  getBase(): Base {
    return this.base;
  }

  prepareBase(): void {
    console.log('基地整备中...');
    this.currentState = GameState.BASE;
    // 恢复玩家状态
    this.player.stats.health = 100;
    this.player.stats.stamina = 100;
    // 装备从基地存储中取出
    console.log('装备已准备就绪');
  }

  enterWarzone(mapId: string): void {
    console.log(`进入战区: ${mapId}`);
    this.currentState = GameState.WARZONE;
    this.currentMap = {
      id: mapId,
      name: mapId === 'forest' ? '神秘森林' : '废弃工厂',
      size: { width: 1000, height: 1000 },
      zones: [],
      evacuationPoints: [
        {
          id: 'evac-1',
          name: '绿色烟雾',
          position: { x: 100, y: 100 },
          status: 'active'
        }
      ],
      shortcuts: [],
      weather: {
        type: 'clear',
        intensity: 1,
        duration: 3600,
        effects: []
      }
    };
    this.timeInWarzone = 0;
    this.riskLevel = 0;
    this.inventory = new Map();
    console.log('已进入战区，开始探索');
  }

  loot(): LootItem[] {
    if (this.currentState !== GameState.WARZONE && this.currentState !== GameState.LOOTING) {
      console.log('当前状态无法搜刮物资');
      return [];
    }

    this.currentState = GameState.LOOTING;
    console.log('搜索/搜刮物资');
    
    // 模拟随机物资生成
    const lootTypes: Array<'weapon' | 'armor' | 'medicine' | 'resource' | 'blueprint' | 'collectible'> = 
      ['weapon', 'armor', 'medicine', 'resource', 'blueprint', 'collectible'];
    const rarities: Array<'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'> = 
      ['common', 'uncommon', 'rare', 'epic', 'legendary'];
    
    const lootCount = Math.floor(Math.random() * 3) + 1;
    const newLoot: LootItem[] = [];
    const timestamp = Date.now();
    
    for (let i = 0; i < lootCount; i++) {
      const random = Math.random();
      const item: LootItem = {
        id: `item-${timestamp}-${i}`,
        name: `物品 ${i + 1}`,
        type: lootTypes[Math.floor(random * lootTypes.length)],
        rarity: rarities[Math.floor(Math.random() * rarities.length)],
        value: Math.floor(Math.random() * 1000) + 100,
        weight: Math.floor(Math.random() * 5) + 1
      };
      newLoot.push(item);
      this.inventory.set(item.id, item);
    }
    
    // 增加风险等级和时间
    this.timeInWarzone += 300; // 5分钟
    this.riskLevel += 1;
    
    console.log(`获得 ${newLoot.length} 个物品`);
    console.log(`当前风险等级: ${this.riskLevel}, 已停留时间: ${Math.floor(this.timeInWarzone / 60)} 分钟`);
    
    // 有一定概率触发战斗
    if (Math.random() > 0.7) {
      console.log('遭遇敌人！');
      this.engageCombat(`enemy-${Date.now()}`);
    }
    
    this.currentState = GameState.WARZONE;
    return newLoot;
  }

  engageCombat(enemyId: string): CombatResult {
    if (this.currentState !== GameState.WARZONE && this.currentState !== GameState.LOOTING) {
      console.log('当前状态无法战斗');
      return { success: false, damage: 0, experience: 0 };
    }

    this.currentState = GameState.COMBAT;
    console.log(`与敌人 ${enemyId} 战斗`);
    
    // 模拟战斗结果
    const success = Math.random() > 0.3; // 70% 胜率
    const damage = success ? Math.floor(Math.random() * 20) : Math.floor(Math.random() * 40);
    const experience = success ? Math.floor(Math.random() * 100) + 50 : 10;
    let loot: LootItem[] = [];
    
    if (success) {
      console.log('战斗胜利！');
      this.player.experience += experience;
      // 有概率获得战利品
      if (Math.random() > 0.5) {
        const newLoot: LootItem = {
          id: `loot-${Date.now()}`,
          name: '战利品',
          type: 'weapon',
          rarity: 'uncommon',
          value: 500,
          weight: 3
        };
        this.inventory.set(newLoot.id, newLoot);
        loot.push(newLoot);
        console.log('获得战利品');
      }
    } else {
      console.log('战斗失败！');
      this.player.stats.health -= damage;
      if (this.player.stats.health <= 0) {
        this.handleDeath();
        return { success: false, damage, experience };
      }
    }
    
    this.currentState = GameState.WARZONE;
    return { success, damage, experience, loot: loot.length > 0 ? loot : undefined };
  }

  evacuate(evacPointId: string): boolean {
    if (this.currentState !== GameState.WARZONE) {
      console.log('当前状态无法撤离');
      return false;
    }

    this.currentState = GameState.EVACUATING;
    console.log(`从撤离点 ${evacPointId} 撤离`);
    
    // 模拟撤离过程
    const success = Math.random() > 0.1; // 90% 成功率
    
    if (success) {
      console.log('成功撤离！');
      this.returnToBase();
    } else {
      console.log('撤离失败！');
      this.handleDeath();
    }
    
    return success;
  }

  returnToBase(): void {
    this.currentState = GameState.RETURNING;
    console.log('返回基地');
    
    // 处理带回的物资
    const inventoryArray = Array.from(this.inventory.values());
    if (inventoryArray.length > 0) {
      this.storeItems(inventoryArray);
    }
    
    this.currentMap = null;
    this.timeInWarzone = 0;
    this.riskLevel = 0;
    this.inventory = new Map();
    
    this.currentState = GameState.BASE;
    console.log('已安全返回基地');
  }

  storeItems(items: LootItem[]): void {
    console.log(`存入 ${items.length} 个物品到仓库`);
    
    // 计算总价值
    const totalValue = items.reduce((sum, item) => sum + item.value, 0);
    this.player.cash += totalValue * 0.8; // 80% 价值转化为现金
    
    // 存入仓库
    this.base.storage.push(...items);
    
    console.log(`获得 ${totalValue * 0.8} 现金`);
    console.log(`仓库现在有 ${this.base.storage.length} 个物品`);
  }

  private handleDeath(): void {
    this.currentState = GameState.DEAD;
    console.log('你 died 了！');
    
    // 计算丢失的物品
    const lostItems: LootItem[] = [];
    const recoverableItems: LootItem[] = [];
    
    // 模拟物品丢失逻辑
    Array.from(this.inventory.values()).forEach(item => {
      if (Math.random() > 0.5) {
        lostItems.push(item);
      } else {
        recoverableItems.push(item);
      }
    });
    
    console.log(`丢失了 ${lostItems.length} 个物品`);
    console.log(`可以回收 ${recoverableItems.length} 个物品`);
    
    // 清空当前库存
    this.inventory = new Map();
    
    // 重置状态
    this.currentState = GameState.BASE;
    this.currentMap = null;
    this.timeInWarzone = 0;
    this.riskLevel = 0;
    
    // 恢复玩家状态
    this.player.stats.health = 100;
    this.player.stats.stamina = 100;
    
    console.log('已回到基地，准备重新开始');
  }

  // 主游戏循环
  gameLoop(): void {
    console.log('\n=== 游戏循环开始 ===');
    console.log(`当前状态: ${this.currentState}`);
    
    switch (this.currentState) {
      case GameState.BASE:
        console.log('基地整备完成，准备进入战区');
        break;
      case GameState.WARZONE:
        console.log('在战区中，可进行搜刮或撤离');
        break;
      case GameState.LOOTING:
        console.log('正在搜刮物资');
        break;
      case GameState.COMBAT:
        console.log('正在战斗');
        break;
      case GameState.EVACUATING:
        console.log('正在撤离');
        break;
      case GameState.DEAD:
        console.log('已死亡，准备复活');
        break;
      case GameState.RETURNING:
        console.log('正在返回基地');
        break;
    }
    
    console.log(`玩家状态: 生命值 ${this.player.stats.health}, 现金 ${this.player.cash}, 经验 ${this.player.experience}`);
    console.log(`库存: ${this.inventory.size} 个物品`);
    console.log(`基地仓库: ${this.base.storage.length} 个物品`);
    console.log('=== 游戏循环结束 ===\n');
  }

  // 成长系统相关方法
  unlockPerk(perkId: string): boolean {
    return this.growthLayer.unlockPerk(perkId);
  }

  trainStats(statType: string, amount: number): boolean {
    return this.growthLayer.trainStats(statType, amount);
  }

  researchBlueprint(blueprintId: string): boolean {
    return this.growthLayer.researchBlueprint(blueprintId);
  }

  modifyEquipment(equipmentId: string, modificationId: string): boolean {
    return this.growthLayer.modifyEquipment(equipmentId, modificationId);
  }

  getPlayerProgress(): any {
    return this.growthLayer.getPlayerProgress();
  }

  levelUp(): boolean {
    return this.growthLayer.levelUp();
  }

  // 获取成长系统实例
  getGrowthLayer(): GrowthLayer {
    return this.growthLayer;
  }

  // 基地建设相关方法
  buildFacility(facilityId: string): boolean {
    return this.baseConstruction.buildFacility(facilityId);
  }

  upgradeFacility(facilityId: string): boolean {
    return this.baseConstruction.upgradeFacility(facilityId);
  }

  useFacility(facilityId: string, action: string, params: any): any {
    return this.baseConstruction.useFacility(facilityId, action, params);
  }

  getFacilityStatus(facilityId: string): any {
    return this.baseConstruction.getFacilityStatus(facilityId);
  }

  // 获取基地建设系统实例
  getBaseConstruction(): BaseConstruction {
    return this.baseConstruction;
  }
}