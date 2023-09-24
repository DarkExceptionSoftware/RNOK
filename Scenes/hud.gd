extends CanvasLayer

@export var location : Label
@export var fps : Label
@export var message : Label
var msg_bkt_count : int
var elapsed = 0
var loaded_mainmenu : Resource
var loaded_optionsmenu : Resource
# Called when the node enters the scene tree for the first time.
func _ready():
	loaded_mainmenu = preload("res://Scenes/mainmenu.tscn").duplicate()
	GloVar.message_bucket.append("Welcome to the sea!")
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			self.visible = false
			if GloVar.menu_stack.size() == 0:
				#var mainmenu = loaded_mainmenu.instantiate()
				var mc = menu_controller.new()
				add_child(mc)
				#GloVar.menu_stack.append(mc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible:
		if GloVar.menu_stack.size() == 0:
			visible = true
			
	elapsed += delta
	
	var pos = GloVar.player.position
	var out : String = ""
	out = str(snapped(pos.x,0.1)) + "x "
	out = out + str(snapped(pos.y,0.1)) + "y "
	out = out + str(snapped(pos.z,0.1)) + "z"
	location.text = out
	
	fps.text = str(snapped(Engine.get_frames_per_second(), 1)) + " FPS"
	
	if msg_bkt_count != GloVar.message_bucket.size():
		elapsed = 0
		message.modulate.a = 1
		if GloVar.message_bucket.size() > 20:
			GloVar.message_bucket.erase(0)
		
		message.text = ""
		if GloVar.message_bucket.size() > 2:
			message.text += GloVar.message_bucket[-3] + "\n"
		if GloVar.message_bucket.size() > 1:
			message.text += GloVar.message_bucket[-2] + "\n"
					
		message.text += GloVar.message_bucket[-1]
		
	msg_bkt_count = GloVar.message_bucket.size()
	if elapsed > 2:
		message.modulate.a = lerp(1.0,0.0, (elapsed - 2) * 1.5)
	pass


func _on_message_mouse_entered():
	message.modulate.a = 1
	elapsed = 0
	pass # Replace with function body.
