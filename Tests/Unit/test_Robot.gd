extends GutTest

class TestRobotFunctions:
	extends GutTest
	var robot
	var tileSize = 96
	func before_each():
		robot = autofree(load('res://Scenes/Level_Components/Puzzle_Elements/Robot.tscn').instance())			
		robot.tile_size = tileSize
		
		
	func test_Rotate_Left():
		var startOrientation = robot.get_node("Sprite").rotation
		#gut.p("START: " + str(startOrientation))
		robot._on_RotateLeft_rotateLeftSignal()
		var endOrientation = robot.get_node("Sprite").rotation
		#gut.p("END: " + str(endOrientation))
		assert_almost_eq(endOrientation, startOrientation - PI/2, 0.005)
	
	func test_Rotate_Right():
		var startOrientation = robot.get_node("Sprite").rotation
		robot._on_RotateRight_rotateRightSignal()
		var endOrientation = robot.get_node("Sprite").rotation
		assert_almost_eq(endOrientation, startOrientation + PI/2, 0.005)

	func test_Interact():
		watch_signals(robot)
		robot._on_Interact_interactSignal()
		assert_signal_emitted(robot, "interact")
	
	func test_Robot_Death():
		robot._on_GameStats_robotDied()
		assert_eq(robot.get_node("Sprite").texture, robot.deadRobotTexture)

	func test_get_direction():
		var dirs = ["Front", "Right", "Back", "Left"]
		var ui_dirs = ["ui_up", "ui_right", "ui_down", "ui_left"]
		robot.rotation = 0
		
		#For all orientations
		for o in PEP.Orientation:
			var orient = PEP.Orientation[o] 
			var i = 0
			#For all directions in a given orientation
			for dir in dirs:
				assert_eq(robot.get_direction(dir), ui_dirs[(i + orient) %4])
				i += 1
			robot._on_RotateRight_rotateRightSignal()
		
	func test_get_object_in_direction():
		var grid = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
		grid._ready()
		grid.add_child(robot)
		robot._ready()
		robot.position = Vector2(0,0)
		
		var dir = Directory.new()
		dir.open("res://Scenes/Level_Components/Puzzle_Elements/")
		dir.list_dir_begin(true, true)
		var file = dir.get_next()
		var elements = []
		
		#Get all puzzle elements
		while file != "":
			if file == "Robot.tscn":
				file = dir.get_next()
				continue
			elements.push_back(autofree(load(dir.get_current_dir() + "/" + file).instance()))
			file = dir.get_next()
		dir.list_dir_end()

		#UP
		for i in range(0,elements.size(),4):
			elements[i].position = Vector2(tileSize*3/2 , 0)
			grid.add_child(elements[i])
			elements[i]._ready()
			print("PLACED AT: ",elements[i].position)
			
		#RIGHT
		for i in range(1,elements.size(),4):
			elements[i].position = Vector2(0, tileSize*3/2)
			grid.add_child(elements[i])
			elements[i]._ready()
		
		#DOWN
		for i in range(2,elements.size(),4):
			elements[i].position = Vector2(-tileSize*3/2, 0)
			grid.add_child(elements[i])
			elements[i]._ready()
		
		#LEFT
		for i in range(3,elements.size(),4):
			elements[i].position = Vector2(0, -tileSize*3/2)
			grid.add_child(elements[i])
			elements[i]._ready()
			
		var ui_dirs = ["ui_up", "ui_right", "ui_down", "ui_left"]

		for direction in ui_dirs:
			print(robot.get_object_in_direction(direction))
			assert_eq(robot.get_object_in_direction(direction), null)
		

	func test_move_forward():
		#RAYCAST IS NULL FOR SOME REASON
		var grid = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
		grid._ready()
		grid.add_child(robot)
		robot._ready()
		
		var startPos = robot.position
		robot._on_Forward_forwardSignal()
		var endPos = robot.position
		assert_eq(endPos-startPos, Vector2(tileSize, tileSize))
		
