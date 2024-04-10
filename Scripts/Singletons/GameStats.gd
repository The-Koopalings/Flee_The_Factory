extends Node

signal robotDied

#Keys: level paths (I.e. res://Scenes/Levels/Tutorial/blah)     
#Values: true if level is completed, false if not
var levelCompletion = {}

#Check if we should play tutorial (I.e. if player exits level without completing, won't replay tutorial automatically)
#Keys: level paths (like levelCompletion)     
#Values: true if should play tutorial, false otherwise (I.e. if level completed or re-entered after not completing)
var playTutorial = {}

#Used to instance SavableGameStats in order to save above levelCompletion + playTutorial
var savableGameStats

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

func _ready():
	savableGameStats = SavableGameStats.new()

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

func init_levelCompletion():
	for levelPath in SceneSwapper.scene_array:
		levelCompletion[levelPath] = false
		playTutorial[levelPath] = true

func set_level_completed(levelPath):
	levelCompletion[levelPath] = true
	playTutorial[levelPath] = false
#	save_GameStats()

func save_GameStats():
	savableGameStats.levelCompletion = self.levelCompletion
	savableGameStats.playTutorial = self.playTutorial
	
	var result = ResourceSaver.save("./save_data/GameStats.res", savableGameStats)
	if result != OK:
		printerr("GameStats didn't save correctly to ./save_data/GameStats.res")

