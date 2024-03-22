extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
signal levelComplete
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var B0_Pressed = false
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
	['R','B',' ',' ',' ',' ','D',' ',' ',' ',' '],
	['K',' ','K','K',' ',' ',' ',' ',' ',' ',' '],
	['D',' ','D','D',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']
]
var robotStartOrientation = PEP.Orientation.DOWN
##LEVEL CONFIGURATION VARIABLES

# Called when the node enters the scene tree for the first time.
# Automatically set the positions of each element based on where they are on the grid.
func _ready():
	PEP.loadLevel(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Check win con
	#If win con, then open door
	if B0_Pressed == true:
		emit_signal("levelComplete")
		$AcceptDialog.popup()
		B0_Pressed = false #So console doesn't get spammed at the end
		

func _on_Button_buttonPressed(_name):
	B0_Pressed = true
