extends MeshInstance3D

var material : ShaderMaterial

func _ready():
	material = material_override
	# start the tween out
	tween_out()

func tween_in():
	return do_the_tween(0.0, 1.0).connect('finished', tween_out)

func tween_out():
	return do_the_tween(1.0, 0.0).connect('finished', tween_in)

func do_the_tween(inval: float, outval: float):
	return create_tween().set_ease(Tween.EASE_OUT).tween_method(set_dissolve_height, inval, outval, 1)

func set_dissolve_height(value: float):
	material.set_shader_parameter('dissolve_height', value)
