"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
describe('GrowthLayer', () => {
    let growthLayer;
    let player;
    let base;
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
        growthLayer = new index_1.GrowthLayer(player, base);
    });
    test('should unlock perk successfully', () => {
        const result = growthLayer.unlockPerk('backpack-upgrade');
        expect(result).toBe(true);
        expect(player.perks).toContain('backpack-upgrade');
        expect(player.cash).toBeLessThan(10000);
    });
    test('should not unlock perk if cash is insufficient', () => {
        player.cash = 500;
        const result = growthLayer.unlockPerk('backpack-upgrade');
        expect(result).toBe(false);
    });
    test('should not unlock perk if it has prerequisites', () => {
        const result = growthLayer.unlockPerk('marksmanship');
        expect(result).toBe(false);
    });
    test('should unlock perk with prerequisites after unlocking them', () => {
        growthLayer.unlockPerk('strength-boost');
        const result = growthLayer.unlockPerk('marksmanship');
        expect(result).toBe(true);
    });
    test('should train stats successfully', () => {
        const initialHealth = player.stats.health;
        const result = growthLayer.trainStats('health', 5);
        expect(result).toBe(true);
        expect(player.stats.health).toBe(initialHealth + 5);
        expect(player.cash).toBeLessThan(10000);
    });
    test('should not train stats if cash is insufficient', () => {
        player.cash = 1000;
        const result = growthLayer.trainStats('health', 5);
        expect(result).toBe(false);
    });
    test('should research blueprint successfully', () => {
        const blueprint = {
            id: 'blueprint-1',
            name: 'Test Blueprint',
            type: 'weapon',
            level: 1,
            materials: [],
            effects: {}
        };
        growthLayer.addBlueprint(blueprint);
        const result = growthLayer.researchBlueprint('blueprint-1');
        expect(result).toBe(true);
        expect(player.cash).toBeLessThan(10000);
    });
    test('should modify equipment successfully', () => {
        const weapon = {
            id: 'weapon-1',
            name: 'Test Weapon',
            type: 'weapon',
            rarity: 'common',
            value: 1000,
            weight: 5,
            weaponType: 'rifle',
            damage: 50,
            fireRate: 10,
            accuracy: 80,
            range: 100,
            magazineSize: 30,
            currentAmmo: 30,
            ammoType: '5.56mm',
            accessories: [],
            stealth: 0
        };
        player.equipment.weapon = weapon;
        const result = growthLayer.modifyEquipment('weapon-1', 'accessory-1');
        expect(result).toBe(true);
        expect(weapon.accessories.length).toBe(1);
    });
    test('should level up successfully', () => {
        player.experience = 1000;
        const initialLevel = player.level;
        const initialHealth = player.stats.health;
        const result = growthLayer.levelUp();
        expect(result).toBe(true);
        expect(player.level).toBe(initialLevel + 1);
        expect(player.stats.health).toBeGreaterThan(initialHealth);
    });
    test('should not level up if experience is insufficient', () => {
        player.experience = 500;
        const result = growthLayer.levelUp();
        expect(result).toBe(false);
    });
    test('should get player progress', () => {
        const progress = growthLayer.getPlayerProgress();
        expect(progress).toHaveProperty('level');
        expect(progress).toHaveProperty('experience');
        expect(progress).toHaveProperty('stats');
        expect(progress).toHaveProperty('perks');
        expect(progress).toHaveProperty('cash');
    });
    test('should get available perks', () => {
        const availablePerks = growthLayer.getAvailablePerks();
        expect(Array.isArray(availablePerks)).toBe(true);
    });
    test('should get researched blueprints', () => {
        const blueprints = growthLayer.getResearchedBlueprints();
        expect(Array.isArray(blueprints)).toBe(true);
    });
});
