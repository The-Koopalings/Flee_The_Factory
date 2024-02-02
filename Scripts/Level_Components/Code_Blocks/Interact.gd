extends Area2D

signal interactSignal

func _ready():
	pass
	

func _process(delta):
	pass


func emitSignal():
	emit_signal("interactSignal")
