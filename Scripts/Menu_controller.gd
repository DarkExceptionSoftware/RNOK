extends Node
class_name menu_controller


var mFac : MenuFactory
var display_width
var menu_canvas_screens : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	display_width = DisplayServer.window_get_size()
	mFac = MenuFactory.new(self)
	
	for ms in menu_screens.keys():
		var call_menu = Callable(self,"setup_" + ms)
		var canvas = mFac.get_base_menu_structure(call_menu.call())
		mFac.resize_slider_titles()
		menu_canvas_screens.append(canvas)
		menu_screens[ms] = canvas
		
	var actual_canvas = menu_canvas_screens[0]
	add_child(actual_canvas)
	actual_canvas.visible = false
	actual_canvas.call_deferred("set_visible", true)
	actual_canvas.offset.x = 1920
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(actual_canvas, "offset",Vector2(0,0),0.3)
	GloVar.menu_stack.append(actual_canvas)
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(GloVar.menu_stack[-1], "offset",Vector2(-1280,0),0.3)
			tween.tween_callback(on_tween_back)	
	
func mouse_entered(description : String):
	var c : CanvasLayer = GloVar.menu_stack[-1]
	var v = c.get_child(0)
	var a : Array = v.get_children()
	for ch in a :
		if ch.name == "l_description":
			var tween = get_tree().create_tween()
			tween.tween_property(ch, "modulate", Color(0,0,0,0), 0.2)
			var cb : Callable = Callable(self,"new_description").bind(description, ch)
			tween.tween_callback(cb)
	pass

func new_description(description : String, label : Label):
	label.text = description
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color.WHITE, 0.2)

	
func on_tween_exit():
	get_tree().quit()
	pass
	
func on_tween_back():
	GloVar.menu_stack.resize(GloVar.menu_stack.size() - 1)
	
	if GloVar.menu_stack.size() == 0:
		get_tree().queue_delete(self)
	else:
		slide_in(GloVar.menu_stack[-1])
	
func on_tween_next(target_menu):
	var c = menu_screens[target_menu]
	slide_in(c)
	GloVar.menu_stack.append(c)
	pass

func slide_in(c : CanvasLayer):
	c.offset.x = display_width.x
	add_child(c)
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(c, "offset",Vector2(0,0),0.3)
pass

func slide_out(c : Callable):
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(GloVar.menu_stack[-1], "offset",Vector2(-display_width.x,0),0.3)
		tween.tween_callback(c)	

enum button_event {switchmenu, menuback, exit, watergl, waterwn, waterws, gblend}

func button_events(_mii : mii):
	match _mii.function:
		button_event.switchmenu:
			slide_out(Callable(self, "on_tween_next").bind(_mii.target))
		
		button_event.menuback:
			slide_out(Callable(self, "on_tween_back"))
			
		button_event.exit:
			slide_out(Callable(self, "on_tween_exit"))

func slider_events(v : float, _mii : mii, l : Label):
	var wp : MeshInstance3D = GloVar.water_plane.clipmesh
	match _mii.function:
		button_event.watergl:
			GloVar.water_plane.global_transform.origin.y = v
			l.text = "%4.1f" % v
		button_event.waterwn:
			var mat = wp.get_surface_override_material(0) as ShaderMaterial
			mat.set_shader_parameter("noise_scale",v)
			l.text = "%3.2f" % v
			wp.set_surface_override_material(0, mat)
		button_event.waterws:
			var mat = wp.get_surface_override_material(0) as ShaderMaterial
			mat.set_shader_parameter("height_scale",v)
			l.text = "%3.2f" % v
			wp.set_surface_override_material(0, mat)
		button_event.gblend:
			for gp in GloVar.ground_plane:
				var mat = gp.material as ShaderMaterial
				mat.set_shader_parameter("gradient_blend",v)
				l.text = "%1.2f" % v
				gp.material = mat

var menu_screens : Dictionary = {
	"main" : CanvasLayer.new(), 
	"options" : CanvasLayer.new(),
	"behavior" :CanvasLayer.new(),
	"graphics" : CanvasLayer.new()
	}

