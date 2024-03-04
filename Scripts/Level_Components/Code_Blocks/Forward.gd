extends Area2D

signal forwardSignal
const BLOCK_TYPE = "CODE"

func _ready():
	
	#Use PEP to get Robot node
	var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot")) 
	var status = connect("forwardSignal",Robot,"_on_Forward_forwardSignal")

func _process(delta):
	pass


func send_signal():
	print("MOVING FORWARDS")
	$CodeBlock/Highlight.visible = true
	emit_signal("forwardSignal")
