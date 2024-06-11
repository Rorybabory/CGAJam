extends Node

var consoleText : String = ""

var lineOne : String = ""
var lineTwo : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func getConsoleText():
	return consoleText

func message(str : String):
	if (lineOne == ""):
		lineOne = str
	elif (lineTwo == ""):
		lineTwo = str
	else:
		lineOne = lineTwo
		lineTwo = str

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	consoleText = lineOne + "\n" + lineTwo
	pass
