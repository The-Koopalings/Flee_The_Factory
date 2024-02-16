extends Area2D

signal f1Signal
signal f2Signal

func _ready():
	var IDE = get_node("../../../../IDE")
	connect("f1Signal", IDE, "_on_f1Signal")
	connect("f2Signal", IDE, "_on_f2Signal")

	
func _process(delta):
	pass


func send_signal():
	var regexF1 = RegEx.new()
	var regexF2 = RegEx.new()
	regexF1.compile("F1_")
	regexF2.compile("F2_")
	var resultF1 = regexF1.search(name)
	var resultF2 = regexF2.search(name) 
	
	if resultF1:
		print("CALLING FUNCTION1")
		emit_signal("f1Signal")
	elif resultF2:
		print("CALLING FUNCTION2")
		emit_signal("f2Signal")
