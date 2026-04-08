import { WarzoneExplorationInterface, MapData, LootItem, Position, WeatherEffect, EvacPointStatus, Zone, EvacuationPoint, Shortcut, Weather } from '../shared/types';

export class WarzoneExploration implements WarzoneExplorationInterface {
  private maps: Map<string, MapData> = new Map();
  private unlockedShortcuts: Set<string> = new Set();
  private currentWeather: Weather = { type: 'clear', intensity: 0, duration: 0, effects: [] };

  // 生成地图
  generateMap(mapId: string): MapData {
    // 检查地图是否已存在
    if (this.maps.has(mapId)) {
      return this.maps.get(mapId)!;
    }

    // 根据地图ID生成不同的地图
    let map: MapData;
    switch (mapId) {
      case 'forest':
        map = this.generateForestMap();
        break;
      case 'urban':
        map = this.generateUrbanMap();
        break;
      case 'industrial':
        map = this.generateIndustrialMap();
        break;
      default:
        map = this.generateDefaultMap();
    }

    // 生成随机天气
    map.weather = this.generateRandomWeather();

    // 存储地图
    this.maps.set(mapId, map);
    return map;
  }

  // 生成森林地图
  private generateForestMap(): MapData {
    const zones: Zone[] = [
      {
        id: 'forest-safe-1',
        name: '森林边缘',
        position: { x: 0, y: 0 },
        size: { width: 300, height: 300 },
        type: 'safe',
        lootSpawns: this.generateLootSpawns(10),
        enemySpawns: this.generateEnemySpawns(5)
      },
      {
        id: 'forest-danger-1',
        name: '深林',
        position: { x: 300, y: 0 },
        size: { width: 400, height: 400 },
        type: 'danger',
        lootSpawns: this.generateLootSpawns(15),
        enemySpawns: this.generateEnemySpawns(10)
      },
      {
        id: 'forest-boss-1',
        name: '森林核心',
        position: { x: 500, y: 200 },
        size: { width: 200, height: 200 },
        type: 'boss',
        lootSpawns: this.generateLootSpawns(20),
        enemySpawns: this.generateEnemySpawns(15)
      }
    ];

    const evacuationPoints: EvacuationPoint[] = [
      {
        id: 'forest-evac-1',
        name: '森林边缘撤离点',
        position: { x: 100, y: 100 },
        status: 'active'
      },
      {
        id: 'forest-evac-2',
        name: '深林撤离点',
        position: { x: 500, y: 100 },
        status: 'active'
      }
    ];

    const shortcuts: Shortcut[] = [
      {
        id: 'forest-shortcut-1',
        name: '森林小径',
        from: { x: 250, y: 150 },
        to: { x: 450, y: 250 },
        status: 'locked'
      }
    ];

    return {
      id: 'forest',
      name: '森林战区',
      size: { width: 1000, height: 1000 },
      zones,
      evacuationPoints,
      shortcuts,
      weather: { type: 'clear', intensity: 0, duration: 0, effects: [] }
    };
  }

  // 生成城市地图
  private generateUrbanMap(): MapData {
    const zones: Zone[] = [
      {
        id: 'urban-safe-1',
        name: '城市郊区',
        position: { x: 0, y: 0 },
        size: { width: 300, height: 300 },
        type: 'safe',
        lootSpawns: this.generateLootSpawns(12),
        enemySpawns: this.generateEnemySpawns(6)
      },
      {
        id: 'urban-danger-1',
        name: '城市中心',
        position: { x: 300, y: 0 },
        size: { width: 400, height: 400 },
        type: 'danger',
        lootSpawns: this.generateLootSpawns(18),
        enemySpawns: this.generateEnemySpawns(12)
      },
      {
        id: 'urban-boss-1',
        name: '城市高楼',
        position: { x: 500, y: 200 },
        size: { width: 200, height: 200 },
        type: 'boss',
        lootSpawns: this.generateLootSpawns(25),
        enemySpawns: this.generateEnemySpawns(18)
      }
    ];

    const evacuationPoints: EvacuationPoint[] = [
      {
        id: 'urban-evac-1',
        name: '郊区撤离点',
        position: { x: 100, y: 100 },
        status: 'active'
      },
      {
        id: 'urban-evac-2',
        name: '城市广场撤离点',
        position: { x: 500, y: 100 },
        status: 'active'
      }
    ];

    const shortcuts: Shortcut[] = [
      {
        id: 'urban-shortcut-1',
        name: '地下通道',
        from: { x: 250, y: 150 },
        to: { x: 450, y: 250 },
        status: 'locked'
      }
    ];

    return {
      id: 'urban',
      name: '城市战区',
      size: { width: 1000, height: 1000 },
      zones,
      evacuationPoints,
      shortcuts,
      weather: { type: 'clear', intensity: 0, duration: 0, effects: [] }
    };
  }

