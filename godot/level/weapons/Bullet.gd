extends KinematicBody2D

var direction setget set_direction
var velocity
var speed = 200

func set_direction(value):
    direction = value
    velocity = speed * direction

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        if collision_info.collider.is_in_group("projectile"):
            queue_free()
        elif collision_info.collider.name == "Player":
            queue_free()
        velocity = velocity.bounce(collision_info.normal)

func _on_LifeTime_timeout():
    queue_free()
