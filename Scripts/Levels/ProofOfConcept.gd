extends Node2D


#Load Puzzle Elements
#Not currently necessary, but if we wanted to do more by script...
"""
var PathToPuzzleElements = "res://Scenes/Level_Components/Puzzle_Elements/"
var Btn = load(PathToPuzzleElements + "Button.tscn")
var Door = load(PathToPuzzleElements + "Door.tscn")
var Obstacle = load(PathToPuzzleElements + "Obstacle.tscn")
var Robot = load(PathToPuzzleElements + "Robot.tscn")
"""

onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")

#Define what's on the grid
#This is one array, read by tile, starting from the first tile of the first row and moving right.
#Size of the grid is curently determined by the above variables, but probably should be determined by variables of the Grid scene
#NOTE: This script assumes the children of Grid are placed in the order they will be read (left to right, top to bottom).
#Useful for easier editing of levels and for level editors in the future
var tiles = [
	'R','O',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ','O',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ','O',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ','B',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ','D',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
]

#win conditions
var B0_Pressed = false
signal openDoor

# Called when the node enters the scene tree for the first time.
# Automatically set the positions of each element based on where they are on the grid.
func _ready():
	PEP.init_puzzle(tiles, Grid)
	PEP.init_code_blocks(CodeBlockBar)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Check win con
	#If win con, then open door
	if B0_Pressed == true:
		emit_signal("openDoor")
		$AcceptDialog.popup()
		B0_Pressed = false #So console doesn't get spammed at the end
		



func _on_Button_buttonPressed(name):
	B0_Pressed = true
