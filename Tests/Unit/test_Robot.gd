extends GutTest

class TestRobot:
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
		
	func test_move_forward_clear():
		var grid = autofree(load('res://Scenes/Level_Components/Level_Elements/Grid.tscn').instance())
		grid._ready()
		grid.add_child(robot)
		robot._ready()
		robot.position = Vector2(robot.start_x + tileSize/2, robot.start_y + tileSize*3/2)
		
		var solutions = [Vector2(0, -tileSize), Vector2(tileSize, 0), Vector2(0, tileSize), Vector2(-tileSize,0)]
		
		for s in solutions:
			var startPos = robot.position
			robot._on_Forward_forwardSignal()
			var endPos = robot.position
			assert_eq(endPos-startPos, s)
			robot._on_RotateRight_rotateRightSignal()
		

	func test_move_forward_blocked():
		pending()
		
	func test_get_object_in_direction():
		pending()
