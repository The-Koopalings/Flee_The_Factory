extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	NonLevelMusic.inCredits = true
	LevelMusic.inCredits = true
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	$BackButton.connect("pressed", self, "on_BackButton_pressed")
	$CreditsMusic.play()


func on_BackButton_pressed():
	NonLevelMusic.inCredits = false
	LevelMusic.inCredits = false
	SceneSwapper.change_scene("Start Menu")
