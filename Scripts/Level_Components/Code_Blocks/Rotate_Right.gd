extends Area2D

signal rotateRightSignal

func _ready():
	pass
	

func _process(delta):
	pass


func emitSignal():
	emit_signal("rotateRightSignal")
