extends Area2D

# TODO: how to export tile_size to use in Robot child node?
var tile_size = 100
var grid_x = 1440
var grid_y = 918

# Draw for now, use sprites later
func _draw():
	for x in range(192, grid_x, tile_size):
		draw_line(Vector2(x, 162), Vector2(x, grid_y), Color8(0, 0, 0), 2)
	for y in range(162, grid_y, tile_size):
		draw_line(Vector2(192, y), Vector2(grid_x, y), Color8(0, 0, 0), 2)
		
