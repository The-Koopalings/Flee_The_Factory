extends VBoxContainer

#Entry point for IDE code
onready var main = get_node("Main/FunctionBlockArea")
onready var f1 = get_node("F1/FunctionBlockArea")
onready var f2 = get_node("F2/FunctionBlockArea")

func _ready():
	#Spacing between function blocks
	add_constant_override("separation", 5)
	
	#Moves Run_Button to the bottom
	move_child(get_child(1), get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Connected to Run_Button
func _on_Button_pressed():
	var code = main.get_children()
	run_code(code)


func _on_f1Signal():
	var code = f1.get_children()
	run_code(code)
	
	
func _on_f2Signal():
	var code = f2.get_children()
	run_code(code)
	
	
func run_code(code):
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block
	for block in code:
		block.send_signal()
		yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
