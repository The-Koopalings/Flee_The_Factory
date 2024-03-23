extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var ui_dir = ["ui_up", "ui_down", "ui_left", "ui_right"]
	for dir in ui_dir:
		print($Grid/Robot.get_object_in_direction(dir))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
