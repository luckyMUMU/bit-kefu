// 服务定位器实现
export class ServiceLocator {
  private static instance: ServiceLocator;
  private services: Map<string, any> = new Map();

  static getInstance(): ServiceLocator {
    if (!ServiceLocator.instance) {
      ServiceLocator.instance = new ServiceLocator();
    }
    return ServiceLocator.instance;
  }

  registerService(name: string, service: any): void {
    this.services.set(name, service);
  }

  getService(name: string): any {
    return this.services.get(name);
  }

  removeService(name: string): void {
    this.services.delete(name);
  }
}