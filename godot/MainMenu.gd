extends Control



func _on_Play_pressed():
    
    get_tree().change_scene("res://level/generated.tscn")


func _on_Quit_pressed():
    get_tree().quit()


func _on_LineEdit_text_changed(new_text):
    StatisticsManager.seed_random = new_text
