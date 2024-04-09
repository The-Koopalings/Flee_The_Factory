extends Node2D

#Gets grid, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY
var color

var openDoorTexture = preload("res://Assets/Miscalleous/completion.png")


func _ready():
	set_color()
	$Highlight.visible = false


func set_color():
	if name.length() > 4:
		color = name.substr(4, 1)
	else:
		color = ""
	
	match color:
		"R":
			$Sprite.set_texture(load("res://Assets/Placeholders/Red_Door.png"))
			$Sprite.set_scale(Vector2(0.25,0.25))
		"G":
			$Sprite.set_texture(load("res://Assets/Placeholders/Green_Door.png"))
			$Sprite.set_scale(Vector2(0.25,0.25))
		"B":
			$Sprite.set_texture(load("res://Assets/Placeholders/Blue_Door.png"))
			$Sprite.set_scale(Vector2(0.25,0.25))
		_:
			color = ""
	

func _on_level_levelComplete():
	$Sprite.set_texture(openDoorTexture)
	get_node("WCLs").visible = false
	
	var root = get_tree().root
	var level_path = root.get_child(root.get_child_count() - 1).filename
	GameStats.levelCompletion[level_path] = true
	
	#Rescale since placeholder texture is too big (b/c the door texture is tiny and needs to be scaled
	$Sprite.set_scale(Vector2(1,1)) 
