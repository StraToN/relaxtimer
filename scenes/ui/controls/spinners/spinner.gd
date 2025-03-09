extends GridContainer

signal value_changed(value)

@export var value: int = 4:
	set = _set_value
@export var min_value = 2
@export var max_value = 12
const text = "{0} s"

func _ready():
	_update_text()

func _update_text():
	$Label.text = text.format([value])

func _set_value(new_val: int):
	value = new_val
	_update_text()
	value_changed.emit(value)


func _on_down_button_pressed():
	if value - 1 >= min_value:
		value -= 1


func _on_up_button_pressed():
	if value + 1 <= max_value:
		value += 1
		_update_text()
