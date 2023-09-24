extends CharacterBody3D

@export var water : Node3D
@export var ground : Node3D
@export var camera : Camera3D

var cam_node : Camera3D
var move_scale : float = 0.1
var mouse_sensitivity = 0.002
var elapsed : float
var t : Timer = Timer.new()
var snap_step : float = 5
var player_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_child(t)
	#t.connect("timeout",Callable(self,"snap"))
	#t.wait_time = 1.0
	#t.start()
	GloVar.player = self
	cam_node = camera
	elapsed = 0
	GloVar.message_bucket.append("Start to fly...")
	pass # Replace with function body.
	
func snap():
	player_pos = global_transform.origin.snapped(Vector3(snap_step,0,snap_step))
	ground.global_transform.origin.x = player_pos.x
	ground.global_transform.origin.z = player_pos.z
	var div : float = 256.0
	
	ground.material.set("shader_parameter/uvx",player_pos.x/div)
	ground.material.set("shader_parameter/uvy",player_pos.z/div)
	
	pass
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam_node.rotate_x(-event.relative.y * mouse_sensitivity)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity != Vector3.ZERO:
		elapsed += delta
		move_scale = lerp(1.0,10.0,elapsed)
	else:
		elapsed = 0
		move_scale = 0.3

	var move_z = Input.get_axis("Backward", "Forward")
	var move_x = Input.get_axis("Right", "Left")
	var move_y = Input.get_axis("Up", "Down")
	#direction = direction.rotated(global_rotation.y)


		
	velocity =  -transform.basis.z * move_z 
	velocity +=  -transform.basis.x * move_x 
	velocity.y = move_y 
	velocity *= move_scale
	move_and_slide()
	if move_z != 0 || move_x != 0:
		player_pos = global_transform.origin.snapped(Vector3(snap_step,0,snap_step))
		water.global_transform.origin.x = player_pos.x
		water.global_transform.origin.z = player_pos.z
		ground.global_transform.origin.x = player_pos.x
		ground.global_transform.origin.z = player_pos.z
	pass


