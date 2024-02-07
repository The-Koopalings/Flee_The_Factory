extends Area2D

signal rotateRightSignal

func _ready():
	var Robot = get_node("../../../../Grid/Robot") #Keep in mind, code blocks become FunctionBlockArea grandchild when added to IDE
	connect("rotateRightSignal",Robot,"_on_RotateRight_rotateRightSignal")
	

func _process(delta):
	pass


func send_signal():
	print("ROTATING RIGHT")
	emit_signal("rotateRightSignal")
