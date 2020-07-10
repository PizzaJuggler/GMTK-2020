extends KinematicBody2D

export var velocity : Vector2

var look_direction
# the weapon that is used by the player
var current_weapon 

func ready():
    pass
    
func change_direction(to : Vector2):
    velocity = to * velocity.length()

func _process(delta):
    compute_player_look_direction()
    
func compute_player_look_direction():
    if current_weapon == null:
        return
    
    look_direction = current_weapon.compute_direction(velocity.normalized())
    look_at(look_direction)

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        velocity = velocity.bounce(collision_info.normal)

