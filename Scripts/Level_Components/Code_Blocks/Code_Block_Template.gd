extends Area2D

var dragging = false
var parent
var startPos

#signal drag(area)
signal stopDrag(globalPos)
signal doubleClick(code_block)

func _ready():
	$Highlight.visible = false
	parent = self.get_parent()
	startPos = parent.global_position
	connections()
	

func connections():
	var status = 0
	#If codeblock is in IDE, connect to the FunctionBlockArea
	var node = get_node("../..")
	if node.name == "FunctionBlockArea":
		status += connect("stopDrag", node, "_on_CodeBlock_stop_drag") 
	
	#Get IDE node from PEP
	var IDE = get_node(PEP.get_path_to_grandpibling(self, "IDE"))
	#Signal for when IDE has finished executing this Code Block
	IDE.connect("executed", self, "_on_IDE_executed") 
	
	# Connect double click signal to all function blocks
	for scope in IDE.get_node("Scopes").get_children():
		scope = scope.get_child(0)
		if scope.name == "Run_Button":
			continue
		#Connect to IfBlock
		if scope.name.rstrip("0123456789") == "If":
			status += connect("doubleClick", scope.get_node("If/FunctionBlockArea"), "_on_CodeBlock_doubleClick")
			status += connect("doubleClick", scope.get_node("Else/FunctionBlockArea"), "_on_CodeBlock_doubleClick")
		#Connect to LoopBlock
		elif scope.name.rstrip("0123456789") == "Loop":
			status += connect("doubleClick", scope.get_node("HighlightControl/FunctionBlockArea"), "_on_CodeBlock_doubleClick")
		#Connect to Main & FunctionBlock
		else:
			status += connect("doubleClick", scope.get_node("FunctionBlockArea"), "_on_CodeBlock_doubleClick")
	
	if status != 0:
		printerr("Something went wrong trying to connect signals in ", name)
	

func _process(_delta):
	if dragging:
		var mousePos = get_viewport().get_mouse_position()
		parent.global_position = Vector2(mousePos.x, mousePos.y)
		#self.global_position = parent.global_position
	if !dragging:
		parent.global_position = startPos 
		#self.global_position = startPos
		

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.doubleclick:
				var code_block = get_parent()
				emit_signal("doubleClick", code_block)
			elif event.pressed:
				dragging = true
			elif !event.pressed:
				dragging = false
				emit_signal("stopDrag", startPos)
				
func _on_IDE_executed(block):
	if block and block.name == get_parent().name:
		$Highlight.visible = false
		
func _on_CodeBlock_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_CodeBlock_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
