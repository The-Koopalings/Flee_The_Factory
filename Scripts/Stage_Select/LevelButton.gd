extends Button


onready var level_select = get_node("../")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add number to button's text
	text = name.substr(6, -1)
	
	# Group level buttons together for easier way to get all level button nodes
	add_to_group("level_buttons")
	
	connect("pressed", level_select, "_on_LevelButton_pressed", [name])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
