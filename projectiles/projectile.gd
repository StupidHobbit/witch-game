extends Area3D
class_name Projectile

signal landed()

@export var data: ProjectileData

var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += velocity * delta

	if not has_overlapping_bodies():
		return
		
	landed.emit(self)
	queue_free()

func get_stats() -> ProjectileData:
	return data
