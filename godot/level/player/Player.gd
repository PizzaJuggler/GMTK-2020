extends KinematicBody2D

export var speed := 100.0
var velocity : Vector2
var init_velocity : Vector2

var parent
func _ready():
	parent = get_parent()
	init_velocity = Vector2(cos(rotation), sin(rotation)) * speed
	velocity = Vector2.ZERO

var was_left
func _process(_delta):
	rotation = init_velocity.angle()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		init_velocity = velocity
	
func _unhandled_input(event):
	if event.is_action_pressed("move"):
		velocity = init_velocity
	elif event.is_action_released("move"):
		velocity = Vector2.ZERO
		
