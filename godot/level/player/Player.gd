extends KinematicBody2D

class_name Player

onready var animated_sprite = $AnimatedSprite
onready var knockback_timer = $KnockBackTimer
onready var animation_player = $AnimationPlayer

export var speed := 100.0
var velocity : Vector2
var init_velocity : Vector2

enum States {KNOCKBACK, WALKING}
var state

func _ready():
    init_velocity = Vector2(cos(rotation), sin(rotation)) * speed
    velocity = Vector2.ZERO
    animated_sprite.play()
    state = States.WALKING

func _process(delta):
    if state == States.KNOCKBACK:
        velocity -= velocity * delta * 10.0
            
    
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
    if collision_info.collider is TileMap:
        velocity = velocity.bounce(collision_info.normal)
        init_velocity = velocity
    elif collision_info.collider is Enemy:
        collide_with_enemy(collision_info.collider)
    
    update_rotation()
        
    
    
func collide_with_enemy(enemy):
    state = States.KNOCKBACK
    StatisticsManager.apply_damage(enemy.strength)
    # push the player backwards
    var direction = (enemy.position - position).normalized()
    # change player direction
    velocity = - direction * init_velocity.length() * 2.5
    
    knockback_timer.start()
    animation_player.play("hit")
    
    
        
func _unhandled_input(event):
    if state == States.KNOCKBACK:
        return
    
    if event.is_action_pressed("move"):
        velocity = init_velocity
    elif event.is_action_released("move"):
        velocity = Vector2.ZERO


func _on_KnockBackTimer_timeout():
    velocity = Vector2.ZERO
    state = States.WALKING
    init_velocity = init_velocity.rotated(PI / 2)
