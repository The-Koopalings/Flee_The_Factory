extends ColorRect

#Last character of the Level's Node2D name, "S" = Stack, "Q" = Queue, "A" = Array
var type
onready var Robot = get_node("../Grid/Robot")
onready var Grid = get_node("../Grid")

func _ready():
	initialize_inventory()
	

func initialize_inventory():
	var levelName = get_node("..").name
	type = levelName.substr(levelName.length() - 1, 1)
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
	

#Only functional for using keys on doors right now
func on_useItem(slotNum):
	var item
	var itemSlot
	var object = Robot.get_object_in_direction(Robot.get_direction("Front"))
	#No object in front, the object isn't a door, or it is a non-colored door, then stop function
	if !object or object.name.substr(0, 4) != "Door" or object.name.rstrip("0123456789").length() <= 4:
		return
	
	#LIFO Stack
	if type == "S":
		var itemSlots = get_node("ItemSlots").get_children()
		for i in range(4, -1, -1):	
			itemSlot = itemSlots.pop_back()
			item = itemSlot.get_child(0)
			if !item:
				continue
			elif item and item.name.substr(3, 1) == object.name.substr(4, 1):
				item.queue_free()
				object.queue_free()
				itemSlot.text = str(i)
			#Stops loop once an item is found 
			break 
	#FIFO Queue
	elif type == "Q":
		itemSlot = get_node("ItemSlots/ItemSlot0")
		item = itemSlot.get_child(0)
		if item and item.name.substr(3, 1) == object.name.substr(4, 1):
			item.queue_free()
			object.queue_free()
			#Shift all items left 1 slot if there are any left in Inventory
			if get_node("ItemSlots/ItemSlot1").get_child_count() != 0:
				shift_items_left()
			else:
				itemSlot.text = "0"
			
	#Array
	elif type == "A":
		itemSlot = get_node("ItemSlots/ItemSlot" + str(slotNum))
		item = itemSlot.get_child(0)
		#If the key is the same color as the door, then queue_free the door & key
		if item and item.name.substr(3, 1) == object.name.substr(4, 1):
			item.queue_free()
			object.queue_free()
			itemSlot.text = str(slotNum)
	

#Shift items 1 slot left
func shift_items_left():
	var itemSlots = get_node("ItemSlots").get_children()
	var itemSlot
	var item
	for i in range(1, 5):
		itemSlot = itemSlots[i]
		item = itemSlot.get_child(0)
		#Stops loop once there are no more items to shift
		if !item:
			break
		else:
			itemSlot.remove_child(item)
			itemSlot.text = str(i)
			itemSlots[i-1].add_child(item)
	
