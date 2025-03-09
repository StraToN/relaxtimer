extends Control

var current_screen: Node

var new_statistics = preload("res://scenes/statistics/new_statistics.tscn")

func _on_start_button_pressed():
	current_screen = $screens.current_screen
	var total_duration_sec = $total_duration_layer/VBoxContainer/total_duration.get_value_secs()
	$screens/stop_button.show()
	$total_duration_layer.hide()
	current_screen.start(total_duration_sec)
	$screens.set_process_input(false)
	

func _on_screen_change(screen: Node):
	current_screen = screen


func _on_exercice_finished():
	$screens/stop_button.hide()
	$total_duration_layer.show()
	$screens.set_state(current_screen)
	$screens.set_process_input(true)

	
func _on_stop_button_pressed():
	current_screen.stop()


func _on_music_toggle_sound_toggled(state):
	current_screen.set_sound(state)
