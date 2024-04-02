extends Node


var scene_path = {"Start Menu": "res://Scenes/Start_Menu/StartMenu.tscn",
				  "Credits": "res://Scenes/Credits/Credits.tscn",
				  "Stage Select": "res://Scenes/Stage_Select/StageSelect.tscn",
				  "Tutorial Select": "res://Scenes/Stage_Select/TutorialSelect.tscn",
				  "Functions Select": "res://Scenes/Stage_Select/FunctionsSelect.tscn",
				  "Recursion Select": "res://Scenes/Stage_Select/RecursionSelect.tscn",
				  "Control_Flow Select": "res://Scenes/Stage_Select/ControlFlowSelect.tscn",
				  "Data_Structures Select": "res://Scenes/Stage_Select/DataStructuresSelect.tscn",
				  "Tutorial 1": "res://Scenes/Levels/Tutorial/1 - Game Intro.tscn",
				  "Tutorial 2": "res://Scenes/Levels/Tutorial/2 - Rotations & Obstacles.tscn",
				  "Tutorial 3": "res://Scenes/Levels/Tutorial/3 - Multiple Buttons.tscn",
				  "Func 1": "res://Scenes/Levels/Functions/1 - Functions Intro.tscn",
				  "Func 2": "res://Scenes/Levels/Functions/2 - L Shape.tscn",
				  "Func 3": "res://Scenes/Levels/Functions/3 - Multi Func Intro.tscn",}


# Modify as we add more levels to the different stages
var stage_level_count = {"Tutorial": 3,
						 "Functions": 3,
						 "Recursion": 2,
						 "Control_Flow": 0,
						 "Data_Structures": 4}


const X_START = 110
const Y_START = 300
const X_SPACE = 300
const Y_SPACE = 300

var current_scene = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


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
	# It is now safe to remove the current scene
	current_scene.free()
	
	#Clear dialogue queue
	DialogueManager.restart_dialogue()
	
	# Load the new scene.
	var path = scene_path[scene_name]
	var scene = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = scene.instance()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().current_scene = current_scene


func load_lvl_buttons(level_select):
	var btn_nodes = level_select.get_children()
	var btn_count = 0
	
	# Pop the first 3 nodes -> not level buttons
	btn_nodes.pop_front()
	btn_nodes.pop_front()
	btn_nodes.pop_front()
	
	var x_pos = X_START
	var y_pos = Y_START
	
	for btn in btn_nodes:
		btn.rect_position = Vector2(x_pos, y_pos)
		btn_count += 1
		
		print(btn.rect_position)
		
		x_pos += X_SPACE
		
		if btn_count % 6 == 0:
			x_pos = X_START
			y_pos += Y_SPACE
