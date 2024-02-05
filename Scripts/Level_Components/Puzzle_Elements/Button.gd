extends Area2D

onready var grid = get_node("../") #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var tile_size = grid.tile_size
var tileX
var tileY

var hit = false

signal buttonPressed(name)
# NOTE: This will change depending on level - hardcode for now
var startPosition = Vector2(1100,700)

func _ready():
	#position = startPosition
	
	# Add half a tile size to center obstacle on tile
	#position += Vector2.ONE * tile_size/2
	pass


func _on_Button_body_entered(body):
	hit = true


func _on_Button_body_exited(body):
	hit = false


func _on_Robot_interact(x, y):
	if x == tileX and y == tileY:
		emit_signal("buttonPressed", name)
