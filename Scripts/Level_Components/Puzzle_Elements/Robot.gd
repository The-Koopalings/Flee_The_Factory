extends KinematicBody2D

onready var grid = get_node("../") #Gets puzzle, which should be the immediate parent for any puzzle elements
onready var ray = $RayCast2D
onready var tile_size = grid.tile_size
onready var grid_x = grid.grid_x
onready var grid_y = grid.grid_y
var tileX
var tileY
var tileXMax = 10 #change once we settle on what this should be
var tileYMax = 6  #change once we settle on what this should be

signal interact(tileX, tileY)

# NOTE: This may be changed depending on level
var startPosition = Vector2(200, 200)


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
	# Round robot position to nearest tile
	#position = startPosition
	# Add half a tile size to center robot on tile
	#position += Vector2.ONE * tile_size/2
	pass
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

# Change position based on movement direction
func move(dir):
	var vector_position = inputs[dir] * tile_size
	
	# Check if there is an obstacle in the direction of the robot's movement
	ray.cast_to = vector_position
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		position += vector_position
	
	# Clamp position to window
	position.x = clamp(position.x, 200 +  tile_size/2, grid_x - tile_size/2)
	position.y = clamp(position.y, 200 + tile_size/2, grid_y - tile_size/2)



func _on_Forward_forwardSignal():
	var orientation = int(rotation * 2 / PI) % 4
	if orientation < 0:
		orientation += 4
	#print("Rotation: " + str(rotation) + " || Orientation: " + str(orientation))
	if orientation == Orientation.UP:
		#Play animation, if can't move, play animation anyways
		
		#Move robot
		if tileY > 0:
			tileY -= 1
			move("ui_up")

	elif orientation == Orientation.LEFT:
		if tileX > 0:
			tileX -= 1
			move("ui_left")
			
	elif orientation == Orientation.DOWN:
		if tileY < tileYMax:
			tileY += 1
			move("ui_down")
			
	elif orientation == Orientation.RIGHT:
		if tileX < tileXMax:
			tileX += 1
			move("ui_right")


func _on_RotateLeft_rotateLeftSignal():
	rotation -= PI/2
	var orientation = int(rotation * 2 / PI) % 4
	if orientation < 0:
		orientation += 4
	print("Rotation: " + str(rotation) + " || Orientation: " + str(orientation))

func _on_RotateRight_rotateRightSignal():
	rotation += PI/2
	var orientation = int(rotation * 2 / PI) % 4
	if orientation < 0:
		orientation += 4
	print("Rotation: " + str(rotation) + " || Orientation: " + str(orientation))

func _on_Interact_interactSignal():
	emit_signal("interact", tileX, tileY)
