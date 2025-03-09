@tool
extends Control

const MIN = 1
const MAX = 6

var dot_scene: PackedScene = preload("res://scenes/ui/controls/dots_page_indicator/dot.tscn")

@export_range(MIN, MAX) var number: int = 3:
	set = _set_number

@export var spacing: float = 10.0:
	set = _set_spacing

@export var radius: float = 3.0:
	set = _set_radius
@export var dot_color_active: Color = Color.WHITE
@export var dot_color_inactive: Color = Color.GRAY
@export var current_active: int = 0:
	set = set_current_active

@onready var instances: Array = [
	dot_scene.instantiate(),
	dot_scene.instantiate(),
	dot_scene.instantiate(),
	dot_scene.instantiate(),
	dot_scene.instantiate(),
	dot_scene.instantiate(),
]

func _ready():
	for n in instances:
		add_child(n)
	_update_spacing_and_current()

func _set_number(num: int):
	number = num
	if current_active >= number:
		current_active = number - 1
	_update_spacing_and_current()

func _set_spacing(space: float):
	spacing = space
	_update_spacing_and_current()

func _set_radius(rad: float):
	radius = rad
	_update_spacing_and_current()
	
func set_current_active(value: int):
	current_active = wrapi(value, 0, number)
	_update_spacing_and_current()
		
func _update_spacing_and_current():
	for i in instances.size():
		var n: Node = instances[i]
		n.radius = radius
		n.color = dot_color_active if i == current_active else dot_color_inactive
		n.position.x = i * spacing
		if i >= number:
			n.hide()
		else:
			n.show()

func get_center_offset() -> Vector2:
	return instances[number-1].position / 2
