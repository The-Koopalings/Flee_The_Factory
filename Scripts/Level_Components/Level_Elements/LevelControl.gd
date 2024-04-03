extends Control


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
	var IDE = get_node("../IDE")
#	for block in IDE.get_children():
#		if block.name == "Run_Button":
#			continue
#		var FBA
#		if block.name.rstrip("0123456789") == "If":
#			FBA = block.get_node("If/FunctionBlockArea")
##			code.push_back(null)
##			for elseCode in block.get_node("Else/FunctionBlockArea").get_children():
##				if elseCode.name != "CollisionShape2D" or elseCode.name != "ColorRect":
##					code.push_back(elseCode)
#		elif block.name.rstrip("0123456789") == "Loop":
#			FBA = block.get_node("HighlightControl/FunctionBlockArea")
#		else:
#			FBA = block.get_node("FunctionBlockArea")
#
#		var dupeCode = []
#		for code in FBA.get_children():
#			if code.name == "CollisionShape2D" or code.name == "ColorRect":
#				continue
#			dupeCode.push_back(code.duplicate())
#
#		#if If statement, then push in Else block's code
#		if block.name.rstrip("0123456789") == "If":
#			FBA = block.get_node("Else/FunctionBlockArea")
#			dupeCode.push_back(null)
#			for code in FBA.get_children():
#				if code.name == "CollisionShape2D" or code.name == "ColorRect":
#					continue
#				dupeCode.push_back(code.duplicate())
#
##		if PEP.codeBlocks.keys().has(block.name):
##			PEP.codeBlocks[block.name].push_back(dupeCode)
##		else:
#		PEP.codeBlocks[block.name] = dupeCode
#		print(PEP.codeBlocks[block.name])
	for block in IDE.get_children():
		PEP.IDEChildren.push_back(block.duplicate())
	print(PEP.IDEChildren)
	var Error = get_tree().reload_current_scene()
	if Error != 0:
		printerr("Error encountered on pressing Restart button. Error code: ", Error)
	
	# Clear dialogue queue to remove duplicate dialogue
	DialogueManager.restart_dialogue()


func _on_DoubleSpeed_toggled(button_pressed):
	if button_pressed:
		GameStats.run_speed = 0.25
	else:
		GameStats.run_speed = 0.50
