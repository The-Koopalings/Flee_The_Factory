extends Area2D

#Load CodeBlock objects
var PathToCodeBlocks = "res://Scenes/Level_Components/Code_Blocks/"
var Template = load(PathToCodeBlocks + "CodeBlock.tscn")
var Forward = load(PathToCodeBlocks + "Forward.tscn")
var RotateLeft = load(PathToCodeBlocks + "RotateLeft.tscn")
var RotateRight = load(PathToCodeBlocks + "RotateRight.tscn")
var Interact  = load(PathToCodeBlocks + "Interact.tscn")
var Pickup = load(PathToCodeBlocks + "Pickup.tscn")
var UseItem = load(PathToCodeBlocks + "UseItem.tscn")
var CallFunction = load(PathToCodeBlocks + "CallFunction.tscn")
var CallIF = load(PathToCodeBlocks + "CallIf.tscn")
var CallLoop = load(PathToCodeBlocks + "CallLoop.tscn")
onready var counter = get_node("../Counter")

var numBlocks = 0
var rowSize = 7
var blockSize = 60 #Replace with actual codeblock size
var xOffset = 30
var yOffset = 30

#To prevent removing a code block if it was dragged out of FBA, but dragged and dropped back into FBA
var blockToAdd = null
var blockToRemove = null
var isDeletingBlock = false

onready var highlight = get_node("../Highlight")

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	


#Area2D enters a function area
func _on_FunctionBlockArea_area_entered(area):
	#Avoid duplicate adds since both CodeBlockTemplate and all Code Blocks trigger this
	if area.name != "CodeBlock" and !is_a_parent_of(area):
		blockToAdd = area
	
	#If block enters the FBA, it shouldn't be deleted
	#Prevents blocks from being removed when it is dropped inside IDE after briefly exiting
	isDeletingBlock = false
	
#Area2D leaves a function area
func _on_FunctionBlockArea_area_exited(area):
	blockToAdd = null
	
	#If block used to be in FBA, prepare to remove it
	if area.name != "CodeBlock" and is_a_parent_of(area):
		blockToRemove = area
		isDeletingBlock = true
	


#Something is dropped in function area
func _on_FunctionBlockArea_input_event(_viewport, event, _shape_idx):
	#If event was a drop
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT and !event.pressed):
		add_block(blockToAdd)
	


func _on_CodeBlock_doubleClick(code_block):
	if !highlight.visible:
		return 
		
	if is_a_parent_of(code_block):
		remove_block(code_block)
	else:
		add_block(code_block)


# Helper function to add a code block into FunctionBlockArea
func add_block(block):
	var child = null
	
	#If valid codeblock, then instantiate a new code block to be added
	if block and block.get_child(2):
		var type = block.name.rstrip("0123456789")
		match type:
			"Forward":
				child = Forward.instance()
			"RotateLeft":
				child = RotateLeft.instance()
			"RotateRight":
				child = RotateRight.instance()
			"Interact":
				child = Interact.instance()
			"Pickup":
				child = Pickup.instance()
				child.slotNum = block.slotNum
			"UseItem":
				child = UseItem.instance()
				child.slotNum = block.slotNum
			"Call_F":
				child = CallFunction.instance()
				child.get_node("Sprite").set_texture(block.get_node("Sprite").get_texture())
				child.name = block.name + "_1"
			"Call_If":
				#Prevent an If statement from calling itself
				var ifName = block.name.trim_prefix("Call_")
				if ifName != get_node("../..").name:
					child = CallIF.instance()
					child.get_node("Sprite").set_texture(block.get_node("Sprite").get_texture())
					child.name = block.name + "_1"
			"Call_Loop":
				#Prevent a Loop from calling itself
				var loopName = block.name.trim_prefix("Call_")
				if loopName != get_node("../..").name:
					child = CallLoop.instance()
					child.get_node("Sprite").set_texture(block.get_node("Sprite").get_texture())
					child.name = block.name + "_1"
				
	#Add codeblock node to tree
	if child and numBlocks < counter.maxBlocks:
		var x = xOffset + blockSize * (numBlocks % rowSize)
		var y = yOffset + blockSize * int(numBlocks / rowSize)
		child.position = Vector2(x, y)
		numBlocks += 1
		add_child(child, true)
		counter.display(numBlocks)
	
	blockToAdd = null
		
	#print("DROPPED " + CodeBlock.name + " in " + name)

# Helper function to remove a code block from FunctionBlockArea
func remove_block(block):
	var startIndex = block.get_index()
	block.queue_free() 
	isDeletingBlock = false
	blockToRemove = null
	numBlocks -= 1
	counter.display(numBlocks)
	shift_blocks(startIndex+1)
	#yield(get_tree().create_timer(0.01, false), "timeout") 
	

#Clears all code blocks from this FBA 
func clear_code():
	var code = get_children()
	
	#Pop CollisionShape2D & ColorRect 
	code.pop_front()
	code.pop_front()
	
	for codeBlock in code:
		codeBlock.queue_free()
	numBlocks = 0
	counter.display(numBlocks)
	

#Remove code blocks once player releases left mouse button
func _on_CodeBlock_stop_drag(globalPos):
	#If we're deleting a block, that block exists, and it's the one following the mouse, then delete
	#print(blockToRemove.name)
	if isDeletingBlock and blockToRemove and is_instance_valid(blockToRemove) and blockToRemove.get_child(2).startPos == globalPos:
		remove_block(blockToRemove)


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
		
