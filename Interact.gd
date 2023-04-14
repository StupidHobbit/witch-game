extends RayCast3D

@export var max_interaction_distance: float = 1

var input_cleanup_regex = RegEx.new()

func _init():
	input_cleanup_regex.compile("^[\\w ]+")

func get_interactable() -> Interactable:
	var collider = get_collider()
	if collider == null:
		return null
	if global_position.distance_to(get_collision_point()) > max_interaction_distance:
		return null
	collider = collider.get_parent()
	if not collider.has_method("get_label"):
		collider = collider.get_parent()
		if not collider.has_method("get_label"):
			return null
	return collider
	
func _process(delta):
	var interactable = get_interactable()
	
	if interactable == null:
		$Control/Label.hide()
		return
	var label = interactable.get_label()
	if label == "":
		$Control/Label.hide()
		return
	
	$Control/Label.show()
	$Control/Label.text = "{0}: {1}".format([get_interact_input_as_text(), label])
	
	if Input.is_action_just_pressed("interact"):
		interactable.on_interact(get_parent().get_parent())

func get_interact_input_as_text() -> String:
	var raw = InputMap.action_get_events("interact")[0].as_text()
	var result = input_cleanup_regex.search(raw)
	if result:
		return result.get_string()
	return "Unknown"
