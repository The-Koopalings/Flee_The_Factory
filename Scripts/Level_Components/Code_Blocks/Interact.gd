extends Area2D

signal interactSignal
const BLOCK_TYPE = "CODE"

func _ready():
	#Use PEP to get Robot node
	var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot")) 
	var status = connect("interactSignal",Robot,"_on_Interact_interactSignal")
	
	if status != 0:
		printerr("Something went wrong trying to connect signals in ", name)

#func _process(delta):
#	pass


func send_signal():
	print("INTERACTING")
	$CodeBlock/Highlight.visible = true
	emit_signal("interactSignal")


#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
