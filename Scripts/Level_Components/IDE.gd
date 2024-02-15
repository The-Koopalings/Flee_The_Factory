extends VBoxContainer

signal function1Finished
signal function2Finished

#Entry point for IDE code
onready var main = get_node("Main/FunctionBlockArea")
onready var f1 = get_node("F1/FunctionBlockArea")
onready var f2 = get_node("F2/FunctionBlockArea")
var regexF1 = RegEx.new()
var regexF2 = RegEx.new()

func _ready():
	#Spacing between function blocks
	add_constant_override("separation", 5)
	
	#Moves Run_Button to the bottom
	move_child(get_child(1), get_child_count() - 1)
	
	#Regex for F1 and F2 code blocks
	regexF1.compile("F1_")
	regexF2.compile("F2_")


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
		if regexF1.search(block.name):
			block.send_signal()
			yield(self, "function1Finished")
		elif regexF2.search(block.name):
			block.send_signal()
			yield(self, "function2Finished")
		else:
			block.send_signal()
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 


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
		else:
			block.send_signal()
			yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
	emit_signal("function2Finished")
	
	
#Helper function to run F1 & F2 code
#func run_func_code(code):
#	#Pop all the non-code nodes {CollisionShape2D, ColorRect}
#	code.pop_front()
#	code.pop_front()
#
#	#debug so we know what's running
#	print(code)
#
#	#Run all of the code + add delay between each block
#	for block in code:
#		if regexF1.search(block.name):
#			block.send_signal()
#			yield(self, "function1Finished")
#		elif regexF2.search(block.name):
#			block.send_signal()
#			yield(self, "function2Finished")
#		else:
#			block.send_signal()
#		yield(get_tree().create_timer(GameStats.run_speed, false), "timeout") 
#

		
