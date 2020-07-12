extends KinematicBody2D

class_name Player

onready var animated_sprite = $AnimatedSprite
onready var knockback_timer = $KnockBackTimer
onready var animation_player = $AnimationPlayer
onready var footstep_audioplayer = $FootStep

signal shake

export var speed := 100.0
var velocity : Vector2
var init_velocity : Vector2

enum States {KNOCKBACK, WALKING}
var state


var footsteps = [
	preload("res://sound/footsteps/footstep00.wav"),
	preload("res://sound/footsteps/footstep01.wav"),
	preload("res://sound/footsteps/footstep02.wav"),
	preload("res://sound/footsteps/footstep03.wav"),
	preload("res://sound/footsteps/footstep04.wav"),
	preload("res://sound/footsteps/footstep05.wav"),
	preload("res://sound/footsteps/footstep06.wav"),
	preload("res://sound/footsteps/footstep07.wav"),
	preload("res://sound/footsteps/footstep08.wav"),
	preload("res://sound/footsteps/footstep09.wav"),
]

func facing_direction():
	return init_velocity.x <= 0

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


	if collision_info.collider is Enemy:
		collide_with_enemy(collision_info.collider)
	else:
		velocity = velocity.bounce(collision_info.normal)
		init_velocity *= -1

	update_rotation()



func collide_with_enemy(enemy):
	if !knockback_timer.time_left > 0.0:
		emit_signal("shake")
		state = States.KNOCKBACK
		StatisticsManager.apply_damage(enemy.strength)
		# push the player backwards
		var direction = (enemy.position - position).normalized()
		# change player direction
		velocity = - direction * init_velocity.length() * enemy.velocity.length() / 10.0

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
    rotate_player()

func rotate_player():
    init_velocity = init_velocity.rotated(PI / 2)

func play_random_footstep():
	if state != States.WALKING:
		return

	if velocity == Vector2.ZERO:
		return

	footstep_audioplayer.stream = footsteps[randi() % footsteps.size()]
	footstep_audioplayer.play()


func _on_FootStepTimer_timeout():
	play_random_footstep()
