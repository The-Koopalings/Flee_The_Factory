extends Node2D


##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
onready var TextBox = get_node("TextBox")
signal levelComplete
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var b1_pressed = false
var b2_pressed = false

signal dialogue_progress
var progress_check = [false]
var progress_check_arr = [["Forward", "Forward", "Interact"]]
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','R','O','D','X','X','X','X'],
	['X','X','X','X',' ','O','B','X','X','X','X'],
	['X','X','X','X','B',' ',' ','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
]
var robotStartOrientation = PEP.Orientation.DOWN
##LEVEL CONFIGURATION VARIABLES

func _ready():
	PEP.loadLevel(self)
	DialogueManager.add_dialogue(self, "Tutorial/Tutorial 3.txt")


func _process(delta):
	DialogueManager.dialogue_progress_check(self)
	
	if b1_pressed and b2_pressed:
		emit_signal("levelComplete")
		emit_signal("dialogue_progress")
		$AcceptDialog.popup()
		b1_pressed = false
		b2_pressed = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	match name:
		"Button1":
			b1_pressed = true
		"Button2":
			b2_pressed = true