  // 生成工业地图
  private generateIndustrialMap(): MapData {
    const zones: Zone[] = [
      {
        id: 'industrial-safe-1',
        name: '工业区边缘',
        position: { x: 0, y: 0 },
        size: { width: 300, height: 300 },
        type: 'safe',
        lootSpawns: this.generateLootSpawns(15),
        enemySpawns: this.generateEnemySpawns(8)
      },
      {
        id: 'industrial-danger-1',
        name: '工厂区',
        position: { x: 300, y: 0 },
        size: { width: 400, height: 400 },
        type: 'danger',
        lootSpawns: this.generateLootSpawns(20),
        enemySpawns: this.generateEnemySpawns(15)
      },
      {
        id: 'industrial-boss-1',
        name: '核心工厂',
        position: { x: 500, y: 200 },
        size: { width: 200, height: 200 },
        type: 'boss',
        lootSpawns: this.generateLootSpawns(30),
        enemySpawns: this.generateEnemySpawns(20)
      }
    ];

    const evacuationPoints: EvacuationPoint[] = [
      {
        id: 'industrial-evac-1',
        name: '工业区边缘撤离点',
        position: { x: 100, y: 100 },
        status: 'active'
      },
      {
        id: 'industrial-evac-2',
        name: '工厂区撤离点',
        position: { x: 500, y: 100 },
        status: 'active'
      }
    ];

    const shortcuts: Shortcut[] = [
      {
        id: 'industrial-shortcut-1',
        name: '管道通道',
        from: { x: 250, y: 150 },
        to: { x: 450, y: 250 },
        status: 'locked'
      }
    ];

    return {
      id: 'industrial',
      name: '工业战区',
      size: { width: 1000, height: 1000 },
      zones,
      evacuationPoints,
      shortcuts,
      weather: { type: 'clear', intensity: 0, duration: 0, effects: [] }
    };
  }

  // 生成默认地图
  private generateDefaultMap(): MapData {
    const zones: Zone[] = [
      {
        id: 'default-safe-1',
        name: '安全区',
        position: { x: 0, y: 0 },
        size: { width: 300, height: 300 },
        type: 'safe',
        lootSpawns: this.generateLootSpawns(8),
        enemySpawns: this.generateEnemySpawns(4)
      },
      {
        id: 'default-danger-1',
        name: '危险区',
        position: { x: 300, y: 0 },
        size: { width: 400, height: 400 },
        type: 'danger',
        lootSpawns: this.generateLootSpawns(12),
        enemySpawns: this.generateEnemySpawns(8)
      }
    ];

    const evacuationPoints: EvacuationPoint[] = [
      {
        id: 'default-evac-1',
        name: '主要撤离点',
        position: { x: 100, y: 100 },
        status: 'active'
      }
    ];

    const shortcuts: Shortcut[] = [];

    return {
      id: 'default',
      name: '默认战区',
      size: { width: 1000, height: 1000 },
      zones,
      evacuationPoints,
      shortcuts,
      weather: { type: 'clear', intensity: 0, duration: 0, effects: [] }
    };
  }

  // 生成物资刷新点
  private generateLootSpawns(count: number): Position[] {
    const spawns: Position[] = [];
    for (let i = 0; i < count; i++) {
      spawns.push({
        x: Math.random() * 1000,
        y: Math.random() * 1000
      });
    }
    return spawns;
  }

  // 生成敌人刷新点
  private generateEnemySpawns(count: number): Position[] {
    const spawns: Position[] = [];
    for (let i = 0; i < count; i++) {
      spawns.push({
        x: Math.random() * 1000,
        y: Math.random() * 1000
      });
    }
    return spawns;
  }

