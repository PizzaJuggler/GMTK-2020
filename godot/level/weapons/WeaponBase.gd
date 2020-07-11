extends Node2D

export var min_rotation : float
export var max_rotation : float
export var bullet_speed : float
export var bullet_type : PackedScene

var min_direction : Vector2
var max_direction : Vector2

func _ready():
	min_direction = Vector2(-1, 0).rotated(min_rotation)
	max_direction = Vector2(-1, 0).rotated(max_rotation) 

func compute_constrained_direction(move_direction : Vector2, look_direction : Vector2) -> Vector2:
	var transform_angle = move_direction.angle_to(Vector2(0, -1))
	var transformed_look = look_direction.rotated(transform_angle)

	if _is_between_allowed_directions(transformed_look):
		return look_direction
	else:
		return _get_closest_direction(transformed_look).rotated(transform_angle)
		
func _is_between_allowed_directions(move_direction : Vector2) -> bool:
	var cross_min_max = min_direction.cross(max_direction)
	if cross_min_max >= 0:
		# is in 0...180 range
		return min_direction.cross(move_direction) >= 0 and move_direction.cross(max_direction) >= 0
	else:
		# is in 180...360 range
		return not (max_direction.cross(move_direction) >= 0 and move_direction.cross(min_direction) >= 0)
	
func _get_closest_direction(move_direction : Vector2) -> Vector2:
	var angle_max = abs(move_direction.angle_to(max_direction))
	var angle_min = abs(move_direction.angle_to(min_direction))
	if angle_max > angle_min:
		return min_direction
	else:
		return max_direction

func fire(look_direction : Vector2):
	var bullet = bullet_type.instance()
	bullet.direction = look_direction
	return bullet
