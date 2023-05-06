extends Interactable


class_name Examinable

@export var scale_while_examinated: float = 1.0

var original_position: Vector3
var original_rotation: Vector3
var original_scale: Vector3
var original_parent
var is_examinated: bool = false

var body: PhysicsBody3D

func _ready():
	for c in get_children():
		if c is PhysicsBody3D:
			body = c
			return

func put_back():
	is_examinated = false
	reparent(original_parent)
	global_position = original_position
	global_rotation = original_rotation
	scale = original_scale

func get_label() -> String:
	return "" if is_examinated else "Examine (hold)"

func on_interact(character: Character):
	is_examinated = true
	original_position = global_position
	original_rotation = global_rotation
	original_scale = scale
	original_parent = get_parent()
	character.examine(self, get_rid())
	scale = scale * scale_while_examinated
	
func get_rid() -> RID:
	if body == null:
		return RID()
	return body.get_rid()
