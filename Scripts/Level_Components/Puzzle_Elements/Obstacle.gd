extends StaticBody2D

onready var grid = get_node("/root/Node2D/Puzzle")
onready var tile_size = grid.tile_size

# NOTE: This will change depending on level - hardcode for now
var startPosition = Vector2(500,300)

func _ready():
	position = startPosition
	
	# Add half a tile size to center obstacle on tile
	position += Vector2.ONE * tile_size/2

