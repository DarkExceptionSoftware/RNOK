extends Node3D
@export var ground_mesh : CSGMesh3D
var mesharray : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var loaded_side_mesh = preload("res://Scenes/side_mesh.tscn").duplicate()
	mesharray.append(ground_mesh)
	
	for i in range(3):
		for k in range(3):
			if !(i == 1 && k == 1):
				var duplicate_mesh : CSGMesh3D = loaded_side_mesh.instantiate()
				duplicate_mesh.material = ground_mesh.material
				add_child(duplicate_mesh)	
				duplicate_mesh.position = Vector3(-256 + 256.0 * k,0.0,-256.0 + 256.0 * i)
				mesharray.append(duplicate_mesh)
	
	GloVar.ground_plane = mesharray

	pass # Replace with function body.

func set_material(sm : ShaderMaterial):
	for gm in mesharray:
		gm.material = sm
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
