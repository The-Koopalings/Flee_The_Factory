extends CanvasLayer

onready var musicVolumeLabel = $Sliders/MusicVolume/Label
onready var soundEffectsVolumeLabel = $Sliders/SoundEffectsVolume/Label
onready var brightnessLabel = $Sliders/Brightness/Label

onready var musicVolumeSlider = $Sliders/MusicVolume/HSlider
onready var soundEffectsVolumeSlider = $Sliders/SoundEffectsVolume/HSlider
onready var brightnessSlider = $Sliders/Brightness/HSlider

#Allows for Reset buttons to work
var mvStartVal = 50.0
var sevStartVal = 50.0
var bStartVal = 50.0

#Contains music + sound volume & brightness which are saved
var savableSettings
var saveFilePath = "user://Settings.res"

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
	$Buttons/ExitLevel.connect("pressed", self, "exit_level_pressed")
	$Buttons/ExitGame.connect("pressed", self, "exit_game_pressed")
#	$Buttons/StartMenu.connect("pressed", self, "start_menu_pressed")
#	$Buttons/StageSelect.connect("pressed", self, "stage_select_pressed")
	

func setup():
	#Load in setting values from file if it exists, if not then default to startVals
	if ResourceLoader.exists(saveFilePath):
		savableSettings = ResourceLoader.load(saveFilePath)
		if savableSettings:
			music_volume_changed(savableSettings.musicVolume)
			sound_effects_volume_changed(savableSettings.soundVolume)
			brightness_changed(savableSettings.brightness)
			set_sliders()
		else:
			printerr("Loaded in savableSettings is null")
	else:
		savableSettings = SavableSettings.new()
		music_volume_changed(mvStartVal)
		sound_effects_volume_changed(sevStartVal)
		brightness_changed(bStartVal)
	

#Test functionality once music has been added
func music_volume_changed(value: float):
	musicVolumeLabel.text = "Music Volume\n" + str(value) + "%"
	savableSettings.musicVolume = value
	var volume = linear2db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume)
	

#Test functionality once sound effects have been added
func sound_effects_volume_changed(value: float):
	soundEffectsVolumeLabel.text = "Sound Effects Volume\n" + str(value) + "%"
	savableSettings.soundVolume = value
	var volume = linear2db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), volume)
	

func brightness_changed(value: float):
	brightnessLabel.text = "Brightness\n" + str(value) + "%"
	savableSettings.brightness = value
	var brightness = value / 100.0
	GlobalWE.environment.adjustment_brightness = 1.5 * brightness + 0.25
	

func set_sliders():
	musicVolumeSlider.value = savableSettings.musicVolume
	soundEffectsVolumeSlider.value = savableSettings.soundVolume
	brightnessSlider.value = savableSettings.brightness
	

func reset_music_volume():
	musicVolumeSlider.value = mvStartVal
	

func reset_sound_effects_volume():
	soundEffectsVolumeSlider.value = sevStartVal
	

func reset_brightness():
	brightnessSlider.value = bStartVal
	

func continue_pressed():
	ButtonPress3.play()
	get_tree().paused = false
	visible = false
	

func exit_level_pressed():
	ButtonPress3.play()
	get_tree().paused = false
	visible = false
	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
	PEP.update()
	
	var root = get_tree().root
	var directory = root.get_child(root.get_child_count() - 1).filename.get_base_dir()
	directory = directory.substr(20)
	SceneSwapper.change_scene(directory + " Select")
	

func exit_game_pressed():
	save_settings()
	GameStats.save_GameStats()
	get_tree().quit()
	

#When game is closed via the window's X button, save settings
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()
	

func save_settings():
	var result = ResourceSaver.save(saveFilePath, savableSettings) 
	if result != OK:
		printerr("Settings values didn't save correctly to ", saveFilePath)
	

#func stage_select_pressed():
#	get_tree().paused = false
#	visible = false
#	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
#	PEP.update()
#
#	SceneSwapper.change_scene("Stage Select")

#func start_menu_pressed():
#	get_tree().paused = false
#	visible = false
#	GameStats.set_game_state(GameStats.State.OUT_OF_LEVEL)
#	PEP.update()
#
#	SceneSwapper.change_scene("Start Menu")
