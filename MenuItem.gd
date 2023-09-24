extends Node
class_name MenuItem
enum ItemClass {TITLE, LINE_LEFT,LINE_RIGHT,BUTTON,DESCRIPTION}

class MenuItem:
	var name : String
	var function : String
	var itemclass : ItemClass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
