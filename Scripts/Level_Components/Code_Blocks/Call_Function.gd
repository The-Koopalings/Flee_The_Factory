extends Area2D

signal functionSignal

func _ready():
	pass

	
func _process(delta):
	pass


func emitSignal():
	emit_signal("functionSignal")
