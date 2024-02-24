extends Area2D

var CodeBlock = null
#Load CodeBlock objects
var PathToCodeBlocks = "res://Scenes/Level_Components/Code_Blocks/"
var Template = load(PathToCodeBlocks + "CodeBlock.tscn")
var Forward = load(PathToCodeBlocks + "Forward.tscn")
var RotateLeft = load(PathToCodeBlocks + "RotateLeft.tscn")
var RotateRight = load(PathToCodeBlocks + "RotateRight.tscn")
var Interact  = load(PathToCodeBlocks + "Interact.tscn")
var F1 = load(PathToCodeBlocks + "CallFunction1.tscn")
var F2 = load(PathToCodeBlocks + "CallFunction2.tscn")
var If1 = load(PathToCodeBlocks + "If1.tscn")
var If2 = load(PathToCodeBlocks + "If2.tscn")
onready var counter = get_node("../Counter")

var numBlocks = 0
var rowSize = 7
var blockSize = 60 #Replace with actual codeblock size
var xOffset = 30
var yOffset = 30

#To prevent removing a code block if it was dragged out of FBA, but dragged and dropped back into FBA
var removeChild = false
var child = null

onready var highlight = get_node("../Highlight")

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Area2D enters a function area
func _on_FunctionBlockArea_area_entered(area):
	if area.name != "CodeBlock":
		CodeBlock = area
	#Prevent blocks from being removed when it is dropped inside IDE after briefly exiting
	removeChild = false
		
	
#Area2D leaves a function area
func _on_FunctionBlockArea_area_exited(area):
	CodeBlock = null
	#Check if targetNode is a child of the grid
	var targetNode = get_node(area.name)
	if targetNode == null:
		return
	
	#If so, prepare to remove it
	child = targetNode
	removeChild = true
	


#Something is dropped in function area
func _on_FunctionBlockArea_input_event(viewport, event, shape_idx):
	#If event was a drop
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT and !event.pressed):
		add_block()
	


func _on_CodeBlock_doubleClick(code_block):
	if highlight.visible:
		CodeBlock = code_block
		add_block()


# Helper function to add a code block into FunctionBlockArea
func add_block():
	child = null
	#Check for valid codeblock & instance code block
	if CodeBlock and CodeBlock.get_child(2) and !CodeBlock.get_child(2).inFBA:
		match CodeBlock.name:
			"Forward":
				child = Forward.instance()
			"RotateLeft":
				child = RotateLeft.instance()
			"RotateRight":
				child = RotateRight.instance()
			"Interact":
				child = Interact.instance()
			"F1_":
				child = F1.instance()
			"F2_":
				child = F2.instance()
			"If1_":
				child = If1.instance()
			"If2_":
				child = If2.instance()
		#Add codeblock node to tree
	if child and numBlocks < counter.maxBlocks:
		var x = xOffset + blockSize * (numBlocks % rowSize)
		var y = yOffset + blockSize * int(numBlocks / rowSize)
		child.position = Vector2(x, y)
		numBlocks += 1
		child.get_child(2).inFBA = true
		add_child(child, true)
		counter.display(numBlocks)
		
	#print("DROPPED " + CodeBlock.name + " in " + name)



#Remove code blocks once player releases left mouse button
func stop_drag(globalPos):
	if child and removeChild and child.get_child(2).startPos == globalPos:
		var startIndex = child.get_index()
		child.queue_free() 
		removeChild = false
		child = null
		numBlocks -= 1
		counter.display(numBlocks)
		shift_blocks(startIndex)
		CodeBlock = null
		

#Helper function to shift blocks once one is removed
func shift_blocks(startIndex):
	#Start shifting from block right after the removed block
	for n in range(startIndex, numBlocks + 3): #exclusive range, doesn't include last number
		var x = xOffset + blockSize * ((n - 3) % rowSize)
		var y = yOffset + blockSize * int((n - 3) / rowSize)
		var childNode = get_child(n)
		childNode.position = Vector2(x, y)
		#Set CodeBlock's startPos to current global position
		childNode.get_child(2).startPos = childNode.global_position 
		
