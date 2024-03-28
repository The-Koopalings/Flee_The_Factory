extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	#Connect signals
	connections()
	#Makes sure initial slider values affect text & volume/brightness
	music_volume_changed($Sliders/MusicVolume/HSlider.value)
	sound_effects_volume_changed($Sliders/SoundEffectsVolume/HSlider.value)
	brightness_changed($Sliders/Brightness/HSlider.value)
	

func connections():
	$Sliders/MusicVolume/HSlider.connect("value_changed", self, "music_volume_changed")
	$Sliders/SoundEffectsVolume/HSlider.connect("value_changed", self, "sound_effects_volume_changed")
	$Sliders/Brightness/HSlider.connect("value_changed", self, "brightness_changed")
	
	$Buttons/Continue.connect("pressed", self, "continue_pressed")
	$Buttons/StageSelect.connect("pressed", self, "stage_select_pressed")
	$Buttons/ExitLevel.connect("pressed", self, "exit_level_pressed")
	$Buttons/ExitGame.connect("pressed", self, "exit_game_pressed")
	

func music_volume_changed(value: float):
	$Sliders/MusicVolume/Label.text = "Music Volume\n" + str(value) + "%"
	

func sound_effects_volume_changed(value: float):
	$Sliders/SoundEffectsVolume/Label.text = "Sound Effects Volume\n" + str(value) + "%"
	

func brightness_changed(value: float):
	$Sliders/Brightness/Label.text = "Brightness\n" + str(value) + "%"
	

func continue_pressed():
	get_tree().paused = false
	visible = false
	

func stage_select_pressed():
	get_tree().paused = false
	visible = false
	SceneSwapper.change_scene("Stage Select")
	

func exit_level_pressed():
	get_tree().paused = false
	visible = false
	var root = get_tree().root
	var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
	directory = directory.substr(20)
	SceneSwapper.change_scene(directory + " Select")
	

func exit_game_pressed():
	get_tree().quit()
