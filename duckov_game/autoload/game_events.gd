extends Node

signal on_player_died
signal on_player_extracted
signal on_player_damaged(amount: float, source: Node)
signal on_player_healed(amount: float)
signal on_item_picked_up(item: InventoryItem)
signal on_item_dropped(item: InventoryItem)
signal on_inventory_changed
signal on_enemy_died(enemy: Node)
signal on_enemy_spawned(enemy: Node)
signal on_zone_entered(zone_id: String)
signal on_zone_exited(zone_id: String)
signal on_extraction_available(extraction_point: Node)
signal on_extraction_started
signal on_time_bonus_updated(multiplier: float)
signal on_boss_wave_incoming
signal on_perk_unlocked(perk_id: String)
signal on_recipe_unlocked(recipe_id: String)
signal on_facility_built(facility_id: String)
signal on_money_changed(new_amount: int, old_amount: int)

func emit_player_died() -> void:
	on_player_died.emit()

func emit_player_extracted() -> void:
	on_player_extracted.emit()

func emit_player_damaged(amount: float, source: Node) -> void:
	on_player_damaged.emit(amount, source)

func emit_player_healed(amount: float) -> void:
	on_player_healed.emit(amount)

func emit_item_picked_up(item: InventoryItem) -> void:
	on_item_picked_up.emit(item)
	on_inventory_changed.emit()

func emit_item_dropped(item: InventoryItem) -> void:
	on_item_dropped.emit(item)
	on_inventory_changed.emit()

func emit_inventory_changed() -> void:
	on_inventory_changed.emit()

func emit_enemy_died(enemy: Node) -> void:
	on_enemy_died.emit(enemy)

func emit_enemy_spawned(enemy: Node) -> void:
	on_enemy_spawned.emit(enemy)

func emit_zone_entered(zone_id: String) -> void:
	on_zone_entered.emit(zone_id)

func emit_zone_exited(zone_id: String) -> void:
	on_zone_exited.emit(zone_id)

func emit_extraction_available(extraction_point: Node) -> void:
	on_extraction_available.emit(extraction_point)

func emit_extraction_started() -> void:
	on_extraction_started.emit()

func emit_time_bonus_updated(multiplier: float) -> void:
	on_time_bonus_updated.emit(multiplier)

func emit_boss_wave_incoming() -> void:
	on_boss_wave_incoming.emit()

func emit_perk_unlocked(perk_id: String) -> void:
	on_perk_unlocked.emit(perk_id)

func emit_recipe_unlocked(recipe_id: String) -> void:
	on_recipe_unlocked.emit(recipe_id)

func emit_facility_built(facility_id: String) -> void:
	on_facility_built.emit(facility_id)

func emit_money_changed(new_amount: int, old_amount: int) -> void:
	on_money_changed.emit(new_amount, old_amount)
