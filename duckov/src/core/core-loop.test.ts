import { CoreLoop, GameState } from './index';

describe('CoreLoop', () => {
  let coreLoop: CoreLoop;

  beforeEach(() => {
    coreLoop = new CoreLoop();
  });

  test('should initialize with base state', () => {
    expect(coreLoop.getCurrentState()).toBe(GameState.BASE);
  });

  test('should prepare base successfully', () => {
    coreLoop.prepareBase();
    expect(coreLoop.getCurrentState()).toBe(GameState.BASE);
    expect(coreLoop.getPlayer().stats.health).toBe(100);
    expect(coreLoop.getPlayer().stats.stamina).toBe(100);
  });

  test('should enter warzone successfully', () => {
    coreLoop.enterWarzone('forest');
    expect(coreLoop.getCurrentState()).toBe(GameState.WARZONE);
  });

  test('should loot items successfully', () => {
    coreLoop.enterWarzone('forest');
    const loot = coreLoop.loot();
    expect(Array.isArray(loot)).toBe(true);
    expect(loot.length).toBeGreaterThan(0);
  });

  test('should engage in combat successfully', () => {
    coreLoop.enterWarzone('forest');
    const result = coreLoop.engageCombat('enemy-1');
    expect(result).toBeDefined();
    expect('success' in result).toBe(true);
  });

  test('should evacuate successfully', () => {
    coreLoop.enterWarzone('forest');
    const result = coreLoop.evacuate('evac-1');
    expect(typeof result).toBe('boolean');
  });

  test('should return to base after evacuation', () => {
    coreLoop.enterWarzone('forest');
    coreLoop.evacuate('evac-1');
    expect(coreLoop.getCurrentState()).toBe(GameState.BASE);
  });

  test('should handle death correctly', () => {
    coreLoop.enterWarzone('forest');
    // Simulate death by setting health to 0
    const player = coreLoop.getPlayer();
    player.stats.health = 0;
    // This should trigger death handling
    coreLoop.engageCombat('enemy-1');
    expect(coreLoop.getCurrentState()).toBe(GameState.BASE);
    expect(coreLoop.getPlayer().stats.health).toBe(100);
  });

  test('should run game loop successfully', () => {
    expect(() => coreLoop.gameLoop()).not.toThrow();
  });

  test('should unlock perk successfully', () => {
    const player = coreLoop.getPlayer();
    player.cash = 10000; // Ensure enough cash
    const result = coreLoop.unlockPerk('backpack-upgrade');
    expect(result).toBe(true);
  });

  test('should train stats successfully', () => {
    const player = coreLoop.getPlayer();
    player.cash = 10000; // Ensure enough cash
    const initialStrength = player.stats.strength;
    const result = coreLoop.trainStats('strength', 5);
    expect(result).toBe(true);
    expect(player.stats.strength).toBe(initialStrength + 5);
  });

  test('should level up successfully', () => {
    const player = coreLoop.getPlayer();
    player.experience = 1000; // Ensure enough experience
    const initialLevel = player.level;
    const result = coreLoop.levelUp();
    expect(result).toBe(true);
    expect(player.level).toBe(initialLevel + 1);
  });

  test('should build facility successfully', () => {
    const base = coreLoop.getBase();
    // Add resources to base
    base.resources = [
      { id: 'metal', name: '金属', type: 'metal', amount: 1000 },
      { id: 'wood', name: '木材', type: 'wood', amount: 1000 }
    ];
    const result = coreLoop.buildFacility('workbench');
    expect(result).toBe(true);
  });

  test('should upgrade facility successfully', () => {
    const base = coreLoop.getBase();
    // Add resources to base
    base.resources = [
      { id: 'metal', name: '金属', type: 'metal', amount: 1000 },
      { id: 'wood', name: '木材', type: 'wood', amount: 1000 }
    ];
    coreLoop.buildFacility('workbench');
    const result = coreLoop.upgradeFacility('workbench');
    expect(result).toBe(true);
  });
});
