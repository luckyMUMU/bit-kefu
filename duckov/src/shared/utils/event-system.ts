// 事件系统实现
export class EventSystem {
  private events: Map<string, Function[]> = new Map();
  private eventQueue: Array<{ event: string, args: any[] }> = [];
  private isProcessing: boolean = false;

  on(event: string, callback: Function): void {
    if (!this.events.has(event)) {
      this.events.set(event, []);
    }
    this.events.get(event)?.push(callback);
  }

  emit(event: string, ...args: any[]): void {
    // 使用事件队列进行批处理
    this.eventQueue.push({ event, args });
    if (!this.isProcessing) {
      this.processEventQueue();
    }
  }

  off(event: string, callback: Function): void {
    const callbacks = this.events.get(event);
    if (callbacks) {
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }

  private processEventQueue(): void {
    this.isProcessing = true;
    while (this.eventQueue.length > 0) {
      const { event, args } = this.eventQueue.shift()!;
      const callbacks = this.events.get(event);
      if (callbacks) {
        // 优化回调执行，避免闭包开销
        for (let i = 0; i < callbacks.length; i++) {
          try {
            callbacks[i](...args);
          } catch (error) {
            console.error(`Event callback error: ${error}`);
          }
        }
      }
    }
    this.isProcessing = false;
  }

  // 清理事件系统
  clear(): void {
    this.events.clear();
    this.eventQueue = [];
  }
}