extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var inFocus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered",self,"_on_FunctionBlockArea_area_entered")
	connect("area_exited",self,"_on_FunctionBlockArea_area_exited")
	connect("drag",self,"_on_Code_Block_drag")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FunctionBlockArea_area_entered(area):
	inFocus = true
	print("HIT")

func _on_FunctionBlockArea_area_exited(area):
	inFocus = false
	print("BYE")

func _on_Code_Block_drag(area):
	if inFocus:
		print("HELLO " + area.name)	
		
