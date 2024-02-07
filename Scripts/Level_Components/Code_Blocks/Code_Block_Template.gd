extends Area2D

var dragging = false
var parent
var startPos

signal drag(area)
signal stopDrag(globalPos)

func _ready():
	connect("stopDrag", get_node("../.."), "stop_drag") #connects to FunctionBlockArea that CodeBlock is grandchild of
	parent = self.get_parent()
	startPos = parent.global_position
	
	
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
			dragging=!dragging
				
			if not event.pressed:
				emit_signal("stopDrag", startPos)
		if event.doubleclick:
			print("DOUBLE CLICK")
			
