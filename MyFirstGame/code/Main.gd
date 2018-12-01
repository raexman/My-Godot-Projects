extends Node2D

export (PackedScene) var Mob
var score
var mobs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	$ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	$MobTimer.connect("timeout", self, "_on_MobTimer_timeout")
	$HUD.connect("start_game", self, "new_game")
	#$Player.start($StartPosition.position)
	#new_game()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	for mob in mobs:
		remove_child(mob)
	mobs.empty()
	$Music.stop()
	$DeathSound.play()
	
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Music.play()
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score+=1
	$HUD.update_score(score)
	
func _on_MobTimer_timeout():
	#Choose a random location on Path2D
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	#Set the mob's direction perperndicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	#Set the mob's position to random location.
	mob.position = $MobPath/MobSpawnLocation.position
	#Add some randomness to the direction
	direction+=rand_range(-PI * 0.25, PI * 0.25)
	mob.rotation = direction
	#Choose the velocity
	mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))
	mobs.append(mob)

func _on_Main_draw():
	pass # Replace with function body.
