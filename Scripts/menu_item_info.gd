class_name mii
extends Node
enum ItemClass {TITLE, LINE_LEFT,LINE_RIGHT,BUTTON,DESCRIPTION,SLIDER}

var text : String
var function : int
var itemclass : ItemClass
var target : String
var description : String
var range : defined_range

func _init(_text : String, _function: int, _itemclass : int,
 _target: String, _description: String, _range : defined_range = defined_range.new(0,0,1,0.1)):
	text = _text
	function = _function
	itemclass = _itemclass
	target = _target
	description = _description
	range = _range
	
	

