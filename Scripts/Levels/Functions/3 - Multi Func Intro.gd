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
onready var F1_FBA = get_node("IDE/F1/FunctionBlockArea")
onready var F2_FBA = get_node("IDE/F2/FunctionBlockArea")

var b1_pressed = false
var b2_pressed = false
var b3_pressed = false

signal dialogue_progress
var progress_check = [false, false]
var progress_check_arr = [["Forward", "Forward", "Forward", "Interact"], ["RotateRight", "Forward", "Forward", "RotateLeft"]]
onready var progress_check_FBA = [F1_FBA, F2_FBA]
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['R',' ',' ','B','X','X','X','X','X','X','X'],
	['X','X','X',' ','X','X','X','X','X','X','X'],
	['X','X','X',' ',' ',' ','B','X','X','X','X'],
	['X','X','X','X','X','X',' ','X','X','X','X'],
	['X','X','X','X','X','X',' ',' ',' ','B','D'],
	['X','X','X','X','X','X','X','X','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES


# Called when the node enters the scene tree for the first time.
func _ready():
	PEP.loadLevel(self)
	DialogueManager.add_dialogue(self, "Functions/3 - Multi Func Intro.txt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DialogueManager.dialogue_progress_check(self)
	
	if b1_pressed and b2_pressed and b3_pressed:
		emit_signal("dialogue_progress")
		
		if level_win:
			emit_signal("levelComplete")
			$AcceptDialog.popup()
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
	
	if b1_pressed and b2_pressed and b3_pressed:
		level_win = true
