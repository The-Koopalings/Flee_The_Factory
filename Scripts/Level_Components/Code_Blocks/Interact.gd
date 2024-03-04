extends Area2D

signal interactSignal
const BLOCK_TYPE = "CODE"

func _ready():
	var Robot = get_node("../../../../Grid/Robot") #Keep in mind, code blocks become FunctionBlockArea grandchild when added to IDE
	connect("interactSignal",Robot,"_on_Interact_interactSignal")
	connect("interactSignal", get_node("../../../../../Grid/Robot"),"_on_Interact_interactSignal") #For IfElseBlocks
	

func _process(delta):
	pass


func send_signal():
	print("INTERACTING")
	$CodeBlock/Highlight.visible = true
	emit_signal("interactSignal")
