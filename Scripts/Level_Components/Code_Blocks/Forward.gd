extends Area2D

signal forwardSignal

func _ready():
	var Robot = get_node("/root/ProofOfConcept/Grid/Robot")
	connect("forwardSignal",Robot,"_on_Forward_forwardSignal")
	pass
	

func _process(delta):
	pass


func send_signal():
	print("MOVING FORWARDS")
	emit_signal("forwardSignal")
