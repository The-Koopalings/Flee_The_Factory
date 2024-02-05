extends Node2D

onready var grid = get_node("../") #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var tile_size = grid.tile_size



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
