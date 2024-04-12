extends Node2D

var levelCompletedTheme = load("res://Themes/LevelCompletedButton.tres")
var levelUncompletedTheme = load("res://Themes/LevelUncompletedButton.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stages()
	

#Setup function where it calls set_windows on all stage buttons in the scene
func set_stages():
	#Each numLevels' element is the number of levels for the stage at the same index in var stages
	var numLevels = []
	var stages = get_children()
	stages.erase($BackButton)
	
	#To be put into numLevels, keeps track of how many levels per stage
	var levelCount = 0
	#Keeps track of which index we're on in stages & numLevels
	var i = 0
	
	#Works only if scene_order has the levels stored in correct the stage order
	for key in SceneSwapper.scene_order:
		if key.begins_with(stages[i].name.replace("Button", "")):
			levelCount += 1
		else:
			numLevels.push_back(levelCount)
			#Assumes that this key is a level in the next stage for sure (should be the case)
			levelCount = 1 
			i += 1
	
	#The last stage's levelCount won't be pushed into numLevels in the for loop, so we need this
	if numLevels.size() < stages.size():
		numLevels.push_back(levelCount)
	
	#Add appropriate number of windows (Panels) as children to the Stage button + set their themes
	i = 0
	for stage in stages:
		set_windows(stage, numLevels[i])
		i += 1
	

#Adds windows based on how many levels there are in the stage, yellow if level is completed, gray if not
func set_windows(stage, levelCount):
	var stageName = stage.name.replace("Button", "")
	var windowSize = Vector2(75, 75)
	var posx = 50
	var posy = 15
	
	for i in range(1, levelCount + 1):
		#Set position & size of window
		var window = Panel.new()
		window.set_position(Vector2(posx + (100 * (i - 1)), posy))
		window.set_size(windowSize)
		
		#Set theme/color of window
		var levelPath = SceneSwapper.scene_path[stageName + " " + str(i)]
		if GameStats.savableGameStats.levelCompletion[levelPath]:
			window.set_theme(levelCompletedTheme)
		else:
			window.set_theme(levelUncompletedTheme)
		
		stage.add_child(window)
	

func _on_FunctionsButton_pressed():
	SceneSwapper.change_scene("Functions Select")


func _on_RecursionButton_pressed():
	SceneSwapper.change_scene("Recursion Select")


func _on_ControlFlowButton_pressed():
	SceneSwapper.change_scene("Control_Flow Select")


func _on_DataStructuresButton_pressed():
	SceneSwapper.change_scene("Data_Structures Select")


func _on_TutorialButton_pressed():
	SceneSwapper.change_scene("Tutorial Select")


func _on_BackButton_pressed():
	SceneSwapper.change_scene("Start Menu")
