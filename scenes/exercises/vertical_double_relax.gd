@tool
extends Control

signal exercice_finished

@export var quad_size: int = 477 :
	set = _set_quad_size

@onready var left = $gap/left
@onready var step_config = $gap/step_config
@onready var action_label = $gap/action
@onready var path2d = $gap/Path2D
@onready var pathfollow = path2d.get_node("PathFollow2D")
@onready var ball = pathfollow.get_node("ball")
const texture_width = 76

var desired_duration_sec = 40

var step1_duration_sec = 4: # default value
	set = _set_step1_duration_sec
var step2_duration_sec = 8 # default value

var pause_step1 = 0.15 # default value
var pause_step2 = 0.15 # default value
@onready var last_round : bool = false

var actions_labels = [
	"Inspirer...",
	"Expirer..."
]
var current_step = 0

var _is_ready = false

var tween: Tween

var _sound_enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_is_ready = true
	set_process(false)
	_set_step1_duration_sec(step1_duration_sec)


func _set_quad_size(new_size: int):
	quad_size = new_size
	if (!_is_ready):
		return
	left.size.y = quad_size
	
	# Path
	path2d.curve.set_point_position(1, Vector2(38 , 38))
	path2d.curve.set_point_position(0, Vector2(38 , quad_size - 38))
	
	# Labels
	step_config.position.y = quad_size/2.0 - step_config.get_rect().size.y/2.0
	action_label.position.y = quad_size + 20.0

func step(node: Node):
	ball.z_index = 10
	left.modulate = Color.GRAY
	left.z_index = 0
	if node != null:
		action_label.text = actions_labels[current_step]
		node.modulate = Color.WHITE
		node.z_index = 1
		current_step = wrap(current_step + 1, 0, 2)
		ding()
	else:
		current_step = 0
		pathfollow.progress_ratio = 0.0

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
	tween.tween_callback(self.step.bind(left))
	tween.tween_property(pathfollow, "progress_ratio", 1.0, step1_duration_sec).from(0.0)
	tween.tween_interval(pause_step1)
	tween.tween_callback(self.step.bind(left))
	tween.tween_property(pathfollow, "progress_ratio", 0.0, step2_duration_sec)
	tween.tween_interval(pause_step2)
	tween.play()
	
	
func _on_tween_finished():
	step(null)
	tween.stop()
	action_label.hide()
	step_config.show()
	exercice_finished.emit()


func _get_loops_for_duration(duration_sec: int):
	var one_loop_duration = step1_duration_sec + step1_duration_sec
	var breaks_duration = pause_step1 + pause_step2
	one_loop_duration += breaks_duration
	var loops = duration_sec / one_loop_duration
	if loops == 0:
		loops = 1
	return ceili(loops)

func start(total_duration_sec: int):
	desired_duration_sec = total_duration_sec
	step1_duration_sec = step1_duration_sec
	step2_duration_sec = step1_duration_sec * 2
	_start()

func stop():
	_on_tween_finished()

func _on_button_pressed():
	_start()


func _on_step_duration_value_changed(value):
	step1_duration_sec = value
	
	
func _set_step1_duration_sec(sec: int):
	step1_duration_sec = sec
	step2_duration_sec = 2 * sec
	step_config.get_node("expiration_duration").text = "%s s" % str(step2_duration_sec)
