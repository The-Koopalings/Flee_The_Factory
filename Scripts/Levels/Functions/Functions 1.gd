extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")
#onready var TextBox = get_node("TextBox")
signal openDoor
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
var b1_pressed = false
var b2_pressed = false
var b3_pressed = false

#signal dialogue_progress
#var progress_check = [false, false]
#var progress_check_arr = [["Forward"], ["Forward", "Forward", "Forward", "Interact"]]
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','R',' ','B',' ','B',' ','B',' ','D','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES


# Called when the node enters the scene tree for the first time.
func _ready():
	PEP.loadLevel(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if b1_pressed and b2_pressed and b3_pressed:
		emit_signal("openDoor")
		$AcceptDialog.popup()
		b1_pressed = false
		b2_pressed = false
		b3_pressed = false


#Handles all button presses
func _on_Button_buttonPressed(name):
	print("hi")
	match name:
		"Button1":
			b1_pressed = true
		"Button2":
			b2_pressed = true
		"Button3":
			b3_pressed = true
