extends Area2D

signal door_opened

onready var open_sprite = $Open
onready var closed_sprite = $Closed

func _ready():
    close_door()
    
func open_door():
    open_sprite.visible = true
    closed_sprite.visible = false
    emit_signal("door_opened")
    $AudioStreamPlayer.play()

func close_door():
    open_sprite.visible = false
    closed_sprite.visible = true


func _on_Door_body_entered(body):
    if body.name == "Player":
        open_door()
