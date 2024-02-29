extends Control

onready var ChooseLoopType = get_node("HighlightControl/ChooseLoopType")
onready var ChooseLoopTypeLabel = get_node("HighlightControl/ChooseLoopType/Label")
#While loop nodes
onready var LHS = get_node("HighlightControl/LHS")
onready var LHSLabel = get_node("HighlightControl/LHS/Label")
onready var Operator = get_node("HighlightControl/Operator")
onready var OperatorLabel = get_node("HighlightControl/Operator/Label")
onready var RHS = get_node("HighlightControl/RHS")
onready var RHSLabel = get_node("HighlightControl/RHS/Label")
onready var = 

# Called when the node enters the scene tree for the first time.
func _ready():
	#Connect selection of dropdown menu option to this node
	ChooseLoopType.get_popup().connect("id_pressed", self, "on_CLT_option_selected")
	
	#Set visibility of Conditional nodes to false
	LHS.set_visible(false)
	Operator.set_visible(false)
	RHS.set_visible(false)
	
	
	#Add options into ChooseLoopType dropdown
	ChooseLoopType.get_popup().add_item("While")
	ChooseLoopType.get_popup().add_item("For")
	
	#Add options into LHS dropdown
	LHS.get_popup().add_item("Obstacle")
	LHS.get_popup().add_item("ButtonA")
	LHS.get_popup().add_item("ButtonB")
	
	#Add options into Operator dropdown
	Operator.get_popup().add_item("==")
	Operator.get_popup().add_item("!=")
	
	#Add options into RHS dropdown
	RHS.get_popup().add_item("Front")
	RHS.get_popup().add_item("Pressed")

func on_CLT_option_selected(id):
	#0 = While, 1 = For
	match id:
		0:
			ChooseLoopType.set_position(Vector2(5, 18))
			if self.name == "Loop1":
				ChooseLoopTypeLabel.text = "While1"
			elif self.name == "Loop2":
				ChooseLoopTypeLabel.text = "While2"
			#ChooseLoopType.set_size(Vector2(134, 50))
			LHS.set_visible(true)
			Operator.set_visible(true)
			RHS.set_visible(true)
		1:
			ChooseLoopType.set_position(Vector2(5, 18))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
