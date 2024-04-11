extends CanvasLayer

const CHAR_READ_RATE = 0.03

onready var textbox_container = $TextBoxContainer
onready var start_symbol = $TextBoxContainer/DialogueContainer/HBoxContainer/Start
onready var text = $TextBoxContainer/DialogueContainer/HBoxContainer/Text

# Keep track of what state the text box is currently in
enum State {
	READY,
	READING,
	END,
}

var current_state = State.READY
var text_queue = []
signal user_action

func _ready():
	hide_textbox()


func _process(_delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				# Change position before displaying text if needed
				if text_queue[0] == "IDE":
					text_queue.pop_front()
					set_IDE_pos()
					emit_signal("user_action")
				elif text_queue[0] == "CODE_BLOCK":
					text_queue.pop_front()
					set_codeblock_pos()
					emit_signal("user_action")
				elif text_queue[0] == "DEFAULT":
					text_queue.pop_front()
					set_default_pos()
					emit_signal("user_action")
				# Display text from queue
				else:
					display_text()
					change_state(State.READING)
		State.READING:
			# Press space to display all text right away
			if Input.is_action_just_pressed("ui_select"):
				text.percent_visible = 1.0
				$Tween.remove_all()
				change_state(State.END)
		State.END:
			if Input.is_action_just_pressed("ui_select"):
				if text_queue.empty():
					hide_textbox()
				change_state(State.READY)
				emit_signal("user_action")


func queue_text(dialogue):
	text_queue.push_back(dialogue)


func hide_textbox():
	start_symbol.text = ""
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
	change_state(State.END)


func change_state(state):
	current_state = state


func set_default_pos():
	textbox_container.rect_position = Vector2(150, 745)
	textbox_container.rect_size = Vector2(1620, 300)


func set_codeblock_pos():
	textbox_container.rect_position = Vector2(250, 650)
	textbox_container.rect_size = Vector2(500, 300)
	textbox_container.rect_scale = Vector2(0.8, 0.8)


func set_IDE_pos():
	textbox_container.rect_position = Vector2(120, 100)
	textbox_container.rect_size = Vector2(500, 300)
	textbox_container.rect_scale = Vector2(0.8, 0.8)
