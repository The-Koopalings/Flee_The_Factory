extends Area2D

signal whileLoop1
signal forLoop1
signal whileLoop2
signal forLoop2

#Which option is chosen, -1 = none, 0 = While, 1 = For
var option = -1 
#Regex results to be used in send_signal() & on_option_selected()
var result1
var result2 

func _ready():
	#Connect signals to IDE
	var IDE = get_node("../../../../IDE")
	connect("ifStatement1", IDE, "_on_ifStatement1")
	connect("f2Signal", IDE, "_on_f2Signal")
	#Connect signals to ControlFlowBlock in IDE
	#Connect pressing of a dropdown option to this node
	$MenuButton.get_popup().connect("id_pressed", self, "on_option_selected")
	
	#Add options into dropdown
	$MenuButton.get_popup().add_item("While")
	$MenuButton.get_popup().add_item("For")
	
	#Get regex ready
	var regexF1 = RegEx.new()
	var regexF2 = RegEx.new()
	regexF1.compile("Loop1_")
	regexF2.compile("Loop2_")
	result1 = regexF1.search(name)
	result2 = regexF2.search(name) 
	
#func _process(delta):
#	pass


func on_option_selected(id):
	option = id
	match id:
		0:
			if result1:
				$Sprite.texture = load("res://Assets/Placeholders/While1.PNG")
			elif result2:
				$Sprite.texture = load("res://Assets/Placeholders/While2.PNG")
		1:
			if result1:
				$Sprite.texture = load("res://Assets/Placeholders/For1.PNG")
			if result2:
				$Sprite.texture = load("res://Assets/Placeholders/For2.PNG")
	send_signal() #will change the type of section in the IDE
	

func send_signal():
	match option:
		0:
			if result1:
				emit_signal("whileLoop1")
			if result2:
				emit_signal("whileLoop2")
		1: 
			if result1:
				emit_signal("forLoop1")
			if result2:
				emit_signal("forLoop2")
