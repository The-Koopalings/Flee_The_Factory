extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var TextBox = get_node("TextBox")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
signal openDoor
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var btn_pressed = false
var dialogue_queue = []

signal tutorial_progress
var progress_check = [false, false, false]
##UNIQUE LEVEL VARIABLES


##LEVEL CONFIGURATION VARIABLES
var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','R',' ','O','X','X','X','X',
	'X','X','X','X','O','B','D','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES

func _ready():
	PEP.loadLevel(self)


func _process(delta):
	tutorial_dialogue_check()
	
	if btn_pressed:
		emit_signal("openDoor")
		$AcceptDialog.popup()
		btn_pressed = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	btn_pressed = true


func display_dialogue():
	var semicolon_count = 0
	
	for dialogue in dialogue_queue:
		if dialogue != ";":
			TextBox.queue_text(dialogue)
		else:
			semicolon_count += 1
			
			if semicolon_count != 4:
				yield(self, "tutorial_progress")
			else:
				yield($IDE/Run_Button, "pressed")
				yield(get_tree().create_timer(GameStats.run_speed * 4, false), "timeout")   # Wait for animation to play


func tutorial_dialogue_check():
	# Check 1: one rotate left block in Main
	var check1_arr = ["RotateLeft"]
	if !progress_check[0] and Dialogue.fba_children_check(MainFBA, check1_arr):
		emit_signal("tutorial_progress")
		progress_check[0] = true
	
	# Check 2: one rotate left and one forward block in Main
	var check2_arr = ["RotateLeft", "Forward"]
	if !progress_check[1] and Dialogue.fba_children_check(MainFBA, check2_arr):
		emit_signal("tutorial_progress")
		progress_check[1] = true
	
	# Check 3: one rotate left, one forward, and one rotate right block in Main
	var check3_arr = ["RotateLeft", "Forward", "RotateRight"]
	if !progress_check[2] and Dialogue.fba_children_check(MainFBA, check3_arr):
		emit_signal("tutorial_progress")
		progress_check[2] = true
