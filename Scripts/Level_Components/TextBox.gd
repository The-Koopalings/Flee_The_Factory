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
	END
}

var current_state = State.READY
var text_queue = []


func _ready():
	print("Starting at State.READY")
	hide_textbox()
	queue_text("ur mom is a lovely lady")
	queue_text("kraen is homophobic frfr")
	queue_text("lamy wants to go on a date with yeah sia at huey berries")
	queue_text("helener disabled herself for the 69th time")
	queue_text("brayan is expecting a little boy")
	queue_text("henrussy wants boom boom koopa's chode")
	queue_text("gace has been eating cucumis melo all day every day")


func _process(delta):
	match current_state:
		State.READY:
			# Display text from queue
			if !text_queue.empty():
				display_text()
		State.READING:
			# Press enter to display all text right away
			if Input.is_action_just_pressed("ui_accept"):
				text.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text = "v"
				change_state(State.END)
		State.END:
			# Press enter to hide textbox
			if Input.is_action_just_pressed("ui_accept"):
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
	
	change_state(State.READING)
	show_textbox()
	
	# Animate text so it doesn't all appear at once
	$Tween.interpolate_property(text, "percent_visible", 0.0, 1.0, len(dialogue) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed():
	end_symbol.text = "v"
	change_state(State.END)


func change_state(state):
	current_state = state
	match current_state:
		State.READY:
			print("Changing state to State.READY")
		State.READING:
			print("Changing state to State.READING")
		State.END:
			print("Changing state to State.END")
