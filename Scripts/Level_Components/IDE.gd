extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main = get_node("Main/FunctionBlockArea")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var code = main.get_children()
	#Pop all the none code children
	code.pop_front()
	code.pop_front()
	
	print(code)
	
	for block in code:
		block.emitSignal()
