"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RiskLayer = void 0;
class RiskLayer {
    constructor() {
        this.playerInventory = [];
        this.safetySlotItems = [];
        this.recoverableItems = [];
        this.timeSpent = 0;
    }
    // 设置玩家库存
    setPlayerInventory(inventory) {
        this.playerInventory = inventory;
    }
    // 设置安全槽物品
    setSafetySlotItems(items) {
        this.safetySlotItems = items;
    }
    // 更新停留时间
    updateTimeSpent(seconds) {
        this.timeSpent = seconds;
    }
    // 计算时间奖励（稀有物品掉落概率提升）
    getTimeBonus(timeSpent) {
        // 基础掉落概率为 1.0
        // 每 60 秒提升 0.1，最大提升到 2.0
        const bonusMultiplier = Math.min(1.0 + Math.floor(timeSpent / 60) * 0.1, 2.0);
        return { type: 'loot', value: bonusMultiplier };
    }
    // 处理死亡机制
    handleDeath() {
        // 分离安全槽物品和普通物品
        const itemsLost = [];
        const itemsRecoverable = [];
        // 检查每个物品是否在安全槽中
        for (const item of this.playerInventory) {
            const isInSafetySlot = this.safetySlotItems.some(safeItem => safeItem.id === item.id);
            if (isInSafetySlot) {
                // 安全槽物品保留
                continue;
            }
            else {
                // 普通物品丢失但可回收
                itemsLost.push(item);
                itemsRecoverable.push(item);
            }
        }
        // 保存可回收物品
        this.recoverableItems = [...itemsRecoverable];
        // 随机重生点
        const respawnPoint = {
            x: Math.floor(Math.random() * 100),
            y: Math.floor(Math.random() * 100)
        };
        return { itemsLost, itemsRecoverable, respawnPoint };
    }
    // 处理二次风险（回收尸体时再次死亡）
    handleSecondaryRisk() {
        // 永久丢失之前可回收的物品
        const permanentLoss = [...this.recoverableItems];
        // 清空可回收物品
        this.recoverableItems = [];
        // 随机重生点
        const respawnPoint = {
            x: Math.floor(Math.random() * 100),
            y: Math.floor(Math.random() * 100)
        };
        return { permanentLoss, respawnPoint };
    }
    // 获取安全槽物品
    getSafetySlotItems() {
        return this.safetySlotItems;
    }
    // 计算区域风险等级
    calculateRisk(zoneId) {
        // 基础风险等级为 1
        let riskLevel = 1;
        // 根据区域类型调整风险
        if (zoneId.includes('danger')) {
            riskLevel = 2;
        }
        else if (zoneId.includes('boss')) {
            riskLevel = 3;
        }
        // 时间因素：每 5 分钟增加 0.5 风险等级
        riskLevel += Math.floor(this.timeSpent / 300) * 0.5;
        return riskLevel;
    }
    // 应用时间惩罚（敌人强度增加）
    applyTimePenalty(timeInZone) {
        // 基础敌人强度为 1.0
        let enemyStrength = 1.0;
        // 每 3 分钟提升 0.2
        enemyStrength += Math.floor(timeInZone / 180) * 0.2;
        // Boss 生成概率：每 10 分钟增加 10%
        const bossSpawnProbability = Math.min(Math.floor(timeInZone / 600) * 0.1, 0.5);
        return {
            enemyStrength,
            bossSpawnProbability,
            message: `已停留 ${timeInZone} 秒，敌人强度提升至 ${enemyStrength.toFixed(1)}，Boss 生成概率 ${(bossSpawnProbability * 100).toFixed(0)}%`
        };
    }
    // 获取风险等级对应的奖励
    getRiskRewards(riskLevel) {
        const rewards = [];
        // 基础奖励
        rewards.push({ type: 'experience', value: riskLevel * 100 });
        rewards.push({ type: 'cash', value: riskLevel * 500 });
        // 高风险额外奖励
        if (riskLevel >= 3) {
            rewards.push({ type: 'loot', value: riskLevel * 0.5 });
        }
        return rewards;
    }
}
exports.RiskLayer = RiskLayer;
