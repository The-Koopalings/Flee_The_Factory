extends Area2D

signal rotateLeftSignal
const BLOCK_TYPE = "CODE"

func _ready():
	#Use PEP to get Robot node
	var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot")) 
	var status = connect("rotateLeftSignal",Robot,"_on_RotateLeft_rotateLeftSignal")
	

func _process(delta):
	pass


func send_signal():
	print("ROTATING LEFT")
	$CodeBlock/Highlight.visible = true
	emit_signal("rotateLeftSignal")
