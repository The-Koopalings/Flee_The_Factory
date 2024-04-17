extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var TextBox = get_node("TextBox")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
signal levelComplete
var level_win = false
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var btn_pressed = false

signal dialogue_progress
var progress_check_arr = [["RotateLeft"], ["RotateLeft", "Forward"], ["RotateLeft", "Forward", "RotateRight"]]
onready var progress_check_FBA = [MainFBA, MainFBA, MainFBA]
##UNIQUE LEVEL VARIABLES


##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','R',' ','O','X','X','X','X'],
	['X','X','X','X','O','B','D','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.DOWN
##LEVEL CONFIGURATION VARIABLES

func _ready():
	PEP.loadLevel(self)
	DialogueManager.add_dialogue(self, "Tutorial/2 - Rotations & Obstacles.txt")


func _process(delta):
	DialogueManager.dialogue_progress_check(self)
	
	if btn_pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$PopupMenu.visible = true
			level_win = false


#Handles all button presses
func _on_Button_buttonPressed(name):
	btn_pressed = true
	level_win = true

