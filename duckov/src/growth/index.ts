import { GrowthLayerInterface, Player, LootItem, Weapon, WeaponAccessory, Base } from '../shared/types';

export interface Perk {
  id: string;
  name: string;
  description: string;
  cost: number;
  level: number;
  maxLevel: number;
  effects: {
    [key: string]: number;
  };
  prerequisites?: string[];
}

export interface Blueprint {
  id: string;
  name: string;
  type: 'weapon' | 'armor' | 'equipment';
  level: number;
  materials: {
    id: string;
    amount: number;
  }[];
  effects: {
    [key: string]: number;
  };
}

export class GrowthLayer implements GrowthLayerInterface {
  private player: Player;
  private base: Base;
  private perks: Perk[] = [
    {
      id: 'backpack-upgrade',
      name: '背包扩容',
      description: '增加背包容量',
      cost: 1000,
      level: 0,
      maxLevel: 5,
      effects: {
        'backpackCapacity': 5
      }
    },
    {
      id: 'health-boost',
      name: '生命值提升',
      description: '增加最大生命值',
      cost: 1500,
      level: 0,
      maxLevel: 5,
      effects: {
        'health': 10
      }
    },
    {
      id: 'stamina-boost',
      name: '耐力提升',
      description: '增加最大耐力',
      cost: 1200,
      level: 0,
      maxLevel: 5,
      effects: {
        'stamina': 10
      }
    },
    {
      id: 'strength-boost',
      name: '力量提升',
      description: '增加力量属性',
      cost: 1300,
      level: 0,
      maxLevel: 5,
      effects: {
        'strength': 1
      }
    },
    {
      id: 'agility-boost',
      name: '敏捷提升',
      description: '增加敏捷属性',
      cost: 1300,
      level: 0,
      maxLevel: 5,
      effects: {
        'agility': 1
      }
    },
    {
      id: 'intellect-boost',
      name: '智力提升',
      description: '增加智力属性',
      cost: 1300,
      level: 0,
      maxLevel: 5,
      effects: {
        'intellect': 1
      }
    },
    {
      id: 'marksmanship',
      name: '枪法精通',
      description: '提高武器 accuracy',
      cost: 2000,
      level: 0,
      maxLevel: 3,
      effects: {
        'accuracy': 5
      },
      prerequisites: ['strength-boost']
    },
    {
      id: 'stealth',
      name: '潜行大师',
      description: '提高隐蔽性',
      cost: 1800,
      level: 0,
      maxLevel: 3,
      effects: {
        'stealth': 10
      },
      prerequisites: ['agility-boost']
    }
  ];
  
  private blueprints: Blueprint[] = [];
  private researchedBlueprints: string[] = [];

  constructor(player: Player, base: Base) {
    this.player = player;
    this.base = base;
  }

  unlockPerk(perkId: string): boolean {
    const perk = this.perks.find(p => p.id === perkId);
    if (!perk) {
      console.log(`Perk ${perkId} 不存在`);
      return false;
    }

    if (perk.level >= perk.maxLevel) {
      console.log(`Perk ${perk.name} 已达到最高等级`);
      return false;
    }

    if (perk.prerequisites && !perk.prerequisites.every(preId => {
      const prePerk = this.perks.find(p => p.id === preId);
      return prePerk && prePerk.level > 0;
    })) {
      console.log(`缺少前置 Perk`);
      return false;
    }

    const cost = perk.cost * (perk.level + 1);
    if (this.player.cash < cost) {
      console.log(`现金不足，需要 ${cost} 现金`);
      return false;
    }

    this.player.cash -= cost;
    perk.level++;
    
    // 应用效果
    Object.entries(perk.effects).forEach(([key, value]) => {
      if (key in this.player.stats) {
        (this.player.stats as any)[key] += value;
      }
    });

    if (!this.player.perks.includes(perkId)) {
      this.player.perks.push(perkId);
    }

    console.log(`成功解锁 Perk: ${perk.name} 等级 ${perk.level}`);
    return true;
  }

  trainStats(statType: string, amount: number): boolean {
    if (!(statType in this.player.stats)) {
      console.log(`属性 ${statType} 不存在`);
      return false;
    }

    const cost = amount * 500;
    if (this.player.cash < cost) {
      console.log(`现金不足，需要 ${cost} 现金`);
      return false;
    }

    this.player.cash -= cost;
    (this.player.stats as any)[statType] += amount;

    console.log(`训练 ${statType} 增加 ${amount}，当前值: ${(this.player.stats as any)[statType]}`);
    return true;
  }

  researchBlueprint(blueprintId: string): boolean {
    const blueprint = this.blueprints.find(b => b.id === blueprintId);
    if (!blueprint) {
      console.log(`蓝图 ${blueprintId} 不存在`);
      return false;
    }

    if (this.researchedBlueprints.includes(blueprintId)) {
      console.log(`蓝图 ${blueprint.name} 已经研究过了`);
      return false;
    }

    const cost = blueprint.level * 1000;
    if (this.player.cash < cost) {
      console.log(`现金不足，需要 ${cost} 现金`);
      return false;
    }

    this.player.cash -= cost;
    this.researchedBlueprints.push(blueprintId);

    console.log(`成功研究蓝图: ${blueprint.name}`);
    return true;
  }

  modifyEquipment(equipmentId: string, modificationId: string): boolean {
    const weapon = this.player.equipment.weapon as Weapon;
    if (!weapon || weapon.id !== equipmentId) {
      console.log(`装备 ${equipmentId} 未装备`);
      return false;
    }

    const accessory: WeaponAccessory = {
      id: modificationId,
      name: '武器配件',
      type: 'silencer',
      effects: {
        damage: -5,
        stealth: 20
      },
      weight: 1
    };

    weapon.accessories.push(accessory);
    
    // 应用配件效果
    Object.entries(accessory.effects).forEach(([key, value]) => {
      if (key in weapon) {
        (weapon as any)[key] += value;
      }
    });

    console.log(`成功改装装备 ${equipmentId}，添加配件 ${modificationId}`);
    return true;
  }

  getPlayerProgress(): any {
    return {
      level: this.player.level,
      experience: this.player.experience,
      stats: this.player.stats,
      perks: this.perks.filter(p => p.level > 0),
      researchedBlueprints: this.researchedBlueprints.length,
      cash: this.player.cash
    };
  }

  levelUp(): boolean {
    const requiredExp = this.player.level * 1000;
    if (this.player.experience < requiredExp) {
      console.log(`经验不足，需要 ${requiredExp} 经验`);
      return false;
    }

    this.player.level++;
    this.player.experience -= requiredExp;
    
    // 每升一级获得属性点
    Object.keys(this.player.stats).forEach(stat => {
      (this.player.stats as any)[stat] += 2;
    });

    console.log(`玩家升级到 ${this.player.level} 级`);
    return true;
  }

  // 添加蓝图到系统
  addBlueprint(blueprint: Blueprint): void {
    this.blueprints.push(blueprint);
  }

  // 获取可用的 Perk 列表
  getAvailablePerks(): Perk[] {
    return this.perks.filter(perk => {
      if (perk.prerequisites) {
        return perk.prerequisites.every(preId => {
          const prePerk = this.perks.find(p => p.id === preId);
          return prePerk && prePerk.level > 0;
        });
      }
      return true;
    });
  }

  // 获取已研究的蓝图
  getResearchedBlueprints(): Blueprint[] {
    return this.blueprints.filter(b => this.researchedBlueprints.includes(b.id));
  }
}