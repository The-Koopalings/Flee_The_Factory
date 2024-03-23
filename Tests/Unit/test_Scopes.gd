extends GutTest

var codeblocks = []
	
func before_all():
	#Get all code blocks	
	var dir = Directory.new()
	dir.open("res://Scenes/Level_Components/Code_Blocks/")
	dir.list_dir_begin(true, true)
	var file = dir.get_next()
		
	while file != "":
		if file == "CodeBlock.tscn":
			file = dir.get_next()
			continue
		var test = autofree(load(dir.get_current_dir() + "/" + file).instance())
		codeblocks.push_back(test)
		
		file = dir.get_next()
	dir.list_dir_end()
	

class TestFunctionBlockArea:
	extends GutTest
	
	func test_add_block():
		pass
	#Add all the code blocks
	#Shift blocks
	#Remove Blocks (Order is kept)
	
func test_Function_Get_Code():
	
	var node = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
	var function = autofree(load('res://Scenes/Level_Components/IDE_Elements/FunctionBlock.tscn').instance())			
	function._ready()
	node.add_child(function)
	var codespace = function.get_node("FunctionBlockArea")
	codespace._ready()
	codespace.get_node("../Counter").maxBlocks = 100

	for block in codeblocks:
		codespace.add_block(block)

	var code = function.get_code()
	for i in range(0,code.size()):
		assert_eq(code[i].name.rstrip("0123456789").trim_suffix("_"), codeblocks[i].name)
	###IfBlock
	#Check conditions (Can't w/o Robot)
	#Get Code (Can't w/o Robot)
	#Is Wall
	#Letter to Name
	
	###LoopBlock
	#CLT option select (3 loops)
	#_on_StartValue_value_changed
	#get_code (Can't w/o Robot)
	#check_conditions (Can't w/o Robot)
	#is_wall
	#letter_to_name
	#increment_loopCount
	#reset_loopCount
		
	"""
	func test_Rotate_Left():
		var startOrientation = robot.get_node("Sprite").rotation
		#gut.p("START: " + str(startOrientation))
		robot._on_RotateLeft_rotateLeftSignal()
		var endOrientation = robot.get_node("Sprite").rotation
		#gut.p("END: " + str(endOrientation))
		assert_almost_eq(endOrientation, startOrientation - PI/2, 0.005)
	"""
