extends Node2D

#Gets grid, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY

var openDoorTexture = preload("res://Assets/Placeholders/Open_Door.png")


func _ready():
	$Highlight.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_level_levelComplete():
	$Sprite.set_texture(openDoorTexture)
	
	#Rescale since placeholder texture is too big (b/c the door texture is tiny and needs to be scaled
	$Sprite.set_scale(Vector2(1,1)) 
