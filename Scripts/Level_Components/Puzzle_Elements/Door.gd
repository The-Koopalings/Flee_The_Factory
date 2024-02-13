extends Node2D

#Gets grid, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY

var openDoorTexture = preload("res://Assets/Placeholders/Open_Door.png")


func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ProofOfConcept_openDoor():
	get_node("Sprite").set_texture(openDoorTexture)
