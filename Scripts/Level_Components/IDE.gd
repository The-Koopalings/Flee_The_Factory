extends VBoxContainer

signal function1Finished
signal function2Finished
signal if1Finished
signal if2Finished
signal loop1Finished
signal loop2Finished

#Entry point for IDE code, called to get children
onready var main = get_node("Main/FunctionBlockArea")
onready var f1 = get_node("F1/FunctionBlockArea") 
onready var f2 = get_node("F2/FunctionBlockArea") 
onready var if1 = get_node("IfElse1/If/FunctionBlockArea")
onready var else1 = get_node("IfElse1/Else/FunctionBlockArea")
onready var if2 = get_node("IfElse2/If/FunctionBlockArea")
onready var else2 = get_node("IfElse2/Else/FunctionBlockArea")
onready var loop1 = get_node("Loop1/HighlightControl/FunctionBlockArea")
onready var loop2 = get_node("Loop2/HighlightControl/FunctionBlockArea")
var regexF1 = RegEx.new()
var regexF2 = RegEx.new()
var regexIf1 = RegEx.new()
var regexIf2 = RegEx.new()
var regexL1 = RegEx.new()
var regexL2 = RegEx.new()

#To allow for only 1 press of Run unless the scene is restarted
var runPressed = false

func _ready():
	#Spacing between function blocks
	add_constant_override("separation", 5)
	
	#Moves Run_Button to the bottom
	move_child(get_child(1), get_child_count() - 1)
	
	# Grab focus of Main Function
	$Main.grab_focus()

	#Regex for F1, F2, If1, If2 code blocks
	regexF1.compile("F1_")
	regexF2.compile("F2_")
	regexIf1.compile("If1_")
	regexIf2.compile("If2_")
	regexL1.compile("Loop1_")
	regexL2.compile("Loop2_")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Connected to Run_Button
func _on_Button_pressed():
	#Check that the Run button hasn't been pressed yet
	if !runPressed:
		var code = main.get_children()
		run_code(code, "Main")
		runPressed = true


#Run F1 code
func _on_f1Signal():
	var code = f1.get_children()
	run_code(code , "F1")
	
	
#Run F2 code
func _on_f2Signal():
	var code = f2.get_children()
	run_code(code, "F2")
	

func _on_if1Signal():
	print("if1Signal received")
	var LHS = get_node("IfElse1/If/LHS/Label").text
	var Operator = get_node("IfElse1/If/Operator/Label").text
	var RHS = get_node("IfElse1/If/RHS/Label").text
	
	var code = null
	if check_conditions(LHS, Operator, RHS):
		code = if1.get_children()
	else:
		code = else1.get_children()
	
	run_code(code, "If1")


func _on_if2Signal():
	print("if2Signal received")
	var LHS = get_node("IfElse2/If/LHS/Label").text
	var Operator = get_node("IfElse2/If/Operator/Label").text
	var RHS = get_node("IfElse2/If/RHS/Label").text
	
	var code = null
	if check_conditions(LHS, Operator, RHS):
		code = if2.get_children()
	else:
		code = else2.get_children()
	
	run_code(code, "If2")


#type is whether the Loop IDE Block is a While or For loop 
#num denotes which Loop IDE block it is (Loop1 = 1, Loop2 = 2)
func _on_LoopSignal(type: String, num: int):
	print("LoopSignal: " + type + str(num))
	var code = null
	var loopPath = ""
	if num == 1:
		loop1.get_children()
		loopPath = "Loop1"
	elif num == 2:
		loop2.get_children()
		loopPath = "Loop2"
	
	if type == "While":
		var LHS = get_node(loopPath + "/HighlightControl/WhileConditional/LHS/Label").text
		var Operator = get_node(loopPath + "/HighlightControl/WhileConditional/Operator/Label").text
		var RHS = get_node(loopPath + "/HighlightControl/WhileConditional/RHS/Label").text
		#NOTE: might call run_code more times than it should because yield returns back to calling function
		while check_conditions(LHS, Operator, RHS): 
			run_code(code, loopPath)
		run_code(null, loopPath, true) #NOTE: might have to change to smth other than null, just to send finished signal
	elif type == "For":
		pass

#
##num denotes which For IDE block it is (For1 = 1, For2 = 2)
#func _on_Loop2Signal(type: String):
#	print("Loop2Signal: " + type)
#	var code = loop2.get_children()
#	if type == "While":
#		pass
#	elif type == "For":
#		pass


#Check conditions in If statement or While loop IDE block
func check_conditions(LHS, Operator, RHS) -> bool:
	return false


#Helper function to execute code blocks, pass in array of code block nodes + what IDE section they are running in
#loopDone optional & is used for For and While loops only
func run_code(code, type: String, loopDone: bool = false):
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block, pause to run other IDE sections' code blocks
	for block in code:
		block.send_signal()
		if regexF1.search(block.name):
			yield(self, "function1Finished")
		elif regexF2.search(block.name):
			yield(self, "function2Finished")
		elif regexIf1.search(block.name):
			yield(self, "if1Finished")
		elif regexIf2.search(block.name):
			yield(self, "if2Finished")
		elif regexL1.search(block.name):
			yield(self, "loop1Finished")
		elif regexL2.search(block.name):
			yield(self, "loop2Finished")
		else:
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
	
	match type:
		"F1":
			emit_signal("function1Finished")
		"F2":
			emit_signal("function2Finished")
		"If1":
			emit_signal("if1Finished")
		"If2":
			emit_signal("if2Finished")
		"Loop1":
			if loopDone:
				emit_signal("loop1Finished")
		"Loop2":
			if loopDone:
				emit_signal("loop2Finished")
