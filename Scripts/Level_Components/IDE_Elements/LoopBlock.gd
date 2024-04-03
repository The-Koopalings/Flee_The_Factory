extends Control

signal ChosenLoop
#What type of loop this is, either While or For
var type
#Keep track of i for For loops
var loopCount: int = 0

onready var Counter = get_node("HighlightControl/Counter")
onready var ChooseLoopType = get_node("HighlightControl/ChooseLoopType")
onready var ChooseLoopTypeLabel = get_node("HighlightControl/ChooseLoopType/Label")
#While loop nodes
var whileConditionalPath = "HighlightControl/WhileConditional"
onready var WhileConditional = get_node(whileConditionalPath)
onready var LHS = get_node(whileConditionalPath + "/LHS")
onready var LHSLabel = get_node(whileConditionalPath + "/LHS/Label")
onready var Operator = get_node(whileConditionalPath + "/Operator")
onready var OperatorLabel = get_node(whileConditionalPath + "/Operator/Label")
onready var RHS = get_node(whileConditionalPath + "/RHS")
onready var RHSLabel = get_node(whileConditionalPath + "/RHS/Label")
#For loop nodes
var forConditionalPath = "HighlightControl/ForConditional"
onready var ForConditional = get_node(forConditionalPath)
onready var StartValue = get_node(forConditionalPath + "/StartValue")
onready var StopValue = get_node(forConditionalPath + "/StopValue")
onready var StepValue = get_node(forConditionalPath + "/StepValue")
onready var StepOperator = get_node(forConditionalPath + "/StepOperator")
onready var StepOperatorLabel = get_node(forConditionalPath + "/StepOperator/Label")
onready var LoopCounter = get_node(forConditionalPath + "/LoopCounter")

onready var Robot = get_node(PEP.get_path_to_grandpibling(self, "Grid/Robot"))

# Called when the node enters the scene tree for the first time.
func _ready():
	connections()
#	add_dropdown_options()

	#Set visibility of Conditional nodes appropriately
	set_conditional_visibility()


#NOTE: ChosenLoop connections are located in Loop.gd
func connections():
	#Connect selection of dropdown menu option to this node
	ChooseLoopType.get_popup().connect("id_pressed", self, "on_CLT_option_selected")
	LHS.get_popup().connect("id_pressed", self, "on_LHS_option_selected")
	Operator.get_popup().connect("id_pressed", self, "on_Operator_option_selected")
	RHS.get_popup().connect("id_pressed", self, "on_RHS_option_selected")
	StepOperator.get_popup().connect("id_pressed", self, "on_StepOperator_option_selected")
	

func set_conditional_visibility():
	type = ChooseLoopTypeLabel.text.rstrip("0123456789")
	if type == "Loop":
		type = ""
	if type == "While":
		WhileConditional.set_visible(true)
		ForConditional.set_visible(false)
	elif type == "For":
		WhileConditional.set_visible(false)
		ForConditional.set_visible(true)
	else:
		WhileConditional.set_visible(false)
		ForConditional.set_visible(false)
		type == ""
	

#NOTE: RHS options added in Level script
func add_dropdown_options():
	#Add options into ChooseLoopType dropdown
	ChooseLoopType.get_popup().add_item("While") 
	ChooseLoopType.get_popup().add_item("For") 
	
	#Add options into LHS dropdown
	LHS.get_popup().add_item("Tile")
	LHS.get_popup().add_item("Front")
	LHS.get_popup().add_item("Back")
	LHS.get_popup().add_item("Left")
	LHS.get_popup().add_item("Right")
	
	#Add options into Operator dropdown
	Operator.get_popup().add_item("==") 
	Operator.get_popup().add_item("!=")  
	
	#Add options into StepOperator dropdown
	StepOperator.get_popup().add_item("+") 
	StepOperator.get_popup().add_item("-") 
	StepOperator.get_popup().add_item("*") 
	StepOperator.get_popup().add_item("/") 


