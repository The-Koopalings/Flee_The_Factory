extends Control


onready var Robot = get_node("../Grid/Robot")
var sceneRootName

# Called when the node enters the scene tree for the first time.
func _ready():
	$Help.connect("pressed", self, "_on_Help_pressed")
	
	# Update 2x speed button toggle after restarting scene to correctly indicate the saved speed
	if GameStats.savableGameStats.run_speed == 0.25:
		$DoubleSpeed.pressed = true
	else:
		$DoubleSpeed.pressed = false
	
	check_if_on_Start_Menu()


func check_if_on_Start_Menu():
	var root = get_tree().root
	sceneRootName = root.get_child(root.get_child_count() - 1).name
	
	if sceneRootName == "StartMenu":
		$Restart.visible = false
		$DoubleSpeed.visible = false
		$Help.visible = false


func _on_Settings_pressed():
	ButtonPress2.play()
	SettingsMenu.set_to_visible(sceneRootName)
	get_tree().paused = true


func _on_Restart_pressed():
	ButtonPress2.play()
	#Duplicate IDE sections to keep code blocks after Restart
	var Scopes = get_node("../IDE/Scopes")
	for container in Scopes.get_children():
		PEP.IDEScopes.push_back(container.duplicate())

	print("WAHOT", PEP.IDEScopes)
	var Error = get_tree().reload_current_scene()
	if Error != 0:
		printerr("Error encountered on pressing Restart button. Error code: ", Error)
	
	# Clear dialogue queue to remove duplicate dialogue
	DialogueManager.restart_dialogue()


func _on_DoubleSpeed_toggled(button_pressed):
#	AltButtonPress.play()
	if GameStats.is_executing():
		yield(Robot, "animationFinished")
	
	if button_pressed:
		GameStats.savableGameStats.run_speed = 0.25
	else:
		GameStats.savableGameStats.run_speed = 0.50


func _on_Help_pressed():
	ButtonPress2.play()
	var level = get_node("..")
	var root = get_tree().root
	
	if level.has_tutorial:
		#If there isn't anymore dialogue to display
		if DialogueManager.dialogue_queue.size() == 0:
			DialogueManager.restart_dialogue()
	#		level.TextBox.text_queue.clear()
			var levelPath = root.get_child(root.get_child_count() - 1).filename
			GameStats.savableGameStats.playTutorial[levelPath] = true
			DialogueManager.add_dialogue(level)
	else: #Will display generic help dialogue based on directory level is in
		var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
		#Gets name of folder directly above
		#I.e. directory = "Recursion" or directory = "Control_Flow"
		directory = directory.substr(20)
		DialogueManager.display_generic_dialogue(level, directory)
