extends KinematicBody2D

export var speed : Vector2

var parent
func _ready():
	parent = get_parent()
	
func change_direction(to : Vector2):
	speed = to * speed.length()

var was_left
func _process(_delta):
	var is_left = rotation_degrees < -90 || rotation_degrees > 90
	if (is_left && !was_left) || (!is_left && was_left):
		scale.x = -1
	was_left = is_left

func _physics_process(delta):
	var collision_info = move_and_collide(speed * delta)
	if collision_info:
		speed = speed.bounce(collision_info.normal)

func _unhandled_input(event):
	if event.is_action_pressed("move"):
		return
