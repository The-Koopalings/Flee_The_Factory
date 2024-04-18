extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
onready var TextBox = get_node("TextBox")
signal levelComplete
var level_win = false
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL 
onready var Loop_Block = get_node("IDE/Loop1/HighlightControl")
onready var While_Block = get_node("IDE/Loop1/HighlightControl/WhileConditional")
onready var Loop_FBA = get_node("IDE/Loop1/HighlightControl/FunctionBlockArea")

var btn_pressed = false

signal dialogue_progress
var progress_check_arr = [["While"], ["Tile", "!=", "Button"], ["Forward"], ["Call_Loop1"], ["Call_Loop1", "Interact"]]
onready var progress_check_FBA = [Loop_Block, While_Block, Loop_FBA, MainFBA, MainFBA]
var has_tutorial = true
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','R',' ',' ',' ',' ','B','D','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
	['X','X','X','X','X','X','X','X','X','X','X'],
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
