extends Node
class_name MenuFactory

var mc : menu_controller
var slider_title_min_size : float = 0
var slider_title_array : Array

# Called when the node enters the scene tree for the first time.
func _init(mController : menu_controller):
	mc = mController
	print_debug(str(mc.get_class()))
	pass # Replace with function body.

func get_base_menu_structure(item_info : Array):
	#Setup CanvasLayer
	var m : CanvasLayer
	m = CanvasLayer.new()
	m.offset = Vector2(0,0)
	m.scale = Vector2(0.98,0.98)

	#Setup VerticalContainer
	var v : VBoxContainer = VBoxContainer.new()
	v.add_theme_constant_override("separation", 10.0)
	v.custom_minimum_size = Vector2(550,10)

	m.add_child(v)
	
	#Add Elements
	
	for ii in item_info:
		match ii.itemclass:
			MenuItemInfo.ItemClass.TITLE:
				var label_title = create_title_item()
				label_title.text = ii.text
				v.add_child(label_title)	
			
			MenuItemInfo.ItemClass.LINE_LEFT:
				var line_left = create_line(true)
				v.add_child(line_left)	
			
			MenuItemInfo.ItemClass.BUTTON:
				var button_item = create_button_item(ii)
				button_item.text = ii.text
				v.add_child(button_item)	
			
			MenuItemInfo.ItemClass.LINE_RIGHT:
				var line_right = create_line(false)
				v.add_child(line_right)
				
			MenuItemInfo.ItemClass.DESCRIPTION:
				var label_desc = create_title_item()
				label_desc.name = "l_description"
				label_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				label_desc.text = ii.text
				v.add_child(label_desc)
				
			MenuItemInfo.ItemClass.SLIDER:
				var h = HBoxContainer.new()
				h.add_theme_constant_override("separation", 30.0)
				h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				var label_title = create_title_item()
				label_title.text = ii.text
				
				if slider_title_min_size < ii.text.length() * 18:
					slider_title_min_size = ii.text.length() * 18
				
				h.add_child(label_title)
				slider_title_array.append(label_title)
				v.add_child(h)
				var slider = create_slider_item(ii)
				h.add_child(slider)
				var label_info = create_info_item()
				label_info.text = "%4.1f" % ii.range.value
				label_info.custom_minimum_size = Vector2(label_info.text.length() * 18,0)
				h.add_child(label_info)
				v.add_child(h)
				var cs = Callable(mc,"slider_events").bind(ii, label_info)
				slider.connect("value_changed", cs)
				
	v.set_anchors_preset(Control.PRESET_CENTER)
	v.set_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	return m

func resize_slider_titles():
	for st in slider_title_array:
		st.custom_minimum_size.x = slider_title_min_size
	slider_title_array.clear()
	slider_title_min_size = 0

func create_line(direction: bool = false):
	var t : TextureButton = TextureButton.new()
	t.stretch_mode = TextureButton.STRETCH_SCALE
	if direction:
		t.texture_normal = load("res://assets/line_left.tres")
	else:
		t.texture_normal = load("res://assets/line_right.tres")
	t.custom_minimum_size = Vector2(0,3)
	return t

func create_title_item():
	var title : Label = Label.new()
	title.text = "Title Item"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER	
	title.add_theme_font_override("font", load("res://assets/fonts/xolonium/xolonium-fonts-4.1/ttf/Xolonium-Regular.ttf"))
	title.add_theme_color_override("font_outline_color",Color(0,0,0,255))
	title.add_theme_color_override("font_shadow_color",Color(0,0,0,255))
	title.add_theme_constant_override("outline_size",2)
	title.add_theme_constant_override("shadow_offset_x",0)
	title.add_theme_constant_override("shadow_offset_y",2)
	title.add_theme_font_size_override("shadow_outline_size", 20)
	title.add_theme_font_size_override("font_size", 30)
	return title

func create_info_item():
	var info_item = create_title_item()
	info_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	return info_item

func create_button_item(button_ii : mii):
	var b : Button = Button.new()
	b.add_theme_font_override("font", load("res://assets/fonts/xolonium/xolonium-fonts-4.1/ttf/Xolonium-Regular.ttf"))
	b.add_theme_color_override("font_outline_color",Color(0,0,0,255))
	b.add_theme_font_size_override("font_size", 60)
	b.add_theme_constant_override("outline_size",10)
	
	var c = Callable(mc,"button_events").bind( button_ii)
	b.connect("pressed", c)
	
	var c_me = Callable(mc,"mouse_entered").bind( button_ii.description)
	b.connect("mouse_entered", c_me)
	
	return b
# Called every frame. 'delta' is the elapsed time since the previous frame.

func create_slider_item(button_ii : mii):
	var s : HSlider = HSlider.new()
	s.min_value = button_ii.range.min
	s.max_value = button_ii.range.max
	s.value = button_ii.range.value
	s.step = button_ii.range.step
	s.size_flags_vertical = Control.SIZE_FILL
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var c_me = Callable(mc,"mouse_entered").bind( button_ii.description)
	s.connect("mouse_entered", c_me)
	return s
	

func _process(delta):
	pass
