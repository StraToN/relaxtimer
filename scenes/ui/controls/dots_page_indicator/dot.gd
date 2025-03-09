@tool
extends Control
class_name Dot

var radius: float = 3.0:
	set = _set_radius

var color: Color = Color.WHITE:
	set = _set_color

func _set_radius(rad: float):
	radius = rad
	queue_redraw()

func _set_color(col: Color):
	color = col
	queue_redraw()

func _draw():
	draw_circle(Vector2(0, 0), radius, color)
