extends Control


onready var Robot = get_node("../Grid/Robot")


# Called when the node enters the scene tree for the first time.
func _ready():
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
	var Scopes = get_node("../IDE/Scopes")
	for block in Scopes.get_children():
		PEP.IDEScopes.push_back(block.duplicate())

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
