extends Node


var maxRows = 7 #Cells per row
var maxCols = 11  #Cells per col

var TileToTypeMapping = {
	'R': "Robot",
	'O': "Obstacle",
	'B': "Button",
	'D': "Door",
}




# TODO: should probably make the naming more intuitive
# For now, grid is the array and Grid is the node
func init_puzzle(tiles, Grid):
	var tileCount = 0
	var childIndex = 0
	var node
	var elements = generate_elements_dict(Grid)
	
	#Iterate through each tile
	for tile in tiles:		
		
		#If tile is off limits 
		if tile == 'X':
			#Generate grid boundaries here
			pass
		#If tile is an element, find that node in elements and set its position
		elif TileToTypeMapping.has(tile):
			var type = TileToTypeMapping[tile]
			
			if elements[type].empty():
				printerr("TRIED TO PLACE ELEMENT THAT DOESN'T EXIST. Consider adding another <" + str(type) + "> to the level")
				assert(!elements[type].empty())
				return
			node = elements[type].pop_back()			
			
			var col = tileCount%maxCols
			var row = tileCount/maxCols
			var x = Grid.start_x + Grid.tile_size/2 + col * Grid.tile_size
			var y = Grid.start_y + Grid.tile_size/2 + row * Grid.tile_size
			
			node.tileX = col
			node.tileY = row
			
			node.position = Vector2(x, y)	
			print(node.name, ": ", node.position)
		#error handling goes here??
		else:
			pass
			
		tileCount += 1

func generate_elements_dict(Grid):
	var nodes = Grid.get_children()
	
	nodes.pop_front() #Get rid of first node b/c that's the tilemap
	
	var elements = {}
	for node in nodes:
		var type = node.name.rstrip("0123456789") #Get the name, but remove any numbers from the end
		
		#For each unique element type, make a list of all instances 
		#For Example: elements["Obstacle"] has a list of all Obstacle Nodes
		if elements.keys().has(type):
			#NOTE: each list is a queue, but stored at the front and retreived at the back (for optimization purposes)
			elements[type].push_front(node) 
		else:
			elements[type] = [node]
			
	return elements


func init_code_blocks(CodeBlockBar):
	var x = 90
	var y = 1008
	
	var blocks = CodeBlockBar.get_children()
	
	# Ignore first child of CodeBlockBar (TextureRect, not code block)
	for i in range(1, blocks.size()):
		var code_block_template = blocks[i].get_child(2)
		
		code_block_template.startPos = Vector2(x, y)
		
		x += 110
