extends Camera

# Declare member variables here. Examples:
var last_mouse_position = Vector2()
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	last_mouse_position = get_viewport().get_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position() 
	var rotation_direction = sign(mouse_position.y - last_mouse_position.y)
	if rotation_direction != 0:
		rotate_z(lerp(rotation.z, rotation.z + rotation_direction, delta))
	last_mouse_position = mouse_position
	#See how to interpolate instead of just setting it.

#func _physics_process(delta):

	