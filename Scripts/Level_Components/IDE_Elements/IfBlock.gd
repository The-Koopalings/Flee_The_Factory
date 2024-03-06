extends Control

onready var LHS = get_node("If/LHS")
onready var LHSLabel = get_node("If/LHS/Label")
onready var Operator = get_node("If/Operator")
onready var OperatorLabel = get_node("If/Operator/Label")
onready var RHS = get_node("If/RHS")
onready var RHSLabel = get_node("If/RHS/Label")
onready var Robot = get_node("../../Grid/Robot")

func _ready():
	#Connect pressing of a dropdown option to this node
	LHS.get_popup().connect("id_pressed", self, "on_LHS_option_selected")
	Operator.get_popup().connect("id_pressed", self, "on_Operator_option_selected")
	RHS.get_popup().connect("id_pressed", self, "on_RHS_option_selected")
	
	#Add options into LHS, Operator, & RHS dropdowns, move to level script later
	add_options()
	
	
func add_options():
	#Add options into LHS dropdown
	LHS.get_popup().add_item("Obstacle")
	LHS.get_popup().add_item("ButtonA")
	LHS.get_popup().add_item("ButtonB")
	
	#Add options into Operator dropdown
	Operator.get_popup().add_item("==")
	Operator.get_popup().add_item("!=")
	
	#Add options into RHS dropdown
	RHS.get_popup().add_item("Front")
	RHS.get_popup().add_item("Back")
	RHS.get_popup().add_item("Left")
	RHS.get_popup().add_item("Right")
	RHS.get_popup().add_item("Pressed")
	

#change LHS text after selecting from dropdown
func on_LHS_option_selected(id):
	match id:
		0:
			LHSLabel.text = "Obstacle"
		1:
			LHSLabel.text = "ButtonA"
		2:
			LHSLabel.text = "ButtonB"

#change Operator text after selecting from dropdown
func on_Operator_option_selected(id):
	match id:
		0:
			OperatorLabel.text = "=="
		1:
			OperatorLabel.text = "!="

#change RHS text after selecting from dropdown
func on_RHS_option_selected(id):
	match id:
		0:
			RHSLabel.text = "Front"
		1:
			RHSLabel.text = "Back"
		2:
			RHSLabel.text = "Left"
		3:
			RHSLabel.text = "Right"
		4: 
			RHSLabel.text = "Pressed"

func get_code():
	var code
	if check_conditions():
		code = $If/FunctionBlockArea.get_children()
	else:
		code = $Else/FunctionBlockArea.get_children()
	 
	#Remove non-codeblocks [CollisionShape2D, ColorRect]
	code.pop_front()
	code.pop_front()
	
	return code
	

func check_conditions():
	#If an Obstacle is in certain direction based on Robot's current orientation
	if is_LHS_an_obstacle() and RHSLabel.text != "Pressed":
		#object = null if no object in that direction
		var object = Robot.get_object_in_direction(Robot.get_direction(RHSLabel.text)) 
		#I.e. Obstacle == Front & object stores a node named Obstacle
		if OperatorLabel.text == "==" and object and object.name.rstrip("0123456789") == LHSLabel.text:
			return true
		#I.e. Obstacle == Front & object = null b/c no object is in front of Robot
		elif OperatorLabel.text == "!=" and !object:
			return true
		#I.e. Obstacle == Front & object stores a node NOT named Obstacle
		elif OperatorLabel.text == "!=" and object.name.rstrip("0123456789") != LHSLabel.text:
			return true
		else:
			return false

#Can add on other types of obstacles later on
func is_LHS_an_obstacle():
	if LHSLabel.text == "Obstacle":
		return true
	else:
		return false
