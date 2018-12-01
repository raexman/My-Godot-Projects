extends ARVRController

export (NodePath) var joint_body_path
export (NodePath) var controller_body_path
var controller_body : RigidBody

var joint_body
var active_joint
var result
var joint_parent
var joint_origin


var transform_start
var transform_current

var rotation_start
var rotation_current

var prev_controller_velocities : Array
var prev_controller_pos : Vector3
var prev_controller_log_max : int = 30
var should_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	active_joint = $Generic6DOFJoint
	joint_body = get_node(joint_body_path)
	prev_controller_pos = transform.origin
	controller_body = get_node(controller_body_path)
	
	var controller_body_scale : Vector3 = controller_body.scale
	controller_body.global_transform = global_transform
	controller_body.scale = controller_body_scale
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#	pass

func _physics_process(delta):
	
	controller_process(delta)
	transform_current = controller_body.global_transform.origin
	rotation_current = self.rotation
	
	#print(rotation_current, " : ", rotation_start)

	if joint_body is Spatial:
		if joint_body && should_turn:
			#joint_body.global_rotate(Vector3(0,1,0), delta)
			#joint_body.rotation += Vector3(0,delta,0)
			#joint_body.rotation += joint_body.to_local((rotation_start - rotation_current)) * delta
			joint_body.global_rotate(Vector3(1, 0, 0), (rotation_start - rotation_current).x * delta)
			joint_body.global_rotate(Vector3(0, 1, 0), (rotation_start - rotation_current).y * delta)
			joint_body.global_rotate(Vector3(0, 0,-1), (rotation_start - rotation_current).z * delta)
			#joint_body.rotation += (rotation_start - rotation_current).normalized() * delta
			#joint_body.rotate_x((transform_start.y - transform_current.y) * delta)
			#joint_body.rotate_y((transform_current.x - transform_start.x) * delta)
			#joint_body.rotate_z((transform_current.z - transform_start.z) * delta)
			pass
		pass
	pass

func _on_ARVRControllerR_button_pressed(button):

	if button == 15 :
		transform_start = controller_body.global_transform.origin
		rotation_start = self.rotation
		should_turn = true
	pass

func _on_ARVRControllerR_button_release(button):
	if button == 15 :
		should_turn = false
	
	pass

func controller_process(delta):
	
	var position_delta : Vector3 = (global_transform.origin - prev_controller_pos ) * delta
	var avg_controller_velocity : Vector3
	var controller_velocity : Vector3 
	
	if prev_controller_velocities.size() > 0:
		for cv in prev_controller_velocities:
			avg_controller_velocity += cv	
		avg_controller_velocity /= prev_controller_velocities.size()
	
	controller_velocity = avg_controller_velocity + position_delta	
		
	if controller_body != null:
		var controller_body_scale : Vector3 = controller_body.scale
		controller_body.global_transform = global_transform
		#controller_body.global_transform.origin = prev_controller_pos.linear_interpolate(global_transform.origin, delta)
		controller_body.scale = controller_body_scale
		#controller_body.apply_impulse(Vector3(), controller_velocity)
	
	#Position cleanup
	prev_controller_velocities.append(position_delta)
	
	prev_controller_pos = global_transform.origin
	
	if prev_controller_velocities.size() > prev_controller_log_max:
		prev_controller_velocities.pop_front()
