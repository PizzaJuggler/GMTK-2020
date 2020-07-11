extends KinematicBody2D

class_name Enemy

onready var animated_sprite = $AnimatedSprite

export var max_hp := 10.0
export var strength := 1.0
export var speed := 20.0
export var regen := 1.0
export var angle : float

var init_velocity : Vector2
var velocity : Vector2
var hp : float
var is_healing : bool

func _ready():
    hp = max_hp
    init_velocity = Vector2(cos(angle), sin(angle)) * speed
    velocity = init_velocity
    animated_sprite.playing = true
    update_rotation()

func _process(delta):
    set_modulate(Color(1, 1, 1, lerp(0.2, 1.0, hp / max_hp)))
    if hp <= 0.0:
        velocity = Vector2.ZERO
        is_healing = true
    if is_healing:
        hp += regen * delta
        if hp >= max_hp:
            hp = max_hp
            is_healing = false
            velocity = init_velocity

func _physics_process(delta):
    if is_healing:
        collision_layer = 2
        collision_mask = 2
    else:
        collision_layer = 1
        collision_mask = 1
    var collision_info = move_and_collide(velocity * delta)
    handle_collision(collision_info)

func handle_collision(collision_info):
    if collision_info == null:
        return
    if collision_info.collider.is_in_group("projectile"):
        if !is_healing:
            hp -= collision_info.collider.damage
            collision_info.collider.queue_free()
        return
    if collision_info.collider is TileMap:
        velocity = velocity.bounce(collision_info.normal)
        init_velocity = velocity
        
    if collision_info.collider.is_in_group("enemy"):
        velocity = velocity.bounce(collision_info.normal)
        init_velocity = velocity
    update_rotation()

func update_rotation():
    if init_velocity.x > 0:
        animated_sprite.flip_h = false
    else:
        animated_sprite.flip_h = true
        
func damage(value):
    hp -= value
