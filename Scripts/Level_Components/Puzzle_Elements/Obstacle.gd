extends StaticBody2D

onready var grid = get_node("../") #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var tile_size = grid.tile_size
var tileX
var tileY

# NOTE: This will change depending on level - hardcode for now
var startPosition = Vector2(500,300)

func _ready():
	#position = startPosition
	
	# Add half a tile size to center obstacle on tile
	#position += Vector2.ONE * tile_size/2
	pass
