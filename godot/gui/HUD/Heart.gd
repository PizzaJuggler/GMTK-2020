extends Control

onready var texture_rect = $TextureRect

var texture_full = preload("res://gui/HUD/heart_full.tres")
var texture_half = preload("res://gui/HUD/heart_half.tres")
var texture_empty = preload("res://gui/HUD/heart_empty.tres")

var type : int

func _ready():
    type = 3
    
func full():
    texture_rect.texture = texture_full
    
func half():
    texture_rect.texture = texture_half
    
func empty():
    texture_rect.texture = texture_empty
