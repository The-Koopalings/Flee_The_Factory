extends ColorRect

#Stack = 0, 1 = Queue, 2 = Array
export var type = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		0:
			$ReferenceRect.set_border_color(Color(1, 0, 0)) #Red
			$Line2D.set_default_color(Color(1, 0, 0))
			$Line2D2.set_default_color(Color(1, 0, 0))
		1:
			$ReferenceRect.set_border_color(Color(0, 1, 0)) #Green
			$Line2D.set_default_color(Color(0, 1, 0))
			$Line2D2.set_default_color(Color(0, 1, 0))
		2:
			$ReferenceRect.set_border_color(Color(0, 0, 1)) #Blue
			$Line2D.set_default_color(Color(0, 0, 1))
			$Line2D2.set_default_color(Color(0, 0, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

