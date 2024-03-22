extends GutTest

class TestRobotFunctions:
	extends GutTest
	var robot
	var tileSize = 96
	
	func before_each():
		robot = autofree(load('res://Scenes/Level_Components/Puzzle_Elements/Robot.tscn').instance())			
		robot.tile_size = tileSize
	
	###FUNCTION BLOCK
	#Click on FunctionBlock
	#Get code
	
	###FUNCTION BLOCK AREA	
	#Add all the code blocks
	#Shift blocks
	#Remove Blocks (Order is kept)
	
	###IfBlock
	#Check conditions (Can't w/o Robot)
	#Get Code (Can't w/o Robot)
	#Is Wall
	#Letter to Name
	
	###LoopBlock
	#CLT option select (3 loops)
	#_on_StartValue_value_changed
	#get_code
	#check_conditions (Can't w/o Robot)
	#is_wall
	#letter_to_name
	#increment_loopCount
	#reset_loopCount
		
	
	func test_Rotate_Left():
		var startOrientation = robot.get_node("Sprite").rotation
		#gut.p("START: " + str(startOrientation))
		robot._on_RotateLeft_rotateLeftSignal()
		var endOrientation = robot.get_node("Sprite").rotation
		#gut.p("END: " + str(endOrientation))
		assert_almost_eq(endOrientation, startOrientation - PI/2, 0.005)
	
