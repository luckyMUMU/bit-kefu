"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
describe('BaseConstruction', () => {
    let base;
    let player;
    let baseConstruction;
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
            cash: 1000,
            experience: 0
        };
        base = {
            id: 'base-1',
            name: 'Test Base',
            facilities: [],
            storage: [],
            resources: [
                { id: 'metal', name: '金属', type: 'metal', amount: 1000 },
                { id: 'wood', name: '木材', type: 'wood', amount: 1000 },
                { id: 'chemical', name: '化学物质', type: 'chemical', amount: 1000 },
                { id: 'electronic', name: '电子元件', type: 'electronic', amount: 1000 }
            ]
        };
        baseConstruction = new index_1.BaseConstruction(base, player);
    });
    test('should build a facility successfully', () => {
        const result = baseConstruction.buildFacility('workbench');
        expect(result).toBe(true);
        expect(base.facilities.length).toBe(1);
        expect(base.facilities[0].id).toBe('workbench');
        expect(base.facilities[0].name).toBe('工作台');
        expect(base.facilities[0].level).toBe(1);
    });
    test('should not build a facility that already exists', () => {
        baseConstruction.buildFacility('workbench');
        const result = baseConstruction.buildFacility('workbench');
        expect(result).toBe(false);
        expect(base.facilities.length).toBe(1);
    });
    test('should not build a facility with insufficient resources', () => {
        base.resources = [];
        const result = baseConstruction.buildFacility('workbench');
        expect(result).toBe(false);
        expect(base.facilities.length).toBe(0);
    });
    test('should upgrade a facility successfully', () => {
        baseConstruction.buildFacility('workbench');
        const result = baseConstruction.upgradeFacility('workbench');
        expect(result).toBe(true);
        expect(base.facilities[0].level).toBe(2);
    });
    test('should not upgrade a facility that does not exist', () => {
        const result = baseConstruction.upgradeFacility('workbench');
        expect(result).toBe(false);
    });
    test('should not upgrade a facility with insufficient resources', () => {
        baseConstruction.buildFacility('workbench');
        base.resources = [];
        const result = baseConstruction.upgradeFacility('workbench');
        expect(result).toBe(false);
        expect(base.facilities[0].level).toBe(1);
    });
    test('should use workbench to craft item', () => {
        baseConstruction.buildFacility('workbench');
        const result = baseConstruction.useFacility('workbench', 'craft', {
            blueprintId: 'blueprint-1',
            materials: []
        });
        expect(result).toBeDefined();
        expect(result.success).toBe(true);
    });
    test('should use medical station to heal player', () => {
        baseConstruction.buildFacility('medical-station');
        player.stats.health = 50;
        const result = baseConstruction.useFacility('medical-station', 'heal', {});
        expect(result).toBeDefined();
        expect(result.success).toBe(true);
        expect(player.stats.health).toBe(100);
    });
    test('should use gym to train stats', () => {
        baseConstruction.buildFacility('gym');
        const initialStrength = player.stats.strength;
        const result = baseConstruction.useFacility('gym', 'train', {
            statType: 'strength',
            amount: 5
        });
        expect(result).toBeDefined();
        expect(result.success).toBe(true);
        expect(player.stats.strength).toBe(initialStrength + 5);
    });
    test('should get facility status', () => {
        baseConstruction.buildFacility('workbench');
        const status = baseConstruction.getFacilityStatus('workbench');
        expect(status).toBeDefined();
        expect(status.level).toBe(1);
        expect(status.status).toBe('active');
        expect(status.effects).toBeDefined();
    });
    test('should get inactive status for non-existent facility', () => {
        const status = baseConstruction.getFacilityStatus('non-existent');
        expect(status).toBeDefined();
        expect(status.level).toBe(0);
        expect(status.status).toBe('inactive');
    });
});
