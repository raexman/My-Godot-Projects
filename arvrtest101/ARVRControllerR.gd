extends ARVRController

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath) var joint_body_path
var joint_body
var active_joint
var result
var joint_parent
var joint_origin

# Called when the node enters the scene tree for the first time.
func _ready():
	active_joint = $Generic6DOFJoint
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_ARVRControllerR_button_pressed(button):

	if button == 15 :
		var result = get_world().direct_space_state.intersect_ray(global_transform.origin, global_transform.origin + global_transform.basis.z * -1000, [self, get_parent()])
		if result :
			joint_body = result.collider
			joint_parent = result.collider.get_parent()
			joint_origin = result.collider.global_transform.origin 
	
			if joint_body && joint_body is RigidBody :
				print("Button pressed is: " + str(button))
				joint_body.mode = RigidBody.MODE_KINEMATIC
				joint_parent.remove_child(joint_body)
				add_child(joint_body)
				#joint_body.transform.origin = joint_body.transform.
				#active_joint["nodes/node_b"] = joint_body.get_path()
				#joint_body.axis_lock_angular_x = true
				#joint_body.axis_lock_angular_y = true
				#joint_body.axis_lock_angular_z = true
				#joint_body.gravity_scale = 0
		pass # Replace with function body.

func _on_ARVRControllerR_button_release(button):
	
	if button == 15 :
		if joint_body && joint_body is RigidBody :
			print("Button released is: " + str(button))
			#active_joint["nodes/node_b"] = ""
			#joint_body.mode = RigidBody.MODE_RIGID
			#joint_body.axis_lock_angular_x = false
			#joint_body.axis_lock_angular_y = false
			#joint_body.axis_lock_angular_z = false
			#joint_body.gravity_scale = 1
			remove_child(joint_body)
			
			if joint_parent :
				joint_parent.add_child(joint_body)

	pass # Replace with function body.




func _on_Main_mouse_enter_window():
	print("WTFFFFFFF")
	pass # Replace with function body.
