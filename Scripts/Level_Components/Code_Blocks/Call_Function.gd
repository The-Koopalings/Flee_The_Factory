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
	if(name == "F1"):
		print("CALLING FUNCTION1")
		emit_signal("f1Signal")
	elif(name == "F2"):
		print("CALLING FUNCTION2")
		emit_signal("f2Signal")
