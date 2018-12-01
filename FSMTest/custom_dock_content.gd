tool
extends VBoxContainer

# class member variables go here, for example:
onready var a = ["State", "Transition"]
var img = preload("res://icon.png")
# var b = "textvar"
func _ready():
	var graph_node = GraphNode.new()
	graph_node.size_flags_vertical = 0#SIZE_FILL #+ SIZE_EXPAND
	graph_node.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
	graph_node.set_anchors_and_margins_preset(PRESET_TOP_WIDE, Control.PRESET_MODE_KEEP_WIDTH)
		
	var grid_container = GridContainer.new()
	grid_container.columns = 4
	grid_container.size_flags_vertical = SIZE_FILL + SIZE_EXPAND
	grid_container.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
	#grid_container.set_anchors_and_margins_preset(PRESET_TOP_WIDE, Control.PRESET_MODE_KEEP_SIZE)
	
	for i in range(100):
		var new_rect = TextureRect.new()
		new_rect.texture = img
		new_rect.size_flags_vertical = SIZE_FILL + SIZE_EXPAND
		new_rect.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
		grid_container.add_child(new_rect)
		
	graph_node.add_child(grid_container)
	graph_node.rect_size = Vector2(1024, 100)
	graph_node.rect_clip_content = true
	add_child(graph_node)
	
	for r in a:
		var newRow = HBoxContainer.new()
		
		var newField = Label.new()
		newField.text = r
		newField.size_flags_vertical = SIZE_FILL
		newField.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
		newField.set_anchors_and_margins_preset(PRESET_TOP_WIDE, Control.PRESET_MODE_KEEP_HEIGHT)
		newRow.add_child(newField)

		var newButton = Button.new()
		newButton.text = r + " Submit"
		newButton.size_flags_vertical = SIZE_FILL
		newButton.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
		newButton.set_anchors_and_margins_preset(PRESET_TOP_WIDE, Control.PRESET_MODE_KEEP_HEIGHT)
		newRow.add_child(newButton)
		
		newRow.size_flags_vertical = SIZE_FILL
		newRow.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
		newRow.set_anchors_and_margins_preset(PRESET_TOP_WIDE, Control.PRESET_MODE_KEEP_HEIGHT)
		add_child(newRow)
	
	


	
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
