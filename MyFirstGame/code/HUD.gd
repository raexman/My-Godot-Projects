extends CanvasLayer

signal start_game

export (String) var game_start_message = "Dodge the \nCreeps!"
export (String) var game_over_message = "Game Over"

func _ready():
	$StartButton.connect("pressed", self, "_on_StartButton_pressed")
	$MessageTimer.connect("timeout", self, "_on_MessageTimer_timeout")

func show_message(text):
	
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message(game_over_message)
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$MessageLabel.text = game_start_message
	$MessageLabel.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	
func _on_MessageTimer_timeout():
	$MessageLabel.hide()