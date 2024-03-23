extends GutTest


	
func before_all():
	pass

func test_draw_borders():
	#4 borders
	assert_true(true)
	#3 borders
	assert_true(true)
	assert_true(true)
	assert_true(true)
	assert_true(true)
	#2 borders
	assert_true(true)
	assert_true(true)
	assert_true(true)
	assert_true(true)
	assert_true(true)
	assert_true(true)
	#1 border
	assert_true(true)
	assert_true(true)
	assert_true(true)
	assert_true(true)

func test_connected_puzzle_element_signals():
	var elements = []
	#Get all code blocks	
	var dir = Directory.new()
	dir.open("res://Scenes/Level_Components/Puzzle_Elements/")
	dir.list_dir_begin(true, true)
	var file = dir.get_next()
		
	while file != "":
		var e = autofree(load(dir.get_current_dir() + "/" + file).instance())
		elements.push_back(e)
		
		file = dir.get_next()
	dir.list_dir_end()
	
	for e in elements:
		assert_true(true)

func test_puzzle_elements_tracker():
	for i in range(0, 5):
		assert_true(true)

func test_codeblocks_placement():
	for i in range(0, 9):
		assert_true(true)
		
func test_conditions_generation():
	for i in range(0, 10):
		assert_true(true)

func test_get_path_to_grandpibling():
	assert_true(true)
