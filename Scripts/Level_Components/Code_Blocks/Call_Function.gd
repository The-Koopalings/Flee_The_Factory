extends Area2D

signal functionSignal

func _ready():
	pass

	
func _process(delta):
	pass


func emitSignal():
	print("CALLING FUNCTION")
	emit_signal("functionSignal")
