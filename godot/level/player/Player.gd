extends KinematicBody2D

export var velocity : Vector2

var look_direction
# the weapon that is used by the player
var current_weapon 
var weapons := []

func _ready():
    obtain_weapons()
    
func obtain_weapons():
    var children = get_children()
    for child in children:
        if child.is_in_group('weapon'):
            weapons.append(child)  
            
    if weapons != []:
        current_weapon = weapons[0]
    
func change_direction(to : Vector2):
    velocity = to * velocity.length()

func _process(delta):
    compute_player_look_direction()
    
func compute_player_look_direction():
    if current_weapon == null:
        return
    look_direction = (get_global_mouse_position() - position)
    look_direction = current_weapon.compute_constrained_direction(velocity.normalized(), look_direction)
    look_at(position + look_direction.rotated(PI / 2))

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        velocity = velocity.bounce(collision_info.normal)

