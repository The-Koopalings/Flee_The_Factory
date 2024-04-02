extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var num = name.substr(6, -1)
	text = num
	
	add_to_group("level_buttons")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
