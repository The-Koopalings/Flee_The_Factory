extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Update 2x speed button toggle after restarting scene to correctly indicate the saved speed
	if GameStats.run_speed == 0.25:
		$DoubleSpeed.pressed = true
	else:
		$DoubleSpeed.pressed = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Settings_pressed():
	$Settings/PopupDialog.popup()


func _on_Restart_pressed():
	var Error = get_tree().reload_current_scene()
	if Error != 0:
		printerr("Error encountered on pressing Restart button. Error code: ", Error)
	
	# Clear dialogue queue to remove duplicate dialogue
	DialogueManager.clear_dialogue_queue()


func _on_DoubleSpeed_toggled(button_pressed):
	if button_pressed:
		GameStats.run_speed = 0.25
	else:
		GameStats.run_speed = 0.50
