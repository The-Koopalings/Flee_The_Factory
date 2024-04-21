extends AudioStreamPlayer

var inCredits = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if !GameStats.is_out_of_level() and !playing and !inCredits:
		play()
	elif GameStats.is_out_of_level() or inCredits:
		stop()
