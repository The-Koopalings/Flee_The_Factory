extends Node2D

var DEBUG_buffer = "~~~~~~~~~~~~~~~"
var wallScene = preload("res://Scenes/Level_Components/Puzzle_Elements/Wall.tscn")
var WCLScene = preload("res://Scenes/Level_Components/Puzzle_Elements/WinConditionLight.tscn")
var maxRows = 7 #Number of Rows (Cells per Column)
var maxCols = 11  #Numbers of Columns (Cells per Row)
var tiles = []
var Grid 
var halftile 
var CodeBlockBar
var robotStartOrientation
var level
var IDE
var robot
var puzzleElements
var codeBlocks = {}
var IDEScopes = []
signal buttonPressed(name)

var TileToTypeMapping = {
	'R': "Robot",
	'O': "Obstacle",
	'B': "Button",
	'D': "Door",
	'V': "Virus",
	'K': "Key",
}

enum Orientation{
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

func loadLevel(_level):
	self.level = _level
	self.tiles = level.tiles
	self.robotStartOrientation = level.robotStartOrientation
	self.Grid = level.get_node("Grid")
	self.CodeBlockBar = level.get_node("CodeBlockBar")
	self.IDE = level.get_node("IDE")
	self.halftile = Grid.tile_size/2
	
	print(DEBUG_buffer)
	self.init_elements()
	self.init_WCLs()
	self.init_IDE()
	self.init_code_blocks_bar()
	self.update()
	GameStats.set_game_state(GameStats.State.CODING)
	

#Draws the borders of the grid+
func _draw():
	if GameStats.game_state == GameStats.State.OUT_OF_LEVEL:
		return
#	var tileCount = 0
	var rowIndex = 0
	var colIndex = 0
	var wall
		
	for row in tiles:
		colIndex = 0
		for tile in row:
#			var col = tileCount%maxCols
#			var row = tileCount/maxCols
			var x = Grid.start_x + halftile + colIndex * Grid.tile_size
			var y = Grid.start_y + halftile + rowIndex * Grid.tile_size
		
			if tile == 'X':
				wall = wallScene.instance()
				Grid.add_child(wall)
				#Check all edges to see if it's a border
				var top = 'X' if (rowIndex == 0) else tiles[rowIndex - 1][colIndex]
				var bottom = 'X' if (rowIndex == maxRows-1) else tiles[rowIndex + 1][colIndex]
				var left = 'X' if (colIndex == 0) else tiles[rowIndex][colIndex - 1]
				var right = 'X' if (colIndex == maxCols-1) else tiles[rowIndex][colIndex + 1]
			
				wall.position = Vector2(x, y)
				
