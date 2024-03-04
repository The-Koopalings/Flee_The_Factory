extends Area2D

signal interactSignal
const BLOCK_TYPE = "CODE"

func _ready():
	#Use PEP to get Robot node
	var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot")) 
	var status = connect("interactSignal",Robot,"_on_Interact_interactSignal")
	

func _process(delta):
	pass


func send_signal():
	print("INTERACTING")
	$CodeBlock/Highlight.visible = true
	emit_signal("interactSignal")
