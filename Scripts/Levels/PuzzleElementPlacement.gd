extends Node2D


var maxRows = 7 #Number of Rows (Cells per Column)
var maxCols = 11  #Numbers of Columns (Cells per Row)
var tiles = []
var Grid 
var halftile 
var CodeBlockBar
var robotStartOrientation
var level
var IDE
signal buttonPressed(name)

var TileToTypeMapping = {
	'R': "Robot",
	'O': "Obstacle",
	'B': "Button",
	'D': "Door",
}

enum Orientation{
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

func loadLevel(level, tiles, robotStartOrientation, Grid, CodeBlockBar):
	self.level = level
	self.Grid = level.get_node("Grid")
	self.halftile = Grid.tile_size/2
	self.CodeBlockBar = level.get_node("CodeBlockBar")
	self.IDE = level.get_node("IDE")
	self.tiles = tiles
	self.robotStartOrientation = robotStartOrientation
	
	self.init_elements()
	self.init_code_blocks()
	self.init_IDE()
	self.update()

#Draws the borders of the grid+
func _draw():
	var tileCount = 0
	for tile in tiles:
		var col = tileCount%maxCols
		var row = tileCount/maxCols
		var x = Grid.start_x + halftile + col * Grid.tile_size
		var y = Grid.start_y + halftile + row * Grid.tile_size
		
		if tile == 'X':
			#Check all edges to see if it's a border
			var top = 'X' if (row == 0) else tiles[tileCount - maxCols]
			var bottom = 'X' if (row == maxRows-1) else tiles[tileCount + maxCols]
			var left = 'X' if (col == 0) else tiles[tileCount - 1]
			var right = 'X' if (col == maxCols-1) else tiles[tileCount + 1]
			
			if top != 'X':
				draw_line(Vector2(x - halftile, y - halftile), Vector2(x + halftile, y - halftile), Color8(0, 0, 0), 4)
			if bottom != 'X':
				draw_line(Vector2(x - halftile, y + halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
			if left != 'X':
				draw_line(Vector2(x - halftile, y - halftile), Vector2(x - halftile, y + halftile), Color8(0, 0, 0), 4)
			if right != 'X':
				draw_line(Vector2(x + halftile, y - halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
		else:
			if row == 0:
				draw_line(Vector2(x - halftile, y - halftile), Vector2(x + halftile, y - halftile), Color8(0, 0, 0), 4)
			elif row == maxRows-1:
				draw_line(Vector2(x - halftile, y + halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
			
			if col == 0:
				draw_line(Vector2(x - halftile, y - halftile), Vector2(x - halftile, y + halftile), Color8(0, 0, 0), 4)
			elif col == maxCols-1:
				draw_line(Vector2(x + halftile, y - halftile), Vector2(x + halftile, y + halftile), Color8(0, 0, 0), 4)
			
		tileCount += 1

#Set positions/orientation of puzzle elements
func init_elements():
	var tileCount = 0
	var node
	var elements = generate_elements_dict()
	
	#Iterate through each tile
	for tile in tiles:		
		var col = tileCount%maxCols
		var row = tileCount/maxCols
		var x = Grid.start_x + halftile + col * Grid.tile_size
		var y = Grid.start_y + halftile + row * Grid.tile_size
			

		#If tile is an element, find that node in elements and set its position
		if TileToTypeMapping.has(tile):
			var type = TileToTypeMapping[tile]
			
			if elements[type].empty():
				printerr("TRIED TO PLACE ELEMENT THAT DOESN'T EXIST. Consider adding another <" + str(type) + "> to the level")
				assert(!elements[type].empty())
				return
			node = elements[type].pop_front()
			
			node.tileX = col
			node.tileY = row
			node.position = Vector2(x, y)	
			
			#If it's a special element, do special thing to it
			if type == "Robot":
				node.get_node("Sprite").rotation_degrees = robotStartOrientation*90
			elif type == "Button":
				node.connect("buttonPressed", level, "_on_Button_buttonPressed")
			elif type == "Door":
				level.connect("openDoor", node, "_on_level_openDoor")
		#error handling goes here??
		else:
			pass
			
		tileCount += 1

#Helper function of init_elements. Creates dict to track all available elements
func generate_elements_dict():
	var nodes = Grid.get_children()
	
	#Get rid of first node b/c that's the tilemap
	nodes.pop_front() 
	
	var elements = {}
	for node in nodes:
		#Get the name, but remove all digits from the end
		var type = node.name.rstrip("0123456789") 
		
		#For each unique element type, make a list of all instances 
		#For Example: elements["Obstacle"] has a list of all Obstacle Nodes
		if elements.keys().has(type):
			elements[type].push_back(node) 
		else:
			elements[type] = [node]
			
	return elements

#Set position of code blocks on CodeBlockBar
func init_code_blocks():
	var x = 90
	var y = 1008
	
	var blocks = CodeBlockBar.get_children()
	# Ignore first child of CodeBlockBar (TextureRect, not code block)
	blocks.pop_front()
	
	for block in blocks:
		var code_block_template = block.get_child(2)
		code_block_template.startPos = Vector2(x, y)
		x += 110
		
		#if block.name == ""

func init_IDE():
	for child in IDE.get_children():
		if child.name != "Run_Button":
			IDE.functions[child.name] = child
