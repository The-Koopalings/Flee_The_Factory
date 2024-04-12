extends Node2D

var levelCompletedTheme = load("res://Themes/LevelCompletedButton.tres")
var levelUncompletedTheme = load("res://Themes/LevelUncompletedButton.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stages()
	

#Calls set_windows() on all stage buttons in the scene
func set_stages():
	var stages = get_children()
	stages.erase($BackButton)
	
	for stage in stages:
		var stageName = stage.name.replace("Button", "")
		set_windows(stage, SceneSwapper.stageLevelCounts[stageName])
	

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
