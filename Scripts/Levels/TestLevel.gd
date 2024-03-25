extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
signal levelComplete
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var b1_pressed = false
var b2_pressed = false
var b3_pressed = false
var level_win = false
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
#Define what's on the grid
#This is one array, read by tile, starting from the first tile of the first row and moving right.
#Size of the grid is curently determined by the above variables, but probably should be determined by variables of the Grid scene
#NOTE: This script assumes the children of Grid are placed in the order they will be read (left to right, top to bottom).
#Useful for easier editing of levels and for level editors in the future
#2D array
var tiles = [
	[' ','O',' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' '],
	['R','B','V',' ',' ',' ',' ',' ',' ',' ',' '],
	['K',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
	['D',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']
]
var robotStartOrientation = PEP.Orientation.DOWN
##LEVEL CONFIGURATION VARIABLES

# Called when the node enters the scene tree for the first time.
# Automatically set the positions of each element based on where they are on the grid.
func _ready():
	PEP.loadLevel(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if b1_pressed and b2_pressed and b3_pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$AcceptDialog.popup()
			level_win = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	match name:
		"Button1":
			b1_pressed = true
		"Button2":
			b2_pressed = true
		"Button3":
			b3_pressed = true
	
	if b1_pressed and b2_pressed and b3_pressed:
		level_win = true
