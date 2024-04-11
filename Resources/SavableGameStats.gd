extends Resource

class_name SavableGameStats

#NOTE: All vars that you want saved with ResourceSaver have to contain "export" as a keyword

#Keys: level paths (I.e. res://Scenes/Levels/Tutorial/blah)     
#Values: true if level is completed, false if not
export var levelCompletion = {}

#Check if we should play tutorial (I.e. if player exits level without completing, won't replay tutorial automatically)
#Keys: level paths (like levelCompletion)     
#Values: true if should play tutorial, false otherwise (I.e. if level completed or re-entered after not completing)
export var playTutorial = {}
