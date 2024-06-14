extends Node

var consoleText : String = ""

var lineOne : String = ""
var lineTwo : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func getConsoleText():
	return consoleText

func message(messageStr : String):
	if (lineOne == ""):
		lineOne = messageStr
	elif (lineTwo == ""):
		lineTwo = messageStr
	else:
		lineOne = lineTwo
		lineTwo = messageStr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	consoleText = lineOne + "\n" + lineTwo
	pass
