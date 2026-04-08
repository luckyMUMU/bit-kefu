"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
describe('RiskLayer', () => {
    let riskLayer;
    let testInventory;
    let testSafetyItems;
    beforeEach(() => {
        riskLayer = new index_1.RiskLayer();
        testInventory = [
            { id: '1', name: '普通武器', type: 'weapon', rarity: 'common', value: 100, weight: 5 },
            { id: '2', name: '稀有装备', type: 'armor', rarity: 'rare', value: 500, weight: 10 },
            { id: '3', name: '传奇药品', type: 'medicine', rarity: 'legendary', value: 1000, weight: 2 }
        ];
        testSafetyItems = [
            { id: '3', name: '传奇药品', type: 'medicine', rarity: 'legendary', value: 1000, weight: 2 }
        ];
        riskLayer.setPlayerInventory(testInventory);
        riskLayer.setSafetySlotItems(testSafetyItems);
    });
    test('should calculate time bonus correctly', () => {
        // 测试0秒时的奖励
        const bonus0 = riskLayer.getTimeBonus(0);
        expect(bonus0.type).toBe('loot');
        expect(bonus0.value).toBe(1.0);
        // 测试60秒时的奖励
        const bonus60 = riskLayer.getTimeBonus(60);
        expect(bonus60.value).toBe(1.1);
        // 测试120秒时的奖励
        const bonus120 = riskLayer.getTimeBonus(120);
        expect(bonus120.value).toBe(1.2);
        // 测试20分钟时的奖励（应该达到最大值2.0）
        const bonus1200 = riskLayer.getTimeBonus(1200);
        expect(bonus1200.value).toBe(2.0);
    });
    test('should handle death correctly', () => {
        const deathResult = riskLayer.handleDeath();
        // 应该丢失2个物品（排除安全槽的）
        expect(deathResult.itemsLost.length).toBe(2);
        expect(deathResult.itemsRecoverable.length).toBe(2);
        // 安全槽物品不应该在丢失列表中
        const hasSafetyItem = deathResult.itemsLost.some(item => item.id === '3');
        expect(hasSafetyItem).toBe(false);
    });
    test('should handle secondary risk correctly', () => {
        // 先处理死亡，生成可回收物品
        riskLayer.handleDeath();
        // 处理二次风险
        const secondaryResult = riskLayer.handleSecondaryRisk();
        // 应该永久丢失之前可回收的物品
        expect(secondaryResult.permanentLoss.length).toBe(2);
    });
    test('should apply time penalty correctly', () => {
        // 测试0秒时的惩罚
        const penalty0 = riskLayer.applyTimePenalty(0);
        expect(penalty0.enemyStrength).toBe(1.0);
        expect(penalty0.bossSpawnProbability).toBe(0);
        // 测试3分钟时的惩罚
        const penalty180 = riskLayer.applyTimePenalty(180);
        expect(penalty180.enemyStrength).toBe(1.2);
        expect(penalty180.bossSpawnProbability).toBe(0);
        // 测试10分钟时的惩罚
        const penalty600 = riskLayer.applyTimePenalty(600);
        expect(penalty600.enemyStrength).toBe(1.6); // 3分钟+3分钟+3分钟=9分钟，应该是1.0+0.2*3=1.6
        expect(penalty600.bossSpawnProbability).toBe(0.1);
        // 测试60分钟时的惩罚（应该达到Boss概率最大值0.5）
        const penalty3600 = riskLayer.applyTimePenalty(3600);
        expect(penalty3600.bossSpawnProbability).toBe(0.5);
    });
    test('should calculate risk level correctly', () => {
        // 更新停留时间为10分钟
        riskLayer.updateTimeSpent(600);
        // 测试安全区域的风险等级
        const safeRisk = riskLayer.calculateRisk('safe-zone-1');
        expect(safeRisk).toBe(1 + 2 * 0.5); // 基础1 + 10分钟*0.5 (600/300=2)
        // 测试危险区域的风险等级
        const dangerRisk = riskLayer.calculateRisk('danger-zone-1');
        expect(dangerRisk).toBe(2 + 2 * 0.5); // 基础2 + 10分钟*0.5 (600/300=2)
        // 测试Boss区域的风险等级
        const bossRisk = riskLayer.calculateRisk('boss-zone-1');
        expect(bossRisk).toBe(3 + 2 * 0.5); // 基础3 + 10分钟*0.5 (600/300=2)
    });
    test('should get risk rewards correctly', () => {
        // 测试低风险等级的奖励
        const lowRiskRewards = riskLayer.getRiskRewards(1);
        expect(lowRiskRewards.length).toBe(2); // 只有经验和现金
        // 测试高风险等级的奖励
        const highRiskRewards = riskLayer.getRiskRewards(3);
        expect(highRiskRewards.length).toBe(3); // 经验、现金和掉落奖励
    });
    test('should get safety slot items correctly', () => {
        const safetyItems = riskLayer.getSafetySlotItems();
        expect(safetyItems.length).toBe(1);
        expect(safetyItems[0].id).toBe('3');
    });
});
