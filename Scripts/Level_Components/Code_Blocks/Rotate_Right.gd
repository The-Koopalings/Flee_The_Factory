extends Area2D

signal rotateRightSignal

func _ready():
	var Robot = get_node("/root/ProofOfConcept/Grid/Robot")
	connect("rotateRightSignal",Robot,"_on_RotateRight_rotateRightSignal")
	

func _process(delta):
	pass


func emitSignal():
	print("ROTATING RIGHT")
	emit_signal("rotateRightSignal")
