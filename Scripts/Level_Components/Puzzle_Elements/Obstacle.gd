extends StaticBody2D

#Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY

# startPosition is now set by the Level
#var startPosition = Vector2(500,300)

func _ready():
	$Highlight.visible = false
