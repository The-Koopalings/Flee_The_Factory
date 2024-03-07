extends Node

var dialogue_queue = []


# Load and display dialogue
func add_dialogue(level, file_path):
	load_dialogue(file_path)
	display_dialogue(level)


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
	for dialogue in dialogue_queue:
		if dialogue != ";":
			level.TextBox.queue_text(dialogue)
		else:
			yield(level, "dialogue_progress")


# Checks if user completed the correct action before the next line of dialogue is triggered
func dialogue_progress_check(level):
	for i in range(level.progress_check.size()):
		if !level.progress_check[i] and fba_children_check(level.MainFBA, level.progress_check_arr[i]):
			level.emit_signal("dialogue_progress")
			level.progress_check[i] = true 


# Helper function to check to see if the right code blocks are dropped into FBA in the expected order
func fba_children_check(FBA, block_names_arr):
	var code_blocks = FBA.get_children()
	code_blocks.pop_front()    # first 2 children aren't code blocks
	code_blocks.pop_front()
	
	var passed_check = true
	
	for i in range(0, code_blocks.size()):
		if code_blocks[i].name.rstrip("0123456789") != block_names_arr[i]:
			passed_check = false
			break
	
	return passed_check and code_blocks.size() == block_names_arr.size()