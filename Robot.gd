extends Area2D

var tile_size = 96

# Map input action names to the appropriate vectors
# For now, use arrow keys as input
var inputs = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}

func _ready():
	# Round robot position to nearest tile
	position = position.snapped(Vector2.ONE * tile_size)
	
	# Add half a tile size to center robot on tile
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

# Change position based on movement direction
func move(dir):
	position += inputs[dir] * tile_size
