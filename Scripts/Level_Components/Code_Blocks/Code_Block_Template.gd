extends Area2D

var dragging = false
var parent
var startPos

signal drag(area)
signal stopDrag(globalPos)
signal doubleClick(code_block)

func _ready():
	
	$Highlight.visible = false
	
	connect("stopDrag", get_node("../.."), "_on_CodeBlock_stop_drag") #connects to FunctionBlockArea that CodeBlock is grandchild of
	parent = self.get_parent()
	startPos = parent.global_position
	
	#Get IDE node from PEP
	var IDE = get_node(PEP.get_path_to_grandpibling(self, "IDE"))
	#Signal for when IDE has finished executing this Code Block
	IDE.connect("executed", self, "_on_IDE_executed") 
	
	
	# Connect double click signal to all function blocks
	for scope in IDE.get_children():
		if scope.name == "Run_Button":
			continue
		status += connect("doubleClick", scope.get_node("FunctionBlockArea"), "_on_CodeBlock_doubleClick")
	
	if status != 0:
		printerr("Something went wrong trying to connect signals in ", name)
	
func _process(delta):
	if dragging:
		var mousePos = get_viewport().get_mouse_position()
		parent.global_position = Vector2(mousePos.x, mousePos.y)
		#self.global_position = parent.global_position
	if !dragging:
		parent.global_position = startPos 
		#self.global_position = startPos
		

func _on_Area2D_input_event(viewport, event, shape_idx):
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
