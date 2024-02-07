extends Area2D

signal functionSignal

func _ready():
	pass

	
func _process(delta):
	pass


func send_signal():
	print("CALLING FUNCTION")
	emit_signal("functionSignal")
