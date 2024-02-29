extends Node


# Loads dialogue from a text file
func load_dialogue(file_path, dialogue_queue):
	var path_to_dialogue = "res://Scripts/Dialogue/"
	
	var file = File.new()
	file.open(path_to_dialogue + file_path, file.READ)
	
	while !file.eof_reached():
		var line = file.get_line()
		dialogue_queue.push_back(line)
	
	file.close()


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
