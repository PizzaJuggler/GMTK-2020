extends Area2D

export var key : String
export var value : float

var is_taken = false


func _on_Collectible_body_entered(body):
    if body is Player and not is_taken:
        is_taken = true
        StatisticsManager.add_collectible(key, value)
        visible = false
        $AudioStreamPlayer.play()
        


func _on_AudioStreamPlayer_finished():
    queue_free()
