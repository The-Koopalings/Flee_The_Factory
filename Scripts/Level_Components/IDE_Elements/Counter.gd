extends Label

export var maxBlocks = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	display(0)

func display(numBlocks):
	text = str(numBlocks) + "/" + str(maxBlocks)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
