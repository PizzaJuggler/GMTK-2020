extends KinematicBody2D

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D

var direction setget set_direction
var damage setget set_damage
var velocity
var speed = 200

func set_direction(value):
    direction = value
    velocity = speed * direction
    update_sprite_rotation()

func set_damage(value):
    damage = value

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    
    if collision_info:
        if collision_info.collider.is_in_group("projectile"):
            visible = false
        elif collision_info.collider.name == "Player":
            visible = false
        elif collision_info.collider.is_in_group("enemy"):
            collision_info.collider.damage(damage)
            visible = false
        velocity = velocity.bounce(collision_info.normal)
        $AudioStreamPlayer2D.play(.2)
    update_sprite_rotation()

func _on_LifeTime_timeout():
    queue_free()

func update_sprite_rotation():
    if sprite == null:
        return
        
    if collision_shape == null:
        return
    sprite.rotation = velocity.angle()
    collision_shape.rotation = velocity.angle()



func _on_AudioStreamPlayer2D_finished():
    if !visible:
        queue_free()
