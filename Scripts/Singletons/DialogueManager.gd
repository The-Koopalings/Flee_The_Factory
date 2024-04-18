extends Node

var dialogue_queue = []

var generic_dialogue = {"Tutorial": ["Remember: Press the button(s) to open the door & win the level. I can only press it if I am standing on top of a button and an Interact code block is executed."],
					"Functions": ["Remember: Executing/calling a function will execute all of the code blocks in it. Also, functions can call other functions."],
					"Control_Flow": ["Remember: You can set the conditions for If statements and While loops.",
									 "When conditions are true, If statements execute the code underneath If, when false it'll execute code under Else.",
									 "When conditions are true for While loops, it will execute the code in it until the conditions are false.",
									 "You can set how many times a For loop will execute by setting what i (the loop counter) should start at, what number i should stop at, and how much i increases with each loop."],
					"Recursion": ["Remember: Functions can call themselves and will stop once the level is complete."],
					"Data_Structures": ["Remember: Stacks are LIFO (last in, first out), Queues are FIFO (first in, first out), and you have to keep track of the index you put an item into and use for Arrays."]
					}

var highlight_path = {"HIGHLIGHT_IDE": "IDE/IDE_Arrow",
					  "HIGHLIGHT_RUN": "IDE/Run_Arrow",
					  "HIGHLIGHT_FUNCTION_BLOCK": "IDE/F1_Arrow",
					  "HIGHLIGHT_INVENTORY": "Inventory/Inventory_Arrow",
					  "HIGHLIGHT_FORWARD": "CodeBlockBar/Forward/CodeBlock/Arrow",
					  "HIGHLIGHT_INTERACT": "CodeBlockBar/Interact/CodeBlock/Arrow",
					  "HIGHLIGHT_ROTATE_LEFT": "CodeBlockBar/RotateLeft/CodeBlock/Arrow",
					  "HIGHLIGHT_ROTATE_RIGHT": "CodeBlockBar/RotateRight/CodeBlock/Arrow",
					  "HIGHLIGHT_CALL_F1": "CodeBlockBar/Call_F1/CodeBlock/Arrow",
					  "HIGHLIGHT_PICKUP": "CodeBlockBar/Pickup/CodeBlock/Arrow",
					  "HIGHLIGHT_USEITEM": "CodeBlockBar/UseItem/CodeBlock/Arrow",
					  "HIGHLIGHT_BUTTON": "Grid/Button/Highlight",
					  "HIGHLIGHT_KEYR": "Grid/KeyR/Highlight",
					  "HIGHLIGHT_DOOR": "Grid/Door/Highlight",
					  "HIGHLIGHT_DOORR": "Grid/DoorR/Highlight",
					  "HIGHLIGHT_OBSTACLE": "Grid/Obstacle/Highlight",
					  "HIGHLIGHT_VIRUS": "Grid/Virus/Highlight",
					  "HIGHLIGHT_SETTINGS": "Level Control/Settings/Arrow",
					  "HIGHLIGHT_RESTART": "Level Control/Restart/Arrow",
					  "HIGHLIGHT_HELP": "Level Control/Help/Arrow",
					  "HIGHLIGHT_2X_SPEED": "Level Control/DoubleSpeed/Arrow",
					  "HIGHLIGHT_CLEAR_CODE": "IDE/Clear_Code_Arrow"}

var check_progress = false  # Boolean check to fix yielding bug
var check_index = 0  # Only check for currently yielding user action checkpoint

# Load and display dialogue
func add_dialogue(level, file_path):
	var root = level.get_tree().root
	var levelPath = root.get_child(root.get_child_count() - 1).filename
	
	if GameStats.savableGameStats.playTutorial[levelPath]:
		level.TextBox.set_default_pos()
		load_dialogue(file_path)
		display_dialogue(level)
		GameStats.savableGameStats.playTutorial[levelPath] = false
	


# Helper function to load dialogue from a text file
func load_dialogue(file_path):
	var path_to_dialogue = "res://Scripts/Dialogue/"
	
	var file = File.new()
	file.open(path_to_dialogue + file_path, file.READ)
	
	while !file.eof_reached():
		var line = file.get_line()
		dialogue_queue.push_back(line)
	
	file.close()


# Helper function that displays dialogue and yields to a level's progress signal when encountering a semicolon
func display_dialogue(level):
	var last_highlight
	
	for dialogue in dialogue_queue:
		if dialogue == ";":
			check_progress = true
			yield(level, "dialogue_progress")
		elif dialogue.begins_with("HIGHLIGHT_"):
			last_highlight = highlight_manager(dialogue, level)
		elif dialogue != "":
			level.TextBox.queue_text(dialogue)
			yield(level.TextBox, "user_action")
			
			if last_highlight:
				last_highlight.visible = false
	
	dialogue_queue.clear()


#Display generic Help dialogue
func display_generic_dialogue(level, directory):
	for dialogue in generic_dialogue[directory]:
		level.TextBox.queue_text(dialogue)
		yield(level.TextBox, "user_action")


func restart_dialogue():
	dialogue_queue.clear()
	check_index = 0
	check_progress = false

# Manages visual highlight for current game component we are describing
func highlight_manager(dialogue, level):
	var path_to_highlight = highlight_path[dialogue]
	var component_highlight = level.get_node(path_to_highlight)
	
	component_highlight.visible = true
	
	return component_highlight

# Checks if user completed the correct action before the next line of dialogue is triggered
func dialogue_progress_check(level):
	if check_index < level.progress_check_arr.size():
		var i = check_index
		
		if check_progress and fba_children_check(level.progress_check_FBA[i], level.progress_check_arr[i]):
			level.emit_signal("dialogue_progress")
			check_progress = false
			check_index += 1


# Helper function to check to see if the right code blocks are dropped into FBA in the expected order
func fba_children_check(FBA, block_names_arr):
	var code_blocks = FBA.get_children()
	code_blocks.pop_front()    # first 2 children aren't code blocks
	code_blocks.pop_front()
	
	var passed_check = true
	
	for i in range(0, code_blocks.size()):
		# Edge case: more code blocks are in the FBA than what we are checking for
		if i >= block_names_arr.size():
			break
		
		var name = code_blocks[i].name
		
		if name.begins_with("Call"):
			if name.begins_with("Call_F1") and block_names_arr[i] != "Call_F1":
				passed_check = false
				break
		elif name.rstrip("0123456789") != block_names_arr[i]:
			passed_check = false
			break
	
	return passed_check and code_blocks.size() == block_names_arr.size()
