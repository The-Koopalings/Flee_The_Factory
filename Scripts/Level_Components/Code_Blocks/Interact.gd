extends Area2D

signal interactSignal

func _ready():
	pass
	

func _process(delta):
	pass


func emitSignal():
	print("INTERACTING")
	emit_signal("interactSignal")
