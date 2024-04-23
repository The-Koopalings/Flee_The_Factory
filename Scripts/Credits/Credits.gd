extends Node2D


onready var tween = get_node("Path2D/PathFollow2D/Credits/Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	NonLevelMusic.inCredits = true
	LevelMusic.inCredits = true
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	$BackButton.connect("pressed", self, "on_BackButton_pressed")
	$CreditsMusic.play()
	run_tween()


func on_BackButton_pressed():
	NonLevelMusic.inCredits = false
	LevelMusic.inCredits = false
	ButtonPress3.play()
	SceneSwapper.change_scene("Start Menu")

func run_tween():
	#3rd number is how long in seconds the whole pathing should take to finish
	#Tween.TRANS_BACK = slow down near beginning & end, alt: Tween.TRANS_LINEAR for linear speed throughout
	tween.interpolate_property(
		$Path2D/PathFollow2D, "unit_offset",
		0.0, 1.0, 22, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	#run_tween()
