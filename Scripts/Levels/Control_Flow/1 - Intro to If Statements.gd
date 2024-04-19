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
onready var F1_FBA = "F1_FBA"
onready var If_Block = "If1_Block"
onready var If_FBA = "If1_FBA"
onready var Else_FBA = "Else1_FBA"

var btn_pressed = false

signal dialogue_progress
var progress_check_arr = [["Forward", "Forward"], ["Front", "==", "Blocked"], ["RotateRight"], ["Interact"], ["Forward", "Forward", "Call_If1"]]
onready var progress_check_FBA = [F1_FBA, If_Block, If_FBA, Else_FBA, F1_FBA]
var has_tutorial = true
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','R',' ',' ','X','X','X','X'],
	['X','X','X','X','X','X',' ','X','X','X','X'],
	['X','X','X','X','X','X','B','X','X','X','X'],
	['X','X','X','X','X','X',' ','X','X','X','X'],
	['X','X','X','X','X','X','D','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
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
