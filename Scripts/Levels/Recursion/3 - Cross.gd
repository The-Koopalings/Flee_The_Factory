extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
onready var TextBox = get_node("TextBox")
signal levelComplete
var level_win = false
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var B1_Pressed = false
var B3_Pressed = false
var B2_Pressed = false
var B4_Pressed = false

signal dialogue_progress
var progress_check_arr = []
onready var progress_check_FBA = []
var has_tutorial = false
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
#Define what's on the grid
#This is one array, read by tile, starting from the first tile of the first row and moving right.
#Size of the grid is curently determined by the above variables, but probably should be determined by variables of the Grid scene
#NOTE: This script assumes the children of Grid are placed in the order they will be read (left to right, top to bottom).
#Useful for easier editing of levels and for level editors in the future
var tiles = [
	['X','X','X','X','X','B','X','X','X','X','X'],
	['X','X','X','X','X',' ','X','X','X','X','X'],
	['X','X','X','X','X',' ','X','X','X','X','X'],
	['X','X','B',' ',' ','R',' ',' ','B','D','X'],
	['X','X','X','X','X',' ','X','X','X','X','X'],
	['X','X','X','X','X',' ','X','X','X','X','X'],
	['X','X','X','X','X','B','X','X','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.UP
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
	if B1_Pressed and B2_Pressed and B3_Pressed and B4_Pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$PopupMenu.visible = true
			level_win = false
		

func _on_Button_buttonPressed(name):
	match name:
		"Button1":
			B1_Pressed = true
		"Button2":
			B2_Pressed = true
		"Button3":
			B3_Pressed = true
		"Button4":
			B4_Pressed = true
	
	if B1_Pressed and B2_Pressed and B3_Pressed and B4_Pressed:
		level_win = true
