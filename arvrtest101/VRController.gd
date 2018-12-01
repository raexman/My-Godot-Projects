extends ARVRController

enum GrabMode {AREA, RAYCAST}
enum VRControllerButtons { TRIGGER = 15, MENU = 1, GRAB = 2 }
#Velocity
var controller_velocity : Vector3
var prior_controller_position : Vector3
var prior_controller_velocities : Array
var prior_controller_velocities_max : int = 30

#Grabbed Object
var held_object : Spatial
var held_object_data : Dictionary = { "mode": RigidBody.MODE_RIGID, "layer":1, "mask":1 }

#Grabbing
var grab_area : Area
var grab_raycast : RayCast
var grab_mode : int = GrabMode.AREA
var grab_pos_node : Spatial
var wakeup_area : Area

#Meshes
var hand_mesh : MeshInstance

#Teleporting
var teleport_pos
var teleport_mesh : MeshInstance
var teleport_button_down : bool
var teleport_raycast : RayCast

const CONTROLLER_DEADZONE = 0.65
const MOVEMENT_SPEED = 1.5

var directional_movement : bool = false

#Ready
func _ready():
	
	#Teleporting
	teleport_raycast = get_node("RayCast")
	teleport_mesh = get_tree().root.get_node("Game/Teleport_Mesh")
	teleport_button_down = false
	
	#Grabbing
	grab_area = get_node("Area")
	grab_raycast = get_node("GrabCast")
	grab_pos_node = get_node("GrabPos")
	grab_mode = GrabMode.AREA
	
	#Physics
	wakeup_area = get_node("WakeupArea")
	wakeup_area.connect("body_entered", self, "wake_area_entered")
	wakeup_area.connect("body_exited", self, "wake_area_exited")
	
	#Hand
	hand_mesh = get_node("Hand")
	
	#Events
	self.connect("button_pressed", self, "button_pressed")
	self.connect("button_release", self, "button_release")

	pass

#Physics Tick
func _physics_process(delta):
	
	#Valid teleport point
	# -------------------------------
	if teleport_button_down == true:
		teleport_raycast.force_raycast_update()
		if teleport_raycast.is_colliding():
			if teleport_raycast.get_collider() is StaticBody:
				if teleport_raycast.get_collision_normal().y >= 0.85:
					teleport_pos = teleport_raycast.get_collision_point()
					teleport_mesh.global_transform.origin = teleport_pos
	
	#Controller Velocity
	# -------------------------------
	if get_is_active() :
		controller_velocity = Vector3()
		var position_delta : Vector3 = (global_transform.origin - prior_controller_position) * delta
		if prior_controller_velocities.size() > 0:
			for vel in prior_controller_velocities:
				controller_velocity += vel
				
			#Get the average velocity, instead of just adding them together.
			controller_velocity = controller_velocity / prior_controller_velocities.size()
		
		#Log current velocity			
		prior_controller_velocities.append(position_delta)
		
		controller_velocity += position_delta
		
		prior_controller_position = global_transform.origin
		
		if prior_controller_velocities.size() > prior_controller_velocities_max:
			prior_controller_velocities.remove(0)
	
	# Grabbing	
	# -------------------------------
	
	if held_object != null:
		var held_scale : Vector3 = held_object.scale
		held_object.global_transform = grab_pos_node.global_transform
		held_object.scale = held_scale
	
	#Directional movement
	#---------------------------------
	# NOTE: You may need to change this depending on which VR controllers
	# you're using and which OS you're on.
	
	#Trackpad
	var trackpad_vector : Vector2 = Vector2(-get_joystick_axis(1), get_joystick_axis(0))
	
	if trackpad_vector.length() < CONTROLLER_DEADZONE:
		trackpad_vector = Vector2()
	else:
		trackpad_vector = trackpad_vector.normalized() * ((trackpad_vector.length() - CONTROLLER_DEADZONE) / ( 1 - CONTROLLER_DEADZONE ))
	
	#Joystick	
	var joystick_vector : Vector2 = Vector2(-get_joystick_axis(5), get_joystick_axis(4))
	
	if joystick_vector.length() < CONTROLLER_DEADZONE:
		joystick_vector = Vector2()
	else:
		joystick_vector = joystick_vector.normalized() * ((joystick_vector.length() - CONTROLLER_DEADZONE) / ( 1 - CONTROLLER_DEADZONE ))
		
	var forward_direction : Vector3 = get_parent().get_node("PlayerCamera").global_transform.basis.z.normalized()
	var right_direction : Vector3 = get_parent().get_node("PlayerCamera").global_transform.basis.x.normalized()
	
	var movement_vector : Vector2 = (trackpad_vector + joystick_vector).normalized()
	
	var movement_forward : Vector3 = forward_direction * movement_vector.x * delta * MOVEMENT_SPEED
	var movement_right : Vector3 = right_direction * movement_vector.y * delta * MOVEMENT_SPEED
	
	movement_forward.y = 0
	movement_right.y = 0
	
	if movement_forward.length() > 0 or movement_right.length() > 0 :
		get_parent().translate(movement_forward + movement_right)
		directional_movement = true
	else:
		directional_movement = false
	
	# ----------------------------------
	
