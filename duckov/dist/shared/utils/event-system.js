"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventSystem = void 0;
// 事件系统实现
class EventSystem {
    constructor() {
        this.events = new Map();
    }
    on(event, callback) {
        var _a;
        if (!this.events.has(event)) {
            this.events.set(event, []);
        }
        (_a = this.events.get(event)) === null || _a === void 0 ? void 0 : _a.push(callback);
    }
    emit(event, ...args) {
        const callbacks = this.events.get(event);
        if (callbacks) {
            callbacks.forEach(callback => callback(...args));
        }
    }
    off(event, callback) {
        const callbacks = this.events.get(event);
        if (callbacks) {
            const index = callbacks.indexOf(callback);
            if (index > -1) {
                callbacks.splice(index, 1);
            }
        }
    }
}
exports.EventSystem = EventSystem;
