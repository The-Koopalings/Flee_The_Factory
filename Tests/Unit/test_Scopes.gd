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
		var block = load(dir.get_current_dir() + "/" + file).instance()
		codeblocks.push_back(block)
		
		file = dir.get_next()
	dir.list_dir_end()

###Function Block Area###
func test_FBA_add_block():
	var node = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
	var function = autofree(load('res://Scenes/Level_Components/IDE_Elements/FunctionBlock.tscn').instance())			
	function._ready()
	node.add_child(function)
	var codespace = function.get_node("FunctionBlockArea")
	codespace._ready()
	codespace.get_node("../Counter").maxBlocks = 100

	for block in codeblocks:
		codespace.add_block(block)
		assert_eq(codespace.get_children().back().name.rstrip("0123456789").trim_suffix("_"), block.name)

func test_FBA_remove_block():
	var node = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
	var function = autofree(load('res://Scenes/Level_Components/IDE_Elements/FunctionBlock.tscn').instance())			
	function._ready()
	node.add_child(function)
	var codespace = function.get_node("FunctionBlockArea")
	codespace._ready()
	codespace.get_node("../Counter").maxBlocks = 100

	for block in codeblocks:
		codespace.add_block(block)
		
	codespace.remove_block(codespace.get_child(2))
	yield(yield_for(1), YIELD)
	
	var program = []
	for code in codespace.get_children():
		program.push_back(code.name.rstrip("0123456789").trim_suffix("_"))
	program.pop_front()
	program.pop_front()
	
	var codeNames = []
	for block in codeblocks:
		codeNames.push_back(block.name)
	codeNames.pop_front()

	assert_eq(program, codeNames) 	#Remove Blocks (Order is kept)

func test_FBA_cannot_add_past_max_count():
	assert_true(true)
	
###Function###
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
	
###IfBlock###
#Check conditions (Can't w/o Robot)
func test_IF_check_conditions():
	pending()
#Get Code (Can't w/o Robot)
func test_IF_Get_Code():
	pending()
#Is Wall
func test_IF_is_wall():
	assert_true(true)
#Letter to Name
func test_IF_letter_to_name():
	var node = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
	var block = autofree(load('res://Scenes/Level_Components/IDE_Elements/IfBlock.tscn').instance())			
	block._ready()
	node.add_child(block)
	
	for element in PEP.TileToTypeMapping.keys():
		if element != 'X' and element != ' ' and element != 'O' and element != 'R':
			assert_eq(block.letter_to_name(element), PEP.TileToTypeMapping[element])
	
###LoopBlock###
#CLT option select (3 loops)
func test_LOOP_CLT_Options():
	assert_true(true)
	assert_true(true)
	assert_true(true)
#_on_StartValue_value_changed
func test_LOOP_Choose_Loop():
	assert_true(true)
	assert_true(true)
	
#get_code (Can't w/o Robot)
func test_LOOP_for_get_code():
	assert_true(true)
func test_LOOP_while_get_code():
	pending()
		
#check_conditions (Can't w/o Robot)
func test_LOOP_check_conditions():
	pending()
#is_wall
func test_LOOP_is_wall():
	assert_true(true)
#letter_to_name
func test_LOOP_letter_to_name():
	var node = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
	var block = autofree(load('res://Scenes/Level_Components/IDE_Elements/LoopBlock.tscn').instance())			
	block._ready()
	node.add_child(block)
	
	for element in PEP.TileToTypeMapping.keys():
		if element != 'X' and element != ' ' and element != 'O' and element != 'R':
			assert_eq(block.letter_to_name(element), PEP.TileToTypeMapping[element])
#increment_loopCount
func test_LOOP_increment_count():
	assert_true(true)
#reset_loopCount
func test_LOOP_reset_count():
	assert_true(true)

func after_all():
	for block in codeblocks:
		block.free()
