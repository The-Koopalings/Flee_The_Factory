extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	$Highlight.visible = false


func _on_FunctionBlockControl_focus_entered():
	$Highlight.visible = true


func _on_FunctionBlockControl_focus_exited():
	$Highlight.visible = false


func _on_Clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		grab_focus()
