@tool
extends Control

signal exercice_finished

@export var quad_size: int = 477 :
	set = _set_quad_size


@onready var up = $gap/up
@onready var right = $gap/right
@onready var down = $gap/down
@onready var left = $gap/left
@onready var step_config = $gap/step_config
@onready var action_label = $gap/action
@onready var path2d = $gap/Path2D
@onready var pathfollow = path2d.get_node("PathFollow2D")
@onready var ball = pathfollow.get_node("ball")

const texture_width = 76



var desired_duration_sec = 40
var top_duration_sec = 4
var right_duration_sec = 4
var down_duration_sec = 4
var left_duration_sec = 4
var loops = 2

var pause_step1 = 0.15
var pause_step2 = 0.15
var pause_step3 = 0.15
var pause_step4 = 0.15
@onready var last_round : bool = false

var actions_labels = [
	"Inspirer...",
	"Suspendre...",
	"Expirer...",
	"Suspendre"
]
var current_step = 0

var _is_ready = false

var tween: Tween

var _sound_enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_is_ready = true
	set_process(false)


func _set_quad_size(new_size: int):
	up.size.x = texture_width
	down.size.x = texture_width
	left.size.x = texture_width
	right.size.x = texture_width
	quad_size = new_size
	if (!_is_ready):
		return
	up.size.y = quad_size
	down.size.y = quad_size
	down.position.y = quad_size
	left.size.y = quad_size
	right.size.y = quad_size
	right.position.x = quad_size - right.texture.get_width()
	
	# Path
	path2d.curve.set_point_position(1, Vector2(quad_size - 38 , 34))
	path2d.curve.set_point_position(2, Vector2(quad_size - 38 , quad_size - 38))
	path2d.curve.set_point_position(3, Vector2(38 , quad_size - 38))

func step(node: Node):
	ball.z_index = 10
	up.modulate = Color.GRAY
	up.z_index = 0
	right.modulate = Color.GRAY
	right.z_index = 0
	down.modulate = Color.GRAY
	down.z_index = 0
	left.modulate = Color.GRAY
	left.z_index = 0
	if node != null:
		action_label.text = actions_labels[current_step]
		node.modulate = Color.WHITE
		node.z_index = 1
		current_step = wrap(current_step + 1, 0, 4)
		ding()
	else:
		current_step = 0
		path2d.get_node("PathFollow2D").progress_ratio = 0.0

func set_sound(enabled: bool):
	_sound_enabled = enabled
	if not _sound_enabled:
		$audio/ding_high.stop()
		$audio/ding_low.stop()


func ding():
	if not _sound_enabled:
		return
	if current_step % 2:
		$audio/ding_high.play()
	else:
		$audio/ding_low.play()

func _start():
	step_config.hide()
	action_label.show()
	
	pathfollow.progress_ratio = 0.0
	tween = pathfollow.create_tween() \
		.set_loops(_get_loops_for_duration(desired_duration_sec)) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(self._on_tween_finished)
	tween.tween_callback(self.step.bind(up))
	tween.tween_property(pathfollow, "progress_ratio", 0.25, top_duration_sec).from(0.0)
	tween.tween_interval(pause_step1)
	tween.tween_callback(self.step.bind(right))
	tween.tween_property(pathfollow, "progress_ratio", 0.5, right_duration_sec)
	tween.tween_interval(pause_step2)
	tween.tween_callback(self.step.bind(down))
	tween.tween_property(pathfollow, "progress_ratio", 0.75, down_duration_sec)
	tween.tween_interval(pause_step3)
	tween.tween_callback(self.step.bind(left))
	tween.tween_property(pathfollow, "progress_ratio", 1.0, left_duration_sec)
	tween.tween_interval(pause_step4)
	tween.play()
	
func _on_tween_finished():
	step(null)
	tween.stop()
	action_label.hide()
	step_config.show()
	exercice_finished.emit()


func _get_loops_for_duration(duration_sec: int):
	var one_loop_duration = top_duration_sec + left_duration_sec + down_duration_sec + right_duration_sec
	var breaks_duration = pause_step1 + pause_step2 + pause_step3 + pause_step4
	one_loop_duration += breaks_duration
	loops = duration_sec / one_loop_duration
	if loops == 0:
		loops = 1
	return ceili(loops)

func start(total_duration_sec: int):
	desired_duration_sec = total_duration_sec
	_start()

func stop():
	_on_tween_finished()

func _on_top_spinner_value_changed(value):
	top_duration_sec = value

func _on_down_spinner_value_changed(value):
	down_duration_sec = value

func _on_right_spinner_value_changed(value):
	right_duration_sec = value

func _on_left_spinner_value_changed(value):
	left_duration_sec = value
