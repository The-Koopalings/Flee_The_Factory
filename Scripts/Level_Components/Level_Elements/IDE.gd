extends VBoxContainer

signal executed

var scopes = {} #Map of all functions using the name to index/hash (Done in PEP)
var code = [] #List of currently executing code
var context = [] #List of Frames (lists of code), 2D array
var nodeNames = [] #List of names of each IDE section contained in context
var previousCode = null
var currentNode = null #Current IDE section node
var looping: bool = false 
var singleLoopCompleted: bool = false #True means loop can increment
onready var Robot = get_node("../Grid/Robot")

#To allow for only 1 press of Run unless the scene is restarted
var runPressed = false

func _ready():
	#Spacing between function blocks
	#add_constant_override("separation", 5)
	#add_spacer(true)
	
	#Moves Run_Button to the bottom
	move_child(get_child(1), get_child_count() - 1)
	
	# Grab focus of the main function
	$Scopes/Main/Main.grab_focus()


#Connected to Run_Button
func _on_RunButton_pressed():
	#Check that the Run button hasn't been pressed yet
	if !runPressed:
		runPressed = true
		GameStats.set_game_state(GameStats.State.EXECUTING)
		print("Scopes: ", scopes)
		enter_scope(scopes["Main"])
		run_code()

func _on_ClearAllButton_pressed():
	print("CLEAR ALL BUTTON NOT IMPLEMENTED YET")
	
func enter_scope(node):
	#If current IDE block node is not a Loop
	if !is_loop(node.name): 
		looping = false
	
	#Store currently executing code to the context of previous scopes
	if !code.empty():
		context.push_back(code)
		nodeNames.push_back(currentNode.name)
	#If code is empty/has all been executed, check if currentNode (previous IDE block) is a Loop
	#NOTE: Here, currentNode is the previous IDE block & node is the current IDE block
	else:
		#Allows Loops that call other IDE blocks at the end of their loop to continue looping after the IDE blocks finish
		#i.e. FOR1{Forward, FOR2} can continue looping until its condition is false even after calling FOR2
		if currentNode and is_loop():
			#Put previous loop's code into context
			#NOTE: Also pushes extra versions of current loop code, this is taken into account in line 127-ish
			var tempCode = currentNode.get_code()
			tempCode.invert()
			context.push_back(tempCode)
			nodeNames.push_back(currentNode.name)
			#code is empty, meaning 1 loop has been completed
			singleLoopCompleted = true
	
	#Increment loopCount, if applicable
	if singleLoopCompleted:
		currentNode.increment_loopCount()
		singleLoopCompleted = false
	
	#Swap code with the new code to run
	code = node.get_code()
	
	#Change currentNode to current IDE block
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
			if block.name.begins_with("Forward"):
				yield(Robot, "animationFinished")
			
			if block.BLOCK_TYPE == "CODE":
				yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
			elif block.BLOCK_TYPE == "CALL":
				var call_name = block.name.trim_prefix("Call_").rstrip("0123456789").trim_suffix("_")
				if is_loop(call_name):
					scopes[call_name].reset_loopCount()
					looping = scopes[call_name].check_conditions()
				yield(enter_scope(scopes[call_name]), "completed")
				
		#Increment loopCount for For Loops, refresh code array, & continue Loop or stop it
		if looping:
			yield(enter_scope(scopes[currentNode.name]), "completed")
			looping = currentNode.check_conditions()
		
		#Looping is finished, code array is empty, but there's more code to execute in context
		if !context.empty() and !looping:
			#Pop all code in the current IDE section until a previous section's code is reached
			var prevName = nodeNames.pop_back()
			code = context.pop_back()

			while prevName == currentNode.name:
				code = context.pop_back()
				prevName = nodeNames.pop_back()
			#Switch currentNode to the previous IDE section node
			if prevName:
				currentNode = scopes[prevName]
				#If currentNode is now a Loop, check it's conditions
				if is_loop():
					looping = currentNode.check_conditions()
				
			#Set code to empty array rather than null, if applicable
			if !code:
				code = []


#Default parameter value is currentNode.name
func is_loop(nodeName: String = currentNode.name):
	return nodeName.rstrip("0123456789") == "Loop"

func dump_code():
	code = []
	context = []
	previousCode = null
	looping = false

func _on_GameStats_robotDied():
	dump_code()
	
func _on_level_levelComplete():
	GameStats.set_game_state(GameStats.State.PASSED)
	
	#Set all execution related variables to empty
	dump_code()

