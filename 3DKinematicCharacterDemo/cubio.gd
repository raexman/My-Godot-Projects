
extends KinematicBody

# Member variables
var jumpLimit = 2;
var jumpCount = 0;

var lastMousePosition = Vector2();

var g = -9.8
var vel = Vector3()

# Constants
const MAX_SPEED = 10
const JUMP_SPEED = 7
const ACCEL= 2
const DEACCEL= 4
const MAX_SLOPE_ANGLE = 30
const ROTATION_SPEED = 5;

func _physics_process(delta):
	var dir = Vector3() # Where does the player intend to walk to
	var cam_xform = get_node("target/camera").get_global_transform()
	
	var current_mouse_position = get_viewport().get_mouse_position()
	var rotation_direction = sign(lastMousePosition.x - current_mouse_position.x)
	
	rotate_y(rotation_direction * delta * ROTATION_SPEED)
	lastMousePosition = current_mouse_position
	
	if (Input.is_action_pressed("move_forward")):
		dir += -cam_xform.basis[2]
	if (Input.is_action_pressed("move_backwards")):
		dir += cam_xform.basis[2]
	if (Input.is_action_pressed("move_left")):
		dir += -cam_xform.basis[0]
	if (Input.is_action_pressed("move_right")):
		dir += cam_xform.basis[0]
	
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta*g
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir*MAX_SPEED
	var accel
	if (dir.dot(hvel) > 0):
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel*delta)
	
	vel.x = hvel.x
	vel.z = hvel.z
	
	vel = move_and_slide(vel,Vector3(0,1,0))
	
	if (is_on_floor()):
		jumpCount = 0
	
	if (Input.is_action_pressed("jump") && jumpCount <= jumpLimit):
		vel.y = JUMP_SPEED
		jumpCount+=1
	
	var crid = get_node("../elevator1").get_rid()



func _on_tcube_body_enter(body):
	if (body == self):
		get_node("../ty").show()
