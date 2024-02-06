extends Area2D

#Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY

var hit = false

signal buttonPressed(name)

# startPosition is now set by the Level
# var startPosition = Vector2(1100,700)

func _ready():
	pass

func _on_Button_body_entered(body):
	hit = true

func _on_Button_body_exited(body):
	hit = false

func _on_Robot_interact(x, y):
	if x == tileX and y == tileY:
		emit_signal("buttonPressed", name)