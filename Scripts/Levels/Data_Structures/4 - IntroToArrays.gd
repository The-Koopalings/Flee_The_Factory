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
var btn_pressed = false

signal dialogue_progress
var progress_check = []    # So signal is only emitted the first time the check is passed
var progress_check_arr = []
onready var progress_check_FBA = []
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','R','K','K','O',' ','X','X','X'],
	['X','X','X','O','O','D','D',' ','X','X','X'],
	['X','X','X',' ',' ','O','B','D','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES

func _ready():
	PEP.loadLevel(self)
	PEP.init_inventory()
	DialogueManager.add_dialogue(self, "DataStructures/4 - IntroToArrays.txt")
	

func _process(delta):
	DialogueManager.dialogue_progress_check(self)
	
	if btn_pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$AcceptDialog.popup()
			level_win = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	btn_pressed = true
	level_win = true

