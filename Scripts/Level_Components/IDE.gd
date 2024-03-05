extends VBoxContainer

signal executed

var scopes = {} #Map of all functions using the name to index/hash (Done in PEP)
var code = [] #List of currently executing code
var context = [] #List of Frames (lists of code), 2D array
var nodeNames = [] #List of names of each IDE section contained in context
var previousCode = null
var currentNode = null
var looping: bool = false
var loopDone: bool = false #True means loop can increment

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
	#Check that the Run button hasn't been pressed yet
	if !runPressed:
		runPressed = true
		print("Scopes: ", scopes)
		enter_scope(scopes["Main"])
		run_code()


func enter_scope(node):
	#Store currently executing code to the context of previous scopes
	if !code.empty():
		context.push_back(code)
		nodeNames.push_back(currentNode.name)
	#A loop has been completed if code is empty & currentNode is a Loop IDE block
	else:
		if currentNode and is_loop():
			loopDone = true
	
	#Increment loopCount 
	if loopDone:
		currentNode.increment_loopCount()
		loopDone = false
	
	#Swap code with the new code to run
	code = node.get_code()
	
	#Change currentNode 
	currentNode = node
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
			#Allows Loops that call other IDE blocks at the end of their loop to continue looping after the IDE blocks finish
			#i.e. FOR1{Forward, FOR2} can continue looping until its condition is false even after calling FOR2
			if looping:
				var tempCode = currentNode.get_code()
				tempCode.invert()
				context.push_back(tempCode)
				nodeNames.push_back(currentNode.name)
				
			
			block = code.pop_back()
			#Prevents Loops whose conditions are false from running
			if !looping and is_loop():
				continue
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
				if is_loop(call_name):
					looping = true
				yield(enter_scope(scopes[call_name]), "completed")
				
		#Increment loopCount, & continue loop or stop it
		if looping:
			if is_loop():
				yield(enter_scope(scopes[currentNode.name]), "completed")
				looping = currentNode.check_conditions()
			else:
				looping = false
		
		#Looping is finished, code array is empty, but there's more code to execute in context
		if !context.empty() and !looping:
			#Reset loopCount when Loop is finished, NOTE: later, find a way to not reset on the last iteration of a loop
			if is_loop():
				currentNode.reset_loopCount()
			#Pop all code in current IDE section until another section's code is reached
			var tempName = nodeNames.pop_back()
			code = context.pop_back()
			while tempName == currentNode.name:
				code = context.pop_back()
				tempName = nodeNames.pop_back()
			#Switch currentNode to current IDE block
			if tempName:
				currentNode = scopes[tempName]
				#If this frame is a Loop, check it's conditions
				if is_loop():
					looping = currentNode.check_conditions()
			#Set code to empty array rather than null, if applicable
			if !code:
				code = []

#Default parameter value is currentNode.name
func is_loop(nodeName: String = currentNode.name):
	return nodeName == "Loop1" or nodeName == "Loop2"
