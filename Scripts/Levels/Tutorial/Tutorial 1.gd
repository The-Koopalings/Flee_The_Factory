extends Node2D


onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var TextBox = get_node("TextBox")


var btn_pressed = false
var openDoorTexture = preload("res://Assets/Placeholders/Open_Door.png")

var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X',' ',' ',' ',' ',' ',' ','X','X','X','X',
	'X',' ',' ','X',' ','X',' ','X','X',' ','X',
	'X','X','X','R',' ',' ','B','D','X',' ','X',
	'X','X','X',' ','X',' ','X','X','X',' ','X',
	'X','X','X',' ',' ',' ','X','X',' ',' ',' ',
	'X','X','X',' ','X','X','X','X','X','X','X',
]


func _ready():
	PEP.loadLevel(tiles, Grid, CodeBlockBar)
	
	# Set Robot orientation
	$Grid/Robot/Sprite.rotation_degrees += 90
	
	# Add tutorial dialogue
	display_dialogue()


func _process(delta):
	if btn_pressed:
		get_node("Grid/Door/Sprite").set_texture(openDoorTexture)
		$AcceptDialog.popup()
		btn_pressed = false


func _on_Button_buttonPressed(name):
	btn_pressed = true


func display_dialogue():
	TextBox.queue_text("Welcome to Flee the Factory! Robby the Robot is trapped in our elaborate factory and it is your job to help him escape.")
	TextBox.queue_text("To help Robby, you must program him to move across the factory floor and reach the exit.")

	TextBox.queue_text("IDE")    # Change position
	TextBox.queue_text("This is the IDE.")
	TextBox.queue_text("Explain Main function")
	
	TextBox.queue_text("CODE_BLOCK")    # Change position
	TextBox.queue_text("These are code blocks. This is what you use to control Robby's movements.")
	TextBox.queue_text("Explain forward code block")
	TextBox.queue_text("Explain interact code block")
	TextBox.queue_text("To place the code blocks into the IDE, you can drag and drop them.")
