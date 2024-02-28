extends MeshInstance3D

@onready var roughnessSlider := $"../CanvasLayer/Control/MarginContainer/GridContainer/RoughnessSlider"
@onready var timeScaleSlider := $"../CanvasLayer/Control/MarginContainer/GridContainer/TimeScaleSlider"

var material : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	material = get_surface_override_material(0)

	timeScaleSlider.value = material.get_shader_parameter('time_scale')
	roughnessSlider.value = material.get_shader_parameter('roughness')

	timeScaleSlider.connect('value_changed', _on_value_changed.bind('time_scale'))
	roughnessSlider.connect('value_changed', _on_value_changed.bind('roughness'))

func _on_value_changed(value: float, name: String):
	material.set_shader_parameter(name, value)
