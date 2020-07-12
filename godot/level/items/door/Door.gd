extends Area2D

signal door_opened

onready var open_sprite = $Open
onready var closed_sprite = $Closed
onready var static_body = $Closed/StaticBody2D

func _ready():
    close_door()
    
func open_door():
    open_sprite.visible = true
    closed_sprite.visible = false
    if static_body:
        static_body.queue_free()
        static_body = null
        emit_signal("door_opened")
        $AudioStreamPlayer.play()

func close_door():
    open_sprite.visible = false
    closed_sprite.visible = true


func _on_Door_body_entered(body):
    if body.name == "Player":
        open_door()
