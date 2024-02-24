extends Control

#signal ifCondSignal

onready var LHS = get_node("If/LHS")
onready var LHSLabel = get_node("If/LHS/Label")
onready var Operator = get_node("If/Operator")
onready var OperatorLabel = get_node("If/Operator/Label")
onready var RHS = get_node("If/RHS")
onready var RHSLabel = get_node("If/RHS/Label")

func _ready():
	#Connect signals to IDE, will send If conditions
#	var IDE = get_node("../../IDE")
#	connect("ifCondSignal", IDE, "_on_ifCond_signal")
	
	#Connect pressing of a dropdown option to this node
	LHS.get_popup().connect("id_pressed", self, "on_LHS_option_selected")
	Operator.get_popup().connect("id_pressed", self, "on_Operator_option_selected")
	RHS.get_popup().connect("id_pressed", self, "on_RHS_option_selected")
	
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
	
	
#func _process(delta):
#	pass

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
			RHSLabel.text = "Pressed"

#func _on_if1Signal():
#	print("if1Signal received")
#	emit_signal("ifCondSignal", LHSLabel.text, OperatorLabel.text, RHSLabel.text)
#
#func _on_if2Signal():
#	print("if2Signal received")
#	emit_signal("ifCondSignal", LHSLabel.text, OperatorLabel.text, RHSLabel.text)
