extends Area2D

var dragging = false
var parent
var startPos

signal drag

func _ready():
	
	#connects drag signal to function set_dragging
	connect("drag",self,"set_dragging") 
	parent = self.get_parent()
	startPos = parent.global_position
	
	
func _process(delta):
	if dragging:
		var mousePos = get_viewport().get_mouse_position()
		parent.global_position = Vector2(mousePos.x, mousePos.y)
	if !dragging:
		parent.global_position = startPos 
		

func set_dragging(area): 
	dragging=!dragging


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("drag") #set dragging to true, mouse button pressed
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("drag") #set dragging to false, mouse button released
