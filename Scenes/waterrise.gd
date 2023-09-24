extends CharacterBody3D
@export var clipmesh : MeshInstance3D
var elapsed : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GloVar.water_plane = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	elapsed += delta
	var freq = 0.5
	var amplitude = 0.05
	velocity.y = cos(elapsed * freq) * amplitude

	

	var collision = move_and_collide(velocity * delta)
