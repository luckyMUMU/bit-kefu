// 核心数据结构定义

// 物品数据结构
export interface LootItem {
  id: string;
  name: string;
  type: 'weapon' | 'armor' | 'medicine' | 'resource' | 'blueprint' | 'collectible';
  rarity: 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary';
  value: number;
  weight: number;
  effects?: Effect[];
}

// 效果数据结构
export interface Effect {
  id: string;
  name: string;
  type: 'buff' | 'debuff';
  value: number;
  duration: number;
}

// 角色数据结构
export interface Player {
  id: string;
  name: string;
  level: number;
  position: Position;
  stats: {
    health: number;
    stamina: number;
    strength: number;
    agility: number;
    intellect: number;
  };
  perks: string[];
  inventory: LootItem[];
  equipment: {
    weapon: LootItem | null;
    armor: LootItem | null;
    accessories: LootItem[];
  };
  cash: number;
  experience: number;
}

// 地图数据结构
export interface MapData {
  id: string;
  name: string;
  size: { width: number; height: number };
  zones: Zone[];
  evacuationPoints: EvacuationPoint[];
  shortcuts: Shortcut[];
  weather: Weather;
}

// 区域数据结构
export interface Zone {
  id: string;
  name: string;
  position: Position;
  size: { width: number; height: number };
  type: 'safe' | 'danger' | 'boss';
  lootSpawns: Position[];
  enemySpawns: Position[];
}

// 撤离点数据结构
export interface EvacuationPoint {
  id: string;
  name: string;
  position: Position;
  status: 'active' | 'inactive' | 'locked';
  requirements?: any;
}

// 捷径数据结构
export interface Shortcut {
  id: string;
  name: string;
  from: Position;
  to: Position;
  status: 'unlocked' | 'locked';
  requirements?: any;
}

// 天气数据结构
export interface Weather {
  type: 'clear' | 'rain' | 'fog' | 'storm';
  intensity: number;
  duration: number;
  effects: WeatherEffect[];
}

// 天气效果数据结构
export interface WeatherEffect {
  id: string;
  name: string;
  type: 'visibility' | 'movement' | 'combat';
  value: number;
}

// 基地数据结构
export interface Base {
  id: string;
  name: string;
  facilities: Facility[];
  storage: LootItem[];
  resources: Resource[];
}

// 设施数据结构
export interface Facility {
  id: string;
  name: string;
  type: 'workbench' | 'research-station' | 'medical-station' | 'armory' | 'gym' | 'storage-locker';
  level: number;
  status: 'active' | 'upgrading' | 'inactive';
  effects?: FacilityEffect[];
}

// 设施效果数据结构
export interface FacilityEffect {
  id: string;
  name: string;
  type: 'production' | 'upgrade' | 'research';
  value: number;
}

// 资源数据结构
export interface Resource {
  id: string;
  name: string;
  type: 'metal' | 'wood' | 'chemical' | 'electronic';
  amount: number;
}

// 位置数据结构
export interface Position {
  x: number;
  y: number;
}

// 武器数据结构
export interface Weapon extends LootItem {
  weaponType: 'melee' | 'pistol' | 'rifle' | 'shotgun' | 'sniper' | 'launcher';
  damage: number;
  fireRate: number;
  accuracy: number;
  range: number;
  magazineSize: number;
  currentAmmo: number;
  ammoType: string;
  accessories: WeaponAccessory[];
  stealth: number;
}

// 武器配件数据结构
export interface WeaponAccessory {
  id: string;
  name: string;
  type: 'silencer' | 'scope' | 'magazine' | 'barrel' | 'grip';
  effects: {
    damage?: number;
    accuracy?: number;
    range?: number;
    fireRate?: number;
    magazineSize?: number;
    stealth?: number;
  };
  weight: number;
}

// 弹药数据结构
export interface Ammo {
  id: string;
  name: string;
  type: string;
  damageMultiplier: number;
  quantity: number;
  weight: number;
}

// 战斗结果数据结构
export interface CombatResult {
  success: boolean;
  damage: number;
  loot?: LootItem[];
  experience: number;
}

// 死亡结果数据结构
export interface DeathResult {
  itemsLost: LootItem[];
  itemsRecoverable: LootItem[];
  respawnPoint: Position;
}

// 二次风险结果数据结构
export interface SecondaryRiskResult {
  permanentLoss: LootItem[];
  respawnPoint: Position;
}

// 奖励数据结构
export interface Bonus {
  type: 'loot' | 'experience' | 'cash';
  value: number;
}

// 设施状态数据结构
export interface FacilityStatus {
  level: number;
  status: 'active' | 'upgrading' | 'inactive';
  effects: FacilityEffect[];
  upgradeCost?: Resource[];
}

// 撤离点状态数据结构
export interface EvacPointStatus {
  status: 'active' | 'inactive' | 'locked';
  requirements?: any;
  countdown?: number;
}

