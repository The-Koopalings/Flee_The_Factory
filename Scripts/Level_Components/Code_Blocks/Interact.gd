extends Area2D

signal interactSignal

func _ready():
	var Robot = get_node("../../../../Grid/Robot") #Keep in mind, code blocks become FunctionBlockArea grandchild when added to IDE
	connect("interactSignal",Robot,"_on_Interact_interactSignal")
	connect("interactSignal", get_node("../../../../../Grid/Robot"),"_on_Interact_interactSignal") #For IfElseBlocks or LoopBlocks
	

func _process(delta):
	pass


func send_signal():
	print("INTERACTING")
	emit_signal("interactSignal")
