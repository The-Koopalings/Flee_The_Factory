extends Area2D

#Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY
var color #R = red, G = green, B = blue


func _ready():
	set_color()
	$Highlight.visible = false
	

func set_color():
	color = name.substr(3, 1)
	match color:
		"R":
			$Sprite.set_texture(load("res://Assets/Objects/Keys/red_key.png"))
		"G":
			$Sprite.set_texture(load("res://Assets/Objects/Keys/green_key.png"))
		"B":
			$Sprite.set_texture(load("res://Assets/Objects/Keys/blue_key.png"))

