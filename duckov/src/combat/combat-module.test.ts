import { CombatModule } from './index';
import { Player, Enemy, Weapon, Terrain, Ammo } from '../shared/types';

describe('CombatModule', () => {
  let combatModule: CombatModule;
  let player: Player;
  let enemy: Enemy;
  let weapon: Weapon;
  let terrain: Terrain;
  let ammo: Ammo;

  beforeEach(() => {
    combatModule = new CombatModule();

    // 创建测试玩家
    player = {
      id: 'player1',
      name: 'Test Player',
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

    // 创建测试武器
    weapon = {
      id: 'weapon1',
      name: 'Assault Rifle',
      type: 'weapon',
      rarity: 'common',
      value: 500,
      weight: 3,
      weaponType: 'rifle',
      damage: 20,
      fireRate: 600,
      accuracy: 80,
      range: 100,
      magazineSize: 30,
      currentAmmo: 30,
      ammoType: '5.56mm',
      accessories: [],
      stealth: 50
    };

    // 创建测试敌人
    enemy = {
      id: 'enemy1',
      name: 'Test Enemy',
      type: 'ranged',
      health: 50,
      maxHealth: 50,
      damage: 10,
      accuracy: 70,
      speed: 2,
      detectionRange: 50,
      attackRange: 30,
      behavior: 'patrol',
      status: 'idle',
      position: { x: 10, y: 10 },
      loot: []
    };

    // 创建测试地形
    terrain = {
      id: 'terrain1',
      type: 'cover',
      position: { x: 5, y: 5 },
      size: { width: 2, height: 2 },
      properties: {
        coverValue: 10,
        passable: false,
        destructible: true,
        health: 50
      }
    };

    // 创建测试弹药
    ammo = {
      id: 'ammo1',
      name: '5.56mm Ammo',
      type: '5.56mm',
      damageMultiplier: 1,
      quantity: 100,
      weight: 0.1
    };

    // 设置玩家武器
    player.equipment.weapon = weapon;

    // 添加到战斗模块
    combatModule.setPlayer(player);
    combatModule.addEnemy(enemy);
    combatModule.addTerrain(terrain);
    combatModule.addWeapon(weapon);
    combatModule.addAmmo(ammo);
  });

  test('should initialize correctly', () => {
    expect(combatModule).toBeDefined();
  });

  test('should handle attack correctly', () => {
    const result = combatModule.attack('enemy1');
    expect(result.success).toBe(true);
    expect(result.damage).toBeGreaterThan(0);
  });

  test('should handle defense correctly', () => {
    const result = combatModule.defend('enemy1');
    expect(result.success).toBe(true);
    expect(result.damageReduced).toBeGreaterThanOrEqual(0);
  });

  test('should reload weapon correctly', () => {
    // 消耗所有弹药
    weapon.currentAmmo = 0;
    const result = combatModule.reloadWeapon();
    expect(result).toBe(true);
    expect(weapon.currentAmmo).toBe(weapon.magazineSize);
  });

  test('should change weapon correctly', () => {
    const newWeapon: Weapon = {
      id: 'weapon2',
      name: 'Pistol',
      type: 'weapon',
      rarity: 'common',
      value: 200,
      weight: 1,
      weaponType: 'pistol',
      damage: 10,
      fireRate: 300,
      accuracy: 70,
      range: 50,
      magazineSize: 15,
      currentAmmo: 15,
      ammoType: '9mm',
      accessories: [],
      stealth: 70
    };

    combatModule.addWeapon(newWeapon);
    const result = combatModule.changeWeapon('weapon2');
    expect(result).toBe(true);
  });

  test('should use terrain correctly', () => {
    const result = combatModule.useTerrain('terrain1', 'takeCover');
    expect(result.type).toBe('cover');
    expect(result.value).toBe(10);
    expect(result.duration).toBe(5000);
  });

  test('should manage ammo correctly', () => {
    const result = combatModule.manageAmmo('weapon1', '5.56mm', 50);
    expect(result).toBe(true);
  });

  test('should update enemy AI correctly', () => {
    // 移动玩家靠近敌人
    player.position = { x: 20, y: 20 };
    combatModule.updateEnemyAI();
    expect(enemy.status).toBe('alert');

    // 移动玩家进入攻击范围
    player.position = { x: 25, y: 25 };
    combatModule.updateEnemyAI();
    expect(enemy.status).toBe('attacking');
  });

  test('should handle enemy attack correctly', () => {
    const initialHealth = player.stats.health;
    enemy.status = 'attacking';
    combatModule.updateCombatState();
    expect(player.stats.health).toBeLessThanOrEqual(initialHealth);
  });
});
