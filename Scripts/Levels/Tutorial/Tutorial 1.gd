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

signal tutorial_progress
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
  
	# Add tutorial dialogue
	Dialogue.load_dialogue("Tutorial/Tutorial 1.txt", dialogue_queue)
	display_dialogue()


func _process(delta):
	tutorial_dialogue_check()
	
	if btn_pressed:
		emit_signal("openDoor")
		$AcceptDialog.popup()
		btn_pressed = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	btn_pressed = true


# Displays dialogue on the screen
# We may need to hardcode when to have the user do an action before triggering the next line of dialogue
func display_dialogue():
	var semicolon_count = 0
	
	for dialogue in dialogue_queue:
		if dialogue != ";":
			TextBox.queue_text(dialogue)
		else:
			semicolon_count += 1
			
			if semicolon_count != 3:
				yield(self, "tutorial_progress")
			else:
				yield($IDE/Run_Button, "pressed")
				yield(get_tree().create_timer(GameStats.run_speed * 4, false), "timeout")   # Wait for animation to play


func tutorial_dialogue_check():
	# Check 1: one forward code block was dropped into main
	var check1_arr = ["Forward"]
	if !progress_check[0] and Dialogue.fba_children_check(MainFBA, check1_arr):
		emit_signal("tutorial_progress")
		progress_check[0] = true 
	
	# Check 2: 3 forward and 1 interact was dropped into main (in that exact order)
	var check2_arr = ["Forward", "Forward", "Forward", "Interact"]
	if !progress_check[1] and Dialogue.fba_children_check(MainFBA, check2_arr):
		emit_signal("tutorial_progress")
		progress_check[1] = true
