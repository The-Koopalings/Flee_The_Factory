extends Node2D


var maxRows = 7 #Number of Rows (Cells per Column)
var maxCols = 11  #Numbers of Columns (Cells per Row)
var tiles = []
var Grid 
var halftile 
var CodeBlockBar
var robotStartOrientation

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

func loadLevel(tiles, robotStartOrientation, Grid, CodeBlockBar):
	self.tiles = tiles
	self.robotStartOrientation = robotStartOrientation
	self.Grid = Grid
	self.CodeBlockBar = CodeBlockBar
	self.halftile = Grid.tile_size/2
	self.init_elements()
	self.init_code_blocks()
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
			if type == "Robot":
				node.get_node("Sprite").rotation_degrees = robotStartOrientation*90
			
		#error handling goes here??
		else:
			pass
			
		tileCount += 1

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


func init_code_blocks():
	var x = 90
	var y = 1008
	
	var blocks = CodeBlockBar.get_children()
	
	# Ignore first child of CodeBlockBar (TextureRect, not code block)
	for i in range(1, blocks.size()):
		var code_block_template = blocks[i].get_child(2)
		
		code_block_template.startPos = Vector2(x, y)
		
		x += 110
