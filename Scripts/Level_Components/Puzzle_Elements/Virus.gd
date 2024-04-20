extends Area2D

#Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY

signal robotDied()

# startPosition is now set by the Level
# var startPosition = Vector2(1100,700)

func _ready():
	$Highlight.visible = false

func _on_Robot_interact(x, y):
	if x == tileX and y == tileY:
		GameStats.kill_robot()
		print("DEATH!!!")
