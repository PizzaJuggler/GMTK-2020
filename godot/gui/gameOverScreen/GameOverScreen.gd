extends Control

onready var animation_player = $AnimationPlayer

func show():
    animation_player.play("show")

func hide():
    animation_player.play("hide")
