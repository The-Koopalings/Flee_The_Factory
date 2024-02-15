extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	$Highlight.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FunctionBlockControl_focus_entered():
	$Highlight.visible = true


func _on_FunctionBlockControl_focus_exited():
	$Highlight.visible = false


func _on_FunctionBlockControl_gui_input(event):
	print(event)
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.doubleclick:
		grab_focus()
		print("Focus grabbed")

