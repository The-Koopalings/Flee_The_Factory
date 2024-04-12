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
var b1_pressed = false
var b2_pressed = false
var b3_pressed = false
var b4_pressed = false

signal dialogue_progress
var progress_check_arr = []
onready var progress_check_FBA = []
var textPath =  "Control_Flow/4 - Nested Loops.txt"
var has_tutorial = true
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','D','RB',' ',' ',' ',' ',' ','B','X','X'],
	['X','X',' ','X','X','X','X','X',' ','X','X'],
	['X','X',' ','X','X','X','X','X',' ','X','X'],
	['X','X',' ','X','X','X','X','X',' ','X','X'],
	['X','X',' ','X','X','X','X','X',' ','X','X'],
	['X','X',' ','X','X','X','X','X',' ','X','X'],
	['X','X','B',' ',' ',' ',' ',' ','B','X','X'],
]
var robotStartOrientation = PEP.Orientation.DOWN
##LEVEL CONFIGURATION VARIABLES


# Called when the node enters the scene tree for the first time.
func _ready():
	PEP.loadLevel(self)
	#DialogueManager.add_dialogue(self, textPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#DialogueManager.dialogue_progress_check(self)
	
	if b1_pressed and b2_pressed and b3_pressed and b4_pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$PopupMenu.visible = true
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
		"Button4":
			b4_pressed = true
	
	if b1_pressed and b2_pressed and b3_pressed and b4_pressed:
		level_win = true
