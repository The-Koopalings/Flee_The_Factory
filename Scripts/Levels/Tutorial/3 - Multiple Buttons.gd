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

signal dialogue_progress
var progress_check_arr = [["Forward", "Forward", "Interact"]]
onready var progress_check_FBA = [MainFBA]
var textPath = "Tutorial/3 - Multiple Buttons.txt"
var has_tutorial = true
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
	var root = get_tree().root
	var levelPath = root.get_child(root.get_child_count() - 1).filename
	if GameStats.playTutorial[levelPath]:
		DialogueManager.add_dialogue(self, textPath)
		GameStats.playTutorial[levelPath] = false


func _process(delta):
	DialogueManager.dialogue_progress_check(self)
	
	if b1_pressed and b2_pressed:
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
	
	if b1_pressed and b2_pressed:
		level_win = true

