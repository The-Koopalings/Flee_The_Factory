extends Area2D

const BLOCK_TYPE = "CALL"

#Which loop type is chosen
var type = "none" 
var loopBlockName = ""
var loopBlockNumber = ""
func _ready():
	connect_to_LoopBlock()


#Connect LoopBlock's signal "ChosenLoop" to this Loop code block, change textures if loop type has already been chosen
func connect_to_LoopBlock():
	var status = 0
	
	if get_parent().name == "CodeBlockBar":
		loopBlockName = name.trim_prefix("Call_")
	else:
		loopBlockName = name.trim_prefix("Call_").rstrip("0123456789").trim_suffix("_")
	
	loopBlockNumber = loopBlockName.trim_prefix("Loop")

	var loopBlockNode = get_node(PEP.get_path_to_grandpibling(self, "IDE/" + loopBlockName)) 
	status = loopBlockNode.connect("ChosenLoop", self, "on_loop_type_selected")
	if status != 0:
		printerr("Something went wrong trying to connect signals in ", name)

	#Change sprite texture if Loop type has already been selected
	type = loopBlockNode.get_node("HighlightControl/ChooseLoopType/Label").text.rstrip("0123456789")
	on_loop_type_selected(type)
		


#Changes Sprite texture to match the loop type of the Loop IDE section it represents
#type is either For or While (anything else does nothing)
func on_loop_type_selected(type: String):
	self.type = type
	 
	#Example path: "res://Assets/Objects/While1.png"
	$Sprite.texture = load("res://Assets/Objects/" + type + loopBlockNumber + ".png")
	if type == "While":
		$Sprite.set_scale(Vector2(0.8,0.8))
	else:
		$Sprite.set_scale(Vector2(0.221, 0.292))
	


func send_signal():
	print("CALLING " + name + " (" + type + ")")
	$CodeBlock/Highlight.visible = true


#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
