extends TextureButton

func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
