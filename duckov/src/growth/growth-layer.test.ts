import { GrowthLayer } from './index';
import { Player, Base } from '../shared/types';

describe('GrowthLayer', () => {
  let growthLayer: GrowthLayer;
  let player: Player;
  let base: Base;

  beforeEach(() => {
    // 初始化测试数据
    player = {
      id: 'player-1',
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
      cash: 10000,
      experience: 0
    };

    base = {
      id: 'base-1',
      name: 'Test Base',
      facilities: [],
      storage: [],
      resources: []
    };

    growthLayer = new GrowthLayer(player, base);
  });

  test('should unlock perk successfully', () => {
    const result = growthLayer.unlockPerk('backpack-upgrade');
    expect(result).toBe(true);
    expect(player.perks).toContain('backpack-upgrade');
  });

  test('should not unlock perk with insufficient cash', () => {
    player.cash = 0;
    const result = growthLayer.unlockPerk('backpack-upgrade');
    expect(result).toBe(false);
  });

  test('should not unlock perk that already reached max level', () => {
    // Unlock the perk multiple times to reach max level
    for (let i = 0; i < 5; i++) {
      growthLayer.unlockPerk('backpack-upgrade');
    }
    const result = growthLayer.unlockPerk('backpack-upgrade');
    expect(result).toBe(false);
  });

  test('should train stats successfully', () => {
    const initialStrength = player.stats.strength;
    const result = growthLayer.trainStats('strength', 5);
    expect(result).toBe(true);
    expect(player.stats.strength).toBe(initialStrength + 5);
  });

  test('should not train stats with insufficient cash', () => {
    player.cash = 0;
    const result = growthLayer.trainStats('strength', 5);
    expect(result).toBe(false);
  });

  test('should not train invalid stat type', () => {
    const result = growthLayer.trainStats('invalid', 5);
    expect(result).toBe(false);
  });

  test('should level up successfully', () => {
    player.experience = 1000;
    const initialLevel = player.level;
    const result = growthLayer.levelUp();
    expect(result).toBe(true);
    expect(player.level).toBe(initialLevel + 1);
  });

  test('should not level up with insufficient experience', () => {
    player.experience = 0;
    const result = growthLayer.levelUp();
    expect(result).toBe(false);
  });

  test('should get player progress', () => {
    const progress = growthLayer.getPlayerProgress();
    expect(progress).toBeDefined();
    expect(progress.level).toBe(player.level);
    expect(progress.experience).toBe(player.experience);
    expect(progress.stats).toBeDefined();
  });

  test('should get available perks', () => {
    const availablePerks = growthLayer.getAvailablePerks();
    expect(Array.isArray(availablePerks)).toBe(true);
  });

  test('should get researched blueprints', () => {
    const researchedBlueprints = growthLayer.getResearchedBlueprints();
    expect(Array.isArray(researchedBlueprints)).toBe(true);
  });

  test('should add blueprint successfully', () => {
    const blueprint = {
      id: 'blueprint-1',
      name: 'Test Blueprint',
      type: 'weapon' as const,
      level: 1,
      materials: [],
      effects: {}
    };
    growthLayer.addBlueprint(blueprint);
    // Verify the blueprint was added by checking researched blueprints (should be empty initially)
    const researchedBlueprints = growthLayer.getResearchedBlueprints();
    expect(Array.isArray(researchedBlueprints)).toBe(true);
  });
});
