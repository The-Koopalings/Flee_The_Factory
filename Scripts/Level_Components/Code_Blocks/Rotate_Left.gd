extends Area2D

signal rotateLeftSignal

func _ready():
	var Robot = get_node("../../Grid/Robot")
	connect("rotateLeftSignal",Robot,"_on_RotateLeft_rotateLeftSignal")
	pass
	

func _process(delta):
	pass


func send_signal():
	print("ROTATING LEFT")
	emit_signal("rotateLeftSignal")
