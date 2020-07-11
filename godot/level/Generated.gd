extends Node2D

onready var tilemap = $TileMap

func _ready():
	tilemap.set_cell(0, 0, 1)
