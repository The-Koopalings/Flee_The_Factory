extends Area2D

# TODO: how to export tile_size to use in Robot child node?
var tile_size = 120
var grid_x = 1920
var grid_y = 1080

# Draw for now, use sprites later
func _draw():
	for x in range(0, grid_x, tile_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_y), Color8(0, 0, 0), 2)
	for y in range(0, grid_y, tile_size):
		draw_line(Vector2(0, y), Vector2(grid_x, y), Color8(0, 0, 0), 2)
		
