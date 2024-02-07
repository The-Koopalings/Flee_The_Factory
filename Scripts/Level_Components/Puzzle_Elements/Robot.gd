extends KinematicBody2D

 #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../")

onready var tile_size = grid.tile_size
onready var grid_x = grid.grid_x
onready var grid_y = grid.grid_y
var tileX
var tileY
export var tileXMax = 10 #change once we settle on what this should be
export var tileYMax = 6  #change once we settle on what this should be

# startPosition is now set by the Level
#var startPosition = Vector2(200, 200)

signal interact(tileX, tileY)


#Used for dictating movement
onready var ray = $RayCast2D

# Map input action names to the appropriate vectors
# For now, use arrow keys as input
var inputs = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}

enum Orientation{
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

func _ready():
	pass
	
#Event handler for movement via keyboard	
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

# Controls movement of the robot
func move(dir):
	var vector_position = inputs[dir] * tile_size
	
	# Check if there is an obstacle in the direction of the robot's movement
	ray.cast_to = vector_position
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		position += vector_position
		
		#Update grid coordinates
		match dir:
			"ui_right":
				tileX += 1
			"ui_left":
				tileX -= 1
			"ui_down":
				tileY += 1
			"ui_up":
				tileY -= 1
	
	# Clamp position to window
	position.x = clamp(position.x, 200 +  tile_size/2, grid_x - tile_size/2)
	position.y = clamp(position.y, 200 + tile_size/2, grid_y - tile_size/2)
	tileX = clamp(tileX, 0, tileXMax)
	tileY = clamp(tileY, 0, tileYMax)


#Forward
func _on_Forward_forwardSignal():
	#Get orientation of the robot
	var orientation
	if rotation >= 0:
		orientation = int((rotation_degrees+1) / 90) % 4
	elif rotation < 0:
		orientation = int((rotation_degrees-1) / 90) % 4
		orientation += 4 if orientation != 0 else 0
	
	#Move forwards based on robot orientation
	match orientation:
		Orientation.UP:
			move("ui_up")
			
		Orientation.LEFT:
			move("ui_left")
			
		Orientation.DOWN:
			move("ui_down")
			
		Orientation.RIGHT:
			move("ui_right")

#RotateLeft
func _on_RotateLeft_rotateLeftSignal():
	rotation -= PI/2

#RotateRight
func _on_RotateRight_rotateRightSignal():
	rotation += PI/2

#Interact
func _on_Interact_interactSignal():
	emit_signal("interact", tileX, tileY)
