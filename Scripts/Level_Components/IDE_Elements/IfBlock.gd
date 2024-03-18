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
	
	#Add options into LHS & Operator dropdowns
	add_dropdown_options()
	
	
#NOTE: RHS options added in Level script
func add_dropdown_options():
	#Add options into LHS dropdown
	LHS.get_popup().add_item("Tile")
	LHS.get_popup().add_item("Front")
	LHS.get_popup().add_item("Back")
	LHS.get_popup().add_item("Left")
	LHS.get_popup().add_item("Right")
	
	#Add options into Operator dropdown
	Operator.get_popup().add_item("==")
	Operator.get_popup().add_item("!=")
	

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
			RHS.get_node("Label").text = "Virus"
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
		var dir = Robot.get_direction(LHSLabel.text)
		#Equals null if no object in that direction
		var object = Robot.get_object_in_direction(dir)
		if object:
			objectName = object.name.rstrip("0123456789")
		if objectName == "Obstacle" or is_wall(dir): 
			objectName = "Blocked"
	elif LHSLabel.text == "Tile":
		objectName = PEP.tiles[Robot.tileY][Robot.tileX]
		objectName = letter_to_name(objectName)
		
	#I.e. Front == Button & objectName is Button
	if OperatorLabel.text == "==" and objectName == RHSLabel.text:
		return true
	#I.e. Front != Button & objectName is NOT DeathTile
	elif OperatorLabel.text == "!=" and objectName != RHSLabel.text:
		return true
	else:
		return false
	

#Checks if a wall is specified direction
func is_wall(dir):
	if dir == "ui_up":
		#If robot is on the top row/tile above is an X
		if Robot.tileY == 0 or PEP.tiles[Robot.tileY - 1][Robot.tileX] == 'X':
			return true
	elif dir == "ui_down":
		#If robot is on the bottom row/tile below is an X
		if Robot.tileY == 6 or PEP.tiles[Robot.tileY + 1][Robot.tileX] == 'X':
			return true
	elif dir == "ui_left":
		#If robot is on the leftmost row/tile left is an X
		if Robot.tileX == 0 or PEP.tiles[Robot.tileY][Robot.tileX - 1] == 'X':
			return true
	elif dir == "ui_right":
		#If robot is on the rightmost row/tile right is an X
		if Robot.tileX == 10 or PEP.tiles[Robot.tileY][Robot.tileX + 1] == 'X':
			return true
	
	return false
	

#For check_conditions(), convert the object letter of the current tile to a name
#Realistically should be in PEP since it's also called in LoopBlocks
func letter_to_name(letter):
	if letter.find('R') != -1:
		letter.erase(letter.find('R'), 1)
	
	if letter == 'O' or letter == 'X':
		return "Blocked"
	elif letter == "" or letter == ' ':
		return ""
	else:
		return PEP.TileToTypeMapping[letter]

	


