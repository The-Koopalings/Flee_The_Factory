extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var MainFBA = "MainFBA"
onready var TextBox = get_node("TextBox")
signal levelComplete
var level_win = false
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var B1_Pressed = false

signal dialogue_progress
var progress_check_arr = []
onready var progress_check_FBA = []
var has_tutorial = true
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
#Define what's on the grid
#This is one array, read by tile, starting from the first tile of the first row and moving right.
#Size of the grid is curently determined by the above variables, but probably should be determined by variables of the Grid scene
#NOTE: This script assumes the children of Grid are placed in the order they will be read (left to right, top to bottom).
#Useful for easier editing of levels and for level editors in the future
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','R','V',' ','V',' ','B',' ','V','D','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES

# Called when the node enters the scene tree for the first time.
# Automatically set the positions of each element based on where they are on the grid.
func _ready():
	PEP.loadLevel(self)
	DialogueManager.add_dialogue(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	DialogueManager.dialogue_progress_check(self)
	
	#Check win con
	#If win con, then open door
	if B1_Pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$PopupMenu.visible = true
			level_win = false
		

func _on_Button_buttonPressed(name):
	match name:
		"Button1":
			B1_Pressed = true
			level_win = true
