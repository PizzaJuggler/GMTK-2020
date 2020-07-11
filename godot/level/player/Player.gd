extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite

export var speed := 100.0
var velocity : Vector2
var init_velocity : Vector2

func _ready():
    init_velocity = Vector2(cos(rotation), sin(rotation)) * speed
    velocity = Vector2.ZERO
    animated_sprite.play()

var was_left
func _process(_delta):
    pass
    
func update_rotation():
    if init_velocity.x > 0:
        animated_sprite.flip_h = false
    else:
        animated_sprite.flip_h = true

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    handle_collision(collision_info)

func handle_collision(collision_info): 
    if collision_info == null:
        return
    if not collision_info.collider is TileMap:
        return
        
    velocity = velocity.bounce(collision_info.normal)
    init_velocity = velocity
    update_rotation()
        
func _unhandled_input(event):
    if event.is_action_pressed("move"):
        velocity = init_velocity
    elif event.is_action_released("move"):
        velocity = Vector2.ZERO
        
