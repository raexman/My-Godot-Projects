extends ARVRController

export (NodePath) var joint_body_path
var joint_body
var active_joint
var result
var joint_parent
var joint_origin

var rotation_start
var rotation_current

# Called when the node enters the scene tree for the first time.
func _ready():
	active_joint = $Generic6DOFJoint
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#	pass

func _physics_process(delta):
	rotation_current = $Hand.global_transform.origin
	
	if joint_body:
		joint_body.rotate_x((rotation_start.y - rotation_current.y) * delta)
		joint_body.rotate_y((rotation_current.x - rotation_start.x) * delta)
		joint_body.rotate_z((rotation_current.z - rotation_start.z) * delta)
	pass

func _on_ARVRControllerR_button_pressed(button):

	if button == 15 :
		var result = get_world().direct_space_state.intersect_ray(global_transform.origin, global_transform.origin + global_transform.basis.z * -1000, [self, get_parent()])
		if result :
			joint_body = result.collider
			joint_parent = result.collider.get_parent()
			joint_origin = result.collider.global_transform.origin
			
			rotation_start = $Hand.global_transform.origin
			#if joint_body && joint_body is RigidBody:
				#joint_body.mode = RigidBody.MODE_KINEMATIC
				#$PinJoint["nodes/node_b"] = joint_body.get_path()
	pass

func _on_ARVRControllerR_button_release(button):
	if button == 15 :
		#if joint_body && joint_body is RigidBody:
			#joint_body.mode = RigidBody.MODE_RIGID
			#joint_body.linear_velocity = $Hand.linear_velocity
			#joint_body.angular_velocity = $Hand.angular_velocity
		
		joint_body = null
	
	pass