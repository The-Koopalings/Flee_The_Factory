extends KinematicBody2D

 #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var grid = get_node("../")

onready var tile_size = grid.tile_size
onready var start_x = grid.start_x
onready var start_y = grid.start_y
onready var end_x = grid.end_x
onready var end_y = grid.end_y
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
	position.x = clamp(position.x, start_x +  tile_size/2, end_x - tile_size/2)
	position.y = clamp(position.y, start_y + tile_size/2, end_y - tile_size/2)
	tileX = clamp(tileX, 0, tileXMax)
	tileY = clamp(tileY, 0, tileYMax)


#Forward
func _on_Forward_forwardSignal():
	move(get_direction())

#RotateLeft
func _on_RotateLeft_rotateLeftSignal():
	$Sprite.rotation -= PI/2

#RotateRight
func _on_RotateRight_rotateRightSignal():
	$Sprite.rotation += PI/2

#Interact
func _on_Interact_interactSignal():
	emit_signal("interact", tileX, tileY)
	

#fromWhere can be "Front", "Back", "Left", or "Right"
func get_direction(fromWhere: String = "Front"):
	var orientation
	if $Sprite.rotation >= 0:
		orientation = int(($Sprite.rotation_degrees+1) / 90) % 4
	elif $Sprite.rotation < 0:
		orientation = int(($Sprite.rotation_degrees-1) / 90) % 4
		orientation += 4 if orientation != 0 else 0
	
	#up = 0, right = 1, down = 2, left = 3
	if fromWhere == "Back":
		orientation = (orientation + 2) % 4
	elif fromWhere == "Left":
		orientation = (orientation + 3) % 4
	elif fromWhere == "Right":
		orientation = (orientation + 1) % 4
	
	#Return direction to move in/detect objects in, based on Robot orientation
	match orientation:
		PEP.Orientation.UP:
			return "ui_up"
			
		PEP.Orientation.LEFT:
			return "ui_left"
			
		PEP.Orientation.DOWN:
			return "ui_down"
			
		PEP.Orientation.RIGHT:
			return "ui_right"


#Returns the object/node in the specified direction of the Robot
func get_object_in_direction(dir: String):
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	if ray.is_colliding():
#		print(ray.get_collider())
		return ray.get_collider()
	else:
		return null
