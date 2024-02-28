extends VBoxContainer

signal function1Finished
signal function2Finished
signal if1Finished
signal if2Finished

#Entry point for IDE code, called to get children
onready var main = get_node("Main/FunctionBlockArea")
onready var f1 = get_node("F1/FunctionBlockArea") #only called in _on_f1signal()
onready var f2 = get_node("F2/FunctionBlockArea") #only called in _on_f2signal()
onready var if1 = get_node("IfElse1/If/FunctionBlockArea")
onready var else1 = get_node("IfElse1/Else/FunctionBlockArea")
onready var if2 = get_node("IfElse2/If/FunctionBlockArea")
onready var else2 = get_node("IfElse2/Else/FunctionBlockArea")
var regexF1 = RegEx.new()
var regexF2 = RegEx.new()
var regexIf1 = RegEx.new()
var regexIf2 = RegEx.new()

#To allow for only 1 press of Run unless the scene is restarted
var runPressed = false

func _ready():
	#Spacing between function blocks
	add_constant_override("separation", 5)
	
	#Moves Run_Button to the bottom
	move_child(get_child(1), get_child_count() - 1)
	
	# Grab focus of Main Function
	$Main.grab_focus()

	#Regex for F1 and F2 code blocks
	regexF1.compile("F1_")
	regexF2.compile("F2_")
	regexIf1.compile("If1_")
	regexIf2.compile("If2_")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Connected to Run_Button
func _on_Button_pressed():
	if !runPressed:
		var code = main.get_children()
	
		#Pop all the non-code nodes {CollisionShape2D, ColorRect}
		code.pop_front()
		code.pop_front()
	
		#debug so we know what's running
		print(code)
	
		#Run all of the code + add delay between each block
		for block in code:
			if regexF1.search(block.name):
				block.send_signal()
				yield(self, "function1Finished")
			elif regexF2.search(block.name):
				block.send_signal()
				yield(self, "function2Finished")
			elif regexIf1.search(block.name):
				block.send_signal()
				yield(self, "if1Finished")
			elif regexIf2.search(block.name):
				block.send_signal()
				yield(self, "if2Finished")
			else:
				block.send_signal()
				yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
		runPressed = true


#Run F1 code
func _on_f1Signal():
	var code = f1.get_children()
	
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block
	for block in code:
		if regexF1.search(block.name):
			block.send_signal()
			yield(self, "function1Finished")
		elif regexF2.search(block.name):
			block.send_signal()
			yield(self, "function2Finished")
		elif regexIf1.search(block.name):
			block.send_signal()
			yield(self, "if1Finished")
		elif regexIf2.search(block.name):
			block.send_signal()
			yield(self, "if2Finished")
		else:
			block.send_signal()
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
	emit_signal("function1Finished")
	
	
#Run F2 code
func _on_f2Signal():
	var code = f2.get_children()
	
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block
	for block in code:
		if regexF1.search(block.name):
			block.send_signal()
			yield(self, "function1Finished")
		elif regexF2.search(block.name):
			block.send_signal()
			yield(self, "function2Finished")
		elif regexIf1.search(block.name):
			block.send_signal()
			yield(self, "if1Finished")
		elif regexIf2.search(block.name):
			block.send_signal()
			yield(self, "if2Finished")
		else:
			block.send_signal()
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
	emit_signal("function2Finished")
	

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
	
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block
	for block in code:
		if regexF1.search(block.name):
			block.send_signal()
			yield(self, "function1Finished")
		elif regexF2.search(block.name):
			block.send_signal()
			yield(self, "function2Finished")
		elif regexIf1.search(block.name):
			block.send_signal()
			yield(self, "if1Finished")
		elif regexIf2.search(block.name):
			block.send_signal()
			yield(self, "if2Finished")
		else:
			block.send_signal()
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
	emit_signal("if1Finished")

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
	
	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
	code.pop_front()
	code.pop_front()
	
	#debug so we know what's running
	print(code)
	
	#Run all of the code + add delay between each block
	for block in code:
		if regexF1.search(block.name):
			block.send_signal()
			yield(self, "function1Finished")
		elif regexF2.search(block.name):
			block.send_signal()
			yield(self, "function2Finished")
		elif regexIf1.search(block.name):
			block.send_signal()
			yield(self, "if1Finished")
		elif regexIf2.search(block.name):
			block.send_signal()
			yield(self, "if2Finished")
		else:
			block.send_signal()
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
	emit_signal("if2Finished")

#Check conditions in If statement IDE block
func check_conditions(LHS, Operator, RHS) -> bool:
	return false
#Parameters are strings, condtions sent in signal because there's too many nodes in  
#func _on_ifCond_signal(LHS, Operator, RHS):
#	print("If condtions received: ", LHS, " + ", Operator, " + ", RHS)
