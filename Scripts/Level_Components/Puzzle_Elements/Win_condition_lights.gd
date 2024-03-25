extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func turn_on(buttonName):
	print(name + " turnt on for "+ buttonName)
	set_texture(load("res://Assets/Placeholders/OnWCL.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
