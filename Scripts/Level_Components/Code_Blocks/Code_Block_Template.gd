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
	
	var temp = get_parent()
	var path = "../"
	while !temp.has_node("IDE"):
		temp = temp.get_parent()
		path += "../"
	var IDE = get_node(path + "IDE")
	
	# Connect double click signal to all function blocks
	var Main = IDE.get_node("Main/FunctionBlockArea")
	connect("doubleClick", Main, "_on_CodeBlock_doubleClick")
	
	var F1 = IDE.get_node("F1/FunctionBlockArea")
	connect("doubleClick", F1, "_on_CodeBlock_doubleClick")
	
	var F2 = IDE.get_node("F2/FunctionBlockArea")
	connect("doubleClick", F2, "_on_CodeBlock_doubleClick")
	
	var If1 = IDE.get_node("IfElse1/If/FunctionBlockArea")
	connect("doubleClick", If1, "_on_CodeBlock_doubleClick")
	var Else1 = IDE.get_node("IfElse1/Else/FunctionBlockArea")
	connect("doubleClick", Else1, "_on_CodeBlock_doubleClick")
	
	var If2 = IDE.get_node("IfElse2/If/FunctionBlockArea")
	connect("doubleClick", If2, "_on_CodeBlock_doubleClick")
	var Else2 = IDE.get_node("IfElse2/Else/FunctionBlockArea")
	connect("doubleClick", Else2, "_on_CodeBlock_doubleClick")
	
	
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

func _on_CodeBlock_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_CodeBlock_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
