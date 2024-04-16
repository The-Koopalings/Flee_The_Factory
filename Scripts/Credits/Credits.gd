extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	NonLevelMusic.inCredits = true
	$BackButton.connect("pressed", self, "on_BackButton_pressed")
	$CreditsMusic.play()


func on_BackButton_pressed():
	NonLevelMusic.inCredits = false
	SceneSwapper.change_scene("Start Menu")
