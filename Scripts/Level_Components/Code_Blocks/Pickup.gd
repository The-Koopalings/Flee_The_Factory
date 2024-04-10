extends Area2D

signal pickup

const BLOCK_TYPE = "CODE"
var type
var slotNum

# Called when the node enters the scene tree for the first time.
func _ready():
	#Use PEP to get Inventory node
	var Inventory = get_node(PEP.get_path_to_grandpibling(self, "Inventory")) 
	var status = connect("pickup", Inventory, "on_pickup")
	if status != 0:
		printerr("Something went wrong trying to connect signals in ", name)
	
	type = Inventory.type
	setup()
	

func setup():
	var SelectSlotNum = $SelectSlotNum
	if type == "S" or type == "Q":
		slotNum = -1
		SelectSlotNum.visible = false
	elif type == "A":
		on_SlotNum_Selected(slotNum)
		SelectSlotNum.get_popup().connect("id_pressed", self, "on_SlotNum_Selected")
		#Add options if pre=Restart or parent is CodeBlockBar
		if PEP.IDEScopes.size() == 0 or get_parent().name == "CodeBlockBar":
			SelectSlotNum.get_popup().add_item("0")
			SelectSlotNum.get_popup().add_item("1")
			SelectSlotNum.get_popup().add_item("2")
			SelectSlotNum.get_popup().add_item("3")
			SelectSlotNum.get_popup().add_item("4")
	

func on_SlotNum_Selected(id):
	match id:
		0:
			$SelectSlotNum/Label.text = "0"
			slotNum = 0
		1:
			$SelectSlotNum/Label.text = "1"
			slotNum = 1
		2:
			$SelectSlotNum/Label.text = "2"
			slotNum = 2
		3:
			$SelectSlotNum/Label.text = "3"
			slotNum = 3
		4:
			$SelectSlotNum/Label.text = "4"
			slotNum = 4
		null:
			slotNum = int($SelectSlotNum/Label.text)
	

func send_signal():
	print("PICKING UP ITEM")
	$CodeBlock/Highlight.visible = true
	emit_signal("pickup", slotNum)
	

#Just here to supress errors during debugging
func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	pass
