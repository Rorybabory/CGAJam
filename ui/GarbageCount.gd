extends RichTextLabel




# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Garbage.numGarbage = get_tree().get_nodes_in_group("Garbage").size()
	text = "TRASH: " + str(Garbage.numGarbage) + "/" + str(Garbage.totalGarbage)
	if (Garbage.numGarbage <= 0):
		get_node("../TrashCollected").show()
	else:
		get_node("../TrashCollected").hide()
	pass
