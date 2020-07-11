extends Control

var hearts : Array
onready var coin_label = find_node("CoinLabel")

func _ready():
    hearts = find_node("HeartContainer").get_children()
    set_hearts(1.5)
    set_coins(200)

func set_hearts(life : float):
    for heart in hearts:   
        if life >= 1.0:
            heart.full()
        elif life > 0:
            heart.half()
        else:
            heart.empty()
            
        life -= 1.0

func set_coins(coins : int):
    coin_label.text = str(coins)
