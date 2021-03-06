tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://custom_dock.tscn").instance()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,dock) 
	dock.request_ready()
	pass

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
	pass