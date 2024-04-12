extends Node

signal robotDied

#Used to instance SavableGameStats in order to save levelCompletion + playTutorial
#Reference res://Resources/SavableGameStats.gd for more info on levelCompletion & playTutorial variables
var savableGameStats

const saveFilePath = "user://GameStats.res" 

enum State{
	OUT_OF_LEVEL = -1,
	CODING = 0,
	EXECUTING = 1,
	PASSED = 2,
	TERMINATED = 3,
	
}

# Set code run speed for robot animations
# 0.50 is for normal and 0.25 is for double speed
var run_speed = 0.50

var game_state = State.OUT_OF_LEVEL

#func _ready():
#	savableGameStats = SavableGameStats.new()

func is_double_speed():
	return true if run_speed == 0.25 else false

func get_game_state():
	return game_state

func set_game_state(state):
	if State.values().has(state):
		game_state = state
		
func is_out_of_level():
	return (game_state == State.OUT_OF_LEVEL)
	
func is_coding():
	return (game_state == State.CODING)

func is_executing():
	return (game_state == State.EXECUTING)
	
func is_passed():
	return (game_state == State.PASSED)
	
func is_terminated():
	return (game_state == State.TERMINATED)

func kill_robot():
	#Game state changes to terminated
	game_state = State.TERMINATED
	
	# Emit signal to Robot and IDE
	emit_signal("robotDied")


#If save file exists, load in data from there, if not then initialize dicts in savableGameStats
func init_levelCompletion():
	#If file exists, load data from file
	if ResourceLoader.exists(saveFilePath):
		savableGameStats = ResourceLoader.load(saveFilePath)
		if !savableGameStats:
			printerr("Loaded in savableGameStats is null")
	else:
		savableGameStats = SavableGameStats.new()
		for key in SceneSwapper.scene_order:
			var levelPath = SceneSwapper.scene_path[key]
			savableGameStats.levelCompletion[levelPath] = false
			savableGameStats.playTutorial[levelPath] = true

func set_level_completed(levelPath):
	savableGameStats.levelCompletion[levelPath] = true
	savableGameStats.playTutorial[levelPath] = false
	save_GameStats()

#Only activates upon level completion 
func save_GameStats():
	var result = ResourceSaver.save(saveFilePath, savableGameStats)
	if result != OK:
		printerr("GameStats didn't save correctly to ", saveFilePath)

