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
		if tile != ' ':
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

