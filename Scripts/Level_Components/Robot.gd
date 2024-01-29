extends Area2D

onready var grid = get_node("/root/Node2D/Grid")
onready var tile_size = grid.tile_size
onready var grid_x = grid.grid_x
onready var grid_y = grid.grid_y
var startPosition = Vector2(192,162)

# Map input action names to the appropriate vectors
# For now, use arrow keys as input
var inputs = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}

func _ready():
	# Round robot position to nearest tile
	position = position.snapped(startPosition)
	
	# Add half a tile size to center robot on tile
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

# Change position based on movement direction
func move(dir):
	position += inputs[dir] * tile_size
	
	# Clamp position to window
	position.x = clamp(position.x, 192 +  tile_size/2, grid_x - tile_size/2)
	position.y = clamp(position.y, 162 + tile_size/2, grid_y - tile_size/2)
