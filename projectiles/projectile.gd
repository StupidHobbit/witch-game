extends Area3D

signal landed()

var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	position += velocity * delta

	if not has_overlapping_bodies():
		return
		
	for body in get_overlapping_bodies():
		landed.emit(self, body)
	queue_free()
