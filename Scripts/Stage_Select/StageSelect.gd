extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FunctionsButton_pressed():
	SceneSwapper.change_scene("Functions Select")


func _on_RecursionButton_pressed():
	SceneSwapper.change_scene("Recursion Select")


func _on_ControlFlowButton_pressed():
	SceneSwapper.change_scene("Control Flow Select")


func _on_DataStructuresButton_pressed():
	SceneSwapper.change_scene("Data Structures Select")
