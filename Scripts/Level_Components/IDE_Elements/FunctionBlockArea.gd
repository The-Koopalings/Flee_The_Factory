extends Area2D

var CodeBlock = null
#Load CodeBlock objects
var PathToCodeBlocks = "res://Scenes/Level_Components/Code_Blocks/"
var Template = load(PathToCodeBlocks + "CodeBlock.tscn")
var Forward = load(PathToCodeBlocks + "Forward.tscn")
var RotateLeft = load(PathToCodeBlocks + "RotateLeft.tscn")
var RotateRight = load(PathToCodeBlocks + "RotateRight.tscn")
var Interact  = load(PathToCodeBlocks + "Interact.tscn")
onready var counter = get_node("../Counter")

var numBlocks = 0
var rowSize = 7
var blockSize = 60 #Replace with actual codeblock size
var xOffset = 30
var yOffset = 30

#Issues with creating code block instances and it triggering area_exit automatically
#This is so newly instanced code blocks won't be deleted on entering the scene tree
var justCreated = false 
var removeChild = false
var child = null

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Area2D enters a function area
func _on_FunctionBlockArea_area_entered(area):
	if CodeBlock == null:
		CodeBlock = area
		
	
#Area2D leaves a function area
func _on_FunctionBlockArea_area_exited(area):
	CodeBlock = null
	#Remove code block from IDE
	var children = get_children()
	for childNode in children:
		if childNode.name == "ColorRect" or childNode.name == "CollisionShape2D":
			continue
		if childNode.name == area.name and !justCreated:
			child = childNode
			removeChild = true
	justCreated = false
	
	
#Something is dropped in function area
func _on_FunctionBlockArea_input_event(viewport, event, shape_idx):
	#If event was a drop
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT and !event.pressed):
		child = null
		#Check for valid codeblock & instance code block
		if CodeBlock:
			match CodeBlock.name:
				"Forward":
					child = Forward.instance()
				"RotateLeft":
					child = RotateLeft.instance()
				"RotateRight":
					child = RotateRight.instance()
				"Interact":
					child = Interact.instance()
		#Add codeblock node to tree
		if child and numBlocks < counter.maxBlocks:
			var x = xOffset + blockSize * (numBlocks%rowSize)
			var y = yOffset + blockSize * int(numBlocks/rowSize)
			child.position = Vector2(x, y)
			numBlocks += 1
			add_child(child, true)
			justCreated = true
			counter.display(numBlocks)
			
		#print("DROPPED " + CodeBlock.name + " in " + name)


#Remove code blocks once player releases left mouse button
func stop_drag(globalPos):
	if child and removeChild and child.get_child(2).startPos == globalPos:
		child.queue_free() 
		removeChild = false
		child = null
		numBlocks -= 1
		counter.display(numBlocks)
		
