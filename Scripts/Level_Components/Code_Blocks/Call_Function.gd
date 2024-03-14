extends Area2D

#signal callFunction

const BLOCK_TYPE = "CALL"

func _ready():
	pass
	
#func _process(delta):
#	pass


func send_signal():
	var funcName = name.trim_prefix("Call_").rstrip("1234567890").trim_suffix("_")
	print("CALLING FUNCTION ", funcName)
	$CodeBlock/Highlight.visible = true
	#emit_signal("callFunction", name) #Not used anymore

#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
