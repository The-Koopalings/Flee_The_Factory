extends Area2D

var tile_size = 96

var start_x = 192
var start_y = 192
var end_x = 1152
var end_y = 768

# Draw bounds of grid
func _draw():
	draw_line(Vector2(start_x, start_x), Vector2(start_x, end_y), Color8(0, 0, 0), 4)
	draw_line(Vector2(end_x, start_x), Vector2(end_x, end_y), Color8(0, 0, 0), 4)
	
	draw_line(Vector2(start_y, start_y), Vector2(end_x, start_y), Color8(0, 0, 0), 4)
	draw_line(Vector2(start_y, end_y), Vector2(end_x, end_y), Color8(0, 0, 0), 4)
		
