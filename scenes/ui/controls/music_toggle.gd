extends TextureButton

signal sound_toggled(state)

@export var enabled_texture: Texture2D:
	set = _set_enabled_texture
@export var enabled_pressed_texture: Texture2D:
	set = _set_enabled_pressed_texture
@export var disabled_texture: Texture2D
@export var disabled_pressed_texture: Texture2D

var enabled: bool = true

func _ready():
	self.pressed.connect(self.toggle)

func toggle():
	enabled = !enabled
	_update_texture()
	sound_toggled.emit(enabled)

func _update_texture():
	if enabled:
		texture_normal = enabled_texture
		texture_pressed = enabled_pressed_texture
	else:
		texture_normal = disabled_texture
		texture_pressed = disabled_pressed_texture

func _set_enabled_texture(texture: Texture2D):
	enabled_texture = texture
	_update_texture()

func _set_enabled_pressed_texture(texture: Texture2D):
	enabled_pressed_texture = texture
	_update_texture()
