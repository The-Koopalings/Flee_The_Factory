extends Area2D

signal f1Signal
signal f2Signal
signal callFunction
var resultF1
var resultF2
const BLOCK_TYPE = "CALL"

func _ready():
	var IDEIf = get_node("../../../../../IDE") #For code blocks in If-Else
	var IDE = get_node("../../../../IDE") #For code blocks NOT in If-Else
	connect("f1Signal", IDEIf, "_on_f1Signal")
	connect("f2Signal", IDEIf, "_on_f2Signal")
	connect("f1Signal", IDE, "_on_f1Signal")
	connect("f2Signal", IDE, "_on_f2Signal")
	
	#Get the regex ready for use in send_signal()
	var regexF1 = RegEx.new()
	var regexF2 = RegEx.new()
	regexF1.compile("F1_")
	regexF2.compile("F2_")
	resultF1 = regexF1.search(name)
	resultF2 = regexF2.search(name) 
	
#func _process(delta):
#	pass


func send_signal():
	print("CALLING FUNCTION ", name)
	$CodeBlock/Highlight.visible = true
	emit_signal("callFunction", name)
	
	"""
	if resultF1:
		
		emit_signal("f1Signal")
	elif resultF2:
		print("CALLING FUNCTION2")
		emit_signal("f2Signal")
	"""
