extends Node2D

export var rotation_limit : float
export var bullet_speed : float
export var bullet_type : PackedScene
export var firing_rate : float
export var damage : float

onready var bow_pivot = $Pivot
onready var angle_range = $AngleRange

var parent
var cooldown := .0
var max_rot

func _ready():
    parent = get_parent()
    max_rot = rotation_limit / 2
    angle_range.value = max_rot

func _process(delta):
    cooldown -= delta
    bow_pivot.look_at(get_global_mouse_position())
    bow_pivot.rotation_degrees = clamp(bow_pivot.rotation_degrees, -max_rot, max_rot)
    rotate_self()

func rotate_self():
    rotation = parent.init_velocity.angle()

func _unhandled_input(event):
    if event.is_action_pressed("shoot"):
        if cooldown <= 0:
            cooldown = firing_rate
            var bullet = bullet_type.instance()
            bullet.direction = Vector2(
                    cos(bow_pivot.rotation + rotation), 
                    sin(bow_pivot.rotation + rotation))
            bullet.position = global_position + bullet.direction * 18
            bullet.damage = damage
            get_tree().get_root().add_child(bullet)