func setup_main():
	var menu : Array
	
	#Structure: TITLE, ACTION, ITEMTYPE, TARGET, DESCRIPTION, RANGE
	menu.append(mii.new("Main Menu",0 ,MenuItemInfo.ItemClass.TITLE,"",""))
	menu.append(mii.new("",0 ,MenuItemInfo.ItemClass.LINE_LEFT,"",""))
	menu.append(mii.new("Options Menu",button_event.switchmenu,MenuItemInfo.ItemClass.BUTTON,"options","Open the Options-Menu"))
	menu.append(mii.new("Quit Game",button_event.exit,MenuItemInfo.ItemClass.BUTTON,"exit","Quit to Desktop"))
	menu.append(mii.new("Close Menu",button_event.menuback,MenuItemInfo.ItemClass.BUTTON,"exit","Close Menu"))
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_RIGHT,"",""))
	menu.append(mii.new("This is the Main Menu",0,MenuItemInfo.ItemClass.DESCRIPTION,"",""))	
	return menu
	
func setup_options():
	var menu : Array
	menu.append(mii.new("Options",0,MenuItemInfo.ItemClass.TITLE,"",""))
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_LEFT,"",""))
	menu.append(mii.new("Behavior",button_event.switchmenu,MenuItemInfo.ItemClass.BUTTON,"behavior","Change World Parameters"))
	menu.append(mii.new("Graphics",button_event.switchmenu,MenuItemInfo.ItemClass.BUTTON,"graphics","Tweak the Graphics"))
	menu.append(mii.new("Controls",button_event.switchmenu,MenuItemInfo.ItemClass.BUTTON,"Controls","Adjust Contols"))
	menu.append(mii.new("Back",button_event.menuback,MenuItemInfo.ItemClass.BUTTON,"exit","Back to Main Menu"))	
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_RIGHT,"",""))
	menu.append(mii.new("This is the Options Menu",0,MenuItemInfo.ItemClass.DESCRIPTION,"",""))	
	return menu

func setup_behavior():
	var menu : Array
	menu.append(mii.new("Behavior",0,MenuItemInfo.ItemClass.TITLE,"",""))
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_LEFT,"",""))
	menu.append(mii.new("Water",0,MenuItemInfo.ItemClass.TITLE,"",""))
	
	var water_height_range = defined_range.new(GloVar.water_plane.global_transform.origin.y, 0, 40, 0.1)
	menu.append(mii.new("Ground Level",button_event.watergl,MenuItemInfo.ItemClass.SLIDER,"water","Water Settings",water_height_range ))
	
	var wp : MeshInstance3D = GloVar.water_plane.clipmesh	
	var mat = wp.get_surface_override_material(0) as ShaderMaterial
	var wave_scale = defined_range.new(mat.get_shader_parameter("noise_scale"), 0, 400, 0.1)
	menu.append(mii.new("Wave Noise",button_event.waterwn,MenuItemInfo.ItemClass.SLIDER,"water","Water Settings",wave_scale ))

	var wave_noise = defined_range.new(mat.get_shader_parameter("height_scale"), 0, 10, 0.01)
	menu.append(mii.new("Wave Scale",button_event.waterws,MenuItemInfo.ItemClass.SLIDER,"water","Water Settings",wave_noise ))

	
	menu.append(mii.new("Back",button_event.menuback,MenuItemInfo.ItemClass.BUTTON,"exit","Back to Options"))	
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_RIGHT,"",""))
	menu.append(mii.new("Adjust World-Options Menu",0,MenuItemInfo.ItemClass.DESCRIPTION,"",""))	
	return menu

func setup_graphics():
	var wp = GloVar.ground_plane[0]
	var mat = wp.material as ShaderMaterial
	
	var menu : Array
	menu.append(mii.new("Graphics",0,MenuItemInfo.ItemClass.TITLE,"",""))
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_LEFT,"",""))
	menu.append(mii.new("Ground",0,MenuItemInfo.ItemClass.TITLE,"",""))
	
	var gradient_blend = defined_range.new(mat.get_shader_parameter("gradient_blend"), 0, 1, 0.1)
	menu.append(mii.new("Gradient",button_event.gblend,MenuItemInfo.ItemClass.SLIDER,"gblend","Gradient Blend",gradient_blend ))

	menu.append(mii.new("Back",button_event.menuback,MenuItemInfo.ItemClass.BUTTON,"exit","Back to Options"))	
	menu.append(mii.new("",0,MenuItemInfo.ItemClass.LINE_RIGHT,"",""))
	menu.append(mii.new("Tweak Graphics",0,MenuItemInfo.ItemClass.DESCRIPTION,"",""))	
	return menu
