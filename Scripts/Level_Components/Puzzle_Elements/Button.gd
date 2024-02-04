extends Area2D

onready var grid = get_node("/root/Node2D/Puzzle")
onready var tile_size = grid.tile_size
var hit = false

# NOTE: This will change depending on level - hardcode for now
var startPosition = Vector2(1100,700)

func _ready():
	position = startPosition
	
	# Add half a tile size to center obstacle on tile
	position += Vector2.ONE * tile_size/2


func _on_Button_body_entered(body):
	hit = true


func _on_Button_body_exited(body):
	hit = false