  // 生成随机天气
  private generateRandomWeather(): Weather {
    const weatherTypes: ('clear' | 'rain' | 'fog' | 'storm')[] = ['clear', 'rain', 'fog', 'storm'];
    const weatherType = weatherTypes[Math.floor(Math.random() * weatherTypes.length)];
    const intensity = Math.random() * 100;
    const duration = 300 + Math.random() * 600; // 5-15分钟

    let effects: WeatherEffect[] = [];
    switch (weatherType) {
      case 'rain':
        effects = [
          { id: 'rain-visibility', name: '雨水降低视野', type: 'visibility', value: -30 },
          { id: 'rain-movement', name: '雨水减缓移动', type: 'movement', value: -20 }
        ];
        break;
      case 'fog':
        effects = [
          { id: 'fog-visibility', name: '雾气降低视野', type: 'visibility', value: -50 }
        ];
        break;
      case 'storm':
        effects = [
          { id: 'storm-visibility', name: '风暴降低视野', type: 'visibility', value: -60 },
          { id: 'storm-movement', name: '风暴减缓移动', type: 'movement', value: -30 },
          { id: 'storm-combat', name: '风暴影响射击', type: 'combat', value: -20 }
        ];
        break;
      default:
        effects = [];
    }

    return {
      type: weatherType,
      intensity,
      duration,
      effects
    };
  }

  // 刷新物资
  spawnLoot(mapId: string, position: Position): LootItem[] {
    const map = this.maps.get(mapId);
    if (!map) {
      return [];
    }

    // 根据位置确定区域类型，影响物资稀有度
    const zoneType = this.getZoneTypeAtPosition(map, position);
    const lootItems: LootItem[] = [];

    // 物资类型和稀有度权重
    const lootTypes = [
      'weapon', 'armor', 'medicine', 'resource', 'blueprint', 'collectible'
    ];
    const rarityWeights = {
      safe: { common: 80, uncommon: 15, rare: 4, epic: 1, legendary: 0 },
      danger: { common: 60, uncommon: 25, rare: 10, epic: 4, legendary: 1 },
      boss: { common: 40, uncommon: 30, rare: 20, epic: 8, legendary: 2 }
    };

    // 生成1-3个物资
    const lootCount = 1 + Math.floor(Math.random() * 3);
    for (let i = 0; i < lootCount; i++) {
      const type = lootTypes[Math.floor(Math.random() * lootTypes.length)];
      const rarity = this.getRandomRarity(rarityWeights[zoneType]);
      const value = this.calculateLootValue(type, rarity);
      const weight = this.calculateLootWeight(type, rarity);

      lootItems.push({
        id: `loot-${Date.now()}-${i}`,
        name: `${this.getLootName(type, rarity)}`,
        type: type as any,
        rarity: rarity as any,
        value,
        weight
      });
    }

    return lootItems;
  }

  // 获取位置所在区域类型
  private getZoneTypeAtPosition(map: MapData, position: Position): 'safe' | 'danger' | 'boss' {
    for (const zone of map.zones) {
      if (
        position.x >= zone.position.x &&
        position.x < zone.position.x + zone.size.width &&
        position.y >= zone.position.y &&
        position.y < zone.position.y + zone.size.height
      ) {
        return zone.type;
      }
    }
    return 'safe'; // 默认安全区
  }

  // 根据权重获取随机稀有度
  private getRandomRarity(weights: { [key: string]: number }): string {
    const totalWeight = Object.values(weights).reduce((sum, weight) => sum + weight, 0);
    let random = Math.random() * totalWeight;

    for (const [rarity, weight] of Object.entries(weights)) {
      random -= weight;
      if (random <= 0) {
        return rarity;
      }
    }

    return 'common';
  }

  // 计算物资价值
  private calculateLootValue(type: string, rarity: string): number {
    const baseValues = {
      weapon: 100,
      armor: 80,
      medicine: 50,
      resource: 20,
      blueprint: 150,
      collectible: 30
    };

    const rarityMultipliers = {
      common: 1,
      uncommon: 1.5,
      rare: 2.5,
      epic: 4,
      legendary: 6
    };

    return Math.floor((baseValues[type as keyof typeof baseValues] || 50) * 
      (rarityMultipliers[rarity as keyof typeof rarityMultipliers] || 1));
  }

