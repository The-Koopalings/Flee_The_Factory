extends Node

signal robotDied

var levelCompletion = {}

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
	# -Game state changes to terminated
	game_state = State.TERMINATED
	
	# Emit signal to Robot and IDE
	emit_signal("robotDied")

func init_levelCompletion():
	for levelPaths in SceneSwapper.scene_array:
		levelCompletion[levelPaths] = false
#	print(levelCompletion)

