extends Interactable

var turned_on = false

func _ready():
	$Light.visible = false

func get_label() -> String:
	return "Turn off" if turned_on else "Turn on"

func on_interact(character: Character):
	turned_on = !turned_on
	$Light.visible = turned_on
