extends Control

signal screen_changed(screen: Node)
signal screen_number_changed(value: int)

@onready var vertical_screen = $screens/Vertical
@onready var vertical_double_screen = $screens/VerticalDouble
@onready var square_screen = $screens/Square
@onready var screens: Array = [
	vertical_screen,
	vertical_double_screen,
	square_screen
]
var current_screen: Node
@onready var current_screen_index = 0

var swipe_start = null
var minimum_drag = 100

func _ready():
	$dots_page_indicator.number = $screens.get_child_count()
	$dots_page_indicator.position.x = get_viewport_rect().size.x/2 - $dots_page_indicator.get_center_offset().x
	screen_number_changed.connect($dots_page_indicator.set_current_active)
	set_state(screens[current_screen_index])

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.get_position()
		else:
			_calculate_swipe(event.get_position())

func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			_go_screen_direction(-1)
		else:
			_go_screen_direction(1)


func _go_screen_direction(direction: int):
	current_screen_index = wrapi(current_screen_index + direction, 0, screens.size())
	screen_number_changed.emit(current_screen_index)
	set_state(screens[current_screen_index])
	
func set_state(screen: Node):
	current_screen = screen
	screen_changed.emit(current_screen)
	
	match screen:
		vertical_screen:
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property($screens, "position:x", 0, 1.0)
			tween.play()
		vertical_double_screen:
			screen_number_changed.emit(1)
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property($screens, "position:x", -720, 1.0)
			tween.play()
		square_screen:
			screen_number_changed.emit(2)
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property($screens, "position:x", -1440, 1.0)
			tween.play()
