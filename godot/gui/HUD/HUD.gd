extends Control

var hearts : Array
onready var coin_label = find_node("CoinLabel")

func _ready():
    hearts = find_node("HeartContainer").get_children()
    set_health(StatisticsManager.health)
    set_coins(StatisticsManager.coins)
    
    StatisticsManager.connect("coins_changed", self, "set_coins")
    StatisticsManager.connect("health_changed", self, "set_health")
    
func set_health(health : float):
    for heart in hearts:   
        if health >= 1.0:
            heart.full()
        elif health > 0:
            heart.half()
        else:
            heart.empty()
            
        health -= 1.0

func set_coins(coins : int):
    coin_label.text = str(coins)
