extends WorldEnvironment
var elapsed : float = 0.0
var env : Environment
var mat : ShaderMaterial
@onready var dl : DirectionalLight3D = $SunLight

# Called when the node enters the scene tree for the first time.
func _ready():
	env = self.environment
	pass # Replace with function body.
	mat = environment.sky.sky_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	var freq = 0.01
	var amplitude = 0.475
	var em_wave = cos(elapsed * freq) * amplitude + 0.525
	var em_linear = fmod(elapsed * freq,1) 
	GloVar.message_bucket.append(str(em_wave))
	#mat.set_shader_parameter("time_scale",em_wave)

	#environment.sky.sky_material = mat
	#ent.set_bg_energy_multiplier(em)
	dl.rotation.x = lerp(-3.14,3.14,em_linear)
	dl.light_energy = 0.0
	pass
	
