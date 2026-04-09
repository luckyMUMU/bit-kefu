class_name WeatherManager
extends Node

enum WeatherType {
    CLEAR,
    RAIN,
    FOG,
    SNOW
}

enum TimeOfDay {
    DAY,
    NIGHT
}

@export var weather_change_interval: float = 300.0  # 5分钟
@export var time_of_day_duration: float = 600.0  # 10分钟
@export var weather_probabilities: Dictionary = {
    WeatherType.CLEAR: 0.5,
    WeatherType.RAIN: 0.3,
    WeatherType.FOG: 0.15,
    WeatherType.SNOW: 0.05
}

var current_weather: WeatherType = WeatherType.CLEAR
var current_time_of_day: TimeOfDay = TimeOfDay.DAY
var time_since_weather_change: float = 0.0
var time_since_time_change: float = 0.0

# 天气影响参数
var weather_effects: Dictionary = {
    WeatherType.CLEAR: {
        vision_modifier: 1.0,
        movement_modifier: 1.0,
        enemy_aggro_range_modifier: 1.0,
        enemy_accuracy_modifier: 1.0
    },
    WeatherType.RAIN: {
        vision_modifier: 0.8,
        movement_modifier: 0.9,
        enemy_aggro_range_modifier: 0.8,
        enemy_accuracy_modifier: 0.8
    },
    WeatherType.FOG: {
        vision_modifier: 0.6,
        movement_modifier: 1.0,
        enemy_aggro_range_modifier: 0.6,
        enemy_accuracy_modifier: 0.7
    },
    WeatherType.SNOW: {
        vision_modifier: 0.7,
        movement_modifier: 0.85,
        enemy_aggro_range_modifier: 0.75,
        enemy_accuracy_modifier: 0.85
    }
}

# 时间影响参数
var time_effects: Dictionary = {
    TimeOfDay.DAY: {
        vision_modifier: 1.0,
        enemy_aggro_range_modifier: 1.0,
        enemy_accuracy_modifier: 1.0
    },
    TimeOfDay.NIGHT: {
        vision_modifier: 0.5,
        enemy_aggro_range_modifier: 0.7,
        enemy_accuracy_modifier: 0.7
    }
}

signal weather_changed(new_weather: WeatherType)
signal time_of_day_changed(new_time: TimeOfDay)
signal weather_effects_updated(effects: Dictionary)

func _ready() -> void:
    randomize()
    # 初始化随机天气
    _change_weather()

func _process(delta: float) -> void:
    time_since_weather_change += delta
    time_since_time_change += delta
    
    if time_since_weather_change >= weather_change_interval:
        _change_weather()
        time_since_weather_change = 0.0
    
    if time_since_time_change >= time_of_day_duration:
        _toggle_time_of_day()
        time_since_time_change = 0.0

func _change_weather() -> void:
    var rand := randf()
    var cumulative_probability: float = 0.0
    
    for weather_type in weather_probabilities.keys():
        cumulative_probability += weather_probabilities[weather_type]
        if rand <= cumulative_probability:
            current_weather = weather_type
            weather_changed.emit(current_weather)
            GameEvents.emit_weather_changed(current_weather)
            _update_effects()
            break

func _toggle_time_of_day() -> void:
    current_time_of_day = TimeOfDay.NIGHT if current_time_of_day == TimeOfDay.DAY else TimeOfDay.DAY
    time_of_day_changed.emit(current_time_of_day)
    GameEvents.emit_time_of_day_changed(current_time_of_day)
    _update_effects()

func _update_effects() -> void:
    var weather_effect = weather_effects[current_weather]
    var time_effect = time_effects[current_time_of_day]
    
    var combined_effects = {
        vision_modifier: weather_effect.vision_modifier * time_effect.vision_modifier,
        movement_modifier: weather_effect.movement_modifier,
        enemy_aggro_range_modifier: weather_effect.enemy_aggro_range_modifier * time_effect.enemy_aggro_range_modifier,
        enemy_accuracy_modifier: weather_effect.enemy_accuracy_modifier * time_effect.enemy_accuracy_modifier
    }
    
    weather_effects_updated.emit(combined_effects)
    GameEvents.emit_weather_effects_updated(combined_effects)

func get_current_weather() -> WeatherType:
    return current_weather

func get_current_time_of_day() -> TimeOfDay:
    return current_time_of_day

func get_weather_effects() -> Dictionary:
    var weather_effect = weather_effects[current_weather]
    var time_effect = time_effects[current_time_of_day]
    
    return {
        vision_modifier: weather_effect.vision_modifier * time_effect.vision_modifier,
        movement_modifier: weather_effect.movement_modifier,
        enemy_aggro_range_modifier: weather_effect.enemy_aggro_range_modifier * time_effect.enemy_aggro_range_modifier,
        enemy_accuracy_modifier: weather_effect.enemy_accuracy_modifier * time_effect.enemy_accuracy_modifier
    }

func get_weather_name() -> String:
    match current_weather:
        WeatherType.CLEAR:
            return "晴天"
        WeatherType.RAIN:
            return "雨天"
        WeatherType.FOG:
            return "雾天"
        WeatherType.SNOW:
            return "雪天"
    return "未知"

func get_time_of_day_name() -> String:
    match current_time_of_day:
        TimeOfDay.DAY:
            return "白天"
        TimeOfDay.NIGHT:
            return "夜晚"
    return "未知"
