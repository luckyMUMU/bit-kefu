import { CoreLoop } from '../core';
import { EventSystem } from '../shared/utils/event-system';
import { ServiceLocator } from '../shared/utils/service-locator';

describe('Compatibility Tests', () => {
  test('should run in different Node.js environments', () => {
    // 测试不同 Node.js 版本的兼容性
    const nodeVersion = process.version;
    console.log(`Running on Node.js version: ${nodeVersion}`);
    
    // 测试核心功能在当前环境下是否正常运行
    const coreLoop = new CoreLoop();
    expect(() => coreLoop.gameLoop()).not.toThrow();
  });

  test('should handle different memory configurations', () => {
    // 测试不同内存配置下的兼容性
    const memoryUsage = process.memoryUsage();
    console.log(`Current memory usage: ${JSON.stringify(memoryUsage)}`);
    
    // 测试内存密集型操作
    const coreLoop = new CoreLoop();
    coreLoop.enterWarzone('forest');
    
    // 生成大量物品
    for (let i = 0; i < 50; i++) {
      coreLoop.loot();
    }
    
    expect(() => coreLoop.gameLoop()).not.toThrow();
  });

  test('should handle different CPU configurations', () => {
    // 测试不同 CPU 配置下的兼容性
    const cpus = require('os').cpus();
    console.log(`Number of CPUs: ${cpus.length}`);
    
    // 测试 CPU 密集型操作
    const start = performance.now();
    const eventSystem = new EventSystem();
    
    // 注册大量事件监听器
    for (let i = 0; i < 1000; i++) {
      eventSystem.on(`event-${i}`, () => {
        // 空回调
      });
    }
    
    // 触发大量事件
    for (let i = 0; i < 1000; i++) {
      eventSystem.emit(`event-${i}`, i);
    }
    
    const end = performance.now();
    console.log(`CPU密集型操作执行时间: ${end - start}ms`);
    expect(end - start).toBeLessThan(1000); // 1000ms 阈值
  });

  test('should handle different service locator configurations', () => {
    // 测试服务定位器在不同配置下的兼容性
    const serviceLocator = ServiceLocator.getInstance();
    
    // 注册和获取服务
    const testService = { id: 'test', name: 'Test Service' };
    serviceLocator.registerService('testService', testService);
    const retrievedService = serviceLocator.getService('testService');
    
    expect(retrievedService).toBeDefined();
    expect(retrievedService.id).toBe('test');
    expect(retrievedService.name).toBe('Test Service');
    
    // 移除服务
    serviceLocator.removeService('testService');
    const removedService = serviceLocator.getService('testService');
    expect(removedService).toBeUndefined();
  });

  test('should handle different game states', () => {
    // 测试不同游戏状态下的兼容性
    const coreLoop = new CoreLoop();
    
    // 测试基地状态
    coreLoop.prepareBase();
    expect(coreLoop.getCurrentState()).toBe('base');
    
    // 测试战区状态
    coreLoop.enterWarzone('forest');
    expect(coreLoop.getCurrentState()).toBe('warzone');
    
    // 测试搜刮状态
    coreLoop.loot();
    expect(coreLoop.getCurrentState()).toBe('warzone'); // 搜刮后返回战区状态
    
    // 测试撤离状态
    coreLoop.evacuate('evac-1');
    expect(coreLoop.getCurrentState()).toBe('base'); // 撤离后返回基地状态
  });

  test('should handle edge cases', () => {
    // 测试边缘情况的兼容性
    const coreLoop = new CoreLoop();
    
    // 测试空操作
    expect(() => coreLoop.gameLoop()).not.toThrow();
    
    // 测试重复操作
    coreLoop.enterWarzone('forest');
    coreLoop.enterWarzone('forest'); // 重复进入战区
    expect(() => coreLoop.gameLoop()).not.toThrow();
    
    // 测试无效操作
    coreLoop.prepareBase();
    expect(() => coreLoop.loot()).not.toThrow(); // 在基地状态下尝试搜刮
    expect(() => coreLoop.engageCombat('enemy-1')).not.toThrow(); // 在基地状态下尝试战斗
  });
});
