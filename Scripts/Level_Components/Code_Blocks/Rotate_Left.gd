extends Area2D

signal rotateLeftSignal

func _ready():
	var Robot = get_node("../../../../Grid/Robot") #Keep in mind, code blocks become FunctionBlockArea grandchild when added to IDE
	connect("rotateLeftSignal",Robot,"_on_RotateLeft_rotateLeftSignal")
	

func _process(delta):
	pass


func send_signal():
	print("ROTATING LEFT")
	emit_signal("rotateLeftSignal")
