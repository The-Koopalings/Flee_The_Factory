extends Area2D

#Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY
var color #R = red, G = green, B = blue


func _ready():
	color = name.substr(3, 1)
	match color:
		"R":
			$Sprite.set_texture(load("res://Assets/Objects/Red_Key.png"))
		"G":
			$Sprite.set_texture(load("res://Assets/Objects/Green_Key.png"))
		"B":
			$Sprite.set_texture(load("res://Assets/Objects/Blue_Key.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
