extends Control

signal ChosenLoop

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

#Pathing
var mainPath = "../Main/FunctionBlockArea/"
var F1Path = "../F1/FunctionBlockArea/"
var F2Path = "../F2/FunctionBlockArea/"
var If1Path = "../IfElse1/If/FunctionBlockArea/"
var Else1Path = "../IfElse1/Else/FunctionBlockArea/"
var If2Path = "../IfElse2/If/FunctionBlockArea/"
var Else2Path = "../IfElse2/Else/FunctionBlockArea/"
var Loop1Path = "../Loop1/HighlightControl/FunctionBlockArea/"
var Loop2Path = "../Loop2/HighlightControl/FunctionBlockArea/"
# Called when the node enters the scene tree for the first time.
func _ready():
	connections()
	add_dropdown_options()
	
	#Set visibility of Conditional nodes to false
	WhileConditional.set_visible(false)
	ForConditional.set_visible(false)


func connections():
	#Connect selection of dropdown menu option to this node
	ChooseLoopType.get_popup().connect("id_pressed", self, "on_CLT_option_selected")
	LHS.get_popup().connect("id_pressed", self, "on_LHS_option_selected")
	Operator.get_popup().connect("id_pressed", self, "on_Operator_option_selected")
	RHS.get_popup().connect("id_pressed", self, "on_RHS_option_selected")
	StepOperator.get_popup().connect("id_pressed", self, "on_StepOperator_option_selected")
	
	#Connect signals for when type of loop is chosen
	connect_loop_blocks()
	#Account for all possible Loop code blocks in each IDE section
	connect_all_possible_loop_blocks()

func connect_loop_blocks():
	connect("ChosenLoop", get_node("../../CodeBlockBar/Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node("../../CodeBlockBar/Loop2_"), "on_loop_type_selected")
	#Connect to code blocks in main
	connect("ChosenLoop", get_node(mainPath + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(mainPath + "Loop2_"), "on_loop_type_selected")
	#Connect to code blocks in F1 & F2
	connect("ChosenLoop", get_node(F1Path + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(F1Path + "Loop2_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(F2Path + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(F2Path + "Loop2_"), "on_loop_type_selected")
	#Connect to If-Else 
	connect("ChosenLoop", get_node(If1Path + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(If1Path + "Loop2_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(Else1Path + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(Else1Path + "Loop2_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(If2Path + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(If2Path + "Loop2_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(Else2Path + "Loop1_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(Else2Path + "Loop2_"), "on_loop_type_selected")
	#Connect to Loops (Loop1 can contain Loop2 code block & vice versa)
	connect("ChosenLoop", get_node(Loop1Path + "Loop2_"), "on_loop_type_selected")
	connect("ChosenLoop", get_node(Loop2Path + "Loop1_"), "on_loop_type_selected")
	
	
func connect_all_possible_loop_blocks():
	for i in range(1, 22):
		#Connect to code blocks in main
		connect("ChosenLoop", get_node(mainPath + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(mainPath + "Loop2_" + str(i)), "on_loop_type_selected")
		#Connect to code blocks in F1 & F2
		connect("ChosenLoop", get_node(F1Path + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(F1Path + "Loop2_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(F2Path + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(F2Path + "Loop2_" + str(i)), "on_loop_type_selected")
		#Connect to If-Else 
		connect("ChosenLoop", get_node(If1Path + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(If1Path + "Loop2_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(Else1Path + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(Else1Path + "Loop2_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(If2Path + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(If2Path + "Loop2_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(Else2Path + "Loop1_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(Else2Path + "Loop2_" + str(i)), "on_loop_type_selected")
		#Connect to Loops (Loop1 can contain Loop2 code block & vice versa)
		connect("ChosenLoop", get_node(Loop1Path + "Loop2_" + str(i)), "on_loop_type_selected")
		connect("ChosenLoop", get_node(Loop2Path + "Loop1_" + str(i)), "on_loop_type_selected")


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
				emit_signal("ChosenLoop", "While", 1)
			elif self.name == "Loop2":
				ChooseLoopTypeLabel.text = "While2"
				emit_signal("ChosenLoop", "While", 2)
			Counter.set_position(Vector2(177.5, 244)) #Move the code block counter to the middle
			WhileConditional.set_visible(true)
			ForConditional.set_visible(false)
		1:
			if self.name == "Loop1":
				ChooseLoopTypeLabel.text = "For1"
				emit_signal("ChosenLoop", "For", 1)
			elif self.name == "Loop2":
				ChooseLoopTypeLabel.text = "For2"
				emit_signal("ChosenLoop", "For", 2)
			Counter.set_position(Vector2(130, 244)) #Move the code block counter slightly left
			ForConditional.set_visible(true)
			WhileConditional.set_visible(false)
			

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
