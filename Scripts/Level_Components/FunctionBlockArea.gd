extends Area2D

var CodeBlock = null
var PathToCodeBlocks = "res://Scenes/Level_Components/Code_Blocks/"
var Template = load(PathToCodeBlocks + "CodeBlock.tscn")
var Forward = load(PathToCodeBlocks + "Forward.tscn")
var RotateLeft = load(PathToCodeBlocks + "RotateLeft.tscn")
var RotateRight = load(PathToCodeBlocks + "RotateRight.tscn")

var numBlocks = 0
var rowSize = 7
var blockSize = 75 #Replace with actual codeblock size

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	connect("area_entered",self,"_on_FunctionBlockArea_area_entered")
	connect("area_exited",self,"_on_FunctionBlockArea_area_exited")
	connect("drag",self,"_on_Code_Block_drag")
	#set_columns(7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FunctionBlockArea_area_entered(area):
	if CodeBlock == null:
		CodeBlock = area
	print("HIT " + area.name + " in " + name)

func _on_FunctionBlockArea_area_exited(area):
	CodeBlock = null


func _on_FunctionBlockArea_input_event(viewport, event, shape_idx):
	#If dropped codeblock onto this grid
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT and !event.pressed):
		var child = null
		#Check for valid codeblock
		match CodeBlock.name:
			"Forward":
				child = Forward.instance()
			"RotateLeft":
				child = RotateLeft.instance()
			"RotateRight":
				child = RotateRight.instance()
		
		#Add codeblock node to tree
		if child != null:
			child.position = Vector2(blockSize * (numBlocks%rowSize), blockSize * int(numBlocks/rowSize))
			print(child.position)
			numBlocks += 1
			add_child(child, true)

		print("DROPPED " + CodeBlock.name + " in " + name)
