extends ColorRect

#First character of the Level's Node2D name, "S" = Stack, "Q" = Queue, "A" = Array
var type
onready var Robot = get_node("../Grid/Robot")
onready var Grid = get_node("../Grid")

func _ready():
	type = get_node("..").name.substr(0,1)
	initialize_inventory()
	

func initialize_inventory():
	match type:
		"S":
			$ReferenceRect.set_border_color(Color(1, 0, 0)) #Red
			$Line2D.set_default_color(Color(1, 0, 0))
			$Line2D2.set_default_color(Color(1, 0, 0))
			$Line2D3.set_default_color(Color(1, 0, 0))
			$Line2D4.set_default_color(Color(1, 0, 0))
		"Q":
			$ReferenceRect.set_border_color(Color(0, 1, 0)) #Green
			$Line2D.set_default_color(Color(0, 1, 0))
			$Line2D2.set_default_color(Color(0, 1, 0))
			$Line2D3.set_default_color(Color(0, 1, 0))
			$Line2D4.set_default_color(Color(0, 1, 0))
		"A":
			$ReferenceRect.set_border_color(Color(0, 0, 1)) #Blue
			$Line2D.set_default_color(Color(0, 0, 1))
			$Line2D2.set_default_color(Color(0, 0, 1))
			$Line2D3.set_default_color(Color(0, 0, 1))
			$Line2D4.set_default_color(Color(0, 0, 1))
	
#NOTE: remember to remove the key that's moved into the inventory from the PEP.puzzleElements["Key"] dict
func on_pickup(slotNum: int):
	var letter = PEP.tiles[Robot.tileY][Robot.tileX]
	if letter.find('R') != -1:
		letter.erase(letter.find('R'), 1)
	
	if letter == 'K':
		for key in PEP.puzzleElements["Key"]:
			if key.tileX == Robot.tileX and key.tileY == Robot.tileY:
				move_to_inventory(key, slotNum) #Move to first available slot
	

func move_to_inventory(item, slotNum):
	#For Queue or Stack, find the next available slot & add item into it, shouldn't pick up anything if inventory is full
	if slotNum == -1:
		var itemSlots = $ItemSlots.get_children()
		for itemSlot in itemSlots:
			if itemSlot.get_child_count() == 0:
				itemSlot.text = ""
				Grid.remove_child(item)
				itemSlot.add_child(item)
				item.global_position = itemSlot.get_global_position() + Vector2(48, 48)
				item.z_index = 99
				PEP.puzzleElements["Key"].erase(item)
				break
	#For Array, add item into specified slot, replaces existing item in the specified slot if there is one
	else:
		var itemSlot = get_node("ItemSlots/ItemSlot" + str(slotNum))
		itemSlot.text = ""
		Grid.remove_child(item)
		if itemSlot.get_child_count() != 0:
			itemSlot.get_child(0).queue_free()
			
		itemSlot.add_child(item)
		item.global_position = itemSlot.get_global_position() + Vector2(48, 48)
		item.z_index = 99
		PEP.puzzleElements["Key"].erase(item)
	

func on_useItem():
	pass
