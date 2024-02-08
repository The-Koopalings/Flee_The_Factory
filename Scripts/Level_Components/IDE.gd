extends VBoxContainer

#Entry point for IDE code
onready var main = get_node("Main/FunctionBlockArea")

# Set code run speed for robot animations
# 0.50 is for normal and 0.25 is for double speed
var run_speed = 0.50

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
	
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block
	for block in code:
		block.send_signal()
		print(run_speed)
		yield(get_tree().create_timer(run_speed, false), "timeout") 
