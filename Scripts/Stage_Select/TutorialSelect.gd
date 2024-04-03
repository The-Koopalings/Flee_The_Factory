extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	SceneSwapper.init_buttons(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	SceneSwapper.change_scene("Stage Select")


func _on_LevelButton_pressed(name):
	SceneSwapper.change_to_level_scene(self, name)

