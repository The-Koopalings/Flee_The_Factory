extends Node2D


onready var Grid = get_node("Grid")
onready var CodeBlockBar = get_node("CodeBlockBar")

var b1_pressed = false
var b2_pressed = false
var openDoorTexture = preload("res://Assets/Placeholders/Open_Door.png")

var tiles = [
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','R','O','D','X','X','X','X',
	'X','X','X','X',' ','O','B','X','X','X','X',
	'X','X','X','X','B',' ',' ','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
	'X','X','X','X','X','X','X','X','X','X','X',
]


func _ready():
	PEP.loadLevel(tiles, Grid, CodeBlockBar)

func _process(delta):
	if b1_pressed and b2_pressed:
		get_node("Grid/Door/Sprite").set_texture(openDoorTexture)
		$AcceptDialog.popup()
		b1_pressed = false
		b2_pressed = false


func _on_Button1_buttonPressed(name):
	b1_pressed = true


func _on_Button2_buttonPressed(name):
	b2_pressed = true
