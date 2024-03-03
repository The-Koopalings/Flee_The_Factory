extends VBoxContainer

signal function1Finished
signal function2Finished
signal if1Finished
signal if2Finished


var functions = {} #Map of all functions using the name to index/hash
var code = [] #List of currently executing code
var stackFrame = [] #List of Frames (lists of code)



#To allow for only 1 press of Run unless the scene is restarted
var runPressed = false

func _ready():
	#Spacing between function blocks
	add_constant_override("separation", 5)
	
	#Moves Run_Button to the bottom
	move_child(get_child(1), get_child_count() - 1)
	
	# Grab focus of Main Function
	$Main.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Connected to Run_Button
func _on_Button_pressed():
	if !runPressed:
		runPressed = true
		print(functions)
		call_function(functions["Main"])
		run_code()


func call_function(node):
	#Add currently executing code to the stack frame
	if !code.empty():
		stackFrame.push_back(code)
		
	#Get the new code to run
	code = node.get_code()
	#print(code)
	
	#Will execute from back to front, so invert
	code.invert()
	yield(get_tree().create_timer(0, false), "timeout") 

func run_code():
	var block
	#While there's still code to run
	while !code.empty() or !stackFrame.empty(): 
		#While this function still has code
		while !code.empty():
			block = code.pop_back()
			
			#debug so we know what's running
			#print(block)
			
			#Run code + add delay between each block
			if block.BLOCK_TYPE == "CODE":
				block.send_signal()
				yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
			elif block.BLOCK_TYPE == "CALL":
				var function_name = block.name.trim_prefix("Call_")
				yield(call_function(functions[function_name]), "completed") 
		
		if !stackFrame.empty():
			code = stackFrame.pop_back()
	
			

