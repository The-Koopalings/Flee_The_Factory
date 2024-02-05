extends Area2D

var CodeBlock = null
var PathToCodeBlocks = "res://Scenes/Level_Components/Code_Blocks/"
var Template = load(PathToCodeBlocks + "CodeBlock.tscn")
var Forward = load(PathToCodeBlocks + "Forward.tscn")
var RotateLeft = load(PathToCodeBlocks + "RotateLeft.tscn")
var RotateRight = load(PathToCodeBlocks + "RotateRight.tscn")
var Interact  = load(PathToCodeBlocks + "Interact.tscn")

var numBlocks = 0
var rowSize = 7
var blockSize = 60 #Replace with actual codeblock size
var xOffset = 30
var yOffset = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	connect("area_entered",self,"_on_FunctionBlockArea_area_entered")
	connect("area_exited",self,"_on_FunctionBlockArea_area_exited")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FunctionBlockArea_area_entered(area):
	if CodeBlock == null:
		CodeBlock = area
	#print("HIT " + area.name + " in " + name)

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
			"Interact":
				child = Interact.instance()
		
		#Add codeblock node to tree
		if child != null:
			var x = xOffset + blockSize * (numBlocks%rowSize)
			var y = yOffset + blockSize * int(numBlocks/rowSize)
			child.position = Vector2(x, y)
			numBlocks += 1
			add_child(child, true)

		#print("DROPPED " + CodeBlock.name + " in " + name)
