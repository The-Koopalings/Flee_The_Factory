extends Node2D

onready var grid = get_node("../") #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var tile_size = grid.tile_size
var openDoorTexture = preload("res://Assets/Open_Door.png")
var tileX
var tileY


# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("interact", self, "_on_ProofOfConcept_openDoor")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ProofOfConcept_openDoor():
	get_node("Sprite").set_texture(openDoorTexture)
	print("OPEN DOOR")
