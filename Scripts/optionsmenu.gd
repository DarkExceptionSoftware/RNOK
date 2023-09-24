extends CanvasLayer

@export var c : Control
var loaded_mainmenu : Resource
var switch_menu : Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	loaded_mainmenu = preload("res://Scenes/mainmenu.tscn").duplicate()
	offset.x = 1920
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "offset",Vector2(0,0),0.3)

	c.grab_focus()


func _exit_tree():
	GloVar.menu_stack.erase(self)
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(self, "offset",Vector2(-1280,0),0.3)
			switch_menu = loaded_mainmenu
			tween.tween_callback(on_tween_last)
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_tween_last():
	if switch_menu != null:
		var next_menu = switch_menu.instantiate()
		get_tree().root.add_child(next_menu)
		GloVar.menu_stack.append(next_menu)
		
	get_tree().queue_delete(self)

