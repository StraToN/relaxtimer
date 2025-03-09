extends Control

const updateDownloadUrl = "https://cloud.murgia.fr/s/by9Z7D5Y2Hyszdk"

func _ready():
	var language = "automatic"
	# Load here language from the user settings file
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)
	$version_number.text = "v%s" % ProjectSettings.get_setting("application/config/version")

func _on_exercises_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/exercices.tscn")

func _on_statistics_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()


func _on_download_update_pressed():
	OS.shell_open(updateDownloadUrl)


func _on_info_button_pressed():
	get_tree().change_scene_to_file("res://scenes/information/information.tscn")
