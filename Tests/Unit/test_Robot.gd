extends GutTest

class TestRobotFunctions:
	extends GutTest
	var robot

	func before_each():
		robot = autofree(load('res://Scenes/Level_Components/Puzzle_Elements/Robot.tscn').instance())
	
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
		pending()

	func test_get_object_in_direction():
		robot.get_object_in_direction("DIRECTION")
		pending()
	
	func test_get_direction():
		robot.get_direction("DIRECTION")
		pending()
		
	func test_move_forward():
		robot._on_Forward_forwardSignal()
		pending()
