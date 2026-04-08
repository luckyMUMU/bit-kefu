"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ServiceLocator = void 0;
// 服务定位器实现
class ServiceLocator {
    constructor() {
        this.services = new Map();
    }
    static getInstance() {
        if (!ServiceLocator.instance) {
            ServiceLocator.instance = new ServiceLocator();
        }
        return ServiceLocator.instance;
    }
    registerService(name, service) {
        this.services.set(name, service);
    }
    getService(name) {
        return this.services.get(name);
    }
    removeService(name) {
        this.services.delete(name);
    }
}
exports.ServiceLocator = ServiceLocator;
