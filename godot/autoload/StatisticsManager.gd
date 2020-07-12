extends Node

signal coins_changed(coin)
signal health_changed(health)
signal player_died()

onready var hud = find_node("HUD")

var max_health = 5.0

var health = 5.0 
var coins = 0

func _ready():
    add_to_group("reset")

func add_collectible(key, value):
    match key:
        "coin":
            coins += value
            emit_signal("coins_changed", coins)
        "health_potion":
            change_health(value)

func apply_damage(damage : float):
    change_health(- damage)

func change_health(value):
    health = clamp(health + value, 0, max_health)
    emit_signal("health_changed", health)
    if health == 0:
        emit_signal("player_died")

func reset():
    health = max_health
    coins = 0
    emit_signal("health_changed", health)
    emit_signal("coins_changed", coins)
