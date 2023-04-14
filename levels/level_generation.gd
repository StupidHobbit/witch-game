extends Node


@export var block: PackedScene
@export var min_range: float = 1
@export var max_range: float = 20
@export var min_height: float = 1
@export var max_height: float = 40
@export var blocks_number: int = 200



func _ready():
	for i in range(blocks_number):
		var spawned = block.instantiate()
		
		var range = randf_range(min_range, max_range)
		var angle = randf_range(-PI, PI)
		
		spawned.position = Vector3(
			range * cos(angle), 
			randf_range(min_height, max_height),
			range * sin(angle), 
		)
		add_child(spawned)
