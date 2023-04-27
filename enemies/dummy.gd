extends CharacterBody3D

@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.took_damage.connect(on_damage)

func on_damage(damage: int):
	print(damage)
