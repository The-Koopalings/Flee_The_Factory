extends Control

onready var codeArea = get_node("FunctionBlockArea")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Clickable/Highlight.visible = false


func get_code():
	var code = codeArea.get_children()
	
	#Remove non-codeblocks [CollisionShape2D, ColorRect]
	code.pop_front()
	code.pop_front()

	return code


#Set FBA numBlocks to correct number after Restart, called in PEP.init_IDE()
#Allows for correct Counter displays & code block placements post-Restart
func set_FBA_numBlocks():
	var FBA = get_node("FunctionBlockArea")
	FBA.numBlocks = FBA.get_child_count() - 2


func _on_FunctionBlockControl_focus_entered():
	$Clickable/Highlight.visible = true



func _on_FunctionBlockControl_focus_exited():
	$Clickable/Highlight.visible = false


func _on_Clickable_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		grab_focus()
