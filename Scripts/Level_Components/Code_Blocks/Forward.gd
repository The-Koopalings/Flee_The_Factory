extends Area2D

signal forwardSignal

func _ready():
	pass
	

func _process(delta):
	pass


func emitSignal():
	print("MOVING FORWARDS")
	emit_signal("forwardSignal")
