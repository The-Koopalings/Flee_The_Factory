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

#Assume 6x10 grid for rn
var numRows = 6 #Cells per row
var numCols = 10  #Cells per col

#Define what's on the grid
#This is one array, read by tile, starting from the first tile of the first row and moving right.
#Size of the grid is curently determined by the above variables, but probably should be determined by variables of the Grid scene
#NOTE: This script assumes the children of Grid are placed in the order they will be read (left to right, top to bottom).
#Useful for easier editing of levels and for level editors in the future
var grid = [
	'R','O',' ',' ',' ',' ',' ',' ',' ',' ',
	' ','O',' ',' ',' ',' ',' ',' ',' ',' ',
	' ','O',' ',' ',' ',' ',' ',' ',' ',' ',
	' ','B',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
	' ',' ',' ',' ',' ',' ',' ',' ',' ','D',
]

#win conditions
var B0_Pressed = false
signal openDoor

# Called when the node enters the scene tree for the first time.
# Automatically set the positions of each element based on where they are on the grid.
func _ready():
	var tileCount = 0
	var childIndex = 0
	var node
	
	#Iterate through each tile
	for tile in grid:		
		#If tile is not empty, get the next child of Grid and set it's position
		if tile != ' ':
			node = Grid.get_child(2 + childIndex)
			childIndex += 1
			
			#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			#TODO: Change the 200 to reference Grid once we add in a variable in it to tell us where the grid starts
			#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			var col = tileCount%numCols
			var row = tileCount/numCols
			var x = 200 + Grid.tile_size/2 + col * Grid.tile_size
			var y = 200 + Grid.tile_size/2 + row * Grid.tile_size
			
			node.tileX = col
			node.tileY = row
			
			node.position = Vector2(x, y)	
			
		tileCount += 1



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
