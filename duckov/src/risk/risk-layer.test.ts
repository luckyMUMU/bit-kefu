import { RiskLayer } from './index';
import { LootItem } from '../shared/types';

describe('RiskLayer', () => {
  let riskLayer: RiskLayer;

  beforeEach(() => {
    riskLayer = new RiskLayer();
  });

  test('should set player inventory successfully', () => {
    const inventory: LootItem[] = [
      { id: 'item-1', name: 'Test Item 1', type: 'weapon', rarity: 'common', value: 100, weight: 1 },
      { id: 'item-2', name: 'Test Item 2', type: 'armor', rarity: 'uncommon', value: 200, weight: 2 }
    ];
    riskLayer.setPlayerInventory(inventory);
    // This method doesn't return a value, but it should not throw
    expect(() => riskLayer.setPlayerInventory(inventory)).not.toThrow();
  });

  test('should set safety slot items successfully', () => {
    const safetyItems: LootItem[] = [
      { id: 'item-1', name: 'Test Item 1', type: 'weapon', rarity: 'common', value: 100, weight: 1 }
    ];
    riskLayer.setSafetySlotItems(safetyItems);
    // This method doesn't return a value, but it should not throw
    expect(() => riskLayer.setSafetySlotItems(safetyItems)).not.toThrow();
  });

  test('should update time spent successfully', () => {
    riskLayer.updateTimeSpent(300);
    // This method doesn't return a value, but it should not throw
    expect(() => riskLayer.updateTimeSpent(300)).not.toThrow();
  });

  test('should get time bonus successfully', () => {
    const bonus = riskLayer.getTimeBonus(600); // 10 minutes
    expect(bonus).toBeDefined();
    expect(bonus.type).toBe('loot');
    expect(bonus.value).toBeGreaterThan(1.0);
  });

  test('should handle death successfully', () => {
    const inventory: LootItem[] = [
      { id: 'item-1', name: 'Test Item 1', type: 'weapon', rarity: 'common', value: 100, weight: 1 },
      { id: 'item-2', name: 'Test Item 2', type: 'armor', rarity: 'uncommon', value: 200, weight: 2 }
    ];
    const safetyItems: LootItem[] = [
      { id: 'item-1', name: 'Test Item 1', type: 'weapon', rarity: 'common', value: 100, weight: 1 }
    ];
    riskLayer.setPlayerInventory(inventory);
    riskLayer.setSafetySlotItems(safetyItems);
    
    const deathResult = riskLayer.handleDeath();
    expect(deathResult).toBeDefined();
    expect(Array.isArray(deathResult.itemsLost)).toBe(true);
    expect(Array.isArray(deathResult.itemsRecoverable)).toBe(true);
    expect(deathResult.respawnPoint).toBeDefined();
    expect(deathResult.respawnPoint.x).toBeDefined();
    expect(deathResult.respawnPoint.y).toBeDefined();
  });

  test('should handle secondary risk successfully', () => {
    const inventory: LootItem[] = [
      { id: 'item-1', name: 'Test Item 1', type: 'weapon', rarity: 'common', value: 100, weight: 1 }
    ];
    riskLayer.setPlayerInventory(inventory);
    riskLayer.handleDeath(); // First death to populate recoverable items
    
    const secondaryResult = riskLayer.handleSecondaryRisk();
    expect(secondaryResult).toBeDefined();
    expect(Array.isArray(secondaryResult.permanentLoss)).toBe(true);
    expect(secondaryResult.respawnPoint).toBeDefined();
    expect(secondaryResult.respawnPoint.x).toBeDefined();
    expect(secondaryResult.respawnPoint.y).toBeDefined();
  });

  test('should get safety slot items successfully', () => {
    const safetyItems: LootItem[] = [
      { id: 'item-1', name: 'Test Item 1', type: 'weapon', rarity: 'common', value: 100, weight: 1 }
    ];
    riskLayer.setSafetySlotItems(safetyItems);
    const retrievedItems = riskLayer.getSafetySlotItems();
    expect(Array.isArray(retrievedItems)).toBe(true);
  });

  test('should calculate risk successfully', () => {
    riskLayer.updateTimeSpent(300); // 5 minutes
    const riskLevel = riskLayer.calculateRisk('danger-zone');
    expect(typeof riskLevel).toBe('number');
    expect(riskLevel).toBeGreaterThan(0);
  });

  test('should apply time penalty successfully', () => {
    const penalty = riskLayer.applyTimePenalty(600); // 10 minutes
    expect(penalty).toBeDefined();
    expect(penalty.enemyStrength).toBeGreaterThan(1.0);
    expect(penalty.bossSpawnProbability).toBeGreaterThan(0);
    expect(typeof penalty.message).toBe('string');
  });

  test('should get risk rewards successfully', () => {
    const rewards = riskLayer.getRiskRewards(3);
    expect(Array.isArray(rewards)).toBe(true);
    expect(rewards.length).toBeGreaterThan(0);
    rewards.forEach(reward => {
      expect(reward.type).toBeDefined();
      expect(reward.value).toBeDefined();
    });
  });
});
