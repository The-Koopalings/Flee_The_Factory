extends Node2D

##UNIVERSAL LEVEL VARIABLES 
onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
signal openDoor
##UNIVERSAL LEVEL VARIABLES 

##UNIQUE LEVEL VARIABLES
onready var TextBox = get_node("TextBox")
var btn_pressed = false
var dialogue_queue = []
##UNIQUE LEVEL VARIABLES

##LEVEL CONFIGURATION VARIABLES
var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X',' ',' ',' ',' ',' ',' ','X','X','X','X',
	'X',' ',' ','X',' ','X',' ','X','X',' ','X',
	'X','X','X','R',' ',' ','B','D','X',' ','X',
	'X','X','X',' ','X',' ','X','X','X',' ','X',
	'X','X','X',' ',' ',' ','X','X',' ',' ',' ',
	'X','X','X',' ','X','X','X','X','X','X','X',
]
var robotStartOrientation = PEP.Orientation.RIGHT
##LEVEL CONFIGURATION VARIABLES

func _ready():
	PEP.loadLevel(self)
  
	# Add tutorial dialogue
	load_dialogue()
	display_dialogue()


func _process(delta):
	if btn_pressed:
		emit_signal("openDoor")
		$AcceptDialog.popup()
		btn_pressed = false

#Handles all button presses
func _on_Button_buttonPressed(name):
	btn_pressed = true


# Loads dialogue from a text file
func load_dialogue():
	var file = File.new()
	file.open("res://Scripts/Dialogue/Tutorial 1.txt", file.READ)
	
	while !file.eof_reached():
		var line = file.get_line()
		dialogue_queue.push_back(line)
	
	file.close()

# Displays dialogue on the screen
# We may need to hardcode when to have the user do an action before triggering the next line of dialogue
func display_dialogue():
	var line_counter = 0
	
	for dialogue in dialogue_queue:
		line_counter += 1
		TextBox.queue_text(dialogue)
