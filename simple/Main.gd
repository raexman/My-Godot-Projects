extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# load SIMPLE library
onready var data = preload("res://bin/Simple.gdns").new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var c = "Data2113"
	$Label.text = c + " 11=1 " + data.GDGet_data()
