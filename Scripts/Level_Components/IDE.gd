extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main = get_node("Main/FunctionBlockArea")

func _ready():
	add_constant_override("separation", 5)
	move_child(get_child(1), get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var code = main.get_children()
	
	#Pop all the non-code nodes
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	for block in code:
		block.emitSignal()
		yield(get_tree().create_timer(0.25, false), "timeout") 
