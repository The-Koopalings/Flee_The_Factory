extends Control

var pressedButtons = []
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func on_button_pressed(buttonName):
	#If button hasn't been pressed yet
	if pressedButtons.find(buttonName) == -1:
		pressedButtons.push_back(buttonName)
		get_child(index).turn_on()
		index = index + 1
