extends Area2D

#signal callFunction

const BLOCK_TYPE = "CALL"

func _ready():
	pass
	
#func _process(delta):
#	pass


func send_signal():
	print("CALLING FUNCTION ", name)
	$CodeBlock/Highlight.visible = true
	#emit_signal("callFunction", name) #Not used anymore

#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
