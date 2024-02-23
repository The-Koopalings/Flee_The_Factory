extends Node


var numRows = 7 #Cells per row
var numCols = 11  #Cells per col


# TODO: should probably make the naming more intuitive
# For now, grid is the array and Grid is the node
func init_puzzle(grid, Grid):
	var tileCount = 0
	var childIndex = 0
	var node
	
	#Iterate through each tile
	for tile in grid:		
		#If tile is not empty, get the next child of Grid and set it's position
		if tile != ' ' and tile != 'X':
			node = Grid.get_child(1 + childIndex)
			childIndex += 1
			
			var col = tileCount%numCols
			var row = tileCount/numCols
			var x = Grid.start_x + Grid.tile_size/2 + col * Grid.tile_size
			var y = Grid.start_y + Grid.tile_size/2 + row * Grid.tile_size
			
			node.tileX = col
			node.tileY = row
			
			node.position = Vector2(x, y)	
			
		tileCount += 1

func init_code_blocks(CodeBlockBar):
	var x = 90
	var y = 1008
	
	var blocks = CodeBlockBar.get_children()
	
	# Ignore first child of CodeBlockBar (TextureRect, not code block)
	for i in range(1, blocks.size()):
		var code_block_template = blocks[i].get_child(2)
		
		code_block_template.startPos = Vector2(x, y)
		
		x += 110