// 攻击结果数据结构
export interface AttackResult {
  success: boolean;
  damage: number;
  critical: boolean;
  effects?: Effect[];
}

// 防御结果数据结构
export interface DefenseResult {
  success: boolean;
  damageReduced: number;
  effects?: Effect[];
}

// 敌人数据结构
export interface Enemy {
  id: string;
  name: string;
  type: 'melee' | 'ranged' | 'special';
  health: number;
  maxHealth: number;
  damage: number;
  accuracy: number;
  speed: number;
  detectionRange: number;
  attackRange: number;
  behavior: 'patrol' | 'guard' | 'aggressive' | 'retreat';
  status: 'idle' | 'alert' | 'attacking' | 'fleeing';
  position: Position;
  loot: LootItem[];
  specialAbility?: string;
}

// 地形效果数据结构
export interface TerrainEffect {
  type: 'cover' | 'obstacle' | 'boost';
  value: number;
  duration: number;
}

// 地形数据结构
export interface Terrain {
  id: string;
  type: 'cover' | 'obstacle' | 'open' | 'water' | 'elevated';
  position: Position;
  size: { width: number; height: number };
  properties: {
    coverValue: number;
    passable: boolean;
    destructible: boolean;
    health?: number;
  };
}

// 库存状态数据结构
export interface InventoryStatus {
  items: LootItem[];
  capacity: number;
  used: number;
  weight: number;
  maxWeight: number;
}

// 分配数据结构
export interface Allocation {
  type: 'use' | 'sell' | 'dismantle';
  itemId: string;
  amount: number;
}

// 核心循环接口
export interface CoreLoopInterface {
  prepareBase(): void;
  enterWarzone(mapId: string): void;
  loot(): LootItem[];
  engageCombat(enemyId: string): CombatResult;
  evacuate(evacPointId: string): boolean;
  returnToBase(): void;
  storeItems(items: LootItem[]): void;
  getCurrentState(): any;
  getPlayer(): Player;
  getBase(): Base;
  gameLoop(): void;
}

// 基地建设接口
export interface BaseConstructionInterface {
  buildFacility(facilityId: string): boolean;
  upgradeFacility(facilityId: string): boolean;
  useFacility(facilityId: string, action: string, params: any): any;
  getFacilityStatus(facilityId: string): FacilityStatus;
}

// 战斗模块接口
export interface CombatModuleInterface {
  attack(enemyId: string): AttackResult;
  defend(enemyId: string): DefenseResult;
  useItem(itemId: string): boolean;
  reloadWeapon(): boolean;
  changeWeapon(weaponId: string): boolean;
}

// 经济模块接口
export interface EconomyModuleInterface {
  sellItems(items: LootItem[]): number;
  buyItem(itemId: string, quantity: number): boolean;
  dismantleItem(itemId: string): Resource[];
  craftItem(blueprintId: string, materials: Resource[]): LootItem | null;
  getMarketPrices(): any;
}

// 成长系统接口
export interface GrowthLayerInterface {
  unlockPerk(perkId: string): boolean;
  trainStats(statType: string, amount: number): boolean;
  researchBlueprint(blueprintId: string): boolean;
  getPlayerProgress(): any;
  levelUp(): boolean;
}

// 轻量化设计接口
export interface LightweightDesignInterface {
  simplifyInventory(): void;
  adjustDifficulty(level: number): void;
  optimizeControls(): void;
  getAccessibilityOptions(): any;
  togglePVEOnly(value: boolean): void;
  setPlayerInventory(inventory: LootItem[]): void;
  setSafetySlotItems(items: LootItem[]): void;
  getSafetySlotItems(): LootItem[];
  controlTopDownView(camera: any): void;
  manageInventory(items: LootItem[]): InventoryStatus;
  ensurePVEOnly(): void;
  getDifficultyLevel(): number;
  isPVEOnly(): boolean;
}

// 风险系统接口
export interface RiskLayerInterface {
  calculateRisk(zoneId: string): number;
  applyTimePenalty(timeInZone: number): any;
  handleDeath(): DeathResult;
  handleSecondaryRisk(): SecondaryRiskResult;
  getRiskRewards(riskLevel: number): Bonus[];
  getTimeBonus(timeSpent: number): Bonus;
  getSafetySlotItems(): LootItem[];
  setPlayerInventory(inventory: LootItem[]): void;
  setSafetySlotItems(items: LootItem[]): void;
  updateTimeSpent(seconds: number): void;
}

// 战区探索接口
export interface WarzoneExplorationInterface {
  exploreZone(zoneId: string): any;
  findLoot(spawnPointId: string): LootItem[];
  unlockShortcut(shortcutId: string): boolean;
  checkEvacPointStatus(evacPointId: string): EvacPointStatus;
  handleWeatherEffects(): any;
}