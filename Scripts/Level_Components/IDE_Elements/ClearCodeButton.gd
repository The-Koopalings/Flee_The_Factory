extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "on_pressed")
	

func on_pressed():
	get_node("../FunctionBlockArea").clear_code()
	