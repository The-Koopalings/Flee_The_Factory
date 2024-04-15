extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if GameStats.is_out_of_level() and !playing:
		play()
	elif !GameStats.is_out_of_level():
		stop()
