extends CanvasLayer

const CHAR_READ_RATE = 0.05

onready var textbox_container = $TextBoxContainer
onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
onready var text = $TextBoxContainer/MarginContainer/HBoxContainer/Text

# Keep track of what state the text box is currently in
enum State {
	READY,
	READING,
	END,
}

var current_state = State.READY
var text_queue = []


func _ready():
	hide_textbox()


func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				# Change position before displaying text if needed
				if text_queue[0] == "IDE":
					text_queue.pop_front()
					set_IDE_pos()
				elif text_queue[0] == "CODE_BLOCK":
					text_queue.pop_front()
					set_codeblock_pos()
				elif text_queue[0] == "DEFAULT":
					text_queue.pop_front()
					set_default_pos()
				# Display text from queue
				else:
					display_text()
					change_state(State.READING)
		State.READING:
			# Press enter to display all text right away
			if Input.is_action_just_pressed("ui_accept"):
				text.percent_visible = 1.0
				$Tween.remove_all()
				end_symbol.text = "v"
				change_state(State.END)
		State.END:
			# Press enter to hide textbox
			if Input.is_action_just_pressed("ui_accept"):
				end_symbol.text = ""
				if text_queue.empty():
					hide_textbox()
				change_state(State.READY)


func queue_text(dialogue):
	text_queue.push_back(dialogue)


func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	text.text = ""
	textbox_container.hide()


func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()


func display_text():
	# Get next text from the queue
	var dialogue = text_queue.pop_front()
	
	text.text = dialogue
	text.percent_visible = 0.0
	show_textbox()
	
	# Animate text so it doesn't all appear at once
	$Tween.interpolate_property(text, "percent_visible", 0.0, 1.0, len(dialogue) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed():
	end_symbol.text = "v"
	change_state(State.END)


func change_state(state):
	current_state = state


func set_default_pos():
	textbox_container.rect_position = Vector2(150, 740)
	textbox_container.rect_size = Vector2(1620, 300)


func set_codeblock_pos():
	textbox_container.rect_position = Vector2(300, 600)
	textbox_container.rect_size = Vector2(1010, 300)


func set_IDE_pos():
	textbox_container.rect_position = Vector2(300, 100)
	textbox_container.rect_size = Vector2(1010, 300)
