extends Area2D

#Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../") 

onready var tile_size = grid.tile_size
var tileX
var tileY

signal buttonPressed(name)

# startPosition is now set by the Level
# var startPosition = Vector2(1100,700)

func _ready():
	$Highlight.visible = false
	$AnimationPlayer.play("Stable")

func _on_Robot_interact(x, y):
	if x == tileX and y == tileY:
		$SoundPressed.play()
		$AnimationPlayer.play("Interact")
		emit_signal("buttonPressed", name)
