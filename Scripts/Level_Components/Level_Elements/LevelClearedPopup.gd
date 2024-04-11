extends CanvasLayer


onready var level = get_node("../")


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Next_Level_pressed():
	var root = get_tree().root
	var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
	directory = directory.substr(20)
	
	var level_num = level.name.get_slice(" ", 0)
	
	SceneSwapper.change_to_next_level_scene(directory + " " + level_num)


func _on_Exit_Level_pressed():
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	
	var root = get_tree().root
	var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
	directory = directory.substr(20)
	
	SceneSwapper.change_scene(directory + " Select")
