extends Node2D


onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")

var btn_pressed = false
var openDoorTexture = preload("res://Assets/Placeholders/Open_Door.png")

var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','R',' ','O','X','X','X','X',
	'X','X','X','X','O','B','D','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
]
var robotStartOrientation = PEP.Orientation.RIGHT

func _ready():
	PEP.loadLevel(tiles, robotStartOrientation, Grid, CodeBlockBar)


func _process(delta):
	if btn_pressed:
		get_node("Grid/Door/Sprite").set_texture(openDoorTexture)
		$AcceptDialog.popup()
		btn_pressed = false


func _on_Button_buttonPressed(name):
	btn_pressed = true
