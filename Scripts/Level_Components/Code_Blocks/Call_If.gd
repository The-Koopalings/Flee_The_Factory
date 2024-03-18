extends Area2D


const BLOCK_TYPE = "CALL"
func _ready():
	pass


func send_signal():
	print("CALLING " + name)
	$CodeBlock/Highlight.visible = true
	
	
#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
