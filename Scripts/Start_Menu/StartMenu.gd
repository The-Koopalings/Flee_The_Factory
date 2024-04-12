extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	SceneSwapper.change_scene("Stage Select")


func _on_ExitButton_pressed():
	SettingsMenu.save_settings()
	GameStats.save_GameStats()
	get_tree().quit()


func _on_CreditsButton_pressed():
	SceneSwapper.change_scene("Credits")
