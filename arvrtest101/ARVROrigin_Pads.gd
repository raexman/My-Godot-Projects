extends ARVROrigin

export (NodePath) var left_controller_path
export (NodePath) var right_controller_path

var left_controller_node : ARVRController
var right_controller_node : ARVRController

var left_controller_trigger_pressed := false
var right_controller_trigger_pressed := false

var left_controller_trigger_start := Vector3()
var right_controller_trigger_start := Vector3()

var rudder_start := Vector3()
var rudder_current := Vector3()

export (NodePath) var platform_path
var platform : Spatial

func _ready():
	
	left_controller_node = get_node(left_controller_path)
	right_controller_node = get_node(right_controller_path)
	
	if platform_path :
		platform = get_node(platform_path)
	
	left_controller_node.connect("button_pressed", self, "on_arvr_controller_pressed", [left_controller_node])
	left_controller_node.connect("button_release", self, "on_arvr_controller_release", [left_controller_node])
	right_controller_node.connect("button_pressed", self, "on_arvr_controller_pressed", [right_controller_node])
	right_controller_node.connect("button_release", self, "on_arvr_controller_release", [right_controller_node])

func _physics_process(delta):
	
	if left_controller_trigger_pressed && right_controller_trigger_pressed :
		
		rudder_current = (right_controller_node.global_transform.origin - left_controller_node.global_transform.origin).normalized()
		
		#var rudder_current_normal = rudder_current.normalized()
		#var rudder_start_normal = rudder_start.normalized()
		
		#print("Opposite: ", rudder_start_normal.length(), ", Hypotenuse: ", rudder_current_normal.length())
		#var rudder_delta = rudder_current.normalized() - rudder_start.normalized()
		
		#var rudder_2d = Vector2(rudder_delta.x, rudder_delta.z).normalized()
		
		var dot = rudder_current.x * rudder_start.normalized().x + rudder_current.z * rudder_start.normalized().z
		var angle = acos(dot) * sign(dot) 
		print(dot, " : ", sign(dot))		
		
		var formula2dX = asin(Vector2(rudder_current.z, rudder_current.y).normalized().y) - asin(Vector2(rudder_start.z, rudder_start.y).normalized().y) 
		var formula2dY = asin(Vector2(rudder_current.x, rudder_current.z).normalized().y) - asin(Vector2(rudder_start.x, rudder_start.z).normalized().y) 
		var formula2dZ = asin(Vector2(rudder_current.x, rudder_current.y).normalized().y) - asin(Vector2(rudder_start.x, rudder_start.y).normalized().y) 
		#asin(rudder_2d.y)
		
		#var formula = asin(rudder_current.normalized().y) - asin(rudder_start.normalized().y)
		platform.rotate_x(formula2dX * delta * 360)
		platform.rotate_y(formula2dY * delta * 360)
		platform.rotate_z(formula2dZ * delta * 360)
			
		rudder_start = rudder_current
		
		
		
		pass

func on_arvr_controller_pressed(button, controller):
	
	match(button):
		15:
			match(controller.controller_id):
				1:
					left_controller_trigger_pressed = true
					if right_controller_trigger_pressed :
						rudder_start = right_controller_node.global_transform.origin - left_controller_node.global_transform.origin
				2:
					right_controller_trigger_pressed = true

					if left_controller_trigger_pressed :
						rudder_start = right_controller_node.global_transform.origin - left_controller_node.global_transform.origin
				
	pass
	
func on_arvr_controller_release(button, controller):
	
	match(button):
		15:
			match(controller.controller_id):
				1:
					left_controller_trigger_pressed = false
					left_controller_trigger_start = Vector3()
				2:
					right_controller_trigger_pressed = false
					right_controller_trigger_start = Vector3()
	pass