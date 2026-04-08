"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseConstruction = void 0;
class BaseConstruction {
    constructor(base, player) {
        this.base = base;
        this.player = player;
        this.facilitiesData = this.initializeFacilitiesData();
    }
    initializeFacilitiesData() {
        return new Map([
            ['workbench', {
                    name: '工作台',
                    type: 'workbench',
                    maxLevel: 5,
                    baseCost: [
                        { id: 'metal', name: '金属', type: 'metal', amount: 100 },
                        { id: 'wood', name: '木材', type: 'wood', amount: 50 }
                    ],
                    upgradeCostMultiplier: 1.5,
                    effects: new Map([
                        [1, [{ id: 'craft-speed-1', name: '基础制造速度', type: 'production', value: 1 }]],
                        [2, [{ id: 'craft-speed-2', name: '中级制造速度', type: 'production', value: 1.5 }]],
                        [3, [{ id: 'craft-speed-3', name: '高级制造速度', type: 'production', value: 2 }]],
                        [4, [{ id: 'craft-speed-4', name: '专家制造速度', type: 'production', value: 2.5 }]],
                        [5, [{ id: 'craft-speed-5', name: '大师制造速度', type: 'production', value: 3 }]]
                    ])
                }],
            ['research-station', {
                    name: '蓝图研究站',
                    type: 'research-station',
                    maxLevel: 5,
                    baseCost: [
                        { id: 'metal', name: '金属', type: 'metal', amount: 150 },
                        { id: 'electronic', name: '电子元件', type: 'electronic', amount: 50 }
                    ],
                    upgradeCostMultiplier: 1.5,
                    effects: new Map([
                        [1, [{ id: 'research-speed-1', name: '基础研究速度', type: 'research', value: 1 }]],
                        [2, [{ id: 'research-speed-2', name: '中级研究速度', type: 'research', value: 1.5 }]],
                        [3, [{ id: 'research-speed-3', name: '高级研究速度', type: 'research', value: 2 }]],
                        [4, [{ id: 'research-speed-4', name: '专家研究速度', type: 'research', value: 2.5 }]],
                        [5, [{ id: 'research-speed-5', name: '大师研究速度', type: 'research', value: 3 }]]
                    ])
                }],
            ['medical-station', {
                    name: '医疗站',
                    type: 'medical-station',
                    maxLevel: 5,
                    baseCost: [
                        { id: 'metal', name: '金属', type: 'metal', amount: 100 },
                        { id: 'chemical', name: '化学物质', type: 'chemical', amount: 50 }
                    ],
                    upgradeCostMultiplier: 1.5,
                    effects: new Map([
                        [1, [{ id: 'heal-efficiency-1', name: '基础治疗效率', type: 'production', value: 1 }]],
                        [2, [{ id: 'heal-efficiency-2', name: '中级治疗效率', type: 'production', value: 1.5 }]],
                        [3, [{ id: 'heal-efficiency-3', name: '高级治疗效率', type: 'production', value: 2 }]],
                        [4, [{ id: 'heal-efficiency-4', name: '专家治疗效率', type: 'production', value: 2.5 }]],
                        [5, [{ id: 'heal-efficiency-5', name: '大师治疗效率', type: 'production', value: 3 }]]
                    ])
                }],
            ['armory', {
                    name: '军备室',
                    type: 'armory',
                    maxLevel: 5,
                    baseCost: [
                        { id: 'metal', name: '金属', type: 'metal', amount: 200 },
                        { id: 'wood', name: '木材', type: 'wood', amount: 100 }
                    ],
                    upgradeCostMultiplier: 1.5,
                    effects: new Map([
                        [1, [{ id: 'storage-capacity-1', name: '基础存储容量', type: 'upgrade', value: 50 }]],
                        [2, [{ id: 'storage-capacity-2', name: '中级存储容量', type: 'upgrade', value: 100 }]],
                        [3, [{ id: 'storage-capacity-3', name: '高级存储容量', type: 'upgrade', value: 150 }]],
                        [4, [{ id: 'storage-capacity-4', name: '专家存储容量', type: 'upgrade', value: 200 }]],
                        [5, [{ id: 'storage-capacity-5', name: '大师存储容量', type: 'upgrade', value: 250 }]]
                    ])
                }],
            ['gym', {
                    name: '健身房',
                    type: 'gym',
                    maxLevel: 5,
                    baseCost: [
                        { id: 'metal', name: '金属', type: 'metal', amount: 150 },
                        { id: 'wood', name: '木材', type: 'wood', amount: 150 }
                    ],
                    upgradeCostMultiplier: 1.5,
                    effects: new Map([
                        [1, [{ id: 'training-efficiency-1', name: '基础训练效率', type: 'upgrade', value: 1 }]],
                        [2, [{ id: 'training-efficiency-2', name: '中级训练效率', type: 'upgrade', value: 1.5 }]],
                        [3, [{ id: 'training-efficiency-3', name: '高级训练效率', type: 'upgrade', value: 2 }]],
                        [4, [{ id: 'training-efficiency-4', name: '专家训练效率', type: 'upgrade', value: 2.5 }]],
                        [5, [{ id: 'training-efficiency-5', name: '大师训练效率', type: 'upgrade', value: 3 }]]
                    ])
                }],
            ['storage-locker', {
                    name: '储物柜',
                    type: 'storage-locker',
                    maxLevel: 5,
                    baseCost: [
                        { id: 'metal', name: '金属', type: 'metal', amount: 100 },
                        { id: 'wood', name: '木材', type: 'wood', amount: 100 }
                    ],
                    upgradeCostMultiplier: 1.5,
                    effects: new Map([
                        [1, [{ id: 'locker-capacity-1', name: '基础储物柜容量', type: 'upgrade', value: 100 }]],
                        [2, [{ id: 'locker-capacity-2', name: '中级储物柜容量', type: 'upgrade', value: 200 }]],
                        [3, [{ id: 'locker-capacity-3', name: '高级储物柜容量', type: 'upgrade', value: 300 }]],
                        [4, [{ id: 'locker-capacity-4', name: '专家储物柜容量', type: 'upgrade', value: 400 }]],
                        [5, [{ id: 'locker-capacity-5', name: '大师储物柜容量', type: 'upgrade', value: 500 }]]
                    ])
                }]
        ]);
    }
    buildFacility(facilityId) {
        const facilityData = this.facilitiesData.get(facilityId);
        if (!facilityData) {
            console.log(`设施 ${facilityId} 不存在`);
            return false;
        }
        const existingFacility = this.base.facilities.find(f => f.id === facilityId);
        if (existingFacility) {
            console.log(`设施 ${facilityId} 已存在`);
            return false;
        }
        if (!this.hasEnoughResources(facilityData.baseCost)) {
            console.log(`资源不足，无法建造设施 ${facilityId}`);
            return false;
        }
        this.consumeResources(facilityData.baseCost);
        const newFacility = {
            id: facilityId,
            name: facilityData.name,
            type: facilityData.type,
            level: 1,
            status: 'active',
            effects: facilityData.effects.get(1)
        };
        this.base.facilities.push(newFacility);
        console.log(`成功建造设施: ${facilityData.name}`);
        return true;
    }
    upgradeFacility(facilityId) {
        const facility = this.base.facilities.find(f => f.id === facilityId);
        if (!facility) {
            console.log(`设施 ${facilityId} 不存在`);
            return false;
        }
        const facilityData = this.facilitiesData.get(facilityId);
        if (!facilityData) {
            console.log(`设施数据不存在`);
            return false;
        }
        if (facility.level >= facilityData.maxLevel) {
            console.log(`设施 ${facilityId} 已达到最高等级`);
            return false;
        }
        const nextLevel = facility.level + 1;
        const upgradeCost = this.calculateUpgradeCost(facilityData.baseCost, nextLevel, facilityData.upgradeCostMultiplier);
        if (!this.hasEnoughResources(upgradeCost)) {
            console.log(`资源不足，无法升级设施 ${facilityId}`);
            return false;
        }
        this.consumeResources(upgradeCost);
        facility.level = nextLevel;
        facility.status = 'active';
        facility.effects = facilityData.effects.get(nextLevel);
        console.log(`成功升级设施 ${facilityId} 至等级 ${nextLevel}`);
        return true;
    }
    useFacility(facilityId, action, params) {
        const facility = this.base.facilities.find(f => f.id === facilityId);
        if (!facility || facility.status !== 'active') {
            console.log(`设施 ${facilityId} 不可用`);
            return null;
        }
        switch (facility.type) {
            case 'workbench':
                return this.useWorkbench(action, params);
            case 'research-station':
                return this.useResearchStation(action, params);
            case 'medical-station':
                return this.useMedicalStation(action, params);
            case 'armory':
                return this.useArmory(action, params);
            case 'gym':
                return this.useGym(action, params);
            case 'storage-locker':
                return this.useStorageLocker(action, params);
            default:
                console.log(`未知设施类型: ${facility.type}`);
                return null;
        }
    }
    getFacilityStatus(facilityId) {
        const facility = this.base.facilities.find(f => f.id === facilityId);
        if (!facility) {
            return { level: 0, status: 'inactive', effects: [] };
        }
        const facilityData = this.facilitiesData.get(facilityId);
        const nextLevel = facility.level + 1;
        let upgradeCost = [];
        if (facilityData && nextLevel <= facilityData.maxLevel) {
            upgradeCost = this.calculateUpgradeCost(facilityData.baseCost, nextLevel, facilityData.upgradeCostMultiplier);
        }
        return {
            level: facility.level,
            status: facility.status,
            effects: facility.effects || [],
            upgradeCost
        };
    }
    useWorkbench(action, params) {
        switch (action) {
            case 'craft':
                return this.craftItem(params.blueprintId, params.materials);
            case 'repair':
                return this.repairItem(params.itemId);
            default:
                return null;
        }
    }
    useResearchStation(action, params) {
        if (action === 'research') {
            return this.researchBlueprint(params.blueprintId);
        }
        return null;
    }
    useMedicalStation(action, params) {
        switch (action) {
            case 'heal':
                return this.healPlayer();
            case 'craftMedicine':
                return this.craftMedicine(params.medicineId, params.materials);
            default:
                return null;
        }
    }
    useArmory(action, params) {
        switch (action) {
            case 'store':
                return this.storeInArmory(params.items);
            case 'retrieve':
                return this.retrieveFromArmory(params.itemIds);
            default:
                return null;
        }
    }
    useGym(action, params) {
        if (action === 'train') {
            return this.trainStats(params.statType, params.amount);
        }
        return null;
    }
    useStorageLocker(action, params) {
        switch (action) {
            case 'store':
                return this.storeInLocker(params.items);
            case 'retrieve':
                return this.retrieveFromLocker(params.itemIds);
            default:
                return null;
        }
    }
    craftItem(blueprintId, materials) {
        console.log(`使用工作台制造物品，蓝图: ${blueprintId}`);
        return { success: true, item: { id: 'crafted-item', name: '制造的物品', type: 'weapon', rarity: 'common', value: 100, weight: 5 } };
    }
    repairItem(itemId) {
        console.log(`使用工作台修理物品: ${itemId}`);
        return { success: true };
    }
    researchBlueprint(blueprintId) {
        console.log(`使用研究站研究蓝图: ${blueprintId}`);
        return { success: true, unlockedRecipes: ['recipe-1', 'recipe-2'] };
    }
    healPlayer() {
        this.player.stats.health = 100;
        console.log(`使用医疗站治疗玩家，当前生命值: ${this.player.stats.health}`);
        return { success: true, health: this.player.stats.health };
    }
    craftMedicine(medicineId, materials) {
        console.log(`使用医疗站制造药品: ${medicineId}`);
        return { success: true, medicine: { id: medicineId, name: '制造的药品', type: 'medicine', rarity: 'common', value: 50, weight: 1 } };
    }
    storeInArmory(items) {
        console.log(`使用军备室存储物品: ${items.length} 件`);
        return { success: true, stored: items.length };
    }
    retrieveFromArmory(itemIds) {
        console.log(`使用军备室取回物品: ${itemIds.length} 件`);
        return { success: true, retrieved: itemIds.length };
    }
    trainStats(statType, amount) {
        if (this.player.stats[statType]) {
            this.player.stats[statType] += amount;
            console.log(`使用健身房训练 ${statType}，增加 ${amount} 点`);
            return { success: true, stat: statType, value: this.player.stats[statType] };
        }
        return { success: false, message: '无效的属性类型' };
    }
    storeInLocker(items) {
        console.log(`使用储物柜存储物品: ${items.length} 件`);
        return { success: true, stored: items.length };
    }
    retrieveFromLocker(itemIds) {
        console.log(`使用储物柜取回物品: ${itemIds.length} 件`);
        return { success: true, retrieved: itemIds.length };
    }
    hasEnoughResources(cost) {
        for (const resource of cost) {
            const availableResource = this.base.resources.find(r => r.id === resource.id);
            if (!availableResource || availableResource.amount < resource.amount) {
                return false;
            }
        }
        return true;
    }
    consumeResources(cost) {
        for (const resource of cost) {
            const availableResource = this.base.resources.find(r => r.id === resource.id);
            if (availableResource) {
                availableResource.amount -= resource.amount;
            }
        }
    }
    calculateUpgradeCost(baseCost, level, multiplier) {
        return baseCost.map(resource => (Object.assign(Object.assign({}, resource), { amount: Math.floor(resource.amount * Math.pow(multiplier, level - 1)) })));
    }
    getBase() {
        return this.base;
    }
    setBase(base) {
        this.base = base;
    }
    setPlayer(player) {
        this.player = player;
    }
}
exports.BaseConstruction = BaseConstruction;
