extends Control

onready var LHS = get_node("If/LHS")
onready var LHSLabel = get_node("If/LHS/Label")
onready var Operator = get_node("If/Operator")
onready var OperatorLabel = get_node("If/Operator/Label")
onready var RHS = get_node("If/RHS")
onready var RHSLabel = get_node("If/RHS/Label")
onready var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot"))

func _ready():
	#Connect pressing of a dropdown option to this node
	LHS.get_popup().connect("id_pressed", self, "on_LHS_option_selected")
	Operator.get_popup().connect("id_pressed", self, "on_Operator_option_selected")
	RHS.get_popup().connect("id_pressed", self, "on_RHS_option_selected")
	
	#Add options into LHS, Operator, & RHS dropdowns, move to level script later
	add_options()
	
	
func add_options():
	#Add options into LHS dropdown
	LHS.get_popup().add_item("Tile")
	LHS.get_popup().add_item("Front")
	LHS.get_popup().add_item("Back")
	LHS.get_popup().add_item("Left")
	LHS.get_popup().add_item("Right")
	
	#Add options into Operator dropdown
	Operator.get_popup().add_item("==")
	Operator.get_popup().add_item("!=")
	
	#Add options into RHS dropdown, might move to load_level/level script
	PEP.init_conditional_RHS_options(["Blocked", "Button"], RHS)
	

#change LHS text after selecting from dropdown
func on_LHS_option_selected(id):
	match id:
		0:
			LHSLabel.text = "Tile"
		1:
			LHSLabel.text = "Front"
		2:
			LHSLabel.text = "Back"
		3:
			LHSLabel.text = "Left"
		4:
			LHSLabel.text = "Right"

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
			RHS.get_node("Label").text = "Blocked"
		1:
			RHS.get_node("Label").text = "Button"
		2:
			RHS.get_node("Label").text = "Door"
		3:
			RHS.get_node("Label").text = "DeathTile"
		4:
			RHS.get_node("Label").text = "Key"
	

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
	
#Testing required still, copy into LoopBlock's While check_conditions()
func check_conditions():
	var objectName = ""
	if LHSLabel.text != "Tile":
		#Equals null if no object in that direction, might make it just return the name (?)
		var object = Robot.get_object_in_direction(Robot.get_direction(LHSLabel.text))
		if object:
			objectName = object.name.rstrip("0123456789")
		if objectName == "Obstacle": #add code for wall
			objectName = "Blocked"
	elif LHSLabel.text == "Tile":
		#Use tileX and tileY in Robot and other grid nodes, use PEP.tiles[x][y]?
		print(Robot.tileX)
		print(Robot.tileY)
#		objectName = PEP.tiles[Robot.tileX * Robot.tileY]
#		objectName = letter_to_name(objectName)
	
	#I.e. Front == DeathTile & object is named DeathTile
	if OperatorLabel.text == "==" and objectName == RHSLabel.text:
		return true
#	#I.e. Front != DeathTile & objectName = "" b/c no object is in front of the Robot
#	elif OperatorLabel.text == "!=" and objectName == "":
#		return true
	#I.e. Front != DeathTile & object is NOT named DeathTile
	elif OperatorLabel.text == "!=" and objectName != RHSLabel.text:
		return true
	else:
		return false
	

func letter_to_name(letter):
	if 'O':
		return "Blocked"
	elif 'B':
		return "Button"
	elif 'D':
		return "Door"
	elif 'K':
		return "Key"
	else:
		return ""

