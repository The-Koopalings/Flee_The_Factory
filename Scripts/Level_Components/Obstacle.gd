extends StaticBody2D

onready var grid = get_node("/root/Node2D/Grid")
onready var tile_size = grid.tile_size
var startPosition = Vector2(500,300)

func _ready():
	position = position.snapped(startPosition)
	
	# Add half a tile size to center obstacle on tile
	position += Vector2.ONE * tile_size/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
