extends Control

# Get run speed for code blocks
onready var IDE = get_node("../IDE")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_DoubleSpeed_toggled(button_pressed):
	if button_pressed:
		IDE.run_speed = 0.25
	else:
		IDE.run_speed = 0.50
