extends Node


var scene_path = {"Start Menu": "res://Scenes/Start_Menu/StartMenu.tscn",
				  "Credits": "res://Scenes/Credits/Credits.tscn",
				  "Stage Select": "res://Scenes/Stage_Select/StageSelect.tscn",
				  "Tutorial Select": "res://Scenes/Stage_Select/TutorialSelect.tscn",
				  "Functions Select": "res://Scenes/Stage_Select/FunctionsSelect.tscn",
				  "Recursion Select": "res://Scenes/Stage_Select/RecursionSelect.tscn",
				  "Control_Flow Select": "res://Scenes/Stage_Select/ControlFlowSelect.tscn",
				  "Data_Structures Select": "res://Scenes/Stage_Select/DataStructuresSelect.tscn",}

var scene_array = []

const X_START = 110
const Y_START = 300
const X_SPACE = 300
const Y_SPACE = 300

var current_scene = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	init_scenes()
	#Put it here instead of GameStats _ready() so scene_array will definitely be initialized
	GameStats.init_levelCompletion()


func change_scene(scene_name):
	# This function will usually be called from a signal callback or some other function in the current scene.
	# Deleting the current scene at this point is a bad idea because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time 
	# when we can be sure that no code from the current scene is running:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	call_deferred("_deferred_change_scene", scene_name)


func _deferred_change_scene(scene_name):
	var scene
	
	# It is now safe to remove the current scene
	current_scene.free()
	
	#Clear dialogue queue
	DialogueManager.restart_dialogue()
	
	# Load the new scene.
	if scene_path.has(scene_name):
		var path = scene_path[scene_name]
		scene = ResourceLoader.load(path)
	else:
		scene = ResourceLoader.load(scene_name)

	# Instance the new scene.
	current_scene = scene.instance()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().current_scene = current_scene


func init_buttons(level_select):
	load_lvl_buttons(level_select)
	load_back_button(level_select)


func load_back_button(level_select):
	var back_btn = level_select.get_node("BackButton")
	back_btn.connect("pressed", level_select, "_on_BackButton_pressed")


func load_lvl_buttons(level_select):
	var completedTheme = load("res://Scenes/Stage_Select/LevelCompletedButton.tres")
	var stage_type = level_select.name.replace("Select", "")
	var btn_nodes = get_tree().get_nodes_in_group("level_buttons")
	var btn_count = 0
	
	var x_pos = X_START
	var y_pos = Y_START
	
	for btn in btn_nodes:
		#Set button color
		var level_number = btn.text
		var scene_key = stage_type + " " + level_number
		var level_path = scene_path[scene_key]
		#If the level is complete, then change button theme (only changes normal texture right now)
		if GameStats.levelCompletion[level_path]:
			btn.set_theme(completedTheme)
			
		#Set button position
		btn.rect_position = Vector2(x_pos, y_pos)
		btn_count += 1
		
		x_pos += X_SPACE
		
		if btn_count % 6 == 0:
			x_pos = X_START
			y_pos += Y_SPACE


func change_to_level_scene(level_select, button_name):
	var stage_type = level_select.name.replace("Select", "")
	var level_number = button_name.replace("Button", "")
	var scene_key = stage_type + " " + level_number
	
	change_scene(scene_key)


func init_scenes():
	scene_array.clear()
	
	# Call in this order because it matters for the scene_array
	load_file_contents("res://Scenes/Levels/Tutorial")
	load_file_contents("res://Scenes/Levels/Functions")
	load_file_contents("res://Scenes/Levels/Recursion")
	load_file_contents("res://Scenes/Levels/Control_Flow")
	load_file_contents("res://Scenes/Levels/Data_Structures")


func load_file_contents(path):
	var dir = Directory.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		# For the scene_path dict key
		var level_num = 1
		
		while file_name != "":
			if !dir.current_is_dir():
				var file_path = path + "/" + file_name
				
				# Add to scene_array for next level flow
				scene_array.push_back(file_path)
				
				# Add to scene_path dictionary
				var key = path.replace("res://Scenes/Levels/", "") + " " + str(level_num)
				scene_path[key] = file_path
				
				level_num += 1
			
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: ", path)


func change_to_next_level_scene(old_scene):
	var index = scene_array.find(old_scene, 0) + 1
	
	# Last level should not go back to first tutorial level (index = scene_array.size() if next scene isn't found)
	if index < scene_array.size():
		var scene_path = scene_array[index]
		change_scene(scene_path)
