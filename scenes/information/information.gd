extends Control


func _on_donate_pressed():
	OS.shell_open("https://liberapay.com/StraToN54/donate")


func _on_label_1_meta_clicked(meta):
	OS.shell_open(str(meta))
