extends Node2D

#Gets grid, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY
var color

var openDoorTexture = preload("res://Assets/Objects/Doors/finalDoor_open.png")


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
			$Sprite.set_texture(load("res://Assets/Objects/Doors/redDoor.png"))
			$Sprite.set_scale(Vector2(0.85,0.85))
		"G":
			$Sprite.set_texture(load("res://Assets/Objects/Doors/greenDoor.png"))
			$Sprite.set_scale(Vector2(0.85,0.85))
		"B":
			$Sprite.set_texture(load("res://Assets/Objects/Doors/blueDoor.png"))
			$Sprite.set_scale(Vector2(0.85,0.85))
		_:
			color = ""
	

func _on_level_levelComplete():
	#Only applicable to exit door, prevents unopened doors to change texture upon level completion
	if color == "":
		$SoundUnlock.play()
		$Sprite.set_texture(openDoorTexture)
		get_node("WCLs").visible = false
	
		var root = get_tree().root
		var levelPath = root.get_child(root.get_child_count() - 1).filename
		GameStats.set_level_completed(levelPath)
		
		#Make sure For loop's i increments properly, only if the last code block in the loop opened the exit door
		var IDE = get_node(PEP.get_path_to_grandpibling(self, "IDE"))
		if IDE.is_loop() and IDE.code.size() == 0:
			IDE.currentNode.increment_loopCount()
	
		#Rescale since placeholder texture is too big (b/c the door texture is tiny and needs to be scaled
		$Sprite.set_scale(Vector2(1,1)) 
