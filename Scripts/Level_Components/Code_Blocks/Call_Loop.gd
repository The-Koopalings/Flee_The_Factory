extends Area2D

#signal loopSignal
const BLOCK_TYPE = "CALL"

#Which loop type is chosen
var type = "none" 

#Regex results to be used in send_signal()
var result1
var result2 

func _ready():
	#Connect signals to IDE
#	var IDEIf = get_node("../../../../../IDE") #For code blocks in If-Else or Loop
#	var IDE = get_node("../../../../IDE") #For code blocks NOT in If-Else or Loop
#	connect("loopSignal", IDEIf, "_on_LoopSignal")
#	connect("loopSignal", IDE, "_on_LoopSignal")
#	connect("loop2Signal", IDEIf, "_on_Loop2Signal")
#	connect("loop2Signal", IDE, "_on_Loop2Signal")
	
	#Get regex ready
	var regexL1 = RegEx.new()
	var regexL2 = RegEx.new()
	regexL1.compile("Call_Loop1")
	regexL2.compile("Call_Loop2")
	result1 = regexL1.search(name)
	result2 = regexL2.search(name) 
	
	connect_to_LoopBlock()


#Connect LoopBlock's signal "ChosenLoop" to this Loop code block, change textures if loop type has already been chosen
func connect_to_LoopBlock():
	var fromFuncMainFBA = null
	var fromIfLoopFBA = null
	var fromCodeBlockBar = null
	var loopTitle = ""
	var status = 0
	
	#Get path to Loop1
	if result1: 
		fromFuncMainFBA = get_node("../../../Loop1")
		fromIfLoopFBA = get_node("../../../../Loop1")
		fromCodeBlockBar = get_node("../../IDE/Loop1")
	#Get path to Loop2
	elif result2:
		fromFuncMainFBA = get_node("../../../Loop2")
		fromIfLoopFBA = get_node("../../../../Loop2")
		fromCodeBlockBar = get_node("../../IDE/Loop2")
	
	#Check which path is correct, then connect & get Loop's title (i.e. While1, For2, etc.)
	if fromFuncMainFBA:
		status += fromFuncMainFBA.connect("ChosenLoop", self, "on_loop_type_selected")
		loopTitle = fromFuncMainFBA.get_node("HighlightControl/ChooseLoopType/Label").text
	elif fromIfLoopFBA:
		status += fromIfLoopFBA.connect("ChosenLoop", self, "on_loop_type_selected")
		loopTitle = fromIfLoopFBA.get_node("HighlightControl/ChooseLoopType/Label").text
	elif fromCodeBlockBar:
		status += fromCodeBlockBar.connect("ChosenLoop", self, "on_loop_type_selected")

	if status != 0:
		printerr("Something went wrong trying to connect signals in ", name)

	#Change sprite texture if Loop type has already been selected
	if loopTitle == "While1" or loopTitle == "While2":
		on_loop_type_selected("While")
	elif loopTitle == "For1" or loopTitle == "For2":
		on_loop_type_selected("For")


#Changes Sprite texture to match the loop type of the Loop IDE section it represents
#type is either For or While, num is either 1 or 2
func on_loop_type_selected(type: String):
	self.type = type
	#Loop1
	if result1:
		if type == "While":
			$Sprite.texture = load("res://Assets/Objects/While1.png")
		elif type == "For":
			$Sprite.texture = load("res://Assets/Objects/For1.png")
	#Loop2
	elif result2:
		if type == "While":
			$Sprite.texture = load("res://Assets/Objects/While2.png")
		elif type == "For":
			$Sprite.texture = load("res://Assets/Objects/For2.png")


func send_signal():
	print("CALLING " + name + " " + type)
	$CodeBlock/Highlight.visible = true
#	if result1:
#		print("CALLING " + type + "1")
#		emit_signal("loop1Signal", type, 1)
#	elif result2:
#		print("CALLING " + type + "2")
#		emit_signal("loop2Signal", type, 2)


#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
