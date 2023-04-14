extends Examinable


func put_back():
	super()
	$collision.freeze = false


func on_interact(character: Character):
	super(character)
	$collision.freeze = true
	$collision.position = Vector3.ZERO
	$collision.rotation = Vector3.ZERO
