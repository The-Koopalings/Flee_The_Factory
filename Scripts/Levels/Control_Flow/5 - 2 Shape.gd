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
var btn_pressed = false

signal dialogue_progress
var progress_check_arr = []
onready var progress_check_FBA = []
var has_tutorial = false
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','R',' ',' ',' ',' ','X','X','X'],
	['X','X','X','X','X','X','X',' ','X','X','X'],
	['X','X','X','X','X','X','X',' ','X','X','X'],
	['X','X','X',' ',' ',' ',' ',' ','X','X','X'],
	['X','X','X',' ','X','X','X','X','X','X','X'],
	['X','X','X',' ','X','X','X','D','X','X','X'],
	['X','X','X',' ',' ',' ',' ','B','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES


# Called when the node enters the scene tree for the first time.
func _ready():
	PEP.loadLevel(self)
	DialogueManager.add_dialogue(self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
