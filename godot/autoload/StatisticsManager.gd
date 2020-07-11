extends Node

signal added_coin(coin)
signal added_health(health)

onready var hud = find_node("HUD")

var max_health = 5.0

var health = 2.0 
var coins = 0

func _ready():
    pass

func add_collectible(key, value):
    match key:
        "coin":
            coins += value
            emit_signal("added_coin", coins)
        "health_potion":
            change_health(value)

func apply_damage(damage : float):
    change_health(- damage)

func change_health(value):
    health = clamp(health + value, 0, max_health)
    emit_signal("added_health", health)
