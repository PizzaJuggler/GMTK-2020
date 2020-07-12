extends Camera2D

var player
var old_direction : bool
var new_direction : bool
const shake_time := 0.3
var time := 0.0
var rng = RandomNumberGenerator.new()
var origin : Vector2

func _ready():
	rng.randomize()
	player = get_parent()
	old_direction = player.facing_direction()
	new_direction = old_direction
	player.connect("shake", self, "shake")

func _process(delta):
	new_direction = player.facing_direction()
	if old_direction != new_direction:
		old_direction = new_direction
		offset_h = -offset_h
	if time > 0.0:
		offset = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0))
		time -= delta
	elif !smoothing_enabled:
		offset = origin
		smoothing_enabled = true

func shake():
	smoothing_enabled = false
	origin = offset
	time = shake_time