#Button Pressed
func button_pressed(button_index):
	
	#Trigger pressed
	if button_index == VRControllerButtons.TRIGGER:
		if held_object != null:
			if held_object.has_method("interact"):
				held_object.interact()
		else:
			if teleport_mesh.visible == false and held_object == null:
				teleport_button_down = true
				teleport_mesh.visible = true
				teleport_raycast.visible = true
	
	#Grab button pressed
	if button_index == VRControllerButtons.GRAB:
		if teleport_button_down == true:
			return
		
		if held_object == null:
			
			var rigid_body : RigidBody = null
			
			match(grab_mode):
				
				GrabMode.AREA:
					var bodies : Array = grab_area.get_overlapping_bodies()
					if len(bodies) > 0 : #this is the same as if bodies.size() > 0
						for body in bodies:
							if body is RigidBody:
								if !("NO_PICKUP" in body): #guessing this is a constant in the body?
									rigid_body = body
									break
				GrabMode.RAYCAST:
					grab_raycast.force_raycast_update() #Forces an update instead of waiting for the next physics step
					if grab_raycast.is_colliding():
						if grab_raycast.get_collider() is RigidBody and !("NO_PICKUP" in grab_raycast.get_collider()) :
							rigid_body = grab_raycast.get_collider()
			
			if rigid_body != null:
				
				held_object = rigid_body
				#Store held object's collision mode, layer and mask	
				held_object_data["mode"] = held_object.mode
				held_object_data["layer"] = held_object.collision_layer
				held_object_data["mask"] = held_object.collision_mask
				
				held_object.mode = RigidBody.MODE_STATIC
				held_object.collision_layer = 0
				held_object.collision_mask = 0
				
				if held_object.has_method("picked_up"):
					held_object.picked_up()
				if "controller" in held_object:
					held_object.controller = self
		
		else: #if held_object IS NOT null
			
			held_object.mode = held_object_data["mode"]
			held_object.collision_layer = held_object_data["layer"]
			held_object.collision_mask = held_object_data["mask"]
			
			held_object.apply_impulse(Vector3(), controller_velocity)
			
			if held_object.has_method("dropped"):
				held_object.dropped()
			
			if "controller" in held_object:
				held_object.controller = null
			
			held_object = null
			hand_mesh.visible = true
			
			if grab_mode == GrabMode.RAYCAST:
				grab_raycast.visible = true
			
		get_node("AudioStreamPlayer3D").play(0)
		
	if button_index == VRControllerButtons.MENU:
		
		match(grab_mode):
			GrabMode.AREA:
				grab_mode = GrabMode.RAYCAST
				
				if held_object == null:
					grab_raycast.visible = true
			GrabMode.RAYCAST:
				grab_mode = GrabMode.AREA
				grab_raycast.visible = false

#Button Released
func button_released(button_index):
	if button_index == VRControllerButtons.TRIGGER:
		
		if teleport_button_down == true:
			if teleport_pos != null and teleport_mesh.visible == true:
				var camera_offset = get_parent().get_node("PlayerCamera").global_transform.origin - get_parent().global_transform.origin
				camera_offset.y = 0
				
				get_parent().global_transform.origin = teleport_pos - camera_offset
			
			teleport_button_down = false
			teleport_mesh.visible = false
			teleport_raycast.visible = false
			teleport_pos = null
			

#Wake Up Area Entered
func wakeup_area_entered(body):
	if "can_sleep" in body:
		if body is RigidBody:
			body.can_sleep = false
			body.sleeping = false

#Wake Up Area Exited
func wakeup_area_exited(body):
	if "can_sleep" in body:
		if body is RigidBody:
			body.can_sleep = true

				