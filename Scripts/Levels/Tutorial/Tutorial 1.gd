extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
onready var TextBox = get_node("TextBox")
signal openDoor
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var btn_pressed = false
var dialogue_queue = []

signal dialogue_progress
var progress_check = [false, false]    # So signal is only emitted the first time the check is passed
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','R',' ',' ','B','D','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES

func _ready():
	PEP.loadLevel(self)
	DialogueManager.add_dialogue(self, "Tutorial/Tutorial 1.txt")


func _process(delta):
	tutorial_dialogue_check()
	
	if btn_pressed:
		emit_signal("openDoor")
		emit_signal("dialogue_progress")
		$AcceptDialog.popup()
		btn_pressed = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	btn_pressed = true


func tutorial_dialogue_check():
	# Check 1: one forward code block was dropped into main
	var check1_arr = ["Forward"]
	if !progress_check[0] and DialogueManager.fba_children_check(MainFBA, check1_arr):
		emit_signal("dialogue_progress")
		progress_check[0] = true 
	
	# Check 2: 3 forward and 1 interact was dropped into main (in that exact order)
	var check2_arr = ["Forward", "Forward", "Forward", "Interact"]
	if !progress_check[1] and DialogueManager.fba_children_check(MainFBA, check2_arr):
		emit_signal("dialogue_progress")
		progress_check[1] = true
