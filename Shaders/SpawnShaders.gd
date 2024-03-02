extends Node3D

@export var model : PackedScene
@export var count := Vector2i(100, 100)
@export var offset := 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-count.x/2, count.x/2):
		for y in range(-count.y/2, count.y/2):
			var m : Node3D = model.instantiate()
			m.transform.origin = Vector3(x*offset, 1.0, y*offset)
			add_child(m)
