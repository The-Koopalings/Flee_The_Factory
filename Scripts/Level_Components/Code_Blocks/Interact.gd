extends Area2D

signal interactSignal

func _ready():
	var Robot = get_node("/root/ProofOfConcept/Grid/Robot")
	connect("interactSignal",Robot,"_on_Interact_interactSignal")
	pass
	

func _process(delta):
	pass


func send_signal():
	print("INTERACTING")
	emit_signal("interactSignal")
