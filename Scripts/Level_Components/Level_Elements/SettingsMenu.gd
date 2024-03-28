extends CanvasLayer

onready var musicVolumeLabel = $Sliders/MusicVolume/Label
onready var soundEffectsVolumeLabel = $Sliders/SoundEffectsVolume/Label
onready var brightnessLabel = $Sliders/Brightness/Label

onready var musicVolumeSlider = $Sliders/MusicVolume/HSlider
onready var soundEffectsVolumeSlider = $Sliders/SoundEffectsVolume/HSlider
onready var brightnessSlider = $Sliders/Brightness/HSlider

var mvStartVal
var sevStartVal
var bStartVal

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	#Connect signals
	connections()
	#Makes sure initial slider values affect text & volume/brightness
	setup()
	

func connections():
	musicVolumeSlider.connect("value_changed", self, "music_volume_changed")
	soundEffectsVolumeSlider.connect("value_changed", self, "sound_effects_volume_changed")
	brightnessSlider.connect("value_changed", self, "brightness_changed")
	
	$Sliders/MusicVolume/Reset.connect("pressed", self, "reset_music_volume")
	$Sliders/SoundEffectsVolume/Reset.connect("pressed", self, "reset_sound_effects_volume")
	$Sliders/Brightness/Reset.connect("pressed", self, "reset_brightness")
	
	$Buttons/Continue.connect("pressed", self, "continue_pressed")
	$Buttons/StageSelect.connect("pressed", self, "stage_select_pressed")
	$Buttons/ExitLevel.connect("pressed", self, "exit_level_pressed")
	$Buttons/StartMenu.connect("pressed", self, "start_menu_pressed")
	
func setup():
	mvStartVal = musicVolumeSlider.value
	sevStartVal = soundEffectsVolumeSlider.value
	bStartVal = brightnessSlider.value
	
	music_volume_changed(mvStartVal)
	sound_effects_volume_changed(sevStartVal)
	brightness_changed(bStartVal)
	

#Test functionality once music has been added
func music_volume_changed(value: float):
	musicVolumeLabel.text = "Music Volume\n" + str(value) + "%"
	var volume = musicVolumeSlider.value / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 4 * volume)
	

#Test functionality once sound effects have been added
func sound_effects_volume_changed(value: float):
	soundEffectsVolumeLabel.text = "Sound Effects Volume\n" + str(value) + "%"
	var volume = soundEffectsVolumeSlider.value / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), 4 * volume)
	

func brightness_changed(value: float):
	brightnessLabel.text = "Brightness\n" + str(value) + "%"
	var brightness = brightnessSlider.value / 100.0
	GlobalWE.environment.adjustment_brightness = 1.5 * brightness
	

func reset_music_volume():
	musicVolumeSlider.value = mvStartVal
	

func reset_sound_effects_volume():
	soundEffectsVolumeSlider.value = sevStartVal
	

func reset_brightness():
	brightnessSlider.value = bStartVal
	

func continue_pressed():
	get_tree().paused = false
	visible = false
	

func stage_select_pressed():
	get_tree().paused = false
	visible = false
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	
	SceneSwapper.change_scene("Stage Select")
	

func exit_level_pressed():
	get_tree().paused = false
	visible = false
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	
	var root = get_tree().root
	var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
	directory = directory.substr(20)
	SceneSwapper.change_scene(directory + " Select")
	

func start_menu_pressed():
	get_tree().paused = false
	visible = false
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	
	SceneSwapper.change_scene("Start Menu")
