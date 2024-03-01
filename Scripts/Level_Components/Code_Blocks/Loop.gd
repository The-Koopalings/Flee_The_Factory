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
	var regexF1 = RegEx.new()
	var regexF2 = RegEx.new()
	regexF1.compile("Loop1_")
	regexF2.compile("Loop2_")
	result1 = regexF1.search(name)
	result2 = regexF2.search(name) 
	

#Changes Sprite texture to match the loop type of the Loop IDE section it represents
#type is either For or While, num is either 1 or 2
func on_loop_type_selected(type: String, num: int):
	if type == "While":
		option = 0
		if self.name == "Loop1_" and num == 1:
			$Sprite.texture = load("res://Assets/Placeholders/While1.png")
		elif self.name == "Loop2_" and num == 2:
			$Sprite.texture = load("res://Assets/Placeholders/While2.png")
	elif type == "For":
		option = 1
		if self.name == "Loop1_" and num == 1:
			$Sprite.texture = load("res://Assets/Placeholders/For1.png")
		elif self.name == "Loop2_" and num == 2:
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
