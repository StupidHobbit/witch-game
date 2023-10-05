extends Node
 
@export var checkpoints: Array[Checkpoint]
@export var player: Character

var last_place: Vector3
var last_rotation: Vector3

func _ready():
	last_place = player.position
	last_rotation = player.rotation
	for c in checkpoints:
		c.body_entered.connect(func(body):
			if body is Character:
				player = body
				c.on_enter(player)
				last_place = c.position
				last_rotation = c.rotation
				get_tree().queue_delete(c)
		)

func reset_player():
	player.position = last_place
	player.rotation = last_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
