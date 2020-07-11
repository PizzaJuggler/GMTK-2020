extends Control

onready var animation_player = $AnimationPlayer

var reset_items

func _ready():
    reset_items = get_tree().get_nodes_in_group("reset")
    StatisticsManager.connect("player_died", self, "_on_StatisticsManager_player_died")

func _on_StatisticsManager_player_died():
    get_tree().paused = true
    show()

func show():
    animation_player.play("show")

func hide():
    animation_player.play("hide")


func _on_RestartButton_pressed():
    for item in reset_items:
        item.reset()
        
    hide()


func _on_QuitButton_pressed():
    get_tree().quit()

func resume():
    get_tree().paused = false
