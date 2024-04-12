extends Control


onready var Robot = get_node("../Grid/Robot")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Help.connect("pressed", self, "_on_Help_pressed")
	
	# Update 2x speed button toggle after restarting scene to correctly indicate the saved speed
	if GameStats.run_speed == 0.25:
		$DoubleSpeed.pressed = true
	else:
		$DoubleSpeed.pressed = false
	

func _on_Settings_pressed():
	SettingsMenu.visible = true
	get_tree().paused = true


func _on_Restart_pressed():
	#Duplicate IDE sections to keep code blocks after Restart
	var IDE = get_node("../IDE")
	for block in IDE.get_children():
		PEP.IDEChildren.push_back(block.duplicate())

	var Error = get_tree().reload_current_scene()
	if Error != 0:
		printerr("Error encountered on pressing Restart button. Error code: ", Error)
	
	# Clear dialogue queue to remove duplicate dialogue
	DialogueManager.restart_dialogue()


func _on_DoubleSpeed_toggled(button_pressed):
	if GameStats.is_executing():
		yield(Robot, "animationFinished")
	
	if button_pressed:
		GameStats.run_speed = 0.25
	else:
		GameStats.run_speed = 0.50


func _on_Help_pressed():
	var level = get_node("..")
	var root = get_tree().root
	
	if level.has_tutorial:
		#If there isn't anymore dialogue to display
		if DialogueManager.dialogue_queue.size() == 0:
			DialogueManager.restart_dialogue()
	#		level.TextBox.text_queue.clear()
			var levelPath = root.get_child(root.get_child_count() - 1).filename
			GameStats.savableGameStats.playTutorial[levelPath] = true
			DialogueManager.add_dialogue(level, level.textPath)
	else: #Will display generic help dialogue based on directory level is in
		var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
		#Gets name of folder directly above
		#I.e. directory = "Recursion" or directory = "Control_Flow"
		directory = directory.substr(20)
		DialogueManager.display_generic_dialogue(level, directory)
