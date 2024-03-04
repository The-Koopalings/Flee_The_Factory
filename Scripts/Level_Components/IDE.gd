extends VBoxContainer

signal function1Finished
signal function2Finished
signal if1Finished
signal if2Finished
signal executed

var scopes = {} #Map of all functions using the name to index/hash (Done in PEP)
var code = [] #List of currently executing code
var context = [] #List of Frames (lists of code)
var previousCode = null


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
		print("Scopes: ", scopes)
		enter_scope(scopes["Main"])
		run_code()


func enter_scope(node):
	#Store currently executing code to the context of previous scopes
	if !code.empty():
		context.push_back(code)
		
	#Swap code with the new code to run
	code = node.get_code()
	#print(code)
	
	#print("Context: ", context)
	#print("SIZE: ", context.size())
	
	#Check for potential infinite loop. If we hit here, probably want to tell player about it.
	if context.size() >= 1000:
		printerr("Too many scopes called. Possibly an inifinite loop. Terminating early")
		assert(context.size() < 1000)

	#Will execute from back to front, so invert
	code.invert()
	yield(get_tree().create_timer(GameStats.run_speed/2, false), "timeout") 

func run_code():
	var block
	#While there's still code to run
	while !code.empty() or !context.empty(): 
		#While this function still has code
		while !code.empty():
			block = code.pop_back()
			
			#debug so we know what's running
			#print(block)
			
			#Run code + add delay between each block
			emit_signal("executed", previousCode)
			block.send_signal()
			previousCode = block
			
			if block.BLOCK_TYPE == "CODE":
				yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
			elif block.BLOCK_TYPE == "CALL":
				var call_name = block.name.trim_prefix("Call_").rstrip("0123456789").trim_suffix("_")
				yield(enter_scope(scopes[call_name]), "completed")
		
		if !context.empty():
			code = context.pop_back()
