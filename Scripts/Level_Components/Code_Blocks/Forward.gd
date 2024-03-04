extends Area2D

signal forwardSignal
const BLOCK_TYPE = "CODE"

func _ready():
	var Robot = get_node("../../../../Grid/Robot") #Keep in mind, code blocks become FunctionBlockArea grandchild when added to IDE
	connect("forwardSignal",Robot,"_on_Forward_forwardSignal")
	connect("forwardSignal", get_node("../../../../../Grid/Robot"), "_on_Forward_forwardSignal") #For IfElseBlocks
	

func _process(delta):
	pass


func send_signal():
	print("MOVING FORWARDS")
	$CodeBlock/Highlight.visible = true
	emit_signal("forwardSignal")
