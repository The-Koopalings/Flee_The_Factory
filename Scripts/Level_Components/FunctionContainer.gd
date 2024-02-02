extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var CodeBlock = null
var PathToCodeBlocks = "res://Scenes/Level_Components/Code_Blocks/"
var Forward = load(PathToCodeBlocks + "Forward.tscn")
var RotateLeft = load(PathToCodeBlocks + "RotateLeft.tscn")
var RotateRight = load(PathToCodeBlocks + "RotateRight.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered",self,"_on_FunctionBlockArea_area_entered")
	connect("area_exited",self,"_on_FunctionBlockArea_area_exited")
	connect("drag",self,"_on_Code_Block_drag")

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
		add_child(child)
		print(get_child(0).position)
		print("DROPPED " + CodeBlock.name + " in " + name)
