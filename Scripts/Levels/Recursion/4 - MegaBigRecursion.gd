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
var B2_Pressed = false
var B3_Pressed = false
var B4_Pressed = false
var B5_Pressed = false
var B6_Pressed = false

signal dialogue_progress
var progress_check_arr = []
onready var progress_check_FBA = []
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
#Define what's on the grid
#This is one array, read by tile, starting from the first tile of the first row and moving right.
#Size of the grid is curently determined by the above variables, but probably should be determined by variables of the Grid scene
#NOTE: This script assumes the children of Grid are placed in the order they will be read (left to right, top to bottom).
#Useful for easier editing of levels and for level editors in the future
var tiles = [
	['O','X','X','X','X','X','X','X','X','X','O'],
	[' ','O','B',' ','O','B',' ','O','B',' ',' '],
	[' ','X','X',' ','X','X',' ','X','X',' ',' '],
	['R',' ',' ',' ',' ',' ',' ',' ',' ',' ','D'],
	[' ','X','X',' ','X','X',' ','X','X',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
	['O','B','X','X','B','X','X','B','X','X','O'],
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES

# Called when the node enters the scene tree for the first time.
# Automatically set the positions of each element based on where they are on the grid.
func _ready():
	PEP.loadLevel(self)
	
	#We don't have room for 3 scopes yet, so I'm just doing this
	var runBtn = get_node("IDE/Run_Button").duplicate()
	self.add_child(runBtn)
	runBtn.rect_position = Vector2(960, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Check win con
	#If win con, then open door
	if B1_Pressed and B2_Pressed and B3_Pressed and B4_Pressed and B5_Pressed and B6_Pressed:
		
		if level_win:
			emit_signal("levelComplete")
			$PopupMenu.visible = true

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
		"Button5":
			B5_Pressed = true
		"Button6":
			B6_Pressed = true
	
	if B1_Pressed and B2_Pressed and B3_Pressed and B4_Pressed and B5_Pressed and B6_Pressed:
		level_win = true
