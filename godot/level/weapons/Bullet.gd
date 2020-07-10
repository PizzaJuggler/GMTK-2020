extends KinematicBody2D

var direction setget set_direction
var velocity
var speed = 500

func set_direction(value):
    direction = value
    velocity = speed * direction

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        velocity = velocity.bounce(collision_info.normal)

func _on_LifeTime_timeout():
    queue_free()
