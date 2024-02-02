extends Area2D

var dragging = false
var startPos = self.global_position

signal drag;

func _ready():
	connect("drag",self,"set_dragging") #connects drag signal to function set_dragging
	
	
func _process(delta):
	if dragging:
		var mousePos = get_viewport().get_mouse_position()
		self.position = Vector2(mousePos.x, mousePos.y)
	if !dragging:
		self.position = startPos 

		

func set_dragging(): 
	dragging=!dragging
	#if dragging is now false, emit signal dropped with the block's current position
	#in the IDE, if that position is within a function's area, add it to the function


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("drag") #set dragging to true, mouse button pressed
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("drag") #set dragging to false, mouse button released
