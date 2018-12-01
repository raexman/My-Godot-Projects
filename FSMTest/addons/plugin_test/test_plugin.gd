tool
extends EditorPlugin

func _enter_tree():
    #Init
    add_custom_type("TestButton", "Button", preload("test_button.gd"), preload("icon.png"))
    pass

func _exit_tree():
	#Cleanup
    remove_custom_type("TestButton")
    pass