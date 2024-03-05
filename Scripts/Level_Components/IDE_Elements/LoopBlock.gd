extends Control

signal ChosenLoop
#What type of loop this is, either While or For
var type = ""
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

# Called when the node enters the scene tree for the first time.
func _ready():
	connections()
	#NOTE: remove this later once level scripts can add these dropdown options
	add_dropdown_options()
	
	#Set visibility of Conditional nodes to false
	WhileConditional.set_visible(false)
	ForConditional.set_visible(false)


#NOTE: ChosenLoop connections are located in Loop.gd
func connections():
	#Connect selection of dropdown menu option to this node
	ChooseLoopType.get_popup().connect("id_pressed", self, "on_CLT_option_selected")
	LHS.get_popup().connect("id_pressed", self, "on_LHS_option_selected")
	Operator.get_popup().connect("id_pressed", self, "on_Operator_option_selected")
	RHS.get_popup().connect("id_pressed", self, "on_RHS_option_selected")
	StepOperator.get_popup().connect("id_pressed", self, "on_StepOperator_option_selected")


func add_dropdown_options():
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
			LHSLabel.text = "Obstacle"
		1: 
			LHSLabel.text = "ButtonA"
		2: 
			LHSLabel.text = "ButtonB"
	

func on_Operator_option_selected(id):
	match id:
		0: 
			OperatorLabel.text = "=="
		1: 
			OperatorLabel.text = "!="
	

func on_RHS_option_selected(id):
	match id:
		0: 
			RHSLabel.text = "Front"
		1: 
			RHSLabel.text = "Pressed"
	

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
		return true


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