#NOTE: id of dropdown options depends on when it is added
#i.e. While was added first, so it's id = 0
func on_CLT_option_selected(id):
	#0 = While, 1 = For
	#Change CLT text & LTL text, move Counter, & make appropriate Conditional nodes visible
	match id:
		0:
			if self.name == "Loop1":
				ChooseLoopTypeLabel.text = "While1"
			elif self.name == "Loop2":
				ChooseLoopTypeLabel.text = "While2"
			Counter.set_position(Vector2(177.5, 244)) #Move the code block counter to the middle
			WhileConditional.set_visible(true)
			ForConditional.set_visible(false)
			type = "While"
			emit_signal("ChosenLoop", "While")
		1:
			if self.name == "Loop1":
				ChooseLoopTypeLabel.text = "For1"
			elif self.name == "Loop2":
				ChooseLoopTypeLabel.text = "For2"
			Counter.set_position(Vector2(130, 244)) #Move the code block counter slightly left
			ForConditional.set_visible(true)
			WhileConditional.set_visible(false)
			type = "For"
			emit_signal("ChosenLoop", "For")
			


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
	

func on_StepOperator_option_selected(id):
	match id:
		0: 
			StepOperatorLabel.text = "+"
		1: 
			StepOperatorLabel.text = "-"
		2: 
			StepOperatorLabel.text = "*"
		3: 
			StepOperatorLabel.text = "/"


func _on_StartValue_value_changed(value):
	loopCount = value
	LoopCounter.text = "i: " + str(loopCount)


func get_code():
	var code = null
	
	#Return empty array if loop type hasn't been selected yet
	if type == "": 
		code = []
	else:
		code = $HighlightControl/FunctionBlockArea.get_children()
		#Remove non-codeblocks [CollisionShape2D, ColorRect]
		code.pop_front()
		code.pop_front()
	
		
	return code


#Returns true if the loop can continue, false if the loop has to stop
func check_conditions():
	#Return false if loop type has not been selected
	if type == "":
		return false
		
	#Return false if For loop needs to stop
	if type == "For":
		match StepOperatorLabel.text:
			"+":
				if loopCount >= StopValue.value:
					return false
			"-":
				if loopCount <= StopValue.value:
					return false
			"*":
				if (StartValue.value >= 0 and loopCount >= StopValue.value) or (StartValue.value < 0 and loopCount <= StopValue.value):
					return false
			"/":
				if (StartValue.value >= 0 and loopCount <= StopValue.value) or (StartValue.value < 0 and loopCount >= StopValue.value):
					return false
		return true
	
	elif type == "While":
		var objectName = ""
		if LHSLabel.text != "Tile":
			var dir = Robot.get_direction(LHSLabel.text)
			#Equals null if no object in that direction
			var object = Robot.get_object_in_direction(dir)
			if object:
				objectName = object.name.rstrip("0123456789")
				if objectName.substr(0, 3) == "Key":
					objectName = objectName.rstrip("RGB")
			if objectName == "Obstacle" or is_wall(dir):
				objectName = "Blocked"
		elif LHSLabel.text == "Tile":
			objectName = PEP.tiles[Robot.tileY][Robot.tileX]
			objectName = letter_to_name(objectName)
	
		#I.e. Front == Button & objectName is Button
		if OperatorLabel.text == "==" and objectName == RHSLabel.text:
			return true
		#I.e. Front != Button & objectName is NOT Button
		elif OperatorLabel.text == "!=" and objectName != RHSLabel.text:
			return true
		else:
			return false
	

#Checks if wall is specified direction
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
#Realistically should be in PEP since it's also called in IfBlocks
func letter_to_name(letter):
	if letter.find('R') != -1:
		letter.erase(letter.find('R'), 1)
	
	if letter == 'O' or letter == 'X':
		return "Blocked"
	elif letter == "" or letter == ' ':
		return ""
	else:
		return PEP.TileToTypeMapping[letter]
		

#Updates loopCount & LoopCounter's text
func increment_loopCount():
	if type == "For":
		match StepOperatorLabel.text:
			"+":
				loopCount += StepValue.value
			"-":
				loopCount -= StepValue.value
			"*":
				loopCount *= StepValue.value
			"/":
				loopCount /= StepValue.value
		LoopCounter.text = "i: " + str(loopCount)


func reset_loopCount():
	if type == "For":
		loopCount = StartValue.value
		LoopCounter.text = "i: " + str(loopCount)

