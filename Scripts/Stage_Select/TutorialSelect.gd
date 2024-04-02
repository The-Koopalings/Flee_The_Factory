extends Node2D


signal button_press(name)


# Called when the node enters the scene tree for the first time.
func _ready():
	SceneSwapper.load_lvl_buttons(self, "Tutorial")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_Btn_pressed():
	SceneSwapper.change_scene("Stage Select")


func on_button_pressed():
	print("HI")


