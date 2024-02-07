extends Area2D

var tile_size = 100
var grid_x = 1200
var grid_y = 800

# Draw for now, use sprites later
func _draw():
	for x in range(200, grid_x + tile_size, tile_size):
		draw_line(Vector2(x, 200), Vector2(x, grid_y), Color8(0, 0, 0), 2)
	for y in range(200, grid_y + tile_size, tile_size):
		draw_line(Vector2(200, y), Vector2(grid_x, y), Color8(0, 0, 0), 2)
		