				if top != 'X':
					draw_line(Vector2(x - halftile, y - halftile), Vector2(x + halftile, y - halftile), Color8(0, 0, 0), 4)
				if bottom != 'X':
					draw_line(Vector2(x - halftile, y + halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
				if left != 'X':
					draw_line(Vector2(x - halftile, y - halftile), Vector2(x - halftile, y + halftile), Color8(0, 0, 0), 4)
				if right != 'X':
					draw_line(Vector2(x + halftile, y - halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
			else:
				if rowIndex == 0:
					draw_line(Vector2(x - halftile, y - halftile), Vector2(x + halftile, y - halftile), Color8(0, 0, 0), 4)
				elif rowIndex == maxRows-1:
					draw_line(Vector2(x - halftile, y + halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)			
				if colIndex == 0:
					draw_line(Vector2(x - halftile, y - halftile), Vector2(x - halftile, y + halftile), Color8(0, 0, 0), 4)
				elif colIndex == maxCols-1:
					draw_line(Vector2(x + halftile, y - halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
			colIndex += 1
		rowIndex += 1
#		tileCount += 1

#Set positions/orientation of puzzle elements
func init_elements():
	var tileCount = 0
	var node
	puzzleElements = generate_elements_dict()
	
	#Iterate through each tile
	var rowIndex = 0
	var colIndex = 0
	for row in tiles:	
		colIndex = 0
		for tile in row:	
#			var col = tileCount%maxCols
#			var row = tileCount/maxCols
			var x = Grid.start_x + halftile + colIndex * Grid.tile_size
			var y = Grid.start_y + halftile + rowIndex * Grid.tile_size
			
			#If tile is an element, find that node in elements and set its position
			for element in tile:
				if TileToTypeMapping.has(element):
					var type = TileToTypeMapping[element]
					
					if puzzleElements[type].empty():
						printerr("TRIED TO PLACE ELEMENT THAT DOESN'T EXIST. Consider adding another <" + str(type) + "> to the level")
						assert(!puzzleElements[element].empty())
						return
					node = puzzleElements[type].pop_front()
					
					node.tileX = colIndex
					node.tileY = rowIndex
					node.position = Vector2(x, y)	
					#If it's a special element, do special thing to it
					if type == "Robot":
						#node.get_node("Sprite").rotation_degrees = robotStartOrientation*90
						node.orientation = robotStartOrientation
						node.set_idle_direction()
						GameStats.connect("robotDied", node, "_on_GameStats_robotDied")
					elif type == "Button":
						robot.connect("interact",node,"_on_Robot_interact")
						node.connect("buttonPressed", level, "_on_Button_buttonPressed")
						#Setup WinConditionLight
						var wcl = WCLScene.instance()
						var wcls = level.get_node("Grid/Door/WCLs")
						wcls.add_child(wcl)
						node.connect("buttonPressed", wcls, "on_button_pressed")
					elif type == "Virus":
						robot.connect("interact",node,"_on_Robot_interact")
					elif type == "Door":
						level.connect("levelComplete", node, "_on_level_levelComplete")
				#error handling goes here??
				elif not (element == 'X' || element == ' '):
					printerr("TRIED TO PLACE ELEMENT THAT DOESN'T EXIST. Consider adding another <" + str(TileToTypeMapping[element]) + "> to the level")
					assert(!puzzleElements[element].empty())
					pass
			
#			tileCount += 1
			colIndex += 1
		rowIndex += 1
	puzzleElements = generate_elements_dict()
	

#Helper function of init_elements. Creates dict to track all available elements
func generate_elements_dict():
	var nodes = Grid.get_children()
	
	#Get rid of first node b/c that's the tilemap
	nodes.pop_front() 
	
	var elements = {}
	
	#For each unique element type, make a list of all instances 
	#Example: elements["Obstacle"] has a list of all Obstacle Nodes
	for node in nodes:
		#Get the name, but remove all digits from the end
		var type = node.name.rstrip("0123456789") 
		#For keys, remove the letter at the end too
		if type.substr(0, 3) == "Key" or type.substr(0, 4) == "Door":
			type = type.rstrip("RGB")
			
		if type == "Robot":
			robot = node
			
		#If it exists, push into list. Else, make a new list
		if elements.keys().has(type):
			elements[type].push_back(node) 
		else:
			elements[type] = [node]
	
	print("ELEMENTS: ", elements)
	print(DEBUG_buffer)
	
	return elements

func init_WCLs():
	var positions = []
	var wcls = level.get_node("Grid/Door/WCLs")
	var wclChildren = wcls.get_children()
	var wclCount = wcls.get_child_count()
	
	if wclCount == 1:
		return
	elif wclCount == 2:
		positions.push_back(Vector2(-10, 0))
		positions.push_back(Vector2(10, 0))
	elif wclCount == 3:
		positions.push_back(Vector2(-15, 0))
		positions.push_back(Vector2(0, 0))
		positions.push_back(Vector2(15, 0))
	elif wclCount == 4:
		positions.push_back(Vector2(-10, -10))
		positions.push_back(Vector2(10, -10))
		positions.push_back(Vector2(-10, 10))
		positions.push_back(Vector2(10, 10))
	elif wclCount == 5:
		positions.push_back(Vector2(-15, -10))
		positions.push_back(Vector2(0, -10))
		positions.push_back(Vector2(15, -10))
		positions.push_back(Vector2(-10, 10))
		positions.push_back(Vector2(10, 10))
	elif wclCount == 6:
		positions.push_back(Vector2(-15, -10))
		positions.push_back(Vector2(0, -10))
		positions.push_back(Vector2(15, -10))
		positions.push_back(Vector2(-15, 10))
		positions.push_back(Vector2(0, 10))
		positions.push_back(Vector2(15, 10))
	
	for wcl in wclChildren:
		wcl.position = positions.pop_front()
	

#Set position of code blocks on CodeBlockBar
func init_code_blocks_bar():
	var x = 90
	var y = 1008
	
	var blocks = CodeBlockBar.get_children()
	# Ignore first child of CodeBlockBar (TextureRect, not code block)
	blocks.pop_front()
	
	for block in blocks:
		var code_block_template = block.get_child(2)
		code_block_template.startPos = Vector2(x, y)
		code_block_template.connections()
		if block.BLOCK_TYPE == "CALL":
			var call_name = block.name.trim_prefix("Call_")
			var texture = load("res://Assets/Objects/" + call_name + ".png")
			block.get_node("Sprite").set_texture(texture)
			#In case of Restart, allows Call_Loop code blocks to reconnect to pre-Restart IDE sections
			if block.name.begins_with("Call_Loop"):
				block.connect_to_LoopBlock()
		
		x += 110
		
	print("CODE BLOCKS: ", blocks)
	print(DEBUG_buffer)
		#if block.name == ""

func init_IDE():
	GameStats.connect("robotDied", IDE, "_on_GameStats_robotDied")
	level.connect("levelComplete", IDE, "_on_level_levelComplete")
	var options = null
	var scopesContainer = IDE.get_node("Scopes")
	
	#If player pressed Restart
	if IDEScopes.size() != 0:
		var i = 0
		scopesContainer.remove_child(scopesContainer.get_child(0))
		#Replace current IDE sections with pre-Restart IDE sections
		for container in IDEScopes:			
			scopesContainer.add_child(container)
			var scope = container.get_child(0)
			if scope.name.begins_with("F") or scope.name == "Main":
				scope.get_node("FunctionBlockArea").reset_CodeBlock_positions()
			elif scope.name.begins_with("If"):
				scope.get_node("If/FunctionBlockArea").reset_CodeBlock_positions()
				scope.get_node("Else/FunctionBlockArea").reset_CodeBlock_positions()
			elif scope.name.begins_with("Loop"):
				scope.get_node("HighlightControl/FunctionBlockArea").reset_CodeBlock_positions()
				pass
			i = i + 1
		IDEScopes.clear()
		
		print("Well ok...",scopesContainer.get_children())
		#remove extra scopes outside of the Scopes Container
		var children = IDE.get_children()
		if children.size() > 2:
			for child in children:
				if child.name == "ButtonContainer" or child.name == "Scopes":
					pass
				else:
					IDE.remove_child(child)

		#Makes sure FBAs in level.progress_check_FBA are the ones in IDEScopes
		init_progress_check_FBA()
		
		# Grab focus of main
		scopesContainer.get_node("Main/Main").grab_focus()
	
	#Only generates dropdown options once (when first entering level) for If & Loop sections
	else:
		options = generate_RHS_options()

	#Move scopes in scene tree to be in the Scopes container if they aren't already
	#Should technically only have 2 children, Scopes and Button containers
	var children = IDE.get_children()
	if children.size() > 2:
		for child in children:
			if child.name == "ButtonContainer" or child.name == "Scopes":
				pass
			else:
				IDE.remove_child(child)
				var container = HBoxContainer.new()
				container.mouse_filter = Control.MOUSE_FILTER_IGNORE
				container.alignment = HBoxContainer.ALIGN_CENTER
				container.name = child.name
				container.add_child(child)
				scopesContainer.add_child(container)
				
			
	#Generate IDE.scopes dictionary
	for scope in scopesContainer.get_children():
		scope = scope.get_child(0) #Get the actual scope out of the nested container
		var type = scope.name.rstrip("1234567890")
		
		#Ignore arrows
		#In case of Restart: Reconnect Run_Button signal to current IDE
		#					 Set FBA.numBlocks to the number of code blocks in that FBA 
		#					 (otherwise numBlocks would = 0 even if there are > 0 code blocks in that FBA)
		if type.find("Arrow") != -1:
			continue
		elif type == "If":
			scope.get_node("If").set_FBA_numBlocks()
			scope.get_node("Else").set_FBA_numBlocks()
		elif type == "Loop":
			scope.get_node("HighlightControl").set_FBA_numBlocks()
			scope.reset_loopCount()
		else:
			scope.set_FBA_numBlocks()
		
		call_loop_reconnections(type, scope)
		
		#Check if we need to add RHS options, shouldn't trigger after a Restart
		if options:
			if type == "If":
				var RHS = scope.get_node("If/RHS")
				scope.add_dropdown_options()
				add_RHS_options(options, RHS)
			elif type == "Loop":
				var RHS = scope.get_node("HighlightControl/WhileConditional/RHS")
				scope.add_dropdown_options()
				add_RHS_options(options, RHS)
			
		#Add the scope to list of scopes
		IDE.scopes[scope.name] = scope
	
	
	#init buttons
	var buttons = IDE.get_node("ButtonContainer")
	#Connect Run Button
	buttons.get_node("Run_Button").connect("pressed", IDE, "_on_RunButton_pressed")

	#Connect Clear All Button
	for scope in scopesContainer.get_children():
		var btnPath = "ClearAll_Button"
		#Coupling this with the existing ClearCode button in all scopes. (ie I'm being lazy)
		if scope.name.begins_with("If"):
			buttons.get_node("ClearAll_Button").connect("pressed", scope.get_child(0).get_node("If/ClearCode"), "on_pressed")
			buttons.get_node("ClearAll_Button").connect("pressed", scope.get_child(0).get_node("Else/ClearCode"), "on_pressed")
		elif scope.name.begins_with("Loop"):
			buttons.get_node("ClearAll_Button").connect("pressed", scope.get_child(0).get_node("HighlightControl/ClearCode"), "on_pressed")
		elif scope.name.begins_with("F") or scope.name == "Main":
			buttons.get_node("ClearAll_Button").connect("pressed", scope.get_child(0).get_node("ClearCode"), "on_pressed")
	buttons.get_node("ClearAll_Button").connect("pressed", IDE, "_on_ClearAllButton_pressed")
		
	print("SCOPES: ", IDE.scopes.keys())
	print(DEBUG_buffer)
	

#Reconnect signals in Call_Loop code blocks, needed after a Restart
func call_loop_reconnections(type, child):
	var code = []
	if type.find("Arrow") != -1 or type == "ButtonContainer":
		return
	elif type == "If":
		code = child.get_node("If/FunctionBlockArea").get_children()
		for codeBlock in child.get_node("Else/FunctionBlockArea").get_children():
			code.push_back(codeBlock)
	elif type == "Loop":
		code = child.get_node("HighlightControl/FunctionBlockArea").get_children()
	else:
		code = child.get_node("FunctionBlockArea").get_children()
	
	#Pop CollisionShape2D & ColorRect
	code.pop_front()
	code.pop_front()
	
	#Reconnect signals for Call_Loop code blocks
	for codeBlock in code:
		if codeBlock.name.begins_with("Call_Loop"):
			codeBlock.connect_to_LoopBlock()
	

#Allows progress checks to work after Restart, progress_check_FBA elements need to point to pre-Restart FBAs
func init_progress_check_FBA():
	for i in range(level.progress_check_FBA.size()):
		#For checking Main & Funcs + to know whether we're checking If or Else FBA 
		var scope = level.progress_check_FBA[i].get_parent().name
		
		var itself = level.progress_check_FBA[i].name
		
		if scope == "Main" or scope.begins_with("F"):
			level.progress_check_FBA[i] = level.get_node("IDE/Scopes/" + scope + "/FunctionBlockArea")
		elif itself == "If" or scope.begins_with("Loop"):
			#For If conditional checks + Loop type selection checks
			level.progress_check_FBA[i] = level.get_node("IDE/Scopes/" + scope + "/" + itself)
		else:
			#For checking Ifs & Loops
			var higherScope = level.progress_check_FBA[i].get_parent().get_parent().name
			if higherScope.begins_with("If"):
				#Should account for If & Else FBAs
				level.progress_check_FBA[i] = level.get_node("IDE/Scopes/" + higherScope + "/" + scope + "/FunctionBlockArea")
			elif higherScope.begins_with("Loop"):
				if itself == "FunctionBlockArea":
					level.progress_check_FBA[i] = level.get_node("IDE/Scopes/" + higherScope + "/HighlightControl/FunctionBlockArea")
				elif itself == "ForConditional" or itself == "WhileConditional":
					#For While & For Loop conditional checks
					level.progress_check_FBA[i] = level.get_node("IDE/Scopes/" + higherScope + "/HighlightControl/" + itself)
	
func init_inventory():
	level.get_node("Inventory").set_position(Vector2(865, 43))
	

#Get path to a node that's a relative to an ancestor of the current node
func get_path_to_grandpibling(node, target):
	var path = ""
	while node and !node.has_node(target):
		node = node.get_parent()
		path += "../"
	if (node != null):
		return (path + target)
	else:
		return "ERROR"
	

func generate_RHS_options():
	var types = puzzleElements.keys()
	var options = ["Blocked"]
	for type in types:
		if type == "Obstacle" || type == "Robot":
			continue
		options.push_back(type)
	options.sort()
	
	print("RHS OPTIONS: ", options)
	print(DEBUG_buffer)
	
	return options
	

func add_RHS_options(options, RHS):
	var index = 0

	#NOTE: index doesn't change, but id can
	for item in options:
		RHS.get_popup().add_item(item)
		if item == "Blocked":
			RHS.get_popup().set_item_id(index, 0)
		elif item == "Button":
			RHS.get_popup().set_item_id(index, 1)
		elif item == "Door":
			RHS.get_popup().set_item_id(index, 2)
		elif item == "Virus":
			RHS.get_popup().set_item_id(index, 3)
		elif item == "Key":
			RHS.get_popup().set_item_id(index, 4)
		index += 1	
