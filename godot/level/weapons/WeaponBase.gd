extends Node2D

export var rotation_limit : float
export var bullet_speed : float
export var bullet_type : PackedScene
export var firing_rate : float

var parent
var cooldown := .0
var max_rot

func _ready():
	parent = get_parent()
	max_rot = rotation_limit / 2

func _process(delta):
	cooldown -= delta
	look_at(get_global_mouse_position())
	rotation_degrees = clamp(rotation_degrees, -max_rot, max_rot)

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		if cooldown <= 0:
			cooldown = firing_rate
			var bullet = bullet_type.instance()
			bullet.direction = Vector2(cos(rotation), sin(rotation))
			if parent.rotation_degrees < -90 || parent.rotation_degrees > 90:
				bullet.direction *= -1
			bullet.position = global_position + bullet.direction * 18
			get_tree().get_root().add_child(bullet)
