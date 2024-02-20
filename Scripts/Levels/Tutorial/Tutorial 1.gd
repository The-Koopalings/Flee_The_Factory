extends Node2D


onready var PEP = load("res://Scripts/Levels/PuzzleElementPlacement.gd").new()
onready var Grid = get_node("Grid")

var grid = [
	'R',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	'B',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	'D',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
]


# Called when the node enters the scene tree for the first time.
func _ready():
	PEP.init_puzzle(grid, Grid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
