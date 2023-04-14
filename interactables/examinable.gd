extends Interactable


class_name Examinable

var original_position: Vector3
var original_rotation: Vector3
var original_parent
var is_examinated: bool = false

func put_back():
	is_examinated = false
	reparent(original_parent)
	global_position = original_position
	global_rotation = original_rotation

func get_label() -> String:
	return "" if is_examinated else "Examine (hold)"

func on_interact(character: Character):
	is_examinated = true
	original_position = global_position
	original_rotation = global_rotation
	original_parent = get_parent()
	character.examine(self, get_rid())
	
func get_rid() -> RID:
	var t = get_children()
	return $collision.get_rid()
