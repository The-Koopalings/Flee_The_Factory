extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SceneSwapper.init_buttons(self)


func _on_BackButton_pressed():
	SceneSwapper.change_scene("Stage Select")


func _on_LevelButton_pressed(name):
	ButtonPress.play()
	SceneSwapper.change_to_level_scene(self, name)


