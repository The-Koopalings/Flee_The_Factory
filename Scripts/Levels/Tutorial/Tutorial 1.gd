extends Node2D


onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")
onready var TextBox = get_node("TextBox")
onready var MainFBA = get_node("IDE/Main/FunctionBlockArea")

var dialogue_queue = []
signal tutorial_progress
var progress_check1 = false    # So signal is only emitted the first time the check is passed
var progress_check2 = false

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
	tutorial1_dialogue_check()
	
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


func tutorial1_dialogue_check():
	# Check 1: one forward code block was dropped into main
	if !progress_check1 and MainFBA.numBlocks == 1 and MainFBA.CodeBlock and MainFBA.CodeBlock.name == "Forward":
		emit_signal("tutorial_progress")
		progress_check1 = true 
	
	# Check 2: main FBA has 3 forward and 1 interact
	var forward_count = 0
	var interact_count = 0
	
	var code_blocks = MainFBA.get_children()
	code_blocks.pop_front()    # first 2 children aren't code blocks
	code_blocks.pop_front()
	
	for block in code_blocks:
		match block.name.rstrip("0123456789"):
			"Forward":
				forward_count += 1
			"Interact":
				interact_count += 1
	
	if !progress_check2 and forward_count == 3 and interact_count == 1:
		emit_signal("tutorial_progress")
		progress_check2 = true
