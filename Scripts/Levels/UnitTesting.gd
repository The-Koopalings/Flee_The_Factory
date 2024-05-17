extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	var nodes = get_children()
	for node in nodes:
		if node.get_script() != null:
			node._ready()
			nodes.append_array(node.get_children())



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
