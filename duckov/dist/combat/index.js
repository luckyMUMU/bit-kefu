"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CombatModule = void 0;
class CombatModule {
    constructor() {
        this.player = null;
        this.enemies = new Map();
        this.terrains = new Map();
        this.weapons = new Map();
        this.ammo = new Map();
        this.currentWeapon = null;
    }
    setPlayer(player) {
        this.player = player;
        if (player.equipment.weapon) {
            this.currentWeapon = player.equipment.weapon;
        }
    }
    addEnemy(enemy) {
        this.enemies.set(enemy.id, enemy);
    }
    addTerrain(terrain) {
        this.terrains.set(terrain.id, terrain);
    }
    addWeapon(weapon) {
        this.weapons.set(weapon.id, weapon);
    }
    addAmmo(ammo) {
        const existingAmmo = this.ammo.get(ammo.type);
        if (existingAmmo) {
            existingAmmo.quantity += ammo.quantity;
        }
        else {
            this.ammo.set(ammo.type, ammo);
        }
    }
    attack(enemyId) {
        if (!this.currentWeapon) {
            return { success: false, damage: 0, critical: false };
        }
        const enemy = this.enemies.get(enemyId);
        if (!enemy) {
            return { success: false, damage: 0, critical: false };
        }
        // 计算基础伤害
        let damage = this.currentWeapon.damage;
        // 应用武器配件效果
        this.currentWeapon.accessories.forEach(accessory => {
            damage += accessory.effects.damage || 0;
        });
        // 计算距离修正
        const distance = this.calculateDistance(this.player.position, enemy.position);
        const rangeFactor = Math.max(0, 1 - (distance - this.currentWeapon.range) * 0.1);
        damage *= rangeFactor;
        // 计算命中率
        const accuracy = this.currentWeapon.accuracy;
        const hitChance = accuracy * 0.01;
        const isHit = Math.random() < hitChance;
        if (!isHit) {
            return { success: false, damage: 0, critical: false };
        }
        // 计算暴击
        const criticalChance = 0.1; // 10% 基础暴击率
        const isCritical = Math.random() < criticalChance;
        if (isCritical) {
            damage *= 2;
        }
        // 消耗弹药
        if (this.currentWeapon.weaponType !== 'melee') {
            if (this.currentWeapon.currentAmmo <= 0) {
                return { success: false, damage: 0, critical: false };
            }
            this.currentWeapon.currentAmmo--;
        }
        // 更新敌人状态
        enemy.health -= damage;
        if (enemy.health <= 0) {
            enemy.status = 'fleeing';
            // 处理敌人死亡逻辑
        }
        return { success: true, damage, critical: isCritical };
    }
    defend(enemyId) {
        var _a, _b;
        const enemy = this.enemies.get(enemyId);
        if (!enemy) {
            return { success: false, damageReduced: 0 };
        }
        // 计算基础伤害减少
        let damageReduced = 0;
        if ((_a = this.player) === null || _a === void 0 ? void 0 : _a.equipment.armor) {
            // 假设 armor 有防御值属性
            damageReduced = this.player.equipment.armor.defense || 0;
        }
        // 检查是否在掩体后面
        const playerPosition = ((_b = this.player) === null || _b === void 0 ? void 0 : _b.position) || { x: 0, y: 0 };
        const coverBonus = this.calculateCoverBonus(playerPosition, enemy.position);
        damageReduced += coverBonus;
        return { success: true, damageReduced };
    }
    useItem(itemId) {
        // 实现物品使用逻辑
        return true;
    }
    reloadWeapon() {
        if (!this.currentWeapon || this.currentWeapon.weaponType === 'melee') {
            return false;
        }
        const ammo = this.ammo.get(this.currentWeapon.ammoType);
        if (!ammo || ammo.quantity <= 0) {
            return false;
        }
        const ammoNeeded = this.currentWeapon.magazineSize - this.currentWeapon.currentAmmo;
        const ammoToUse = Math.min(ammoNeeded, ammo.quantity);
        this.currentWeapon.currentAmmo += ammoToUse;
        ammo.quantity -= ammoToUse;
        return true;
    }
    changeWeapon(weaponId) {
        const weapon = this.weapons.get(weaponId);
        if (!weapon) {
            return false;
        }
        this.currentWeapon = weapon;
        return true;
    }
    // 辅助方法
    calculateDistance(pos1, pos2) {
        const dx = pos1.x - pos2.x;
        const dy = pos1.y - pos2.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
    calculateCoverBonus(playerPosition, enemyPosition) {
        let maxCoverValue = 0;
        this.terrains.forEach(terrain => {
            if (terrain.type === 'cover' && terrain.properties.coverValue > 0) {
                // 检查地形是否在玩家和敌人之间
                if (this.isTerrainBetween(terrain, playerPosition, enemyPosition)) {
                    maxCoverValue = Math.max(maxCoverValue, terrain.properties.coverValue);
                }
            }
        });
        return maxCoverValue;
    }
    isTerrainBetween(terrain, pos1, pos2) {
        // 简化的线段相交检测
        // 实际项目中可能需要更复杂的碰撞检测
        const terrainCenter = {
            x: terrain.position.x + terrain.size.width / 2,
            y: terrain.position.y + terrain.size.height / 2
        };
        const distance1 = this.calculateDistance(pos1, terrainCenter);
        const distance2 = this.calculateDistance(pos2, terrainCenter);
        const totalDistance = this.calculateDistance(pos1, pos2);
        return distance1 + distance2 <= totalDistance + 1; // 允许一定误差
    }
    // 敌人AI行为逻辑
    updateEnemyAI() {
        this.enemies.forEach(enemy => {
            if (!this.player)
                return;
            const distance = this.calculateDistance(enemy.position, this.player.position);
            switch (enemy.status) {
                case 'idle':
                    if (distance <= enemy.detectionRange) {
                        enemy.status = 'alert';
                    }
                    break;
                case 'alert':
                    if (distance <= enemy.attackRange) {
                        enemy.status = 'attacking';
                    }
                    else if (distance > enemy.detectionRange * 1.5) {
                        enemy.status = 'idle';
                    }
                    break;
                case 'attacking':
                    if (enemy.health < enemy.maxHealth * 0.3) {
                        enemy.status = 'fleeing';
                    }
                    else if (distance > enemy.attackRange * 1.5) {
                        enemy.status = 'alert';
                    }
                    break;
                case 'fleeing':
                    if (distance > enemy.detectionRange * 2) {
                        enemy.status = 'idle';
                    }
                    break;
            }
            // 根据状态执行移动
            this.updateEnemyMovement(enemy);
        });
    }
    updateEnemyMovement(enemy) {
        if (!this.player)
            return;
        switch (enemy.status) {
            case 'attacking':
                // 向玩家移动
                this.moveTowards(enemy, this.player.position);
                break;
            case 'fleeing':
                // 远离玩家
                this.moveAway(enemy, this.player.position);
                break;
            case 'alert':
                // 向玩家移动，但速度较慢
                this.moveTowards(enemy, this.player.position, enemy.speed * 0.7);
                break;
            case 'idle':
                // 巡逻行为
                this.patrol(enemy);
                break;
        }
    }
    moveTowards(enemy, target, speedMultiplier = 1) {
        const dx = target.x - enemy.position.x;
        const dy = target.y - enemy.position.y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        if (distance > 0) {
            const moveX = (dx / distance) * enemy.speed * speedMultiplier;
            const moveY = (dy / distance) * enemy.speed * speedMultiplier;
            enemy.position.x += moveX;
            enemy.position.y += moveY;
        }
    }
    moveAway(enemy, target) {
        const dx = enemy.position.x - target.x;
        const dy = enemy.position.y - target.y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        if (distance > 0) {
            const moveX = (dx / distance) * enemy.speed;
            const moveY = (dy / distance) * enemy.speed;
            enemy.position.x += moveX;
            enemy.position.y += moveY;
        }
    }
    patrol(enemy) {
        // 简单的巡逻逻辑，随机移动
        if (Math.random() < 0.01) { // 1% 概率改变方向
            const angle = Math.random() * Math.PI * 2;
            const moveX = Math.cos(angle) * enemy.speed;
            const moveY = Math.sin(angle) * enemy.speed;
            enemy.position.x += moveX;
            enemy.position.y += moveY;
        }
    }
    // 地形利用方法
    useTerrain(terrainId, action) {
        const terrain = this.terrains.get(terrainId);
        if (!terrain) {
            return { type: 'cover', value: 0, duration: 0 };
        }
        switch (action) {
            case 'takeCover':
                if (terrain.type === 'cover') {
                    return {
                        type: 'cover',
                        value: terrain.properties.coverValue,
                        duration: 5000 // 5秒
                    };
                }
                break;
            case 'destroy':
                if (terrain.properties.destructible && terrain.properties.health) {
                    terrain.properties.health -= 10;
                    if (terrain.properties.health <= 0) {
                        terrain.properties.passable = true;
                        terrain.properties.coverValue = 0;
                    }
                    return {
                        type: 'obstacle',
                        value: -1,
                        duration: 0
                    };
                }
                break;
        }
        return { type: 'cover', value: 0, duration: 0 };
    }
    // 弹药管理方法
    manageAmmo(weaponId, ammoType, amount) {
        const weapon = this.weapons.get(weaponId);
        if (!weapon || weapon.ammoType !== ammoType) {
            return false;
        }
        const ammo = this.ammo.get(ammoType);
        if (!ammo) {
            this.ammo.set(ammoType, {
                id: `ammo-${ammoType}`,
                name: `${ammoType} ammo`,
                type: ammoType,
                damageMultiplier: 1,
                quantity: amount,
                weight: 0.1
            });
        }
        else {
            ammo.quantity += amount;
        }
        return true;
    }
    // 俯视角战斗系统核心逻辑
    updateCombatState() {
        // 更新敌人AI
        this.updateEnemyAI();
        // 检查敌人攻击
        this.enemies.forEach(enemy => {
            if (enemy.status === 'attacking' && this.player) {
                const distance = this.calculateDistance(enemy.position, this.player.position);
                if (distance <= enemy.attackRange) {
                    this.enemyAttack(enemy);
                }
            }
        });
    }
    enemyAttack(enemy) {
        if (!this.player)
            return;
        // 计算敌人命中率
        const hitChance = enemy.accuracy * 0.01;
        if (Math.random() < hitChance) {
            // 计算玩家防御
            const defenseResult = this.defend(enemy.id);
            const finalDamage = Math.max(0, enemy.damage - defenseResult.damageReduced);
            // 应用伤害到玩家
            if (this.player.stats.health > 0) {
                this.player.stats.health -= finalDamage;
                if (this.player.stats.health <= 0) {
                    // 处理玩家死亡逻辑
                    console.log('Player died!');
                }
            }
        }
    }
}
exports.CombatModule = CombatModule;
