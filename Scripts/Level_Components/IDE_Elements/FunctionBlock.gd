extends Control

onready var codeArea = get_node("FunctionBlockArea")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Highlight.visible = false


func get_code():
	var code = codeArea.get_children()
	
	#Remove non-codeblocks [CollisionShape2D, ColorRect]
	code.pop_front()
	code.pop_front()

	return code

func _on_FunctionBlockControl_focus_entered():
	$Highlight.visible = true


func _on_FunctionBlockControl_focus_exited():
	$Highlight.visible = false


func _on_Clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		grab_focus()

