extends Area2D

signal whileSignal
signal forSignal


#Which option is chosen, none = -1, While = 0, For = 1
var option = -1 
#Regex results to be used in send_signal()
var result1
var result2 

func _ready():
	#Connect signals to IDE
	var IDEIf = get_node("../../../../../IDE") #For code blocks in If-Else or Loop
	var IDE = get_node("../../../../IDE") #For code blocks NOT in If-Else or Loop
	connect("whileSignal", IDEIf, "_on_whileSignal")
	connect("forSignal", IDEIf, "_on_forSignal")
	connect("whileSignal", IDE, "_on_whileSignal")
	connect("forSignal", IDE, "_on_forSignal")
	
	#Get regex ready
	var regexL1 = RegEx.new()
	var regexL2 = RegEx.new()
	regexL1.compile("Loop1_")
	regexL2.compile("Loop2_")
	result1 = regexL1.search(name)
	result2 = regexL2.search(name) 
	
	connect_to_LoopBlock()


#Connect LoopBlock's signal "ChosenLoop" to this Loop code block, change textures if loop type has already been chosen
func connect_to_LoopBlock():
	var fromFuncMainFBA = null
	var fromIfLoopFBA = null
	var fromCodeBlockBar = null
	var loopTitle = ""
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
		fromFuncMainFBA.connect("ChosenLoop", self, "on_loop_type_selected")
		loopTitle = fromFuncMainFBA.get_node("HighlightControl/ChooseLoopType/Label").text
	elif fromIfLoopFBA:
		fromIfLoopFBA.connect("ChosenLoop", self, "on_loop_type_selected")
		loopTitle = fromIfLoopFBA.get_node("HighlightControl/ChooseLoopType/Label").text
	elif fromCodeBlockBar:
		fromCodeBlockBar.connect("ChosenLoop", self, "on_loop_type_selected")
	
	#Change sprite texture if Loop type has already been selected
	if loopTitle == "While1" or loopTitle == "While2":
		on_loop_type_selected("While")
	elif loopTitle == "For1" or loopTitle == "For2":
		on_loop_type_selected("For")


#Changes Sprite texture to match the loop type of the Loop IDE section it represents
#type is either For or While, num is either 1 or 2
func on_loop_type_selected(type: String):
	#Loop1
	if result1:
		if type == "While":
			option = 0
			$Sprite.texture = load("res://Assets/Placeholders/While1.png")
		elif type == "For":
			option = 1
			$Sprite.texture = load("res://Assets/Placeholders/For1.png")
	#Loop2
	elif result2:
		if type == "While":
			option = 0
			$Sprite.texture = load("res://Assets/Placeholders/While2.png")
		elif type == "For":
			option = 1
			$Sprite.texture = load("res://Assets/Placeholders/For2.png")


func send_signal():
	match option:
		0:
			if result1:
				emit_signal("whileSignal", 1)
			if result2:
				emit_signal("whileSignal", 2)
		1: 
			if result1:
				emit_signal("forSignal", 1)
			if result2:
				emit_signal("forSignal", 2)
