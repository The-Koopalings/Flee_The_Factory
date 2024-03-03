extends Area2D

signal if1Signal
signal if2Signal

var result1
var result2
const BLOCK_TYPE = "CALL"
func _ready():
	var IDEIf = get_node("../../../../../IDE") #For code blocks in If-Else
	var IDE = get_node("../../../../IDE") #For code blocks NOT in If-Else
	connect("if1Signal", IDEIf, "_on_if1Signal")
	connect("if2Signal", IDEIf, "_on_if2Signal")
	connect("if1Signal", IDE, "_on_if1Signal") 
	connect("if2Signal", IDE, "_on_if2Signal")
	
	#Get the regex ready for use in send_signal()
	var regex1 = RegEx.new()
	var regex2 = RegEx.new()
	regex1.compile("If1_")
	regex2.compile("If2_")
	result1 = regex1.search(name)
	result2 = regex2.search(name) 
	
#func _process(delta):
#	pass


func send_signal():
	if result1:
		print("CALLING IF1")
		emit_signal("if1Signal")
	elif result2:
		print("CALLING IF2")
		emit_signal("if2Signal")
