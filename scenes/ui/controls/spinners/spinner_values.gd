extends GridContainer

signal value_changed(value)

@export var default = "4:00"
@export var values = {
	"30s": 30,
	"60s": 60,
	"1:30" : 90,
	"2:00" : 120,
	"2:30" : 150,
	"3:00" : 180,
	"3:30" : 210,
	"4:00" : 240,
	"5:00" : 300,
	"4:30" : 270,
	"5:30" : 330,
	"6:00" : 360,
	"6:30" : 390,
}

@onready var value_index = 0

func _ready():
	value_index = values.keys().find(default) if not default.is_empty() else 0
	_update_text()

func _update_text():
	$Label.text = values.keys()[value_index]

func _on_down_button_pressed():
	if value_index - 1 >= 0:
		value_index -= 1
		_update_text()
		var key = values.keys()[value_index]
		value_changed.emit(values[key])

func _on_up_button_pressed():
	if value_index + 1 < values.size():
		value_index += 1
		_update_text()
		var key = values.keys()[value_index]
		value_changed.emit(values[key])

func get_value_secs() -> int:
	return values[values.keys()[value_index]]
