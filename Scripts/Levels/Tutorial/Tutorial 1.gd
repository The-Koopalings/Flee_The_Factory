extends Node2D


onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var TextBox = get_node("TextBox")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")

var dialogue_queue = []

var btn_pressed = false
var openDoorTexture = preload("res://Assets/Placeholders/Open_Door.png")

var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','R',' ',' ','B','D','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
]


func _ready():
	PEP.init_puzzle(tiles, Grid)
	PEP.init_code_blocks(CodeBlockBar)
	
	# Set Robot orientation
	$Grid/Robot/Sprite.rotation_degrees += 90
	
	# Add tutorial dialogue
	load_dialogue()
	display_dialogue()


func _process(delta):
	if btn_pressed:
		get_node("Grid/Door/Sprite").set_texture(openDoorTexture)
		$AcceptDialog.popup()
		btn_pressed = false


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
		
		if line_counter == 10:
			yield(MainFBA, "input_event")