  // 计算物资重量
  private calculateLootWeight(type: string, rarity: string): number {
    const baseWeights = {
      weapon: 5,
      armor: 4,
      medicine: 1,
      resource: 2,
      blueprint: 0.5,
      collectible: 1
    };

    return (baseWeights[type as keyof typeof baseWeights] || 1) * 
      (rarity === 'legendary' ? 1.5 : 1);
  }

  // 获取物资名称
  private getLootName(type: string, rarity: string): string {
    const names = {
      weapon: ['手枪', '步枪', '霰弹枪', '狙击枪'],
      armor: ['防弹衣', '头盔', '护膝', '战术背心'],
      medicine: ['急救包', '止痛药', '绷带', '能量饮料'],
      resource: ['金属', '木材', '化学物质', '电子元件'],
      blueprint: ['武器蓝图', '装备蓝图', '药品蓝图'],
      collectible: ['古董', '艺术品', '稀有货币', '纪念品']
    };

    const rarityPrefixes = {
      common: '基础',
      uncommon: '改进',
      rare: '高级',
      epic: '史诗',
      legendary: '传说'
    };

    const typeNames = names[type as keyof typeof names] || ['物品'];
    const name = typeNames[Math.floor(Math.random() * typeNames.length)];
    const prefix = rarityPrefixes[rarity as keyof typeof rarityPrefixes] || '';

    return `${prefix}${name}`;
  }

  // 应用天气效果
  applyWeatherEffect(weatherType: string): WeatherEffect {
    const effects: { [key: string]: WeatherEffect } = {
      clear: { id: 'clear-visibility', name: '晴朗天气', type: 'visibility', value: 10 },
      rain: { id: 'rain-visibility', name: '雨水降低视野', type: 'visibility', value: -30 },
      fog: { id: 'fog-visibility', name: '雾气降低视野', type: 'visibility', value: -50 },
      storm: { id: 'storm-visibility', name: '风暴降低视野', type: 'visibility', value: -60 }
    };

    return effects[weatherType] || effects.clear;
  }

  // 检查撤离点状态
  checkEvacPoint(evacPointId: string): EvacPointStatus {
    // 模拟撤离点状态检查
    const statuses: ('active' | 'inactive' | 'locked')[] = ['active', 'active', 'inactive', 'locked'];
    const status = statuses[Math.floor(Math.random() * statuses.length)];

    return {
      status,
      countdown: status === 'active' ? 60 + Math.floor(Math.random() * 120) : undefined
    };
  }

  // 解锁捷径
  unlockShortcut(shortcutId: string): boolean {
    if (this.unlockedShortcuts.has(shortcutId)) {
      return true;
    }

    // 模拟解锁过程
    const success = Math.random() > 0.3; // 70% 成功率
    if (success) {
      this.unlockedShortcuts.add(shortcutId);
    }

    return success;
  }

  // 探索区域
  exploreZone(zoneId: string): any {
    // 模拟区域探索结果
    return {
      zoneId,
      discoveredLoot: this.spawnLoot('default', { x: Math.random() * 1000, y: Math.random() * 1000 }),
      discoveredEnemies: Math.floor(Math.random() * 5),
      discoveredShortcuts: Math.random() > 0.7 ? ["shortcut-" + Date.now()] : []
    };
  }

  // 寻找物资
  findLoot(spawnPointId: string): LootItem[] {
    // 模拟在刷新点寻找物资
    return this.spawnLoot('default', { x: Math.random() * 1000, y: Math.random() * 1000 });
  }

  // 检查撤离点状态
  checkEvacPointStatus(evacPointId: string): EvacPointStatus {
    return this.checkEvacPoint(evacPointId);
  }

  // 处理天气效果
  handleWeatherEffects(): any {
    // 模拟天气效果处理
    const weatherTypes: ('clear' | 'rain' | 'fog' | 'storm')[] = ['clear', 'rain', 'fog', 'storm'];
    const newWeather = weatherTypes[Math.floor(Math.random() * weatherTypes.length)];
    this.currentWeather = this.generateRandomWeather();

    return {
      newWeather: this.currentWeather,
      effects: this.currentWeather.effects
    };
  }
}