extends Area2D

signal rotateLeftSignal
const BLOCK_TYPE = "CODE"

func _ready():
	var Robot = get_node("../../../../Grid/Robot") #Keep in mind, code blocks become FunctionBlockArea grandchild when added to IDE
	connect("rotateLeftSignal",Robot,"_on_RotateLeft_rotateLeftSignal")
	connect("rotateLeftSignal", get_node("../../../../../Grid/Robot"),"_on_RotateLeft_rotateLeftSignal") #For IfElseBlocks

	var temp = get_parent()
	while !temp.has_node("IDE"):
		temp = temp.get_parent()
	var IDE = temp
	

func _process(delta):
	pass


func send_signal():
	print("ROTATING LEFT")
	$CodeBlock/Highlight.visible = true
	emit_signal("rotateLeftSignal")
