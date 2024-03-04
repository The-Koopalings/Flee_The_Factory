extends Area2D

signal rotateRightSignal
const BLOCK_TYPE = "CODE"

func _ready():
	#Use PEP to get Robot node
	var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot")) 
	var status = connect("rotateRightSignal",Robot,"_on_RotateRight_rotateRightSignal")

func _process(delta):
	pass


func send_signal():
	print("ROTATING RIGHT")
	$CodeBlock/Highlight.visible = true
	emit_signal("rotateRightSignal")
