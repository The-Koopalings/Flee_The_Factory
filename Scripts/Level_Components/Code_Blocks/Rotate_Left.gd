extends Area2D

signal rotateLeftSignal

func _ready():
	pass
	

func _process(delta):
	pass


func emitSignal():
	print("ROTATING LEFT")
	emit_signal("rotateLeftSignal")
